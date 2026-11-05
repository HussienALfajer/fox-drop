import { describe, expect, it } from 'vitest';
import { checkWeeklySchedule, currentPeriod, type OpeningPeriod } from './hours.js';

// The weekly schedule of RA §10: periods per weekday, one may cross midnight
// and belongs to the day it starts, none overlap, each lasts 30 minutes or
// more. Times are the city's wall clock (Asia/Damascus, UTC+3 all year).
const timeZone = 'Asia/Damascus';
const at = (local: string) => new Date(`${local}+03:00`);
const hm = (text: string) => {
  const [hours, minutes] = text.split(':').map(Number) as [number, number];
  return hours * 60 + minutes;
};
const period = (weekday: number, opens: string, closes: string): OpeningPeriod => ({
  weekday,
  opensAt: hm(opens),
  closesAt: hm(closes),
});

// 2026-11-06 is a Friday (weekday 5; Sunday is 0).
describe('checkWeeklySchedule', () => {
  it('accepts several periods a day, a day off and a period crossing midnight', () => {
    expect(
      checkWeeklySchedule([
        period(5, '10:00', '14:00'),
        period(5, '18:00', '02:00'),
        period(6, '10:00', '22:00'),
      ]),
    ).toBeNull();
    expect(checkWeeklySchedule([])).toBeNull();
  });

  it('accepts a whole day, from midnight to midnight', () => {
    expect(checkWeeklySchedule([period(1, '00:00', '00:00')])).toBeNull();
  });

  it('refuses a period shorter than 30 minutes', () => {
    expect(checkWeeklySchedule([period(1, '10:00', '10:29')])).toMatch(/30 minutes/);
    expect(checkWeeklySchedule([period(1, '23:50', '00:10')])).toMatch(/30 minutes/);
    expect(checkWeeklySchedule([period(1, '10:00', '10:30')])).toBeNull();
  });

  it('refuses overlapping periods, a period crossing into the next day included', () => {
    expect(checkWeeklySchedule([period(1, '10:00', '14:00'), period(1, '13:00', '16:00')])).toMatch(
      /overlap/,
    );
    expect(checkWeeklySchedule([period(1, '18:00', '02:00'), period(2, '01:00', '05:00')])).toMatch(
      /overlap/,
    );
    // Saturday night into Sunday morning wraps around the week.
    expect(checkWeeklySchedule([period(6, '20:00', '03:00'), period(0, '02:00', '09:00')])).toMatch(
      /overlap/,
    );
    // Touching is not overlapping.
    expect(
      checkWeeklySchedule([period(1, '10:00', '14:00'), period(1, '14:00', '16:00')]),
    ).toBeNull();
  });

  it('refuses a weekday or a time outside the day', () => {
    expect(checkWeeklySchedule([period(7, '10:00', '14:00')])).toMatch(/weekday/);
    expect(checkWeeklySchedule([{ weekday: 1, opensAt: 1440, closesAt: 60 }])).toMatch(/time/);
    expect(checkWeeklySchedule([{ weekday: 1, opensAt: 60, closesAt: 1441 }])).toMatch(/time/);
    expect(checkWeeklySchedule([{ weekday: 1, opensAt: 60.5, closesAt: 600 }])).toMatch(/time/);
  });
});

describe('currentPeriod', () => {
  const schedule = [period(5, '10:00', '14:00'), period(5, '18:00', '02:00')];

  it('finds the open period at a moment of the city clock, and when it ends', () => {
    expect(currentPeriod(schedule, at('2026-11-06T12:30:00'), timeZone)).toEqual({
      endsAt: at('2026-11-06T14:00:00'),
    });
  });

  it('is closed between periods, at the closing minute and on a day without periods', () => {
    expect(currentPeriod(schedule, at('2026-11-06T15:00:00'), timeZone)).toBeNull();
    expect(currentPeriod(schedule, at('2026-11-06T14:00:00'), timeZone)).toBeNull();
    expect(currentPeriod(schedule, at('2026-11-05T12:00:00'), timeZone)).toBeNull();
  });

  it('opens at the opening minute', () => {
    expect(currentPeriod(schedule, at('2026-11-06T10:00:00'), timeZone)).not.toBeNull();
  });

  it('keeps a period crossing midnight open into the next day', () => {
    expect(currentPeriod(schedule, at('2026-11-07T01:15:00'), timeZone)).toEqual({
      endsAt: at('2026-11-07T02:00:00'),
    });
    expect(currentPeriod(schedule, at('2026-11-07T02:00:00'), timeZone)).toBeNull();
  });

  it('reads the city clock, not the server clock', () => {
    // 08:00 UTC is 11:00 in Azaz.
    expect(currentPeriod(schedule, new Date('2026-11-06T08:00:00Z'), timeZone)).not.toBeNull();
    // 12:00 UTC is 15:00 in Azaz, between the periods.
    expect(currentPeriod(schedule, new Date('2026-11-06T12:00:00Z'), timeZone)).toBeNull();
  });

  it('keeps a Saturday night period open into Sunday morning', () => {
    // 2026-11-07 is a Saturday.
    const saturday = [period(6, '20:00', '03:00')];
    expect(currentPeriod(saturday, at('2026-11-08T02:30:00'), timeZone)).toEqual({
      endsAt: at('2026-11-08T03:00:00'),
    });
    expect(currentPeriod(saturday, at('2026-11-08T03:00:00'), timeZone)).toBeNull();
  });

  it('is open all day for a whole-day period', () => {
    expect(
      currentPeriod([period(5, '00:00', '00:00')], at('2026-11-06T23:59:00'), timeZone),
    ).toEqual({ endsAt: at('2026-11-07T00:00:00') });
  });
});
