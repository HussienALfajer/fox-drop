import { type RateSnapshot, toBase } from '../fx/index.js';
import type { PaymentLine } from './pickup-booking.js';

export type DoorPaymentRefusal =
  | 'invalid_lines'
  | 'currency_not_accepted'
  // AP §8.6, CA §9.7 item 4: «سجّل الباقي الذي أعدته للزبون».
  | 'overpaid';

// The door payment checked against the amount due (AP §8.6, CA §9.7): what
// was received and given back, in base minor units by the order's snapshot.
export interface DoorPayment {
  // The received lines minus the change lines.
  netBase: bigint;
  // The amount due minus the net when it is lower beyond rounding, else 0:
  // «المبلغ المقبوض أقل من المطلوب بـ {المبلغ}» (K16).
  shortfall: bigint;
  // The gap within rounding (due − net), booked to platform.fx_rounding; 0
  // with a shortfall.
  roundingGap: bigint;
  // Per currency: received minus change, in that currency, and its base
  // value; the lines' currencies only.
  perCurrency: { currency: string; net: bigint; base: bigint }[];
}

// Received: one line per currency, each above zero, at least one. Change:
// one line per currency, each above zero, none allowed. Every currency is
// one the order's snapshot accepted. The net within half the largest
// rounding unit among the currencies of all the lines is the amount due;
// above it is refused, below it a shortfall.
export function checkDoorPayment(
  snapshot: RateSnapshot,
  received: PaymentLine[],
  change: PaymentLine[],
  due: bigint,
): DoorPaymentRefusal | DoorPayment {
  const oneEach = (lines: PaymentLine[]) =>
    new Set(lines.map((line) => line.currency)).size === lines.length &&
    lines.every((line) => line.amount > 0n);
  // Nothing is received for an amount due of 0 (a free re-delivery, AP
  // §9.9.3); any other needs a line at least.
  if ((received.length === 0 && due !== 0n) || !oneEach(received) || !oneEach(change)) {
    return 'invalid_lines';
  }
  const accepted = new Set(snapshot.currencies.map((entry) => entry.code));
  const all = [...received, ...change];
  if (all.some((line) => !accepted.has(line.currency))) return 'currency_not_accepted';
  const currencies = [...new Set(all.map((line) => line.currency))];
  const perCurrency = currencies.map((currency) => {
    const sum = (lines: PaymentLine[]) =>
      lines
        .filter((line) => line.currency === currency)
        .reduce((total, line) => total + line.amount, 0n);
    const inBase = (lines: PaymentLine[]) =>
      lines
        .filter((line) => line.currency === currency)
        .reduce((total, line) => total + toBase(snapshot, line.amount, currency), 0n);
    return {
      currency,
      net: sum(received) - sum(change),
      base: inBase(received) - inBase(change),
    };
  });
  const netBase = perCurrency.reduce((total, each) => total + each.base, 0n);
  const largestUnit = currencies
    .map((currency) => {
      const entry = snapshot.currencies.find((each) => each.code === currency)!;
      return toBase(snapshot, entry.roundingUnitMinor, currency);
    })
    .reduce((largest, unit) => (unit > largest ? unit : largest), 0n);
  const gap = due - netBase;
  const withinRounding = 2n * (gap < 0n ? -gap : gap) <= largestUnit;
  if (!withinRounding && gap < 0n) return 'overpaid';
  return {
    netBase,
    shortfall: withinRounding ? 0n : gap,
    roundingGap: withinRounding ? gap : 0n,
    perCurrency,
  };
}

// AP §8.4, docs/domain/04: whole minutes of waiting at the restaurant past
// the threshold, counted from the later of the arrival and the prep due
// time, until the pickup. The threshold is the one in force at the arrival
// (the waiting alert's moment kept with it).
export function waitingMinutes(order: WaitingOrder & { pickedUpAt: Date }): number {
  const from = waitingPayFrom(order);
  if (from === null) return 0;
  return Math.max(0, Math.floor((order.pickedUpAt.getTime() - from.getTime()) / 60_000));
}

interface WaitingOrder {
  arrivedAtMerchantAt: Date | null;
  captainWaitingAlertAt: Date | null;
  acceptedAt: Date;
  prepMin: number;
}

// CA §9.3, AP §8.4: the moment paid waiting starts («بدأ احتساب أجر
// الانتظار»), or null before the arrival.
export function waitingPayFrom(order: WaitingOrder): Date | null {
  if (order.arrivedAtMerchantAt === null || order.captainWaitingAlertAt === null) return null;
  const threshold = order.captainWaitingAlertAt.getTime() - order.arrivedAtMerchantAt.getTime();
  const due = order.acceptedAt.getTime() + order.prepMin * 60_000;
  return new Date(Math.max(order.arrivedAtMerchantAt.getTime(), due) + threshold);
}

// AP §8.4: commission_pct × (items value − restaurant-funded item discount),
// to the nearest minor unit, half up. No codes yet (Phase 2), so no discount.
export function commission(itemsValue: bigint, commissionBp: number): bigint {
  return (itemsValue * BigInt(commissionBp) + 5_000n) / 10_000n;
}
