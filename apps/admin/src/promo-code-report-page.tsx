import { useQuery } from '@tanstack/react-query';
import { getRouteApi, Link } from '@tanstack/react-router';
import { type FormEvent, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { type City, chosenCity, citiesQuery } from './cities.js';
import { formatDateTime, formatMoney } from './format.js';
import {
  extendedEndOf,
  type PromoCodeReport,
  useExtendPromoCode,
  usePromoCodeReport,
  useSetPromoCodeStatus,
  utcToZoned,
} from './promo-codes.js';
import { kindKeys, refusalKeys, stateKeys, ValueText } from './promo-codes-page.js';

const route = getRouteApi('/signed-in/promo-codes/$codeId');

// AP §9.11.1 «Code report» (slice 2.21d): the code's orders, customers,
// cost and the new customers it acquired; OWN pauses, resumes or extends it
// from here. Unstyled until the design.
export function PromoCodeReportPage() {
  const { t } = useTranslation();
  const search = route.useSearch();
  const { codeId } = route.useParams();
  const cities = useQuery(citiesQuery);
  const city = cities.data ? chosenCity(cities.data, search.city) : undefined;
  const report = usePromoCodeReport(city?.id, codeId);
  return (
    <main>
      <h1>{t('promoCodes.report.title')}</h1>
      <p>
        <Link to="/promo-codes" search={search}>
          {t('promoCodes.title')}
        </Link>
      </p>
      {report.isError || cities.isError ? (
        <p role="alert">{t('common.failed')}</p>
      ) : !city || report.data === undefined ? (
        <p role="status">{t('status.loading')}</p>
      ) : report.data === null ? (
        <p role="alert">{t('promoCodes.refusal.unknown_promo_code')}</p>
      ) : (
        <ReportView report={report.data} city={city} />
      )}
    </main>
  );
}

function ReportView({ report, city }: { report: PromoCodeReport; city: City }) {
  const { t } = useTranslation();
  const { code } = report;
  const money = (amount: string | null) =>
    amount === null ? '—' : formatMoney({ amount, currency: code.currency });
  const setStatus = useSetPromoCodeStatus(city.id);
  return (
    <>
      <h2>{code.code}</h2>
      <dl>
        <dt>{t('promoCodes.column.kind')}</dt>
        <dd>{t(kindKeys[code.kind])}</dd>
        <dt>{t('promoCodes.column.value')}</dt>
        <dd>
          <ValueText code={code} />
        </dd>
        <dt>{t('promoCodes.column.state')}</dt>
        <dd>{t(stateKeys[code.state])}</dd>
        <dt>{t('promoCodes.column.end')}</dt>
        <dd>{formatDateTime(code.validTo, city.timeZone)}</dd>
        <dt>{t('promoCodes.report.orders')}</dt>
        <dd>{report.report.orders}</dd>
        <dt>{t('promoCodes.report.returned')}</dt>
        <dd>{report.report.returned}</dd>
        <dt>{t('promoCodes.report.customers')}</dt>
        <dd>{report.report.customers}</dd>
        <dt>{t('promoCodes.report.newCustomers')}</dt>
        <dd>{report.report.newCustomers}</dd>
        <dt>{t('promoCodes.report.cost')}</dt>
        <dd>{money(report.report.cost)}</dd>
        <dt>{t('promoCodes.report.merchantShare')}</dt>
        <dd>{money(report.report.merchantShare)}</dd>
      </dl>
      <p>{t('promoCodes.report.note')}</p>
      {report.canManage && (
        <>
          {code.state !== 'expired' && (
            <button
              type="button"
              disabled={setStatus.isPending}
              onClick={() => setStatus.mutate({ codeId: code.id, pause: code.status === 'active' })}
            >
              {code.status === 'active'
                ? t('promoCodes.pause', { code: code.code })
                : t('promoCodes.resume', { code: code.code })}
            </button>
          )}
          {setStatus.isError && <p role="alert">{t('common.failed')}</p>}
          <ExtendForm report={report} city={city} />
        </>
      )}
    </>
  );
}

function ExtendForm({ report, city }: { report: PromoCodeReport; city: City }) {
  const { t } = useTranslation();
  const { code } = report;
  const [typed, setTyped] = useState(() => utcToZoned(code.validTo, city.timeZone));
  const [message, setMessage] = useState<string | null>(null);
  const extend = useExtendPromoCode(city.id);
  const validTo = extendedEndOf(typed, code, city.timeZone, new Date());
  const submit = (event: FormEvent) => {
    event.preventDefault();
    if (validTo === null) return;
    setMessage(null);
    extend.mutate(
      { codeId: code.id, validTo },
      {
        onSuccess: (result) =>
          setMessage(
            result.status === 'saved'
              ? t('promoCodes.report.extended', {
                  code: code.code,
                  end: formatDateTime(validTo, city.timeZone),
                })
              : t(refusalKeys[result.refusal]),
          ),
      },
    );
  };
  return (
    <form onSubmit={submit}>
      <h3>{t('promoCodes.report.extend')}</h3>
      <label>
        {t('promoCodes.report.newEnd')}
        <input
          type="datetime-local"
          value={typed}
          onChange={(event) => setTyped(event.target.value)}
        />
      </label>
      {validTo === null && <p>{t('promoCodes.report.endLater')}</p>}
      <button type="submit" disabled={validTo === null || extend.isPending}>
        {t('promoCodes.report.extendAction', { code: code.code })}
      </button>
      {message && <p role="status">{message}</p>}
      {extend.isError && <p role="alert">{t('common.failed')}</p>}
    </form>
  );
}
