import {
  Body,
  Get,
  HttpCode,
  HttpStatus,
  NotFoundException,
  Param,
  Post,
  Req,
} from '@nestjs/common';
import { Inject } from '@nestjs/common';
import type { FastifyRequest } from 'fastify';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { CurrentAdminSession, RequirePermission } from '../../http/access.js';
import { Idempotent, IdempotencyKey } from '../../http/idempotency.js';
import { AdminController } from '../../http/route-groups.js';
import type { AdminSession } from '../identity/index.js';
import {
  openTicketFields,
  SupportService,
  ticketAdminOf,
  ticketAnswered,
  ticketBody,
  ticketOut,
} from '../support/index.js';
import { UNTIL_ENDED } from './active-orders.js';
import { lockOrder } from './order-events.js';
import { orders } from './schema.js';
import { eq } from 'drizzle-orm';

class AdminOrderTicketParamsDto extends createZodDto(z.object({ orderId: z.uuid() })) {}

class AdminOrderTicketsDto extends createZodDto(
  z.object({ tickets: z.array(ticketBody).describe('Newest first.') }),
) {}

class AdminOpenOrderTicketDto extends createZodDto(z.object(openTicketFields)) {}

class AdminOrderTicketDto extends createZodDto(ticketBody) {}

// AP §9.3.1 «tickets linked» and §9.3.2 «فتح تذكرة» (slice 2.23a): an
// order's tickets, and «تذكرة يدوية» on it for OWN, OPS and SUP, the party
// taken from the order. The ticket is opened under the order's lock, so it
// is urgent exactly when the order is still active.
@AdminController('orders')
export class AdminOrderTicketsController {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly support: SupportService,
  ) {}

  @Get(':orderId/tickets')
  @RequirePermission('support.read')
  @ZodResponse({ status: 200, type: AdminOrderTicketsDto })
  async list(@Param() params: AdminOrderTicketParamsDto) {
    const rows = await this.support.forOrder(params.orderId);
    return { tickets: rows.map(ticketOut) } as AdminOrderTicketsDto;
  }

  // 400 unknown_reason; 404 unknown_order; 409 no_captain (a captain's
  // ticket on an order without one); 422 idempotency_key_reused.
  @Post(':orderId/tickets')
  @RequirePermission('support.manage')
  @Idempotent()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: AdminOrderTicketDto })
  async open(
    @Param() params: AdminOrderTicketParamsDto,
    @Body() body: AdminOpenOrderTicketDto,
    @IdempotencyKey() idempotencyKey: string,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    const [placed] = await this.database.db
      .select({ placedAt: orders.placedAt, cityId: orders.cityId })
      .from(orders)
      .where(eq(orders.id, params.orderId));
    if (!placed) throw unknownOrder();
    const now = new Date();
    const ticket = await ticketAnswered(async () => {
      const prepared = await this.support.prepare({
        ...body,
        cityId: placed.cityId,
        partyId: null,
      });
      const id = await this.database.db.transaction(async (tx) => {
        const order = await lockOrder(tx, params.orderId, placed.placedAt);
        if (!order) throw unknownOrder();
        return this.support.openIn(
          tx,
          prepared,
          {
            id: order.id,
            cityId: order.cityId,
            number: order.number,
            active: UNTIL_ENDED.includes(order.status),
            customerId: order.customerAccountId,
            restaurantId: order.restaurantId,
            captainId: order.captainId,
          },
          ticketAdminOf(session, request),
          idempotencyKey,
          now,
        );
      });
      return this.support.ticket(placed.cityId, id);
    });
    return ticketOut(ticket) as AdminOrderTicketDto;
  }
}

function unknownOrder(): NotFoundException {
  return new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, error: 'unknown_order' });
}
