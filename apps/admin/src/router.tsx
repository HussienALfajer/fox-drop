import type { QueryClient } from '@tanstack/react-query';
import {
  createRootRouteWithContext,
  createRoute,
  createRouter,
  Outlet,
  redirect,
} from '@tanstack/react-router';
import { useTranslation } from 'react-i18next';
import { OPERATIONS_MANAGE } from './assign-captain.js';
import { AssignCaptainPage } from './assign-captain-page.js';
import { OrderHandoverPage } from './order-handover-page.js';
import { SETTINGS_READ } from './app-settings.js';
import { AppSettingsPage } from './app-settings-page.js';
import { EMERGENCY_CODE_PERMISSION } from './emergency-code.js';
import { EMERGENCY_STOP_TOGGLE } from './emergency-stop.js';
import { EmergencyStopBar } from './emergency-stop-bar.js';
import { EmergencyStopPage } from './emergency-stop-page.js';
import { EmergencyCodePage } from './emergency-code-page.js';
import { receivesAlerts } from './alerts.js';
import { AlertsMonitor } from './alerts-monitor.js';
import { AlertsPage } from './alerts-page.js';
import { HomePage } from './home-page.js';
import { OrderDetailPage } from './order-detail-page.js';
import { OPERATIONS_READ } from './orders-board.js';
import { OrdersBoardPage } from './orders-board-page.js';
import { CASH_DESK, FINANCE_READ } from './cash-desk.js';
import { CaptainBalancesPage } from './captain-balances-page.js';
import { CostReportPage } from './cost-report-page.js';
import { DailyReportPage } from './daily-report-page.js';
import { ExchangeRatesPage } from './exchange-rates-page.js';
import { CASH_DESK_RECORD, CUSTOMERS_READ } from './customers.js';
import { CustomerProfilePage, CustomerReceiptPage, CustomersPage } from './customers-page.js';
import { MANUAL_ADJUSTMENT } from './manual-entries.js';
import { ManualEntriesPage } from './manual-entries-page.js';
import { CashDeskPage, CashDeskSessionsPage } from './cash-desk-page.js';
import { ZONES_READ } from './peak-bonus.js';
import { PeakBonusPage } from './peak-bonus-page.js';
import { CompensationApprovalsPage } from './compensation-approvals-page.js';
import { canApproveCompensations } from './order-compensation.js';
import { canSeePromoCodes } from './promo-codes.js';
import { canReadTickets } from './tickets.js';
import { TicketsPage } from './tickets-page.js';
import { TicketPage } from './ticket-page.js';
import { PromoCodesPage } from './promo-codes-page.js';
import { PromoCodeReportPage } from './promo-code-report-page.js';
import { OfficePage } from './office-page.js';
import { ReceiptPage } from './receipt-page.js';
import { RESTAURANT_STATEMENTS } from './restaurant-statements.js';
import { RestaurantStatementsPage } from './restaurant-statements-page.js';
import { SettleCaptainPage, SettlementsPage, StatementPage } from './settlement-page.js';
import { RestaurantReceiptPage, RestaurantSettlePage } from './restaurant-settle-page.js';
import { MerchantStatementPage, RestaurantSettlementsPage } from './restaurant-settlement-page.js';
import { CONTENT_FAQS, CONTENT_READ } from './content.js';
import { ContentPage } from './content-page.js';
import { canSeeImages } from './restaurant-images.js';
import { RestaurantImagesPage } from './restaurant-images-page.js';
import { canSeeRestaurantStatus } from './restaurant-status.js';
import { RestaurantStatusPage } from './restaurant-status-page.js';
import { RatingsPage } from './ratings-page.js';
import { canSeeRatings, ratingsSearch } from './ratings.js';
import { can, sessionQuery } from './session.js';
import { SetupPage } from './setup-page.js';
import { SignInPage } from './sign-in-page.js';

function NotFound() {
  const { t } = useTranslation();
  return <p>{t('notFound')}</p>;
}

// A page that cannot load, such as the session read with the server down.
function LoadFailed() {
  const { t } = useTranslation();
  return <p role="alert">{t('status.error')}</p>;
}

