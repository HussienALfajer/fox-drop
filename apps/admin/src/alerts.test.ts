import { describe, expect, it, vi } from 'vitest';
import { type AdminAlert, needsRepeat, receivesAlerts, soundPlan } from './alerts.js';

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
    restaurantName: null,
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

  it('is true for OWN, OPS and FIN, and false for a SUP or DATA user alone', () => {
    expect(receivesAlerts(session(['OPS']))).toBe(true);
    expect(receivesAlerts(session(['FIN']))).toBe(true);
    expect(receivesAlerts(session(['SUP']))).toBe(false);
    expect(receivesAlerts(session(['DATA']))).toBe(false);
  });
});
