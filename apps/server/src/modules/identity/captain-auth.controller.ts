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
  UnauthorizedException,
} from '@nestjs/common';
import type { FastifyReply, FastifyRequest } from 'fastify';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { AppSignedIn, CurrentAppSession, Public } from '../../http/access.js';
import { requestContext } from '../../http/request-context.js';
import { CaptainController } from '../../http/route-groups.js';
import {
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
import { CaptainSignInRefusedError } from './captain-accounts.service.js';

class CaptainCodeRequestDto extends createZodDto(z.object({ phone, deviceId })) {}

class CaptainCodeSentDto extends createZodDto(codeSent) {}

class CaptainSignInDto extends createZodDto(z.object({ phone, deviceId, code: signInCode })) {}

const user = { accountId: z.uuid(), captainId: z.uuid() };

class CaptainSignedInDto extends createZodDto(z.object({ ...user, ...tokens })) {}

class CaptainRefreshDto extends createZodDto(z.object({ refreshToken })) {}

class CaptainTokensDto extends createZodDto(z.object(tokens)) {}

class CaptainSessionDto extends createZodDto(z.object({ ...user, sessionId: z.uuid() })) {}

class CaptainSignedOutDto extends createZodDto(z.object({ status: z.literal('signed_out') })) {}

// CA §4.9: the captain app's sign-in with a WhatsApp code, its tokens and
// sign-out, on the same engine as the other apps. There is no self-signup: a
// number of no captain is refused before any code is sent. A sign-in on a new
// device signs the old one out (K5): its next call answers 401, and the app
// shows «سُجّل دخولك من جهاز آخر».
@CaptainController('auth')
export class CaptainAuthController {
  constructor(
    private readonly signInService: AppSignInService,
    private readonly sessions: AppSessionsService,
  ) {}

  @Post('code')
  @Public()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: CaptainCodeSentDto })
  async requestCode(
    @Body() body: CaptainCodeRequestDto,
    @Req() request: FastifyRequest,
    @Res({ passthrough: true }) reply: FastifyReply,
  ) {
    try {
      const sent = await this.signInService.requestCode(
        { party: 'captain', phone: body.phone, deviceId: body.deviceId },
        requestContext(request),
      );
      return { ...sent, expiresAt: sent.expiresAt.toISOString() };
    } catch (error) {
      if (error instanceof CaptainSignInRefusedError) throw signInRefused(error);
      codeRequestAnswer(error, reply);
    }
  }

  // A contract ended since the code request answers 403 as it would.
  @Post('sign-in')
  @Public()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: CaptainSignedInDto })
  async signIn(@Body() body: CaptainSignInDto, @Req() request: FastifyRequest) {
    try {
      const result = await this.signInService.signIn(
        { party: 'captain', ...body },
        requestContext(request),
      );
      const captain = result.captain!;
      return { accountId: captain.id, captainId: captain.captainId, ...tokensBody(result) };
    } catch (error) {
      if (error instanceof SignInCodeRefusedError) {
        throw new BadRequestException({
          statusCode: HttpStatus.BAD_REQUEST,
          error: error.refusal,
          attemptsLeft: error.attemptsLeft,
        });
      }
      if (error instanceof CaptainSignInRefusedError) throw signInRefused(error);
      throw error;
    }
  }

  @Post('refresh')
  @Public()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: CaptainTokensDto })
  async refresh(@Body() body: CaptainRefreshDto) {
    try {
      return tokensBody(await this.sessions.refresh(body.refreshToken));
    } catch (error) {
      if (error instanceof RefreshRefusedError) throw new UnauthorizedException();
      throw error;
    }
  }

  @Get('session')
  @AppSignedIn()
  @ZodResponse({ status: 200, type: CaptainSessionDto })
  current(@CurrentAppSession() session: AppSession) {
    const captain = session.captain!;
    return { accountId: captain.id, captainId: captain.captainId, sessionId: session.id };
  }

  @Post('sign-out')
  @AppSignedIn()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: CaptainSignedOutDto })
  async signOut(@CurrentAppSession() session: AppSession) {
    await this.sessions.signOut(session);
    return { status: 'signed_out' as const };
  }
}

// CA §4.9: 403 with the reason the app shows: not_registered (the number
// belongs to no captain) or contract_ended «انتهى تعاقدك مع FOX DROP.».
function signInRefused(error: CaptainSignInRefusedError): ForbiddenException {
  return new ForbiddenException({ statusCode: HttpStatus.FORBIDDEN, error: error.refusal });
}
