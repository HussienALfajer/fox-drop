import { describe, expect, it } from 'vitest';
import type { RateSnapshot } from '../fx/index.js';
import { checkLines, pickupCurrencies, proposeLines } from './pickup-booking.js';

// Azaz's placeholder rules: TRY the base, rounded to 5 TRY; USD at 41.20 TRY,
// rounded to 0.50 USD; SYP at 1/290 TRY, rounded to 500 SYP. Amounts are in
// minor units (AP §8.6).
const snapshot: RateSnapshot = {
  cityId: 'azaz',
  baseCurrency: 'TRY',
  takenAt: new Date('2026-11-06T10:00:00Z'),
  currencies: [
    {
      code: 'TRY',
      decimals: 2,
      rate: { numerator: 1n, denominator: 1n },
      rateVersionId: null,
      roundingUnitMinor: 500n,
      roundingMode: 'nearest',
    },
    {
      code: 'USD',
      decimals: 2,
      rate: { numerator: 412n, denominator: 10n },
      rateVersionId: 'usd-1',
      roundingUnitMinor: 50n,
      roundingMode: 'nearest',
    },
    {
      code: 'SYP',
      decimals: 2,
      rate: { numerator: 1n, denominator: 290n },
      rateVersionId: 'syp-1',
      roundingUnitMinor: 50_000n,
      roundingMode: 'nearest',
    },
  ],
};
const TRY = (amount: bigint) => ({ currency: 'TRY', amount });
const USD = (amount: bigint) => ({ currency: 'USD', amount });
const SYP = (amount: bigint) => ({ currency: 'SYP', amount });

// 440 TRY due; at 41.20 TRY a dollar that is 10.68 USD, 10.50 rounded to
// 0.50 (432.60 TRY): 7.40 TRY short, within half a 0.50 USD unit (10.30 TRY).
const due = 44_000n;

describe('pickupCurrencies (RA §12.7)', () => {
  it('is the base, then the restaurant’s others the snapshot has, in its display order', () => {
    expect(pickupCurrencies(snapshot, [])).toEqual(['TRY']);
    expect(pickupCurrencies(snapshot, ['SYP', 'USD'])).toEqual(['TRY', 'USD', 'SYP']);
    // A currency the city disabled before the order is not in its snapshot.
    expect(pickupCurrencies(snapshot, ['EUR', 'SYP'])).toEqual(['TRY', 'SYP']);
    // The base first, wherever the city shows it.
    const baseLast = { ...snapshot, currencies: [...snapshot.currencies].reverse() };
    expect(pickupCurrencies(baseLast, ['USD', 'SYP'])).toEqual(['TRY', 'SYP', 'USD']);
  });
});

describe('proposeLines (CA §10.5)', () => {
  it('proposes the whole amount in the base when both have it', () => {
    expect(proposeLines(snapshot, ['TRY', 'USD'], ['TRY', 'USD'], due)).toEqual([TRY(due)]);
    // Never set: the captain carries the base only.
    expect(proposeLines(snapshot, ['TRY', 'USD'], null, due)).toEqual([TRY(due)]);
  });

  it('otherwise proposes the first common currency in the display order, rounded by its rule', () => {
    expect(proposeLines(snapshot, ['TRY', 'USD', 'SYP'], ['SYP', 'USD'], due)).toEqual([
      USD(1_050n),
    ]);
    // 440 TRY × 290 = 127,600 SYP, 127,500 by 500.
    expect(proposeLines(snapshot, ['TRY', 'SYP'], ['USD', 'SYP'], due)).toEqual([SYP(12_750_000n)]);
  });

  it('passes over a common currency the whole amount cannot be paid in', () => {
    // 5 TRY is 0.12 USD, nothing by 0.50; 1,450 SYP is 1,500 by 500.
    expect(proposeLines(snapshot, ['TRY', 'USD', 'SYP'], ['USD', 'SYP'], 500n)).toEqual([
      SYP(150_000n),
    ]);
    expect(proposeLines(snapshot, ['TRY', 'USD'], ['USD'], 500n)).toEqual([TRY(500n)]);
  });

  it('falls back to the base without a common currency', () => {
    expect(proposeLines(snapshot, ['TRY'], ['USD'], due)).toEqual([TRY(due)]);
  });

  it('stays within the tolerance when the rule rounds up past it', () => {
    const up: typeof snapshot = {
      ...snapshot,
      currencies: snapshot.currencies.map((entry) =>
        entry.code === 'USD' ? { ...entry, roundingMode: 'up' as const } : entry,
      ),
    };
    // Up would be 11.00 USD (453.20 TRY, 13.20 over): the nearest unit instead.
    const proposal = proposeLines(up, ['TRY', 'USD'], ['USD'], due);
    expect(proposal).toEqual([USD(1_050n)]);
    expect(checkLines(up, proposal, due, ['TRY', 'USD'])).toBeNull();
  });

  it('is always accepted by checkLines', () => {
    for (const carried of [null, ['USD'], ['SYP'], ['USD', 'SYP'], ['TRY']]) {
      for (const accepted of [['TRY'], ['TRY', 'USD'], ['TRY', 'SYP'], ['TRY', 'USD', 'SYP']]) {
        for (const amount of [44_000n, 1n, 123_456n, 9_999_999n]) {
          const lines = proposeLines(snapshot, accepted, carried, amount);
          expect(checkLines(snapshot, lines, amount, accepted)).toBeNull();
        }
      }
    }
  });
});

describe('checkLines (CA §9.4, RA §12.7)', () => {
  it('takes the restaurant’s currencies, split across them', () => {
    expect(checkLines(snapshot, [USD(1_050n)], due, ['TRY', 'USD'])).toBeNull();
    // 5 USD (206 TRY) and 234 TRY.
    expect(checkLines(snapshot, [USD(500n), TRY(23_400n)], due, ['TRY', 'USD'])).toBeNull();
  });

  it('refuses a currency the restaurant does not accept', () => {
    expect(checkLines(snapshot, [USD(1_050n)], due, ['TRY'])).toBe('currency_not_accepted');
    expect(checkLines(snapshot, [TRY(due)], due, ['TRY'])).toBeNull();
  });

  it('refuses lines beyond half the largest rounding unit among them', () => {
    expect(checkLines(snapshot, [USD(1_000n)], due, ['TRY', 'USD'])).toBe('amount_mismatch');
    expect(checkLines(snapshot, [TRY(43_700n)], due, ['TRY', 'USD'])).toBe('amount_mismatch');
  });
});
