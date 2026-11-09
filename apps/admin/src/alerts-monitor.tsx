import { useQuery } from '@tanstack/react-query';
import { Link } from '@tanstack/react-router';
import { type ReactNode, useCallback } from 'react';
import { useTranslation } from 'react-i18next';
import { useAlertAlarm } from './alert-alarm.js';
import { type AdminAlert, alertsQuery } from './alerts.js';
import { chosenCity, citiesQuery } from './cities.js';
import { useOpsChannel } from './live.js';
import { alertKeys } from './order-labels.js';

// AP §7.2–7.3: on every page of a recipient, the blocking banner that enables
// the alert sound (the page shows again once the sound is on) and the bell
// with the count of open alerts. V1 has one city, so the alarm watches the
// first; the city selector's choice comes with the top bar. Until the cities
// load the page shows, so a failed read never locks the panel.
export function AlertsMonitor({ children }: { children: ReactNode }) {
  const cities = useQuery(citiesQuery);
  const city = cities.data && chosenCity(cities.data, undefined);
  if (!city) return children;
  return (
    <CityAlarm cityId={city.id} cityCode={city.code}>
      {children}
    </CityAlarm>
  );
}

function CityAlarm({
  cityId,
  cityCode,
  children,
}: {
  cityId: string;
  cityCode: string;
  children: ReactNode;
}) {
  const { t } = useTranslation();
  const alerts = useQuery(alertsQuery(cityId));
  useOpsChannel(cityId);
  const describe = useCallback(
    (alert: AdminAlert) => ({
      title: t('alerts.notificationTitle', { label: t(alertKeys[alert.code]) }),
      body: alert.orderNumber
        ? t('alerts.order', { number: alert.orderNumber })
        : alert.captainName
          ? t('alerts.captain', { name: alert.captainName })
          : alert.restaurantName
            ? t('alerts.restaurant', { name: alert.restaurantName })
            : '',
    }),
    [t],
  );
  const alarm = useAlertAlarm(alerts.data, describe);
  if (!alarm.enabled) {
    return (
      <main>
        <button type="button" onClick={() => void alarm.enable()}>
          {t('alerts.enableSound')}
        </button>
      </main>
    );
  }
  return (
    <>
      <header>
        <Link to="/alerts" search={{ city: cityCode }}>
          {t('alerts.bell', { count: alerts.data?.length ?? 0 })}
        </Link>
      </header>
      {children}
    </>
  );
}
