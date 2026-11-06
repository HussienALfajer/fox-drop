import { Inject, Injectable, Logger, type OnModuleInit } from '@nestjs/common';
import { and, eq } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { QUEUES } from '../../jobs/job-queue.js';
import { Jobs } from '../../jobs/jobs.module.js';
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

// AP §8.3: the reason of the automatic cancellation, «المطعم لم يستجب», which
// also counts the order as unanswered by the restaurant.
export const MERCHANT_NO_RESPONSE = 'merchant_no_response';

// The order's timers when they fire. Each re-reads the order under its lock
// and acts only on the state and version it was set for, so a late or
// repeated job changes nothing.
@Injectable()
export class OrderTimers {
  constructor(@Inject(DATABASE) private readonly database: Database) {}

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
          cancelReason: MERCHANT_NO_RESPONSE,
          foodPrepared: false,
        })
        .where(and(eq(orders.id, order.id), eq(orders.placedAt, order.placedAt)));
      await recordTransition(tx, order, {
        type: 'order.cancelled',
        from: 'placed',
        to: 'cancelled',
        version,
        actor: { type: 'system', id: null },
        reason: MERCHANT_NO_RESPONSE,
        at: now,
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
    await this.jobs.work<AutoCancelJob>(QUEUES.merchantAutoCancel, async (batch) => {
      for (const job of batch) {
        if (await this.timers.merchantAutoCancel(job.data, new Date())) {
          this.logger.log({ orderId: job.data.orderId }, 'cancelled: no restaurant response');
        }
      }
    });
  }
}
