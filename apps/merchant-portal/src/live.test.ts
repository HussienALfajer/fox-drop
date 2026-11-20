import { describe, expect, it, vi } from 'vitest';
import { merchantChannel, staleKeys } from './live.js';

vi.mock('./api.js', () => ({ api: {} }));

describe('the restaurant channel (RA §4.3, §17)', () => {
  it('follows the restaurant’s own channel', () => {
    expect(merchantChannel('r1')).toBe('merchant:r1');
  });

  it('reads again what an event changed', () => {
    expect(staleKeys({ type: 'order.accepted', orderId: 'o1' })).toEqual([
      ['board'],
      ['order', 'o1'],
    ]);
    expect(staleKeys({ type: 'restaurant.state_changed' })).toEqual([
      ['restaurant-status'],
      ['restaurant-hours'],
    ]);
    expect(staleKeys({ type: 'restaurant.state_changed', kind: 'menu_changed' })).toEqual([
      ['restaurant-status'],
      ['menu'],
      ['menu-price-log'],
      ['menu-preview'],
    ]);
    expect(staleKeys({ type: 'restaurant.state_changed', kind: 'paused' })).toEqual([
      ['restaurant-status'],
      ['restaurant-hours'],
    ]);
    expect(staleKeys({ type: 'platform.emergency_stop' })).toEqual([['emergency-stop']]);
    expect(staleKeys({ type: 'platform.app_changed' })).toEqual([]);
  });
});
