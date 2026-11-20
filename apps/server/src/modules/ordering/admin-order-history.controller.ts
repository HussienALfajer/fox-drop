import {
  BadRequestException,
  Body,
  ForbiddenException,
  HttpCode,
  HttpStatus,
  Post,
} from '@nestjs/common';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { CurrentAdminSession, RequirePermission } from '../../http/access.js';
import { AdminController } from '../../http/route-groups.js';
import { CaptainsService } from '../captains/index.js';
import type { AdminSession } from '../identity/index.js';
import { MerchantsService } from '../merchants/index.js';
import {
  ADMIN_HISTORY_PAGE,
  type HistoryFilterRefusal,
  orderHistoryFilterBody,
  OrderHistoryService,
} from './order-history.js';
import { orderOutcomes, orderStatuses, responsibleParties } from './schema.js';

// A page's cursor: the placing time and id of the page's last order.
const CURSOR = /^(\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3}Z)_([0-9a-f-]{36})$/;

class AdminOrderHistoryQueryDto extends createZodDto(
  orderHistoryFilterBody.extend({
    cursor: z
      .string()
      .regex(CURSOR)
      .refine((cursor) => !Number.isNaN(Date.parse(cursor.split('_')[0]!)), 'a real moment')
      .nullable()
      .describe('The `next` of the page before; null for the first page.'),
  }),
) {}

const minor = z.string().regex(/^\d{1,18}$/);

class AdminOrderHistoryDto extends createZodDto(
  z.object({
    orders: z
      .array(
        z.object({
          id: z.uuid(),
          number: z.string(),
          placedAt: z.iso.datetime(),
          restaurantId: z.uuid(),
          restaurantName: z.string(),
          neighbourhood: z.string().describe("The customer's neighbourhood at placing."),
          captainId: z.uuid().nullable(),
          captainName: z.string().nullable(),
          status: z.enum(orderStatuses),
          outcome: z.enum(orderOutcomes).nullable(),
          responsible: z.enum(responsibleParties).nullable(),
          total: z.object({ amount: minor, currency: z.string().length(3) }),
          deliveryMinutes: z
            .int()
            .nullable()
            .describe('From placing to delivery; null unless delivered.'),
          code: z.string().nullable(),
          testOrder: z.boolean(),
          redelivery: z.boolean(),
        }),
      )
      .describe('Newest first.'),
    next: z
      .string()
      .nullable()
      .describe(`The cursor of the next ${ADMIN_HISTORY_PAGE} orders; null at the end.`),
  }),
) {}

function historyRefusal(refusal: HistoryFilterRefusal): never {
  const body = (statusCode: number) => ({ statusCode, error: refusal, message: refusal });
  if (refusal === 'phone_not_allowed') throw new ForbiddenException(body(HttpStatus.FORBIDDEN));
  throw new BadRequestException(body(HttpStatus.BAD_REQUEST));
}

// AP §9.5 «سجل الطلبات» (slice 2.40): every order of the city, newest first,
// by the filters, a page of ADMIN_HISTORY_PAGE at a time (`order_history.read`:
// OWN, OPS, SUP, FIN). A read sent as a POST so a customer's phone never sits
// in a URL; no key. Each order opens the board's detail (AP §9.3.1).
@AdminController('order-history')
export class AdminOrderHistoryController {
  constructor(
    private readonly history: OrderHistoryService,
    private readonly merchants: MerchantsService,
    private readonly captains: CaptainsService,
  ) {}

  // 400 invalid_period, invalid_phone; 403 phone_not_allowed (a phone
  // without customers.reveal_phone).
  @Post()
  @RequirePermission('order_history.read')
  @HttpCode(200)
  @ZodResponse({ status: 200, type: AdminOrderHistoryDto })
  async read(
    @Body() body: AdminOrderHistoryQueryDto,
    @CurrentAdminSession() session: AdminSession,
  ) {
    const filter = await this.history.resolve(body, session.permissions);
    if (typeof filter === 'string') historyRefusal(filter);
    const match = body.cursor === null ? null : CURSOR.exec(body.cursor);
    const { rows, more } = await this.history.page(
      filter,
      match ? { placedAt: new Date(match[1]!), id: match[2]! } : null,
    );
    const [restaurants, captains] = await Promise.all([
      this.merchants.names([...new Set(rows.map((row) => row.restaurantId))]),
      this.captains.names([
        ...new Set(rows.flatMap((row) => (row.captainId ? [row.captainId] : []))),
      ]),
    ]);
    const last = rows.at(-1);
    return {
      orders: rows.map((row) => ({
        id: row.id,
        number: row.number.toString(),
        placedAt: row.placedAt.toISOString(),
        restaurantId: row.restaurantId,
        restaurantName: restaurants.get(row.restaurantId)?.nameAr ?? '',
        neighbourhood: row.neighbourhood,
        captainId: row.captainId,
        captainName: row.captainId ? (captains.get(row.captainId) ?? null) : null,
        status: row.status,
        outcome: row.outcome,
        responsible: row.responsible,
        total: { amount: row.total.toString(), currency: row.currency },
        deliveryMinutes: row.deliveryMinutes,
        code: row.promoCode,
        testOrder: row.testOrder,
        redelivery: row.redelivery,
      })),
      next: more && last ? `${last.placedAt.toISOString()}_${last.id}` : null,
    };
  }
}
