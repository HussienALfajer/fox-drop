import { useQuery } from '@tanstack/react-query';
import { getRouteApi, useNavigate } from '@tanstack/react-router';
import { type FormEvent, type ReactNode, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { chosenCity, citiesQuery } from './cities.js';
import {
  compensationName,
  type CostReport,
  operatingKeys,
  partyKeys,
  totalLines,
  useCostReport,
  useExportCostReport,
} from './cost-report.js';
import { ExportButton } from './export-button.js';
import { formatDateTime, formatMoney } from './format.js';
import { periodFits } from './restaurant-statements.js';

const route = getRouteApi('/signed-in/cost-report');

const refusalKeys = {
  invalid_period: 'costReport.invalidPeriod',
  no_base_currency: 'dailyReport.noBaseCurrency',
  rate_missing: 'costReport.rateMissing',
} as const;

// AP §9.10.6 «كلفة التعويضات والخصومات» (slice 2.22d): a period's cost of
// codes, compensations and operating costs, split by reason, by responsible
// party, by code and by restaurant, with «تصدير Excel». Unstyled until the
// design.
export function CostReportPage() {
  const { t } = useTranslation();
  const search = route.useSearch();
  const navigate = useNavigate();
  const cities = useQuery(citiesQuery);
  const city = cities.data ? chosenCity(cities.data, search.city) : undefined;
  const asked =
    search.from !== undefined && search.to !== undefined
      ? { from: search.from, to: search.to }
      : undefined;
  const report = useCostReport(city?.id, asked);
  const show = (period: { from: string; to: string }) =>
    void navigate({
      to: '/cost-report',
      search: { ...(search.city ? { city: search.city } : {}), ...period },
    });

  return (
    <main>
      <h1>{t('costReport.title')}</h1>
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
          <ExportPeriodButton
            key={city.id + report.data.report.fromDay + report.data.report.toDay}
            cityId={city.id}
            from={report.data.report.fromDay}
            to={report.data.report.toDay}
          />
          <ReportView report={report.data.report} timeZone={city.timeZone} />
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

function ExportPeriodButton({ cityId, from, to }: { cityId: string; from: string; to: string }) {
  const requested = useExportCostReport();
  return (
    <p>
      <ExportButton
        request={{
          data: requested.data,
          isPending: requested.isPending,
          isError: requested.isError,
          ask: () => requested.mutate({ cityId, from, to }),
        }}
      />
    </p>
  );
}

// One split: its name, the orders behind it and its cost.
function Split({
  title,
  column,
  currency,
  rows,
}: {
  title: string;
  column: string;
  currency: string;
  rows: { key: string; name: ReactNode; orders: number; amount: string }[];
}) {
  const { t } = useTranslation();
  return (
    <>
      <h2>{title}</h2>
      {rows.length === 0 ? (
        <p>{t('costReport.empty')}</p>
      ) : (
        <table>
          <thead>
            <tr>
              <th scope="col">{column}</th>
              <th scope="col">{t('costReport.column.orders')}</th>
              <th scope="col">{t('costReport.column.amount')}</th>
            </tr>
          </thead>
          <tbody>
            {rows.map((row) => (
              <tr key={row.key}>
                <th scope="row">{row.name}</th>
                <td>{String(row.orders)}</td>
                <td>{formatMoney({ amount: row.amount, currency })}</td>
              </tr>
            ))}
          </tbody>
        </table>
      )}
    </>
  );
}

function ReportView({ report, timeZone }: { report: CostReport; timeZone: string }) {
  const { t } = useTranslation();
  const { currency } = report;
  return (
    <>
      <p>
        {t('dailyReport.period', {
          from: formatDateTime(report.from, timeZone),
          to: formatDateTime(report.to, timeZone),
        })}
      </p>
      <p>{t('costReport.note')}</p>

      <table>
        <tbody>
          {totalLines.map((line) => (
            <tr key={line}>
              <th scope="row">{t(`costReport.line.${line}`)}</th>
              <td>{formatMoney({ amount: report.totals[line], currency })}</td>
            </tr>
          ))}
        </tbody>
      </table>

      <Split
        title={t('costReport.section.compensationReasons')}
        column={t('costReport.column.reason')}
        currency={currency}
        rows={report.compensationReasons.map((row) => {
          const name = compensationName(row);
          return {
            ...row,
            key: row.kind + (row.reason ?? ''),
            name: 'label' in name ? name.label : t(name.key),
          };
        })}
      />
      <Split
        title={t('costReport.section.operatingReasons')}
        column={t('costReport.column.reason')}
        currency={currency}
        rows={report.operatingReasons.map((row) => ({
          ...row,
          key: row.reason,
          name: t(operatingKeys[row.reason]),
        }))}
      />
      <Split
        title={t('costReport.section.parties')}
        column={t('costReport.column.party')}
        currency={currency}
        rows={report.parties.map((row) => ({
          ...row,
          key: row.party ?? 'none',
          name: t(row.party === null ? 'costReport.party.none' : partyKeys[row.party]),
        }))}
      />
      <Split
        title={t('costReport.section.codes')}
        column={t('costReport.column.code')}
        currency={currency}
        rows={report.codes.map((row) => ({
          ...row,
          key: row.codeId ?? 'none',
          name: row.code ?? t('costReport.unknown'),
        }))}
      />

      <h2>{t('costReport.section.restaurants')}</h2>
      {report.restaurants.length === 0 ? (
        <p>{t('costReport.empty')}</p>
      ) : (
        <table>
          <thead>
            <tr>
              <th scope="col">{t('costReport.column.restaurant')}</th>
              {totalLines.map((line) => (
                <th scope="col" key={line}>
                  {t(`costReport.line.${line}`)}
                </th>
              ))}
            </tr>
          </thead>
          <tbody>
            {report.restaurants.map((row) => (
              <tr key={row.restaurantId ?? 'none'}>
                <th scope="row">{row.name ?? t('costReport.unknown')}</th>
                {totalLines.map((line) => (
                  <td key={line}>{formatMoney({ amount: row[line], currency })}</td>
                ))}
              </tr>
            ))}
          </tbody>
        </table>
      )}
    </>
  );
}
