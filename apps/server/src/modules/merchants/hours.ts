// RA §10: one weekly opening period. The weekday is 0 for Sunday to 6 for
// Saturday; the times are minutes after midnight on the city's clock. A
// period whose closing time is not after its opening time crosses midnight
// and belongs to the day it starts; 00:00 to 00:00 is the whole day.
export interface OpeningPeriod {
  weekday: number;
  opensAt: number;
  closesAt: number;
}

const DAY = 24 * 60;
const WEEK = 7 * DAY;
// RA §10, fixed.
const SHORTEST_PERIOD_MIN = 30;

function lengthOf({ opensAt, closesAt }: OpeningPeriod): number {
  return closesAt > opensAt ? closesAt - opensAt : closesAt + DAY - opensAt;
}

function startInWeek(period: OpeningPeriod): number {
  return period.weekday * DAY + period.opensAt;
}

// Why the schedule breaks RA §10, or null when it follows it.
export function checkWeeklySchedule(periods: readonly OpeningPeriod[]): string | null {
  for (const period of periods) {
    if (!Number.isInteger(period.weekday) || period.weekday < 0 || period.weekday > 6) {
      return 'a weekday is 0 (Sunday) to 6 (Saturday)';
    }
    const inDay = (minutes: number, last: number) =>
      Number.isInteger(minutes) && minutes >= 0 && minutes <= last;
    if (!inDay(period.opensAt, DAY - 1) || !inDay(period.closesAt, DAY)) {
      return 'a time is a whole minute of the day';
    }
    if (lengthOf(period) < SHORTEST_PERIOD_MIN) {
      return `a period lasts ${SHORTEST_PERIOD_MIN} minutes or more`;
    }
  }
  // On the week's circle, two periods overlap when one starts inside the other.
  for (const [index, first] of periods.entries()) {
    for (const second of periods.slice(index + 1)) {
      const gap = (startInWeek(second) - startInWeek(first) + WEEK) % WEEK;
      if (gap < lengthOf(first) || WEEK - gap < lengthOf(second)) {
        return 'opening periods overlap';
      }
    }
  }
  return null;
}

const weekdays: Record<string, number> = {
  Sun: 0,
  Mon: 1,
  Tue: 2,
  Wed: 3,
  Thu: 4,
  Fri: 5,
  Sat: 6,
};

// The minute of the week on the city's clock.
function minuteOfWeek(instant: Date, timeZone: string): number {
  const parts = Object.fromEntries(
    new Intl.DateTimeFormat('en-US', {
      timeZone,
      weekday: 'short',
      hour: '2-digit',
      minute: '2-digit',
      hourCycle: 'h23',
    })
      .formatToParts(instant)
      .map((part) => [part.type, part.value]),
  );
  return weekdays[parts.weekday!]! * DAY + Number(parts.hour) * 60 + Number(parts.minute);
}

// The opening period the restaurant is in at this moment, with when it ends;
// null while it is closed by the schedule. It opens at the opening minute and
// closes at the closing minute.
export function currentPeriod(
  periods: readonly OpeningPeriod[],
  instant: Date,
  timeZone: string,
): { endsAt: Date } | null {
  const now = minuteOfWeek(instant, timeZone);
  for (const period of periods) {
    const into = (now - startInWeek(period) + WEEK) % WEEK;
    if (into < lengthOf(period)) {
      const startOfMinute = instant.getTime() - (instant.getTime() % 60_000);
      return { endsAt: new Date(startOfMinute + (lengthOf(period) - into) * 60_000) };
    }
  }
  return null;
}
