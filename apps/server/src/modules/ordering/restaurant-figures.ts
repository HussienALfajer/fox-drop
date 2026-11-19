import { Inject, Injectable } from '@nestjs/common';
import { and, desc, eq, gte, inArray, isNull, sql } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { GeoService } from '../geo/index.js';
import { MerchantsService } from '../merchants/index.js';
import { SettingsService } from '../settings/index.js';
import { periodBounds } from './rating-pages.js';
import { RatingsService } from './ratings.js';
import { orders, ratings } from './schema.js';

// AP §9.6.2 «المطاعم» (slice 2.30c): one restaurant's figures in the list.
export interface RestaurantFigures {
  // Placed since today's business-day cutoff on the city's clock.
  ordersToday: number;
  // Of the orders placed in the last 7 business days (today included) that
  // the restaurant answered or let time out: the share it accepted, in
  // basis points; null without one.
  acceptanceBp7d: number | null;
  lastOrderAt: Date | null;
  rating: { count: number; average: number } | null;
}

// AP §9.6.4 «نظرة عامة» (slice 2.30d): the overview's periods, in business
// days on the city's clock, today included in the 7 and the 30.
export const overviewPeriods = ['today', 'last_7_days', 'last_30_days'] as const;
export type OverviewPeriod = (typeof overviewPeriods)[number];

export interface RestaurantOverview {
  from: Date;
  // Placed in the period.
  orders: number;
  // The items value of the orders delivered, per currency.
  sales: { currency: string; amount: bigint }[];
  // Of the orders answered or timed out (as the list's): accepted, rejected,
  // in basis points; null without one.
  acceptanceBp: number | null;
  rejectionBp: number | null;
  // The rejections by the reason's label as chosen, most first.
  rejectionReasons: { label: string; count: number }[];
  // Cancelled because the restaurant never answered (merchant_auto_cancel).
  unanswered: number;
  // Of the orders marked ready: the minutes from acceptance to ready, the
  // prep time chosen (after any change), both averaged to one decimal, and
  // the share ready after the time chosen; null without one.
  prepActualMin: number | null;
  prepChosenMin: number | null;
  lateBp: number | null;
  // The ratings sent in the period.
  rating: { count: number; average: number } | null;
}

