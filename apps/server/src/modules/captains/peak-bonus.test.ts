import { describe, expect, it } from 'vitest';
import {
  activeWindows,
  bonusAt,
  checkPeakWindows,
  localClock,
  type PeakVersion,
  type PeakWindow,
  takesEffect,
  versionInForce,
} from './peak-bonus.js';

// AP §9.12.5 «مكافأة ساعة الذروة» (D15). Azaz keeps Syria's clock, UTC+3
// all year, so 17:00 UTC is 20:00 there.
const ZONE = 'Asia/Damascus';
const at = (iso: string) => new Date(iso);
// 2026-11-12 is a Thursday (ISO day 4).
const thursday = (time: string) => at(`2026-11-12T${time}:00+03:00`);

const evening: PeakWindow = {
  days: [4, 5],
  startMinute: 20 * 60,
  endMinute: 22 * 60,
  amount: 500n,
  zoneIds: [],
};
const zoneA = 'aaaaaaaa-0000-7000-8000-000000000001';
const zoneB = 'aaaaaaaa-0000-7000-8000-000000000002';

let sequence = 0;
const version = (
  windows: PeakWindow[],
  effectiveFrom: Date,
  createdAt = effectiveFrom,
  enabled = true,
): PeakVersion => ({
  id: `v${++sequence}`,
  enabled,
  currency: 'TRY',
  windows,
  effectiveFrom,
  createdAt,
});

describe('localClock', () => {
  it('reads the city clock: ISO day, minute of the day and second', () => {
    expect(localClock(thursday('20:15'), ZONE)).toEqual({
      day: 4,
      minute: 20 * 60 + 15,
      second: 0,
    });
    expect(localClock(at('2026-11-15T21:30:05Z'), ZONE)).toEqual({ day: 1, minute: 30, second: 5 });
  });
});

describe('checkPeakWindows', () => {
  it('takes days 1 to 7 once each, whole minutes of a day, a start apart from the end', () => {
    expect(checkPeakWindows([evening])).toBeNull();
    expect(checkPeakWindows([{ ...evening, days: [] }])).not.toBeNull();
    expect(checkPeakWindows([{ ...evening, days: [8] }])).not.toBeNull();
    expect(checkPeakWindows([{ ...evening, days: [4, 4] }])).not.toBeNull();
    expect(checkPeakWindows([{ ...evening, startMinute: 1440 }])).not.toBeNull();
    expect(checkPeakWindows([{ ...evening, endMinute: 20.5 }])).not.toBeNull();
    expect(checkPeakWindows([{ ...evening, endMinute: evening.startMinute }])).not.toBeNull();
  });

  it('takes an amount above zero and each zone once', () => {
    expect(checkPeakWindows([{ ...evening, amount: 0n }])).not.toBeNull();
    expect(checkPeakWindows([{ ...evening, zoneIds: [zoneA, zoneA] }])).not.toBeNull();
    expect(checkPeakWindows([{ ...evening, zoneIds: [zoneA, zoneB] }])).toBeNull();
  });
});

describe('activeWindows', () => {
  it('runs from the start to the end, the end excluded, on its days', () => {
    const clock = (time: string) => localClock(thursday(time), ZONE);
    expect(activeWindows([evening], clock('19:59'))).toEqual([]);
    expect(activeWindows([evening], clock('20:00'))).toEqual([
      { window: evening, endsInSeconds: 7200 },
    ]);
    expect(activeWindows([evening], clock('21:59'))).toEqual([
      { window: evening, endsInSeconds: 60 },
    ]);
    expect(activeWindows([evening], clock('22:00'))).toEqual([]);
    expect(activeWindows([evening], localClock(at('2026-11-14T20:30:00+03:00'), ZONE))).toEqual([]);
  });

  it('runs past midnight into the next day, belonging to the day it starts', () => {
    const late: PeakWindow = { ...evening, days: [4], startMinute: 23 * 60, endMinute: 60 };
    const fridayNight = localClock(at('2026-11-13T00:30:00+03:00'), ZONE);
    expect(activeWindows([late], fridayNight)).toEqual([{ window: late, endsInSeconds: 1800 }]);
    expect(activeWindows([late], localClock(thursday('23:30'), ZONE))).toEqual([
      { window: late, endsInSeconds: 5400 },
    ]);
    // Thursday 00:30 belongs to Wednesday's night, not a day of the window.
    expect(activeWindows([late], localClock(thursday('00:30'), ZONE))).toEqual([]);
  });
});

