import { Inject, Injectable } from '@nestjs/common';
import { and, asc, count, eq, inArray } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { CaptainsService } from '../captains/index.js';
import { MerchantsService } from '../merchants/index.js';
import { UNTIL_ENDED } from './active-orders.js';
import type { CaptainTrack } from './order-events.js';
import { orderKey, readOrders, type OrderView } from './order-views.js';
import { orderEvents, orders } from './schema.js';

// AP §9.1.3, §8.3: operations' alerts, each from its moment (owner decision
// 2026-11-06: the board's read shows them once their moment passed; the
// critical alerts' timers, sounds and channel come with their slice).
export type OperationsAlert =
  // «مطعم لم يقبل»: placed, past order.merchant_accept_alert_min.
  | 'restaurant_not_accepted'
  // «تحضير متأخر»: accepted, order.prep_late_ops_alert_min past the prep time.
  | 'prep_late'
  // «طلب بلا كابتن»: dispatch.no_captain_alert_min after the search started.
  | 'no_captain'
  // No captain dispatch.no_captain_after_ready_min after ready.
  | 'no_captain_after_ready'
  // «كابتن ينتظر عند المطعم»: captain.waiting_threshold_min at the
  // restaurant before pickup (RA §8.9).
  | 'captain_waiting';

// An order as the operations board shows it (AP §9.2.1) and the detail's
// header (AP §9.3.1).
export interface OperationsOrder {
  order: OrderView;
  restaurantName: string;
  captainTrack: CaptainTrack | null;
  captain: { id: string; name: string; vehicle: string } | null;
  // When the order entered its status, and the limit of its column: the
  // time in the current state and its SLA colour (AP §9.2.1).
  statusSince: Date;
  limitAt: Date | null;
  moments: {
    acceptAlertAt: Date | null;
    prepLateAlertAt: Date | null;
    searchStartedAt: Date | null;
    searchAlertAt: Date | null;
    noCaptainAlertAt: Date | null;
    captainArrivedAt: Date | null;
    captainWaitingAlertAt: Date | null;
  };
  alerts: OperationsAlert[];
  // The badges built so far: «بحاجة لتعيين», «ملاحظة», «زبون جديد».
  needsAssignment: boolean;
  newCustomer: boolean;
}

// One event of the order's timeline (AP §9.3.1).
export interface TimelineEvent {
  version: number;
  at: Date;
  // Null for an event written before slice 1.11.
  type: string | null;
  from: OrderView['status'] | null;
  to: OrderView['status'];
  actor: { type: string; id: string | null };
  captainId: string | null;
  reason: string | null;
}

