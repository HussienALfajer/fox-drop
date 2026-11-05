import '@fastify/cookie';
import {
  type CanActivate,
  type ExecutionContext,
  ForbiddenException,
  Injectable,
  UnauthorizedException,
} from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import type { FastifyRequest } from 'fastify';
import { ROUTE_ACCESS, type RouteAccess } from '../../http/access.js';
import { ROUTE_GROUP, type RouteGroup } from '../../http/route-groups.js';
import { AdminSessionsService } from './admin-sessions.service.js';

// Architecture §10.3: an HTTP-only, secure, same-site cookie. The __Host-
// prefix makes the browser refuse it unless it is secure, has no domain and
// covers the whole site.
export const ADMIN_SESSION_COOKIE = '__Host-fox_drop_admin';

// Architecture §15.2, deny by default: every route of every group passes here.
// A route that declares nothing is refused; an admin route checks the session
// and the permission it names against the union of the admin's roles, read at
// every request so a role change applies at once.
@Injectable()
export class RouteAccessGuard implements CanActivate {
  constructor(
    private readonly reflector: Reflector,
    private readonly sessions: AdminSessionsService,
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const targets = [context.getHandler(), context.getClass()];
    const access = this.reflector.getAllAndOverride<RouteAccess | undefined>(ROUTE_ACCESS, targets);
    if (!access) throw new ForbiddenException();
    if (access.kind === 'public') return true;
    // Only the admin group has sessions so far; the apps' guards come with
    // their sign-in.
    const group = this.reflector.get<RouteGroup | undefined>(ROUTE_GROUP, context.getClass());
    if (group !== 'admin') throw new ForbiddenException();

    const request = context.switchToHttp().getRequest<FastifyRequest>();
    const token = request.cookies[ADMIN_SESSION_COOKIE];
    const session = token ? await this.sessions.authenticate(token) : null;
    if (!session) throw new UnauthorizedException();
    request.adminSession = session;
    if (
      access.kind === 'admin_permission' &&
      !(session.permissions as string[]).includes(access.permission)
    ) {
      throw new ForbiddenException();
    }
    return true;
  }
}
