// The ledger's accounts and journal types (AP §8.5, §8.7, §8.11; architecture
// §5.6; owner decisions 2026-11-05).
//
// Amounts are stored from the platform's side: a positive amount is a debit
// (the platform holds or is owed more, or spent more), a negative one a
// credit. Every journal sums to zero per currency. A balance is shown as the
// specs state it, from the party's view: the sum of the entries times the
// account's sign.

interface Purpose {
  // Whose account it is: an account of a captain or a restaurant names the
  // record that owns it; so does each drawer's cash. The other platform
  // accounts are one per city and currency.
  owned: boolean;
  sign: 1n | -1n;
}

export const accountPurposes = {
  // AP §8.5.1: + the captain must hand cash in, − the platform owes them.
  'captain.custody': { owned: true, sign: 1n },
  // AP §8.5.2: + what the platform owes the captain for their work.
  'captain.earnings': { owned: true, sign: -1n },
  // The kit deposit held for the captain, paid back at termination (AP §9.10.3).
  'captain.deposit': { owned: true, sign: -1n },
  // AP §8.8 «مستحقات الزبون», in the base currency: + the customer owes the
  // platform. Owned by the customer's account.
  'customer.dues': { owned: true, sign: 1n },
  // AP §8.7: − the restaurant owes the platform, + the platform owes it.
  'merchant.account': { owned: true, sign: -1n },
  // AP §8.11, revenues shown positive.
  'platform.revenue_commission': { owned: false, sign: -1n },
  'platform.revenue_delivery': { owned: false, sign: -1n },
  // AP §8.11, costs shown positive.
  'platform.discount_cost': { owned: false, sign: 1n },
  'platform.compensation_cost': { owned: false, sign: 1n },
  'platform.operating_cost': { owned: false, sign: 1n },
  'platform.captain_pay': { owned: false, sign: 1n },
  'platform.test_cost': { owned: false, sign: 1n },
  // AP §8.11: rounding and exchange differences, + a gain for the platform.
  'platform.fx_rounding': { owned: false, sign: -1n },
  // «طلبات قيد التسليم»: the items value paid to restaurants and not yet
  // settled by the order's other entries. Each order's entries here sum to
  // zero once its money is settled.
  'platform.order_clearing': { owned: false, sign: 1n },
  // «القيود التصحيحية»: the platform's side of every manual correction
  // (AP §9.10.7), + a gain for the platform.
  'platform.adjustments': { owned: false, sign: -1n },
  // The cash in one cash-desk drawer (architecture §5.6), per currency.
  'platform.cash': { owned: true, sign: 1n },
} as const satisfies Record<string, Purpose>;

export type AccountPurpose = keyof typeof accountPurposes;
export const accountPurposeNames = Object.keys(accountPurposes) as AccountPurpose[];
export const ownedPurposes = accountPurposeNames.filter(
  (purpose) => accountPurposes[purpose].owned,
);
// The accounts of a party, as opposed to the platform's: one journal reaches
// one party's accounts only.
export const partyPurposes = ownedPurposes.filter((purpose) => !purpose.startsWith('platform.'));

export interface JournalRule {
  // The account the type is named for, and the accounts that may take its
  // other side.
  account: AccountPurpose;
  counters: readonly AccountPurpose[];
  // Accounts the journal must reach besides its own.
  requires?: readonly AccountPurpose[];
  // The journal converts between two currencies or more.
  crossCurrency?: true;
  // The journal says why (AP §8.5.2, §9.10.7).
  reason?: true;
}

const orderCounter = ['platform.order_clearing'] as const;
// Desk journals move a drawer's cash. A payment in another currency than the
// account's converts at the current rate through platform.fx_rounding, one
// entry per currency; fx_rounding takes the other side of a party's journal
// only when the journal spans two currencies or more.
const desk = { counters: ['platform.cash'], requires: ['platform.cash'] } as const;
const deskInAnyCurrency = {
  counters: ['platform.cash', 'platform.fx_rounding'],
  requires: ['platform.cash'],
} as const;
const adjustment = { counters: ['platform.adjustments'], reason: true } as const;
const captainPayCounter = [
  'platform.captain_pay',
  // Captain pay borne by the platform under AP §8.9, and on test orders.
  'platform.operating_cost',
  'platform.test_cost',
] as const;
// After a normal delivery the order is settled; a ticket's charge or debit
// (AP §8.10) recovers the cost of its remedy instead.
const orderOrTicketCounter = ['platform.order_clearing', 'platform.compensation_cost'] as const;

