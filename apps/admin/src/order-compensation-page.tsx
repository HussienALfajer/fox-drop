import { type FormEvent, useId, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { formatDateTime, formatMoney } from './format.js';
import {
  type CompensateRefusal,
  type Compensation,
  emptyValue,
  needsApproval,
  type OrderCompensations,
  useCompensate,
  useOrderCompensations,
  type ValueForm,
  valueOf,
  type ValueProblem,
  valueParts,
} from './order-compensation.js';

const statusKeys = {
  issued: 'compensation.status.issued',
  waiting: 'compensation.status.waiting',
  rejected: 'compensation.status.rejected',
} as const satisfies Record<Compensation['status'], string>;

const problemKeys = {
  amount: 'compensation.problem.amount',
  percent: 'compensation.problem.percent',
  maxDiscount: 'compensation.problem.maxDiscount',
} as const satisfies Record<ValueProblem, string>;

const refusalKeys = {
  invalid_value: 'compensation.refusal.invalidValue',
  unknown_reason: 'compensation.refusal.unknownReason',
  reason_note_required: 'compensation.refusal.noteRequired',
  reason_note_not_allowed: 'compensation.refusal.noteNotAllowed',
  unknown_order: 'compensation.refusal.unknownOrder',
  no_base_currency: 'compensation.refusal.noBaseCurrency',
  currency_changed: 'compensation.refusal.currencyChanged',
} as const satisfies Record<CompensateRefusal, string>;

// A compensation's value: «25.00 ₺» or «20% بحد أقصى 50.00 ₺».
export function CompensationValueText({ compensation }: { compensation: Compensation }) {
  const { t } = useTranslation();
  const parts = valueParts(compensation);
  return (
    <>
      {parts.kind === 'fixed_amount'
        ? parts.amount
        : t('compensation.percentValue', { percent: parts.percent, max: parts.max })}
    </>
  );
}

// AP §9.3.2 «تعويض الزبون», §6.4 (slice 2.22a): the order's compensations
// and, for operations.compensate, a next-order code within the admin's
// cumulative cap, or a request OWN approves. Unstyled until the design.
export function OrderCompensations({ orderId, timeZone }: { orderId: string; timeZone: string }) {
  const { t } = useTranslation();
  const time = (at: string) => formatDateTime(at, timeZone);
  const read = useOrderCompensations(orderId);
  if (read.isError) return <p role="alert">{t('common.failed')}</p>;
  if (!read.data) return null;
  const data = read.data;
  return (
    <section aria-label={t('compensation.title')}>
      <h3>{t('compensation.title')}</h3>
      {data.compensations.length === 0 ? (
        <p>{t('compensation.none')}</p>
      ) : (
        <ul>
          {data.compensations.map((each) => (
            <li key={each.id}>
              <CompensationValueText compensation={each} /> {t(statusKeys[each.status])}{' '}
              {t('compensation.reason', { reason: each.reason.label })}
              {each.note && <> {t('compensation.note', { note: each.note })}</>}{' '}
              {t('compensation.requested', {
                name: each.requestedBy ?? t('compensation.unnamed'),
                time: time(each.requestedAt),
              })}
              {each.code && each.codeValidTo && (
                <> {t('compensation.code', { code: each.code, time: time(each.codeValidTo) })}</>
              )}
            </li>
          ))}
        </ul>
      )}
      {data.canCompensate && <CompensateForm key={orderId} orderId={orderId} data={data} />}
    </section>
  );
}

function CompensateForm({ orderId, data }: { orderId: string; data: OrderCompensations }) {
  const { t } = useTranslation();
  const title = useId();
  const [form, setForm] = useState<ValueForm>(emptyValue);
  const [reason, setReason] = useState('');
  const [note, setNote] = useState('');
  const compensate = useCompensate(orderId);
  const checked = valueOf(form, data.currency);
  const value = 'value' in checked ? checked.value : null;
  const touched = form.amount !== '' || form.percent !== '' || form.maxDiscount !== '';
  const set = (change: Partial<ValueForm>) => setForm({ ...form, ...change });
  const submit = (event: FormEvent) => {
    event.preventDefault();
    if (!value || reason === '') return;
    const trimmed = note.trim();
    compensate.mutate(
      { value, reason: { code: reason, note: trimmed === '' ? null : trimmed } },
      {
        onSuccess: (result) => {
          if (result.status !== 'done') return;
          setForm(emptyValue);
          setReason('');
          setNote('');
        },
      },
    );
  };
  const result = compensate.data;
  return (
    <form onSubmit={submit} aria-labelledby={title} noValidate>
      <h4 id={title}>{t('compensation.give')}</h4>
      <p>
        {data.capLeft === null
          ? t('compensation.noCap')
          : t('compensation.capLeft', {
              amount: formatMoney({ amount: data.capLeft, currency: data.currency }),
            })}
      </p>
      <fieldset>
        <legend>{t('compensation.kind')}</legend>
        <label>
          <input
            type="radio"
            name="kind"
            checked={form.kind === 'fixed_amount'}
            onChange={() => set({ kind: 'fixed_amount' })}
          />
          {t('compensation.kindAmount')}
        </label>
        <label>
          <input
            type="radio"
            name="kind"
            checked={form.kind === 'percentage'}
            onChange={() => set({ kind: 'percentage' })}
          />
          {t('compensation.kindPercent')}
        </label>
      </fieldset>
      {form.kind === 'fixed_amount' ? (
        <label>
          {t('compensation.amount', { currency: data.currency })}
          <input
            inputMode="decimal"
            value={form.amount}
            onChange={(event) => set({ amount: event.target.value })}
          />
        </label>
      ) : (
        <>
          <label>
            {t('compensation.percent')}
            <input
              inputMode="decimal"
              value={form.percent}
              onChange={(event) => set({ percent: event.target.value })}
            />
          </label>
          <label>
            {t('compensation.maxDiscount', { currency: data.currency })}
            <input
              inputMode="decimal"
              value={form.maxDiscount}
              onChange={(event) => set({ maxDiscount: event.target.value })}
            />
          </label>
        </>
      )}
      {touched && 'problem' in checked && <p role="alert">{t(problemKeys[checked.problem])}</p>}
      {value && needsApproval(value, data.capLeft) && (
        <p role="status">{t('compensation.aboveCap')}</p>
      )}
      <label>
        {t('compensation.reasonField')}
        <select value={reason} onChange={(event) => setReason(event.target.value)}>
          <option value="">{t('compensation.chooseReason')}</option>
          {data.reasons.map((each) => (
            <option key={each.code} value={each.code}>
              {each.label}
            </option>
          ))}
        </select>
      </label>
      <label>
        {t('compensation.noteField')}
        <textarea maxLength={300} value={note} onChange={(event) => setNote(event.target.value)} />
      </label>
      <button type="submit" disabled={compensate.isPending || !value || reason === ''}>
        {value && needsApproval(value, data.capLeft)
          ? t('compensation.ask')
          : t('compensation.confirm')}
      </button>
      {compensate.isError && <p role="alert">{t('common.failed')}</p>}
      {result?.status === 'refused' && <p role="alert">{t(refusalKeys[result.refusal])}</p>}
      {result?.status === 'done' && (
        <p role="status">
          {result.compensation.status === 'issued'
            ? t('compensation.issued', { code: result.compensation.code ?? '' })
            : t('compensation.sentForApproval')}
        </p>
      )}
    </form>
  );
}
