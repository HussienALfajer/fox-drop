import {
  BadRequestException,
  Body,
  ConflictException,
  Get,
  HttpStatus,
  NotFoundException,
  Param,
  Put,
  Req,
} from '@nestjs/common';
import type { FastifyRequest } from 'fastify';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { CurrentAdminSession, RequirePermission, SignedIn } from '../../http/access.js';
import { requestContext } from '../../http/request-context.js';
import { AdminController } from '../../http/route-groups.js';
import { FxRefusedError, FxService } from '../fx/index.js';
import type { AdminSession } from '../identity/index.js';
import { type GeoChange, type Office, GeoRefusedError, GeoService } from './geo.service.js';

class AdminCitiesDto extends createZodDto(
  z.object({
    cities: z
      .array(
        z.object({
          id: z.uuid(),
          code: z.string().describe('Such as AZ (AP §4.8).'),
          name: z.string(),
          timeZone: z.string().describe("The city's clock, such as Asia/Damascus."),
        }),
      )
      .describe('The active cities, by name.'),
  }),
) {}

class AdminCityParamsDto extends createZodDto(z.object({ cityId: z.uuid() })) {}

const location = z
  .object({
    latitude: z.number().min(-90).max(90),
    longitude: z.number().min(-180).max(180),
  })
  .describe("The office's point, until the map (slice 2.29).");

const deskPeriod = z.object({
  weekday: z.number().int().min(0).max(6).describe('0 Sunday to 6 Saturday.'),
  opensAt: z.number().int().min(0).max(1439).describe('Minutes after midnight, city clock.'),
  closesAt: z
    .number()
    .int()
    .min(0)
    .max(1440)
    .describe('Minutes after midnight; at or before the opening it runs past midnight.'),
});

const officeBody = z.object({
  location,
  hours: z.array(deskPeriod).max(7).describe('One period per weekday at most; none is closed.'),
  open: z.boolean().describe('Whether the desk is open now.'),
  closesAt: z.iso.datetime().nullable().describe('While open: when it closes.'),
  opensAt: z.iso.datetime().nullable().describe('While closed: when it opens next.'),
});

class AdminCityOfficeDto extends createZodDto(
  z.object({ office: officeBody.nullable().describe('Null until the owner saves one.') }),
) {}

class AdminSetCityOfficeDto extends createZodDto(
  z.object({ location, hours: z.array(deskPeriod).max(7) }),
) {}

const reason = z.string().trim().max(500).nullish().describe('Why, for the audit log; optional.');

const cityBody = z.object({
  id: z.uuid(),
  code: z.string().describe('Two or three capital letters, such as AZ (AP §4.8).'),
  name: z.string(),
  timeZone: z.string().describe('An IANA time zone, such as Asia/Damascus.'),
  status: z.enum(['active', 'inactive']),
});

class AdminAllCitiesDto extends createZodDto(
  z.object({ cities: z.array(cityBody).describe('Every city, active or not, by name.') }),
) {}

class AdminCityDto extends createZodDto(
  z.object({
    city: cityBody,
    currencies: z
      .array(
        z.object({
          code: z.string(),
          name: z.string(),
          symbol: z.string(),
          displayOrder: z.number().int(),
          enabled: z.boolean(),
          isBase: z.boolean(),
        }),
      )
      .describe("The city's currencies in display order, enabled or not."),
    otherCurrencies: z
      .array(z.object({ code: z.string(), name: z.string(), symbol: z.string() }))
      .describe('The currencies in use the city does not have yet.'),
    baseLocked: z.boolean().describe('Whether the first order has locked the base (D25).'),
  }),
) {}

class AdminUpdateCityDto extends createZodDto(
  z.object({
    name: z.string().max(100),
    code: z.string().max(3),
    timeZone: z.string().max(64),
    status: z.enum(['active', 'inactive']),
    reason,
  }),
) {}

class AdminCityCurrencyParamsDto extends createZodDto(
  z.object({ cityId: z.uuid(), currency: z.string().regex(/^[A-Z]{3}$/) }),
) {}

class AdminSetCityCurrencyDto extends createZodDto(
  z.object({ displayOrder: z.number().int().min(0).max(1000), enabled: z.boolean(), reason }),
) {}

class AdminSetBaseCurrencyDto extends createZodDto(
  z.object({ currency: z.string().regex(/^[A-Z]{3}$/), reason }),
) {}

const zonePoint = z
  .object({
    latitude: z.number().min(-90).max(90),
    longitude: z.number().min(-180).max(180),
  })
  .describe("A corner of the zone's outline.");

