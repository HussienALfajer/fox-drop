import { queryOptions, useMutation, useQueryClient } from '@tanstack/react-query';
import type { components } from '@fox-drop/api-schema';
import { api } from './api.js';
import { decimalOf, minorOf } from './format.js';
import { minuteOf, timeOf } from './peak-bonus.js';
import { type AdminSession, can } from './session.js';

// The menu editor «القائمة» (AP §9.6.3, §9.6.6): the wizard's step 7 (slice
// 2.30b) and the profile's tab past it (slice 2.31), with the option groups.
// Past test mode a price needs `menus.edit_prices` (the menu's
// `pricesLocked`). The server checks everything.
export const RESTAURANTS_MENUS = 'restaurants.menus';

export function canEditMenu(session: AdminSession | null | undefined): boolean {
  return can(session, RESTAURANTS_MENUS);
}

export type Menu = components['schemas']['AdminMenuDto_Output'];
export type MenuCategory = Menu['categories'][number];
export type MenuItem = MenuCategory['items'][number];
type CategoryBody = components['schemas']['AdminMenuCategoryDto'];
type ItemBody = components['schemas']['AdminMenuItemDto'];
export type Badge = NonNullable<MenuItem['badge']>;
export type OptionGroup = Menu['optionGroups'][number];
export type GroupOption = OptionGroup['options'][number];
type GroupBody = components['schemas']['AdminMenuOptionGroupDto'];
type OptionBody = components['schemas']['AdminMenuOptionDto'];

export const BADGES = ['new', 'most_ordered', 'spicy'] as const satisfies readonly Badge[];

export const menuKey = (restaurantId: string) => ['restaurant-menu', restaurantId] as const;

export const menuQuery = (restaurantId: string) =>
  queryOptions({
    queryKey: menuKey(restaurantId),
    queryFn: async (): Promise<Menu> => {
      const { data } = await api.GET('/v1/admin/restaurant-drafts/{restaurantId}/menu', {
        params: { path: { restaurantId } },
      });
      if (!data) throw new Error('The menu read failed.');
      return data;
    },
  });

// A category as typed: the daily window as two `HH:MM` (CU §9.3), such as
// breakfast from 06:00 to 12:00; an end at or before the start crosses
// midnight, 00:00 as the end is midnight.
export interface CategoryForm {
  name: string;
  hidden: boolean;
  windowOn: boolean;
  from: string;
  to: string;
}

export function categoryFormOf(category: MenuCategory | null): CategoryForm {
  return {
    name: category?.name ?? '',
    hidden: category?.hidden ?? false,
    windowOn: category?.window != null,
    from: category?.window ? timeOf(category.window.startsAt) : '',
    to: category?.window ? timeOf(category.window.endsAt % 1440) : '',
  };
}

export type CategoryProblem = 'name' | 'window';

export function categoryBody(
  form: CategoryForm,
  nameMax: number,
): CategoryBody | { problem: CategoryProblem } {
  const name = form.name.trim();
  if (name === '' || name.length > nameMax) return { problem: 'name' };
  if (!form.windowOn) return { name, hidden: form.hidden, window: null };
  const startsAt = minuteOf(form.from);
  const to = minuteOf(form.to);
  if (startsAt === null || to === null || startsAt === to) return { problem: 'window' };
  return { name, hidden: form.hidden, window: { startsAt, endsAt: to === 0 ? 1440 : to } };
}

// An item as typed: the price in the base currency's major units.
export interface ItemForm {
  categoryId: string;
  code: string;
  name: string;
  description: string;
  price: string;
  hidden: boolean;
  badge: Badge | '';
}

export function itemFormOf(item: MenuItem | null, categoryId: string): ItemForm {
  return {
    categoryId,
    code: item?.code ?? '',
    name: item?.name ?? '',
    description: item?.description ?? '',
    price: item ? decimalOf(item.price.amount, item.price.currency) : '',
    hidden: item?.hidden ?? false,
    badge: item?.badge ?? '',
  };
}

export type ItemProblem = 'item_name' | 'description' | 'code' | 'price';

