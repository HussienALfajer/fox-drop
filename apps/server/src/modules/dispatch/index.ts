import {
  Inject,
  Injectable,
  Logger,
  Module,
  type OnApplicationBootstrap,
  type OnModuleDestroy,
  type OnModuleInit,
} from '@nestjs/common';
import pg from 'pg';
import { DATABASE, DatabaseModule } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { QUEUES } from '../../jobs/job-queue.js';
import { Jobs, JobsModule } from '../../jobs/jobs.module.js';
import { reportError } from '../../observability/error-tracking.js';
import { AuditModule } from '../audit/index.js';
import { CaptainsModule } from '../captains/index.js';
import { GeoModule, GeoService } from '../geo/index.js';
import { MerchantsModule } from '../merchants/index.js';
import { NotificationsWorkerModule } from '../notifications/index.js';
import { OrderAssignmentsModule } from '../ordering/index.js';
import { SettingsModule } from '../settings/index.js';
import { AdminDispatchController, CaptainOffersController } from './dispatch.controller.js';
import { AcceptanceReviews, AcceptanceReviewsWorker } from './acceptance-reviews.js';
import { AdminLiveMapController } from './admin-live-map.controller.js';
import { LiveMap, LiveMapPublisher } from './live-map.js';
import { DispatchService, type OfferExpiryJob } from './dispatch.service.js';

const imports = [
  DatabaseModule,
  JobsModule,
  SettingsModule,
  AuditModule,
  GeoModule,
  MerchantsModule,
  CaptainsModule,
  OrderAssignmentsModule,
];

// The dispatch module (architecture §4.2): the offers and assignments of
// manual dispatch (D6; AP §9.3.2, §9.12.6; CA §8); automatic and mixed
// dispatch run in the dispatcher role (DispatcherModule).
@Module({
  imports,
  controllers: [AdminDispatchController, CaptainOffersController, AdminLiveMapController],
  providers: [DispatchService, LiveMap],
  exports: [DispatchService],
})
export class DispatchModule {}

// The worker's offer timers (AP §8.3: dispatch.offer_timeout_sec).
@Injectable()
export class OfferTimersWorker implements OnModuleInit {
  private readonly logger = new Logger('OfferTimers');

  constructor(
    private readonly jobs: Jobs,
    private readonly dispatch: DispatchService,
  ) {}

  async onModuleInit(): Promise<void> {
    await this.jobs.work<OfferExpiryJob>(QUEUES.offerExpiry, async (batch) => {
      for (const job of batch) {
        try {
          if (await this.dispatch.expire(job.data, new Date())) {
            this.logger.log({ offerId: job.data.offerId }, 'offer expired');
          }
        } catch (error) {
          // pg-boss tries it again (QUEUE_OPTIONS); each failure is reported.
          this.logger.error({ err: error, offerId: job.data.offerId }, 'offer expiry failed');
          reportError(error);
          throw error;
        }
      }
    });
  }
}

// The worker also runs the acceptance review (AP §9.7.6, slice 2.36b), which
// raises operations' alert, and publishes the live map's captains (AP §9.4,
// slice 2.39).
@Module({
  imports: [...imports, NotificationsWorkerModule],
  providers: [
    DispatchService,
    OfferTimersWorker,
    AcceptanceReviews,
    AcceptanceReviewsWorker,
    LiveMap,
    LiveMapPublisher,
  ],
  // The reports' exports read the offers (slice 2.41) through the worker's
  // own DispatchService, so its listeners are registered once.
  exports: [DispatchService],
})
export class DispatchWorkerModule {}

// How often the dispatcher passes over each city it leads: the next offer
// after a decline, an expiry or a withdrawal follows within it.
export const DISPATCH_TICK_MS = 1000;

