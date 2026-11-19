import type { components } from '@fox-drop/api-schema';
import { queryOptions, useMutation, useQueryClient } from '@tanstack/react-query';
import { useRef } from 'react';
import { api } from './api.js';
import { minorOf } from './format.js';
import { type AdminSession, can } from './session.js';

export type CaptainProfile = components['schemas']['AdminCaptainProfileDto_Output'];
export type CaptainOffer = components['schemas']['AdminCaptainOffersDto_Output']['offers'][number];
export type CaptainOrder = components['schemas']['AdminCaptainOrdersDto_Output']['orders'][number];
export type CaptainNote = components['schemas']['AdminCaptainNotesDto_Output']['notes'][number];
export type CaptainChange =
  components['schemas']['AdminCaptainChangeLogDto_Output']['entries'][number];

// AP §9.7.4: the profile's tabs, in its order. «البيانات والمستندات»,
// «المركبة», «العقد» and «العدة والتأمين» live on the captain's file (the
// application's page), which «البيانات» and «العقد» open; «العقد» holds
// «إنهاء التعاقد» (slice 2.36a).
export const CAPTAIN_TABS = [
  'overview',
  'data',
  'app',
  'contract',
  'custody',
  'earnings',
  'orders',
  'offers',
  'ratings',
  'suspensions',
  'notes',
  'log',
] as const;
export type CaptainTab = (typeof CAPTAIN_TABS)[number];

export function isCaptainTab(value: unknown): value is CaptainTab {
  return CAPTAIN_TABS.some((tab) => tab === value);
}

// AP §9.7.5, AP §6.2: who acts.
export const canSuspend = (session: AdminSession | null | undefined) =>
  can(session, 'captains.suspend');
export const canChangeCashLimit = (session: AdminSession | null | undefined) =>
  can(session, 'captains.cash_limit');
export const canMessage = (session: AdminSession | null | undefined) =>
  can(session, 'captains.manage');
export const canGrantGrace = (session: AdminSession | null | undefined) =>
  can(session, 'captains.hand_in_grace');

const profileKey = (captainId: string) => ['captain-profile', captainId] as const;

// Null for an unknown captain (404 unknown_captain); 'rates_unavailable'
// while a currency the captain holds has no rate (409).
export const captainProfileQuery = (captainId: string) =>
  queryOptions({
    queryKey: profileKey(captainId),
    queryFn: async (): Promise<CaptainProfile | 'rates_unavailable' | null> => {
      const { data, response } = await api.GET('/v1/admin/captains/{captainId}/profile', {
        params: { path: { captainId } },
      });
      if (response.status === 404) return null;
      if (response.status === 409) return 'rates_unavailable';
      if (!data) throw new Error('The captain profile read failed.');
      return data;
    },
  });

export const captainOrdersQuery = (captainId: string) =>
  queryOptions({
    queryKey: ['captain-orders', captainId],
    queryFn: async (): Promise<CaptainOrder[]> => {
      const { data } = await api.GET('/v1/admin/captains/{captainId}/orders', {
        params: { path: { captainId } },
      });
      if (!data) throw new Error('The orders read failed.');
      return data.orders;
    },
  });

export const captainOffersQuery = (captainId: string) =>
  queryOptions({
    queryKey: ['captain-offers', captainId],
    queryFn: async (): Promise<CaptainOffer[]> => {
      const { data } = await api.GET('/v1/admin/captains/{captainId}/offers', {
        params: { path: { captainId } },
      });
      if (!data) throw new Error('The offer log read failed.');
      return data.offers;
    },
  });

// The number in full (captains.manage), each read audited as a view: asked
// by «إظهار الرقم» only, never kept.
export function useCaptainPhone(captainId: string) {
  return useMutation({
    mutationFn: async (): Promise<string | null> => {
      const { data } = await api.GET('/v1/admin/captains/{captainId}/phone', {
        params: { path: { captainId } },
      });
      if (!data) throw new Error('The number read failed.');
      return data.phone;
    },
  });
}

const changeLogKey = (captainId: string) => ['captain-change-log', captainId] as const;

export const captainChangeLogQuery = (captainId: string) =>
  queryOptions({
    queryKey: changeLogKey(captainId),
    queryFn: async (): Promise<CaptainChange[]> => {
      const { data } = await api.GET('/v1/admin/captains/{captainId}/change-log', {
        params: { path: { captainId } },
      });
      if (!data) throw new Error('The change log read failed.');
      return data.entries;
    },
  });

const notesKey = (captainId: string) => ['captain-notes', captainId] as const;

export const captainNotesQuery = (captainId: string) =>
  queryOptions({
    queryKey: notesKey(captainId),
    queryFn: async (): Promise<CaptainNote[]> => {
      const { data } = await api.GET('/v1/admin/captains/{captainId}/notes', {
        params: { path: { captainId } },
      });
      if (!data) throw new Error('The notes read failed.');
      return data.notes;
    },
  });

// One Idempotency-Key per body until an answer arrives (architecture §5.3).
export function useAddCaptainNote(captainId: string) {
  const queryClient = useQueryClient();
  const keys = useRef(new Map<string, string>());
  return useMutation({
    mutationFn: async (body: string): Promise<CaptainNote[]> => {
      let key = keys.current.get(body);
      if (key === undefined) {
        key = crypto.randomUUID();
        keys.current.set(body, key);
      }
      const { data, response } = await api.POST('/v1/admin/captains/{captainId}/notes', {
        params: { path: { captainId }, header: { 'Idempotency-Key': key } },
        body: { body },
      });
      if (!data) throw new Error(`The note failed (${response.status}).`);
      keys.current.delete(body);
      return data.notes;
    },
    onSuccess: (notes) => queryClient.setQueryData(notesKey(captainId), notes),
  });
}

