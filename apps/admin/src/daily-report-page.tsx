import { useQuery } from '@tanstack/react-query';
import { getRouteApi, useNavigate } from '@tanstack/react-router';
import { type FormEvent, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { chosenCity, citiesQuery } from './cities.js';
import {
  cashLines,
  type DailyReport,
  figureLines,
  useDailyReport,
  useExportDailyReport,
} from './daily-report.js';
import { ExportButton } from './export-button.js';
import { formatDateTime, formatMoney } from './format.js';

const route = getRouteApi('/signed-in/daily-report');

const refusalKeys = {
  invalid_day: 'dailyReport.invalidDay',
  no_base_currency: 'dailyReport.noBaseCurrency',
  rate_missing: 'dailyReport.rateMissing',
} as const;

// AP §9.10.1 «التقرير اليومي» (slice 2.20d): a business day's figures beside
// the six days before, the captains' cash per currency, today's state and
// «تصدير Excel». Unstyled until the design.
export function DailyReportPage() {
  const { t } = useTranslation();
  const search = route.useSearch();
  const navigate = useNavigate();
  const cities = useQuery(citiesQuery);
  const city = cities.data ? chosenCity(cities.data, search.city) : undefined;
  const report = useDailyReport(city?.id, search.day);
  const show = (day: string) =>
    void navigate({
      to: '/daily-report',
      search: { ...(search.city ? { city: search.city } : {}), day },
    });

  return (
    <main>
      <h1>{t('dailyReport.title')}</h1>
      {cities.isError || report.isError ? (
        <p role="alert">{t('common.failed')}</p>
      ) : !city || !report.data ? (
        <p role="status">{t('status.loading')}</p>
      ) : report.data.status === 'refused' ? (
        <>
          <DayForm key={search.day} initial={search.day ?? ''} onShow={show} />
          <p role="alert">{t(refusalKeys[report.data.refusal])}</p>
        </>
      ) : (
        <>
          <DayForm key={report.data.report.day} initial={report.data.report.day} onShow={show} />
          <ExportDayButton
            key={city.id + report.data.report.day}
            cityId={city.id}
            day={report.data.report.day}
          />
          <ReportView report={report.data.report} timeZone={city.timeZone} />
        </>
      )}
    </main>
  );
}

function DayForm({ initial, onShow }: { initial: string; onShow: (day: string) => void }) {
  const { t } = useTranslation();
  const [day, setDay] = useState(initial);
  const submit = (event: FormEvent) => {
    event.preventDefault();
    if (day !== '') onShow(day);
  };
  return (
    <form onSubmit={submit}>
      <label>
        {t('dailyReport.day')}{' '}
        <input type="date" value={day} onChange={(event) => setDay(event.target.value)} />
      </label>{' '}
      <button type="submit" disabled={day === ''}>
        {t('dailyReport.show')}
      </button>
    </form>
  );
}

function ExportDayButton({ cityId, day }: { cityId: string; day: string }) {
  const requested = useExportDailyReport();
  return (
    <p>
      <ExportButton
        request={{
          data: requested.data,
          isPending: requested.isPending,
          isError: requested.isError,
          ask: () => requested.mutate({ cityId, day }),
        }}
      />
    </p>
  );
}

function ReportView({ report, timeZone }: { report: DailyReport; timeZone: string }) {
  const { t } = useTranslation();
  const days = [report, ...report.previous];
  return (
    <>
      <p>
        {t('dailyReport.period', {
          from: formatDateTime(report.from, timeZone),
          to: formatDateTime(report.to, timeZone),
        })}
        {report.today && <> {t('dailyReport.running')}</>}
      </p>
      <p>{t('dailyReport.note')}</p>

      <h2>{t('dailyReport.earned')}</h2>
      <table>
        <thead>
          <tr>
            <th scope="col">{t('dailyReport.figure')}</th>
            {days.map((each) => (
              <th scope="col" key={each.day}>
                {each.day}
              </th>
            ))}
          </tr>
        </thead>
        <tbody>
          {figureLines.map(([key, value]) => (
            <tr key={key}>
              <th scope="row">{t(`dailyReport.line.${key}`)}</th>
              {days.map((each) => {
                const figure = value(each);
                return (
                  <td key={each.day}>
                    {'count' in figure
                      ? String(figure.count)
                      : formatMoney({ amount: figure.amount, currency: each.currency })}
                  </td>
                );
              })}
            </tr>
          ))}
        </tbody>
      </table>

      <h2>{t('dailyReport.cash')}</h2>
      {report.cash.length === 0 ? (
        <p>{t('dailyReport.noCash')}</p>
      ) : (
        <table>
          <thead>
            <tr>
              <th scope="col">{t('dailyReport.figure')}</th>
              {report.cash.map((each) => (
                <th scope="col" key={each.currency}>
                  {each.currency}
                </th>
              ))}
            </tr>
          </thead>
          <tbody>
            {cashLines.map((key) => (
              <tr key={key}>
                <th scope="row">{t(`dailyReport.line.${key}`)}</th>
                {report.cash.map((each) => (
                  <td key={each.currency}>
                    {formatMoney({ amount: each[key], currency: each.currency })}
                  </td>
                ))}
              </tr>
            ))}
          </tbody>
        </table>
      )}

      {report.now && (
        <>
          <h2>{t('dailyReport.now')}</h2>
          <p>{t('dailyReport.blocked', { count: report.now.captainsBlocked })}</p>
          <h3>{t('dailyReport.line.overdueRestaurants')}</h3>
          {report.now.overdueRestaurants.length === 0 ? (
            <p>{t('dailyReport.noOverdue')}</p>
          ) : (
            <table>
              <thead>
                <tr>
                  <th scope="col">{t('dailyReport.restaurant')}</th>
                  <th scope="col">{t('dailyReport.balance')}</th>
                  <th scope="col">{t('dailyReport.overdueSince')}</th>
                </tr>
              </thead>
              <tbody>
                {report.now.overdueRestaurants.map((row) => (
                  <tr key={row.restaurantId}>
                    <th scope="row">{row.name}</th>
                    <td>{formatMoney({ amount: row.balance, currency: report.currency })}</td>
                    <td>{formatDateTime(row.overdueSince, timeZone)}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}
        </>
      )}
    </>
  );
}
