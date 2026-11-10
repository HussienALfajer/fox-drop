import { useQuery } from '@tanstack/react-query';
import { type FormEvent, useId, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { formatMoney } from './format.js';
import { outcomeKeys, responsibleKeys } from './order-detail.js';
import {
  deliveredFor,
  emptyOutcome,
  foodsFor,
  type OutcomeChoices,
  type OutcomeForm,
  type OutcomeLine,
  type OutcomeRefusal,
  outcomeBody,
  outcomeLines,
  outcomePreviewBody,
  outcomePreviewQuery,
  OUTCOMES,
  partiesFor,
  useSetOutcome,
} from './order-outcome.js';

// AP §9.3.2 «تحديد النتيجة» (slice 2.11a): the outcome, the responsible party
// (the customer for a fake order only), whether a damaged order was
// delivered, where a failed order's food went, the preview of every entry
// (docs/domain/09), asked again on each choice, then operations' note and the
// confirm. Nothing is collected yet (slice 2.11b).
export function SetOutcome({
  orderId,
  version,
  choices,
  pickup,
}: {
  orderId: string;
  version: number;
  choices: OutcomeChoices;
  pickup: { captainName: string | null; payment: { amount: string; currency: string } };
}) {
  const { t } = useTranslation();
  const title = useId();
  const [form, setForm] = useState<OutcomeForm>(emptyOutcome);
  const set = (change: Partial<OutcomeForm>) => {
    const next = { ...form, ...change };
    // A fake order takes the customer; another outcome never does.
    const parties = partiesFor(next.outcome);
    if (next.responsible !== null && !parties.includes(next.responsible)) {
      next.responsible = parties.length === 1 ? parties[0]! : null;
    }
    if (next.outcome === 'fake') next.responsible = 'customer';
    // A food the party no longer allows falls back to the default (K10).
    if (next.food === 'returned_to_restaurant' && next.responsible !== 'restaurant') {
      next.food = 'kept_by_captain';
    }
    setForm(next);
  };
  const asked = outcomePreviewBody(form);
  const preview = useQuery(outcomePreviewQuery(orderId, version, asked));
  const shown = preview.data?.status === 'preview' ? preview.data.preview : undefined;
  const lines = shown && outcomeLines(shown, pickup);
  const setOutcome = useSetOutcome(orderId);
  const body = lines?.some((line) => line.key === 'unknown') ? null : outcomeBody(form, version);
  const submit = (event: FormEvent) => {
    event.preventDefault();
    if (body) setOutcome.mutate(body);
  };
  const delivered = deliveredFor(form);
  return (
    <form onSubmit={submit} aria-labelledby={title} noValidate>
      <h3 id={title}>{t('order.setOutcome.title')}</h3>
      <fieldset>
        <legend>{t('order.setOutcome.outcome')}</legend>
        {OUTCOMES.map((outcome) => (
          <label key={outcome}>
            <input
              type="radio"
              name="outcome"
              checked={form.outcome === outcome}
              onChange={() => set({ outcome })}
            />
            {t(outcomeKeys[outcome])}
          </label>
        ))}
      </fieldset>
      {form.outcome === 'damaged' && (
        <label>
          <input
            type="checkbox"
            checked={form.damagedDelivered}
            onChange={(event) => set({ damagedDelivered: event.target.checked })}
          />
          {t('order.setOutcome.damagedDelivered')}
        </label>
      )}
      {form.outcome !== null && (
        <fieldset>
          <legend>{t('order.setOutcome.responsible')}</legend>
          {partiesFor(form.outcome).map((party) => (
            <label key={party}>
              <input
                type="radio"
                name="responsible"
                checked={form.responsible === party}
                onChange={() => set({ responsible: party })}
              />
              {t(responsibleKeys[party])}
            </label>
          ))}
        </fieldset>
      )}
      {form.outcome !== null && !delivered && (
        <fieldset>
          <legend>{t('order.setOutcome.food')}</legend>
          {foodsFor(form, choices).map((food) => (
            <label key={food.code}>
              <input
                type="radio"
                name="food"
                checked={form.food === food.code}
                onChange={() => set({ food: food.code })}
              />
              {food.label}
            </label>
          ))}
        </fieldset>
      )}
      <p>{t('order.setOutcome.nothingToCollect')}</p>
      <section aria-live="polite">
        <h4>{t('order.cancel.preview')}</h4>
        {asked === null && <p>{t('order.setOutcome.pick')}</p>}
        {preview.isError && <p role="alert">{t('common.failed')}</p>}
        {preview.data?.status === 'refused' && (
          <p role="alert">{t(refusalKeys[preview.data.refusal])}</p>
        )}
        {lines && (
          <ul>
            {lines.map((line, index) => (
              <li key={index}>
                <OutcomeSentence line={line} />
              </li>
            ))}
          </ul>
        )}
      </section>
      <label>
        {t('order.onBehalf.reason')}
        <textarea
          required
          maxLength={500}
          value={form.reason}
          onChange={(event) => set({ reason: event.target.value })}
        />
      </label>
      <button
        type="submit"
        disabled={
          setOutcome.isPending || preview.isFetching || shown === undefined || body === null
        }
      >
        {t('order.setOutcome.confirm')}
      </button>
      {setOutcome.isError && <p role="alert">{t('common.failed')}</p>}
      {setOutcome.data?.status === 'refused' && (
        <p role="alert">{t(refusalKeys[setOutcome.data.refusal])}</p>
      )}
    </form>
  );
}

const refusalKeys = {
  order_state_changed: 'order.onBehalf.stateChanged',
  captain_pay_unset: 'order.setOutcome.captainPayUnset',
  dues_rule_unset: 'order.setOutcome.duesRuleUnset',
  invalid_outcome: 'order.onBehalf.refused',
} as const satisfies Record<OutcomeRefusal, string>;

function OutcomeSentence({ line }: { line: OutcomeLine }) {
  const { t } = useTranslation();
  // A party the server could not name shows by its kind.
  const name = 'name' in line ? line.name : null;
  const captain = name ?? t('order.captain');
  const restaurant = name ?? t('order.restaurant');
  const customer = name ?? t('order.customer');
  switch (line.key) {
    case 'custodyReimbursed':
      return t('order.setOutcome.entry.custodyReimbursed', {
        name: captain,
        amount: formatMoney(line.amount),
      });
    case 'commission':
      return t('order.setOutcome.entry.commission', {
        name: restaurant,
        amount: formatMoney(line.amount),
      });
    case 'commissionRestored':
      return t('order.setOutcome.entry.commissionRestored', {
        name: restaurant,
        amount: formatMoney(line.amount),
      });
    case 'merchantDebitReturned':
      return t('order.setOutcome.entry.merchantDebitReturned', {
        name: restaurant,
        amount: formatMoney(line.amount),
      });
    case 'merchantDebit':
      return t('order.setOutcome.entry.merchantDebit', {
        name: restaurant,
        amount: formatMoney(line.amount),
      });
    case 'dues':
      return t('order.setOutcome.entry.dues', {
        name: customer,
        amount: formatMoney(line.amount),
      });
    case 'captainPay':
      return t(payKeys[line.by], { name: captain, amount: formatMoney(line.amount) });
    case 'captainCharge':
      return t('order.setOutcome.entry.captainCharge', {
        name: captain,
        amount: formatMoney(line.amount),
        reason: line.reason ?? '',
      });
    case 'captainChargeReturned':
      return t('order.setOutcome.entry.captainChargeReturned', {
        name: captain,
        amount: formatMoney(line.amount),
      });
    case 'platformCost':
      return t(line.test ? 'order.setOutcome.entry.testCost' : 'order.cancel.entry.platformCost', {
        amount: formatMoney(line.amount),
      });
    case 'platformCostReturned':
      return t('order.setOutcome.entry.platformCostReturned', { amount: formatMoney(line.amount) });
    case 'nothing':
      return t('order.setOutcome.entry.nothing');
    case 'unknown':
      return t('order.cancel.entry.unknown');
  }
}

const payKeys = {
  captainPay: 'order.setOutcome.entry.captainPay',
  cost: 'order.cancel.entry.captainPay',
  test: 'order.cancel.entry.captainPayTest',
} as const;
