import { useQuery } from '@tanstack/react-query';
import { getRouteApi, Link } from '@tanstack/react-router';
import { type FormEvent, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { type CashLine, type CurrentSession, type Paper, useCurrentSession } from './cash-desk.js';
import { citiesQuery } from './cities.js';
import { formatDateTime, formatMoney } from './format.js';
import { BalanceText } from './restaurant-settlement-page.js';
import {
  aboveDue,
  defaultSession,
  type RestaurantReceipt,
  type RestaurantSettlementPreview,
  restaurantSettleBodyOf,
  type SettleVia,
  settlementLinesOf,
  useFieldVisitors,
  useRestaurantReceipt,
  useRestaurantSettle,
  useRestaurantSettlementPreview,
} from './restaurant-settlement.js';
import './receipt-print.css';

const settleRoute = getRouteApi('/signed-in/cash-desk/restaurants/$restaurantId/settle');
const receiptRoute = getRouteApi('/signed-in/cash-desk/restaurant-receipts/$receiptId');

const receiptTypeLabelKeys = {
  merchant_settlement: 'cashDesk.receiptType.merchant_settlement',
  merchant_payout: 'cashDesk.receiptType.merchant_payout',
} as const satisfies Record<RestaurantReceipt['type'], string>;

const methodKeys = {
  office: 'restaurantSettlement.receipt.methodName.office',
  field: 'restaurantSettlement.receipt.methodName.field',
} as const satisfies Record<RestaurantReceipt['method'], string>;

const paperClasses = { thermal: 'paper-thermal', a4: 'paper-a4' } as const satisfies Record<
  Paper,
  string
>;

// AP §9.10.3 tab 3, AP §8.7, RA §12.4 (slices 2.19b, 2.19c): the
// settlement at the office or on a field visit. The cash per currency, in
// part or in full, reviewed at the current rate, then «تأكيد وإصدار
// الإيصال». Unstyled until the design.
export function RestaurantSettlePage() {
  const { t } = useTranslation();
  const { restaurantId } = settleRoute.useParams();
  const search = settleRoute.useSearch();
  const balance = useRestaurantSettlementPreview(restaurantId, []);
  const known = balance.data && balance.data !== 'refused' ? balance.data : undefined;
  const current = useCurrentSession(known?.cityId);
  const first =
    current.data &&
    defaultSession({ office: current.data.session !== null, field: current.data.field !== null });
  return (
    <main>
      <p>
        <Link to="/cash-desk/restaurants" search={search}>
          {t('restaurantSettlement.title')}
        </Link>
      </p>
      {balance.isError || current.isError ? (
        <p role="alert">{t('common.failed')}</p>
      ) : balance.data === 'refused' ? (
        <p role="alert">{t('restaurantSettlement.form.quoteRefused')}</p>
      ) : !known || !current.data ? (
        <p role="status">{t('status.loading')}</p>
      ) : (
        <>
          <h1>{t('restaurantSettlement.form.title', { name: known.restaurantName })}</h1>
          <p>
            {t('restaurantSettlement.form.due')}{' '}
            <BalanceText amount={known.due} currency={known.currency} />
          </p>
          {known.due === '0' ? (
            <p>{t('restaurantSettlement.form.nothingDue')}</p>
          ) : !first ? (
            <p>
              <Link to="/cash-desk" search={search}>
                {t('restaurantSettlement.form.noSession')}
              </Link>
            </p>
          ) : (
            <SettleForm
              restaurantId={restaurantId}
              collect={BigInt(known.due) > 0n}
              current={current.data}
              first={first}
            />
          )}
        </>
      )}
    </main>
  );
}

function SettleForm({
  restaurantId,
  collect,
  current,
  first,
}: {
  restaurantId: string;
  collect: boolean;
  current: CurrentSession;
  first: SettleVia['session'];
}) {
  const { t } = useTranslation();
  const [chosen, setChosen] = useState<SettleVia['session']>(first);
  const [visitorId, setVisitorId] = useState('');
  const visitors = useFieldVisitors();
  const via: SettleVia =
    chosen === 'field'
      ? { session: 'field', visitorId: null }
      : { session: 'office', visitorId: visitorId || null };
  const currencies = (chosen === 'field' ? current.field : current.session)!.currencies.map(
    (each) => each.currency,
  );
  const [typed, setTyped] = useState<Record<string, string>>({});
  const [reviewed, setReviewed] = useState<CashLine[] | null>(null);
  const [problem, setProblem] = useState<string | null>(null);

  function review(event: FormEvent) {
    event.preventDefault();
    const result = settlementLinesOf(typed, currencies);
    if (result.status === 'invalid') {
      setProblem(t('restaurantSettlement.form.invalid', { currency: result.currency }));
      setReviewed(null);
    } else if (result.status === 'empty') {
      setProblem(t('restaurantSettlement.form.empty'));
      setReviewed(null);
    } else {
      setProblem(null);
      setReviewed(result.lines);
    }
  }

  return (
    <>
      <form onSubmit={review}>
        {current.session && current.field && (
          <fieldset>
            <legend>{t('restaurantSettlement.form.session')}</legend>
            {(['office', 'field'] as const).map((kind) => (
              <label key={kind}>
                <input
                  type="radio"
                  name="session"
                  checked={chosen === kind}
                  onChange={() => {
                    setChosen(kind);
                    setReviewed(null);
                  }}
                />{' '}
                {t(
                  kind === 'office'
                    ? 'restaurantSettlement.form.sessionOffice'
                    : 'restaurantSettlement.form.sessionField',
                )}
              </label>
            ))}
          </fieldset>
        )}
        {chosen === 'field' ? (
          <p>{t('restaurantSettlement.form.inField')}</p>
        ) : (
          <>
            <p>
              <label>
                {t('restaurantSettlement.form.visitor')}{' '}
                <select
                  value={visitorId}
                  onChange={(event) => {
                    setVisitorId(event.target.value);
                    setReviewed(null);
                  }}
                >
                  <option value="">{t('restaurantSettlement.form.visitorNone')}</option>
                  {visitors.data?.map((visitor) => (
                    <option key={visitor.id} value={visitor.id}>
                      {visitor.name}
                    </option>
                  ))}
                </select>
              </label>
            </p>
            <p>{t('restaurantSettlement.form.visitorHint')}</p>
            {visitors.isError && <p role="alert">{t('common.failed')}</p>}
          </>
        )}
        <p>
          {collect
            ? t('restaurantSettlement.form.collectHint')
            : t('restaurantSettlement.form.payHint')}
        </p>
        {currencies.map((currency) => (
          <p key={currency}>
            <label>
              {t('restaurantSettlement.form.amount', { currency })}{' '}
              <input
                inputMode="decimal"
                value={typed[currency] ?? ''}
                onChange={(event) => {
                  setTyped({ ...typed, [currency]: event.target.value });
                  setReviewed(null);
                }}
              />
            </label>
          </p>
        ))}
        <p>
          <button type="submit">{t('restaurantSettlement.form.review')}</button>
        </p>
        {problem && <p role="alert">{problem}</p>}
      </form>
      {reviewed && <Review restaurantId={restaurantId} lines={reviewed} via={via} />}
    </>
  );
}

function Review({
  restaurantId,
  lines,
  via,
}: {
  restaurantId: string;
  lines: CashLine[];
  via: SettleVia;
}) {
  const { t } = useTranslation();
  const preview = useRestaurantSettlementPreview(restaurantId, lines);
  const settle = useRestaurantSettle();
  if (preview.isError) return <p role="alert">{t('common.failed')}</p>;
  if (preview.data === 'refused') {
    return <p role="alert">{t('restaurantSettlement.form.quoteRefused')}</p>;
  }
  if (!preview.data) return <p role="status">{t('status.loading')}</p>;
  const quoted: RestaurantSettlementPreview = preview.data;
  const above = aboveDue(quoted);
  const result = settle.data;
  return (
    <section>
      <ul>
        {quoted.lines.map((line) => (
          <li key={line.currency}>
            {t('restaurantSettlement.form.line', {
              amount: formatMoney({ amount: line.amount, currency: line.currency }),
              base: formatMoney({ amount: line.base, currency: quoted.currency }),
            })}
            {line.unit && (
              <>
                {' '}
                {t('restaurantSettlement.form.rate', {
                  from: line.unit.from,
                  value: line.unit.value,
                  to: line.unit.to,
                })}
              </>
            )}
          </li>
        ))}
      </ul>
      <p>
        {t('restaurantSettlement.form.total', {
          amount: formatMoney({ amount: quoted.total, currency: quoted.currency }),
        })}
      </p>
      {above ? (
        <p role="alert">{t('restaurantSettlement.form.above')}</p>
      ) : (
        <p>
          {t('restaurantSettlement.form.remaining')}{' '}
          <BalanceText amount={quoted.remaining} currency={quoted.currency} />
        </p>
      )}
      {result?.status === 'settled' ? (
        <p role="status">
          <Link
            to="/cash-desk/restaurant-receipts/$receiptId"
            params={{ receiptId: result.receipt.id }}
          >
            {t('restaurantSettlement.form.done', { number: result.receipt.number })}
          </Link>
        </p>
      ) : (
        <>
          <p>
            <button
              type="button"
              disabled={above || settle.isPending}
              onClick={() => settle.mutate(restaurantSettleBodyOf(quoted, via))}
            >
              {t('restaurantSettlement.form.confirm')}
            </button>
          </p>
          {result?.status === 'refused' && (
            <p role="alert">{t(`restaurantSettlement.form.refused.${result.refusal}`)}</p>
          )}
          {settle.isError && <p role="alert">{t('common.failed')}</p>}
        </>
      )}
    </section>
  );
}

// RA §12.4: the restaurant's receipt, printed on an 80 mm roll or on A4: the
// number, the amounts per currency with their base value, the method, the
// cashier, the time, and the balance before and after.
export function RestaurantReceiptPage() {
  const { t } = useTranslation();
  const { receiptId } = receiptRoute.useParams();
  const receipt = useRestaurantReceipt(receiptId);
  const cities = useQuery(citiesQuery);
  const [paper, setPaper] = useState<Paper>('thermal');

  function print(choice: Paper) {
    setPaper(choice);
    // After React has applied the paper's class.
    requestAnimationFrame(() => window.print());
  }

  const city = cities.data?.find((each) => each.id === receipt.data?.cityId);
  return (
    <main>
      <p className="no-print">
        <Link to="/cash-desk/restaurants">{t('restaurantSettlement.title')}</Link>
      </p>
      {receipt.isError || cities.isError ? (
        <p role="alert">{t('common.failed')}</p>
      ) : !receipt.data || !city ? (
        <p role="status">{t('status.loading')}</p>
      ) : (
        <>
          <p className="no-print">
            <button type="button" onClick={() => print('thermal')}>
              {t('cashDesk.receipt.printThermal')}
            </button>{' '}
            <button type="button" onClick={() => print('a4')}>
              {t('cashDesk.receipt.printA4')}
            </button>
          </p>
          <ReceiptView receipt={receipt.data} timeZone={city.timeZone} paper={paper} />
        </>
      )}
    </main>
  );
}

function ReceiptView({
  receipt,
  timeZone,
  paper,
}: {
  receipt: RestaurantReceipt;
  timeZone: string;
  paper: Paper;
}) {
  const { t } = useTranslation();
  return (
    <article
      className={['receipt', paperClasses[paper]].join(' ')}
      aria-labelledby="restaurant-receipt-number"
    >
      <h1>{t('app.name')}</h1>
      <h2 id="restaurant-receipt-number">
        {t('cashDesk.receipt.number', { number: receipt.number })}
      </h2>
      <p>{t(receiptTypeLabelKeys[receipt.type])}</p>
      <p>{formatDateTime(receipt.createdAt, timeZone)}</p>
      <p>{t('restaurantSettlement.receipt.restaurant', { name: receipt.restaurantName })}</p>
      <p>
        {t('restaurantSettlement.receipt.method', {
          method: t(methodKeys[receipt.method]),
        })}
      </p>
      {receipt.visitorName !== null && (
        <p>{t('restaurantSettlement.receipt.visitor', { name: receipt.visitorName })}</p>
      )}
      <p>{t('cashDesk.receipt.cashier', { name: receipt.cashierName ?? '' })}</p>
      <table>
        <thead>
          <tr>
            <th scope="col">{t('cashDesk.currency')}</th>
            <th scope="col">{t('restaurantSettlement.receipt.amount')}</th>
            <th scope="col">
              {t('restaurantSettlement.receipt.base', { currency: receipt.currency })}
            </th>
          </tr>
        </thead>
        <tbody>
          {receipt.lines.map((line) => (
            <tr key={line.currency}>
              <th scope="row">{line.currency}</th>
              <td>{formatMoney({ amount: line.amount, currency: line.currency })}</td>
              <td>{formatMoney({ amount: line.base, currency: receipt.currency })}</td>
            </tr>
          ))}
        </tbody>
      </table>
      <p>
        {t('restaurantSettlement.receipt.total', {
          amount: formatMoney({ amount: receipt.total, currency: receipt.currency }),
        })}
      </p>
      <p>
        {t('restaurantSettlement.receipt.dueBefore')}{' '}
        <BalanceText amount={receipt.dueBefore} currency={receipt.currency} />
      </p>
      <p>
        {t('restaurantSettlement.receipt.dueAfter')}{' '}
        <BalanceText amount={receipt.dueAfter} currency={receipt.currency} />
      </p>
    </article>
  );
}
