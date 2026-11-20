import { useQuery } from '@tanstack/react-query';
import {
  createRootRouteWithContext,
  createRoute,
  createRouter,
  Outlet,
  redirect,
} from '@tanstack/react-router';
import type { QueryClient } from '@tanstack/react-query';
import type { ReactNode } from 'react';
import { useTranslation } from 'react-i18next';
import { BoardPage } from './board-page.js';
import { HistoryPage } from './history-page.js';
import { LayoutPage } from './layout-page.js';
import { MenuPage } from './menu-page.js';
import {
  AccountPage,
  ReceiptPage,
  ReceiptsPage,
  StatementPage,
  StatementsPage,
} from './money-page.js';
import { BulkPricePage, PreviewPage, PriceLogPage, QuickEditPage } from './menu-tools-page.js';
import { OrderPage } from './order-page.js';
import { RatingsPage } from './ratings-page.js';
import { ReportsPage } from './reports-page.js';
import { sessionQuery } from './session.js';
import { SignInPage } from './sign-in-page.js';
import { SettingsPage } from './settings-page.js';
import { StatusPage } from './status-page.js';
import { SupportPage } from './support-page.js';
import { DevicesPage, StaffPage } from './team-page.js';
import { termsQuery } from './terms.js';
import { TermsPage } from './terms-page.js';

function NotFound() {
  const { t } = useTranslation();
  return <p>{t('notFound')}</p>;
}

const rootRoute = createRootRouteWithContext<{ queryClient: QueryClient }>()({
  component: Outlet,
  notFoundComponent: NotFound,
});

const signInRoute = createRoute({
  getParentRoute: () => rootRoute,
  path: '/sign-in',
  beforeLoad: async ({ context }) => {
    if (await context.queryClient.ensureQueryData(sessionQuery)) throw redirect({ to: '/orders' });
  },
  component: SignInPage,
});

// RA §5.3: every page but the sign-in needs the owner's session.
const signedInRoute = createRoute({
  getParentRoute: () => rootRoute,
  id: 'signed-in',
  beforeLoad: async ({ context }) => {
    const session = await context.queryClient.ensureQueryData(sessionQuery);
    if (!session) throw redirect({ to: '/sign-in' });
    return { session };
  },
  component: function SignedIn() {
    const { session } = signedInRoute.useRouteContext();
    return <LayoutPage session={session} />;
  },
});

const homeRoute = createRoute({
  getParentRoute: () => signedInRoute,
  path: '/',
  beforeLoad: () => {
    throw redirect({ to: '/orders' });
  },
});

const ordersRoute = createRoute({
  getParentRoute: () => signedInRoute,
  path: '/orders',
  component: BoardPage,
});

const orderRoute = createRoute({
  getParentRoute: () => signedInRoute,
  path: '/orders/$orderId',
  component: function Order() {
    const { orderId } = orderRoute.useParams();
    return <OrderPage orderId={orderId} />;
  },
});

// RA S13: until the owner accepts the terms in force, only «الطلبات» and the
// terms open.
function AfterTerms({ children }: { children: ReactNode }) {
  const { t } = useTranslation();
  const terms = useQuery(termsQuery);
  if (terms.isPending) return <p>{t('app.loading')}</p>;
  if (terms.isError) return <p role="alert">{t('app.error')}</p>;
  if (terms.data.pending) return <TermsPage />;
  return children;
}

const statusRoute = createRoute({
  getParentRoute: () => signedInRoute,
  path: '/status',
  component: () => (
    <AfterTerms>
      <StatusPage />
    </AfterTerms>
  ),
});

// RA §9, §17 (slice 2.45b): the owner's menu and its tools.
const menuRoutes = (
  [
    ['/menu', MenuPage],
    ['/menu/quick-edit', QuickEditPage],
    ['/menu/bulk-price', BulkPricePage],
    ['/menu/price-log', PriceLogPage],
    ['/menu/preview', PreviewPage],
  ] as const
).map(([path, Page]) =>
  createRoute({
    getParentRoute: () => signedInRoute,
    path,
    component: () => (
      <AfterTerms>
        <Page />
      </AfterTerms>
    ),
  }),
);

// RA §10, §14, §15, §17 (slice 2.45c): the settings, staff, devices and
// support.
const settingsRoutes = (
  [
    ['/settings', SettingsPage],
    ['/staff', StaffPage],
    ['/devices', DevicesPage],
  ] as const
).map(([path, Page]) =>
  createRoute({
    getParentRoute: () => signedInRoute,
    path,
    component: () => (
      <AfterTerms>
        <Page />
      </AfterTerms>
    ),
  }),
);

// RA §8.18, §11–13, §17 (slice 2.45d): the reports, the history, the
// ratings and the money section.
const recordRoutes = (
  [
    ['/reports', ReportsPage],
    ['/history', HistoryPage],
    ['/ratings', RatingsPage],
    ['/account', AccountPage],
    ['/statements', StatementsPage],
    ['/receipts', ReceiptsPage],
  ] as const
).map(([path, Page]) =>
  createRoute({
    getParentRoute: () => signedInRoute,
    path,
    component: () => (
      <AfterTerms>
        <Page />
      </AfterTerms>
    ),
  }),
);

const statementRoute = createRoute({
  getParentRoute: () => signedInRoute,
  path: '/statements/$statementId',
  component: function Statement() {
    const { statementId } = statementRoute.useParams();
    return (
      <AfterTerms>
        <StatementPage statementId={statementId} />
      </AfterTerms>
    );
  },
});

const receiptRoute = createRoute({
  getParentRoute: () => signedInRoute,
  path: '/receipts/$receiptId',
  component: function Receipt() {
    const { receiptId } = receiptRoute.useParams();
    return (
      <AfterTerms>
        <ReceiptPage receiptId={receiptId} />
      </AfterTerms>
    );
  },
});

// `report` opens «إبلاغ عن مشكلة» on a type (the settings' «طلب تعديل»),
// `order` and `number` on an order (an order's page).
const supportRoute = createRoute({
  getParentRoute: () => signedInRoute,
  path: '/support',
  validateSearch: (
    search: Record<string, unknown>,
  ): { report?: string; order?: string; number?: string } => ({
    ...(typeof search.report === 'string' ? { report: search.report } : {}),
    ...(typeof search.order === 'string' && typeof search.number === 'string'
      ? { order: search.order, number: String(search.number) }
      : {}),
  }),
  component: function Support() {
    const { report, order, number } = supportRoute.useSearch();
    return (
      <AfterTerms>
        <SupportPage
          report={report}
          order={order !== undefined && number !== undefined ? { id: order, number } : undefined}
        />
      </AfterTerms>
    );
  },
});

const termsRoute = createRoute({
  getParentRoute: () => signedInRoute,
  path: '/terms',
  component: TermsPage,
});

export function createPortalRouter(queryClient: QueryClient) {
  return createRouter({
    routeTree: rootRoute.addChildren([
      signInRoute,
      signedInRoute.addChildren([
        homeRoute,
        ordersRoute,
        orderRoute,
        statusRoute,
        ...menuRoutes,
        ...settingsRoutes,
        ...recordRoutes,
        statementRoute,
        receiptRoute,
        supportRoute,
        termsRoute,
      ]),
    ]),
    context: { queryClient },
  });
}

declare module '@tanstack/react-router' {
  interface Register {
    router: ReturnType<typeof createPortalRouter>;
  }
}