const rootRoute = createRootRouteWithContext<{ queryClient: QueryClient }>()({
  component: Outlet,
  notFoundComponent: NotFound,
});

// AP §5.1 item 3: the setup link works without a session.
const setupRoute = createRoute({
  getParentRoute: () => rootRoute,
  path: '/setup',
  component: SetupPage,
});

const signInRoute = createRoute({
  getParentRoute: () => rootRoute,
  path: '/sign-in',
  beforeLoad: async ({ context }) => {
    if (await context.queryClient.fetchQuery(sessionQuery)) throw redirect({ to: '/' });
  },
  component: SignInPage,
});

// Every other page needs a session; without one it opens the sign-in page.
// fetchQuery reads the session again once it is stale (sessionQuery).
const signedInRoute = createRoute({
  getParentRoute: () => rootRoute,
  id: 'signed-in',
  beforeLoad: async ({ context }) => {
    const session = await context.queryClient.fetchQuery(sessionQuery);
    if (!session) throw redirect({ to: '/sign-in' });
    return { session };
  },
  component: SignedInLayout,
});

// AP §7: every page shows the platform status; AP §7.3: a recipient of
// alerts hears them on every page.
function SignedInLayout() {
  const { session } = signedInRoute.useRouteContext();
  const page = (
    <>
      <EmergencyStopBar session={session} />
      <Outlet />
    </>
  );
  return receivesAlerts(session) ? <AlertsMonitor>{page}</AlertsMonitor> : page;
}

const homeRoute = createRoute({
  getParentRoute: () => signedInRoute,
  path: '/',
  component: HomePage,
});

const emergencyCodeRoute = createRoute({
  getParentRoute: () => signedInRoute,
  path: '/emergency-code',
  beforeLoad: ({ context }) => {
    if (!can(context.session, EMERGENCY_CODE_PERMISSION)) throw redirect({ to: '/' });
  },
  component: EmergencyCodePage,
});

// AP §9.1.6 «الإيقاف الطارئ»: OWN and OPS.
const emergencyStopRoute = createRoute({
  getParentRoute: () => signedInRoute,
  path: '/emergency-stop',
  beforeLoad: ({ context }) => {
    if (!can(context.session, EMERGENCY_STOP_TOGGLE)) throw redirect({ to: '/' });
  },
  component: EmergencyStopPage,
});

// The city chosen in the top bar's selector (AP §7.2), by its code; the
// first city without one.
const citySearch = (search: Record<string, unknown>): { city?: string } =>
  typeof search.city === 'string' ? { city: search.city } : {};

// AP §9.2: the operations room.
const ordersRoute = createRoute({
  getParentRoute: () => signedInRoute,
  path: '/orders',
  validateSearch: citySearch,
  beforeLoad: ({ context }) => {
    if (!can(context.session, OPERATIONS_READ)) throw redirect({ to: '/' });
  },
  component: OrdersBoardPage,
});

// The detail opens beside the board (AP §9.2.1), and the picker inside it.
const orderRoute = createRoute({
  getParentRoute: () => ordersRoute,
  path: '$orderId',
  component: OrderDetailPage,
});

const assignRoute = createRoute({
  getParentRoute: () => orderRoute,
  path: 'assign',
  beforeLoad: ({ context }) => {
    if (!can(context.session, OPERATIONS_MANAGE)) throw redirect({ to: '/' });
  },
  component: AssignCaptainPage,
});

// AP §9.3.2 «تسليم لكابتن آخر» (slice 2.12b): the note and the picker.
const handoverRoute = createRoute({
  getParentRoute: () => orderRoute,
  path: 'handover',
  beforeLoad: ({ context }) => {
    if (!can(context.session, OPERATIONS_MANAGE)) throw redirect({ to: '/' });
  },
  component: OrderHandoverPage,
});

// AP §9.1.3: the alerts list. Any signed-in user may open it; the server
// answers the alerts the session's roles receive.
const alertsRoute = createRoute({
  getParentRoute: () => signedInRoute,
  path: '/alerts',
  validateSearch: citySearch,
  component: AlertsPage,
});

