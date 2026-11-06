import { describe, expect, it } from 'vitest';
import {
  dailyCap,
  poolAlerts,
  type PoolNumberHealth,
  senderDay,
  shouldThrottle,
  warmup,
} from './otp-sender-pool.js';

// The sender pool's rules (architecture §8.3.3 items 6, 7, 12, 14; owner
// decisions 2026-11-06).
const caps = [50, 100, 200, 400, 800, 'full'] as const;
const start = new Date('2026-11-01T09:00:00Z');
const days = (count: number) => new Date(start.getTime() + count * 24 * 60 * 60 * 1000);

describe('the warm-up', () => {
  it('rises one step every three days and ends full after fifteen', () => {
    expect(warmup(start, start, caps, 3)).toEqual({ step: 1, cap: 50, nextStepAt: days(3) });
    expect(warmup(start, days(2.9), caps, 3)?.cap).toBe(50);
    expect(warmup(start, days(3), caps, 3)).toEqual({ step: 2, cap: 100, nextStepAt: days(6) });
    expect(warmup(start, days(12), caps, 3)?.cap).toBe(800);
    expect(warmup(start, days(14.9), caps, 3)?.cap).toBe(800);
    expect(warmup(start, days(15), caps, 3)).toBeNull();
  });

  it('ends after the last step of a list without full', () => {
    expect(warmup(start, days(5), [50, 100], 3)?.cap).toBe(100);
    expect(warmup(start, days(6), [50, 100], 3)).toBeNull();
  });

  it('caps the day at the step or the daily maximum, the lower', () => {
    expect(dailyCap(warmup(start, start, caps, 3), 1500)).toBe(50);
    expect(dailyCap(warmup(start, start, caps, 3), 20)).toBe(20);
    expect(dailyCap(null, 1500)).toBe(1500);
  });
});

describe('the day of the counts', () => {
  it('is the day in Damascus', () => {
    expect(senderDay(new Date('2026-11-06T21:30:00Z'))).toBe('2026-11-07');
    expect(senderDay(new Date('2026-11-06T20:59:00Z'))).toBe('2026-11-06');
  });
});

describe('the throttle', () => {
  const outcomes = (sent: number, failed: number) => [
    ...Array<boolean>(sent).fill(true),
    ...Array<boolean>(failed).fill(false),
  ];

  it('needs ten sends', () => {
    expect(shouldThrottle(outcomes(0, 9))).toBe(false);
    expect(shouldThrottle(outcomes(7, 3))).toBe(true);
    expect(shouldThrottle(outcomes(8, 2))).toBe(false);
  });

  it('looks at the last twenty sends only', () => {
    expect(shouldThrottle(outcomes(14, 6))).toBe(true);
    expect(shouldThrottle(outcomes(15, 5))).toBe(false);
    expect(shouldThrottle([...outcomes(0, 10), ...outcomes(20, 0)])).toBe(false);
  });
});

describe('the alerts', () => {
  const number = (overrides: Partial<PoolNumberHealth>): PoolNumberHealth => ({
    id: 'n1',
    status: 'active',
    connected: true,
    attemptedToday: 0,
    dailyCap: 1500,
    ...overrides,
  });

  it('raise nothing while a number can send and none stopped', () => {
    expect(poolAlerts([number({}), number({ id: 'n2', status: 'standby' })])).toEqual([]);
  });

  it('name the stopped numbers', () => {
    expect(
      poolAlerts([
        number({}),
        number({ id: 'n2', status: 'throttled' }),
        number({ id: 'n3', status: 'banned', connected: false }),
        number({ id: 'n4', status: 'disconnected', connected: false }),
      ]),
    ).toEqual([{ type: 'number_stopped', severity: 'warning', numberIds: ['n2', 'n3', 'n4'] }]);
  });

  it('name a number whose session is closed', () => {
    expect(poolAlerts([number({}), number({ id: 'n2', connected: false })])).toEqual([
      { type: 'number_stopped', severity: 'warning', numberIds: ['n2'] },
    ]);
  });

  it.each([
    ['no number', []],
    ['only a standby number', [number({ status: 'standby' })]],
    ['a number at its cap', [number({ status: 'warming', attemptedToday: 50, dailyCap: 50 })]],
    ['a number not connected', [number({ connected: false })]],
  ])('say codes cannot be sent with %s', (_, numbers) => {
    expect(poolAlerts(numbers)).toContainEqual({
      type: 'cannot_send',
      severity: 'critical',
      numberIds: [],
    });
  });

  it('count a warming number that can send', () => {
    expect(poolAlerts([number({ status: 'warming', dailyCap: 50 })])).toEqual([]);
  });
});
