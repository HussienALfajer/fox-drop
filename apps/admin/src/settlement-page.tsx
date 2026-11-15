import { useQuery } from '@tanstack/react-query';
import { getRouteApi, Link } from '@tanstack/react-router';
import { type FormEvent, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { useCurrentSession } from './cash-desk.js';
import { type City, chosenCity, citiesQuery } from './cities.js';
import { formatDateTime, formatMoney } from './format.js';
import { receiptTypeKeys } from './receipt-page.js';
import {
  absolute,
  canSettle,
  netDirection,
  type PayoutWeekday,
  type SettleRefusal,
  type Settlement,
  type SettlementPreview,
  type Statement,
  settleBodyOf,
  useSettle,
  useSettlementList,
  useSettlementPreview,
  useStatement,
} from './settlement.js';
import './receipt-print.css';

const listRoute = getRouteApi('/signed-in/cash-desk/settlements');
const settleRoute = getRouteApi('/signed-in/cash-desk/settlements/$captainId');
const statementRoute = getRouteApi('/signed-in/cash-desk/statements/$statementId');
const signedIn = getRouteApi('/signed-in');

const weekdayKeys = {
  saturday: 'settlement.weekday.saturday',
  sunday: 'settlement.weekday.sunday',
  monday: 'settlement.weekday.monday',
  tuesday: 'settlement.weekday.tuesday',
  wednesday: 'settlement.weekday.wednesday',
  thursday: 'settlement.weekday.thursday',
  friday: 'settlement.weekday.friday',
} as const satisfies Record<PayoutWeekday, string>;

const policyKeys = {
  carry_forward: 'settlement.policy.carry_forward',
  collect_at_desk: 'settlement.policy.collect_at_desk',
} as const satisfies Record<SettlementPreview['policy'], string>;

const refusalKeys = {
  not_payout_day: 'settlement.refusal.not_payout_day',
  reason_required: 'settlement.refusal.reason_required',
  balance_changed: 'settlement.refusal.balance_changed',
  rate_changed: 'cashDesk.refusal.rate_changed',
  rate_missing: 'cashDesk.refusal.rate_missing',
  nothing_due: 'settlement.refusal.nothing_due',
  drawer_short: 'cashDesk.refusal.drawer_short',
  no_open_session: 'cashDesk.refusal.no_open_session',
  unknown_captain: 'cashDesk.refusal.unknown_captain',
} as const satisfies Record<SettleRefusal, string>;

// AP §9.10.3 «تصفية الخميس» (slice 2.18a): the captains with an earnings
// balance or open custody. Read-only on another day, except for OWN.
// Unstyled until the design.
export function SettlementsPage() {
  const { t } = useTranslation();
  const search = listRoute.useSearch();
  const { session } = signedIn.useRouteContext();
  const cities = useQuery(citiesQuery);
  const city = cities.data ? chosenCity(cities.data, search.city) : undefined;
  const list = useSettlementList(city?.id);
  return (
    <main>
      <h1>{t('settlement.title')}</h1>
      <p>
        <Link to="/cash-desk" search={search}>
          {t('cashDesk.title')}
        </Link>
      </p>
      {cities.isError || list.isError ? (
        <p role="alert">{t('common.failed')}</p>
      ) : !city || !list.data ? (
        <p role="status">{t('status.loading')}</p>
      ) : (
        <>
          <DayLine
            payoutDay={list.data.payoutDay}
            weekday={list.data.payoutWeekday}
            settles={canSettle(session, list.data.payoutDay)}
          />
          <p>{t(policyKeys[list.data.policy])}</p>
          {list.data.captains.length === 0 ? (
            <p>{t('settlement.none')}</p>
          ) : (
            <table>
              <thead>
                <tr>
                  <th scope="col">{t('captainBalances.captain')}</th>
                  <th scope="col">{t('captainBalances.custody')}</th>
                  <th scope="col">{t('captainBalances.earnings')}</th>
                  <th scope="col">{t('captainBalances.lastPayout')}</th>
                  <th scope="col">{t('captainBalances.actions')}</th>
                </tr>
              </thead>
              <tbody>
                {list.data.captains.map((row) => (
                  <tr key={row.captainId}>
                    <th scope="row">{row.name}</th>
                    <td>
                      {row.currencies
                        .filter((line) => BigInt(line.balance) !== 0n)
                        .map((line) =>
                          formatMoney({ amount: line.balance, currency: line.currency }),
                        )
                        .join(t('captainBalances.and'))}
                    </td>
                    <td>{formatMoney(row.earnings)}</td>
                    <td>
                      {row.lastPayoutAt
                        ? formatDateTime(row.lastPayoutAt, city.timeZone)
                        : t('captainBalances.never')}
                    </td>
                    <td>
                      <Link
                        to="/cash-desk/settlements/$captainId"
                        params={{ captainId: row.captainId }}
                        search={search}
                      >
                        {canSettle(session, list.data.payoutDay)
                          ? t('settlement.open')
                          : t('settlement.view')}
                      </Link>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}
        </>
      )}
    </main>
  );
}

function DayLine({
  payoutDay,
  weekday,
  settles,
}: {
  payoutDay: boolean;
  weekday: PayoutWeekday;
  settles: boolean;
}) {
  const { t } = useTranslation();
  const day = t(weekdayKeys[weekday]);
  if (payoutDay) return <p>{t('settlement.payoutDay', { day })}</p>;
  return (
    <p>{settles ? t('settlement.offCycleOwner', { day }) : t('settlement.readOnly', { day })}</p>
  );
}

// AP §8.5.5: one flow for one captain: the custody settled to zero in every
// currency and the full earnings paid, netted on screen per currency.
export function SettleCaptainPage() {
  const { t } = useTranslation();
  const { captainId } = settleRoute.useParams();
  const search = settleRoute.useSearch();
  const cities = useQuery(citiesQuery);
  const city = cities.data ? chosenCity(cities.data, search.city) : undefined;
  const current = useCurrentSession(city?.id);
  const [payoutCurrency, setPayoutCurrency] = useState<string | null>(null);
  const preview = useSettlementPreview(captainId, payoutCurrency);
  const [settled, setSettled] = useState<Settlement | null>(null);
  return (
    <main>
      <h1>{t('settlement.title')}</h1>
      <p>
        <Link to="/cash-desk/settlements" search={search.city ? { city: search.city } : {}}>
          {t('settlement.back')}
        </Link>
      </p>
      {cities.isError || current.isError || preview.isError ? (
        <p role="alert">{t('common.failed')}</p>
      ) : !city || !current.data || !preview.data ? (
        <p role="status">{t('status.loading')}</p>
      ) : preview.data === 'refused' ? (
        <p role="alert">{t('settlement.previewRefused')}</p>
      ) : settled ? (
        <Settled settlement={settled} />
      ) : (
        <SettleForm
          preview={preview.data}
          city={city}
          currencies={current.data.currencies}
          sessionOpen={current.data.session !== null}
          payoutCurrency={payoutCurrency}
          onPayoutCurrency={setPayoutCurrency}
          onSettled={setSettled}
        />
      )}
    </main>
  );
}

function SettleForm({
  preview,
  city,
  currencies,
  sessionOpen,
  payoutCurrency,
  onPayoutCurrency,
  onSettled,
}: {
  preview: SettlementPreview;
  city: City;
  currencies: string[];
  sessionOpen: boolean;
  payoutCurrency: string | null;
  onPayoutCurrency: (currency: string | null) => void;
  onSettled: (settlement: Settlement) => void;
}) {
  const { t } = useTranslation();
  const { session } = signedIn.useRouteContext();
  const settle = useSettle();
  const [reason, setReason] = useState('');
  const [refusal, setRefusal] = useState<SettleRefusal | null>(null);
  const settles = canSettle(session, preview.payoutDay);
  const needsReason = !preview.payoutDay && reason.trim() === '';
  const base = preview.earnings.currency;

  async function submit(event: FormEvent) {
    event.preventDefault();
    setRefusal(null);
    const result = await settle.mutateAsync(settleBodyOf(preview, reason));
    if (result.status === 'settled') onSettled(result.settlement);
    else setRefusal(result.refusal);
  }

  return (
    <form onSubmit={submit} aria-labelledby="settle-captain">
      <h2 id="settle-captain">{preview.name}</h2>
      <DayLine payoutDay={preview.payoutDay} weekday={preview.payoutWeekday} settles={settles} />
      <h3>{t('settlement.custody')}</h3>
      {preview.custody.length === 0 ? (
        <p>{t('cashDesk.handIn.noCustody')}</p>
      ) : (
        <ul>
          {preview.custody.map((line) => (
            <li key={line.currency}>
              {BigInt(line.balance) > 0n
                ? t('settlement.custodyHandIn', {
                    amount: formatMoney({ amount: line.balance, currency: line.currency }),
                  })
                : t('settlement.custodyReimburse', {
                    amount: formatMoney({
                      amount: absolute(line.balance),
                      currency: line.currency,
                    }),
                  })}
            </li>
          ))}
        </ul>
      )}
      <h3>{t('settlement.earnings')}</h3>
      <p>{formatMoney(preview.earnings)}</p>
      {preview.payout ? (
        <>
          <label>
            {t('settlement.payoutCurrency')}{' '}
            <select
              value={payoutCurrency ?? base}
              onChange={(event) =>
                onPayoutCurrency(event.target.value === base ? null : event.target.value)
              }
            >
              {[base, ...currencies.filter((each) => each !== base)].map((currency) => (
                <option key={currency} value={currency}>
                  {currency}
                </option>
              ))}
            </select>
          </label>
          <p>{t('settlement.payout', { amount: formatMoney(preview.payout) })}</p>
          {preview.payout.unit && (
            <p>
              {t('cashDesk.conversion.rate', {
                from: preview.payout.unit.from,
                value: preview.payout.unit.value,
                to: preview.payout.unit.to,
              })}
            </p>
          )}
        </>
      ) : BigInt(preview.earnings.amount) < 0n ? (
        <p>
          {preview.collect
            ? t('settlement.collect', {
                amount: formatMoney({ amount: preview.collect, currency: base }),
              })
            : t('settlement.carryForward', {
                amount: formatMoney({ amount: absolute(preview.earnings.amount), currency: base }),
              })}
        </p>
      ) : null}
      <h3>{t('settlement.net')}</h3>
      {preview.net.length === 0 ? (
        <p>{t('settlement.netNone')}</p>
      ) : (
        <ul>
          {preview.net.map((line) => (
            <li key={line.currency}>
              {netDirection(line.amount) === 'gives'
                ? t('settlement.netGives', {
                    amount: formatMoney({ amount: line.amount, currency: line.currency }),
                  })
                : t('settlement.netReceives', {
                    amount: formatMoney({ amount: absolute(line.amount), currency: line.currency }),
                  })}
            </li>
          ))}
        </ul>
      )}
      <p>{t('settlement.ledgerApart')}</p>
      {!settles ? null : !sessionOpen ? (
        <p>
          <Link to="/cash-desk" search={{ city: city.code }}>
            {t('settlement.openFirst')}
          </Link>
        </p>
      ) : (
        <>
          {!preview.payoutDay && (
            <label>
              {t('settlement.reason')}{' '}
              <input
                value={reason}
                maxLength={500}
                onChange={(event) => setReason(event.target.value)}
              />
            </label>
          )}
          {refusal && <p role="alert">{t(refusalKeys[refusal])}</p>}
          {settle.isError && <p role="alert">{t('common.failed')}</p>}
          <p>
            <button type="submit" disabled={settle.isPending || needsReason}>
              {t('settlement.confirm')}
            </button>
          </p>
        </>
      )}
    </form>
  );
}

function Settled({ settlement }: { settlement: Settlement }) {
  const { t } = useTranslation();
  return (
    <section aria-labelledby="settled">
      <h2 id="settled">{t('settlement.done')}</h2>
      <ul>
        {settlement.receipts.map((receipt) => (
          <li key={receipt.id}>
            <Link to="/cash-desk/receipts/$receiptId" params={{ receiptId: receipt.id }}>
              {t('settlement.receiptLink', {
                number: receipt.number,
                type: t(receiptTypeKeys[receipt.type]),
              })}
            </Link>
          </li>
        ))}
      </ul>
      <p>
        <Link
          to="/cash-desk/statements/$statementId"
          params={{ statementId: settlement.statement.id }}
        >
          {t('settlement.statementLink')}
        </Link>
      </p>
    </section>
  );
}

// AP §8.5.5 step 4: the weekly statement, printed on A4 as a plain layout
// until the design (owner decision 2026-11-15).
export function StatementPage() {
  const { t } = useTranslation();
  const { statementId } = statementRoute.useParams();
  const statement = useStatement(statementId);
  const cities = useQuery(citiesQuery);
  const city = cities.data?.find((each) => each.id === statement.data?.cityId);
  return (
    <main>
      <p className="no-print">
        <Link to="/cash-desk/settlements">{t('settlement.title')}</Link>
      </p>
      {statement.isError || cities.isError ? (
        <p role="alert">{t('common.failed')}</p>
      ) : !statement.data || !city ? (
        <p role="status">{t('status.loading')}</p>
      ) : (
        <>
          <p className="no-print">
            <button type="button" onClick={() => window.print()}>
              {t('cashDesk.receipt.printA4')}
            </button>
          </p>
          <StatementView statement={statement.data} timeZone={city.timeZone} />
        </>
      )}
    </main>
  );
}

function StatementView({ statement, timeZone }: { statement: Statement; timeZone: string }) {
  const { t } = useTranslation();
  const money = (amount: string) => formatMoney({ amount, currency: statement.currency });
  const rows: [string, string][] = [
    [t('settlement.statement.carriedIn'), money(statement.carriedIn)],
    [t('settlement.statement.basePay'), money(statement.basePay)],
    [t('settlement.statement.distancePay'), money(statement.distancePay)],
    [t('settlement.statement.waitingPay'), money(statement.waitingPay)],
    [t('settlement.statement.peakBonus'), money(statement.peakBonus)],
    [t('settlement.statement.bonuses'), money(statement.bonuses)],
    [t('settlement.statement.charges'), money(statement.charges)],
    [t('settlement.statement.instalments'), money(statement.instalments)],
    [t('settlement.statement.adjustments'), money(statement.adjustments)],
    [t('settlement.statement.balance'), money(statement.balance)],
    [t('settlement.statement.paid'), statement.payout ? formatMoney(statement.payout) : money('0')],
    [t('settlement.statement.collected'), money(statement.collected)],
    [t('settlement.statement.carriedOut'), money(statement.carriedOut)],
  ];
  return (
    <article className="receipt paper-a4" aria-labelledby="statement-title">
      <h1>{t('app.name')}</h1>
      <h2 id="statement-title">{t('settlement.statement.title')}</h2>
      <p>{t('cashDesk.receipt.captain', { name: statement.captainName })}</p>
      <p>
        {statement.periodFrom
          ? t('settlement.statement.period', {
              from: formatDateTime(statement.periodFrom, timeZone),
              to: formatDateTime(statement.createdAt, timeZone),
            })
          : t('settlement.statement.periodFirst', {
              to: formatDateTime(statement.createdAt, timeZone),
            })}
      </p>
      <p>{t('settlement.statement.orders', { orders: statement.orders })}</p>
      {statement.offCycle && (
        <p>{t('settlement.statement.offCycle', { reason: statement.reason ?? '' })}</p>
      )}
      <table>
        <tbody>
          {rows.map(([label, value]) => (
            <tr key={label}>
              <th scope="row">{label}</th>
              <td>{value}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </article>
  );
}
