import { describe, expect, it } from 'vitest';
import { PICKUP_CORRECTION_REASON, pickupCorrection } from './pickup-correction.js';

// AP §9.9.3 «تصحيح في الحسابات», RA §8.10 item 8, S10: what correcting a
// disputed pickup posts, per currency on the captain and in the base on the
// restaurant.

// TRY the base; USD at 41.20 TRY (AP §8.6).
const snapshot = {
  cityId: 'city-1',
  baseCurrency: 'TRY',
  takenAt: new Date('2026-11-11T10:00:00Z'),
  currencies: [
    {
      code: 'TRY',
      decimals: 2,
      rate: { numerator: 1n, denominator: 1n },
      rateVersionId: null,
      roundingUnitMinor: 500n,
      roundingMode: 'nearest' as const,
    },
    {
      code: 'USD',
      decimals: 2,
      rate: { numerator: 412n, denominator: 10n },
      rateVersionId: '019a0000-0000-7000-8000-000000000001',
      roundingUnitMinor: 50n,
      roundingMode: 'nearest' as const,
    },
  ],
};

const parties = { captainId: 'captain-1', restaurantId: 'restaurant-1' };
const usd = (amount: bigint) => ({ currency: 'USD', amount });
const tryLine = (amount: bigint) => ({ currency: 'TRY', amount });

// Every currency's entries sum to zero, and so does the order clearing
// account over the correction.
function sums(journals: ReturnType<typeof pickupCorrection>['journals']) {
  const byJournal = journals.map((journal) => {
    const totals = new Map<string, bigint>();
    for (const entry of journal.entries) {
      totals.set(entry.currency, (totals.get(entry.currency) ?? 0n) + entry.amount);
    }
    return [...totals.values()];
  });
  const clearing = new Map<string, bigint>();
  for (const entry of journals.flatMap((journal) => journal.entries)) {
    if (entry.account !== 'platform.order_clearing') continue;
    clearing.set(entry.currency, (clearing.get(entry.currency) ?? 0n) + entry.amount);
  }
  return { byJournal: byJournal.flat(), clearing: [...clearing.values()] };
}

describe('pickupCorrection', () => {
  it('posts +5 $ custody on the captain and a 206 ₺ credit to the restaurant (AP §9.9.3)', () => {
    const correction = pickupCorrection({
      snapshot,
      ...parties,
      recorded: [usd(500n), tryLine(19_500n)],
      received: [tryLine(19_500n)],
    });
    expect(correction.captainChanges).toEqual([usd(500n)]);
    expect(correction.merchantAmount).toBe(20_600n);
    const custody = correction.journals.find((j) => j.type === 'custody.pickup_correction')!;
    expect(custody.entries).toEqual([
      {
        account: 'captain.custody',
        party: { kind: 'captain', id: 'captain-1' },
        amount: 500n,
        currency: 'USD',
      },
      {
        account: 'platform.order_clearing',
        party: { kind: 'platform', id: null },
        amount: -500n,
        currency: 'USD',
      },
    ]);
    expect(custody.reason).toBe(PICKUP_CORRECTION_REASON);
    expect(custody.rates).toBeUndefined();
    const credit = correction.journals.find((j) => j.type === 'merchant.credit')!;
    expect(credit.entries).toContainEqual({
      account: 'merchant.account',
      party: { kind: 'merchant', id: 'restaurant-1' },
      amount: -20_600n,
      currency: 'TRY',
    });
    expect(correction.journals.some((j) => j.type === 'merchant.debit')).toBe(false);
    const rounding = correction.journals.find((j) => j.type === 'platform.fx_rounding')!;
    expect(rounding.rates).toEqual([
      { currency: 'USD', rateVersionId: snapshot.currencies[1]!.rateVersionId },
    ]);
    const { byJournal, clearing } = sums(correction.journals);
    expect(byJournal.every((sum) => sum === 0n)).toBe(true);
    expect(clearing.every((sum) => sum === 0n)).toBe(true);
  });

  it('posts − custody and a debit when the restaurant received more than recorded', () => {
    const correction = pickupCorrection({
      snapshot,
      ...parties,
      recorded: [tryLine(40_000n)],
      received: [tryLine(40_500n)],
    });
    expect(correction.captainChanges).toEqual([tryLine(-500n)]);
    expect(correction.merchantAmount).toBe(-500n);
    expect(correction.journals.map((j) => j.type)).toEqual([
      'custody.pickup_correction',
      'merchant.debit',
    ]);
    const debit = correction.journals.find((j) => j.type === 'merchant.debit')!;
    expect(debit.entries).toContainEqual({
      account: 'merchant.account',
      party: { kind: 'merchant', id: 'restaurant-1' },
      amount: 500n,
      currency: 'TRY',
    });
    const { byJournal, clearing } = sums(correction.journals);
    expect(byJournal.every((sum) => sum === 0n)).toBe(true);
    expect(clearing.every((sum) => sum === 0n)).toBe(true);
  });

  it('corrects each currency apart when the split differs both ways', () => {
    // Recorded 5 $ + 195 ₺; the restaurant says it got 401 ₺ in lira only.
    const correction = pickupCorrection({
      snapshot,
      ...parties,
      recorded: [usd(500n), tryLine(19_500n)],
      received: [tryLine(40_100n)],
    });
    expect(correction.captainChanges).toEqual([usd(500n), tryLine(-20_600n)]);
    expect(correction.merchantAmount).toBe(0n);
    expect(correction.journals.map((j) => j.type)).toEqual([
      'custody.pickup_correction',
      'platform.fx_rounding',
    ]);
    const custody = correction.journals[0]!;
    expect(custody.rates).toEqual([
      { currency: 'USD', rateVersionId: snapshot.currencies[1]!.rateVersionId },
    ]);
    const { byJournal, clearing } = sums(correction.journals);
    expect(byJournal.every((sum) => sum === 0n)).toBe(true);
    expect(clearing.every((sum) => sum === 0n)).toBe(true);
  });

  it('posts nothing when the lines match what was recorded', () => {
    const correction = pickupCorrection({
      snapshot,
      ...parties,
      recorded: [usd(500n), tryLine(19_500n)],
      received: [tryLine(19_500n), usd(500n)],
    });
    expect(correction).toEqual({ captainChanges: [], merchantAmount: 0n, journals: [] });
  });
});
