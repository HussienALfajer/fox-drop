import { useQuery } from '@tanstack/react-query';
import { type FormEvent, useId, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { formatMoney } from './format.js';
import { responsibleKeys } from './order-detail.js';
import { OutcomeSentence } from './order-outcome-page.js';
import {
  resolveBody,
  SHORTFALL_PARTIES,
  type ShortfallParty,
  shortfallLines,
  shortfallPreviewQuery,
  useResolveShortfall,
} from './order-shortfall.js';

// AP §8.6 «حلّ النقص» (slice 2.20b): who bears the missing amount (the
// captain, the customer or the platform), the preview of its entry in the
// outcome dialog's sentences, asked again on each choice, then operations'
// required note and the confirm.
export function ResolveShortfall({
  orderId,
  version,
  amount,
}: {
  orderId: string;
  version: number;
  amount: { amount: string; currency: string };
}) {
  const { t } = useTranslation();
  const title = useId();
  const [responsible, setResponsible] = useState<ShortfallParty | null>(null);
  const [reason, setReason] = useState('');
  const preview = useQuery(shortfallPreviewQuery(orderId, version, responsible));
  const shown = preview.data?.status === 'preview' ? preview.data.preview : undefined;
  const lines = shown && shortfallLines(shown);
  const resolve = useResolveShortfall(orderId);
  const body = lines?.some((line) => line.key === 'unknown')
    ? null
    : resolveBody(responsible, reason);
  const submit = (event: FormEvent) => {
    event.preventDefault();
    if (body) resolve.mutate(body);
  };
  return (
    <form onSubmit={submit} aria-labelledby={title} noValidate>
      <h3 id={title}>{t('order.resolveShortfall.title')}</h3>
      <p>{t('order.resolveShortfall.amount', { amount: formatMoney(amount) })}</p>
      <fieldset>
        <legend>{t('order.setOutcome.responsible')}</legend>
        {SHORTFALL_PARTIES.map((party) => (
          <label key={party}>
            <input
              type="radio"
              name="shortfall-responsible"
              checked={responsible === party}
              onChange={() => setResponsible(party)}
            />
            {t(responsibleKeys[party])}
          </label>
        ))}
      </fieldset>
      <section aria-live="polite">
        <h4>{t('order.cancel.preview')}</h4>
        {responsible === null && <p>{t('order.resolveShortfall.pick')}</p>}
        {preview.isError && <p role="alert">{t('common.failed')}</p>}
        {preview.data?.status === 'refused' && (
          <p role="alert">{t('order.resolveShortfall.resolved')}</p>
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
          value={reason}
          onChange={(event) => setReason(event.target.value)}
        />
      </label>
      <button
        type="submit"
        disabled={resolve.isPending || preview.isFetching || shown === undefined || body === null}
      >
        {t('order.resolveShortfall.confirm')}
      </button>
      {resolve.isError && <p role="alert">{t('common.failed')}</p>}
      {resolve.data?.status === 'refused' && (
        <p role="alert">{t('order.resolveShortfall.resolved')}</p>
      )}
    </form>
  );
}
