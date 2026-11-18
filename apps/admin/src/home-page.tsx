import { getRouteApi, Link, useNavigate } from '@tanstack/react-router';
import { useTranslation } from 'react-i18next';
import { SETTINGS_READ } from './app-settings.js';
import { CASH_DESK, FINANCE_READ } from './cash-desk.js';
import { ApprovalsLink } from './compensation-approvals-page.js';
import { CONTENT_FAQS, CONTENT_READ } from './content.js';
import { EMERGENCY_CODE_PERMISSION } from './emergency-code.js';
import { OPERATIONS_READ } from './orders-board.js';
import { ZONES_READ } from './peak-bonus.js';
import { canApproveCompensations } from './order-compensation.js';
import { canReadTickets } from './tickets.js';
import { canSeePromoCodes } from './promo-codes.js';
import { RESTAURANT_STATEMENTS } from './restaurant-statements.js';
import { canSeeImages } from './restaurant-images.js';
import { canSeeRestaurantStatus } from './restaurant-status.js';
import { canSeeRatings } from './ratings.js';
import { CUSTOMERS_READ } from './customers.js';
import { MANUAL_ADJUSTMENT } from './manual-entries.js';
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
          {canSeeRestaurantStatus(session) && (
            <li>
              <Link to="/restaurant-status">{t('restaurantStatus.title')}</Link>
            </li>
          )}
          {canSeeRatings(session) && (
            <li>
              <Link to="/ratings">{t('ratings.title')}</Link>
            </li>
          )}
          {can(session, ZONES_READ) && (
            <li>
              <Link to="/peak-bonus">{t('peakBonus.title')}</Link>
            </li>
          )}
          {canReadTickets(session) && (
            <li>
              <Link to="/tickets">{t('tickets.title')}</Link>
            </li>
          )}
          {canApproveCompensations(session) && (
            <li>
              <ApprovalsLink />
            </li>
          )}
          {canSeePromoCodes(session) && (
            <li>
              <Link to="/promo-codes">{t('promoCodes.title')}</Link>
            </li>
          )}
          {can(session, ZONES_READ) && (
            <li>
              <Link to="/office">{t('office.title')}</Link>
            </li>
          )}
          {can(session, CASH_DESK) && (
            <li>
              <Link to="/cash-desk">{t('cashDesk.title')}</Link>
            </li>
          )}
          {can(session, FINANCE_READ) && (
            <li>
              <Link to="/captain-balances">{t('captainBalances.title')}</Link>
            </li>
          )}
          {can(session, FINANCE_READ) && (
            <li>
              <Link to="/daily-report">{t('dailyReport.title')}</Link>
            </li>
          )}
          {can(session, FINANCE_READ) && (
            <li>
              <Link to="/cost-report">{t('costReport.title')}</Link>
            </li>
          )}
          {can(session, FINANCE_READ) && (
            <li>
              <Link to="/exchange-rates">{t('exchangeRates.title')}</Link>
            </li>
          )}
          {can(session, CUSTOMERS_READ) && (
            <li>
              <Link to="/customers">{t('customers.title')}</Link>
            </li>
          )}
          {can(session, MANUAL_ADJUSTMENT) && (
            <li>
              <Link to="/manual-entries">{t('manualEntries.title')}</Link>
            </li>
          )}
          {can(session, RESTAURANT_STATEMENTS) && (
            <li>
              <Link to="/restaurant-statements">{t('restaurantStatements.title')}</Link>
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
