import type { components } from '@fox-drop/api-schema';
import { queryOptions, useMutation, useQueryClient } from '@tanstack/react-query';
import { api } from './api.js';
import { receivesAlerts } from './alerts.js';
import { type AdminSession, can } from './session.js';

// AP §6.3: OWN and OPS start and end the stop; every panel user sees the bar.
export const EMERGENCY_STOP_TOGGLE = 'emergency_stop.toggle';

export type EmergencyStopState = components['schemas']['AdminEmergencyStopStateDto_Output'];
export type EmergencyStop = NonNullable<EmergencyStopState['stop']>;

// AP §9.1.6 item 4: the attempts have no event of their own, so the bar
// reads the stop again this often.
export const ATTEMPTS_POLL_MS = 30_000;

export const emergencyStopKey = (cityId: string) => ['emergency-stop', cityId] as const;

// The city's stop (null while the platform runs) and the dialog's prefills.
export const emergencyStopQuery = (cityId: string) =>
  queryOptions({
    queryKey: emergencyStopKey(cityId),
    queryFn: async (): Promise<EmergencyStopState> => {
      const { data } = await api.GET('/v1/admin/emergency-stop', {
        params: { query: { cityId } },
      });
      if (!data) throw new Error('The emergency stop read failed.');
      return data;
    },
    // A start or an end arrives over the city's channel at once; this read
    // brings the attempts, and the stop to a session without the channel.
    refetchInterval: ATTEMPTS_POLL_MS,
  });

// AP §7: how long the stop has lasted, in whole minutes, by the server's
// clock.
export function elapsedMinutes(startedAt: string, nowMs: number): number {
  return Math.max(0, Math.floor((nowMs - Date.parse(startedAt)) / 60_000));
}

// The delay notice as the customer reads it (CU §14 #18).
export function fillReason(delayNotice: string, customerReason: string): string {
  return delayNotice.replaceAll('{السبب}', customerReason);
}

// A wall time typed in the city's clock (an <input type="datetime-local">
// value, such as 2026-11-09T18:30) as an instant. Null for an empty or
// unreadable value.
export function zonedToUtc(local: string, timeZone: string): string | null {
  const match = /^(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2})$/.exec(local);
  if (!match) return null;
  const [year, month, day, hour, minute] = match.slice(1).map(Number) as [
    number,
    number,
    number,
    number,
    number,
  ];
  const asUtc = Date.UTC(year, month - 1, day, hour, minute);
  // The zone's offset at that moment, read twice so a change of offset
  // between the guess and the answer is taken into account.
  let instant = asUtc - offsetMs(asUtc, timeZone);
  instant = asUtc - offsetMs(instant, timeZone);
  return new Date(instant).toISOString();
}

function offsetMs(instant: number, timeZone: string): number {
  const parts = Object.fromEntries(
    new Intl.DateTimeFormat('en-US', {
      timeZone,
      hourCycle: 'h23',
      year: 'numeric',
      month: '2-digit',
      day: '2-digit',
      hour: '2-digit',
      minute: '2-digit',
      second: '2-digit',
    })
      .formatToParts(new Date(instant))
      .map((part) => [part.type, part.value]),
  );
  const wall = Date.UTC(
    Number(parts.year),
    Number(parts.month) - 1,
    Number(parts.day),
    Number(parts.hour),
    Number(parts.minute),
    Number(parts.second),
  );
  return wall - Math.floor(instant / 1000) * 1000;
}

export interface StartForm {
  internalReason: string;
  browseMessage: string;
  delayNotice: string;
  customerReason: string;
  // The city's wall time, or empty for no automatic resume.
  resumeAt: string;
}

export type StartResult =
  | { status: 'started'; stop: EmergencyStop }
  | { status: 'refused'; refusal: 'already_stopped' | 'resume_at_past' | 'invalid' };

export function useStartEmergencyStop(cityId: string, timeZone: string) {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: async (form: StartForm): Promise<StartResult> => {
      const resumeAt = form.resumeAt === '' ? null : zonedToUtc(form.resumeAt, timeZone);
      if (form.resumeAt !== '' && resumeAt === null)
        return { status: 'refused', refusal: 'invalid' };
      const { data, error, response } = await api.POST('/v1/admin/emergency-stop', {
        body: {
          cityId,
          internalReason: form.internalReason,
          browseMessage: form.browseMessage,
          delayNotice: form.delayNotice,
          customerReason: form.customerReason,
          resumeAt,
        },
      });
      if (data) return { status: 'started', stop: data.stop };
      const refusal = (error as { error?: unknown } | undefined)?.error;
      if (response.status === 409 && refusal === 'already_stopped') {
        return { status: 'refused', refusal };
      }
      if (response.status === 400) {
        return { status: 'refused', refusal: refusal === 'resume_at_past' ? refusal : 'invalid' };
      }
      throw new Error(`The emergency stop failed with ${response.status}.`);
    },
    onSettled: () => queryClient.invalidateQueries({ queryKey: emergencyStopKey(cityId) }),
  });
}

export type ResumeResult =
  { status: 'resumed' } | { status: 'refused'; refusal: 'stop_ended' | 'unknown_stop' | 'invalid' };

// «استئناف», with «الخدمة عادت» when serviceBack is a text (AP §9.1.6).
export function useResumeEmergencyStop(cityId: string) {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: async (command: {
      stopId: string;
      serviceBack: string | null;
    }): Promise<ResumeResult> => {
      const { data, error, response } = await api.POST('/v1/admin/emergency-stop/resume', {
        body: { cityId, ...command },
      });
      if (data) return { status: 'resumed' };
      const refusal = (error as { error?: unknown } | undefined)?.error;
      if (response.status === 409 && refusal === 'stop_ended')
        return { status: 'refused', refusal };
      if (response.status === 404) return { status: 'refused', refusal: 'unknown_stop' };
      if (response.status === 400) return { status: 'refused', refusal: 'invalid' };
      throw new Error(`The resume failed with ${response.status}.`);
    },
    onSettled: () => queryClient.invalidateQueries({ queryKey: emergencyStopKey(cityId) }),
  });
}

// Who the ops channel lets in (the server's readsOps): the board's readers and
// the alerts' recipients. Another session reads the stop by polling.
export function followsOps(session: AdminSession | null | undefined): boolean {
  return can(session, 'operations.read') || receivesAlerts(session);
}
