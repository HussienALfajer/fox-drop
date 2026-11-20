import type { components } from '@fox-drop/api-schema';
import { queryOptions, useMutation, useQueryClient } from '@tanstack/react-query';
import { useRef } from 'react';
import { api } from './api.js';
import { type Direction, signedAmountOf } from './manual-entries.js';
import { ORDER_HISTORY_READ } from './order-history.js';
import { type AdminSession, can } from './session.js';

// AP §9.5 (slice 2.40): a finished order is read-only; OWN and FIN correct
// its money with a manual entry linked to it (owner decision 2026-11-20).
export type OrderCorrections = components['schemas']['AdminOrderCorrectionsDto_Output'];
export type CorrectionAccount = OrderCorrections['accounts'][number];
type CorrectionBody = components['schemas']['AdminOrderCorrectionDto'];

export const canReadCorrections = (session: AdminSession) => can(session, ORDER_HISTORY_READ);

const correctionsKey = (orderId: string) => ['order', orderId, 'financial-corrections'] as const;

// Keyed under the order, so its events read it again.
export const orderCorrectionsQuery = (orderId: string) =>
  queryOptions({
    queryKey: correctionsKey(orderId),
    queryFn: async (): Promise<OrderCorrections | null> => {
      const { data, response } = await api.GET('/v1/admin/orders/{orderId}/financial-corrections', {
        params: { path: { orderId } },
      });
      if (data) return data;
      if (response.status === 404) return null;
      throw new Error(`The corrections read failed with ${response.status}.`);
    },
  });

export interface CorrectionForm {
  // The index of the chosen account in the read's `accounts`.
  choice: number;
  currency: string;
  direction: Direction;
  amount: string;
  reason: string;
}

// The body once an account, the amount and the reason are there, else null.
export function correctionBody(
  accounts: readonly CorrectionAccount[],
  form: CorrectionForm,
): CorrectionBody | null {
  const account = accounts[form.choice];
  if (!account || !account.currencies.includes(form.currency)) return null;
  const amount = signedAmountOf(form.amount, form.direction, form.currency);
  const reason = form.reason.trim();
  if (amount === null || reason === '') return null;
  return {
    party: account.partyKind,
    partyId: account.partyId,
    account: account.account,
    currency: form.currency,
    amount,
    reason,
  };
}

export const correctionRefusals = [
  'order_not_finished',
  'not_order_party',
  'invalid_amounts',
  'invalid_currency',
  'invalid_account',
  'reason_required',
  'unknown_party',
  'no_base_currency',
] as const;
export type CorrectionRefusal = (typeof correctionRefusals)[number];

export type CorrectionResult =
  { status: 'posted' } | { status: 'refused'; refusal: CorrectionRefusal };

// One Idempotency-Key per body until an answer arrives (architecture §5.3).
export function useCorrectOrder(orderId: string) {
  const queryClient = useQueryClient();
  const keys = useRef(new Map<string, string>());
  return useMutation({
    mutationFn: async (body: CorrectionBody): Promise<CorrectionResult> => {
      const choice = JSON.stringify(body);
      let key = keys.current.get(choice);
      if (key === undefined) {
        key = crypto.randomUUID();
        keys.current.set(choice, key);
      }
      const { data, error, response } = await api.POST(
        '/v1/admin/orders/{orderId}/financial-corrections',
        { params: { path: { orderId }, header: { 'Idempotency-Key': key } }, body },
      );
      if (data) {
        keys.current.delete(choice);
        return { status: 'posted' };
      }
      const refusal = (error as { error?: unknown } | undefined)?.error;
      if ((correctionRefusals as readonly unknown[]).includes(refusal)) {
        keys.current.delete(choice);
        return { status: 'refused', refusal: refusal as CorrectionRefusal };
      }
      throw new Error(`The correction failed with ${response.status}.`);
    },
    onSettled: () => queryClient.invalidateQueries({ queryKey: correctionsKey(orderId) }),
  });
}
