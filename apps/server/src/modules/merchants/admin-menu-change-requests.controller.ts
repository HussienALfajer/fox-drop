import {
  BadRequestException,
  Body,
  ConflictException,
  ForbiddenException,
  Get,
  HttpCode,
  HttpStatus,
  NotFoundException,
  Param,
  Post,
  Query,
  Req,
} from '@nestjs/common';
import type { FastifyRequest } from 'fastify';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { CurrentAdminSession, RequirePermission } from '../../http/access.js';
import { requestContext } from '../../http/request-context.js';
import { AdminController } from '../../http/route-groups.js';
import type { AdminSession } from '../identity/index.js';
import {
  type ChangeValues,
  ChangeRequestsService,
  changeFields,
  type QueuedRequest,
  REJECTION_REASON_MAX,
} from './change-requests.service.js';
import { MENU_DESCRIPTION_MAX, MENU_NAME_MAX } from './menu-editor.service.js';
import { type MerchantChange, MerchantsRefusedError, type Money } from './merchants.service.js';
import { changeRequestTargets } from './schema.js';

const money = z
  .object({
    amount: z.string().regex(/^\d+$/).describe('Integer minor units (AP §8.6).'),
    currency: z.string().length(3),
  })
  .meta({ id: 'AdminChangeMoney' });

const queuedRequest = z.object({
  id: z.uuid(),
  restaurantId: z.uuid(),
  restaurantName: z.string(),
  targetType: z.enum(changeRequestTargets),
  targetId: z.uuid(),
  field: z
    .enum(changeFields)
    .describe('`created`: a new row; otherwise the field the restaurant asks to change.'),
  targetName: z.string().describe("The row's name as the restaurant knows it."),
  createdAt: z.iso.datetime().describe('Its age: SHOULD be reviewed within 24 hours (RA §9.5).'),
});
const queuedRow = queuedRequest.meta({ id: 'AdminChangeRequestRow' });
const changeOption = z
  .object({ id: z.uuid(), name: z.string(), priceDelta: money })
  .meta({ id: 'AdminChangeOption' });

const changeValues = z
  .object({
    name: z.string().nullable(),
    description: z.string().nullable(),
    photoKey: z.string().nullable().describe('In public-media, shown through /media/.'),
    price: money.nullable().describe("A new item's price, a new option's delta."),
    categoryId: z.uuid().nullable(),
    groupId: z.uuid().nullable(),
    minChoices: z.int().nullable(),
    maxChoices: z.int().nullable(),
    itemIds: z.array(z.uuid()).nullable(),
    options: z.array(changeOption).nullable(),
  })
  .meta({ id: 'AdminChangeValues' });

class AdminChangeRequestsQueryDto extends createZodDto(z.object({ cityId: z.uuid() })) {}
class AdminChangeRequestParamsDto extends createZodDto(z.object({ requestId: z.uuid() })) {}

class AdminChangeRequestsDto extends createZodDto(
  z.object({ requests: z.array(queuedRow).describe('Oldest first (AP §9.6.7).') }),
) {}

class AdminChangeRequestDto extends createZodDto(
  queuedRequest.extend({
    status: z.enum(['pending', 'approved', 'rejected', 'withdrawn']),
    updatedAt: z.iso
      .datetime()
      .describe("The request's version, sent back with «قبول» (409 request_changed)."),
    before: changeValues.nullable().describe('Null for a new row.'),
    after: changeValues,
    parentName: z.string().nullable().describe("An item's category, an option's group."),
    item: z
      .object({
        name: z.string(),
        description: z.string().nullable(),
        photoKey: z.string().nullable(),
        price: money,
      })
      .meta({ id: 'AdminChangeItem' })
      .nullable()
      .describe('The item as customers see it now, for the customer preview.'),
    itemNames: z.array(
      z.object({ id: z.uuid(), name: z.string() }).meta({ id: 'AdminChangeItemName' }),
    ),
  }),
) {}

class AdminChangeApproveDto extends createZodDto(
  z.object({
    seen: z.iso.datetime().describe("The `updatedAt` of the request's view the reviewer saw."),
    name: z
      .string()
      .max(MENU_NAME_MAX)
      .optional()
      .describe("The reviewer's correction of the name asked (RA §9.5)."),
    description: z.string().max(MENU_DESCRIPTION_MAX).nullable().optional(),
  }),
) {}