// AP §9.13 «المحتوى»: OWN and OPS (content.read), SUP for the FAQs.
const contentRoute = createRoute({
  getParentRoute: () => signedInRoute,
  path: '/content',
  beforeLoad: ({ context }) => {
    if (!can(context.session, CONTENT_READ) && !can(context.session, CONTENT_FAQS)) {
      throw redirect({ to: '/' });
    }
  },
  component: ContentPage,
});

// AP §9.14 «التطبيقات»: OWN (the server checks each key's edit roles).
const appSettingsRoute = createRoute({
  getParentRoute: () => signedInRoute,
  path: '/settings/apps',
  beforeLoad: ({ context }) => {
    if (!can(context.session, SETTINGS_READ)) throw redirect({ to: '/' });
  },
  component: AppSettingsPage,
});

// «الصور» (slice 2.5): logos and covers (restaurants.manage) and item photos
// (restaurants.menus); the server checks each.
const imagesRoute = createRoute({
  getParentRoute: () => signedInRoute,
  path: '/images',
  validateSearch: (search: Record<string, unknown>): { city?: string; restaurant?: string } => ({
    ...citySearch(search),
    ...(typeof search.restaurant === 'string' ? { restaurant: search.restaurant } : {}),
  }),
  beforeLoad: ({ context }) => {
    if (!canSeeImages(context.session)) throw redirect({ to: '/' });
  },
  component: RestaurantImagesPage,
});

// «حالة المطاعم» (slice 2.6b, AP §9.6.5): every restaurants.read session
// sees the state; restaurants.manage changes it (the server checks).
const restaurantStatusRoute = createRoute({
  getParentRoute: () => signedInRoute,
  path: '/restaurant-status',
  validateSearch: (search: Record<string, unknown>): { city?: string; restaurant?: string } => ({
    ...citySearch(search),
    ...(typeof search.restaurant === 'string' ? { restaurant: search.restaurant } : {}),
  }),
  beforeLoad: ({ context }) => {
    if (!canSeeRestaurantStatus(context.session)) throw redirect({ to: '/' });
  },
  component: RestaurantStatusPage,
});

// «التقييمات» (slice 2.26c; AP §9.6.4, §9.7.4): restaurants.read or
// captains.read, each choice by its own (the server checks), until the
// restaurant and captain profiles (2.30, 2.36).
const ratingsRoute = createRoute({
  getParentRoute: () => signedInRoute,
  path: '/ratings',
  validateSearch: ratingsSearch,
  beforeLoad: ({ context }) => {
    if (!canSeeRatings(context.session)) throw redirect({ to: '/' });
  },
  component: RatingsPage,
});

// AP §9.12.5 «مكافأة ساعة الذروة» (slice 2.16): read with the zones
// (zones.read); only OWN saves it (pricing.edit_pay_tables, checked by the
// page and the server), until the zones and pricing screens of 2.37.
const peakBonusRoute = createRoute({
  getParentRoute: () => signedInRoute,
  path: '/peak-bonus',
  validateSearch: citySearch,
  beforeLoad: ({ context }) => {
    if (!can(context.session, ZONES_READ)) throw redirect({ to: '/' });
  },
  component: PeakBonusPage,
});

// AP §6.4 «طلبات الموافقة» (slice 2.22a): OWN approves, edits or rejects
// the compensations asked above a cap (compensation.approve_above_cap).
const compensationsRoute = createRoute({
  getParentRoute: () => signedInRoute,
  path: '/compensations',
  validateSearch: citySearch,
  beforeLoad: ({ context }) => {
    if (!canApproveCompensations(context.session)) throw redirect({ to: '/' });
  },
  component: CompensationApprovalsPage,
});

// AP §9.9 «الدعم» (slice 2.23a): the tickets' list and a ticket's page
// (support.read: OWN, OPS, SUP, FIN; changes need support.manage).
const ticketsRoute = createRoute({
  getParentRoute: () => signedInRoute,
  path: '/tickets',
  validateSearch: citySearch,
  beforeLoad: ({ context }) => {
    if (!canReadTickets(context.session)) throw redirect({ to: '/' });
  },
  component: TicketsPage,
});

