import { useQuery } from '@tanstack/react-query';
import { Link } from '@tanstack/react-router';
import { useCallback } from 'react';
import { useTranslation } from 'react-i18next';
import { useAlertAlarm } from './alert-alarm.js';
import { type AdminAlert, alertsQuery } from './alerts.js';
import { chosenCity, citiesQuery } from './cities.js';
import { alertKeys } from './order-labels.js';

// AP §7.2–7.3: on every page of a recipient, the banner that enables the
// alert sound and the bell with the count of open alerts. V1 has one city,
// so the alarm watches the first; the city selector's choice comes with the
// top bar.
export function AlertsMonitor() {
  const cities = useQuery(citiesQuery);
  const city = cities.data && chosenCity(cities.data, undefined);
  if (!city) return null;
  return <CityAlarm cityId={city.id} cityCode={city.code} />;
}

function CityAlarm({ cityId, cityCode }: { cityId: string; cityCode: string }) {
  const { t } = useTranslation();
  const alerts = useQuery(alertsQuery(cityId));
  const describe = useCallback(
    (alert: AdminAlert) => ({
      title: t('alerts.notificationTitle', { label: t(alertKeys[alert.code]) }),
      body: alert.orderNumber
        ? t('alerts.order', { number: alert.orderNumber })
        : alert.captainName
          ? t('alerts.captain', { name: alert.captainName })
          : '',
    }),
    [t],
  );
  const alarm = useAlertAlarm(alerts.data, describe);
  return (
    <header>
      {!alarm.enabled && (
        <button type="button" onClick={() => void alarm.enable()}>
          {t('alerts.enableSound')}
        </button>
      )}
      <Link to="/alerts" search={{ city: cityCode }}>
        {t('alerts.bell', { count: alerts.data?.length ?? 0 })}
      </Link>
    </header>
  );
}
