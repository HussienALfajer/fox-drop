import { Inject, Injectable } from '@nestjs/common';
import { and, count, eq, inArray, type SQL } from 'drizzle-orm';
import type { NodePgDatabase } from 'drizzle-orm/node-postgres';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { SettingsService } from '../settings/index.js';
import { orders, type orderStatuses } from './schema.js';

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
  // trusted.
  async customer(
    accountId: string,
    rules: CustomerLimitRules,
    executor: Executor = this.database.db,
  ): Promise<CustomerLimit> {
    const whose = eq(orders.customerAccountId, accountId);
    const delivered = await countOrders(executor, and(whose, eq(orders.outcome, 'normal'))!, [
      'delivered',
    ]);
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
