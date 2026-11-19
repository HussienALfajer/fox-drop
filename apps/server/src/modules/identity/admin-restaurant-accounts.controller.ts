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
  Req,
} from '@nestjs/common';
import type { FastifyRequest } from 'fastify';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { CurrentAdminSession, RequireAnyPermission, RequirePermission } from '../../http/access.js';
import { requestContext } from '../../http/request-context.js';
import { AdminController } from '../../http/route-groups.js';
import { AuditService } from '../audit/index.js';
import { MerchantsService } from '../merchants/index.js';
import type { AdminSession } from './admin-sessions.service.js';
import { AppSessionsService } from './app-sessions.service.js';
import { APP_PHONE_PATTERN } from './app-phone.js';
import {
  MerchantAccountRefusedError,
  MerchantAccountsService,
} from './merchant-accounts.service.js';
import {
  RestaurantDevicesRefusedError,
  RestaurantDevicesService,
} from './restaurant-devices.service.js';

class AdminRestaurantAccountsParamsDto extends createZodDto(z.object({ restaurantId: z.uuid() })) {}

class AdminRestaurantAccountParamsDto extends createZodDto(
  z.object({ restaurantId: z.uuid(), accountId: z.uuid() }),
) {}

class AdminRestaurantAccountsDto extends createZodDto(
  z.object({
    accounts: z
      .array(
        z.object({
          id: z.uuid(),
          role: z.enum(['owner', 'cashier']),
          name: z.string(),
          phone: z
            .string()
            .describe(
              'The number the user signs in with (OTP): E.164 for restaurants.owner_accounts (each such read is audited), else masked as «+963 ••• 456».',
            ),
        }),
      )
      .describe('Owners first, then cashiers, oldest first.'),
  }),
) {}

class AdminNewRestaurantAccountDto extends createZodDto(
  z.object({
    role: z.enum(['owner', 'cashier']),
    name: z.string().trim().min(1).max(80),
    phone: z
      .string()
      .regex(APP_PHONE_PATTERN)
      .describe('A Syrian or Turkish mobile in E.164, as at sign-in.'),
  }),
) {}

// architecture §15.3: a number is masked in the panel unless its holder must
// act on it.
function masked(phone: string): string {
  const code = phone.startsWith('+90') ? '+90' : phone.startsWith('+963') ? '+963' : '+';
  return `${code} ••• ${phone.slice(-3)}`;
}

class AdminRestaurantDevicesDto extends createZodDto(
  z.object({
    devices: z
      .array(
        z.object({
          deviceId: z.string(),
          name: z.string(),
          platform: z.enum(['android', 'ios', 'windows']),
          appVersion: z.string(),
          user: z
            .object({ name: z.string(), role: z.enum(['owner', 'cashier']) })
            .nullable()
            .describe('Signed in on it now, else the latest who was; null before any sign-in.'),
          signedIn: z.boolean(),
          lastSeenAt: z.iso
            .datetime()
            .nullable()
            .describe('Its session’s last refresh (every 15 minutes while open), or its end.'),
          ringing: z.boolean().nullable().describe('Null until the devices report it (2.42).'),
          deviceCheck: z.string().nullable().describe('Null until the device check (2.42).'),
        }),
      )
      .describe('Every device named on the restaurant, the latest named first.'),
  }),
) {}

class AdminRestaurantDevicesSignOutDto extends createZodDto(
  z.object({
    deviceId: z.string().min(1).max(200).nullable().describe('One device; null for every one.'),
    reason: z.string().trim().min(1).max(500),
  }),
) {}

function refusalAsHttp(error: unknown): never {
  if (error instanceof RestaurantDevicesRefusedError) {
    const body = { error: error.refusal };
    if (error.refusal === 'unknown_restaurant') {
      throw new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, ...body });
    }
    throw new ConflictException({ statusCode: HttpStatus.CONFLICT, ...body });
  }
  if (error instanceof MerchantAccountRefusedError) {
    const body = { error: error.refusal };
    if (error.refusal === 'unknown_restaurant' || error.refusal === 'unknown_account') {
      throw new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, ...body });
    }
    if (error.refusal === 'restaurant_terminated') {
      throw new ForbiddenException({ statusCode: HttpStatus.FORBIDDEN, ...body });
    }
    if (error.refusal === 'invalid_account') {
      throw new BadRequestException({ statusCode: HttpStatus.BAD_REQUEST, ...body });
    }
    throw new ConflictException({ statusCode: HttpStatus.CONFLICT, ...body });
  }
  throw error;
}

