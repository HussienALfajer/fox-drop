import type { components } from '@fox-drop/api-schema';
import { queryOptions, useMutation, useQueryClient } from '@tanstack/react-query';
import { api } from './api.js';

export type Staff = components['schemas']['MerchantStaffDto_Output'];
export type StaffMember = Staff['staff'][number];
export type Devices = components['schemas']['MerchantDevicesDto_Output'];
export type Device = Devices['devices'][number];
export type PortalSessions = components['schemas']['MerchantPortalSessionsDto_Output'];
export type Pairing = components['schemas']['MerchantWindowsPairingDto_Output'];

// RA §14.1, §17 (slice 2.45c): «الموظفون», the owners'.
export const staffQuery = queryOptions({
  queryKey: ['staff'],
  queryFn: async (): Promise<Staff> => {
    const { data, response } = await api.GET('/v1/merchant/staff');
    if (!data) throw new Error(`The staff read failed (${response.status}).`);
    return data;
  },
});

// RA §14.2: «الأجهزة», the app installations; the portal is never one (§4.6).
export const devicesQuery = queryOptions({
  queryKey: ['devices'],
  queryFn: async (): Promise<Devices> => {
    const { data, response } = await api.GET('/v1/merchant/devices');
    if (!data) throw new Error(`The devices read failed (${response.status}).`);
    return data;
  },
});

// Owner decision 2026-11-20: the restaurant's open portal sessions, which an
// owner signs out from «الأجهزة» (a lost laptop).
export const portalSessionsQuery = queryOptions({
  queryKey: ['portal-sessions'],
  queryFn: async (): Promise<PortalSessions> => {
    const { data, response } = await api.GET('/v1/merchant/portal-sessions');
    if (!data) throw new Error(`The portal sessions read failed (${response.status}).`);
    return data;
  },
});

export type TeamRefusal =
  'phoneTaken' | 'invalidPhone' | 'gone' | 'tooMany' | 'terminated' | 'other';

export function teamRefusalOf(error: unknown): TeamRefusal {
  switch ((error as { error?: unknown } | undefined)?.error) {
    case 'phone_taken':
      return 'phoneTaken';
    case 'unknown_account':
    case 'unknown_device':
    case 'unknown_session':
    case 'no_device':
    case 'not_a_cashier':
      return 'gone';
    case 'too_many':
      return 'tooMany';
    case 'restaurant_terminated':
      return 'terminated';
    default:
      return 'other';
  }
}

export type TeamCommand =
  | { kind: 'add_cashier'; name: string; phone: string }
  | { kind: 'remove_cashier'; accountId: string }
  | { kind: 'rename_device'; deviceId: string; name: string }
  | { kind: 'sign_out_device'; deviceId: string }
  | { kind: 'sign_out_portal'; sessionId: string };

export type TeamAnswer = { status: 'done' } | { status: 'refused'; refusal: TeamRefusal };

// Each answers its list, which replaces the read; none takes a key (the add
// answers a repeat with the account made, the others name their target).
// A refusal reads the list again, since it may have changed elsewhere.
export function useTeamCommand() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: async (command: TeamCommand): Promise<TeamAnswer> => {
      const [queryKey, result] = await send(command);
      if (result.data) {
        queryClient.setQueryData(queryKey, result.data);
        // A cashier removed or added changes the devices' users too.
        if (queryKey === staffQuery.queryKey) {
          void queryClient.invalidateQueries({ queryKey: devicesQuery.queryKey });
        }
        return { status: 'done' };
      }
      if (result.response.status === 400 && command.kind === 'add_cashier') {
        return { status: 'refused', refusal: 'invalidPhone' };
      }
      if (result.response.status >= 400 && result.response.status < 500) {
        void queryClient.invalidateQueries({ queryKey });
        return { status: 'refused', refusal: teamRefusalOf(result.error) };
      }
      throw new Error(`The team command failed (${result.response.status}).`);
    },
  });
}

async function send(command: TeamCommand) {
  switch (command.kind) {
    case 'add_cashier':
      return [
        staffQuery.queryKey,
        await api.POST('/v1/merchant/staff', {
          body: { name: command.name, phone: command.phone },
        }),
      ] as const;
    case 'remove_cashier':
      return [
        staffQuery.queryKey,
        await api.POST('/v1/merchant/staff/{accountId}/remove', {
          params: { path: { accountId: command.accountId } },
        }),
      ] as const;
    case 'rename_device':
      return [
        devicesQuery.queryKey,
        await api.PUT('/v1/merchant/devices/{deviceId}/name', {
          params: { path: { deviceId: command.deviceId } },
          body: { name: command.name },
        }),
      ] as const;
    case 'sign_out_device':
      return [
        devicesQuery.queryKey,
        await api.POST('/v1/merchant/devices/{deviceId}/sign-out', {
          params: { path: { deviceId: command.deviceId } },
        }),
      ] as const;
    case 'sign_out_portal':
      return [
        portalSessionsQuery.queryKey,
        await api.POST('/v1/merchant/portal-sessions/{sessionId}/sign-out', {
          params: { path: { sessionId: command.sessionId } },
        }),
      ] as const;
  }
}

// RA §4.3 «ربط كمبيوتر بويندوز» (slice 2.44): a one-time code shown once,
// never cached; a repeat makes a new code.
export function usePairWindows() {
  return useMutation({
    mutationFn: async (): Promise<
      { status: 'done'; pairing: Pairing } | { status: 'refused'; refusal: TeamRefusal }
    > => {
      const { data, error, response } = await api.POST('/v1/merchant/devices/windows-pairing');
      if (data) return { status: 'done', pairing: data };
      if (response.status >= 400 && response.status < 500) {
        return { status: 'refused', refusal: teamRefusalOf(error) };
      }
      throw new Error(`The pairing code failed (${response.status}).`);
    },
  });
}

// The browser a portal session signed in from, as its user agent names it:
// the browser and the system, else the raw text (null: unknown).
export function browserOf(userAgent: string | null): { browser: string; system: string } | null {
  if (userAgent === null) return null;
  const browser = /Edg\//.test(userAgent)
    ? 'Edge'
    : /OPR\/|Opera/.test(userAgent)
      ? 'Opera'
      : /Firefox\//.test(userAgent)
        ? 'Firefox'
        : /Chrome\//.test(userAgent)
          ? 'Chrome'
          : /Safari\//.test(userAgent)
            ? 'Safari'
            : null;
  const system = /Windows/.test(userAgent)
    ? 'Windows'
    : /Android/.test(userAgent)
      ? 'Android'
      : /iPhone|iPad/.test(userAgent)
        ? 'iOS'
        : /Mac OS X/.test(userAgent)
          ? 'macOS'
          : /Linux/.test(userAgent)
            ? 'Linux'
            : null;
  if (browser === null || system === null) return null;
  return { browser, system };
}
