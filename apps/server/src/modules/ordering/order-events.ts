import { and, eq } from 'drizzle-orm';
import type { NodePgDatabase } from 'drizzle-orm/node-postgres';
import { inTransaction, QUEUES } from '../../jobs/job-queue.js';
import type { Jobs } from '../../jobs/jobs.module.js';
import { type captainTracks, orderEvents, orders, outbox, type orderStatuses } from './schema.js';

type OrderStatus = (typeof orderStatuses)[number];
export type CaptainTrack = (typeof captainTracks)[number];
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
  captainTrack: CaptainTrack | null;
  captainId: string | null;
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
      captainTrack: orders.captainTrack,
      captainId: orders.captainId,
    })
    .from(orders)
    .where(and(eq(orders.id, id), eq(orders.placedAt, placedAt)))
    .for('update');
  return row;
}

export type OrderEventType =
  | 'order.placed'
  | 'order.accepted'
  | 'order.ready'
  | 'order.cancelled'
  // RA §8.14, §18 (slice 2.8b): «حسناً» on a restaurant device after
  // operations cancelled an accepted order (cancelled to cancelled).
  | 'order.cancellation_acknowledged'
  // RA §8.6, AP §9.3.2: the restaurant, or operations on its behalf, rejected
  // a placed order.
  | 'order.rejected'
  // AP §8.2–8.3: the captain track changed, the status did not.
  | 'order.search_started'
  | 'order.offered'
  | 'order.offer_closed'
  | 'order.assigned'
  // CA §9.2: the captain reached the restaurant (track at_merchant).
  | 'order.captain_arrived'
  // RA §8.10, AP §8.1: a pickup request opened (track pickup_pending), a
  // request the restaurant rejected (back to at_merchant), the pickup
  // (status picked_up) and a dispute after it.
  | 'order.pickup_requested'
  | 'order.pickup_rejected'
  | 'order.picked_up'
  | 'order.pickup_disputed'
  // CA §9.6: the captain at the customer (status arrived, track at_customer).
  | 'order.arrived_at_customer'
  // CA §9.8, AP §9.3.2: «تم التسليم» with outcome normal (status delivered,
  // track done).
  | 'order.delivered'
  // AP §9.3.2 «تعديل الوقت»: operations moved the promised time (and the prep
  // time while accepted); the status stays.
  | 'order.time_changed';

// Architecture §5.5 steps 3 and 5: the order's event row and its outgoing
// event, in the transition's transaction, with a run of the relay that
// publishes it once it commits (outbox-relay.ts) and a sync of its alerts. The outbox payload is
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
    // device: a restaurant user's or a captain's app installation (RA §18,
    // CA §15).
    actor: {
      type: 'customer' | 'restaurant' | 'captain' | 'admin' | 'system';
      id: string | null;
      device?: string;
    };
    reason: string | null;
    // What the outbox publishes as the reason, the reason when left out. An
    // operations note stays in the event row and the audit, never on the
    // apps' channels (AP §10, RA §8.4): its transitions publish null.
    publicReason?: string | null;
    at: Date;
    // The captain track after it, and the captain it is about (an offer's or
    // the one assigned); the order's own when left out.
    captainTrack?: CaptainTrack | null;
    captainId?: string | null;
    // An offer's order pay (CA §8.2), which its push shows (CA §14 #1).
    offerPay?: { amount: bigint; currency: string } | null;
    // The offer's end: its push is no use after it (CA §14 #1-2).
    offerExpiresAt?: Date;
  },
): Promise<void> {
  const captainTrack =
    transition.captainTrack === undefined ? order.captainTrack : transition.captainTrack;
  const captainId = transition.captainId === undefined ? order.captainId : transition.captainId;
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
    actorDevice: transition.actor.device ?? null,
    reason: transition.reason,
    type: transition.type,
    captainId,
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
      reason: transition.publicReason === undefined ? transition.reason : transition.publicReason,
      at: transition.at.toISOString(),
      // RA §8.15: operations acted for the restaurant, which the restaurant's
      // devices chime (RA §16 #5, #6).
      byOperations: transition.actor.type === 'admin',
      // RA §8.3: the customer cancelled while placed, which the restaurant's
      // devices chime (RA §16 #4).
      byCustomer: transition.actor.type === 'customer' && transition.to === 'cancelled',
      captainTrack,
      captainId,
      ...(transition.offerPay === undefined
        ? {}
        : {
            offerPay: transition.offerPay && {
              amount: transition.offerPay.amount.toString(),
              currency: transition.offerPay.currency,
            },
          }),
      ...(transition.offerExpiresAt === undefined
        ? {}
        : { offerExpiresAt: transition.offerExpiresAt.toISOString() }),
    },
  });
  await jobs.send(QUEUES.outboxRelay, {}, { db: inTransaction(tx) });
  // AP §7.3: the order's alerts follow it, raised or resolved once the
  // transition commits (order-alerts.ts).
  await jobs.send(
    QUEUES.orderAlerts,
    { orderId: order.id, placedAt: order.placedAt.toISOString() },
    { db: inTransaction(tx) },
  );
}
