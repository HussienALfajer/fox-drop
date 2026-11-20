import { useQuery } from '@tanstack/react-query';
import { Link, Outlet, useNavigate } from '@tanstack/react-router';
import { useTranslation } from 'react-i18next';
import { ContactLinks } from './contact-links.js';
import { LiveContext, TimeZoneContext, useMerchantChannel } from './live.js';
import { type PortalSession, useSignOut } from './session.js';
import { emergencyStopQuery, statusQuery } from './status.js';
import { termsQuery } from './terms.js';

// RA §17: the signed-in portal, unstyled until the design (owner decision
// 2026-11-20): the owner's name, the screens, sign-out, the pending terms
// and the platform's emergency stop above every page.
export function LayoutPage({ session }: { session: PortalSession }) {
  const { t } = useTranslation();
  const navigate = useNavigate();
  const signOut = useSignOut();
  const terms = useQuery(termsQuery);
  const stop = useQuery(emergencyStopQuery);
  const status = useQuery(statusQuery);
  const terminated = status.data === 'terminated';
  const live = useMerchantChannel(terminated ? undefined : session.restaurantId);

  return (
    <>
      <header>
        <strong>{t('app.name')}</strong>{' '}
        <span>{t('layout.signedInAs', { name: session.name })}</span>
        <nav>
          <Link to="/orders">{t('layout.orders')}</Link>{' '}
          <Link to="/status">{t('layout.status')}</Link> <Link to="/menu">{t('layout.menu')}</Link>{' '}
          <Link to="/settings">{t('layout.settings')}</Link>{' '}
          <Link to="/staff">{t('layout.staff')}</Link>{' '}
          <Link to="/devices">{t('layout.devices')}</Link>{' '}
          <Link to="/support">{t('layout.support')}</Link>{' '}
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
      {terminated ? (
        <p role="alert">{t('layout.terminated')}</p>
      ) : (
        <TimeZoneContext value={session.timeZone}>
          <LiveContext value={live}>
            <Outlet />
          </LiveContext>
        </TimeZoneContext>
      )}
    </>
  );
}
