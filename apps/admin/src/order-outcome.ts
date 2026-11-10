import type { components } from '@fox-drop/api-schema';
import { keepPreviousData, queryOptions, useMutation, useQueryClient } from '@tanstack/react-query';
import { useRef } from 'react';
import { api } from './api.js';
import { OPERATIONS_MANAGE } from './assign-captain.js';
import type { OrderDetail } from './order-detail.js';
import { type AdminSession, can } from './session.js';

type OutcomeBody = components['schemas']['AdminSetOutcomeDto'];
type PreviewBody = components['schemas']['AdminOutcomePreviewDto'];
export type OutcomePreview = components['schemas']['AdminOutcomePreviewAnswerDto_Output'];
export type Outcome = OutcomeBody['outcome'];
export type OutcomeParty = OutcomeBody['responsible'];
export type Food = NonNullable<OutcomeBody['food']>;
export type OutcomeChoices = NonNullable<OrderDetail['outcomeChoices']>;

// AP §9.3.2 «تحديد النتيجة»: OWN and OPS, while the order is picked up or
// arrived (the detail then carries the foods).
export function canSetOutcome(
  session: AdminSession | null | undefined,
  order: Pick<OrderDetail, 'outcomeChoices'>,
): order is { outcomeChoices: OutcomeChoices } {
  return can(session, OPERATIONS_MANAGE) && order.outcomeChoices !== null;
}

// AP §8.9, Appendix C: the outcomes «تحديد النتيجة» sets, in the spec's order.
export const OUTCOMES = [
  'free',
  'fake',
  'damaged',
  'wrong_refused',
  'failed_other',
] as const satisfies readonly Outcome[];

export interface OutcomeForm {
  outcome: Outcome | null;
  responsible: OutcomeParty | null;
  // A damaged order: «سُلّم بتخفيض» rather than failed.
  damagedDelivered: boolean;
  food: Food;
  // Operations' note, required (AP §9.3.2), never shown to the apps.
  reason: string;
}

export const emptyOutcome: OutcomeForm = {
  outcome: null,
  responsible: null,
  damagedDelivered: false,
  food: 'kept_by_captain',
  reason: '',
};

// AP §8.9: a fake order has the customer responsible, and only a fake one.
export function partiesFor(outcome: Outcome | null): readonly OutcomeParty[] {
  if (outcome === null) return [];
  return outcome === 'fake' ? ['customer'] : ['restaurant', 'captain', 'platform'];
}

// Free is delivered, damaged as chosen, the others failed.
export function deliveredFor(form: OutcomeForm): boolean {
  return form.outcome === 'free' || (form.outcome === 'damaged' && form.damagedDelivered);
}

// CA §9.12, K10: the foods a failed order offers; «أُعيد إلى المطعم» only
// with the restaurant responsible.
export function foodsFor(form: OutcomeForm, choices: OutcomeChoices) {
  return choices.foods.filter(
    (food) => food.code !== 'returned_to_restaurant' || form.responsible === 'restaurant',
  );
}

// The choices once an outcome and a fitting party are chosen; a food that no
// longer fits falls back to «يبقى مع الكابتن», the default.
export function outcomePreviewBody(form: OutcomeForm): PreviewBody | null {
  if (form.outcome === null || form.responsible === null) return null;
  if (!partiesFor(form.outcome).includes(form.responsible)) return null;
  const delivered = deliveredFor(form);
  const food =
    form.food === 'returned_to_restaurant' && form.responsible !== 'restaurant'
      ? 'kept_by_captain'
      : form.food;
  return {
    outcome: form.outcome,
    responsible: form.responsible,
    delivered,
    food: delivered ? null : food,
  };
}

// The body of a complete form, or null while a step is missing, with the
// order's version the preview was asked on (AP §8.9: the entries posted are
// the ones shown).
export function outcomeBody(form: OutcomeForm, version: number): OutcomeBody | null {
  const choices = outcomePreviewBody(form);
  const reason = form.reason.trim();
  return choices === null || reason === '' ? null : { ...choices, version, reason };
}

// The refusals the panel explains: the order moved on, the captain's vehicle
// has no rate in the pay table, the fixed dues rule has no amount, or the
// choices no longer fit.
export type OutcomeRefusal =
  'order_state_changed' | 'captain_pay_unset' | 'dues_rule_unset' | 'invalid_outcome';

