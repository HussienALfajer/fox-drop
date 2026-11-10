import { useQuery } from '@tanstack/react-query';
import { type FormEvent, useId, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { formatMoney } from './format.js';
import { type OrderDetail, outcomeKeys, responsibleKeys } from './order-detail.js';
import {
  changeBody,
  changeFormOf,
  changeLines,
  changePreviewBody,
  collected,
  type OutcomeChange,
  type OutcomeChangeRefusal,
  outcomeChangePreviewQuery,
  outcomesFor,
  useChangeOutcome,
} from './order-outcome-change.js';
import { OutcomeSentence } from './order-outcome-page.js';
import { deliveredFor, foodsFor, type OutcomeForm, partiesFor } from './order-outcome.js';

// AP §8.9, §9.3.2 «تغيير النتيجة» (slice 2.11c): OWN changes the outcome in
// force, its party or where the food went, sees what the change undoes and
// posts (the same preview), and confirms with the required reason.
export function ChangeOutcome({
  orderId,
  version,
  current,
  choices,
  time,
}: {
  orderId: string;
  version: number;
  current: NonNullable<OrderDetail['outcome']>;
  choices: OutcomeChange;
  time: (iso: string) => string;
}) {
  const { t } = useTranslation();
  const title = useId();
  const [form, setForm] = useState<OutcomeForm>(() => changeFormOf(current));
  const set = (change: Partial<OutcomeForm>) => {
    const next = { ...form, ...change };
    const parties = partiesFor(next.outcome);
    if (next.responsible !== null && !parties.includes(next.responsible)) {
      next.responsible = parties.length === 1 ? parties[0]! : null;
    }
    if (next.outcome === 'fake') next.responsible = 'customer';
    if (next.food === 'returned_to_restaurant' && next.responsible !== 'restaurant') {
      next.food = 'kept_by_captain';
    }
    setForm(next);
  };
  const asked = changePreviewBody(form, current);
  const preview = useQuery(outcomeChangePreviewQuery(orderId, version, asked));
  const shown = preview.data?.status === 'preview' ? preview.data.preview : undefined;
  const lines = shown && changeLines(shown);
  const change = useChangeOutcome(orderId);
  const unknown =
    lines && [...lines.undone, ...lines.posted].some((line) => line.key === 'unknown');
  const body = unknown ? null : changeBody(form, current, version);
  const submit = (event: FormEvent) => {
    event.preventDefault();
    if (body) change.mutate(body);
  };
  const delivered = deliveredFor(form);
  return (
    <form onSubmit={submit} aria-labelledby={title} noValidate>
      <h3 id={title}>{t('order.changeOutcome.title')}</h3>
      <p>{t('order.changeOutcome.until', { time: time(choices.until) })}</p>
      {collected(current) && (
        <p>
          {t('order.changeOutcome.collected', { amount: formatMoney(current.amountToCollect) })}
        </p>
      )}
      <fieldset>
        <legend>{t('order.setOutcome.outcome')}</legend>
        {outcomesFor(current).map((outcome) => (
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
      {form.outcome === 'damaged' && !collected(current) && (
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
      <section aria-live="polite">
        <h4>{t('order.cancel.preview')}</h4>
        {asked === null && <p>{t('order.changeOutcome.pick')}</p>}
        {preview.isError && <p role="alert">{t('common.failed')}</p>}
        {preview.data?.status === 'refused' && (
          <p role="alert">{t(refusalKeys[preview.data.refusal])}</p>
        )}
        {lines && (
          <>
            <p>{t('order.changeOutcome.undone')}</p>
            <ul>
              {lines.undone.map((line, index) => (
                <li key={index}>
                  <OutcomeSentence line={line} />
                </li>
              ))}
            </ul>
            <p>{t('order.changeOutcome.posted')}</p>
            <ul>
              {lines.posted.map((line, index) => (
                <li key={index}>
                  <OutcomeSentence line={line} />
                </li>
              ))}
            </ul>
          </>
        )}
      </section>
      <label>
        {t('order.changeOutcome.reason')}
        <textarea
          required
          maxLength={500}
          value={form.reason}
          onChange={(event) => set({ reason: event.target.value })}
        />
      </label>
      <button
        type="submit"
        disabled={change.isPending || preview.isFetching || shown === undefined || body === null}
      >
        {t('order.changeOutcome.confirm')}
      </button>
      {change.isError && <p role="alert">{t('common.failed')}</p>}
      {change.data?.status === 'done' && <p role="status">{t('order.changeOutcome.done')}</p>}
      {change.data?.status === 'refused' && (
        <p role="alert">{t(refusalKeys[change.data.refusal])}</p>
      )}
    </form>
  );
}

const refusalKeys = {
  order_state_changed: 'order.onBehalf.stateChanged',
  outcome_change_closed: 'order.changeOutcome.closed',
  captain_pay_unset: 'order.setOutcome.captainPayUnset',
  dues_rule_unset: 'order.setOutcome.duesRuleUnset',
  invalid_outcome: 'order.onBehalf.refused',
} as const satisfies Record<OutcomeChangeRefusal, string>;
