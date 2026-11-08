import { useQuery } from '@tanstack/react-query';
import { Link } from '@tanstack/react-router';
import { useTranslation } from 'react-i18next';
import { chosenCity, citiesQuery } from './cities.js';
import { useServerNow } from './clock.js';
import {
  EMERGENCY_STOP_TOGGLE,
  elapsedMinutes,
  emergencyStopQuery,
  type EmergencyStop,
  followsOps,
} from './emergency-stop.js';
import { useOpsChannel } from './live.js';
import { type AdminSession, can } from './session.js';

// AP §7: the top bar's platform status on every signed-in page: «المنصة
// تعمل», or «إيقاف طارئ» with how long it has lasted and the attempts (AP
// §9.1.6 item 4). V1 has one city, so it shows the first until the top bar's
// selector. Its red, flashing look waits for the design.
export function EmergencyStopBar({ session }: { session: AdminSession }) {
  const cities = useQuery(citiesQuery);
  const city = cities.data && chosenCity(cities.data, undefined);
  if (!city) return null;
  return <CityStatus session={session} cityId={city.id} />;
}

function CityStatus({ session, cityId }: { session: AdminSession; cityId: string }) {
  const { t } = useTranslation();
  const state = useQuery(emergencyStopQuery(cityId));
  useOpsChannel(followsOps(session) ? cityId : undefined);
  if (!state.data) return null;
  const toggles = can(session, EMERGENCY_STOP_TOGGLE);
  const { stop } = state.data;
  return (
    <header data-platform={stop ? 'emergency-stop' : 'running'}>
      {stop ? <StoppedStatus stop={stop} /> : <p role="status">{t('emergencyStop.running')}</p>}
      {toggles && (
        <Link to="/emergency-stop">
          {stop ? t('emergencyStop.resume') : t('emergencyStop.title')}
        </Link>
      )}
    </header>
  );
}

function StoppedStatus({ stop }: { stop: EmergencyStop }) {
  const { t } = useTranslation();
  const now = useServerNow();
  return (
    <p role="alert">
      {t('emergencyStop.stopped', {
        minutes: elapsedMinutes(stop.startedAt, now),
        attempts: stop.attempts,
      })}
    </p>
  );
}