class AdminZonesDto extends createZodDto(
  z.object({
    zones: z
      .array(
        z.object({
          id: z.uuid(),
          name: z.string(),
          active: z.boolean(),
          area: z.array(zonePoint).describe('The corners in order, the ring left open.'),
        }),
      )
      .describe("The city's zones, active or not, by name."),
    votes: z
      .array(
        z.object({
          latitude: z.number(),
          longitude: z.number(),
          votes: z.number().int().describe('The votes in this cell of about 100 m.'),
        }),
      )
      .describe('Votes from outside the zones, the most voted first (AP §9.12.2).'),
  }),
) {}

class AdminZoneParamsDto extends createZodDto(z.object({ cityId: z.uuid(), zoneId: z.uuid() })) {}

class AdminSaveZoneDto extends createZodDto(
  z.object({
    name: z.string().max(100),
    area: z.array(zonePoint).min(3).max(500),
    active: z.boolean(),
    reason,
  }),
) {}

// Who changes the city, for the audit log.
function changeBy(session: AdminSession, request: FastifyRequest, why?: string | null): GeoChange {
  return {
    actor: { type: 'admin', id: session.accountId, role: session.roles.join(',') },
    context: requestContext(request),
    reason: why || null,
  };
}

// The refusals of geo and fx as the routes answer them.
function refusal(error: unknown): unknown {
  if (error instanceof GeoRefusedError) {
    const body = { error: error.refusal, message: error.message };
    if (error.refusal === 'unknown_city' || error.refusal === 'unknown_zone') {
      return new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, ...body });
    }
    if (
      error.refusal === 'zone_name_taken' ||
      error.refusal === 'zones_overlap' ||
      error.refusal === 'city_code_taken'
    ) {
      return new ConflictException({ statusCode: HttpStatus.CONFLICT, ...body });
    }
    return new BadRequestException({ statusCode: HttpStatus.BAD_REQUEST, ...body });
  }
  if (error instanceof FxRefusedError) {
    const body = { error: error.refusal, message: error.message };
    if (
      error.refusal === 'base_locked' ||
      error.refusal === 'rate_missing' ||
      error.refusal === 'amounts_in_other_currency'
    ) {
      return new ConflictException({ statusCode: HttpStatus.CONFLICT, ...body });
    }
    return new BadRequestException({ statusCode: HttpStatus.BAD_REQUEST, ...body });
  }
  return error;
}

async function refusalsAsHttp<T>(action: () => Promise<T>): Promise<T> {
  try {
    return await action();
  } catch (error) {
    throw refusal(error);
  }
}

// The office as the routes answer it.
function officeView(office: Office) {
  return {
    location: office.location,
    hours: office.hours,
    open: office.open,
    closesAt: office.closesAt?.toISOString() ?? null,
    opensAt: office.opensAt?.toISOString() ?? null,
  };
}

// AP §7.2: the top bar's city selector, for every signed-in panel user. The
// city reads (the operations board, settings) take the chosen city's id.
// AP §9.12.1: the city's office and desk hours (CA C13), and «المدن»: the
// city's own fields and currencies (slice 2.37c; owner decision 2026-11-19:
// the existing city only, adding one waits for a second city).
// AP §9.12.2: the zones on the map and the votes from outside them.
@AdminController('cities')
export class AdminCitiesController {
  constructor(
    private readonly geo: GeoService,
    private readonly fx: FxService,
  ) {}

  @Get()
  @SignedIn()
  @ZodResponse({ status: 200, type: AdminCitiesDto })
  async list() {
    return { cities: await this.geo.activeCities() };
  }

  // «المدن»: every city, so an inactive one can be activated again.
  @Get('all')
  @RequirePermission('zones.read')
  @ZodResponse({ status: 200, type: AdminAllCitiesDto })
  async all() {
    return { cities: await this.geo.cities() };
  }

