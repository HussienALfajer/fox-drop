import type { AccountPurpose, JournalType } from '../ledger/index.js';
import type { ResponsibleParty } from './cancellation.js';
import { commission } from './door-payment.js';
import type { orderOutcomes, outcomeFoods } from './schema.js';

export type OrderOutcome = (typeof orderOutcomes)[number];
// The outcomes «تحديد النتيجة» sets: every one but normal.
export type SetOutcome = Exclude<OrderOutcome, 'normal'>;
export type OutcomeFood = (typeof outcomeFoods)[number];

// AP Appendix C: the outcomes' labels, also the reason of the captain's charge
// (CA §14 #14 «خُصم من مستحقاتك {المبلغ}: {السبب}»).
export const OUTCOME_LABELS: Record<OrderOutcome, string> = {
  normal: 'عادي',
  free: 'مجاني',
  fake: 'وهمي',
  damaged: 'تالف',
  wrong_refused: 'خطأ ورفضه الزبون',
  failed_other: 'تعذّر التسليم',
};

// RA §12.5: the restaurant's account line when it returns the pickup payment.
export const PICKUP_RETURNED_REASON = 'استرداد مبلغ الاستلام';
// The line of a charge from an edit after the pickup given back because the
// restaurant was responsible for the order (to confirm with the owner).
export const CHARGE_RETURNED_REASON = 'إلغاء خصم: المطعم مسؤول عن الطلب';
// A lower fee an edit after the pickup charged, given back since the outcome
// books no delivery revenue (to confirm with the owner).
export const FEE_CUT_RETURNED_REASON = 'إلغاء خصم أجرة التوصيل: لم يُسلَّم الطلب كالمعتاد';
// The commission the restaurant's own edits reversed, restored when it is
// responsible for the order (to confirm with the owner).
export const COMMISSION_RESTORED_REASON = 'إلغاء استرداد العمولة: المطعم مسؤول عن الطلب';

// What the customer paid offsetting the captain's pay when the restaurant is
// responsible (docs/domain/09 rule 5; slice 2.11b, to confirm with the
// owner).
export const PAY_OFFSET_REASON = 'ما دفعه الزبون يغطّي أجر الكابتن';

// AP §8.9 «تغيير النتيجة» (slice 2.11c): the reason of each reversal of the
// old outcome's journals (to confirm with the owner).
export const OUTCOME_CHANGE_REASON = 'تغيير النتيجة';

const FAILED_ONLY: readonly SetOutcome[] = ['fake', 'wrong_refused', 'failed_other'];

export type DuesRule = 'fee_plus_merchant_net' | 'fee_plus_items_value' | 'fixed';

// What the outcome's money depends on, read from the order under its lock.
export interface OutcomeFacts {
  restaurantId: string;
  captainId: string;
  customerAccountId: string;
  // The base currency, the order's.
  currency: string;
  testOrder: boolean;
  // AP §8.4: the order's commission rate, null on a test order.
  commissionBp: number | null;
  // The order now, after any edit after the pickup.
  itemsValue: bigint;
  deliveryFee: bigint;
  discount: bigint;
  // The customer total now, which an amount to collect stays below.
  total: bigint;
  // What the pickup paid and what the edits after it already booked against
  // the order clearing account (`frozenAtPickup`): each party's charges, and
  // the commission the restaurant's own edits reversed.
  pickup: {
    itemsValue: bigint;
    restaurantCharge: bigint;
    restaurantCommissionCut: bigint;
    captainCharge: bigint;
    platformCharge: bigint;
    // The part of each party's charges that was a lower fee.
    feeCuts: { restaurant: bigint; captain: bigint; platform: bigint };
  };
  // The captain's pay by the order's pay table (CA §9.8), null when it has no
  // rate for the captain's vehicle.
  pay: { orderPay: bigint; waiting: bigint } | null;
  // customer.fake_order_dues_rule and customer.fake_order_dues_fixed.
  duesRule: { kind: DuesRule; fixed: bigint | null };
}

// AP §9.3.2 «تحديد النتيجة»: operations' choices. `delivered` says whether a
// damaged order was delivered with a reduction or failed; free is always
// delivered, the other outcomes always failed. `amountToCollect`, in the base
// currency, is what the customer still pays (K9): only on a delivered
// outcome, below the order total (owner decisions 2026-11-10).
export interface OutcomeChoices {
  outcome: OrderOutcome;
  responsible: ResponsibleParty;
  delivered: boolean;
  food: OutcomeFood | null;
  amountToCollect: bigint;
}

