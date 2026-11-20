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
import { LayoutPage } from './layout-page.js';
import { OrderPage } from './order-page.js';
import { sessionQuery } from './session.js';
import { SignInPage } from './sign-in-page.js';
import { StatusPage } from './status-page.js';
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

const termsRoute = createRoute({
  getParentRoute: () => signedInRoute,
  path: '/terms',
  component: TermsPage,
});

export function createPortalRouter(queryClient: QueryClient) {
  return createRouter({
    routeTree: rootRoute.addChildren([
      signInRoute,
      signedInRoute.addChildren([homeRoute, ordersRoute, orderRoute, statusRoute, termsRoute]),
    ]),
    context: { queryClient },
  });
}

declare module '@tanstack/react-router' {
  interface Register {
    router: ReturnType<typeof createPortalRouter>;
  }
}
