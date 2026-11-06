import {
  BadRequestException,
  createParamDecorator,
  type ExecutionContext,
  ForbiddenException,
  HttpException,
  HttpStatus,
  ServiceUnavailableException,
} from '@nestjs/common';
import { ApiHeader } from '@nestjs/swagger';
import type { FastifyReply, FastifyRequest } from 'fastify';
import { z } from 'zod';
import { APP_CHECK_HEADER } from './app-check.js';
import { APP_PHONE_PATTERN } from './app-phone.js';
import type { AppTokens } from './app-sessions.service.js';
import { CodeRequestRefusedError } from './app-sign-in.service.js';

// The request and answer parts every app's sign-in routes share.

export const phone = z
  .string()
  .regex(APP_PHONE_PATTERN)
  .describe('The mobile number in E.164: +9639xxxxxxxx or +905xxxxxxxxx.');

export const deviceId = z
  .uuid()
  .describe('The app installation, generated once by the app and kept until it is removed.');

export const signInCode = z.string().regex(/^\d{6}$/);

export const codeSent = z.object({
  channel: z.literal('whatsapp').describe('Where the code went (architecture §8.3.4).'),
  resendAfterSec: z.int().describe('When the app may offer «إعادة الإرسال».'),
  expiresAt: z.iso.datetime(),
});

export const tokens = {
  accessToken: z.string().describe('A JWT for the Authorization header, valid 15 minutes.'),
  accessTokenExpiresAt: z.iso.datetime(),
  refreshToken: z
    .string()
    .describe('Used once at /refresh for a new pair; using it twice signs the device out.'),
};

export const refreshToken = z.string().min(1).max(200);

export function tokensBody(result: AppTokens) {
  return {
    accessToken: result.accessToken,
    accessTokenExpiresAt: result.accessTokenExpiresAt.toISOString(),
    refreshToken: result.refreshToken,
  };
}

// Architecture §8.3.3 item 1: documents the App Check header of a code
// request, so the generated clients can send it.
export const AppCheckHeader = () =>
  ApiHeader({
    name: APP_CHECK_HEADER,
    required: false,
    description:
      'The Firebase App Check token. Refused with 403 app_check_failed when missing or invalid ' +
      'while the server requires it (otp.app_check_required).',
    schema: { type: 'string' },
  });

// The header's value, if any; the service decides whether it is needed.
export const AppCheckToken = createParamDecorator(
  (_data: unknown, context: ExecutionContext): string | undefined => {
    const value = context.switchToHttp().getRequest<FastifyRequest>().headers[
      APP_CHECK_HEADER.toLowerCase()
    ];
    return typeof value === 'string' ? value : undefined;
  },
);

// A refused code request as its HTTP answer: 403, 503, 400 or 429 with
// Retry-After.
export function codeRequestAnswer(error: unknown, reply: FastifyReply): never {
  if (!(error instanceof CodeRequestRefusedError)) throw error;
  const body = { error: error.refusal };
  if (error.refusal === 'app_check_failed') {
    throw new ForbiddenException({ statusCode: HttpStatus.FORBIDDEN, ...body });
  }
  if (error.refusal === 'unavailable') throw new ServiceUnavailableException(body);
  if (error.refusal === 'not_on_whatsapp') {
    throw new BadRequestException({ statusCode: HttpStatus.BAD_REQUEST, ...body });
  }
  reply.header('retry-after', String(error.retryAfterSec));
  throw new HttpException(
    { statusCode: HttpStatus.TOO_MANY_REQUESTS, ...body, retryAfterSec: error.retryAfterSec },
    HttpStatus.TOO_MANY_REQUESTS,
  );
}
