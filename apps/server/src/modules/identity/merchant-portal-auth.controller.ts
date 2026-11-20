import {
  BadRequestException,
  Body,
  ForbiddenException,
  Get,
  HttpCode,
  HttpStatus,
  Post,
  Req,
  Res,
} from '@nestjs/common';
import type { FastifyReply, FastifyRequest } from 'fastify';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { AppSignedIn, CurrentAppSession, Public } from '../../http/access.js';
import { requestContext } from '../../http/request-context.js';
import { MerchantController } from '../../http/route-groups.js';
import { codeRequestAnswer, codeSent, phone, signInCode } from './app-auth.js';
import { type AppSession, AppSessionsService } from './app-sessions.service.js';
import { AppSignInService, SignInCodeRefusedError } from './app-sign-in.service.js';
import { MerchantSignInRefusedError } from './merchant-accounts.service.js';
import { PortalSessionsService } from './portal-sessions.service.js';
import { PORTAL_SESSION_COOKIE } from './route-access.guard.js';

const browserId = z
  .uuid()
  .describe('The browser: a random id the portal keeps, which the code is bound to.');

class MerchantPortalCodeRequestDto extends createZodDto(z.object({ phone, browserId })) {}

class MerchantPortalCodeSentDto extends createZodDto(codeSent) {}

class MerchantPortalSignInDto extends createZodDto(
  z.object({ phone, browserId, code: signInCode }),
) {}

const owner = {
  accountId: z.uuid(),
  restaurantId: z.uuid(),
  name: z.string(),
};

class MerchantPortalSignedInDto extends createZodDto(
  z.object({ ...owner, expiresAt: z.iso.datetime() }),
) {}

class MerchantPortalSessionDto extends createZodDto(z.object({ ...owner, sessionId: z.uuid() })) {}

class MerchantPortalSignedOutDto extends createZodDto(
  z.object({ status: z.literal('signed_out') }),
) {}

const cookieOptions = {
  httpOnly: true,
  secure: true,
  sameSite: 'strict',
  path: '/',
} as const;

// RA §17, §5.2–5.3, S14 (slice 2.45a): the owner web portal's sign-in by
// phone and WhatsApp code, owners only, with no App Check (owner decision
// 2026-11-20: a browser has none; the request limits hold). The session is
// an HTTP-only cookie on the portal's own origin, as the panel's (architecture
// §10.3–10.4), valid `merchant.web_session_days` from the sign-in.
@MerchantController('auth/portal')
export class MerchantPortalAuthController {
  constructor(
    private readonly signInService: AppSignInService,
    private readonly sessions: AppSessionsService,
    private readonly portalSessions: PortalSessionsService,
  ) {}

  // 403 not_registered, restaurant_draft, owner_only (a cashier's number)
  // before anything is sent; the code request's 429, 400 and 503 otherwise.
  @Post('code')
  @Public()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: MerchantPortalCodeSentDto })
  async requestCode(
    @Body() body: MerchantPortalCodeRequestDto,
    @Req() request: FastifyRequest,
    @Res({ passthrough: true }) reply: FastifyReply,
  ) {
    try {
      const sent = await this.signInService.requestCode(
        { party: 'merchant', phone: body.phone, deviceId: body.browserId, portal: true },
        requestContext(request),
      );
      return { ...sent, expiresAt: sent.expiresAt.toISOString() };
    } catch (error) {
      if (error instanceof MerchantSignInRefusedError) throw signInRefused(error);
      codeRequestAnswer(error, reply);
    }
  }

  // 400 wrong_code with attemptsLeft or code_expired; 403 as the code request.
  @Post('sign-in')
  @Public()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: MerchantPortalSignedInDto })
  async signIn(
    @Body() body: MerchantPortalSignInDto,
    @Req() request: FastifyRequest,
    @Res({ passthrough: true }) reply: FastifyReply,
  ) {
    try {
      const now = new Date();
      const result = await this.signInService.signInToPortal(body, requestContext(request), now);
      reply.setCookie(PORTAL_SESSION_COOKIE, result.token, {
        ...cookieOptions,
        maxAge: Math.floor((result.expiresAt.getTime() - now.getTime()) / 1000),
      });
      return {
        accountId: result.merchant.id,
        restaurantId: result.merchant.restaurantId,
        name: result.merchant.name,
        expiresAt: result.expiresAt.toISOString(),
      };
    } catch (error) {
      if (error instanceof SignInCodeRefusedError) {
        throw new BadRequestException({
          statusCode: HttpStatus.BAD_REQUEST,
          error: error.refusal,
          attemptsLeft: error.attemptsLeft,
        });
      }
      if (error instanceof MerchantSignInRefusedError) throw signInRefused(error);
      throw error;
    }
  }

  // The portal knows its session only from here: the cookie is HTTP-only.
  @Get('session')
  @AppSignedIn({ portal: true })
  @ZodResponse({ status: 200, type: MerchantPortalSessionDto })
  current(@CurrentAppSession() session: AppSession) {
    return portalOnly(session, {
      accountId: session.accountId,
      restaurantId: session.merchant!.restaurantId,
      name: session.merchant!.name,
      sessionId: session.id,
    });
  }

  @Post('sign-out')
  @AppSignedIn({ portal: true })
  @HttpCode(200)
  @ZodResponse({ status: 200, type: MerchantPortalSignedOutDto })
  async signOut(
    @CurrentAppSession() session: AppSession,
    @Res({ passthrough: true }) reply: FastifyReply,
  ) {
    portalOnly(session, null);
    // Its real-time connections end once the end committed.
    if (await this.portalSessions.signOut(session.id)) this.sessions.notifyEnded([session.id]);
    reply.clearCookie(PORTAL_SESSION_COOKIE, cookieOptions);
    return { status: 'signed_out' as const };
  }
}

// The portal's own routes answer an app's token 403 not_in_portal.
function portalOnly<T>(session: AppSession, answer: T): T {
  if (!session.portal) {
    throw new ForbiddenException({ statusCode: HttpStatus.FORBIDDEN, error: 'not_in_portal' });
  }
  return answer;
}

function signInRefused(error: MerchantSignInRefusedError): ForbiddenException {
  return new ForbiddenException({ statusCode: HttpStatus.FORBIDDEN, error: error.refusal });
}
