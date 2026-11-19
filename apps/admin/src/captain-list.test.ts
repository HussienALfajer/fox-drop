import { describe, expect, it, vi } from 'vitest';

vi.mock('./api.js', () => ({ api: {} }));

const { acceptancePercent, canSeeCaptains, captainListFilterOf, limitUsePercent, sortCaptains } =
  await import('./captain-list.js');

type Listed = Parameters<typeof sortCaptains>[0][number];

const session = (permissions: string[]) => ({ permissions }) as never;
const money = (amount: string) => ({ amount, currency: 'TRY' });

function captain(id: string, fields: Partial<Listed> = {}): Listed {
  return {
    id,
    name: id,
    maskedPhone: null,
    vehicle: 'motorbike',
    plateNumber: null,
    status: 'offline',
    applicationId: null,
    contractPhase: null,
    custody: { usage: money('0'), limit: money('100000'), closedDue: money('0') },
    earnings: money('0'),
    ordersToday: 0,
    acceptance: null,
    ratingAverage: null,
    ratingCount: 0,
    ...fields,
  };
}

// AP §9.7.3 «الكباتن» (slice 2.36a): who sees it, its search and its order.
describe('canSeeCaptains', () => {
  it('needs captains.read or captains.money', () => {
    expect(canSeeCaptains(session(['captains.read']))).toBe(true);
    expect(canSeeCaptains(session(['captains.money']))).toBe(true);
    expect(canSeeCaptains(session(['restaurants.read']))).toBe(false);
    expect(canSeeCaptains(null)).toBe(false);
  });
});

describe('captainListFilterOf', () => {
  it('keeps the known filters and drops the rest', () => {
    expect(
      captainListFilterOf({ status: 'busy', q: 'أحمد', sort: 'custody', dir: 'desc', x: 1 }),
    ).toEqual({ status: 'busy', q: 'أحمد', sort: 'custody', dir: 'desc' });
    expect(captainListFilterOf({ status: 'active', sort: 'phone', dir: 'up', q: '' })).toEqual({});
  });
});

describe('sortCaptains', () => {
  const rich = captain('b', {
    custody: { usage: money('90000'), limit: money('100000'), closedDue: money('0') },
  });
  const poor = captain('a', {
    custody: { usage: money('100'), limit: money('100000'), closedDue: money('0') },
  });
  it('puts the highest custody first', () => {
    expect(sortCaptains([poor, rich], 'custody', 'desc').map((each) => each.id)).toEqual([
      'b',
      'a',
    ]);
    expect(sortCaptains([rich, poor], 'name', 'asc').map((each) => each.id)).toEqual(['a', 'b']);
  });

  it('keeps a captain without a value last either way', () => {
    const rated = captain('r', { ratingAverage: 4.5, ratingCount: 3 });
    const low = captain('l', { ratingAverage: 2, ratingCount: 1 });
    const none = captain('n');
    expect(sortCaptains([none, low, rated], 'rating', 'desc').map((each) => each.id)).toEqual([
      'r',
      'l',
      'n',
    ]);
    expect(sortCaptains([none, rated, low], 'rating', 'asc').map((each) => each.id)).toEqual([
      'l',
      'r',
      'n',
    ]);
  });
});

describe('acceptancePercent and limitUsePercent', () => {
  it('round to whole percents', () => {
    expect(acceptancePercent({ acceptance: { accepted: 2, answered: 3 } })).toBe(67);
    expect(acceptancePercent({ acceptance: null })).toBeNull();
    expect(
      limitUsePercent({
        custody: { usage: money('150000'), limit: money('100000'), closedDue: money('0') },
      }),
    ).toBe(100);
    expect(
      limitUsePercent({
        custody: { usage: money('25000'), limit: money('100000'), closedDue: money('0') },
      }),
    ).toBe(25);
  });
});