export function itemBody(
  form: ItemForm,
  currency: string,
  menu: Pick<Menu, 'nameMax' | 'descriptionMax' | 'codeMax'>,
): ItemBody | { problem: ItemProblem } {
  const name = form.name.trim();
  if (name === '' || name.length > menu.nameMax) return { problem: 'item_name' };
  const description = form.description.trim();
  if (description.length > menu.descriptionMax) return { problem: 'description' };
  const code = form.code.trim();
  if (code.length > menu.codeMax) return { problem: 'code' };
  const amount = minorOf(form.price, currency);
  if (amount === null || /^0+$/.test(amount)) return { problem: 'price' };
  return {
    categoryId: form.categoryId,
    code: code === '' ? null : code,
    name,
    description: description === '' ? null : description,
    price: { amount, currency },
    hidden: form.hidden,
    badge: form.badge === '' ? null : form.badge,
  };
}

// AP §9.6.6 «مجموعات الخيارات»: a group as typed. A minimum of 0 makes it an
// add-on group («إضافات»), 1 or more a required one.
export interface GroupForm {
  name: string;
  minChoices: string;
  maxChoices: string;
}

export function groupFormOf(group: OptionGroup | null): GroupForm {
  return {
    name: group?.name ?? '',
    minChoices: String(group?.minChoices ?? 0),
    maxChoices: String(group?.maxChoices ?? 1),
  };
}

export type GroupProblem = 'group_name' | 'choices';

export function groupBody(form: GroupForm, nameMax: number): GroupBody | { problem: GroupProblem } {
  const name = form.name.trim();
  if (name === '' || name.length > nameMax) return { problem: 'group_name' };
  const whole = (typed: string) => (/^\d{1,2}$/.test(typed.trim()) ? Number(typed) : null);
  const minChoices = whole(form.minChoices);
  const maxChoices = whole(form.maxChoices);
  if (minChoices === null || maxChoices === null || maxChoices < 1 || maxChoices < minChoices) {
    return { problem: 'choices' };
  }
  return { name, minChoices, maxChoices };
}

// An option as typed: its price delta in the base's major units, 0 for free.
export interface OptionForm {
  name: string;
  delta: string;
}

export function optionFormOf(option: GroupOption | null): OptionForm {
  return {
    name: option?.name ?? '',
    delta: option ? decimalOf(option.priceDelta.amount, option.priceDelta.currency) : '0',
  };
}

export type OptionProblem = 'option_name' | 'delta';

export function optionBody(
  form: OptionForm,
  currency: string,
  nameMax: number,
  removed = false,
): OptionBody | { problem: OptionProblem } {
  const name = form.name.trim();
  if (name === '' || name.length > nameMax) return { problem: 'option_name' };
  const amount = minorOf(form.delta, currency);
  if (amount === null) return { problem: 'delta' };
  return { name, priceDelta: { amount, currency }, removed };
}

// An item's groups as a set chosen in the item's form, in the order they
// were ticked (the item's order for the customer).
export function toggled(ids: readonly string[], id: string, on: boolean): string[] {
  const without = ids.filter((each) => each !== id);
  return on ? [...without, id] : without;
}

// One place up or down; the list as it was at the ends.
export function moved(ids: readonly string[], id: string, step: -1 | 1): string[] {
  const from = ids.indexOf(id);
  const to = from + step;
  if (from < 0 || to < 0 || to >= ids.length) return [...ids];
  const next = [...ids];
  next.splice(from, 1);
  next.splice(to, 0, id);
  return next;
}

export type MenuCommand =
  | { kind: 'category'; id: string; body: CategoryBody }
  | { kind: 'item'; id: string; body: ItemBody }
  | { kind: 'categoryOrder'; categoryIds: string[] }
  | { kind: 'itemOrder'; categoryId: string; itemIds: string[] }
  | { kind: 'availability'; type: 'category' | 'item' | 'option'; id: string; available: boolean }
  | { kind: 'group'; id: string; body: GroupBody }
  | { kind: 'option'; groupId: string; id: string; body: OptionBody }
  | { kind: 'optionOrder'; groupId: string; optionIds: string[] }
  | { kind: 'groupItems'; groupId: string; itemIds: string[] }
  | { kind: 'itemGroups'; itemId: string; groupIds: string[] }
  | {
      kind: 'bulkAvailability';
      itemIds: string[];
      available: boolean;
      until?: 'tomorrow' | 'turned_back_on';
    };

export type MenuResult = { status: 'saved'; menu: Menu } | { status: 'refused'; refusal: string };

type Answer = { data?: Menu; error?: unknown; response: Response };

