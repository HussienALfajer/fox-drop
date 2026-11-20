import type { components } from '@fox-drop/api-schema';
import { queryOptions, useMutation, useQueryClient } from '@tanstack/react-query';
import { useRef } from 'react';
import { api } from './api.js';
import { decimalOf, minorOf } from './format.js';

// RA §9, §17, §5.4 (slice 2.45b): the owner's «القائمة» in the portal, the
// restaurant app's owner menu on the same routes. Every command answers the
// menu, which replaces the read; the availability switch answers only the
// switch, so the menu is read again.
export type Menu = components['schemas']['MerchantMenuDto_Output'];
export type MenuCategory = Menu['categories'][number];
export type MenuItem = MenuCategory['items'][number];
export type MenuOption = MenuItem['optionGroups'][number]['options'][number];
export type MenuGroup = Menu['optionGroups'][number];
export type Pending = MenuItem['pending'][number];
export type SwitchedOff = MenuItem['switchedOff'];
export type BulkPreview = components['schemas']['MerchantMenuBulkPreviewDto_Output'];
export type BulkBody = components['schemas']['MerchantMenuBulkPriceDto'];
export type PriceLogEntry = components['schemas']['MerchantPriceLogDto_Output']['entries'][number];
export type PreviewCategory =
  components['schemas']['MerchantMenuPreviewDto_Output']['menu'][number];
type GroupBody = components['schemas']['MerchantOptionGroupRequestDto'];

export const menuKey = ['menu'] as const;

export const menuQuery = queryOptions({
  queryKey: menuKey,
  queryFn: async (): Promise<Menu | 'terminated'> => {
    const { data, error, response } = await api.GET('/v1/merchant/menu');
    if (data) return data;
    if (refusalOf(error) === 'restaurant_terminated') return 'terminated';
    throw new Error(`The menu read failed (${response.status}).`);
  },
});

export const priceLogQuery = queryOptions({
  queryKey: ['menu-price-log'],
  queryFn: async (): Promise<PriceLogEntry[] | 'terminated'> => {
    const { data, error, response } = await api.GET('/v1/merchant/menu/price-log');
    if (data) return data.entries;
    if (refusalOf(error) === 'restaurant_terminated') return 'terminated';
    throw new Error(`The price log read failed (${response.status}).`);
  },
});

// RA §9.7: read again each time it opens, so it follows the edits.
export const previewQuery = queryOptions({
  queryKey: ['menu-preview'],
  queryFn: async (): Promise<PreviewCategory[] | 'terminated'> => {
    const { data, error, response } = await api.GET('/v1/merchant/menu/customer-preview');
    if (data) return data.menu;
    if (refusalOf(error) === 'restaurant_terminated') return 'terminated';
    throw new Error(`The preview read failed (${response.status}).`);
  },
  staleTime: 0,
});

// The kinds of restaurant.state_changed after which the menu is read again
// (RA §18): a change from another device, an admin's price change, a
// review's decision. As the restaurant app's `menuKinds`.
export const MENU_KINDS: ReadonlySet<string> = new Set([
  'menu_changed',
  'price_change',
  'price_change_bulk',
  'menu_change_approved',
  'menu_change_rejected',
]);

export function refusalOf(error: unknown): string {
  const refusal = (error as { error?: unknown } | undefined)?.error;
  return typeof refusal === 'string' ? refusal : 'invalid';
}

// RA §9.5: a row waiting for review as a new one: customers do not see it,
// and only its request changes it.
export const isNew = (pending: readonly Pending[]): boolean =>
  pending.some((each) => each.field === 'created');

// A row's pending request of one field: the forms start from it, since
// sending the published value again withdraws it.
export const pendingOf = (pending: readonly Pending[], field: Pending['field']) =>
  pending.find((each) => each.field === field) ?? null;

// The menu's currency, from its prices (the base); null before any price.
export function menuCurrency(menu: Menu): string | null {
  for (const category of menu.categories) {
    for (const item of category.items) return item.price.currency;
  }
  for (const group of menu.optionGroups) {
    for (const option of group.options) return option.priceDelta.currency;
  }
  return null;
}