describe('bonusAt', () => {
  it('pays the largest amount of the windows running for the zone, none when off', () => {
    const big: PeakWindow = { ...evening, amount: 800n, zoneIds: [zoneA] };
    const v = version([evening, big], at('2026-01-01T00:00:00Z'));
    const clock = localClock(thursday('20:30'), ZONE);
    expect(bonusAt(v, clock, zoneA)).toBe(800n);
    expect(bonusAt(v, clock, zoneB)).toBe(500n);
    // A restaurant outside every zone gets only the windows for all zones.
    expect(bonusAt(v, clock, null)).toBe(500n);
    expect(bonusAt({ ...v, enabled: false }, clock, zoneA)).toBe(0n);
    expect(bonusAt(v, localClock(thursday('22:30'), ZONE), zoneA)).toBe(0n);
    expect(bonusAt(null, clock, zoneA)).toBe(0n);
  });
});

describe('takesEffect', () => {
  const current = version([evening], at('2026-01-01T00:00:00Z'));

  it('raises, enables or changes nothing running at once', () => {
    const now = thursday('20:30');
    const clock = localClock(now, ZONE);
    expect(takesEffect(null, { enabled: true, windows: [evening] }, now, clock)).toEqual(now);
    const raised = { enabled: true, windows: [{ ...evening, amount: 700n }] };
    expect(takesEffect(current, raised, now, clock)).toEqual(now);
    // A lowered window that is not running now is not the current window.
    const later = { enabled: true, windows: [evening, { ...evening, days: [6], amount: 100n }] };
    expect(takesEffect(current, later, now, clock)).toEqual(now);
  });

  it('lowers or disables at the end of the current window', () => {
    const now = thursday('20:30');
    const clock = localClock(now, ZONE);
    const end = thursday('22:00');
    const lowered = { enabled: true, windows: [{ ...evening, amount: 200n }] };
    expect(takesEffect(current, lowered, now, clock)).toEqual(end);
    expect(takesEffect(current, { enabled: false, windows: [evening] }, now, clock)).toEqual(end);
    expect(takesEffect(current, { enabled: true, windows: [] }, now, clock)).toEqual(end);
    // Narrowed to one zone: the others lose it.
    const narrowed = { enabled: true, windows: [{ ...evening, zoneIds: [zoneA] }] };
    expect(takesEffect(current, narrowed, now, clock)).toEqual(end);
  });

  it('lowers or disables at once when no window is running (owner decision 2026-11-12)', () => {
    const now = thursday('18:00');
    const clock = localClock(now, ZONE);
    expect(takesEffect(current, { enabled: false, windows: [evening] }, now, clock)).toEqual(now);
  });

  it('waits for the latest end among the running windows a lowered zone had', () => {
    const now = thursday('20:30');
    const clock = localClock(now, ZONE);
    const long: PeakWindow = { ...evening, endMinute: 23 * 60, amount: 300n, zoneIds: [zoneA] };
    const withLong = version([evening, long], at('2026-01-01T00:00:00Z'));
    // Zone B loses 500 (ends 22:00); zone A keeps 500 from the new window.
    const next = { enabled: true, windows: [{ ...evening, zoneIds: [zoneA] }] };
    expect(takesEffect(withLong, next, now, clock)).toEqual(thursday('22:00'));
    // Both off: zone A's longer window ends at 23:00.
    expect(takesEffect(withLong, { enabled: false, windows: [] }, now, clock)).toEqual(
      thursday('23:00'),
    );
  });
});

describe('versionInForce', () => {
  it('is the latest version whose start was reached', () => {
    const v1 = version([evening], at('2026-11-01T00:00:00Z'));
    const v2 = version([evening], thursday('22:00'), thursday('20:30'));
    expect(versionInForce([v1, v2], thursday('21:00'))?.id).toBe(v1.id);
    expect(versionInForce([v1, v2], thursday('22:00'))?.id).toBe(v2.id);
    expect(versionInForce([v1, v2], at('2026-10-01T00:00:00Z'))).toBeNull();
  });

  it('drops a waiting version once a newer one is saved before its start', () => {
    const v1 = version([evening], at('2026-11-01T00:00:00Z'));
    const v2 = version([evening], thursday('22:00'), thursday('20:00'));
    const v3 = version([evening], thursday('21:00'), thursday('21:00'));
    expect(versionInForce([v1, v2, v3], thursday('20:30'))?.id).toBe(v1.id);
    expect(versionInForce([v1, v2, v3], thursday('21:30'))?.id).toBe(v3.id);
    expect(versionInForce([v1, v2, v3], thursday('22:30'))?.id).toBe(v3.id);
    // A version saved after another started does not cancel it.
    const v4 = version([evening], thursday('23:00'), thursday('22:30'));
    expect(versionInForce([v1, v2, v3, v4], thursday('22:45'))?.id).toBe(v3.id);
  });
});
