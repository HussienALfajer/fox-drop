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
  Put,
  Query,
  Req,
  UnprocessableEntityException,
} from '@nestjs/common';
import type { FastifyRequest } from 'fastify';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { CurrentAdminSession, RequireAnyPermission, RequirePermission } from '../../http/access.js';
import { Idempotent, IdempotencyKey } from '../../http/idempotency.js';
import { requestContext } from '../../http/request-context.js';
import { AdminController } from '../../http/route-groups.js';
import type { AdminSession } from '../identity/index.js';
import { MerchantsService } from '../merchants/index.js';
import {
  CUSTOM_SECTIONS_MAX,
  type HomeSection,
  HomeSectionRefusedError,
  HomeSectionsService,
  SECTION_RESTAURANTS_MAX,
  SECTION_TITLE_MAX,
} from './home-sections.service.js';
import type { PromoChange } from './promo-codes.service.js';
import { homeSectionKinds } from './schema.js';

const sectionBody = z.object({
  key: z
    .string()
    .describe("A built-in section's kind, or a custom section's id: what the commands name."),
  kind: z
    .enum(homeSectionKinds)
    .describe(
      '«البانرات», «التصنيفات», «الأقرب إليك», «الأكثر طلباً», «جديد على FOX DROP», «العروض», or a custom section.',
    ),
  title: z.string().nullable().describe("A custom section's title; null for a built-in one."),
  restaurantIds: z
    .array(z.uuid())
    .describe("A custom section's restaurants in the admin's order; empty for a built-in one."),
  visible: z.boolean(),
});

class AdminHomeSectionsDto extends createZodDto(
  z.object({
    sections: z
      .array(sectionBody)
      .describe('Every section of the city in the home’s order, hidden ones included.'),
    restaurants: z
      .array(z.object({ id: z.uuid(), name: z.string() }))
      .describe("The city's restaurants a custom section picks from."),
    canManage: z.boolean().describe('Whether this admin may change them (marketing.manage).'),
  }),
) {}

class AdminHomeSectionsQueryDto extends createZodDto(z.object({ cityId: z.uuid() })) {}

class AdminHomeSectionsOrderDto extends createZodDto(
  z.object({
    cityId: z.uuid(),
    keys: z
      .array(z.string().max(64))
      .max(CUSTOM_SECTIONS_MAX + 10)
      .describe('Every section of the city once, in the new order.'),
  }),
) {}

class AdminHomeSectionVisibilityDto extends createZodDto(
  z.object({ cityId: z.uuid(), key: z.string().max(64), visible: z.boolean() }),
) {}

const customFields = {
  cityId: z.uuid(),
  title: z.string().max(200).describe(`Trimmed, 1 to ${SECTION_TITLE_MAX} characters.`),
  restaurantIds: z
    .array(z.uuid())
    .max(SECTION_RESTAURANTS_MAX + 1)
    .describe(`1 to ${SECTION_RESTAURANTS_MAX} of the city's restaurants, in the home's order.`),
};

class AdminNewHomeSectionDto extends createZodDto(z.object(customFields)) {}

class AdminUpdateHomeSectionDto extends createZodDto(z.object(customFields)) {}

class AdminHomeSectionCityDto extends createZodDto(z.object({ cityId: z.uuid() })) {}

class AdminHomeSectionParamsDto extends createZodDto(z.object({ sectionId: z.uuid() })) {}

// AP §9.11.3 «أقسام الرئيسية» (slice 2.27b, owner decision 2026-11-18): OWN
// orders, shows or hides the sections and writes the custom ones
// (marketing.manage); OPS reads them (marketing.read). Each command sets a
// value or names its target, so takes no Idempotency-Key, but the create.
// Each answers the city's sections.
@AdminController('home-sections')
export class AdminHomeSectionsController {
  constructor(
    private readonly sections: HomeSectionsService,
    private readonly merchants: MerchantsService,
  ) {}

  // 404 unknown_city.
  @Get()
  @RequireAnyPermission('marketing.read', 'marketing.manage')
  @ZodResponse({ status: 200, type: AdminHomeSectionsDto })
  list(@Query() query: AdminHomeSectionsQueryDto, @CurrentAdminSession() session: AdminSession) {
    return refusalsAsHttp(async () => {
      await this.sections.checkCity(query.cityId);
      return this.answer(query.cityId, session, await this.sections.sections(query.cityId));
    });
  }

