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
import { CaptainsService, PeakBonusService } from '../captains/index.js';
import { formatMoney, formatTime, NotificationTexts } from '../content/index.js';
import { FxService } from '../fx/index.js';
import { GeoService } from '../geo/index.js';
import { PushQueue, type QueuedPush } from './push-queue.js';

// How often the worker looks for a window that started, and how far back:
// a worker down for less than that still announces the window once it is
// back (the push's source keeps it once).
export const PEAK_NOTICES_MS = 60_000;
export const PEAK_NOTICE_CATCH_UP_MS = 10 * 60_000;

// CA §14 #23 (AP §9.12.5, D15; owner decision 2026-11-12): when a peak window
// starts, every active captain of the city hears «مكافأة الذروة الآن: +{المبلغ}
// لكل طلب حتى {الساعة}», online or not, with the chime; the push ends with
// the window.
@Injectable()
export class PeakWindowNotices {
  private readonly logger = new Logger('PeakWindowNotices');

  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly peak: PeakBonusService,
    private readonly captains: CaptainsService,
    private readonly geo: GeoService,
    private readonly fx: FxService,
    private readonly texts: NotificationTexts,
    private readonly pushes: PushQueue,
  ) {}

  async run(now: Date): Promise<void> {
    for (const city of await this.geo.activeCities()) {
      try {
        await this.announce(city, now);
      } catch (error) {
        this.logger.error({ err: error, cityId: city.id }, 'peak window notices failed');
        reportError(error);
      }
    }
  }

  private async announce(city: { id: string; timeZone: string }, now: Date): Promise<void> {
    const started = (await this.peak.activeNow(city.id, now)).filter(
      (window) => now.getTime() - window.since.getTime() <= PEAK_NOTICE_CATCH_UP_MS,
    );
    if (started.length === 0) return;
    const [captainIds, currencies] = await Promise.all([
      this.captains.activeCaptainIds(city.id, now),
      this.fx.currencies(),
    ]);
    const known = new Map(
      currencies.map((currency) => [
        currency.code,
        { symbol: currency.symbol, decimals: currency.decimals },
      ]),
    );
    const pushes: QueuedPush[] = [];
    for (const window of started) {
      const zones = window.zones.map((zone) => zone.name).join('، ');
      const templateKey = zones === '' ? 'captain.peak_started' : 'captain.peak_started_zones';
      const rendered = await this.texts.render(templateKey, {
        المبلغ: formatMoney(window.amount, window.currency, known),
        الساعة: formatTime(window.until, city.timeZone),
        ...(zones === '' ? {} : { المناطق: zones }),
      });
      const occurrence = `${window.since.toISOString()}:${window.amount}:${window.zones
        .map((zone) => zone.id)
        .join(',')}`;
      for (const captainId of captainIds) {
        pushes.push({
          source: `captain:${templateKey}:${captainId}:${occurrence}`,
          recipient: { party: 'captain', captainId },
          templateKey,
          body: rendered.body,
          level: rendered.level,
          priority: rendered.priority,
          data: { type: 'captain.peak_bonus' },
          at: window.since,
          expiresAt: window.until,
        });
      }
    }
    await this.pushes.enqueue(this.database.db, pushes, now);
  }
}

// The worker's loop of the notices.
@Injectable()
export class PeakWindowNoticesWorker implements OnModuleInit, OnApplicationShutdown {
  private timer: NodeJS.Timeout | undefined;
  private running: Promise<void> | undefined;

  constructor(private readonly notices: PeakWindowNotices) {}

  onModuleInit(): void {
    this.timer = setInterval(() => {
      // A slow run is never overlapped by the next.
      this.running ??= this.notices.run(new Date()).finally(() => {
        this.running = undefined;
      });
    }, PEAK_NOTICES_MS);
  }

  async onApplicationShutdown(): Promise<void> {
    clearInterval(this.timer);
    await this.running;
  }
}