const ticketRoute = createRoute({
  getParentRoute: () => signedInRoute,
  path: '/tickets/$ticketId',
  validateSearch: citySearch,
  beforeLoad: ({ context }) => {
    if (!canReadTickets(context.session)) throw redirect({ to: '/' });
  },
  component: TicketPage,
});

// AP §9.11.1 «أكواد الخصم» (slice 2.21a): OPS reads the codes, FIN reads
// them with their cost, OWN manages them (checked by the page and the server).
const promoCodesRoute = createRoute({
  getParentRoute: () => signedInRoute,
  path: '/promo-codes',
  validateSearch: citySearch,
  beforeLoad: ({ context }) => {
    if (!canSeePromoCodes(context.session)) throw redirect({ to: '/' });
  },
  component: PromoCodesPage,
});

// AP §9.11.1 «Code report» (slice 2.21d): the list's readers; OWN pauses,
// resumes and extends from it (checked by the page and the server).
const promoCodeReportRoute = createRoute({
  getParentRoute: () => signedInRoute,
  path: '/promo-codes/$codeId',
  validateSearch: citySearch,
  beforeLoad: ({ context }) => {
    if (!canSeePromoCodes(context.session)) throw redirect({ to: '/' });
  },
  component: PromoCodeReportPage,
});

// AP §9.12.1 «المكتب» (slice 2.17c; owner decision 2026-11-12): the city's
// office and desk hours, read with the zones (zones.read); only OWN saves
// them (zones.manage, checked by the page and the server), until the map.
const officeRoute = createRoute({
  getParentRoute: () => signedInRoute,
  path: '/office',
  validateSearch: citySearch,
  beforeLoad: ({ context }) => {
    if (!can(context.session, ZONES_READ)) throw redirect({ to: '/' });
  },
  component: OfficePage,
});

// AP §9.10.3 «الصندوق» (slice 2.17a): the drawer session and the daily
// hand-in, the sessions with their variances and a receipt to print, for
// OWN and FIN (cash_desk.record).
const cashDeskRoute = createRoute({
  getParentRoute: () => signedInRoute,
  path: '/cash-desk',
  // `captain`: the captain «سجّل تسليماً» chose in «أرصدة الكباتن».
  validateSearch: (search: Record<string, unknown>): { city?: string; captain?: string } => ({
    ...citySearch(search),
    ...(typeof search.captain === 'string' ? { captain: search.captain } : {}),
  }),
  beforeLoad: ({ context }) => {
    if (!can(context.session, CASH_DESK)) throw redirect({ to: '/' });
  },
  component: CashDeskPage,
});

const cashDeskSessionsRoute = createRoute({
  getParentRoute: () => signedInRoute,
  path: '/cash-desk/sessions',
  validateSearch: citySearch,
  beforeLoad: ({ context }) => {
    if (!can(context.session, CASH_DESK)) throw redirect({ to: '/' });
  },
  component: CashDeskSessionsPage,
});

// AP §9.10.2 «أرصدة الكباتن» (slice 2.17b), finance's (OWN, FIN).
const captainBalancesRoute = createRoute({
  getParentRoute: () => signedInRoute,
  path: '/captain-balances',
  validateSearch: citySearch,
  beforeLoad: ({ context }) => {
    if (!can(context.session, FINANCE_READ)) throw redirect({ to: '/' });
  },
  component: CaptainBalancesPage,
});

// AP §9.10.4 «أسعار الصرف» (slice 2.20a), finance's (OWN, FIN).
const exchangeRatesRoute = createRoute({
  getParentRoute: () => signedInRoute,
  path: '/exchange-rates',
  validateSearch: citySearch,
  beforeLoad: ({ context }) => {
    if (!can(context.session, FINANCE_READ)) throw redirect({ to: '/' });
  },
  component: ExchangeRatesPage,
});

