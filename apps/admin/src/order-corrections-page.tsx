import { useQuery } from '@tanstack/react-query';
import { useState } from 'react';
import { useTranslation } from 'react-i18next';
import { formatDateTime, formatMoney } from './format.js';
import { accountKeys, directionKeys, partyKeys, typeKeyOf } from './manual-entries.js';
import {
  type CorrectionAccount,
  type CorrectionForm,
  correctionBody,
  type CorrectionResult,
  orderCorrectionsQuery,
  useCorrectOrder,
} from './order-corrections.js';

const refusalKeys = {
  order_not_finished: 'orderCorrections.refused.notFinished',
  not_order_party: 'orderCorrections.refused.notOrderParty',
  invalid_amounts: 'manualEntries.refusal.invalidAmounts',
  invalid_currency: 'manualEntries.refusal.invalidCurrency',
  invalid_account: 'manualEntries.refusal.invalidAccount',
  reason_required: 'manualEntries.refusal.reasonRequired',
  unknown_party: 'manualEntries.refusal.unknownParty',
  no_base_currency: 'manualEntries.refusal.noBaseCurrency',
} as const;

// AP §9.5 «تصحيح مالي» (slice 2.40): the finished order's corrections, and
// for OWN and FIN a manual entry on an account of its restaurant, customer
// or a captain who held it, with a reason. Each also shows in «القيود
// التصحيحية», where it can be reversed.
export function OrderCorrections({ orderId, timeZone }: { orderId: string; timeZone: string }) {
  const { t } = useTranslation();
  const read = useQuery(orderCorrectionsQuery(orderId));
  if (read.isError) return <p role="alert">{t('common.failed')}</p>;
  if (!read.data) return null;
  const { entries, canCorrect, accounts, finished } = read.data;
  if (!finished) return null;
  return (
    <section aria-labelledby="order-corrections">
      <h3 id="order-corrections">{t('orderCorrections.title')}</h3>
      {entries.length === 0 ? (
        <p>{t('orderCorrections.empty')}</p>
      ) : (
        <ul>
          {entries.map((entry) => (
            <li key={entry.id}>
              {t('orderCorrections.entry', {
                type: t(typeKeyOf(entry.journal.type)),
                party: entry.partyName,
                amounts: entry.journal.lines.map((line) => formatMoney(line)).join(' + '),
              })}{' '}
              {t('manualEntries.reason', { reason: entry.reason })}{' '}
              {t('manualEntries.by', {
                name: entry.adminName ?? t('manualEntries.noName'),
                at: formatDateTime(entry.createdAt, timeZone),
              })}
              {entry.reversedBy &&
                ` ${t('manualEntries.reversedAt', { at: formatDateTime(entry.reversedBy.at, timeZone) })}`}
            </li>
          ))}
        </ul>
      )}
      {canCorrect && accounts.length > 0 && (
        <CorrectionDialog key={orderId} orderId={orderId} accounts={accounts} />
      )}
    </section>
  );
}

function CorrectionDialog({
  orderId,
  accounts,
}: {
  orderId: string;
  accounts: CorrectionAccount[];
}) {
  const { t } = useTranslation();
  const correct = useCorrectOrder(orderId);
  const [open, setOpen] = useState(false);
  const [reviewed, setReviewed] = useState(false);
  const [form, setForm] = useState<CorrectionForm>({
    choice: 0,
    currency: accounts[0]!.currencies[0] ?? '',
    direction: 'up',
    amount: '',
    reason: '',
  });
  const account = accounts[form.choice]!;
  const body = correctionBody(accounts, form);
  const result: CorrectionResult | undefined = correct.data;
  const change = (next: Partial<CorrectionForm>) => {
    setReviewed(false);
    setForm((before) => ({ ...before, ...next }));
  };
  if (!open) {
    return (
      <>
        {result?.status === 'posted' && <p role="status">{t('manualEntries.posted')}</p>}
        <button type="button" onClick={() => setOpen(true)}>
          {t('orderCorrections.open')}
        </button>
      </>
    );
  }
  return (
    <fieldset>
      <legend>{t('orderCorrections.open')}</legend>
      <label>
        {t('manualEntries.accountLabel')}
        <select
          value={form.choice}
          onChange={(event) => {
            const choice = Number(event.target.value);
            change({ choice, currency: accounts[choice]!.currencies[0] ?? '' });
          }}
        >
          {accounts.map((each, index) => (
            <option key={each.partyId + each.account} value={index}>
              {t('orderCorrections.account', {
                party: t(partyKeys[each.partyKind]),
                name: each.partyName,
                account: t(accountKeys[each.account]),
              })}
            </option>
          ))}
        </select>
      </label>
      <label>
        {t('manualEntries.currency')}
        <select
          value={form.currency}
          onChange={(event) => change({ currency: event.target.value })}
        >
          {account.currencies.map((currency) => (
            <option key={currency} value={currency}>
              {currency}
            </option>
          ))}
        </select>
      </label>
      {(['up', 'down'] as const).map((direction) => (
        <label key={direction}>
          <input
            type="radio"
            name="correction-direction"
            checked={form.direction === direction}
            onChange={() => change({ direction })}
          />
          {t(directionKeys[account.account][direction])}
        </label>
      ))}
      <label>
        {t('manualEntries.amount')}
        <input
          inputMode="decimal"
          value={form.amount}
          onChange={(event) => change({ amount: event.target.value })}
        />
      </label>
      <label>
        {t('manualEntries.reasonLabel')}
        <textarea
          value={form.reason}
          maxLength={500}
          onChange={(event) => change({ reason: event.target.value })}
        />
      </label>
      {result?.status === 'refused' && <p role="alert">{t(refusalKeys[result.refusal])}</p>}
      {correct.isError && <p role="alert">{t('common.failed')}</p>}
      {!reviewed ? (
        <button type="button" disabled={body === null} onClick={() => setReviewed(true)}>
          {t('manualEntries.reviewButton')}
        </button>
      ) : (
        <>
          <p>
            {t('manualEntries.review', {
              direction: t(directionKeys[account.account][form.direction]),
              amount: formatMoney({
                amount: body!.amount.replace('-', ''),
                currency: form.currency,
              }),
            })}
          </p>
          <button
            type="button"
            disabled={correct.isPending}
            onClick={() =>
              correct.mutate(body!, {
                onSuccess: (answer) => {
                  if (answer.status === 'posted') setOpen(false);
                },
              })
            }
          >
            {t('manualEntries.confirm')}
          </button>
        </>
      )}
      <button type="button" onClick={() => setOpen(false)}>
        {t('manualEntries.back')}
      </button>
    </fieldset>
  );
}
