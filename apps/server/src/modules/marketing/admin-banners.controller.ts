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
import { CategoriesService } from '../content/index.js';
import { FilesRefusedError } from '../files/index.js';
import { GeoService } from '../geo/index.js';
import type { AdminSession } from '../identity/index.js';
import { MerchantsService } from '../merchants/index.js';
import {
  BANNER_RESTAURANTS_MAX,
  BANNER_TITLE_MAX,
  type Banner,
  type BannerFields,
  BannerRefusedError,
  BannersService,
} from './banners.service.js';
import type { PromoChange } from './promo-codes.service.js';
import { bannerTargets } from './schema.js';

const targetDescription =
  '`restaurant` opens its page (restaurantIds holds it), `category` its category page, `restaurants` the banner’s own list under its title (restaurantIds in order), `code` «أكوادي» on that code.';

const bannerBody = z.object({
  id: z.uuid(),
  title: z.string(),
  imageKey: z.string().describe('In public-media, 1200×500 (architecture §5.8).'),
  target: z.enum(bannerTargets).describe(targetDescription),
  restaurantIds: z.array(z.uuid()),
  categoryId: z.uuid().nullable(),
  codeId: z.uuid().nullable(),
  code: z.string().nullable().describe("The code target's code; null otherwise."),
  zoneIds: z.array(z.uuid()).describe('None: every zone of the city.'),
  startsAt: z.iso.datetime(),
  endsAt: z.iso.datetime(),
});

class AdminBannersDto extends createZodDto(
  z.object({
    banners: z
      .array(bannerBody)
      .describe('The city’s banners in the strip’s order, ended ones included.'),
    restaurants: z
      .array(z.object({ id: z.uuid(), name: z.string() }))
      .describe("The city's restaurants a target picks from."),
    categories: z
      .array(z.object({ id: z.uuid(), name: z.string() }))
      .describe('The active categories, in their order.'),
    codes: z
      .array(z.object({ id: z.uuid(), code: z.string() }))
      .describe("The city's visible codes running now in its base currency, newest first."),
    zones: z.array(z.object({ id: z.uuid(), name: z.string(), active: z.boolean() })),
    canManage: z.boolean().describe('Whether this admin may publish (marketing.banners).'),
  }),
) {}

class AdminBannersQueryDto extends createZodDto(z.object({ cityId: z.uuid() })) {}

const fields = {
  cityId: z.uuid(),
  title: z.string().max(200).describe(`Trimmed, 1 to ${BANNER_TITLE_MAX} characters.`),
  target: z.enum(bannerTargets).describe(targetDescription),
  restaurantIds: z
    .array(z.uuid())
    .max(BANNER_RESTAURANTS_MAX + 1)
    .describe(`One for \`restaurant\`, 1 to ${BANNER_RESTAURANTS_MAX} for \`restaurants\`.`),
  categoryId: z.uuid().nullable(),
  codeId: z.uuid().nullable(),
  zoneIds: z.array(z.uuid()).max(200).describe("The city's zones; none for all."),
  startsAt: z.iso.datetime(),
  endsAt: z.iso.datetime().describe('After the start and after now.'),
};

class AdminNewBannerDto extends createZodDto(
  z.object({
    ...fields,
    uploadId: z
      .uuid()
      .describe('From POST /v1/admin/uploads (banner_image), cut to exactly 1200×500.'),
  }),
) {}

class AdminUpdateBannerDto extends createZodDto(
  z.object({
    ...fields,
    uploadId: z.uuid().nullable().describe('A new image (banner_image); null keeps the image.'),
  }),
) {}

class AdminBannersOrderDto extends createZodDto(
  z.object({
    cityId: z.uuid(),
    ids: z
      .array(z.uuid())
      .max(5000)
      .describe('Every banner of the city once (ended ones included), in the new order.'),
  }),
) {}

class AdminBannerCityDto extends createZodDto(z.object({ cityId: z.uuid() })) {}

class AdminBannerParamsDto extends createZodDto(z.object({ bannerId: z.uuid() })) {}

// AP §9.11.2 «البانرات» (slice 2.27c, owner decision 2026-11-18): OWN and
// DATA publish (marketing.banners); OPS reads (marketing.read). The create
// takes an Idempotency-Key; the edit, the order and the removal set a value
// or name their target. Each answers the city's banners.
@AdminController('banners')
export class AdminBannersController {
  constructor(
    private readonly banners: BannersService,
    private readonly merchants: MerchantsService,
    private readonly categories: CategoriesService,
    private readonly geo: GeoService,
  ) {}

  // 404 unknown_city.
  @Get()
  @RequireAnyPermission('marketing.read', 'marketing.manage', 'marketing.banners')
  @ZodResponse({ status: 200, type: AdminBannersDto })
  list(@Query() query: AdminBannersQueryDto, @CurrentAdminSession() session: AdminSession) {
    return refusalsAsHttp(async () => {
      await this.banners.checkCity(query.cityId);
      return this.answer(query.cityId, session, await this.banners.list(query.cityId));
    });
  }

