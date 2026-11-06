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
  UnprocessableEntityException,
} from '@nestjs/common';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { AppSignedIn, CurrentAppSession } from '../../http/access.js';
import { Idempotent, IdempotencyKey } from '../../http/idempotency.js';
import { CaptainController } from '../../http/route-groups.js';
import type { AppSession } from '../identity/index.js';
import {
  type CaptainActiveOrder,
  CaptainOrderRefusedError,
  CaptainOrders,
  WEAK_GPS_METRES,
} from './captain-orders.js';
import { minor } from './customer-quote.controller.js';
import { captainTracks, orderStatuses } from './schema.js';

const money = z.object({ amount: minor, currency: z.string().length(3) });
const point = z.object({ latitude: z.number(), longitude: z.number() });

const activeOrder = z
  .object({
    id: z.uuid(),
    number: z.string().describe('Shown as #10423 (AP §4.8).'),
    status: z.enum(orderStatuses),
    version: z
      .int()
      .describe(
        'Increases with every change (architecture §5.3); ignore a real-time event not newer than the version shown.',
      ),
    captainTrack: z
      .enum(captainTracks)
      .describe(
        'The step (CA §9.1): assigned «إلى المطعم», at_merchant and pickup_pending «عند المطعم».',
      ),
    restaurant: z.object({
      name: z.string(),
      address: z.string().nullable(),
      phone: z.string().nullable().describe('«اتصال بالمطعم» opens the dialer with it.'),
      location: point.describe('On the map, with the route and «ابدأ الملاحة».'),
    }),
    preparation: z.object({
      ready: z.boolean().describe('«جاهز».'),
      readyAt: z.iso.datetime().nullable(),
      prepDueAt: z.iso
        .datetime()
        .describe('«قيد التحضير — جاهز بعد {د} د» counts to it while not ready.'),
    }),
    arrival: z
      .object({
        at: z.iso.datetime().describe('The waiting timer counts from it (CA §9.3).'),
      })
      .nullable()
      .describe('Null until «وصلت إلى المطعم».'),
    itemCount: z.int(),
    lines: z
      .array(
        z.object({
          name: z.string(),
          quantity: z.int(),
          options: z.array(z.object({ name: z.string() })),
          note: z.string().nullable(),
        }),
      )
      .describe('The item check (C7): one tick box per line.'),
    note: z.string().nullable().describe("The customer's note."),
    pickupPayment: money.describe('«تدفع للمطعم» (D26: the items value).'),
    collect: money.describe('«تقبض من الزبون».'),
  })
  .describe('The active order (CA §9); the customer block joins with the delivery slice.');

class CaptainActiveOrderDto extends createZodDto(
  z.object({ order: activeOrder.nullable().describe('Null without an active order.') }),
) {}

class CaptainOrderDto extends createZodDto(z.object({ order: activeOrder })) {}

class CaptainOrderParamsDto extends createZodDto(z.object({ orderId: z.uuid() })) {}

// CA §15: every command records the captain's location.
const commandLocation = z
  .object({
    latitude: z.number().min(-90).max(90),
    longitude: z.number().min(-180).max(180),
    accuracyMetres: z.number().min(0),
    recordedAt: z.iso.datetime(),
    simulated: z.boolean().describe('The device reports a mock location.'),
  })
  .describe('The latest GPS fix.');

class CaptainArriveDto extends createZodDto(z.object({ location: commandLocation })) {}

function activeOrderBody({ order, restaurant }: CaptainActiveOrder) {
  if (order.captainTrack === null) throw new Error(`order ${order.id} has no captain track`);
  if (order.acceptance === null) throw new Error(`order ${order.id} was never accepted`);
  const money = (amount: bigint) => ({ amount: amount.toString(), currency: order.currency });
  return {
    id: order.id,
    number: order.number.toString(),
    status: order.status,
    version: order.version,
    captainTrack: order.captainTrack,
    restaurant,
    preparation: {
      ready: order.readyAt !== null,
      readyAt: order.readyAt?.toISOString() ?? null,
      prepDueAt: new Date(
        order.acceptance.at.getTime() + order.acceptance.prepMin * 60_000,
      ).toISOString(),
    },
    arrival: order.captainArrival && { at: order.captainArrival.at.toISOString() },
    itemCount: order.lines.reduce((sum, line) => sum + line.quantity, 0),
    lines: order.lines.map((line) => ({
      name: line.name,
      quantity: line.quantity,
      options: line.options.map((option) => ({ name: option.name })),
      note: line.note,
    })),
    note: order.note,
    pickupPayment: money(order.money.itemsValue),
    collect: money(order.money.total),
  };
}

