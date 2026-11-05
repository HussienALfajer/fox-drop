import {
  BadRequestException,
  Body,
  Get,
  HttpCode,
  HttpException,
  HttpStatus,
  Post,
  Req,
  Res,
  ServiceUnavailableException,
  UnauthorizedException,
} from '@nestjs/common';
import type { FastifyReply, FastifyRequest } from 'fastify';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { AppSignedIn, CurrentAppSession, Public } from '../../http/access.js';
import { requestContext } from '../../http/request-context.js';
import { CustomerController } from '../../http/route-groups.js';
import {
  type AppSession,
  AppSessionsService,
  type AppTokens,
  RefreshRefusedError,
} from './app-sessions.service.js';
import {
  AppSignInService,
  CodeRequestRefusedError,
  SignInCodeRefusedError,
} from './app-sign-in.service.js';

// CU §5.2 item 1: a Syrian (+963 9…, 9 digits) or Turkish (+90 5…, 10 digits)
// mobile, which the app sends in E.164.
const phone = z
  .string()
  .regex(/^(\+9639\d{8}|\+905\d{9})$/)
  .describe('The mobile number in E.164: +9639xxxxxxxx or +905xxxxxxxxx.');
const deviceId = z
  .uuid()
  .describe('The app installation, generated once by the app and kept until it is removed.');

class CustomerCodeRequestDto extends createZodDto(z.object({ phone, deviceId })) {}

class CustomerCodeSentDto extends createZodDto(
  z.object({
    channel: z.literal('whatsapp').describe('Where the code went (architecture §8.3.4).'),
    resendAfterSec: z.int().describe('When the app may offer «إعادة الإرسال».'),
    expiresAt: z.iso.datetime(),
  }),
) {}

class CustomerSignInDto extends createZodDto(
  z.object({
    phone,
    deviceId,
    code: z.string().regex(/^\d{6}$/),
  }),
) {}

const tokens = {
  accessToken: z.string().describe('A JWT for the Authorization header, valid 15 minutes.'),
  accessTokenExpiresAt: z.iso.datetime(),
  refreshToken: z
    .string()
    .describe('Used once at /refresh for a new pair; using it twice signs the device out.'),
};

class CustomerSignedInDto extends createZodDto(
  z.object({
    accountId: z.uuid(),
    newAccount: z.boolean().describe('The app shows «أكمل بياناتك» (CU §5.3).'),
    ...tokens,
  }),
) {}

class CustomerRefreshDto extends createZodDto(z.object({ refreshToken: z.string().min(1).max(200) })) {}

class CustomerTokensDto extends createZodDto(z.object(tokens)) {}

class CustomerSessionDto extends createZodDto(
  z.object({ accountId: z.uuid(), sessionId: z.uuid() }),
) {}

class CustomerSignedOutDto extends createZodDto(z.object({ status: z.literal('signed_out') })) {}

function tokensBody(result: AppTokens) {
  return {
    accessToken: result.accessToken,
    accessTokenExpiresAt: result.accessTokenExpiresAt.toISOString(),
    refreshToken: result.refreshToken,
  };
}

// CU §5.2, §5.4: the customer app's sign-in with a WhatsApp code, its tokens,
// sign-out and «تسجيل الخروج من كل الأجهزة». Codes and tokens travel in bodies
// and the Authorization header, never in a path.
@CustomerController('auth')
export class CustomerAuthController {
  constructor(
    private readonly signInService: AppSignInService,
    private readonly sessions: AppSessionsService,
  ) {}

  @Post('code')
  @Public()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: CustomerCodeSentDto })
  async requestCode(
    @Body() body: CustomerCodeRequestDto,
    @Req() request: FastifyRequest,
    @Res({ passthrough: true }) reply: FastifyReply,
  ) {
    try {
      const sent = await this.signInService.requestCode(
        { party: 'customer', phone: body.phone, deviceId: body.deviceId },
        requestContext(request),
      );
      return { ...sent, expiresAt: sent.expiresAt.toISOString() };
    } catch (error) {
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
  }

  @Post('sign-in')
  @Public()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: CustomerSignedInDto })
  async signIn(@Body() body: CustomerSignInDto, @Req() request: FastifyRequest) {
    try {
      const result = await this.signInService.signIn(
        { party: 'customer', ...body },
        requestContext(request),
      );
      return { accountId: result.accountId, newAccount: result.newAccount, ...tokensBody(result) };
    } catch (error) {
      if (!(error instanceof SignInCodeRefusedError)) throw error;
      throw new BadRequestException({
        statusCode: HttpStatus.BAD_REQUEST,
        error: error.refusal,
        attemptsLeft: error.attemptsLeft,
      });
    }
  }

  @Post('refresh')
  @Public()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: CustomerTokensDto })
  async refresh(@Body() body: CustomerRefreshDto) {
    try {
      return tokensBody(await this.sessions.refresh(body.refreshToken));
    } catch (error) {
      if (error instanceof RefreshRefusedError) throw new UnauthorizedException();
      throw error;
    }
  }

  @Get('session')
  @AppSignedIn()
  @ZodResponse({ status: 200, type: CustomerSessionDto })
  current(@CurrentAppSession() session: AppSession) {
    return { accountId: session.accountId, sessionId: session.id };
  }

  @Post('sign-out')
  @AppSignedIn()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: CustomerSignedOutDto })
  async signOut(@CurrentAppSession() session: AppSession) {
    await this.sessions.signOut(session);
    return { status: 'signed_out' as const };
  }

  @Post('sign-out-everywhere')
  @AppSignedIn()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: CustomerSignedOutDto })
  async signOutEverywhere(@CurrentAppSession() session: AppSession) {
    await this.sessions.signOutEverywhere(session);
    return { status: 'signed_out' as const };
  }
}
