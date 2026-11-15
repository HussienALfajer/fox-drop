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

// RA §12.5: what an exception is, from its journal.
export function causeOf(
  entry: AccountEntry,
  owes: bigint,
  foodCreditReason: string,
): ExceptionCause {
  switch (entry.type) {
    case 'merchant.credit':
      return entry.reason === foodCreditReason ? 'food_credit' : 'credit';
    case 'merchant.debit':
      // The failed order's return of the pickup payment carries no reason;
      // items removed after pickup carry theirs. A ticket's comes with 2.23.
      if (entry.sourceKind !== 'order') return 'debit';
      return entry.reason === null ? 'pickup_refund' : 'items_removed';
    case 'merchant.commission':
      return 'commission_reversal';
    case 'merchant.discount_share':
      return 'discount_reversal';
    case 'merchant.adjustment':
      return 'adjustment';
    default:
      throw new Error(`${entry.type} (${owes}) is not a restaurant exception`);
  }
}

// The statement of a period: each order with a commission or a discount
// share raising what is owed, in the order of its first such entry; every
// other entry an exception (a credit, a debit, a reversal, a correction) or a
// payment (merchant.settlement), in the ledger's order.
export function buildStatement(
  entries: readonly AccountEntry[],
  previousDue: bigint,
  pickups: ReadonlyMap<string, OrderPickup>,
  foodCreditReason: string,
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
    const charge = entry.type === 'merchant.commission' || entry.type === 'merchant.discount_share';
    if (charge && owes > 0n && orderId !== null) {
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
    const payment = entry.type === 'merchant.settlement';
    if (payment) paid -= owes;
    else exceptions += owes;
    lines.push({
      kind: payment ? 'payment' : 'exception',
      at: entry.createdAt,
      orderId,
      orderNumber: orderId === null ? null : (pickups.get(orderId)?.number ?? null),
      cause: payment ? null : causeOf(entry, owes, foodCreditReason),
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
