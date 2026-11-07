import { useQuery } from '@tanstack/react-query';
import { getRouteApi, Link, Outlet } from '@tanstack/react-router';
import { useTranslation } from 'react-i18next';
import { canAssign, OPERATIONS_MANAGE } from './assign-captain.js';
import { chosenCity, citiesQuery } from './cities.js';
import { formatMoney, formatTime } from './format.js';
import {
  actorKey,
  awayKeys,
  cancelReasonKeys,
  eventKey,
  eventReason,
  orderQuery,
  outcomeKeys,
  requestStatusKeys,
  shortfallKeys,
} from './order-detail.js';
import { statusKeys, trackKeys, vehicleKey } from './order-labels.js';
import { Badges } from './orders-board-page.js';
import { can } from './session.js';

const route = getRouteApi('/signed-in/orders/$orderId');

type Lines = { amount: string; currency: string }[];

function linesText(lines: Lines): string {
  return lines.map(formatMoney).join(' + ');
}

// AP §9.3.1: the order detail beside the board, read again every 10
// seconds. Its actions come with their slices; this one has «تعيين كابتن»
// (AP §9.3.2), whose picker opens below it.
export function OrderDetailPage() {
  const { t } = useTranslation();
  const { orderId } = route.useParams();
  const { city: cityCode } = route.useSearch();
  const { session } = route.useRouteContext();
  const cities = useQuery(citiesQuery);
  const order = useQuery(orderQuery(orderId));
  // The board's city; the order's own comes with a second city.
  const city = cities.data && chosenCity(cities.data, cityCode);
  const close = (
    <p>
      <Link to="/orders" search>
        {t('order.close')}
      </Link>
    </p>
  );

  if (order.isError) return <p role="alert">{t('status.error')}</p>;
  if (order.isPending || !city) return <p>{t('status.loading')}</p>;
  if (order.data === null) {
    return (
      <section>
        <p role="alert">{t('order.notFound')}</p>
        {close}
      </section>
    );
  }
  const detail = order.data;
  const time = (at: string) => formatTime(at, city.timeZone);
  const money = (amount: string) => formatMoney({ amount, currency: detail.money.currency });
  const { customer, pickup, delivery, cancellation } = detail;

  return (
    <section aria-labelledby="order-title">
      <h2 id="order-title">{t('order.number', { number: detail.number })}</h2>
      {close}
      <p>
        {t(statusKeys[detail.status])}
        {detail.captainTrack && <span> {t(trackKeys[detail.captainTrack])}</span>}
        {delivery && <span> {t(outcomeKeys[delivery.outcome])}</span>}
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
      {cancellation && (
        <p>
          {t('order.cancelledAt', { time: time(cancellation.at) })}
          {cancellation.reason in cancelReasonKeys && (
            <span> {t(cancelReasonKeys[cancellation.reason]!)}</span>
          )}
        </p>
      )}
      <Badges card={detail} />

      <h3>{t('order.captain')}</h3>
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
      <Outlet />

      <h3>{t('order.restaurant')}</h3>
      <p>{detail.restaurant.name}</p>

      <h3>{t('order.customer')}</h3>
      <p>{customer.name ?? t('order.noName')}</p>
      {customer.recipientName && <p>{t('order.recipient', { name: customer.recipientName })}</p>}
      <p>{customer.address.neighbourhood}</p>
      <p>{customer.address.street}</p>
      {customer.address.floor && <p>{customer.address.floor}</p>}
      <p>{t('order.landmark', { landmark: customer.address.landmark })}</p>
      {customer.address.directions && <p>{customer.address.directions}</p>}
      {customer.payIn && <p>{t('order.payIn', { currency: customer.payIn })}</p>}
      {detail.note && <p>{t('order.note', { note: detail.note })}</p>}
      {customer.arrival && (
        <p>
          {t('order.atCustomer', { time: time(customer.arrival.at) })}
          {customer.arrival.away && (
            <strong>
              {' '}
              {t('order.alert.awayFromAddress')} {t(awayKeys[customer.arrival.away.reason])}{' '}
              {customer.arrival.away.note}
            </strong>
          )}
        </p>
      )}

      <h3>{t('order.items')}</h3>
      <ul>
        {detail.lines.map((line, index) => (
          <li key={index}>
            {t('order.line', { quantity: line.quantity, name: line.name })} {money(line.lineTotal)}
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

      <h3>{t('order.money')}</h3>
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

      <h3>{t('order.pickup')}</h3>
      {pickup.at ? (
        <p>{t('order.pickedUpAt', { time: time(pickup.at) })}</p>
      ) : (
        <p>{t('order.notPickedUp')}</p>
      )}
      {pickup.readyNotPressed && <p>{t('order.readyNotPressed')}</p>}
      {pickup.requests.length > 0 && (
        <ul>
          {pickup.requests.map((request) => (
            <li key={request.id}>
              {t('order.request.line', {
                time: time(request.openedAt),
                status: t(requestStatusKeys[request.status]),
                lines: linesText(request.bookedLines ?? request.lines),
              })}
              {request.receivedLines && (
                <span>
                  {' '}
                  {t('order.request.received', { lines: linesText(request.receivedLines) })}
                </span>
              )}
            </li>
          ))}
        </ul>
      )}
      {pickup.dispute && (
        <p>
          <strong>
            {t('order.pickupDisputed')}{' '}
            {t('order.request.received', { lines: linesText(pickup.dispute.receivedLines) })}
          </strong>
        </p>
      )}

      {delivery && (
        <>
          <h3>{t('order.delivery')}</h3>
          <p>{t('order.deliveredAt', { time: time(delivery.at) })}</p>
          <p>{t('order.received', { lines: linesText(delivery.received) })}</p>
          {delivery.change.length > 0 && (
            <p>{t('order.change', { lines: linesText(delivery.change) })}</p>
          )}
          <p>{t('order.netReceived', { amount: formatMoney(delivery.netReceived) })}</p>
          {delivery.shortfall && (
            <p>
              <strong>
                {t('order.shortfall', { amount: formatMoney(delivery.shortfall.amount) })}{' '}
                {t(shortfallKeys[delivery.shortfall.reason])} {delivery.shortfall.note}
              </strong>
            </p>
          )}
        </>
      )}

      <h3>{t('order.timeline')}</h3>
      <ol>
        {detail.timeline.map((event) => {
          const key = eventKey(event.type);
          const reason = eventReason(event);
          return (
            <li key={event.version}>
              <time dateTime={event.at}>{time(event.at)}</time>{' '}
              {key ? t(key) : t(statusKeys[event.to])}{' '}
              {t('order.by', { actor: t(actorKey(event.actor.type)) })}
              {reason && <span> {'key' in reason ? t(reason.key) : reason.text}</span>}
            </li>
          );
        })}
      </ol>
    </section>
  );
}