export type OutcomeProblem = 'invalid_outcome' | 'dues_rule_unset' | 'captain_pay_unset';

export interface OutcomeEntry {
  account: AccountPurpose;
  party: { kind: 'merchant' | 'captain' | 'customer' | 'platform'; id: string | null };
  // From the platform's side, as LedgerService.post takes it.
  amount: bigint;
  currency: string;
}

export interface OutcomeJournal {
  type: JournalType;
  reason: string | null;
  entries: OutcomeEntry[];
}

export interface OutcomeBooking {
  status: 'delivered' | 'failed';
  journals: OutcomeJournal[];
  // docs/domain/09 rule 3: what the responsible party bears for the food.
  loss: bigint;
  // AP §8.8: the customer's dues, set only with the customer responsible.
  dues: bigint | null;
  // RA §12.5 «استرداد مبلغ الاستلام»: what the restaurant now owes for the
  // order, the pickup payment returned and any reversed commission restored,
  // set only with the restaurant responsible (RA §16 #19's amount).
  merchantDebit: bigint | null;
  captainPay: bigint;
}

// docs/domain/09: the one rule of every non-normal outcome's money, shared by
// the preview and «تحديد النتيجة», so the panel shows exactly what is posted.
// The pickup put the items value on the order clearing account and the edits
// after it took their charges off it; the collection of an amount to collect
// (slice 2.11b, K9) took what the customer paid off it, its custody lines
// being the collection's own (rule 1). These journals take the rest back to
// zero (owner decision 2026-11-10: nobody pays twice). A collection short of
// the amount beyond rounding leaves the shortfall on the clearing account for
// its own flow (AP §8.6), so the amount is what these journals count.
export function outcomeEntries(
  facts: OutcomeFacts,
  choices: OutcomeChoices,
): OutcomeBooking | { problem: OutcomeProblem } {
  const { outcome, responsible } = choices;
  if (outcome === 'normal') return { problem: 'invalid_outcome' };
  if ((outcome === 'fake') !== (responsible === 'customer')) return { problem: 'invalid_outcome' };
  if (outcome === 'free' && !choices.delivered) return { problem: 'invalid_outcome' };
  if (FAILED_ONLY.includes(outcome) && choices.delivered) return { problem: 'invalid_outcome' };
  // CA §9.12, K10: where the food went, for a failed order only, and back to
  // the restaurant only when it is responsible.
  if (choices.delivered !== (choices.food === null)) return { problem: 'invalid_outcome' };
  if (choices.food === 'returned_to_restaurant' && responsible !== 'restaurant') {
    return { problem: 'invalid_outcome' };
  }
  const collected = choices.amountToCollect;
  if (collected < 0n || (collected > 0n && (!choices.delivered || collected >= facts.total))) {
    return { problem: 'invalid_outcome' };
  }
  if (facts.pay === null && responsible !== 'captain') return { problem: 'captain_pay_unset' };
  // AP §8.4: a discount needs its share booked; codes come in Phase 2, as
  // the delivery refuses it until then.
  if (facts.discount !== 0n) throw new Error('an order with a discount, not booked yet');

  const { currency, pickup } = facts;
  const platform = { kind: 'platform' as const, id: null };
  const merchant = { kind: 'merchant' as const, id: facts.restaurantId };
  const captain = { kind: 'captain' as const, id: facts.captainId };
  const customer = { kind: 'customer' as const, id: facts.customerAccountId };
  const entry = (
    account: AccountPurpose,
    party: OutcomeEntry['party'],
    amount: bigint,
  ): OutcomeEntry => ({ account, party, amount, currency });
  const clearing = (amount: bigint) => entry('platform.order_clearing', platform, amount);
  // The platform's cost account and its journal type share the name.
  const platformCost: AccountPurpose & JournalType = facts.testOrder
    ? 'platform.test_cost'
    : 'platform.operating_cost';
  const journals: OutcomeJournal[] = [];
  const push = (type: JournalType, reason: string | null, entries: OutcomeEntry[]) => {
    const nonZero = entries.filter((each) => each.amount !== 0n);
    if (nonZero.length > 0) journals.push({ type, reason, entries: nonZero });
  };
  let loss = 0n;
  let dues: bigint | null = null;
  let merchantDebit: bigint | null = null;
  // What the customer paid beyond what the journals below settle, booked as
  // delivery revenue at the end; with the restaurant responsible it first
  // offsets the captain's pay (rule 5).
  let surplus: bigint;

  if (responsible === 'restaurant') {
    // Rule 5: the restaurant returns the pickup payment, less what its edits
    // after the pickup already debited, and posts no commission: the
    // commission its edits reversed is restored, so it ends with nothing.
    const returned = pickup.itemsValue - pickup.restaurantCharge;
    merchantDebit = returned + pickup.restaurantCommissionCut;
    push('merchant.debit', PICKUP_RETURNED_REASON, [
      entry('merchant.account', merchant, returned),
      clearing(-returned),
    ]);
    push('merchant.commission', COMMISSION_RESTORED_REASON, [
      entry('merchant.account', merchant, pickup.restaurantCommissionCut),
      entry('platform.revenue_commission', platform, -pickup.restaurantCommissionCut),
    ]);
    // What the captain or the platform bore for an edit is given back, since
    // the restaurant returns the whole payment.
    push('earn.charge', CHARGE_RETURNED_REASON, [
      entry('captain.earnings', captain, -pickup.captainCharge),
      clearing(pickup.captainCharge),
    ]);
    // An edit's platform cost was always booked as operating cost.
    push('platform.operating_cost', CHARGE_RETURNED_REASON, [
      entry('platform.operating_cost', platform, -pickup.platformCharge),
      clearing(pickup.platformCharge),
    ]);
    surplus = collected;
  } else {
    // No delivery fee is booked on such an outcome, so a lower fee an edit
    // after the pickup charged to its party is given back (nobody pays for a
    // fee nobody collects).
    const { feeCuts } = pickup;
    push('merchant.debit', FEE_CUT_RETURNED_REASON, [
      entry('merchant.account', merchant, -feeCuts.restaurant),
      clearing(feeCuts.restaurant),
    ]);
    push('earn.charge', FEE_CUT_RETURNED_REASON, [
      entry('captain.earnings', captain, -feeCuts.captain),
      clearing(feeCuts.captain),
    ]);
    push('platform.operating_cost', FEE_CUT_RETURNED_REASON, [
      entry('platform.operating_cost', platform, -feeCuts.platform),
      clearing(feeCuts.platform),
    ]);
    // Rule 2: the commission as usual, on the pickup's items value, less
    // the restaurant's own reversals; against the order clearing account,
    // where it recovers part of the pickup payment (rule 3).
    const full =
      facts.commissionBp === null ? 0n : commission(pickup.itemsValue, facts.commissionBp);
    push('merchant.commission', null, [
      entry('merchant.account', merchant, full),
      entry('platform.revenue_commission', platform, -pickup.restaurantCommissionCut),
      clearing(-(full - pickup.restaurantCommissionCut)),
    ]);
    // Rule 3: what the order clearing account still holds is the loss: the
    // merchant net of the items still in the order, never below zero.
    const itemCharges =
      pickup.restaurantCharge +
      pickup.captainCharge +
      pickup.platformCharge -
      (feeCuts.restaurant + feeCuts.captain + feeCuts.platform);
    const left = pickup.itemsValue - itemCharges - (full - pickup.restaurantCommissionCut);
    if (left < 0n) throw new Error('the order clearing account would not settle');
    // Rule 3: the loss less what the customer paid, floored at zero.
    loss = left > collected ? left - collected : 0n;
    surplus = collected - (left - loss);
    if (responsible === 'captain') {
      push('earn.charge', OUTCOME_LABELS[outcome], [
        entry('captain.earnings', captain, loss),
        clearing(-loss),
      ]);
    } else if (responsible === 'platform') {
      push(platformCost, null, [entry(platformCost, platform, loss), clearing(-loss)]);
    } else {
      const amount = duesAmount(facts);
      if (amount === null) return { problem: 'dues_rule_unset' };
      dues = amount;
      const recovered = amount < loss ? amount : loss;
      push('dues.charge', null, [
        entry('customer.dues', customer, amount),
        clearing(-recovered),
        entry('platform.revenue_delivery', platform, -(amount - recovered)),
      ]);
      push(platformCost, null, [
        entry(platformCost, platform, loss - recovered),
        clearing(-(loss - recovered)),
      ]);
    }
  }

  // Rule 4: the captain is paid unless responsible; the platform bears the
  // pay when it or the restaurant is responsible, the captain pay account
  // otherwise. Rule 5: with the restaurant responsible, what the customer
  // paid offsets the pay first.
  let captainPay = 0n;
  if (responsible !== 'captain' && facts.pay !== null) {
    const counter: AccountPurpose = facts.testOrder
      ? 'platform.test_cost'
      : responsible === 'customer'
        ? 'platform.captain_pay'
        : 'platform.operating_cost';
    for (const [type, amount] of [
      ['earn.order_pay', facts.pay.orderPay],
      ['earn.waiting_pay', facts.pay.waiting],
    ] as const) {
      push(type, null, [
        entry('captain.earnings', captain, -amount),
        entry(counter, platform, amount),
      ]);
      captainPay += amount;
    }
    if (responsible === 'restaurant') {
      // The pay's counter is the platform's cost (the ledger takes no pay
      // against the clearing account), which the customer's money lowers.
      const offset = surplus < captainPay ? surplus : captainPay;
      push(platformCost, PAY_OFFSET_REASON, [
        entry(platformCost, platform, -offset),
        clearing(offset),
      ]);
      surplus -= offset;
    }
  }
  push('platform.revenue_delivery', null, [
    clearing(surplus),
    entry('platform.revenue_delivery', platform, -surplus),
  ]);

  return {
    status: choices.delivered ? 'delivered' : 'failed',
    journals,
    loss,
    dues,
    merchantDebit,
    captainPay,
  };
}

