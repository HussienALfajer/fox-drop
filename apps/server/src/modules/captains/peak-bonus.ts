// AP §9.12.5 «مكافأة ساعة الذروة» (D15): the pure rules of the peak windows,
// the bonus they pay and when a change of them takes effect.

// One window: its days (ISO, 1 Monday to 7 Sunday), its hours on the city's
// clock in minutes of the day (an end at or before the start runs past
// midnight into the next day, and belongs to the day it starts), the amount
// per delivered order in minor units of the city's base currency, and the
// zones it is limited to (none: every zone).
export interface PeakWindow {
  days: number[];
  startMinute: number;
  endMinute: number;
  amount: bigint;
  zoneIds: string[];
}

// A version of a city's peak bonus, never changed: in force from its start
// unless a newer version was saved before that start (versionInForce).
export interface PeakVersion {
  id: string;
  enabled: boolean;
  currency: string;
  windows: PeakWindow[];
  effectiveFrom: Date;
  createdAt: Date;
}

// The city's clock at a moment: the ISO day, the minute of the day and the
// second of that minute.
export interface LocalClock {
  day: number;
  minute: number;
  second: number;
}

const MINUTES_PER_DAY = 1440;
const MAX_AMOUNT = 2n ** 63n - 1n;
const WEEKDAYS: Record<string, number> = { Mon: 1, Tue: 2, Wed: 3, Thu: 4, Fri: 5, Sat: 6, Sun: 7 };

export function localClock(at: Date, timeZone: string): LocalClock {
  const parts = Object.fromEntries(
    new Intl.DateTimeFormat('en-US', {
      timeZone,
      weekday: 'short',
      hour: '2-digit',
      minute: '2-digit',
      second: '2-digit',
      hourCycle: 'h23',
    })
      .formatToParts(at)
      .map((part) => [part.type, part.value]),
  );
  const day = WEEKDAYS[parts.weekday ?? ''];
  if (day === undefined) throw new Error(`no weekday for ${at.toISOString()} in ${timeZone}`);
  return {
    day,
    minute: Number(parts.hour) * 60 + Number(parts.minute),
    second: Number(parts.second),
  };
}

// Why the windows cannot be saved, or null when they can.
export function checkPeakWindows(windows: readonly PeakWindow[]): string | null {
  for (const window of windows) {
    const { days, startMinute, endMinute, amount, zoneIds } = window;
    if (days.length === 0) return 'a window needs one day at least';
    if (days.some((day) => !Number.isInteger(day) || day < 1 || day > 7)) {
      return 'days are 1 (Monday) to 7 (Sunday)';
    }
    if (new Set(days).size !== days.length) return 'each day once';
    for (const minute of [startMinute, endMinute]) {
      if (!Number.isInteger(minute) || minute < 0 || minute >= MINUTES_PER_DAY) {
        return 'the hours are whole minutes of a day';
      }
    }
    if (startMinute === endMinute) return 'a window ends after it starts';
    if (amount <= 0n) return 'the amount is above zero';
    if (amount > MAX_AMOUNT) return 'the amount is too large';
    if (new Set(zoneIds).size !== zoneIds.length) return 'each zone once';
  }
  return null;
}

// The windows running at a moment of the city's clock, each with the
// seconds since it started and until it ends.
export function activeWindows(
  windows: readonly PeakWindow[],
  clock: LocalClock,
): { window: PeakWindow; startedSecondsAgo: number; endsInSeconds: number }[] {
  const previousDay = clock.day === 1 ? 7 : clock.day - 1;
  const nowSeconds = clock.minute * 60 + clock.second;
  const running: { window: PeakWindow; startedSecondsAgo: number; endsInSeconds: number }[] = [];
  for (const window of windows) {
    const crosses = window.endMinute < window.startMinute;
    // An occurrence that started today.
    if (
      window.days.includes(clock.day) &&
      clock.minute >= window.startMinute &&
      (crosses || clock.minute < window.endMinute)
    ) {
      const end = (crosses ? MINUTES_PER_DAY + window.endMinute : window.endMinute) * 60;
      running.push({
        window,
        startedSecondsAgo: nowSeconds - window.startMinute * 60,
        endsInSeconds: end - nowSeconds,
      });
    } else if (crosses && window.days.includes(previousDay) && clock.minute < window.endMinute) {
      // The rest of yesterday's occurrence, past midnight.
      running.push({
        window,
        startedSecondsAgo: nowSeconds + (MINUTES_PER_DAY - window.startMinute) * 60,
        endsInSeconds: window.endMinute * 60 - nowSeconds,
      });
    }
  }
  return running;
}

