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
  Req,
  UnprocessableEntityException,
} from '@nestjs/common';
import type { FastifyRequest } from 'fastify';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { CurrentAdminSession, RequirePermission } from '../../http/access.js';
import { Idempotent, IdempotencyKey } from '../../http/idempotency.js';
import { AdminController } from '../../http/route-groups.js';
import { ContentRefusedError, ContentService } from '../content/index.js';
import { type AdminSession, AdminSessionsService } from '../identity/index.js';
import {
  compensationAdminOf,
  compensationAdmins,
  compensationBody,
  type CompensationOrder,
  compensationOut,
  CompensationRefusedError,
  CompensationsService,
  compensationValue,
  compensationValueBody,
} from '../marketing/index.js';
import { OperationsViews } from './operations-views.js';

const minor = z.string().regex(/^\d{1,18}$/);

class AdminCompensationOrderParamsDto extends createZodDto(z.object({ orderId: z.uuid() })) {}

class AdminOrderCompensationsDto extends createZodDto(
  z.object({
    compensations: z.array(compensationBody).describe('Newest first.'),
    currency: z.string().length(3).describe("The order's currency, the codes' too."),
    capLeft: minor
      .nullable()
      .describe(
        "What the admin may still give on this order without OWN's approval; null for no cap (OWN).",
      ),
    canCompensate: z.boolean().describe('The session holds operations.compensate.'),
    reasons: z
      .array(z.object({ code: z.string(), label: z.string() }))
      .describe('The active «تعويض الزبون» reasons, in order; each takes an optional note.'),
  }),
) {}

class AdminCompensateDto extends createZodDto(
  z.object({
    value: compensationValueBody,
    reason: z.object({ code: z.string().min(1).max(60), note: z.string().max(300).nullable() }),
  }),
) {}

class AdminOrderCompensationDto extends createZodDto(compensationBody) {}

// AP §9.3.2 «تعويض الزبون», §6.4 (slice 2.22a): a next-order code for the
// order's customer, in any status, within the admin's cumulative cap for the
// order, or a request OWN decides in «طلبات الموافقة».
@AdminController('orders')
export class AdminOrderCompensationsController {
  constructor(
    private readonly views: OperationsViews,
    private readonly compensations: CompensationsService,
    private readonly content: ContentService,
    private readonly sessions: AdminSessionsService,
  ) {}

  @Get(':orderId/compensations')
  @RequirePermission('operations.read')
  @ZodResponse({ status: 200, type: AdminOrderCompensationsDto })
  async list(
    @Param() params: AdminCompensationOrderParamsDto,
    @CurrentAdminSession() session: AdminSession,
  ) {
    const order = await this.order(params.orderId);
    const [{ compensations, capLeft }, reasons] = await Promise.all([
      this.compensations.forOrder(order, session),
      this.content.reasonsOf('compensation'),
    ]);
    const names = await this.sessions.names(compensationAdmins(compensations));
    return {
      compensations: compensations.map((row) => compensationOut(row, names)),
      currency: order.currency,
      capLeft: capLeft?.toString() ?? null,
      canCompensate: session.permissions.includes('operations.compensate'),
      reasons: reasons.filter((each) => each.active).map(({ code, label }) => ({ code, label })),
    } as AdminOrderCompensationsDto;
  }

  // Issued at once within the cap (the customer gets the code and its push),
  // else waiting for OWN with the alert «طلب موافقة تعويض». 400
  // invalid_value, unknown_reason; 404 unknown_order; 409 no_base_currency,
  // currency_changed; 422 idempotency_key_reused.
  @Post(':orderId/compensations')
  @RequirePermission('operations.compensate')
  @Idempotent()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: AdminOrderCompensationDto })
  async compensate(
    @Param() params: AdminCompensationOrderParamsDto,
    @Body() body: AdminCompensateDto,
    @IdempotencyKey() idempotencyKey: string,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    const value = compensationValue(body.value);
    if (value === null) {
      throw new BadRequestException({ statusCode: HttpStatus.BAD_REQUEST, error: 'invalid_value' });
    }
    const order = await this.order(params.orderId);
    try {
      const row = await this.compensations.request(
        order,
        value,
        body.reason,
        compensationAdminOf(session, request),
        idempotencyKey,
        new Date(),
      );
      const names = await this.sessions.names(compensationAdmins([row]));
      return compensationOut(row, names) as AdminOrderCompensationDto;
    } catch (error) {
      if (error instanceof ContentRefusedError) {
        throw new BadRequestException({ statusCode: HttpStatus.BAD_REQUEST, error: error.refusal });
      }
      if (!(error instanceof CompensationRefusedError)) throw error;
      if (error.refusal === 'idempotency_key_reused') {
        throw new UnprocessableEntityException({
          statusCode: HttpStatus.UNPROCESSABLE_ENTITY,
          error: error.refusal,
        });
      }
      throw new ConflictException({ statusCode: HttpStatus.CONFLICT, error: error.refusal });
    }
  }

  private async order(orderId: string): Promise<CompensationOrder> {
    const item = await this.views.order(orderId, new Date());
    if (item === null) {
      throw new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, error: 'unknown_order' });
    }
    const { order } = item;
    return {
      id: order.id,
      cityId: order.cityId,
      number: order.number,
      customerAccountId: order.customerAccountId,
      total: order.money.total,
      currency: order.currency,
    };
  }
}
