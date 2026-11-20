import { Inject, Injectable } from '@nestjs/common';
import { and, eq, gte, inArray, isNull, lt, sql } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import {
  emergencyStopAttempts,
  emergencyStops,
  handovers,
  orderLines,
  orders,
  orderStatuses,
  ratings,
  reassignments,
} from './schema.js';

type Actor = 'customer' | 'restaurant' | 'captain' | 'admin' | 'system';

// One order of a report's period (AP §9.17, RA §11), placed in it.
export interface ReportOrder {
  id: string;
  restaurantId: string;
  zoneId: string;
  captainId: string | null;
  customerAccountId: string;
  status: (typeof orderStatuses)[number];
  // The outcome in force (AP §8.9); null before the order ends after pickup.
  outcome: string | null;
  currency: string;
  itemsValue: bigint;
  placedAt: Date;
  acceptedAt: Date | null;
  // Who answered: `restaurant` or `admin` (on its behalf, RA §8.15).
  acceptedBy: Actor | null;
  // The prep time chosen (after any change), in minutes.
  prepMin: number | null;
  readyAt: Date | null;
  // «لم يُضغط جاهز»: ready was recorded at the pickup.
  readyByPickup: boolean;
  searchStartedAt: Date | null;
  assignedAt: Date | null;
  arrivedAtMerchantAt: Date | null;
  pickedUpAt: Date | null;
  deliveredAt: Date | null;
  promisedAt: Date | null;
  rejectedBy: Actor | null;
  rejectReason: string | null;
  rejectReasonLabel: string | null;
  // The cancellation's code, its label (operations' as chosen; null for the
  // others), who cancelled and from which status, and the party operations
  // named responsible.
  cancelReason: string | null;
  cancelReasonLabel: string | null;
  cancelledBy: Actor | null;
  cancelledFrom: (typeof orderStatuses)[number] | null;
  cancelResponsible: string | null;
  // No earlier order of the customer's account, test orders left out.
  firstOrder: boolean;
}

// The scope of a report: a city's orders or one restaurant's.
export type ReportScope = { cityId: string } | { restaurantId: string };

// One item of the delivered orders' lines (RA §11 «Top items»).
export interface ReportItem {
  itemId: string;
  name: string;
  // The sales' currency (the orders').
  currency: string;
  quantity: number;
  sales: bigint;
}

const instant = (value: Date | string | null) => (value === null ? null : new Date(value));

// AP §9.17, RA §11: the orders a report counts, placed in its period, test
// orders and free re-deliveries left out (AP §9.6.3, RA §11 «Exclusions»).
// It reads every partition the period touches, by the city or the
// restaurant (fine for Azaz).
@Injectable()
export class ReportOrdersService {
  constructor(@Inject(DATABASE) private readonly database: Database) {}

  private where(scope: ReportScope, from: Date, to: Date) {
    return and(
      'cityId' in scope
        ? eq(orders.cityId, scope.cityId)
        : eq(orders.restaurantId, scope.restaurantId),
      eq(orders.testOrder, false),
      isNull(orders.redeliveryOfId),
      gte(orders.placedAt, from),
      lt(orders.placedAt, to),
    );
  }

  async placedBetween(scope: ReportScope, from: Date, to: Date): Promise<ReportOrder[]> {
    // The event that moved the order into a status, written out: the outer
    // row named in full, so the subquery's alias never captures it.
    const actorInto = (status: string, extra = '') =>
      sql<Actor | null>`(SELECT event.actor_type FROM ordering.order_events event WHERE event.order_id = ordering.orders.id AND event.order_placed_at = ordering.orders.placed_at AND event.to_status = ${status} AND event.from_status IS DISTINCT FROM ${status} ${sql.raw(extra)} ORDER BY event.version LIMIT 1)`;
    const rows = await this.database.db
      .select({
        id: orders.id,
        restaurantId: orders.restaurantId,
        zoneId: orders.zoneId,
        captainId: orders.captainId,
        customerAccountId: orders.customerAccountId,
        status: orders.status,
        outcome: orders.outcome,
        currency: orders.currency,
        itemsValue: orders.itemsValue,
        placedAt: orders.placedAt,
        acceptedAt: orders.acceptedAt,
        acceptedBy: actorInto('accepted', "AND event.from_status = 'placed'"),
        prepMin: orders.prepMin,
        readyAt: orders.readyAt,
        readyByPickup: orders.readyByPickup,
        searchStartedAt: orders.searchStartedAt,
        assignedAt: orders.assignedAt,
        arrivedAtMerchantAt: orders.arrivedAtMerchantAt,
        pickedUpAt: orders.pickedUpAt,
        deliveredAt: orders.deliveredAt,
        promisedAt: orders.promisedAt,
        rejectedBy: actorInto('rejected'),
        rejectReason: orders.rejectReason,
        rejectReasonLabel: orders.rejectReasonLabel,
        cancelReason: orders.cancelReason,
        cancelReasonLabel: orders.cancelReasonLabel,
        cancelledBy: actorInto('cancelled'),
        cancelledFrom: sql<
          (typeof orderStatuses)[number] | null
        >`(SELECT event.from_status FROM ordering.order_events event WHERE event.order_id = ordering.orders.id AND event.order_placed_at = ordering.orders.placed_at AND event.to_status = 'cancelled' AND event.from_status <> 'cancelled' ORDER BY event.version LIMIT 1)`,
        cancelResponsible: orders.cancelResponsible,
        firstOrder: sql<boolean>`NOT EXISTS (SELECT 1 FROM ordering.orders earlier WHERE earlier.customer_account_id = ordering.orders.customer_account_id AND earlier.placed_at < ordering.orders.placed_at AND earlier.test_order = false)`,
      })
      .from(orders)
      .where(this.where(scope, from, to))
      .orderBy(orders.placedAt);
    return rows.map((row) => ({
      ...row,
      readyByPickup: row.readyByPickup === true,
      firstOrder: Boolean(row.firstOrder),
      // Raw subqueries come back as text.
      acceptedAt: instant(row.acceptedAt),
    }));
  }

