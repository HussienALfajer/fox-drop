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

// The pure rule: each new price rounded to the base's rounding unit by its
// mode, and never below one unit while the change keeps it above 0.
export function bulkPrices(
  items: readonly { id: string; price: bigint }[],
  change: BulkPriceChange,
  rounding: { unit: bigint; mode: RoundingMode },
): BulkPriceResult {
  const sign = change.direction === 'up' ? 1n : -1n;
  if (change.kind === 'percent' && (!Number.isInteger(change.bp) || change.bp <= 0)) {
    throw new RangeError('a percentage is a whole number of basis points above 0');
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
    const after = rounded < rounding.unit ? rounding.unit : rounded;
    if (after === item.price) result.unchanged += 1;
    result.rows.push({ id: item.id, before: item.price, after });
  }
  return result;
}
