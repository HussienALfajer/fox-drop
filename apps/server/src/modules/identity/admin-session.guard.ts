import '@fastify/cookie';
import {
  type CanActivate,
  createParamDecorator,
  type ExecutionContext,
  Injectable,
  UnauthorizedException,
} from '@nestjs/common';
import type { FastifyRequest } from 'fastify';
import { type AdminSession, AdminSessionsService } from './admin-sessions.service.js';

// Architecture §10.3: an HTTP-only, secure, same-site cookie. The __Host-
// prefix makes the browser refuse it unless it is secure, has no domain and
// covers the whole site.
export const ADMIN_SESSION_COOKIE = '__Host-fox_drop_admin';

declare module 'fastify' {
  interface FastifyRequest {
    adminSession?: AdminSession;
  }
}

// Lets a route through only with an open admin session, which it finds with
// @CurrentAdminSession(). Slice 0.8 turns this into the default for every
// admin route, with the role checks.
@Injectable()
export class AdminSessionGuard implements CanActivate {
  constructor(private readonly sessions: AdminSessionsService) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const request = context.switchToHttp().getRequest<FastifyRequest>();
    const token = request.cookies[ADMIN_SESSION_COOKIE];
    const session = token ? await this.sessions.authenticate(token) : null;
    if (!session) throw new UnauthorizedException();
    request.adminSession = session;
    return true;
  }
}

export const CurrentAdminSession = createParamDecorator(
  (_data: unknown, context: ExecutionContext): AdminSession => {
    const session = context.switchToHttp().getRequest<FastifyRequest>().adminSession;
    if (!session) throw new Error('the route has no AdminSessionGuard');
    return session;
  },
);