// What the journals give the captain's earnings (the pay, a charge below 0,
// an edit's charge given back), from the captain's view; «تغيير النتيجة»
// tells the captain when it moves (slice 2.11c).
export function captainNet(journals: readonly Pick<OutcomeJournal, 'entries'>[]): bigint {
  return journals
    .flatMap((journal) => journal.entries)
    .filter((entry) => entry.account === 'captain.earnings')
    .reduce((sum, entry) => sum - entry.amount, 0n);
}

// The outcome in force on a finished order, as «تغيير النتيجة» reads it.
// `posted` is false while it waits for its collection (K9) and for an outcome
// posted before slice 2.11c kept its journals, which cannot be reversed.
export interface CurrentOutcome {
  outcome: SetOutcome;
  responsible: ResponsibleParty;
  status: 'delivered' | 'failed';
  food: OutcomeFood | null;
  amountToCollect: bigint;
  // The order's first outcome: the days count from it, not from a change.
  firstSetAt: Date;
  posted: boolean;
}

export type OutcomeChangeProblem = 'outcome_change_closed' | 'invalid_outcome';

const DAY_MS = 24 * 60 * 60 * 1000;

// AP §8.9 «Changing an outcome», AP §9.3.2 «تغيير النتيجة» (slice 2.11c,
// owner decisions 2026-11-10): within order.outcome_change_days of the first
// outcome, as often as needed, to another outcome, party or food. The amount
// collected stays (its custody lines are cash that really moved), so the new
// outcome counts the same amount, which outcomeEntries allows on a delivered
// outcome only.
export function outcomeChangeProblem(
  current: CurrentOutcome,
  choices: OutcomeChoices,
  now: Date,
  changeDays: number,
): OutcomeChangeProblem | null {
  if (!current.posted) return 'outcome_change_closed';
  if (now > outcomeChangeUntil(current.firstSetAt, changeDays)) return 'outcome_change_closed';
  if (choices.amountToCollect !== current.amountToCollect) return 'invalid_outcome';
  const same =
    choices.outcome === current.outcome &&
    choices.responsible === current.responsible &&
    choices.delivered === (current.status === 'delivered') &&
    choices.food === current.food;
  return same ? 'invalid_outcome' : null;
}

// The last moment «تغيير النتيجة» is open.
export function outcomeChangeUntil(firstSetAt: Date, changeDays: number): Date {
  return new Date(firstSetAt.getTime() + changeDays * DAY_MS);
}

// AP §8.8 customer.fake_order_dues_rule, in the base currency: the fee plus
// the merchant net (the items value less the commission, the whole value on a
// test order), the fee plus the items value, or the fixed amount OWN set
// (null while unset).
function duesAmount(facts: OutcomeFacts): bigint | null {
  const { kind, fixed } = facts.duesRule;
  if (kind === 'fixed') return fixed !== null && fixed > 0n ? fixed : null;
  if (kind === 'fee_plus_items_value') return facts.deliveryFee + facts.itemsValue;
  const net =
    facts.commissionBp === null
      ? facts.itemsValue
      : facts.itemsValue - commission(facts.itemsValue, facts.commissionBp);
  return facts.deliveryFee + net;
}
