import { useQuery } from '@tanstack/react-query';
import { getRouteApi, Link, Outlet } from '@tanstack/react-router';
import { useTranslation } from 'react-i18next';
import { canAssign, OPERATIONS_MANAGE } from './assign-captain.js';
import { chosenCity, citiesQuery } from './cities.js';
import { formatMoney, formatTime } from './format.js';
import { CancelOrder } from './order-cancel-page.js';
import { canCancel } from './order-cancel.js';
import {
  actorKey,
  cancelReasonKeys,
  cashKeys,
  eventKey,
  eventReason,
  orderQuery,
  outcomeKeys,
  requestStatusKeys,
  responsibleKeys,
} from './order-detail.js';
import { statusKeys, trackKeys, vehicleKey } from './order-labels.js';
import { DecideOnBehalf } from './order-on-behalf-page.js';
import { canDecide } from './order-on-behalf.js';
import { Badges } from './orders-board-page.js';
import {
  canResend,
  type ResendTarget,
  resendTargets,
  useResendNotification,
} from './resend-notification.js';
import { can } from './session.js';

const route = getRouteApi('/signed-in/orders/$orderId');

type Lines = { amount: string; currency: string }[];

function linesText(lines: Lines): string {
  return lines.map(formatMoney).join(' + ');
}