const refusals: readonly string[] = [
  'order_state_changed',
  'captain_pay_unset',
  'dues_rule_unset',
  'invalid_outcome',
] satisfies OutcomeRefusal[];

function refusalOf(status: number, error: unknown): OutcomeRefusal | null {
  const refusal = (error as { error?: unknown } | undefined)?.error;
  return (status === 409 || status === 400) &&
    typeof refusal === 'string' &&
    refusals.includes(refusal)
    ? (refusal as OutcomeRefusal)
    : null;
}

export type OutcomePreviewResult =
  { status: 'preview'; preview: OutcomePreview } | { status: 'refused'; refusal: OutcomeRefusal };

// AP §8.9 «Preview»: asked again on each choice and on each new version of
// the order (an edit after the pickup), keeping the previous answer with the
// confirm off while the next one loads, as «إلغاء الطلب» does.
export function outcomePreviewQuery(orderId: string, version: number, body: PreviewBody | null) {
  return queryOptions({
    queryKey: ['outcome-preview', orderId, version, body],
    enabled: body !== null,
    placeholderData: keepPreviousData,
    queryFn: async (): Promise<OutcomePreviewResult> => {
      const { data, error, response } = await api.POST(
        '/v1/admin/orders/{orderId}/outcome-preview',
        { params: { path: { orderId } }, body: body! },
      );
      if (data) return { status: 'preview', preview: data };
      const refusal = refusalOf(response.status, error);
      if (refusal) return { status: 'refused', refusal };
      throw new Error(`The preview failed with ${response.status}.`);
    },
  });
}

export type OutcomeResult = { status: 'done' } | { status: 'refused'; refusal: OutcomeRefusal };

