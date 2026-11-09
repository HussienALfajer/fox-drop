import type { components } from '@fox-drop/api-schema';
import { keepPreviousData, queryOptions, useMutation, useQueryClient } from '@tanstack/react-query';
import { useRef } from 'react';
import { api } from './api.js';
import { OPERATIONS_MANAGE } from './assign-captain.js';
import type { OrderDetail } from './order-detail.js';
import { type AdminSession, can } from './session.js';

type CancelBody = components['schemas']['AdminCancelDto'];
type PreviewBody = components['schemas']['AdminCancelPreviewDto'];
export type CancelPreview = components['schemas']['AdminCancelPreviewAnswerDto_Output'];
export type Responsible = CancelBody['responsible'];
export type CashAnswer = NonNullable<CancelBody['cash']>;
export type CancelChoices = NonNullable<OrderDetail['cancelChoices']>;

// AP §9.3.2 «إلغاء الطلب»: OWN and OPS, while the order is placed, accepted
// or ready (the detail then carries the reasons).
export function canCancel(
  session: AdminSession | null | undefined,
  order: Pick<OrderDetail, 'cancelChoices'>,
): order is { cancelChoices: CancelChoices } {
  return can(session, OPERATIONS_MANAGE) && order.cancelChoices !== null;
}

// docs/domain/09, AP Appendix C: the responsible parties, in the panel's order.
export const RESPONSIBLE_PARTIES = [
  'restaurant',
  'captain',
  'customer',
  'platform',
] as const satisfies readonly Responsible[];

// docs/domain/01: «نعم», «لا», «لم يدفع الكابتن بعد».
export const CASH_ANSWERS = [
  'returned',
  'not_returned',
  'not_paid',
] as const satisfies readonly CashAnswer[];

export interface CancelForm {
  cancellation: string | null;
  responsible: Responsible | null;
  // «تم تحضير الطعام؟» and «تعويض الكابتن»: never on a placed order.
  foodPrepared: boolean;
  compensateCaptain: boolean;
  cash: CashAnswer | null;
  // Operations' note, required (AP §9.3.2), never shown to the apps.
  reason: string;
}

// The preview's choices once a responsible party is chosen (the server needs
// one); the reason is checked only when chosen. Food and compensation are
// sent false on a placed order, which never offers them.
export function previewBody(form: CancelForm, placed: boolean): PreviewBody | null {
  if (form.responsible === null) return null;
  return {
    cancellation: form.cancellation,
    responsible: form.responsible,
    foodPrepared: !placed && form.foodPrepared,
    compensateCaptain: !placed && form.compensateCaptain,
    cash: form.cash,
  };
}

// The body of a complete form, or null while a step is missing: a reason, a
// responsible party, the cash answer when the preview asks it, the note.
// What the preview says the order does not allow is left out, so a question
// answered before it disappeared is never sent.
export function cancelBody(
  form: CancelForm,
  placed: boolean,
  preview: Pick<CancelPreview, 'cashAsked' | 'compensationAllowed'> | undefined,
): CancelBody | null {
  const reason = form.reason.trim();
  if (form.cancellation === null || form.responsible === null || reason === '') return null;
  if (preview === undefined) return null;
  if (preview.cashAsked && form.cash === null) return null;
  return {
    cancellation: form.cancellation,
    responsible: form.responsible,
    foodPrepared: !placed && form.foodPrepared,
    compensateCaptain: !placed && preview.compensationAllowed && form.compensateCaptain,
    cash: preview.cashAsked ? form.cash : null,
    reason,
  };
}

// The refusals the panel explains: the order moved on, the captain's vehicle
// has no rate in the pay table, or the choices no longer fit the order.
export type CancelRefusal =
  | 'order_state_changed'
  | 'captain_pay_unset'
  | 'unknown_reason'
  | 'invalid_cancellation'
  | 'compensation_not_allowed'
  | 'cash_answer_required'
  | 'cash_answer_not_allowed';

const refusals: readonly string[] = [
  'order_state_changed',
  'captain_pay_unset',
  'unknown_reason',
  'invalid_cancellation',
  'compensation_not_allowed',
  'cash_answer_required',
  'cash_answer_not_allowed',
] satisfies CancelRefusal[];

function refusalOf(status: number, error: unknown): CancelRefusal | null {
  const refusal = (error as { error?: unknown } | undefined)?.error;
  return (status === 409 || status === 400) &&
    typeof refusal === 'string' &&
    refusals.includes(refusal)
    ? (refusal as CancelRefusal)
    : null;
}

export type PreviewResult =
  { status: 'preview'; preview: CancelPreview } | { status: 'refused'; refusal: CancelRefusal };

