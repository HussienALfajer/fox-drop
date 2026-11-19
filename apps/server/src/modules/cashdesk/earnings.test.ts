import { describe, expect, it } from 'vitest';
import type { AccountEntry, JournalType } from '../ledger/index.js';
import { monthFrom, otherLines, orderLines, payoutCycle, windowTotals } from './earnings.js';

// CA §10.6 «أرباحي» (slice 2.18b): the pure rules of the screen. «هذا
// الأسبوع» is the payout cycle since the last payout weekday, by business
// day (owner decision 2026-11-15).
const azaz = 'Asia/Damascus';
const six = 6 * 60;

describe('payoutCycle (CA §10.6, owner decision 2026-11-15)', () => {
  it('starts the week at the latest payout weekday, by business day', () => {
    // Monday 2026-11-16 10:00 in Azaz (UTC+3).
    const cycle = payoutCycle(new Date('2026-11-16T07:00:00Z'), six, azaz, 'thursday');
    expect(cycle.todayFrom.toISOString()).toBe('2026-11-16T03:00:00.000Z');
    expect(cycle.weekFrom.toISOString()).toBe('2026-11-12T03:00:00.000Z');
    expect(cycle.nextPayout).toBe('2026-11-19');
  });

  it('counts the hours before the cutoff on the business day before', () => {
    // Friday 2026-11-20 05:00 in Azaz: still Thursday's business day.
    const cycle = payoutCycle(new Date('2026-11-20T02:00:00Z'), six, azaz, 'thursday');
    expect(cycle.todayFrom.toISOString()).toBe('2026-11-19T03:00:00.000Z');
    expect(cycle.weekFrom.toISOString()).toBe('2026-11-19T03:00:00.000Z');
    expect(cycle.nextPayout).toBe('2026-11-19');
  });

  it('makes the payout day the first of its week, and today the payout', () => {
    // Thursday 2026-11-19 12:00 in Azaz.
    const cycle = payoutCycle(new Date('2026-11-19T09:00:00Z'), six, azaz, 'thursday');
    expect(cycle.weekFrom).toEqual(cycle.todayFrom);
    expect(cycle.nextPayout).toBe('2026-11-19');
  });

  it('moves the payout a week on once the captain was paid today', () => {
    const cycle = payoutCycle(new Date('2026-11-19T09:00:00Z'), six, azaz, 'thursday', true);
    expect(cycle.weekFrom).toEqual(cycle.todayFrom);
    expect(cycle.nextPayout).toBe('2026-11-26');
  });

  it('follows another payout weekday', () => {
    // Wednesday 2026-11-18 12:00 in Azaz, paid on Saturdays.
    const cycle = payoutCycle(new Date('2026-11-18T09:00:00Z'), six, azaz, 'saturday');
    expect(cycle.weekFrom.toISOString()).toBe('2026-11-14T03:00:00.000Z');
    expect(cycle.nextPayout).toBe('2026-11-21');
  });
});

let journals = 0;
function entry(
  type: JournalType,
  amount: bigint,
  at: string,
  source: { kind: 'order' | 'receipt'; id: string } | null = null,
  reason: string | null = null,
): AccountEntry {
  journals += 1;
  return {
    journalId: `j${journals}`,
    type,
    sourceKind: source?.kind ?? null,
    sourceId: source?.id ?? null,
    currency: 'TRY',
    amount,
    createdAt: new Date(at),
    reason,
  };
}
const order = (id: string) => ({ kind: 'order' as const, id });

describe('windowTotals (CA §10.6: the earnings so far and the orders)', () => {
  const entries = [
    entry('earn.order_pay', 3_500n, '2026-11-15T08:00:00Z', order('a')),
    entry('earn.peak_bonus', 500n, '2026-11-15T08:00:00Z', order('a')),
    entry('earn.order_pay', 3_000n, '2026-11-16T08:00:00Z', order('b')),
    entry('earn.waiting_pay', 200n, '2026-11-16T08:00:00Z', order('b')),
    entry('earn.charge', -1_000n, '2026-11-16T09:00:00Z', order('c'), 'إرجاع'),
    entry('earn.payout', -2_000n, '2026-11-16T10:00:00Z', { kind: 'receipt', id: 'r' }),
    // A pay reversed in full is no order.
    entry('earn.order_pay', 2_500n, '2026-11-16T11:00:00Z', order('d')),
    entry('earn.order_pay', -2_500n, '2026-11-16T12:00:00Z', order('d')),
  ];

  it('sums every earning but the payouts, from the window on', () => {
    expect(windowTotals(entries, new Date('2026-11-16T03:00:00Z'))).toEqual({
      earnings: 2_200n,
      orders: 1,
    });
    expect(windowTotals(entries, new Date('2026-11-12T03:00:00Z'))).toEqual({
      earnings: 6_200n,
      orders: 2,
    });
  });
});

