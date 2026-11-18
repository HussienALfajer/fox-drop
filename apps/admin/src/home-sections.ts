import type { components } from '@fox-drop/api-schema';
import { queryOptions, useMutation, useQueryClient } from '@tanstack/react-query';
import { api } from './api.js';
import { type AdminSession, can } from './session.js';

// AP §6, §9.11.3 «أقسام الرئيسية» (owner decision 2026-11-18): OWN changes
// them (marketing.manage), OPS reads them (marketing.read).
export function canSeeHomeSections(session: AdminSession | null | undefined): boolean {
  return can(session, 'marketing.read') || can(session, 'marketing.manage');
}

export type HomeSections = components['schemas']['AdminHomeSectionsDto_Output'];
export type HomeSection = HomeSections['sections'][number];
export type HomeSectionKind = HomeSection['kind'];

// The bounds the server checks (SECTION_TITLE_MAX, SECTION_RESTAURANTS_MAX).
export const SECTION_TITLE_MAX = 40;
export const SECTION_RESTAURANTS_MAX = 30;

// The refusals the page explains; anything else is a thrown error.
export type HomeSectionRefusal = 'invalid_section' | 'sections_changed' | 'unknown_section';
const refusals: readonly string[] = [
  'invalid_section',
  'sections_changed',
  'unknown_section',
] satisfies HomeSectionRefusal[];

export type HomeSectionResult =
  { status: 'saved' } | { status: 'refused'; refusal: HomeSectionRefusal };

function refused(error: unknown, status: number): HomeSectionResult {
  const refusal = (error as { error?: unknown } | undefined)?.error;
  if (
    [400, 404, 409].includes(status) &&
    typeof refusal === 'string' &&
    refusals.includes(refusal)
  ) {
    return { status: 'refused', refusal: refusal as HomeSectionRefusal };
  }
  throw new Error(`home section edit failed with ${status}`);
}

const sectionsKey = (cityId: string) => ['home-sections', cityId] as const;

export const homeSectionsQuery = (cityId: string) =>
  queryOptions({
    queryKey: sectionsKey(cityId),
    queryFn: async (): Promise<HomeSections> => {
      const { data } = await api.GET('/v1/admin/home-sections', {
        params: { query: { cityId } },
      });
      if (!data) throw new Error('The home sections read failed.');
      return data;
    },
  });

// Every command answers the city's sections, which replace the read.
function useSectionEdit<Input>(
  cityId: string,
  run: (
    input: Input,
  ) => Promise<{ data: HomeSections | undefined; error: unknown; status: number }>,
) {
  const client = useQueryClient();
  return useMutation({
    mutationFn: async (input: Input): Promise<HomeSectionResult> => {
      const { data, error, status } = await run(input);
      if (!data) return refused(error, status);
      client.setQueryData(sectionsKey(cityId), data);
      return { status: 'saved' };
    },
  });
}

export function useReorderSections(cityId: string) {
  return useSectionEdit(cityId, async (keys: string[]) => {
    const { data, error, response } = await api.POST('/v1/admin/home-sections/order', {
      body: { cityId, keys },
    });
    return { data, error, status: response.status };
  });
}

export function useSetSectionVisible(cityId: string) {
  return useSectionEdit(cityId, async (input: { key: string; visible: boolean }) => {
    const { data, error, response } = await api.POST('/v1/admin/home-sections/visibility', {
      body: { cityId, ...input },
    });
    return { data, error, status: response.status };
  });
}

export interface CustomSectionForm {
  title: string;
  restaurantIds: string[];
}

// The form's problem before sending, or null: a title of 1 to 40
// characters and 1 to 30 restaurants (the server checks the same).
export function customSectionProblem(form: CustomSectionForm): 'title' | 'restaurants' | null {
  const title = form.title.trim();
  if (title.length === 0 || [...title].length > SECTION_TITLE_MAX) return 'title';
  if (form.restaurantIds.length === 0 || form.restaurantIds.length > SECTION_RESTAURANTS_MAX) {
    return 'restaurants';
  }
  return null;
}

export function useAddCustomSection(cityId: string) {
  return useSectionEdit(cityId, async (form: CustomSectionForm) => {
    const { data, error, response } = await api.POST('/v1/admin/home-sections', {
      body: { cityId, title: form.title.trim(), restaurantIds: form.restaurantIds },
    });
    return { data, error, status: response.status };
  });
}

export function useUpdateCustomSection(cityId: string) {
  return useSectionEdit(cityId, async (input: CustomSectionForm & { sectionId: string }) => {
    const { data, error, response } = await api.PUT('/v1/admin/home-sections/{sectionId}', {
      params: { path: { sectionId: input.sectionId } },
      body: { cityId, title: input.title.trim(), restaurantIds: input.restaurantIds },
    });
    return { data, error, status: response.status };
  });
}

export function useRemoveCustomSection(cityId: string) {
  return useSectionEdit(cityId, async (sectionId: string) => {
    const { data, error, response } = await api.POST('/v1/admin/home-sections/{sectionId}/remove', {
      params: { path: { sectionId } },
      body: { cityId },
    });
    return { data, error, status: response.status };
  });
}

// The list with one entry moved a step towards the start (-1) or the end
// (+1); unchanged at an edge.
export function movedKey<T>(list: readonly T[], item: T, step: -1 | 1): T[] {
  const from = list.indexOf(item);
  const to = from + step;
  if (from < 0 || to < 0 || to >= list.length) return [...list];
  const next = [...list];
  next.splice(from, 1);
  next.splice(to, 0, item);
  return next;
}

// A restaurant ticked or not, kept in the order it was picked (a new one
// at the end): the custom section's order on the home.
export function pickedRestaurants(picked: readonly string[], id: string, on: boolean): string[] {
  if (on) return picked.includes(id) ? [...picked] : [...picked, id];
  return picked.filter((each) => each !== id);
}
