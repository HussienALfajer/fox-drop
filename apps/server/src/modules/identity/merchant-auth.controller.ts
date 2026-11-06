import {
  BadRequestException,
  Body,
  ForbiddenException,
  Get,
  HttpCode,
  HttpStatus,
  Post,
  Put,
  Req,
  Res,
  UnauthorizedException,
} from '@nestjs/common';
import type { FastifyReply, FastifyRequest } from 'fastify';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { AppSignedIn, CurrentAppSession, Public } from '../../http/access.js';
import { requestContext } from '../../http/request-context.js';
import { MerchantController } from '../../http/route-groups.js';
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
import {
  type MerchantAccount,
  MerchantAccountsService,
  MerchantSignInRefusedError,
} from './merchant-accounts.service.js';
import { devicePlatforms, MerchantsRefusedError, MerchantsService } from '../merchants/index.js';
import { merchantRoles } from './schema.js';

class MerchantCodeRequestDto extends createZodDto(
  z.object({
    phone,
    deviceId,
    platform: z
      .enum(devicePlatforms)
      .optional()
      .describe('Windows sends no App Check token (owner decision 2026-11-07).'),
  }),
) {}

class MerchantCodeSentDto extends createZodDto(codeSent) {}

class MerchantSignInDto extends createZodDto(z.object({ phone, deviceId, code: signInCode })) {}

const user = {
  accountId: z.uuid(),
  restaurantId: z.uuid(),
  role: z.enum(merchantRoles).describe('RA §5.4: what the app shows and the server allows.'),
  name: z.string(),
  deviceNamed: z
    .boolean()
    .describe('False on the first sign-in of this device: the app asks for its name (RA §5.2).'),
};

class MerchantSignedInDto extends createZodDto(z.object({ ...user, ...tokens })) {}

class MerchantRefreshDto extends createZodDto(z.object({ refreshToken })) {}

class MerchantTokensDto extends createZodDto(z.object(tokens)) {}

class MerchantSessionDto extends createZodDto(z.object({ ...user, sessionId: z.uuid() })) {}

class MerchantDeviceDto extends createZodDto(
  z.object({
    name: z.string().trim().min(1).max(60).describe('Such as «كاشير 1» or «تابلت المطبخ».'),
    platform: z.enum(devicePlatforms),
    appVersion: z.string().min(1).max(40),
  }),
) {}

class MerchantDeviceSavedDto extends createZodDto(z.object({ status: z.literal('saved') })) {}

class MerchantSignedOutDto extends createZodDto(z.object({ status: z.literal('signed_out') })) {}

// RA §5.2–5.3: the restaurant app's sign-in with a WhatsApp code, its tokens,
// the device's name and sign-out, on the same engine as the customer app.
// There is no self-signup: a number of no restaurant is refused once its code
// is right. Codes and tokens travel in bodies and the Authorization header.
@MerchantController('auth')
export class MerchantAuthController {
  constructor(
    private readonly signInService: AppSignInService,
    private readonly sessions: AppSessionsService,
    private readonly accounts: MerchantAccountsService,
    private readonly merchants: MerchantsService,
  ) {}

  @Post('code')
  @Public()
  @HttpCode(200)
  @AppCheckHeader()
  @ZodResponse({ status: 200, type: MerchantCodeSentDto })
  async requestCode(
    @Body() body: MerchantCodeRequestDto,
    @Req() request: FastifyRequest,
    @Res({ passthrough: true }) reply: FastifyReply,
    @AppCheckToken() appCheckToken: string | undefined,
  ) {
    try {
      const sent = await this.signInService.requestCode(
        {
          party: 'merchant',
          phone: body.phone,
          deviceId: body.deviceId,
          appCheckToken,
          platform: body.platform,
        },
        requestContext(request),
      );
      return { ...sent, expiresAt: sent.expiresAt.toISOString() };
    } catch (error) {
      if (error instanceof MerchantSignInRefusedError) throw signInRefused(error);
      codeRequestAnswer(error, reply);
    }
  }

  // A status changed since the code request answers 403 as it would.
  @Post('sign-in')
  @Public()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: MerchantSignedInDto })
  async signIn(@Body() body: MerchantSignInDto, @Req() request: FastifyRequest) {
    try {
      const result = await this.signInService.signIn(
        { party: 'merchant', ...body },
        requestContext(request),
      );
      const merchant = result.merchant!;
      return { ...(await this.user(merchant, body.deviceId)), ...tokensBody(result) };
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

  @Post('refresh')
  @Public()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: MerchantTokensDto })
  async refresh(@Body() body: MerchantRefreshDto) {
    try {
      return tokensBody(await this.sessions.refresh(body.refreshToken));
    } catch (error) {
      if (error instanceof RefreshRefusedError) throw new UnauthorizedException();
      throw error;
    }
  }

  @Get('session')
  @AppSignedIn()
  @ZodResponse({ status: 200, type: MerchantSessionDto })
  async current(@CurrentAppSession() session: AppSession) {
    return { ...(await this.user(session.merchant!, session.deviceId)), sessionId: session.id };
  }

  // RA §5.2 item 5: names this device in the restaurant. Renaming it is an
  // owner's (RA §5.4): a cashier's answers 403 device_rename_not_allowed.
  @Put('device')
  @AppSignedIn()
  @ZodResponse({ status: 200, type: MerchantDeviceSavedDto })
  async device(@CurrentAppSession() session: AppSession, @Body() body: MerchantDeviceDto) {
    const merchant = session.merchant!;
    try {
      await this.merchants.nameDevice(merchant.restaurantId, session.deviceId, body, {
        accountId: merchant.id,
        role: merchant.role,
      });
    } catch (error) {
      if (error instanceof MerchantsRefusedError && error.refusal === 'device_rename_not_allowed') {
        throw new ForbiddenException({ statusCode: HttpStatus.FORBIDDEN, error: error.refusal });
      }
      throw error;
    }
    return { status: 'saved' as const };
  }

  @Post('sign-out')
  @AppSignedIn()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: MerchantSignedOutDto })
  async signOut(@CurrentAppSession() session: AppSession) {
    await this.sessions.signOut(session);
    return { status: 'signed_out' as const };
  }

  private async user(account: MerchantAccount, device: string) {
    return {
      accountId: account.id,
      restaurantId: account.restaurantId,
      role: account.role,
      name: account.name,
      deviceNamed: await this.merchants.deviceNamed(account.restaurantId, device),
    };
  }
}

// RA §5.2 items 3–4, §5.5: 403 with the reason the app shows: not_registered
// «هذا الرقم غير مسجّل لدى أي مطعم في FOX DROP», restaurant_draft «حساب مطعمك
// قيد الإعداد. سنتواصل معك عند جاهزيته.», restaurant_terminated.
function signInRefused(error: MerchantSignInRefusedError): ForbiddenException {
  return new ForbiddenException({ statusCode: HttpStatus.FORBIDDEN, error: error.refusal });
}
