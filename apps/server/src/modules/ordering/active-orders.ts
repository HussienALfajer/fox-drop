import { Inject, Injectable } from '@nestjs/common';
import { and, count, eq, gt, inArray, isNull, type SQL, sql } from 'drizzle-orm';
import type { NodePgDatabase } from 'drizzle-orm/node-postgres';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { SettingsService } from '../settings/index.js';
import { orderOutcomeRows, orders, type orderStatuses } from './schema.js';

type OrderStatus = (typeof orderStatuses)[number];
type Executor = Pick<NodePgDatabase, 'select'>;

// RA §7.4: a restaurant's orders count until pickup or their end.
const RESTAURANT_ACTIVE: OrderStatus[] = ['placed', 'accepted', 'ready'];
// D23, CU §5.5: a customer's orders count until they end; RA §8.2: the
// restaurant's board shows them until then.
export const UNTIL_ENDED: OrderStatus[] = ['placed', 'accepted', 'ready', 'picked_up', 'arrived'];

// D23: the city's limits, read before any transaction (a settings read may
// take a pool connection of its own).
export interface CustomerLimitRules {
  newMax: number;
  trustedAfter: number;
  trustedMax: number;
}

export interface CustomerLimit {
  reached: boolean;
  limit: number;
  // After customer.trusted_after_delivered_orders delivered (D23). Not shown
  // to the customer, only its limit (CU §5.5).
  trusted: boolean;
}

// The active orders of a restaurant (RA §7.4) and of a customer (D23), for
// the quote, the order command and the restaurant's state.
@Injectable()
export class ActiveOrders {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly settings: SettingsService,
  ) {}

  restaurant(restaurantId: string, executor: Executor = this.database.db): Promise<number> {
    return countOrders(executor, eq(orders.restaurantId, restaurantId), RESTAURANT_ACTIVE);
  }

  async rules(cityId: string): Promise<CustomerLimitRules> {
    const [newMax, trustedAfter, trustedMax] = await Promise.all([
      this.settings.get('customer.new_max_active_orders', { cityId }),
      this.settings.get('customer.trusted_after_delivered_orders', { cityId }),
      this.settings.get('customer.trusted_max_active_orders', { cityId }),
    ]);
    return { newMax, trustedAfter, trustedMax };
  }

  // D23: the delivered orders with outcome normal (AP §8.9) make a customer
  // trusted; a fake outcome removes the trust and starts the count again
  // (docs/domain/08, slice 2.11a), so only the deliveries after the latest
  // one count. A fake outcome changed since (slice 2.11c) counts no more.
  async customer(
    accountId: string,
    rules: CustomerLimitRules,
    executor: Executor = this.database.db,
  ): Promise<CustomerLimit> {
    const whose = eq(orders.customerAccountId, accountId);
    const [lastFake] = await executor
      // When the fake outcome happened: the order's first outcome, which a
      // change (slice 2.11c) does not move.
      .select({
        at: sql`max((SELECT min(first.set_at) FROM ordering.order_outcomes first
                     WHERE first.order_id = ${orderOutcomeRows.orderId}))`.mapWith(
          orderOutcomeRows.setAt,
        ),
      })
      .from(orderOutcomeRows)
      .innerJoin(
        orders,
        and(
          eq(orders.id, orderOutcomeRows.orderId),
          eq(orders.placedAt, orderOutcomeRows.orderPlacedAt),
        ),
      )
      .where(and(whose, eq(orderOutcomeRows.outcome, 'fake'), isNull(orderOutcomeRows.replacedAt)));
    const delivered = await countOrders(
      executor,
      and(
        whose,
        eq(orders.outcome, 'normal'),
        lastFake?.at ? gt(orders.deliveredAt, lastFake.at) : undefined,
      )!,
      ['delivered'],
    );
    const trusted = delivered >= rules.trustedAfter;
    const limit = trusted ? rules.trustedMax : rules.newMax;
    const active = await countOrders(executor, whose, UNTIL_ENDED);
    return { reached: active >= limit, limit, trusted };
  }
}

async function countOrders(
  executor: Executor,
  whose: SQL,
  statuses: OrderStatus[],
): Promise<number> {
  const [row] = await executor
    .select({ n: count() })
    .from(orders)
    .where(and(whose, inArray(orders.status, statuses)));
  return row?.n ?? 0;
}
