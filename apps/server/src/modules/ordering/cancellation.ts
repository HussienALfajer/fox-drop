import type { AccountPurpose, JournalType } from '../ledger/index.js';
import { commission } from './door-payment.js';
import type { PaymentLine } from './pickup-booking.js';
import type { cashAnswers, responsibleParties } from './schema.js';

// docs/domain/09: who is responsible for a cancellation before pickup.
export type ResponsibleParty = (typeof responsibleParties)[number];

// AP §8.1, RA §8.10: «هل أعاد المطعم المبلغ للكابتن؟», asked once the captain
// reached the restaurant: «نعم», «لا» or «لم يدفع الكابتن بعد».
export type CashAnswer = (typeof cashAnswers)[number];

// RA §16 #18, owner decision 2026-11-09: the food credit's journal carries the
// text the restaurant's account line will show (slice 2.19).
export const FOOD_CREDIT_REASON = 'تعويض عن طلب أُلغي بعد التحضير';

// What the cancellation's money and strike depend on, read from the order.
export interface CancellationFacts {
  status: 'placed' | 'accepted' | 'ready';
  restaurantId: string;
  captainId: string | null;
  // arrived_at_merchant_at is set: the cash question is asked.
  arrivedAtMerchant: boolean;
  // The base currency, the order's.
  currency: string;
  itemsValue: bigint;
  discount: bigint;
  commissionBp: number;
  testOrder: boolean;
  // Owner decision 2026-11-09: the captain's last pickup request's lines (its
  // received lines when the restaurant disputed the amount), else the items
  // value in the base currency; and their total in the base.
  cashLines: PaymentLine[];
  cashBase: bigint;
  // The pay table's base pay for the captain's vehicle; null when the order
  // kept no pay table or it has no rate for the vehicle.
  captainPay: bigint | null;
}

// AP §9.3.2 «إلغاء الطلب»: operations' choices.
export interface CancellationChoices {
  responsible: ResponsibleParty;
  foodPrepared: boolean;
  compensateCaptain: boolean;
  cash: CashAnswer | null;
}

export type CancellationProblem =
  | 'invalid_cancellation'
  | 'compensation_not_allowed'
  | 'captain_pay_unset'
  | 'cash_answer_required'
  | 'cash_answer_not_allowed';

export interface CancellationEntry {
  account: AccountPurpose;
  party: { kind: 'merchant' | 'captain' | 'platform'; id: string | null };
  // From the platform's side, as LedgerService.post takes it.
  amount: bigint;
  currency: string;
}

export interface CancellationJournal {
  type: JournalType;
  reason: string | null;
  entries: CancellationEntry[];
}

export interface Cancellation {
  journals: CancellationJournal[];
  // docs/domain/08: a late-cancellation strike on the customer.
  strike: boolean;
  merchantCredit: bigint | null;
  captainCompensation: bigint | null;
  cashAsked: boolean;
  compensationAllowed: boolean;
}

