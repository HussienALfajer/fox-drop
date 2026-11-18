import type { components } from '@fox-drop/api-schema';
import { queryOptions, useMutation, useQueryClient } from '@tanstack/react-query';
import { api } from './api.js';
import { zonedToUtc } from './emergency-stop.js';
import { basisPointsOf, RESTAURANTS_COMMISSION, RESTAURANTS_MANAGE } from './restaurant-drafts.js';
import { type AdminSession, can } from './session.js';

export type RestaurantAccount = components['schemas']['AdminRestaurantActionsDto_Output'];

// AP §6.3, §9.6.5: OWN alone ends a contract.
export const RESTAURANTS_TERMINATE = 'restaurants.terminate';

// AP §9.6.5: suspend, reactivate, hide and the sort weight (OWN, OPS).
export function canManageAccount(session: AdminSession | null | undefined): boolean {
  return can(session, RESTAURANTS_MANAGE);
}

// D16: the commission change, OWN alone.
export function canChangeCommission(session: AdminSession | null | undefined): boolean {
  return can(session, RESTAURANTS_COMMISSION);
}

export function canTerminate(session: AdminSession | null | undefined): boolean {
  return can(session, RESTAURANTS_TERMINATE);
}

const accountKey = (restaurantId: string) => ['restaurant-account', restaurantId] as const;

export const restaurantAccountQuery = (restaurantId: string) =>
  queryOptions({
    queryKey: accountKey(restaurantId),
    queryFn: async (): Promise<RestaurantAccount> => {
      const { data } = await api.GET('/v1/admin/restaurants/{restaurantId}/account', {
        params: { path: { restaurantId } },
      });
      if (!data) throw new Error('The restaurant account read failed.');
      return data;
    },
  });

// The refusals the page explains, by the server's answer.
export type AccountRefusal =
  'invalid' | 'not_allowed' | 'terminated' | 'balance_not_zero' | 'orders_unfinished';

export type AccountResult = { status: 'done' } | { status: 'refused'; refusal: AccountRefusal };

function refusalOf(response: Response, error: unknown): AccountRefusal | null {
  const code = (error as { error?: string } | undefined)?.error;
  if (response.status === 400) return 'invalid';
  if (response.status === 403 && code === 'restaurant_terminated') return 'terminated';
  if (response.status === 409) {
    if (code === 'balance_not_zero' || code === 'orders_unfinished') return code;
    return 'not_allowed';
  }
  return null;
}

async function outcome(answer: {
  data?: unknown;
  error?: unknown;
  response: Response;
}): Promise<AccountResult> {
  if (answer.data) return { status: 'done' };
  const refusal = refusalOf(answer.response, answer.error);
  if (refusal !== null) return { status: 'refused', refusal };
  throw new Error(`The restaurant account command failed (${answer.response.status}).`);
}

// Every command reads the account, the state and the list again.
function useAccountCommand<Input>(
  restaurantId: string,
  run: (input: Input) => Promise<AccountResult>,
) {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: run,
    onSettled: () =>
      Promise.all([
        queryClient.invalidateQueries({ queryKey: accountKey(restaurantId) }),
        queryClient.invalidateQueries({ queryKey: ['restaurant-status', restaurantId] }),
        queryClient.invalidateQueries({ queryKey: ['restaurant-list'] }),
      ]),
  });
}

const path = (restaurantId: string) => ({ params: { path: { restaurantId } } });

export function useSuspend(restaurantId: string) {
  return useAccountCommand(restaurantId, async (reason: string) =>
    outcome(
      await api.POST('/v1/admin/restaurants/{restaurantId}/suspend', {
        ...path(restaurantId),
        body: { reason: reason.trim() },
      }),
    ),
  );
}

export function useReactivate(restaurantId: string) {
  return useAccountCommand(restaurantId, async (reason: string) =>
    outcome(
      await api.POST('/v1/admin/restaurants/{restaurantId}/reactivate', {
        ...path(restaurantId),
        body: { reason: reason.trim() },
      }),
    ),
  );
}

export function useSetVisibility(restaurantId: string) {
  return useAccountCommand(restaurantId, async (visible: boolean) =>
    outcome(
      await api.PUT('/v1/admin/restaurants/{restaurantId}/visibility', {
        ...path(restaurantId),
        body: { visible },
      }),
    ),
  );
}

// «تثبيت»: a whole number from 0 to the server's maximum, or null.
export function sortWeightOf(typed: string, max: number): number | null {
  if (!/^\d{1,4}$/.test(typed.trim())) return null;
  const weight = Number(typed.trim());
  return weight <= max ? weight : null;
}

export function useSetSortWeight(restaurantId: string) {
  return useAccountCommand(restaurantId, async (sortWeight: number) =>
    outcome(
      await api.PUT('/v1/admin/restaurants/{restaurantId}/sort-weight', {
        ...path(restaurantId),
        body: { sortWeight },
      }),
    ),
  );
}

// «تغيير العمولة» (D16): for new orders, now or from a moment typed on the
// city's clock, with a reason.
export interface CommissionForm {
  percent: string;
  when: 'now' | 'at';
  at: string;
  reason: string;
}

type CommissionBody = components['schemas']['AdminRestaurantCommissionDto'];

// The body the server takes, or null while a field cannot be read.
export function commissionBody(form: CommissionForm, timeZone: string): CommissionBody | null {
  const rateBp = basisPointsOf(form.percent);
  if (rateBp === null || rateBp > 10_000 || form.reason.trim() === '') return null;
  if (form.when === 'now') return { rateBp, effectiveFrom: null, reason: form.reason.trim() };
  const effectiveFrom = zonedToUtc(form.at, timeZone);
  return effectiveFrom === null ? null : { rateBp, effectiveFrom, reason: form.reason.trim() };
}

export function useChangeCommission(restaurantId: string, timeZone: string) {
  return useAccountCommand(restaurantId, async (form: CommissionForm) => {
    const body = commissionBody(form, timeZone);
    if (body === null) return { status: 'refused', refusal: 'invalid' };
    return outcome(
      await api.POST('/v1/admin/restaurants/{restaurantId}/commission', {
        ...path(restaurantId),
        body,
      }),
    );
  });
}

export function useTerminate(restaurantId: string) {
  return useAccountCommand(restaurantId, async (reason: string) =>
    outcome(
      await api.POST('/v1/admin/restaurants/{restaurantId}/terminate', {
        ...path(restaurantId),
        body: { reason: reason.trim() },
      }),
    ),
  );
}
