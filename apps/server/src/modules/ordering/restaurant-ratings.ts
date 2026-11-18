import { Inject, Injectable } from '@nestjs/common';
import { and, desc, eq, gte, lt, lte, sql, type SQL } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { GeoService, lastCutoff } from '../geo/index.js';
import { SettingsService } from '../settings/index.js';
import { ratings } from './schema.js';

// RA §13, R16, CU §12.1 «Who sees what» (slice 2.26b): the restaurant's
// owners read its ratings without the customer or the order; test orders
// never show (owner decision 2026-11-17).

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

export interface RestaurantRating {
  stars: number;
  reasons: { code: string; label: string }[];
  comment: string | null;
  // The business day it was sent, YYYY-MM-DD on the city's clock: never its
  // time, which with the board's times could trace it to an order (RA §13).
  day: string;
}

export interface RestaurantRatings {
  // The moment the first page was read: the next pages read up to it, so
  // they neither repeat nor miss a rating, and keep its period.
  asOf: Date;
  count: number;
  average: number | null;
  // From 5 stars down to 1.
  distribution: { stars: number; count: number }[];
  ratings: RestaurantRating[];
  // Whether a page follows.
  more: boolean;
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
export class RestaurantRatingsService {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly geo: GeoService,
    private readonly settings: SettingsService,
  ) {}

  // The period's count, average and distribution, whatever the stars
  // chosen, and a page of its ratings with those stars, newest first, all
  // as of `asOf` (now on the first page; never after now).
  async read(
    restaurant: { id: string; cityId: string },
    query: { period: RatingPeriod; stars: number | null; page: number; asOf: Date | null },
    now: Date,
  ): Promise<RestaurantRatings> {
    const asOf = query.asOf === null || query.asOf.getTime() > now.getTime() ? now : query.asOf;
    const [timeZone, cutoff] = await Promise.all([
      this.geo.cityTimeZone(restaurant.cityId),
      this.settings.get('finance.business_day_cutoff', { cityId: restaurant.cityId }),
    ]);
    if (timeZone === null) throw new Error('the restaurant’s city has no clock');
    const [hours, minutes] = cutoff.split(':').map(Number) as [number, number];
    const cutoffMinutes = hours * 60 + minutes;
    const { from, to } = periodBounds(query.period, asOf, cutoffMinutes, timeZone);
    const inPeriod: SQL[] = [
      eq(ratings.party, 'restaurant'),
      eq(ratings.restaurantId, restaurant.id),
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
          stars: ratings.stars,
          reasons: sql<{ code: string; label: string }[]>`${ratings.reasons}`,
          comment: ratings.comment,
          at: ratings.at,
        })
        .from(ratings)
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
      average: count === 0 ? null : Math.round((total / count) * 10) / 10,
      distribution,
      ratings: rows.slice(0, RATINGS_PAGE).map(({ at, ...rating }) => ({
        ...rating,
        day: dayOf(lastCutoff(at, cutoffMinutes, timeZone), timeZone),
      })),
      more: rows.length > RATINGS_PAGE,
    };
  }
}
