import type { OperatingState } from './operating-state.js';

// RA §7.2, RA Appendix A (fixed): the restaurant's pause choices, in
// minutes; «حتى أعيد الفتح» is the fourth, without minutes.
export const PAUSE_CHOICES_MIN = [15, 30, 60] as const;

// RA §10, fixed: the longest holiday close message.
export const HOLIDAY_MESSAGE_MAX = 100;

export type StatusRefusal =
  'restaurant_closed' | 'paused_by_operations' | 'invalid_pause' | 'invalid_busy_extra';

// RA §18 «Pause / resume»: the restaurant pauses while open or busy, never
// over an operations pause or the auto-pause (one pause at a time, RA §7.1),
// and never while closed. Its own pause is replaced, so the owner can change
// its length. The pause ends after the chosen minutes, or for «حتى أعيد
// الفتح» (minutes null) with the opening period, and at the latest with the
// period (S3).
export function restaurantPauseEnd(
  state: OperatingState,
  closesAt: Date | null,
  minutes: number | null,
  now: Date,
): { endsAt: Date } | { refusal: StatusRefusal } {
  if (minutes !== null && !(PAUSE_CHOICES_MIN as readonly number[]).includes(minutes)) {
    return { refusal: 'invalid_pause' };
  }
  if (state.state === 'paused' && state.source !== 'restaurant') {
    return { refusal: 'paused_by_operations' };
  }
  if ((state.state !== 'open' && state.state !== 'busy' && state.state !== 'paused') || !closesAt) {
    return { refusal: 'restaurant_closed' };
  }
  if (minutes === null) return { endsAt: closesAt };
  const chosen = now.getTime() + minutes * 60_000;
  return { endsAt: new Date(Math.min(chosen, closesAt.getTime())) };
}

// RA §18: the restaurant ends only its own pause (S4). With no pause there is
// nothing to do, so a repeat is harmless.
export function restaurantResume(
  state: OperatingState,
): 'end' | 'nothing' | 'paused_by_operations' {
  if (state.state !== 'paused') return 'nothing';
  return state.source === 'restaurant' ? 'end' : 'paused_by_operations';
}

// RA §7.3, §18 «Busy mode on / off»: on while the restaurant is open (busy at
// its limit is open too), with minutes from merchant.busy_extra_options_min,
// until the end of the opening period (S3).
export function busyModeEnd(
  state: OperatingState,
  closesAt: Date | null,
  extraMin: number,
  options: readonly number[],
): { endsAt: Date } | { refusal: StatusRefusal } {
  if (!options.includes(extraMin)) return { refusal: 'invalid_busy_extra' };
  if ((state.state !== 'open' && state.state !== 'busy') || !closesAt) {
    return { refusal: 'restaurant_closed' };
  }
  return { endsAt: closesAt };
}

// RA §10: a holiday close from now or a later moment until a later one, with
// an optional message of up to 100 characters. Why it breaks the rule, or
// null. A start a few seconds in the past is now: the app sends its clock.
export function checkHolidayClose(
  close: { startsAt: Date; endsAt: Date; message: string | null },
  now: Date,
): string | null {
  if (close.startsAt.getTime() < now.getTime() - 60_000) {
    return 'a holiday close starts now or later';
  }
  if (close.endsAt.getTime() <= Math.max(close.startsAt.getTime(), now.getTime())) {
    return 'a holiday close ends after it starts';
  }
  if (close.message !== null && [...close.message].length > HOLIDAY_MESSAGE_MAX) {
    return `the message has ${HOLIDAY_MESSAGE_MAX} characters or fewer`;
  }
  return null;
}
