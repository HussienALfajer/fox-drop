import { useMutation } from '@tanstack/react-query';
import type { components } from '@fox-drop/api-schema';
import { useQuery } from '@tanstack/react-query';
import { api } from './api.js';
import { SETTINGS_READ } from './app-settings.js';
import { canReadAuditLog } from './audit-log.js';
import { canSeeBanners } from './banners.js';
import { canSeeApplications } from './captain-applications.js';
import { canSeeCaptains } from './captain-list.js';
import { CASH_DESK, FINANCE_READ } from './cash-desk.js';
import { canSeeCategories } from './categories.js';
import { SETTINGS_MANAGE, SWITCH_DISPATCH_MODE } from './city-settings.js';
import { CONTENT_FAQS, CONTENT_READ } from './content.js';
import { CUSTOMERS_READ } from './customers.js';
import { EMERGENCY_CODE_PERMISSION } from './emergency-code.js';
import { canSeeHomeSections } from './home-sections.js';
import { canSeeLostDemand } from './lost-demand.js';
import { MANUAL_ADJUSTMENT } from './manual-entries.js';
import { canSeeMassPushes } from './mass-pushes.js';
import { canSeeLiveMap } from './live-map.js';
import { canReviewMenuChanges } from './menu-change-requests.js';
import { OPERATIONS_READ } from './orders-board.js';
import { ZONES_READ } from './peak-bonus.js';
import { canSeePromoCodes } from './promo-codes.js';
import { canSeeRatings } from './ratings.js';
import { canSeeDrafts } from './restaurant-drafts.js';
import { canSeeRestaurantList } from './restaurant-list.js';
import { RESTAURANT_STATEMENTS } from './restaurant-statements.js';
import { type AdminSession, can } from './session.js';
import { ADMIN_TEAM } from './team.js';
import { canReadTickets } from './tickets.js';

// AP §7.1 the side menu's modules, in its order. Dashboard and the order
// history have no page yet (slice 2.40), so they are not listed until they
// do.
export const MODULES = [
  'operations',
  'liveMap',
  'restaurants',
  'captains',
  'customers',
  'support',
  'finance',
  'marketing',
  'zones',
  'content',
  'settings',
  'team',
  'auditLog',
  'reports',
] as const;
export type MenuModule = (typeof MODULES)[number];

type Check = (session: AdminSession) => boolean;
const holds =
  (...permissions: string[]): Check =>
  (session) =>
    permissions.some((permission) => can(session, permission));

