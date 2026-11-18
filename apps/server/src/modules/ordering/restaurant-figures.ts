import { Inject, Injectable } from '@nestjs/common';
import { and, eq, gte, inArray, isNull, sql } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { GeoService } from '../geo/index.js';
import { SettingsService } from '../settings/index.js';
import { periodBounds } from './rating-pages.js';
import { RatingsService } from './ratings.js';
import { orders } from './schema.js';

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
    const [rows, lasts, ratings] = await Promise.all([
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
        rating: ratings.get(id) ?? null,
      });
    }
    return figures;
  }
}
