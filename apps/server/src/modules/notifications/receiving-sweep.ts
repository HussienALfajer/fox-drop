import {
  Inject,
  Injectable,
  Logger,
  type OnApplicationShutdown,
  type OnModuleInit,
} from '@nestjs/common';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { reportError } from '../../observability/error-tracking.js';
import { NotificationTexts } from '../content/index.js';
import { GeoService } from '../geo/index.js';
import { OpenAppSessions } from '../identity/index.js';
import {
  isReceiving,
  MerchantsService,
  ReceivingDevicesService,
  withoutDeviceStep,
} from '../merchants/index.js';
import { SettingsService } from '../settings/index.js';
import type { AlertCode } from './alert-rules.js';
import { AlertsService } from './alerts.service.js';
import { merchantChannel } from './channels.js';
import { PushQueue } from './push-queue.js';
import { RealtimePublisher } from './realtime-publisher.js';

// RA §4.3: the devices' heartbeat is Centrifugo's ping every 20 s, so the
// worker reads the restaurants' channels as often.
export const RECEIVING_SWEEP_MS = 20_000;

const CODE: AlertCode = 'restaurant_without_device';
const TEMPLATE = 'merchant.no_receiving_device';

// RA §4.3–4.6, AP §9.1.1, §9.1.3 (slice 2.42): every RECEIVING_SWEEP_MS the
// worker reads who is on each restaurant's channel (Centrifugo's presence:
// each user an app session), records the devices it sees, counts the
// receiving devices and, while the restaurant is open or busy with none for
// merchant.no_device_alert_min, raises «مطعم مفتوح بلا جهاز استقبال» for
// operations and pushes the owners once (RA §16 #27). A receiving device or
// the restaurant no longer open resolves it. The restaurant is never paused
// for it (RA §4.6).
@Injectable()
export class ReceivingSweep {
  private readonly logger = new Logger('ReceivingSweep');

  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly geo: GeoService,
    private readonly merchants: MerchantsService,
    private readonly devices: ReceivingDevicesService,
    private readonly sessions: OpenAppSessions,
    private readonly publisher: RealtimePublisher,
    private readonly settings: SettingsService,
    private readonly alerts: AlertsService,
    private readonly texts: NotificationTexts,
    private readonly queue: PushQueue,
  ) {}

  async run(now: Date): Promise<void> {
    // Without real time no device receives, but nothing can be seen either:
    // the alerts keep their state until the channels can be read.
    if (!this.publisher.enabled) return;
    const minVersion = await this.settings.get('app.<app>.min_version', {
      parameter: 'merchant',
    });
    const seen = new Set<string>();
    let unread = 0;
    for (const city of await this.geo.activeCities()) {
      const alertMinutes = await this.settings.get('merchant.no_device_alert_min', {
        cityId: city.id,
      });
      for (const row of await this.merchants.listRows(city.id)) {
        if (row.accountStatus === 'draft' || row.accountStatus === 'terminated') continue;
        seen.add(row.id);
        await this.restaurant(row, city.id, minVersion, alertMinutes, now).catch(
          (error: unknown) => {
            if (unread === 0) this.logger.warn({ err: error }, 'a restaurant was not read');
            unread += 1;
          },
        );
      }
    }
    // Once per run: Centrifugo out of reach fails every restaurant alike.
    if (unread > 0) this.logger.warn({ unread }, 'restaurants not read this run');
    // A restaurant no longer listed (terminated, its city inactive).
    for (const subject of await this.alerts.openSubjects(CODE)) {
      if (seen.has(subject.id)) continue;
      await this.database.db.transaction((tx) =>
        this.alerts.sync(
          tx,
          { type: 'restaurant', id: subject.id, cityId: subject.cityId },
          [CODE],
          [],
          now,
        ),
      );
      await this.devices.setWithoutDeviceSince(subject.id, null);
    }
  }

  private async restaurant(
    row: { id: string; nameAr: string },
    cityId: string,
    minVersion: string | null,
    alertMinutes: number,
    now: Date,
  ): Promise<void> {
    const present = await this.publisher.presence(merchantChannel(row.id));
    const sessions = await this.sessions.merchantSessions(row.id);
    const onChannel = sessions.filter((session) => present.has(session.sessionId));
    await this.devices.recordPresence(
      row.id,
      onChannel.map((session) => session.deviceId),
      now,
    );
    const roles = new Map(sessions.map((session) => [session.deviceId, session.role]));
    const named = await this.merchants.devices(row.id);
    const receiving = named.filter((device) =>
      isReceiving({ ...device, role: roles.get(device.deviceId) ?? null }, minVersion, now),
    ).length;
    const state = (await this.merchants.storefrontState(row.id, now)).state.state;
    const step = withoutDeviceStep({
      open: state === 'open' || state === 'busy',
      receiving,
      since: await this.devices.withoutDeviceSince(row.id),
      alertMinutes,
      now,
    });
    const rendered = step.alert ? await this.texts.render(TEMPLATE, {}) : null;
    // The stretch's start, the alert and the owners' push commit together.
    await this.database.db.transaction(async (tx) => {
      await this.devices.setWithoutDeviceSince(row.id, step.since, tx);
      await this.alerts.sync(
        tx,
        { type: 'restaurant', id: row.id, cityId, details: { restaurantName: row.nameAr } },
        [CODE],
        step.alert ? [CODE] : [],
        now,
      );
      if (rendered === null || step.since === null) return;
      // Once per stretch without a device: its start names the push.
      await this.queue.enqueue(
        tx,
        [
          {
            source: `merchants-receiving:${row.id}:${step.since.toISOString()}`,
            recipient: { party: 'merchant', restaurantId: row.id, owners: true },
            templateKey: TEMPLATE,
            body: rendered.body,
            level: rendered.level,
            priority: rendered.priority,
            data: { restaurantId: row.id, target: 'devices' },
            at: now,
          },
        ],
        now,
      );
    });
  }
}

@Injectable()
export class ReceivingSweepWorker implements OnModuleInit, OnApplicationShutdown {
  private timer: NodeJS.Timeout | undefined;
  private running: Promise<void> | undefined;
  private readonly logger = new Logger('ReceivingSweep');

  constructor(private readonly sweep: ReceivingSweep) {}

  onModuleInit(): void {
    this.timer = setInterval(() => {
      // A slow run is never overlapped by the next.
      this.running ??= this.sweep
        .run(new Date())
        .catch((error: unknown) => {
          this.logger.error({ err: error }, 'the receiving devices were not read');
          reportError(error);
        })
        .finally(() => {
          this.running = undefined;
        });
    }, RECEIVING_SWEEP_MS);
  }

  async onApplicationShutdown(): Promise<void> {
    clearInterval(this.timer);
    await this.running;
  }
}
