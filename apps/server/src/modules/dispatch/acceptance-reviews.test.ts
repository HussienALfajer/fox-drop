import { describe, expect, it } from 'vitest';
import { acceptanceRate, rateBelow } from './acceptance-reviews.js';

// AP §9.7.6 «below 50%», «below 70%»: compared unrounded, shown rounded.
describe('the acceptance rate', () => {
  it('compares before rounding', () => {
    const counts = { accepted: 124, answered: 250 }; // 49.6%
    expect(acceptanceRate(counts)).toBe(50);
    expect(rateBelow(counts, 50)).toBe(true);
    expect(rateBelow({ accepted: 1, answered: 2 }, 50)).toBe(false);
    expect(rateBelow(undefined, 50)).toBe(false);
    expect(acceptanceRate(undefined)).toBeNull();
  });
});
