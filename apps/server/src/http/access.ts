import { createParamDecorator, type ExecutionContext, SetMetadata } from '@nestjs/common';
import type { FastifyRequest } from 'fastify';
import type { AdminPermission, AdminSession } from '../modules/identity/index.js';

// Architecture §15.2: every route says who may call it, and a route that says
// nothing is refused (the identity module's RouteAccessGuard). The decorators
// live here, outside the identity module, so any module's routes can use them,
// the settings module's included, which the identity module imports. A route is
// public, needs a signed-in admin, or needs an admin permission.
export type RouteAccess =
  { kind: 'public' } | { kind: 'admin_session' } | { kind: 'admin_permission'; permission: string };

export const ROUTE_ACCESS = 'fox_drop:route_access';

// Open without sign-in, such as the status routes and the admin sign-in.
export const Public = () => SetMetadata(ROUTE_ACCESS, { kind: 'public' } satisfies RouteAccess);

declare module 'fastify' {
  interface FastifyRequest {
    adminSession?: AdminSession;
  }
}

// An admin route that needs a signed-in admin and no permission: the admin's
// own session, or a route whose service checks the roles itself.
export const SignedIn = () =>
  SetMetadata(ROUTE_ACCESS, { kind: 'admin_session' } satisfies RouteAccess);

// An admin route that needs this permission (AP §6.2–6.3).
export const RequirePermission = (permission: AdminPermission) =>
  SetMetadata(ROUTE_ACCESS, { kind: 'admin_permission', permission } satisfies RouteAccess);

// The session RouteAccessGuard checked for this request.
export const CurrentAdminSession = createParamDecorator(
  (_data: unknown, context: ExecutionContext): AdminSession => {
    const session = context.switchToHttp().getRequest<FastifyRequest>().adminSession;
    if (!session) throw new Error('the route is not @SignedIn() or @RequirePermission()');
    return session;
  },
);
