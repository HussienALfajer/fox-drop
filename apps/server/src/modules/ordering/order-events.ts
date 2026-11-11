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
  // AP §9.12.6, §9.3.2 (slice 2.15c): the order left automatic dispatch for
  // operations; its reason max_offers, no_captain_alert or operations.
  | 'order.moved_to_manual'
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
  | 'order.time_changed'
  // RA §8.12, AP §9.3.2: the restaurant reported items unavailable after
  // accepting, withdrew its report, or operations closed it without an edit.
  | 'order.item_reported'
  | 'order.item_report_withdrawn'
  | 'order.item_report_closed'
  // AP §9.3.3, RA §8.13 (slice 2.10a): operations edited the order before its
  // pickup (a ready order back to accepted when items were added), and the
  // restaurant's «اطلعت على التعديل».
  | 'order.edited'
  | 'order.edit_acknowledged'
  // AP §9.3.2 «تحديد النتيجة», AP §8.9 (slice 2.11a): operations ended a
  // picked-up order with an outcome other than normal (status failed, or
  // delivered for free and damaged; track done). The outcome is its reason.
  // With an amount to collect (slice 2.11b, K9) the status stays and the
  // captain's payment screen opens; order.outcome_collected is the payment
  // recorded and the outcome posted (status delivered, track done).
  | 'order.outcome_set'
  | 'order.outcome_collected'
  // AP §8.9 «تغيير النتيجة» (slice 2.11c): OWN changed a finished order's
  // outcome; the status follows it (delivered or failed). The new outcome is
  // its reason.
  | 'order.outcome_changed'
  // AP §9.3.2 «سحب وإعادة تعيين» (slice 2.12a): operations took the order
  // from its captain before the pickup (the status stays, the track back to
  // searching); the event is about the withdrawn captain, and publishes the
  // reason's code.
  | 'order.reassigned'
  // AP §9.3.2 «تسليم لكابتن آخر», CA §9.10.1 (slice 2.12b): operations offered
  // or assigned a picked-up order's handover to a second captain, the second
  // captain has it (accepted or assigned), the handover closed without the
  // receipt (its reason: declined, expired, withdrawn, ended), and the
  // receipt near the first captain (status back to picked_up if arrived; the
  // order becomes the second captain's). The status stays but at the
  // receipt; each is about the second captain, and reaches the first's
  // channel too.
  | 'order.handover_offered'
  | 'order.handover_assigned'
  | 'order.handover_closed'
  | 'order.handed_over'
  // CA §9.11 (slice 2.13b): the captain's «لا أستطيع إكمال الطلب» (its
  // reason's code published to operations and the captain) and its «تراجع»;
  // the status stays.
  | 'order.cannot_complete_requested'
  | 'order.cannot_complete_withdrawn'
  // CA §9.11 (slice 2.13c): the captain pressed «طوارئ»; the status stays.
  | 'order.emergency_raised'
  // CA §9.9, CU §11.7 (slice 2.13d): the captain at the door pinged the
  // customer, the customer answered (the answer as the reason), the captain
  // reported «الزبون لا يستجيب», and operations answered «انتظر» (the
  // message as the reason, for the captain); the status stays.
  | 'order.customer_pinged'
  | 'order.ping_answered'
  | 'order.customer_not_answering'
  | 'order.no_answer_waited';

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
    // A handover's other captain (slice 2.12b), whose channel hears it too.
    otherCaptainId?: string;
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
      ...(transition.otherCaptainId === undefined
        ? {}
        : { otherCaptainId: transition.otherCaptainId }),
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
