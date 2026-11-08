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
import { SETTINGS_READ } from './app-settings.js';
import { AppSettingsPage } from './app-settings-page.js';
import { EMERGENCY_CODE_PERMISSION } from './emergency-code.js';
import { EmergencyCodePage } from './emergency-code-page.js';
import { receivesAlerts } from './alerts.js';
import { AlertsMonitor } from './alerts-monitor.js';
import { AlertsPage } from './alerts-page.js';
import { HomePage } from './home-page.js';
import { OrderDetailPage } from './order-detail-page.js';
import { OPERATIONS_READ } from './orders-board.js';
import { OrdersBoardPage } from './orders-board-page.js';
import { CONTENT_FAQS, CONTENT_READ } from './content.js';
import { ContentPage } from './content-page.js';
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

// AP §7.3: a recipient of alerts hears them on every page.
function SignedInLayout() {
  const { session } = signedInRoute.useRouteContext();
  return receivesAlerts(session) ? (
    <AlertsMonitor>
      <Outlet />
    </AlertsMonitor>
  ) : (
    <Outlet />
  );
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

const routeTree = rootRoute.addChildren([
  setupRoute,
  signInRoute,
  signedInRoute.addChildren([
    homeRoute,
    emergencyCodeRoute,
    contentRoute,
    appSettingsRoute,
    alertsRoute,
    ordersRoute.addChildren([orderRoute.addChildren([assignRoute])]),
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
