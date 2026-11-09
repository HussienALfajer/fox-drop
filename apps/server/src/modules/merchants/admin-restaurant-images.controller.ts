import {
  BadRequestException,
  Body,
  ConflictException,
  Get,
  HttpStatus,
  NotFoundException,
  Param,
  Put,
  Query,
  Req,
} from '@nestjs/common';
import type { FastifyRequest } from 'fastify';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { CurrentAdminSession, RequireAnyPermission, RequirePermission } from '../../http/access.js';
import { requestContext } from '../../http/request-context.js';
import { AdminController } from '../../http/route-groups.js';
import { FilesRefusedError, RESTAURANT_PROFILE } from '../files/index.js';
import type { AdminSession } from '../identity/index.js';
import {
  type MerchantChange,
  MerchantsRefusedError,
  MerchantsService,
} from './merchants.service.js';

const imageKey = z
  .string()
  .nullable()
  .describe(
    'Its key in public-media, shown through /media/ (architecture §5.8); null without one.',
  );

class AdminRestaurantsQueryDto extends createZodDto(z.object({ cityId: z.uuid() })) {}

class AdminRestaurantsDto extends createZodDto(
  z.object({ restaurants: z.array(z.object({ id: z.uuid(), nameAr: z.string() })) }),
) {}

class AdminRestaurantParamsDto extends createZodDto(z.object({ restaurantId: z.uuid() })) {}

class AdminItemParamsDto extends createZodDto(
  z.object({ restaurantId: z.uuid(), itemId: z.uuid() }),
) {}

class AdminRestaurantImagesDto extends createZodDto(
  z.object({
    logoKey: imageKey,
    coverKey: imageKey,
    categories: z.array(
      z.object({
        id: z.uuid(),
        name: z.string(),
        items: z.array(z.object({ id: z.uuid(), name: z.string(), photoKey: imageKey })),
      }),
    ),
  }),
) {}

class AdminSetImageDto extends createZodDto(
  z.object({ uploadId: z.uuid().describe('From POST /v1/admin/uploads, once the PUT is done.') }),
) {}

class AdminImageSetDto extends createZodDto(z.object({ key: z.string() })) {}

function refusalAsHttp(error: unknown): never {
  if (error instanceof MerchantsRefusedError) {
    const body = { error: error.refusal };
    if (error.refusal === 'unknown_restaurant' || error.refusal === 'unknown_menu_row') {
      throw new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, ...body });
    }
    throw new ConflictException({ statusCode: HttpStatus.CONFLICT, ...body });
  }
  if (error instanceof FilesRefusedError) {
    const body = { error: error.refusal };
    if (error.refusal === 'upload_not_found') {
      throw new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, ...body });
    }
    if (error.refusal === 'upload_wrong_purpose' || error.refusal === 'upload_invalid') {
      throw new BadRequestException({ statusCode: HttpStatus.BAD_REQUEST, ...body });
    }
    throw new ConflictException({ statusCode: HttpStatus.CONFLICT, ...body });
  }
  throw error;
}

function adminChange(session: AdminSession, request: FastifyRequest): MerchantChange {
  return {
    actor: { type: 'admin', id: session.accountId, role: session.roles.join(',') },
    context: requestContext(request),
  };
}

// The panel's «الصور» (slice 2.5, owner decision 2026-11-09): a restaurant's
// logo and cover (AP §9.6.3 step 1, restaurants.manage or restaurants.create) and its items' photos
// (AP §9.6.6, restaurants.menus), until the onboarding wizard (2.30) and the
// menu editor (2.31) take them. Setting an image sets a state to a value, so
// it takes no Idempotency-Key. The refusals: 404 unknown_restaurant,
// unknown_menu_row, upload_not_found; 400 upload_wrong_purpose,
// upload_invalid; 409 upload_missing (not uploaded yet), upload_expired,
// upload_used.
@AdminController('restaurants')
export class AdminRestaurantImagesController {
  constructor(private readonly merchants: MerchantsService) {}

  @Get()
  @RequireAnyPermission('restaurants.read', 'restaurants.menus')
  @ZodResponse({ status: 200, type: AdminRestaurantsDto })
  async list(@Query() query: AdminRestaurantsQueryDto) {
    return { restaurants: await this.merchants.restaurantIds(query.cityId) };
  }

  @Get(':restaurantId/images')
  @RequireAnyPermission('restaurants.read', 'restaurants.menus')
  @ZodResponse({ status: 200, type: AdminRestaurantImagesDto })
  async images(@Param() params: AdminRestaurantParamsDto) {
    const restaurant = await this.merchants.restaurant(params.restaurantId);
    if (restaurant === null) {
      throw new NotFoundException({
        statusCode: HttpStatus.NOT_FOUND,
        error: 'unknown_restaurant',
      });
    }
    const menu = await this.merchants.menu(params.restaurantId);
    return {
      logoKey: restaurant.logoKey,
      coverKey: restaurant.coverKey,
      categories: menu.categories.map((category) => ({
        id: category.id,
        name: category.name,
        items: category.items.map((item) => ({
          id: item.id,
          name: item.name,
          photoKey: item.photoKey,
        })),
      })),
    };
  }

  @Put(':restaurantId/logo')
  @RequireAnyPermission(...RESTAURANT_PROFILE)
  @ZodResponse({ status: 200, type: AdminImageSetDto })
  async logo(
    @Param() params: AdminRestaurantParamsDto,
    @Body() body: AdminSetImageDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return this.setRestaurantImage('logo', params, body, session, request);
  }

  @Put(':restaurantId/cover')
  @RequireAnyPermission(...RESTAURANT_PROFILE)
  @ZodResponse({ status: 200, type: AdminImageSetDto })
  async cover(
    @Param() params: AdminRestaurantParamsDto,
    @Body() body: AdminSetImageDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return this.setRestaurantImage('cover', params, body, session, request);
  }

  @Put(':restaurantId/items/:itemId/photo')
  @RequirePermission('restaurants.menus')
  @ZodResponse({ status: 200, type: AdminImageSetDto })
  async itemPhoto(
    @Param() params: AdminItemParamsDto,
    @Body() body: AdminSetImageDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    try {
      const key = await this.merchants.setItemPhoto(
        params.restaurantId,
        params.itemId,
        body.uploadId,
        adminChange(session, request),
      );
      return { key };
    } catch (error) {
      refusalAsHttp(error);
    }
  }

  private async setRestaurantImage(
    image: 'logo' | 'cover',
    params: AdminRestaurantParamsDto,
    body: AdminSetImageDto,
    session: AdminSession,
    request: FastifyRequest,
  ) {
    try {
      const key = await this.merchants.setRestaurantImage(
        params.restaurantId,
        image,
        body.uploadId,
        adminChange(session, request),
      );
      return { key };
    } catch (error) {
      refusalAsHttp(error);
    }
  }
}
