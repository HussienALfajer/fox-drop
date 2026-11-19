import { queryOptions, useMutation, useQueryClient } from '@tanstack/react-query';
import { useRef } from 'react';
import type { components } from '@fox-drop/api-schema';
import { api } from './api.js';
import { minorOf } from './format.js';
import { menuKey } from './restaurant-menu.js';

// AP §9.6.6 «تعديل جماعي» and «سجل الأسعار» (slice 2.31): a bulk price change
// previewed before and after, then applied with one Idempotency-Key per
// preview; the price log of the restaurant.
type BulkBody = components['schemas']['AdminMenuBulkPriceDto'];
export type BulkPreview = components['schemas']['AdminMenuBulkPreviewDto_Output'];
export type BulkApplied = components['schemas']['AdminMenuBulkPriceResultDto_Output'];
export type PriceLogEntry =
  components['schemas']['AdminRestaurantPriceLogDto_Output']['entries'][number];

// The change as typed: the scope (a category, or '' for the whole menu), a
// percentage («10» or «7.5») or an amount in the base's major units.
export interface BulkForm {
  categoryId: string;
  kind: BulkBody['kind'];
  direction: BulkBody['direction'];
  value: string;
}

export const bulkFormOf = (): BulkForm => ({
  categoryId: '',
  kind: 'percent',
  direction: 'up',
  value: '',
});

export function bulkBody(form: BulkForm, currency: string): BulkBody | { problem: 'value' } {
  // A percentage in basis points: two decimals at most, 1000 is 10%.
  const value =
    form.kind === 'percent' ? minorOf(form.value, currency, 2) : minorOf(form.value, currency);
  if (value === null || /^0+$/.test(value)) return { problem: 'value' };
  return {
    categoryId: form.categoryId === '' ? null : form.categoryId,
    kind: form.kind,
    direction: form.direction,
    value,
  };
}

export type BulkResult<T> = { status: 'done'; value: T } | { status: 'refused'; refusal: string };

function refusalOf(error: unknown): string {
  const refusal = (error as { error?: unknown } | undefined)?.error;
  return typeof refusal === 'string' ? refusal : 'invalid';
}

const REFUSED = [400, 403, 404, 409, 422];

export function useBulkPreview(restaurantId: string) {
  return useMutation({
    mutationFn: async (body: BulkBody): Promise<BulkResult<BulkPreview>> => {
      const { data, error, response } = await api.POST(
        '/v1/admin/restaurant-drafts/{restaurantId}/menu/bulk-price/preview',
        { params: { path: { restaurantId } }, body },
      );
      if (data) return { status: 'done', value: data };
      if (REFUSED.includes(response.status))
        return { status: 'refused', refusal: refusalOf(error) };
      throw new Error(`The bulk preview failed (${response.status}).`);
    },
  });
}

// One key per change previewed, kept until an answer arrives, so a retry of
// a lost answer applies it once (architecture §5.3).
export function useApplyBulk(restaurantId: string) {
  const queryClient = useQueryClient();
  const keys = useRef(new Map<string, string>());
  return useMutation({
    mutationFn: async (body: BulkBody): Promise<BulkResult<BulkApplied>> => {
      const id = JSON.stringify(body);
      let key = keys.current.get(id);
      if (key === undefined) {
        key = crypto.randomUUID();
        keys.current.set(id, key);
      }
      const { data, error, response } = await api.POST(
        '/v1/admin/restaurant-drafts/{restaurantId}/menu/bulk-price',
        { params: { path: { restaurantId }, header: { 'Idempotency-Key': key } }, body },
      );
      if (data) {
        keys.current.delete(id);
        return { status: 'done', value: data };
      }
      if (REFUSED.includes(response.status)) {
        keys.current.delete(id);
        return { status: 'refused', refusal: refusalOf(error) };
      }
      throw new Error(`The bulk change failed (${response.status}).`);
    },
    onSuccess: (result) => {
      if (result.status !== 'done') return;
      void queryClient.invalidateQueries({ queryKey: menuKey(restaurantId) });
      void queryClient.invalidateQueries({ queryKey: priceLogKey(restaurantId) });
    },
  });
}

// The items ticked for «توفر جماعي», in menu order.
export function ticked(order: readonly string[], chosen: ReadonlySet<string>): string[] {
  return order.filter((id) => chosen.has(id));
}

const priceLogKey = (restaurantId: string) => ['restaurant-price-log', restaurantId] as const;

export const priceLogQuery = (restaurantId: string) =>
  queryOptions({
    queryKey: priceLogKey(restaurantId),
    queryFn: async (): Promise<PriceLogEntry[]> => {
      const { data } = await api.GET('/v1/admin/restaurants/{restaurantId}/menu/price-log', {
        params: { path: { restaurantId } },
      });
      if (!data) throw new Error('The price log read failed.');
      return data.entries;
    },
  });