// AP §9.6.2: what the restaurant list shows of each restaurant's orders and
// ratings, test orders and free re-deliveries left out (AP §9.6.3: test
// orders stay out of the KPIs). Acceptance counts an order accepted (by the
// restaurant or on its behalf) against those accepted, rejected or
// cancelled because the restaurant never answered (merchant_auto_cancel);
// a cancellation before any answer by the customer or operations is no
// answer of the restaurant's (decided by us). The counts read the last 7
// business days; the last order reads every month's partition, by the
// restaurants asked.
@Injectable()
export class RestaurantFiguresService {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly geo: GeoService,
    private readonly settings: SettingsService,
    private readonly ratings: RatingsService,
    private readonly merchants: MerchantsService,
  ) {}

  async ofCity(cityId: string, restaurantIds: string[], now: Date) {
    const figures = new Map<string, RestaurantFigures>();
    if (restaurantIds.length === 0) return figures;
    const [timeZone, cutoff] = await Promise.all([
      this.geo.cityTimeZone(cityId),
      this.settings.get('finance.business_day_cutoff', { cityId }),
    ]);
    if (timeZone === null) throw new Error('the city has no clock');
    const [hours, minutes] = cutoff.split(':').map(Number) as [number, number];
    const cutoffMinutes = hours * 60 + minutes;
    const today = periodBounds('today', now, cutoffMinutes, timeZone).from!;
    const week = periodBounds('last_7_days', now, cutoffMinutes, timeZone).from!;
    const counted = and(
      eq(orders.cityId, cityId),
      inArray(orders.restaurantId, restaurantIds),
      eq(orders.testOrder, false),
      isNull(orders.redeliveryOfId),
    );
    const [rows, lasts, summaries] = await Promise.all([
      // The last 7 business days only, so the month partitions prune.
      this.database.db
        .select({
          restaurantId: orders.restaurantId,
          today: sql<number>`count(*) FILTER (WHERE ${orders.placedAt} >= ${today})::int`,
          accepted: sql<number>`count(*) FILTER (WHERE ${orders.acceptedAt} IS NOT NULL)::int`,
          answered: sql<number>`count(*) FILTER (WHERE ${orders.acceptedAt} IS NOT NULL OR ${orders.status} = 'rejected' OR ${orders.cancelReason} = 'merchant_auto_cancel')::int`,
        })
        .from(orders)
        .where(and(counted, gte(orders.placedAt, week)))
        .groupBy(orders.restaurantId),
      // The last order, whenever it was: every partition, by the restaurant.
      this.database.db
        .select({
          restaurantId: orders.restaurantId,
          last: sql<Date>`max(${orders.placedAt})`.mapWith((value) => new Date(value)),
        })
        .from(orders)
        .where(counted)
        .groupBy(orders.restaurantId),
      this.ratings.restaurantSummaries(restaurantIds),
    ]);
    const lastOf = new Map(lasts.map((row) => [row.restaurantId, row.last]));
    const byRestaurant = new Map(rows.map((row) => [row.restaurantId, row]));
    for (const id of restaurantIds) {
      const row = byRestaurant.get(id);
      const answered = Number(row?.answered ?? 0);
      figures.set(id, {
        ordersToday: Number(row?.today ?? 0),
        acceptanceBp7d:
          answered === 0 ? null : Math.round((Number(row!.accepted) * 10_000) / answered),
        lastOrderAt: lastOf.get(id) ?? null,
        rating: summaries.get(id) ?? null,
      });
    }
    return figures;
  }

  // AP §9.6.4 «نظرة عامة» (slice 2.30d): one restaurant's figures over a
  // period, test orders and free re-deliveries left out as in the list. The
  // late rate counts an order ready after its prep time (acceptance plus
  // prep_min, a time change included); «لم يُضغط جاهز» counts its pickup
  // (decided by us). Null for an unknown restaurant.
  async overview(
    restaurantId: string,
    period: OverviewPeriod,
    now: Date,
  ): Promise<RestaurantOverview | null> {
    const cityId = (await this.merchants.cityAndStatus(restaurantId))?.cityId;
    if (cityId === undefined) return null;
    const [timeZone, cutoff] = await Promise.all([
      this.geo.cityTimeZone(cityId),
      this.settings.get('finance.business_day_cutoff', { cityId }),
    ]);
    if (timeZone === null) throw new Error('the city has no clock');
    const [hours, minutes] = cutoff.split(':').map(Number) as [number, number];
    const from = periodBounds(period, now, hours * 60 + minutes, timeZone).from!;
    const counted = and(
      eq(orders.restaurantId, restaurantId),
      eq(orders.testOrder, false),
      isNull(orders.redeliveryOfId),
      gte(orders.placedAt, from),
    );
    const answered = sql`(${orders.acceptedAt} IS NOT NULL OR ${orders.status} = 'rejected' OR ${orders.cancelReason} = 'merchant_auto_cancel')`;
    const prepEnd = sql`${orders.acceptedAt} + make_interval(mins => ${orders.prepMin})`;
    const [[totals], sales, reasons, [rated]] = await Promise.all([
      this.database.db
        .select({
          orders: sql<number>`count(*)::int`,
          accepted: sql<number>`count(*) FILTER (WHERE ${orders.acceptedAt} IS NOT NULL)::int`,
          rejected: sql<number>`count(*) FILTER (WHERE ${orders.status} = 'rejected')::int`,
          answered: sql<number>`count(*) FILTER (WHERE ${answered})::int`,
          unanswered: sql<number>`count(*) FILTER (WHERE ${orders.cancelReason} = 'merchant_auto_cancel')::int`,
          ready: sql<number>`count(*) FILTER (WHERE ${orders.readyAt} IS NOT NULL AND ${orders.acceptedAt} IS NOT NULL)::int`,
          late: sql<number>`count(*) FILTER (WHERE ${orders.readyAt} > ${prepEnd})::int`,
          actual: sql<number | null>`avg(extract(epoch FROM ${orders.readyAt} - ${orders.acceptedAt}) / 60) FILTER (WHERE ${orders.readyAt} IS NOT NULL AND ${orders.acceptedAt} IS NOT NULL)::float8`,
          chosen: sql<number | null>`avg(${orders.prepMin}) FILTER (WHERE ${orders.readyAt} IS NOT NULL AND ${orders.acceptedAt} IS NOT NULL)::float8`,
        })
        .from(orders)
        .where(counted),
      this.database.db
        .select({
          currency: orders.currency,
          amount: sql<string>`sum(${orders.itemsValue})::text`,
        })
        .from(orders)
        .where(and(counted, eq(orders.status, 'delivered')))
        .groupBy(orders.currency)
        .orderBy(orders.currency),
      this.database.db
        .select({ label: orders.rejectReasonLabel, count: sql<number>`count(*)::int` })
        .from(orders)
        .where(and(counted, eq(orders.status, 'rejected')))
        .groupBy(orders.rejectReasonLabel)
        .orderBy(sql`count(*) DESC`, orders.rejectReasonLabel),
      this.database.db
        .select({
          count: sql<number>`count(*)::int`,
          average: sql<number | null>`avg(${ratings.stars})::float8`,
        })
        .from(ratings)
        .where(
          and(
            eq(ratings.party, 'restaurant'),
            eq(ratings.restaurantId, restaurantId),
            eq(ratings.testOrder, false),
            gte(ratings.at, from),
          ),
        ),
    ]);
    const share = (part: number, whole: number) =>
      whole === 0 ? null : Math.round((part * 10_000) / whole);
    const tenth = (value: number | null) => (value === null ? null : Math.round(value * 10) / 10);
    const t = totals!;
    return {
      from,
      orders: t.orders,
      sales: sales.map((row) => ({ currency: row.currency, amount: BigInt(row.amount) })),
      acceptanceBp: share(t.accepted, t.answered),
      rejectionBp: share(t.rejected, t.answered),
      rejectionReasons: reasons.map((row) => ({ label: row.label ?? '', count: row.count })),
      unanswered: t.unanswered,
      prepActualMin: tenth(t.actual),
      prepChosenMin: tenth(t.chosen),
      lateBp: share(t.late, t.ready),
      rating:
        rated && rated.count > 0 && rated.average !== null
          ? { count: rated.count, average: rated.average }
          : null,
    };
  }

  // AP §9.6.4 «الطلبات» (slice 2.30d): the restaurant's latest orders, test
  // orders and free re-deliveries included and marked; the panel's order
  // history with its filters joins with 2.40. Reads every month's partition.
  async latestOrders(restaurantId: string, limit: number) {
    return this.database.db
      .select({
        id: orders.id,
        number: orders.number,
        placedAt: orders.placedAt,
        status: orders.status,
        currency: orders.currency,
        total: orders.total,
        testOrder: orders.testOrder,
        redelivery: sql<boolean>`${orders.redeliveryOfId} IS NOT NULL`,
      })
      .from(orders)
      .where(eq(orders.restaurantId, restaurantId))
      .orderBy(desc(orders.placedAt), desc(orders.id))
      .limit(limit);
  }
}
