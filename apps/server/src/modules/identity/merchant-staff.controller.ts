import {
  BadRequestException,
  Body,
  ConflictException,
  ForbiddenException,
  Get,
  HttpCode,
  HttpStatus,
  NotFoundException,
  Param,
  Post,
  Put,
  Req,
} from '@nestjs/common';
import type { FastifyRequest } from 'fastify';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { AppSignedIn, CurrentAppSession } from '../../http/access.js';
import { MerchantController } from '../../http/route-groups.js';
import { devicePlatforms, MerchantsRefusedError, MerchantsService } from '../merchants/index.js';
import { deviceId } from './app-auth.js';
import { APP_PHONE_PATTERN } from './app-phone.js';
import { type AppSession, AppSessionsService } from './app-sessions.service.js';
import {
  type MerchantAccount,
  MerchantAccountRefusedError,
  MerchantAccountsService,
} from './merchant-accounts.service.js';
import {
  RestaurantDevicesRefusedError,
  RestaurantDevicesService,
} from './restaurant-devices.service.js';
import { merchantRoles } from './schema.js';

class MerchantStaffDto extends createZodDto(
  z.object({
    staff: z
      .array(
        z.object({
          accountId: z.uuid(),
          role: z.enum(merchantRoles),
          name: z.string(),
          phone: z.string().describe('The number the user signs in with, in E.164.'),
          devices: z.int().min(0).describe('The devices the user is signed in on now.'),
          lastActiveAt: z.iso
            .datetime()
            .nullable()
            .describe('The latest session’s last refresh or end; null before any sign-in.'),
        }),
      )
      .describe('Owners first (read-only in the app, RA §5.1), then cashiers, oldest first.'),
  }),
) {}

class MerchantNewCashierDto extends createZodDto(
  z.object({
    name: z.string().trim().min(1).max(80),
    phone: z
      .string()
      .regex(APP_PHONE_PATTERN)
      .describe('A Syrian or Turkish mobile in E.164, as at sign-in.'),
  }),
) {}

class MerchantStaffParamsDto extends createZodDto(z.object({ accountId: z.uuid() })) {}

class MerchantDeviceParamsDto extends createZodDto(z.object({ deviceId })) {}

class MerchantDeviceNameDto extends createZodDto(
  z.object({ name: z.string().trim().min(1).max(60) }),
) {}

class MerchantDevicesDto extends createZodDto(
  z.object({
    devices: z
      .array(
        z.object({
          deviceId: z.string(),
          name: z.string(),
          platform: z.enum(devicePlatforms),
          appVersion: z.string(),
          user: z
            .object({ name: z.string(), role: z.enum(merchantRoles) })
            .nullable()
            .describe('Signed in on it now, else the latest who was; null before any sign-in.'),
          signedIn: z.boolean(),
          lastSeenAt: z.iso
            .datetime()
            .nullable()
            .describe('Its session’s last refresh (every 15 minutes while open), or its end.'),
          ringing: z.boolean().nullable().describe('Null until the devices report it (2.42).'),
          deviceCheck: z.string().nullable().describe('Null until the device check (2.42).'),
          thisDevice: z.boolean().describe('The device making the request.'),
        }),
      )
      .describe('Every device named on the restaurant, the latest named first.'),
  }),
) {}

// RA §14.1–14.2, §18 (slice 2.33): the owners' «الموظفون» and «الأجهزة» in
// the restaurant app. Owners add and remove cashiers (S5: owners themselves
// only through FOX DROP, so removing one is 409 not_a_cashier); a removed
// cashier's sessions end at once. Owners rename a device and sign it out
// (`signed_out_by_owner`); the cashier stays. The add answers a repeat (the
// same number and name) with the account made, the others name their target
// or set a value, so none takes an Idempotency-Key. A cashier gets 403
// owner_only, a terminated restaurant 403 restaurant_terminated (RA §5.5);
// 404 unknown_account, unknown_device; 409 phone_taken, no_device.
@MerchantController()
export class MerchantStaffController {
  constructor(
    private readonly accounts: MerchantAccountsService,
    private readonly devices: RestaurantDevicesService,
    private readonly merchants: MerchantsService,
    private readonly sessions: AppSessionsService,
  ) {}

  @Get('staff')
  @AppSignedIn()
  @ZodResponse({ status: 200, type: MerchantStaffDto })
  async staff(@CurrentAppSession() session: AppSession) {
    const { restaurantId } = await this.ownerOf(session);
    return this.staffAnswer(restaurantId);
  }

