import { useQuery } from '@tanstack/react-query';
import { getRouteApi, Link } from '@tanstack/react-router';
import { useTranslation } from 'react-i18next';
import { chosenCity, citiesQuery } from './cities.js';
import { formatDateTime, formatMoney } from './format.js';
import {
  balanceSide,
  type ExceptionCause,
  type MerchantStatement,
  type MerchantStatementLine,
  type StatementStatus,
  statementParts,
  useMerchantStatement,
  useRestaurantSettlements,
} from './restaurant-settlement.js';
import './receipt-print.css';

const listRoute = getRouteApi('/signed-in/cash-desk/restaurants');
const statementRoute = getRouteApi('/signed-in/cash-desk/merchant-statements/$statementId');

// RA §12.5: the exceptions' labels.
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

// RA §12.3 «غير مسدّد», «مسدّد جزئياً», «مسدّد».
export const statusKeys = {
  unpaid: 'restaurantSettlement.statusLabel.unpaid',
  partly_paid: 'restaurantSettlement.statusLabel.partly_paid',
  paid: 'restaurantSettlement.statusLabel.paid',
} as const satisfies Record<StatementStatus, string>;

const sideKeys = {
  owes: 'restaurantSettlement.owes',
  owed: 'restaurantSettlement.owed',
  settled: 'restaurantSettlement.settled',
} as const;

// + the restaurant owes («عليه»), − the platform owes it («له»).
export function BalanceText({ amount, currency }: { amount: string; currency: string }) {
  const { t } = useTranslation();
  const absolute = amount.startsWith('-') ? amount.slice(1) : amount;
  return (
    <>{t(sideKeys[balanceSide(amount)], { amount: formatMoney({ amount: absolute, currency }) })}</>
  );
}

