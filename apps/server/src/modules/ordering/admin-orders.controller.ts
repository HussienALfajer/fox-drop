import {
  Body,
  ConflictException,
  Get,
  HttpCode,
  HttpStatus,
  NotFoundException,
  Param,
  Post,
  Query,
  Req,
  UnprocessableEntityException,
} from '@nestjs/common';
import type { FastifyRequest } from 'fastify';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { CurrentAdminSession, RequirePermission } from '../../http/access.js';
import { Idempotent, IdempotencyKey } from '../../http/idempotency.js';
import { requestContext } from '../../http/request-context.js';
import { AdminController } from '../../http/route-groups.js';
import { CustomersService } from '../customers/index.js';
import type { AdminSession } from '../identity/index.js';
import { CaptainOrderRefusedError, CaptainOrders } from './captain-orders.js';
import { minor } from './customer-quote.controller.js';
import { type OperationsOrder, OperationsViews } from './operations-views.js';
import { captainTracks, orderStatuses } from './schema.js';

const money = z.object({ amount: minor, currency: z.string().length(3) });
const alerts = z
  .array(
    z.enum([
      'restaurant_not_accepted',
      'prep_late',
      'no_captain',
      'no_captain_after_ready',
      'captain_waiting',
    ]),
  )
  .describe(
    'AP §9.1.3, §8.3, past their moment: «مطعم لم يقبل», «تحضير متأخر», «طلب بلا كابتن», no captain after ready, «كابتن ينتظر عند المطعم».',
  );

const card = z.object({
  id: z.uuid(),
  number: z.string().describe('Shown as #10423 (AP §4.8).'),
  status: z.enum(orderStatuses).describe('The board column (AP §9.2.1).'),
  version: z.int().describe('Increases with every change (architecture §5.3).'),
  placedAt: z.iso.datetime(),
  restaurant: z.object({ id: z.uuid(), name: z.string() }),
  neighbourhood: z.string(),
  statusSince: z.iso.datetime().describe('The time in the current state counts from it.'),
  limitAt: z.iso
    .datetime()
    .nullable()
    .describe(
      "The column's limit (AP §9.2.1): green before 80% of it, amber from 80%, red past it; null where it is not built yet.",
    ),
  captainTrack: z
    .enum(captainTracks)
    .nullable()
    .describe('AP §8.2; null before the search starts and before any offer.'),
  captain: z
    .object({ id: z.uuid(), name: z.string(), vehicle: z.string() })
    .nullable()
    .describe('Null shows a red «بلا كابتن».'),
  total: money.describe('The customer total in the base currency.'),
  badges: z.object({
    needsAssignment: z.boolean().describe('«بحاجة لتعيين» (AP §8.3).'),
    note: z.boolean().describe('«ملاحظة».'),
    newCustomer: z.boolean().describe('«زبون جديد»: no delivered order yet.'),
  }),
  moments: z
    .object({
      acceptAlertAt: z.iso.datetime().nullable(),
      prepLateAlertAt: z.iso.datetime().nullable(),
      searchStartedAt: z.iso.datetime().nullable(),
      searchAlertAt: z.iso.datetime().nullable(),
      noCaptainAlertAt: z.iso.datetime().nullable(),
      captainArrivedAt: z.iso.datetime().nullable().describe('«وصل الكابتن».'),
      captainWaitingAlertAt: z.iso.datetime().nullable(),
    })
    .describe("The alerts' moments, so the panel raises each when it passes."),
  alerts,
});

class AdminBoardQueryDto extends createZodDto(z.object({ cityId: z.uuid() })) {}

class AdminBoardDto extends createZodDto(
  z.object({ orders: z.array(card).describe('Every live order, oldest first.') }),
) {}

class AdminOrderParamsDto extends createZodDto(z.object({ orderId: z.uuid() })) {}

class AdminRecordArrivalDto extends createZodDto(
  z.object({ reason: z.string().trim().min(1).max(500).describe('Required (AP §9.3.2).') }),
) {}

class AdminOrderCardDto extends createZodDto(z.object({ order: card })) {}

