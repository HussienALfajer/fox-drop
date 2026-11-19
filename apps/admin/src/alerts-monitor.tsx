import { useQuery } from '@tanstack/react-query';
import { type ReactNode, useCallback } from 'react';
import { useTranslation } from 'react-i18next';
import { useAlertAlarm } from './alert-alarm.js';
import { type AdminAlert, alertsQuery } from './alerts.js';
import { chosenCity, citiesQuery } from './cities.js';
import { useOpsChannel } from './live.js';
import { alertKeys } from './order-labels.js';

// AP §7.3: on every page of a recipient, the blocking banner that enables
// the alert sound (the page shows again once the sound is on), for the city
// the top bar's selector chose (the bell is the top bar's, `AlertsBell`).
// Until the cities load the page shows, so a failed read never locks the
// panel.
export function AlertsMonitor({
  cityCode,
  children,
}: {
  cityCode: string | undefined;
  children: ReactNode;
}) {
  const cities = useQuery(citiesQuery);
  const city = cities.data && chosenCity(cities.data, cityCode);
  if (!city) return children;
  return <CityAlarm cityId={city.id}>{children}</CityAlarm>;
}

function CityAlarm({ cityId, children }: { cityId: string; children: ReactNode }) {
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
            : alert.currency
              ? t('alerts.currency', { code: alert.currency })
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
  return children;
}
