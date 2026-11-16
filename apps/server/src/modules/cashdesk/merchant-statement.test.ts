import { describe, expect, it } from 'vitest';
import type { AccountEntry } from '../ledger/index.js';
import { merchantEntryCause, merchantEntryCauses, type OrderPickup } from '../ordering/index.js';
import {
  buildStatement,
  oldestUnpaid,
  overdueOf,
  statementStatuses,
} from './merchant-statement.js';
import { merchantExceptionCauses } from './schema.js';

// AP §8.7, RA §12.3, §12.5 (slice 2.19a): the restaurant's weekly statement
// from its period's entries. Amounts are minor units of TRY; the ledger's
// party view is − the restaurant owes.
const FOOD = 'تعويض عن طلب أُلغي بعد التحضير';
const causeOf = merchantEntryCause;
let journal = 0;
const at = (minute: number) => new Date(Date.UTC(2026, 10, 10, 9, minute));
function entry(
  type: AccountEntry['type'],
  owes: bigint,
  {
    orderId = null,
    reason = null,
    minute = 0,
    sourceKind = orderId === null ? null : 'order',
  }: {
    orderId?: string | null;
    reason?: string | null;
    minute?: number;
    sourceKind?: AccountEntry['sourceKind'];
  } = {},
): AccountEntry {
  journal += 1;
  return {
    journalId: `j${journal}`,
    type,
    sourceKind,
    sourceId: orderId ?? (sourceKind === 'receipt' ? 'r1' : null),
    currency: 'TRY',
    amount: -owes,
    createdAt: at(minute),
    reason,
  };
}

const pickups = new Map<string, OrderPickup>([
  [
    'o1',
    {
      number: 10001n,
      pickup: {
        currency: 'TRY',
        amount: 40_000n,
        lines: [
          { currency: 'TRY', amount: 20_000n },
          { currency: 'USD', amount: 500n },
        ],
      },
    },
  ],
  ['o2', { number: 10002n, pickup: { currency: 'TRY', amount: 38_000n, lines: [] } }],
  ['o3', { number: 10003n, pickup: null }],
]);

describe('the restaurant weekly statement', () => {
  it('lists each order with its items value, commission and discount share', () => {
    const built = buildStatement(
      [
        entry('merchant.commission', 6_000n, { orderId: 'o1', minute: 1 }),
        entry('merchant.commission', 5_700n, { orderId: 'o2', minute: 2 }),
        entry('merchant.discount_share', 2_000n, { orderId: 'o2', minute: 2 }),
      ],
      0n,
      pickups,
      causeOf,
    );
    expect(built.lines).toEqual([
      expect.objectContaining({
        kind: 'order',
        orderId: 'o1',
        orderNumber: 10001n,
        itemsValue: 40_000n,
        pickupLines: [
          { currency: 'TRY', amount: 20_000n },
          { currency: 'USD', amount: 500n },
        ],
        commission: 6_000n,
        discountShare: 0n,
      }),
      expect.objectContaining({
        kind: 'order',
        orderId: 'o2',
        itemsValue: 38_000n,
        commission: 5_700n,
        discountShare: 2_000n,
      }),
    ]);
    // RA §12.1: 15% of 380 is 57, plus the 20 the restaurant funded.
    expect(built.totals).toEqual({
      orders: 2,
      itemsValue: 78_000n,
      commission: 11_700n,
      discountShare: 2_000n,
      exceptions: 0n,
      weekTotal: 13_700n,
      previousDue: 0n,
      paid: 0n,
      earlierUnpaid: 0n,
      totalDue: 13_700n,
    });
  });

  it('lists the exceptions apart with their order, cause and reason', () => {
    const built = buildStatement(
      [
        entry('merchant.credit', -3_400n, { orderId: 'o3', reason: FOOD }),
        entry('merchant.debit', 40_000n, { orderId: 'o1', reason: 'استرداد مبلغ الاستلام' }),
        entry('merchant.debit', 1_000n, { orderId: 'o2', reason: 'أصناف حُذفت بعد الاستلام' }),
        entry('merchant.commission', -150n, { orderId: 'o2', reason: 'إلغاء عمولة' }),
        entry('merchant.adjustment', -500n, { reason: 'خطأ في الكشف' }),
        entry('merchant.debit', 40_000n, { orderId: 'o3' }),
        entry('merchant.commission', 600n, {
          orderId: 'o1',
          reason: 'إلغاء استرداد العمولة: المطعم مسؤول عن الطلب',
        }),
        entry('merchant.debit', -40_000n, { orderId: 'o1', reason: 'تغيير النتيجة' }),
        entry('merchant.debit', 500n, {
          orderId: 'o2',
          reason: 'خُفّضت أجرة التوصيل بعد الاستلام',
        }),
      ],
      0n,
      pickups,
      causeOf,
    );
    expect(built.lines.map((line) => line.kind === 'order' || [line.cause, line.amount])).toEqual([
      ['food_credit', -3_400n],
      ['pickup_refund', 40_000n],
      ['items_removed', 1_000n],
      ['commission_reversal', -150n],
      ['adjustment', -500n],
      ['pickup_kept', 40_000n],
      ['commission_restored', 600n],
      ['outcome_changed', -40_000n],
      ['fee_lowered', 500n],
    ]);
    expect(built.lines[0]).toMatchObject({ orderNumber: 10003n, reason: FOOD });
    expect(built.totals).toMatchObject({ orders: 0, exceptions: 38_050n, totalDue: 38_050n });
  });

  it('carries the earlier unpaid balance less the payments since', () => {
    const built = buildStatement(
      [
        entry('merchant.settlement', -5_000n, { sourceKind: 'receipt' }),
        entry('merchant.commission', 6_000n, { orderId: 'o1' }),
      ],
      8_000n,
      pickups,
      causeOf,
    );
    expect(built.lines[0]).toMatchObject({ kind: 'payment', amount: -5_000n, cause: null });
    expect(built.totals).toMatchObject({
      previousDue: 8_000n,
      paid: 5_000n,
      earlierUnpaid: 3_000n,
      weekTotal: 6_000n,
      totalDue: 9_000n,
    });
    expect(built.journalIds).toHaveLength(2);
  });

  it('owes the restaurant when its credits pass what it owes', () => {
    const built = buildStatement(
      [entry('merchant.credit', -3_400n, { orderId: 'o3', reason: FOOD })],
      0n,
      pickups,
      causeOf,
    );
    expect(built.totals.totalDue).toBe(-3_400n);
  });
});

