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
import { CaptainsService } from '../captains/index.js';
import { GeoService } from '../geo/index.js';
import { OtpSenderPoolService } from '../identity/index.js';
import type { AlertCode } from './alert-rules.js';
import { AlertsService, type AlertSubjectRef } from './alerts.service.js';

// How often the worker reads the conditions no transaction of ours changes:
// the code senders' health (Valkey marks, the otp-sender's states) and the
// captains' cash at the current rates.
export const ALERTS_SWEEP_MS = 30_000;

const POOL_SUBJECT = 'pool';

// AP §9.1.3: «لا يمكن إرسال رموز الدخول», «رقم إرسال الرموز متوقف» and
// «كابتن بلغ حد العهدة», raised and resolved by reading their state every
// ALERTS_SWEEP_MS. Two workers syncing at once leave one open alert (the
// partial unique index).
@Injectable()
export class AlertsSweep {
  private readonly logger = new Logger('AlertsSweep');

  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly alerts: AlertsService,
    private readonly pool: OtpSenderPoolService,
    private readonly captains: CaptainsService,
    private readonly geo: GeoService,
  ) {}

  async run(now: Date): Promise<void> {
    await Promise.all([
      this.senders(now).catch((error: unknown) => this.failed('code senders', error)),
      this.cashLimits(now).catch((error: unknown) => this.failed('cash limits', error)),
    ]);
  }

  async senders(now: Date): Promise<void> {
    const { numbers, alerts } = await this.pool.read(now);
    const db = this.database.db;
    const cannotSend = alerts.some((alert) => alert.type === 'cannot_send');
    await this.alerts.sync(
      db,
      { type: 'otp_pool', id: POOL_SUBJECT, cityId: null },
      ['codes_cannot_send'],
      cannotSend ? ['codes_cannot_send'] : [],
      now,
    );
    const stopped = new Set(
      alerts.flatMap((alert) => (alert.type === 'number_stopped' ? alert.numberIds : [])),
    );
    const subjects = new Set([
      ...numbers.map((number) => number.id),
      ...(await this.alerts.openSubjects('code_number_stopped')).map((subject) => subject.id),
    ]);
    for (const id of subjects) {
      await this.alerts.sync(
        db,
        { type: 'otp_number', id, cityId: null },
        ['code_number_stopped'],
        stopped.has(id) ? ['code_number_stopped'] : [],
        now,
      );
    }
  }

  async cashLimits(now: Date): Promise<void> {
    const code: AlertCode = 'captain_cash_limit';
    const seen = new Set<string>();
    for (const city of await this.geo.activeCities()) {
      for (const captain of await this.captains.cashLimits(city.id, now)) {
        seen.add(captain.id);
        const subject: AlertSubjectRef = {
          type: 'captain',
          id: captain.id,
          cityId: city.id,
          details: { captainName: captain.name },
        };
        await this.alerts.sync(
          this.database.db,
          subject,
          [code],
          captain.atLimit ? [code] : [],
          now,
        );
      }
    }
    // A captain terminated since, or of a city no longer active.
    for (const subject of await this.alerts.openSubjects(code)) {
      if (seen.has(subject.id)) continue;
      await this.alerts.sync(
        this.database.db,
        { type: 'captain', id: subject.id, cityId: subject.cityId },
        [code],
        [],
        now,
      );
    }
  }

  private failed(what: string, error: unknown): void {
    this.logger.error({ err: error }, `alerts sweep failed: ${what}`);
    reportError(error);
  }
}

// The worker's loop of the sweep.
@Injectable()
export class AlertsSweepWorker implements OnModuleInit, OnApplicationShutdown {
  private timer: NodeJS.Timeout | undefined;
  private running: Promise<void> | undefined;

  constructor(private readonly sweep: AlertsSweep) {}

  onModuleInit(): void {
    this.timer = setInterval(() => {
      // A slow run is never overlapped by the next.
      this.running ??= this.sweep.run(new Date()).finally(() => {
        this.running = undefined;
      });
    }, ALERTS_SWEEP_MS);
  }

  async onApplicationShutdown(): Promise<void> {
    clearInterval(this.timer);
    await this.running;
  }
}