// The published rows' ids in a new order after moving one up (-1) or down
// (+1); null at an end. New rows take the end once approved (RA §9.2), so
// they are never named.
export function moved(
  rows: readonly { id: string; pending: readonly Pending[] }[],
  id: string,
  step: -1 | 1,
): string[] | null {
  const ids = rows.filter((row) => !isNew(row.pending)).map((row) => row.id);
  const at = ids.indexOf(id);
  const to = at + step;
  if (at < 0 || to < 0 || to >= ids.length) return null;
  [ids[at], ids[to]] = [ids[to]!, ids[at]!];
  return ids;
}

// RA §9.6 «تعديل سريع»: every published item and its options, by name and
// category; an option shared by several items shows once, under the first.
export type QuickRow =
  | { kind: 'item'; category: MenuCategory; item: MenuItem }
  | { kind: 'option'; category: MenuCategory; item: MenuItem; option: MenuOption };

export function quickRows(menu: Menu, query: string, categoryId: string): QuickRow[] {
  const wanted = query.trim().toLowerCase();
  const matches = (name: string) => wanted === '' || name.toLowerCase().includes(wanted);
  const seen = new Set<string>();
  const rows: QuickRow[] = [];
  for (const category of menu.categories) {
    if (categoryId !== '' && category.id !== categoryId) continue;
    for (const item of category.items) {
      if (isNew(item.pending)) continue;
      if (matches(item.name)) rows.push({ kind: 'item', category, item });
      for (const group of item.optionGroups) {
        for (const option of group.options) {
          if (!seen.has(option.id) && matches(option.name)) {
            rows.push({ kind: 'option', category, item, option });
          }
          seen.add(option.id);
        }
      }
    }
  }
  return rows;
}

// A price typed in the base's major units: above 0 for an item, 0 or more
// for an option's delta (RA §9.4); null when it cannot be one.
export function priceOf(typed: string, currency: string, allowZero: boolean): string | null {
  const minor = minorOf(typed, currency);
  if (minor === null || (!allowZero && /^0+$/.test(minor))) return null;
  return minor;
}

// A time of day typed in an <input type="time"> («07:30») as minutes after
// midnight on the city's clock.
export function minuteOf(typed: string): number | null {
  const match = /^(\d{2}):(\d{2})$/.exec(typed);
  if (!match) return null;
  const hours = Number(match[1]);
  const minutes = Number(match[2]);
  if (hours > 23 || minutes > 59) return null;
  return hours * 60 + minutes;
}

// Minutes after midnight shown as «07:30» (Western digits, AP §4.7).
export function timeOfMinute(minute: number): string {
  const inDay = minute % 1440;
  return `${String(Math.floor(inDay / 60)).padStart(2, '0')}:${String(inDay % 60).padStart(2, '0')}`;
}

// A category's daily window from two typed times (RA §9.1): two different
// minutes of the day; an end not after the start crosses midnight, and
// 00:00 as the end is midnight (1440).
export function windowOf(from: string, to: string): { startsAt: number; endsAt: number } | null {
  const startsAt = minuteOf(from);
  const end = minuteOf(to);
  if (startsAt === null || end === null || startsAt === end) return null;
  return { startsAt, endsAt: end === 0 ? 1440 : end };
}

// The bulk change as typed (RA §9.4): the scope ('' for the whole menu), a
// percentage («10» or «7.5», sent in basis points) or an amount in major units.
export interface BulkForm {
  categoryId: string;
  kind: BulkBody['kind'];
  direction: BulkBody['direction'];
  value: string;
}

export function bulkBody(form: BulkForm, currency: string): BulkBody | null {
  const value =
    form.kind === 'percent' ? minorOf(form.value, currency, 2) : minorOf(form.value, currency);
  if (value === null || /^0+$/.test(value)) return null;
  return {
    categoryId: form.categoryId === '' ? null : form.categoryId,
    kind: form.kind,
    direction: form.direction,
    value,
  };
}

export type MenuAnswer = { status: 'done' } | { status: 'refused'; refusal: string };

const REFUSED = [400, 403, 404, 409, 422, 429];

