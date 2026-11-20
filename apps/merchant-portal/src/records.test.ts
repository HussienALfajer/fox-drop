import { describe, expect, it, vi } from 'vitest';
import { absolute, balanceKind, pickupsTotal, weekByDay, type WeekLine } from './account.js';
import { exportGaveUp, exportRefusalOf, EXPORT_WAIT_MS } from './exports.js';
import { numberOf } from './history.js';
import { periodQuery, rangeProblem } from './period.js';
import { changeOf, minutesOf, percentOf } from './reports.js';

vi.mock('./api.js', () => ({ api: {} }));

// RA §8.18, §11–13, §17 (slice 2.45d): the reports, the history, the
// ratings and the money section of the portal.
describe('the custom range (owner decision 2026-11-20)', () => {
  it('asks two real days, the last not before the first, at most 366', () => {
    expect(rangeProblem('2026-11-01', '2026-11-20')).toBeNull();
    expect(rangeProblem('2026-11-20', '2026-11-20')).toBeNull();
    expect(rangeProblem('', '2026-11-20')).toBe('missing');
    expect(rangeProblem('2026-02-30', '2026-03-01')).toBe('missing');
    expect(rangeProblem('2026-11-20', '2026-11-19')).toBe('backwards');
    expect(rangeProblem('2025-11-20', '2026-11-20')).toBeNull();
    expect(rangeProblem('2025-11-19', '2026-11-20')).toBe('tooLong');
  });

  it('sends the period or the range', () => {
    expect(periodQuery({ kind: 'period', period: 'today' })).toEqual({ period: 'today' });
    expect(periodQuery({ kind: 'range', from: '2026-11-01', to: '2026-11-02' })).toEqual({
      from: '2026-11-01',
      to: '2026-11-02',
    });
  });
});

describe('the reports’ comparison (RA §11)', () => {
  it('compares as the app does', () => {
    expect(changeOf(null, 3)).toEqual({ kind: 'none' });
    expect(changeOf(3, 3)).toEqual({ kind: 'same' });
    expect(changeOf(3, 0)).toEqual({ kind: 'new' });
    expect(changeOf(0, 0)).toEqual({ kind: 'same' });
    expect(changeOf(15, 10)).toEqual({ kind: 'moved', up: true, percent: 50 });
    expect(changeOf(5, 10)).toEqual({ kind: 'moved', up: false, percent: 50 });
  });

  it('compares money in integers of minor units', () => {
    expect(changeOf('20000', '15000')).toEqual({ kind: 'moved', up: true, percent: 33 });
    expect(changeOf('10050', '10000')).toEqual({ kind: 'moved', up: true, percent: 1 });
    expect(changeOf('-1800', '0')).toEqual({ kind: 'none' });
    expect(changeOf('-900', '-1800')).toEqual({ kind: 'moved', up: true, percent: 50 });
    expect(changeOf('900000000000000001', '900000000000000000')).toEqual({
      kind: 'moved',
      up: true,
      percent: 0,
    });
  });

  it('shows shares and minutes to one decimal', () => {
    expect(percentOf(1250)).toBe(12.5);
    expect(percentOf(10_000)).toBe(100);
    expect(minutesOf(7.25)).toBe(7.3);
  });
});

describe('«السجل»’s order number', () => {
  it('takes it with or without «#»', () => {
    expect(numberOf(' #10001 ')).toBe('10001');
    expect(numberOf('')).toBeNull();
    expect(numberOf('10a')).toBe('invalid');
  });
});

describe('the Excel exports', () => {
  it('names each refusal and gives up after the wait', () => {
    expect(exportRefusalOf({ error: 'invalid_period' })).toBe('period');
    expect(exportRefusalOf({ error: 'too_many_rows' })).toBe('tooMany');
    expect(exportRefusalOf({ error: 'unknown_statement' })).toBe('gone');
    expect(exportRefusalOf({ error: 'restaurant_terminated' })).toBe('terminated');
    expect(exportRefusalOf(undefined)).toBe('other');
    expect(exportGaveUp(0, EXPORT_WAIT_MS)).toBe(false);
    expect(exportGaveUp(0, EXPORT_WAIT_MS + 1)).toBe(true);
  });
});

describe('«الحساب» (RA §12.2)', () => {
  it('groups the week by its business day and adds up today', () => {
    const line = (day: string, orderNumber: string) =>
      ({ day, kind: 'order', orderNumber }) as unknown as WeekLine;
    expect(
      weekByDay([line('2026-11-20', '3'), line('2026-11-20', '2'), line('2026-11-19', '1')]),
    ).toEqual([
      { day: '2026-11-20', lines: [line('2026-11-20', '3'), line('2026-11-20', '2')] },
      { day: '2026-11-19', lines: [line('2026-11-19', '1')] },
    ]);
    expect(
      pickupsTotal([{ amount: '24000' }, { amount: '900000000000000000' }] as Parameters<
        typeof pickupsTotal
      >[0]),
    ).toBe('900000000000024000');
  });

  it('reads a balance’s side', () => {
    expect(balanceKind('100')).toBe('owed');
    expect(balanceKind('-100')).toBe('credit');
    expect(balanceKind('0')).toBe('settled');
    expect(absolute('-100')).toBe('100');
  });
});
