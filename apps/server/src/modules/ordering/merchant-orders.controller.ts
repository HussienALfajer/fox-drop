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
import { MerchantController } from '../../http/route-groups.js';
import { CaptainsService } from '../captains/index.js';
import { CustomersService } from '../customers/index.js';
import type { AppSession } from '../identity/index.js';
import { MerchantsService } from '../merchants/index.js';
import { minor } from './customer-quote.controller.js';
import { type MerchantCommand, OrderCommandRefusedError, OrderCommands } from './order-commands.js';
import type { OrderView } from './order-views.js';
import { OrdersService } from './orders.service.js';
import { captainTracks, orderStatuses } from './schema.js';

const boardOrder = z.object({
  id: z.uuid(),
  number: z.string().describe('Shown as #10423 (AP §4.8).'),
  status: z.enum(orderStatuses).describe('AP §8.1; the board column (RA §8.1–8.2).'),
  version: z
    .int()
    .describe(
      'Increases with every change (architecture §5.3); ignore a real-time event not newer than the version shown (RA §4.3).',
    ),
  placedAt: z.iso.datetime(),
  acceptAlertAt: z.iso
    .datetime()
    .nullable()
    .describe(
      'While placed from then: the card turns red and the prompt adds «تأخرتم في الرد — سيتصل بكم فريق العمليات» (RA §8.2–8.3).',
    ),
  autoCancelAt: z.iso
    .datetime()
    .nullable()
    .describe('«يُلغى تلقائياً خلال {د:ث}» counts down to it while placed (RA §8.3).'),
  acceptance: z
    .object({
      at: z.iso.datetime(),
      prepMin: z.int().describe('The prep time chosen (RA §8.5).'),
      prepDueAt: z.iso
        .datetime()
        .describe(
          'While accepted, the prep countdown runs to it; past it the card turns red and counts up, «متأخر {د} د» (RA §8.7).',
        ),
      deviceName: z
        .string()
        .nullable()
        .describe(
          '«قُبل الطلب من جهاز {اسم الجهاز}» (RA §4.7); null when not accepted on a named device of the restaurant.',
        ),
    })
    .nullable()
    .describe('Null until the order is accepted.'),
  readyAt: z.iso.datetime().nullable().describe('«الطلب جاهز» (RA §8.8).'),
  customer: z
    .object({
      firstName: z
        .string()
        .nullable()
        .describe('Null while the customer has not completed the account (CU §5.3).'),
      neighbourhood: z.string(),
    })
    .describe('Never the phone number, the last name or the full address (RA §8.4).'),
  note: z.string().nullable().describe("The customer's note."),
  lines: z.array(
    z.object({
      name: z.string(),
      quantity: z.int(),
      options: z.array(z.object({ name: z.string() })),
      note: z.string().nullable(),
      lineTotal: minor,
    }),
  ),
  currency: z.string().length(3),
  itemsValue: minor.describe(
    '«قيمة الأصناف — يدفعها لك الكابتن نقداً عند الاستلام» (RA §8.4); the delivery fee and the customer total are never shown (R11).',
  ),
  captainTrack: z
    .enum(captainTracks)
    .nullable()
    .describe(
      'The captain line (RA §8.1): searching or offered «بانتظار كابتن», assigned «الكابتن {الاسم} في الطريق»; null before the search starts.',
    ),
  captain: z
    .object({
      firstName: z.string(),
      vehicle: z.enum(['walking', 'bicycle', 'motorbike', 'car']),
    })
    .nullable()
    .describe('From assignment (RA §8.9); the photo and the ETA come with their slices.'),
  captainArrival: z
    .object({
      at: z.iso
        .datetime()
        .describe('«وصل الكابتن {الاسم} لاستلام الطلب #{رقم}»; the waiting timer counts from it.'),
      waitingAlertAt: z.iso
        .datetime()
        .describe(
          'Not picked up by then: every device chimes «الكابتن ينتظر الطلب #{رقم} منذ {د} دقائق» (RA §8.9).',
        ),
    })
    .nullable()
    .describe('While the captain waits at the restaurant (RA §8.9), else null.'),
});

