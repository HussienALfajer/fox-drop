import { useQuery } from '@tanstack/react-query';
import { Link, Outlet, useNavigate, useRouterState } from '@tanstack/react-router';
import { overdueQuery } from './account.js';
import { useTranslation } from 'react-i18next';
import { ContactLinks } from './contact-links.js';
import { formatMoney } from './format.js';
import { LiveContext, TimeZoneContext, useMerchantChannel } from './live.js';
import { type PortalSession, useSignOut } from './session.js';
import { emergencyStopQuery, statusQuery } from './status.js';
import { termsQuery } from './terms.js';

// RA §17: the signed-in portal, unstyled until the design (owner decision
// 2026-11-20): the owner's name, the screens, sign-out, the pending terms,
// the overdue settlement (RA §12.6) and the platform's emergency stop above
// every page. A terminated restaurant's owners keep the money section only,
// read only (RA §5.5; slice 2.45d), so nothing else shows before the
// status is read. A status that fails to read shows everything: each
// route checks the restaurant's status anyway.
const MONEY_PATHS = ['/account', '/statements', '/receipts'];

function isMoneyPath(path: string): boolean {
  return MONEY_PATHS.some((money) => path === money || path.startsWith(`${money}/`));
}

export function LayoutPage({ session }: { session: PortalSession }) {
  const { t } = useTranslation();
  const navigate = useNavigate();
  const signOut = useSignOut();
  const terms = useQuery(termsQuery);
  const stop = useQuery(emergencyStopQuery);
  const status = useQuery(statusQuery);
  const terminated = status.data === 'terminated';
  const live = useMerchantChannel(terminated ? undefined : session.restaurantId);
  const overdue = useQuery(overdueQuery);
  const path = useRouterState({ select: (state) => state.location.pathname });
  const money = (
    <>
      <Link to="/account">{t('layout.account')}</Link>{' '}
      <Link to="/statements">{t('layout.statements')}</Link>{' '}
      <Link to="/receipts">{t('layout.receipts')}</Link>
    </>
  );

  return (
    <>
      <header data-print="hide">
        <strong>{t('app.name')}</strong>{' '}
        <span>{t('layout.signedInAs', { name: session.name })}</span>
        <nav data-print="hide">
          {terminated || status.isPending ? (
            money
          ) : (
            <>
              <Link to="/orders">{t('layout.orders')}</Link>{' '}
              <Link to="/status">{t('layout.status')}</Link>{' '}
              <Link to="/menu">{t('layout.menu')}</Link>{' '}
              <Link to="/reports">{t('layout.reports')}</Link>{' '}
              <Link to="/history">{t('layout.history')}</Link>{' '}
              <Link to="/ratings">{t('layout.ratings')}</Link> {money}{' '}
              <Link to="/settings">{t('layout.settings')}</Link>{' '}
              <Link to="/staff">{t('layout.staff')}</Link>{' '}
              <Link to="/devices">{t('layout.devices')}</Link>{' '}
              <Link to="/support">{t('layout.support')}</Link>
            </>
          )}{' '}
          <Link to="/terms">{t('layout.terms')}</Link>
        </nav>
        <ContactLinks />{' '}
        <button
          type="button"
          disabled={signOut.isPending}
          onClick={() => void signOut.mutateAsync().then(() => navigate({ to: '/sign-in' }))}
        >
          {t('layout.signOut')}
        </button>
      </header>
      {stop.data?.active && <p role="alert">{t('layout.emergencyStop')}</p>}
      {terms.data?.pending && (
        <p role="alert">
          {t('layout.termsPending')} <Link to="/terms">{t('layout.termsShow')}</Link>
        </p>
      )}
      {overdue.data && (
        <p role="alert">
          {t('layout.overdue', { amount: formatMoney(overdue.data.amount, overdue.data.currency) })}{' '}
          <Link to="/account">{t('layout.account')}</Link>
        </p>
      )}
      {terminated && <p role="alert">{t('layout.terminated')}</p>}
      {status.isPending && <p>{t('app.loading')}</p>}
      {!status.isPending && (!terminated || isMoneyPath(path)) && (
        <TimeZoneContext value={session.timeZone}>
          <LiveContext value={live}>
            <Outlet />
          </LiveContext>
        </TimeZoneContext>
      )}
    </>
  );
}
