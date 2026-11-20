import { useQuery } from '@tanstack/react-query';
import { Link } from '@tanstack/react-router';
import { use } from 'react';
import { useTranslation } from 'react-i18next';
import {
  type BoardOrder,
  boardColumns,
  boardQuery,
  captainLine,
  columns,
  isLate,
  itemCount,
  timerOf,
} from './board.js';
import { useServerNow } from './clock.js';
import { formatClock } from './format.js';
import { FALLBACK_POLL_MS, LiveContext } from './live.js';

// RA §17, §8.1–8.2: the four columns, live and read-only: no sound and no
// action, with the banner that sends receiving to the apps.
export function BoardPage() {
  const { t } = useTranslation();
  const live = use(LiveContext);
  const now = useServerNow();
  const board = useQuery({ ...boardQuery, refetchInterval: live ? false : FALLBACK_POLL_MS });

  return (
    <main>
      <h1>{t('board.title')}</h1>
      <p role="note">{t('board.receiveBanner')}</p>
      {!live && <p role="status">{t('board.offline')}</p>}
      {board.isPending ? (
        <p>{t('app.loading')}</p>
      ) : board.isError ? (
        <p role="alert">{t('app.error')}</p>
      ) : (
        <Columns orders={board.data} now={now} />
      )}
    </main>
  );
}

function Columns({ orders, now }: { orders: BoardOrder[]; now: number }) {
  const { t } = useTranslation();
  const board = boardColumns(orders, now);
  return (
    <div>
      {columns.map((column) => {
        const list = board[column];
        const late = list.filter((order) => isLate(order, now)).length;
        const name = t(`board.column.${column}`);
        return (
          <section key={column} aria-label={name}>
            <h2>
              {late > 0
                ? t('board.columnLate', { column: name, count: list.length, late })
                : t('board.columnCount', { column: name, count: list.length })}
            </h2>
            {list.length === 0 ? (
              <p>{t('board.empty')}</p>
            ) : (
              <ul>
                {list.map((order) => (
                  <li key={order.id}>
                    <Card order={order} now={now} />
                  </li>
                ))}
              </ul>
            )}
          </section>
        );
      })}
    </div>
  );
}

function Card({ order, now }: { order: BoardOrder; now: number }) {
  const { t } = useTranslation();
  const line = captainLine(order, now);
  const timer = timerOf(order, now);
  const minutes = Math.max(0, Math.floor((now - Date.parse(order.placedAt)) / 60_000));
  return (
    <article>
      <Link to="/orders/$orderId" params={{ orderId: order.id }}>
        {t('board.number', { number: order.number })}
      </Link>{' '}
      <span>{t('board.sincePlaced', { minutes })}</span>
      {isLate(order, now) && <strong> {t('board.late')}</strong>}
      <p>
        {t('board.items', {
          count: itemCount(order),
          names: order.lines
            .slice(0, 3)
            .map((item) => item.name)
            .join('، '),
        })}
      </p>
      {line && <p>{t(`board.captain.${line.key}`, line)}</p>}
      {timer && (
        <p>
          {timer.key === 'prepLate'
            ? t('board.timer.prepLate', { minutes: timer.minutes })
            : t(`board.timer.${timer.key}`, { time: formatClock(timer.ms) })}
        </p>
      )}
      <Badges order={order} />
    </article>
  );
}

function Badges({ order }: { order: BoardOrder }) {
  const { t } = useTranslation();
  const badges = [
    order.testOrder && t('board.badge.test'),
    order.acceptance?.byOperations && t('board.badge.byOperations'),
    order.redeliveryOf && t('board.badge.redelivery', { number: order.redeliveryOf.number }),
    order.itemReport && t('board.badge.itemReport'),
    order.edits.length > 0 && t('board.badge.edited'),
    order.note && t('board.badge.note'),
  ].filter((badge): badge is string => typeof badge === 'string');
  return badges.length === 0 ? null : <p>{badges.join(' · ')}</p>;
}