class AdminChangeRejectDto extends createZodDto(
  z.object({
    reason: z.string().max(REJECTION_REASON_MAX).describe('Required; the restaurant sees it.'),
  }),
) {}

class AdminChangeDecidedDto extends createZodDto(
  z.object({ status: z.enum(['approved', 'rejected']) }),
) {}

const moneyBody = (value: Money) => ({
  amount: value.amount.toString(),
  currency: value.currency,
});

function valuesBody(values: ChangeValues) {
  return {
    ...values,
    price: values.price === null ? null : moneyBody(values.price),
    options:
      values.options?.map((option) => ({ ...option, priceDelta: moneyBody(option.priceDelta) })) ??
      null,
  };
}

const queuedBody = (request: QueuedRequest) => ({
  ...request,
  createdAt: request.createdAt.toISOString(),
});

// AP §9.6.7 «طلبات تعديل القائمة» (slice 2.32b): OWN and OPS review the
// restaurants' requests (AP §6.2, `menus.review_change_requests`). Approving
// publishes at once, a text corrected first; rejecting needs a reason. A
// decision's repeat is refused (409 request_not_pending), so no route takes a
// key; «قبول» sends the version it saw. Refusals: 400 invalid_menu; 403
// restaurant_terminated; 404 unknown_change_request; 409
// request_not_pending, request_changed, category_pending, group_pending.
@AdminController('menu-change-requests')
export class AdminMenuChangeRequestsController {
  constructor(private readonly requests: ChangeRequestsService) {}

  @Get()
  @RequirePermission('menus.review_change_requests')
  @ZodResponse({ status: 200, type: AdminChangeRequestsDto })
  async queue(@Query() query: AdminChangeRequestsQueryDto) {
    return { requests: (await this.requests.queue(query.cityId)).map(queuedBody) };
  }

  @Get(':requestId')
  @RequirePermission('menus.review_change_requests')
  @ZodResponse({ status: 200, type: AdminChangeRequestDto })
  async view(@Param() params: AdminChangeRequestParamsDto) {
    const view = await refused(() => this.requests.view(params.requestId));
    return {
      ...queuedBody(view),
      status: view.status,
      updatedAt: view.updatedAt.toISOString(),
      before: view.before === null ? null : valuesBody(view.before),
      after: valuesBody(view.after),
      parentName: view.parentName,
      item: view.item === null ? null : { ...view.item, price: moneyBody(view.item.price) },
      itemNames: view.itemNames,
    };
  }

  @Post(':requestId/approve')
  @HttpCode(200)
  @RequirePermission('menus.review_change_requests')
  @ZodResponse({ status: 200, type: AdminChangeDecidedDto })
  async approve(
    @Param() params: AdminChangeRequestParamsDto,
    @Body() body: AdminChangeApproveDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    await refused(() =>
      this.requests.approve(
        params.requestId,
        { name: body.name, description: body.description },
        new Date(body.seen),
        adminChange(session, request),
      ),
    );
    return { status: 'approved' as const };
  }

  @Post(':requestId/reject')
  @HttpCode(200)
  @RequirePermission('menus.review_change_requests')
  @ZodResponse({ status: 200, type: AdminChangeDecidedDto })
  async reject(
    @Param() params: AdminChangeRequestParamsDto,
    @Body() body: AdminChangeRejectDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    await refused(() =>
      this.requests.reject(params.requestId, body.reason, adminChange(session, request)),
    );
    return { status: 'rejected' as const };
  }
}

function adminChange(session: AdminSession, request: FastifyRequest): MerchantChange {
  return {
    actor: { type: 'admin', id: session.accountId, role: session.roles.join(',') },
    context: requestContext(request),
  };
}

async function refused<T>(run: () => Promise<T>): Promise<T> {
  try {
    return await run();
  } catch (error) {
    if (!(error instanceof MerchantsRefusedError)) throw error;
    const body = { error: error.refusal };
    if (error.refusal === 'unknown_change_request') {
      throw new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, ...body });
    }
    if (error.refusal === 'invalid_menu') {
      throw new BadRequestException({ statusCode: HttpStatus.BAD_REQUEST, ...body });
    }
    if (error.refusal === 'restaurant_terminated') {
      throw new ForbiddenException({ statusCode: HttpStatus.FORBIDDEN, ...body });
    }
    throw new ConflictException({ statusCode: HttpStatus.CONFLICT, ...body });
  }
}
