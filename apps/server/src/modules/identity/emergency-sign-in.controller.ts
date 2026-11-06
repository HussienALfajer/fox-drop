import { Body, ConflictException, Header, HttpCode, HttpStatus, Post, Req } from '@nestjs/common';
import type { FastifyRequest } from 'fastify';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { CurrentAdminSession, RequirePermission } from '../../http/access.js';
import { requestContext } from '../../http/request-context.js';
import { AdminController } from '../../http/route-groups.js';
import type { AdminSession } from './admin-sessions.service.js';
import { phone } from './app-auth.js';
import { EmergencyCodeRefusedError, EmergencySignInService } from './emergency-sign-in.service.js';

class EmergencySignInCodeRequestDto extends createZodDto(
  z.object({
    party: z
      .enum(['captain', 'merchant'])
      .describe('The captain app or the restaurant app; customers are not covered.'),
    phone,
    reason: z
      .string()
      .trim()
      .min(1)
      .max(500)
      .describe('Why, kept in the audit log (owner decision 2026-11-07).'),
  }),
) {}

class EmergencySignInCodeDto extends createZodDto(
  z.object({
    code: z
      .string()
      .regex(/^\d{6}$/)
      .describe('Shown once; read out to the person, who types it in the app.'),
    expiresAt: z.iso.datetime(),
    accountId: z.uuid().describe('The captain or restaurant user account it signs in to.'),
  }),
) {}

// The emergency sign-in (W4, architecture §22 item 1): OWN and OPS issue a
// one-time code after verifying the person by phone. No Idempotency-Key: a
// repeat issues a new code that replaces the first, and the code is never
// stored in clear to answer a repeat with.
@AdminController('emergency-sign-in-codes')
export class EmergencySignInController {
  constructor(private readonly emergency: EmergencySignInService) {}

  // 409 not_registered, contract_ended, restaurant_draft or
  // restaurant_terminated for a number that cannot sign in.
  @Post()
  @HttpCode(200)
  // The answer carries a code that signs in: never cached.
  @Header('Cache-Control', 'no-store')
  @RequirePermission('sign_in.emergency_code')
  @ZodResponse({ status: 200, type: EmergencySignInCodeDto })
  async issue(
    @Body() body: EmergencySignInCodeRequestDto,
    @CurrentAdminSession() actor: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    try {
      const issued = await this.emergency.issue(body, actor, requestContext(request));
      return { ...issued, expiresAt: issued.expiresAt.toISOString() };
    } catch (error) {
      if (!(error instanceof EmergencyCodeRefusedError)) throw error;
      throw new ConflictException({ statusCode: HttpStatus.CONFLICT, error: error.refusal });
    }
  }
}