// AP §9.3.1: the order detail beside the board, live over the board's
// channel. Its actions come with their slices: «تعيين كابتن» (AP §9.3.2),
// whose picker opens below it, while placed «قبول نيابة عن المطعم» and
// «رفض نيابة عن المطعم», and until pickup «إلغاء الطلب».
export function OrderDetailPage() {
  const { t } = useTranslation();
  const { orderId } = route.useParams();
  const { city: cityCode } = route.useSearch();
  const { session } = route.useRouteContext();
  const cities = useQuery(citiesQuery);
  // The board's city; the order's own comes with a second city.
  const city = cities.data && chosenCity(cities.data, cityCode);
  const order = useQuery(orderQuery(orderId, city?.id));
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
  const { customer, pickup, delivery, cancellation, rejection } = detail;
  // The reason as chosen, or the timer's (AP §8.3); an unknown code is hidden.
  const cancelLabel =
    cancellation &&
    (cancellation.label ??
      (cancellation.reason in cancelReasonKeys ? t(cancelReasonKeys[cancellation.reason]!) : null));

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
        <>
          <p>
            {t('order.cancelledAt', { time: time(cancellation.at) })}{' '}
            {cancelLabel && t('order.cancellation.title', { label: cancelLabel })}
          </p>
          <p>{t('order.cancellation.by', { actor: t(actorKey(cancellation.by.type)) })}</p>
          {cancellation.note && (
            <p>
              {t(
                cancellation.by.type === 'admin'
                  ? 'order.cancellation.opsNote'
                  : 'order.cancellation.customerNote',
                { note: cancellation.note },
              )}
            </p>
          )}
          {cancellation.customerText && (
            <p>{t('order.cancellation.customerText', { text: cancellation.customerText })}</p>
          )}
          {cancellation.responsible && (
            <p>
              {t('order.cancellation.responsible', {
                party: t(responsibleKeys[cancellation.responsible]),
              })}
            </p>
          )}
          {cancellation.foodPrepared && <p>{t('order.cancellation.foodPrepared')}</p>}
          {cancellation.cash && (
            <p>{t('order.cancellation.cash', { answer: t(cashKeys[cancellation.cash]) })}</p>
          )}
          {cancellation.merchantCredit && (
            <p>
              {t('order.cancellation.merchantCredit', {
                amount: formatMoney(cancellation.merchantCredit),
              })}
            </p>
          )}
          {cancellation.captainCompensation && (
            <p>
              {t('order.cancellation.captainCompensation', {
                amount: formatMoney(cancellation.captainCompensation),
              })}
            </p>
          )}
          {cancellation.acknowledgedAt && (
            <p>
              {t('order.cancellation.acknowledged', { time: time(cancellation.acknowledgedAt) })}
            </p>
          )}
          {cancellation.captainSeenAt && (
            <p>{t('order.cancellation.captainSeen', { time: time(cancellation.captainSeenAt) })}</p>
          )}
        </>
      )}
      {rejection && (
        <>
          <p>
            {t('order.rejectedAt', { time: time(rejection.at) })}{' '}
            {t('order.rejection.title', { label: rejection.label })}
          </p>
          {rejection.byOperations && <p>{t('order.rejection.byOperations')}</p>}
          {rejection.itemIds.length > 0 && (
            <p>
              {t('order.rejection.items', {
                names: [
                  ...new Set(
                    detail.lines
                      .filter((line) => rejection.itemIds.includes(line.itemId))
                      .map((line) => line.name),
                  ),
                ].join('، '),
              })}
            </p>
          )}
          <p>{t('order.rejection.customerText', { text: rejection.customerText })}</p>
        </>
      )}
      <Badges card={detail} />
      {canDecide(session, detail) && (
        <DecideOnBehalf
          key={orderId}
          orderId={orderId}
          choices={detail.onBehalf}
          lines={detail.lines}
        />
      )}
      {canCancel(session, detail) && (
        <CancelOrder
          key={orderId}
          orderId={orderId}
          status={detail.status}
          version={detail.version}
          choices={detail.cancelChoices}
        />
      )}
      {canResend(session) && (
        <ResendNotification orderId={orderId} targets={resendTargets(detail)} />
      )}

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
              {t('order.alert.awayFromAddress')} {customer.arrival.away.label}{' '}
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
                {delivery.shortfall.label} {delivery.shortfall.note}
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
          // AP §9.3.1 «cancellation (reason and party)»: the reason as chosen
          // and the responsible party, beside operations' note.
          const cancelled = event.type === 'order.cancelled' && cancellation;
          return (
            <li key={event.version}>
              <time dateTime={event.at}>{time(event.at)}</time>{' '}
              {key ? t(key) : t(statusKeys[event.to])}{' '}
              {t('order.by', { actor: t(actorKey(event.actor.type)) })}
              {cancelled && cancelLabel && <span> {cancelLabel}</span>}
              {cancelled && cancellation.responsible && (
                <span>
                  {' '}
                  {t('order.cancellation.responsible', {
                    party: t(responsibleKeys[cancellation.responsible]),
                  })}
                </span>
              )}
              {cancelled && cancellation.by.type === 'customer' && cancellation.note && (
                <span> {cancellation.note}</span>
              )}
              {reason && !(cancelled && 'key' in reason) && (
                <span> {'key' in reason ? t(reason.key) : reason.text}</span>
              )}
            </li>
          );
        })}
      </ol>
    </section>
  );
}

const targetKeys = {
  customer: 'order.resend.customer',
  merchant: 'order.resend.merchant',
  captain: 'order.resend.captain',
} as const satisfies Record<ResendTarget, string>;

// AP §9.3.2 «إعادة إرسال الإشعار»: the order's latest push to that party,
// sent again.
function ResendNotification({ orderId, targets }: { orderId: string; targets: ResendTarget[] }) {
  const { t } = useTranslation();
  const resend = useResendNotification(orderId);
  if (targets.length === 0) return null;
  const result = resend.data;
  return (
    <section>
      <h3>{t('order.resend.title')}</h3>
      {targets.map((to) => (
        <button
          key={to}
          type="button"
          disabled={resend.isPending}
          onClick={() => resend.mutate(to)}
        >
          {t(targetKeys[to])}
        </button>
      ))}
      {resend.isError && <p role="alert">{t('common.failed')}</p>}
      {result?.status === 'sent' && (
        <p role="status">{t('order.resend.sent', { text: result.body })}</p>
      )}
      {result?.status === 'refused' && (
        <p role="alert">
          {t(
            result.refusal === 'nothing_to_resend'
              ? 'order.resend.nothingToResend'
              : 'order.resend.notActive',
          )}
        </p>
      )}
    </section>
  );
}
