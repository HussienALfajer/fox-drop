import { useQuery } from '@tanstack/react-query';
import { getRouteApi, Link, useNavigate } from '@tanstack/react-router';
import { type FormEvent, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { type City, chosenCity, citiesQuery } from './cities.js';
import {
  acceptancePercent,
  captainListQuery,
  captainStatuses,
  type CaptainListFilter,
  type ListedCaptain,
  limitUsePercent,
  type SortColumn,
  sortCaptains,
} from './captain-list.js';
import { formatAverage, formatMoney } from './format.js';
import { vehicleKey } from './order-labels.js';
import { looksLikePhone } from './restaurant-list.js';

const route = getRouteApi('/signed-in/captains');

// AP §9.7.3 «الكباتن» (slice 2.36a): the city's captains with their
// columns, the status filter, the search and the order by any column; a
// name opens the profile. Unstyled until the design.
export function CaptainListPage() {
  const { t } = useTranslation();
  const search = route.useSearch();
  const cities = useQuery(citiesQuery);
  const city = cities.data ? chosenCity(cities.data, search.city) : undefined;
  return (
    <main>
      <h1>{t('captainList.title')}</h1>
      <p>
        <Link to="/">{t('common.home')}</Link>
      </p>
      {cities.isError ? (
        <p role="alert">{t('common.failed')}</p>
      ) : !city ? (
        <p role="status">{t('status.loading')}</p>
      ) : (
        <Captains city={city} />
      )}
    </main>
  );
}

function Captains({ city }: { city: City }) {
  const { t } = useTranslation();
  const search = route.useSearch();
  const navigate = useNavigate();
  // A number searched stays in the page, never in the URL.
  const [phone, setPhone] = useState<string | null>(null);
  const [typed, setTyped] = useState(search.q ?? '');
  const list = useQuery(
    captainListQuery(city.id, search.status ?? null, phone ?? search.q ?? null),
  );
  const go = (next: Partial<Record<keyof CaptainListFilter, string | undefined>>) => {
    const merged = {
      status: search.status,
      q: search.q,
      sort: search.sort,
      dir: search.dir,
      ...next,
    };
    void navigate({
      to: '/captains',
      search: Object.fromEntries(
        Object.entries({ city: search.city, ...merged }).filter(([, value]) => value),
      ),
    });
  };
  const submit = (event: FormEvent) => {
    event.preventDefault();
    const text = typed.trim();
    if (looksLikePhone(text)) {
      setPhone(text);
      go({ q: undefined });
    } else {
      setPhone(null);
      go({ q: text === '' ? undefined : text });
    }
  };
  const sort = search.sort ?? 'name';
  const dir = search.dir ?? 'asc';
  const sortBy = (column: SortColumn) =>
    go({
      sort: column,
      // A second press reverses; money and counts start from the highest.
      dir:
        column === sort
          ? dir === 'asc'
            ? 'desc'
            : 'asc'
          : column === 'name' || column === 'status' || column === 'phase'
            ? 'asc'
            : 'desc',
    });
  const header = (column: SortColumn) => (
    <th
      scope="col"
      aria-sort={column === sort ? (dir === 'asc' ? 'ascending' : 'descending') : undefined}
    >
      <button type="button" onClick={() => sortBy(column)}>
        {t(`captainList.column.${column}`)}
      </button>
    </th>
  );
  const rows = list.data ? sortCaptains(list.data, sort, dir) : null;
  return (
    <>
      <form onSubmit={submit} aria-label={t('captainList.filters')}>
        <label>
          {t('captainList.status')}
          <select
            value={search.status ?? ''}
            onChange={(event) => go({ status: event.target.value || undefined })}
          >
            <option value="">{t('captainList.all')}</option>
            {captainStatuses.map((status) => (
              <option key={status} value={status}>
                {t(`captainList.statusLabel.${status}`)}
              </option>
            ))}
          </select>
        </label>
        <label>
          {t('captainList.search')}
          <input
            type="search"
            value={typed}
            maxLength={60}
            onChange={(event) => setTyped(event.target.value)}
          />
        </label>
        <button type="submit">{t('captainList.find')}</button>
      </form>
      {list.isError ? (
        <p role="alert">{t('common.failed')}</p>
      ) : rows === null ? (
        <p role="status">{t('status.loading')}</p>
      ) : rows.length === 0 ? (
        <p>{t('captainList.none')}</p>
      ) : (
        <table aria-label={t('captainList.title')}>
          <thead>
            <tr>
              {header('name')}
              <th scope="col">{t('captainList.column.phone')}</th>
              <th scope="col">{t('captainList.column.vehicle')}</th>
              {header('status')}
              {header('phase')}
              {header('custody')}
              {header('earnings')}
              {header('ordersToday')}
              {header('acceptance')}
              {header('rating')}
            </tr>
          </thead>
          <tbody>
            {rows.map((captain) => (
              <Row key={captain.id} captain={captain} city={city} />
            ))}
          </tbody>
        </table>
      )}
    </>
  );
}

function Row({ captain, city }: { captain: ListedCaptain; city: City }) {
  const { t } = useTranslation();
  const acceptance = acceptancePercent(captain);
  const use = limitUsePercent(captain);
  return (
    <tr>
      <td>
        <Link
          to="/captains/$captainId"
          params={{ captainId: captain.id }}
          search={{ city: city.code }}
        >
          {captain.name}
        </Link>
      </td>
      <td dir="ltr">{captain.maskedPhone ?? '—'}</td>
      <td>
        {t(vehicleKey(captain.vehicle))}
        {captain.plateNumber !== null && <p dir="ltr">{captain.plateNumber}</p>}
      </td>
      <td>{t(`captainList.statusLabel.${captain.status}`)}</td>
      <td>
        {captain.contractPhase === null ? '—' : t(`captainList.phase.${captain.contractPhase}`)}
      </td>
      <td>
        {t('captainList.custody', {
          usage: formatMoney(captain.custody.usage),
          limit: formatMoney(captain.custody.limit),
        })}
        <meter
          min={0}
          max={100}
          value={use}
          aria-label={t('captainList.limitUse', { percent: use })}
        />
      </td>
      <td>{formatMoney(captain.earnings)}</td>
      <td>{captain.ordersToday}</td>
      <td>
        {acceptance === null
          ? '—'
          : t('captainList.acceptance', {
              percent: acceptance,
              answered: captain.acceptance!.answered,
            })}
      </td>
      <td>
        {captain.ratingAverage === null
          ? t('captainList.noRating')
          : t('captainList.rating', {
              average: formatAverage(captain.ratingAverage),
              count: captain.ratingCount,
            })}
      </td>
    </tr>
  );
}
