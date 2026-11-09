import {
  BadRequestException,
  Body,
  ConflictException,
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
import { type MerchantChange, MerchantsRefusedError } from './merchants.service.js';
import { pauseSources } from './operating-state.js';
import { type RestaurantStatus, RestaurantStatusService } from './restaurant-status.service.js';

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
  constructor(private readonly status: RestaurantStatusService) {}

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