class MerchantOrdersDto extends createZodDto(
  z.object({
    orders: z
      .array(boardOrder)
      .describe('Every order until it is delivered or ends, oldest first (RA §8.2).'),
    prepTime: z
      .object({
        options: z.array(z.int()).describe('The chips (merchant.prep_time_options).'),
        stepMin: z.int().describe('The «−» and «+» step.'),
        floorMin: z.int(),
        ceilingMin: z.int(),
        defaultMin: z
          .int()
          .describe(
            'Preselected: the default prep time plus the busy-mode minutes while busy mode is on, «قبول — {د} د».',
          ),
      })
      .describe("The accept prompt's prep-time chooser (RA §8.5)."),
  }),
) {}

class MerchantOrderDto extends createZodDto(z.object({ order: boardOrder })) {}

class MerchantOrderParamsDto extends createZodDto(z.object({ orderId: z.uuid() })) {}

class MerchantAcceptDto extends createZodDto(
  z.object({
    prepMin: z
      .int()
      .describe(
        'Whole minutes from merchant.prep_time_floor_min to merchant.prep_time_ceiling_min (RA §8.5); 400 invalid_prep_time otherwise.',
      ),
  }),
) {}

// RA §8.2–8.8, §18, §4.3: the board's orders, which the restaurant app
// fetches on opening and after every reconnect before it shows them, and the
// commands on them, for owners and cashiers alike. A terminated restaurant's
// owners keep only the money section (RA §5.5).
@MerchantController()
export class MerchantOrdersController {
  constructor(
    private readonly orders: OrdersService,
    private readonly commands: OrderCommands,
    private readonly merchants: MerchantsService,
    private readonly customers: CustomersService,
    private readonly captains: CaptainsService,
  ) {}

  @Get('orders')
  @AppSignedIn()
  @ZodResponse({ status: 200, type: MerchantOrdersDto })
  async board(@CurrentAppSession() session: AppSession) {
    const restaurantId = await this.restaurantOf(session);
    const [orders, prepTime] = await Promise.all([
      this.orders.restaurantActiveOrders(restaurantId),
      this.commands.prepTimeChooser(restaurantId, new Date()),
    ]);
    return { orders: await this.boardOrders(restaurantId, orders), prepTime };
  }

