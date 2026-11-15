import type { AccountEntry } from '../ledger/index.js';
import type { OrderPickup } from '../ordering/index.js';
import type { merchantExceptionCauses } from './schema.js';

// The restaurant's weekly statement (AP §8.7, RA §12.3, §12.5; slice 2.19a):
// the pure rule that turns the period's merchant.account entries into the
// statement's lines and totals. Every amount here is from the restaurant's
// side as the statement reads: + the restaurant owes, − the platform owes it
// (the ledger's party view negated).

export type ExceptionCause = (typeof merchantExceptionCauses)[number];

export interface StatementOrderLine {
  kind: 'order';
  at: Date;
  orderId: string;
  orderNumber: bigint | null;
  // The pickup payment in the base and the currency lines the captain paid,
  // null without a confirmed pickup.
  itemsValue: bigint | null;
  pickupLines: { currency: string; amount: bigint }[] | null;
  commission: bigint;
  discountShare: bigint;
}

export interface StatementEntryLine {
  kind: 'exception' | 'payment';
  at: Date;
  orderId: string | null;
  orderNumber: bigint | null;
  cause: ExceptionCause | null;
  amount: bigint;
  reason: string | null;
  journalId: string;
}

export type StatementLine = StatementOrderLine | StatementEntryLine;

export interface StatementTotals {
  orders: number;
  itemsValue: bigint;
  commission: bigint;
  discountShare: bigint;
  exceptions: bigint;
  weekTotal: bigint;
  previousDue: bigint;
  // + the restaurant paid, − it was paid.
  paid: bigint;
  earlierUnpaid: bigint;
  totalDue: bigint;
}

export interface BuiltStatement {
  totals: StatementTotals;
  lines: StatementLine[];
  journalIds: string[];
}

// RA §12.5: what an entry is, from its type, reason and side (ordering's
// merchantEntryCause, which owns the reasons it posts with).
export type CauseOf = (
  type: string,
  reason: string | null,
  owes: bigint,
) => 'order' | ExceptionCause;

// The statement of a period: each order with its own commission or discount
// share (cause `order`), in the order of its first such entry; every other
// entry an exception (a credit, a debit, a reversal, a restored commission,
// a correction) or a payment (merchant.settlement), in the ledger's order.
export function buildStatement(
  entries: readonly AccountEntry[],
  previousDue: bigint,
  pickups: ReadonlyMap<string, OrderPickup>,
  causeOf: CauseOf,
): BuiltStatement {
  const lines: StatementLine[] = [];
  const orderLines = new Map<string, StatementOrderLine>();
  let commission = 0n;
  let discountShare = 0n;
  let exceptions = 0n;
  let paid = 0n;
  for (const entry of entries) {
    const owes = -entry.amount;
    const orderId = entry.sourceKind === 'order' ? entry.sourceId : null;
    const payment = entry.type === 'merchant.settlement';
    const cause = payment ? null : causeOf(entry.type, entry.reason, owes);
    if (cause === 'order' && orderId !== null) {
      let line = orderLines.get(orderId);
      if (!line) {
        const pickup = pickups.get(orderId);
        line = {
          kind: 'order',
          at: entry.createdAt,
          orderId,
          orderNumber: pickup?.number ?? null,
          itemsValue: pickup?.pickup?.amount ?? null,
          pickupLines: pickup?.pickup?.lines ?? null,
          commission: 0n,
          discountShare: 0n,
        };
        orderLines.set(orderId, line);
        lines.push(line);
      }
      if (entry.type === 'merchant.commission') {
        line.commission += owes;
        commission += owes;
      } else {
        line.discountShare += owes;
        discountShare += owes;
      }
      continue;
    }
    if (payment) paid -= owes;
    else exceptions += owes;
    lines.push({
      kind: payment ? 'payment' : 'exception',
      at: entry.createdAt,
      orderId,
      orderNumber: orderId === null ? null : (pickups.get(orderId)?.number ?? null),
      cause: cause === 'order' ? 'debit' : cause,
      amount: owes,
      reason: entry.reason,
      journalId: entry.journalId,
    });
  }
  const itemsValue = [...orderLines.values()].reduce(
    (sum, line) => sum + (line.itemsValue ?? 0n),
    0n,
  );
  const weekTotal = commission + discountShare + exceptions;
  const earlierUnpaid = previousDue - paid;
  return {
    totals: {
      orders: orderLines.size,
      itemsValue,
      commission,
      discountShare,
      exceptions,
      weekTotal,
      previousDue,
      paid,
      earlierUnpaid,
      totalDue: earlierUnpaid + weekTotal,
    },
    lines,
    journalIds: [...new Set(entries.map((entry) => entry.journalId))],
  };
}

// AP §8.7, owner decision 2026-11-16: a payment settles the oldest statement
// first, so what is still unpaid is the newest weeks' totals. The statement
// the unpaid amount reaches back to, its overdue time counting from its
// cutoff; null when nothing is unpaid. Newest first; a week whose total
// lowered what was owed adds nothing (it already lowered the unpaid amount).
export function oldestUnpaid<Statement extends { weekTotal: bigint }>(
  newestFirst: readonly Statement[],
  unpaid: bigint,
): Statement | null {
  if (unpaid <= 0n || newestFirst.length === 0) return null;
  let left = unpaid;
  for (const statement of newestFirst) {
    const week = statement.weekTotal > 0n ? statement.weekTotal : 0n;
    if (left <= week) return statement;
    left -= week;
  }
  // Older than the statements read: the oldest of them.
  return newestFirst[newestFirst.length - 1]!;
}
