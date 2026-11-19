import type { components } from '@fox-drop/api-schema';
import { queryOptions, useMutation, useQueryClient } from '@tanstack/react-query';
import { api } from './api.js';
import { type AdminSession, can } from './session.js';

export type QueuedChange = components['schemas']['AdminChangeRequestRow_Output'];
export type ChangeView = components['schemas']['AdminChangeRequestDto_Output'];
export type ChangeValues = components['schemas']['AdminChangeValues_Output'];

// AP §6.2: OWN and OPS review the restaurants' menu change requests.
export const MENU_REVIEW = 'menus.review_change_requests';

export function canReviewMenuChanges(session: AdminSession | null | undefined): boolean {
  return can(session, MENU_REVIEW);
}

// AP §9.6.7 «طلبات تعديل القائمة»: the city's pending requests, oldest first.
export const menuChangesQuery = (cityId: string) =>
  queryOptions({
    queryKey: ['menu-change-requests', cityId] as const,
    queryFn: async (): Promise<QueuedChange[]> => {
      const { data } = await api.GET('/v1/admin/menu-change-requests', {
        params: { query: { cityId } },
      });
      if (!data) throw new Error('The menu change requests read failed.');
      return data.requests;
    },
  });

export const menuChangeQuery = (requestId: string) =>
  queryOptions({
    queryKey: ['menu-change-request', requestId] as const,
    queryFn: async (): Promise<ChangeView> => {
      const { data } = await api.GET('/v1/admin/menu-change-requests/{requestId}', {
        params: { path: { requestId } },
      });
      if (!data) throw new Error('The menu change request read failed.');
      return data;
    },
  });

// The kind of change by its target and field; a pair the panel does not
// know has no label (never shown in English).
const kindKeys = {
  'category.created': 'menuChanges.kind.category.created',
  'category.name': 'menuChanges.kind.category.name',
  'item.created': 'menuChanges.kind.item.created',
  'item.name': 'menuChanges.kind.item.name',
  'item.description': 'menuChanges.kind.item.description',
  'item.photo': 'menuChanges.kind.item.photo',
  'option_group.created': 'menuChanges.kind.option_group.created',
  'option_group.name': 'menuChanges.kind.option_group.name',
  'option_group.choices': 'menuChanges.kind.option_group.choices',
  'option_group.items': 'menuChanges.kind.option_group.items',
  'option.created': 'menuChanges.kind.option.created',
  'option.name': 'menuChanges.kind.option.name',
} as const;

export type KindKey = (typeof kindKeys)[keyof typeof kindKeys];

export function changeKind(change: Pick<QueuedChange, 'targetType' | 'field'>): KindKey | null {
  return (kindKeys as Record<string, KindKey>)[`${change.targetType}.${change.field}`] ?? null;
}

// RA §9.5: SHOULD be reviewed within 24 hours, so the age is in whole hours.
export function ageHours(createdAt: string, now: Date): number {
  return Math.max(0, Math.floor((now.getTime() - new Date(createdAt).getTime()) / 3_600_000));
}

export const REVIEW_HOURS = 24;

// What the reviewer may correct before approving (RA §9.5): the name of a
// new row or a rename, the description of a new item or a description.
export function correctable(change: Pick<QueuedChange, 'targetType' | 'field'>): {
  name: boolean;
  description: boolean;
} {
  return {
    name: change.field === 'created' || change.field === 'name',
    description:
      change.field === 'description' ||
      (change.field === 'created' && change.targetType === 'item'),
  };
}

// The item as customers will see it once approved: today's item with the
// asked values, the reviewer's correction last. A new item has no today.
export function itemAfter(
  view: ChangeView,
  correction: { name: string; description: string },
): {
  name: string;
  description: string | null;
  photoKey: string | null;
  price: ChangeValues['price'];
} | null {
  if (view.targetType !== 'item') return null;
  const fix = correctable(view);
  const base = view.item;
  const after = view.after;
  const name =
    fix.name && correction.name.trim() !== ''
      ? correction.name.trim()
      : view.field === 'created' || view.field === 'name'
        ? after.name
        : (base?.name ?? null);
  const description = fix.description
    ? correction.description.trim() !== ''
      ? correction.description.trim()
      : after.description
    : (base?.description ?? null);
  return {
    name: name ?? '',
    description,
    photoKey:
      view.field === 'photo' || view.field === 'created'
        ? after.photoKey
        : (base?.photoKey ?? null),
    price: view.field === 'created' ? after.price : (base?.price ?? null),
  };
}

export type DecideRefusal =
  | 'request_not_pending'
  | 'unknown_change_request'
  | 'category_pending'
  | 'group_pending'
  | 'invalid_menu'
  | 'restaurant_terminated';

const refusals: readonly string[] = [
  'request_not_pending',
  'unknown_change_request',
  'category_pending',
  'group_pending',
  'invalid_menu',
  'restaurant_terminated',
] satisfies DecideRefusal[];

export type Decision =
  | { kind: 'approve'; name?: string; description?: string | null }
  | { kind: 'reject'; reason: string };

export type DecideResult = { status: 'done' } | { status: 'refused'; refusal: DecideRefusal };

// RA §9.5 «Approve» (a text corrected first) or «Reject» (a reason). A
// repeat is refused as decided, so it needs no key.
export function useDecideMenuChange(requestId: string) {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: async (decision: Decision): Promise<DecideResult> => {
      const path = { params: { path: { requestId } } };
      const { data, error, response } =
        decision.kind === 'approve'
          ? await api.POST('/v1/admin/menu-change-requests/{requestId}/approve', {
              ...path,
              body: {
                ...(decision.name === undefined ? {} : { name: decision.name }),
                ...(decision.description === undefined
                  ? {}
                  : { description: decision.description }),
              },
            })
          : await api.POST('/v1/admin/menu-change-requests/{requestId}/reject', {
              ...path,
              body: { reason: decision.reason },
            });
      if (data) return { status: 'done' };
      const refusal = (error as { error?: unknown } | undefined)?.error;
      if (typeof refusal === 'string' && refusals.includes(refusal)) {
        return { status: 'refused', refusal: refusal as DecideRefusal };
      }
      throw new Error(`The decision failed with ${response.status}.`);
    },
    onSettled: () =>
      Promise.all([
        queryClient.invalidateQueries({ queryKey: ['menu-change-requests'] }),
        queryClient.invalidateQueries({ queryKey: ['menu-change-request', requestId] }),
        queryClient.invalidateQueries({ queryKey: ['restaurant-menu-preview'] }),
      ]),
  });
}

// The correction sent: only what the reviewer typed and the request asks.
export function approvalOf(
  change: Pick<QueuedChange, 'targetType' | 'field'>,
  form: { name: string; description: string },
): Decision {
  const fix = correctable(change);
  const name = form.name.trim();
  const description = form.description.trim();
  return {
    kind: 'approve',
    ...(fix.name && name !== '' ? { name } : {}),
    ...(fix.description && description !== '' ? { description } : {}),
  };
}
