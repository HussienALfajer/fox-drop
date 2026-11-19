import { useQuery } from '@tanstack/react-query';
import { getRouteApi, Link, useNavigate } from '@tanstack/react-router';
import { type FormEvent, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { type City, chosenCity, citiesQuery } from './cities.js';
import { formatAverage, formatDateTime, formatMoney } from './format.js';
import { draftChoicesQuery } from './restaurant-drafts.js';
import {
  accountStatuses,
  listFilterOf,
  type ListedRestaurant,
  type ListFilter,
  looksLikePhone,
  percentText,
  restaurantListQuery,
} from './restaurant-list.js';
import { balanceSide } from './restaurant-settlement.js';

const route = getRouteApi('/signed-in/restaurants');

// AP §9.6.2 «المطاعم» (slice 2.30c): the city's restaurants with their
// columns, filters and search; a name opens «حالة المطاعم» with the
// actions until the profile (2.30d). Unstyled until the design.
export function RestaurantListPage() {
  const { t } = useTranslation();
  const search = route.useSearch();
  const cities = useQuery(citiesQuery);
  const city = cities.data ? chosenCity(cities.data, search.city) : undefined;
  return (
    <main>
      <h1>{t('restaurantList.title')}</h1>
      <p>
        <Link to="/">{t('common.home')}</Link>
      </p>
      <p>{t('restaurantList.explain')}</p>
      {cities.isError ? (
        <p role="alert">{t('common.failed')}</p>
      ) : !city ? (
        <p role="status">{t('status.loading')}</p>
      ) : (
        <Restaurants city={city} />
      )}
    </main>
  );
}

function Restaurants({ city }: { city: City }) {
  const { t } = useTranslation();
  const search = route.useSearch();
  const navigate = useNavigate();
  // A number searched stays in the page, never in the URL.
  const [phone, setPhone] = useState<string | null>(null);
  const [typed, setTyped] = useState(search.q ?? '');
  const filter: ListFilter = {
    ...(search.status ? { status: search.status } : {}),
    ...(search.category ? { category: search.category } : {}),
    ...(search.zone ? { zone: search.zone } : {}),
    ...(phone !== null ? { q: phone } : search.q ? { q: search.q } : {}),
  };
  const choices = useQuery(draftChoicesQuery(city.id));
  const list = useQuery(restaurantListQuery(city.id, filter));
  // The page's own search: the city and the filters, an empty one left out.
  const go = (next: Partial<Record<keyof ListFilter, string | undefined>>) => {
    const merged: Record<string, string | undefined> = {
      city: search.city,
      status: search.status,
      category: search.category,
      zone: search.zone,
      q: search.q,
      ...next,
    };
    void navigate({
      to: '/restaurants',
      search: { ...(merged.city ? { city: merged.city } : {}), ...listFilterOf(merged) },
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
  return (
    <>
      <form onSubmit={submit} aria-label={t('restaurantList.filters')}>
        <label>
          {t('restaurantList.status')}
          <select
            value={search.status ?? ''}
            onChange={(event) => go({ status: event.target.value || undefined })}
          >
            <option value="">{t('restaurantList.all')}</option>
            {accountStatuses.map((status) => (
              <option key={status} value={status}>
                {t(`restaurantList.accountStatus.${status}`)}
              </option>
            ))}
          </select>
        </label>
        <label>
          {t('restaurantList.category')}
          <select
            value={search.category ?? ''}
            onChange={(event) => go({ category: event.target.value || undefined })}
          >
            <option value="">{t('restaurantList.all')}</option>
            {choices.data?.categories.map((category) => (
              <option key={category.id} value={category.id}>
                {category.name}
              </option>
            ))}
          </select>
        </label>
        <label>
          {t('restaurantList.zone')}
          <select
            value={search.zone ?? ''}
            onChange={(event) => go({ zone: event.target.value || undefined })}
          >
            <option value="">{t('restaurantList.all')}</option>
            {choices.data?.zones.map((zone) => (
              <option key={zone.id} value={zone.id}>
                {zone.name}
              </option>
            ))}
          </select>
        </label>
        <label>
          {t('restaurantList.search')}
          <input
            type="search"
            value={typed}
            maxLength={60}
            onChange={(event) => setTyped(event.target.value)}
          />
        </label>
        <button type="submit">{t('restaurantList.find')}</button>
      </form>
      {list.isError ? (
        <p role="alert">{t('common.failed')}</p>
      ) : !list.data ? (
        <p role="status">{t('status.loading')}</p>
      ) : list.data.restaurants.length === 0 ? (
        <p>{t('restaurantList.none')}</p>
      ) : (
        <table aria-label={t('restaurantList.title')}>
          <thead>
            <tr>
              <th scope="col">{t('restaurantList.column.name')}</th>
              <th scope="col">{t('restaurantList.column.state')}</th>
              <th scope="col">{t('restaurantList.column.rating')}</th>
              <th scope="col">{t('restaurantList.column.ordersToday')}</th>
              <th scope="col">{t('restaurantList.column.acceptance')}</th>
              <th scope="col">{t('restaurantList.column.commission')}</th>
              <th scope="col">{t('restaurantList.column.balance')}</th>
              <th scope="col">{t('restaurantList.column.lastOrder')}</th>
            </tr>
          </thead>
          <tbody>
            {list.data.restaurants.map((restaurant) => (
              <Row
                key={restaurant.id}
                restaurant={restaurant}
                city={city}
                currency={list.data.currency}
              />
            ))}
          </tbody>
        </table>
      )}
    </>
  );
}

function Row({
  restaurant,
  city,
  currency,
}: {
  restaurant: ListedRestaurant;
  city: City;
  currency: string | null;
}) {
  const { t } = useTranslation();
  const side = balanceSide(restaurant.balance);
  const amount =
    currency === null
      ? null
      : formatMoney({ amount: restaurant.balance.replace('-', ''), currency });
  return (
    <tr>
      <td>
        {/* A draft opens its wizard; the others their state and actions. */}
        {restaurant.accountStatus === 'draft' ? (
          <Link
            to="/restaurant-drafts/$restaurantId"
            params={{ restaurantId: restaurant.id }}
            search={{ city: city.code, step: 'basics' }}
          >
            {restaurant.nameAr}
          </Link>
        ) : (
          <Link
            to="/restaurants/$restaurantId"
            params={{ restaurantId: restaurant.id }}
            search={{ city: city.code }}
          >
            {restaurant.nameAr}
          </Link>
        )}
        {restaurant.categories.length > 0 && (
          <p>{restaurant.categories.map((category) => category.name).join('، ')}</p>
        )}
        {!restaurant.visible && <p>{t('restaurantList.hidden')}</p>}
      </td>
      <td>
        {t(`restaurantList.accountStatus.${restaurant.accountStatus}`)}
        {restaurant.state && <p>{t(`restaurantList.state.${restaurant.state}`)}</p>}
      </td>
      <td>
        {restaurant.ratingAverage === null
          ? t('restaurantList.noRating')
          : t('restaurantList.rating', {
              average: formatAverage(restaurant.ratingAverage),
              count: restaurant.ratingCount,
            })}
      </td>
      <td>{restaurant.ordersToday}</td>
      <td>{restaurant.acceptanceBp7d === null ? '—' : percentText(restaurant.acceptanceBp7d)}</td>
      <td>{restaurant.commissionBp === null ? '—' : percentText(restaurant.commissionBp)}</td>
      <td>
        {amount === null || side === 'settled'
          ? t('restaurantSettlement.settled')
          : t(`restaurantSettlement.${side}`, { amount })}
      </td>
      <td>
        {restaurant.lastOrderAt === null
          ? '—'
          : formatDateTime(restaurant.lastOrderAt, city.timeZone)}
      </td>
    </tr>
  );
}