  // 409 sections_changed when a section was added or removed since the
  // panel read them; 404 unknown_city.
  @Post('order')
  @RequirePermission('marketing.manage')
  @HttpCode(200)
  @ZodResponse({ status: 200, type: AdminHomeSectionsDto })
  order(
    @Body() body: AdminHomeSectionsOrderDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return refusalsAsHttp(async () =>
      this.answer(
        body.cityId,
        session,
        await this.sections.reorder(body.cityId, body.keys, changeOf(session, request)),
      ),
    );
  }

  // Show or hide. 404 unknown_city, unknown_section.
  @Post('visibility')
  @RequirePermission('marketing.manage')
  @HttpCode(200)
  @ZodResponse({ status: 200, type: AdminHomeSectionsDto })
  visibility(
    @Body() body: AdminHomeSectionVisibilityDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return refusalsAsHttp(async () =>
      this.answer(
        body.cityId,
        session,
        await this.sections.setVisible(
          body.cityId,
          body.key,
          body.visible,
          changeOf(session, request),
        ),
      ),
    );
  }

  // A custom section at the end, with an Idempotency-Key: a repeat answers
  // the sections without adding one. 400 invalid_section; 404 unknown_city;
  // 422 idempotency_key_reused.
  @Post()
  @RequirePermission('marketing.manage')
  @Idempotent()
  @ZodResponse({ status: 201, type: AdminHomeSectionsDto })
  create(
    @Body() body: AdminNewHomeSectionDto,
    @IdempotencyKey() idempotencyKey: string,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return refusalsAsHttp(async () =>
      this.answer(
        body.cityId,
        session,
        await this.sections.create(
          body.cityId,
          { title: body.title, restaurantIds: body.restaurantIds },
          idempotencyKey,
          changeOf(session, request),
        ),
      ),
    );
  }

  // 400 invalid_section; 404 unknown_city, unknown_section.
  @Put(':sectionId')
  @RequirePermission('marketing.manage')
  @ZodResponse({ status: 200, type: AdminHomeSectionsDto })
  update(
    @Param() params: AdminHomeSectionParamsDto,
    @Body() body: AdminUpdateHomeSectionDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return refusalsAsHttp(async () =>
      this.answer(
        body.cityId,
        session,
        await this.sections.update(
          body.cityId,
          params.sectionId,
          { title: body.title, restaurantIds: body.restaurantIds },
          changeOf(session, request),
        ),
      ),
    );
  }

  // A custom section off for good; a repeat is 404 unknown_section.
  @Post(':sectionId/remove')
  @RequirePermission('marketing.manage')
  @HttpCode(200)
  @ZodResponse({ status: 200, type: AdminHomeSectionsDto })
  remove(
    @Param() params: AdminHomeSectionParamsDto,
    @Body() body: AdminHomeSectionCityDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return refusalsAsHttp(async () =>
      this.answer(
        body.cityId,
        session,
        await this.sections.remove(body.cityId, params.sectionId, changeOf(session, request)),
      ),
    );
  }

  private async answer(cityId: string, session: AdminSession, sections: HomeSection[]) {
    const restaurants = await this.merchants.restaurantIds(cityId);
    return {
      sections,
      restaurants: restaurants.map(({ id, nameAr }) => ({ id, name: nameAr })),
      canManage: session.permissions.includes('marketing.manage'),
    };
  }
}

function changeOf(session: AdminSession, request: FastifyRequest): PromoChange {
  return {
    accountId: session.accountId,
    actor: { type: 'admin', id: session.accountId, role: session.roles.join(',') },
    context: requestContext(request),
  };
}

async function refusalsAsHttp<T>(run: () => Promise<T>): Promise<T> {
  try {
    return await run();
  } catch (error) {
    if (!(error instanceof HomeSectionRefusedError)) throw error;
    const body = (statusCode: number) => ({
      statusCode,
      error: error.refusal,
      message: error.message,
    });
    switch (error.refusal) {
      case 'invalid_section':
        throw new BadRequestException(body(HttpStatus.BAD_REQUEST));
      case 'unknown_city':
      case 'unknown_section':
        throw new NotFoundException(body(HttpStatus.NOT_FOUND));
      case 'sections_changed':
        throw new ConflictException(body(HttpStatus.CONFLICT));
      case 'idempotency_key_reused':
        throw new UnprocessableEntityException(body(HttpStatus.UNPROCESSABLE_ENTITY));
    }
  }
}
