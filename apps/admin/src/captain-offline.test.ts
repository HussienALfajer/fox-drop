import { describe, expect, it, vi } from 'vitest';
import { canForceOffline } from './captain-offline.js';

vi.mock('./api.js', () => ({ api: {} }));

// AP §9.7.5 «فصل من الاتصال»: while the captain is online in any way, and
// not again once operations forced last-order mode (K18).
describe('canForceOffline', () => {
  it('needs an online captain not already forced', () => {
    for (const state of ['online_available', 'busy', 'not_receiving_offers'] as const) {
      expect(canForceOffline({ state, lastOrderBy: null })).toBe(true);
    }
    expect(canForceOffline({ state: 'last_order', lastOrderBy: 'captain' })).toBe(true);
    expect(canForceOffline({ state: 'last_order', lastOrderBy: 'forced' })).toBe(false);
    expect(canForceOffline({ state: 'offline', lastOrderBy: null })).toBe(false);
    expect(canForceOffline({ state: 'suspended', lastOrderBy: null })).toBe(false);
    expect(canForceOffline(null)).toBe(false);
  });
});