describe('orderLines (CA §10.6: each order with its pay and total)', () => {
  it('groups the pay, the waiting and the peak bonus of each order, newest first', () => {
    const lines = orderLines([
      entry('earn.order_pay', 3_500n, '2026-11-15T08:00:00Z', order('a')),
      entry('earn.peak_bonus', 500n, '2026-11-15T08:00:00Z', order('a')),
      entry('earn.order_pay', 3_000n, '2026-11-16T08:00:00Z', order('b')),
      entry('earn.waiting_pay', 200n, '2026-11-16T08:00:00Z', order('b')),
      entry('earn.charge', -1_000n, '2026-11-16T09:00:00Z', order('b'), 'إرجاع'),
      entry('earn.bonus', 1_000n, '2026-11-16T09:00:00Z', null, 'مكافأة'),
    ]);
    expect(lines).toEqual([
      {
        orderId: 'b',
        at: new Date('2026-11-16T08:00:00Z'),
        orderPay: 3_000n,
        waitingPay: 200n,
        peakBonus: 0n,
        total: 3_200n,
      },
      {
        orderId: 'a',
        at: new Date('2026-11-15T08:00:00Z'),
        orderPay: 3_500n,
        waitingPay: 0n,
        peakBonus: 500n,
        total: 4_000n,
      },
    ]);
  });
});

describe('otherLines (CA §10.6: bonuses, charges, instalments, payouts)', () => {
  it('keeps every other entry with its reason and source, newest first', () => {
    const lines = otherLines([
      entry('earn.order_pay', 3_000n, '2026-11-16T08:00:00Z', order('b')),
      entry('earn.charge', -1_000n, '2026-11-16T09:00:00Z', order('b'), 'إرجاع'),
      entry('earn.bonus', 1_000n, '2026-11-16T10:00:00Z', null, 'مكافأة'),
      entry('earn.deposit_instalment', -500n, '2026-11-16T11:00:00Z'),
      entry('earn.adjustment', 200n, '2026-11-16T12:00:00Z', null, 'تصحيح'),
      entry('earn.payout', -2_700n, '2026-11-16T13:00:00Z', { kind: 'receipt', id: 'r' }),
    ]);
    expect(lines.map((line) => [line.kind, line.amount, line.reason, line.sourceId])).toEqual([
      ['payout', -2_700n, null, 'r'],
      ['adjustment', 200n, 'تصحيح', null],
      ['instalment', -500n, null, null],
      ['bonus', 1_000n, 'مكافأة', null],
      ['charge', -1_000n, 'إرجاع', 'b'],
    ]);
  });
});

describe('monthFrom (AP §9.7.4, slice 2.36a)', () => {
  it('starts at the business day on the first of the city’s month', () => {
    // Thursday 2026-11-19 12:00 in Azaz: the month from 2026-11-01 06:00.
    const today = payoutCycle(new Date('2026-11-19T09:00:00Z'), six, azaz, 'thursday').todayFrom;
    expect(monthFrom(today, six, azaz).toISOString()).toBe('2026-11-01T03:00:00.000Z');
  });

  it('counts the hours before the first’s cutoff in the month before', () => {
    // Sunday 2026-11-01 05:00 in Azaz: still 31 October's business day.
    const today = payoutCycle(new Date('2026-11-01T02:00:00Z'), six, azaz, 'thursday').todayFrom;
    expect(monthFrom(today, six, azaz).toISOString()).toBe('2026-10-01T03:00:00.000Z');
  });

  it('is today on the first', () => {
    const today = payoutCycle(new Date('2026-12-01T09:00:00Z'), six, azaz, 'thursday').todayFrom;
    expect(monthFrom(today, six, azaz)).toEqual(today);
  });
});
