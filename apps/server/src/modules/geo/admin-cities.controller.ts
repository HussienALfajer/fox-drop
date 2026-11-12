import {
  BadRequestException,
  Body,
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
import type { AdminSession } from '../identity/index.js';
import { type Office, GeoRefusedError, GeoService } from './geo.service.js';

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
// AP §9.12.1: the city's office and desk hours (CA C13).
@AdminController('cities')
export class AdminCitiesController {
  constructor(private readonly geo: GeoService) {}

  @Get()
  @SignedIn()
  @ZodResponse({ status: 200, type: AdminCitiesDto })
  async list() {
    return { cities: await this.geo.activeCities() };
  }

  @Get(':cityId/office')
  @RequirePermission('zones.read')
  @ZodResponse({ status: 200, type: AdminCityOfficeDto })
  async office(@Param() params: AdminCityParamsDto) {
    if ((await this.geo.cityTimeZone(params.cityId)) === null) {
      throw new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, error: 'unknown_city' });
    }
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
