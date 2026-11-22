import fc from 'fast-check';
import { describe, expect, it } from 'vitest';
import {
  equivalent,
  exchange,
  parseRate,
  type Rate,
  type RateSnapshot,
  reduce,
  roundingModes,
  roundToUnit,
  type SnapshotCurrency,
  toBase,
} from './conversion.js';

// AP §8.6 (D14), architecture §5.2: the rounding and conversion rules hold
// for any amount, rate and rounding unit, not only the worked examples of
// conversion.test.ts. Phase 7 item 2 of docs/claude-code-workflow.md.

const mode = fc.constantFrom(...roundingModes);
// Minor units well past any real order, so an overflow or a float would show.
const amount = fc.bigInt({ min: -(10n ** 15n), max: 10n ** 15n });
const positive = fc.bigInt({ min: 1n, max: 10n ** 12n });
const denominator = fc.bigInt({ min: 1n, max: 10n ** 9n });
const unit = fc.bigInt({ min: 1n, max: 100_000n });
const rate: fc.Arbitrary<Rate> = fc
  .tuple(fc.bigInt({ min: 1n, max: 10n ** 7n }), fc.bigInt({ min: 1n, max: 10n ** 7n }))
  .map(([numerator, denominator]) => reduce(numerator, denominator));

// A city's snapshot: the base (rate 1/1) and two other currencies, each with
// its own decimals, rate, rounding unit and mode.
const snapshot: fc.Arbitrary<RateSnapshot> = fc
  .tuple(
    fc.integer({ min: 0, max: 3 }),
    unit,
    mode,
    fc.array(fc.tuple(fc.integer({ min: 0, max: 3 }), rate, unit, mode), {
      minLength: 2,
      maxLength: 2,
    }),
  )
  .map(([decimals, baseUnit, baseMode, others]) => ({
    cityId: '0190f3a0-0000-7000-8000-0000000000c1',
    baseCurrency: 'TRY',
    takenAt: new Date('2026-11-22T09:00:00Z'),
    currencies: [
      {
        code: 'TRY',
        decimals,
        rate: { numerator: 1n, denominator: 1n },
        rateVersionId: null,
        roundingUnitMinor: baseUnit,
        roundingMode: baseMode,
      },
      ...others.map(
        ([decimals, rate, roundingUnitMinor, roundingMode], index): SnapshotCurrency => ({
          code: ['USD', 'SYP'][index]!,
          decimals,
          rate,
          rateVersionId: `0190f3a0-0000-7000-8000-0000000000a${index}`,
          roundingUnitMinor,
          roundingMode,
        }),
      ),
    ],
  }));

const abs = (value: bigint) => (value < 0n ? -value : value);
const gcd = (a: bigint, b: bigint): bigint => (b === 0n ? a : gcd(b, a % b));
const currency = (snapshot: RateSnapshot, code: string) =>
  snapshot.currencies.find((each) => each.code === code)!;
// The rounding unit of a currency in base minor units, as checkLines and
// the door's tolerance read it.
const unitInBase = (snapshot: RateSnapshot, code: string) =>
  toBase(snapshot, currency(snapshot, code).roundingUnitMinor, code);

describe('rounding to a unit, for any amount (AP §8.6)', () => {
  it('lands on a multiple of the unit, between the floor and the ceiling', () => {
    fc.assert(
      fc.property(amount, denominator, unit, (numerator, denominator, unit) => {
        const down = roundToUnit(numerator, denominator, unit, 'down');
        const up = roundToUnit(numerator, denominator, unit, 'up');
        const nearest = roundToUnit(numerator, denominator, unit, 'nearest');
        for (const rounded of [down, up, nearest]) expect(rounded % unit).toBe(0n);
        expect(down * denominator <= numerator).toBe(true);
        expect(up * denominator >= numerator).toBe(true);
        const exact = numerator % (denominator * unit) === 0n;
        expect(up - down).toBe(exact ? 0n : unit);
        expect([down, up]).toContain(nearest);
      }),
    );
  });

  it('rounds to the nearest multiple, a half going up', () => {
    fc.assert(
      fc.property(amount, denominator, unit, (numerator, denominator, unit) => {
        const nearest = roundToUnit(numerator, denominator, unit, 'nearest');
        const gap = 2n * (nearest * denominator - numerator);
        // Within half a unit, and a half exactly goes towards +∞.
        expect(gap <= unit * denominator && gap > -unit * denominator).toBe(true);
      }),
    );
  });

  it('rounds down as the mirror of rounding up', () => {
    fc.assert(
      fc.property(amount, denominator, unit, (numerator, denominator, unit) => {
        expect(roundToUnit(-numerator, denominator, unit, 'down')).toBe(
          -roundToUnit(numerator, denominator, unit, 'up'),
        );
      }),
    );
  });

  it('never puts a larger amount below a smaller one', () => {
    fc.assert(
      fc.property(amount, amount, denominator, unit, mode, (a, b, denominator, unit, mode) => {
        const [low, high] = a <= b ? [a, b] : [b, a];
        expect(
          roundToUnit(low, denominator, unit, mode) <= roundToUnit(high, denominator, unit, mode),
        ).toBe(true);
      }),
    );
  });
});

