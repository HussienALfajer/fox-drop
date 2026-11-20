import type { components } from '@fox-drop/api-schema';
import { queryOptions, useMutation, useQueryClient } from '@tanstack/react-query';
import { api } from './api.js';
import { zonedToUtc } from './format.js';

export type RestaurantStatus = components['schemas']['MerchantStatusDto_Output'];

// RA §7.1–7.3, §10, §17: the status, read again on every state change the
// channel announces.
// RA §5.5: a terminated restaurant's owners keep the money section only, so
// every live screen answers 403 restaurant_terminated; the portal says so.
export const statusQuery = queryOptions({
  queryKey: ['restaurant-status'],
  queryFn: async (): Promise<RestaurantStatus | 'terminated'> => {
    const { data, error, response } = await api.GET('/v1/merchant/restaurant/status');
    if (data) return data;
    if ((error as { error?: unknown } | undefined)?.error === 'restaurant_terminated') {
      return 'terminated';
    }
    throw new Error(`The status read failed (${response.status}).`);
  },
});

export const emergencyStopQuery = queryOptions({
  queryKey: ['emergency-stop'],
  queryFn: async () => {
    const { data, response } = await api.GET('/v1/merchant/emergency-stop');
    if (!data) throw new Error(`The emergency stop read failed (${response.status}).`);
    return data;
  },
});

// RA §7.1: the words of the state, as the app's status pill.
export type StateLabel =
  | { key: 'open' }
  | { key: 'busyMode'; minutes: number }
  | { key: 'busy' }
  | { key: 'paused' }
  | { key: 'pausedByOperations' }
  | { key: 'autoPaused' }
  | { key: 'closed' }
  | { key: 'holiday'; until: string | null }
  | { key: 'suspended' }
  | { key: 'terminated' }
  | { key: 'draft' };

export function stateLabel(status: RestaurantStatus): StateLabel {
  switch (status.state) {
    case 'open':
      return status.busyMode
        ? { key: 'busyMode', minutes: status.busyMode.extraMin }
        : { key: 'open' };
    case 'paused':
      return status.pauseSource === 'ops'
        ? { key: 'pausedByOperations' }
        : status.pauseSource === 'auto'
          ? { key: 'autoPaused' }
          : { key: 'paused' };
    case 'holiday':
      return { key: 'holiday', until: status.stateUntil };
    default:
      return { key: status.state };
  }
}

// RA §7.2: what the restaurant's own buttons may do now. Operations' pause
// and the auto-pause hold the buttons; the restaurant cannot pause while
// closed; busy mode matters only while open.
export function controlsOf(status: RestaurantStatus) {
  const heldByOperations =
    status.state === 'paused' && (status.pauseSource === 'ops' || status.pauseSource === 'auto');
  const open = status.state === 'open' || status.state === 'busy';
  return {
    heldByOperations,
    canPause: open,
    canResume: status.state === 'paused' && status.pauseSource === 'restaurant',
    canBusyMode: status.state === 'open',
    holidaySet: status.holiday !== null,
  };
}

export type StatusCommand =
  | { kind: 'pause'; minutes: number | null }
  | { kind: 'resume' }
  | { kind: 'busy_mode'; extraMin: number | null }
  | { kind: 'holiday'; startsAt: string | null; endsAt: string; message: string | null }
  | { kind: 'end_holiday' };

export type StatusAnswer = { status: 'done' } | { status: 'refused'; refusal: string };

// Each command answers the status, which replaces the read. A refusal (the
// state changed on another device, a holiday end before its start) is
// explained; anything else throws.
export function useStatusCommand() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: async (command: StatusCommand): Promise<StatusAnswer> => {
      const result = await send(command);
      if (result.data) {
        queryClient.setQueryData(statusQuery.queryKey, result.data);
        return { status: 'done' };
      }
      const refusal = (result.error as { error?: unknown } | undefined)?.error;
      if (result.response.status >= 400 && result.response.status < 500) {
        void queryClient.invalidateQueries({ queryKey: statusQuery.queryKey });
        return { status: 'refused', refusal: typeof refusal === 'string' ? refusal : 'invalid' };
      }
      throw new Error(`The status command failed (${result.response.status}).`);
    },
  });
}

function send(command: StatusCommand) {
  switch (command.kind) {
    case 'pause':
      return api.POST('/v1/merchant/restaurant/status/pause', {
        body: { minutes: command.minutes },
      });
    case 'resume':
      return api.POST('/v1/merchant/restaurant/status/resume');
    case 'busy_mode':
      return api.PUT('/v1/merchant/restaurant/status/busy-mode', {
        body: { extraMin: command.extraMin },
      });
    case 'holiday':
      return api.PUT('/v1/merchant/restaurant/holiday-close', {
        body: { startsAt: command.startsAt, endsAt: command.endsAt, message: command.message },
      });
    case 'end_holiday':
      return api.DELETE('/v1/merchant/restaurant/holiday-close');
  }
}

// The holiday close's form: from (empty: now) and to, typed on the city's
// clock; the instants, or which part is wrong. The end must come after the
// start, or after now on the server's clock.
export function holidayOf(
  form: { from: string; to: string; message: string },
  timeZone: string,
  now: number,
): { startsAt: string | null; endsAt: string; message: string | null } | null {
  const startsAt = form.from === '' ? null : zonedToUtc(form.from, timeZone);
  const endsAt = zonedToUtc(form.to, timeZone);
  if (endsAt === null || (form.from !== '' && startsAt === null)) return null;
  if (Date.parse(endsAt) <= (startsAt === null ? now : Date.parse(startsAt))) return null;
  const message = form.message.trim();
  return { startsAt, endsAt, message: message === '' ? null : message };
}
