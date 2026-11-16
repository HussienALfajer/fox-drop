import { and, gt, sql } from 'drizzle-orm';
import type { AccountPurpose, JournalType } from '../ledger/index.js';
import type { OutcomeEntry, OutcomeJournal } from './outcome.js';
import { collections, shortfallResolutions } from './schema.js';

// AP §8.6, docs/domain/06 «Payment at the door» (slice 2.20b): who bears a
// collection shortfall «نقص في التحصيل». Never the restaurant, which was
// paid in full at the pickup.
export const shortfallParties = ['captain', 'customer', 'platform'] as const;
export type ShortfallParty = (typeof shortfallParties)[number];

// The reason of the resolution's journal, also the captain's charge push's
// «{السبب}» (CA §14 #14) and the dues line (AP §9.1.3's alert name).
export const SHORTFALL_REASON = 'نقص في التحصيل';

// What the resolution's money depends on: the collection's shortfall, in
// the base currency, and the parties of the order.
export interface ShortfallFacts {
  amount: bigint;
  currency: string;
  // The captain who collected (the collection's, after a handover too).
  captainId: string;
  customerAccountId: string;
  testOrder: boolean;
}

export interface ShortfallBooking {
  journals: OutcomeJournal[];
  // CA §14 #14's amount, set only with the captain responsible.
  captainCharge: bigint | null;
  // AP §8.8: the customer's dues, set only with the customer responsible.
  dues: bigint | null;
}

// AP §8.6: the §8.9 effects on the missing amount only. The delivery left
// the shortfall on the order clearing account; one journal moves it to the
// captain's earnings (earn.charge), the customer's dues (dues.charge, which
// blocks ordering until paid; no fake-order rule, strike or trust change) or
// the platform's operating cost (test cost on a test order). Shared by the
// preview and the resolution, so the panel shows exactly what is posted.
export function shortfallEntries(facts: ShortfallFacts, party: ShortfallParty): ShortfallBooking {
  if (facts.amount <= 0n) throw new Error('a collection with no shortfall');
  const { amount, currency } = facts;
  const platform = { kind: 'platform' as const, id: null };
  const entry = (
    account: AccountPurpose,
    who: OutcomeEntry['party'],
    value: bigint,
  ): OutcomeEntry => ({ account, party: who, amount: value, currency });
  const clearing = entry('platform.order_clearing', platform, -amount);
  const journal = (type: JournalType, debit: OutcomeEntry): OutcomeJournal => ({
    type,
    reason: SHORTFALL_REASON,
    entries: [debit, clearing],
  });
  if (party === 'captain') {
    return {
      journals: [
        journal(
          'earn.charge',
          entry('captain.earnings', { kind: 'captain', id: facts.captainId }, amount),
        ),
      ],
      captainCharge: amount,
      dues: null,
    };
  }
  if (party === 'customer') {
    return {
      journals: [
        journal(
          'dues.charge',
          entry('customer.dues', { kind: 'customer', id: facts.customerAccountId }, amount),
        ),
      ],
      captainCharge: null,
      dues: amount,
    };
  }
  const cost: AccountPurpose & JournalType = facts.testOrder
    ? 'platform.test_cost'
    : 'platform.operating_cost';
  return {
    journals: [journal(cost, entry(cost, platform, amount))],
    captainCharge: null,
    dues: null,
  };
}

// A collection short beyond rounding that operations have not resolved yet:
// «نقص في التحصيل» is open on the order, the dashboard and the alerts.
export const shortfallOpen = and(
  gt(collections.shortfall, 0n),
  sql`NOT EXISTS (SELECT 1 FROM ${shortfallResolutions} WHERE ${shortfallResolutions.orderId} = ${collections.orderId})`,
);
