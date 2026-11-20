import { useQuery } from '@tanstack/react-query';
import { use, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { ExportButton } from './export-button.js';
import { formatDateTime, formatMoney } from './format.js';
import { TimeZoneContext } from './live.js';
import { OWNER_PERIODS, type OwnerPeriod, type PeriodChoice } from './period.js';
import { PeriodPicker } from './period-picker.js';
import {
  type Change,
  changeOf,
  type FigureSet,
  figuresQuery,
  METRICS,
  type MetricKind,
  minutesOf,
  percentOf,
} from './reports.js';

// RA §11, §17 (slice 2.45d): «التقارير», the app's owner reports with the
// portal's custom range and «تصدير Excel». The daily summary image stays
// the app's (the system share sheet).
export function ReportsPage() {
  const { t } = useTranslation();
  const [choice, setChoice] = useState<PeriodChoice>({ kind: 'period', period: 'today' });
  const read = useQuery(figuresQuery(choice));
  const timeZone = use(TimeZoneContext);

  return (
    <main>
      <h1>{t('reports.title')}</h1>
      <PeriodPicker<OwnerPeriod> periods={OWNER_PERIODS} value={choice} onChange={setChoice} />
      <ExportButton
        ask={{
          kind: 'report',
          body:
            choice.kind === 'period'
              ? { period: choice.period, from: null, to: null }
              : { period: null, from: choice.from, to: choice.to },
        }}
      />
      {read.isPending ? (
        <p>{t('app.loading')}</p>
      ) : read.isError ? (
        <p role="alert">{t('app.error')}</p>
      ) : read.data.status === 'refused' ? (
        <p role="alert">{t(`reports.refusal.${read.data.refusal}`)}</p>
      ) : (
        <>
          <p>
            {t('reports.range', {
              from: formatDateTime(read.data.figures.from, timeZone),
              to: formatDateTime(read.data.figures.to, timeZone),
            })}
          </p>
          <p>{t('reports.compared')}</p>
          <Figures
            current={read.data.figures.current}
            previous={read.data.figures.previous}
            currency={read.data.figures.currency}
          />
        </>
      )}
    </main>
  );
}

function Figures({
  current,
  previous,
  currency,
}: {
  current: FigureSet;
  previous: FigureSet;
  currency: string;
}) {
  const { t } = useTranslation();
  const changeText = useChangeText();
  const show = (kind: MetricKind, value: number | string | null, figures: FigureSet) => {
    if (value === null) return t('reports.noValue');
    switch (kind) {
      case 'count':
        return String(value);
      case 'percent':
        return t('reports.percent', { value: percentOf(Number(value)) });
      case 'minutes':
        return t('reports.minutes', { value: minutesOf(Number(value)) });
      case 'money':
        return formatMoney(String(value), currency);
      case 'rating':
        return t('reports.rating', { average: value, count: figures.rating.count });
    }
  };
  return (
    <>
      <table>
        <thead>
          <tr>
            <th scope="col">{t('reports.metric')}</th>
            <th scope="col">{t('reports.current')}</th>
            <th scope="col">{t('reports.previous')}</th>
            <th scope="col">{t('reports.change')}</th>
          </tr>
        </thead>
        <tbody>
          {METRICS.map((metric) => {
            const now = metric.value(current);
            const before = metric.value(previous);
            const label = t(`reports.metrics.${metric.key as 'received'}`);
            return (
              <tr key={metric.key}>
                <th scope="row">
                  <details>
                    <summary>{label}</summary>
                    {t(`reports.info.${metric.key as 'received'}`)}
                  </details>
                </th>
                <td>{show(metric.kind, now, current)}</td>
                <td>{show(metric.kind, before, previous)}</td>
                <td>{changeText(changeOf(now, before))}</td>
              </tr>
            );
          })}
        </tbody>
      </table>
      <h2>{t('reports.rejections')}</h2>
      {current.rejections.length === 0 ? (
        <p>{t('reports.empty')}</p>
      ) : (
        <ul>
          {current.rejections.map((each, index) => (
            <li key={index}>
              {t(each.byOperations ? 'reports.rejectionByOperations' : 'reports.rejectionRow', {
                reason: each.label,
                count: each.count,
              })}
            </li>
          ))}
        </ul>
      )}
      {(
        [
          ['topByQuantity', current.topByQuantity],
          ['topBySales', current.topBySales],
        ] as const
      ).map(([key, items]) => (
        <section key={key}>
          <h2>{t(`reports.${key}`)}</h2>
          {items.length === 0 ? (
            <p>{t('reports.empty')}</p>
          ) : (
            <ol>
              {items.map((item) => (
                <li key={item.itemId}>
                  {t('reports.itemRow', {
                    name: item.name,
                    quantity: item.quantity,
                    sales: formatMoney(item.sales, currency),
                  })}
                </li>
              ))}
            </ol>
          )}
        </section>
      ))}
      <h2>{t('reports.hours')}</h2>
      <ul>
        {current.hours
          .filter((hour) => hour.delivered > 0)
          .map((hour) => (
            <li key={hour.hour}>
              {t('reports.hourRow', {
                hour: String(hour.hour).padStart(2, '0'),
                count: hour.delivered,
              })}
            </li>
          ))}
      </ul>
      <h2>{t('reports.pauses')}</h2>
      <ul>
        <li>{t('reports.pauseRestaurant', { minutes: current.pauseMinutes.restaurant })}</li>
        <li>{t('reports.pauseOps', { minutes: current.pauseMinutes.ops })}</li>
        <li>{t('reports.pauseAuto', { minutes: current.pauseMinutes.auto })}</li>
        <li>{t('reports.busyNotYet')}</li>
      </ul>
    </>
  );
}

// The arrow of RA §11: «↑ 12%», «↓ 5%», «↑» from nothing, «=» or «—».
function useChangeText() {
  const { t } = useTranslation();
  return (change: Change): string => {
    switch (change.kind) {
      case 'none':
        return t('reports.noValue');
      case 'same':
        return t('reports.changeSame');
      case 'new':
        return t('reports.changeNew');
      case 'moved':
        return change.up
          ? t('reports.changeUp', { percent: change.percent })
          : t('reports.changeDown', { percent: change.percent });
    }
  };
}
