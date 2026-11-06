import { and, eq } from 'drizzle-orm';
import type { NodePgDatabase } from 'drizzle-orm/node-postgres';
import { inTransaction, QUEUES } from '../../jobs/job-queue.js';
import type { Jobs } from '../../jobs/jobs.module.js';
import { orderEvents, orders, outbox, type orderStatuses } from './schema.js';

type OrderStatus = (typeof orderStatuses)[number];
type Tx = Parameters<Parameters<NodePgDatabase['transaction']>[0]>[0];

export interface OrderRow {
  id: string;
  placedAt: Date;
  cityId: string;
  number: bigint;
  restaurantId: string;
  customerAccountId: string;
  status: OrderStatus;
  version: number;
}

// The order's columns a transition reads, locked for it.
export async function lockOrder(tx: Tx, id: string, placedAt: Date): Promise<OrderRow | undefined> {
  const [row] = await tx
    .select({
      id: orders.id,
      placedAt: orders.placedAt,
      cityId: orders.cityId,
      number: orders.number,
      restaurantId: orders.restaurantId,
      customerAccountId: orders.customerAccountId,
      status: orders.status,
      version: orders.version,
    })
    .from(orders)
    .where(and(eq(orders.id, id), eq(orders.placedAt, placedAt)))
    .for('update');
  return row;
}

export type OrderEventType = 'order.placed' | 'order.cancelled';

// Architecture §5.5 steps 3 and 5: the order's event row and its outgoing
// event, in the transition's transaction, with a run of the relay that
// publishes it once it commits (outbox-relay.ts). The outbox payload is
// version 1 of its type; clients ignore one older than the order version they
// show (RA §4.3).
export async function recordTransition(
  tx: Tx,
  jobs: Jobs,
  order: OrderRow,
  transition: {
    type: OrderEventType;
    from: OrderStatus | null;
    to: OrderStatus;
    version: number;
    actor: { type: 'customer' | 'restaurant' | 'captain' | 'admin' | 'system'; id: string | null };
    reason: string | null;
    at: Date;
  },
): Promise<void> {
  await tx.insert(orderEvents).values({
    orderId: order.id,
    orderPlacedAt: order.placedAt,
    version: transition.version,
    cityId: order.cityId,
    at: transition.at,
    fromStatus: transition.from,
    toStatus: transition.to,
    actorType: transition.actor.type,
    actorId: transition.actor.id,
    reason: transition.reason,
  });
  await tx.insert(outbox).values({
    createdAt: transition.at,
    cityId: order.cityId,
    type: transition.type,
    orderId: order.id,
    orderVersion: transition.version,
    payload: {
      schema: 1,
      orderId: order.id,
      number: order.number.toString(),
      cityId: order.cityId,
      restaurantId: order.restaurantId,
      customerAccountId: order.customerAccountId,
      status: transition.to,
      version: transition.version,
      reason: transition.reason,
      at: transition.at.toISOString(),
    },
  });
  await jobs.send(QUEUES.outboxRelay, {}, { db: inTransaction(tx) });
}
