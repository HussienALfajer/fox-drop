import type { components } from '@fox-drop/api-schema';
import { queryOptions, useMutation, useQueryClient } from '@tanstack/react-query';
import { api } from './api.js';
import { zonedToUtc } from './emergency-stop.js';
import { RESTAURANTS_MANAGE, RESTAURANTS_READ } from './restaurant-images.js';
import { type AdminSession, can } from './session.js';

export type RestaurantStatus = components['schemas']['AdminRestaurantStatusDto_Output'];
export type RestaurantState = RestaurantStatus['state'];

// AP §9.6.5: everyone who reads restaurants sees their state; OWN and OPS
// (restaurants.manage) change it.
export function canSeeRestaurantStatus(session: AdminSession | null | undefined): boolean {
  return can(session, RESTAURANTS_READ);
}

export function canChangeRestaurantStatus(session: AdminSession | null | undefined): boolean {
  return can(session, RESTAURANTS_MANAGE);
}

export const restaurantStatusQuery = (restaurantId: string) =>
  queryOptions({
    queryKey: ['restaurant-status', restaurantId],
    queryFn: async (): Promise<RestaurantStatus> => {
      const { data } = await api.GET('/v1/admin/restaurants/{restaurantId}/status', {
        params: { path: { restaurantId } },
      });
      if (!data) throw new Error('The restaurant status read failed.');
      return data;
    },
  });

export type StateKey =
  | 'open'
  | 'busy'
  | 'paused'
  | 'pausedByOperations'
  | 'autoPaused'
  | 'closed'
  | 'holiday'
  | 'suspended'
  | 'draft'
  | 'terminated';

// RA Appendix B's labels, by state and who paused it.
export function stateKey(status: Pick<RestaurantStatus, 'state' | 'pauseSource'>): StateKey {
  if (status.state !== 'paused') return status.state;
  if (status.pauseSource === 'ops') return 'pausedByOperations';
  if (status.pauseSource === 'auto') return 'autoPaused';
  return 'paused';
}

// «إيقاف مؤقت» (AP §9.6.5): a fixed length, until a time on the city's
// clock, or until resumed.
export type PauseLength = '15' | '30' | '60' | 'until' | 'resumed';

export interface PauseForm {
  length: PauseLength;
  // The city's wall time, for «حتى وقت محدد».
  until: string;
  message: string;
  reason: string;
}

// The refusals the page explains: the server's 400 (a reason missing, a time
// not ahead, a value off its range) and a suspended restaurant's holiday.
export type StatusRefusal = 'invalid' | 'suspended';

export type StatusResult =
  { status: 'done'; restaurant: RestaurantStatus } | { status: 'refused'; refusal: StatusRefusal };

type PauseBody = components['schemas']['AdminRestaurantPauseDto'];

// The pause the server takes, or null when the time cannot be read.
export function pauseBody(form: PauseForm, timeZone: string): PauseBody | null {
  const message = form.message.trim() === '' ? null : form.message.trim();
  const base = { message, reason: form.reason.trim() };
  if (form.length === 'resumed') return { ...base, minutes: null, until: null };
  if (form.length === 'until') {
    const until = zonedToUtc(form.until, timeZone);
    return until === null ? null : { ...base, minutes: null, until };
  }
  return { ...base, minutes: Number(form.length), until: null };
}

// A command's answer as the page shows it: the status after it, or why not.
function outcome(answer: { data?: RestaurantStatus; response: Response }): StatusResult {
  if (answer.data) return { status: 'done', restaurant: answer.data };
  if (answer.response.status === 400) return { status: 'refused', refusal: 'invalid' };
  if (answer.response.status === 409) return { status: 'refused', refusal: 'suspended' };
  throw new Error(`The restaurant status command failed (${answer.response.status}).`);
}

function useStatusCommand<Input>(
  restaurantId: string,
  run: (input: Input) => Promise<StatusResult>,
) {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: run,
    onSuccess: (result) => {
      if (result.status === 'done') {
        queryClient.setQueryData(['restaurant-status', restaurantId], result.restaurant);
      }
    },
    // The auto-pause's alert resolves with a resume.
    onSettled: () => queryClient.invalidateQueries({ queryKey: ['alerts'] }),
  });
}

export function usePauseRestaurant(restaurantId: string, timeZone: string) {
  return useStatusCommand(restaurantId, async (form: PauseForm) => {
    const body = pauseBody(form, timeZone);
    if (body === null) return { status: 'refused', refusal: 'invalid' };
    return outcome(
      await api.POST('/v1/admin/restaurants/{restaurantId}/status/pause', {
        params: { path: { restaurantId } },
        body,
      }),
    );
  });
}

export function useResumeRestaurant(restaurantId: string) {
  return useStatusCommand(restaurantId, async () =>
    outcome(
      await api.POST('/v1/admin/restaurants/{restaurantId}/status/resume', {
        params: { path: { restaurantId } },
      }),
    ),
  );
}

export function useEndBusyMode(restaurantId: string) {
  return useStatusCommand(restaurantId, async () =>
    outcome(
      await api.DELETE('/v1/admin/restaurants/{restaurantId}/status/busy-mode', {
        params: { path: { restaurantId } },
      }),
    ),
  );
}

export interface HolidayForm {
  // The city's wall times; an empty start is now.
  startsAt: string;
  endsAt: string;
  message: string;
  reason: string;
}

export function useHolidayClose(restaurantId: string, timeZone: string) {
  return useStatusCommand(restaurantId, async (form: HolidayForm) => {
    const startsAt = form.startsAt === '' ? null : zonedToUtc(form.startsAt, timeZone);
    const endsAt = zonedToUtc(form.endsAt, timeZone);
    if (endsAt === null || (form.startsAt !== '' && startsAt === null)) {
      return { status: 'refused', refusal: 'invalid' };
    }
    return outcome(
      await api.PUT('/v1/admin/restaurants/{restaurantId}/holiday-close', {
        params: { path: { restaurantId } },
        body: {
          startsAt,
          endsAt,
          message: form.message.trim() === '' ? null : form.message.trim(),
          reason: form.reason.trim(),
        },
      }),
    );
  });
}

export function useEndHolidayClose(restaurantId: string) {
  return useStatusCommand(restaurantId, async () =>
    outcome(
      await api.DELETE('/v1/admin/restaurants/{restaurantId}/holiday-close', {
        params: { path: { restaurantId } },
      }),
    ),
  );
}

// The maximum active orders (RA §7.4): empty is off, else 1 to 50.
export function maxActiveOrders(value: string): number | null | undefined {
  if (value.trim() === '') return null;
  const number = Number(value);
  return Number.isInteger(number) && number >= 1 && number <= 50 ? number : undefined;
}

export function useSetMaxActiveOrders(restaurantId: string) {
  return useStatusCommand(restaurantId, async (value: string) => {
    const max = maxActiveOrders(value);
    if (max === undefined) return { status: 'refused', refusal: 'invalid' };
    return outcome(
      await api.PUT('/v1/admin/restaurants/{restaurantId}/max-active-orders', {
        params: { path: { restaurantId } },
        body: { maxActiveOrders: max },
      }),
    );
  });
}
