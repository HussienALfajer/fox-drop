import { describe, expect, it, vi } from 'vitest';
import {
  type BoardOrder,
  boardColumns,
  captainLine,
  columnOf,
  isLate,
  itemCount,
  timerOf,
} from './board.js';

vi.mock('./api.js', () => ({ api: {} }));

const now = Date.parse('2026-11-20T12:00:00Z');
const at = (minutes: number) => new Date(now + minutes * 60_000).toISOString();

function order(overrides: Partial<BoardOrder>): BoardOrder {
  return {
    id: crypto.randomUUID(),
    number: '10001',
    redeliveryOf: null,
    testOrder: false,
    status: 'placed',
    version: 1,
    placedAt: at(-2),
    acceptAlertAt: at(1),
    autoCancelAt: at(3),
    acceptance: null,
    readyAt: null,
    customer: { firstName: 'سامر', neighbourhood: 'الحي الشمالي' },
    note: null,
    lines: [
      {
        itemId: crypto.randomUUID(),
        name: 'شاورما',
        quantity: 2,
        options: [],
        note: null,
        lineTotal: '20000',
      },
    ],
    currency: 'TRY',
    itemsValue: '20000',
    owner: null,
    captainTrack: null,
    captain: null,
    captainArrival: null,
    itemReport: null,
    edits: [],
    cancellation: null,
    pickup: {
      request: null,
      pickedUpAt: null,
      readyNotPressed: false,
      disputeUntil: null,
      disputedAt: null,
    },
    ...overrides,
  };
}

const accepted = (dueInMinutes: number) =>
  order({
    status: 'accepted',
    acceptance: {
      at: at(-10),
      prepMin: 20,
      prepDueAt: at(dueInMinutes),
      deviceName: null,
      byOperations: false,
    },
  });

describe('the read-only board (RA §8.1–8.2, §17)', () => {
  it('puts each status in its column and leaves out what ended', () => {
    expect(columnOf({ status: 'placed' })).toBe('incoming');
    expect(columnOf({ status: 'accepted' })).toBe('preparing');
    expect(columnOf({ status: 'ready' })).toBe('ready');
    expect(columnOf({ status: 'picked_up' })).toBe('with_captain');
    expect(columnOf({ status: 'arrived' })).toBe('with_captain');
    for (const status of ['delivered', 'cancelled', 'rejected', 'failed'] as const) {
      expect(columnOf({ status })).toBeNull();
    }
  });

  it('marks a new order past its accept alert and a preparation past its time late', () => {
    expect(isLate(order({ acceptAlertAt: at(-1) }), now)).toBe(true);
    expect(isLate(order({ acceptAlertAt: at(1) }), now)).toBe(false);
    expect(isLate(accepted(-1), now)).toBe(true);
    expect(isLate(accepted(5), now)).toBe(false);
  });

  it('sorts the new oldest first and the late preparations on top', () => {
    const older = order({ placedAt: at(-5) });
    const newer = order({ placedAt: at(-1) });
    const late = accepted(-3);
    const soon = accepted(2);
    const later = accepted(9);
    const board = boardColumns([newer, later, soon, older, late], now);
    expect(board.incoming).toEqual([older, newer]);
    expect(board.preparing).toEqual([late, soon, later]);
  });

  it('puts a ready order whose captain waits on top', () => {
    const waiting = order({
      status: 'ready',
      readyAt: at(-1),
      captainArrival: { at: at(-4), waitingAlertAt: at(1) },
    });
    const plain = order({ status: 'ready', readyAt: at(-8) });
    expect(boardColumns([plain, waiting], now).ready).toEqual([waiting, plain]);
  });

  it('writes the captain line of the track', () => {
    expect(captainLine(order({ captainTrack: 'searching' }), now)).toEqual({ key: 'waiting' });
    expect(
      captainLine(
        order({ captainTrack: 'assigned', captain: { firstName: 'أحمد', vehicle: 'motorbike' } }),
        now,
      ),
    ).toEqual({ key: 'onTheWay', name: 'أحمد' });
    expect(
      captainLine(
        order({
          captainTrack: 'at_merchant',
          captainArrival: { at: at(-6), waitingAlertAt: at(-1) },
        }),
        now,
      ),
    ).toEqual({ key: 'atRestaurant', minutes: 6 });
    expect(captainLine(order({ captainTrack: null }), now)).toBeNull();
  });

  it('runs the column timer', () => {
    expect(timerOf(order({ autoCancelAt: at(2) }), now)).toEqual({
      key: 'autoCancel',
      ms: 120_000,
    });
    expect(timerOf(accepted(3), now)).toEqual({ key: 'prepLeft', ms: 180_000 });
    expect(timerOf(accepted(-4), now)).toEqual({ key: 'prepLate', minutes: 4 });
    expect(
      timerOf(
        order({ status: 'ready', captainArrival: { at: at(-2), waitingAlertAt: at(3) } }),
        now,
      ),
    ).toEqual({ key: 'captainWaiting', ms: 120_000 });
    expect(timerOf(order({ status: 'picked_up' }), now)).toBeNull();
  });

  it('counts the quantities', () => {
    expect(itemCount(order({}))).toBe(2);
  });
});