export const MESSAGE_MAX = 300;

// The text trimmed, or null when empty or longer than `max`.
export function textOf(text: string, max: number): string | null {
  const body = text.trim();
  return body.length === 0 || body.length > max ? null : body;
}

// CA §14 #24: one Idempotency-Key per text until an answer arrives, so a
// retry sends no second push.
export function useMessageCaptain(captainId: string) {
  const queryClient = useQueryClient();
  const keys = useRef(new Map<string, string>());
  return useMutation({
    mutationFn: async (text: string): Promise<'sent' | 'terminated'> => {
      let key = keys.current.get(text);
      if (key === undefined) {
        key = crypto.randomUUID();
        keys.current.set(text, key);
      }
      const { data, response } = await api.POST('/v1/admin/captains/{captainId}/message', {
        params: { path: { captainId }, header: { 'Idempotency-Key': key } },
        body: { text },
      });
      if (response.status === 409) return 'terminated';
      if (!data) throw new Error(`The message failed (${response.status}).`);
      keys.current.delete(text);
      return 'sent';
    },
    onSuccess: () => queryClient.invalidateQueries({ queryKey: changeLogKey(captainId) }),
  });
}

// AP §9.7.5 «إيقاف» and the reactivation: the refusals the panel explains.
export type StatusRefusal =
  'status_change_not_allowed' | 'offboarding_open' | 'invalid_captain' | 'reason_required';

export type CommandResult<R extends string> =
  { status: 'done' } | { status: 'refused'; refusal: R };

const statusRefusals: readonly StatusRefusal[] = [
  'status_change_not_allowed',
  'offboarding_open',
  'invalid_captain',
  'reason_required',
];

function refusalOf<R extends string>(error: unknown, known: readonly R[]): R | null {
  const code = (error as { error?: unknown } | undefined)?.error;
  return known.find((each) => each === code) ?? null;
}

// No Idempotency-Key: it sets a state. The profile, the change log and the
// state beside «فصل من الاتصال» are read again.
export function useSetCaptainStatus(captainId: string) {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: async (command: {
      status: 'suspended' | 'active';
      until: string | null;
      reason: string;
    }): Promise<CommandResult<StatusRefusal>> => {
      const { data, error, response } = await api.POST('/v1/admin/captains/{captainId}/status', {
        params: { path: { captainId } },
        body: command,
      });
      if (data) return { status: 'done' };
      const refusal = refusalOf(error, statusRefusals);
      if (refusal !== null) return { status: 'refused', refusal };
      throw new Error(`The status change failed (${response.status}).`);
    },
    onSettled: () => {
      void queryClient.invalidateQueries({ queryKey: profileKey(captainId) });
      void queryClient.invalidateQueries({ queryKey: changeLogKey(captainId) });
      void queryClient.invalidateQueries({ queryKey: ['captain-availability', captainId] });
    },
  });
}

export type CashLimitRefusal = 'invalid_captain' | 'not_in_base_currency';

// No Idempotency-Key: it sets a value.
export function useSetCaptainCashLimit(captainId: string) {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: async (command: {
      amount: string;
      currency: string;
      reason: string;
    }): Promise<CommandResult<CashLimitRefusal>> => {
      const { data, error, response } = await api.PUT('/v1/admin/captains/{captainId}/cash-limit', {
        params: { path: { captainId } },
        body: command,
      });
      if (data) return { status: 'done' };
      const refusal = refusalOf(error, ['invalid_captain', 'not_in_base_currency'] as const);
      if (refusal !== null) return { status: 'refused', refusal };
      throw new Error(`The cash limit change failed (${response.status}).`);
    },
    onSettled: () => {
      void queryClient.invalidateQueries({ queryKey: profileKey(captainId) });
      void queryClient.invalidateQueries({ queryKey: changeLogKey(captainId) });
    },
  });
}

// A cash limit typed in the base's major units, as minor units above zero;
// null otherwise.
export function cashLimitMinor(text: string, currency: string): string | null {
  const minor = minorOf(text, currency);
  return minor === null || BigInt(minor) <= 0n ? null : minor;
}

// The change log's actions by their Arabic labels; another reads «تغيير».
export const captainChangeActions = [
  'captain.create',
  'captain.rehire',
  'captain.status',
  'captain.custody_limit',
  'captain.force_offline',
  'captain.hand_in_grace',
  'captain.note',
  'captain.message',
  'captain.violation',
  'captain.violation_appeal',
  'captain_application.note',
  'captain_application.interview',
  'captain_application.training_passed',
  'captain_application.waitlist',
  'captain_application.back_from_waitlist',
  'captain_application.reject',
  'captain_application.document_review',
  'captain_application.document_upload',
  'captain_application.document_request',
  'captain_application.issue_kit',
  'captain_application.cash_limit',
  'captain_application.contract',
  'captain_application.deposit',
  'captain_application.activate',
  'captain_application.probation_confirmed',
  'captain_application.terminate',
  'captain_application.kit_return',
  'captain_application.close',
] as const;
export type CaptainChangeAction = (typeof captainChangeActions)[number];

export function captainChangeActionOf(action: string): CaptainChangeAction | null {
  return captainChangeActions.find((each) => each === action) ?? null;
}
