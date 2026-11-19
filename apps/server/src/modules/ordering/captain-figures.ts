import { Inject, Injectable } from '@nestjs/common';
import { sql } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { GeoService } from '../geo/index.js';
import { SettingsService } from '../settings/index.js';
import { periodBounds, RatingPagesService } from './rating-pages.js';
import { handovers, orders, reassignments } from './schema.js';

// CA §11.2: the on-time rate counts the captain's last 50 delivered orders.
export const ON_TIME_WINDOW = 50;

// AP §9.7.3–9.7.4, CA §11.2 (slice 2.36a): what the panel shows of one
// captain's orders and ratings.
export interface CaptainFigures {
  // Delivered by the captain since today's business-day cutoff.
  ordersToday: number;
  // Every order the captain delivered.
  delivered: number;
  // Of the last ON_TIME_WINDOW delivered: those delivered at or before the
  // promised time, and how many were counted.
  onTime: { onTime: number; counted: number };
  // Captain cancellations within captain.violation_window_days: a withdrawal
  // «بخطأ من الكابتن» and a handover received «بخطأ من الكابتن» (AP §9.7.6).
  cancellations: number;
  rating: { count: number; average: number } | null;
}

// The captains' order figures, test orders left out (AP §9.6.3: they stay
// out of the KPIs); a free re-delivery is the captain's work and counts.
// The order a handover moved counts for the captain who delivered it.
@Injectable()
export class CaptainFiguresService {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly geo: GeoService,
    private readonly settings: SettingsService,
    private readonly ratings: RatingPagesService,
  ) {}

  async ofCaptains(
    cityId: string,
    captainIds: readonly string[],
    now: Date,
  ): Promise<Map<string, CaptainFigures>> {
    const figures = new Map<string, CaptainFigures>();
    if (captainIds.length === 0) return figures;
    const [timeZone, cutoff, windowDays] = await Promise.all([
      this.geo.cityTimeZone(cityId),
      this.settings.get('finance.business_day_cutoff', { cityId }),
      this.settings.get('captain.violation_window_days', { cityId }),
    ]);
    if (timeZone === null) throw new Error('the city has no clock');
    const [hours, minutes] = cutoff.split(':').map(Number) as [number, number];
    const today = periodBounds('today', now, hours * 60 + minutes, timeZone).from!;
    const since = new Date(now.getTime() - windowDays * 86_400_000);
    const ids = sql.join(
      captainIds.map((id) => sql`${id}::uuid`),
      sql`, `,
    );
    const [delivered, cancelled, rated] = await Promise.all([
      // Every partition, by the captain (orders_captain_status).
      this.database.db.execute<{
        captain_id: string;
        today: number;
        delivered: number;
        on_time: number;
        counted: number;
      }>(sql`
        SELECT captain_id,
               count(*) FILTER (WHERE delivered_at >= ${today})::int AS today,
               count(*)::int AS delivered,
               count(*) FILTER (WHERE n <= ${ON_TIME_WINDOW} AND delivered_at <= promised_at)::int AS on_time,
               count(*) FILTER (WHERE n <= ${ON_TIME_WINDOW})::int AS counted
          FROM (
            SELECT ${orders.captainId} AS captain_id, ${orders.deliveredAt} AS delivered_at,
                   ${orders.promisedAt} AS promised_at,
                   row_number() OVER (PARTITION BY ${orders.captainId}
                                      ORDER BY ${orders.deliveredAt} DESC, ${orders.id} DESC) AS n
              FROM ${orders}
             WHERE ${orders.captainId} IN (${ids}) AND ${orders.status} = 'delivered'
               AND ${orders.testOrder} = false
          ) AS done
         GROUP BY captain_id`),
      this.database.db.execute<{ captain_id: string; count: number }>(sql`
        SELECT captain_id, count(*)::int AS count FROM (
          SELECT ${reassignments.captainId} AS captain_id FROM ${reassignments}
           WHERE ${reassignments.captainId} IN (${ids}) AND ${reassignments.captainFault}
             AND ${reassignments.at} >= ${since}
          UNION ALL
          SELECT ${handovers.fromCaptainId} FROM ${handovers}
           WHERE ${handovers.fromCaptainId} IN (${ids}) AND ${handovers.captainFault} IS TRUE
             AND ${handovers.receivedAt} >= ${since}
        ) AS faults
        GROUP BY captain_id`),
      this.ratings.captainsOfCity(captainIds.map((id) => ({ id, name: '' }))),
    ]);
    const done = new Map(delivered.rows.map((row) => [row.captain_id, row]));
    const faults = new Map(cancelled.rows.map((row) => [row.captain_id, Number(row.count)]));
    const ratings = new Map(rated.map((row) => [row.id, row]));
    for (const id of captainIds) {
      const row = done.get(id);
      const rating = ratings.get(id);
      figures.set(id, {
        ordersToday: Number(row?.today ?? 0),
        delivered: Number(row?.delivered ?? 0),
        onTime: { onTime: Number(row?.on_time ?? 0), counted: Number(row?.counted ?? 0) },
        cancellations: faults.get(id) ?? 0,
        rating:
          rating === undefined || rating.count === 0 || rating.average === null
            ? null
            : { count: rating.count, average: rating.average },
      });
    }
    return figures;
  }
}
