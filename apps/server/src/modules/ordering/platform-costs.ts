import { FEE_LOWERED_AFTER_PICKUP_REASON, REMOVED_AFTER_PICKUP_REASON } from './order-edits.js';
import { CHARGE_RETURNED_REASON, FEE_CUT_RETURNED_REASON } from './outcome.js';
import type { orderOutcomes, orderStatuses, responsibleParties } from './schema.js';
import { SHORTFALL_REASON } from './shortfall.js';

type OrderStatus = (typeof orderStatuses)[number];
type OrderOutcome = (typeof orderOutcomes)[number];
type ResponsibleParty = (typeof responsibleParties)[number];

// AP §9.10.6 «كلفة التعويضات والخصومات» (slice 2.22d): what the cost report
// reads of an order behind an entry on the platform's cost accounts.
export interface CostOrder {
  restaurantId: string;
  status: OrderStatus;
  // Operations' cancellation's party; null on any other order.
  cancelResponsible: ResponsibleParty | null;
  // The outcome in force and its party (null for a normal delivery).
  outcome: OrderOutcome | null;
  outcomeResponsible: ResponsibleParty | null;
  // Every outcome operations set that posted journals, a replaced one
  // included, with the journals it posted («تغيير النتيجة» reverses them).
  outcomes: readonly {
    outcome: OrderOutcome;
    responsible: ResponsibleParty;
    journalIds: readonly string[];
  }[];
  promoCodeId: string | null;
  promoCode: string | null;
}

// What an entry on platform.operating_cost was for (docs/domain/11): the
// merchant net of food prepared for an order operations cancelled, «تعويض
// الكابتن» of a cancellation, the loss and the captain's pay of an outcome
// (by the outcome), an edit after the pickup the platform bore, a shortfall
// it bore, or `other` for an entry this module cannot place.
export const operatingCostCauses = [
  'cancelled_prepared',
  'captain_compensation',
  'free',
  'fake',
  'damaged',
  'wrong_refused',
  'failed_other',
  'edit_after_pickup',
  'shortfall',
  'other',
] as const;
export type OperatingCostCause = (typeof operatingCostCauses)[number];

// An edit after the pickup the platform bore, and what an outcome gave back
// of it.
const editReasons: readonly (string | null)[] = [
  REMOVED_AFTER_PICKUP_REASON,
  FEE_LOWERED_AFTER_PICKUP_REASON,
  CHARGE_RETURNED_REASON,
  FEE_CUT_RETURNED_REASON,
];

// The cause of an entry on platform.operating_cost and the party operations
// named responsible, from its journal (a reversal's: the journal it
// reverses, with that journal's reason) and the order. A shortfall and an
// edit are known by the reasons this module posts them with; a cancelled
// order's by its cancellation; an outcome's by the outcome that posted the
// journal, so what «تغيير النتيجة» takes back counts against the outcome and
// the party that were replaced, in whatever period it falls. A journal no
// outcome row names (posted before slice 2.11c) counts under the outcome in
// force.
export function operatingCostCause(
  journal: { id: string; type: string; reason: string | null },
  order: CostOrder | undefined,
): { cause: OperatingCostCause; responsible: ResponsibleParty | null } {
  if (journal.reason === SHORTFALL_REASON) return { cause: 'shortfall', responsible: 'platform' };
  if (editReasons.includes(journal.reason)) {
    return { cause: 'edit_after_pickup', responsible: 'platform' };
  }
  if (order?.status === 'cancelled') {
    return {
      cause: journal.type.startsWith('earn.') ? 'captain_compensation' : 'cancelled_prepared',
      responsible: order.cancelResponsible,
    };
  }
  const posted = order?.outcomes.find((each) => each.journalIds.includes(journal.id));
  if (posted && posted.outcome !== 'normal') {
    return { cause: posted.outcome, responsible: posted.responsible };
  }
  if (order?.outcome != null && order.outcome !== 'normal') {
    return { cause: order.outcome, responsible: order.outcomeResponsible };
  }
  return { cause: 'other', responsible: null };
}
