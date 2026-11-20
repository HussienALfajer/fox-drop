import type { QueryClient } from '@tanstack/react-query';
import {
  createRootRouteWithContext,
  createRoute,
  createRouter,
  Outlet,
  redirect,
  retainSearchParams,
} from '@tanstack/react-router';
import { useTranslation } from 'react-i18next';
import { OPERATIONS_MANAGE } from './assign-captain.js';
import { AssignCaptainPage } from './assign-captain-page.js';
import { OrderHandoverPage } from './order-handover-page.js';
import { SETTINGS_READ } from './app-settings.js';
import { AppSettingsPage } from './app-settings-page.js';
import { EMERGENCY_CODE_PERMISSION } from './emergency-code.js';
import { EMERGENCY_STOP_TOGGLE } from './emergency-stop.js';
import { AlertsBell, SideMenu, TopBar } from './layout-page.js';
import { EmergencyStopPage } from './emergency-stop-page.js';
import { EmergencyCodePage } from './emergency-code-page.js';
import { receivesAlerts } from './alerts.js';
import { AlertsMonitor } from './alerts-monitor.js';
import { AlertsPage } from './alerts-page.js';
import { HomePage } from './home-page.js';
import { OrderDetailPage } from './order-detail-page.js';
import { OrderHistoryPage } from './order-history-page.js';
import { canSeeOrderHistory, historySearchOf } from './order-history.js';
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
import { DepositsPage } from './cash-desk-deposits-page.js';
import { ZONES_READ } from './peak-bonus.js';
import { PeakBonusPage } from './peak-bonus-page.js';
import { DeliveryFeesPage } from './delivery-fees-page.js';
import { PayTablesPage } from './pay-tables-page.js';
import { CompensationApprovalsPage } from './compensation-approvals-page.js';
import { canApproveCompensations } from './order-compensation.js';
import { canSeeBanners } from './banners.js';
import { BannersPage } from './banners-page.js';
import { canSeeMassPushes } from './mass-pushes.js';
import { MassPushesPage } from './mass-pushes-page.js';
import { isSettingGroup, type SettingGroup } from './settings.js';
import { SettingsPage } from './settings-page.js';
import { OtpSendersPage } from './otp-senders-page.js';
import { auditLogSearchOf, canReadAuditLog } from './audit-log.js';
import { AuditLogPage } from './audit-log-page.js';
import { canSeeLostDemand } from './lost-demand.js';
import { LostDemandPage } from './lost-demand-page.js';
import { MenuChangeRequestPage, MenuChangeRequestsPage } from './menu-change-requests-page.js';
import { canReviewMenuChanges } from './menu-change-requests.js';
import { canSeeHomeSections } from './home-sections.js';
import { HomeSectionsPage } from './home-sections-page.js';
import { canSeePromoCodes } from './promo-codes.js';
import { canReadTickets } from './tickets.js';
import { TicketsPage } from './tickets-page.js';
import { TicketPage } from './ticket-page.js';
import { PromoCodesPage } from './promo-codes-page.js';
import { PromoCodeReportPage } from './promo-code-report-page.js';
import { OfficePage } from './office-page.js';
import { CityProfilePage } from './city-profile-page.js';
import { DefaultsPage, DispatchRulesPage } from './city-settings-page.js';
import { SETTINGS_MANAGE, SWITCH_DISPATCH_MODE } from './city-settings.js';
import { ZonesPage } from './zones-page.js';
import { canSeeLiveMap } from './live-map.js';
import { LiveMapPage } from './live-map-page.js';
import { ReceiptPage } from './receipt-page.js';
import { RESTAURANT_STATEMENTS } from './restaurant-statements.js';
import { RestaurantStatementsPage } from './restaurant-statements-page.js';
import { SettleCaptainPage, SettlementsPage, StatementPage } from './settlement-page.js';
import { RestaurantReceiptPage, RestaurantSettlePage } from './restaurant-settle-page.js';
import { MerchantStatementPage, RestaurantSettlementsPage } from './restaurant-settlement-page.js';
import { canSeeCategories } from './categories.js';
import { CategoriesPage } from './categories-page.js';
import { CONTENT_FAQS, CONTENT_READ } from './content.js';
import { ContentPage } from './content-page.js';
import { canSeeDrafts, isStep, type Step } from './restaurant-drafts.js';
import { RestaurantDraftPage, RestaurantDraftsPage } from './restaurant-drafts-page.js';
import { canSeeRestaurantList, type ListFilter, listFilterOf } from './restaurant-list.js';
import { RestaurantListPage } from './restaurant-list-page.js';
import { isProfileTab, type ProfileTab } from './restaurant-profile.js';
import { RestaurantProfilePage } from './restaurant-profile-page.js';
import { boardSearch, canSeeApplications } from './captain-applications.js';
import { type CaptainListFilter, canSeeCaptains, captainListFilterOf } from './captain-list.js';
import { CaptainListPage } from './captain-list-page.js';
import { type CaptainTab, isCaptainTab } from './captain-profile.js';
import { CaptainProfilePage } from './captain-profile-page.js';
import { CaptainApplicationPage, CaptainApplicationsPage } from './captain-applications-page.js';
import { RatingsPage } from './ratings-page.js';
import { canSeeRatings, ratingsSearch } from './ratings.js';
import { can, sessionQuery } from './session.js';
import { SetupPage } from './setup-page.js';
import { SignInPage } from './sign-in-page.js';
import { ADMIN_TEAM } from './team.js';
import { TeamPage } from './team-page.js';

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

