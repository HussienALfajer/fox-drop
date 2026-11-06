import { Injectable, Logger, Module, type OnModuleInit } from '@nestjs/common';
import { DatabaseModule } from '../../database/database.module.js';
import { QUEUES } from '../../jobs/job-queue.js';
import { Jobs, JobsModule } from '../../jobs/jobs.module.js';
import { reportError } from '../../observability/error-tracking.js';
import { AuditModule } from '../audit/index.js';
import { CaptainsModule } from '../captains/index.js';
import { GeoModule } from '../geo/index.js';
import { MerchantsModule } from '../merchants/index.js';
import { OrderAssignmentsModule } from '../ordering/index.js';
import { SettingsModule } from '../settings/index.js';
import { AdminDispatchController, CaptainOffersController } from './dispatch.controller.js';
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
// manual dispatch (D6; AP §9.3.2, §9.12.6; CA §8). Automatic and mixed
// dispatch, with their ranking and loop in the dispatcher role, join later.
@Module({
  imports,
  controllers: [AdminDispatchController, CaptainOffersController],
  providers: [DispatchService],
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

@Module({ imports, providers: [DispatchService, OfferTimersWorker] })
export class DispatchWorkerModule {}

export {
  type CaptainOffer,
  DispatchRefusedError,
  DispatchService,
  type DispatchState,
} from './dispatch.service.js';
