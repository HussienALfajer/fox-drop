import { createHash } from 'node:crypto';
import { and, eq } from 'drizzle-orm';
import type { NodePgDatabase } from 'drizzle-orm/node-postgres';
import { idempotencyKeys } from './schema.js';

type Tx = Parameters<Parameters<NodePgDatabase['transaction']>[0]>[0];
type Executor = Pick<NodePgDatabase, 'select'>;

// Architecture §5.3: a key answers its order for 24 hours.
const KEY_LIFETIME_MS = 24 * 60 * 60 * 1000;

// The key came with another command than the first time.
export class IdempotencyKeyReusedError extends Error {
  override readonly name = 'IdempotencyKeyReusedError';
}

// The order a command's key gave in the last 24 hours, or null; the key sent
// with another command is refused (IdempotencyKeyReusedError). Keys are kept
// per account, whichever party's, with the order of the command.
export async function replayKey(
  executor: Executor,
  accountId: string,
  key: string,
  requestHash: string,
  now: Date,
): Promise<{ id: string; placedAt: Date } | null> {
  const [row] = await executor
    .select({
      requestHash: idempotencyKeys.requestHash,
      id: idempotencyKeys.orderId,
      placedAt: idempotencyKeys.orderPlacedAt,
      createdAt: idempotencyKeys.createdAt,
    })
    .from(idempotencyKeys)
    .where(and(eq(idempotencyKeys.accountId, accountId), eq(idempotencyKeys.key, key)));
  if (!row || now.getTime() - row.createdAt.getTime() >= KEY_LIFETIME_MS) return null;
  if (row.requestHash !== requestHash) {
    throw new IdempotencyKeyReusedError('the key came with another command');
  }
  return { id: row.id, placedAt: row.placedAt };
}

// Keeps the key with its order, in the command's transaction, so a refused
// command keeps none. A key older than 24 hours is used again.
export async function keepKey(
  tx: Tx,
  accountId: string,
  key: string,
  requestHash: string,
  order: { id: string; placedAt: Date },
  now: Date,
): Promise<void> {
  const kept = { requestHash, orderId: order.id, orderPlacedAt: order.placedAt, createdAt: now };
  await tx
    .insert(idempotencyKeys)
    .values({ accountId, key, ...kept })
    .onConflictDoUpdate({ target: [idempotencyKeys.accountId, idempotencyKeys.key], set: kept });
}

// A command's hash, its bigints as strings, so a repeat is recognised.
export function commandHash(command: unknown): string {
  return createHash('sha256')
    .update(
      JSON.stringify(command, (_key, entry: unknown) =>
        typeof entry === 'bigint' ? entry.toString() : entry,
      ),
    )
    .digest('hex');
}
