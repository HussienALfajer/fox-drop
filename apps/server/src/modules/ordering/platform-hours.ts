import { currentPeriod, nextOpening, type OpeningPeriod } from '../geo/index.js';

// The weekdays of platform.hours, by the numbers of OpeningPeriod (0 Sunday).
const weekdayNumbers: Record<string, number> = {
  sunday: 0,
  monday: 1,
  tuesday: 2,
  wednesday: 3,
  thursday: 4,
  friday: 5,
  saturday: 6,
};

const minutes = (time: string) => {
  const [hours, mins] = time.split(':').map(Number) as [number, number];
  return (hours * 60 + mins) % (24 * 60);
};

// CU §4.7, AP D9: whether the platform takes orders at a moment of the
// city's clock, by platform.hours; while closed, when it opens next, for
// «FOX DROP يستقبل الطلبات من الساعة {الساعة}». An interval closing at 24:00
// ends with the day, as a restaurant period ending at 00:00 does.
export function platformOpening(
  schedule: Record<string, readonly { open: string; close: string }[]>,
  instant: Date,
  timeZone: string,
): { open: true } | { open: false; opensAt: Date | null } {
  const periods: OpeningPeriod[] = Object.entries(schedule).flatMap(([day, intervals]) =>
    intervals.map((interval) => ({
      weekday: weekdayNumbers[day]!,
      opensAt: minutes(interval.open),
      closesAt: minutes(interval.close),
    })),
  );
  if (currentPeriod(periods, instant, timeZone) !== null) return { open: true };
  return { open: false, opensAt: nextOpening(periods, instant, timeZone) };
}