// Architecture §4.4, AP §9.12.6 (slice 2.15b): the dispatcher role's loop.
// Each active city has one leader, the process that holds the city's
// session advisory lock on its own connection; a lost connection frees the
// lock, and another process leads at its next tick. Every offer is still
// checked under the order's and the captain's locks, so two leaders for a
// moment never offer one order twice.
@Injectable()
export class AutoDispatcher implements OnApplicationBootstrap, OnModuleDestroy {
  private readonly logger = new Logger('AutoDispatcher');
  private timer: NodeJS.Timeout | null = null;
  private running: Promise<void> | null = null;
  private client: pg.Client | null = null;
  private readonly led = new Set<string>();

  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly geo: GeoService,
    private readonly dispatch: DispatchService,
  ) {}

  onApplicationBootstrap(): void {
    this.timer = setInterval(() => {
      this.running ??= this.tick().finally(() => {
        this.running = null;
      });
    }, DISPATCH_TICK_MS);
  }

  async onModuleDestroy(): Promise<void> {
    if (this.timer) clearInterval(this.timer);
    await this.running;
    // The server frees the locks before it closes the connection, so once
    // the end resolves another process can lead at its next tick.
    await this.drop();
  }

  // One pass over every active city this process leads.
  async tick(): Promise<void> {
    try {
      for (const city of await this.geo.activeCities()) {
        if (!(await this.lead(city.id))) continue;
        try {
          const sent = await this.dispatch.autoDispatchCity(city.id, new Date());
          if (sent > 0) this.logger.log({ cityId: city.id, sent }, 'automatic offers sent');
        } catch (error) {
          this.logger.error({ err: error, cityId: city.id }, 'automatic dispatch failed');
          reportError(error);
        }
      }
    } catch (error) {
      this.logger.error({ err: error }, 'the dispatcher could not read the cities');
      reportError(error);
    }
  }

  // Whether this process leads the city: it holds the city's lock, or takes
  // it now.
  // A city already led checks that the session still holds the lock: a
  // half-open connection the server ended gives no error until used.
  private async lead(cityId: string): Promise<boolean> {
    try {
      if (this.led.has(cityId) && this.client !== null) {
        const { rows } = await this.client.query<{ held: boolean }>(
          `SELECT EXISTS (
             SELECT 1 FROM pg_locks
             WHERE locktype = 'advisory' AND pid = pg_backend_pid() AND granted
               AND ((classid::bigint << 32) | objid::bigint) = hashtextextended($1, 0)
           ) AS held`,
          [`dispatcher:${cityId}`],
        );
        if (rows[0]?.held) return true;
        this.logger.warn({ cityId }, 'the city lock was lost');
        void this.drop();
        return false;
      }
      this.client ??= await this.connect();
      const { rows } = await this.client.query<{ led: boolean }>(
        'SELECT pg_try_advisory_lock(hashtextextended($1, 0)) AS led',
        [`dispatcher:${cityId}`],
      );
      if (rows[0]?.led) {
        this.led.add(cityId);
        this.logger.log({ cityId }, 'leading the city');
      }
      return this.led.has(cityId);
    } catch (error) {
      this.logger.warn({ err: error }, 'the leader connection failed');
      void this.drop();
      return false;
    }
  }

  // A connection of its own, outside the pool, with TCP keepalive, so a
  // dead peer is found.
  private async connect(): Promise<pg.Client> {
    const client = new pg.Client({ ...this.database.pool.options, keepAlive: true });
    client.on('error', (error) => {
      this.logger.warn({ err: error }, 'the leader connection was lost');
      if (this.client === client) void this.drop();
    });
    await client.connect();
    return client;
  }

  // Closes the leader connection, which frees every lock it held. Only
  // stopping waits for it: a tick never waits on a broken connection.
  private async drop(): Promise<void> {
    const client = this.client;
    this.client = null;
    this.led.clear();
    await client?.end().catch(() => undefined);
  }
}

@Module({ imports, providers: [DispatchService, AutoDispatcher] })
export class DispatcherModule {}

export { AcceptanceReviews, acceptanceRate, rateBelow } from './acceptance-reviews.js';
export {
  type CaptainOffer,
  type CaptainOfferLogRow,
  DispatchRefusedError,
  DispatchService,
  type DispatchState,
} from './dispatch.service.js';
