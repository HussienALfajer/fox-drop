import { useQuery } from '@tanstack/react-query';
import { type FormEvent, useId, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { formatMoney } from './format.js';
import { cashKeys, responsibleKeys } from './order-detail.js';
import {
  type CancelChoices,
  type CancelForm,
  type CancelRefusal,
  cancelBody,
  cancelPreviewQuery,
  CASH_ANSWERS,
  type PreviewLine,
  previewBody,
  previewLines,
  RESPONSIBLE_PARTIES,
  useCancelOrder,
} from './order-cancel.js';

const empty: CancelForm = {
  cancellation: null,
  responsible: null,
  foodPrepared: false,
  compensateCaptain: false,
  cash: null,
  reason: '',
};

// AP §9.3.2 «إلغاء الطلب»: the reason, the responsible party, «تم تحضير
// الطعام؟» and «تعويض الكابتن» once accepted, the cash question once the
// captain reached the restaurant, and the preview of every entry (docs/domain
// 09), asked again on each choice, before operations' note and the confirm.
export function CancelOrder({
  orderId,
  status,
  choices,
}: {
  orderId: string;
  status: string;
  choices: CancelChoices;
}) {
  const { t } = useTranslation();
  const title = useId();
  const [form, setForm] = useState(empty);
  const placed = status === 'placed';
  const set = (change: Partial<CancelForm>) => setForm({ ...form, ...change });
  const asked = previewBody(form, placed);
  const preview = useQuery(cancelPreviewQuery(orderId, asked));
  const shown = preview.data?.status === 'preview' ? preview.data.preview : undefined;
  const lines = shown && previewLines(shown);
  const cancel = useCancelOrder(orderId);
  const body = lines?.some((line) => line.key === 'unknown')
    ? null
    : cancelBody(form, placed, shown);
  const submit = (event: FormEvent) => {
    event.preventDefault();
    if (body) cancel.mutate(body);
  };
  return (
    <form onSubmit={submit} aria-labelledby={title} noValidate>
      <h3 id={title}>{t('order.cancel.title')}</h3>
      <fieldset>
        <legend>{t('order.cancel.reasonList')}</legend>
        {choices.reasons.map((choice) => (
          <label key={choice.code}>
            <input
              type="radio"
              name="cancellation"
              checked={form.cancellation === choice.code}
              onChange={() => set({ cancellation: choice.code })}
            />
            {choice.label}
          </label>
        ))}
      </fieldset>
      <fieldset>
        <legend>{t('order.cancel.responsible')}</legend>
        {RESPONSIBLE_PARTIES.map((party) => (
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
      {!placed && (
        <label>
          <input
            type="checkbox"
            checked={form.foodPrepared}
            onChange={(event) => set({ foodPrepared: event.target.checked })}
          />
          {t('order.cancel.foodPrepared')}
        </label>
      )}
      {!placed && shown?.compensationAllowed && (
        <label>
          <input
            type="checkbox"
            checked={form.compensateCaptain}
            onChange={(event) => set({ compensateCaptain: event.target.checked })}
          />
          {t('order.cancel.compensateCaptain')}
        </label>
      )}
      {shown?.cashAsked && (
        <fieldset>
          <legend>{t('order.cancel.cashQuestion')}</legend>
          {shown.cashLines && (
            <p>
              {t('order.cancel.captainPaid', {
                lines: shown.cashLines.map(formatMoney).join(' + '),
              })}
            </p>
          )}
          {CASH_ANSWERS.map((answer) => (
            <label key={answer}>
              <input
                type="radio"
                name="cash"
                checked={form.cash === answer}
                onChange={() => set({ cash: answer })}
              />
              {t(cashKeys[answer])}
            </label>
          ))}
        </fieldset>
      )}
      <section aria-live="polite">
        <h4>{t('order.cancel.preview')}</h4>
        {asked === null && <p>{t('order.cancel.pickResponsible')}</p>}
        {preview.isError && <p role="alert">{t('common.failed')}</p>}
        {preview.data?.status === 'refused' && (
          <p role="alert">{t(refusalKeys[preview.data.refusal])}</p>
        )}
        {lines && (
          <ul>
            {lines.map((line, index) => (
              <li key={index}>
                <PreviewSentence line={line} />
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
      <button type="submit" disabled={cancel.isPending || preview.isFetching || body === null}>
        {t('order.cancel.confirm')}
      </button>
      {cancel.isError && <p role="alert">{t('common.failed')}</p>}
      {cancel.data?.status === 'refused' && (
        <p role="alert">{t(refusalKeys[cancel.data.refusal])}</p>
      )}
    </form>
  );
}

const refusalKeys = {
  order_state_changed: 'order.onBehalf.stateChanged',
  captain_pay_unset: 'order.cancel.captainPayUnset',
  unknown_reason: 'order.onBehalf.refused',
  invalid_cancellation: 'order.onBehalf.refused',
  compensation_not_allowed: 'order.onBehalf.refused',
  cash_answer_required: 'order.onBehalf.refused',
  cash_answer_not_allowed: 'order.onBehalf.refused',
} as const satisfies Record<CancelRefusal, string>;

function PreviewSentence({ line }: { line: PreviewLine }) {
  const { t } = useTranslation();
  // A party the server could not name shows by its kind.
  const restaurant = 'name' in line ? (line.name ?? t('order.restaurant')) : '';
  const captain = 'name' in line ? (line.name ?? t('order.captain')) : '';
  switch (line.key) {
    case 'merchantCredit':
      return t('order.cancel.entry.merchantCredit', {
        name: restaurant,
        amount: formatMoney(line.amount),
      });
    case 'platformCost':
      return t('order.cancel.entry.platformCost', { amount: formatMoney(line.amount) });
    case 'captainPay':
      return t(
        line.testCost ? 'order.cancel.entry.captainPayTest' : 'order.cancel.entry.captainPay',
        { name: captain, amount: formatMoney(line.amount) },
      );
    case 'captainCustody':
      return t('order.cancel.entry.captainCustody', {
        name: captain,
        amount: line.amounts.map(formatMoney).join(' + '),
      });
    case 'merchantDebit':
      return t('order.cancel.entry.merchantDebit', {
        name: restaurant,
        amount: formatMoney(line.amount),
      });
    case 'strike':
      return t('order.cancel.entry.strike');
    case 'nothing':
      return t('order.cancel.entry.nothing');
    case 'unknown':
      return t('order.cancel.entry.unknown');
  }
}
