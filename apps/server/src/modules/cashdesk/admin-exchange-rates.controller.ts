import {
  BadRequestException,
  Body,
  ConflictException,
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
import { type CurrentRate, FxRefusedError, FxService } from '../fx/index.js';
import { GeoService } from '../geo/index.js';
import { type AdminSession, AdminSessionsService } from '../identity/index.js';

const currencyCode = z.string().regex(/^[A-Z]{3}$/);

const rateVersion = z.object({
  versionId: z.string(),
  baseCurrency: currencyCode,
  numerator: z.string().describe('Base major units per one major unit, as an exact fraction.'),
  denominator: z.string(),
  editorId: z.uuid(),
  editorName: z.string().nullable(),
  reason: z.string().nullable(),
  setAt: z.iso.datetime(),
});

class AdminExchangeRatesQueryDto extends createZodDto(z.object({ cityId: z.uuid() })) {}

class AdminExchangeRateHistoryQueryDto extends createZodDto(
  z.object({ cityId: z.uuid(), currency: currencyCode }),
) {}

class AdminExchangeRatesDto extends createZodDto(
  z.object({
    baseCurrency: currencyCode.nullable().describe('Null while the city has no base currency.'),
    staleAlertHours: z.number().int().describe('fx.stale_alert_hours'),
    largeChangePct: z.number().describe('fx.large_change_confirm_pct'),
    currencies: z.array(
      z.object({
        currency: currencyCode,
        nameAr: z.string(),
        symbol: z.string(),
        decimals: z.number().int(),
        displayOrder: z.number().int(),
        enabled: z.boolean(),
        isBase: z.boolean(),
        rate: rateVersion.nullable().describe('Null for the base and before a first rate.'),
        stale: z.boolean().describe('Enabled, with a rate older than fx.stale_alert_hours.'),
        roundingUnitMinor: z
          .string()
          .nullable()
          .describe('currency.<code>.rounding_unit in minor units; null until entered.'),
        roundingMode: z.enum(['nearest', 'up', 'down']),
      }),
    ),
  }),
) {}

class AdminExchangeRateHistoryDto extends createZodDto(
  z.object({ versions: z.array(rateVersion).describe('Newest first, at most 100.') }),
) {}

class AdminSetExchangeRateDto extends createZodDto(
  z.object({
    cityId: z.uuid(),
    currency: currencyCode,
    value: z.string().max(40).describe('A decimal such as 41.20.'),
    direction: z
      .enum(['base_per_unit', 'units_per_base'])
      .describe('«1 USD = 41.20 TRY» is base_per_unit, «1 TRY = 290 SYP» units_per_base.'),
    reason: z.string().max(500).nullable().optional(),
    confirmLargeChange: z
      .boolean()
      .optional()
      .describe('The second confirmation of a change above fx.large_change_confirm_pct.'),
  }),
) {}

// AP §9.10.4 «أسعار الصرف» (OWN, FIN): the city's currencies with their
// rate now, its editor and its history, and the rate edit with the
// large-change confirmation (AP §8.6). The routes live here, with the
// finance screens, because fx cannot import identity for the editors' names.
// The edit sets the rate to the value sent, so it takes no Idempotency-Key:
// a repeat leaves the same rate in force. The same rate again is a new
// version, which confirms it and clears «سعر صرف قديم» (AP §9.1.3).
@AdminController('exchange-rates')
export class AdminExchangeRatesController {
  constructor(
    private readonly fx: FxService,
    private readonly geo: GeoService,
    private readonly admins: AdminSessionsService,
  ) {}

  // 404 unknown_city.
  @Get()
  @RequirePermission('finance.read')
  @ZodResponse({ status: 200, type: AdminExchangeRatesDto })
  async rates(@Query() query: AdminExchangeRatesQueryDto) {
    await this.city(query.cityId);
    const board = await this.fx.exchangeRates(query.cityId, new Date());
    const names = await this.admins.names(
      board.currencies.flatMap((entry) => (entry.rate ? [entry.rate.editorId] : [])),
    );
    return {
      ...board,
      currencies: board.currencies.map((entry) => ({
        currency: entry.currency,
        nameAr: entry.nameAr,
        symbol: entry.symbol,
        decimals: entry.decimals,
        displayOrder: entry.displayOrder,
        enabled: entry.enabled,
        isBase: entry.isBase,
        rate: entry.rate && versionBody(entry.rate, names),
        stale: entry.stale,
        roundingUnitMinor: entry.roundingUnitMinor?.toString() ?? null,
        roundingMode: entry.roundingMode,
      })),
    };
  }

  // 404 unknown_city.
  @Get('history')
  @RequirePermission('finance.read')
  @ZodResponse({ status: 200, type: AdminExchangeRateHistoryDto })
  async history(@Query() query: AdminExchangeRateHistoryQueryDto) {
    await this.city(query.cityId);
    const versions = await this.fx.rateHistory(query.cityId, query.currency);
    const names = await this.admins.names([...new Set(versions.map((row) => row.editorId))]);
    return { versions: versions.map((row) => versionBody(row, names)) };
  }

  // 400 invalid_rate, not_city_currency, no_base_currency; 404 unknown_city;
  // 409 large_change_unconfirmed until confirmLargeChange.
  @Put()
  @RequirePermission('fx.edit_rates')
  @ZodResponse({ status: 200, type: AdminExchangeRatesDto })
  async set(
    @Body() body: AdminSetExchangeRateDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    await this.city(body.cityId);
    try {
      await this.fx.setRate(
        body.cityId,
        body.currency,
        { value: body.value, direction: body.direction },
        {
          actor: { type: 'admin', id: session.accountId, role: session.roles.join(',') },
          context: requestContext(request),
          reason: body.reason ?? null,
          confirmLargeChange: body.confirmLargeChange ?? false,
        },
      );
    } catch (error) {
      if (error instanceof FxRefusedError && error.refusal === 'large_change_unconfirmed') {
        throw new ConflictException({
          statusCode: HttpStatus.CONFLICT,
          error: error.refusal,
          message: error.message,
        });
      }
      if (error instanceof FxRefusedError) {
        throw new BadRequestException({
          statusCode: HttpStatus.BAD_REQUEST,
          error: error.refusal,
          message: error.message,
        });
      }
      throw error;
    }
    return this.rates({ cityId: body.cityId });
  }

  private async city(cityId: string): Promise<void> {
    if ((await this.geo.cityCode(cityId)) === null) {
      throw new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, error: 'unknown_city' });
    }
  }
}

function versionBody(rate: CurrentRate, names: Map<string, string>) {
  return {
    versionId: rate.versionId,
    baseCurrency: rate.baseCurrency,
    numerator: rate.rate.numerator.toString(),
    denominator: rate.rate.denominator.toString(),
    editorId: rate.editorId,
    editorName: names.get(rate.editorId) ?? null,
    reason: rate.reason,
    setAt: rate.setAt.toISOString(),
  };
}
