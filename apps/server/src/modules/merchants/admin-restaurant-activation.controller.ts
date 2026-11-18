import {
  Body,
  ConflictException,
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
import { CurrentAdminSession, RequireAnyPermission, RequirePermission } from '../../http/access.js';
import { requestContext } from '../../http/request-context.js';
import { AdminController } from '../../http/route-groups.js';
import type { AdminSession } from '../identity/index.js';
import { checklistCodes, checklistStates } from './activation-checklist.js';
import { ActivationService } from './activation.service.js';
import { type MerchantChange, MerchantsRefusedError } from './merchants.service.js';

class AdminChecklistDto extends createZodDto(
  z.object({
    accountStatus: z.enum(['draft', 'test', 'active', 'suspended', 'terminated']),
    items: z
      .array(
        z.object({
          code: z.enum(checklistCodes),
          state: z
            .enum(checklistStates)
            .describe(
              "`waived`: the image rule under OWN's waiver; `not_available`: the device check, «غير متاح بعد» until 2.42, never blocking.",
            ),
        }),
      )
      .describe('AP §9.6.3 step 8, in order.'),
    canStartTest: z
      .boolean()
      .describe('«تشغيل الوضع التجريبي»: every item but the test order is met.'),
    canActivate: z.boolean().describe('«تفعيل وإظهار للزبائن»: every item is met.'),
    images: z.object({
      withPhoto: z.int(),
      total: z.int().describe('The visible items of the visible categories.'),
      requiredPct: z.int(),
    }),
    imagesWaiver: z
      .object({ at: z.iso.datetime(), by: z.uuid() })
      .nullable()
      .describe("OWN's waiver of the image rule; null without one."),
  }),
) {}

class AdminChecklistParamsDto extends createZodDto(z.object({ restaurantId: z.uuid() })) {}

class AdminImagesWaiverDto extends createZodDto(z.object({ waived: z.boolean() })) {}

function refusalAsHttp(error: unknown): never {
  if (error instanceof MerchantsRefusedError) {
    const body = { error: error.refusal };
    if (error.refusal === 'unknown_restaurant') {
      throw new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, ...body });
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

// The wizard's step 8 «المراجعة والتفعيل» (AP §9.6.3; slice 2.30b): the
// checklist, OWN's waiver of the image rule (restaurants.waive_menu_images),
// «تشغيل الوضع التجريبي» and «تفعيل وإظهار للزبائن» (restaurants.activate:
// OWN, OPS). Each sets a state to a value (a repeat answers the checklist as
// it is), so none takes an Idempotency-Key; each answers the checklist.
// Refusals: 404 unknown_restaurant; 409 checklist_incomplete,
// status_change_not_allowed (test mode from a draft only, activation from
// test mode only), menu_locked (a waiver past test mode).
@AdminController('restaurant-drafts')
export class AdminRestaurantActivationController {
  constructor(private readonly activation: ActivationService) {}

  @Get(':restaurantId/checklist')
  @RequireAnyPermission('restaurants.read', 'restaurants.create')
  @ZodResponse({ status: 200, type: AdminChecklistDto })
  async read(@Param() params: AdminChecklistParamsDto) {
    return this.answer(params.restaurantId);
  }

  @Put(':restaurantId/menu-images-waiver')
  @RequirePermission('restaurants.waive_menu_images')
  @ZodResponse({ status: 200, type: AdminChecklistDto })
  async waiver(
    @Param() params: AdminChecklistParamsDto,
    @Body() body: AdminImagesWaiverDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    try {
      await this.activation.setImagesWaiver(
        params.restaurantId,
        body.waived,
        adminChange(session, request),
      );
    } catch (error) {
      refusalAsHttp(error);
    }
    return this.answer(params.restaurantId);
  }

  @Post(':restaurantId/test-mode')
  @HttpCode(200)
  @RequirePermission('restaurants.activate')
  @ZodResponse({ status: 200, type: AdminChecklistDto })
  async testMode(
    @Param() params: AdminChecklistParamsDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    try {
      await this.activation.startTestMode(params.restaurantId, adminChange(session, request));
    } catch (error) {
      refusalAsHttp(error);
    }
    return this.answer(params.restaurantId);
  }

  @Post(':restaurantId/activate')
  @HttpCode(200)
  @RequirePermission('restaurants.activate')
  @ZodResponse({ status: 200, type: AdminChecklistDto })
  async activate(
    @Param() params: AdminChecklistParamsDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    try {
      await this.activation.activate(params.restaurantId, adminChange(session, request));
    } catch (error) {
      refusalAsHttp(error);
    }
    return this.answer(params.restaurantId);
  }

  private async answer(restaurantId: string) {
    const checklist = await this.activation.checklist(restaurantId);
    if (checklist === null) {
      throw new NotFoundException({
        statusCode: HttpStatus.NOT_FOUND,
        error: 'unknown_restaurant',
      });
    }
    return {
      ...checklist,
      imagesWaiver:
        checklist.imagesWaiver === null
          ? null
          : { at: checklist.imagesWaiver.at.toISOString(), by: checklist.imagesWaiver.by },
    };
  }
}
