import { describe, expect, it, vi } from 'vitest';
import {
  captainsOf,
  cityQueries,
  opsChannel,
  opsMapChannel,
  pollUnlessLive,
  staleQueries,
} from './live.js';

vi.mock('./api.js', () => ({ api: {} }));

const city = '019a0000-0000-7000-8000-000000000001';

// Architecture §6.2, §10.3: an event names what changed and the panel reads
// it again; after every (re)subscription it reads the city's full state.
describe('the ops channel', () => {
  it('is the city channel of architecture §6.2', () => {
    expect(opsChannel(city)).toBe(`ops:city.${city}`);
  });

  it("refreshes the board and the order's detail on an order event", () => {
    expect(staleQueries({ type: 'order.accepted', orderId: 'o1' }, city)).toEqual([
      ['orders-board', city],
      ['live-map', city],
      ['order', 'o1'],
    ]);
    // Slice 2.9: the item report and the time change are order events too.
    for (const type of [
      'order.time_changed',
      'order.item_reported',
      'order.item_report_withdrawn',
      'order.item_report_closed',
    ]) {
      expect(staleQueries({ type, orderId: 'o1' }, city)).toContainEqual(['order', 'o1']);
    }
  });

  it('refreshes the alerts and the cards that show them on an alert change', () => {
    for (const type of ['alert.raised', 'alert.acknowledged', 'alert.resolved']) {
      expect(staleQueries({ type }, city)).toEqual([
        ['alerts', city],
        ['orders-board', city],
        ['order'],
      ]);
    }
    expect(staleQueries({ type: 'platform.emergency_stop' }, city)).toEqual([
      ['emergency-stop', city],
    ]);
    expect(staleQueries({ type: 'restaurant.state_changed', restaurantId: 'r1' }, city)).toEqual([
      ['restaurant-status', 'r1'],
      ['live-map', city],
    ]);
    expect(staleQueries({ type: 'ticket.opened' }, city)).toEqual([]);
    // Slice 2.23a: a ticket opened or changed.
    expect(staleQueries({ type: 'ticket.changed', ticketId: 't1' }, city)).toEqual([
      ['tickets', city],
      ['ticket', 't1'],
      ['orders-board', city],
      ['order'],
    ]);
  });

  it('reads everything of the city again after a subscription', () => {
    expect(cityQueries(city)).toEqual([
      ['orders-board', city],
      ['order'],
      ['alerts', city],
      ['emergency-stop', city],
      ['restaurant-status'],
      ['tickets', city],
      ['ticket'],
      ['live-map', city],
    ]);
  });

  it('polls only while the city is not live (owner decision 2026-11-07)', () => {
    expect(pollUnlessLive(city, 10_000)()).toBe(10_000);
    expect(pollUnlessLive(undefined, 10_000)()).toBe(10_000);
  });
});

// Architecture §6.2, AP §9.4 (slice 2.39): the live map's channel carries
// the city's whole captains layer.
describe('the live map channel', () => {
  it('is the city map channel of architecture §6.2', () => {
    expect(opsMapChannel(city)).toBe(`ops_map:city.${city}`);
  });

  it('takes the captains of a captains publication only', () => {
    expect(captainsOf({ type: 'captains', captains: [{ captainId: 'c1' }] })).toEqual([
      { captainId: 'c1' },
    ]);
    expect(captainsOf({ type: 'other' })).toBeNull();
    expect(captainsOf({ type: 'captains' })).toBeNull();
  });
});
