import { useQuery } from '@tanstack/react-query';
import { getRouteApi, Link } from '@tanstack/react-router';
import { useTranslation } from 'react-i18next';
import { canAssign, OPERATIONS_MANAGE } from './assign-captain.js';
import { chosenCity, citiesQuery } from './cities.js';
import { formatMoney, formatTime } from './format.js';
import { actorKey, eventKey, orderQuery } from './order-detail.js';
import { statusKeys, trackKeys, vehicleKey } from './order-labels.js';
import { Badges } from './orders-board-page.js';
import { can } from './session.js';

const route = getRouteApi('/signed-in/orders/$orderId');

// AP §9.3.1: the order detail, read again every 10 seconds. Its actions
// come with their slices; this one has «تعيين كابتن» (AP §9.3.2).
export function OrderDetailPage() {
  const { t } = useTranslation();
  const { orderId } = route.useParams();
  const { city: cityCode } = route.useSearch();
  const { session } = route.useRouteContext();
  const cities = useQuery(citiesQuery);
  const order = useQuery(orderQuery(orderId));
  const timeZone = (cities.data && chosenCity(cities.data, cityCode)?.timeZone) ?? 'Asia/Damascus';
  const time = (at: string) => formatTime(at, timeZone);
  const back = (
    <p>
      <Link to="/orders" search>
        {t('board.title')}
      </Link>
    </p>
  );

  if (order.isError) return <p role="alert">{t('status.error')}</p>;
  if (order.isPending) return <p>{t('status.loading')}</p>;
  if (order.data === null) {
    return (
      <main>
        <p role="alert">{t('order.notFound')}</p>
        {back}
      </main>
    );
  }
  const detail = order.data;
  const money = (amount: string) => formatMoney({ amount, currency: detail.money.currency });
  const { customer } = detail;

  return (
    <main>
      <h1>{t('order.number', { number: detail.number })}</h1>
      <p>
        {t(statusKeys[detail.status])}
        {detail.captainTrack && <span> {t(trackKeys[detail.captainTrack])}</span>}
      </p>
      {detail.promisedAt && <p>{t('order.promisedAt', { time: time(detail.promisedAt) })}</p>}
      {detail.acceptance && (
        <p>
          {t('order.acceptance', {
            time: time(detail.acceptance.at),
            prepMin: detail.acceptance.prepMin,
            due: time(detail.acceptance.prepDueAt),
          })}
        </p>
      )}
      {detail.readyAt && <p>{t('order.readyAt', { time: time(detail.readyAt) })}</p>}
      {detail.cancellation && (
        <p>{t('order.cancelledAt', { time: time(detail.cancellation.at) })}</p>
      )}
      <Badges card={detail} />

      <section aria-labelledby="captain">
        <h2 id="captain">{t('order.captain')}</h2>
        {detail.captain ? (
          <p>
            {detail.captain.name} {t(vehicleKey(detail.captain.vehicle))}
          </p>
        ) : (
          <p>
            <strong>{t('board.noCaptain')}</strong>
          </p>
        )}
        {detail.captainTrack === 'offered' && <p>{t('order.offerOpen')}</p>}
        {can(session, OPERATIONS_MANAGE) && canAssign(detail) && (
          <p>
            <Link to="/orders/$orderId/assign" params={{ orderId }} search>
              {t('assign.title')}
            </Link>
          </p>
        )}
      </section>

      <section aria-labelledby="restaurant">
        <h2 id="restaurant">{t('order.restaurant')}</h2>
        <p>{detail.restaurant.name}</p>
      </section>

      <section aria-labelledby="customer">
        <h2 id="customer">{t('order.customer')}</h2>
        <p>{customer.name ?? t('order.noName')}</p>
        {customer.recipientName && <p>{t('order.recipient', { name: customer.recipientName })}</p>}
        <p>{customer.address.neighbourhood}</p>
        <p>{customer.address.street}</p>
        {customer.address.floor && <p>{customer.address.floor}</p>}
        <p>{t('order.landmark', { landmark: customer.address.landmark })}</p>
        {customer.address.directions && <p>{customer.address.directions}</p>}
        {customer.payIn && <p>{t('order.payIn', { currency: customer.payIn })}</p>}
        {detail.note && <p>{t('order.note', { note: detail.note })}</p>}
      </section>

      <section aria-labelledby="items">
        <h2 id="items">{t('order.items')}</h2>
        <ul>
          {detail.lines.map((line, index) => (
            <li key={index}>
              {t('order.line', { quantity: line.quantity, name: line.name })}{' '}
              {money(line.lineTotal)}
              {line.options.length > 0 && (
                <ul>
                  {line.options.map((option, each) => (
                    <li key={each}>{option.name}</li>
                  ))}
                </ul>
              )}
              {line.note && <p>{line.note}</p>}
            </li>
          ))}
        </ul>
      </section>

      <section aria-labelledby="money">
        <h2 id="money">{t('order.money')}</h2>
        <dl>
          <dt>{t('order.itemsValue')}</dt>
          <dd>{money(detail.money.itemsValue)}</dd>
          <dt>{t('order.deliveryFee')}</dt>
          <dd>{money(detail.money.deliveryFee)}</dd>
          <dt>{t('order.discount')}</dt>
          <dd>{money(detail.money.discount)}</dd>
          <dt>{t('order.rounding')}</dt>
          <dd>{money(detail.money.rounding)}</dd>
          <dt>{t('order.total')}</dt>
          <dd>{money(detail.money.total)}</dd>
          <dt>{t('order.pickupPayment')}</dt>
          <dd>{money(detail.money.pickupPayment)}</dd>
        </dl>
      </section>

      <section aria-labelledby="pickup">
        <h2 id="pickup">{t('order.pickup')}</h2>
        {detail.pickup.at ? (
          <p>{t('order.pickedUpAt', { time: time(detail.pickup.at) })}</p>
        ) : (
          <p>{t('order.notPickedUp')}</p>
        )}
        {detail.pickup.readyNotPressed && <p>{t('order.readyNotPressed')}</p>}
        {detail.pickup.dispute && (
          <p>
            <strong>{t('order.pickupDisputed')}</strong>
          </p>
        )}
      </section>

      {detail.delivery && (
        <section aria-labelledby="delivery">
          <h2 id="delivery">{t('order.delivery')}</h2>
          <p>{t('order.deliveredAt', { time: time(detail.delivery.at) })}</p>
          <p>{t('order.netReceived', { amount: formatMoney(detail.delivery.netReceived) })}</p>
          {detail.delivery.shortfall && (
            <p>
              <strong>
                {t('order.shortfall', { amount: formatMoney(detail.delivery.shortfall.amount) })}
              </strong>
            </p>
          )}
        </section>
      )}

      <section aria-labelledby="timeline">
        <h2 id="timeline">{t('order.timeline')}</h2>
        <ol>
          {detail.timeline.map((event) => {
            const key = eventKey(event.type);
            return (
              <li key={event.version}>
                <time dateTime={event.at}>{time(event.at)}</time>{' '}
                {key ? t(key) : t(statusKeys[event.to])}{' '}
                {t('order.by', { actor: t(actorKey(event.actor.type)) })}
                {event.reason && <span> {event.reason}</span>}
              </li>
            );
          })}
        </ol>
      </section>
      {back}
    </main>
  );
}
