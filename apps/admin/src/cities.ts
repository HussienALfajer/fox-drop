import type { components } from '@fox-drop/api-schema';
import { queryOptions } from '@tanstack/react-query';
import { api } from './api.js';

export type City = components['schemas']['AdminCitiesDto_Output']['cities'][number];

// AP §7.2: the cities of the top bar's selector. They change rarely.
export const citiesQuery = queryOptions({
  queryKey: ['cities'],
  queryFn: async (): Promise<City[]> => {
    const { data } = await api.GET('/v1/admin/cities');
    if (!data) throw new Error('The cities read failed.');
    return data.cities;
  },
  staleTime: 10 * 60_000,
});

// The city a page shows: the one its address names by code, else the first.
export function chosenCity(cities: City[], code: string | undefined): City | undefined {
  return cities.find((city) => city.code === code) ?? cities[0];
}
