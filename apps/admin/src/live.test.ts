import { describe, expect, it, vi } from 'vitest';
import { cityQueries, opsChannel, pollUnlessLive, staleQueries } from './live.js';

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
      ['order', 'o1'],
    ]);
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
    ]);
    expect(staleQueries({ type: 'ticket.opened' }, city)).toEqual([]);
  });

  it('reads everything of the city again after a subscription', () => {
    expect(cityQueries(city)).toEqual([
      ['orders-board', city],
      ['order'],
      ['alerts', city],
      ['emergency-stop', city],
      ['restaurant-status'],
    ]);
  });

  it('polls only while the city is not live (owner decision 2026-11-07)', () => {
    expect(pollUnlessLive(city, 10_000)()).toBe(10_000);
    expect(pollUnlessLive(undefined, 10_000)()).toBe(10_000);
  });
});
