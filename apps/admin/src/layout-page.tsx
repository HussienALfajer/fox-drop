import { useQuery } from '@tanstack/react-query';
import { Link, useLocation, useNavigate } from '@tanstack/react-router';
import { type FormEvent, type ReactNode, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { alertsQuery, receivesAlerts } from './alerts.js';
import { type City, chosenCity, citiesQuery } from './cities.js';
import { ApprovalsLink } from './compensation-approvals-page.js';
import { EmergencyStopBar } from './emergency-stop-bar.js';
import {
  type MenuLinkId,
  menuOf,
  moduleOfPath,
  noResults,
  type SearchResults,
  useDispatchMode,
  useGlobalSearch,
} from './layout.js';
import { canApproveCompensations } from './order-compensation.js';
import { statusKeys } from './order-labels.js';
import { type AdminSession, useSignOut } from './session.js';
import { isRole } from './team.js';
import { ticketStatusKeys } from './tickets.js';

// Each menu page's link, by its id (layout.ts says who sees it).
function MenuLink({ id }: { id: MenuLinkId }) {
  const { t } = useTranslation();
  switch (id) {
    case 'dashboard':
      return <Link to="/dashboard">{t('dashboard.title')}</Link>;
    case 'orders':
      return <Link to="/orders">{t('board.title')}</Link>;
    case 'liveMap':
      return <Link to="/live-map">{t('liveMap.title')}</Link>;
    case 'orderHistory':
      return <Link to="/order-history">{t('orderHistory.title')}</Link>;
    case 'alerts':
      return <Link to="/alerts">{t('alerts.title')}</Link>;
    case 'emergencyCode':
      return <Link to="/emergency-code">{t('emergencyCode.title')}</Link>;
    case 'restaurantList':
      return <Link to="/restaurants">{t('restaurantList.title')}</Link>;
    case 'drafts':
      return <Link to="/restaurant-drafts">{t('drafts.title')}</Link>;
    case 'menuChanges':
      return <Link to="/menu-change-requests">{t('menuChanges.title')}</Link>;
    case 'captainList':
      return <Link to="/captains">{t('captainList.title')}</Link>;
    case 'applications':
      return <Link to="/captain-applications">{t('captainApplications.title')}</Link>;
    case 'ratings':
      return <Link to="/ratings">{t('ratings.title')}</Link>;
    case 'customers':
      return <Link to="/customers">{t('customers.title')}</Link>;
    case 'tickets':
      return <Link to="/tickets">{t('tickets.title')}</Link>;
    case 'cashDesk':
      return <Link to="/cash-desk">{t('cashDesk.title')}</Link>;
    case 'captainBalances':
      return <Link to="/captain-balances">{t('captainBalances.title')}</Link>;
    case 'dailyReport':
      return <Link to="/daily-report">{t('dailyReport.title')}</Link>;
    case 'costReport':
      return <Link to="/cost-report">{t('costReport.title')}</Link>;
    case 'exchangeRates':
      return <Link to="/exchange-rates">{t('exchangeRates.title')}</Link>;
    case 'manualEntries':
      return <Link to="/manual-entries">{t('manualEntries.title')}</Link>;
    case 'restaurantStatements':
      return <Link to="/restaurant-statements">{t('restaurantStatements.title')}</Link>;
    case 'promoCodes':
      return <Link to="/promo-codes">{t('promoCodes.title')}</Link>;
    case 'homeSections':
      return <Link to="/home-sections">{t('homeSections.title')}</Link>;
    case 'banners':
      return <Link to="/banners">{t('banners.title')}</Link>;
    case 'massPushes':
      return <Link to="/mass-pushes">{t('massPushes.title')}</Link>;
    case 'zones':
      return <Link to="/zones">{t('zones.title')}</Link>;
    case 'cities':
      return <Link to="/cities">{t('cityProfile.title')}</Link>;
    case 'office':
      return <Link to="/office">{t('office.title')}</Link>;
    case 'deliveryFees':
      return <Link to="/delivery-fees">{t('deliveryFees.title')}</Link>;
    case 'payTables':
      return <Link to="/pay-tables">{t('payTables.title')}</Link>;
    case 'peakBonus':
      return <Link to="/peak-bonus">{t('peakBonus.title')}</Link>;
    case 'defaults':
      return <Link to="/defaults">{t('citySettings.defaultsTitle')}</Link>;
    case 'dispatchRules':
      return <Link to="/dispatch-rules">{t('citySettings.dispatchTitle')}</Link>;
    case 'content':
      return <Link to="/content">{t('content.title')}</Link>;
    case 'categories':
      return <Link to="/categories">{t('categories.title')}</Link>;
    case 'settings':
      return (
        <Link to="/settings" search={{ group: 'timers_limits' }}>
          {t('settings.title')}
        </Link>
      );
    case 'appSettings':
      return <Link to="/settings/apps">{t('appSettings.title')}</Link>;
    case 'team':
      return <Link to="/team">{t('team.title')}</Link>;
    case 'auditLog':
      return <Link to="/audit-log">{t('auditLog.title')}</Link>;
    case 'lostDemand':
      return <Link to="/lost-demand">{t('lostDemand.title')}</Link>;
  }
}

// AP §7.1 the side menu (on the start side, right in Arabic, once styled):
// the modules the session's roles allow, each with its pages. On the start
// page every module is open; elsewhere the page's own module. Unstyled until
// the design.
export function SideMenu({ session }: { session: AdminSession }) {
  const { t } = useTranslation();
  const { pathname } = useLocation();
  const current = moduleOfPath(pathname);
  return (
    <nav aria-label={t('layout.menu')}>
      {menuOf(session).map(({ module, links }) => (
        <details key={module} open={pathname === '/' || module === current}>
          <summary>{t(`layout.module.${module}`)}</summary>
          <ul>
            {links.map((id) => (
              <li key={id}>
                <MenuLink id={id} />
              </li>
            ))}
          </ul>
        </details>
      ))}
    </nav>
  );
}

// AP §7.2 the top bar: the city (kept in every page's `city` parameter),
// the platform status, the dispatch mode, the search, the alerts bell, the
// approvals badge (OWN) and the user menu.
export function TopBar({
  session,
  cityCode,
  bell,
}: {
  session: AdminSession;
  cityCode: string | undefined;
  bell: ReactNode;
}) {
  const cities = useQuery(citiesQuery);
  const city = cities.data ? chosenCity(cities.data, cityCode) : undefined;
  return (
    <header>
      {cities.data && city && <CitySelector cities={cities.data} city={city} />}
      <EmergencyStopBar session={session} cityCode={cityCode} />
      {city && <DispatchMode cityId={city.id} />}
      {city && <GlobalSearch key={city.id} city={city} />}
      {receivesAlerts(session) && bell}
      {canApproveCompensations(session) && <ApprovalsLink cityCode={cityCode} />}
      <UserMenu session={session} />
    </header>
  );
}

function CitySelector({ cities, city }: { cities: City[]; city: City }) {
  const { t } = useTranslation();
  const navigate = useNavigate();
  return (
    <label>
      {t('layout.city')}
      <select
        value={city.code}
        onChange={(event) =>
          void navigate({
            to: '.',
            search: (before: Record<string, unknown>) => ({ ...before, city: event.target.value }),
          } as never)
        }
      >
        {cities.map((each) => (
          <option key={each.id} value={each.code}>
            {each.name}
          </option>
        ))}
      </select>
    </label>
  );
}

function DispatchMode({ cityId }: { cityId: string }) {
  const { t } = useTranslation();
  const mode = useDispatchMode(cityId);
  if (!mode.data) return null;
  return <p>{t('layout.dispatchMode', { mode: t(`layout.dispatch.${mode.data}`) })}</p>;
}

// The alerts bell with the count of open alerts (AP §7.2), for a recipient;
// the alarm itself is AlertsMonitor's.
export function AlertsBell({ cityCode }: { cityCode: string | undefined }) {
  const { t } = useTranslation();
  const cities = useQuery(citiesQuery);
  const city = cities.data ? chosenCity(cities.data, cityCode) : undefined;
  const alerts = useQuery({ ...alertsQuery(city?.id ?? ''), enabled: city !== undefined });
  if (!city) return null;
  return (
    <Link to="/alerts" search={{ city: city.code }}>
      {t('alerts.bell', { count: alerts.data?.length ?? 0 })}
    </Link>
  );
}

function GlobalSearch({ city }: { city: City }) {
  const { t } = useTranslation();
  const [q, setQ] = useState('');
  const search = useGlobalSearch();
  function submit(event: FormEvent) {
    event.preventDefault();
    if (q.trim() === '') return;
    search.mutate({ cityId: city.id, q: q.trim() });
  }
  return (
    <search>
      <form onSubmit={submit}>
        <label>
          {t('layout.search.label')}
          <input type="search" value={q} onChange={(event) => setQ(event.target.value)} />
        </label>
        <button type="submit" disabled={search.isPending}>
          {t('layout.search.submit')}
        </button>
      </form>
      <p>{t('layout.search.hint')}</p>
      {search.isError && <p role="alert">{t('common.failed')}</p>}
      {search.data && <SearchList results={search.data} city={city} />}
    </search>
  );
}

function SearchList({ results, city }: { results: SearchResults; city: City }) {
  const { t } = useTranslation();
  if (noResults(results)) return <p role="status">{t('layout.search.none')}</p>;
  const params = { city: city.code };
  return (
    <ul aria-label={t('layout.search.results')}>
      {results.orders.map((order) => (
        <li key={order.id}>
          <Link to="/orders/$orderId" params={{ orderId: order.id }} search={params}>
            {t('layout.search.order', {
              number: order.number,
              status: t(statusKeys[order.status]),
            })}
          </Link>
        </li>
      ))}
      {results.tickets.map((ticket) => (
        <li key={ticket.id}>
          <Link to="/tickets/$ticketId" params={{ ticketId: ticket.id }} search={params}>
            {t('layout.search.ticket', {
              number: ticket.number,
              status: t(ticketStatusKeys[ticket.status]),
            })}
          </Link>
        </li>
      ))}
      {results.restaurants.map((restaurant) => (
        <li key={restaurant.id}>
          <Link
            to="/restaurants/$restaurantId"
            params={{ restaurantId: restaurant.id }}
            search={params}
          >
            {t('layout.search.restaurant', { name: restaurant.name })}
          </Link>
        </li>
      ))}
      {results.captains.map((captain) => (
        <li key={captain.id}>
          <Link to="/captains/$captainId" params={{ captainId: captain.id }} search={params}>
            {t('layout.search.captain', { name: captain.name })}
          </Link>
        </li>
      ))}
      {results.customers.map((customer) => (
        <li key={customer.id}>
          <Link to="/customers/$customerId" params={{ customerId: customer.id }} search={params}>
            {t('layout.search.customer', {
              name: customer.name === '' ? t('layout.search.noName') : customer.name,
            })}{' '}
            <bdi dir="ltr">{customer.maskedPhone}</bdi>
          </Link>
        </li>
      ))}
    </ul>
  );
}

// AP §7.2 the user menu: the roles held and «تسجيل الخروج». The profile and
// the user's own sessions come with their pages.
function UserMenu({ session }: { session: AdminSession }) {
  const { t } = useTranslation();
  const navigate = useNavigate();
  const signOut = useSignOut();
  const roles = session.roles
    .map((role) => (isRole(role) ? t(`team.role.${role}`) : role))
    .join(t('team.separator'));
  return (
    <details>
      <summary>{t('layout.user', { roles })}</summary>
      <button
        type="button"
        disabled={signOut.isPending}
        onClick={() =>
          signOut.mutate(undefined, { onSuccess: () => void navigate({ to: '/sign-in' }) })
        }
      >
        {t('signOut')}
      </button>
      {signOut.isError && <p role="alert">{t('common.failed')}</p>}
    </details>
  );
}