class AdminOrderDto extends createZodDto(
  z.object({
    order: card.extend({
      promisedAt: z.iso.datetime().nullable(),
      acceptance: z
        .object({ at: z.iso.datetime(), prepMin: z.int(), prepDueAt: z.iso.datetime() })
        .nullable(),
      readyAt: z.iso.datetime().nullable(),
      cancellation: z.object({ at: z.iso.datetime(), reason: z.string() }).nullable(),
      customer: z
        .object({
          name: z.string().nullable().describe('Null before «أكمل بياناتك» (CU §5.3).'),
          address: z.object({
            location: z.object({ latitude: z.number(), longitude: z.number() }),
            neighbourhood: z.string(),
            street: z.string(),
            floor: z.string().nullable(),
            landmark: z.string(),
            directions: z.string().nullable(),
          }),
          recipientName: z.string().nullable(),
          payIn: z.string().nullable().describe('«سأدفع بـ».'),
        })
        .describe('The phone, masked and revealed with a log (AP §5.4), comes with its slice.'),
      note: z.string().nullable(),
      lines: z.array(
        z.object({
          name: z.string(),
          quantity: z.int(),
          options: z.array(z.object({ name: z.string(), priceDelta: minor })),
          note: z.string().nullable(),
          unitPrice: minor,
          lineTotal: minor,
        }),
      ),
      money: z.object({
        currency: z.string().length(3),
        itemsValue: minor,
        deliveryFee: minor,
        discount: minor,
        rounding: z.string().regex(/^-?\d+$/),
        total: minor,
        pickupPayment: minor.describe('Paid by the captain at pickup (D26: the items value).'),
      }),
      timeline: z.array(
        z.object({
          version: z.int(),
          at: z.iso.datetime(),
          type: z.string().nullable().describe('Such as order.accepted or order.offered.'),
          from: z.enum(orderStatuses).nullable(),
          to: z.enum(orderStatuses),
          actor: z.object({ type: z.string(), id: z.uuid().nullable() }),
          captainId: z.uuid().nullable().describe("The offer's captain, or the one assigned."),
          reason: z.string().nullable(),
        }),
      ),
    }),
  }),
) {}

function cardBody(item: OperationsOrder) {
  const { order } = item;
  const at = (moment: Date | null) => moment?.toISOString() ?? null;
  return {
    id: order.id,
    number: order.number.toString(),
    status: order.status,
    version: order.version,
    placedAt: order.placedAt.toISOString(),
    restaurant: { id: order.restaurantId, name: item.restaurantName },
    neighbourhood: order.address.neighbourhood,
    statusSince: item.statusSince.toISOString(),
    limitAt: at(item.limitAt),
    captainTrack: item.captainTrack,
    captain: item.captain,
    total: { amount: order.money.total.toString(), currency: order.currency },
    badges: {
      needsAssignment: item.needsAssignment,
      note: order.note !== null,
      newCustomer: item.newCustomer,
    },
    moments: {
      acceptAlertAt: at(item.moments.acceptAlertAt),
      prepLateAlertAt: at(item.moments.prepLateAlertAt),
      searchStartedAt: at(item.moments.searchStartedAt),
      searchAlertAt: at(item.moments.searchAlertAt),
      noCaptainAlertAt: at(item.moments.noCaptainAlertAt),
      captainArrivedAt: at(item.moments.captainArrivedAt),
      captainWaitingAlertAt: at(item.moments.captainWaitingAlertAt),
    },
    alerts: item.alerts,
  };
}

// AP §9.2, §9.3.1: the operations room's board and an order's detail, for
// the roles that read operations (OWN, OPS, SUP).
@AdminController('orders')
export class AdminOrdersController {
  constructor(
    private readonly views: OperationsViews,
    private readonly customers: CustomersService,
    private readonly captainOrders: CaptainOrders,
  ) {}

