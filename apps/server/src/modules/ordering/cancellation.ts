import { type RateSnapshot, toBase } from '../fx/index.js';
import type { AccountPurpose, JournalRate, JournalType } from '../ledger/index.js';
import { commission } from './door-payment.js';
import { journalRates } from './journal-rates.js';
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
  // The order's rates (AP §8.6), which convert a line in another currency.
  snapshot: RateSnapshot;
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
  // A journal across currencies: the order's rate versions (AP §8.6).
  rates?: JournalRate[] | undefined;
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

  // AP §8.1: the restaurant kept the captain's payment.
  if (choices.cash === 'not_returned') journals.push(...keptPaymentJournals(facts));

  return {
    journals,
    strike: !placed && choices.responsible === 'customer',
    merchantCredit,
    captainCompensation,
    cashAsked,
    compensationAllowed,
  };
}

// AP §8.1, docs/domain/01: the restaurant kept the captain's payment («لا»
// to «هل أعاد المطعم المبلغ للكابتن؟»): the payment on the captain's
// custody, and the restaurant owes it back at settlement. Shared by the
// cancellation and the reassignment (slice 2.12a); the order clearing
// account nets to zero over them.
export function keptPaymentJournals(
  facts: Pick<
    CancellationFacts,
    'restaurantId' | 'captainId' | 'currency' | 'cashLines' | 'cashBase' | 'snapshot'
  >,
): CancellationJournal[] {
  const { currency, snapshot } = facts;
  const platform = { kind: 'platform' as const, id: null };
  // RA §12.7: a line in another currency is brought into the base at the
  // order's rates, as the pickup does, so the clearing account nets in the
  // base against the restaurant's debit of the lines' base total.
  const conversion: CancellationEntry[] = [];
  let inBase = 0n;
  for (const line of facts.cashLines) {
    if (line.currency === currency) continue;
    conversion.push(
      {
        account: 'platform.order_clearing',
        party: platform,
        amount: -line.amount,
        currency: line.currency,
      },
      {
        account: 'platform.fx_rounding',
        party: platform,
        amount: line.amount,
        currency: line.currency,
      },
    );
    inBase += toBase(snapshot, line.amount, line.currency);
  }
  if (inBase !== 0n) {
    conversion.push(
      { account: 'platform.order_clearing', party: platform, amount: inBase, currency },
      { account: 'platform.fx_rounding', party: platform, amount: -inBase, currency },
    );
  }
  const paid: CancellationEntry[] = facts.cashLines.flatMap((line) => [
    {
      account: 'captain.custody' as const,
      party: { kind: 'captain' as const, id: facts.captainId },
      amount: -line.amount,
      currency: line.currency,
    },
    {
      account: 'platform.order_clearing' as const,
      party: platform,
      amount: line.amount,
      currency: line.currency,
    },
  ]);
  return [
    {
      type: 'custody.pay_merchant',
      reason: null,
      entries: paid,
      rates: journalRates(snapshot, paid),
    },
    ...(conversion.length > 0
      ? [
          {
            type: 'platform.fx_rounding' as const,
            reason: null,
            entries: conversion,
            rates: journalRates(snapshot, conversion),
          },
        ]
      : []),
    {
      type: 'merchant.debit',
      reason: null,
      entries: [
        {
          account: 'merchant.account',
          party: { kind: 'merchant', id: facts.restaurantId },
          amount: facts.cashBase,
          currency,
        },
        { account: 'platform.order_clearing', party: platform, amount: -facts.cashBase, currency },
      ],
    },
  ];
}
