import { Injectable, Logger, type OnApplicationShutdown, type OnModuleInit } from '@nestjs/common';
import { reportError } from '../../observability/error-tracking.js';
import { GeoService } from '../geo/index.js';
import { MerchantStatementsService } from './merchant-statements.service.js';

// How often the worker looks for a settlement cutoff that passed: the
// statement is taken, and the owners told, within this of the cutoff.
export const MERCHANT_STATEMENTS_MS = 60_000;

// AP §8.7 (slice 2.19a): each active city's restaurants get their statement
// at the cutoff that starts merchant.settlement_weekday. A city whose cutoff
// was swept is skipped until the next one; a failed sweep runs again.
@Injectable()
export class MerchantStatementsWorker implements OnModuleInit, OnApplicationShutdown {
  private readonly logger = new Logger('MerchantStatementsWorker');
  private timer: NodeJS.Timeout | undefined;
  private running: Promise<void> | undefined;
  private readonly swept = new Map<string, number>();

  constructor(
    private readonly statements: MerchantStatementsService,
    private readonly geo: GeoService,
  ) {}

  onModuleInit(): void {
    const tick = () => {
      // A slow run is never overlapped by the next.
      this.running ??= this.run(new Date()).finally(() => {
        this.running = undefined;
      });
    };
    tick();
    this.timer = setInterval(tick, MERCHANT_STATEMENTS_MS);
  }

  async run(now: Date): Promise<void> {
    for (const city of await this.geo.activeCities()) {
      try {
        const { last } = await this.statements.cutoffs(city.id, now);
        if (this.swept.get(city.id) === last.getTime()) continue;
        const { cutoff, complete } = await this.statements.closeDue(city.id, now);
        if (complete) this.swept.set(city.id, cutoff.getTime());
      } catch (error) {
        this.logger.error({ err: error, cityId: city.id }, 'restaurant statements failed');
        reportError(error);
      }
    }
  }

  async onApplicationShutdown(): Promise<void> {
    clearInterval(this.timer);
    await this.running;
  }
}