  // AP §9.3.2 «تسجيل وصول الكابتن», for OWN and OPS when GPS fails at the
  // restaurant (CA §9.2): the assigned captain's track becomes at_merchant.
  // 409 order_state_changed with the order as it is now (no captain, already
  // arrived, picked up or ended); 404 unknown_order; 422
  // idempotency_key_reused.
  @Post(':orderId/record-arrival')
  @RequirePermission('operations.manage')
  @Idempotent()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: AdminOrderCardDto })
  async recordArrival(
    @Param() params: AdminOrderParamsDto,
    @Body() body: AdminRecordArrivalDto,
    @IdempotencyKey() idempotencyKey: string,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    try {
      await this.captainOrders.recordArrival(
        {
          orderId: params.orderId,
          admin: { accountId: session.accountId, roles: session.roles },
          context: requestContext(request),
          reason: body.reason,
          idempotencyKey,
        },
        new Date(),
      );
    } catch (error) {
      if (!(error instanceof CaptainOrderRefusedError)) throw error;
      if (error.refusal === 'unknown_order') {
        throw new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, error: error.refusal });
      }
      if (error.refusal === 'idempotency_key_reused') {
        throw new UnprocessableEntityException({
          statusCode: HttpStatus.UNPROCESSABLE_ENTITY,
          error: error.refusal,
        });
      }
      throw new ConflictException({
        statusCode: HttpStatus.CONFLICT,
        error: error.refusal,
        order: await this.card(params.orderId),
      });
    }
    return { order: await this.card(params.orderId) };
  }

  private async card(orderId: string) {
    const item = await this.views.order(orderId, new Date());
    if (item === null) throw new Error(`order ${orderId} not found`);
    return cardBody(item);
  }

  @Get()
  @RequirePermission('operations.read')
  @ZodResponse({ status: 200, type: AdminBoardDto })
  async board(@Query() query: AdminBoardQueryDto) {
    return { orders: (await this.views.board(query.cityId, new Date())).map(cardBody) };
  }

  @Get(':orderId')
  @RequirePermission('operations.read')
  @ZodResponse({ status: 200, type: AdminOrderDto })
  async order(@Param() params: AdminOrderParamsDto) {
    const item = await this.views.order(params.orderId, new Date());
    if (item === null) {
      throw new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, error: 'unknown_order' });
    }
    const { order } = item;
    const [profile, timeline] = await Promise.all([
      this.customers.profile(order.customerAccountId),
      this.views.timeline(order),
    ]);
    const { acceptance } = order;
    return {
      order: {
        ...cardBody(item),
        promisedAt: acceptance?.promisedAt.toISOString() ?? null,
        acceptance: acceptance && {
          at: acceptance.at.toISOString(),
          prepMin: acceptance.prepMin,
          prepDueAt: new Date(acceptance.at.getTime() + acceptance.prepMin * 60_000).toISOString(),
        },
        readyAt: order.readyAt?.toISOString() ?? null,
        cancellation: order.cancellation && {
          at: order.cancellation.at.toISOString(),
          reason: order.cancellation.reason,
        },
        customer: {
          name: profile ? [profile.firstName, profile.lastName].filter(Boolean).join(' ') : null,
          address: {
            location: order.address.location,
            neighbourhood: order.address.neighbourhood,
            street: order.address.street,
            floor: order.address.floor,
            landmark: order.address.landmark,
            directions: order.address.directions,
          },
          recipientName: order.address.recipientName,
          payIn: order.payIn,
        },
        note: order.note,
        lines: order.lines.map((line) => ({
          name: line.name,
          quantity: line.quantity,
          options: line.options.map((option) => ({
            name: option.name,
            priceDelta: option.priceDelta.toString(),
          })),
          note: line.note,
          unitPrice: line.unitPrice.toString(),
          lineTotal: line.lineTotal.toString(),
        })),
        money: {
          currency: order.currency,
          itemsValue: order.money.itemsValue.toString(),
          deliveryFee: order.money.deliveryFee.toString(),
          discount: order.money.discount.toString(),
          rounding: order.money.rounding.toString(),
          total: order.money.total.toString(),
          pickupPayment: order.money.itemsValue.toString(),
        },
        timeline: timeline.map((event) => ({ ...event, at: event.at.toISOString() })),
      },
    };
  }
}
