import type { components } from '@fox-drop/api-schema';
import { queryOptions, useMutation, useQueryClient } from '@tanstack/react-query';
import { useRef } from 'react';
import { api } from './api.js';
import { RESTAURANTS_OWNER_ACCOUNTS } from './restaurant-drafts.js';
import { RESTAURANT_STATEMENTS } from './restaurant-statements.js';
import { type AdminSession, can } from './session.js';

export type RestaurantOverview = components['schemas']['AdminRestaurantOverviewDto_Output'];
export type RestaurantOrder =
  components['schemas']['AdminRestaurantOrdersDto_Output']['orders'][number];
export type RestaurantDevice =
  components['schemas']['AdminRestaurantDevicesDto_Output']['devices'][number];
export type RestaurantNote =
  components['schemas']['AdminRestaurantNotesDto_Output']['notes'][number];
export type ChangeLogEntry =
  components['schemas']['AdminRestaurantChangeLogDto_Output']['entries'][number];

// AP §9.6.4: the profile's tabs, in its order.
export const PROFILE_TABS = [
  'overview',
  'status',
  'data',
  'location',
  'hours',
  'accounts',
  'menu',
  'orders',
  'statement',
  'ratings',
  'contract',
  'notes',
  'log',
] as const;
export type ProfileTab = (typeof PROFILE_TABS)[number];

export function isProfileTab(value: unknown): value is ProfileTab {
  return PROFILE_TABS.some((tab) => tab === value);
}

export const overviewPeriods = ['today', 'last_7_days', 'last_30_days'] as const;
export type OverviewPeriod = (typeof overviewPeriods)[number];

// «الكشف المالي» opens «كشوف المطاعم» (AP §9.10.5): OWN and FIN.
export function canOpenStatement(session: AdminSession | null | undefined): boolean {
  return can(session, RESTAURANT_STATEMENTS);
}

// RA §14.2 from the panel (AP §9.6.4): OWN and OPS.
export function canSignOutDevices(session: AdminSession | null | undefined): boolean {
  return can(session, RESTAURANTS_OWNER_ACCOUNTS);
}

export const overviewQuery = (restaurantId: string, period: OverviewPeriod) =>
  queryOptions({
    queryKey: ['restaurant-overview', restaurantId, period],
    queryFn: async (): Promise<RestaurantOverview> => {
      const { data } = await api.GET('/v1/admin/restaurants/{restaurantId}/overview', {
        params: { path: { restaurantId }, query: { period } },
      });
      if (!data) throw new Error('The overview read failed.');
      return data;
    },
  });

export const restaurantOrdersQuery = (restaurantId: string) =>
  queryOptions({
    queryKey: ['restaurant-orders', restaurantId],
    queryFn: async (): Promise<RestaurantOrder[]> => {
      const { data } = await api.GET('/v1/admin/restaurants/{restaurantId}/orders', {
        params: { path: { restaurantId } },
      });
      if (!data) throw new Error('The orders read failed.');
      return data.orders;
    },
  });

const devicesKey = (restaurantId: string) => ['restaurant-devices', restaurantId] as const;

export const devicesQuery = (restaurantId: string) =>
  queryOptions({
    queryKey: devicesKey(restaurantId),
    queryFn: async (): Promise<RestaurantDevice[]> => {
      const { data } = await api.GET('/v1/admin/restaurants/{restaurantId}/devices', {
        params: { path: { restaurantId } },
      });
      if (!data) throw new Error('The devices read failed.');
      return data.devices;
    },
  });

export type DevicesResult = { status: 'done' } | { status: 'refused'; refusal: 'no_device' };

// One device, or every device (null), signed out with the required reason.
export function useSignOutDevices(restaurantId: string) {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: async (command: {
      deviceId: string | null;
      reason: string;
    }): Promise<DevicesResult> => {
      const answer = await api.POST('/v1/admin/restaurants/{restaurantId}/devices/sign-out', {
        params: { path: { restaurantId } },
        body: command,
      });
      if (answer.data) {
        queryClient.setQueryData(devicesKey(restaurantId), answer.data.devices);
        void queryClient.invalidateQueries({ queryKey: changeLogKey(restaurantId) });
        return { status: 'done' };
      }
      if (answer.response.status === 409) return { status: 'refused', refusal: 'no_device' };
      throw new Error(`The sign-out failed (${answer.response.status}).`);
    },
  });
}

const notesKey = (restaurantId: string) => ['restaurant-notes', restaurantId] as const;

export const notesQuery = (restaurantId: string) =>
  queryOptions({
    queryKey: notesKey(restaurantId),
    queryFn: async (): Promise<RestaurantNote[]> => {
      const { data } = await api.GET('/v1/admin/restaurants/{restaurantId}/notes', {
        params: { path: { restaurantId } },
      });
      if (!data) throw new Error('The notes read failed.');
      return data.notes;
    },
  });

export const NOTE_MAX = 500;

// The note trimmed, or null when empty or too long.
export function noteOf(text: string): string | null {
  const body = text.trim();
  return body.length === 0 || body.length > NOTE_MAX ? null : body;
}