  @Get(':cityId')
  @RequirePermission('zones.read')
  @ZodResponse({ status: 200, type: AdminCityDto })
  async city(@Param() params: AdminCityParamsDto) {
    const city = await this.geo.city(params.cityId);
    if (!city) {
      throw new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, error: 'unknown_city' });
    }
    const [mine, all, baseLocked] = await Promise.all([
      this.fx.cityCurrencies(params.cityId),
      this.fx.currencies(),
      this.fx.baseLocked(params.cityId),
    ]);
    const byCode = new Map(all.map((each) => [each.code, each]));
    return {
      city,
      currencies: mine.map((each) => ({
        code: each.currency,
        name: byCode.get(each.currency)?.nameAr ?? each.currency,
        symbol: byCode.get(each.currency)?.symbol ?? each.currency,
        displayOrder: each.displayOrder,
        enabled: each.enabled,
        isBase: each.isBase,
      })),
      otherCurrencies: all
        .filter(
          (each) => each.status === 'active' && !mine.some((entry) => entry.currency === each.code),
        )
        .map((each) => ({ code: each.code, name: each.nameAr, symbol: each.symbol })),
      baseLocked,
    };
  }

  // Sets the city's fields to the values sent, so no Idempotency-Key.
  // 400 invalid_name, invalid_city; 409 city_code_taken; 404 unknown_city.
  @Put(':cityId')
  @RequirePermission('zones.manage')
  @ZodResponse({ status: 200, type: AdminCityDto })
  async updateCity(
    @Param() params: AdminCityParamsDto,
    @Body() body: AdminUpdateCityDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    const { reason: why, ...fields } = body;
    await refusalsAsHttp(() =>
      this.geo.updateCity(params.cityId, fields, changeBy(session, request, why)),
    );
    return this.city(params);
  }

  // Adds a currency to the city, or sets its order and whether it is
  // accepted (AP §8.6); its rate and rounding are on «أسعار الصرف».
  // 400 inactive_currency, base_disabled, unknown_currency; 409 rate_missing.
  @Put(':cityId/currencies/:currency')
  @RequirePermission('zones.manage')
  @ZodResponse({ status: 200, type: AdminCityDto })
  async setCurrency(
    @Param() params: AdminCityCurrencyParamsDto,
    @Body() body: AdminSetCityCurrencyDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    await this.knownCity(params.cityId);
    await refusalsAsHttp(() =>
      this.fx.setCityCurrency(
        params.cityId,
        { currency: params.currency, displayOrder: body.displayOrder, enabled: body.enabled },
        changeBy(session, request, body.reason),
      ),
    );
    return this.city({ cityId: params.cityId });
  }

  // D25: the base currency, until the city's first order locks it.
  // 400 not_city_currency, unknown_currency; 409 base_locked,
  // amounts_in_other_currency.
  @Put(':cityId/base-currency')
  @RequirePermission('zones.manage')
  @ZodResponse({ status: 200, type: AdminCityDto })
  async setBaseCurrency(
    @Param() params: AdminCityParamsDto,
    @Body() body: AdminSetBaseCurrencyDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    await this.knownCity(params.cityId);
    await refusalsAsHttp(() =>
      this.fx.setBaseCurrency(
        params.cityId,
        body.currency,
        changeBy(session, request, body.reason),
      ),
    );
    return this.city(params);
  }

  @Get(':cityId/zones')
  @RequirePermission('zones.read')
  @ZodResponse({ status: 200, type: AdminZonesDto })
  async zones(@Param() params: AdminCityParamsDto) {
    await this.knownCity(params.cityId);
    const [zones, votes] = await Promise.all([
      this.geo.zoneOutlines(params.cityId),
      this.geo.voteMap(params.cityId),
    ]);
    return { zones, votes };
  }

  // Draws a zone under the id the panel chose, or changes its name, outline
  // and state: it sets the value sent, so no Idempotency-Key.
  // 400 invalid_name, invalid_area; 409 zone_name_taken, zones_overlap;
  // 404 unknown_city, unknown_zone.
  @Put(':cityId/zones/:zoneId')
  @RequirePermission('zones.manage')
  @ZodResponse({ status: 200, type: AdminZonesDto })
  async saveZone(
    @Param() params: AdminZoneParamsDto,
    @Body() body: AdminSaveZoneDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    await this.knownCity(params.cityId);
    const { reason: why, ...zone } = body;
    await refusalsAsHttp(() =>
      this.geo.saveZone(params.cityId, params.zoneId, zone, changeBy(session, request, why)),
    );
    return this.zones({ cityId: params.cityId });
  }

  private async knownCity(cityId: string): Promise<void> {
    if ((await this.geo.cityTimeZone(cityId)) === null) {
      throw new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, error: 'unknown_city' });
    }
  }

  @Get(':cityId/office')
  @RequirePermission('zones.read')
  @ZodResponse({ status: 200, type: AdminCityOfficeDto })
  async office(@Param() params: AdminCityParamsDto) {
    await this.knownCity(params.cityId);
    const office = await this.geo.office(params.cityId, new Date());
    return { office: office && officeView(office) };
  }

  // Sets the office to the value sent, so no Idempotency-Key.
  // 400 invalid_office; 404 unknown_city (the read too).
  @Put(':cityId/office')
  @RequirePermission('zones.manage')
  @ZodResponse({ status: 200, type: AdminCityOfficeDto })
  async setOffice(
    @Param() params: AdminCityParamsDto,
    @Body() body: AdminSetCityOfficeDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    try {
      await this.geo.setOffice(params.cityId, body, {
        actor: { type: 'admin', id: session.accountId, role: session.roles.join(',') },
        context: requestContext(request),
      });
    } catch (error) {
      if (error instanceof GeoRefusedError && error.refusal === 'unknown_city') {
        throw new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, error: error.refusal });
      }
      if (error instanceof GeoRefusedError && error.refusal === 'invalid_office') {
        throw new BadRequestException({
          statusCode: HttpStatus.BAD_REQUEST,
          error: error.refusal,
          message: error.message,
        });
      }
      throw error;
    }
    return this.office(params);
  }
}
