import {
  BadRequestException,
  ConflictException,
  ForbiddenException,
  HttpStatus,
  NotFoundException,
  UnprocessableEntityException,
} from '@nestjs/common';
import type { FastifyRequest } from 'fastify';
import { requestContext } from '../../http/request-context.js';
import type { AdminSession } from '../identity/index.js';
import { CashDeskRefusedError, type DeskUser } from './cashdesk.service.js';

// The desk's controllers share these: who records, and the refusals as HTTP.

export function deskUser(session: AdminSession, request: FastifyRequest): DeskUser {
  return {
    accountId: session.accountId,
    roles: session.roles,
    actor: { type: 'admin', id: session.accountId, role: session.roles.join(',') },
    context: requestContext(request),
  };
}

// The refusals as HTTP answers.
export async function refusalsAsHttp<T>(run: () => Promise<T>): Promise<T> {
  try {
    return await run();
  } catch (error) {
    if (!(error instanceof CashDeskRefusedError)) throw error;
    const { refusal, message } = error;
    const body = (statusCode: number) => ({ statusCode, error: refusal, message });
    switch (refusal) {
      case 'unknown_session':
      case 'unknown_captain':
      case 'unknown_restaurant':
      case 'unknown_city':
        throw new NotFoundException(body(HttpStatus.NOT_FOUND));
      case 'not_your_session':
      case 'not_payout_day':
        throw new ForbiddenException(body(HttpStatus.FORBIDDEN));
      case 'invalid_amounts':
      case 'note_required':
      case 'reason_required':
        throw new BadRequestException(body(HttpStatus.BAD_REQUEST));
      case 'idempotency_key_reused':
        throw new UnprocessableEntityException(body(HttpStatus.UNPROCESSABLE_ENTITY));
      default:
        throw new ConflictException(body(HttpStatus.CONFLICT));
    }
  }
}
