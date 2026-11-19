import type { components } from '@fox-drop/api-schema';
import { queryOptions, useMutation, useQueryClient } from '@tanstack/react-query';
import { useRef } from 'react';
import { api } from './api.js';
import { type AdminSession, can } from './session.js';

export type CaptainViolations = components['schemas']['AdminCaptainViolationsDto_Output'];
export type CaptainViolation = CaptainViolations['violations'][number];
export type ViolationStep = CaptainViolation['step'];

// AP §9.7.6: the conduct ladder, in order.
export const VIOLATION_STEPS: readonly ViolationStep[] = [
  'warning',
  'suspension_1d',
  'suspension_7d',
  'termination',
];

// AP §9.7.5 «تسجيل مخالفة»: OWN and OPS.
export const canRecordViolation = (session: AdminSession | null | undefined) =>
  can(session, 'captains.manage');

const violationsKey = (captainId: string) => ['captain-violations', captainId] as const;

export const captainViolationsQuery = (captainId: string) =>
  queryOptions({
    queryKey: violationsKey(captainId),
    queryFn: async (): Promise<CaptainViolations> => {
      const { data, response } = await api.GET('/v1/admin/captains/{captainId}/violations', {
        params: { path: { captainId } },
      });
      if (!data) throw new Error(`The violations failed to load (${response.status}).`);
      return data;
    },
  });

// The step the ladder suggests for the type chosen: a severe one terminates
// at once, any other takes the next step (AP §9.7.6).
export function suggestedFor(violations: CaptainViolations, severe: boolean): ViolationStep {
  return severe ? 'termination' : violations.suggestion.step;
}

// The form's choice of a type, from either list, as one value.
export function typeKey(severe: boolean, code: string): string {
  return (severe ? 'severe:' : 'regular:') + code;
}

export function typeOfKey(key: string): { severe: boolean; code: string | null } {
  const at = key.indexOf(':');
  if (at < 0) return { severe: false, code: null };
  return { severe: key.slice(0, at) === 'severe', code: key.slice(at + 1) };
}

// An appeal's state as the panel shows it: none, waiting for its ticket's
// resolution, accepted (the violation voided) or rejected.
export type AppealState = 'none' | 'open' | 'accepted' | 'rejected';

export function appealStateOf(violation: CaptainViolation): AppealState {
  if (violation.appeal === null) return 'none';
  return violation.appeal.outcome ?? 'open';
}

export type ViolationRefusal =
  | 'unknown_reason'
  | 'reason_note_required'
  | 'reason_note_not_allowed'
  | 'unknown_order'
  | 'captain_terminated'
  | 'no_contract'
  | 'already_terminated'
  | 'offboarding_open';

const violationRefusals: readonly ViolationRefusal[] = [
  'unknown_reason',
  'reason_note_required',
  'reason_note_not_allowed',
  'unknown_order',
  'captain_terminated',
  'no_contract',
  'already_terminated',
  'offboarding_open',
];

export interface NewViolation {
  severe: boolean;
  typeCode: string;
  typeNote: string | null;
  step: ViolationStep;
  orderId: string | null;
  reason: string;
}

export type RecordResult = { status: 'done' } | { status: 'refused'; refusal: ViolationRefusal };

// One Idempotency-Key per violation as typed until an answer arrives, so a
// retry after a lost answer records it once. The profile (its status), the
// change log and the contract are read again: a step may suspend or end it.
export function useRecordViolation(captainId: string) {
  const queryClient = useQueryClient();
  const keys = useRef(new Map<string, string>());
  return useMutation({
    mutationFn: async (violation: NewViolation): Promise<RecordResult> => {
      const typed = JSON.stringify(violation);
      let key = keys.current.get(typed);
      if (key === undefined) {
        key = crypto.randomUUID();
        keys.current.set(typed, key);
      }
      const { data, error, response } = await api.POST(
        '/v1/admin/captains/{captainId}/violations',
        {
          params: { path: { captainId }, header: { 'Idempotency-Key': key } },
          body: violation,
        },
      );
      if (data) {
        keys.current.delete(typed);
        queryClient.setQueryData(violationsKey(captainId), data);
        return { status: 'done' };
      }
      const code = (error as { error?: unknown } | undefined)?.error;
      const refusal = violationRefusals.find((each) => each === code);
      if (refusal !== undefined) {
        keys.current.delete(typed);
        return { status: 'refused', refusal };
      }
      throw new Error(`The violation failed (${response.status}).`);
    },
    onSettled: () => {
      void queryClient.invalidateQueries({ queryKey: ['captain-profile', captainId] });
      void queryClient.invalidateQueries({ queryKey: ['captain-change-log', captainId] });
      void queryClient.invalidateQueries({ queryKey: ['captain-availability', captainId] });
    },
  });
}
