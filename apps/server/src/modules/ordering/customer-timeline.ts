import type { OrderView } from './order-views.js';

type TimelineStep =
  | 'placed'
  | 'accepted'
  | 'picked_up'
  | 'arrived'
  | 'delivered'
  | 'failed'
  | 'rejected'
  | 'cancelled';

// CU §12.3: the steps the order reached, oldest first. A delivery set by
// «تحديد النتيجة» is the outcome's moment (its collection's, once collected).
export function timeline(
  order: Pick<
    OrderView,
    | 'status'
    | 'placedAt'
    | 'acceptance'
    | 'pickup'
    | 'customerArrival'
    | 'delivery'
    | 'outcome'
    | 'rejection'
    | 'cancellation'
  >,
): { step: TimelineStep; at: string }[] {
  const ended =
    order.status === 'delivered'
      ? (order.delivery?.at ?? order.outcome?.collectedAt ?? order.outcome?.at ?? null)
      : order.status === 'failed'
        ? (order.outcome?.at ?? null)
        : null;
  const steps: [TimelineStep, Date | null | undefined][] = [
    ['placed', order.placedAt],
    ['accepted', order.acceptance?.at],
    ['picked_up', order.pickup?.at],
    ['arrived', order.customerArrival?.at],
    [order.status === 'failed' ? 'failed' : 'delivered', ended],
    ['rejected', order.rejection?.at],
    ['cancelled', order.cancellation?.at],
  ];
  return steps.flatMap(([step, at]) => (at ? [{ step, at: at.toISOString() }] : []));
}
