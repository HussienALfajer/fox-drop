import {
  BadRequestException,
  Body,
  Get,
  HttpStatus,
  NotFoundException,
  Put,
  Query,
  Req,
} from '@nestjs/common';
import type { FastifyRequest } from 'fastify';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { CurrentAdminSession, RequirePermission } from '../../http/access.js';
import { requestContext } from '../../http/request-context.js';
import { AdminController } from '../../http/route-groups.js';
import { FxService } from '../fx/index.js';
import { GeoService } from '../geo/index.js';
import type { AdminSession } from '../identity/index.js';
import { CaptainsRefusedError } from './captains.service.js';
import { PeakBonusService, type PeakVersionView } from './peak-bonus.service.js';

const minor = z.string().regex(/^\d{1,18}$/);
const minuteOfDay = z.number().int().min(0).max(1439);

const windowFields = {
  days: z
    .array(z.number().int().min(1).max(7))
    .min(1)
    .max(7)
    .describe('ISO days: 1 Monday to 7 Sunday.'),
  startMinute: minuteOfDay.describe('Minutes from midnight on the city clock, 20:00 is 1200.'),
  endMinute: minuteOfDay.describe(
    'Minutes from midnight; at or before the start the window runs past midnight.',
  ),
  amount: minor.describe('Per delivered order, minor units of the base currency.'),
};

const peakVersion = z.object({
  id: z.uuid(),
  enabled: z.boolean(),
  currency: z.string().length(3),
  effectiveFrom: z.iso.datetime(),
  windows: z.array(
    z.object({
      ...windowFields,
      zones: z.array(z.object({ id: z.uuid(), name: z.string() })).describe('None: every zone.'),
    }),
  ),
});

class AdminPeakBonusQueryDto extends createZodDto(z.object({ cityId: z.uuid() })) {}

class AdminPeakBonusDto extends createZodDto(
  z.object({
    inForce: peakVersion.nullable().describe('Null until the owner first saves it: off (D15).'),
    pending: peakVersion
      .nullable()
      .describe('A lowering or disabling waiting for the end of the current window.'),
    zones: z.array(z.object({ id: z.uuid(), name: z.string(), active: z.boolean() })),
    baseCurrency: z
      .string()
      .length(3)
      .nullable()
      .describe('The amounts are typed in it; null while the city has none.'),
  }),
) {}

class AdminSetPeakBonusDto extends createZodDto(
  z.object({
    cityId: z.uuid(),
    enabled: z.boolean(),
    windows: z.array(z.object({ ...windowFields, zoneIds: z.array(z.uuid()).max(200) })).max(50),
  }),
) {}

// AP §9.12.5 «مكافأة ساعة الذروة» (D15): the panel reads it with the zones
// (zones.read) and the owner saves a new version (pricing.edit_pay_tables).
// Saving sets the bonus to the value sent, so no Idempotency-Key.
@AdminController('peak-bonus')
export class AdminPeakBonusController {
  constructor(
    private readonly peak: PeakBonusService,
    private readonly geo: GeoService,
    private readonly fx: FxService,
  ) {}

  @Get()
  @RequirePermission('zones.read')
  @ZodResponse({ status: 200, type: AdminPeakBonusDto })
  async state(@Query() query: AdminPeakBonusQueryDto) {
    const [state, zones, baseCurrency] = await Promise.all([
      this.peak.state(query.cityId, new Date()),
      this.geo.zones(query.cityId),
      this.fx.baseCurrency(query.cityId),
    ]);
    return {
      inForce: state.inForce && versionBody(state.inForce),
      pending: state.pending && versionBody(state.pending),
      zones,
      baseCurrency,
    };
  }

  // 400 invalid_peak_bonus, not_in_base_currency; 404 unknown_city.
  @Put()
  @RequirePermission('pricing.edit_pay_tables')
  @ZodResponse({ status: 200, type: AdminPeakBonusDto })
  async set(
    @Body() body: AdminSetPeakBonusDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    try {
      await this.peak.setPeakBonus(
        body.cityId,
        {
          enabled: body.enabled,
          windows: body.windows.map((window) => ({ ...window, amount: BigInt(window.amount) })),
        },
        {
          actor: { type: 'admin', id: session.accountId, role: session.roles.join(',') },
          context: requestContext(request),
        },
      );
    } catch (error) {
      if (error instanceof CaptainsRefusedError && error.refusal === 'unknown_city') {
        throw new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, error: error.refusal });
      }
      if (error instanceof CaptainsRefusedError) {
        throw new BadRequestException({
          statusCode: HttpStatus.BAD_REQUEST,
          error: error.refusal,
          message: error.message,
        });
      }
      throw error;
    }
    return this.state({ cityId: body.cityId });
  }
}

function versionBody(version: PeakVersionView) {
  return {
    id: version.id,
    enabled: version.enabled,
    currency: version.currency,
    effectiveFrom: version.effectiveFrom.toISOString(),
    windows: version.windows.map((window) => ({
      days: window.days,
      startMinute: window.startMinute,
      endMinute: window.endMinute,
      amount: window.amount.toString(),
      zones: window.zones,
    })),
  };
}
