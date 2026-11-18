import { describe, expect, it, vi } from 'vitest';

vi.mock('./api.js', () => ({ api: {} }));

const { canSeeRatings, nextRatingsPage, ratingsSearch } = await import('./ratings.js');

const session = (permissions: string[]) => ({ permissions }) as never;

// AP §9.6.4, §9.7.4 (slice 2.26c): the panel's «التقييمات».
describe('canSeeRatings', () => {
  it('needs restaurants.read or captains.read', () => {
    expect(canSeeRatings(session(['restaurants.read']))).toBe(true);
    expect(canSeeRatings(session(['captains.read']))).toBe(true);
    // FIN reads neither (AP §6.2).
    expect(canSeeRatings(session(['captains.money', 'restaurants.statements']))).toBe(false);
    expect(canSeeRatings(null)).toBe(false);
  });
});

describe('ratingsSearch', () => {
  it('keeps a restaurant or a captain, the period and the stars', () => {
    expect(ratingsSearch({ city: 'azaz', captain: 'c1', period: 'today', stars: '2' })).toEqual({
      city: 'azaz',
      captain: 'c1',
      period: 'today',
      stars: 2,
    });
    // The restaurant wins over a captain; «الكل» is the default.
    expect(ratingsSearch({ restaurant: 'r1', captain: 'c1', period: 'all' })).toEqual({
      restaurant: 'r1',
    });
  });

  it('drops what it cannot read', () => {
    expect(ratingsSearch({ period: 'week', stars: '6', restaurant: 3 })).toEqual({});
    expect(ratingsSearch({ stars: '2.5' })).toEqual({});
  });
});

describe('nextRatingsPage', () => {
  const page = (more: boolean, asOf: string) => ({
    asOf,
    count: 0,
    average: null,
    distribution: [],
    ratings: [],
    more,
  });

  it('reads the next page as of the first', () => {
    const first = page(true, '2026-11-18T10:00:00.000Z');
    const second = page(true, '2026-11-18T10:00:00.000Z');
    expect(nextRatingsPage(second, [first, second])).toEqual({
      page: 2,
      asOf: '2026-11-18T10:00:00.000Z',
    });
    expect(nextRatingsPage(page(false, first.asOf), [first])).toBeUndefined();
  });
});
