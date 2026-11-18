import { describe, expect, it } from 'vitest';
import { notificationTemplate } from '../content/index.js';
import { stateKinds } from '../merchants/index.js';
import { dateOn, percentOf, restaurantStatePush } from './restaurant-state-relay.js';

// RA §16 #3, #23, #24, #25: the pushes a restaurant state change sends.
describe('restaurantStatePush', () => {
  it('sends the auto-pause, the pause’s end and busy mode’s reminder', () => {
    expect(restaurantStatePush('auto_paused', { count: 3 }, 'UTC')).toEqual({
      templateKey: 'merchant.auto_paused',
      values: { العدد: '3' },
    });
    expect(restaurantStatePush('pause_ended', { push: true }, 'UTC')).toEqual({
      templateKey: 'merchant.pause_ended',
      values: {},
    });
    expect(restaurantStatePush('busy_reminder', { extraMin: 20 }, 'UTC')).toEqual({
      templateKey: 'merchant.busy_reminder',
      values: { د: '20' },
    });
  });

  it('tells the restaurant what operations did (RA §16 #23)', () => {
    expect(restaurantStatePush('paused_by_operations', { reason: 'لا يرد' }, 'UTC')).toEqual({
      templateKey: 'merchant.paused_by_operations',
      values: { السبب: 'لا يرد' },
    });
    expect(restaurantStatePush('resumed_by_operations', {}, 'UTC')?.templateKey).toBe(
      'merchant.resumed_by_operations',
    );
    expect(restaurantStatePush('busy_ended_by_operations', {}, 'UTC')?.templateKey).toBe(
      'merchant.busy_ended_by_operations',
    );
  });

  it('tells the restaurant of a suspension and a reactivation (RA §16 #23, slice 2.30c)', () => {
    expect(restaurantStatePush('suspended_by_operations', { reason: 'مخالفة' }, 'UTC')).toEqual({
      templateKey: 'merchant.suspended_by_operations',
      values: { السبب: 'مخالفة' },
    });
    expect(restaurantStatePush('reactivated_by_operations', {}, 'UTC')?.templateKey).toBe(
      'merchant.reactivated_by_operations',
    );
    expect(restaurantStatePush('terminated', {}, 'UTC')).toBe(null);
  });

  it('tells the owners only of a new commission, on the city’s clock (RA §16 #33)', () => {
    expect(
      restaurantStatePush(
        'commission_change',
        { rateBp: 1250, from: '2026-11-18T22:30:00.000Z' },
        'Asia/Damascus',
      ),
    ).toEqual({
      templateKey: 'merchant.commission_change',
      values: { النسبة: '12.5', التاريخ: '19/11/2026' },
      owners: true,
    });
    expect(percentOf(1500)).toBe('15');
    expect(percentOf(1234)).toBe('12.34');
    expect(percentOf(0)).toBe('0');
    expect(dateOn(new Date('2026-02-01T10:00:00Z'), 'UTC')).toBe('01/02/2026');
  });

  it('stays silent for a pause that ended with the opening period, and for commands', () => {
    expect(restaurantStatePush('pause_ended', { push: false }, 'UTC')).toBe(null);
    for (const kind of ['paused', 'resumed', 'busy_mode', 'holiday_close', 'hours'] as const) {
      expect(restaurantStatePush(kind, {}, 'UTC')).toBe(null);
    }
  });

  it('names templates that exist', () => {
    for (const kind of stateKinds) {
      const push = restaurantStatePush(kind, {
        push: true,
        count: 3,
        extraMin: 10,
        reason: 'x',
        rateBp: 1500,
        from: '2026-11-18T00:00:00Z',
      }, 'UTC');
      if (push) expect(notificationTemplate(push.templateKey)).toBeDefined();
    }
  });
});
