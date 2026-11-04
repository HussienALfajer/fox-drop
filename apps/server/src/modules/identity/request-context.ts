import type { FastifyRequest } from 'fastify';
import type { AuditRequestContext } from '../audit/index.js';

// Where a request came from, for the audit and the sessions.
export function requestContext(request: FastifyRequest): AuditRequestContext {
  return {
    ipAddress: request.ip,
    device: request.headers['user-agent']?.slice(0, 500) ?? null,
  };
}
