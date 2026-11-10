import { type FormEvent, useId, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { useReasonLists } from './content.js';
import { formatMoney } from './format.js';
import {
  emptyOutcomePayment,
  type OutcomePaymentForm,
  type OutcomePaymentRefusal,
  outcomePaymentBody,
  useRecordOutcomePayment,
} from './order-outcome-payment.js';

// AP §9.3.2, CA §9.10 (K9, slice 2.11b): the payment of an outcome's amount
// to collect, entered by operations for a captain who cannot: what was
// received and given back in the base currency, the shortfall's reason once
// the server finds one (K16, Content's shortfall list), and the reason.
export function RecordOutcomePayment({
  orderId,
  due,
}: {
  orderId: string;
  due: { amount: string; currency: string };
}) {
  const { t } = useTranslation();
  const title = useId();
  const [form, setForm] = useState<OutcomePaymentForm>(emptyOutcomePayment);
  const set = (change: Partial<OutcomePaymentForm>) => setForm({ ...form, ...change });
  const record = useRecordOutcomePayment(orderId);
  const refused = record.data?.status === 'refused' ? record.data : null;
  const asksReason = refused?.refusal === 'shortfall_reason_required' || form.shortfall !== null;
  const lists = useReasonLists();
  const reasons =
    lists.data
      ?.find((list) => list.list === 'shortfall')
      ?.reasons.filter((reason) => reason.active) ?? [];
  const chosen = reasons.find((reason) => reason.code === form.shortfall);
  const body = outcomePaymentBody(form, due);
  const typed = form.received.trim() !== '' && body === null && form.reason.trim() !== '';
  const submit = (event: FormEvent) => {
    event.preventDefault();
    if (body) record.mutate(body);
  };
  return (
    <form onSubmit={submit} aria-labelledby={title} noValidate>
      <h3 id={title}>{t('order.outcomePayment.title')}</h3>
      <p>{t('order.outcomePayment.due', { amount: formatMoney(due) })}</p>
      <label>
        {t('order.outcomePayment.received', { currency: due.currency })}
        <input
          inputMode="decimal"
          value={form.received}
          onChange={(event) => set({ received: event.target.value })}
        />
      </label>
      <label>
        {t('order.outcomePayment.change', { currency: due.currency })}
        <input
          inputMode="decimal"
          value={form.change}
          onChange={(event) => set({ change: event.target.value })}
        />
      </label>
      {typed && <p role="alert">{t('order.outcomePayment.invalid')}</p>}
      {asksReason && (
        <fieldset>
          <legend>
            {refused?.shortfall
              ? t('order.outcomePayment.shortBy', { amount: formatMoney(refused.shortfall) })
              : t('order.outcomePayment.shortBy', { amount: '' })}
          </legend>
          {reasons.map((reason) => (
            <label key={reason.code}>
              <input
                type="radio"
                name="shortfall"
                checked={form.shortfall === reason.code}
                onChange={() => set({ shortfall: reason.code })}
              />
              {reason.label}
            </label>
          ))}
          {chosen && chosen.note !== 'none' && (
            <label>
              {t('order.outcomePayment.shortfallNote')}
              <input
                maxLength={200}
                value={form.shortfallNote}
                onChange={(event) => set({ shortfallNote: event.target.value })}
              />
            </label>
          )}
        </fieldset>
      )}
      <label>
        {t('order.onBehalf.reason')}
        <textarea
          required
          maxLength={500}
          value={form.reason}
          onChange={(event) => set({ reason: event.target.value })}
        />
      </label>
      <button type="submit" disabled={record.isPending || body === null}>
        {t('order.outcomePayment.confirm')}
      </button>
      {record.isError && <p role="alert">{t('common.failed')}</p>}
      {refused && refused.refusal !== 'shortfall_reason_required' && (
        <p role="alert">{t(refusalKeys[refused.refusal])}</p>
      )}
    </form>
  );
}

const refusalKeys = {
  order_state_changed: 'order.onBehalf.stateChanged',
  amount_due_changed: 'order.outcomePayment.amountDueChanged',
  overpaid: 'order.outcomePayment.overpaid',
  invalid_lines: 'order.outcomePayment.refused',
  unknown_reason: 'order.outcomePayment.refused',
  reason_note_required: 'order.outcomePayment.refused',
  reason_note_not_allowed: 'order.outcomePayment.refused',
} as const satisfies Record<Exclude<OutcomePaymentRefusal, 'shortfall_reason_required'>, string>;