// Each page of the menu: its module, its path and who may open it (the
// same check as its route's beforeLoad).
export const MENU_LINKS = {
  orders: { module: 'operations', path: '/orders', allowed: holds(OPERATIONS_READ) },
  alerts: { module: 'operations', path: '/alerts', allowed: () => true },
  emergencyCode: {
    module: 'operations',
    path: '/emergency-code',
    allowed: holds(EMERGENCY_CODE_PERMISSION),
  },
  liveMap: { module: 'liveMap', path: '/live-map', allowed: canSeeLiveMap },
  restaurantList: { module: 'restaurants', path: '/restaurants', allowed: canSeeRestaurantList },
  drafts: { module: 'restaurants', path: '/restaurant-drafts', allowed: canSeeDrafts },
  menuChanges: {
    module: 'restaurants',
    path: '/menu-change-requests',
    allowed: canReviewMenuChanges,
  },
  captainList: { module: 'captains', path: '/captains', allowed: canSeeCaptains },
  applications: { module: 'captains', path: '/captain-applications', allowed: canSeeApplications },
  ratings: { module: 'captains', path: '/ratings', allowed: canSeeRatings },
  customers: { module: 'customers', path: '/customers', allowed: holds(CUSTOMERS_READ) },
  tickets: { module: 'support', path: '/tickets', allowed: canReadTickets },
  cashDesk: { module: 'finance', path: '/cash-desk', allowed: holds(CASH_DESK) },
  captainBalances: { module: 'finance', path: '/captain-balances', allowed: holds(FINANCE_READ) },
  dailyReport: { module: 'finance', path: '/daily-report', allowed: holds(FINANCE_READ) },
  costReport: { module: 'finance', path: '/cost-report', allowed: holds(FINANCE_READ) },
  exchangeRates: { module: 'finance', path: '/exchange-rates', allowed: holds(FINANCE_READ) },
  manualEntries: { module: 'finance', path: '/manual-entries', allowed: holds(MANUAL_ADJUSTMENT) },
  restaurantStatements: {
    module: 'finance',
    path: '/restaurant-statements',
    allowed: holds(RESTAURANT_STATEMENTS),
  },
  promoCodes: { module: 'marketing', path: '/promo-codes', allowed: canSeePromoCodes },
  homeSections: { module: 'marketing', path: '/home-sections', allowed: canSeeHomeSections },
  banners: { module: 'marketing', path: '/banners', allowed: canSeeBanners },
  massPushes: { module: 'marketing', path: '/mass-pushes', allowed: canSeeMassPushes },
  zones: { module: 'zones', path: '/zones', allowed: holds(ZONES_READ) },
  cities: { module: 'zones', path: '/cities', allowed: holds(ZONES_READ) },
  office: { module: 'zones', path: '/office', allowed: holds(ZONES_READ) },
  deliveryFees: { module: 'zones', path: '/delivery-fees', allowed: holds(ZONES_READ) },
  payTables: { module: 'zones', path: '/pay-tables', allowed: holds(ZONES_READ) },
  peakBonus: { module: 'zones', path: '/peak-bonus', allowed: holds(ZONES_READ) },
  defaults: { module: 'zones', path: '/defaults', allowed: holds(SETTINGS_MANAGE) },
  dispatchRules: { module: 'zones', path: '/dispatch-rules', allowed: holds(SWITCH_DISPATCH_MODE) },
  content: { module: 'content', path: '/content', allowed: holds(CONTENT_READ, CONTENT_FAQS) },
  categories: { module: 'content', path: '/categories', allowed: canSeeCategories },
  settings: { module: 'settings', path: '/settings', allowed: holds(SETTINGS_READ) },
  appSettings: { module: 'settings', path: '/settings/apps', allowed: holds(SETTINGS_READ) },
  team: { module: 'team', path: '/team', allowed: holds(ADMIN_TEAM) },
  auditLog: { module: 'auditLog', path: '/audit-log', allowed: canReadAuditLog },
  lostDemand: { module: 'reports', path: '/lost-demand', allowed: canSeeLostDemand },
} as const satisfies Record<string, { module: MenuModule; path: string; allowed: Check }>;
export type MenuLinkId = keyof typeof MENU_LINKS;

// AP §7.1 «Each user sees only the modules their roles allow»: the modules
// with the pages the session may open, a module with none left out.
export function menuOf(session: AdminSession): { module: MenuModule; links: MenuLinkId[] }[] {
  const ids = Object.keys(MENU_LINKS) as MenuLinkId[];
  return MODULES.flatMap((module) => {
    const links = ids.filter(
      (id) => MENU_LINKS[id].module === module && MENU_LINKS[id].allowed(session),
    );
    return links.length === 0 ? [] : [{ module, links }];
  });
}

// The module of the page open, by the longest menu path it starts with
// (`/settings/apps` is settings', `/cash-desk/sessions` finance's); null on
// the home page and pages no menu link leads to.
export function moduleOfPath(pathname: string): MenuModule | null {
  let best: { module: MenuModule; length: number } | null = null;
  for (const { module, path } of Object.values(MENU_LINKS)) {
    const under = pathname === path || pathname.startsWith(`${path}/`);
    if (under && (best === null || path.length > best.length)) {
      best = { module, length: path.length };
    }
  }
  return best?.module ?? null;
}

// AP §7.2 the dispatch mode in the top bar, read by every user.
export function useDispatchMode(cityId: string | undefined) {
  return useQuery({
    queryKey: ['dispatch-mode', cityId],
    enabled: cityId !== undefined,
    queryFn: async () => {
      const { data } = await api.GET('/v1/admin/settings/dispatch-mode', {
        params: { query: { cityId: cityId! } },
      });
      if (!data) throw new Error('The dispatch mode read failed.');
      return data.mode;
    },
    staleTime: 60_000,
  });
}

export type SearchResults = components['schemas']['AdminSearchResultsDto_Output'];

// AP §7.2 the global search, a POST so a phone stays out of the URL; the
// server answers each kind only to its module's readers.
export function useGlobalSearch() {
  return useMutation({
    mutationFn: async (query: { cityId: string; q: string }): Promise<SearchResults> => {
      const { data } = await api.POST('/v1/admin/search', { body: query });
      if (!data) throw new Error('The search failed.');
      return data;
    },
  });
}

export function noResults(results: SearchResults): boolean {
  return (
    results.orders.length +
      results.restaurants.length +
      results.captains.length +
      results.tickets.length +
      results.customers.length ===
    0
  );
}
