import { createHash } from 'node:crypto';
import {
  Inject,
  Injectable,
  Logger,
  type OnApplicationShutdown,
  type OnModuleInit,
} from '@nestjs/common';
import { and, eq, gt, inArray, isNotNull } from 'drizzle-orm';
import type { NodePgDatabase } from 'drizzle-orm/node-postgres';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { inTransaction, QUEUES } from '../../jobs/job-queue.js';
import { Jobs } from '../../jobs/jobs.module.js';
import { reportError } from '../../observability/error-tracking.js';
import { CaptainsService } from '../captains/index.js';
import { type AlertCode, AlertsService } from '../notifications/index.js';
import { SettingsService } from '../settings/index.js';
import { UNTIL_ENDED } from './active-orders.js';
import { openItemReport } from './item-reports.js';
import { type CaptainTrack, lockOrder } from './order-events.js';
import { collections, type orderStatuses, orders, pickupRequests } from './schema.js';

type OrderStatus = (typeof orderStatuses)[number];
type Tx = Parameters<Parameters<NodePgDatabase['transaction']>[0]>[0];

const MINUTE_MS = 60_000;

// AP §9.1.3: the alerts about an order, each from its condition.
export const ORDER_ALERT_CODES = [
  'restaurant_not_accepted',
  'no_captain',
  'no_captain_after_ready',
  'captain_gps_lost',
  'pickup_disputed',
  'prep_late',
  'captain_waiting',
  'delivery_late',
  'collection_shortfall',
  'away_from_address',
  'item_unavailable',
] as const satisfies readonly AlertCode[];
export type OrderAlertCode = (typeof ORDER_ALERT_CODES)[number];

// What the conditions read of an order.
export interface OrderAlertInput {
  status: OrderStatus;
  captainId: string | null;
  captainTrack: CaptainTrack | null;
  acceptAlertAt: Date | null;
  prepLateAlertAt: Date | null;
  searchAlertAt: Date | null;
  noCaptainAlertAt: Date | null;
  captainWaitingAlertAt: Date | null;
  // promised_at plus order.delivery_late_alert_min.
  deliveryLateAt: Date | null;
  // When the captain was assigned, and their newest point since (null with
  // none), with captain.gps_stale_alert_min.
  assignedAt: Date | null;
  lastFixAt: Date | null;
  gpsStaleMin: number;
  amountDisputed: boolean;
  away: boolean;
  shortfall: boolean;
  // RA §8.12: an open item-unavailable report.
  itemReportOpen: boolean;
}

// The captain tracks of a captain on the order (AP §9.1.3 «أثناء طلب»).
const ON_THE_ORDER: readonly CaptainTrack[] = [
  'assigned',
  'at_merchant',
  'pickup_pending',
  'picked_up',
  'at_customer',
];

// The open alerts of an order now, and the next moment one of them may open
// with nothing else changing (a timer for it). Pure, so the board and the
// alerts' records agree.
export function orderAlerts(
  order: OrderAlertInput,
  now: Date,
): { open: OrderAlertCode[]; next: Date | null } {
  const open: OrderAlertCode[] = [];
  const ahead: Date[] = [];
  // A condition that holds from a moment: open once it passed, else a timer.
  const from = (code: OrderAlertCode, when: boolean, moment: Date | null) => {
    if (!when || moment === null) return;
    if (moment <= now) open.push(code);
    else ahead.push(moment);
  };
  const waiting = order.status === 'accepted' || order.status === 'ready';
  const unassigned = order.captainId === null;
  from('restaurant_not_accepted', order.status === 'placed', order.acceptAlertAt);
  from('no_captain', waiting && unassigned, order.searchAlertAt);
  from('no_captain_after_ready', order.status === 'ready' && unassigned, order.noCaptainAlertAt);
  const onTheOrder =
    UNTIL_ENDED.includes(order.status) &&
    order.captainId !== null &&
    order.captainTrack !== null &&
    ON_THE_ORDER.includes(order.captainTrack);
  // No point for captain.gps_stale_alert_min, counted from the newest point
  // or the assignment, whichever is later. Its moment moves with every point,
  // so the worker's sweep checks it (GPS_SWEEP_MS), never a timer.
  const heardAt = [order.lastFixAt, order.assignedAt]
    .filter((moment): moment is Date => moment !== null)
    .reduce<Date | null>((latest, moment) => (latest && latest > moment ? latest : moment), null);
  if (
    onTheOrder &&
    heardAt !== null &&
    heardAt.getTime() + order.gpsStaleMin * MINUTE_MS <= now.getTime()
  ) {
    open.push('captain_gps_lost');
  }
  // RA §8.10 item 6.4: until the pickup completes or the order ends.
  if (waiting && order.amountDisputed) open.push('pickup_disputed');
  from('prep_late', order.status === 'accepted', order.prepLateAlertAt);
  const atRestaurant =
    order.captainTrack === 'at_merchant' || order.captainTrack === 'pickup_pending';
  from('captain_waiting', waiting && atRestaurant, order.captainWaitingAlertAt);
  from('delivery_late', UNTIL_ENDED.includes(order.status), order.deliveryLateAt);
  // AP §8.6: open until operations resolve it (not built yet).
  if (order.shortfall) open.push('collection_shortfall');
  if (order.away) open.push('away_from_address');
  if (order.itemReportOpen) open.push('item_unavailable');
  const next = ahead.reduce<Date | null>(
    (soonest, moment) => (soonest && soonest < moment ? soonest : moment),
    null,
  );
  return { open, next };
}

