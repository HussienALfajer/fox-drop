import { useQuery } from '@tanstack/react-query';
import { getRouteApi, Link, useNavigate } from '@tanstack/react-router';
import { type FormEvent, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { canSeeCaptains, captainListQuery } from './captain-list.js';
import { type City, chosenCity, citiesQuery } from './cities.js';
import { ExportButton } from './export-button.js';
import { formatDateTime, formatMoney } from './format.js';
import { outcomeKeys, responsibleKeys } from './order-detail.js';
import {
  canExport,
  canSearchByPhone,
  historyBodyOf,
  HistoryRefusedError,
  type HistorySearch,
  KINDS,
  OUTCOMES,
  RESPONSIBLES,
  STATUSES,
  ExportTooBigError,
  useExportOrderHistory,
  useOrderHistory,
} from './order-history.js';
import { statusKeys } from './order-labels.js';
import { draftChoicesQuery } from './restaurant-drafts.js';
import { canSeeRestaurantList, restaurantListQuery } from './restaurant-list.js';

const route = getRouteApi('/signed-in/order-history');

const refusalKeys = {
  invalid_period: 'orderHistory.refused.invalidPeriod',
  invalid_phone: 'orderHistory.refused.invalidPhone',
  phone_not_allowed: 'orderHistory.refused.phoneNotAllowed',
} as const;

// AP §9.5 «سجل الطلبات» (slice 2.40): every order of the city by the
// filters, newest first, 50 at a time; a number opens the order's detail
// beside the board (AP §9.3.1), where OWN and FIN correct a finished one.
// Unstyled until the design.
export function OrderHistoryPage() {
  const { t } = useTranslation();
  const search = route.useSearch();
  const cities = useQuery(citiesQuery);
  const city = cities.data ? chosenCity(cities.data, search.city) : undefined;
  return (
    <main>
      <h1>{t('orderHistory.title')}</h1>
      <p>{t('orderHistory.readOnly')}</p>
      {cities.isError ? (
        <p role="alert">{t('common.failed')}</p>
      ) : !city ? (
        <p role="status">{t('status.loading')}</p>
      ) : (
        <History city={city} />
      )}
    </main>
  );
}

function History({ city }: { city: City }) {
  const { t } = useTranslation();
  const { session } = route.useRouteContext();
  const { city: cityCode, ...search } = route.useSearch();
  const navigate = useNavigate();
  // The phone stays in the page and the POST's body, never in the URL.
  const [phone, setPhone] = useState('');
  const [typedPhone, setTypedPhone] = useState('');
  const [form, setForm] = useState<HistorySearch>(search);
  const body = historyBodyOf(city.id, search, phone);
  const history = useOrderHistory(body);
  const requested = useExportOrderHistory();
  const restaurants = useQuery({
    ...restaurantListQuery(city.id, {}),
    enabled: canSeeRestaurantList(session),
  });
  const captains = useQuery({
    ...captainListQuery(city.id, null, null),
    enabled: canSeeCaptains(session),
  });
  const choices = useQuery({
    ...draftChoicesQuery(city.id),
    enabled: canSeeRestaurantList(session),
  });
  const set = (key: keyof HistorySearch, value: string) =>
    setForm((before) => ({ ...before, [key]: value === '' ? undefined : value }));
  const submit = (event: FormEvent) => {
    event.preventDefault();
    setPhone(typedPhone);
    void navigate({
      to: '/order-history',
      search: Object.fromEntries(
        Object.entries({ city: cityCode, ...form }).filter(([, value]) => value),
      ),
    });
  };
  const rows = history.data?.pages.flatMap((page) => page.orders) ?? null;
  const refusal = history.error instanceof HistoryRefusedError ? history.error.refusal : null;
  const select = (
    key: 'status' | 'outcome' | 'responsible' | 'restaurant' | 'captain' | 'zone',
    label: string,
    options: { value: string; label: string }[],
  ) => (
    <label>
      {label}
      <select value={form[key] ?? ''} onChange={(event) => set(key, event.target.value)}>
        <option value="">{t('orderHistory.any')}</option>
        {options.map((option) => (
          <option key={option.value} value={option.value}>
            {option.label}
          </option>
        ))}
      </select>
    </label>
  );
  return (
    <>
      <form onSubmit={submit} aria-label={t('orderHistory.filters')}>
        <label>
          {t('orderHistory.number')}
          <input
            value={form.number ?? ''}
            maxLength={13}
            onChange={(event) => set('number', event.target.value.trim())}
          />
        </label>
        {canSearchByPhone(session) && (
          <label>
            {t('orderHistory.phone')}
            <input
              type="tel"
              value={typedPhone}
              maxLength={30}
              onChange={(event) => setTypedPhone(event.target.value)}
            />
          </label>
        )}
        {restaurants.data &&
          select(
            'restaurant',
            t('orderHistory.column.restaurant'),
            restaurants.data.restaurants.map((each) => ({ value: each.id, label: each.nameAr })),
          )}
        {captains.data &&
          select(
            'captain',
            t('orderHistory.column.captain'),
            captains.data.map((each) => ({ value: each.id, label: each.name })),
          )}
        <label>
          {t('orderHistory.from')}
          <input
            type="date"
            value={form.from ?? ''}
            onChange={(event) => set('from', event.target.value)}
          />
        </label>
        <label>
          {t('orderHistory.to')}
          <input
            type="date"
            value={form.to ?? ''}
            onChange={(event) => set('to', event.target.value)}
          />
        </label>
        {select(
          'status',
          t('orderHistory.column.status'),
          STATUSES.map((each) => ({ value: each, label: t(statusKeys[each]) })),
        )}
        {select(
          'outcome',
          t('orderHistory.column.outcome'),
          OUTCOMES.map((each) => ({ value: each, label: t(outcomeKeys[each]) })),
        )}
        {select(
          'responsible',
          t('orderHistory.column.responsible'),
          RESPONSIBLES.map((each) => ({ value: each, label: t(responsibleKeys[each]) })),
        )}
        <label>
          {t('orderHistory.column.code')}
          <input
            value={form.code ?? ''}
            maxLength={40}
            onChange={(event) => set('code', event.target.value.trim())}
          />
        </label>
        {choices.data &&
          select(
            'zone',
            t('orderHistory.zone'),
            choices.data.zones.map((each) => ({ value: each.id, label: each.name })),
          )}
        <label>
          {t('orderHistory.column.kind')}
          <select
            value={form.kind ?? 'all'}
            onChange={(event) =>
              set('kind', event.target.value === 'all' ? '' : event.target.value)
            }
          >
            {KINDS.map((each) => (
              <option key={each} value={each}>
                {t(`orderHistory.kind.${each}`)}
              </option>
            ))}
          </select>
        </label>
        <button type="submit">{t('orderHistory.find')}</button>
      </form>
      <p>
        {canExport(search) ? (
          <ExportButton
            key={JSON.stringify(body)}
            request={{
              data: requested.data,
              isPending: requested.isPending,
              isError: requested.isError && !(requested.error instanceof ExportTooBigError),
              ask: () => requested.mutate(body),
            }}
          />
        ) : (
          t('orderHistory.exportNeedsPeriod')
        )}
      </p>
      {requested.error instanceof ExportTooBigError ? (
        <p role="alert">{t('orderHistory.refused.tooManyRows')}</p>
      ) : null}
      {refusal ? (
        <p role="alert">{t(refusalKeys[refusal])}</p>
      ) : history.isError ? (
        <p role="alert">{t('common.failed')}</p>
      ) : rows === null ? (
        <p role="status">{t('status.loading')}</p>
      ) : rows.length === 0 ? (
        <p>{t('orderHistory.empty')}</p>
      ) : (
        <table>
          <thead>
            <tr>
              {(
                [
                  'number',
                  'time',
                  'restaurant',
                  'neighbourhood',
                  'captain',
                  'status',
                  'outcome',
                  'responsible',
                  'total',
                  'deliveryTime',
                  'code',
                  'kind',
                ] as const
              ).map((column) => (
                <th key={column} scope="col">
                  {t(`orderHistory.column.${column}`)}
                </th>
              ))}
            </tr>
          </thead>
          <tbody>
            {rows.map((row) => (
              <tr key={row.id}>
                <td>
                  <Link
                    to="/orders/$orderId"
                    params={{ orderId: row.id }}
                    search={{ city: city.code }}
                  >
                    {t('order.number', { number: row.number })}
                  </Link>
                </td>
                <td>{formatDateTime(row.placedAt, city.timeZone)}</td>
                <td>{row.restaurantName}</td>
                <td>{row.neighbourhood}</td>
                <td>{row.captainName ?? t('orderHistory.none')}</td>
                <td>{t(statusKeys[row.status])}</td>
                <td>{row.outcome ? t(outcomeKeys[row.outcome]) : t('orderHistory.none')}</td>
                <td>
                  {row.responsible ? t(responsibleKeys[row.responsible]) : t('orderHistory.none')}
                </td>
                <td>{formatMoney(row.total)}</td>
                <td>
                  {row.deliveryMinutes === null
                    ? t('orderHistory.none')
                    : t('orderHistory.minutes', { minutes: row.deliveryMinutes })}
                </td>
                <td>{row.code ?? t('orderHistory.none')}</td>
                <td>
                  {row.redelivery
                    ? t('orderHistory.redelivery')
                    : t(row.testOrder ? 'orderHistory.kind.test' : 'orderHistory.kind.real')}
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      )}
      {history.hasNextPage && (
        <button
          type="button"
          disabled={history.isFetchingNextPage}
          onClick={() => void history.fetchNextPage()}
        >
          {t('orderHistory.more')}
        </button>
      )}
    </>
  );
}