function outcome(answer: Answer): MenuResult {
  if (answer.data) return { status: 'saved', menu: answer.data };
  const status = answer.response.status;
  if (status === 400 || status === 403 || status === 404 || status === 409) {
    const refusal = (answer.error as { error?: unknown } | undefined)?.error;
    return { status: 'refused', refusal: typeof refusal === 'string' ? refusal : 'invalid' };
  }
  throw new Error(`The menu command failed (${status}).`);
}

async function run(restaurantId: string, command: MenuCommand): Promise<MenuResult> {
  switch (command.kind) {
    case 'category':
      return outcome(
        await api.PUT('/v1/admin/restaurant-drafts/{restaurantId}/menu/categories/{categoryId}', {
          params: { path: { restaurantId, categoryId: command.id } },
          body: command.body,
        }),
      );
    case 'item':
      return outcome(
        await api.PUT('/v1/admin/restaurant-drafts/{restaurantId}/menu/items/{itemId}', {
          params: { path: { restaurantId, itemId: command.id } },
          body: command.body,
        }),
      );
    case 'categoryOrder':
      return outcome(
        await api.PUT('/v1/admin/restaurant-drafts/{restaurantId}/menu/category-order', {
          params: { path: { restaurantId } },
          body: { categoryIds: command.categoryIds },
        }),
      );
    case 'itemOrder':
      return outcome(
        await api.PUT(
          '/v1/admin/restaurant-drafts/{restaurantId}/menu/categories/{categoryId}/item-order',
          {
            params: { path: { restaurantId, categoryId: command.categoryId } },
            body: { itemIds: command.itemIds },
          },
        ),
      );
    case 'availability':
      return outcome(
        await api.PUT('/v1/admin/restaurant-drafts/{restaurantId}/menu/availability', {
          params: { path: { restaurantId } },
          body: { type: command.type, id: command.id, available: command.available },
        }),
      );
    case 'group':
      return outcome(
        await api.PUT('/v1/admin/restaurant-drafts/{restaurantId}/menu/option-groups/{groupId}', {
          params: { path: { restaurantId, groupId: command.id } },
          body: command.body,
        }),
      );
    case 'option':
      return outcome(
        await api.PUT(
          '/v1/admin/restaurant-drafts/{restaurantId}/menu/option-groups/{groupId}/options/{optionId}',
          {
            params: { path: { restaurantId, groupId: command.groupId, optionId: command.id } },
            body: command.body,
          },
        ),
      );
    case 'optionOrder':
      return outcome(
        await api.PUT(
          '/v1/admin/restaurant-drafts/{restaurantId}/menu/option-groups/{groupId}/option-order',
          {
            params: { path: { restaurantId, groupId: command.groupId } },
            body: { optionIds: command.optionIds },
          },
        ),
      );
    case 'groupItems':
      return outcome(
        await api.PUT(
          '/v1/admin/restaurant-drafts/{restaurantId}/menu/option-groups/{groupId}/items',
          {
            params: { path: { restaurantId, groupId: command.groupId } },
            body: { itemIds: command.itemIds },
          },
        ),
      );
    case 'itemGroups':
      return outcome(
        await api.PUT(
          '/v1/admin/restaurant-drafts/{restaurantId}/menu/items/{itemId}/option-groups',
          {
            params: { path: { restaurantId, itemId: command.itemId } },
            body: { groupIds: command.groupIds },
          },
        ),
      );
    case 'bulkAvailability':
      return outcome(
        await api.PUT('/v1/admin/restaurant-drafts/{restaurantId}/menu/bulk-availability', {
          params: { path: { restaurantId } },
          body: {
            itemIds: command.itemIds,
            available: command.available,
            ...(command.until ? { until: command.until } : {}),
          },
        }),
      );
  }
}

// Every command answers the menu, which replaces the read; the checklist of
// step 8 is read again.
export function useMenuCommand(restaurantId: string) {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (command: MenuCommand) => run(restaurantId, command),
    onSuccess: (result) => {
      if (result.status !== 'saved') return;
      queryClient.setQueryData(menuKey(restaurantId), result.menu);
      void queryClient.invalidateQueries({ queryKey: ['restaurant-checklist', restaurantId] });
      void queryClient.invalidateQueries({ queryKey: ['restaurant-price-log', restaurantId] });
    },
  });
}