describe('the causes of the restaurant entries', () => {
  it('keeps the statement lines and ordering on the same causes', () => {
    expect([...merchantExceptionCauses].sort()).toEqual(
      merchantEntryCauses.filter((cause) => cause !== 'order').sort(),
    );
  });
});

// Owner decision 2026-11-16: a payment settles the oldest statement first.
describe('the oldest statement still unpaid', () => {
  const weeks = [
    { id: 'w3', weekTotal: 2_000n },
    { id: 'w2', weekTotal: -500n },
    { id: 'w1', weekTotal: 3_000n },
  ];

  it('is the newest week while the unpaid amount fits in it', () => {
    expect(oldestUnpaid(weeks, 2_000n)?.id).toBe('w3');
  });

  it('reaches back past the newer weeks, a credit week adding nothing', () => {
    expect(oldestUnpaid(weeks, 2_001n)?.id).toBe('w1');
  });

  it('is none when nothing is unpaid', () => {
    expect(oldestUnpaid(weeks, 0n)).toBeNull();
    expect(oldestUnpaid([], 100n)).toBeNull();
  });
});

// RA §12.3 «غير مسدّد», «مسدّد جزئياً», «مسدّد» (slice 2.19b): what is still
// unpaid is the newest weeks' (owner decision 2026-11-16), so each
// statement's own part is what reaches back to it, at most its total due.
describe("each statement's status", () => {
  const weeks = [
    { id: 'w3', weekTotal: 2_000n, totalDue: 4_500n },
    { id: 'w2', weekTotal: -500n, totalDue: 2_500n },
    { id: 'w1', weekTotal: 3_000n, totalDue: 3_000n },
  ];

  it('is unpaid while nothing reached it', () => {
    const statuses = statementStatuses(weeks, 4_500n);
    expect(statuses.get('w3')).toEqual({ status: 'unpaid', unpaid: 4_500n });
    expect(statuses.get('w2')).toEqual({ status: 'unpaid', unpaid: 2_500n });
    // The credit of w2 settles the oldest week first, as a payment would.
    expect(statuses.get('w1')).toEqual({ status: 'partly_paid', unpaid: 2_500n });
  });

  it('turns partly paid, the older ones paid first', () => {
    const statuses = statementStatuses(weeks, 1_000n);
    expect(statuses.get('w3')).toEqual({ status: 'partly_paid', unpaid: 1_000n });
    expect(statuses.get('w2')).toEqual({ status: 'paid', unpaid: 0n });
    expect(statuses.get('w1')).toEqual({ status: 'paid', unpaid: 0n });
  });

  it('is paid once nothing is unpaid, and none when nothing was due', () => {
    expect(statementStatuses(weeks, 0n).get('w3')).toEqual({ status: 'paid', unpaid: 0n });
    expect(
      statementStatuses([{ id: 'c', weekTotal: -3_400n, totalDue: -3_400n }], 0n).get('c'),
    ).toEqual({ status: null, unpaid: 0n });
  });
});

// RA §12.6, AP §8.7 (slice 2.19f): what is overdue is the unpaid part of the
// statements past their overdue time. The newer weeks not yet overdue take
// their positive totals first, as a payment settles the oldest first.
describe('what is overdue', () => {
  const day = (n: number) => new Date(Date.UTC(2026, 10, n, 4));
  const weeks = [
    { id: 'w3', cutoff: day(14), weekTotal: 2_000n },
    { id: 'w2', cutoff: day(7), weekTotal: -500n },
    { id: 'w1', cutoff: day(1), weekTotal: 3_000n },
  ];

  it('is nothing while every unpaid week is still within its days', () => {
    expect(overdueOf(weeks, 2_000n, day(10))).toBeNull();
  });

  it('is what reaches back past the weeks not yet overdue', () => {
    // w3 is not overdue (its cutoff is after the threshold): 2 000 is its.
    expect(overdueOf(weeks, 2_600n, day(10))).toEqual({ amount: 600n, statement: weeks[2] });
  });

  it('is the whole unpaid amount once the latest week is overdue', () => {
    expect(overdueOf(weeks, 2_600n, day(16))).toEqual({ amount: 2_600n, statement: weeks[2] });
    expect(overdueOf(weeks, 1_500n, day(16))).toEqual({ amount: 1_500n, statement: weeks[0] });
  });

  it('is nothing when nothing is unpaid', () => {
    expect(overdueOf(weeks, 0n, day(16))).toBeNull();
    expect(overdueOf([], 100n, day(16))).toBeNull();
  });
});
