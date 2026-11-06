import { Inject, Injectable, Logger, type OnModuleInit } from '@nestjs/common';
import { and, eq } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { QUEUES } from '../../jobs/job-queue.js';
import { Jobs } from '../../jobs/jobs.module.js';
import { reportError } from '../../observability/error-tracking.js';
import { lockOrder, recordTransition } from './order-events.js';
import { orders } from './schema.js';

// The job of the automatic cancellation: the order and the version it was
// set for (architecture §5.5).
export interface AutoCancelJob {
  orderId: string;
  // ISO time, the order's partition key.
  placedAt: string;
  version: number;
}

// The search-start timer of an accepted order (AP §8.3, §9.12.6), set for
// its search-start moment.
export interface SearchStartJob {
  orderId: string;
  // ISO time, the order's partition key.
  placedAt: string;
  // ISO time, the moment it was set for: one moved since (an early ready,
  // later «تعديل الوقت») leaves this job without effect.
  searchStartAt: string;
}

// AP §8.3: the reason of the automatic cancellation, «المطعم لم يستجب», kept
// for the system alone: it is what counts the order as unanswered by the
// restaurant (RA §11), which an operations cancellation never does.
export const MERCHANT_AUTO_CANCEL = 'merchant_auto_cancel';

// The order's timers when they fire. Each re-reads the order under its lock
// and acts only on the state and version it was set for, so a late or
// repeated job changes nothing.
@Injectable()
export class OrderTimers {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly jobs: Jobs,
  ) {}

  // AP §8.3: cancels a placed order the restaurant did not accept in time;
  // true when it did.
  async merchantAutoCancel(job: AutoCancelJob, now: Date): Promise<boolean> {
    return this.database.db.transaction(async (tx) => {
      const order = await lockOrder(tx, job.orderId, new Date(job.placedAt));
      if (!order || order.status !== 'placed' || order.version !== job.version) return false;
      const version = order.version + 1;
      await tx
        .update(orders)
        .set({
          status: 'cancelled',
          version,
          cancelledAt: now,
          cancelReason: MERCHANT_AUTO_CANCEL,
          foodPrepared: false,
        })
        .where(and(eq(orders.id, order.id), eq(orders.placedAt, order.placedAt)));
      await recordTransition(tx, this.jobs, order, {
        type: 'order.cancelled',
        from: 'placed',
        to: 'cancelled',
        version,
        actor: { type: 'system', id: null },
        reason: MERCHANT_AUTO_CANCEL,
        at: now,
      });
      return true;
    });
  }

  // AP §8.3, §9.12.6: the search-start moment came; true while the order
  // still waits for a captain (accepted or ready) and its moment is still the
  // job's. In manual mode (D6) it raises «بحاجة لتعيين», which comes with
  // dispatch (slice 1.11) and will act under the order's lock; until then the
  // worker logs it.
  async searchStart(job: SearchStartJob): Promise<boolean> {
    const [order] = await this.database.db
      .select({ status: orders.status, searchStartAt: orders.searchStartAt })
      .from(orders)
      .where(and(eq(orders.id, job.orderId), eq(orders.placedAt, new Date(job.placedAt))));
    return (
      (order?.status === 'accepted' || order?.status === 'ready') &&
      order.searchStartAt?.getTime() === new Date(job.searchStartAt).getTime()
    );
  }
}

// The worker's handlers of the order timers.
@Injectable()
export class OrderTimersWorker implements OnModuleInit {
  private readonly logger = new Logger('OrderTimers');

  constructor(
    private readonly jobs: Jobs,
    private readonly timers: OrderTimers,
  ) {}

  async onModuleInit(): Promise<void> {
    await this.jobs.work<SearchStartJob>(QUEUES.searchStart, async (batch) => {
      for (const job of batch) {
        try {
          if (await this.timers.searchStart(job.data)) {
            this.logger.log(
              { orderId: job.data.orderId },
              'search start: the order needs a captain',
            );
          }
        } catch (error) {
          // pg-boss tries it again (QUEUE_OPTIONS); each failure is reported.
          this.logger.error({ err: error, orderId: job.data.orderId }, 'search start failed');
          reportError(error);
          throw error;
        }
      }
    });
    await this.jobs.work<AutoCancelJob>(QUEUES.merchantAutoCancel, async (batch) => {
      for (const job of batch) {
        try {
          if (await this.timers.merchantAutoCancel(job.data, new Date())) {
            this.logger.log({ orderId: job.data.orderId }, 'cancelled: no restaurant response');
          }
        } catch (error) {
          // pg-boss tries it again (QUEUE_OPTIONS); each failure is reported.
          this.logger.error(
            { err: error, orderId: job.data.orderId },
            'automatic cancellation failed',
          );
          reportError(error);
          throw error;
        }
      }
    });
  }
}
