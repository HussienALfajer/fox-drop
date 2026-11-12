import { useQuery } from '@tanstack/react-query';
import { getRouteApi, Link } from '@tanstack/react-router';
import { useTranslation } from 'react-i18next';
import { CASH_DESK, type CaptainBalance, useBalances } from './cash-desk.js';
import { type City, chosenCity, citiesQuery } from './cities.js';
import { formatDateTime, formatMoney } from './format.js';
import { can } from './session.js';

const route = getRouteApi('/signed-in/captain-balances');
const signedIn = getRouteApi('/signed-in');

const blockKeys = {
  closed_due: 'captainBalances.block.closed_due',
  cash_limit: 'captainBalances.block.cash_limit',
} as const satisfies Record<CaptainBalance['blocks'][number], string>;

const statusKeys = {
  active: 'cashDesk.status.active',
  suspended: 'cashDesk.status.suspended',
  terminated: 'cashDesk.status.terminated',
} as const satisfies Record<CaptainBalance['status'], string>;

// AP §9.10.2 «أرصدة الكباتن» (slice 2.17b): every captain's money, the
// highest custody first; «سجّل تسليماً» opens the desk for that captain.
// Unstyled until the design.
export function CaptainBalancesPage() {
  const { t } = useTranslation();
  const search = route.useSearch();
  const cities = useQuery(citiesQuery);
  const city = cities.data ? chosenCity(cities.data, search.city) : undefined;
  const balances = useBalances(city?.id);
  return (
    <main>
      <h1>{t('captainBalances.title')}</h1>
      <p>
        <Link to="/">{t('common.home')}</Link>
      </p>
      {cities.isError || balances.isError ? (
        <p role="alert">{t('common.failed')}</p>
      ) : !city || !balances.data ? (
        <p role="status">{t('status.loading')}</p>
      ) : balances.data.length === 0 ? (
        <p>{t('captainBalances.none')}</p>
      ) : (
        <BalancesTable rows={balances.data} city={city} />
      )}
    </main>
  );
}

function BalancesTable({ rows, city }: { rows: CaptainBalance[]; city: City }) {
  const { t } = useTranslation();
  const { session } = signedIn.useRouteContext();
  const money = (value: { amount: string; currency: string }) => formatMoney(value);
  const date = (at: string | null) =>
    at ? formatDateTime(at, city.timeZone) : t('captainBalances.never');
  return (
    <table>
      <thead>
        <tr>
          <th scope="col">{t('captainBalances.captain')}</th>
          <th scope="col">{t('captainBalances.custody')}</th>
          <th scope="col">{t('captainBalances.closedDue')}</th>
          <th scope="col">{t('captainBalances.limit')}</th>
          <th scope="col">{t('captainBalances.blocked')}</th>
          <th scope="col">{t('captainBalances.earnings')}</th>
          <th scope="col">{t('captainBalances.lastHandIn')}</th>
          <th scope="col">{t('captainBalances.lastPayout')}</th>
          <th scope="col">{t('captainBalances.actions')}</th>
        </tr>
      </thead>
      <tbody>
        {rows.map((row) => {
          const base = row.closedDue.currency;
          const usage =
            BigInt(row.limit.amount) === 0n
              ? 0n
              : (BigInt(row.usage.amount) * 100n) / BigInt(row.limit.amount);
          return (
            <tr key={row.captainId}>
              <th scope="row">
                {row.name} {t(statusKeys[row.status])}
              </th>
              <td>
                <ul>
                  {row.currencies
                    .filter((line) => BigInt(line.balance) !== 0n)
                    .map((line) => (
                      <li key={line.currency}>
                        {money({ amount: line.balance, currency: line.currency })}
                        {line.currency !== base &&
                          ` ${t('captainBalances.inBase', {
                            amount: money({ amount: line.balanceInBase, currency: base }),
                          })}`}
                      </li>
                    ))}
                </ul>
                {t('captainBalances.total', {
                  amount: money({ amount: row.custodyInBase, currency: base }),
                })}
              </td>
              <td>{money(row.closedDue)}</td>
              <td>
                {t('captainBalances.usage', { limit: money(row.limit), pct: usage.toString() })}
              </td>
              <td>
                {row.blocks.length === 0
                  ? t('captainBalances.notBlocked')
                  : row.blocks.map((block) => t(blockKeys[block])).join(t('captainBalances.and'))}
                {row.handInGrace &&
                  ` ${t('captainBalances.grace', {
                    until: formatDateTime(row.handInGrace.until, city.timeZone),
                  })}`}
              </td>
              <td>{money(row.earnings)}</td>
              <td>{date(row.lastHandInAt)}</td>
              <td>{date(row.lastPayoutAt)}</td>
              <td>
                {can(session, CASH_DESK) && (
                  <Link to="/cash-desk" search={{ city: city.code, captain: row.captainId }}>
                    {t('captainBalances.record')}
                  </Link>
                )}
              </td>
            </tr>
          );
        })}
      </tbody>
    </table>
  );
}