// AP §9.10.3 «تسوية المطاعم» (slices 2.19a, 2.19b): every restaurant with a
// balance, the overdue first, its latest statement with its status, and
// «تسوية». Unstyled until the design.
export function RestaurantSettlementsPage() {
  const { t } = useTranslation();
  const search = listRoute.useSearch();
  const cities = useQuery(citiesQuery);
  const city = cities.data ? chosenCity(cities.data, search.city) : undefined;
  const list = useRestaurantSettlements(city?.id);
  return (
    <main>
      <h1>{t('restaurantSettlement.title')}</h1>
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
          <p>
            {t('restaurantSettlement.nextCutoff', {
              at: formatDateTime(list.data.nextCutoff, city.timeZone),
            })}
          </p>
          {list.data.restaurants.length === 0 ? (
            <p>{t('restaurantSettlement.none')}</p>
          ) : (
            <table>
              <thead>
                <tr>
                  <th scope="col">{t('restaurantSettlement.restaurant')}</th>
                  <th scope="col">{t('restaurantSettlement.balance')}</th>
                  <th scope="col">{t('restaurantSettlement.latest')}</th>
                  <th scope="col">{t('restaurantSettlement.statement.commission')}</th>
                  <th scope="col">{t('restaurantSettlement.statement.discountShare')}</th>
                  <th scope="col">{t('restaurantSettlement.statement.exceptions')}</th>
                  <th scope="col">{t('restaurantSettlement.unpaid')}</th>
                  <th scope="col">{t('restaurantSettlement.state')}</th>
                  <th scope="col">{t('restaurantSettlement.settle')}</th>
                </tr>
              </thead>
              <tbody>
                {list.data.restaurants.map((row) => (
                  <tr key={row.restaurantId}>
                    <th scope="row">{row.restaurantName}</th>
                    <td>
                      <BalanceText amount={row.balance} currency={row.currency} />
                    </td>
                    <td>
                      {row.latest ? (
                        <Link
                          to="/cash-desk/merchant-statements/$statementId"
                          params={{ statementId: row.latest.id }}
                        >
                          {t('restaurantSettlement.latestLine', {
                            at: formatDateTime(row.latest.cutoff, city.timeZone),
                            amount: formatMoney({
                              amount: row.latest.totalDue,
                              currency: row.currency,
                            }),
                          })}
                        </Link>
                      ) : (
                        t('restaurantSettlement.noStatement')
                      )}
                      {row.latest?.status && <> {t(statusKeys[row.latest.status])}</>}
                    </td>
                    {(['commission', 'discountShare', 'exceptions'] as const).map((part) => (
                      <td key={part}>
                        {row.latest
                          ? formatMoney({ amount: row.latest[part], currency: row.currency })
                          : '—'}
                      </td>
                    ))}
                    <td>{formatMoney({ amount: row.unpaid, currency: row.currency })}</td>
                    <td>
                      {row.overdueSince
                        ? t('restaurantSettlement.overdue', {
                            at: formatDateTime(row.overdueSince, city.timeZone),
                          })
                        : t('restaurantSettlement.onTime')}
                    </td>
                    <td>
                      <Link
                        to="/cash-desk/restaurants/$restaurantId/settle"
                        params={{ restaurantId: row.restaurantId }}
                        search={search}
                      >
                        {t('restaurantSettlement.settle')}
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

// A restaurant's weekly statement, entry by entry, printable on A4 as a
// plain layout until the design (AP §8.7, RA §12.3).
export function MerchantStatementPage() {
  const { t } = useTranslation();
  const { statementId } = statementRoute.useParams();
  const statement = useMerchantStatement(statementId);
  const cities = useQuery(citiesQuery);
  const city = cities.data?.find((each) => each.id === statement.data?.cityId);
  return (
    <main>
      <p className="no-print">
        <Link to="/cash-desk/restaurants">{t('restaurantSettlement.title')}</Link>
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

function StatementView({
  statement,
  timeZone,
}: {
  statement: MerchantStatement;
  timeZone: string;
}) {
  const { t } = useTranslation();
  const money = (amount: string) => formatMoney({ amount, currency: statement.currency });
  const parts = statementParts(statement);
  const orderLabel = (line: MerchantStatementLine) =>
    line.orderNumber ? `#${line.orderNumber}` : '—';
  const summary: [string, string][] = [
    [t('restaurantSettlement.statement.itemsValue'), money(statement.itemsValue)],
    [t('restaurantSettlement.statement.commission'), money(statement.commission)],
    [t('restaurantSettlement.statement.discountShare'), money(statement.discountShare)],
    [t('restaurantSettlement.statement.exceptions'), money(statement.exceptions)],
    [t('restaurantSettlement.statement.weekTotal'), money(statement.weekTotal)],
    [t('restaurantSettlement.statement.previousDue'), money(statement.previousDue)],
    [t('restaurantSettlement.statement.paid'), money(statement.paid)],
    [t('restaurantSettlement.statement.earlierUnpaid'), money(statement.earlierUnpaid)],
    [t('restaurantSettlement.statement.totalDue'), money(statement.totalDue)],
  ];
  return (
    <article className="receipt paper-a4" aria-labelledby="merchant-statement-title">
      <h1>{t('app.name')}</h1>
      <h2 id="merchant-statement-title">{t('restaurantSettlement.statement.title')}</h2>
      <p>{statement.restaurantName}</p>
      {statement.status && (
        <p>
          {t('restaurantSettlement.statement.status', {
            status: t(statusKeys[statement.status]),
          })}{' '}
          {statement.status === 'partly_paid' &&
            t('restaurantSettlement.statement.unpaid', { amount: money(statement.unpaid) })}
        </p>
      )}
      <p>
        {statement.periodFrom
          ? t('restaurantSettlement.statement.period', {
              from: formatDateTime(statement.periodFrom, timeZone),
              to: formatDateTime(statement.cutoff, timeZone),
            })
          : t('restaurantSettlement.statement.periodFirst', {
              to: formatDateTime(statement.cutoff, timeZone),
            })}
      </p>
      <h3>{t('restaurantSettlement.statement.orders', { orders: statement.orders })}</h3>
      {parts.orders.length === 0 ? (
        <p>{t('restaurantSettlement.statement.noOrders')}</p>
      ) : (
        <table>
          <thead>
            <tr>
              <th scope="col">{t('restaurantSettlement.statement.order')}</th>
              <th scope="col">{t('restaurantSettlement.statement.itemsValue')}</th>
              <th scope="col">{t('restaurantSettlement.statement.commission')}</th>
              <th scope="col">{t('restaurantSettlement.statement.discountShare')}</th>
            </tr>
          </thead>
          <tbody>
            {parts.orders.map((line) => (
              <tr key={line.position}>
                <th scope="row">{orderLabel(line)}</th>
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
                <td>{money(line.commission ?? '0')}</td>
                <td>{money(line.discountShare ?? '0')}</td>
              </tr>
            ))}
          </tbody>
        </table>
      )}
      <h3>{t('restaurantSettlement.statement.exceptionsTitle')}</h3>
      {parts.exceptions.length === 0 ? (
        <p>{t('restaurantSettlement.statement.noExceptions')}</p>
      ) : (
        <table>
          <thead>
            <tr>
              <th scope="col">{t('restaurantSettlement.statement.order')}</th>
              <th scope="col">{t('restaurantSettlement.statement.entry')}</th>
              <th scope="col">{t('restaurantSettlement.statement.reason')}</th>
              <th scope="col">{t('restaurantSettlement.statement.amount')}</th>
            </tr>
          </thead>
          <tbody>
            {parts.exceptions.map((line) => (
              <tr key={line.position}>
                <th scope="row">{orderLabel(line)}</th>
                <td>{line.cause ? t(causeKeys[line.cause]) : '—'}</td>
                <td>{line.reason ?? '—'}</td>
                <td>{money(line.amount ?? '0')}</td>
              </tr>
            ))}
          </tbody>
        </table>
      )}
      {parts.payments.length > 0 && (
        <>
          <h3>{t('restaurantSettlement.statement.paymentsTitle')}</h3>
          <table>
            <tbody>
              {parts.payments.map((line) => (
                <tr key={line.position}>
                  <th scope="row">{formatDateTime(line.at, timeZone)}</th>
                  <td>{money(line.amount ?? '0')}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </>
      )}
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
    </article>
  );
}
