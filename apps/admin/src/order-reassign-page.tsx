import { useQuery } from '@tanstack/react-query';
import { useNavigate } from '@tanstack/react-router';
import { type FormEvent, useId, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { formatMoney } from './format.js';
import { CASH_ANSWERS, previewLines } from './order-cancel.js';
import { PreviewSentence } from './order-cancel-page.js';
import { cashKeys } from './order-detail.js';
import {
  chooseReason,
  type Next,
  reassignBody,
  reassignPreviewQuery,
  type ReassignChoices,
  type ReassignForm,
  type ReassignRefusal,
  useReassignOrder,
} from './order-reassign.js';

const empty: ReassignForm = {
  reassignment: null,
  captainFault: null,
  cash: null,
  next: 'dispatch',
  reason: '',
};

// AP §9.3.2 «سحب وإعادة تعيين»: the reason with its fault prefilled, the cash
// question once the captain reached the restaurant with the preview of what
// it posts, operations' note, then back to dispatch or the picker.
export function ReassignOrder({
  orderId,
  version,
  choices,
  cannotComplete,
  emergency,
}: {
  orderId: string;
  version: number;
  choices: ReassignChoices;
  // CA §9.11: the captain's «لا أستطيع إكمال الطلب» is open.
  cannotComplete: boolean;
  // CA §9.11 (slice 2.13c): the captain's «طوارئ» is open.
  emergency: boolean;
}) {
  const { t } = useTranslation();
  const title = useId();
  const navigate = useNavigate();
  const [form, setForm] = useState(empty);
  const set = (change: Partial<ReassignForm>) => setForm({ ...form, ...change });
  const preview = useQuery(reassignPreviewQuery(orderId, version, form.cash));
  const shown = preview.data?.status === 'preview' ? preview.data.preview : undefined;
  const lines = shown && previewLines(shown);
  const reassign = useReassignOrder(orderId);
  const body = lines?.some((line) => line.key === 'unknown') ? null : reassignBody(form, shown);
  const submit = (event: FormEvent) => {
    event.preventDefault();
    if (!body) return;
    reassign.mutate(body, {
      onSuccess: (result) => {
        if (result.status === 'done' && form.next === 'pick') {
          void navigate({ to: '/orders/$orderId/assign', params: { orderId }, search: true });
        }
      },
    });
  };
  return (
    <form onSubmit={submit} aria-labelledby={title} noValidate>
      <h3 id={title}>{t('order.reassign.title')}</h3>
      <fieldset>
        <legend>{t('order.reassign.reasonList')}</legend>
        {choices.reasons.map((choice) => (
          <label key={choice.code}>
            <input
              type="radio"
              name="reassignment"
              checked={form.reassignment === choice.code}
              onChange={() =>
                setForm(chooseReason(form, choices, choice.code, cannotComplete, emergency))
              }
            />
            {choice.label}
          </label>
        ))}
      </fieldset>
      {form.captainFault !== null && (
        <fieldset>
          <legend>{t('order.reassign.fault')}</legend>
          <label>
            <input
              type="radio"
              name="captainFault"
              checked={form.captainFault}
              onChange={() => set({ captainFault: true })}
            />
            {t('order.reassign.captainFault')}
          </label>
          <label>
            <input
              type="radio"
              name="captainFault"
              checked={!form.captainFault}
              onChange={() => set({ captainFault: false })}
            />
            {t('order.reassign.noFault')}
          </label>
        </fieldset>
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
        {preview.isError && <p role="alert">{t('common.failed')}</p>}
        {preview.data?.status === 'refused' && (
          <p role="alert">{t(refusalKeys[preview.data.refusal])}</p>
        )}
        {lines && (
          <ul>
            {lines.map((line, index) => (
              <li key={index}>
                {line.key === 'nothing' ? (
                  t('order.reassign.nothing')
                ) : (
                  <PreviewSentence line={line} />
                )}
              </li>
            ))}
          </ul>
        )}
      </section>
      <fieldset>
        <legend>{t('order.reassign.next')}</legend>
        {(['dispatch', 'pick'] as const satisfies readonly Next[]).map((next) => (
          <label key={next}>
            <input
              type="radio"
              name="next"
              checked={form.next === next}
              onChange={() => set({ next })}
            />
            {t(nextKeys[next])}
          </label>
        ))}
      </fieldset>
      <label>
        {t('order.onBehalf.reason')}
        <textarea
          required
          maxLength={500}
          value={form.reason}
          onChange={(event) => set({ reason: event.target.value })}
        />
      </label>
      <button type="submit" disabled={reassign.isPending || preview.isFetching || body === null}>
        {t('order.reassign.confirm')}
      </button>
      {reassign.isError && <p role="alert">{t('common.failed')}</p>}
      {reassign.data?.status === 'refused' && (
        <p role="alert">{t(refusalKeys[reassign.data.refusal])}</p>
      )}
    </form>
  );
}

const nextKeys = {
  dispatch: 'order.reassign.toDispatch',
  pick: 'order.reassign.pickCaptain',
} as const satisfies Record<Next, string>;

const refusalKeys = {
  order_state_changed: 'order.onBehalf.stateChanged',
  pickup_request_open: 'order.reassign.pickupRequestOpen',
  unknown_reason: 'order.onBehalf.refused',
  cash_answer_required: 'order.onBehalf.refused',
  cash_answer_not_allowed: 'order.onBehalf.refused',
} as const satisfies Record<ReassignRefusal, string>;
