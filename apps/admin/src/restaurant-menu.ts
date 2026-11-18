import { queryOptions, useMutation, useQueryClient } from '@tanstack/react-query';
import type { components } from '@fox-drop/api-schema';
import { api } from './api.js';
import { decimalOf, minorOf } from './format.js';
import { minuteOf, timeOf } from './peak-bonus.js';
import { type AdminSession, can } from './session.js';

// The wizard's step 7 «القائمة» (AP §9.6.3, §9.6.6; slice 2.30b): the basic
// menu of a draft or a restaurant in test mode. The server checks everything.
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

export const BADGES = ['new', 'most_ordered', 'spicy'] as const satisfies readonly Badge[];

const menuKey = (restaurantId: string) => ['restaurant-menu', restaurantId] as const;

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
  | { kind: 'availability'; type: 'category' | 'item'; id: string; available: boolean };

export type MenuResult = { status: 'saved'; menu: Menu } | { status: 'refused'; refusal: string };

type Answer = { data?: Menu; error?: unknown; response: Response };

function outcome(answer: Answer): MenuResult {
  if (answer.data) return { status: 'saved', menu: answer.data };
  const status = answer.response.status;
  if (status === 400 || status === 404 || status === 409) {
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
    },
  });
}
