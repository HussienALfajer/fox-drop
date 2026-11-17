import type { NodePgDatabase } from 'drizzle-orm/node-postgres';
import type { LedgerActor } from '../ledger/index.js';

type Tx = Parameters<Parameters<NodePgDatabase['transaction']>[0]>[0];

// A currency line in minor units.
export interface MoneyLine {
  currency: string;
  amount: bigint;
}

// What the pickup-dispute ticket shows (AP §9.9.3): the pickup payment, the
// captain's payment lines, the lines the restaurant says it received, and
// how the pickup was confirmed.
export interface PickupDisputeFacts {
  pickupPayment: MoneyLine;
  recorded: MoneyLine[];
  received: MoneyLine[];
  // Who disputed (slice 2.24c): the restaurant, or the captain, whose
  // `received` is what they say they handed over.
  openedBy: 'restaurant' | 'captain';
  confirmedBy: 'restaurant' | 'automatic' | 'operations';
  captainId: string;
  captainName: string | null;
  disputedAt: Date;
  // The order's currencies, which the corrected lines may use.
  currencies: string[];
}

export interface CorrectionEntry {
  type: string;
  reason: string | null;
  account: string;
  party: { kind: 'merchant' | 'captain' | 'platform'; id: string | null; name: string | null };
  amount: MoneyLine;
}

// «تصحيح في الحسابات» before it is posted: the captain's custody change per
// currency (+ hands in, − reimbursed), D in the base (+ a credit to the
// restaurant, − a debit) and every entry.
export interface PickupCorrectionPreview {
  captainChanges: MoneyLine[];
  merchant: MoneyLine;
  entries: CorrectionEntry[];
}

// The pickup dispute's side that only ordering can read and post (it owns
// the order, its pickup and its rates): ordering registers it with
// SupportService.usePickupDisputes at start, as dispatch registers its views
// with ordering. The refusals are TicketRefusedError: invalid_lines,
// no_difference.
export interface PickupDisputes {
  facts(disputeId: string): Promise<PickupDisputeFacts>;
  preview(disputeId: string, received: MoneyLine[], now: Date): Promise<PickupCorrectionPreview>;
  // In the resolution's transaction: the journals with the order as their
  // source, and the captain's silent push of the change; answers the
  // journals' ids.
  correct(
    tx: Tx,
    input: { disputeId: string; received: MoneyLine[]; actor: LedgerActor; now: Date },
  ): Promise<string[]>;
}
