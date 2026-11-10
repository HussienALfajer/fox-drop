import type { components } from '@fox-drop/api-schema';
import { keepPreviousData, queryOptions, useMutation, useQueryClient } from '@tanstack/react-query';
import { useRef } from 'react';
import { api } from './api.js';
import { OPERATIONS_MANAGE } from './assign-captain.js';
import type { CashAnswer } from './order-cancel.js';
import type { OrderDetail } from './order-detail.js';
import { type AdminSession, can } from './session.js';

type ReassignBody = components['schemas']['AdminReassignDto'];
export type ReassignPreview = components['schemas']['AdminReassignPreviewAnswerDto_Output'];
export type ReassignChoices = NonNullable<OrderDetail['reassignChoices']>;

// AP §9.3.2 «سحب وإعادة تعيين»: OWN and OPS, while the order is accepted or
// ready with a captain (the detail then carries the reasons).
export function canReassign(
  session: AdminSession | null | undefined,
  order: Pick<OrderDetail, 'reassignChoices'>,
): order is { reassignChoices: ReassignChoices } {
  return can(session, OPERATIONS_MANAGE) && order.reassignChoices !== null;
}

// «Then the order goes back to dispatch or to a picked captain» (AP §9.3.2):
// the picker opens after the withdrawal for `pick`.
export type Next = 'dispatch' | 'pick';

export interface ReassignForm {
  reassignment: string | null;
  // «بخطأ من الكابتن» or «دون خطأ», prefilled from the reason (owner
  // decision 2026-11-10); null until a reason is chosen.
  captainFault: boolean | null;
  cash: CashAnswer | null;
  next: Next;
  // Operations' note, required (AP §9.3.2), never shown to the apps.
  reason: string;
}

// Choosing a reason prefills its default fault (AP Appendix B).
export function chooseReason(
  form: ReassignForm,
  choices: ReassignChoices,
  code: string,
): ReassignForm {
  const reason = choices.reasons.find((each) => each.code === code);
  return { ...form, reassignment: code, captainFault: reason?.captainFault ?? null };
}

// The body of a complete form, or null while a step is missing: a reason, the
// fault, the cash answer when the preview asks it, the note. An answer the
// preview no longer asks is left out.
export function reassignBody(
  form: ReassignForm,
  preview: Pick<ReassignPreview, 'cashAsked'> | undefined,
): ReassignBody | null {
  const reason = form.reason.trim();
  if (form.reassignment === null || form.captainFault === null || reason === '') return null;
  if (preview === undefined) return null;
  if (preview.cashAsked && form.cash === null) return null;
  return {
    reassignment: form.reassignment,
    captainFault: form.captainFault,
    cash: preview.cashAsked ? form.cash : null,
    reason,
  };
}

// The refusals the panel explains: the order moved on, a pickup request is
// open, or the choices no longer fit it.
export type ReassignRefusal =
  | 'order_state_changed'
  | 'pickup_request_open'
  | 'unknown_reason'
  | 'cash_answer_required'
  | 'cash_answer_not_allowed';

const refusals: readonly string[] = [
  'order_state_changed',
  'pickup_request_open',
  'unknown_reason',
  'cash_answer_required',
  'cash_answer_not_allowed',
] satisfies ReassignRefusal[];

function refusalOf(status: number, error: unknown): ReassignRefusal | null {
  const refusal = (error as { error?: unknown } | undefined)?.error;
  return (status === 409 || status === 400) &&
    typeof refusal === 'string' &&
    refusals.includes(refusal)
    ? (refusal as ReassignRefusal)
    : null;
}

export type PreviewResult =
  { status: 'preview'; preview: ReassignPreview } | { status: 'refused'; refusal: ReassignRefusal };

// docs/domain/09: what the cash answer would post, asked on opening (it says
// whether to ask the question), on each answer and on each new version of
// the order, so the confirm never follows entries the operator did not see.
export function reassignPreviewQuery(orderId: string, version: number, cash: CashAnswer | null) {
  return queryOptions({
    queryKey: ['reassign-preview', orderId, version, cash],
    placeholderData: keepPreviousData,
    queryFn: async (): Promise<PreviewResult> => {
      const { data, error, response } = await api.POST(
        '/v1/admin/orders/{orderId}/reassign-preview',
        { params: { path: { orderId } }, body: { cash } },
      );
      if (data) return { status: 'preview', preview: data };
      const refusal = refusalOf(response.status, error);
      if (refusal) return { status: 'refused', refusal };
      throw new Error(`The preview failed with ${response.status}.`);
    },
  });
}

export type ReassignResult = { status: 'done' } | { status: 'refused'; refusal: ReassignRefusal };

// One Idempotency-Key per choice until an answer arrives, so a retry after a
// lost answer replays instead of withdrawing twice (architecture §5.3).
export function useReassignOrder(orderId: string) {
  const queryClient = useQueryClient();
  const keys = useRef(new Map<string, string>());
  return useMutation({
    mutationFn: async (body: ReassignBody): Promise<ReassignResult> => {
      const id = JSON.stringify(body);
      let key = keys.current.get(id);
      if (key === undefined) {
        key = crypto.randomUUID();
        keys.current.set(id, key);
      }
      const { data, error, response } = await api.POST('/v1/admin/orders/{orderId}/reassign', {
        params: { path: { orderId }, header: { 'Idempotency-Key': key } },
        body,
      });
      if (data) {
        keys.current.delete(id);
        return { status: 'done' };
      }
      const refusal = refusalOf(response.status, error);
      if (refusal) {
        keys.current.delete(id);
        return { status: 'refused', refusal };
      }
      throw new Error(`The reassignment failed with ${response.status}.`);
    },
    onSettled: () =>
      Promise.all([
        queryClient.invalidateQueries({ queryKey: ['order', orderId] }),
        queryClient.invalidateQueries({ queryKey: ['orders-board'] }),
        queryClient.invalidateQueries({ queryKey: ['reassign-preview', orderId] }),
      ]),
  });
}
