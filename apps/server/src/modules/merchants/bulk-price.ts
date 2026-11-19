import { type RoundingMode, roundToUnit } from '../fx/index.js';

// AP §9.6.6 «تعديل جماعي»: raise or lower by a percentage (in basis points,
// 1000 is 10%) or by a fixed amount in minor units of the base.
export type BulkPriceChange =
  | { kind: 'percent'; direction: 'up' | 'down'; bp: number }
  | { kind: 'amount'; direction: 'up' | 'down'; amount: bigint };

export interface BulkPriceResult {
  // Every price that stays above 0, before and after (an unchanged one too).
  rows: { id: string; before: bigint; after: bigint }[];
  // The prices the change would bring to 0 or below: refused, never set to
  // the floor (decided by us, slice 2.31).
  refused: { id: string; before: bigint }[];
  // The rows whose price the rounding left as it was.
  unchanged: number;
}

// The largest change by a percentage (1000%) and the largest price (15
// digits, the API's bound) a bulk change may reach.
export const BULK_MAX_BP = 100_000;
const PRICE_MAX = 999_999_999_999_999n;

// The pure rule: each new price rounded to the base's rounding unit by its
// mode, and never below one unit while the change keeps it above 0. A price
// off the unit's grid never moves against the direction asked: a lowering
// never raises it and a raise never lowers it.
export function bulkPrices(
  items: readonly { id: string; price: bigint }[],
  change: BulkPriceChange,
  rounding: { unit: bigint; mode: RoundingMode },
): BulkPriceResult {
  const sign = change.direction === 'up' ? 1n : -1n;
  if (
    change.kind === 'percent' &&
    (!Number.isInteger(change.bp) || change.bp <= 0 || change.bp > BULK_MAX_BP)
  ) {
    throw new RangeError('a percentage is a whole number of basis points, 1 to 100000');
  }
  if (change.kind === 'amount' && change.amount <= 0n) {
    throw new RangeError('an amount is above 0');
  }
  const result: BulkPriceResult = { rows: [], refused: [], unchanged: 0 };
  for (const item of items) {
    // The raw new price as a fraction, numerator over denominator.
    const [numerator, denominator] =
      change.kind === 'percent'
        ? [item.price * (10_000n + sign * BigInt(change.bp)), 10_000n]
        : [item.price + sign * change.amount, 1n];
    if (numerator <= 0n) {
      result.refused.push({ id: item.id, before: item.price });
      continue;
    }
    const rounded = roundToUnit(numerator, denominator, rounding.unit, rounding.mode);
    const floored = rounded < rounding.unit ? rounding.unit : rounded;
    const after =
      change.direction === 'down'
        ? floored < item.price
          ? floored
          : item.price
        : floored > item.price
          ? floored
          : item.price;
    if (after > PRICE_MAX) throw new RangeError('a new price is above 15 digits');
    if (after === item.price) result.unchanged += 1;
    result.rows.push({ id: item.id, before: item.price, after });
  }
  return result;
}
