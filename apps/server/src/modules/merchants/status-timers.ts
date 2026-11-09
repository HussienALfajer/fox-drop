import { Injectable, Logger, type OnModuleInit } from '@nestjs/common';
import { QUEUES } from '../../jobs/job-queue.js';
import { Jobs } from '../../jobs/jobs.module.js';
import { reportError } from '../../observability/error-tracking.js';
import {
  type BusyReminderJob,
  type PauseEndJob,
  RestaurantStatusService,
} from './restaurant-status.service.js';

// The worker's handlers of the restaurant status timers: a timed pause's end
// (RA §16 #24) and busy mode's reminder (RA §7.3, §16 #25). Each re-reads the
// restaurant under its lock and acts only on what the job was set for, so a
// late or repeated job changes nothing.
@Injectable()
export class RestaurantStatusTimersWorker implements OnModuleInit {
  private readonly logger = new Logger('RestaurantStatusTimers');

  constructor(
    private readonly jobs: Jobs,
    private readonly status: RestaurantStatusService,
  ) {}

  async onModuleInit(): Promise<void> {
    await this.jobs.work<PauseEndJob>(QUEUES.pauseEnd, async (batch) => {
      for (const job of batch) {
        await this.run('pause end', job.data.restaurantId, () =>
          this.status.pauseEnded(job.data, new Date()),
        );
      }
    });
    await this.jobs.work<BusyReminderJob>(QUEUES.busyReminder, async (batch) => {
      for (const job of batch) {
        await this.run('busy-mode reminder', job.data.restaurantId, () =>
          this.status.busyReminder(job.data, new Date()),
        );
      }
    });
  }

  private async run(what: string, restaurantId: string, act: () => Promise<boolean>) {
    try {
      if (await act()) this.logger.log({ restaurantId }, what);
    } catch (error) {
      // pg-boss tries it again (QUEUE_OPTIONS); each failure is reported.
      this.logger.error({ err: error, restaurantId }, `${what} failed`);
      reportError(error);
      throw error;
    }
  }
}
