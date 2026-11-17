import { type RateSnapshot, toBase } from '../fx/index.js';
import type { CancellationEntry, CancellationJournal } from './cancellation.js';
import { journalRates } from './journal-rates.js';
import type { PaymentLine } from './pickup-booking.js';

// The reason every journal of a pickup correction carries, which names it on
// the restaurant's statement and in the captain's custody.
export const PICKUP_CORRECTION_REASON = 'تصحيح دفعة الاستلام';

export interface PickupCorrection {
  // Per currency, recorded less received: + the captain still holds that cash
  // and hands it in, − the desk reimburses them. Zero differences left out,
  // in the order of the recorded lines, then the received.
  captainChanges: PaymentLine[];
  // D in the base: + a merchant.credit, − a merchant.debit of |D|.
  merchantAmount: bigint;
  journals: CancellationJournal[];
}

const platform = { kind: 'platform' as const, id: null };

// AP §9.9.3 «تصحيح في الحسابات» (S10): the lines recorded at the pickup
// (custody.pay_merchant) against the lines the restaurant actually received.
// The captain gets custody.pickup_correction of the difference in each
// currency; the restaurant merchant.credit (or merchant.debit) of D, the
// recorded total less the received total in the base by the order's
// snapshot. Each journal's other side is the order clearing account, and one
// platform.fx_rounding journal brings the other currencies' differences into
// the base at the order's rates, so the clearing account nets to zero.
export function pickupCorrection(input: {
  snapshot: RateSnapshot;
  captainId: string;
  restaurantId: string;
  recorded: readonly PaymentLine[];
  received: readonly PaymentLine[];
}): PickupCorrection {
  const { snapshot } = input;
  const base = snapshot.baseCurrency;
  const differences = new Map<string, bigint>();
  for (const line of input.recorded) {
    differences.set(line.currency, (differences.get(line.currency) ?? 0n) + line.amount);
  }
  for (const line of input.received) {
    differences.set(line.currency, (differences.get(line.currency) ?? 0n) - line.amount);
  }
  const captainChanges = [...differences]
    .filter(([, amount]) => amount !== 0n)
    .map(([currency, amount]) => ({ currency, amount }));
  const inBase = (lines: readonly PaymentLine[]) =>
    lines.reduce((sum, line) => sum + toBase(snapshot, line.amount, line.currency), 0n);
  const merchantAmount = inBase(input.recorded) - inBase(input.received);
  if (captainChanges.length === 0 && merchantAmount === 0n) {
    return { captainChanges, merchantAmount, journals: [] };
  }

  const journals: CancellationJournal[] = [];
  if (captainChanges.length > 0) {
    const entries: CancellationEntry[] = captainChanges.flatMap((change) => [
      {
        account: 'captain.custody' as const,
        party: { kind: 'captain' as const, id: input.captainId },
        amount: change.amount,
        currency: change.currency,
      },
      {
        account: 'platform.order_clearing' as const,
        party: platform,
        amount: -change.amount,
        currency: change.currency,
      },
    ]);
    journals.push({
      type: 'custody.pickup_correction',
      reason: PICKUP_CORRECTION_REASON,
      entries,
      rates: journalRates(snapshot, entries),
    });
  }
  if (merchantAmount !== 0n) {
    journals.push({
      type: merchantAmount > 0n ? 'merchant.credit' : 'merchant.debit',
      reason: PICKUP_CORRECTION_REASON,
      entries: [
        {
          account: 'merchant.account',
          party: { kind: 'merchant', id: input.restaurantId },
          amount: -merchantAmount,
          currency: base,
        },
        {
          account: 'platform.order_clearing',
          party: platform,
          amount: merchantAmount,
          currency: base,
        },
      ],
    });
  }
  // The clearing account now holds −difference in each other currency and
  // D − (the base's difference) in the base: bring the others into the base.
  const conversion: CancellationEntry[] = [];
  for (const change of captainChanges) {
    if (change.currency === base) continue;
    conversion.push(
      {
        account: 'platform.order_clearing',
        party: platform,
        amount: change.amount,
        currency: change.currency,
      },
      {
        account: 'platform.fx_rounding',
        party: platform,
        amount: -change.amount,
        currency: change.currency,
      },
    );
  }
  if (conversion.length > 0) {
    const baseDifference = differences.get(base) ?? 0n;
    const inBaseLeft = baseDifference - merchantAmount;
    if (inBaseLeft !== 0n) {
      conversion.push(
        { account: 'platform.order_clearing', party: platform, amount: inBaseLeft, currency: base },
        { account: 'platform.fx_rounding', party: platform, amount: -inBaseLeft, currency: base },
      );
    }
    journals.push({
      type: 'platform.fx_rounding',
      reason: PICKUP_CORRECTION_REASON,
      entries: conversion,
      rates: journalRates(snapshot, conversion),
    });
  }
  return { captainChanges, merchantAmount, journals };
}
