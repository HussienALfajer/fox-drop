import type { components } from '@fox-drop/api-schema';
import { keepPreviousData, queryOptions, useMutation, useQueryClient } from '@tanstack/react-query';
import { useRef } from 'react';
import { api } from './api.js';
import type { OrderDetail } from './order-detail.js';
import {
  deliveredFor,
  journalLines,
  type OutcomeForm,
  type OutcomeLine,
  OUTCOMES,
  outcomePreviewBody,
} from './order-outcome.js';
import { type AdminSession, can } from './session.js';

type ChangeBody = components['schemas']['AdminChangeOutcomeDto'];
type ChangePreviewBody = components['schemas']['AdminOutcomeChangePreviewDto'];
export type OutcomeChangePreview =
  components['schemas']['AdminOutcomeChangePreviewAnswerDto_Output'];
export type OutcomeChange = NonNullable<OrderDetail['outcomeChange']>;
type CurrentOutcome = NonNullable<OrderDetail['outcome']>;

// AP §8.9, §9.3.2 «تغيير النتيجة» (slice 2.11c): OWN only, while the detail
// carries `outcomeChange` (a finished order within order.outcome_change_days
// of its first outcome).
export const ORDERS_CHANGE_OUTCOME = 'orders.change_outcome';

export function canChangeOutcome(
  session: AdminSession | null | undefined,
  order: Pick<OrderDetail, 'outcomeChange' | 'outcome'>,
): order is { outcomeChange: OutcomeChange; outcome: CurrentOutcome } {
  return (
    can(session, ORDERS_CHANGE_OUTCOME) && order.outcomeChange !== null && order.outcome !== null
  );
}

// The dialog starts from the outcome in force; its amount collected stays
// (owner decision 2026-11-10), so the form takes no amount.
export function changeFormOf(current: CurrentOutcome): OutcomeForm {
  return {
    outcome: current.outcome,
    responsible: current.responsible,
    damagedDelivered: current.status === 'delivered',
    food: current.food ?? 'kept_by_captain',
    collect: '',
    reason: '',
  };
}

// An amount was collected: the customer paid, so only a delivered outcome
// may follow (free, or damaged delivered).
export function collected(current: CurrentOutcome): boolean {
  return current.amountToCollect.amount !== '0';
}

export function outcomesFor(current: CurrentOutcome): readonly (typeof OUTCOMES)[number][] {
  return collected(current)
    ? OUTCOMES.filter((outcome) => outcome === 'free' || outcome === 'damaged')
    : OUTCOMES;
}

// The choices once an outcome and a fitting party are chosen, and something
// differs from the outcome in force; null otherwise.
export function changePreviewBody(
  form: OutcomeForm,
  current: CurrentOutcome,
): ChangePreviewBody | null {
  if (collected(current) && !deliveredFor(form)) return null;
  const body = outcomePreviewBody({ ...form, collect: '' }, current.amountToCollect.currency);
  if (body === null) return null;
  const choices = {
    outcome: body.outcome,
    responsible: body.responsible,
    delivered: body.delivered,
    food: body.food,
  };
  const same =
    choices.outcome === current.outcome &&
    choices.responsible === current.responsible &&
    choices.delivered === (current.status === 'delivered') &&
    choices.food === current.food;
  return same ? null : choices;
}

export function changeBody(
  form: OutcomeForm,
  current: CurrentOutcome,
  version: number,
): ChangeBody | null {
  const choices = changePreviewBody(form, current);
  const reason = form.reason.trim();
  return choices === null || reason === '' ? null : { ...choices, version, reason };
}

// The refusals the panel explains: the order moved on, the days passed, the
// captain's vehicle has no rate, the fixed dues rule has no amount, or the
// choices no longer fit.
export type OutcomeChangeRefusal =
  | 'order_state_changed'
  | 'outcome_change_closed'
  | 'captain_pay_unset'
  | 'dues_rule_unset'
  | 'invalid_outcome';

const refusals: readonly string[] = [
  'order_state_changed',
  'outcome_change_closed',
  'captain_pay_unset',
  'dues_rule_unset',
  'invalid_outcome',
] satisfies OutcomeChangeRefusal[];

function refusalOf(status: number, error: unknown): OutcomeChangeRefusal | null {
  const refusal = (error as { error?: unknown } | undefined)?.error;
  return (status === 409 || status === 400) &&
    typeof refusal === 'string' &&
    refusals.includes(refusal)
    ? (refusal as OutcomeChangeRefusal)
    : null;
}

export type OutcomeChangePreviewResult =
  | { status: 'preview'; preview: OutcomeChangePreview }
  | { status: 'refused'; refusal: OutcomeChangeRefusal };

// AP §8.9 «The same preview is shown first», keyed by the detail's version
// as the outcome's own preview.
export function outcomeChangePreviewQuery(
  orderId: string,
  version: number,
  body: ChangePreviewBody | null,
) {
  return queryOptions({
    queryKey: ['outcome-change-preview', orderId, version, body],
    enabled: body !== null,
    placeholderData: keepPreviousData,
    queryFn: async (): Promise<OutcomeChangePreviewResult> => {
      const { data, error, response } = await api.POST(
        '/v1/admin/orders/{orderId}/outcome-change-preview',
        { params: { path: { orderId } }, body: body! },
      );
      if (data) return { status: 'preview', preview: data };
      const refusal = refusalOf(response.status, error);
      if (refusal) return { status: 'refused', refusal };
      throw new Error(`The preview failed with ${response.status}.`);
    },
  });
}

// What the change undoes, in the outcome's own sentences (the reversed
// entries signed back as the outcome in force posted them), and what it
// posts. The collection stays, so neither says what the captain collects.
export function changeLines(preview: OutcomeChangePreview): {
  undone: OutcomeLine[];
  posted: OutcomeLine[];
} {
  const signedBack = preview.reversed.map((entry) => ({
    ...entry,
    amount: {
      ...entry.amount,
      amount: entry.amount.amount.startsWith('-')
        ? entry.amount.amount.slice(1)
        : `-${entry.amount.amount}`,
    },
  }));
  return { undone: journalLines(signedBack), posted: journalLines(preview.entries) };
}

export type OutcomeChangeResult =
  { status: 'done' } | { status: 'refused'; refusal: OutcomeChangeRefusal };

// One Idempotency-Key per choice until an answer arrives (architecture §5.3).
export function useChangeOutcome(orderId: string) {
  const queryClient = useQueryClient();
  const keys = useRef(new Map<string, string>());
  return useMutation({
    mutationFn: async (body: ChangeBody): Promise<OutcomeChangeResult> => {
      const id = JSON.stringify(body);
      let key = keys.current.get(id);
      if (key === undefined) {
        key = crypto.randomUUID();
        keys.current.set(id, key);
      }
      const { data, error, response } = await api.POST(
        '/v1/admin/orders/{orderId}/outcome-change',
        { params: { path: { orderId }, header: { 'Idempotency-Key': key } }, body },
      );
      if (data) {
        keys.current.delete(id);
        return { status: 'done' };
      }
      const refusal = refusalOf(response.status, error);
      if (refusal) {
        keys.current.delete(id);
        return { status: 'refused', refusal };
      }
      throw new Error(`The outcome change failed with ${response.status}.`);
    },
    onSettled: () =>
      Promise.all([
        queryClient.invalidateQueries({ queryKey: ['order', orderId] }),
        queryClient.invalidateQueries({ queryKey: ['outcome-change-preview', orderId] }),
      ]),
  });
}
