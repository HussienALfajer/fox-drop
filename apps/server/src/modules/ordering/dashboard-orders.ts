import { Inject, Injectable } from '@nestjs/common';
import { and, eq, gte, isNull, lt, sql } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { orders } from './schema.js';

// One order of the dashboard's window (AP §9.1.2, §9.1.5).
export interface DashboardOrderRow {
  restaurantId: string;
  status: (typeof orders.$inferSelect)['status'];
  placedAt: Date;
  deliveredAt: Date | null;
  promisedAt: Date | null;
  rejected: boolean;
  // Ready after acceptance plus the prep time chosen (a time change
  // included), or still not ready past it at `now`; «لم يُضغط جاهز» counts
  // its pickup, as the restaurant's overview does.
  late: boolean;
  // No order of the customer's account placed before it, test orders left
  // out.
  firstOrder: boolean;
}

// «لوحة التحكم» (AP §9.1; slice 2.40): the city's orders placed in a
// window, test orders and free re-deliveries left out (AP §9.6.3: test
// orders stay out of the KPIs), for the reporting module's figures.
@Injectable()
export class DashboardOrdersService {
  constructor(@Inject(DATABASE) private readonly database: Database) {}

  async placedBetween(
    cityId: string,
    from: Date,
    to: Date,
    now: Date,
  ): Promise<DashboardOrderRow[]> {
    const prepEnd = sql`${orders.acceptedAt} + make_interval(mins => ${orders.prepMin})`;
    const rows = await this.database.db
      .select({
        restaurantId: orders.restaurantId,
        status: orders.status,
        placedAt: orders.placedAt,
        deliveredAt: orders.deliveredAt,
        promisedAt: orders.promisedAt,
        late: sql<boolean>`coalesce(${orders.readyAt} > ${prepEnd} OR (${orders.readyAt} IS NULL AND ${orders.status} = 'accepted' AND ${prepEnd} < ${now.toISOString()}), false)`,
        // Written out: the outer row named in full, so the subquery's alias
        // never captures it.
        firstOrder: sql<boolean>`NOT EXISTS (SELECT 1 FROM ordering.orders earlier WHERE earlier.customer_account_id = ordering.orders.customer_account_id AND earlier.placed_at < ordering.orders.placed_at AND earlier.test_order = false)`,
      })
      .from(orders)
      .where(
        and(
          eq(orders.cityId, cityId),
          eq(orders.testOrder, false),
          isNull(orders.redeliveryOfId),
          gte(orders.placedAt, from),
          lt(orders.placedAt, to),
        ),
      );
    return rows.map((row) => ({
      ...row,
      rejected: row.status === 'rejected',
      late: Boolean(row.late),
      firstOrder: Boolean(row.firstOrder),
    }));
  }
}
