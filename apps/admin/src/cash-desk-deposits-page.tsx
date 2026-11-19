import { useQuery } from '@tanstack/react-query';
import { getRouteApi, Link } from '@tanstack/react-router';
import { type FormEvent, useState } from 'react';
import { useTranslation } from 'react-i18next';
import {
  type AwaitingDeposit,
  depositBodyOf,
  type DepositForm,
  type DepositProblem,
  type DepositRefund,
  type DepositRefusal,
  settlementOf,
  type SettleRefusal,
  useAwaitingDeposits,
  useDepositRefunds,
  useSettleDeposit,
  useRecordDeposit,
  useSetCashLimit,
} from './cash-desk-deposits.js';
import { canSetCashLimit, cashLimitOf } from './captain-activation.js';
import { useCurrentSession } from './cash-desk.js';
import { chosenCity, citiesQuery } from './cities.js';
import { decimalOf, formatMoney } from './format.js';

const route = getRouteApi('/signed-in/cash-desk/deposits');
const signedIn = getRouteApi('/signed-in');

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
  const { session } = signedIn.useRouteContext();
  const setsCashLimit = canSetCashLimit(session);
  const current = useCurrentSession(city?.id);
  const refunds = useDepositRefunds(city?.id);
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
              setsCashLimit={setsCashLimit}
            />
          ))}
        </>
      )}
      <h2>{t('depositRefunds.title')}</h2>
      {refunds.isError ? (
        <p role="alert">{t('common.failed')}</p>
      ) : !city || !refunds.data ? (
        <p role="status">{t('status.loading')}</p>
      ) : refunds.data.length === 0 ? (
        <p>{t('depositRefunds.none')}</p>
      ) : (
        refunds.data.map((contract) => (
          <RefundEntry
            key={contract.applicationId}
            contract={contract}
            cityId={city.id}
            cityCode={city.code}
          />
        ))
      )}
    </main>
  );
}

const settleRefusalKeys = {
  no_open_session: 'cashDesk.refusal.no_open_session',
  not_terminated: 'depositRefunds.refusal.not_terminated',
  contract_ended: 'depositRefunds.refusal.contract_ended',
  kit_not_checked: 'depositRefunds.refusal.kit_not_checked',
  deposit_settled: 'depositRefunds.refusal.deposit_settled',
  wrong_settlement: 'depositRefunds.refusal.wrong_settlement',
  nothing_held: 'depositRefunds.refusal.nothing_held',
  unknown_party: 'deposits.refusal.unknown_party',
  no_base_currency: 'deposits.refusal.no_base_currency',
} as const satisfies Record<SettleRefusal, string>;

// A contract being ended (AP §9.7.5 step 4): the deposit held and what the
// kit's step says; the refund needs the drawer, the withholding does not.
function RefundEntry(props: { contract: DepositRefund; cityId: string; cityCode: string }) {
  const { t } = useTranslation();
  const { contract } = props;
  const settlement = settlementOf(contract);
  const settle = useSettleDeposit(props.cityId);
  return (
    <section aria-label={contract.fullName}>
      <h3>
        <Link
          to="/captain-applications/$applicationId"
          params={{ applicationId: contract.applicationId }}
          search={{ city: props.cityCode }}
        >
          {contract.fullName}
        </Link>
      </h3>
      <p>
        {t('depositRefunds.line', {
          day: contract.terminatedAt.slice(0, 10),
          amount: formatMoney(contract.held),
        })}{' '}
        {contract.earlyExit && t('captainOffboarding.earlyExitFlag')}
      </p>
      {settlement === null ? (
        <p>{t('depositRefunds.waitingKit')}</p>
      ) : (
        <button
          type="button"
          disabled={settle.isPending}
          onClick={() => settle.mutate({ applicationId: contract.applicationId, settlement })}
        >
          {settlement === 'refunded'
            ? t('depositRefunds.refund', { amount: formatMoney(contract.held) })
            : t('depositRefunds.withhold', { amount: formatMoney(contract.held) })}
        </button>
      )}
      {settle.isPending && <p role="status">{t('captainApplications.sending')}</p>}
      {settle.isError && <p role="alert">{t('common.failed')}</p>}
      {settle.data?.status === 'refused' && (
        <p role="alert">{t(settleRefusalKeys[settle.data.refusal])}</p>
      )}
      {settle.data?.status === 'settled' && (
        <p role="status">
          {t('depositRefunds.settled')}{' '}
          {settle.data.receipt && (
            <Link
              to="/cash-desk/receipts/$receiptId"
              params={{ receiptId: settle.data.receipt.id }}
            >
              {t('deposits.receipt', { number: settle.data.receipt.number })}
            </Link>
          )}
        </p>
      )}
    </section>
  );
}

function DepositEntry(props: {
  application: AwaitingDeposit;
  cityId: string;
  cityCode: string;
  setsCashLimit: boolean;
}) {
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
      <p>
        {application.cashLimit
          ? t('deposits.cashLimitNow', { amount: formatMoney(application.cashLimit) })
          : t('deposits.noCashLimit')}
      </p>
      {props.setsCashLimit && <CashLimitForm application={application} cityId={props.cityId} />}
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

function CashLimitForm(props: { application: AwaitingDeposit; cityId: string }) {
  const { t } = useTranslation();
  const { cashLimit, suggestedCashLimit } = props.application;
  const prefill = cashLimit ?? suggestedCashLimit;
  const currency = prefill?.currency ?? props.application.suggested?.currency ?? null;
  const [typed, setTyped] = useState(prefill ? decimalOf(prefill.amount, prefill.currency) : '');
  const [problem, setProblem] = useState(false);
  const save = useSetCashLimit(props.cityId);
  if (currency === null) return null;
  const submit = (event: FormEvent) => {
    event.preventDefault();
    const amount = cashLimitOf(typed, currency);
    setProblem(amount === null);
    if (amount !== null) {
      save.mutate({ applicationId: props.application.applicationId, amount, currency });
    }
  };
  return (
    <form onSubmit={submit} aria-label={t('deposits.setCashLimit')}>
      <label>
        {t('deposits.cashLimitAmount', { currency })}
        <input
          inputMode="decimal"
          dir="ltr"
          value={typed}
          onChange={(event) => setTyped(event.target.value)}
        />
      </label>
      <button type="submit" disabled={save.isPending}>
        {t('deposits.setCashLimit')}
      </button>
      {problem && <p role="alert">{t('deposits.problem.cashLimit')}</p>}
      {save.isError && <p role="alert">{t('common.failed')}</p>}
      {save.data?.status === 'saved' && <p role="status">{t('captainApplications.done')}</p>}
      {save.data?.status === 'refused' && (
        <p role="alert">{t(`deposits.refusal.${save.data.refusal}`)}</p>
      )}
    </form>
  );
}
