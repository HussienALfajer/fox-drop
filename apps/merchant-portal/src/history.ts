import type { components } from '@fox-drop/api-schema';
import { infiniteQueryOptions } from '@tanstack/react-query';
import { api } from './api.js';

export type HistoryPage = components['schemas']['MerchantOrderHistoryDto_Output'];
export type HistoryOrder = HistoryPage['orders'][number];
export type OrderStatus = HistoryOrder['status'];

export const ORDER_STATUSES = [
  'placed',
  'accepted',
  'ready',
  'picked_up',
  'arrived',
  'delivered',
  'failed',
  'rejected',
  'cancelled',
] as const satisfies readonly OrderStatus[];

// What «السجل» asks (RA §8.18): a range of business days (none: today and
// the 7 days before), a status and an order number, each narrowing it.
export interface HistoryFilter {
  from: string | null;
  to: string | null;
  status: OrderStatus | null;
  number: string | null;
}

export type HistoryRead =
  | { status: 'ok'; page: HistoryPage }
  | { status: 'refused'; refusal: 'period' | 'terminated' | 'other' };

// RA §8.18, §17 (slice 2.45d): the restaurant's orders, newest first,
// HISTORY_PAGE a page; «عرض المزيد» reads the next one.
export function historyQuery(filter: HistoryFilter) {
  return infiniteQueryOptions({
    queryKey: ['history', filter],
    initialPageParam: null as string | null,
    getNextPageParam: (last: HistoryRead) => (last.status === 'ok' ? last.page.next : null),
    queryFn: async ({ pageParam }): Promise<HistoryRead> => {
      const { data, error, response } = await api.GET('/v1/merchant/orders/history', {
        params: {
          query: {
            ...(filter.from !== null && filter.to !== null
              ? { from: filter.from, to: filter.to }
              : {}),
            ...(filter.status === null ? {} : { status: filter.status }),
            ...(filter.number === null ? {} : { number: filter.number }),
            ...(pageParam === null ? {} : { cursor: pageParam }),
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
      throw new Error(`The history read failed (${response.status}).`);
    },
  });
}

// An order number typed with or without «#», or null when it is none.
export function numberOf(typed: string): string | null | 'invalid' {
  const trimmed = typed.trim().replace(/^#/, '');
  if (trimmed === '') return null;
  return /^\d{1,12}$/.test(trimmed) ? trimmed : 'invalid';
}
