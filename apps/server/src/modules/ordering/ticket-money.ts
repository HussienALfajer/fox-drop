import type { ResponsibleParty } from './cancellation.js';
import { commission } from './door-payment.js';
import {
  type AfterPickupEntry,
  type AfterPickupJournal,
  COMMISSION_REVERSED_REASON,
} from './order-edits.js';

// AP §8.10, docs/domain/10, RA §12.5 (slice 2.23c): the reasons a ticket
// after a normal delivery posts with: the restaurant's line «مشكلة بعد
// التسليم» (also the captain's charge), and the wrong change, which keeps the
// customer app's problem label (CU Q23).
export const POST_DELIVERY_PROBLEM_REASON = 'مشكلة بعد التسليم';
export const WRONG_CHANGE_REASON = 'مشكلة في المبلغ أو الباقي';

// An affected line: the order's line by its position and how many of it.
export interface AffectedLine {
  position: number;
  quantity: number;
}

// `V` (docs/domain/10): the affected items' value from the order's lines at
// their unit prices; null when a line is not the order's, is named twice or
// a quantity is outside 1 to the line's.
export function affectedValue(
  lines: readonly { position: number; quantity: number; unitPrice: bigint }[],
  affected: readonly AffectedLine[],
): bigint | null {
  const byPosition = new Map(lines.map((line) => [line.position, line]));
  const seen = new Set<number>();
  let value = 0n;
  for (const each of affected) {
    const line = byPosition.get(each.position);
    if (!line || seen.has(each.position)) return null;
    if (!Number.isInteger(each.quantity) || each.quantity < 1 || each.quantity > line.quantity) {
      return null;
    }
    seen.add(each.position);
    value += line.unitPrice * BigInt(each.quantity);
  }
  return value;
}

// AP §8.4: the commission on an items value after the restaurant-funded
// item discount, its base never below zero (V can reach the discounted
// part, and a reversal never exceeds what was booked); none on a test order.
export function commissionOn(
  commissionBp: number,
  itemDiscount: bigint,
  testOrder: boolean,
): (itemsValue: bigint) => bigint {
  return (itemsValue) =>
    testOrder
      ? 0n
      : commission(itemsValue > itemDiscount ? itemsValue - itemDiscount : 0n, commissionBp);
}

export interface TicketMoneyBooking {
  journals: AfterPickupJournal[];
  // What the restaurant gives back (V, before its commission's reversal) and
  // what the captain is charged, for the pushes and the ticket.
  merchantDebit: bigint;
  captainCharge: bigint;
}

// docs/domain/10: the entries of a ticket after a normal delivery. With the
// affected value `V`: the restaurant `merchant.debit` of V and a reversing
// `merchant.commission` on V (it gives back the merchant net); the captain
// `earn.charge` of the merchant net of V; the platform and the customer
// nothing. Whatever the remedy (owner decision 2026-11-17), the free
// re-delivery aside (2.23d). With the wrong change `M`: the captain
// `earn.charge` of M when the customer gets it back as a code, nothing when
// the captain returned it in person; the platform bears the code alone. The
// order is settled, so the party's side goes against
// platform.compensation_cost, recovering the remedy's cost.
export function ticketMoneyEntries(facts: {
  responsible: ResponsibleParty;
  restaurantId: string;
  captainId: string | null;
  currency: string;
  // The order's items value, the commission's base.
  itemsValue: bigint;
  // AP §8.4; zero on a test order (AP §9.6.3).
  commissionOf: (itemsValue: bigint) => bigint;
  affected: bigint;
  wrongChange: { amount: bigint; code: boolean } | null;
}): TicketMoneyBooking {
  const { currency } = facts;
  const platform = { kind: 'platform' as const, id: null };
  const merchant = { kind: 'merchant' as const, id: facts.restaurantId };
  const cost = (amount: bigint): AfterPickupEntry => ({
    account: 'platform.compensation_cost',
    party: platform,
    amount: -amount,
    currency,
  });
  const captainCharge = (amount: bigint, reason: string): AfterPickupJournal => {
    if (facts.captainId === null) throw new Error('a delivered order has a captain');
    return {
      type: 'earn.charge',
      reason,
      entries: [
        {
          account: 'captain.earnings',
          party: { kind: 'captain', id: facts.captainId },
          amount,
          currency,
        },
        cost(amount),
      ],
    };
  };
  const journals: AfterPickupJournal[] = [];
  let merchantDebit = 0n;
  let charged = 0n;
  if (facts.affected > 0n) {
    // The difference of the commissions, so it rounds once (as an edit's).
    const cut =
      facts.commissionOf(facts.itemsValue) - facts.commissionOf(facts.itemsValue - facts.affected);
    if (facts.responsible === 'restaurant') {
      merchantDebit = facts.affected;
      journals.push({
        type: 'merchant.debit',
        reason: POST_DELIVERY_PROBLEM_REASON,
        entries: [
          { account: 'merchant.account', party: merchant, amount: facts.affected, currency },
          cost(facts.affected),
        ],
      });
      if (cut > 0n) {
        journals.push({
          type: 'merchant.commission',
          reason: COMMISSION_REVERSED_REASON,
          entries: [
            { account: 'merchant.account', party: merchant, amount: -cut, currency },
            { account: 'platform.revenue_commission', party: platform, amount: cut, currency },
          ],
        });
      }
    } else if (facts.responsible === 'captain' && facts.affected > cut) {
      // The merchant net of V; nothing when its commission takes all of it
      // (a minor unit at a high rate), since the ledger takes no entry of zero.
      charged += facts.affected - cut;
      journals.push(captainCharge(facts.affected - cut, POST_DELIVERY_PROBLEM_REASON));
    }
  }
  const wrong = facts.wrongChange;
  if (wrong && wrong.code && wrong.amount > 0n && facts.responsible === 'captain') {
    charged += wrong.amount;
    journals.push(captainCharge(wrong.amount, WRONG_CHANGE_REASON));
  }
  return { journals, merchantDebit, captainCharge: charged };
}