// Operations' reads of the orders (AP §9.2, §9.3.1).
@Injectable()
export class OperationsViews {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly merchants: MerchantsService,
    private readonly captains: CaptainsService,
  ) {}

  // The board: every live order of the city, from placed to arrived, oldest
  // first (AP §9.2.1).
  async board(cityId: string, now: Date): Promise<OperationsOrder[]> {
    const views = await readOrders(
      this.database.db,
      and(eq(orders.cityId, cityId), inArray(orders.status, UNTIL_ENDED)),
    );
    return this.operations(views, now);
  }

  // One order of any state, or null.
  async order(orderId: string, now: Date): Promise<OperationsOrder | null> {
    const [placed] = await this.database.db
      .select({ placedAt: orders.placedAt })
      .from(orders)
      .where(eq(orders.id, orderId));
    if (!placed) return null;
    const [view] = await readOrders(this.database.db, orderKey(orderId, placed.placedAt));
    if (!view) return null;
    const [order] = await this.operations([view], now);
    return order ?? null;
  }

  // AP §9.3.1: every event of the order with its time and actor, oldest
  // first.
  async timeline(order: OrderView): Promise<TimelineEvent[]> {
    const rows = await this.database.db
      .select()
      .from(orderEvents)
      .where(and(eq(orderEvents.orderId, order.id), eq(orderEvents.orderPlacedAt, order.placedAt)))
      .orderBy(asc(orderEvents.version));
    return rows.map((row) => ({
      version: row.version,
      at: row.at,
      type: row.type,
      from: row.fromStatus,
      to: row.toStatus,
      actor: { type: row.actorType, id: row.actorId },
      captainId: row.captainId,
      reason: row.reason,
    }));
  }

  private async operations(views: OrderView[], now: Date): Promise<OperationsOrder[]> {
    if (views.length === 0) return [];
    const ids = views.map((view) => view.id);
    const extras = await this.database.db
      .select({
        id: orders.id,
        captainTrack: orders.captainTrack,
        captainId: orders.captainId,
        prepLateAlertAt: orders.prepLateAlertAt,
        searchStartedAt: orders.searchStartedAt,
        searchAlertAt: orders.searchAlertAt,
        noCaptainAlertAt: orders.noCaptainAlertAt,
      })
      .from(orders)
      .where(
        and(
          inArray(orders.id, ids),
          inArray(
            orders.placedAt,
            views.map((view) => view.placedAt),
          ),
        ),
      );
    const extra = new Map(extras.map((row) => [row.id, row]));
    const customerIds = [...new Set(views.map((view) => view.customerAccountId))];
    const delivered = await this.database.db
      .select({ customerAccountId: orders.customerAccountId, n: count() })
      .from(orders)
      .where(and(inArray(orders.customerAccountId, customerIds), eq(orders.status, 'delivered')))
      .groupBy(orders.customerAccountId);
    const regulars = new Set(delivered.map((row) => row.customerAccountId));
    const names = await this.merchants.names([...new Set(views.map((view) => view.restaurantId))]);
    const captainIds = [...new Set(extras.flatMap((row) => row.captainId ?? []))];
    const captains = new Map(
      (await Promise.all(captainIds.map((id) => this.captains.captain(id, now)))).flatMap(
        (captain) => (captain ? [[captain.id, captain] as const] : []),
      ),
    );
    return views.map((view) => {
      const more = extra.get(view.id)!;
      const captain = more.captainId === null ? undefined : captains.get(more.captainId);
      const prepDue = view.acceptance
        ? new Date(view.acceptance.at.getTime() + view.acceptance.prepMin * 60_000)
        : null;
      const passed = (moment: Date | null) => moment !== null && moment <= now;
      const waiting = view.status === 'accepted' || view.status === 'ready';
      const alerts: OperationsAlert[] = [];
      if (view.status === 'placed' && passed(view.acceptAlertAt)) {
        alerts.push('restaurant_not_accepted');
      }
      if (view.status === 'accepted' && passed(more.prepLateAlertAt)) alerts.push('prep_late');
      if (waiting && more.captainId === null && passed(more.searchAlertAt)) {
        alerts.push('no_captain');
      }
      if (view.status === 'ready' && more.captainId === null && passed(more.noCaptainAlertAt)) {
        alerts.push('no_captain_after_ready');
      }
      const atRestaurant =
        more.captainTrack === 'at_merchant' || more.captainTrack === 'pickup_pending';
      if (waiting && atRestaurant && passed(view.captainArrival?.waitingAlertAt ?? null)) {
        alerts.push('captain_waiting');
      }
      return {
        order: view,
        restaurantName: names.get(view.restaurantId)?.nameAr ?? '',
        captainTrack: more.captainTrack,
        captain: captain ? { id: captain.id, name: captain.name, vehicle: captain.vehicle } : null,
        statusSince:
          view.status === 'accepted' && view.acceptance
            ? view.acceptance.at
            : view.status === 'ready' && view.readyAt
              ? view.readyAt
              : view.status === 'cancelled' && view.cancellation
                ? view.cancellation.at
                : view.placedAt,
        // AP §9.2.1: the acceptance alert, the prep time, the no-captain-after-
        // ready limit; the promised time and the no-answer window with their
        // slices.
        limitAt:
          view.status === 'placed'
            ? view.acceptAlertAt
            : view.status === 'accepted'
              ? prepDue
              : view.status === 'ready'
                ? more.noCaptainAlertAt
                : null,
        moments: {
          acceptAlertAt: view.acceptAlertAt,
          prepLateAlertAt: more.prepLateAlertAt,
          searchStartedAt: more.searchStartedAt,
          searchAlertAt: more.searchAlertAt,
          noCaptainAlertAt: more.noCaptainAlertAt,
          captainArrivedAt: view.captainArrival?.at ?? null,
          captainWaitingAlertAt: view.captainArrival?.waitingAlertAt ?? null,
        },
        alerts,
        needsAssignment: more.captainTrack === 'searching',
        newCustomer: !regulars.has(view.customerAccountId),
      };
    });
  }
}
