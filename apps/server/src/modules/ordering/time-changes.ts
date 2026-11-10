import { and, asc, eq, isNotNull } from 'drizzle-orm';
import type { NodePgDatabase } from 'drizzle-orm/node-postgres';
import { orderEdits, timeChanges } from './schema.js';

type Executor = Pick<NodePgDatabase, 'select'>;

// docs/domain/04 (slices 2.9, 2.10a): the prep time chosen at acceptance,
// before any «تعديل الوقت» or edit back to preparing moved it, or null when
// none did.
export async function acceptedPrepMin(
  executor: Executor,
  order: { id: string; placedAt: Date },
): Promise<number | null> {
  const [change] = await executor
    .select({ at: timeChanges.at, prepMinBefore: timeChanges.prepMinBefore })
    .from(timeChanges)
    .where(and(eq(timeChanges.orderId, order.id), eq(timeChanges.orderPlacedAt, order.placedAt)))
    .orderBy(asc(timeChanges.at))
    .limit(1);
  const [edit] = await executor
    .select({ at: orderEdits.at, prepMinBefore: orderEdits.prepMinBefore })
    .from(orderEdits)
    .where(
      and(
        eq(orderEdits.orderId, order.id),
        eq(orderEdits.orderPlacedAt, order.placedAt),
        isNotNull(orderEdits.prepMinBefore),
      ),
    )
    .orderBy(asc(orderEdits.at))
    .limit(1);
  const first = [change, edit]
    .filter((entry) => entry !== undefined)
    .sort((a, b) => a.at.getTime() - b.at.getTime())[0];
  return first?.prepMinBefore ?? null;
}
