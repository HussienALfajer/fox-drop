import {
  BadRequestException,
  HttpException,
  HttpStatus,
  ServiceUnavailableException,
} from '@nestjs/common';
import type { FastifyReply } from 'fastify';
import { z } from 'zod';
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

// A refused code request as its HTTP answer: 503, 400 or 429 with Retry-After.
export function codeRequestAnswer(error: unknown, reply: FastifyReply): never {
  if (!(error instanceof CodeRequestRefusedError)) throw error;
  const body = { error: error.refusal };
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
