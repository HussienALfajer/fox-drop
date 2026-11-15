import { FOOD_CREDIT_REASON } from './cancellation.js';
import {
  COMMISSION_REVERSED_REASON,
  FEE_LOWERED_AFTER_PICKUP_REASON,
  REMOVED_AFTER_PICKUP_REASON,
} from './order-edits.js';
import {
  COMMISSION_RESTORED_REASON,
  FEE_CUT_RETURNED_REASON,
  OUTCOME_CHANGE_REASON,
  PICKUP_RETURNED_REASON,
} from './outcome.js';

// RA §12.5 (slice 2.19a): what an entry on a restaurant's account is, read
// from its type and the reason ordering posted it with, for the weekly
// statement. `order` is the order's own commission or discount share; every
// other cause is an exception the statement lists apart.
export const merchantEntryCauses = [
  'order',
  // merchant.credit: an order cancelled after the food was prepared.
  'food_credit',
  // merchant.credit otherwise (a pickup dispute, slice 2.23).
  'credit',
  // merchant.debit: the pickup payment returned for a failed or refused
  // order with the restaurant responsible.
  'pickup_refund',
  // merchant.debit: the captain's pickup payment the restaurant kept on a
  // cancelled or withdrawn order (no reason).
  'pickup_kept',
  'items_removed',
  // merchant.debit: a delivery fee lowered after pickup, the restaurant
  // bearing it, or such a cut given back by an outcome.
  'fee_lowered',
  'fee_cut_returned',
  // merchant.debit otherwise (a ticket, slice 2.23).
  'debit',
  'commission_reversal',
  // merchant.commission restored by an outcome with the restaurant
  // responsible.
  'commission_restored',
  'discount_reversal',
  // Any reversal posted by «تغيير النتيجة».
  'outcome_changed',
  'adjustment',
] as const;
export type MerchantEntryCause = (typeof merchantEntryCauses)[number];

export function merchantEntryCause(
  type: string,
  reason: string | null,
  // + the restaurant owes more.
  owes: bigint,
): MerchantEntryCause {
  if (reason === OUTCOME_CHANGE_REASON) return 'outcome_changed';
  switch (type) {
    case 'merchant.commission':
      if (reason === null && owes > 0n) return 'order';
      if (reason === COMMISSION_RESTORED_REASON) return 'commission_restored';
      if (reason === COMMISSION_REVERSED_REASON || owes < 0n) return 'commission_reversal';
      return 'commission_restored';
    case 'merchant.discount_share':
      return reason === null && owes > 0n ? 'order' : 'discount_reversal';
    case 'merchant.credit':
      return reason === FOOD_CREDIT_REASON ? 'food_credit' : 'credit';
    case 'merchant.debit':
      switch (reason) {
        case null:
          return 'pickup_kept';
        case PICKUP_RETURNED_REASON:
          return 'pickup_refund';
        case REMOVED_AFTER_PICKUP_REASON:
          return 'items_removed';
        case FEE_LOWERED_AFTER_PICKUP_REASON:
          return 'fee_lowered';
        case FEE_CUT_RETURNED_REASON:
          return 'fee_cut_returned';
        default:
          return 'debit';
      }
    case 'merchant.adjustment':
      return 'adjustment';
    default:
      throw new Error(`${type} is not an entry on a restaurant's account`);
  }
}
