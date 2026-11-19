import { describe, expect, it } from 'vitest';
import { bulkPrices } from './bulk-price.js';

// AP §9.6.6 «تعديل جماعي» (slice 2.31): by % or a fixed amount, up or down,
// rounded to the base's rounding unit.
const lira = { unit: 100n, mode: 'nearest' as const };
const items = [
  { id: 'a', price: 12_000n },
  { id: 'b', price: 9_950n },
  { id: 'c', price: 150n },
];

describe('bulkPrices', () => {
  it('raises by a percentage, rounded to the unit', () => {
    expect(bulkPrices(items, { kind: 'percent', direction: 'up', bp: 1000 }, lira)).toEqual({
      rows: [
        { id: 'a', before: 12_000n, after: 13_200n },
        { id: 'b', before: 9_950n, after: 10_900n },
        { id: 'c', before: 150n, after: 200n },
      ],
      refused: [],
      unchanged: 0,
    });
  });

  it('lowers by a percentage, never below one unit', () => {
    expect(bulkPrices(items, { kind: 'percent', direction: 'down', bp: 7500 }, lira).rows).toEqual([
      { id: 'a', before: 12_000n, after: 3_000n },
      { id: 'b', before: 9_950n, after: 2_500n },
      { id: 'c', before: 150n, after: 100n },
    ]);
  });

  it('adds or takes off a fixed amount, rounded the same way', () => {
    expect(
      bulkPrices(items, { kind: 'amount', direction: 'up', amount: 1_000n }, lira).rows,
    ).toEqual([
      { id: 'a', before: 12_000n, after: 13_000n },
      { id: 'b', before: 9_950n, after: 11_000n },
      { id: 'c', before: 150n, after: 1_200n },
    ]);
    const lowered = bulkPrices(items, { kind: 'amount', direction: 'down', amount: 9_950n }, lira);
    expect(lowered.rows).toEqual([{ id: 'a', before: 12_000n, after: 2_100n }]);
    // A price that would reach 0 or less is refused, never set to the floor.
    expect(lowered.refused).toEqual([
      { id: 'b', before: 9_950n },
      { id: 'c', before: 150n },
    ]);
  });

  it('follows the rounding mode and counts the prices left as they were', () => {
    const up = { unit: 500n, mode: 'up' as const };
    expect(
      bulkPrices(
        [
          { id: 'a', price: 10_000n },
          { id: 'b', price: 10_100n },
        ],
        { kind: 'percent', direction: 'up', bp: 1 },
        up,
      ),
    ).toEqual({
      rows: [
        { id: 'a', before: 10_000n, after: 10_500n },
        { id: 'b', before: 10_100n, after: 10_500n },
      ],
      refused: [],
      unchanged: 0,
    });
    const nearest = bulkPrices(
      [{ id: 'a', price: 10_000n }],
      { kind: 'percent', direction: 'up', bp: 1 },
      { unit: 500n, mode: 'nearest' },
    );
    expect(nearest).toEqual({
      rows: [{ id: 'a', before: 10_000n, after: 10_000n }],
      refused: [],
      unchanged: 1,
    });
  });

  it('refuses a change of nothing', () => {
    expect(() => bulkPrices(items, { kind: 'percent', direction: 'up', bp: 0 }, lira)).toThrow(
      RangeError,
    );
    expect(() =>
      bulkPrices(items, { kind: 'amount', direction: 'down', amount: 0n }, lira),
    ).toThrow(RangeError);
  });
});