// The job that syncs an order's alerts: sent with each transition
// (recordTransition) and for the next moment an alert may open.
export interface OrderAlertsJob {
  orderId: string;
  // ISO time, the order's partition key.
  placedAt: string;
}

// AP §7.3, §9.1.3: the order's alerts, synced under the order's lock so two
// runs never interleave, with the timer of its next moment in the same
// transaction.
@Injectable()
export class OrderAlerts {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly jobs: Jobs,
    private readonly alerts: AlertsService,
    private readonly captains: CaptainsService,
    private readonly settings: SettingsService,
  ) {}

  // With `timer`, it also sends the job of the next moment: a transition's
  // run and a timer's do; the GPS sweep's does not, or it would add a job
  // every run.
  async sync(job: OrderAlertsJob, now: Date, timer = true): Promise<void> {
    const placedAt = new Date(job.placedAt);
    const [row] = await this.database.db
      .select({ cityId: orders.cityId, captainId: orders.captainId })
      .from(orders)
      .where(and(eq(orders.id, job.orderId), eq(orders.placedAt, placedAt)));
    if (!row) return;
    // Settings and the captain's points are read before the transaction (a
    // settings read may take a pool connection of its own).
    const [lateMin, gpsStaleMin, fixes] = await Promise.all([
      this.settings.get('order.delivery_late_alert_min', { cityId: row.cityId }),
      this.settings.get('captain.gps_stale_alert_min', { cityId: row.cityId }),
      row.captainId === null
        ? Promise.resolve(new Map<string, Date>())
        : this.captains.lastFixes([row.captainId], new Date(now.getTime() - 60 * MINUTE_MS)),
    ]);
    await this.database.db.transaction(async (tx) => {
      const order = await lockOrder(tx, job.orderId, placedAt);
      if (!order) return;
      const input = await readInput(tx, order.id, placedAt, lateMin);
      const { open, next } = orderAlerts(
        {
          ...input,
          gpsStaleMin,
          // The captain read before the lock; another since has no point yet.
          lastFixAt: input.captainId === null ? null : (fixes.get(input.captainId) ?? null),
        },
        now,
      );
      await this.alerts.sync(
        tx,
        {
          type: 'order',
          id: order.id,
          cityId: order.cityId,
          details: { orderNumber: order.number.toString() },
        },
        ORDER_ALERT_CODES,
        open,
        now,
      );
      if (timer && next) {
        await this.jobs.send(
          QUEUES.orderAlerts,
          { orderId: order.id, placedAt: job.placedAt } satisfies OrderAlertsJob,
          {
            db: inTransaction(tx),
            // One timer per order and moment, however many syncs send it.
            id: timerId(order.id, next),
            startAfter: next,
          },
        );
      }
    });
  }

  // The live orders, for the worker's start, or those a captain is on, for
  // the GPS sweep.
  async liveOrders(withCaptain: boolean): Promise<OrderAlertsJob[]> {
    const rows = await this.database.db
      .select({ orderId: orders.id, placedAt: orders.placedAt })
      .from(orders)
      .where(
        and(
          inArray(orders.status, UNTIL_ENDED),
          withCaptain ? isNotNull(orders.captainId) : undefined,
        ),
      );
    return rows.map((row) => ({ orderId: row.orderId, placedAt: row.placedAt.toISOString() }));
  }
}

// A UUID derived from the order and the moment (in the form of version 5),
// so pg-boss keeps one job for both (its insert skips a known id).
export function timerId(orderId: string, moment: Date): string {
  const hex = createHash('sha1').update(`${orderId}:${moment.toISOString()}`).digest('hex');
  const variant = ((parseInt(hex.slice(16, 18), 16) & 0x3f) | 0x80).toString(16);
  return `${hex.slice(0, 8)}-${hex.slice(8, 12)}-5${hex.slice(13, 16)}-${variant}${hex.slice(18, 20)}-${hex.slice(20, 32)}`;
}