  @Post('staff')
  @AppSignedIn()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: MerchantStaffDto })
  async addCashier(
    @CurrentAppSession() session: AppSession,
    @Body() body: MerchantNewCashierDto,
    @Req() request: FastifyRequest,
  ) {
    const owner = await this.ownerOf(session);
    try {
      await this.accounts.addAccount(
        owner.restaurantId,
        { role: 'cashier', ...body },
        changeOf(owner, session, request),
        { notTerminated: true },
      );
    } catch (error) {
      refusalAsHttp(error);
    }
    return this.staffAnswer(owner.restaurantId);
  }

  @Post('staff/:accountId/remove')
  @AppSignedIn()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: MerchantStaffDto })
  async removeCashier(
    @CurrentAppSession() session: AppSession,
    @Param() params: MerchantStaffParamsDto,
    @Req() request: FastifyRequest,
  ) {
    const owner = await this.ownerOf(session);
    try {
      const ended = await this.accounts.removeAccount(
        owner.restaurantId,
        params.accountId,
        changeOf(owner, session, request),
        { cashierOnly: true },
      );
      this.sessions.notifyEnded(ended);
    } catch (error) {
      refusalAsHttp(error);
    }
    return this.staffAnswer(owner.restaurantId);
  }

  @Get('devices')
  @AppSignedIn()
  @ZodResponse({ status: 200, type: MerchantDevicesDto })
  async listDevices(@CurrentAppSession() session: AppSession) {
    const { restaurantId } = await this.ownerOf(session);
    return this.devicesAnswer(restaurantId, session);
  }

  @Put('devices/:deviceId/name')
  @AppSignedIn()
  @ZodResponse({ status: 200, type: MerchantDevicesDto })
  async renameDevice(
    @CurrentAppSession() session: AppSession,
    @Param() params: MerchantDeviceParamsDto,
    @Body() body: MerchantDeviceNameDto,
    @Req() request: FastifyRequest,
  ) {
    const owner = await this.ownerOf(session);
    try {
      await this.merchants.renameDevice(
        owner.restaurantId,
        params.deviceId,
        body.name,
        changeOf(owner, session, request),
      );
    } catch (error) {
      refusalAsHttp(error);
    }
    return this.devicesAnswer(owner.restaurantId, session);
  }

  // RA §14.2: the device goes back to sign-in; its user stays.
  @Post('devices/:deviceId/sign-out')
  @AppSignedIn()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: MerchantDevicesDto })
  async signOutDevice(
    @CurrentAppSession() session: AppSession,
    @Param() params: MerchantDeviceParamsDto,
    @Req() request: FastifyRequest,
  ) {
    const owner = await this.ownerOf(session);
    try {
      const ended = await this.devices.signOut(owner.restaurantId, params.deviceId, {
        ...changeOf(owner, session, request),
        reason: null,
      });
      this.sessions.notifyEnded(ended);
    } catch (error) {
      refusalAsHttp(error);
    }
    return this.devicesAnswer(owner.restaurantId, session);
  }

  // RA §5.4: staff and devices are the owners'; RA §5.5: a terminated
  // restaurant's owners keep only the money section.
  private async ownerOf(session: AppSession): Promise<MerchantAccount> {
    const account = session.merchant;
    if (!account) throw new Error('a merchant route without a restaurant user');
    if (account.role !== 'owner') {
      throw new ForbiddenException({ statusCode: HttpStatus.FORBIDDEN, error: 'owner_only' });
    }
    if ((await this.merchants.accountStatus(account.restaurantId)) === 'terminated') {
      throw new ForbiddenException({
        statusCode: HttpStatus.FORBIDDEN,
        error: 'restaurant_terminated',
      });
    }
    return account;
  }

  private async staffAnswer(restaurantId: string) {
    const staff = await this.accounts.staff(restaurantId);
    return {
      staff: staff.map((account) => ({
        accountId: account.id,
        role: account.role,
        name: account.name,
        phone: account.phone,
        devices: account.devices,
        lastActiveAt: account.lastActiveAt?.toISOString() ?? null,
      })),
    };
  }

  private async devicesAnswer(restaurantId: string, session: AppSession) {
    const devices = await this.devices.devices(restaurantId);
    return {
      devices: devices.map((device) => ({
        ...device,
        lastSeenAt: device.lastSeenAt?.toISOString() ?? null,
        ringing: null,
        deviceCheck: null,
        thisDevice: device.deviceId === session.deviceId,
      })),
    };
  }
}

// RA §7.1 «Logging»: the restaurant user, their role and the device.
function changeOf(owner: MerchantAccount, session: AppSession, request: FastifyRequest) {
  return {
    actor: { type: 'merchant' as const, id: owner.id, role: owner.role },
    context: { ipAddress: request.ip, device: session.deviceId },
  };
}

function refusalAsHttp(error: unknown): never {
  if (
    error instanceof MerchantAccountRefusedError ||
    error instanceof RestaurantDevicesRefusedError
  ) {
    const body = { error: error.refusal };
    switch (error.refusal) {
      case 'unknown_restaurant':
      case 'unknown_account':
        throw new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, ...body });
      case 'restaurant_terminated':
        throw new ForbiddenException({ statusCode: HttpStatus.FORBIDDEN, ...body });
      case 'invalid_account':
        throw new BadRequestException({ statusCode: HttpStatus.BAD_REQUEST, ...body });
      default:
        throw new ConflictException({ statusCode: HttpStatus.CONFLICT, ...body });
    }
  }
  if (error instanceof MerchantsRefusedError) {
    const body = { error: error.refusal };
    switch (error.refusal) {
      case 'unknown_restaurant':
      case 'unknown_device':
        throw new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, ...body });
      case 'restaurant_terminated':
        throw new ForbiddenException({ statusCode: HttpStatus.FORBIDDEN, ...body });
      case 'invalid_device':
        throw new BadRequestException({ statusCode: HttpStatus.BAD_REQUEST, ...body });
      default:
        throw new ConflictException({ statusCode: HttpStatus.CONFLICT, ...body });
    }
  }
  throw error;
}