  // RA §11 «Top items»: the items of the delivered orders placed in the
  // period, by quantity, with their sales (the lines in force after edits).
  async deliveredItems(restaurantId: string, from: Date, to: Date): Promise<ReportItem[]> {
    const rows = await this.database.db
      .select({
        itemId: orderLines.itemId,
        currency: orders.currency,
        name: sql<string>`(array_agg(${orderLines.itemName} ORDER BY ${orderLines.orderPlacedAt} DESC))[1]`,
        quantity: sql<number>`sum(${orderLines.quantity})::int`,
        sales: sql<string>`sum(${orderLines.lineTotal})::text`,
      })
      .from(orderLines)
      .innerJoin(
        orders,
        and(eq(orders.id, orderLines.orderId), eq(orders.placedAt, orderLines.orderPlacedAt)),
      )
      .where(
        and(
          this.where({ restaurantId }, from, to),
          eq(orders.status, 'delivered'),
          isNull(orderLines.removedByEdit),
          gte(orderLines.orderPlacedAt, from),
          lt(orderLines.orderPlacedAt, to),
        ),
      )
      .groupBy(orderLines.itemId, orders.currency);
    return rows.map((row) => ({ ...row, sales: BigInt(row.sales) }));
  }

  // AP §9.17 «Captains», AP §9.7.6: each captain's cancellations by fault
  // between two moments, as `CaptainFiguresService` counts them (a
  // withdrawal «بخطأ من الكابتن», a handover received with the fault).
  async captainFaults(captainIds: string[], from: Date, to: Date): Promise<Map<string, number>> {
    if (captainIds.length === 0) return new Map();
    const ids = sql.join(
      captainIds.map((id) => sql`${id}::uuid`),
      sql`, `,
    );
    const { rows } = await this.database.db.execute<{ captain_id: string; count: number }>(sql`
      SELECT captain_id, count(*)::int AS count FROM (
        SELECT ${reassignments.captainId} AS captain_id FROM ${reassignments}
         WHERE ${reassignments.captainId} IN (${ids}) AND ${reassignments.captainFault}
           AND ${reassignments.at} >= ${from.toISOString()} AND ${reassignments.at} < ${to.toISOString()}
        UNION ALL
        SELECT ${handovers.fromCaptainId} FROM ${handovers}
         WHERE ${handovers.fromCaptainId} IN (${ids}) AND ${handovers.captainFault} IS TRUE
           AND ${handovers.receivedAt} >= ${from.toISOString()} AND ${handovers.receivedAt} < ${to.toISOString()}
      ) AS faults
      GROUP BY captain_id`);
    return new Map(rows.map((row) => [row.captain_id, Number(row.count)]));
  }

  // AP §9.17 «Lost demand»: the city's emergency stops started between two
  // moments and the customers who opened checkout during them (CU §10.6).
  async emergencyAttempts(
    cityId: string,
    from: Date,
    to: Date,
  ): Promise<{ stops: number; attempts: number }> {
    const [row] = await this.database.db
      .select({
        stops: sql<number>`count(DISTINCT ${emergencyStops.id})::int`,
        attempts: sql<number>`count(${emergencyStopAttempts.customerAccountId})::int`,
      })
      .from(emergencyStops)
      .leftJoin(emergencyStopAttempts, eq(emergencyStopAttempts.stopId, emergencyStops.id))
      .where(
        and(
          eq(emergencyStops.cityId, cityId),
          gte(emergencyStops.startedAt, from),
          lt(emergencyStops.startedAt, to),
        ),
      );
    return { stops: Number(row?.stops ?? 0), attempts: Number(row?.attempts ?? 0) };
  }

  // The ratings sent in a period (RA §11 «Rating», AP §9.17), test orders
  // left out: per restaurant or per captain.
  async ratingsBetween(
    party: 'restaurant' | 'captain',
    ids: string[],
    from: Date,
    to: Date,
  ): Promise<Map<string, { count: number; total: number }>> {
    const result = new Map<string, { count: number; total: number }>();
    if (ids.length === 0) return result;
    const target = party === 'restaurant' ? ratings.restaurantId : ratings.captainId;
    const rows = await this.database.db
      .select({
        id: sql<string>`${target}`,
        count: sql<number>`count(*)::int`,
        total: sql<number>`sum(${ratings.stars})::int`,
      })
      .from(ratings)
      .where(
        and(
          eq(ratings.party, party),
          inArray(target, ids),
          eq(ratings.testOrder, false),
          gte(ratings.at, from),
          lt(ratings.at, to),
        ),
      )
      .groupBy(target);
    for (const row of rows) result.set(row.id, { count: row.count, total: row.total });
    return result;
  }
}
