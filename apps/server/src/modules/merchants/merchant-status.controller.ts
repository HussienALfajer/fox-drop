import {
  BadRequestException,
  Body,
  ConflictException,
  Delete,
  ForbiddenException,
  Get,
  HttpCode,
  HttpStatus,
  Post,
  Put,
  Req,
} from '@nestjs/common';
import type { FastifyRequest } from 'fastify';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { AppSignedIn, CurrentAppSession } from '../../http/access.js';
import { MerchantController } from '../../http/route-groups.js';
import type { AppSession, MerchantAccount } from '../identity/index.js';
import {
  type MerchantChange,
  MerchantsRefusedError,
  MerchantsService,
} from './merchants.service.js';
import { pauseSources } from './operating-state.js';
import {
  type RestaurantHours,
  type RestaurantStatus,
  RestaurantStatusService,
} from './restaurant-status.service.js';

const instant = z.iso.datetime();

export const merchantStatusSchema = z.object({
  state: z
    .enum(['draft', 'suspended', 'terminated', 'holiday', 'closed', 'paused', 'busy', 'open'])
    .describe('The operating state now (RA §7.1).'),
  pauseSource: z
    .enum(pauseSources)
    .nullable()
    .describe(
      'Who paused it while paused: the restaurant’s own buttons work only for «restaurant» (RA §7.2).',
    ),
  stateUntil: instant.nullable().describe('When a holiday close or a pause ends.'),
  closesAt: instant
    .nullable()
    .describe('Inside an opening period, when it ends: «يغلق اليوم 11:30 م» (RA §7.2).'),
  opensAt: instant.nullable().describe('Closed by the schedule, when it next opens.'),
  busyMode: z
    .object({ extraMin: z.int(), until: instant })
    .nullable()
    .describe('Busy mode while on (RA §7.3), until the end of the opening period.'),
  activeOrders: z
    .int()
    .nullable()
    .describe('Orders in placed, accepted or ready, counted only against a maximum (RA §7.4).'),
  maxActiveOrders: z.int().nullable(),
  holiday: z
    .object({ startsAt: instant, endsAt: instant, message: z.string().nullable() })
    .nullable()
    .describe('The holiday close in force, or the next one set (RA §10).'),
  pauseChoicesMin: z.array(z.int()).describe('«إيقاف 15 د», «30 د», «60 د» (RA §7.2).'),
  busyExtraOptionsMin: z.array(z.int()).describe('merchant.busy_extra_options_min.'),
  busyReminderMin: z.int().describe('merchant.busy_mode_reminder_min (RA §7.3).'),
});

class MerchantStatusDto extends createZodDto(merchantStatusSchema) {}

class MerchantPauseDto extends createZodDto(
  z.object({
    minutes: z
      .int()
      .nullable()
      .describe('15, 30 or 60; null for «حتى أعيد الفتح», until the opening period ends.'),
  }),
) {}

class MerchantBusyModeDto extends createZodDto(
  z.object({
    extraMin: z
      .int()
      .nullable()
      .describe('One of busyExtraOptionsMin to turn it on; null for «إلغاء وضع الضغط».'),
  }),
) {}

const period = z.object({
  weekday: z.int().min(0).max(6).describe('0 Sunday to 6 Saturday.'),
  opensAt: z.int().describe('Minutes after midnight on the city clock.'),
  closesAt: z
    .int()
    .describe('Minutes after midnight; not after opensAt crosses midnight (18:00–02:00).'),
});

const merchantHoursSchema = z.object({
  periods: z
    .array(period)
    .describe('The weekly schedule; a weekday without a period is «مغلق طوال اليوم» (RA §10).'),
  holiday: merchantStatusSchema.shape.holiday,
  defaultPrepMin: z.int(),
  prepFloorMin: z.int().describe('merchant.prep_time_floor_min.'),
  prepCeilingMin: z.int().describe('merchant.prep_time_ceiling_min.'),
  maxActiveOrders: z.int().nullable().describe('Off (null) or 1 to 50 (RA §7.4).'),
  minimumOrder: z.object({
    amount: z.string().regex(/^\d+$/).describe('Integer minor units (AP §8.6).'),
    currency: z.string().length(3),
  }),
  coverage: z.object({
    kind: z.enum(['radius', 'zones']),
    radiusMetres: z.int().nullable(),
    zoneCount: z.int().nullable(),
  }),
  commissionBp: z.int().nullable().describe('Basis points of the items value: 1500 is 15%.'),
  settlementWeekday: z.string().describe('merchant.settlement_weekday, such as saturday.'),
});

class MerchantHoursDto extends createZodDto(merchantHoursSchema) {}

