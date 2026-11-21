import { Inject, Injectable, Logger, type OnModuleInit } from '@nestjs/common';
import { and, eq } from 'drizzle-orm';
import { ContentService, NotificationTexts } from '../content/index.js';
import { GeoService } from '../geo/index.js';
import { LateCodesService, PromoCodeUsesService } from '../marketing/index.js';
import { RestaurantStatusService } from '../merchants/index.js';
import { PushQueue } from '../notifications/index.js';
import { SettingsService } from '../settings/index.js';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { QUEUES } from '../../jobs/job-queue.js';
import { Jobs } from '../../jobs/jobs.module.js';
import { reportError } from '../../observability/error-tracking.js';
import { lockOrder, recordTransition } from './order-events.js';
import { orders } from './schema.js';
import { unansweredInBusinessDay } from './unanswered.js';

// The job of the automatic cancellation: the order and the version it was
// set for (architecture §5.5).
export interface AutoCancelJob {
  orderId: string;
  // ISO time, the order's partition key.
  placedAt: string;
  // The order's version at placing (1); no longer compared (slice 2.15c),
  // kept so the jobs already queued keep their shape.
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

// The late code's timer (AP §8.3, docs/domain/03; slice 2.22c), sent with
// every new promised time for order.delivery_late_compensation_min after it.
export interface LateCodeJob {
  orderId: string;
  // ISO time, the order's partition key.
  placedAt: string;
  // ISO time, the promised time it was set for: one moved since («تعديل
  // الوقت», an edit back to preparing) leaves this job without effect.
  promisedAt: string;
}

// The late apology's timer (CU §11.6, §14 #14, docs/domain/03; slice L.1b),
// sent with every new promised time for order.delivery_late_alert_min after
// it, with the late code's shape.
export type LateApologyJob = LateCodeJob;

// The order is still on its way: it gets the late code (owner decision
// 2026-11-17: an order that ended before the moment gets none).
const NOT_DELIVERED = ['accepted', 'ready', 'picked_up', 'arrived'];

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
    private readonly geo: GeoService,
    private readonly settings: SettingsService,
    private readonly status: RestaurantStatusService,
    private readonly promoCodes: PromoCodeUsesService,
    private readonly lateCodes: LateCodesService,
    private readonly pushes: PushQueue,
    private readonly texts: NotificationTexts,
  ) {}

  // CU §11.6, §14 #14 (slice L.1b): the order is still not delivered at its
  // promised time + order.delivery_late_alert_min, so the customer gets
  // «نعتذر، طلبك متأخر قليلاً», once per order (the push's source). A
  // promised time moved since, or an order ended, gets none. Whether it was
  // queued.
  async lateApology(job: LateApologyJob, now: Date): Promise<boolean> {
    const placedAt = new Date(job.placedAt);
    // The text is read before the lock (a content read takes a connection).
    const rendered = await this.texts.render('customer.late_apology', {});
    return this.database.db.transaction(async (tx) => {
      const order = await lockOrder(tx, job.orderId, placedAt);
      if (!order || !NOT_DELIVERED.includes(order.status)) return false;
      const [row] = await tx
        .select({ promisedAt: orders.promisedAt })
        .from(orders)
        .where(and(eq(orders.id, order.id), eq(orders.placedAt, placedAt)));
      if (!row?.promisedAt || row.promisedAt.getTime() !== new Date(job.promisedAt).getTime()) {
        return false;
      }
      await this.pushes.enqueue(
        tx,
        [
          {
            source: `customer:customer.late_apology:${order.id}`,
            recipient: { party: 'customer', accountId: order.customerAccountId },
            templateKey: 'customer.late_apology',
            body: rendered.body,
            level: rendered.level,
            priority: rendered.priority,
            data: { target: 'order', orderId: order.id },
            at: now,
          },
        ],
        now,
      );
      return true;
    });
  }

  // AP §8.3, §6.4 (slice 2.22c): the order is still not delivered at its
  // promised time + order.delivery_late_compensation_min, so the customer
  // gets the late code, once per order. A promised time moved since, or an
  // order ended, delivered or a test order (decided by us: a test order's code
  // would cost real money) gets none. The issue or why none.
  async lateCode(job: LateCodeJob, now: Date) {
    const placedAt = new Date(job.placedAt);
    return this.database.db.transaction(async (tx) => {
      const order = await lockOrder(tx, job.orderId, placedAt);
      if (!order || !NOT_DELIVERED.includes(order.status)) return 'not_late' as const;
      const [row] = await tx
        .select({
          promisedAt: orders.promisedAt,
          currency: orders.currency,
          testOrder: orders.testOrder,
        })
        .from(orders)
        .where(and(eq(orders.id, order.id), eq(orders.placedAt, placedAt)));
      if (
        !row?.promisedAt ||
        row.testOrder ||
        row.promisedAt.getTime() !== new Date(job.promisedAt).getTime()
      ) {
        return 'not_late' as const;
      }
      return this.lateCodes.issue(
        tx,
        {
          id: order.id,
          cityId: order.cityId,
          number: order.number,
          customerAccountId: order.customerAccountId,
          currency: row.currency,
          promisedAt: row.promisedAt,
        },
        now,
      );
    });
  }

  // AP §8.3: cancels a placed order the restaurant did not accept in time;
  // true when it did. The order keeps the customer's text as it is now (CU
  // Appendix C, owner decision 2026-11-07), read before the transaction. The
  // cancellation that reaches merchant.auto_pause_unanswered_count in the
  // business day auto-pauses the restaurant in the same transaction (RA §8.3,
  // AP §9.6.5), even after closing time.
  async merchantAutoCancel(job: AutoCancelJob, now: Date): Promise<boolean> {
    const customerText = await this.content.customerText(
      'system_cancellation',
      MERCHANT_AUTO_CANCEL,
    );
    return this.database.db.transaction(async (tx) => {
      const order = await lockOrder(tx, job.orderId, new Date(job.placedAt));
      // An order never returns to placed, so the status alone says the
      // restaurant has not answered: operations' steps on a placed order
      // («تعديل الطلب», «توزيع يدوي لهذا الطلب») move its version, not the
      // timer.
      if (!order || order.status !== 'placed') return false;
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
      // AP §9.11.1: a code's use is given back.
      await this.promoCodes.settle(tx, order.id, 'returned', now);
      const timeZone = await this.geo.cityTimeZone(order.cityId);
      if (timeZone !== null) {
        await this.status.autoPauseIfDue(
          tx,
          order.restaurantId,
          () =>
            unansweredInBusinessDay(tx, this.settings, {
              restaurantId: order.restaurantId,
              cityId: order.cityId,
              moment: now,
              timeZone,
            }),
          now,
        );
      }
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
    await this.jobs.work<LateCodeJob>(QUEUES.lateCode, async (batch) => {
      for (const job of batch) {
        try {
          const result = await this.timers.lateCode(job.data, new Date());
          if (typeof result === 'object') {
            this.logger.log({ orderId: job.data.orderId }, 'late code issued');
          } else if (result === 'unset' || result === 'zero' || result === 'other_currency') {
            this.logger.warn(
              { orderId: job.data.orderId, skip: result },
              'late order without a late code: order.late_compensation_value',
            );
          }
        } catch (error) {
          // pg-boss tries it again (QUEUE_OPTIONS); each failure is reported.
          this.logger.error({ err: error, orderId: job.data.orderId }, 'late code failed');
          reportError(error);
          throw error;
        }
      }
    });
    await this.jobs.work<LateApologyJob>(QUEUES.lateApology, async (batch) => {
      for (const job of batch) {
        try {
          if (await this.timers.lateApology(job.data, new Date())) {
            this.logger.log({ orderId: job.data.orderId }, 'late apology queued');
          }
        } catch (error) {
          // pg-boss tries it again (QUEUE_OPTIONS); each failure is reported.
          this.logger.error({ err: error, orderId: job.data.orderId }, 'late apology failed');
          reportError(error);
          throw error;
        }
      }
    });
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