const covers = (window: PeakWindow, zoneId: string | null) =>
  window.zoneIds.length === 0 || (zoneId !== null && window.zoneIds.includes(zoneId));

// The bonus per delivered order at a moment for the restaurant's zone (null
// outside every zone: only the windows for every zone): the largest amount
// of the windows running (owner decision 2026-11-12), 0 when off.
export function bonusAt(
  version: Pick<PeakVersion, 'enabled' | 'windows'> | null,
  clock: LocalClock,
  zoneId: string | null,
): bigint {
  if (version === null || !version.enabled) return 0n;
  let bonus = 0n;
  for (const { window } of activeWindows(version.windows, clock)) {
    if (covers(window, zoneId) && window.amount > bonus) bonus = window.amount;
  }
  return bonus;
}

// When a new version takes effect (AP §9.12.5): enabling or raising at once;
// lowering, shortening or disabling a window running now at the end of the
// current window: the latest end among the running windows during whose rest
// the new version pays a zone they cover less; with no window running, at
// once (owner decision 2026-11-12). Each running window is checked minute by
// minute until its end on the city's clock.
export function takesEffect(
  current: Pick<PeakVersion, 'enabled' | 'windows'> | null,
  next: Pick<PeakVersion, 'enabled' | 'windows'>,
  now: Date,
  clock: LocalClock,
): Date {
  if (current === null || !current.enabled) return now;
  // Every zone either version names, and null for any other zone.
  const zones = new Set<string | null>([null]);
  for (const window of [...current.windows, ...next.windows]) {
    for (const zoneId of window.zoneIds) zones.add(zoneId);
  }
  let waitSeconds = 0;
  for (const { window, endsInSeconds } of activeWindows(current.windows, clock)) {
    if (endsInSeconds <= waitSeconds) continue;
    const lowered = [...zones].some(
      (zoneId) =>
        covers(window, zoneId) &&
        minutesUntil(clock, endsInSeconds).some(
          (later) => bonusAt(next, later, zoneId) < window.amount,
        ),
    );
    if (lowered) waitSeconds = endsInSeconds;
  }
  return new Date(now.getTime() + waitSeconds * 1000);
}

// The city's clock now and at the start of every minute after it, before a
// moment that many seconds ahead.
function minutesUntil(clock: LocalClock, seconds: number): LocalClock[] {
  const clocks = [clock];
  const minutes = Math.ceil((clock.second + seconds) / 60);
  for (let ahead = 1; ahead < minutes; ahead += 1) {
    const total = clock.minute + ahead;
    clocks.push({
      day: ((clock.day - 1 + Math.floor(total / MINUTES_PER_DAY)) % 7) + 1,
      minute: total % MINUTES_PER_DAY,
      second: 0,
    });
  }
  return clocks;
}

// The version in force at a moment, of a city's versions in the order they
// were saved: the latest whose start was reached, leaving out a version that
// was still waiting when a newer one was saved (the newer replaces it).
export function versionInForce<V extends PeakVersion>(versions: readonly V[], at: Date): V | null {
  let inForce: V | null = null;
  versions.forEach((version, index) => {
    if (version.effectiveFrom > at) return;
    const next = versions[index + 1];
    if (next !== undefined && next.createdAt < version.effectiveFrom) return;
    inForce = version;
  });
  return inForce;
}