// AP §9.10.1 «التقرير اليومي» (slice 2.20d), finance's (OWN, FIN): the
// `day` parameter is the business day shown, today's when left out.
const dailyReportRoute = createRoute({
  getParentRoute: () => signedInRoute,
  path: '/daily-report',
  validateSearch: (search: Record<string, unknown>): { city?: string; day?: string } => ({
    ...citySearch(search),
    ...(typeof search.day === 'string' ? { day: search.day } : {}),
  }),
  beforeLoad: ({ context }) => {
    if (!can(context.session, FINANCE_READ)) throw redirect({ to: '/' });
  },
  component: DailyReportPage,
});

// AP §9.10.6 «كلفة التعويضات والخصومات» (slice 2.22d), finance's (OWN,
// FIN): `from` and `to` are the business days shown, the last 7 when left
// out.
const costReportRoute = createRoute({
  getParentRoute: () => signedInRoute,
  path: '/cost-report',
  validateSearch: (
    search: Record<string, unknown>,
  ): { city?: string; from?: string; to?: string } => ({
    ...citySearch(search),
    ...(typeof search.from === 'string' && typeof search.to === 'string'
      ? { from: search.from, to: search.to }
      : {}),
  }),
  beforeLoad: ({ context }) => {
    if (!can(context.session, FINANCE_READ)) throw redirect({ to: '/' });
  },
  component: CostReportPage,
});

// AP §9.10.7 «القيود التصحيحية» (slice 2.20c), OWN and FIN.
const manualEntriesRoute = createRoute({
  getParentRoute: () => signedInRoute,
  path: '/manual-entries',
  validateSearch: citySearch,
  beforeLoad: ({ context }) => {
    if (!can(context.session, MANUAL_ADJUSTMENT)) throw redirect({ to: '/' });
  },
  component: ManualEntriesPage,
});

// AP §9.8 «الزبائن» (slice 2.25a): the search and the profile
// (customers.read), and a customer's receipt at the desk (cash_desk.record).
const customersRoute = createRoute({
  getParentRoute: () => signedInRoute,
  path: '/customers',
  validateSearch: citySearch,
  beforeLoad: ({ context }) => {
    if (!can(context.session, CUSTOMERS_READ)) throw redirect({ to: '/' });
  },
  component: CustomersPage,
});

const customerRoute = createRoute({
  getParentRoute: () => signedInRoute,
  path: '/customers/$customerId',
  validateSearch: citySearch,
  beforeLoad: ({ context }) => {
    if (!can(context.session, CUSTOMERS_READ)) throw redirect({ to: '/' });
  },
  component: CustomerProfilePage,
});

const customerReceiptRoute = createRoute({
  getParentRoute: () => signedInRoute,
  path: '/cash-desk/customer-receipts/$receiptId',
  beforeLoad: ({ context }) => {
    if (!can(context.session, CASH_DESK_RECORD)) throw redirect({ to: '/' });
  },
  component: CustomerReceiptPage,
});

const receiptRoute = createRoute({
  getParentRoute: () => signedInRoute,
  path: '/cash-desk/receipts/$receiptId',
  beforeLoad: ({ context }) => {
    if (!can(context.session, CASH_DESK)) throw redirect({ to: '/' });
  },
  component: ReceiptPage,
});

// AP §9.10.3 «تصفية الخميس» (slice 2.18a): the list, one captain's
// settlement and the weekly statement to print (cash_desk.record).
const settlementsRoute = createRoute({
  getParentRoute: () => signedInRoute,
  path: '/cash-desk/settlements',
  validateSearch: citySearch,
  beforeLoad: ({ context }) => {
    if (!can(context.session, CASH_DESK)) throw redirect({ to: '/' });
  },
  component: SettlementsPage,
});

const settleCaptainRoute = createRoute({
  getParentRoute: () => signedInRoute,
  path: '/cash-desk/settlements/$captainId',
  validateSearch: citySearch,
  beforeLoad: ({ context }) => {
    if (!can(context.session, CASH_DESK)) throw redirect({ to: '/' });
  },
  component: SettleCaptainPage,
});

const statementRoute = createRoute({
  getParentRoute: () => signedInRoute,
  path: '/cash-desk/statements/$statementId',
  beforeLoad: ({ context }) => {
    if (!can(context.session, CASH_DESK)) throw redirect({ to: '/' });
  },
  component: StatementPage,
});