export type MenuCommand =
  | { kind: 'item_price'; itemId: string; amount: string; currency: string }
  | { kind: 'option_price'; optionId: string; amount: string; currency: string }
  | { kind: 'item_hidden'; itemId: string; hidden: boolean }
  | { kind: 'category_hidden'; categoryId: string; hidden: boolean }
  | {
      kind: 'category_window';
      categoryId: string;
      window: { startsAt: number; endsAt: number } | null;
    }
  | { kind: 'category_order'; categoryIds: string[] }
  | { kind: 'item_order'; categoryId: string; itemIds: string[] }
  | { kind: 'request_category'; categoryId: string; name: string }
  | {
      kind: 'request_item';
      itemId: string;
      categoryId: string;
      name: string;
      description: string | null;
      amount: string;
      currency: string;
      uploadId: string | null;
    }
  | { kind: 'request_text'; itemId: string; name: string; description: string | null }
  | { kind: 'request_photo'; itemId: string; uploadId: string }
  | { kind: 'request_group'; groupId: string; body: GroupBody }
  | { kind: 'withdraw'; requestId: string };

function send(command: MenuCommand) {
  switch (command.kind) {
    case 'item_price':
      return api.PUT('/v1/merchant/menu/items/{itemId}/price', {
        params: { path: { itemId: command.itemId } },
        body: { price: { amount: command.amount, currency: command.currency } },
      });
    case 'option_price':
      return api.PUT('/v1/merchant/menu/options/{optionId}/price', {
        params: { path: { optionId: command.optionId } },
        body: { priceDelta: { amount: command.amount, currency: command.currency } },
      });
    case 'item_hidden':
      return api.PUT('/v1/merchant/menu/items/{itemId}/hidden', {
        params: { path: { itemId: command.itemId } },
        body: { hidden: command.hidden },
      });
    case 'category_hidden':
      return api.PUT('/v1/merchant/menu/categories/{categoryId}/hidden', {
        params: { path: { categoryId: command.categoryId } },
        body: { hidden: command.hidden },
      });
    case 'category_window':
      return api.PUT('/v1/merchant/menu/categories/{categoryId}/window', {
        params: { path: { categoryId: command.categoryId } },
        body: { window: command.window },
      });
    case 'category_order':
      return api.PUT('/v1/merchant/menu/category-order', {
        body: { categoryIds: command.categoryIds },
      });
    case 'item_order':
      return api.PUT('/v1/merchant/menu/categories/{categoryId}/item-order', {
        params: { path: { categoryId: command.categoryId } },
        body: { itemIds: command.itemIds },
      });
    case 'request_category':
      return api.PUT('/v1/merchant/menu/requests/categories/{categoryId}', {
        params: { path: { categoryId: command.categoryId } },
        body: { name: command.name },
      });
    case 'request_item':
      return api.PUT('/v1/merchant/menu/requests/items/{itemId}', {
        params: { path: { itemId: command.itemId } },
        body: {
          categoryId: command.categoryId,
          name: command.name,
          description: command.description,
          price: { amount: command.amount, currency: command.currency },
          uploadId: command.uploadId,
        },
      });
    case 'request_text':
      return api.PUT('/v1/merchant/menu/requests/items/{itemId}/text', {
        params: { path: { itemId: command.itemId } },
        body: { name: command.name, description: command.description },
      });
    case 'request_photo':
      return api.PUT('/v1/merchant/menu/requests/items/{itemId}/photo', {
        params: { path: { itemId: command.itemId } },
        body: { uploadId: command.uploadId },
      });
    case 'request_group':
      return api.PUT('/v1/merchant/menu/requests/option-groups/{groupId}', {
        params: { path: { groupId: command.groupId } },
        body: command.body,
      });
    case 'withdraw':
      return api.POST('/v1/merchant/menu/requests/{requestId}/withdraw', {
        params: { path: { requestId: command.requestId } },
      });
  }
}

