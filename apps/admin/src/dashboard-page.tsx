import { useQuery } from '@tanstack/react-query';
import { getRouteApi, Link } from '@tanstack/react-router';
import { useTranslation } from 'react-i18next';
import { OpenAlerts } from './alerts-page.js';
import { type City, chosenCity, citiesQuery } from './cities.js';
import { SWITCH_DISPATCH_MODE } from './city-settings.js';
import {
  changeOf,
  type Dashboard,
  dashboardQuery,
  taskPaths,
  type TileValue,
  tileLines,
} from './dashboard.js';
import { EmergencyStopBar } from './emergency-stop-bar.js';
import { formatMoney, formatSignedMoney } from './format.js';
import { useDispatchMode } from './layout.js';
import { type AdminSession, can } from './session.js';

const route = getRouteApi('/signed-in/dashboard');
const signedIn = getRouteApi('/signed-in');

const captainKeys = ['online', 'available', 'busy', 'cashBlocked'] as const;
const restaurantKeys = ['open', 'busy', 'paused', 'closed', 'holiday', 'suspended'] as const;

// AP §9.1 «لوحة التحكم» (slice 2.40): the state now, today against the same
// weekday last week, the alerts, the tasks and the charts as tables until
// the design. Unstyled until the design.
export function DashboardPage() {
  const { t } = useTranslation();
  const { city: code } = route.useSearch();
  const { session } = signedIn.useRouteContext();
  const cities = useQuery(citiesQuery);
  const city = cities.data ? chosenCity(cities.data, code) : undefined;
  const dashboard = useQuery({ ...dashboardQuery(city?.id ?? ''), enabled: city !== undefined });
  return (
    <main>
      <h1>{t('dashboard.title')}</h1>
      {cities.isError || dashboard.isError ? (
        <p role="alert">{t('common.failed')}</p>
      ) : !city || !dashboard.data ? (
        <p role="status">{t('status.loading')}</p>
      ) : (
        <DashboardView dashboard={dashboard.data} city={city} session={session} />
      )}
    </main>
  );
}

function DashboardView({
  dashboard,
  city,
  session,
}: {
  dashboard: Dashboard;
  city: City;
  session: AdminSession;
}) {
  const { t } = useTranslation();
  return (
    <>
      <StatusStrip dashboard={dashboard} city={city} session={session} />
      <Tiles dashboard={dashboard} />
      <section>
        <h2>{t('dashboard.alerts')}</h2>
        <OpenAlerts city={city} />
      </section>
      <Tasks dashboard={dashboard} city={city} />
      <Charts dashboard={dashboard} />
    </>
  );
}

// AP §9.1.1.
function StatusStrip({
  dashboard,
  city,
  session,
}: {
  dashboard: Dashboard;
  city: City;
  session: AdminSession;
}) {
  const { t } = useTranslation();
  const mode = useDispatchMode(city.id);
  const { captains, restaurants, withoutDevice } = dashboard.status;
  return (
    <section>
      <h2>{t('dashboard.status')}</h2>
      <EmergencyStopBar session={session} cityCode={city.code} />
      <p>
        {mode.data && t('layout.dispatchMode', { mode: t(`layout.dispatch.${mode.data}`) })}{' '}
        {can(session, SWITCH_DISPATCH_MODE) && (
          <Link to="/dispatch-rules" search={{ city: city.code }}>
            {t('dashboard.switchMode')}
          </Link>
        )}
      </p>
      <h3>{t('dashboard.captains')}</h3>
      <ul>
        {captainKeys.map((key) => (
          <li key={key}>{t(`dashboard.captain.${key}`, { count: captains[key] })}</li>
        ))}
      </ul>
      <h3>{t('dashboard.restaurants')}</h3>
      <ul>
        {restaurantKeys.map((key) => (
          <li key={key}>{t(`dashboard.restaurant.${key}`, { count: restaurants[key] })}</li>
        ))}
        <li>{t('dashboard.withoutDevice', { count: withoutDevice })}</li>
      </ul>
    </section>
  );
}

