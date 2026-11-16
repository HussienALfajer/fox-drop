import type { components } from '@fox-drop/api-schema';
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { useRef } from 'react';
import { api } from './api.js';
import { formatMoney, minorOf } from './format.js';
import { basisPointsOf } from './promo-codes.js';
import { type AdminSession, can } from './session.js';

export type OrderCompensations = components['schemas']['AdminOrderCompensationsDto_Output'];
export type Compensation = OrderCompensations['compensations'][number];
type CompensateBody = components['schemas']['AdminCompensateDto'];
export type CompensationValue = CompensateBody['value'];

// AP §9.3.2 «تعويض الزبون»: OWN, OPS and SUP (operations.compensate).
export const OPERATIONS_COMPENSATE = 'operations.compensate';
// AP §6.4: OWN approves, edits or rejects a request above a cap.
export const APPROVE_ABOVE_CAP = 'compensation.approve_above_cap';

export function canCompensate(session: AdminSession | null | undefined): boolean {
  return can(session, OPERATIONS_COMPENSATE);
}

export function canApproveCompensations(session: AdminSession | null | undefined): boolean {
  return can(session, APPROVE_ABOVE_CAP);
}

export function orderCompensationsQuery(orderId: string) {
  return {
    // Under the order's key, so its events read it again.
    queryKey: ['order', orderId, 'compensations'],
    queryFn: async (): Promise<OrderCompensations> => {
      const { data, error } = await api.GET('/v1/admin/orders/{orderId}/compensations', {
        params: { path: { orderId } },
      });
      if (error || !data) throw new Error('The compensations could not be read.');
      return data;
    },
  };
}

export function useOrderCompensations(orderId: string) {
  return useQuery(orderCompensationsQuery(orderId));
}

// The value as typed: an amount, or a percentage with its maximum amount, in
// the major units of the order's currency.
export interface ValueForm {
  kind: CompensationValue['kind'];
  amount: string;
  percent: string;
  maxDiscount: string;
}

export const emptyValue: ValueForm = {
  kind: 'fixed_amount',
  amount: '',
  percent: '',
  maxDiscount: '',
};

export type ValueProblem = 'amount' | 'percent' | 'maxDiscount';

// The whole compensation as typed: the value, the reason's code ('' until
// chosen) and the optional note.
export interface CompensationForm {
  value: ValueForm;
  reason: string;
  note: string;
}

export const emptyCompensation: CompensationForm = { value: emptyValue, reason: '', note: '' };

// The body of a complete compensation, or null while the value or the reason
// is missing (AP §6.4); a blank note is none.
export function compensationOf(form: CompensationForm, currency: string): CompensateBody | null {
  const checked = valueOf(form.value, currency);
  if (!('value' in checked) || form.reason === '') return null;
  const note = form.note.trim();
  return { value: checked.value, reason: { code: form.reason, note: note === '' ? null : note } };
}

// AP §6.4: an amount above 0, or a percentage from 0.01 to 100 with a
// maximum above 0 (what counts against the cap).
export function valueOf(
  form: ValueForm,
  currency: string,
): { value: CompensationValue } | { problem: ValueProblem } {
  if (form.kind === 'fixed_amount') {
    const amount = minorOf(form.amount, currency);
    if (amount === null || amount === '0') return { problem: 'amount' };
    return { value: { kind: 'fixed_amount', amount, percentBp: null, maxDiscount: null } };
  }
  const percentBp = basisPointsOf(form.percent);
  if (percentBp === null || percentBp < 1 || percentBp > 10000) return { problem: 'percent' };
  const maxDiscount = minorOf(form.maxDiscount, currency);
  if (maxDiscount === null || maxDiscount === '0') return { problem: 'maxDiscount' };
  return { value: { kind: 'percentage', amount: null, percentBp, maxDiscount } };
}

// What counts against a cap (AP §6.4): the amount, or a percentage's maximum.
export function countedOf(value: CompensationValue): bigint {
  return BigInt((value.kind === 'fixed_amount' ? value.amount : value.maxDiscount) ?? '0');
}

// Whether the value goes to OWN for approval: above what the admin may still
// give on the order (null: no cap).
export function needsApproval(value: CompensationValue, capLeft: string | null): boolean {
  return capLeft !== null && countedOf(value) > BigInt(capLeft);
}

// A value as the panel shows it: «25.00 ₺», or the percentage and its
// maximum for the translation «{النسبة}% بحد أقصى {المبلغ}».
export function valueParts(
  value: Pick<Compensation, 'kind' | 'amount' | 'percentBp' | 'maxDiscount' | 'currency'>,
): { kind: 'fixed_amount'; amount: string } | { kind: 'percentage'; percent: string; max: string } {
  if (value.kind === 'fixed_amount') {
    return {
      kind: 'fixed_amount',
      amount: formatMoney({ amount: value.amount ?? '0', currency: value.currency }),
    };
  }
  return {
    kind: 'percentage',
    percent: percentText(value.percentBp ?? 0),
    max: formatMoney({ amount: value.maxDiscount ?? '0', currency: value.currency }),
  };
}

export type CompensateRefusal =
  | 'invalid_value'
  | 'unknown_reason'
  | 'reason_note_required'
  | 'reason_note_not_allowed'
  | 'unknown_order'
  | 'no_base_currency'
  | 'currency_changed';

export type CompensateResult =
  | { status: 'done'; compensation: Compensation }
  | { status: 'refused'; refusal: CompensateRefusal };

const refusals: readonly string[] = [
  'invalid_value',
  'unknown_reason',
  'reason_note_required',
  'reason_note_not_allowed',
  'unknown_order',
  'no_base_currency',
  'currency_changed',
] satisfies CompensateRefusal[];

// One Idempotency-Key per body until an answer arrives, so a retry after a
// lost answer never issues a second code (architecture §5.3).
export function useCompensate(orderId: string) {
  const queryClient = useQueryClient();
  const keys = useRef(new Map<string, string>());
  return useMutation({
    mutationFn: async (body: CompensateBody): Promise<CompensateResult> => {
      const id = JSON.stringify(body);
      let key = keys.current.get(id);
      if (key === undefined) {
        key = crypto.randomUUID();
        keys.current.set(id, key);
      }
      const { data, error, response } = await api.POST('/v1/admin/orders/{orderId}/compensations', {
        params: { path: { orderId }, header: { 'Idempotency-Key': key } },
        body,
      });
      if (data) {
        keys.current.delete(id);
        return { status: 'done', compensation: data };
      }
      const refusal = (error as { error?: unknown } | undefined)?.error;
      if (typeof refusal === 'string' && refusals.includes(refusal)) {
        keys.current.delete(id);
        return { status: 'refused', refusal: refusal as CompensateRefusal };
      }
      throw new Error(`The compensation failed with ${response.status}.`);
    },
    onSettled: () =>
      Promise.all([
        queryClient.invalidateQueries({ queryKey: ['order', orderId, 'compensations'] }),
        queryClient.invalidateQueries({ queryKey: ['compensation-requests'] }),
      ]),
  });
}

// Basis points as a percent with Western digits: 2000 «20», 1250 «12.5».
export function percentText(bp: number): string {
  const whole = Math.trunc(bp / 100);
  const rest = bp % 100;
  if (rest === 0) return String(whole);
  return `${whole}.${String(rest).padStart(2, '0').replace(/0$/, '')}`;
}