// One Idempotency-Key per choice until an answer arrives (architecture §5.3).
export function useSetOutcome(orderId: string) {
  const queryClient = useQueryClient();
  const keys = useRef(new Map<string, string>());
  return useMutation({
    mutationFn: async (body: OutcomeBody): Promise<OutcomeResult> => {
      const id = JSON.stringify(body);
      let key = keys.current.get(id);
      if (key === undefined) {
        key = crypto.randomUUID();
        keys.current.set(id, key);
      }
      const { data, error, response } = await api.POST('/v1/admin/orders/{orderId}/outcome', {
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
      throw new Error(`The outcome failed with ${response.status}.`);
    },
    onSettled: () =>
      Promise.all([
        queryClient.invalidateQueries({ queryKey: ['order', orderId] }),
        queryClient.invalidateQueries({ queryKey: ['orders-board'] }),
        queryClient.invalidateQueries({ queryKey: ['outcome-preview', orderId] }),
      ]),
  });
}

type Money = { amount: string; currency: string };

// One sentence of the preview in docs/domain/09's style («سيُعاد للكابتن …
// (عهدة) ويُقيَّد له أجر … (مستحقات). تُسجَّل عمولة … على المطعم. سيُحظر الزبون
// حتى دفع ….»), as a translation key and its values.
export type OutcomeLine =
  // The desk pays the captain back what the pickup took from the custody.
  | { key: 'custodyReimbursed'; name: string | null; amount: Money }
  | { key: 'commission'; name: string | null; amount: Money }
  | { key: 'commissionRestored'; name: string | null; amount: Money }
  | { key: 'merchantDebit'; name: string | null; amount: Money }
  | { key: 'merchantDebitReturned'; name: string | null; amount: Money }
  | { key: 'dues'; name: string | null; amount: Money }
  | { key: 'captainPay'; name: string | null; amount: Money; by: 'captainPay' | 'cost' | 'test' }
  | { key: 'captainCharge'; name: string | null; amount: Money; reason: string | null }
  | { key: 'captainChargeReturned'; name: string | null; amount: Money }
  | { key: 'platformCost'; amount: Money; test: boolean }
  | { key: 'platformCostReturned'; amount: Money }
  | { key: 'nothing' }
  // A journal the panel cannot name: the dialog refuses to confirm.
  | { key: 'unknown' };

type Entry = OutcomePreview['entries'][number];

const isCredit = (entry: Entry) => entry.amount.amount.startsWith('-');
const size = (entry: Entry): Money => ({
  ...entry.amount,
  amount: entry.amount.amount.replace(/^-/, ''),
});

// docs/domain/09: every entry the outcome posts, one sentence per journal,
// each naming an entry only when its sign is the sentence's; anything else
// is `unknown`. The order clearing account only carries each journal and
// nets to zero, so it is left out, as is the commission's revenue side.
// It first says what the desk pays the captain back: the pickup payment,
// which nothing collected offsets (AP §8.9 rule 1).
export function outcomeLines(
  preview: OutcomePreview,
  pickup: { captainName: string | null; payment: Money },
): OutcomeLine[] {
  const lines: OutcomeLine[] = [];
  // Rule 1: whatever the outcome, nothing collected leaves the custody short
  // by the pickup payment until the desk pays it back.
  lines.push({ key: 'custodyReimbursed', name: pickup.captainName, amount: pickup.payment });
  const journals = new Map<string, Entry[]>();
  // One journal per type and reason: a fee cut given back and the
  // captain's charge are two earn.charge journals.
  for (const entry of preview.entries) {
    const key = JSON.stringify([entry.type, entry.reason]);
    journals.set(key, [...(journals.get(key) ?? []), entry]);
  }
  for (const entries of journals.values()) {
    lines.push(journalLine(entries[0]!.type, entries) ?? { key: 'unknown' });
  }
  if (lines.length === 0) lines.push({ key: 'nothing' });
  return lines;
}

function journalLine(type: string, entries: Entry[]): OutcomeLine | null {
  const on = (account: string) => entries.filter((entry) => entry.account === account);
  const one = (account: string, credit: boolean) => {
    const found = on(account);
    return found.length === 1 && isCredit(found[0]!) === credit ? found[0]! : null;
  };
  switch (type) {
    case 'merchant.commission': {
      const merchant = one('merchant.account', false);
      if (!merchant) return null;
      // The restaurant responsible: the commission its own edits reversed
      // comes back (no commission is posted on the order, rule 2).
      return on('platform.order_clearing').length === 0
        ? { key: 'commissionRestored', name: merchant.party.name, amount: size(merchant) }
        : { key: 'commission', name: merchant.party.name, amount: size(merchant) };
    }
    case 'merchant.debit': {
      const merchant = on('merchant.account');
      if (merchant.length !== 1) return null;
      return isCredit(merchant[0]!)
        ? {
            key: 'merchantDebitReturned',
            name: merchant[0]!.party.name,
            amount: size(merchant[0]!),
          }
        : { key: 'merchantDebit', name: merchant[0]!.party.name, amount: size(merchant[0]!) };
    }
    case 'dues.charge': {
      const dues = one('customer.dues', false);
      return dues && { key: 'dues', name: dues.party.name, amount: size(dues) };
    }
    case 'earn.order_pay':
    case 'earn.waiting_pay': {
      const earnings = one('captain.earnings', true);
      const counter = (
        ['platform.captain_pay', 'platform.operating_cost', 'platform.test_cost'] as const
      )
        .map((account) => [account, one(account, false)] as const)
        .find(([, entry]) => entry !== null);
      if (!earnings || !counter) return null;
      const by =
        counter[0] === 'platform.captain_pay'
          ? 'captainPay'
          : counter[0] === 'platform.operating_cost'
            ? 'cost'
            : 'test';
      return { key: 'captainPay', name: earnings.party.name, amount: size(earnings), by };
    }
    case 'earn.charge': {
      const earnings = on('captain.earnings');
      if (earnings.length !== 1) return null;
      const entry = earnings[0]!;
      return isCredit(entry)
        ? { key: 'captainChargeReturned', name: entry.party.name, amount: size(entry) }
        : {
            key: 'captainCharge',
            name: entry.party.name,
            amount: size(entry),
            reason: entry.reason,
          };
    }
    case 'platform.operating_cost':
    case 'platform.test_cost': {
      const cost = on(type);
      if (cost.length !== 1) return null;
      return isCredit(cost[0]!)
        ? { key: 'platformCostReturned', amount: size(cost[0]!) }
        : { key: 'platformCost', amount: size(cost[0]!), test: type === 'platform.test_cost' };
    }
    default:
      return null;
  }
}