// One Idempotency-Key per body until an answer arrives (architecture §5.3).
export function useAddNote(restaurantId: string) {
  const queryClient = useQueryClient();
  const keys = useRef(new Map<string, string>());
  return useMutation({
    mutationFn: async (body: string): Promise<RestaurantNote[]> => {
      let key = keys.current.get(body);
      if (key === undefined) {
        key = crypto.randomUUID();
        keys.current.set(body, key);
      }
      const { data, response } = await api.POST('/v1/admin/restaurants/{restaurantId}/notes', {
        params: { path: { restaurantId }, header: { 'Idempotency-Key': key } },
        body: { body },
      });
      if (!data) throw new Error(`The note failed (${response.status}).`);
      keys.current.delete(body);
      return data.notes;
    },
    onSuccess: (notes) => queryClient.setQueryData(notesKey(restaurantId), notes),
  });
}

const changeLogKey = (restaurantId: string) => ['restaurant-change-log', restaurantId] as const;

export const changeLogQuery = (restaurantId: string) =>
  queryOptions({
    queryKey: changeLogKey(restaurantId),
    queryFn: async (): Promise<ChangeLogEntry[]> => {
      const { data } = await api.GET('/v1/admin/restaurants/{restaurantId}/change-log', {
        params: { path: { restaurantId } },
      });
      if (!data) throw new Error('The change log read failed.');
      return data.entries;
    },
  });

// The change log's actions by their Arabic labels; an action the panel does
// not know reads «تغيير».
export const changeActions = [
  'restaurant.create',
  'restaurant.basics',
  'restaurant.location',
  'restaurant.operations',
  'restaurant.hours',
  'restaurant.commission',
  'restaurant.contract',
  'restaurant.contract.confirm',
  'restaurant.status',
  'restaurant.visibility',
  'restaurant.sort_weight',
  'restaurant.categories',
  'restaurant.logo',
  'restaurant.cover',
  'restaurant.pause',
  'restaurant.resume',
  'restaurant.busy_mode',
  'restaurant.holiday_close',
  'restaurant.holiday_close.end',
  'restaurant.prep_time',
  'restaurant.max_active_orders',
  'restaurant.pickup_currencies',
  'restaurant.auto_pause',
  'restaurant.menu_images_waiver',
  'restaurant.note',
  'merchant_account.create',
  'merchant_account.remove',
  'merchant_devices.sign_out',
  'restaurant_fee_rule.set',
] as const;
export type ChangeAction = (typeof changeActions)[number];

export function changeActionOf(action: string): ChangeAction | null {
  return changeActions.find((each) => each === action) ?? null;
}

// The changed fields the log names; another reads «قيمة أخرى».
export const changeFields = [
  'nameAr',
  'nameEn',
  'categoryIds',
  'description',
  'latitude',
  'longitude',
  'address',
  'ownerName',
  'periods',
  'defaultPrepMin',
  'minimumOrder',
  'coverage',
  'rateBp',
  'effectiveFrom',
  'status',
  'accountStatus',
  'visible',
  'sortWeight',
  'maxActiveOrders',
  'pickupCurrencies',
  'key',
  'phoneChanged',
  'body',
  'role',
  'name',
  'signedOn',
  'durationMonths',
] as const;
export type ChangeField = (typeof changeFields)[number];

export function changeFieldOf(field: string): ChangeField | null {
  return changeFields.find((each) => each === field) ?? null;
}

const accountStatuses = ['draft', 'test', 'active', 'suspended', 'terminated'] as const;
export type AccountStatusValue = (typeof accountStatuses)[number];

// A changed value as the log shows it: a commission in percent, an account
// status by its label, a moment on the city's clock, a flag as yes or no, a
// text or a number as written; null for none, or for a list or an object.
export type ChangeValue =
  | { kind: 'text'; text: string }
  | { kind: 'percent'; bp: number }
  | { kind: 'status'; status: AccountStatusValue }
  | { kind: 'time'; at: string }
  | { kind: 'now' }
  | { kind: 'flag'; on: boolean };

export function changeValue(field: string, json: string | null): ChangeValue | null {
  if (json === null) return null;
  const value: unknown = JSON.parse(json);
  if (field === 'rateBp' && typeof value === 'number') return { kind: 'percent', bp: value };
  if ((field === 'accountStatus' || field === 'status') && typeof value === 'string') {
    const status = accountStatuses.find((each) => each === value);
    if (status) return { kind: 'status', status };
  }
  if (field === 'effectiveFrom' && value === 'now') return { kind: 'now' };
  if (field === 'effectiveFrom' && typeof value === 'string' && !Number.isNaN(Date.parse(value))) {
    return { kind: 'time', at: value };
  }
  if (typeof value === 'boolean') return { kind: 'flag', on: value };
  if (typeof value === 'string') return { kind: 'text', text: value };
  if (typeof value === 'number') return { kind: 'text', text: String(value) };
  return null;
}