// The wizard's step 6 (AP §9.6.3; slice 2.30a) and the profile's «الحسابات»
// (AP §9.6.4; slice 2.30d): a restaurant's owner and cashier accounts, which
// sign in to the restaurant app by OTP once the restaurant leaves its draft
// (RA §5.1–5.2), added and removed by OPS or OWN (restaurants.owner_accounts)
// while the restaurant is not terminated; a removed user's sessions end at
// once. The devices with their force sign-out. The add answers a repeat
// (the same number, role and name on the restaurant) with the account made,
// and the removal and the sign-out name their target, so none takes an
// Idempotency-Key. 404 unknown_restaurant, unknown_account; 403
// restaurant_terminated; 409 phone_taken, no_device.
@AdminController('restaurants')
export class AdminRestaurantAccountsController {
  constructor(
    private readonly accounts: MerchantAccountsService,
    private readonly merchants: MerchantsService,
    private readonly audit: AuditService,
    private readonly devices: RestaurantDevicesService,
    private readonly sessions: AppSessionsService,
  ) {}

  @Get(':restaurantId/accounts')
  @RequireAnyPermission('restaurants.read', 'restaurants.owner_accounts')
  @ZodResponse({ status: 200, type: AdminRestaurantAccountsDto })
  async list(
    @Param() params: AdminRestaurantAccountsParamsDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return this.answer(params.restaurantId, session, request);
  }

  // The accounts, their numbers in full only for restaurants.owner_accounts
  // (OWN, OPS), who add and remove them, with the view audited
  // (`merchant_accounts.view`, AP §14); masked for every other reader.
  private async answer(restaurantId: string, session: AdminSession, request: FastifyRequest) {
    const restaurant = await this.merchants.cityAndStatus(restaurantId);
    if (restaurant === null) {
      refusalAsHttp(new MerchantAccountRefusedError('unknown_restaurant', 'no such restaurant'));
    }
    const accounts = await this.accounts.accountsWithPhones(restaurantId);
    if (!session.permissions.includes('restaurants.owner_accounts')) {
      return {
        accounts: accounts.map((account) => ({ ...account, phone: masked(account.phone) })),
      };
    }
    if (accounts.length > 0) {
      await this.audit.recordView({
        actor: actorOf(session),
        context: requestContext(request),
        cityId: restaurant.cityId,
        action: 'merchant_accounts.view',
        target: { type: 'restaurant', id: restaurantId },
      });
    }
    return { accounts };
  }

  @Post(':restaurantId/accounts')
  @HttpCode(200)
  @RequirePermission('restaurants.owner_accounts')
  @ZodResponse({ status: 200, type: AdminRestaurantAccountsDto })
  async add(
    @Param() params: AdminRestaurantAccountsParamsDto,
    @Body() body: AdminNewRestaurantAccountDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    try {
      await this.accounts.addAccount(
        params.restaurantId,
        body,
        { actor: actorOf(session), context: requestContext(request) },
        { notTerminated: true },
      );
    } catch (error) {
      refusalAsHttp(error);
    }
    return this.answer(params.restaurantId, session, request);
  }

  @Post(':restaurantId/accounts/:accountId/remove')
  @HttpCode(200)
  @RequirePermission('restaurants.owner_accounts')
  @ZodResponse({ status: 200, type: AdminRestaurantAccountsDto })
  async remove(
    @Param() params: AdminRestaurantAccountParamsDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    try {
      const ended = await this.accounts.removeAccount(params.restaurantId, params.accountId, {
        actor: actorOf(session),
        context: requestContext(request),
      });
      this.sessions.notifyEnded(ended);
    } catch (error) {
      refusalAsHttp(error);
    }
    return this.answer(params.restaurantId, session, request);
  }

  @Get(':restaurantId/devices')
  @RequirePermission('restaurants.read')
  @ZodResponse({ status: 200, type: AdminRestaurantDevicesDto })
  async listDevices(@Param() params: AdminRestaurantAccountsParamsDto) {
    return this.devicesAnswer(params.restaurantId);
  }

  // RA §14.2: a device signed out goes back to sign-in; its user stays.
  @Post(':restaurantId/devices/sign-out')
  @HttpCode(200)
  @RequirePermission('restaurants.owner_accounts')
  @ZodResponse({ status: 200, type: AdminRestaurantDevicesDto })
  async signOutDevices(
    @Param() params: AdminRestaurantAccountsParamsDto,
    @Body() body: AdminRestaurantDevicesSignOutDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    try {
      const ended = await this.devices.signOut(params.restaurantId, body.deviceId, {
        actor: actorOf(session),
        context: requestContext(request),
        reason: body.reason,
      });
      this.sessions.notifyEnded(ended);
    } catch (error) {
      refusalAsHttp(error);
    }
    return this.devicesAnswer(params.restaurantId);
  }

  private async devicesAnswer(restaurantId: string) {
    if ((await this.merchants.cityAndStatus(restaurantId)) === null) {
      refusalAsHttp(new MerchantAccountRefusedError('unknown_restaurant', 'no such restaurant'));
    }
    const devices = await this.devices.devices(restaurantId);
    return {
      devices: devices.map((device) => ({
        ...device,
        lastSeenAt: device.lastSeenAt?.toISOString() ?? null,
        ringing: null,
        deviceCheck: null,
      })),
    };
  }
}

function actorOf(session: AdminSession) {
  return { type: 'admin' as const, id: session.accountId, role: session.roles.join(',') };
}
