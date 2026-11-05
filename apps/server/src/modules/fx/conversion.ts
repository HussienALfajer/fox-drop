// Conversion and rounding of AP §8.6 (D14) in integer minor units and exact
// fractions: no amount or rate ever passes through a float (architecture §5.2).

// Base major units per one major unit of the currency, as an exact reduced
// fraction (AP §8.6: "one canonical value with high precision"). The base
// currency's own rate is 1/1.
export interface Rate {
  numerator: bigint;
  denominator: bigint;
}

export const roundingModes = ['nearest', 'up', 'down'] as const;
export type RoundingMode = (typeof roundingModes)[number];

// How the panel accepts a rate (AP §8.6): «1 USD = 41.20 TRY» is base units
// per unit, «1 TRY = 290 SYP» units per base unit. The value is a plain
// decimal such as 41.20.
export interface RateInput {
  value: string;
  direction: 'base_per_unit' | 'units_per_base';
}

// One accepted currency as an order keeps it: its rate version and its
// rounding rule when the snapshot was taken.
export interface SnapshotCurrency {
  code: string;
  decimals: number;
  rate: Rate;
  // Null for the base currency.
  rateVersionId: string | null;
  // In minor units of this currency, such as 50 for 0.50 USD.
  roundingUnitMinor: bigint;
  roundingMode: RoundingMode;
}

// The rates an order keeps (AP §8.6, architecture §5.2): every later
// calculation for the order uses it, never the current rates.
export interface RateSnapshot {
  cityId: string;
  baseCurrency: string;
  takenAt: Date;
  // The enabled accepted currencies in display order, the base among them.
  currencies: SnapshotCurrency[];
}

// A rate the server cannot use: the caller's input or the city's data.
export class InvalidRateError extends Error {
  override readonly name = 'InvalidRateError';
}

const decimal = /^(\d+)(?:\.(\d+))?$/;
const MAX_DIGITS = 18;
// The largest PostgreSQL bigint, which holds each part of a stored rate.
const MAX_PART = 9_223_372_036_854_775_807n;

export function parseRate(input: RateInput): Rate {
  const match = decimal.exec(input.value);
  if (!match) throw new InvalidRateError(`${JSON.stringify(input.value)} is not a decimal number`);
  const [, whole, fraction = ''] = match;
  const digits = (whole! + fraction).replace(/^0+/, '');
  if (digits.length > MAX_DIGITS) {
    throw new InvalidRateError(`a rate has at most ${MAX_DIGITS} significant digits`);
  }
  const scaled = BigInt(whole! + fraction);
  if (scaled === 0n) throw new InvalidRateError('a rate is above zero');
  const scale = 10n ** BigInt(fraction.length);
  const rate = input.direction === 'base_per_unit' ? reduce(scaled, scale) : reduce(scale, scaled);
  if (rate.numerator > MAX_PART || rate.denominator > MAX_PART) {
    throw new InvalidRateError('the rate is too small or too large to store exactly');
  }
  return rate;
}

export function reduce(numerator: bigint, denominator: bigint): Rate {
  const divisor = gcd(numerator, denominator);
  return { numerator: numerator / divisor, denominator: denominator / divisor };
}

// numerator/denominator minor units, rounded to a multiple of the unit:
// nearest with a half going up, up towards +∞, down towards −∞.
export function roundToUnit(
  numerator: bigint,
  denominator: bigint,
  unit: bigint,
  mode: RoundingMode,
): bigint {
  if (unit <= 0n || denominator <= 0n)
    throw new RangeError('the unit and denominator are above zero');
  const whole = denominator * unit;
  switch (mode) {
    case 'down':
      return floorDiv(numerator, whole) * unit;
    case 'up':
      return -floorDiv(-numerator, whole) * unit;
    case 'nearest':
      return floorDiv(2n * numerator + whole, 2n * whole) * unit;
  }
}

// What a customer sees beside the base total (AP §8.6): a base amount in
// another accepted currency, rounded by that currency's rule.
export function equivalent(snapshot: RateSnapshot, baseAmountMinor: bigint, code: string): bigint {
  const target = currencyOf(snapshot, code);
  const [numerator, denominator] = convert(baseAmountMinor, baseOf(snapshot), target);
  return roundToUnit(numerator, denominator, target.roundingUnitMinor, target.roundingMode);
}

// A payment line in base minor units, to the nearest one (AP §8.6: the lines
// are converted with the order snapshot before the net is compared).
export function toBase(snapshot: RateSnapshot, amountMinor: bigint, code: string): bigint {
  const [numerator, denominator] = convert(
    amountMinor,
    currencyOf(snapshot, code),
    baseOf(snapshot),
  );
  return roundToUnit(numerator, denominator, 1n, 'nearest');
}

// amount × from.rate ÷ to.rate, moved between the two minor units, as an
// exact fraction of the target's minor units.
function convert(
  amountMinor: bigint,
  from: SnapshotCurrency,
  to: SnapshotCurrency,
): [bigint, bigint] {
  const shift = to.decimals - from.decimals;
  return [
    amountMinor * from.rate.numerator * to.rate.denominator * 10n ** BigInt(Math.max(shift, 0)),
    from.rate.denominator * to.rate.numerator * 10n ** BigInt(Math.max(-shift, 0)),
  ];
}

function currencyOf(snapshot: RateSnapshot, code: string): SnapshotCurrency {
  const currency = snapshot.currencies.find((candidate) => candidate.code === code);
  if (!currency) throw new InvalidRateError(`${code} is not in the order's rate snapshot`);
  return currency;
}

function baseOf(snapshot: RateSnapshot): SnapshotCurrency {
  return currencyOf(snapshot, snapshot.baseCurrency);
}

function floorDiv(numerator: bigint, denominator: bigint): bigint {
  const quotient = numerator / denominator;
  return numerator % denominator !== 0n && numerator < 0n !== denominator < 0n
    ? quotient - 1n
    : quotient;
}

function gcd(a: bigint, b: bigint): bigint {
  while (b !== 0n) [a, b] = [b, a % b];
  return a;
}
