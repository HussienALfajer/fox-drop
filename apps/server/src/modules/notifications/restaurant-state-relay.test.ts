import { describe, expect, it } from 'vitest';
import { notificationTemplate } from '../content/index.js';
import { stateKinds } from '../merchants/index.js';
import { restaurantStatePush } from './restaurant-state-relay.js';

// RA §16 #3, #23, #24, #25: the pushes a restaurant state change sends.
describe('restaurantStatePush', () => {
  it('sends the auto-pause, the pause’s end and busy mode’s reminder', () => {
    expect(restaurantStatePush('auto_paused', { count: 3 })).toEqual({
      templateKey: 'merchant.auto_paused',
      values: { العدد: '3' },
    });
    expect(restaurantStatePush('pause_ended', { push: true })).toEqual({
      templateKey: 'merchant.pause_ended',
      values: {},
    });
    expect(restaurantStatePush('busy_reminder', { extraMin: 20 })).toEqual({
      templateKey: 'merchant.busy_reminder',
      values: { د: '20' },
    });
  });

  it('tells the restaurant what operations did (RA §16 #23)', () => {
    expect(restaurantStatePush('paused_by_operations', { reason: 'لا يرد' })).toEqual({
      templateKey: 'merchant.paused_by_operations',
      values: { السبب: 'لا يرد' },
    });
    expect(restaurantStatePush('resumed_by_operations', {})?.templateKey).toBe(
      'merchant.resumed_by_operations',
    );
    expect(restaurantStatePush('busy_ended_by_operations', {})?.templateKey).toBe(
      'merchant.busy_ended_by_operations',
    );
  });

  it('stays silent for a pause that ended with the opening period, and for commands', () => {
    expect(restaurantStatePush('pause_ended', { push: false })).toBe(null);
    for (const kind of ['paused', 'resumed', 'busy_mode', 'holiday_close', 'hours'] as const) {
      expect(restaurantStatePush(kind, {})).toBe(null);
    }
  });

  it('names templates that exist', () => {
    for (const kind of stateKinds) {
      const push = restaurantStatePush(kind, { push: true, count: 3, extraMin: 10, reason: 'x' });
      if (push) expect(notificationTemplate(push.templateKey)).toBeDefined();
    }
  });
});
