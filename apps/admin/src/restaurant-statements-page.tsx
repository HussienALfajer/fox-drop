import { useQuery } from '@tanstack/react-query';
import { getRouteApi, Link, useNavigate } from '@tanstack/react-router';
import { type FormEvent, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { CASH_DESK } from './cash-desk.js';
import { chosenCity, citiesQuery } from './cities.js';
import { ExportButton } from './export-button.js';
import { formatDateTime, formatMoney } from './format.js';
import type { ExceptionCause } from './restaurant-settlement.js';
import {
  defaultPeriod,
  entryOf,
  type Period,
  periodFits,
  type PeriodStatement,
  type PeriodStatementLine,
  useExportStatement,
  useRestaurantPeriodStatement,
  useStatementRestaurants,
} from './restaurant-statements.js';
import { can } from './session.js';
import './receipt-print.css';

const route = getRouteApi('/signed-in/restaurant-statements');
const signedIn = getRouteApi('/signed-in');

// RA §12.5: the exceptions' labels, as on the weekly statement.
const causeKeys = {
  food_credit: 'restaurantSettlement.cause.food_credit',
  credit: 'restaurantSettlement.cause.credit',
  pickup_refund: 'restaurantSettlement.cause.pickup_refund',
  pickup_kept: 'restaurantSettlement.cause.pickup_kept',
  items_removed: 'restaurantSettlement.cause.items_removed',
  fee_lowered: 'restaurantSettlement.cause.fee_lowered',
  fee_cut_returned: 'restaurantSettlement.cause.fee_cut_returned',
  debit: 'restaurantSettlement.cause.debit',
  commission_reversal: 'restaurantSettlement.cause.commission_reversal',
  commission_restored: 'restaurantSettlement.cause.commission_restored',
  discount_reversal: 'restaurantSettlement.cause.discount_reversal',
  outcome_changed: 'restaurantSettlement.cause.outcome_changed',
  adjustment: 'restaurantSettlement.cause.adjustment',
} as const satisfies Record<ExceptionCause, string>;

const entryKeys = {
  order: 'restaurantStatements.entry.order',
  payment: 'restaurantStatements.entry.payment',
  payout: 'restaurantStatements.entry.payout',
} as const;

// AP §9.10.5 «كشوف المطاعم» (slice 2.19g): any restaurant and any period of
// business days, the statement on screen, «طباعة A4» and «تصدير Excel».
// Unstyled until the design.
export function RestaurantStatementsPage() {
  const { t } = useTranslation();
  const search = route.useSearch();
  const navigate = useNavigate();
  const cities = useQuery(citiesQuery);
  const city = cities.data ? chosenCity(cities.data, search.city) : undefined;
  const restaurants = useStatementRestaurants(city?.id);
  const period: Period | null =
    search.restaurant && search.from && search.to
      ? { restaurantId: search.restaurant, from: search.from, to: search.to }
      : null;
  const statement = useRestaurantPeriodStatement(
    period && periodFits(period.from, period.to) ? period : null,
  );

  // The form starts again from the period shown whenever it changes.
  const formKey = [period?.restaurantId, period?.from, period?.to].join(':');
  const show = (chosen: Period) =>
    void navigate({
      to: '/restaurant-statements',
      search: {
        ...(search.city ? { city: search.city } : {}),
        restaurant: chosen.restaurantId,
        from: chosen.from,
        to: chosen.to,
      },
    });

  return (
    <main>
      <h1 className="no-print">{t('restaurantStatements.title')}</h1>
      {cities.isError || restaurants.isError ? (
        <p role="alert">{t('common.failed')}</p>
      ) : !city || !restaurants.data ? (
        <p role="status">{t('status.loading')}</p>
      ) : restaurants.data.length === 0 ? (
        <p>{t('restaurantStatements.noRestaurants')}</p>
      ) : (
        <>
          <PeriodForm
            key={formKey}
            restaurants={restaurants.data}
            initial={period ?? { restaurantId: '', ...defaultPeriod(new Date(), city.timeZone) }}
            onShow={show}
          />
          {period && !periodFits(period.from, period.to) ? (
            <p role="alert">{t('restaurantStatements.invalidPeriod')}</p>
          ) : statement.isError ? (
            <p role="alert">{t('common.failed')}</p>
          ) : period && !statement.data ? (
            <p role="status">{t('status.loading')}</p>
          ) : statement.data?.status === 'refused' ? (
            <p role="alert">
              {t(
                statement.data.refusal === 'invalid_period'
                  ? 'restaurantStatements.invalidPeriod'
                  : 'restaurantStatements.unknownRestaurant',
              )}
            </p>
          ) : statement.data?.status === 'ready' && period ? (
            <>
              <p className="no-print">
                <button type="button" onClick={() => window.print()}>
                  {t('cashDesk.receipt.printA4')}
                </button>{' '}
                <ExportStatementButton key={formKey} period={period} />
              </p>
              <StatementView statement={statement.data.statement} timeZone={city.timeZone} />
            </>
          ) : null}
        </>
      )}
    </main>
  );
}

function PeriodForm({
  restaurants,
  initial,
  onShow,
}: {
  restaurants: { id: string; name: string }[];
  initial: Period;
  onShow: (period: Period) => void;
}) {
  const { t } = useTranslation();
  const [restaurantId, setRestaurantId] = useState(initial.restaurantId);
  const [from, setFrom] = useState(initial.from);
  const [to, setTo] = useState(initial.to);
  const fits = restaurantId !== '' && periodFits(from, to);
  const submit = (event: FormEvent) => {
    event.preventDefault();
    if (fits) onShow({ restaurantId, from, to });
  };
  return (
    <form className="no-print" onSubmit={submit}>
      <label>
        {t('restaurantStatements.restaurant')}{' '}
        <select value={restaurantId} onChange={(event) => setRestaurantId(event.target.value)}>
          <option value="">{t('restaurantStatements.choose')}</option>
          {restaurants.map((restaurant) => (
            <option key={restaurant.id} value={restaurant.id}>
              {restaurant.name}
            </option>
          ))}
        </select>
      </label>{' '}
      <label>
        {t('restaurantStatements.from')}{' '}
        <input type="date" value={from} onChange={(event) => setFrom(event.target.value)} />
      </label>{' '}
      <label>
        {t('restaurantStatements.to')}{' '}
        <input type="date" value={to} onChange={(event) => setTo(event.target.value)} />
      </label>{' '}
      <button type="submit" disabled={!fits}>
        {t('restaurantStatements.show')}
      </button>
      {restaurantId !== '' && !periodFits(from, to) && (
        <p role="alert">{t('restaurantStatements.invalidPeriod')}</p>
      )}
    </form>
  );
}

function ExportStatementButton({ period }: { period: Period }) {
  const requested = useExportStatement();
  return (
    <ExportButton
      request={{
        data: requested.data,
        isPending: requested.isPending,
        isError: requested.isError,
        ask: () => requested.mutate(period),
      }}
    />
  );
}

function StatementView({ statement, timeZone }: { statement: PeriodStatement; timeZone: string }) {
  const { t } = useTranslation();
  const { session } = signedIn.useRouteContext();
  const currency = statement.currency;
  const money = (amount: string) => (currency ? formatMoney({ amount, currency }) : amount);
  const summary: [string, string][] = [
    [t('restaurantStatements.opening'), money(statement.opening)],
    [t('restaurantStatements.orders'), String(statement.orders)],
    [t('restaurantSettlement.statement.itemsValue'), money(statement.itemsValue)],
    [t('restaurantSettlement.statement.commission'), money(statement.commission)],
    [t('restaurantSettlement.statement.discountShare'), money(statement.discountShare)],
    [t('restaurantSettlement.statement.exceptions'), money(statement.exceptions)],
    [t('restaurantStatements.paid'), money(statement.paid)],
    [t('restaurantStatements.closing'), money(statement.closing)],
  ];
  const entryLabel = (line: PeriodStatementLine) => {
    const entry = entryOf(line);
    if (entry.kind !== 'exception') return t(entryKeys[entry.kind]);
    return entry.cause ? t(causeKeys[entry.cause]) : '—';
  };
  return (
    <article className="receipt paper-a4" aria-labelledby="period-statement-title">
      <h1>{t('app.name')}</h1>
      <h2 id="period-statement-title">{t('restaurantStatements.statementTitle')}</h2>
      <p>{statement.restaurantName}</p>
      <p>
        {t('restaurantSettlement.statement.period', {
          from: statement.fromDay,
          to: statement.toDay,
        })}
      </p>
      <p>{t('restaurantStatements.sign')}</p>
      <table>
        <tbody>
          {summary.map(([label, value]) => (
            <tr key={label}>
              <th scope="row">{label}</th>
              <td>{value}</td>
            </tr>
          ))}
        </tbody>
      </table>
      <h3>{t('restaurantStatements.lines')}</h3>
      {statement.lines.length === 0 ? (
        <p>{t('restaurantStatements.noLines')}</p>
      ) : (
        <table>
          <thead>
            <tr>
              <th scope="col">{t('restaurantStatements.column.at')}</th>
              <th scope="col">{t('restaurantSettlement.statement.entry')}</th>
              <th scope="col">{t('restaurantSettlement.statement.order')}</th>
              <th scope="col">{t('restaurantSettlement.statement.itemsValue')}</th>
              <th scope="col">{t('restaurantSettlement.statement.commission')}</th>
              <th scope="col">{t('restaurantSettlement.statement.discountShare')}</th>
              <th scope="col">{t('restaurantSettlement.statement.amount')}</th>
              <th scope="col">{t('restaurantSettlement.statement.reason')}</th>
              <th scope="col">{t('restaurantStatements.column.receipt')}</th>
            </tr>
          </thead>
          <tbody>
            {statement.lines.map((line, index) => (
              <tr key={index}>
                <th scope="row">{formatDateTime(line.at, timeZone)}</th>
                <td>{entryLabel(line)}</td>
                <td>{line.orderNumber ? `#${line.orderNumber}` : '—'}</td>
                <td>
                  {line.itemsValue === null ? '—' : money(line.itemsValue)}
                  {line.pickupLines && line.pickupLines.length > 0 && (
                    <>
                      {' '}
                      {t('restaurantSettlement.statement.pickupLines', {
                        lines: line.pickupLines
                          .map((each) => formatMoney(each))
                          .join(t('captainBalances.and')),
                      })}
                    </>
                  )}
                </td>
                <td>{line.commission === null ? '—' : money(line.commission)}</td>
                <td>{line.discountShare === null ? '—' : money(line.discountShare)}</td>
                <td>{line.amount === null ? '—' : money(line.amount)}</td>
                <td>{line.reason ?? '—'}</td>
                <td>
                  {line.receiptId && line.receiptNumber ? (
                    can(session, CASH_DESK) ? (
                      <Link
                        to="/cash-desk/restaurant-receipts/$receiptId"
                        params={{ receiptId: line.receiptId }}
                      >
                        {line.receiptNumber}
                      </Link>
                    ) : (
                      line.receiptNumber
                    )
                  ) : (
                    '—'
                  )}
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      )}
    </article>
  );
}
