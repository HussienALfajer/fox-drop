import {
  BadRequestException,
  Body,
  ConflictException,
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
import { APP_PHONE_PATTERN } from './app-phone.js';
import {
  MerchantAccountRefusedError,
  MerchantAccountsService,
} from './merchant-accounts.service.js';

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

function refusalAsHttp(error: unknown): never {
  if (error instanceof MerchantAccountRefusedError) {
    const body = { error: error.refusal };
    if (error.refusal === 'unknown_restaurant' || error.refusal === 'unknown_account') {
      throw new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, ...body });
    }
    if (error.refusal === 'invalid_account') {
      throw new BadRequestException({ statusCode: HttpStatus.BAD_REQUEST, ...body });
    }
    throw new ConflictException({ statusCode: HttpStatus.CONFLICT, ...body });
  }
  throw error;
}

// The wizard's step 6 (AP §9.6.3; slice 2.30a): a draft restaurant's owner
// and cashier accounts, which sign in to the restaurant app by OTP once the
// restaurant leaves its draft (RA §5.1–5.2). Owners are added here only, by
// OPS or OWN (restaurants.owner_accounts); the profile's accounts tab and
// staff and devices (2.30c, 2.33) take the other restaurants' accounts. The
// add answers a repeat (the same number, role and name on the restaurant)
// with the account made, and the removal names its target, so neither takes
// an Idempotency-Key. 404 unknown_restaurant, unknown_account; 409
// not_a_draft, phone_taken.
@AdminController('restaurants')
export class AdminRestaurantAccountsController {
  constructor(
    private readonly accounts: MerchantAccountsService,
    private readonly merchants: MerchantsService,
    private readonly audit: AuditService,
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
        { draftOnly: true },
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
      await this.accounts.removeDraftAccount(params.restaurantId, params.accountId, {
        actor: actorOf(session),
        context: requestContext(request),
      });
    } catch (error) {
      refusalAsHttp(error);
    }
    return this.answer(params.restaurantId, session, request);
  }
}

function actorOf(session: AdminSession) {
  return { type: 'admin' as const, id: session.accountId, role: session.roles.join(',') };
}
