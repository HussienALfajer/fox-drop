import { describe, expect, it, vi } from 'vitest';
import { crossesMidnight, formOf, minuteOf, requestOf, timeOf } from './peak-bonus.js';

vi.mock('./api.js', () => ({ api: {} }));

// AP §9.12.5 «مكافأة ساعة الذروة»: the form and the body it saves.
const cityId = '01900000-0000-7000-8000-0000000000c1';
const zone = '01900000-0000-7000-8000-0000000000e1';

describe('the hours', () => {
  it('reads «20:00» as minutes of the day and writes them back', () => {
    expect(minuteOf('20:00')).toBe(1200);
    expect(minuteOf('00:30')).toBe(30);
    expect(minuteOf('24:00')).toBeNull();
    expect(minuteOf('8:00')).toBeNull();
    expect(timeOf(1200)).toBe('20:00');
    expect(timeOf(5)).toBe('00:05');
  });

  it('knows a window that runs past midnight', () => {
    expect(crossesMidnight({ startMinute: 1380, endMinute: 60 })).toBe(true);
    expect(crossesMidnight({ startMinute: 1200, endMinute: 1320 })).toBe(false);
  });
});

describe('formOf', () => {
  it('is off with no window before the first save', () => {
    expect(formOf(null)).toEqual({ enabled: false, windows: [] });
  });

  it('starts from the version, the amount in major units', () => {
    expect(
      formOf({
        id: '01900000-0000-7000-8000-0000000000f1',
        enabled: true,
        currency: 'TRY',
        effectiveFrom: '2026-11-12T17:00:00.000Z',
        windows: [
          {
            days: [4, 5],
            startMinute: 1200,
            endMinute: 1320,
            amount: '500',
            zones: [{ id: zone, name: 'الشمال' }],
          },
        ],
      }),
    ).toEqual({
      enabled: true,
      windows: [{ days: [4, 5], start: '20:00', end: '22:00', amount: '5.00', zoneIds: [zone] }],
    });
  });
});

describe('requestOf', () => {
  const window = { days: [5, 4], start: '20:00', end: '22:00', amount: '5', zoneIds: [] };

  it('sends the days in order, the minutes and the amount in minor units', () => {
    expect(requestOf({ enabled: true, windows: [window] }, cityId, 'TRY')).toEqual({
      body: {
        cityId,
        enabled: true,
        windows: [{ days: [4, 5], startMinute: 1200, endMinute: 1320, amount: '500', zoneIds: [] }],
      },
    });
    expect(requestOf({ enabled: false, windows: [] }, cityId, 'TRY')).toEqual({
      body: { cityId, enabled: false, windows: [] },
    });
  });

  it('names the first window that cannot be saved', () => {
    const form = (change: object) => ({
      enabled: true,
      windows: [window, { ...window, ...change }],
    });
    expect(requestOf(form({ days: [] }), cityId, 'TRY')).toEqual({ problem: 'days', window: 1 });
    expect(requestOf(form({ end: '20:00' }), cityId, 'TRY')).toEqual({
      problem: 'hours',
      window: 1,
    });
    expect(requestOf(form({ start: '' }), cityId, 'TRY')).toEqual({ problem: 'hours', window: 1 });
    expect(requestOf(form({ amount: '0' }), cityId, 'TRY')).toEqual({
      problem: 'amount',
      window: 1,
    });
    expect(requestOf(form({ amount: '5.555' }), cityId, 'TRY')).toEqual({
      problem: 'amount',
      window: 1,
    });
  });
});