// The owner's commands (RA §9.2–9.5). Each sets a value by the ids the
// portal names (a new row's id is made once by its form), so a retry changes
// nothing and none takes a key, as in the app.
export function useMenuCommand() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: async (command: MenuCommand): Promise<MenuAnswer> => {
      const result = await send(command);
      if (result.data) {
        queryClient.setQueryData(menuKey, result.data);
        if (command.kind === 'item_price' || command.kind === 'option_price') {
          void queryClient.invalidateQueries({ queryKey: priceLogQuery.queryKey });
        }
        return { status: 'done' };
      }
      if (REFUSED.includes(result.response.status)) {
        void queryClient.invalidateQueries({ queryKey: menuKey });
        return { status: 'refused', refusal: refusalOf(result.error) };
      }
      throw new Error(`The menu command failed (${result.response.status}).`);
    },
  });
}

export type Availability =
  | { type: 'category' | 'item' | 'option'; id: string; available: true }
  | {
      type: 'category' | 'item' | 'option';
      id: string;
      available: false;
      until: 'tomorrow' | 'turned_back_on';
    };

// RA §9.3: switching off asks «حتى الغد» (the default) or «حتى أعيده».
export function useAvailability() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: async (change: Availability): Promise<MenuAnswer> => {
      const { data, error, response } = await api.PUT('/v1/merchant/menu/availability', {
        body: change,
      });
      void queryClient.invalidateQueries({ queryKey: menuKey });
      if (data) return { status: 'done' };
      if (REFUSED.includes(response.status))
        return { status: 'refused', refusal: refusalOf(error) };
      throw new Error(`The availability change failed (${response.status}).`);
    },
  });
}

export function useBulkPreview() {
  return useMutation({
    mutationFn: async (
      body: BulkBody,
    ): Promise<
      { status: 'done'; preview: BulkPreview } | { status: 'refused'; refusal: string }
    > => {
      const { data, error, response } = await api.POST('/v1/merchant/menu/bulk-price/preview', {
        body,
      });
      if (data) return { status: 'done', preview: data };
      if (REFUSED.includes(response.status))
        return { status: 'refused', refusal: refusalOf(error) };
      throw new Error(`The bulk preview failed (${response.status}).`);
    },
  });
}

// One Idempotency-Key per change previewed, kept until an answer arrives,
// so a retry of a lost answer applies it once (architecture §5.3).
export function useApplyBulk() {
  const queryClient = useQueryClient();
  const keys = useRef(new Map<string, string>());
  return useMutation({
    mutationFn: async (
      body: BulkBody,
    ): Promise<{ status: 'done'; changed: number } | { status: 'refused'; refusal: string }> => {
      const id = JSON.stringify(body);
      let key = keys.current.get(id);
      if (key === undefined) {
        key = crypto.randomUUID();
        keys.current.set(id, key);
      }
      const { data, error, response } = await api.POST('/v1/merchant/menu/bulk-price', {
        params: { header: { 'Idempotency-Key': key } },
        body,
      });
      if (data) {
        keys.current.delete(id);
        void queryClient.invalidateQueries({ queryKey: menuKey });
        void queryClient.invalidateQueries({ queryKey: priceLogQuery.queryKey });
        return { status: 'done', changed: data.changed };
      }
      if (REFUSED.includes(response.status)) {
        keys.current.delete(id);
        return { status: 'refused', refusal: refusalOf(error) };
      }
      throw new Error(`The bulk change failed (${response.status}).`);
    },
  });
}

// Architecture §5.8: the server's image types and limit (files module).
export const IMAGE_TYPES = ['image/jpeg', 'image/png', 'image/webp'] as const;
export const MAX_IMAGE_BYTES = 8 * 1024 * 1024;

export function photoRefusal(file: { type: string; size: number }): 'type' | 'size' | null {
  if (!(IMAGE_TYPES as readonly string[]).includes(file.type)) return 'type';
  if (file.size === 0 || file.size > MAX_IMAGE_BYTES) return 'size';
  return null;
}