class MerchantScheduleDto extends createZodDto(z.object({ periods: z.array(period).max(50) })) {}

class MerchantOrderSettingsDto extends createZodDto(
  z.object({
    defaultPrepMin: z.int().describe('Within prepFloorMin and prepCeilingMin.'),
    maxActiveOrders: z.int().nullable().describe('Off (null) or 1 to 50.'),
  }),
) {}

class MerchantHolidayCloseDto extends createZodDto(
  z.object({
    startsAt: instant.nullable().describe('null: from now.'),
    endsAt: instant,
    message: z.string().max(100).nullable().describe('To customers, up to 100 characters.'),
  }),
) {}

function hoursBody(hours: RestaurantHours): z.infer<typeof merchantHoursSchema> {
  const { coverage } = hours;
  return {
    periods: hours.periods,
    holiday:
      hours.holiday === null
        ? null
        : {
            startsAt: hours.holiday.startsAt.toISOString(),
            endsAt: hours.holiday.endsAt.toISOString(),
            message: hours.holiday.message,
          },
    defaultPrepMin: hours.defaultPrepMin,
    prepFloorMin: hours.prepFloorMin,
    prepCeilingMin: hours.prepCeilingMin,
    maxActiveOrders: hours.maxActiveOrders,
    minimumOrder: {
      amount: hours.minimumOrder.amount.toString(),
      currency: hours.minimumOrder.currency,
    },
    coverage: {
      kind: coverage.kind,
      radiusMetres: coverage.kind === 'radius' ? coverage.radiusMetres : null,
      zoneCount: coverage.kind === 'zones' ? coverage.zoneIds.length : null,
    },
    commissionBp: hours.commissionBp,
    settlementWeekday: hours.settlementWeekday,
  };
}

export function statusBody(status: RestaurantStatus): z.infer<typeof merchantStatusSchema> {
  const { state } = status;
  return {
    state: state.state,
    pauseSource: state.state === 'paused' ? state.source : null,
    stateUntil: 'until' in state ? (state.until?.toISOString() ?? null) : null,
    closesAt: status.closesAt?.toISOString() ?? null,
    opensAt: status.opensAt?.toISOString() ?? null,
    busyMode:
      status.busyMode === null
        ? null
        : { extraMin: status.busyMode.extraMin, until: status.busyMode.until.toISOString() },
    activeOrders: status.activeOrders,
    maxActiveOrders: status.maxActiveOrders,
    holiday:
      status.holiday === null
        ? null
        : {
            startsAt: status.holiday.startsAt.toISOString(),
            endsAt: status.holiday.endsAt.toISOString(),
            message: status.holiday.message,
          },
    pauseChoicesMin: [...status.pauseChoicesMin],
    busyExtraOptionsMin: status.busyExtraOptionsMin,
    busyReminderMin: status.busyReminderMin,
  };
}

// RA §7.2, §18: the status pill and sheet, for owners and cashiers. Each
// command sets a state to a value, so a repeat is harmless and needs no
// Idempotency-Key; each answers the status after it.
@MerchantController()
export class MerchantStatusController {
  constructor(
    private readonly status: RestaurantStatusService,
    private readonly merchants: MerchantsService,
  ) {}

  @Get('restaurant/status')
  @AppSignedIn()
  @ZodResponse({ status: 200, type: MerchantStatusDto })
  async read(@CurrentAppSession() session: AppSession) {
    return statusBody(await this.status.status(merchantOf(session).restaurantId));
  }

