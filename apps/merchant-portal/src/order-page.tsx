import { useQuery } from '@tanstack/react-query';
import { Link } from '@tanstack/react-router';
import { useTranslation } from 'react-i18next';
import { type OrderDetail, orderQuery } from './board.js';
import { formatMoney, formatTime } from './format.js';

// RA §8.4, §17: the order as the board shows it, with the owner's money
// lines and its steps; nothing to press.
export function OrderPage({ orderId }: { orderId: string }) {
  const { t } = useTranslation();
  const read = useQuery(orderQuery(orderId));

  return (
    <main>
      <Link to="/orders">{t('order.back')}</Link>
      {read.isPending ? (
        <p>{t('app.loading')}</p>
      ) : read.isError ? (
        <p role="alert">{t('app.error')}</p>
      ) : read.data === null ? (
        <p>{t('order.notFound')}</p>
      ) : (
        <Detail detail={read.data} />
      )}
    </main>
  );
}

function Detail({ detail }: { detail: OrderDetail }) {
  const { t } = useTranslation();
  const { order, timeline } = detail;
  const money = (amount: string) => formatMoney(amount, order.currency);
  return (
    <>
      <h1>{t('order.title', { number: order.number })}</h1>
      <p>{t(`order.status.${order.status}`)}</p>
      <p>
        {order.customer.firstName
          ? t('order.customer', {
              name: order.customer.firstName,
              neighbourhood: order.customer.neighbourhood,
            })
          : t('order.customerNoName', { neighbourhood: order.customer.neighbourhood })}
      </p>
      {order.note && <p>{t('order.note', { note: order.note })}</p>}
      <ul>
        {order.lines.map((line, index) => (
          <li key={index}>
            {t('order.line', { quantity: line.quantity, name: line.name })}
            {line.options.length > 0 &&
              t('order.lineOptions', {
                options: line.options.map((option) => option.name).join('، '),
              })}{' '}
            {money(line.lineTotal)}
            {line.note && t('order.lineNote', { note: line.note })}
          </li>
        ))}
      </ul>
      <p>{t('order.itemsValue', { amount: money(order.itemsValue) })}</p>
      {order.owner &&
        (order.owner.testOrder ? (
          <p>{t('order.testNoCommission')}</p>
        ) : (
          <>
            {order.owner.commission !== null && order.owner.commissionBp !== null && (
              <p>
                {t('order.commission', {
                  percent: order.owner.commissionBp / 100,
                  amount: money(order.owner.commission),
                })}
              </p>
            )}
            {order.owner.discountShare !== null && order.owner.discountShare !== '0' && (
              <p>{t('order.discountShare', { amount: money(order.owner.discountShare) })}</p>
            )}
            {order.owner.merchantNet !== null && (
              <p>{t('order.net', { amount: money(order.owner.merchantNet) })}</p>
            )}
          </>
        ))}
      {order.acceptance && (
        <p>
          {t('order.prep', {
            minutes: order.acceptance.prepMin,
            at: formatTime(order.acceptance.at),
          })}
        </p>
      )}
      {order.readyAt && <p>{t('order.readyAt', { at: formatTime(order.readyAt) })}</p>}
      {order.pickup.pickedUpAt && (
        <p>{t('order.pickedUpAt', { at: formatTime(order.pickup.pickedUpAt) })}</p>
      )}
      <h2>{t('order.timelineTitle')}</h2>
      <ol>
        {timeline.map((step) => (
          <li key={step.step}>
            {t('order.stepAt', { step: t(`order.step.${step.step}`), at: formatTime(step.at) })}
          </li>
        ))}
      </ol>
    </>
  );
}
