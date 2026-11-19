import type { components } from '@fox-drop/api-schema';
import { infiniteQueryOptions, queryOptions } from '@tanstack/react-query';
import { api } from './api.js';
import { type AdminSession, can } from './session.js';

export type RatingsPage = components['schemas']['AdminRatingsDto_Output'];
export type RatedCaptain =
  components['schemas']['AdminRatedCaptainsDto_Output']['captains'][number];

export const CAPTAINS_READ = 'captains.read';

// AP §9.6.4, §9.7.4 (slice 2.26c): restaurants.read reads a restaurant's
// ratings, captains.read a captain's (OWN, OPS, SUP; AP §6.2).
// A captain's ratings (a restaurant's are in its profile, slice 2.30d).
export function canSeeRatings(session: AdminSession | null | undefined): boolean {
  return can(session, CAPTAINS_READ);
}

export const ratingPeriods = ['all', 'today', 'yesterday', 'last_7_days', 'last_30_days'] as const;
export type RatingPeriod = (typeof ratingPeriods)[number];

export interface RatingsSearch {
  city?: string;
  captain?: string;
  period?: RatingPeriod;
  stars?: number;
}

// The page's search: a captain, the period and the stars; anything else is
// dropped.
export function ratingsSearch(search: Record<string, unknown>): RatingsSearch {
  const text = (key: string) => (typeof search[key] === 'string' ? search[key] : undefined);
  const city = text('city');
  const captain = text('captain');
  const period = ratingPeriods.find((each) => each === search.period);
  const stars = Number(search.stars);
  return {
    ...(city ? { city } : {}),
    ...(captain ? { captain } : {}),
    ...(period && period !== 'all' ? { period } : {}),
    ...(Number.isInteger(stars) && stars >= 1 && stars <= 5 ? { stars } : {}),
  };
}

export type RatingTarget = { party: 'restaurant'; id: string } | { party: 'captain'; id: string };

// The next page of «عرض المزيد», read as of the first page so the pages
// neither repeat nor miss a rating; none once the last says no more follow.
export function nextRatingsPage(
  last: RatingsPage,
  pages: readonly RatingsPage[],
): { page: number; asOf: string } | undefined {
  if (!last.more) return undefined;
  return { page: pages.length, asOf: pages[0]!.asOf };
}

export const ratingsQuery = (
  target: RatingTarget,
  filters: { period: RatingPeriod; stars: number | null },
) =>
  infiniteQueryOptions({
    queryKey: ['ratings', target.party, target.id, filters.period, filters.stars],
    initialPageParam: { page: 0, asOf: null } as { page: number; asOf: string | null },
    getNextPageParam: nextRatingsPage,
    queryFn: async ({ pageParam }): Promise<RatingsPage> => {
      const query = {
        period: filters.period,
        page: pageParam.page,
        ...(filters.stars === null ? {} : { stars: filters.stars }),
        ...(pageParam.asOf === null ? {} : { asOf: pageParam.asOf }),
      };
      const { data } =
        target.party === 'restaurant'
          ? await api.GET('/v1/admin/ratings/restaurants/{restaurantId}', {
              params: { path: { restaurantId: target.id }, query },
            })
          : await api.GET('/v1/admin/ratings/captains/{captainId}', {
              params: { path: { captainId: target.id }, query },
            });
      if (!data) throw new Error('The ratings read failed.');
      return data;
    },
  });

export const ratedCaptainsQuery = (cityId: string) =>
  queryOptions({
    queryKey: ['rated-captains', cityId],
    queryFn: async (): Promise<RatedCaptain[]> => {
      const { data } = await api.GET('/v1/admin/ratings/captains', {
        params: { query: { cityId } },
      });
      if (!data) throw new Error('The captains read failed.');
      return data.captains;
    },
  });
