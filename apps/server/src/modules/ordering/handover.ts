import { type Point, straightLineMetres } from '../geo/index.js';
import type { orderStatuses } from './schema.js';

type OrderStatus = (typeof orderStatuses)[number];

// AP §9.3.2 «تسليم لكابتن آخر»: picked_up or arrived only.
export const HANDOVER_FROM: readonly OrderStatus[] = ['picked_up', 'arrived'];

export type HandoverRefusal = 'order_not_handoverable' | 'same_captain';

// AP §9.3.2, CA §9.10.1 (slice 2.12b): operations hand a picked-up order
// from its captain to a second one, while no other handover is open and no
// outcome waits for its collection (K9: the order is the outcome's then).
export function canHandOver(
  order: { status: OrderStatus; captainId: string | null },
  facts: { open: boolean; outcomePending: boolean },
  toCaptainId: string,
): HandoverRefusal | null {
  if (
    !HANDOVER_FROM.includes(order.status) ||
    order.captainId === null ||
    facts.open ||
    facts.outcomePending
  ) {
    return 'order_not_handoverable';
  }
  if (order.captainId === toCaptainId) return 'same_captain';
  return null;
}

// CA §9.10.1, §15: «استلمت الطلب من الكابتن {الاسم}» within
// captain.customer_radius_m of the first captain's latest fix, by the
// straight line; without a fix of theirs the receipt cannot be checked.
export function receiptDistance(
  fix: Point,
  firstFix: Point | null,
  radiusMetres: number,
): { within: boolean; metres: number | null } {
  if (firstFix === null) return { within: false, metres: null };
  const metres = Math.round(straightLineMetres(fix, firstFix));
  return { within: metres <= radiusMetres, metres };
}

// docs/domain/01, CA §9.10.1: at the receipt the order becomes the second
// captain's, picked_up again if it was arrived, with the door arrival and its
// away reason cleared (they were the first captain's).
export function receiptSet(toCaptainId: string) {
  return {
    status: 'picked_up' as const,
    captainId: toCaptainId,
    captainTrack: 'picked_up' as const,
    arrivedAtCustomerAt: null,
    awayReason: null,
    awayReasonLabel: null,
    awayNote: null,
  };
}
