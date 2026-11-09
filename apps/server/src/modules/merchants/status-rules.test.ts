import { describe, expect, it } from 'vitest';
import type { OperatingState } from './operating-state.js';
import {
  busyModeEnd,
  checkHolidayClose,
  restaurantPauseEnd,
  restaurantResume,
} from './status-rules.js';

// The restaurant's own status commands (RA §7.1–7.3, §10, §18): what each
// may do in each state, and when what it sets ends.
const now = new Date('2026-11-09T12:00:00+03:00');
const closesAt = new Date('2026-11-09T23:30:00+03:00');
const minutes = (count: number) => new Date(now.getTime() + count * 60_000);

const open: OperatingState = { state: 'open', busyExtraMin: null };
const busy: OperatingState = { state: 'busy' };
const restaurantPause: OperatingState = {
  state: 'paused',
  source: 'restaurant',
  until: minutes(10),
};
const operationsPause: OperatingState = { state: 'paused', source: 'ops', until: null };
const autoPause: OperatingState = { state: 'paused', source: 'auto', until: null };
const closedStates: OperatingState[] = [
  { state: 'closed' },
  { state: 'holiday', until: minutes(600) },
  { state: 'suspended' },
  { state: 'draft' },
  { state: 'terminated' },
];

describe('restaurantPauseEnd', () => {
  it('pauses an open or busy restaurant for 15, 30 or 60 minutes', () => {
    for (const state of [open, busy]) {
      for (const choice of [15, 30, 60]) {
        expect(restaurantPauseEnd(state, closesAt, choice, now)).toEqual({
          endsAt: minutes(choice),
        });
      }
    }
  });

  it('ends «حتى أعيد الفتح» with the opening period (S3)', () => {
    expect(restaurantPauseEnd(open, closesAt, null, now)).toEqual({ endsAt: closesAt });
  });

  it('ends a timed pause with the opening period when the period ends first (S3)', () => {
    const soon = minutes(20);
    expect(restaurantPauseEnd(open, soon, 30, now)).toEqual({ endsAt: soon });
    expect(restaurantPauseEnd(open, soon, 15, now)).toEqual({ endsAt: minutes(15) });
  });

  it('replaces the restaurant’s own pause, so the owner can change its length', () => {
    expect(restaurantPauseEnd(restaurantPause, closesAt, 60, now)).toEqual({
      endsAt: minutes(60),
    });
  });

  it('refuses over an operations pause or the auto-pause (one pause at a time)', () => {
    for (const state of [operationsPause, autoPause]) {
      expect(restaurantPauseEnd(state, closesAt, 15, now)).toEqual({
        refusal: 'paused_by_operations',
      });
    }
  });

  it('refuses while the restaurant is closed, on holiday or not active', () => {
    for (const state of closedStates) {
      expect(restaurantPauseEnd(state, null, 15, now)).toEqual({ refusal: 'restaurant_closed' });
    }
  });

  it('refuses a length other than the fixed choices', () => {
    for (const choice of [0, 10, 45, 90, 15.5]) {
      expect(restaurantPauseEnd(open, closesAt, choice, now)).toEqual({
        refusal: 'invalid_pause',
      });
    }
  });
});

describe('restaurantResume', () => {
  it('ends the restaurant’s own pause', () => {
    expect(restaurantResume(restaurantPause)).toBe('end');
  });

  it('changes nothing when there is no pause, so a repeat is harmless', () => {
    for (const state of [open, busy, ...closedStates]) {
      expect(restaurantResume(state)).toBe('nothing');
    }
  });

  it('refuses to end an operations pause or the auto-pause (S4)', () => {
    expect(restaurantResume(operationsPause)).toBe('paused_by_operations');
    expect(restaurantResume(autoPause)).toBe('paused_by_operations');
  });
});

describe('busyModeEnd', () => {
  const options = [10, 20];

  it('turns busy mode on until the end of the opening period (S3)', () => {
    for (const state of [open, busy]) {
      expect(busyModeEnd(state, closesAt, 10, options)).toEqual({ endsAt: closesAt });
      expect(busyModeEnd(state, closesAt, 20, options)).toEqual({ endsAt: closesAt });
    }
  });

  it('refuses minutes outside merchant.busy_extra_options_min', () => {
    expect(busyModeEnd(open, closesAt, 15, options)).toEqual({ refusal: 'invalid_busy_extra' });
    expect(busyModeEnd(open, closesAt, 30, [10, 30])).toEqual({ endsAt: closesAt });
  });

  it('refuses while the restaurant is not open', () => {
    for (const state of [...closedStates, restaurantPause, operationsPause, autoPause]) {
      expect(busyModeEnd(state, closesAt, 10, options)).toEqual({ refusal: 'restaurant_closed' });
    }
  });
});

describe('checkHolidayClose', () => {
  it('accepts a close from now or later until a later moment, with a short message', () => {
    expect(checkHolidayClose({ startsAt: now, endsAt: minutes(60), message: null }, now)).toBe(
      null,
    );
    expect(
      checkHolidayClose(
        { startsAt: minutes(60), endsAt: minutes(120), message: 'ع'.repeat(100) },
        now,
      ),
    ).toBe(null);
  });

  it('refuses an end not after the start, a start in the past or a message over 100', () => {
    expect(checkHolidayClose({ startsAt: now, endsAt: now, message: null }, now)).not.toBe(null);
    expect(
      checkHolidayClose({ startsAt: minutes(-5), endsAt: minutes(60), message: null }, now),
    ).not.toBe(null);
    expect(
      checkHolidayClose({ startsAt: now, endsAt: minutes(60), message: 'ع'.repeat(101) }, now),
    ).not.toBe(null);
  });
});
