import { Inject, Injectable } from '@nestjs/common';
import { and, desc, eq, gte, inArray, lt, lte, sql, type SQL } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { GeoService, lastCutoff } from '../geo/index.js';
import { SettingsService } from '../settings/index.js';
import { orders, ratings } from './schema.js';

// CU §12.1 «Who sees what»: the restaurant's owners read its ratings without
// the customer or the order (RA §13, slice 2.26b); the captain reads their
// average and reasons, never a comment (CA §11.2, slice 2.26c); the panel
// reads a restaurant's and a captain's ratings with the comments and the
// order, never the customer's name (AP §9.6.4, §9.7.4, slice 2.26c). Test
// orders never show nor count (owner decisions 2026-11-17 and 2026-11-18).

// The reports' periods (RA §11; owner decision 2026-11-17), and «الكل».
export const ratingPeriods = ['all', 'today', 'yesterday', 'last_7_days', 'last_30_days'] as const;
export type RatingPeriod = (typeof ratingPeriods)[number];

export const RATINGS_PAGE = 20;

const DAYS: Partial<Record<RatingPeriod, number>> = { last_7_days: 7, last_30_days: 30 };

// A period's moments in business days on the city's clock: from a day's
// cutoff, to the next cutoff for «أمس» and to now otherwise (null for no
// bound). Each cutoff is found from the one after it, so a daylight saving
// change in between is counted.
export function periodBounds(
  period: RatingPeriod,
  now: Date,
  cutoffMinutes: number,
  timeZone: string,
): { from: Date | null; to: Date | null } {
  if (period === 'all') return { from: null, to: null };
  const before = (cutoff: Date) =>
    lastCutoff(new Date(cutoff.getTime() - 1), cutoffMinutes, timeZone);
  const today = lastCutoff(now, cutoffMinutes, timeZone);
  if (period === 'today') return { from: today, to: null };
  if (period === 'yesterday') return { from: before(today), to: today };
  let from = today;
  for (let day = 1; day < DAYS[period]!; day += 1) from = before(from);
  return { from, to: null };
}

// Whose ratings: a restaurant's or a captain's, read on its city's clock.
export type RatingTarget =
  | { party: 'restaurant'; id: string; cityId: string }
  | { party: 'captain'; id: string; cityId: string };

export interface RatingRow {
  orderId: string;
  orderNumber: string;
  stars: number;
  reasons: { code: string; label: string }[];
  comment: string | null;
  at: Date;
  // The business day it was sent, YYYY-MM-DD on the city's clock.
  day: string;
}

export interface RatingPage {
  // The moment the first page was read: the next pages read up to it, so
  // they neither repeat nor miss a rating, and keep its period.
  asOf: Date;
  count: number;
  average: number | null;
  // From 5 stars down to 1.
  distribution: { stars: number; count: number }[];
  ratings: RatingRow[];
  // Whether a page follows.
  more: boolean;
}

// CA §11.2 (C14): the captain's figures, every rating (owner decision
// 2026-11-18), with the reasons picked and their counts, most picked first.
export interface CaptainRatingSummary {
  count: number;
  average: number | null;
  reasons: { code: string; label: string; count: number }[];
}

const averageOf = (total: number, count: number) =>
  count === 0 ? null : Math.round((total / count) * 10) / 10;

function partyOf(target: RatingTarget): SQL[] {
  return target.party === 'restaurant'
    ? [eq(ratings.party, 'restaurant'), eq(ratings.restaurantId, target.id)]
    : [eq(ratings.party, 'captain'), eq(ratings.captainId, target.id)];
}

// The calendar day of an instant on the city's clock, YYYY-MM-DD.
function dayOf(instant: Date, timeZone: string): string {
  return new Intl.DateTimeFormat('en-CA', {
    timeZone,
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
  }).format(instant);
}