// docs/domain/01, 08, 09: every entry operations' cancellation books, shared
// by the preview and the cancellation itself, so the panel shows exactly
// what is posted. The order clearing account nets to zero over them. The
// preview (AP §9.3.2: the dialog asks before every answer is given) never
// refuses a missing cash answer or a choice the order does not allow: it
// books what is allowed and answers `cashAsked` and `compensationAllowed`,
// so the dialog knows which questions to ask; the cancellation refuses them.
export function cancellationEntries(
  facts: CancellationFacts,
  given: CancellationChoices,
  { preview = false }: { preview?: boolean } = {},
): Cancellation | { problem: CancellationProblem } {
  const placed = facts.status === 'placed';
  if (placed && (given.foodPrepared || given.compensateCaptain)) {
    return { problem: 'invalid_cancellation' };
  }
  const compensationAllowed = facts.captainId !== null && facts.arrivedAtMerchant;
  const cashAsked = facts.arrivedAtMerchant;
  if (!preview) {
    if (given.compensateCaptain && !compensationAllowed) {
      return { problem: 'compensation_not_allowed' };
    }
    if (cashAsked && given.cash === null) return { problem: 'cash_answer_required' };
    if (!cashAsked && given.cash !== null) return { problem: 'cash_answer_not_allowed' };
  }
  const choices: CancellationChoices = {
    ...given,
    compensateCaptain: given.compensateCaptain && compensationAllowed,
    cash: cashAsked ? given.cash : null,
  };
  if (choices.compensateCaptain && facts.captainPay === null) {
    return { problem: 'captain_pay_unset' };
  }

  const { currency } = facts;
  const platform = { kind: 'platform' as const, id: null };
  const merchant = { kind: 'merchant' as const, id: facts.restaurantId };
  const captain = { kind: 'captain' as const, id: facts.captainId };
  const clearing = (amount: bigint): CancellationEntry => ({
    account: 'platform.order_clearing',
    party: platform,
    amount,
    currency,
  });
  const journals: CancellationJournal[] = [];

  // docs/domain/09, owner decision 2026-11-09: food prepared and the
  // restaurant not responsible: the merchant net, borne by the platform.
  let merchantCredit: bigint | null = null;
  if (!placed && choices.foodPrepared && choices.responsible !== 'restaurant') {
    // AP §8.4: a restaurant-funded discount changes the net; codes book it
    // (Phase 2), as the delivery refuses it until then.
    if (facts.discount !== 0n) throw new Error('an order with a discount, not booked yet');
    const net = facts.testOrder
      ? facts.itemsValue
      : facts.itemsValue - commission(facts.itemsValue, facts.commissionBp);
    if (net > 0n) {
      merchantCredit = net;
      journals.push(
        {
          type: 'merchant.credit',
          reason: FOOD_CREDIT_REASON,
          entries: [
            { account: 'merchant.account', party: merchant, amount: -net, currency },
            clearing(net),
          ],
        },
        {
          type: 'platform.operating_cost',
          reason: null,
          entries: [
            { account: 'platform.operating_cost', party: platform, amount: net, currency },
            clearing(-net),
          ],
        },
      );
    }
  }

  // «تعويض الكابتن»: the base pay, borne by the platform (AP §8.9), or the
  // test cost on a test order (AP §9.6.3).
  let captainCompensation: bigint | null = null;
  if (choices.compensateCaptain && facts.captainPay !== null && facts.captainPay > 0n) {
    captainCompensation = facts.captainPay;
    journals.push({
      type: 'earn.order_pay',
      reason: null,
      entries: [
        { account: 'captain.earnings', party: captain, amount: -facts.captainPay, currency },
        {
          account: facts.testOrder ? 'platform.test_cost' : 'platform.operating_cost',
          party: platform,
          amount: facts.captainPay,
          currency,
        },
      ],
    });
  }

  // AP §8.1: the restaurant kept the captain's payment: the payment on the
  // captain's custody, and the restaurant owes it back at settlement.
  if (choices.cash === 'not_returned') {
    // Phase 1 (owner decision 2026-11-05): the pickup payment is in the base
    // currency only, so the lines and their base total net the clearing
    // account. When other currencies arrive (RA §12.7), book the gap between
    // the lines and their base total on platform.fx_rounding, as
    // PickupBooking does, before allowing them here.
    if (facts.cashLines.some((line) => line.currency !== currency)) {
      throw new Error('a kept payment outside the base currency, not booked yet');
    }
    journals.push(
      {
        type: 'custody.pay_merchant',
        reason: null,
        entries: facts.cashLines.flatMap((line) => [
          {
            account: 'captain.custody' as const,
            party: captain,
            amount: -line.amount,
            currency: line.currency,
          },
          {
            account: 'platform.order_clearing' as const,
            party: platform,
            amount: line.amount,
            currency: line.currency,
          },
        ]),
      },
      {
        type: 'merchant.debit',
        reason: null,
        entries: [
          { account: 'merchant.account', party: merchant, amount: facts.cashBase, currency },
          clearing(-facts.cashBase),
        ],
      },
    );
  }

  return {
    journals,
    strike: !placed && choices.responsible === 'customer',
    merchantCredit,
    captainCompensation,
    cashAsked,
    compensationAllowed,
  };
}
