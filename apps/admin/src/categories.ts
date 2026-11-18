import { queryOptions, useMutation, useQueryClient } from '@tanstack/react-query';
import type { components } from '@fox-drop/api-schema';
import { api } from './api.js';
import { CONTENT_READ } from './content.js';
import { RESTAURANTS_CREATE, RESTAURANTS_MANAGE, RESTAURANTS_READ } from './restaurant-images.js';
import { type AdminSession, can } from './session.js';

// AP §6.2, §9.13 «التصنيفات»: OWN and DATA edit them (content.categories),
// OPS reads them (content.read).
export const CONTENT_CATEGORIES = 'content.categories';

export function canSeeCategories(session: AdminSession | null | undefined): boolean {
  return can(session, CONTENT_READ) || can(session, CONTENT_CATEGORIES);
}

export function canEditCategories(session: AdminSession | null | undefined): boolean {
  return can(session, CONTENT_CATEGORIES);
}

// A restaurant's categories (AP §9.6.3 step 1): read with the restaurants,
// set by those who manage restaurants or add them (OWN, OPS, DATA). The
// page names them from «التصنيفات», so it also needs that read (SUP has
// neither content.read nor content.categories).
export function canSeeRestaurantCategories(session: AdminSession | null | undefined): boolean {
  return (
    canSeeCategories(session) &&
    (can(session, RESTAURANTS_READ) ||
      can(session, RESTAURANTS_MANAGE) ||
      can(session, RESTAURANTS_CREATE))
  );
}

export function canSetRestaurantCategories(session: AdminSession | null | undefined): boolean {
  return can(session, RESTAURANTS_MANAGE) || can(session, RESTAURANTS_CREATE);
}

// AP §9.13: how many categories one restaurant links to, as the server
// allows (RESTAURANT_CATEGORIES_MAX).
export const RESTAURANT_CATEGORIES_MAX = 5;

export type Category = components['schemas']['AdminCategoryDto_Output'];

// The refusals the pages explain; anything else is a thrown error.
export type CategoryRefusal =
  'duplicate_label' | 'invalid_order' | 'invalid_value' | 'unknown_category';
const refusals: readonly string[] = [
  'duplicate_label',
  'invalid_order',
  'invalid_value',
  'unknown_category',
] satisfies CategoryRefusal[];

export type CategoryResult = { status: 'saved' } | { status: 'refused'; refusal: CategoryRefusal };

function refused(error: unknown, status: number): CategoryResult {
  const refusal = (error as { error?: unknown } | undefined)?.error;
  if (status === 400 && typeof refusal === 'string' && refusals.includes(refusal)) {
    return { status: 'refused', refusal: refusal as CategoryRefusal };
  }
  throw new Error(`category edit failed with ${status}`);
}

export const CATEGORIES_KEY = ['content', 'categories'] as const;

// Every category in its order, removed ones included.
export const categoriesQuery = queryOptions({
  queryKey: CATEGORIES_KEY,
  queryFn: async (): Promise<Category[]> => {
    const { data } = await api.GET('/v1/admin/content/categories');
    if (!data) throw new Error('The categories read failed.');
    return data.categories;
  },
});

function useCategoryEdit<Input>(
  key: readonly string[],
  run: (input: Input) => Promise<CategoryResult>,
) {
  const client = useQueryClient();
  return useMutation({
    mutationFn: run,
    onSuccess: (result) => {
      if (result.status === 'saved') void client.invalidateQueries({ queryKey: key });
    },
  });
}

export function useAddCategory() {
  return useCategoryEdit(CATEGORIES_KEY, async (name: string) => {
    const { data, error, response } = await api.POST('/v1/admin/content/categories', {
      body: { name: name.trim() },
    });
    return data ? { status: 'saved' } : refused(error, response.status);
  });
}

export function useUpdateCategory() {
  return useCategoryEdit(
    CATEGORIES_KEY,
    async (input: { categoryId: string; name: string; active: boolean }) => {
      const { data, error, response } = await api.PUT('/v1/admin/content/categories/{categoryId}', {
        params: { path: { categoryId: input.categoryId } },
        body: { name: input.name.trim(), active: input.active },
      });
      return data ? { status: 'saved' } : refused(error, response.status);
    },
  );
}

export function useReorderCategories() {
  return useCategoryEdit(CATEGORIES_KEY, async (ids: string[]) => {
    const { data, error, response } = await api.POST('/v1/admin/content/categories/order', {
      body: { ids },
    });
    return data ? { status: 'saved' } : refused(error, response.status);
  });
}

export const restaurantCategoriesQuery = (restaurantId: string) =>
  queryOptions({
    queryKey: ['restaurant-categories', restaurantId],
    queryFn: async (): Promise<string[]> => {
      const { data } = await api.GET('/v1/admin/restaurants/{restaurantId}/categories', {
        params: { path: { restaurantId } },
      });
      if (!data) throw new Error('The restaurant categories read failed.');
      return data.categoryIds;
    },
  });

// A restaurant's choice, ticked or not, in the platform's order: a removed
// category it still has is dropped once the choice is saved (the server
// links active ones only).
export function chosenCategories(order: Category[], chosen: string[], id: string, on: boolean) {
  const next = new Set(chosen);
  if (on) next.add(id);
  else next.delete(id);
  return order.filter((category) => category.active && next.has(category.id)).map((c) => c.id);
}

export function useSetRestaurantCategories(restaurantId: string) {
  return useCategoryEdit(['restaurant-categories', restaurantId], async (categoryIds: string[]) => {
    const { data, error, response } = await api.PUT(
      '/v1/admin/restaurants/{restaurantId}/categories',
      { params: { path: { restaurantId } }, body: { categoryIds } },
    );
    return data ? { status: 'saved' } : refused(error, response.status);
  });
}
