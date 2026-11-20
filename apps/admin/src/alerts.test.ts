import { describe, expect, it, vi } from 'vitest';
import {
  type AdminAlert,
  needsRepeat,
  overdueRestaurantOf,
  priceChangeRestaurantOf,
  receivesAlerts,
  soundPlan,
  withoutDeviceRestaurantOf,
} from './alerts.js';

vi.mock('./api.js', () => ({ api: {} }));

function alert(overrides: Partial<AdminAlert>): AdminAlert {
  return {
    id: 'a1',
    code: 'restaurant_not_accepted',
    severity: 'critical',
    subjectType: 'order',
    subjectId: 'o1',
    orderNumber: '10001',
    captainName: null,
    ticketNumber: null,
    restaurantName: null,
    restaurantId: null,
    currency: null,
    statementId: null,
    applicationId: null,
    location: null,
    raisedAt: '2026-11-08T09:00:00.000Z',
    acknowledged: null,
    resolvedAt: null,
    ...overrides,
  };
}

const taken = { at: '2026-11-08T09:01:00.000Z', byId: 'u1', byName: 'ليلى' };

// AP §7.3: critical repeats until acknowledged, a warning plays once,
// information is silent.
describe('soundPlan', () => {
  it('repeats while a critical alert waits for «استلام»', () => {
    expect(needsRepeat([alert({})])).toBe(true);
    expect(needsRepeat([alert({ acknowledged: taken })])).toBe(false);
    expect(needsRepeat([alert({ severity: 'warning' })])).toBe(false);
  });

  it('chimes once for a warning not heard before', () => {
    const warning = alert({ id: 'w1', severity: 'warning', code: 'prep_late' });
    expect(soundPlan([warning], new Set()).chime).toBe(true);
    expect(soundPlan([warning], new Set(['w1'])).chime).toBe(false);
  });

  it('stays silent for information', () => {
    const info = alert({ id: 'i1', severity: 'information', code: 'away_from_address' });
    expect(soundPlan([info], new Set())).toEqual({ repeat: false, chime: false, notify: [] });
  });

  it('notifies the desktop of each critical alert seen first', () => {
    const first = alert({ id: 'c1' });
    const second = alert({ id: 'c2' });
    expect(soundPlan([first, second], new Set(['c1'])).notify).toEqual([second]);
  });
});

describe('receivesAlerts', () => {
  const session = (roles: string[]) => ({
    accountId: 'a',
    roles,
    permissions: [],
    signedInAt: '',
    expiresAt: '',
  });

  it('is true for OWN, OPS, FIN and SUP («تذكرة عاجلة», slice 2.23a), and false for DATA alone', () => {
    expect(receivesAlerts(session(['OPS']))).toBe(true);
    expect(receivesAlerts(session(['FIN']))).toBe(true);
    expect(receivesAlerts(session(['SUP']))).toBe(true);
    expect(receivesAlerts(session(['DATA']))).toBe(false);
  });
});

// AP §9.1.3 «مطعم متأخر في التسوية» (slice 2.19f): its restaurant only.
describe('withoutDeviceRestaurantOf (RA §4.6, slice 2.42)', () => {
  it('names the restaurant open without a receiving device, and nothing for another alert', () => {
    const without = alert({
      code: 'restaurant_without_device',
      severity: 'warning',
      subjectType: 'restaurant',
      subjectId: 'r2',
      orderNumber: null,
      restaurantName: 'مطعم',
    });
    expect(withoutDeviceRestaurantOf(without)).toBe('r2');
    expect(withoutDeviceRestaurantOf(alert({}))).toBeNull();
  });
});

describe('overdueRestaurantOf', () => {
  it('names the restaurant of the overdue alert, and nothing for another alert', () => {
    const overdue = alert({
      code: 'restaurant_settlement_overdue',
      severity: 'warning',
      subjectType: 'restaurant',
      subjectId: 'r1',
      orderNumber: null,
      restaurantName: 'مطعم',
    });
    expect(overdueRestaurantOf(overdue)).toBe('r1');
    expect(overdueRestaurantOf(alert({}))).toBeNull();
  });
});

describe('«تغيير أسعار كبير» (AP §9.1.3, slice 2.32a)', () => {
  it('opens the price log of its restaurant', () => {
    expect(
      priceChangeRestaurantOf(
        alert({
          code: 'large_price_change',
          severity: 'information',
          subjectType: 'price_change',
          subjectId: 'c1',
          restaurantId: 'r1',
          restaurantName: 'مطعم',
        }),
      ),
    ).toBe('r1');
    expect(priceChangeRestaurantOf(alert({ restaurantId: 'r1' }))).toBeNull();
  });
});
