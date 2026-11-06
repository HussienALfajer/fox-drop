const DAY_MS = 86_400_000;

// The wall clock of a city at an instant, as if it were UTC.
function wallClock(instant: Date, timeZone: string): number {
  const parts = Object.fromEntries(
    new Intl.DateTimeFormat('en-US', {
      timeZone,
      year: 'numeric',
      month: '2-digit',
      day: '2-digit',
      hour: '2-digit',
      minute: '2-digit',
      second: '2-digit',
      hourCycle: 'h23',
    })
      .formatToParts(instant)
      .map((part) => [part.type, Number(part.value)]),
  );
  return Date.UTC(
    parts.year!,
    parts.month! - 1,
    parts.day!,
    parts.hour!,
    parts.minute!,
    parts.second!,
  );
}

// The instant a city's wall clock shows this time (UTC fields), taking the
// offset in force then, so a daylight saving change between now and then is
// counted.
function instantOf(wall: number, timeZone: string): Date {
  let instant = wall;
  for (let step = 0; step < 2; step += 1) {
    instant = wall - (wallClock(new Date(instant), timeZone) - instant);
  }
  return new Date(instant);
}

// RA §4.9, §9.3: the next business-day cutoff after now on the city's clock,
// when «حتى الغد» ends. The cutoff is minutes after midnight
// (finance.business_day_cutoff, 06:00 by default); at the cutoff itself the
// next one is a day later.
export function nextCutoff(now: Date, cutoffMinutes: number, timeZone: string): Date {
  const wall = wallClock(now, timeZone);
  const midnight = wall - (wall % DAY_MS);
  let cutoff = midnight + cutoffMinutes * 60_000;
  if (cutoff <= wall) cutoff += DAY_MS;
  return instantOf(cutoff, timeZone);
}
