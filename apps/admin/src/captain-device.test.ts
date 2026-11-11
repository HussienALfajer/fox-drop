import { describe, expect, it, vi } from 'vitest';
import { canReleaseDevice, releaseReason } from './captain-device.js';

vi.mock('./api.js', () => ({ api: {} }));

const captain = { id: '0190b0a0-0000-7000-8000-000000000001', name: 'أحمد', vehicle: 'motorbike' };

// AP §9.7.5 «تحرير الجهاز»: OWN and OPS, on the detail's captain line while
// the order is active with a captain (owner decision 2026-11-11).
describe('canReleaseDevice', () => {
  const session = (permissions: string[]) => ({ permissions }) as never;
  it('needs captains.manage, a captain and an active order', () => {
    const manage = session(['captains.manage']);
    for (const status of ['accepted', 'ready', 'picked_up', 'arrived'] as const) {
      expect(canReleaseDevice(manage, { status, captain })).toBe(true);
    }
    expect(canReleaseDevice(session(['operations.manage']), { status: 'ready', captain })).toBe(
      false,
    );
    expect(canReleaseDevice(manage, { status: 'ready', captain: null })).toBe(false);
    expect(canReleaseDevice(manage, { status: 'delivered', captain })).toBe(false);
    expect(canReleaseDevice(manage, { status: 'cancelled', captain })).toBe(false);
  });
});

describe('releaseReason', () => {
  it('requires a reason and trims it', () => {
    expect(releaseReason(' انكسر هاتفه ')).toBe('انكسر هاتفه');
    expect(releaseReason('   ')).toBeNull();
  });
});
