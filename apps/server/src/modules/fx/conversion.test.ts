import { describe, expect, it } from 'vitest';
import {
  equivalent,
  parseRate,
  type RateSnapshot,
  roundToUnit,
  type SnapshotCurrency,
  toBase,
} from './conversion.js';

// AP §8.6 (D14): amounts are integer minor units, rates exact fractions, and
// every result is rounded by an explicit rule; nothing passes through a float.

const lira: SnapshotCurrency = {
  code: 'TRY',
  decimals: 2,
  rate: { numerator: 1n, denominator: 1n },
  rateVersionId: null,
  roundingUnitMinor: 500n,
  roundingMode: 'nearest',
};
// 1 USD = 41.20 TRY.
const dollar: SnapshotCurrency = {
  code: 'USD',
  decimals: 2,
  rate: { numerator: 206n, denominator: 5n },
  rateVersionId: '0190f3a0-0000-7000-8000-0000000000a1',
  roundingUnitMinor: 50n,
  roundingMode: 'nearest',
};
// 1 TRY = 290 SYP.
const pound: SnapshotCurrency = {
  code: 'SYP',
  decimals: 2,
  rate: { numerator: 1n, denominator: 290n },
  rateVersionId: '0190f3a0-0000-7000-8000-0000000000a2',
  roundingUnitMinor: 50_000n,
  roundingMode: 'nearest',
};

function snapshot(...currencies: SnapshotCurrency[]): RateSnapshot {
  return {
    cityId: '0190f3a0-0000-7000-8000-0000000000c1',
    baseCurrency: 'TRY',
    takenAt: new Date('2026-11-05T09:00:00Z'),
    currencies: [lira, ...currencies],
  };
}

describe('rounding to a unit', () => {
  it('rounds to the nearest unit, a half going up', () => {
    expect(roundToUnit(1249n, 1n, 500n, 'nearest')).toBe(1000n);
    expect(roundToUnit(1250n, 1n, 500n, 'nearest')).toBe(1500n);
    expect(roundToUnit(1251n, 1n, 500n, 'nearest')).toBe(1500n);
  });

  it('rounds up and down', () => {
    expect(roundToUnit(1001n, 1n, 500n, 'up')).toBe(1500n);
    expect(roundToUnit(1499n, 1n, 500n, 'down')).toBe(1000n);
  });

  it('keeps an amount already on the unit in every mode', () => {
    for (const mode of ['nearest', 'up', 'down'] as const) {
      expect(roundToUnit(1500n, 1n, 500n, mode)).toBe(1500n);
    }
  });

  it('rounds a fraction of a minor unit', () => {
    // 2.5 minor units.
    expect(roundToUnit(5n, 2n, 1n, 'nearest')).toBe(3n);
    expect(roundToUnit(5n, 2n, 1n, 'down')).toBe(2n);
    expect(roundToUnit(5n, 2n, 1n, 'up')).toBe(3n);
  });

  it('rounds a negative amount towards the same side of the number line', () => {
    expect(roundToUnit(-1250n, 1n, 500n, 'nearest')).toBe(-1000n);
    expect(roundToUnit(-1251n, 1n, 500n, 'nearest')).toBe(-1500n);
    expect(roundToUnit(-1001n, 1n, 500n, 'up')).toBe(-1000n);
    expect(roundToUnit(-1001n, 1n, 500n, 'down')).toBe(-1500n);
  });

  it('refuses a unit or a denominator that is not positive', () => {
    expect(() => roundToUnit(100n, 1n, 0n, 'nearest')).toThrow();
    expect(() => roundToUnit(100n, 0n, 1n, 'nearest')).toThrow();
  });
});

describe('a rate as entered', () => {
  it('keeps the base units per unit of the currency as an exact fraction', () => {
    // «1 USD = 41.20 TRY»
    expect(parseRate({ value: '41.20', direction: 'base_per_unit' })).toEqual({
      numerator: 206n,
      denominator: 5n,
    });
  });

  it('turns the other direction into the same canonical form', () => {
    // «1 TRY = 290 SYP»
    expect(parseRate({ value: '290', direction: 'units_per_base' })).toEqual({
      numerator: 1n,
      denominator: 290n,
    });
    expect(parseRate({ value: '0.025', direction: 'units_per_base' })).toEqual({
      numerator: 40n,
      denominator: 1n,
    });
  });

  it.each([
    '0',
    '0.000',
    '-41.2',
    '41,20',
    '4.1e1',
    '',
    ' 41.2',
    '.5',
    '5.',
    '1234567890123456789',
  ])('refuses %j', (value) => {
    expect(() => parseRate({ value, direction: 'base_per_unit' })).toThrow();
  });
});

describe('the equivalent of a base amount', () => {
  it('converts through the rate and rounds by the currency rule', () => {
    // 410.00 TRY = 9.9514… USD, to the nearest 0.50 USD.
    expect(equivalent(snapshot(dollar), 41_000n, 'USD')).toBe(1000n);
    // 410.00 TRY = 118 900 SYP, on a 500 SYP unit.
    expect(equivalent(snapshot(pound), 41_000n, 'SYP')).toBe(11_900_000n);
  });

  it('follows the currency rounding mode', () => {
    const up = { ...dollar, roundingMode: 'up' as const };
    const down = { ...dollar, roundingMode: 'down' as const };
    // 400.00 TRY = 9.7087… USD.
    expect(equivalent(snapshot(up), 40_000n, 'USD')).toBe(1000n);
    expect(equivalent(snapshot(down), 40_000n, 'USD')).toBe(950n);
  });

  it('rounds the base currency by its own rule', () => {
    expect(equivalent(snapshot(), 40_240n, 'TRY')).toBe(40_000n);
  });

  it('works across different decimals', () => {
    const wholePound = { ...pound, decimals: 0, roundingUnitMinor: 500n };
    expect(equivalent(snapshot(wholePound), 41_000n, 'SYP')).toBe(119_000n);
  });

  it('refuses a currency outside the snapshot', () => {
    expect(() => equivalent(snapshot(dollar), 41_000n, 'SYP')).toThrow();
  });
});

describe('a payment line in base minor units', () => {
  it('converts exactly, to the nearest base minor unit', () => {
    // 10.00 USD = 412.00 TRY.
    expect(toBase(snapshot(dollar), 1000n, 'USD')).toBe(41_200n);
    // 1 000 SYP = 3.448… TRY.
    expect(toBase(snapshot(pound), 100_000n, 'SYP')).toBe(345n);
  });

  it('keeps a base amount as it is', () => {
    expect(toBase(snapshot(), 40_240n, 'TRY')).toBe(40_240n);
  });

  it('gives the same answer for any large amount, without floating point', () => {
    // 2^60 cents of USD: a float would lose the last digits.
    const amount = 1n << 60n;
    expect(toBase(snapshot(dollar), amount, 'USD')).toBe((amount * 206n) / 5n);
  });
});
