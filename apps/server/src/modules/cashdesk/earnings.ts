import { lastCutoff, nextCutoff } from '../geo/index.js';
import type { AccountEntry } from '../ledger/index.js';
import type { PayoutWeekday } from './settlement.service.js';

// CA §10.6 «أرباحي» (slice 2.18b): the pure rules of the earnings screen.

export interface PayoutCycle {
  // The business day now: since its cutoff.
  todayFrom: Date;
  // «هذا الأسبوع»: the payout cycle, since the start of the latest business
  // day on captain.payout_weekday, today included (owner decision
  // 2026-11-15).
  weekFrom: Date;
  // «موعد القبض»: the date of the next business day on the payout weekday,
  // today when it is one and the captain was not paid yet today, on the
  // city's clock (YYYY-MM-DD).
  nextPayout: string;
}

// Seven business days at most, back or forward, find the payout weekday.
const WEEK = 7;

export function payoutCycle(
  now: Date,
  cutoffMinutes: number,
  timeZone: string,
  weekday: PayoutWeekday,
  // A payout already made today moves «موعد القبض» to the next week.
  paidToday = false,
): PayoutCycle {
  const todayFrom = lastCutoff(now, cutoffMinutes, timeZone);
  const weekdayOf = (dayStart: Date) =>
    new Intl.DateTimeFormat('en-US', { timeZone, weekday: 'long' }).format(dayStart).toLowerCase();
  let weekFrom = todayFrom;
  for (let step = 0; step < WEEK && weekdayOf(weekFrom) !== weekday; step += 1) {
    weekFrom = lastCutoff(new Date(weekFrom.getTime() - 1), cutoffMinutes, timeZone);
  }
  let payout = paidToday ? nextCutoff(todayFrom, cutoffMinutes, timeZone) : todayFrom;
  for (let step = 0; step < WEEK && weekdayOf(payout) !== weekday; step += 1) {
    payout = nextCutoff(payout, cutoffMinutes, timeZone);
  }
  const nextPayout = new Intl.DateTimeFormat('en-CA', {
    timeZone,
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
  }).format(payout);
  return { todayFrom, weekFrom, nextPayout };
}

// The earnings so far from `from` (every entry but the payouts, charges and
// instalments taken off) and the orders: those whose earn.order_pay nets
// above zero, as the weekly statement counts them.
export function windowTotals(
  entries: readonly AccountEntry[],
  from: Date,
): { earnings: bigint; orders: number } {
  const inside = entries.filter((entry) => entry.createdAt >= from);
  const earnings = inside
    .filter((entry) => entry.type !== 'earn.payout')
    .reduce((total, entry) => total + entry.amount, 0n);
  const pay = new Map<string, bigint>();
  for (const entry of inside) {
    if (entry.type !== 'earn.order_pay' || entry.sourceKind !== 'order' || !entry.sourceId) {
      continue;
    }
    pay.set(entry.sourceId, (pay.get(entry.sourceId) ?? 0n) + entry.amount);
  }
  return { earnings, orders: [...pay.values()].filter((amount) => amount > 0n).length };
}

// CA §10.6 «each order»: the pay of an order (earn.order_pay: base,
// distance and the minimum's top-up), its waiting pay and its peak bonus.
export interface OrderPay {
  orderId: string;
  // Its first entry's time.
  at: Date;
  orderPay: bigint;
  waitingPay: bigint;
  peakBonus: bigint;
  total: bigint;
}

const PAY_TYPES = new Set(['earn.order_pay', 'earn.waiting_pay', 'earn.peak_bonus']);

export function orderLines(entries: readonly AccountEntry[]): OrderPay[] {
  const lines = new Map<string, OrderPay>();
  for (const entry of entries) {
    if (!PAY_TYPES.has(entry.type) || entry.sourceKind !== 'order' || !entry.sourceId) continue;
    const line = lines.get(entry.sourceId) ?? {
      orderId: entry.sourceId,
      at: entry.createdAt,
      orderPay: 0n,
      waitingPay: 0n,
      peakBonus: 0n,
      total: 0n,
    };
    if (entry.createdAt < line.at) line.at = entry.createdAt;
    if (entry.type === 'earn.order_pay') line.orderPay += entry.amount;
    if (entry.type === 'earn.waiting_pay') line.waitingPay += entry.amount;
    if (entry.type === 'earn.peak_bonus') line.peakBonus += entry.amount;
    line.total += entry.amount;
    lines.set(entry.sourceId, line);
  }
  return [...lines.values()].sort((a, b) => b.at.getTime() - a.at.getTime());
}

// CA §10.6 «other entries»: bonuses, charges (with their order), deposit
// instalments, payouts (with their receipt) and corrections, each with its
// reason.
export const otherKinds = ['bonus', 'charge', 'instalment', 'payout', 'adjustment'] as const;
export type OtherKind = (typeof otherKinds)[number];

const KIND_OF: Record<string, OtherKind> = {
  'earn.bonus': 'bonus',
  'earn.charge': 'charge',
  'earn.deposit_instalment': 'instalment',
  'earn.payout': 'payout',
  'earn.adjustment': 'adjustment',
};

export interface OtherLine {
  kind: OtherKind;
  amount: bigint;
  reason: string | null;
  sourceKind: AccountEntry['sourceKind'];
  sourceId: string | null;
  at: Date;
}

export function otherLines(entries: readonly AccountEntry[]): OtherLine[] {
  return entries
    .flatMap((entry) => {
      const kind = KIND_OF[entry.type];
      return kind === undefined
        ? []
        : [
            {
              kind,
              amount: entry.amount,
              reason: entry.reason,
              sourceKind: entry.sourceKind,
              sourceId: entry.sourceId,
              at: entry.createdAt,
            },
          ];
    })
    .sort((a, b) => b.at.getTime() - a.at.getTime());
}