// The city chosen in the top bar's selector (AP §7.2), by its code; the
// first city without one.
const citySearch = (search: Record<string, unknown>): { city?: string } =>
  typeof search.city === 'string' ? { city: search.city } : {};

// Every other page needs a session; without one it opens the sign-in page.
// fetchQuery reads the session again once it is stale (sessionQuery). The
// top bar's city stays in the address from page to page (retainSearchParams).
const signedInRoute = createRoute({
  getParentRoute: () => rootRoute,
  id: 'signed-in',
  validateSearch: citySearch,
  search: { middlewares: [retainSearchParams(['city'])] },
  beforeLoad: async ({ context }) => {
    const session = await context.queryClient.fetchQuery(sessionQuery);
    if (!session) throw redirect({ to: '/sign-in' });
    return { session };
  },
  component: SignedInLayout,
});

// AP §7.1–7.2: every page shows the top bar and the side menu; AP §7.3: a
// recipient of alerts hears them on every page.
function SignedInLayout() {
  const { session } = signedInRoute.useRouteContext();
  const { city } = signedInRoute.useSearch();
  const page = (
    <>
      <TopBar session={session} cityCode={city} bell={<AlertsBell cityCode={city} />} />
      <SideMenu session={session} />
      <Outlet />
    </>
  );
  return receivesAlerts(session) ? <AlertsMonitor cityCode={city}>{page}</AlertsMonitor> : page;
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

// AP §9.5 «سجل الطلبات» (slice 2.40): OWN, OPS, SUP and FIN; the filters
// in the search but the customer's phone, which stays in the page.
const orderHistoryRoute = createRoute({
  getParentRoute: () => signedInRoute,
  path: '/order-history',
  validateSearch: (search: Record<string, unknown>) => ({
    ...citySearch(search),
    ...historySearchOf(search),
  }),
  beforeLoad: ({ context }) => {
    if (!canSeeOrderHistory(context.session)) throw redirect({ to: '/' });
  },
  component: OrderHistoryPage,
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

// AP §9.14 «الإعدادات» (slice 2.38a): OWN (the server lists each role only
// the settings it may change); the group and the city in the search.
const settingsRoute = createRoute({
  getParentRoute: () => signedInRoute,
  path: '/settings',
  validateSearch: (search: Record<string, unknown>): { city?: string; group: SettingGroup } => ({
    ...citySearch(search),
    group: isSettingGroup(search.group) && search.group !== 'apps' ? search.group : 'timers_limits',
  }),
  beforeLoad: ({ context }) => {
    if (!can(context.session, SETTINGS_READ)) throw redirect({ to: '/' });
  },
  component: SettingsPage,
});

// AP §9.14 «أرقام إرسال الرموز» (slice 2.38a): OWN reads (settings.read)
// and changes them (settings.manage).
const otpSendersRoute = createRoute({
  getParentRoute: () => signedInRoute,
  path: '/settings/otp-senders',
  beforeLoad: ({ context }) => {
    if (!can(context.session, SETTINGS_READ)) throw redirect({ to: '/' });
  },
  component: OtpSendersPage,
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

// AP §9.16 «سجل التدقيق» (slice 2.38a): OWN (audit_log.read, checked by the
// server too); the filters in the search.
const auditLogRoute = createRoute({
  getParentRoute: () => signedInRoute,
  path: '/audit-log',
  validateSearch: auditLogSearchOf,
  beforeLoad: ({ context }) => {
    if (!canReadAuditLog(context.session)) throw redirect({ to: '/' });
  },
  component: AuditLogPage,
});

// AP §9.13 «التصنيفات» (slice 2.27a): OWN, OPS (reads) and DATA.
const categoriesRoute = createRoute({
  getParentRoute: () => signedInRoute,
  path: '/categories',
  beforeLoad: ({ context }) => {
    if (!canSeeCategories(context.session)) throw redirect({ to: '/' });
  },
  component: CategoriesPage,
});

// «إضافة مطعم» (AP §9.6.3, slice 2.30a): the city's drafts, and one draft's
// steps; restaurants.read or restaurants.create read them, and each step's
// own permission saves it (the server checks).
const restaurantDraftsRoute = createRoute({
  getParentRoute: () => signedInRoute,
  path: '/restaurant-drafts',
  validateSearch: (search: Record<string, unknown>): { city?: string } => citySearch(search),
  beforeLoad: ({ context }) => {
    if (!canSeeDrafts(context.session)) throw redirect({ to: '/' });
  },
  component: RestaurantDraftsPage,
});

const restaurantDraftRoute = createRoute({
  getParentRoute: () => signedInRoute,
  path: '/restaurant-drafts/$restaurantId',
  validateSearch: (search: Record<string, unknown>): { city?: string; step: Step } => ({
    ...citySearch(search),
    step: isStep(search.step) ? search.step : 'basics',
  }),
  beforeLoad: ({ context }) => {
    if (!canSeeDrafts(context.session)) throw redirect({ to: '/' });
  },
  component: RestaurantDraftPage,
});

// «المطاعم» (slice 2.30c, AP §9.6.2): every restaurants.read session; the
// filters and a name searched in the search (a number stays in the page).
const restaurantListRoute = createRoute({
  getParentRoute: () => signedInRoute,
  path: '/restaurants',
  validateSearch: (search: Record<string, unknown>): { city?: string } & ListFilter => ({
    ...citySearch(search),
    ...listFilterOf(search),
  }),
  beforeLoad: ({ context }) => {
    if (!canSeeRestaurantList(context.session)) throw redirect({ to: '/' });
  },
  component: RestaurantListPage,
});

// AP §9.6.4 «ملف المطعم» (slice 2.30d): restaurants.read opens it; each
// tab's commands check their own permission (the server too). It took over
// «حالة المطاعم», «الصور» and «تصنيفات المطعم».
const restaurantProfileRoute = createRoute({
  getParentRoute: () => signedInRoute,
  path: '/restaurants/$restaurantId',
  validateSearch: (search: Record<string, unknown>): { city?: string; tab?: ProfileTab } => ({
    ...citySearch(search),
    ...(isProfileTab(search.tab) ? { tab: search.tab } : {}),
  }),
  beforeLoad: ({ context }) => {
    if (!canSeeRestaurantList(context.session)) throw redirect({ to: '/' });
  },
  component: RestaurantProfilePage,
});

// AP §9.7.3 «الكباتن» (slice 2.36a): captains.read or captains.money; the
// status, a name searched and the order in the search (a number stays in
// the page).
const captainListRoute = createRoute({
  getParentRoute: () => signedInRoute,
  path: '/captains',
  validateSearch: (search: Record<string, unknown>): { city?: string } & CaptainListFilter => ({
    ...citySearch(search),
    ...captainListFilterOf(search),
  }),
  beforeLoad: ({ context }) => {
    if (!canSeeCaptains(context.session)) throw redirect({ to: '/' });
  },
  component: CaptainListPage,
});

// AP §9.7.4 «ملف الكابتن» (slice 2.36a): as the list; each tab's actions
// check their own permission (the server too).
const captainProfileRoute = createRoute({
  getParentRoute: () => signedInRoute,
  path: '/captains/$captainId',
  validateSearch: (search: Record<string, unknown>): { city?: string; tab?: CaptainTab } => ({
    ...citySearch(search),
    ...(isCaptainTab(search.tab) ? { tab: search.tab } : {}),
  }),
  beforeLoad: ({ context }) => {
    if (!canSeeCaptains(context.session)) throw redirect({ to: '/' });
  },
  component: CaptainProfilePage,
});

// «التقييمات» (slice 2.26c; AP §9.7.4): a captain's, captains.read, until
// the captain profile (2.36); a restaurant's are in its profile (2.30d).
const ratingsRoute = createRoute({
  getParentRoute: () => signedInRoute,
  path: '/ratings',
  validateSearch: ratingsSearch,
  beforeLoad: ({ context }) => {
    if (!canSeeRatings(context.session)) throw redirect({ to: '/' });
  },
  component: RatingsPage,
});

// AP §9.7.1 «طلبات الانضمام» (slice 2.34b): the board by stage and an
// application's review page (captains.read); the actions need
// captains.manage (checked by the page and the server).
const captainApplicationsRoute = createRoute({
  getParentRoute: () => signedInRoute,
  path: '/captain-applications',
  validateSearch: boardSearch,
  beforeLoad: ({ context }) => {
    if (!canSeeApplications(context.session)) throw redirect({ to: '/' });
  },
  component: CaptainApplicationsPage,
});

const captainApplicationRoute = createRoute({
  getParentRoute: () => signedInRoute,
  path: '/captain-applications/$applicationId',
  validateSearch: citySearch,
  beforeLoad: ({ context }) => {
    if (!canSeeApplications(context.session)) throw redirect({ to: '/' });
  },
  component: CaptainApplicationPage,
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

// AP §9.12.3 «رسوم التوصيل» (slice 2.37a): read with zones.read (OWN, OPS,
// FIN); OWN changes the rules (zones.manage, checked by the page and the
// server).
const deliveryFeesRoute = createRoute({
  getParentRoute: () => signedInRoute,
  path: '/delivery-fees',
  validateSearch: citySearch,
  beforeLoad: ({ context }) => {
    if (!can(context.session, ZONES_READ)) throw redirect({ to: '/' });
  },
  component: DeliveryFeesPage,
});

// AP §9.12.5 «أجور الكباتن» (slice 2.37b): read with zones.read (OWN, OPS,
// FIN); OWN publishes a table (pricing.edit_pay_tables, checked by the page
// and the server).
const payTablesRoute = createRoute({
  getParentRoute: () => signedInRoute,
  path: '/pay-tables',
  validateSearch: citySearch,
  beforeLoad: ({ context }) => {
    if (!can(context.session, ZONES_READ)) throw redirect({ to: '/' });
  },
  component: PayTablesPage,
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

// AP §9.11.3 «أقسام الرئيسية» (slice 2.27b): OPS reads, OWN changes them
// (checked by the page and the server).
const homeSectionsRoute = createRoute({
  getParentRoute: () => signedInRoute,
  path: '/home-sections',
  validateSearch: citySearch,
  beforeLoad: ({ context }) => {
    if (!canSeeHomeSections(context.session)) throw redirect({ to: '/' });
  },
  component: HomeSectionsPage,
});

// AP §9.11.2 «البانرات» (slice 2.27c): OWN and DATA publish, OPS reads
// (checked by the page and the server).
const bannersRoute = createRoute({
  getParentRoute: () => signedInRoute,
  path: '/banners',
  validateSearch: citySearch,
  beforeLoad: ({ context }) => {
    if (!canSeeBanners(context.session)) throw redirect({ to: '/' });
  },
  component: BannersPage,
});

// AP §9.11.4 «الإشعارات الجماعية» (slice 2.27d): OWN sends, OPS reads
// (checked by the page and the server).
const massPushesRoute = createRoute({
  getParentRoute: () => signedInRoute,
  path: '/mass-pushes',
  validateSearch: citySearch,
  beforeLoad: ({ context }) => {
    if (!canSeeMassPushes(context.session)) throw redirect({ to: '/' });
  },
  component: MassPushesPage,
});

// AP §9.6.7 «طلبات تعديل القائمة» (slice 2.32b): OWN and OPS review the
// restaurants' menu change requests (menus.review_change_requests).
const menuChangesRoute = createRoute({
  getParentRoute: () => signedInRoute,
  path: '/menu-change-requests',
  validateSearch: citySearch,
  beforeLoad: ({ context }) => {
    if (!canReviewMenuChanges(context.session)) throw redirect({ to: '/' });
  },
  component: MenuChangeRequestsPage,
});

const menuChangeRoute = createRoute({
  getParentRoute: () => signedInRoute,
  path: '/menu-change-requests/$requestId',
  validateSearch: citySearch,
  beforeLoad: ({ context }) => {
    if (!canReviewMenuChanges(context.session)) throw redirect({ to: '/' });
  },
  component: MenuChangeRequestPage,
});

// AP §9.17 «الطلب الضائع» (slice 2.28a): an operations report, OWN and OPS
// (reports.all or reports.operations, checked by the server too).
const lostDemandRoute = createRoute({
  getParentRoute: () => signedInRoute,
  path: '/lost-demand',
  validateSearch: citySearch,
  beforeLoad: ({ context }) => {
    if (!canSeeLostDemand(context.session)) throw redirect({ to: '/' });
  },
  component: LostDemandPage,
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

// AP §9.4 «الخريطة الحية» (slice 2.39): live_map.read (OWN, OPS, SUP);
// OWN and OPS assign from it (operations.manage).
const liveMapRoute = createRoute({
  getParentRoute: () => signedInRoute,
  path: '/live-map',
  validateSearch: citySearch,
  beforeLoad: ({ context }) => {
    if (!canSeeLiveMap(context.session)) throw redirect({ to: '/' });
  },
  component: LiveMapPage,
});

// AP §9.12.2 «مناطق الخدمة» (slice 2.37c): read with zones.read (OWN, OPS,
// FIN); OWN draws, edits and activates a zone (zones.manage).
const zonesRoute = createRoute({
  getParentRoute: () => signedInRoute,
  path: '/zones',
  validateSearch: citySearch,
  beforeLoad: ({ context }) => {
    if (!can(context.session, ZONES_READ)) throw redirect({ to: '/' });
  },
  component: ZonesPage,
});

// AP §9.12.1 «المدن» (slice 2.37c): read with zones.read; OWN changes the
// city (zones.manage).
const citiesRoute = createRoute({
  getParentRoute: () => signedInRoute,
  path: '/cities',
  validateSearch: citySearch,
  beforeLoad: ({ context }) => {
    if (!can(context.session, ZONES_READ)) throw redirect({ to: '/' });
  },
  component: CityProfilePage,
});

// AP §9.12.4 «الإعدادات الافتراضية» (slice 2.37c): OWN's settings.
const defaultsRoute = createRoute({
  getParentRoute: () => signedInRoute,
  path: '/defaults',
  validateSearch: citySearch,
  beforeLoad: ({ context }) => {
    if (!can(context.session, SETTINGS_MANAGE)) throw redirect({ to: '/' });
  },
  component: DefaultsPage,
});

// AP §9.12.6 «قواعد التوزيع» (slice 2.37c): OWN, and OPS for the mode only.
const dispatchRulesRoute = createRoute({
  getParentRoute: () => signedInRoute,
  path: '/dispatch-rules',
  validateSearch: citySearch,
  beforeLoad: ({ context }) => {
    if (!can(context.session, SWITCH_DISPATCH_MODE)) throw redirect({ to: '/' });
  },
  component: DispatchRulesPage,
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

// AP §9.7.1 «تأمين العدة» (slice 2.35a): the deposits of the applications
// at «بانتظار العدة» (cash_desk.record).
const depositsRoute = createRoute({
  getParentRoute: () => signedInRoute,
  path: '/cash-desk/deposits',
  validateSearch: citySearch,
  beforeLoad: ({ context }) => {
    if (!can(context.session, CASH_DESK)) throw redirect({ to: '/' });
  },
  component: DepositsPage,
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

// AP §9.15 «فريق الإدارة» (slice 2.38b): OWN only (admin_team.manage).
const teamRoute = createRoute({
  getParentRoute: () => signedInRoute,
  path: '/team',
  validateSearch: citySearch,
  beforeLoad: ({ context }) => {
    if (!can(context.session, ADMIN_TEAM)) throw redirect({ to: '/' });
  },
  component: TeamPage,
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
    deliveryFeesRoute,
    payTablesRoute,
    compensationsRoute,
    ticketsRoute,
    ticketRoute,
    promoCodesRoute,
    promoCodeReportRoute,
    homeSectionsRoute,
    bannersRoute,
    massPushesRoute,
    lostDemandRoute,
    settingsRoute,
    otpSendersRoute,
    auditLogRoute,
    teamRoute,
    menuChangesRoute,
    menuChangeRoute,
    officeRoute,
    zonesRoute,
    liveMapRoute,
    citiesRoute,
    defaultsRoute,
    dispatchRulesRoute,
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
    depositsRoute,
    settleCaptainRoute,
    statementRoute,
    restaurantSettlementsRoute,
    merchantStatementRoute,
    restaurantSettleRoute,
    restaurantReceiptRoute,
    restaurantStatementsRoute,
    restaurantDraftsRoute,
    restaurantDraftRoute,
    categoriesRoute,
    restaurantListRoute,
    restaurantProfileRoute,
    captainListRoute,
    captainProfileRoute,
    ratingsRoute,
    captainApplicationsRoute,
    captainApplicationRoute,
    alertsRoute,
    ordersRoute.addChildren([orderRoute.addChildren([assignRoute, handoverRoute])]),
    orderHistoryRoute,
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
