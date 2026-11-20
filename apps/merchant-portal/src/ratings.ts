import type { components } from '@fox-drop/api-schema';
import { infiniteQueryOptions } from '@tanstack/react-query';
import { api } from './api.js';
import type { PeriodChoice } from './period.js';

export type RatingsPage = components['schemas']['MerchantRatingsDto_Output'];

// RA §13: «الكل» (the default) and the reports' periods; the portal adds a
// custom range (owner decision 2026-11-17).
export const RATING_PERIODS = ['all', 'today', 'yesterday', 'last_7_days', 'last_30_days'] as const;
export type RatingPeriod = (typeof RATING_PERIODS)[number];

export type RatingsRead =
  | { status: 'ok'; page: RatingsPage }
  | { status: 'refused'; refusal: 'period' | 'terminated' | 'other' };

// RA §13, §17 (slice 2.45d): the summary of the period and its ratings
// newest first, a page at a time; every next page carries the first page's
// `asOf`, so the pages agree.
export function ratingsQuery(choice: PeriodChoice<RatingPeriod>, stars: number | null) {
  return infiniteQueryOptions({
    queryKey: ['ratings', choice, stars],
    initialPageParam: { page: 0, asOf: null as string | null },
    getNextPageParam: (last: RatingsRead, all: RatingsRead[]) =>
      last.status === 'ok' && last.page.more
        ? { page: all.length, asOf: (all[0] as { page: RatingsPage }).page.asOf }
        : null,
    queryFn: async ({ pageParam }): Promise<RatingsRead> => {
      const { data, error, response } = await api.GET('/v1/merchant/ratings', {
        params: {
          query: {
            ...(choice.kind === 'period'
              ? { period: choice.period }
              : { from: choice.from, to: choice.to }),
            ...(stars === null ? {} : { stars }),
            page: pageParam.page,
            ...(pageParam.asOf === null ? {} : { asOf: pageParam.asOf }),
          },
        },
      });
      if (data) return { status: 'ok', page: data };
      if (response.status >= 400 && response.status < 500) {
        const refusal = (error as { error?: unknown } | undefined)?.error;
        return {
          status: 'refused',
          refusal:
            refusal === 'invalid_period'
              ? 'period'
              : refusal === 'restaurant_terminated'
                ? 'terminated'
                : 'other',
        };
      }
      throw new Error(`The ratings read failed (${response.status}).`);
    },
  });
}
