import {
  type CancellationFacts,
  type CancellationJournal,
  type CashAnswer,
  keptPaymentJournals,
} from './cancellation.js';
import type { CaptainTrack } from './order-events.js';
import type { orderStatuses } from './schema.js';

// AP §9.3.2 «سحب وإعادة تعيين»: before the pickup only, from an accepted or
// ready order with its captain.
export const REASSIGNABLE: (typeof orderStatuses)[number][] = ['accepted', 'ready'];

// What the reassignment depends on, read from the order (the cash lines as
// the cancellation reads them: the captain's last request's, else the items
// value).
export interface ReassignmentFacts extends Pick<
  CancellationFacts,
  'restaurantId' | 'currency' | 'cashLines' | 'cashBase' | 'snapshot'
> {
  status: (typeof orderStatuses)[number];
  captainId: string | null;
  captainTrack: CaptainTrack | null;
  // arrived_at_merchant_at is set: the cash question is asked (AP §8.1).
  arrivedAtMerchant: boolean;
}

export type ReassignmentProblem =
  | 'order_state_changed'
  | 'pickup_request_open'
  | 'cash_answer_required'
  | 'cash_answer_not_allowed';

export interface Reassignment {
  journals: CancellationJournal[];
  cashAsked: boolean;
}

// AP §9.3.2, AP §8.1, docs/domain/01: whether operations may take the order
// from its captain now, and what the cash question books. No reassignment
// while a pickup request is open (docs/domain/01: at most 60 seconds). The
// cash answer is required exactly once the captain reached the restaurant;
// «لا» books the payment the restaurant kept, as the cancellation does. The
// preview (the dialog asks before the answer is given) never refuses the
// cash answer: it answers `cashAsked`, so the dialog knows to ask.
export function reassignmentEntries(
  facts: ReassignmentFacts,
  cash: CashAnswer | null,
  { preview = false }: { preview?: boolean } = {},
): Reassignment | { problem: ReassignmentProblem } {
  if (!REASSIGNABLE.includes(facts.status) || facts.captainId === null) {
    return { problem: 'order_state_changed' };
  }
  if (facts.captainTrack === 'pickup_pending') return { problem: 'pickup_request_open' };
  const cashAsked = facts.arrivedAtMerchant;
  if (!preview) {
    if (cashAsked && cash === null) return { problem: 'cash_answer_required' };
    if (!cashAsked && cash !== null) return { problem: 'cash_answer_not_allowed' };
  }
  return {
    journals: cashAsked && cash === 'not_returned' ? keptPaymentJournals(facts) : [],
    cashAsked,
  };
}
