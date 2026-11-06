import {
  BadRequestException,
  Body,
  Get,
  Header,
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
import { CurrentAdminSession, Public, SignedIn } from '../../http/access.js';
import { AdminController } from '../../http/route-groups.js';
import { type AdminSession, AdminSessionsService } from './admin-sessions.service.js';
import { AdminSetupService, SetupRefusedError } from './admin-setup.service.js';
import { AdminSignInService, SignInRefusedError } from './admin-sign-in.service.js';
import { requestContext } from '../../http/request-context.js';
import { ADMIN_SESSION_COOKIE } from './route-access.guard.js';

// Bounds that keep a request cheap; the password rule itself is a setting.
const token = z.string().min(1).max(200);
const password = z.string().min(1).max(256);

class SetupTokenDto extends createZodDto(z.object({ token })) {}

class TotpEnrolmentDto extends createZodDto(
  z.object({
    secret: z.string().describe('The TOTP secret in base32, for typing it in by hand.'),
    otpauthUri: z.string().describe('The otpauth:// URI the panel shows as a QR code.'),
  }),
) {}

class CompleteSetupDto extends createZodDto(
  z.object({
    token,
    password,
    code: z
      .string()
      .regex(/^\d{6}$/)
      .describe('A TOTP code from the secret just enrolled.'),
  }),
) {}

class BackupCodesDto extends createZodDto(
  z.object({
    backupCodes: z
      .array(z.string())
      .length(10)
      .describe('The 10 single-use backup codes, shown this once only (AP §5.1).'),
  }),
) {}

class SignInDto extends createZodDto(
  z.object({
    login: z.string().min(1).max(254).describe('The email, or the phone in international form.'),
    password,
    code: z.string().min(1).max(20).describe('A 6-digit TOTP code or a backup code.'),
  }),
) {}

class AdminSessionDto extends createZodDto(
  z.object({
    accountId: z.uuid(),
    roles: z.array(z.string()),
    permissions: z
      .array(z.string())
      .describe(
        "The union of the roles' permissions (AP §6.1), so the panel hides what is not allowed.",
      ),
    signedInAt: z.iso.datetime(),
    expiresAt: z.iso
      .datetime()
      .describe('When the session ends unless used again before (AP §5.2).'),
  }),
) {}

class SignedOutDto extends createZodDto(z.object({ status: z.literal('signed_out') })) {}

function sessionBody(session: AdminSession): AdminSessionDto {
  return {
    accountId: session.accountId,
    roles: session.roles,
    permissions: session.permissions,
    signedInAt: session.signedInAt.toISOString(),
    expiresAt: session.expiresAt.toISOString(),
  };
}

function setupError(error: unknown): unknown {
  if (!(error instanceof SetupRefusedError)) return error;
  return new BadRequestException({
    statusCode: HttpStatus.BAD_REQUEST,
    error: error.refusal,
    ...(error.passwordMinLength === undefined
      ? {}
      : { passwordMinLength: error.passwordMinLength }),
  });
}

// AP §5.1–5.2: the panel's first sign-in, sign-in and sign-out. Tokens and
// codes travel in bodies and the cookie, never in a path.
@AdminController('auth')
export class AdminAuthController {
  constructor(
    private readonly setup: AdminSetupService,
    private readonly signInService: AdminSignInService,
    private readonly sessions: AdminSessionsService,
  ) {}

  @Post('setup/totp')
  // The TOTP secret and the backup codes are shown once: never cached.
  @Header('Cache-Control', 'no-store')
  @Public()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: TotpEnrolmentDto })
  async startTotpEnrolment(@Body() body: SetupTokenDto) {
    try {
      return await this.setup.startTotpEnrolment(body.token);
    } catch (error) {
      throw setupError(error);
    }
  }

  @Post('setup/complete')
  // The TOTP secret and the backup codes are shown once: never cached.
  @Header('Cache-Control', 'no-store')
  @Public()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: BackupCodesDto })
  async completeSetup(@Body() body: CompleteSetupDto, @Req() request: FastifyRequest) {
    try {
      return { backupCodes: await this.setup.completeSetup(body, requestContext(request)) };
    } catch (error) {
      throw setupError(error);
    }
  }

  @Post('sign-in')
  @Public()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: AdminSessionDto })
  async signIn(
    @Body() body: SignInDto,
    @Req() request: FastifyRequest,
    @Res({ passthrough: true }) reply: FastifyReply,
  ) {
    try {
      const { token: sessionToken, session } = await this.signInService.signIn(
        body,
        requestContext(request),
      );
      reply.setCookie(ADMIN_SESSION_COOKIE, sessionToken, {
        httpOnly: true,
        secure: true,
        sameSite: 'strict',
        path: '/',
        maxAge: await this.sessions.maxLifetimeSeconds(),
      });
      return sessionBody(session);
    } catch (error) {
      if (!(error instanceof SignInRefusedError)) throw error;
      // Every refusal, a locked account included, gets one answer, so a wrong
      // password, code or sign-in name and a lock cannot be told apart (owner
      // decision 2026-11-05).
      throw new UnauthorizedException();
    }
  }

  @Get('session')
  @SignedIn()
  @ZodResponse({ status: 200, type: AdminSessionDto })
  current(@CurrentAdminSession() session: AdminSession) {
    return sessionBody(session);
  }

  @Post('sign-out')
  @HttpCode(200)
  @SignedIn()
  @ZodResponse({ status: 200, type: SignedOutDto })
  async signOut(
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
    @Res({ passthrough: true }) reply: FastifyReply,
  ) {
    await this.sessions.signOut(session, requestContext(request));
    reply.clearCookie(ADMIN_SESSION_COOKIE, {
      httpOnly: true,
      secure: true,
      sameSite: 'strict',
      path: '/',
    });
    return { status: 'signed_out' as const };
  }
}
