import { describe, expect, it, vi } from 'vitest';
import {
  defaultPeriod,
  entryOf,
  type PeriodStatementLine,
  periodFits,
  todayOn,
} from './restaurant-statements.js';

vi.mock('./api.js', () => ({ api: {} }));

// AP §9.10.5 «كشوف المطاعم» (slice 2.19g).
describe('the period', () => {
  it('opens on this month so far, on the city clock', () => {
    // 23:30 on 31 October in UTC is already 1 November in Damascus (UTC+3).
    const now = new Date('2026-10-31T23:30:00Z');
    expect(todayOn(now, 'Asia/Damascus')).toBe('2026-11-01');
    expect(defaultPeriod(now, 'Asia/Damascus')).toEqual({ from: '2026-11-01', to: '2026-11-01' });
    expect(defaultPeriod(new Date('2026-11-16T10:00:00Z'), 'Asia/Damascus')).toEqual({
      from: '2026-11-01',
      to: '2026-11-16',
    });
  });

  it('fits from one day to a year and a day, the last not before the first', () => {
    expect(periodFits('2026-11-01', '2026-11-01')).toBe(true);
    expect(periodFits('2025-01-01', '2026-01-01')).toBe(true);
    expect(periodFits('2025-01-01', '2026-01-02')).toBe(false);
    expect(periodFits('2026-11-02', '2026-11-01')).toBe(false);
    expect(periodFits('2026-02-30', '2026-03-01')).toBe(false);
    expect(periodFits('', '2026-03-01')).toBe(false);
  });
});

describe('entryOf', () => {
  const line = (kind: PeriodStatementLine['kind'], amount: string | null, cause = null) =>
    ({ kind, amount, cause }) as PeriodStatementLine;

  it('tells a payment from the desk paying the restaurant', () => {
    expect(entryOf(line('order', null))).toEqual({ kind: 'order' });
    expect(entryOf(line('payment', '-1500'))).toEqual({ kind: 'payment' });
    expect(entryOf(line('payment', '700'))).toEqual({ kind: 'payout' });
    expect(entryOf({ ...line('exception', '-500'), cause: 'adjustment' })).toEqual({
      kind: 'exception',
      cause: 'adjustment',
    });
  });
});