describe('a rate as entered, for any decimal (AP §8.6)', () => {
  const decimal = fc
    .tuple(fc.bigInt({ min: 0n, max: 10n ** 8n }), fc.stringMatching(/^\d{0,8}$/))
    .filter(([whole, fraction]) => whole > 0n || /[1-9]/.test(fraction));

  it('keeps the exact value, reduced, in both directions', () => {
    fc.assert(
      fc.property(decimal, ([whole, fraction]) => {
        const value = fraction === '' ? `${whole}` : `${whole}.${fraction}`;
        const scaled = BigInt(`${whole}${fraction}`);
        const scale = 10n ** BigInt(fraction.length);
        const perUnit = parseRate({ value, direction: 'base_per_unit' });
        const perBase = parseRate({ value, direction: 'units_per_base' });
        expect(perUnit.numerator * scale).toBe(scaled * perUnit.denominator);
        expect(perBase).toEqual({ numerator: perUnit.denominator, denominator: perUnit.numerator });
        expect(gcd(perUnit.numerator, perUnit.denominator)).toBe(1n);
      }),
    );
  });
});

describe('conversion at an order snapshot, for any rates (AP §8.6)', () => {
  it('keeps a base amount as it is', () => {
    fc.assert(
      fc.property(snapshot, amount, (snapshot, amount) => {
        expect(toBase(snapshot, amount, 'TRY')).toBe(amount);
        expect(exchange(snapshot, amount, 'TRY', 'TRY')).toBe(
          roundToUnit(
            amount,
            1n,
            currency(snapshot, 'TRY').roundingUnitMinor,
            currency(snapshot, 'TRY').roundingMode,
          ),
        );
      }),
    );
  });

  it('never gives a larger amount less than a smaller one', () => {
    fc.assert(
      fc.property(
        snapshot,
        positive,
        positive,
        fc.constantFrom('USD', 'SYP'),
        (snapshot, a, b, code) => {
          const [low, high] = a <= b ? [a, b] : [b, a];
          expect(toBase(snapshot, low, code) <= toBase(snapshot, high, code)).toBe(true);
          expect(equivalent(snapshot, low, code) <= equivalent(snapshot, high, code)).toBe(true);
          expect(
            exchange(snapshot, low, code, 'TRY') <= exchange(snapshot, high, code, 'TRY'),
          ).toBe(true);
        },
      ),
    );
  });

  it('adds up to within one minor unit, however large the amounts', () => {
    fc.assert(
      fc.property(
        snapshot,
        fc.bigInt({ min: 0n, max: 10n ** 18n }),
        fc.bigInt({ min: 0n, max: 10n ** 18n }),
        fc.constantFrom('USD', 'SYP'),
        (snapshot, a, b, code) => {
          const apart = toBase(snapshot, a, code) + toBase(snapshot, b, code);
          expect(abs(toBase(snapshot, a + b, code) - apart) <= 1n).toBe(true);
        },
      ),
    );
  });

  // The way back of what the customer sees beside the base total: the base
  // amount in another currency by its rule, then that line in the base, is
  // off by at most the currency's rounding unit (half of it to the nearest),
  // plus the base's own minor unit.
  it('comes back to the base amount within the rounding unit', () => {
    fc.assert(
      fc.property(snapshot, positive, fc.constantFrom('USD', 'SYP'), (snapshot, due, code) => {
        const back = toBase(snapshot, equivalent(snapshot, due, code), code);
        const gap = abs(back - due);
        const tolerance = unitInBase(snapshot, code);
        if (currency(snapshot, code).roundingMode === 'nearest') {
          expect(2n * gap <= tolerance + 1n).toBe(true);
        } else {
          expect(gap <= tolerance + 1n).toBe(true);
        }
      }),
    );
  });
});
