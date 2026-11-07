import { useQuery } from '@tanstack/react-query';
import { getRouteApi, Link, useNavigate } from '@tanstack/react-router';
import { useState } from 'react';
import { useTranslation } from 'react-i18next';
import { chosenCity, citiesQuery } from './cities.js';
import { useServerNow } from './clock.js';
import { formatMoney } from './format.js';
import { alertKeys, badgeKeys, slaKeys, statusKeys, trackKeys } from './order-labels.js';
import {
  type BoardFilter,
  boardQuery,
  columns,
  elapsed,
  filterCards,
  filterChoices,
  NO_FILTER,
  type OrderCard,
  sla,
} from './orders-board.js';

const route = getRouteApi('/signed-in/orders');

// «غرفة العمليات» (AP §9.2): every live order of the city in five columns,
// read again every 10 seconds until the ops: channel exists.
export function OrdersBoardPage() {
  const { t } = useTranslation();
  const { city: cityCode } = route.useSearch();
  const navigate = useNavigate();
  const cities = useQuery(citiesQuery);
  const city = cities.data && chosenCity(cities.data, cityCode);
  const board = useQuery({ ...boardQuery(city?.id ?? ''), enabled: city !== undefined });
  const [filter, setFilter] = useState<BoardFilter>(NO_FILTER);
  const now = useServerNow();

  if (cities.isError) return <p role="alert">{t('status.error')}</p>;
  if (!cities.data) return <p>{t('status.loading')}</p>;
  if (!city) return <p>{t('board.noCity')}</p>;

  const cards = board.data ?? [];
  const choices = filterChoices(cards);
  const shown = columns(filterCards(cards, filter, now), now);

  return (
    <main>
      <h1>{t('board.title')}</h1>
      <p>
        <label>
          {t('board.city')}
          <select
            value={city.code}
            onChange={(event) =>
              void navigate({ to: '/orders', search: { city: event.target.value } })
            }
          >
            {cities.data.map((each) => (
              <option key={each.id} value={each.code}>
                {each.name}
              </option>
            ))}
          </select>
        </label>
      </p>
      <fieldset>
        <legend>{t('board.filters')}</legend>
        <label>
          {t('board.restaurant')}
          <select
            value={filter.restaurantId}
            onChange={(event) => setFilter({ ...filter, restaurantId: event.target.value })}
          >
            <option value="">{t('board.all')}</option>
            {choices.restaurants.map((each) => (
              <option key={each.id} value={each.id}>
                {each.name}
              </option>
            ))}
          </select>
        </label>
        <label>
          {t('board.captain')}
          <select
            value={filter.captainId}
            onChange={(event) => setFilter({ ...filter, captainId: event.target.value })}
          >
            <option value="">{t('board.all')}</option>
            {choices.captains.map((each) => (
              <option key={each.id} value={each.id}>
                {each.name}
              </option>
            ))}
          </select>
        </label>
        <label>
          {t('board.neighbourhood')}
          <select
            value={filter.neighbourhood}
            onChange={(event) => setFilter({ ...filter, neighbourhood: event.target.value })}
          >
            <option value="">{t('board.all')}</option>
            {choices.neighbourhoods.map((each) => (
              <option key={each} value={each}>
                {each}
              </option>
            ))}
          </select>
        </label>
        <label>
          <input
            type="checkbox"
            checked={filter.lateOnly}
            onChange={(event) => setFilter({ ...filter, lateOnly: event.target.checked })}
          />
          {t('board.lateOnly')}
        </label>
        <label>
          <input
            type="checkbox"
            checked={filter.noCaptainOnly}
            onChange={(event) => setFilter({ ...filter, noCaptainOnly: event.target.checked })}
          />
          {t('board.noCaptainOnly')}
        </label>
      </fieldset>
      {board.isError && <p role="alert">{t('board.failed')}</p>}
      {board.isPending ? (
        <p>{t('status.loading')}</p>
      ) : (
        shown.map((column) => (
          <section key={column.status} aria-label={t(statusKeys[column.status])}>
            <h2>
              {t('board.columnHeader', {
                name: t(statusKeys[column.status]),
                count: column.cards.length,
                late: column.late,
              })}
            </h2>
            {column.cards.length === 0 ? (
              <p>{t('board.empty')}</p>
            ) : (
              <ul>
                {column.cards.map((card) => (
                  <li key={card.id}>
                    <Card card={card} now={now} cityCode={city.code} />
                  </li>
                ))}
              </ul>
            )}
          </section>
        ))
      )}
      <p>
        <Link to="/">{t('common.home')}</Link>
      </p>
    </main>
  );
}

function Card({ card, now, cityCode }: { card: OrderCard; now: number; cityCode: string }) {
  const { t } = useTranslation();
  const colour = sla(card, now);
  return (
    <article>
      <h3>
        <Link to="/orders/$orderId" params={{ orderId: card.id }} search={{ city: cityCode }}>
          {t('order.number', { number: card.number })}
        </Link>
      </h3>
      <p>{card.restaurant.name}</p>
      <p>{card.neighbourhood}</p>
      <p>
        {t('board.inState', { time: elapsed(card.statusSince, now) })}
        {colour && <span> {t(slaKeys[colour])}</span>}
      </p>
      <p>
        {card.captain ? card.captain.name : <strong>{t('board.noCaptain')}</strong>}
        {card.captainTrack && <span> {t(trackKeys[card.captainTrack])}</span>}
      </p>
      <p>{formatMoney(card.total)}</p>
      <Badges card={card} />
    </article>
  );
}

export function Badges({ card }: { card: OrderCard }) {
  const { t } = useTranslation();
  const badges = (Object.keys(badgeKeys) as (keyof typeof badgeKeys)[]).filter(
    (badge) => card.badges[badge],
  );
  if (badges.length === 0 && card.alerts.length === 0) return null;
  return (
    <ul>
      {card.alerts.map((alert) => (
        <li key={alert}>
          <strong>{t(alertKeys[alert])}</strong>
        </li>
      ))}
      {badges.map((badge) => (
        <li key={badge}>{t(badgeKeys[badge])}</li>
      ))}
    </ul>
  );
}
