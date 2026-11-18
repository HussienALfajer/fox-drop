import { queryOptions, useMutation, useQueryClient } from '@tanstack/react-query';
import type { components } from '@fox-drop/api-schema';
import { api } from './api.js';
import { type AdminSession, can } from './session.js';

// The wizard's step 8 «المراجعة والتفعيل» (AP §9.6.3; slice 2.30b): the
// checklist, OWN's waiver of the image rule, test mode and the activation.
export const RESTAURANTS_ACTIVATE = 'restaurants.activate';
export const WAIVE_MENU_IMAGES = 'restaurants.waive_menu_images';

export function canActivate(session: AdminSession | null | undefined): boolean {
  return can(session, RESTAURANTS_ACTIVATE);
}

export function canWaiveImages(session: AdminSession | null | undefined): boolean {
  return can(session, WAIVE_MENU_IMAGES);
}

export type Checklist = components['schemas']['AdminChecklistDto_Output'];
export type ChecklistCode = Checklist['items'][number]['code'];
export type ChecklistState = Checklist['items'][number]['state'];

// The labels' keys, checked against the API's enums.
export const CHECKLIST_CODES = [
  'record',
  'commission',
  'contract',
  'hours',
  'menu',
  'menu_images',
  'owner_account',
  'device_check',
  'test_order',
] as const satisfies readonly ChecklistCode[];

export const CHECKLIST_STATES = [
  'met',
  'missing',
  'waived',
  'not_available',
] as const satisfies readonly ChecklistState[];

const checklistKey = (restaurantId: string) => ['restaurant-checklist', restaurantId] as const;

export const checklistQuery = (restaurantId: string) =>
  queryOptions({
    queryKey: checklistKey(restaurantId),
    queryFn: async (): Promise<Checklist | null> => {
      const { data, response } = await api.GET(
        '/v1/admin/restaurant-drafts/{restaurantId}/checklist',
        { params: { path: { restaurantId } } },
      );
      if (response.status === 404) return null;
      if (!data) throw new Error('The checklist read failed.');
      return data;
    },
  });

// Step 7 is done once the menu item of the checklist is met; step 8 once the
// restaurant is active.
export function menuDone(checklist: Checklist | null | undefined): boolean {
  return checklist?.items.some((item) => item.code === 'menu' && item.state === 'met') ?? false;
}

export function activationDone(checklist: Checklist | null | undefined): boolean {
  return checklist?.accountStatus === 'active';
}

export type ActivationCommand =
  { kind: 'waiver'; waived: boolean } | { kind: 'test' } | { kind: 'activate' };

export type ActivationResult =
  { status: 'saved'; checklist: Checklist } | { status: 'refused'; refusal: string };

export function useActivationCommand(restaurantId: string) {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: async (command: ActivationCommand): Promise<ActivationResult> => {
      const path = { restaurantId };
      const answer =
        command.kind === 'waiver'
          ? await api.PUT('/v1/admin/restaurant-drafts/{restaurantId}/menu-images-waiver', {
              params: { path },
              body: { waived: command.waived },
            })
          : command.kind === 'test'
            ? await api.POST('/v1/admin/restaurant-drafts/{restaurantId}/test-mode', {
                params: { path },
              })
            : await api.POST('/v1/admin/restaurant-drafts/{restaurantId}/activate', {
                params: { path },
              });
      if (answer.data) return { status: 'saved', checklist: answer.data };
      const status = answer.response.status;
      if (status === 404 || status === 409) {
        const refusal = (answer.error as { error?: unknown } | undefined)?.error;
        return { status: 'refused', refusal: typeof refusal === 'string' ? refusal : 'invalid' };
      }
      throw new Error(`The activation command failed (${status}).`);
    },
    onSuccess: (result) => {
      if (result.status !== 'saved') return;
      queryClient.setQueryData(checklistKey(restaurantId), result.checklist);
      // The status moved: the draft, its menu and the list read again.
      void queryClient.invalidateQueries({ queryKey: ['restaurant-draft', restaurantId] });
      void queryClient.invalidateQueries({ queryKey: ['restaurant-menu', restaurantId] });
      void queryClient.invalidateQueries({ queryKey: ['restaurant-drafts'] });
    },
  });
}
