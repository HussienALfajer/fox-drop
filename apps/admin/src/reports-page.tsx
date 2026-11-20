import { useQuery } from '@tanstack/react-query';
import { getRouteApi, Link, useNavigate } from '@tanstack/react-router';
import { type FormEvent, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { chosenCity, citiesQuery } from './cities.js';
import { ExportButton } from './export-button.js';
import { formatDateTime } from './format.js';
import {
  cellText,
  type Report,
  type ReportKind,
  reportsOf,
  rowName,
  useExportReport,
  useReport,
  type Words,
} from './reports.js';
import { periodFits } from './restaurant-statements.js';
import { sessionQuery } from './session.js';

const route = getRouteApi('/signed-in/reports');

const rowKey = (code: string | null, label: string | null, index: number) =>
  [code ?? '', label ?? '', index].join('|');

const refusalKeys = {
  invalid_period: 'costReport.invalidPeriod',
  no_base_currency: 'dailyReport.noBaseCurrency',
  rate_missing: 'costReport.rateMissing',
} as const;

// AP §9.17 «التقارير» (slice 2.41): a report of the session's (AP §6.2) over
// a period of business days, each table as the server answers it (owner
// decision 2026-11-20: every chart a table), with «تصدير Excel». Unstyled
// until the design.
export function ReportsPage() {
  const { t, i18n } = useTranslation();
  const search = route.useSearch();
  const navigate = useNavigate();
  const session = useQuery(sessionQuery);
  const cities = useQuery(citiesQuery);
  const city = cities.data ? chosenCity(cities.data, search.city) : undefined;
  const kinds = reportsOf(session.data);
  const kind: ReportKind =
    search.report !== undefined && kinds.includes(search.report) ? search.report : kinds[0]!;
  const asked =
    search.from !== undefined && search.to !== undefined
      ? { from: search.from, to: search.to }
      : undefined;
  const report = useReport(kind, city?.id, asked);
  const words: Words = (key, fallback) => (i18n.exists(key) ? t(key as 'reports.title') : fallback);
  const show = (period: { from: string; to: string }) =>
    void navigate({
      to: '/reports',
      search: { ...(search.city ? { city: search.city } : {}), report: kind, ...period },
    });

  return (
    <main>
      <h1>{t('reports.title')}</h1>
      <nav aria-label={t('reports.choose')}>
        <ul>
          {kinds.map((each) => (
            <li key={each}>
              <Link
                to="/reports"
                search={{
                  ...(search.city ? { city: search.city } : {}),
                  report: each,
                  ...(asked ?? {}),
                }}
                aria-current={each === kind ? 'page' : undefined}
              >
                {t(`reports.kind.${each}`)}
              </Link>
            </li>
          ))}
        </ul>
      </nav>
      <h2>{t(`reports.kind.${kind}`)}</h2>
      <p>{t(`reports.explain.${kind}`)}</p>
      {cities.isError || report.isError ? (
        <p role="alert">{t('common.failed')}</p>
      ) : !city || !report.data ? (
        <p role="status">{t('status.loading')}</p>
      ) : report.data.status === 'refused' ? (
        <>
          <PeriodForm
            key={(asked?.from ?? '') + (asked?.to ?? '')}
            initial={asked ?? { from: '', to: '' }}
            onShow={show}
          />
          <p role="alert">{t(refusalKeys[report.data.refusal])}</p>
        </>
      ) : (
        <>
          <PeriodForm
            key={report.data.report.fromDay + report.data.report.toDay}
            initial={{ from: report.data.report.fromDay, to: report.data.report.toDay }}
            onShow={show}
          />
          <ExportReportButton
            key={kind + city.id + report.data.report.fromDay + report.data.report.toDay}
            report={kind}
            cityId={city.id}
            from={report.data.report.fromDay}
            to={report.data.report.toDay}
          />
          <ReportView report={report.data.report} timeZone={city.timeZone} words={words} />
        </>
      )}
    </main>
  );
}

function PeriodForm({
  initial,
  onShow,
}: {
  initial: { from: string; to: string };
  onShow: (period: { from: string; to: string }) => void;
}) {
  const { t } = useTranslation();
  const [from, setFrom] = useState(initial.from);
  const [to, setTo] = useState(initial.to);
  const fits = periodFits(from, to);
  const submit = (event: FormEvent) => {
    event.preventDefault();
    if (fits) onShow({ from, to });
  };
  return (
    <form onSubmit={submit}>
      <label>
        {t('costReport.from')}{' '}
        <input type="date" value={from} onChange={(event) => setFrom(event.target.value)} />
      </label>{' '}
      <label>
        {t('costReport.to')}{' '}
        <input type="date" value={to} onChange={(event) => setTo(event.target.value)} />
      </label>{' '}
      <button type="submit" disabled={!fits}>
        {t('costReport.show')}
      </button>
    </form>
  );
}

function ExportReportButton(props: {
  report: ReportKind;
  cityId: string;
  from: string;
  to: string;
}) {
  const requested = useExportReport();
  return (
    <p>
      <ExportButton
        request={{
          data: requested.data,
          isPending: requested.isPending,
          isError: requested.isError,
          ask: () => requested.mutate(props),
        }}
      />
    </p>
  );
}

function ReportView({
  report,
  timeZone,
  words,
}: {
  report: Report;
  timeZone: string;
  words: Words;
}) {
  const { t } = useTranslation();
  return (
    <>
      <p>
        {t('dailyReport.period', {
          from: formatDateTime(report.from, timeZone),
          to: formatDateTime(report.to, timeZone),
        })}
      </p>
      {report.tables.map((table) => {
        const key = `${report.report}.${table.key}`;
        const title = words(`reports.table.${key}`, table.key);
        const named = table.rowKind !== 'none';
        return (
          <section key={table.key} aria-label={title}>
            <h3>{title}</h3>
            {table.rows.length === 0 ? (
              <p>{t('reports.empty')}</p>
            ) : (
              <table>
                <thead>
                  <tr>
                    {named ? <th scope="col">{words(`reports.rowHeader.${key}`, '')}</th> : null}
                    {table.columns.map((column) => (
                      <th scope="col" key={column.key}>
                        {words(`reports.column.${column.key}`, column.key)}
                      </th>
                    ))}
                  </tr>
                </thead>
                <tbody>
                  {table.rows.map((row, index) => (
                    <tr key={rowKey(row.code, row.label, index)}>
                      {named ? <th scope="row">{rowName(table, row, words)}</th> : null}
                      {table.columns.map((column, cell) => (
                        <td key={column.key}>
                          {cellText(
                            column,
                            row.cells[cell] ?? null,
                            row.currency ?? report.currency,
                            words,
                          )}
                        </td>
                      ))}
                    </tr>
                  ))}
                </tbody>
              </table>
            )}
          </section>
        );
      })}
    </>
  );
}
