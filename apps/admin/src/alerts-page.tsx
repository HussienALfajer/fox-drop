import { useQuery } from '@tanstack/react-query';
import { getRouteApi, Link } from '@tanstack/react-router';
import { useState } from 'react';
import { useTranslation } from 'react-i18next';
import {
  type AdminAlert,
  alertHistoryQuery,
  alertsQuery,
  orderOf,
  useAcknowledgeAlert,
} from './alerts.js';
import { type City, chosenCity, citiesQuery } from './cities.js';
import { formatTime } from './format.js';
import { alertKeys } from './order-labels.js';

const alertsRoute = getRouteApi('/signed-in/alerts');

// AP §9.1.3: the alerts list, by severity then age, with «استلام» and the
// direct action built so far (open the order); and the history.
export function AlertsPage() {
  const { t } = useTranslation();
  const { city: code } = alertsRoute.useSearch();
  const cities = useQuery(citiesQuery);
  if (cities.isPending) return <p role="status">{t('status.loading')}</p>;
  if (cities.isError) return <p role="alert">{t('status.error')}</p>;
  const city = chosenCity(cities.data, code);
  if (!city) return <p>{t('status.error')}</p>;
  return <CityAlerts city={city} />;
}

function CityAlerts({ city }: { city: City }) {
  const { t } = useTranslation();
  const open = useQuery(alertsQuery(city.id));
  const [showHistory, setShowHistory] = useState(false);
  const acknowledge = useAcknowledgeAlert(city.id);
  return (
    <main>
      <h1>{t('alerts.title')}</h1>
      {open.isError && <p role="alert">{t('alerts.failed')}</p>}
      {open.data?.length === 0 && <p>{t('alerts.empty')}</p>}
      <ul>
        {open.data?.map((alert) => (
          <li key={alert.id}>
            <AlertLine alert={alert} city={city} />
            {alert.acknowledged === null && (
              <button
                type="button"
                disabled={acknowledge.isPending}
                onClick={() => acknowledge.mutate(alert.id)}
              >
                {t('alerts.acknowledge')}
              </button>
            )}
          </li>
        ))}
      </ul>
      {acknowledge.isError && <p role="alert">{t('common.failed')}</p>}
      <button type="button" onClick={() => setShowHistory((shown) => !shown)}>
        {t('alerts.history')}
      </button>
      {showHistory && <History city={city} />}
    </main>
  );
}

function History({ city }: { city: City }) {
  const { t } = useTranslation();
  const closed = useQuery(alertHistoryQuery(city.id));
  if (closed.isPending) return <p role="status">{t('status.loading')}</p>;
  if (closed.isError) return <p role="alert">{t('alerts.failed')}</p>;
  if (closed.data.length === 0) return <p>{t('alerts.historyEmpty')}</p>;
  return (
    <section>
      <h2>{t('alerts.history')}</h2>
      <ul>
        {closed.data.map((alert) => (
          <li key={alert.id}>
            <AlertLine alert={alert} city={city} />
            {alert.resolvedAt && (
              <span>
                {' '}
                {t('alerts.resolvedAt', { time: formatTime(alert.resolvedAt, city.timeZone) })}
              </span>
            )}
          </li>
        ))}
      </ul>
    </section>
  );
}

function AlertLine({ alert, city }: { alert: AdminAlert; city: City }) {
  const { t } = useTranslation();
  const time = (at: string) => formatTime(at, city.timeZone);
  const orderId = orderOf(alert);
  return (
    <>
      <strong>{t(`alerts.severity.${alert.severity}`)}</strong>{' '}
      <span>{t(alertKeys[alert.code])}</span>{' '}
      {alert.orderNumber && <span>{t('alerts.order', { number: alert.orderNumber })}</span>}{' '}
      {alert.captainName && <span>{t('alerts.captain', { name: alert.captainName })}</span>}{' '}
      <span>{t('alerts.raisedAt', { time: time(alert.raisedAt) })}</span>{' '}
      {alert.acknowledged && (
        <span>
          {alert.acknowledged.byName
            ? t('alerts.takenBy', {
                name: alert.acknowledged.byName,
                time: time(alert.acknowledged.at),
              })
            : t('alerts.takenByUnnamed', { time: time(alert.acknowledged.at) })}
        </span>
      )}{' '}
      {orderId && (
        <Link to="/orders/$orderId" params={{ orderId }} search={{ city: city.code }}>
          {t('alerts.openOrder')}
        </Link>
      )}
    </>
  );
}
