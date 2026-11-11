import {
  BadRequestException,
  Body,
  ConflictException,
  Delete,
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
import { CurrentAdminSession, RequirePermission } from '../../http/access.js';
import { requestContext } from '../../http/request-context.js';
import { AdminController } from '../../http/route-groups.js';
import type { AdminSession } from '../identity/index.js';
import { merchantStatusSchema, statusBody } from './merchant-status.controller.js';
import { pauseSources } from './operating-state.js';
import {
  type MerchantChange,
  MerchantsRefusedError,
  MerchantsService,
} from './merchants.service.js';
import {
  type PickupCurrencies,
  type RestaurantStatus,
  RestaurantStatusService,
} from './restaurant-status.service.js';

const instant = z.iso.datetime();
const reason = z.string().trim().min(1).max(500).describe('Why, for the change log (AP §9.6.4).');
// Counted in characters, as the service and the database do (an emoji is one).
const message = z
  .string()
  .refine((text) => [...text].length <= 100)
  .nullable()
  .describe('To customers, up to 100 characters.');

const currencyName = z.object({
  currency: z.string().length(3),
  name: z.string().describe('Its Arabic name.'),
});

const adminRestaurantStatusSchema = merchantStatusSchema
  .omit({ pauseChoicesMin: true, busyExtraOptionsMin: true, busyReminderMin: true })
  .extend({
    nameAr: z.string(),
    accountStatus: z.enum(['draft', 'test', 'active', 'suspended', 'terminated']),
    // Flat, since the Dart generator misnames an enum inside a nested object.
    heldPauseSource: z
      .enum(pauseSources)
      .nullable()
      .describe(
        'The pause in force, whatever the state: an operations or auto pause holds while closed too (AP §9.6.5); null without one.',
      ),
    heldPauseUntil: instant.nullable().describe('Its end; null until resumed, or without one.'),
    pauseMessage: z.string().nullable().describe('An operations pause’s, to customers (CU §9.2).'),
    pauseReason: z.string().nullable().describe('An operations pause’s reason.'),
    pauseChoicesMin: z.array(z.int()).describe('«15 د», «30 د», «60 د» (AP §9.6.5).'),
    pickupBaseCurrency: currencyName
      .nullable()
      .describe(
        '«العملات التي تقبلها من الكابتن» (RA §12.7): the base, always accepted; null while the city has none.',
      ),
    pickupCurrencies: z
      .array(z.string().length(3))
      .describe('The other currencies switched on, in the city’s display order.'),
    pickupCurrencyChoices: z
      .array(currencyName)
      .describe('Every other currency the city has enabled, in its display order.'),
  });

class AdminRestaurantStatusDto extends createZodDto(adminRestaurantStatusSchema) {}

class AdminRestaurantStatusParamsDto extends createZodDto(z.object({ restaurantId: z.uuid() })) {}

class AdminRestaurantPauseDto extends createZodDto(
  z.object({
    minutes: z.int().nullable().describe('15, 30 or 60; null with until, or for «حتى الاستئناف».'),
    until: instant.nullable().describe('A later time; null with minutes, or for «حتى الاستئناف».'),
    message,
    reason,
  }),
) {}

class AdminRestaurantHolidayCloseDto extends createZodDto(
  z.object({
    startsAt: instant.nullable().describe('null: from now.'),
    endsAt: instant,
    message,
    reason,
  }),
) {}

class AdminRestaurantMaxActiveOrdersDto extends createZodDto(
  z.object({ maxActiveOrders: z.int().nullable().describe('Off (null) or 1 to 50 (RA §7.4).') }),
) {}

function adminChange(session: AdminSession, request: FastifyRequest): MerchantChange {
  return {
    actor: { type: 'admin', id: session.accountId, role: session.roles.join(',') },
    context: requestContext(request),
  };
}

async function answer(run: () => Promise<void>): Promise<void> {
  try {
    await run();
  } catch (error) {
    if (!(error instanceof MerchantsRefusedError)) throw error;
    const body = (status: number) => ({ statusCode: status, error: error.refusal });
    switch (error.refusal) {
      case 'unknown_restaurant':
        throw new NotFoundException(body(HttpStatus.NOT_FOUND));
      case 'restaurant_suspended':
        throw new ConflictException(body(HttpStatus.CONFLICT));
      case 'restaurant_terminated':
        throw new ForbiddenException(body(HttpStatus.FORBIDDEN));
      case 'reason_required':
      case 'invalid_pause':
      case 'invalid_holiday_close':
      case 'invalid_max_active_orders':
      case 'invalid_pickup_currencies':
        throw new BadRequestException({ ...body(HttpStatus.BAD_REQUEST), message: error.message });
      default:
        throw error;
    }
  }
}

class AdminRestaurantPickupCurrenciesDto extends createZodDto(
  z.object({
    currencies: z
      .array(z.string().length(3))
      .max(10)
      .describe('The other currencies to accept at pickup; the base is always accepted.'),
  }),
) {}

// AP §9.6.5, the panel's restaurant actions on its state (OWN, OPS:
// restaurants.manage): «إيقاف مؤقت» with a reason and a message to
// customers, «استئناف» of any pause (the auto-pause's too, AP §9.1.3),
// «إنهاء وضع الضغط», the holiday close with a reason, and the maximum active
// orders and the pickup currencies (AP §9.6.4, RA §12.7) on the
// restaurant's request. None takes an Idempotency-Key: each
// sets a state to a value, and the same pause again is a repeat that changes
// nothing (operationsPause); each answers the status after it.
@AdminController('restaurants')
export class AdminRestaurantStatusController {
  constructor(
    private readonly status: RestaurantStatusService,
    private readonly merchants: MerchantsService,
  ) {}

  @Get(':restaurantId/status')
  @RequirePermission('restaurants.read')
  @ZodResponse({ status: 200, type: AdminRestaurantStatusDto })
  async read(@Param() params: AdminRestaurantStatusParamsDto) {
    return this.body(params.restaurantId);
  }

  @Post(':restaurantId/status/pause')
  @RequirePermission('restaurants.manage')
  @HttpCode(200)
  @ZodResponse({ status: 200, type: AdminRestaurantStatusDto })
  async pause(
    @Param() params: AdminRestaurantStatusParamsDto,
    @Body() body: AdminRestaurantPauseDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    await answer(() =>
      this.status.operationsPause(
        params.restaurantId,
        {
          minutes: body.minutes,
          until: body.until === null ? null : new Date(body.until),
          message: body.message,
          reason: body.reason,
        },
        adminChange(session, request),
      ),
    );
    return this.body(params.restaurantId);
  }

  @Post(':restaurantId/status/resume')
  @RequirePermission('restaurants.manage')
  @HttpCode(200)
  @ZodResponse({ status: 200, type: AdminRestaurantStatusDto })
  async resume(
    @Param() params: AdminRestaurantStatusParamsDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    await answer(() =>
      this.status.operationsResume(params.restaurantId, adminChange(session, request)),
    );
    return this.body(params.restaurantId);
  }

  @Delete(':restaurantId/status/busy-mode')
  @RequirePermission('restaurants.manage')
  @ZodResponse({ status: 200, type: AdminRestaurantStatusDto })
  async endBusyMode(
    @Param() params: AdminRestaurantStatusParamsDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    await answer(() =>
      this.status.operationsEndBusyMode(params.restaurantId, adminChange(session, request)),
    );
    return this.body(params.restaurantId);
  }

  @Put(':restaurantId/holiday-close')
  @RequirePermission('restaurants.manage')
  @ZodResponse({ status: 200, type: AdminRestaurantStatusDto })
  async setHolidayClose(
    @Param() params: AdminRestaurantStatusParamsDto,
    @Body() body: AdminRestaurantHolidayCloseDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    await answer(() =>
      this.status.setHolidayClose(
        params.restaurantId,
        {
          startsAt: body.startsAt === null ? null : new Date(body.startsAt),
          endsAt: new Date(body.endsAt),
          message: body.message,
        },
        { ...adminChange(session, request), reason: body.reason },
      ),
    );
    return this.body(params.restaurantId);
  }

  @Delete(':restaurantId/holiday-close')
  @RequirePermission('restaurants.manage')
  @ZodResponse({ status: 200, type: AdminRestaurantStatusDto })
  async endHolidayClose(
    @Param() params: AdminRestaurantStatusParamsDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    await answer(() =>
      this.status.endHolidayClose(params.restaurantId, adminChange(session, request)),
    );
    return this.body(params.restaurantId);
  }

  @Put(':restaurantId/max-active-orders')
  @RequirePermission('restaurants.manage')
  @ZodResponse({ status: 200, type: AdminRestaurantStatusDto })
  async setMaxActiveOrders(
    @Param() params: AdminRestaurantStatusParamsDto,
    @Body() body: AdminRestaurantMaxActiveOrdersDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    await answer(() =>
      this.status.setOrderSettings(
        params.restaurantId,
        { maxActiveOrders: body.maxActiveOrders },
        adminChange(session, request),
      ),
    );
    return this.body(params.restaurantId);
  }

  @Put(':restaurantId/pickup-currencies')
  @RequirePermission('restaurants.manage')
  @ZodResponse({ status: 200, type: AdminRestaurantStatusDto })
  async setPickupCurrencies(
    @Param() params: AdminRestaurantStatusParamsDto,
    @Body() body: AdminRestaurantPickupCurrenciesDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    await answer(() =>
      this.status.setPickupCurrencies(
        params.restaurantId,
        body.currencies,
        adminChange(session, request),
      ),
    );
    return this.body(params.restaurantId);
  }

  private async body(restaurantId: string): Promise<z.infer<typeof adminRestaurantStatusSchema>> {
    const restaurant = await this.merchants.restaurant(restaurantId);
    if (restaurant === null) {
      throw new NotFoundException({
        statusCode: HttpStatus.NOT_FOUND,
        error: 'unknown_restaurant',
      });
    }
    const [status, pickup]: [RestaurantStatus, PickupCurrencies] = await Promise.all([
      this.status.status(restaurantId),
      this.status.pickupCurrencies(restaurantId),
    ]);
    const { pause } = status;
    const ops = pause !== null && pause.source === 'ops' ? pause : null;
    // The restaurant's busy-mode choices are left out by the schema.
    return {
      ...statusBody(status),
      nameAr: restaurant.nameAr,
      accountStatus: restaurant.accountStatus,
      heldPauseSource: pause?.source ?? null,
      heldPauseUntil: pause?.endsAt?.toISOString() ?? null,
      pauseMessage: ops?.message ?? null,
      pauseReason: ops?.reason ?? null,
      pickupBaseCurrency: pickup.base,
      pickupCurrencies: pickup.accepted,
      pickupCurrencyChoices: pickup.choices,
    };
  }
}
