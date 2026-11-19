import { useQuery } from '@tanstack/react-query';
import { getRouteApi, Link } from '@tanstack/react-router';
import { type FormEvent, useState } from 'react';
import { useTranslation } from 'react-i18next';
import {
  type AwaitingDeposit,
  depositBodyOf,
  type DepositForm,
  type DepositProblem,
  type DepositRefusal,
  useAwaitingDeposits,
  useRecordDeposit,
} from './cash-desk-deposits.js';
import { useCurrentSession } from './cash-desk.js';
import { chosenCity, citiesQuery } from './cities.js';
import { decimalOf, formatMoney } from './format.js';

const route = getRouteApi('/signed-in/cash-desk/deposits');

const problemKeys = {
  amount: 'deposits.problem.amount',
  instalment: 'deposits.problem.instalment',
  paid_now: 'deposits.problem.paidNow',
} as const satisfies Record<DepositProblem, string>;

const refusalKeys = {
  no_open_session: 'cashDesk.refusal.no_open_session',
  above_balance: 'deposits.refusal.above_balance',
  wrong_stage: 'deposits.refusal.wrong_stage',
  invalid_amounts: 'deposits.refusal.invalid_amounts',
  unknown_party: 'deposits.refusal.unknown_party',
  no_base_currency: 'deposits.refusal.no_base_currency',
} as const satisfies Record<DepositRefusal, string>;

// AP §9.7.1 «تأمين العدة» (slice 2.35a): the applications at «بانتظار العدة»
// and their deposit. Unstyled until the design.
export function DepositsPage() {
  const { t } = useTranslation();
  const search = route.useSearch();
  const cities = useQuery(citiesQuery);
  const city = cities.data ? chosenCity(cities.data, search.city) : undefined;
  const awaiting = useAwaitingDeposits(city?.id);
  const current = useCurrentSession(city?.id);
  return (
    <main>
      <h1>{t('deposits.title')}</h1>
      <p>
        <Link to="/cash-desk" search={search.city ? { city: search.city } : {}}>
          {t('cashDesk.title')}
        </Link>
      </p>
      {cities.isError || awaiting.isError ? (
        <p role="alert">{t('common.failed')}</p>
      ) : !city || !awaiting.data ? (
        <p role="status">{t('status.loading')}</p>
      ) : awaiting.data.length === 0 ? (
        <p>{t('deposits.none')}</p>
      ) : (
        <>
          {current.data && !current.data.session && <p role="alert">{t('deposits.openDrawer')}</p>}
          {awaiting.data.map((application) => (
            <DepositEntry
              key={application.applicationId}
              application={application}
              cityId={city.id}
              cityCode={city.code}
            />
          ))}
        </>
      )}
    </main>
  );
}

function DepositEntry(props: { application: AwaitingDeposit; cityId: string; cityCode: string }) {
  const { t } = useTranslation();
  const { application } = props;
  const { deposit, suggested } = application;
  const currency = deposit.amount?.currency ?? suggested?.currency ?? null;
  const start = deposit.amount ?? suggested;
  const [form, setForm] = useState<DepositForm>({
    amount: start ? decimalOf(start.amount, start.currency) : '',
    instalment: deposit.instalment
      ? decimalOf(deposit.instalment.amount, deposit.instalment.currency)
      : '',
    paidNow: '',
  });
  const [problem, setProblem] = useState<DepositProblem | null>(null);
  const record = useRecordDeposit();
  const submit = (event: FormEvent) => {
    event.preventDefault();
    if (currency === null) return;
    const found = depositBodyOf(form, application, props.cityId, currency);
    if ('problem' in found) {
      setProblem(found.problem);
      return;
    }
    setProblem(null);
    record.mutate(found.body);
  };
  return (
    <section aria-label={application.fullName}>
      <h2>
        <Link
          to="/captain-applications/$applicationId"
          params={{ applicationId: application.applicationId }}
          search={{ city: props.cityCode }}
        >
          {application.fullName}
        </Link>
      </h2>
      <p>
        {deposit.amount
          ? t('deposits.state', {
              amount: formatMoney(deposit.amount),
              paid: formatMoney({ amount: deposit.paid, currency: deposit.amount.currency }),
            })
          : t('deposits.notRecorded')}
      </p>
      {currency === null ? (
        <p role="alert">{t('deposits.noCurrency')}</p>
      ) : (
        <form onSubmit={submit}>
          <label>
            {t('deposits.amount', { currency })}
            <input
              inputMode="decimal"
              dir="ltr"
              value={form.amount}
              onChange={(event) => setForm({ ...form, amount: event.target.value })}
            />
          </label>
          <label>
            {t('deposits.instalment', { currency })}
            <input
              inputMode="decimal"
              dir="ltr"
              value={form.instalment}
              onChange={(event) => setForm({ ...form, instalment: event.target.value })}
            />
          </label>
          <label>
            {t('deposits.paidNow', { currency })}
            <input
              inputMode="decimal"
              dir="ltr"
              value={form.paidNow}
              onChange={(event) => setForm({ ...form, paidNow: event.target.value })}
            />
          </label>
          <button type="submit" disabled={record.isPending}>
            {t('deposits.record')}
          </button>
          {problem && <p role="alert">{t(problemKeys[problem])}</p>}
          {record.isPending && <p role="status">{t('captainApplications.sending')}</p>}
          {record.isError && <p role="alert">{t('common.failed')}</p>}
          {record.data?.status === 'refused' && (
            <p role="alert">{t(refusalKeys[record.data.refusal])}</p>
          )}
          {record.data?.status === 'recorded' && (
            <p role="status">
              {t('deposits.recorded')}{' '}
              {record.data.receipt && (
                <Link
                  to="/cash-desk/receipts/$receiptId"
                  params={{ receiptId: record.data.receipt.id }}
                >
                  {t('deposits.receipt', { number: record.data.receipt.number })}
                </Link>
              )}
            </p>
          )}
        </form>
      )}
    </section>
  );
}