// One journal per entry type of AP §8.5 and §8.7, plus the types that book an
// order's platform money (AP §8.11) against the order clearing account.
export const journalRules = {
  'custody.collect': { account: 'captain.custody', counters: orderCounter },
  'custody.change_given': { account: 'captain.custody', counters: orderCounter },
  'custody.pay_merchant': { account: 'captain.custody', counters: orderCounter },
  'custody.hand_in': { account: 'captain.custody', ...desk },
  'custody.reimburse': { account: 'captain.custody', ...desk },
  // Between two currencies of the same captain's custody (AP §9.10.3).
  'custody.fx_convert': {
    account: 'captain.custody',
    counters: ['platform.fx_rounding'],
    requires: ['platform.fx_rounding'],
    crossCurrency: true,
  },
  'custody.pickup_correction': { account: 'captain.custody', counters: orderCounter },
  'custody.adjustment': { account: 'captain.custody', ...adjustment },
  'earn.order_pay': { account: 'captain.earnings', counters: captainPayCounter },
  'earn.waiting_pay': { account: 'captain.earnings', counters: captainPayCounter },
  'earn.peak_bonus': { account: 'captain.earnings', counters: captainPayCounter },
  'earn.bonus': { account: 'captain.earnings', counters: ['platform.captain_pay'], reason: true },
  'earn.charge': { account: 'captain.earnings', counters: orderOrTicketCounter },
  'earn.deposit_instalment': { account: 'captain.earnings', counters: ['captain.deposit'] },
  'earn.payout': { account: 'captain.earnings', ...deskInAnyCurrency },
  'earn.adjustment': { account: 'captain.earnings', ...adjustment },
  // Revenue on a normal order. On an order that failed after pickup it
  // recovers part of the pickup payment instead, so the platform's loss is
  // the merchant net (AP §8.9 rule 3), and it goes to the order clearing
  // account.
  'merchant.commission': {
    account: 'merchant.account',
    counters: ['platform.revenue_commission', 'platform.order_clearing'],
  },
  'merchant.discount_share': { account: 'merchant.account', counters: orderCounter },
  'merchant.credit': { account: 'merchant.account', counters: orderCounter },
  'merchant.debit': { account: 'merchant.account', counters: orderOrTicketCounter },
  'merchant.settlement': { account: 'merchant.account', ...deskInAnyCurrency },
  'merchant.adjustment': { account: 'merchant.account', ...adjustment },
  // AP §8.8, §8.9: a fake order's dues recover the loss on the order
  // clearing account; what they charge beyond it (the fee, by
  // customer.fake_order_dues_rule) is the delivery's revenue.
  'dues.charge': {
    account: 'customer.dues',
    counters: ['platform.order_clearing', 'platform.revenue_delivery'],
  },
  'platform.revenue_delivery': { account: 'platform.revenue_delivery', counters: orderCounter },
  'platform.discount_cost': { account: 'platform.discount_cost', counters: orderCounter },
  'platform.compensation_cost': {
    account: 'platform.compensation_cost',
    counters: orderCounter,
  },
  'platform.operating_cost': { account: 'platform.operating_cost', counters: orderCounter },
  'platform.test_cost': { account: 'platform.test_cost', counters: orderCounter },
  'platform.fx_rounding': { account: 'platform.fx_rounding', counters: orderCounter },
} as const satisfies Record<string, JournalRule>;

export type JournalType = keyof typeof journalRules;
export const journalTypeNames = Object.keys(journalRules) as JournalType[];
export const journalTypesWithReason = journalTypeNames.filter(
  (type) => (journalRules[type] as JournalRule).reason,
);

export const actorTypes = ['admin', 'merchant', 'captain', 'customer', 'system'] as const;
export type ActorType = (typeof actorTypes)[number];

// The kinds of record a journal comes from. An order's journals are the only
// ones that touch the order clearing account.
export const sourceKinds = ['order'] as const;
export type SourceKind = (typeof sourceKinds)[number];