// RA §9.2: the photo goes straight to the storage on the portal's own origin
// (/public-media/incoming/, signed for it by the server, so not through the
// API client), and its request links it by the upload's id. Each chosen
// file is uploaded once: a request refused and sent again reuses its upload,
// as the app's ItemPhoto does, so retries never use up the hourly limit.
// A report's photo (RA §15, slice 2.45c) goes the same way to
// /private-docs/incoming/.
export function usePhotoUpload(purpose: 'item' | 'report' = 'item') {
  const uploads = useRef(new WeakMap<File, string>());
  const upload = useMutation({
    mutationFn: async (file: File): Promise<string | null> => {
      const done = uploads.current.get(file);
      if (done !== undefined) return done;
      const body = { contentType: file.type as (typeof IMAGE_TYPES)[number], sizeBytes: file.size };
      const asked =
        purpose === 'item'
          ? await api.POST('/v1/merchant/uploads/item-photo', { body })
          : await api.POST('/v1/merchant/uploads/report-photo', { body });
      if (!asked.data) return null;
      const put = await fetch(asked.data.url, {
        method: 'PUT',
        body: file,
        headers: { 'Content-Type': file.type },
      });
      if (!put.ok) return null;
      uploads.current.set(file, asked.data.uploadId);
      return asked.data.uploadId;
    },
  });
  // A request refused for its upload (used, expired, missing) uploads the
  // file again on the next send.
  const refused = (file: File, refusal: string) => {
    if (refusal.startsWith('upload_')) uploads.current.delete(file);
  };
  return { upload, refused };
}

// imgproxy's widths (infra/imgproxy/imgproxy.env), as the panel's media.ts.
export function mediaUrl(key: string, width: 160 | 320 | 640): string {
  return `/media/_/w${width}/plain/${key}`;
}

// The sentence of a refusal (menu.refusal.*), as the app's refusalText: an
// invalid request's fields, or an invalid price.
export function refusalKey(refusal: string, request = false): string {
  if (refusal === 'invalid_menu') return request ? 'requestInvalid' : 'invalidPrice';
  if (refusal === 'restaurant_terminated') return 'terminated';
  if (refusal === 'price_reaches_zero') return 'bulkRefused';
  if (refusal === 'request_not_pending' || refusal === 'unknown_change_request') {
    return 'requestGone';
  }
  if (refusal.startsWith('upload_') || refusal === 'too_many_uploads') return 'photoFailed';
  return 'saveFailed';
}

// The option group's form (RA §9.2): a published group starts from its
// pending values, a new one from its row (its request's values); each
// option keeps its id, a published option's delta stays as it is.
export interface GroupForm {
  name: string;
  minChoices: string;
  maxChoices: string;
  itemIds: string[];
  options: { id: string; name: string; delta: string; published: boolean }[];
}

export function groupFormOf(group: MenuGroup | null): GroupForm {
  if (group === null) {
    return { name: '', minChoices: '0', maxChoices: '1', itemIds: [], options: [] };
  }
  const rename = pendingOf(group.pending, 'rename');
  const choices = pendingOf(group.pending, 'choices');
  const items = pendingOf(group.pending, 'items');
  return {
    name: rename?.name ?? group.name,
    minChoices: String(choices?.minChoices ?? group.minChoices),
    maxChoices: String(choices?.maxChoices ?? group.maxChoices),
    itemIds: [...(items?.itemIds ?? group.itemIds)],
    options: group.options.map((option) => ({
      id: option.id,
      name: pendingOf(option.pending, 'rename')?.name ?? option.name,
      delta: decimalOf(option.priceDelta.amount, option.priceDelta.currency),
      published: !isNew(option.pending),
    })),
  };
}

export function groupBodyOf(form: GroupForm, currency: string): GroupBody | null {
  const minChoices = Number(form.minChoices);
  const maxChoices = Number(form.maxChoices);
  const name = form.name.trim();
  if (
    name === '' ||
    !Number.isInteger(minChoices) ||
    !Number.isInteger(maxChoices) ||
    minChoices < 0 ||
    maxChoices < 1 ||
    minChoices > maxChoices ||
    maxChoices > 50
  ) {
    return null;
  }
  const options: GroupBody['options'] = [];
  for (const option of form.options) {
    const amount = priceOf(option.delta, currency, true);
    if (amount === null || option.name.trim() === '') return null;
    options.push({ id: option.id, name: option.name.trim(), priceDelta: { amount, currency } });
  }
  return { name, minChoices, maxChoices, itemIds: form.itemIds, options };
}
