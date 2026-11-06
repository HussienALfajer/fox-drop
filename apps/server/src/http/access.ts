import { createParamDecorator, type ExecutionContext, SetMetadata } from '@nestjs/common';
import type { FastifyRequest } from 'fastify';
import type { AdminPermission, AdminSession, AppSession } from '../modules/identity/index.js';

// Architecture §15.2: every route says who may call it, and a route that says
// nothing is refused (the identity module's RouteAccessGuard). The decorators
// live here, outside the identity module, so any module's routes can use them,
// the settings module's included, which the identity module imports. A route is
// public, needs a signed-in admin, needs an admin permission, or needs a
// signed-in user of the route group's app.
export type RouteAccess =
  | { kind: 'public' }
  | { kind: 'admin_session' }
  | { kind: 'admin_permission'; permission: string }
  | { kind: 'app_session' }
  | { kind: 'optional_app_session' }
  | { kind: 'realtime_proxy' };

export const ROUTE_ACCESS = 'fox_drop:route_access';

// Open without sign-in, such as the status routes and the admin sign-in.
export const Public = () => SetMetadata(ROUTE_ACCESS, { kind: 'public' } satisfies RouteAccess);

declare module 'fastify' {
  interface FastifyRequest {
    adminSession?: AdminSession;
    appSession?: AppSession;
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

// An app route (customer so far) that needs the bearer access token of a
// signed-in user of that app (architecture §15.1).
export const AppSignedIn = () =>
  SetMetadata(ROUTE_ACCESS, { kind: 'app_session' } satisfies RouteAccess);

// An app route open to guests that answers more to a signed-in user, such as
// the customer's quote (CU §5.1, §10.6): without a token it runs as a guest;
// with one, the token must be valid.
export const AppSignedInOrGuest = () =>
  SetMetadata(ROUTE_ACCESS, { kind: 'optional_app_session' } satisfies RouteAccess);

// The app session of an @AppSignedInOrGuest() route; null for a guest.
export const OptionalAppSession = createParamDecorator(
  (_data: unknown, context: ExecutionContext): AppSession | null =>
    context.switchToHttp().getRequest<FastifyRequest>().appSession ?? null,
);

// A route Centrifugo calls, such as the subscription proxy (architecture
// §6.1): it must carry X-Centrifugo-Proxy-Secret, the CENTRIFUGO_PROXY_SECRET
// Centrifugo is configured with. Such a route stays out of the OpenAPI
// document, so no client is generated for it.
export const RealtimeProxy = () =>
  SetMetadata(ROUTE_ACCESS, { kind: 'realtime_proxy' } satisfies RouteAccess);

export const REALTIME_PROXY_SECRET_HEADER = 'x-centrifugo-proxy-secret';

// The app session RouteAccessGuard checked for this request.
export const CurrentAppSession = createParamDecorator(
  (_data: unknown, context: ExecutionContext): AppSession => {
    const session = context.switchToHttp().getRequest<FastifyRequest>().appSession;
    if (!session) throw new Error('the route is not @AppSignedIn()');
    return session;
  },
);
