import { useInfiniteQuery } from '@tanstack/react-query';
import { Link } from '@tanstack/react-router';
import { use, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { ExportButton } from './export-button.js';
import { formatDateTime, formatMoney } from './format.js';
import {
  type HistoryFilter,
  historyQuery,
  numberOf,
  ORDER_STATUSES,
  type OrderStatus,
} from './history.js';
import { TimeZoneContext } from './live.js';
import { rangeProblem } from './period.js';

// RA §8.18, §17 (slice 2.45d): «السجل», the owner's orders of any range up
// to a year with the commission and the net, each opening its detail, and
// «تصدير Excel» of the range read.
export function HistoryPage() {
  const { t } = useTranslation();
  const timeZone = use(TimeZoneContext);
  const [filter, setFilter] = useState<HistoryFilter>({
    from: null,
    to: null,
    status: null,
    number: null,
  });
  const [form, setForm] = useState({ from: '', to: '', status: '', number: '' });
  const [problem, setProblem] = useState<string | null>(null);
  const read = useInfiniteQuery(historyQuery(filter));
  const first = read.data?.pages[0];
  const range = first?.status === 'ok' ? first.page : null;

  function search() {
    const number = numberOf(form.number);
    if (number === 'invalid') return setProblem(t('history.numberInvalid'));
    const bothEmpty = form.from === '' && form.to === '';
    const found = bothEmpty ? null : rangeProblem(form.from, form.to);
    if (found !== null) return setProblem(t(`period.problem.${found}`));
    setProblem(null);
    setFilter({
      from: bothEmpty ? null : form.from,
      to: bothEmpty ? null : form.to,
      status: form.status === '' ? null : (form.status as OrderStatus),
      number,
    });
  }

  return (
    <main>
      <h1>{t('history.title')}</h1>
      <form
        onSubmit={(event) => {
          event.preventDefault();
          search();
        }}
      >
        <label>
          {t('period.from')}{' '}
          <input
            type="date"
            value={form.from}
            onChange={(e) => setForm({ ...form, from: e.target.value })}
          />
        </label>{' '}
        <label>
          {t('period.to')}{' '}
          <input
            type="date"
            value={form.to}
            onChange={(e) => setForm({ ...form, to: e.target.value })}
          />
        </label>{' '}
        <label>
          {t('history.status')}{' '}
          <select
            value={form.status}
            onChange={(e) => setForm({ ...form, status: e.target.value })}
          >
            <option value="">{t('history.allStatuses')}</option>
            {ORDER_STATUSES.map((status) => (
              <option key={status} value={status}>
                {t(`excel.history.status.${status}`)}
              </option>
            ))}
          </select>
        </label>{' '}
        <label>
          {t('history.number')}{' '}
          <input
            inputMode="numeric"
            dir="ltr"
            value={form.number}
            onChange={(e) => setForm({ ...form, number: e.target.value })}
          />
        </label>{' '}
        <button type="submit">{t('history.search')}</button>
        {problem !== null && <span role="alert">{problem}</span>}
      </form>
      {range && (
        <>
          <p>{t('history.range', { from: range.fromDay, to: range.toDay })}</p>
          <ExportButton
            ask={{
              kind: 'order-history',
              body: {
                from: range.fromDay,
                to: range.toDay,
                status: filter.status,
                number: filter.number,
              },
            }}
          />
        </>
      )}
      {read.isPending ? (
        <p>{t('app.loading')}</p>
      ) : read.isError && !read.data ? (
        <p role="alert">{t('app.error')}</p>
      ) : first?.status === 'refused' ? (
        <p role="alert">{t(`history.refusal.${first.refusal}`)}</p>
      ) : (
        <>
          {read.data.pages.every(
            (page) => page.status !== 'ok' || page.page.orders.length === 0,
          ) && <p>{t('history.empty')}</p>}
          <table>
            <thead>
              <tr>
                <th scope="col">{t('excel.history.column.number')}</th>
                <th scope="col">{t('excel.history.column.time')}</th>
                <th scope="col">{t('excel.history.column.status')}</th>
                <th scope="col">{t('excel.history.column.items')}</th>
                <th scope="col">{t('excel.history.column.itemsValue')}</th>
                <th scope="col">{t('excel.history.column.commission')}</th>
                <th scope="col">{t('excel.history.column.net')}</th>
              </tr>
            </thead>
            <tbody>
              {read.data.pages.flatMap((page) =>
                page.status !== 'ok'
                  ? []
                  : page.page.orders.map((order) => (
                      <tr key={order.id}>
                        <td>
                          <Link to="/orders/$orderId" params={{ orderId: order.id }}>
                            {t('history.orderNumber', { number: order.number })}
                          </Link>
                          {order.testOrder && ` ${t('excel.history.test')}`}
                          {order.redelivery && ` ${t('excel.history.redelivery')}`}
                        </td>
                        <td>{formatDateTime(order.placedAt, timeZone)}</td>
                        <td>{t(`excel.history.status.${order.status}`)}</td>
                        <td>{order.itemCount}</td>
                        <td>{formatMoney(order.itemsValue, order.currency)}</td>
                        <td>
                          {order.owner?.commission != null
                            ? formatMoney(order.owner.commission, order.currency)
                            : ''}
                        </td>
                        <td>
                          {order.owner?.merchantNet != null
                            ? formatMoney(order.owner.merchantNet, order.currency)
                            : ''}
                        </td>
                      </tr>
                    )),
              )}
            </tbody>
          </table>
          {read.hasNextPage && (
            <button
              type="button"
              disabled={read.isFetchingNextPage}
              onClick={() => void read.fetchNextPage()}
            >
              {t('history.more')}
            </button>
          )}
          {read.isFetchNextPageError && <p role="alert">{t('history.moreFailed')}</p>}
        </>
      )}
    </main>
  );
}