// AP §9.10.3 «تسوية المطاعم» (slice 2.19a): the restaurants with a balance
// and their weekly statements to print (cash_desk.record).
const restaurantSettlementsRoute = createRoute({
  getParentRoute: () => signedInRoute,
  path: '/cash-desk/restaurants',
  validateSearch: citySearch,
  beforeLoad: ({ context }) => {
    if (!can(context.session, CASH_DESK)) throw redirect({ to: '/' });
  },
  component: RestaurantSettlementsPage,
});

const merchantStatementRoute = createRoute({
  getParentRoute: () => signedInRoute,
  path: '/cash-desk/merchant-statements/$statementId',
  beforeLoad: ({ context }) => {
    if (!can(context.session, CASH_DESK)) throw redirect({ to: '/' });
  },
  component: MerchantStatementPage,
});

// «تسوية» (slice 2.19b): the settlement at the office and its receipt.
const restaurantSettleRoute = createRoute({
  getParentRoute: () => signedInRoute,
  path: '/cash-desk/restaurants/$restaurantId/settle',
  validateSearch: citySearch,
  beforeLoad: ({ context }) => {
    if (!can(context.session, CASH_DESK)) throw redirect({ to: '/' });
  },
  component: RestaurantSettlePage,
});

const restaurantReceiptRoute = createRoute({
  getParentRoute: () => signedInRoute,
  path: '/cash-desk/restaurant-receipts/$receiptId',
  beforeLoad: ({ context }) => {
    if (!can(context.session, CASH_DESK)) throw redirect({ to: '/' });
  },
  component: RestaurantReceiptPage,
});

// AP §9.10.5 «كشوف المطاعم» (slice 2.19g): any restaurant and any period,
// printed and exported to Excel (restaurants.statements: OWN, FIN).
const restaurantStatementsRoute = createRoute({
  getParentRoute: () => signedInRoute,
  path: '/restaurant-statements',
  validateSearch: (
    search: Record<string, unknown>,
  ): { city?: string; restaurant?: string; from?: string; to?: string } => ({
    ...citySearch(search),
    ...(typeof search.restaurant === 'string' ? { restaurant: search.restaurant } : {}),
    ...(typeof search.from === 'string' ? { from: search.from } : {}),
    ...(typeof search.to === 'string' ? { to: search.to } : {}),
  }),
  beforeLoad: ({ context }) => {
    if (!can(context.session, RESTAURANT_STATEMENTS)) throw redirect({ to: '/' });
  },
  component: RestaurantStatementsPage,
});

const routeTree = rootRoute.addChildren([
  setupRoute,
  signInRoute,
  signedInRoute.addChildren([
    homeRoute,
    emergencyCodeRoute,
    emergencyStopRoute,
    contentRoute,
    appSettingsRoute,
    peakBonusRoute,
    compensationsRoute,
    ticketsRoute,
    ticketRoute,
    promoCodesRoute,
    promoCodeReportRoute,
    officeRoute,
    cashDeskRoute,
    cashDeskSessionsRoute,
    captainBalancesRoute,
    exchangeRatesRoute,
    dailyReportRoute,
    costReportRoute,
    manualEntriesRoute,
    customersRoute,
    customerRoute,
    customerReceiptRoute,
    receiptRoute,
    settlementsRoute,
    settleCaptainRoute,
    statementRoute,
    restaurantSettlementsRoute,
    merchantStatementRoute,
    restaurantSettleRoute,
    restaurantReceiptRoute,
    restaurantStatementsRoute,
    imagesRoute,
    restaurantStatusRoute,
    ratingsRoute,
    alertsRoute,
    ordersRoute.addChildren([orderRoute.addChildren([assignRoute, handoverRoute])]),
  ]),
]);

export function createAppRouter(queryClient: QueryClient) {
  return createRouter({ routeTree, context: { queryClient }, defaultErrorComponent: LoadFailed });
}

declare module '@tanstack/react-router' {
  interface Register {
    router: ReturnType<typeof createAppRouter>;
  }
}
