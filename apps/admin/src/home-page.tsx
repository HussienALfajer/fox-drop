import { getRouteApi, Link, useNavigate } from '@tanstack/react-router';
import { useTranslation } from 'react-i18next';
import { SETTINGS_READ } from './app-settings.js';
import { CONTENT_FAQS, CONTENT_READ } from './content.js';
import { EMERGENCY_CODE_PERMISSION } from './emergency-code.js';
import { OPERATIONS_READ } from './orders-board.js';
import { canSeeImages } from './restaurant-images.js';
import { can, useSignOut } from './session.js';
import { useServerStatus } from './status.js';

const signedIn = getRouteApi('/signed-in');

// The panel's start page until the layout and the dashboard: the server
// status, the pages this session may open, and sign-out.
export function HomePage() {
  const { t } = useTranslation();
  const navigate = useNavigate();
  const { session } = signedIn.useRouteContext();
  const signOut = useSignOut();
  const status = useServerStatus();

  function leave() {
    signOut.mutate(undefined, { onSuccess: () => void navigate({ to: '/sign-in' }) });
  }

  return (
    <main>
      <h1>{t('app.name')}</h1>
      <p role="status">
        {status.isPending
          ? t('status.loading')
          : status.isError
            ? t('status.error')
            : t('status.ok')}
      </p>
      <nav>
        <ul>
          {can(session, OPERATIONS_READ) && (
            <li>
              <Link to="/orders">{t('board.title')}</Link>
            </li>
          )}
          {(can(session, CONTENT_READ) || can(session, CONTENT_FAQS)) && (
            <li>
              <Link to="/content">{t('content.title')}</Link>
            </li>
          )}
          {canSeeImages(session) && (
            <li>
              <Link to="/images">{t('images.title')}</Link>
            </li>
          )}
          {can(session, SETTINGS_READ) && (
            <li>
              <Link to="/settings/apps">{t('appSettings.title')}</Link>
            </li>
          )}
          {can(session, EMERGENCY_CODE_PERMISSION) && (
            <li>
              <Link to="/emergency-code">{t('emergencyCode.title')}</Link>
            </li>
          )}
        </ul>
      </nav>
      <button type="button" onClick={leave} disabled={signOut.isPending}>
        {t('signOut')}
      </button>
      {signOut.isError && <p role="alert">{t('common.failed')}</p>}
    </main>
  );
}