// AP §9.1.2: each tile today, the same weekday last week up to the same
// moment, and the change.
function Tiles({ dashboard }: { dashboard: Dashboard }) {
  const { t } = useTranslation();
  const weekday = new Intl.DateTimeFormat('ar-u-nu-latn', {
    weekday: 'long',
    timeZone: 'UTC',
  }).format(new Date(dashboard.lastWeekDay));
  return (
    <section>
      <h2>{t('dashboard.today')}</h2>
      <p>{t('dashboard.compared', { weekday, day: dashboard.lastWeekDay })}</p>
      <table>
        <thead>
          <tr>
            <th scope="col">{t('dashboard.tile')}</th>
            <th scope="col">{t('dashboard.todayColumn')}</th>
            <th scope="col">{t('dashboard.lastWeekColumn')}</th>
            <th scope="col">{t('dashboard.change')}</th>
          </tr>
        </thead>
        <tbody>
          {tileLines.map(([key, value]) => {
            const today = value(dashboard.today);
            const lastWeek = value(dashboard.lastWeek);
            return (
              <tr key={key}>
                <th scope="row">{t(`dashboard.tiles.${key}`)}</th>
                <td>{tileText(today, false, t('dashboard.none'))}</td>
                <td>{tileText(lastWeek, false, t('dashboard.none'))}</td>
                <td>{tileText(changeOf(today, lastWeek), true, t('dashboard.none'))}</td>
              </tr>
            );
          })}
        </tbody>
      </table>
      {dashboard.today.money === null && <p role="alert">{t('dashboard.moneyMissing')}</p>}
      <p>{t('dashboard.countsNote')}</p>
      <p>{t('dashboard.newCustomersNote')}</p>
    </section>
  );
}

// A tile's value in words; a change carries its sign.
function tileText(value: TileValue, signed: boolean, none: string): string {
  if (value === null) return none;
  const sign = signed ? 'exceptZero' : 'auto';
  switch (value.kind) {
    case 'count':
      return new Intl.NumberFormat('ar-u-nu-latn', { signDisplay: sign }).format(value.value);
    case 'minutes':
      return new Intl.NumberFormat('ar-u-nu-latn', {
        style: 'unit',
        unit: 'minute',
        maximumFractionDigits: 1,
        signDisplay: sign,
      }).format(value.value);
    case 'percent':
      return new Intl.NumberFormat('ar-u-nu-latn', {
        style: 'percent',
        maximumFractionDigits: 1,
        signDisplay: sign,
      }).format(value.bp / 10_000);
    case 'money':
      return signed ? formatSignedMoney(value) : formatMoney(value);
  }
}

// AP §9.1.4: the session's tasks with their counts and pages.
function Tasks({ dashboard, city }: { dashboard: Dashboard; city: City }) {
  const { t } = useTranslation();
  return (
    <section>
      <h2>{t('dashboard.tasks')}</h2>
      {dashboard.tasks.length === 0 ? (
        <p>{t('dashboard.noTasks')}</p>
      ) : (
        <ul>
          {dashboard.tasks.map((task) => (
            <li key={task.key}>
              <Link to={taskPaths[task.key]} search={{ city: city.code }}>
                {t(`dashboard.task.${task.key}`, { count: task.count })}
              </Link>
            </li>
          ))}
        </ul>
      )}
    </section>
  );
}

// AP §9.1.5 as tables until the design draws them.
function Charts({ dashboard }: { dashboard: Dashboard }) {
  const { t } = useTranslation();
  return (
    <section>
      <h2>{t('dashboard.perHour')}</h2>
      <table>
        <thead>
          <tr>
            <th scope="col">{t('dashboard.hour')}</th>
            <th scope="col">{t('dashboard.todayColumn')}</th>
            <th scope="col">{t('dashboard.lastWeekColumn')}</th>
          </tr>
        </thead>
        <tbody>
          {dashboard.hours.map((row) => (
            <tr key={row.hour}>
              <th scope="row">{row.hour}</th>
              <td>{row.today}</td>
              <td>{row.lastWeek}</td>
            </tr>
          ))}
        </tbody>
      </table>

      <h2>{t('dashboard.top')}</h2>
      {dashboard.topRestaurants.length === 0 ? (
        <p>{t('dashboard.noOrders')}</p>
      ) : (
        <table>
          <thead>
            <tr>
              <th scope="col">{t('dashboard.restaurant.name')}</th>
              <th scope="col">{t('dashboard.orders')}</th>
            </tr>
          </thead>
          <tbody>
            {dashboard.topRestaurants.map((row) => (
              <tr key={row.restaurantId}>
                <th scope="row">{row.name}</th>
                <td>{row.orders}</td>
              </tr>
            ))}
          </tbody>
        </table>
      )}

      <h2>{t('dashboard.troubled')}</h2>
      {dashboard.troubledRestaurants.length === 0 ? (
        <p>{t('dashboard.noTrouble')}</p>
      ) : (
        <table>
          <thead>
            <tr>
              <th scope="col">{t('dashboard.restaurant.name')}</th>
              <th scope="col">{t('dashboard.rejected')}</th>
              <th scope="col">{t('dashboard.late')}</th>
            </tr>
          </thead>
          <tbody>
            {dashboard.troubledRestaurants.map((row) => (
              <tr key={row.restaurantId}>
                <th scope="row">{row.name}</th>
                <td>{row.rejected}</td>
                <td>{row.late}</td>
              </tr>
            ))}
          </tbody>
        </table>
      )}
    </section>
  );
}