// CA §9, §15: the captain's active order and their commands on it.
@CaptainController('orders')
export class CaptainOrdersController {
  constructor(private readonly orders: CaptainOrders) {}

  // Fetched on opening and after every reconnect (CA §15), and when the
  // channel says the order was assigned.
  @Get('active')
  @AppSignedIn()
  @ZodResponse({ status: 200, type: CaptainActiveOrderDto })
  async active(@CurrentAppSession() session: AppSession) {
    const active = await this.orders.active(captainOf(session), new Date());
    return { order: active && activeOrderBody(active) };
  }

  // CA §9.2 «وصلت إلى المطعم». 409 too_far_from_restaurant with the distance
  // («اقترب من المطعم لتأكيد الوصول»), weak_location (worse than 100 m:
  // «إشارة الموقع ضعيفة — اتصل بالعمليات لتسجيل وصولك»),
  // simulated_location, stale_location (a fix older than a minute),
  // not_online, order_state_changed with the order as it
  // is now; 404 unknown_order; 400 invalid_location; 422
  // idempotency_key_reused.
  @Post(':orderId/arrive')
  @AppSignedIn()
  @Idempotent()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: CaptainOrderDto })
  async arrive(
    @CurrentAppSession() session: AppSession,
    @IdempotencyKey() idempotencyKey: string,
    @Param() params: CaptainOrderParamsDto,
    @Body() body: CaptainArriveDto,
  ) {
    const captainId = captainOf(session);
    return refusalsAsHttp(captainId, this.orders, async () => ({
      order: activeOrderBody(
        await this.orders.arrive(
          {
            orderId: params.orderId,
            captainId,
            accountId: session.accountId,
            deviceId: session.deviceId,
            idempotencyKey,
            location: { ...body.location, recordedAt: new Date(body.location.recordedAt) },
          },
          new Date(),
        ),
      ),
    }));
  }
}

// The refusals as HTTP answers; a state that changed answers the captain's
// order as it is now, or null once it is no longer theirs.
async function refusalsAsHttp<T>(
  captainId: string,
  orders: CaptainOrders,
  run: () => Promise<T>,
): Promise<T> {
  try {
    return await run();
  } catch (error) {
    if (!(error instanceof CaptainOrderRefusedError)) throw error;
    const { refusal } = error;
    if (refusal === 'unknown_order') {
      throw new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, error: refusal });
    }
    if (refusal === 'invalid_location') {
      throw new BadRequestException({
        statusCode: HttpStatus.BAD_REQUEST,
        error: refusal,
        message: error.message,
      });
    }
    if (refusal === 'idempotency_key_reused') {
      throw new UnprocessableEntityException({
        statusCode: HttpStatus.UNPROCESSABLE_ENTITY,
        error: refusal,
      });
    }
    if (refusal === 'order_state_changed') {
      const active = await orders.active(captainId, new Date());
      throw new ConflictException({
        statusCode: HttpStatus.CONFLICT,
        error: refusal,
        order: active && activeOrderBody(active),
      });
    }
    throw new ConflictException({
      statusCode: HttpStatus.CONFLICT,
      error: refusal,
      ...(refusal === 'too_far_from_restaurant' ? { distanceMetres: error.distanceMetres } : {}),
      ...(refusal === 'weak_location' ? { accuracyLimitMetres: WEAK_GPS_METRES } : {}),
    });
  }
}

function captainOf(session: AppSession): string {
  if (session.captain === null) throw new ForbiddenException();
  return session.captain.captainId;
}
