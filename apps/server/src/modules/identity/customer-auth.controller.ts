import {
  BadRequestException,
  Body,
  Get,
  HttpCode,
  HttpStatus,
  Post,
  Req,
  Res,
  UnauthorizedException,
} from '@nestjs/common';
import type { FastifyReply, FastifyRequest } from 'fastify';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { AppSignedIn, CurrentAppSession, Public } from '../../http/access.js';
import { requestContext } from '../../http/request-context.js';
import { CustomerController } from '../../http/route-groups.js';
import {
  AppCheckHeader,
  AppCheckToken,
  codeRequestAnswer,
  codeSent,
  deviceId,
  phone,
  refreshToken,
  signInCode,
  tokens,
  tokensBody,
} from './app-auth.js';
import {
  type AppSession,
  AppSessionsService,
  RefreshRefusedError,
} from './app-sessions.service.js';
import { AppSignInService, SignInCodeRefusedError } from './app-sign-in.service.js';

class CustomerCodeRequestDto extends createZodDto(z.object({ phone, deviceId })) {}

class CustomerCodeSentDto extends createZodDto(codeSent) {}

class CustomerSignInDto extends createZodDto(
  z.object({
    phone,
    deviceId,
    code: signInCode,
  }),
) {}

class CustomerSignedInDto extends createZodDto(
  z.object({
    accountId: z.uuid(),
    newAccount: z.boolean().describe('The app shows «أكمل بياناتك» (CU §5.3).'),
    ...tokens,
  }),
) {}

class CustomerRefreshDto extends createZodDto(z.object({ refreshToken })) {}

class CustomerTokensDto extends createZodDto(z.object(tokens)) {}

class CustomerSessionDto extends createZodDto(
  z.object({ accountId: z.uuid(), sessionId: z.uuid() }),
) {}

class CustomerSignedOutDto extends createZodDto(z.object({ status: z.literal('signed_out') })) {}

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
  @AppCheckHeader()
  @ZodResponse({ status: 200, type: CustomerCodeSentDto })
  async requestCode(
    @Body() body: CustomerCodeRequestDto,
    @Req() request: FastifyRequest,
    @Res({ passthrough: true }) reply: FastifyReply,
    @AppCheckToken() appCheckToken: string | undefined,
  ) {
    try {
      const sent = await this.signInService.requestCode(
        { party: 'customer', phone: body.phone, deviceId: body.deviceId, appCheckToken },
        requestContext(request),
      );
      return { ...sent, expiresAt: sent.expiresAt.toISOString() };
    } catch (error) {
      codeRequestAnswer(error, reply);
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
