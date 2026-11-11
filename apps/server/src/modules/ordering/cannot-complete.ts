import { and, eq, inArray, isNull } from 'drizzle-orm';
import type { NodePgDatabase } from 'drizzle-orm/node-postgres';
import type { CaptainsService } from '../captains/index.js';
import { cannotCompleteRequests, type cannotCompleteHows } from './schema.js';

type Executor = Pick<NodePgDatabase, 'select'>;
type Tx = Parameters<Parameters<NodePgDatabase['transaction']>[0]>[0];

// How an open «لا أستطيع إكمال الطلب» closed (CA §9.11, slice 2.13b).
export type CannotCompleteHow = (typeof cannotCompleteHows)[number];

// An open request as the reads give it: the captain's reason (its label as
// chosen and the text «أخرى» needs) and when.
export interface OpenCannotComplete {
  orderId: string;
  captainId: string;
  reason: string;
  reasonLabel: string;
  note: string | null;
  at: Date;
}

// The open requests of these orders (at most one each).
export async function openCannotCompletes(
  executor: Executor,
  keys: { id: string; placedAt: Date }[],
): Promise<Map<string, OpenCannotComplete>> {
  if (keys.length === 0) return new Map();
  const rows = await executor
    .select({
      orderId: cannotCompleteRequests.orderId,
      captainId: cannotCompleteRequests.captainId,
      reason: cannotCompleteRequests.reason,
      reasonLabel: cannotCompleteRequests.reasonLabel,
      note: cannotCompleteRequests.note,
      at: cannotCompleteRequests.requestedAt,
    })
    .from(cannotCompleteRequests)
    .where(
      and(
        inArray(
          cannotCompleteRequests.orderId,
          keys.map((key) => key.id),
        ),
        inArray(
          cannotCompleteRequests.orderPlacedAt,
          keys.map((key) => key.placedAt),
        ),
        isNull(cannotCompleteRequests.closedAt),
      ),
    );
  return new Map(rows.map((row) => [row.orderId, row]));
}

export async function openCannotComplete(
  executor: Executor,
  key: { id: string; placedAt: Date },
): Promise<OpenCannotComplete | null> {
  return (await openCannotCompletes(executor, [key])).get(key.id) ?? null;
}

// Closes the order's open request, if any, and answers it.
export async function closeCannotComplete(
  tx: Tx,
  key: { id: string; placedAt: Date },
  how: CannotCompleteHow,
  now: Date,
): Promise<OpenCannotComplete | null> {
  const open = await openCannotComplete(tx, key);
  if (open === null) return null;
  await tx
    .update(cannotCompleteRequests)
    .set({ closedAt: now, closedHow: how })
    .where(
      and(
        eq(cannotCompleteRequests.orderId, key.id),
        eq(cannotCompleteRequests.orderPlacedAt, key.placedAt),
        isNull(cannotCompleteRequests.closedAt),
      ),
    );
  return open;
}

// K17 (slice 2.13b, owner decision 2026-11-11): in the transaction where the
// order left its captain, whatever way it left (withdrawn, ended, cancelled,
// delivered by the captain), an open «لا أستطيع إكمال الطلب» of that captain
// closes and takes them offline; otherwise a last-order mode may end their
// online period (CA §7.3, K18). The answer runs after the commit.
export async function leaveCaptain(
  tx: Tx,
  captains: CaptainsService,
  key: { id: string; placedAt: Date },
  captainId: string,
  how: Exclude<CannotCompleteHow, 'withdrawn' | 'handed_over'>,
  now: Date,
): Promise<() => Promise<void>> {
  const open = await closeCannotComplete(tx, key, how, now);
  if (open?.captainId === captainId) {
    return captains.offlineAfterCannotComplete(tx, captainId, now);
  }
  return captains.afterOrderLeft(tx, captainId, now);
}
