import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import type { components } from '@fox-drop/api-schema';
import { api } from './api.js';
import { citiesQuery } from './cities.js';

// AP §9.12.1 «المدن» (slice 2.37c; owner decisions 2026-11-19: the existing
// city only, adding one waits for a second city; the clock may change at
// any time): the city's name, code, clock and status, and its currencies
// and base (D25). OWN changes them (zones.manage); OPS and FIN read.
export type CityProfile = components['schemas']['AdminCityDto_Output'];
type UpdateCity = components['schemas']['AdminUpdateCityDto'];

export interface CityForm {
  name: string;
  code: string;
  timeZone: string;
  active: boolean;
  reason: string;
}

export function cityFormOf(city: CityProfile['city']): CityForm {
  return {
    name: city.name,
    code: city.code,
    timeZone: city.timeZone,
    active: city.status === 'active',
    reason: '',
  };
}

export type CityProblem = 'name' | 'code' | 'timeZone';

// The body to save, or the first problem; the server checks that it knows
// the time zone and that the code is free.
export function cityRequestOf(form: CityForm): { body: UpdateCity } | { problem: CityProblem } {
  const name = form.name.trim();
  if (name === '' || name.length > 100) return { problem: 'name' };
  const code = form.code.trim().toUpperCase();
  if (!/^[A-Z]{2,3}$/.test(code)) return { problem: 'code' };
  const timeZone = form.timeZone.trim();
  if (!/^[A-Za-z_]+(\/[A-Za-z0-9_+-]+)+$/.test(timeZone) && timeZone !== 'UTC') {
    return { problem: 'timeZone' };
  }
  const reason = form.reason.trim();
  return {
    body: {
      name,
      code,
      timeZone,
      status: form.active ? 'active' : 'inactive',
      reason: reason === '' ? null : reason,
    },
  };
}

// The base currency, null before one is chosen.
export function baseOf(profile: CityProfile): string | null {
  return profile.currencies.find((each) => each.isBase)?.code ?? null;
}

// The next display order for a currency added at the end.
export function nextDisplayOrder(profile: CityProfile): number {
  return Math.max(0, ...profile.currencies.map((each) => each.displayOrder)) + 1;
}

const profileKey = (cityId: string) => ['city-profile', cityId] as const;

export function useCityProfile(cityId: string | undefined) {
  return useQuery({
    queryKey: profileKey(cityId ?? ''),
    enabled: cityId !== undefined,
    queryFn: async () => {
      const { data } = await api.GET('/v1/admin/cities/{cityId}', {
        params: { path: { cityId: cityId! } },
      });
      if (!data) throw new Error('city unavailable');
      return data;
    },
  });
}

// Every city, active or not, so an inactive one can be activated again.
export const allCitiesQuery = {
  queryKey: ['cities', 'all'] as const,
  queryFn: async () => {
    const { data } = await api.GET('/v1/admin/cities/all');
    if (!data) throw new Error('cities unavailable');
    return data.cities;
  },
};

export type CityRefusal =
  | 'invalid_name'
  | 'invalid_city'
  | 'city_code_taken'
  | 'not_city_currency'
  | 'inactive_currency'
  | 'base_disabled'
  | 'base_locked'
  | 'rate_missing'
  | 'amounts_in_other_currency';

const cityRefusals: readonly CityRefusal[] = [
  'invalid_name',
  'invalid_city',
  'city_code_taken',
  'not_city_currency',
  'inactive_currency',
  'base_disabled',
  'base_locked',
  'rate_missing',
  'amounts_in_other_currency',
];

export type CitySaveResult = { status: 'saved' } | { status: 'refused'; refusal: CityRefusal };

export type CityCommand =
  | { kind: 'city'; body: UpdateCity }
  | { kind: 'currency'; currency: string; displayOrder: number; enabled: boolean }
  | { kind: 'base'; currency: string };

// The commands of «المدن»: each sets a value, so none takes a key; each
// answers the city, which replaces the read. The selector's list is read
// again after a change of the city's own fields.
export function useCityCommand(cityId: string) {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: async (command: CityCommand): Promise<CitySaveResult> => {
      const path = { path: { cityId } };
      const { data, error, response } =
        command.kind === 'city'
          ? await api.PUT('/v1/admin/cities/{cityId}', { params: path, body: command.body })
          : command.kind === 'currency'
            ? await api.PUT('/v1/admin/cities/{cityId}/currencies/{currency}', {
                params: { path: { cityId, currency: command.currency } },
                body: { displayOrder: command.displayOrder, enabled: command.enabled },
              })
            : await api.PUT('/v1/admin/cities/{cityId}/base-currency', {
                params: path,
                body: { currency: command.currency },
              });
      if (data) {
        queryClient.setQueryData(profileKey(cityId), data);
        if (command.kind === 'city') {
          await queryClient.invalidateQueries({ queryKey: citiesQuery.queryKey });
        }
        return { status: 'saved' };
      }
      const code = (error as { error?: string } | undefined)?.error;
      const refusal = cityRefusals.find((each) => each === code);
      if (refusal) return { status: 'refused', refusal };
      throw new Error(`city command failed with ${response.status}`);
    },
  });
}