// docs/domain/09: the entries the choices would post, asked again on each
// choice; the previous answer stays shown while the next one loads.
export function cancelPreviewQuery(orderId: string, body: PreviewBody | null) {
  return queryOptions({
    queryKey: ['cancel-preview', orderId, body],
    enabled: body !== null,
    placeholderData: keepPreviousData,
    queryFn: async (): Promise<PreviewResult> => {
      const { data, error, response } = await api.POST(
        '/v1/admin/orders/{orderId}/cancel-preview',
        {
          params: { path: { orderId } },
          body: body!,
        },
      );
      if (data) return { status: 'preview', preview: data };
      const refusal = refusalOf(response.status, error);
      if (refusal) return { status: 'refused', refusal };
      throw new Error(`The preview failed with ${response.status}.`);
    },
  });
}

export type CancelResult = { status: 'done' } | { status: 'refused'; refusal: CancelRefusal };

// One Idempotency-Key per choice until an answer arrives, so a retry after a
// lost answer replays instead of cancelling twice (architecture §5.3).
export function useCancelOrder(orderId: string) {
  const queryClient = useQueryClient();
  const keys = useRef(new Map<string, string>());
  return useMutation({
    mutationFn: async (body: CancelBody): Promise<CancelResult> => {
      const id = JSON.stringify(body);
      let key = keys.current.get(id);
      if (key === undefined) {
        key = crypto.randomUUID();
        keys.current.set(id, key);
      }
      const { data, error, response } = await api.POST('/v1/admin/orders/{orderId}/cancel', {
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
      throw new Error(`The cancellation failed with ${response.status}.`);
    },
    onSettled: () =>
      Promise.all([
        queryClient.invalidateQueries({ queryKey: ['order', orderId] }),
        queryClient.invalidateQueries({ queryKey: ['orders-board'] }),
        queryClient.invalidateQueries({ queryKey: ['cancel-preview', orderId] }),
      ]),
  });
}

type Money = { amount: string; currency: string };

// One sentence of the preview (owner decision 2026-11-10: the style of
// docs/domain/09's example), as a translation key and its values; the page
// formats the amounts.
export type PreviewLine =
  | { key: 'merchantCredit'; name: string | null; amount: Money }
  | { key: 'platformCost'; amount: Money }
  | { key: 'captainPay'; name: string | null; amount: Money; testCost: boolean }
  | { key: 'captainCustody'; name: string | null; amounts: Money[] }
  | { key: 'merchantDebit'; name: string | null; amount: Money }
  | { key: 'strike' }
  | { key: 'nothing' }
  // A journal type the panel cannot name: the dialog refuses to confirm.
  | { key: 'unknown' };

const positive = (money: Money): Money => ({
  ...money,
  amount: money.amount.replace(/^-/, ''),
});

// docs/domain/09: every entry the cancellation posts, with its amount,
// account and party, one sentence per journal. The order clearing account
// («طلبات قيد التسليم») only carries each journal through and nets to zero,
// so it is not repeated. A journal type the panel does not know is `unknown`:
// the preview must be whole before anyone confirms.
export function previewLines(preview: CancelPreview): PreviewLine[] {
  const journals = new Map<string, CancelPreview['entries']>();
  for (const entry of preview.entries) {
    journals.set(entry.type, [...(journals.get(entry.type) ?? []), entry]);
  }
  const lines: PreviewLine[] = [];
  for (const [type, entries] of journals) {
    const on = (account: string) => entries.find((entry) => entry.account === account);
    const merchant = on('merchant.account');
    if (type === 'merchant.credit' && merchant) {
      lines.push({
        key: 'merchantCredit',
        name: merchant.party.name,
        amount: positive(merchant.amount),
      });
    } else if (type === 'platform.operating_cost' && on('platform.operating_cost')) {
      lines.push({ key: 'platformCost', amount: positive(on('platform.operating_cost')!.amount) });
    } else if (type === 'earn.order_pay' && on('captain.earnings')) {
      const earnings = on('captain.earnings')!;
      lines.push({
        key: 'captainPay',
        name: earnings.party.name,
        amount: positive(earnings.amount),
        testCost: on('platform.test_cost') !== undefined,
      });
    } else if (type === 'custody.pay_merchant' && on('captain.custody')) {
      const custody = entries.filter((entry) => entry.account === 'captain.custody');
      lines.push({
        key: 'captainCustody',
        name: custody[0]!.party.name,
        amounts: custody.map((entry) => positive(entry.amount)),
      });
    } else if (type === 'merchant.debit' && merchant) {
      lines.push({
        key: 'merchantDebit',
        name: merchant.party.name,
        amount: positive(merchant.amount),
      });
    } else {
      lines.push({ key: 'unknown' });
    }
  }
  if (preview.strike) lines.push({ key: 'strike' });
  if (lines.length === 0) lines.push({ key: 'nothing' });
  return lines;
}
