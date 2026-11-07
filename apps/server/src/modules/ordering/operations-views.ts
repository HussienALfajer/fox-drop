import { Inject, Injectable } from '@nestjs/common';
import { and, asc, count, desc, eq, gt, inArray } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { CaptainsService } from '../captains/index.js';
import { MerchantsService } from '../merchants/index.js';
import { SettingsService } from '../settings/index.js';
import { UNTIL_ENDED } from './active-orders.js';
import { orderAlerts, type OrderAlertCode } from './order-alerts.js';
import type { CaptainTrack } from './order-events.js';
import { orderKey, readOrders, type OrderView } from './order-views.js';
import {
  type PickupDisputeView,
  pickupDisputesOf,
  type PickupRequestView,
  pickupRequestsOf,
} from './pickup-views.js';
import { collections, orderEvents, orders } from './schema.js';

// AP §9.1.3: the alerts the board shows on a card, the same conditions as
// the alerts list (order-alerts.ts).
export type OperationsAlert = OrderAlertCode;

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
  // The badges built so far: «بحاجة لتعيين», «ملاحظة», «زبون جديد»,
  // «بانتظار تأكيد الاستلام» (AP §9.2.1).
  needsAssignment: boolean;
  pickupPending: boolean;
  // AP §9.3.1: every pickup request, newest first.
  pickupRequests: PickupRequestView[];
  // RA §8.10 item 8: the restaurant's dispute after the pickup.
  pickupDispute: PickupDisputeView | null;
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
export interface Shortfall {
  orderId: string;
  number: bigint;
  captainId: string;
  currency: string;
  amountDue: bigint;
  netReceived: bigint;
  amount: bigint;
  reason: string;
  // Null only on a row a version before Content wrote.
  label: string | null;
  note: string | null;
  recordedAt: Date;
}

@Injectable()
export class OperationsViews {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly merchants: MerchantsService,
    private readonly captains: CaptainsService,
    private readonly settings: SettingsService,
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
  // AP §8.6, CA §9.7 item 4: «نقص في التحصيل», the orders of the city
  // delivered short of their total beyond rounding, newest first. Operations
  // resolve them with the responsible party (not built yet), so every one is
  // still open.
  async shortfalls(cityId: string): Promise<Shortfall[]> {
    return this.database.db
      .select({
        orderId: collections.orderId,
        number: orders.number,
        captainId: collections.captainId,
        currency: collections.currency,
        amountDue: collections.amountDue,
        netReceived: collections.netReceived,
        amount: collections.shortfall,
        reason: collections.shortfallReason,
        label: collections.shortfallReasonLabel,
        note: collections.shortfallNote,
        recordedAt: collections.recordedAt,
      })
      .from(collections)
      .innerJoin(
        orders,
        and(eq(orders.id, collections.orderId), eq(orders.placedAt, collections.orderPlacedAt)),
      )
      .where(and(eq(collections.cityId, cityId), gt(collections.shortfall, 0n)))
      .orderBy(desc(collections.recordedAt)) as Promise<Shortfall[]>;
  }

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
        promisedAt: orders.promisedAt,
        assignedAt: orders.assignedAt,
        cityId: orders.cityId,
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
    const [requests, disputes] = await Promise.all([
      pickupRequestsOf(this.database.db, views),
      pickupDisputesOf(this.database.db, views),
    ]);
    const names = await this.merchants.names([...new Set(views.map((view) => view.restaurantId))]);
    const captainIds = [...new Set(extras.flatMap((row) => row.captainId ?? []))];
    const cityIds = [...new Set(extras.map((row) => row.cityId))];
    const [rules, fixes, shortfalls] = await Promise.all([
      Promise.all(
        cityIds.map(async (cityId) => {
          const [lateMin, gpsStaleMin] = await Promise.all([
            this.settings.get('order.delivery_late_alert_min', { cityId }),
            this.settings.get('captain.gps_stale_alert_min', { cityId }),
          ]);
          return [cityId, { lateMin, gpsStaleMin }] as const;
        }),
      ).then((entries) => new Map(entries)),
      this.captains.lastFixes(captainIds, new Date(now.getTime() - 60 * 60_000)),
      this.database.db
        .select({ orderId: collections.orderId })
        .from(collections)
        .where(and(inArray(collections.orderId, ids), gt(collections.shortfall, 0n)))
        .then((rows) => new Set(rows.map((row) => row.orderId))),
    ]);
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
      const rule = rules.get(more.cityId)!;
      const { open } = orderAlerts(
        {
          status: view.status,
          captainId: more.captainId,
          captainTrack: more.captainTrack,
          acceptAlertAt: view.acceptAlertAt,
          prepLateAlertAt: more.prepLateAlertAt,
          searchAlertAt: more.searchAlertAt,
          noCaptainAlertAt: more.noCaptainAlertAt,
          captainWaitingAlertAt: view.captainArrival?.waitingAlertAt ?? null,
          deliveryLateAt:
            more.promisedAt && new Date(more.promisedAt.getTime() + rule.lateMin * 60_000),
          assignedAt: more.assignedAt,
          lastFixAt: more.captainId === null ? null : (fixes.get(more.captainId) ?? null),
          gpsStaleMin: rule.gpsStaleMin,
          amountDisputed: (requests.get(view.id) ?? []).some(
            (request) => request.outcome === 'amount_incorrect',
          ),
          away: view.away !== null,
          shortfall: shortfalls.has(view.id),
        },
        now,
      );
      // The card shows «تسليم بعيد عن العنوان» while the order is active;
      // the alerts list keeps it until someone takes it.
      const alerts = UNTIL_ENDED.includes(view.status)
        ? open
        : open.filter((code) => code !== 'away_from_address');
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
              : view.status === 'picked_up' && view.pickup
                ? view.pickup.at
                : view.status === 'arrived' && view.customerArrival
                  ? view.customerArrival.at
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
        pickupPending: more.captainTrack === 'pickup_pending',
        pickupRequests: requests.get(view.id) ?? [],
        pickupDispute: disputes.get(view.id) ?? null,
        newCustomer: !regulars.has(view.customerAccountId),
      };
    });
  }
}
