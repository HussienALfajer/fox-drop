import { createRootRoute, createRoute, createRouter, Outlet } from '@tanstack/react-router';
import { useTranslation } from 'react-i18next';
import { StatusPage } from './status-page.js';

function NotFound() {
  const { t } = useTranslation();
  return <p>{t('notFound')}</p>;
}

const rootRoute = createRootRoute({ component: Outlet, notFoundComponent: NotFound });

const statusRoute = createRoute({
  getParentRoute: () => rootRoute,
  path: '/',
  component: StatusPage,
});

export const router = createRouter({ routeTree: rootRoute.addChildren([statusRoute]) });

declare module '@tanstack/react-router' {
  interface Register {
    router: typeof router;
  }
}
