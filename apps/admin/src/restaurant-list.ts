import type { components } from '@fox-drop/api-schema';
import { keepPreviousData, queryOptions } from '@tanstack/react-query';
import { api } from './api.js';
import { RESTAURANTS_READ } from './restaurant-drafts.js';
import { type AdminSession, can } from './session.js';

export type RestaurantList = components['schemas']['AdminRestaurantListDto_Output'];
export type ListedRestaurant = RestaurantList['restaurants'][number];
export type AccountStatus = ListedRestaurant['accountStatus'];

// AP §9.6.1, in the list's filter order.
export const accountStatuses = [
  'active',
  'test',
  'draft',
  'suspended',
  'terminated',
] as const satisfies readonly AccountStatus[];

// AP §9.6.2 «المطاعم» (slice 2.30c): everyone who reads restaurants.
export function canSeeRestaurantList(session: AdminSession | null | undefined): boolean {
  return can(session, RESTAURANTS_READ);
}

// The list's filters as the search keeps them.
export interface ListFilter {
  status?: AccountStatus;
  category?: string;
  zone?: string;
  q?: string;
}

export function listFilterOf(search: Record<string, unknown>): ListFilter {
  const text = (key: string) =>
    typeof search[key] === 'string' && search[key] !== '' ? (search[key] as string) : undefined;
  const status = text('status');
  return {
    ...((accountStatuses as readonly string[]).includes(status ?? '')
      ? { status: status as AccountStatus }
      : {}),
    ...(text('category') ? { category: text('category')! } : {}),
    ...(text('zone') ? { zone: text('zone')! } : {}),
    ...(text('q') ? { q: text('q')! } : {}),
  };
}

// The search is a POST, so a number typed never sits in a URL; the panel
// keeps only the name searched in its own search parameters (q) and the
// number in the page's state.
export const restaurantListQuery = (cityId: string, filter: ListFilter) =>
  queryOptions({
    queryKey: ['restaurant-list', cityId, filter],
    queryFn: async (): Promise<RestaurantList> => {
      const { data } = await api.POST('/v1/admin/restaurant-list', {
        body: {
          cityId,
          status: filter.status ?? null,
          categoryId: filter.category ?? null,
          zoneId: filter.zone ?? null,
          q: filter.q?.trim() ? filter.q.trim().slice(0, 60) : null,
        },
      });
      if (!data) throw new Error('The restaurant list read failed.');
      return data;
    },
    placeholderData: keepPreviousData,
  });

// A number in any of the forms the server reads (E.164, 00…, 09…, 05…):
// kept out of the URL.
export function looksLikePhone(text: string): boolean {
  return /^\+?\d[\d\s-]{6,}$/.test(text.trim());
}

// «12.5%» from basis points.
export function percentText(bp: number): string {
  return `${(bp / 100).toFixed(2).replace(/\.?0+$/, '')}%`;
}
