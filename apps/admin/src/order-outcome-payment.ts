import type { components } from '@fox-drop/api-schema';
import { useMutation, useQueryClient } from '@tanstack/react-query';
import { useRef } from 'react';
import { api } from './api.js';
import { OPERATIONS_MANAGE } from './assign-captain.js';
import { minorOf } from './format.js';
import type { OrderDetail } from './order-detail.js';
import { type AdminSession, can } from './session.js';

type PaymentBody = components['schemas']['AdminRecordDeliveryDto'];
type Money = { amount: string; currency: string };

// AP §9.3.2, CA §9.10 (K9, slice 2.11b): operations record the payment of an
// outcome's amount to collect when the captain cannot, while it waits.
export function canRecordOutcomePayment(
  session: AdminSession | null | undefined,
  order: Pick<OrderDetail, 'outcome'>,
): boolean {
  return can(session, OPERATIONS_MANAGE) && order.outcome?.awaitingCollection === true;
}

// The lines in the base currency only (the captain's screen takes the
// order's other currencies), typed in major units.
export interface OutcomePaymentForm {
  received: string;
  change: string;
  // K16: a code of Content's shortfall list, asked once the server finds one.
  shortfall: string | null;
  shortfallNote: string;
  // Operations' reason, required (AP §9.3.2).
  reason: string;
}

export const emptyOutcomePayment: OutcomePaymentForm = {
  received: '',
  change: '',
  shortfall: null,
  shortfallNote: '',
  reason: '',
};

// The body, or null while an amount is not one or the reason is missing.
export function outcomePaymentBody(form: OutcomePaymentForm, due: Money): PaymentBody | null {
  const received = minorOf(form.received, due.currency);
  const change = form.change.trim() === '' ? '0' : minorOf(form.change, due.currency);
  const reason = form.reason.trim();
  if (received === null || received === '0' || change === null || reason === '') return null;
  const note = form.shortfallNote.trim();
  return {
    received: [{ currency: due.currency, amount: received }],
    change: change === '0' ? [] : [{ currency: due.currency, amount: change }],
    amountDue: due,
    shortfall: form.shortfall === null ? null : { reason: form.shortfall, note: note || null },
    reason,
  };
}

// The refusals the dialog explains.
export type OutcomePaymentRefusal =
  | 'order_state_changed'
  | 'amount_due_changed'
  | 'overpaid'
  | 'shortfall_reason_required'
  | 'invalid_lines'
  | 'unknown_reason'
  | 'reason_note_required'
  | 'reason_note_not_allowed';

const refusals: readonly string[] = [
  'order_state_changed',
  'amount_due_changed',
  'overpaid',
  'shortfall_reason_required',
  'invalid_lines',
  'unknown_reason',
  'reason_note_required',
  'reason_note_not_allowed',
] satisfies OutcomePaymentRefusal[];

export type OutcomePaymentResult =
  | { status: 'done' }
  | { status: 'refused'; refusal: OutcomePaymentRefusal; shortfall: Money | null };

// One Idempotency-Key per body until an answer arrives (architecture §5.3).
export function useRecordOutcomePayment(orderId: string) {
  const queryClient = useQueryClient();
  const keys = useRef(new Map<string, string>());
  return useMutation({
    mutationFn: async (body: PaymentBody): Promise<OutcomePaymentResult> => {
      const id = JSON.stringify(body);
      let key = keys.current.get(id);
      if (key === undefined) {
        key = crypto.randomUUID();
        keys.current.set(id, key);
      }
      const { data, error, response } = await api.POST(
        '/v1/admin/orders/{orderId}/outcome-payment',
        { params: { path: { orderId }, header: { 'Idempotency-Key': key } }, body },
      );
      if (data) {
        keys.current.delete(id);
        return { status: 'done' };
      }
      const answer = error as { error?: unknown; shortfall?: Money } | undefined;
      const refusal = answer?.error;
      if (
        (response.status === 409 || response.status === 400) &&
        typeof refusal === 'string' &&
        refusals.includes(refusal)
      ) {
        keys.current.delete(id);
        return {
          status: 'refused',
          refusal: refusal as OutcomePaymentRefusal,
          shortfall: answer?.shortfall ?? null,
        };
      }
      throw new Error(`The payment failed with ${response.status}.`);
    },
    onSettled: () =>
      Promise.all([
        queryClient.invalidateQueries({ queryKey: ['order', orderId] }),
        queryClient.invalidateQueries({ queryKey: ['orders-board'] }),
      ]),
  });
}
