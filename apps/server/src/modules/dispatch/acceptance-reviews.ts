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
import { type AlertCode, AlertsService } from '../notifications/index.js';
import { SettingsService } from '../settings/index.js';
import { DispatchService } from './dispatch.service.js';

// How often the worker reads the acceptance rates (decided by us): a rate
// changes only with an answer, so a minute is soon enough for a review task.
export const ACCEPTANCE_REVIEW_MS = 60_000;

const CODE: AlertCode = 'acceptance_review';

// A rate in whole percent, as the app and the panel show it; null without
// an answered offer.
export function acceptanceRate(counts: { accepted: number; answered: number } | undefined) {
  return counts === undefined || counts.answered === 0
    ? null
    : Math.round((counts.accepted * 100) / counts.answered);
}

// AP §9.7.6, §9.1.3 «مراجعة نسبة القبول», CA §11.1 (slice 2.36b): OPS gets
// a review task while a captain's acceptance over the last
// captain.acceptance_window_offers answered offers is below
// captain.acceptance_review_pct; it closes once the rate is back. No
// automatic suspension in V1. Read from the offers, so it lives here.
@Injectable()
export class AcceptanceReviews {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly dispatch: DispatchService,
    private readonly captains: CaptainsService,
    private readonly geo: GeoService,
    private readonly settings: SettingsService,
    private readonly alerts: AlertsService,
  ) {}

  async run(now: Date): Promise<void> {
    const seen = new Set<string>();
    for (const city of await this.geo.activeCities()) {
      const [captains, window, threshold] = await Promise.all([
        this.captains.reviewable(city.id),
        this.settings.get('captain.acceptance_window_offers', { cityId: city.id }),
        this.settings.get('captain.acceptance_review_pct', { cityId: city.id }),
      ]);
      const counts = await this.dispatch.acceptance(
        captains.map((captain) => captain.id),
        window,
      );
      for (const captain of captains) {
        seen.add(captain.id);
        const rate = acceptanceRate(counts.get(captain.id));
        await this.sync(
          {
            type: 'captain',
            id: captain.id,
            cityId: city.id,
            details: { captainName: captain.name, rate: String(rate ?? '') },
          },
          rate !== null && rate < threshold,
          now,
        );
      }
    }
    // A captain terminated since, or of a city no longer active.
    for (const subject of await this.alerts.openSubjects(CODE)) {
      if (seen.has(subject.id)) continue;
      await this.sync({ type: 'captain', id: subject.id, cityId: subject.cityId }, false, now);
    }
  }

  private sync(
    subject: Parameters<AlertsService['sync']>[1],
    open: boolean,
    now: Date,
  ): Promise<void> {
    return this.database.db.transaction((tx) =>
      this.alerts.sync(tx, subject, [CODE], open ? [CODE] : [], now),
    );
  }
}

// The worker's loop of the review.
@Injectable()
export class AcceptanceReviewsWorker implements OnModuleInit, OnApplicationShutdown {
  private readonly logger = new Logger('AcceptanceReviews');
  private timer: NodeJS.Timeout | undefined;
  private running: Promise<void> | undefined;

  constructor(private readonly reviews: AcceptanceReviews) {}

  onModuleInit(): void {
    this.timer = setInterval(() => {
      // A slow run is never overlapped by the next.
      this.running ??= this.reviews
        .run(new Date())
        .catch((error: unknown) => {
          this.logger.error({ err: error }, 'the acceptance review failed');
          reportError(error);
        })
        .finally(() => {
          this.running = undefined;
        });
    }, ACCEPTANCE_REVIEW_MS);
  }

  async onApplicationShutdown(): Promise<void> {
    clearInterval(this.timer);
    await this.running;
  }
}
