import { Inject, Injectable, Logger, type OnModuleInit } from '@nestjs/common';
import { and, eq } from 'drizzle-orm';
import { ContentService } from '../content/index.js';
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
  // dispatch.no_captain_alert_min when the job was sent (AP §8.3); a job
  // sent before slice 1.11 has none and takes the default, 5.
  noCaptainAlertMin?: number;
}

const MINUTE_MS = 60_000;

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
    private readonly content: ContentService,
  ) {}

  // AP §8.3: cancels a placed order the restaurant did not accept in time;
  // true when it did. The order keeps the customer's text as it is now (CU
  // Appendix C, owner decision 2026-11-07), read before the transaction.
  async merchantAutoCancel(job: AutoCancelJob, now: Date): Promise<boolean> {
    const customerText = await this.content.customerText(
      'system_cancellation',
      MERCHANT_AUTO_CANCEL,
    );
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
          cancelCustomerText: customerText,
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

  // AP §8.3, §9.12.6: the search-start moment came. While the order still
  // waits for a captain (accepted or ready, none assigned) and its moment is
  // still the job's, the search starts: in manual mode (D6, the only one
  // built) the order needs assignment, «بحاجة لتعيين», while its track is
  // searching, and operations' «طلب بلا كابتن» moment is
  // dispatch.no_captain_alert_min later. An order already offered keeps its
  // offer and returns to searching if it is declined or expires. True when
  // the search started.
  async searchStart(job: SearchStartJob, now: Date): Promise<boolean> {
    const placedAt = new Date(job.placedAt);
    return this.database.db.transaction(async (tx) => {
      const order = await lockOrder(tx, job.orderId, placedAt);
      if (!order || (order.status !== 'accepted' && order.status !== 'ready')) return false;
      if (order.captainId !== null) return false;
      const [moments] = await tx
        .select({ searchStartAt: orders.searchStartAt, searchStartedAt: orders.searchStartedAt })
        .from(orders)
        .where(and(eq(orders.id, order.id), eq(orders.placedAt, placedAt)));
      // A moment moved since (an early ready, later «تعديل الوقت») leaves
      // this job without effect, and the search starts once.
      if (
        !moments ||
        moments.searchStartedAt !== null ||
        moments.searchStartAt?.getTime() !== new Date(job.searchStartAt).getTime()
      ) {
        return false;
      }
      const version = order.version + 1;
      const captainTrack = order.captainTrack ?? 'searching';
      await tx
        .update(orders)
        .set({
          version,
          captainTrack,
          searchStartedAt: now,
          searchAlertAt: new Date(now.getTime() + (job.noCaptainAlertMin ?? 5) * MINUTE_MS),
        })
        .where(and(eq(orders.id, order.id), eq(orders.placedAt, placedAt)));
      await recordTransition(tx, this.jobs, order, {
        type: 'order.search_started',
        from: order.status,
        to: order.status,
        version,
        actor: { type: 'system', id: null },
        reason: null,
        at: now,
        captainTrack,
      });
      return true;
    });
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
          if (await this.timers.searchStart(job.data, new Date())) {
            this.logger.log(
              { orderId: job.data.orderId },
              'search started: the order needs a captain',
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
