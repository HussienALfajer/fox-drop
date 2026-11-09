import { and, count, eq, gte, lte } from 'drizzle-orm';
import type { NodePgDatabase } from 'drizzle-orm/node-postgres';
import { lastCutoff } from '../geo/index.js';
import type { SettingsService } from '../settings/index.js';
import { orders } from './schema.js';

type Executor = Pick<NodePgDatabase, 'select'>;

// RA §8.3, §11, §16 #2: the restaurant's orders cancelled for no answer in
// the business day of a moment (from finance.business_day_cutoff on the
// city's clock) up to it, and merchant.auto_pause_unanswered_count, the
// count that auto-pauses it (AP §9.6.5).
export async function unansweredInBusinessDay(
  executor: Executor,
  settings: SettingsService,
  at: { restaurantId: string; cityId: string; moment: Date; timeZone: string },
): Promise<{ count: number; limit: number }> {
  const [cutoff, limit] = await Promise.all([
    settings.get('finance.business_day_cutoff', { cityId: at.cityId }),
    settings.get('merchant.auto_pause_unanswered_count', { cityId: at.cityId }),
  ]);
  const [hours, minutes] = cutoff.split(':').map(Number) as [number, number];
  const since = lastCutoff(at.moment, hours * 60 + minutes, at.timeZone);
  const [row] = await executor
    .select({ count: count() })
    .from(orders)
    .where(
      and(
        eq(orders.restaurantId, at.restaurantId),
        eq(orders.cancelReason, 'merchant_auto_cancel'),
        gte(orders.cancelledAt, since),
        lte(orders.cancelledAt, at.moment),
        // An order cancelled for no answer was placed minutes before.
        gte(orders.placedAt, new Date(since.getTime() - 86_400_000)),
      ),
    );
  return { count: row?.count ?? 0, limit };
}
