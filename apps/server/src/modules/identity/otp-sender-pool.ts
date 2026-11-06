import type { otpSenderNumberStatuses } from './schema.js';

// The sender pool's rules (architecture §8.3.3 items 6, 7, 11, 12, 14),
// shared by the otp-sender process and the API's read of
// «أرقام إرسال الرموز». Pure, so the tests pass the time.

export type SenderStatus = (typeof otpSenderNumberStatuses)[number];

// The day of the daily caps and counts: the sending numbers serve Azaz.
export const SENDER_TIME_ZONE = 'Asia/Damascus';

const dayFormat = new Intl.DateTimeFormat('en-CA', {
  timeZone: SENDER_TIME_ZONE,
  year: 'numeric',
  month: '2-digit',
  day: '2-digit',
});

// YYYY-MM-DD in Asia/Damascus.
export function senderDay(now: Date): string {
  return dayFormat.format(now);
}

const DAY_MS = 24 * 60 * 60 * 1000;

export type WarmupCaps = readonly (number | 'full')[];

export interface Warmup {
  // 1 for the first step.
  step: number;
  // The step's daily cap.
  cap: number;
  // When the next step starts.
  nextStepAt: Date;
}

// Item 6 (owner decision 2026-11-06): one step of otp.sender_warmup_caps every
// otp.sender_warmup_step_days days from the warm-up start. The warm-up is
// over (null) once a step is full or the list ends.
export function warmup(
  startedAt: Date,
  now: Date,
  caps: WarmupCaps,
  stepDays: number,
): Warmup | null {
  const stepMs = stepDays * DAY_MS;
  const index = Math.max(0, Math.floor((now.getTime() - startedAt.getTime()) / stepMs));
  const cap = caps[index];
  if (cap === undefined || cap === 'full') return null;
  return {
    step: index + 1,
    cap,
    nextStepAt: new Date(startedAt.getTime() + (index + 1) * stepMs),
  };
}

// The sends a number may attempt today: otp.sender_daily_max, and its warm-up
// step's cap while warming. Failed sends count too: WhatsApp saw them.
export function dailyCap(warming: Warmup | null, dailyMax: number): number {
  return warming ? Math.min(warming.cap, dailyMax) : dailyMax;
}

// Item 12 (owner decision 2026-11-06): a number whose last 20 sends, at least
// 10 of them, failed 30% or more rests for 60 minutes.
export const THROTTLE_WINDOW = 20;
export const THROTTLE_MIN_SENDS = 10;
export const THROTTLE_FAILURE_RATE = 0.3;
export const THROTTLE_MINUTES = 60;

// The last sends' outcomes, true for a send that went through.
export function shouldThrottle(outcomes: readonly boolean[]): boolean {
  const last = outcomes.slice(-THROTTLE_WINDOW);
  if (last.length < THROTTLE_MIN_SENDS) return false;
  const failed = last.filter((sent) => !sent).length;
  return failed / last.length >= THROTTLE_FAILURE_RATE;
}

// The states that send codes: active first, then warming (owner decision
// 2026-11-06).
export const SENDING_STATUSES = ['active', 'warming'] as const satisfies SenderStatus[];
// The states kept connected: they send, may send again soon, or answer the
// people who write to them.
export const CONNECTED_STATUSES = [
  'active',
  'warming',
  'standby',
  'throttled',
] as const satisfies SenderStatus[];
// Item 14: a number in these states raises «رقم إرسال الرموز متوقف».
export const STOPPED_STATUSES = [
  'disconnected',
  'throttled',
  'banned',
] as const satisfies SenderStatus[];

// The otp-sender marks each connected number in Valkey for this long and
// renews it every supervision, so the API's read knows which can send.
export const CONNECTED_SECONDS = 30;
export function connectedKey(numberId: string): string {
  return `identity:otp:sender:connected:${numberId}`;
}

export interface PoolNumberHealth {
  id: string;
  status: SenderStatus;
  connected: boolean;
  // Sends attempted today and the day's cap.
  attemptedToday: number;
  dailyCap: number;
}

export type PoolAlert =
  | { type: 'number_stopped'; severity: 'warning'; numberIds: string[] }
  | { type: 'cannot_send'; severity: 'critical' };

// Whether a number can send a code now, its pacing aside.
export function canSend(number: PoolNumberHealth): boolean {
  return (
    (SENDING_STATUSES as readonly SenderStatus[]).includes(number.status) &&
    number.connected &&
    number.attemptedToday < number.dailyCap
  );
}

// Item 14, AP §9.1.3: «رقم إرسال الرموز متوقف» (Warning, OWN) while a number
// is disconnected, throttled or banned; «لا يمكن إرسال رموز الدخول»
// (Critical, OWN and OPS) while no number can send.
export function poolAlerts(numbers: readonly PoolNumberHealth[]): PoolAlert[] {
  const alerts: PoolAlert[] = [];
  const stopped = numbers
    .filter((number) => (STOPPED_STATUSES as readonly SenderStatus[]).includes(number.status))
    .map((number) => number.id);
  if (stopped.length > 0) {
    alerts.push({ type: 'number_stopped', severity: 'warning', numberIds: stopped });
  }
  if (!numbers.some(canSend)) alerts.push({ type: 'cannot_send', severity: 'critical' });
  return alerts;
}