async function readInput(
  tx: Tx,
  orderId: string,
  placedAt: Date,
  deliveryLateMin: number,
): Promise<Omit<OrderAlertInput, 'gpsStaleMin' | 'lastFixAt'>> {
  const [order] = await tx
    .select({
      status: orders.status,
      captainId: orders.captainId,
      captainTrack: orders.captainTrack,
      acceptAlertAt: orders.acceptAlertAt,
      prepLateAlertAt: orders.prepLateAlertAt,
      searchAlertAt: orders.searchAlertAt,
      noCaptainAlertAt: orders.noCaptainAlertAt,
      captainWaitingAlertAt: orders.captainWaitingAlertAt,
      promisedAt: orders.promisedAt,
      assignedAt: orders.assignedAt,
      awayReason: orders.awayReason,
    })
    .from(orders)
    .where(and(eq(orders.id, orderId), eq(orders.placedAt, placedAt)));
  const [disputed] = await tx
    .select({ id: pickupRequests.id })
    .from(pickupRequests)
    .where(
      and(
        eq(pickupRequests.orderId, orderId),
        eq(pickupRequests.orderPlacedAt, placedAt),
        eq(pickupRequests.outcome, 'amount_incorrect'),
      ),
    )
    .limit(1);
  const [short] = await tx
    .select({ orderId: collections.orderId })
    .from(collections)
    .where(
      and(
        eq(collections.orderId, orderId),
        eq(collections.orderPlacedAt, placedAt),
        gt(collections.shortfall, 0n),
      ),
    )
    .limit(1);
  const report = await openItemReport(tx, orderId, placedAt);
  const row = order!;
  return {
    status: row.status,
    captainId: row.captainId,
    captainTrack: row.captainTrack,
    acceptAlertAt: row.acceptAlertAt,
    prepLateAlertAt: row.prepLateAlertAt,
    searchAlertAt: row.searchAlertAt,
    noCaptainAlertAt: row.noCaptainAlertAt,
    captainWaitingAlertAt: row.captainWaitingAlertAt,
    deliveryLateAt:
      row.promisedAt && new Date(row.promisedAt.getTime() + deliveryLateMin * MINUTE_MS),
    assignedAt: row.assignedAt,
    amountDisputed: disputed !== undefined,
    away: row.awayReason !== null,
    shortfall: short !== undefined,
    itemReportOpen: report !== null,
  };
}

// How often the worker checks the captains on an order for their GPS
// (captain.gps_stale_alert_min is 2 minutes or more).
export const GPS_SWEEP_MS = 30_000;

// The worker: the order alert jobs, and the sweep of the orders a captain is
// on, since a point that stops coming changes no order.
@Injectable()
export class OrderAlertsWorker implements OnModuleInit, OnApplicationShutdown {
  private readonly logger = new Logger('OrderAlerts');
  private timer: NodeJS.Timeout | undefined;
  private sweeping: Promise<void> | undefined;

  constructor(
    private readonly jobs: Jobs,
    private readonly alerts: OrderAlerts,
  ) {}

  async onModuleInit(): Promise<void> {
    await this.jobs.work<OrderAlertsJob>(QUEUES.orderAlerts, async (batch) => {
      for (const job of batch) await this.run(job.data, true, true);
    });
    // The orders live when the worker starts (a deploy, or a sync whose
    // retries ran out) get their alerts and timers again.
    this.sweeping = this.sweep(false, true).finally(() => {
      this.sweeping = undefined;
    });
    this.timer = setInterval(() => {
      this.sweeping ??= this.sweep(true, false).finally(() => {
        this.sweeping = undefined;
      });
    }, GPS_SWEEP_MS);
  }

  async onApplicationShutdown(): Promise<void> {
    clearInterval(this.timer);
    await this.sweeping;
  }

  private async sweep(withCaptain: boolean, timer: boolean): Promise<void> {
    try {
      for (const job of await this.alerts.liveOrders(withCaptain)) {
        await this.run(job, false, timer);
      }
    } catch (error) {
      this.logger.error({ err: error }, 'order alerts sweep failed');
      reportError(error);
    }
  }

  private async run(job: OrderAlertsJob, rethrow: boolean, timer: boolean): Promise<void> {
    try {
      await this.alerts.sync(job, new Date(), timer);
    } catch (error) {
      // A job is tried again by pg-boss (QUEUE_OPTIONS); each failure is
      // reported.
      this.logger.error({ err: error, orderId: job.orderId }, 'order alerts sync failed');
      reportError(error);
      if (rethrow) throw error;
    }
  }
}