  // A banner at the end of the strip. 400 invalid_banner (with the rule
  // broken: at most BANNERS_MAX running), upload_wrong_purpose,
  // upload_invalid, upload_wrong_size; 404 unknown_city, upload_not_found;
  // 409 upload_missing, upload_expired, upload_used; 422
  // idempotency_key_reused.
  @Post()
  @RequirePermission('marketing.banners')
  @Idempotent()
  @ZodResponse({ status: 201, type: AdminBannersDto })
  create(
    @Body() body: AdminNewBannerDto,
    @IdempotencyKey() idempotencyKey: string,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return refusalsAsHttp(async () =>
      this.answer(
        body.cityId,
        session,
        await this.banners.create(
          body.cityId,
          fieldsOf(body),
          body.uploadId,
          idempotencyKey,
          changeOf(session, request),
        ),
      ),
    );
  }

  // Every field, and the image when uploadId is given. The create's
  // refusals, and 404 unknown_banner.
  @Put(':bannerId')
  @RequirePermission('marketing.banners')
  @ZodResponse({ status: 200, type: AdminBannersDto })
  update(
    @Param() params: AdminBannerParamsDto,
    @Body() body: AdminUpdateBannerDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return refusalsAsHttp(async () =>
      this.answer(
        body.cityId,
        session,
        await this.banners.update(
          body.cityId,
          params.bannerId,
          fieldsOf(body),
          body.uploadId,
          changeOf(session, request),
        ),
      ),
    );
  }

  // 409 banners_changed when a banner was added or removed since the panel
  // read them; 404 unknown_city.
  @Post('order')
  @RequirePermission('marketing.banners')
  @HttpCode(200)
  @ZodResponse({ status: 200, type: AdminBannersDto })
  order(
    @Body() body: AdminBannersOrderDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return refusalsAsHttp(async () =>
      this.answer(
        body.cityId,
        session,
        await this.banners.reorder(body.cityId, body.ids, changeOf(session, request)),
      ),
    );
  }

  // Off the strip for good; a repeat is 404 unknown_banner.
  @Post(':bannerId/remove')
  @RequirePermission('marketing.banners')
  @HttpCode(200)
  @ZodResponse({ status: 200, type: AdminBannersDto })
  remove(
    @Param() params: AdminBannerParamsDto,
    @Body() body: AdminBannerCityDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return refusalsAsHttp(async () =>
      this.answer(
        body.cityId,
        session,
        await this.banners.remove(body.cityId, params.bannerId, changeOf(session, request)),
      ),
    );
  }

  private async answer(cityId: string, session: AdminSession, banners: Banner[]) {
    const [restaurants, categories, codes, zones] = await Promise.all([
      this.merchants.restaurantIds(cityId),
      this.categories.active(),
      this.banners.codeChoices(cityId),
      this.geo.zones(cityId),
    ]);
    return {
      banners: banners.map((banner) => ({
        ...banner,
        startsAt: banner.startsAt.toISOString(),
        endsAt: banner.endsAt.toISOString(),
      })),
      restaurants: restaurants.map(({ id, nameAr }) => ({ id, name: nameAr })),
      categories: categories.map(({ id, name }) => ({ id, name })),
      codes,
      zones,
      canManage: session.permissions.includes('marketing.banners'),
    };
  }
}

function fieldsOf(body: AdminUpdateBannerDto | AdminNewBannerDto): BannerFields {
  return {
    title: body.title,
    target: body.target,
    restaurantIds: body.restaurantIds,
    categoryId: body.categoryId,
    codeId: body.codeId,
    zoneIds: body.zoneIds,
    startsAt: new Date(body.startsAt),
    endsAt: new Date(body.endsAt),
  };
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
    if (error instanceof FilesRefusedError) {
      const body = (statusCode: number) => ({ statusCode, error: error.refusal });
      switch (error.refusal) {
        case 'upload_not_found':
          throw new NotFoundException(body(HttpStatus.NOT_FOUND));
        case 'upload_wrong_purpose':
        case 'upload_invalid':
        case 'upload_wrong_size':
          throw new BadRequestException(body(HttpStatus.BAD_REQUEST));
        default:
          throw new ConflictException(body(HttpStatus.CONFLICT));
      }
    }
    if (!(error instanceof BannerRefusedError)) throw error;
    const body = (statusCode: number) => ({
      statusCode,
      error: error.refusal,
      message: error.message,
    });
    switch (error.refusal) {
      case 'invalid_banner':
        throw new BadRequestException(body(HttpStatus.BAD_REQUEST));
      case 'unknown_city':
      case 'unknown_banner':
        throw new NotFoundException(body(HttpStatus.NOT_FOUND));
      case 'banners_changed':
      case 'upload_used':
        throw new ConflictException(body(HttpStatus.CONFLICT));
      case 'idempotency_key_reused':
        throw new UnprocessableEntityException(body(HttpStatus.UNPROCESSABLE_ENTITY));
    }
  }
}
