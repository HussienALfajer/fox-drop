import { describe, expect, it, vi } from 'vitest';
import { controlsOf, type RestaurantStatus, stateLabel } from './status.js';

vi.mock('./api.js', () => ({ api: {} }));

function status(overrides: Partial<RestaurantStatus>): RestaurantStatus {
  return {
    state: 'open',
    pauseSource: null,
    stateUntil: null,
    closesAt: null,
    opensAt: null,
    busyMode: null,
    activeOrders: null,
    maxActiveOrders: null,
    holiday: null,
    pauseChoicesMin: [15, 30, 60],
    busyExtraOptionsMin: [10, 20],
    busyReminderMin: 60,
    ...overrides,
  };
}

describe('the status from the portal (RA §7.1–7.2, §17)', () => {
  it('names the state', () => {
    expect(stateLabel(status({}))).toEqual({ key: 'open' });
    expect(
      stateLabel(status({ busyMode: { extraMin: 10, until: '2026-11-20T22:00:00Z' } })),
    ).toEqual({
      key: 'busyMode',
      minutes: 10,
    });
    expect(stateLabel(status({ state: 'paused', pauseSource: 'ops' }))).toEqual({
      key: 'pausedByOperations',
    });
    expect(stateLabel(status({ state: 'paused', pauseSource: 'auto' }))).toEqual({
      key: 'autoPaused',
    });
    expect(stateLabel(status({ state: 'paused', pauseSource: 'restaurant' }))).toEqual({
      key: 'paused',
    });
  });

  it('holds the buttons while operations or the rule paused the restaurant', () => {
    expect(controlsOf(status({ state: 'paused', pauseSource: 'ops' }))).toMatchObject({
      heldByOperations: true,
      canResume: false,
    });
    expect(controlsOf(status({ state: 'paused', pauseSource: 'restaurant' }))).toMatchObject({
      heldByOperations: false,
      canResume: true,
      canPause: false,
    });
  });

  it('pauses only while open, and busy mode only while open', () => {
    expect(controlsOf(status({ state: 'closed' }))).toMatchObject({
      canPause: false,
      canBusyMode: false,
    });
    expect(controlsOf(status({ state: 'busy' }))).toMatchObject({
      canPause: true,
      canBusyMode: false,
    });
    expect(controlsOf(status({}))).toMatchObject({ canPause: true, canBusyMode: true });
  });
});