  @Post('restaurant/status/pause')
  @AppSignedIn()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: MerchantStatusDto })
  async pause(
    @CurrentAppSession() session: AppSession,
    @Body() body: MerchantPauseDto,
    @Req() request: FastifyRequest,
  ) {
    const { restaurantId } = merchantOf(session);
    await answer(() => this.status.pause(restaurantId, body.minutes, changeOf(session, request)));
    return statusBody(await this.status.status(restaurantId));
  }

  @Post('restaurant/status/resume')
  @AppSignedIn()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: MerchantStatusDto })
  async resume(@CurrentAppSession() session: AppSession, @Req() request: FastifyRequest) {
    const { restaurantId } = merchantOf(session);
    await answer(() => this.status.resume(restaurantId, changeOf(session, request)));
    return statusBody(await this.status.status(restaurantId));
  }

  @Put('restaurant/status/busy-mode')
  @AppSignedIn()
  @ZodResponse({ status: 200, type: MerchantStatusDto })
  async busyMode(
    @CurrentAppSession() session: AppSession,
    @Body() body: MerchantBusyModeDto,
    @Req() request: FastifyRequest,
  ) {
    const { restaurantId } = merchantOf(session);
    await answer(() =>
      this.status.setBusyMode(restaurantId, body.extraMin, changeOf(session, request)),
    );
    return statusBody(await this.status.status(restaurantId));
  }

  // RA §10, §6.1: «الحالة والأوقات» is the owners'; cashiers see the status.
  @Get('restaurant/hours')
  @AppSignedIn()
  @ZodResponse({ status: 200, type: MerchantHoursDto })
  async hours(@CurrentAppSession() session: AppSession) {
    return hoursBody(await this.status.hours(ownerOf(session).restaurantId));
  }

  @Put('restaurant/hours')
  @AppSignedIn()
  @ZodResponse({ status: 200, type: MerchantHoursDto })
  async setHours(
    @CurrentAppSession() session: AppSession,
    @Body() body: MerchantScheduleDto,
    @Req() request: FastifyRequest,
  ) {
    const { restaurantId } = ownerOf(session);
    await answer(() =>
      this.merchants.setWeeklySchedule(restaurantId, body.periods, changeOf(session, request)),
    );
    return hoursBody(await this.status.hours(restaurantId));
  }

  @Put('restaurant/order-settings')
  @AppSignedIn()
  @ZodResponse({ status: 200, type: MerchantHoursDto })
  async setOrderSettings(
    @CurrentAppSession() session: AppSession,
    @Body() body: MerchantOrderSettingsDto,
    @Req() request: FastifyRequest,
  ) {
    const { restaurantId } = ownerOf(session);
    await answer(() =>
      this.status.setOrderSettings(restaurantId, body, changeOf(session, request)),
    );
    return hoursBody(await this.status.hours(restaurantId));
  }

  @Put('restaurant/holiday-close')
  @AppSignedIn()
  @ZodResponse({ status: 200, type: MerchantStatusDto })
  async setHolidayClose(
    @CurrentAppSession() session: AppSession,
    @Body() body: MerchantHolidayCloseDto,
    @Req() request: FastifyRequest,
  ) {
    const { restaurantId } = ownerOf(session);
    await answer(() =>
      this.status.setHolidayClose(
        restaurantId,
        {
          startsAt: body.startsAt === null ? null : new Date(body.startsAt),
          endsAt: new Date(body.endsAt),
          message: body.message,
        },
        changeOf(session, request),
      ),
    );
    return statusBody(await this.status.status(restaurantId));
  }

  @Delete('restaurant/holiday-close')
  @AppSignedIn()
  @ZodResponse({ status: 200, type: MerchantStatusDto })
  async endHolidayClose(@CurrentAppSession() session: AppSession, @Req() request: FastifyRequest) {
    const { restaurantId } = ownerOf(session);
    await answer(() => this.status.endHolidayClose(restaurantId, changeOf(session, request)));
    return statusBody(await this.status.status(restaurantId));
  }
}

// RA §5.4, §18: hours, holiday closes, the prep time and the limit are the
// owners' (MO).
function ownerOf(session: AppSession): MerchantAccount {
  const account = merchantOf(session);
  if (account.role !== 'owner') {
    throw new ForbiddenException({ statusCode: HttpStatus.FORBIDDEN, error: 'owner_only' });
  }
  return account;
}

// RA §7.1 «Logging»: the restaurant user, their role and the device.
export function changeOf(session: AppSession, request: FastifyRequest): MerchantChange {
  const account = merchantOf(session);
  return {
    actor: { type: 'merchant', id: account.id, role: account.role },
    context: { ipAddress: request.ip, device: session.deviceId },
  };
}

// Maps the module's refusals to the routes' answers.
export async function answer(run: () => Promise<void>): Promise<void> {
  try {
    await run();
  } catch (error) {
    if (!(error instanceof MerchantsRefusedError)) throw error;
    const body = (status: number) => ({ statusCode: status, error: error.refusal });
    switch (error.refusal) {
      case 'restaurant_closed':
      case 'paused_by_operations':
      case 'restaurant_suspended':
        throw new ConflictException(body(HttpStatus.CONFLICT));
      case 'restaurant_terminated':
        throw new ForbiddenException(body(HttpStatus.FORBIDDEN));
      case 'invalid_pause':
      case 'invalid_busy_extra':
      case 'invalid_holiday_close':
      case 'invalid_schedule':
      case 'invalid_prep_time':
      case 'invalid_max_active_orders':
        throw new BadRequestException({ ...body(HttpStatus.BAD_REQUEST), message: error.message });
      default:
        throw error;
    }
  }
}

export function merchantOf(session: AppSession): MerchantAccount {
  if (!session.merchant) throw new Error('a merchant route without a restaurant user');
  return session.merchant;
}
