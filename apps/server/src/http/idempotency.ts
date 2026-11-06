import {
  BadRequestException,
  createParamDecorator,
  type ExecutionContext,
  HttpStatus,
} from '@nestjs/common';
import { ApiHeader } from '@nestjs/swagger';
import type { FastifyRequest } from 'fastify';

// Architecture §5.3, RA §4.7: every command carries an Idempotency-Key the
// app makes once per command and sends again with each retry, such as a
// UUID. The module that runs the command keeps the key with its result in the
// command's transaction, so a repeat answers that result.
const KEY = /^[A-Za-z0-9_-]{16,128}$/;

// Documents the header, so the generated clients send it.
export const Idempotent = () =>
  ApiHeader({
    name: 'Idempotency-Key',
    required: true,
    description: 'One per command, sent again with each retry: 16 to 128 letters, digits, - or _.',
    schema: { type: 'string', pattern: KEY.source },
  });

// The command's key; a missing or malformed one is 400
// idempotency_key_required.
export const IdempotencyKey = createParamDecorator(
  (_data: unknown, context: ExecutionContext): string => {
    const value = context.switchToHttp().getRequest<FastifyRequest>().headers['idempotency-key'];
    if (typeof value !== 'string' || !KEY.test(value)) {
      throw new BadRequestException({
        statusCode: HttpStatus.BAD_REQUEST,
        error: 'idempotency_key_required',
      });
    }
    return value;
  },
);
