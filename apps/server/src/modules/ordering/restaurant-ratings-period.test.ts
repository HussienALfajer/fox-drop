import { describe, expect, it } from 'vitest';
import { periodBounds } from './restaurant-ratings.js';

// RA §13, §11 (slice 2.26b, owner decision 2026-11-17): the restaurant's
// ratings filtered by the reports' periods, in business days from
// finance.business_day_cutoff on the city's clock.

const SIX = 6 * 60;
const zone = 'Asia/Damascus'; // UTC+3 all year

describe('the period of the restaurant’s ratings', () => {
  // 10:00 on 17 November on Azaz's clock, after the 06:00 cutoff.
  const now = new Date('2026-11-17T07:00:00Z');
  const todayStart = new Date('2026-11-17T03:00:00Z');

  it('is unbounded for «الكل»', () => {
    expect(periodBounds('all', now, SIX, zone)).toEqual({ from: null, to: null });
  });

  it('starts today at the cutoff, and yesterday runs to it', () => {
    expect(periodBounds('today', now, SIX, zone)).toEqual({ from: todayStart, to: null });
    expect(periodBounds('yesterday', now, SIX, zone)).toEqual({
      from: new Date('2026-11-16T03:00:00Z'),
      to: todayStart,
    });
  });

  it('counts today among the last 7 and 30 days', () => {
    expect(periodBounds('last_7_days', now, SIX, zone)).toEqual({
      from: new Date('2026-11-11T03:00:00Z'),
      to: null,
    });
    expect(periodBounds('last_30_days', now, SIX, zone)).toEqual({
      from: new Date('2026-10-19T03:00:00Z'),
      to: null,
    });
  });

  it('keeps the night before the cutoff in the day before', () => {
    // 03:00 on 17 November on Azaz's clock: still the 16th's business day.
    const night = new Date('2026-11-17T00:00:00Z');
    expect(periodBounds('today', night, SIX, zone).from).toEqual(new Date('2026-11-16T03:00:00Z'));
  });

  it('follows a daylight saving change on the city’s clock', () => {
    // Berlin moved from UTC+2 to UTC+1 at 03:00 on 25 October 2026, so the
    // 24th's business day lasted 25 hours.
    const berlin = periodBounds(
      'yesterday',
      new Date('2026-10-25T08:00:00Z'),
      SIX,
      'Europe/Berlin',
    );
    expect(berlin).toEqual({
      from: new Date('2026-10-24T04:00:00Z'),
      to: new Date('2026-10-25T05:00:00Z'),
    });
  });
});
