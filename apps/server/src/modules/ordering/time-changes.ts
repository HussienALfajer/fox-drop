import { and, asc, eq } from 'drizzle-orm';
import type { NodePgDatabase } from 'drizzle-orm/node-postgres';
import { timeChanges } from './schema.js';

type Executor = Pick<NodePgDatabase, 'select'>;

// docs/domain/04 (slice 2.9): the prep time chosen at acceptance, before any
// «تعديل الوقت» moved it, or null when none did.
export async function acceptedPrepMin(
  executor: Executor,
  order: { id: string; placedAt: Date },
): Promise<number | null> {
  const [first] = await executor
    .select({ prepMinBefore: timeChanges.prepMinBefore })
    .from(timeChanges)
    .where(and(eq(timeChanges.orderId, order.id), eq(timeChanges.orderPlacedAt, order.placedAt)))
    .orderBy(asc(timeChanges.at))
    .limit(1);
  return first?.prepMinBefore ?? null;
}
