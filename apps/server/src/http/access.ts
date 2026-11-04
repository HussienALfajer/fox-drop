import { SetMetadata } from '@nestjs/common';

// Architecture §15.2: every route says who may call it, and a route that says
// nothing is refused (the identity module's RouteAccessGuard). A route is
// public, needs a signed-in admin, or needs an admin permission.
export type RouteAccess =
  { kind: 'public' } | { kind: 'admin_session' } | { kind: 'admin_permission'; permission: string };

export const ROUTE_ACCESS = 'fox_drop:route_access';

// Open without sign-in, such as the status routes and the admin sign-in.
export const Public = () => SetMetadata(ROUTE_ACCESS, { kind: 'public' } satisfies RouteAccess);
