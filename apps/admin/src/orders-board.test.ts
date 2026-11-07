import { describe, expect, it, vi } from 'vitest';
import {
  columns,
  effectiveFilter,
  elapsed,
  filterCards,
  filterChoices,
  NO_FILTER,
  type OrderCard,
  sla,
} from './orders-board.js';

vi.mock('./api.js', () => ({ api: {} }));

const at = (minutes: number) => new Date(Date.UTC(2026, 10, 7, 9, minutes)).toISOString();
const now = (minutes: number) => Date.UTC(2026, 10, 7, 9, minutes);

function card(overrides: Partial<OrderCard>): OrderCard {
  return {
    id: '01900000-0000-7000-8000-00000000000a',
    number: '10001',
    status: 'placed',
    version: 1,
    placedAt: at(0),
    restaurant: { id: 'r1', name: 'مطعم' },
    neighbourhood: 'الحي الأول',
    statusSince: at(0),
    limitAt: at(10),
    captainTrack: null,
    captain: null,
    total: { amount: '1000', currency: 'USD' },
    badges: { needsAssignment: false, note: false, newCustomer: false, pickupPending: false },
    moments: {
      acceptAlertAt: null,
      prepLateAlertAt: null,
      searchStartedAt: null,
      searchAlertAt: null,
      noCaptainAlertAt: null,
      captainArrivedAt: null,
      captainWaitingAlertAt: null,
    },
    alerts: [],
    ...overrides,
  };
}

// AP §9.2.1: green within the limit, amber from 80% of it, red past it.
describe('sla', () => {
  it('is green below 80% of the limit, amber from 80% and red from the limit', () => {
    const order = card({});
    expect(sla(order, now(7))).toBe('green');
    expect(sla(order, now(8))).toBe('amber');
    expect(sla(order, now(9))).toBe('amber');
    expect(sla(order, now(10))).toBe('red');
  });

  it('has no colour where the column has no limit yet', () => {
    expect(sla(card({ limitAt: null }), now(30))).toBeNull();
  });
});

describe('columns', () => {
  it('puts each card in its status column and counts the late ones', () => {
    const board = columns(
      [card({ id: 'a' }), card({ id: 'b', limitAt: at(20) }), card({ id: 'c', status: 'ready' })],
      now(12),
    );
    expect(board.map((column) => column.status)).toEqual([
      'placed',
      'accepted',
      'ready',
      'picked_up',
      'arrived',
    ]);
    expect(board[0]).toMatchObject({ late: 1 });
    expect(board[0]?.cards.map((each) => each.id)).toEqual(['a', 'b']);
    expect(board[2]).toMatchObject({ late: 1 });
    expect(board[1]?.cards).toEqual([]);
  });
});

describe('filterCards', () => {
  const captain = { id: 'k1', name: 'سامر', vehicle: 'motorbike' };
  const cards = [
    card({ id: 'a' }),
    card({ id: 'b', captain, limitAt: at(30) }),
    card({ id: 'c', restaurant: { id: 'r2', name: 'آخر' }, neighbourhood: 'الحي الثاني' }),
  ];
  const ids = (shown: OrderCard[]) => shown.map((each) => each.id);

  it('keeps the late ones, those without a captain, or those of a restaurant, captain or neighbourhood', () => {
    expect(ids(filterCards(cards, NO_FILTER, now(12)))).toEqual(['a', 'b', 'c']);
    expect(ids(filterCards(cards, { ...NO_FILTER, lateOnly: true }, now(12)))).toEqual(['a', 'c']);
    expect(ids(filterCards(cards, { ...NO_FILTER, noCaptainOnly: true }, now(12)))).toEqual([
      'a',
      'c',
    ]);
    expect(ids(filterCards(cards, { ...NO_FILTER, restaurantId: 'r2' }, now(12)))).toEqual(['c']);
    expect(ids(filterCards(cards, { ...NO_FILTER, captainId: 'k1' }, now(12)))).toEqual(['b']);
    expect(
      ids(filterCards(cards, { ...NO_FILTER, neighbourhood: 'الحي الثاني' }, now(12))),
    ).toEqual(['c']);
  });
});

describe('elapsed', () => {
  it('shows minutes and seconds, never below zero', () => {
    expect(elapsed(at(0), now(12) + 5000)).toBe('12:05');
    expect(elapsed(at(5), now(0))).toBe('0:00');
  });
});

describe('effectiveFilter', () => {
  it('drops a choice whose last order left the board, so no live order hides behind «الكل»', () => {
    const choices = filterChoices([card({})]);
    const stale = { ...NO_FILTER, restaurantId: 'gone', captainId: 'gone', neighbourhood: 'gone' };
    expect(effectiveFilter(stale, choices)).toEqual(NO_FILTER);
    const kept = { ...NO_FILTER, restaurantId: 'r1', neighbourhood: 'الحي الأول', lateOnly: true };
    expect(effectiveFilter(kept, choices)).toEqual(kept);
  });
});
