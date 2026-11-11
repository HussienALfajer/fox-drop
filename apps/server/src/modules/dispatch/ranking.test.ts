import { describe, expect, it } from 'vitest';
import { nearestThenFewestToday } from './ranking.js';

describe('nearestThenFewestToday (AP §9.12.6)', () => {
  it('puts the nearest first, and on a tie the fewest orders today', () => {
    const ranked = nearestThenFewestToday([
      { id: 'far', metres: 2400, ordersToday: 0 },
      { id: 'busy-day', metres: 900, ordersToday: 6 },
      { id: 'quiet-day', metres: 900, ordersToday: 2 },
      { id: 'near', metres: 300, ordersToday: 9 },
    ]);
    expect(ranked.map((entry) => entry.id)).toEqual(['near', 'quiet-day', 'busy-day', 'far']);
  });

  it('keeps the given order on a full tie, and leaves its input alone', () => {
    const entries = [
      { id: 'a', metres: 500, ordersToday: 1 },
      { id: 'b', metres: 500, ordersToday: 1 },
    ];
    expect(nearestThenFewestToday(entries).map((entry) => entry.id)).toEqual(['a', 'b']);
    expect(nearestThenFewestToday([])).toEqual([]);
    expect(entries[0]?.id).toBe('a');
  });
});