@Injectable()
export class RatingPagesService {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly geo: GeoService,
    private readonly settings: SettingsService,
  ) {}

  // The period's count, average and distribution, whatever the stars
  // chosen, and a page of its ratings with those stars, newest first, all
  // as of `asOf` (now on the first page; never after now).
  async read(
    target: RatingTarget,
    query: { period: RatingPeriod; stars: number | null; page: number; asOf: Date | null },
    now: Date,
  ): Promise<RatingPage> {
    const asOf = query.asOf === null || query.asOf.getTime() > now.getTime() ? now : query.asOf;
    const [timeZone, cutoff] = await Promise.all([
      this.geo.cityTimeZone(target.cityId),
      this.settings.get('finance.business_day_cutoff', { cityId: target.cityId }),
    ]);
    if (timeZone === null) throw new Error('the city has no clock');
    const [hours, minutes] = cutoff.split(':').map(Number) as [number, number];
    const cutoffMinutes = hours * 60 + minutes;
    const { from, to } = periodBounds(query.period, asOf, cutoffMinutes, timeZone);
    const inPeriod: SQL[] = [
      ...partyOf(target),
      eq(ratings.testOrder, false),
      lte(ratings.at, asOf),
    ];
    if (from !== null) inPeriod.push(gte(ratings.at, from));
    if (to !== null) inPeriod.push(lt(ratings.at, to));
    const page: SQL[] = [...inPeriod];
    if (query.stars !== null) page.push(eq(ratings.stars, query.stars));
    const [byStars, rows] = await Promise.all([
      this.database.db
        .select({ stars: ratings.stars, count: sql<number>`count(*)::int` })
        .from(ratings)
        .where(and(...inPeriod))
        .groupBy(ratings.stars),
      this.database.db
        .select({
          orderId: ratings.orderId,
          orderNumber: sql<string>`${orders.number}::text`,
          stars: ratings.stars,
          reasons: sql<{ code: string; label: string }[]>`${ratings.reasons}`,
          comment: ratings.comment,
          at: ratings.at,
        })
        .from(ratings)
        .innerJoin(
          orders,
          and(eq(orders.id, ratings.orderId), eq(orders.placedAt, ratings.orderPlacedAt)),
        )
        .where(and(...page))
        .orderBy(desc(ratings.at), desc(ratings.id))
        .offset(query.page * RATINGS_PAGE)
        .limit(RATINGS_PAGE + 1),
    ]);
    const counts = new Map(byStars.map((row) => [row.stars, row.count]));
    const distribution = [5, 4, 3, 2, 1].map((stars) => ({
      stars,
      count: counts.get(stars) ?? 0,
    }));
    const count = distribution.reduce((sum, each) => sum + each.count, 0);
    const total = distribution.reduce((sum, each) => sum + each.stars * each.count, 0);
    return {
      asOf,
      count,
      average: averageOf(total, count),
      distribution,
      ratings: rows.slice(0, RATINGS_PAGE).map((rating) => ({
        ...rating,
        day: dayOf(lastCutoff(rating.at, cutoffMinutes, timeZone), timeZone),
      })),
      more: rows.length > RATINGS_PAGE,
    };
  }

  // CA §11.2: the captain's count and average, and each reason picked with
  // its count; a reason shows with its label as last chosen.
  async captainSummary(captainId: string): Promise<CaptainRatingSummary> {
    const rated = sql`${ratings.party} = 'captain' AND ${ratings.captainId} = ${captainId} AND NOT ${ratings.testOrder}`;
    const [[totals], reasons] = await Promise.all([
      this.database.db
        .select({
          count: sql<number>`count(*)::int`,
          total: sql<number>`coalesce(sum(${ratings.stars}), 0)::int`,
        })
        .from(ratings)
        .where(rated),
      this.database.db.execute<{ code: string; label: string; count: number }>(sql`
        SELECT reason ->> 'code' AS code,
               (array_agg(reason ->> 'label' ORDER BY ${ratings.at} DESC))[1] AS label,
               count(*)::int AS count
        FROM ${ratings}, jsonb_array_elements(${ratings.reasons}) AS reason
        WHERE ${rated}
        GROUP BY 1
        ORDER BY 3 DESC, 1`),
    ]);
    const { count, total } = totals ?? { count: 0, total: 0 };
    return { count, average: averageOf(total, count), reasons: reasons.rows };
  }

  // The captains of a city with their count and average, for the panel's
  // choice (AP §9.7.4), the best rated first and the unrated last.
  async captainsOfCity(
    captains: readonly { id: string; name: string }[],
  ): Promise<{ id: string; name: string; count: number; average: number | null }[]> {
    if (captains.length === 0) return [];
    const rows = await this.database.db
      .select({
        captainId: ratings.captainId,
        count: sql<number>`count(*)::int`,
        total: sql<number>`sum(${ratings.stars})::int`,
      })
      .from(ratings)
      .where(
        and(
          eq(ratings.party, 'captain'),
          inArray(
            ratings.captainId,
            captains.map((captain) => captain.id),
          ),
          eq(ratings.testOrder, false),
        ),
      )
      .groupBy(ratings.captainId);
    const found = new Map(rows.map((row) => [row.captainId, row]));
    return captains
      .map((captain) => {
        const row = found.get(captain.id);
        return {
          id: captain.id,
          name: captain.name,
          count: row?.count ?? 0,
          average: row ? averageOf(row.total, row.count) : null,
        };
      })
      .sort(
        (a, b) =>
          (b.average ?? -1) - (a.average ?? -1) ||
          b.count - a.count ||
          a.name.localeCompare(b.name, 'ar'),
      );
  }
}