  // RA §8.5: «قبول — {د} د». 409 order_state_changed with the order as it is
  // now, accepted from another device or cancelled first (RA §4.7); 404
  // unknown_order; 400 invalid_prep_time; 422 idempotency_key_reused.
  @Post('orders/:orderId/accept')
  @AppSignedIn()
  @Idempotent()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: MerchantOrderDto })
  async accept(
    @CurrentAppSession() session: AppSession,
    @IdempotencyKey() idempotencyKey: string,
    @Param() params: MerchantOrderParamsDto,
    @Body() body: MerchantAcceptDto,
  ) {
    const command = await this.command(session, idempotencyKey, params.orderId);
    return this.answer(command.restaurantId, () =>
      this.commands.accept({ ...command, prepMin: body.prepMin }, new Date()),
    );
  }

  // RA §8.8: «الطلب جاهز», with no undo. 409 order_state_changed with the
  // order as it is now; 404 unknown_order; 422 idempotency_key_reused.
  @Post('orders/:orderId/ready')
  @AppSignedIn()
  @Idempotent()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: MerchantOrderDto })
  async ready(
    @CurrentAppSession() session: AppSession,
    @IdempotencyKey() idempotencyKey: string,
    @Param() params: MerchantOrderParamsDto,
  ) {
    const command = await this.command(session, idempotencyKey, params.orderId);
    return this.answer(command.restaurantId, () => this.commands.ready(command, new Date()));
  }

  private async command(
    session: AppSession,
    idempotencyKey: string,
    orderId: string,
  ): Promise<MerchantCommand> {
    return {
      restaurantId: await this.restaurantOf(session),
      accountId: session.accountId,
      deviceId: session.deviceId,
      idempotencyKey,
      orderId,
    };
  }

  private async answer(restaurantId: string, run: () => Promise<OrderView>) {
    try {
      const [order] = await this.boardOrders(restaurantId, [await run()]);
      return { order: order! };
    } catch (error) {
      if (!(error instanceof OrderCommandRefusedError)) throw error;
      const { refusal } = error;
      if (refusal === 'unknown_order') {
        throw new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, error: refusal });
      }
      if (refusal === 'invalid_prep_time') {
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
      const [order] = await this.boardOrders(restaurantId, [error.order!]);
      throw new ConflictException({ statusCode: HttpStatus.CONFLICT, error: refusal, order });
    }
  }

  // The signed-in user's restaurant, refused once terminated (RA §5.5).
  private async restaurantOf(session: AppSession): Promise<string> {
    if (!session.merchant) throw new Error('a merchant route without a restaurant user');
    const { restaurantId } = session.merchant;
    if ((await this.merchants.accountStatus(restaurantId)) === 'terminated') {
      throw new ForbiddenException({
        statusCode: HttpStatus.FORBIDDEN,
        error: 'restaurant_terminated',
      });
    }
    return restaurantId;
  }

  // What the restaurant sees of its orders (RA §8.4): never the delivery fee,
  // the total, the address, a phone, the promised time or operations' alert
  // moments.
  private async boardOrders(restaurantId: string, orders: OrderView[]) {
    const captainIds = [...new Set(orders.flatMap((order) => order.captainId ?? []))];
    const now = new Date();
    const captains = new Map(
      (await Promise.all(captainIds.map((id) => this.captains.captain(id, now)))).flatMap(
        (captain) => (captain ? [[captain.id, captain] as const] : []),
      ),
    );
    const [firstNames, deviceNames] = await Promise.all([
      this.customers.firstNames([...new Set(orders.map((order) => order.customerAccountId))]),
      this.merchants.deviceNames(restaurantId, [
        ...new Set(orders.flatMap((order) => order.acceptance?.device ?? [])),
      ]),
    ]);
    return orders.map((order) => ({
      id: order.id,
      number: order.number.toString(),
      status: order.status,
      version: order.version,
      placedAt: order.placedAt.toISOString(),
      acceptAlertAt: order.acceptAlertAt?.toISOString() ?? null,
      autoCancelAt: order.autoCancelAt?.toISOString() ?? null,
      acceptance: order.acceptance && {
        at: order.acceptance.at.toISOString(),
        prepMin: order.acceptance.prepMin,
        prepDueAt: new Date(
          order.acceptance.at.getTime() + order.acceptance.prepMin * 60_000,
        ).toISOString(),
        deviceName:
          order.acceptance.device === null
            ? null
            : (deviceNames.get(order.acceptance.device) ?? null),
      },
      readyAt: order.readyAt?.toISOString() ?? null,
      customer: {
        firstName: firstNames.get(order.customerAccountId) ?? null,
        neighbourhood: order.address.neighbourhood,
      },
      note: order.note,
      lines: order.lines.map((line) => ({
        name: line.name,
        quantity: line.quantity,
        options: line.options.map((option) => ({ name: option.name })),
        note: line.note,
        lineTotal: line.lineTotal.toString(),
      })),
      currency: order.currency,
      itemsValue: order.money.itemsValue.toString(),
      captainTrack: order.captainTrack,
      captain: captainLine(order.captainId === null ? undefined : captains.get(order.captainId)),
      // RA §8.9: only while the captain waits at the restaurant, so the app
      // never chimes after pickup.
      captainArrival:
        order.captainArrival &&
        (order.captainTrack === 'at_merchant' || order.captainTrack === 'pickup_pending')
          ? {
              at: order.captainArrival.at.toISOString(),
              waitingAlertAt: order.captainArrival.waitingAlertAt.toISOString(),
            }
          : null,
    }));
  }
}

// RA §8.9: the captain's first name and vehicle, never the phone number.
function captainLine(
  captain: { name: string; vehicle: 'walking' | 'bicycle' | 'motorbike' | 'car' } | undefined,
) {
  return captain ? { firstName: captain.name.split(' ')[0]!, vehicle: captain.vehicle } : null;
}
