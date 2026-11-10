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
  UnprocessableEntityException,
} from '@nestjs/common';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { GENERIC_CUSTOMER_TEXT, NOTE_MAX } from '../content/index.js';
import { AppSignedIn, CurrentAppSession } from '../../http/access.js';
import { Idempotent, IdempotencyKey } from '../../http/idempotency.js';
import { CustomerController } from '../../http/route-groups.js';
import { type Captain, CaptainsService } from '../captains/index.js';
import { unsavedAddressFields, withRecipient } from '../customers/index.js';
import type { AppSession } from '../identity/index.js';
import { MerchantsService } from '../merchants/index.js';
import {
  appVersion,
  cartLines,
  minor,
  noPhone,
  payInCurrency,
  quoteBody,
} from './customer-quote.controller.js';
import { OrderCommandRefusedError, OrderCommands } from './order-commands.js';
import type { OrderView } from './order-views.js';
import { OrderRefusedError, OrdersService } from './orders.service.js';
import { orderStatuses } from './schema.js';

class CustomerPlaceOrderDto extends createZodDto(
  z
    .object({
      restaurantId: z.uuid(),
      lines: cartLines,
      payIn: payInCurrency,
      appVersion,
      quoteVersion: z
        .string()
        .min(1)
        .max(64)
        .describe('The version of the quote the customer confirmed (CU §10.7).'),
      // The order keeps a copy of the address (Q6); its pin is the delivery
      // point. Exactly one of the two.
      addressId: z.uuid().nullable().describe('A saved address (CU §7.3), or null.'),
      unsavedAddress: withRecipient(unsavedAddressFields)
        .nullable()
        .describe('«التوصيل إلى موقعي الحالي»: an address for this order only (CU §7.4), or null.'),
      note: z
        .string()
        .trim()
        .min(1)
        .max(200)
        .refine(noPhone, 'no phone numbers in a note (Q25)')
        .nullable()
        .describe('To the restaurant and the captain, up to 200 characters; no phone number.'),
    })
    .refine((body) => (body.addressId === null) !== (body.unsavedAddress === null), {
      message: 'either a saved address or an unsaved one',
      path: ['addressId'],
    }),
) {}

const customerOrder = z.object({
  id: z.uuid(),
  number: z.string().describe('Shown as #10423 (AP §4.8).'),
  status: z.enum(orderStatuses).describe('AP §8.1.'),
  version: z
    .int()
    .describe(
      'Increases with every change (architecture §5.3); ignore a real-time event not newer than the version shown (RA §4.3).',
    ),
  placedAt: z.iso.datetime(),
  promisedAt: z.iso
    .datetime()
    .nullable()
    .describe(
      '«يصل حوالي {الساعة}» from acceptance (CU §11.1–11.2, docs/domain/03); null while placed, when the estimate range shows.',
    ),
  itemReport: z
    .object({ at: z.iso.datetime() })
    .nullable()
    .describe(
      'CU §11.6: the restaurant reported an item unavailable; the banner «المطعم أبلغ أن صنفاً في طلبك غير متوفر. سيتصل بك فريق FOX DROP الآن.» shows until the report is closed, withdrawn, or the order edited or cancelled. Null otherwise.',
    ),
  cancellation: z
    .object({
      at: z.iso.datetime(),
      reason: z.string().describe('The code, such as merchant_auto_cancel (CU §11.9).'),
      text: z
        .string()
        .describe(
          'What the customer sees (CU Appendix C), from Content as it was at the cancellation.',
        ),
      byCustomer: z
        .boolean()
        .describe(
          'The customer cancelled it themselves while placed: «ألغيت طلبك» instead of the text (CU §11.4, §11.9).',
        ),
    })
    .nullable()
    .describe('While cancelled (CU §11.9).'),
  rejection: z
    .object({
      at: z.iso.datetime(),
      reason: z
        .string()
        .describe('The code: item_unavailable, restaurant_closed or too_busy (RA §8.6).'),
      text: z
        .string()
        .describe(
          "After «نعتذر، لم يقبل المطعم طلبك»: the reason's customer text (CU Appendix C) as it was at the rejection, with the items filled in.",
        ),
      unavailableItemIds: z
        .array(z.uuid())
        .describe(
          '«اطلب بدون الأصناف غير المتوفرة» rebuilds the cart without these items (CU §11.9, Q22); empty for the other reasons.',
        ),
    })
    .nullable()
    .describe('While rejected (CU §11.9).'),
  delivery: z
    .object({
      at: z.iso.datetime().describe('«تم التسليم».'),
      received: z
        .array(z.object({ amount: minor, currency: z.string().length(3) }))
        .describe('«استلم الكابتن: {المبالغ}» (CU §11.8, Q23).'),
      change: z
        .array(z.object({ amount: minor, currency: z.string().length(3) }))
        .describe('«أعاد لك: {المبالغ}».'),
    })
    .nullable()
    .describe('Once delivered; the order screen opens the rating sheet (CU §12.1).'),
  restaurant: z.object({ id: z.uuid(), nameAr: z.string(), nameEn: z.string().nullable() }),
  captain: z
    .object({
      firstName: z.string(),
      vehicle: z
        .enum(['walking', 'bicycle', 'motorbike', 'car'])
        .describe('«سيراً على الأقدام», «دراجة», «دراجة نارية» or «سيارة» (CU §11.3).'),
      atRestaurant: z
        .boolean()
        .describe(
          'Before the pickup: «الكابتن {الاسم} وصل إلى المطعم», or «الكابتن يستلم طلبك الآن» once ready (CU §11.2).',
        ),
    })
    .nullable()
    .describe(
      'The captain card from assignment (CU §11.3, Q14): «الكابتن {الاسم} في طريقه إلى المطعم»; never the phone number or the captain track (CU §11.2). The photo comes with the object storage.',
    ),
  currency: z.string().length(3),
  money: z.object({
    itemsValue: minor,
    deliveryFee: minor,
    deliveryFree: z.boolean(),
    discount: minor,
    rounding: minor,
    total: minor,
  }),
  equivalents: z
    .array(z.object({ currency: z.string().length(3), amount: minor }))
    .describe("The total in the city's other currencies, by the order's own rates (CU §11.1)."),
  lines: z.array(
    z.object({
      itemId: z.uuid(),
      name: z.string(),
      quantity: z.int(),
      note: z.string().nullable(),
      options: z.array(z.object({ id: z.uuid(), name: z.string(), priceDelta: minor })),
      unitPrice: minor,
      lineTotal: minor,
      added: z.boolean().describe('Added by an edit of FOX DROP: marked «أُضيف» (CU §11.6).'),
      quantityBefore: z
        .int()
        .nullable()
        .describe('The quantity before an edit changed it, shown beside the new one (CU §11.6).'),
    }),
  ),
  removedLines: z
    .array(
      z.object({
        name: z.string(),
        quantity: z.int(),
        options: z.array(z.object({ name: z.string() })),
      }),
    )
    .describe('Lines an edit of FOX DROP removed, struck through as «حُذف» (CU §11.6).'),
  edited: z
    .boolean()
    .describe(
      'FOX DROP edited the order: the banner «عدّلت FOX DROP طلبك. المجموع الجديد: {المبلغ}» (CU §11.6).',
    ),
  payIn: z.string().length(3).nullable().describe('«سأدفع بـ»; null for «لم أحدد».'),
  note: z.string().nullable(),
  estimate: z
    .object({ fromMin: z.int(), toMin: z.int() })
    .describe('The range shown while placed (CU §11.1).'),
  address: z.object({
    location: z.object({ latitude: z.number(), longitude: z.number() }),
    neighbourhood: z.string().describe('«الحي» at placing.'),
    label: z.enum(['home', 'work', 'other']).nullable().describe('Null for an unsaved one.'),
    customLabel: z.string().nullable(),
    street: z.string(),
    floor: z.string().nullable(),
    landmark: z.string(),
    recipientName: z.string().nullable(),
    directions: z.string().nullable(),
  }),
});

class CustomerOrderDto extends createZodDto(z.object({ order: customerOrder })) {}

class CustomerActiveOrdersDto extends createZodDto(
  z.object({
    orders: z
      .array(customerOrder)
      .describe('Until each ends, newest first: the active-order bar (CU §6).'),
  }),
) {}

class CustomerOrderParamsDto extends createZodDto(z.object({ orderId: z.uuid() })) {}

class CustomerCancelOrderDto extends createZodDto(
  z.object({
    reason: z
      .string()
      .min(1)
      .max(64)
      .describe("A code of Content's customer_cancel list (AP Appendix B)."),
    note: z
      .string()
      .max(NOTE_MAX)
      .nullable()
      .describe('The optional text of «سبب آخر»; null for the other reasons.'),
  }),
) {}

// CU §10.7: placing the order. A repeat of the command with its
// Idempotency-Key answers the order it placed. CU §4.3, §11: the order
// screen's reads, which the app fetches on opening, after every reconnect
// and every 30 seconds while the socket is down.
@CustomerController()
export class CustomerOrdersController {
  constructor(
    private readonly orders: OrdersService,
    private readonly merchants: MerchantsService,
    private readonly captains: CaptainsService,
    private readonly commands: OrderCommands,
  ) {}

  @Get('orders/active')
  @AppSignedIn()
  @ZodResponse({ status: 200, type: CustomerActiveOrdersDto })
  async active(@CurrentAppSession() session: AppSession) {
    const orders = await this.orders.customerActiveOrders(session.accountId);
    const [names, captains] = await Promise.all([
      this.merchants.names([...new Set(orders.map((order) => order.restaurantId))]),
      this.captainsOf(orders),
    ]);
    return { orders: orders.map((order) => orderBody(order, names, captains)) };
  }

  // 404 unknown_order for another customer's order.
  @Get('orders/:orderId')
  @AppSignedIn()
  @ZodResponse({ status: 200, type: CustomerOrderDto })
  async order(@CurrentAppSession() session: AppSession, @Param() params: CustomerOrderParamsDto) {
    const order = await this.orders.customerOrder(session.accountId, params.orderId);
    if (!order) {
      throw new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, error: 'unknown_order' });
    }
    return { order: await this.withNames(order) };
  }

  // 409 quote_changed or order_blocked with the new quote, which shows the
  // restaurant busy or the customer at the limit (CU §5.5); 404 unknown_restaurant or
  // unknown_address; 409 outside_zones; 422 idempotency_key_reused.
  @Post('orders')
  @AppSignedIn()
  @Idempotent()
  @HttpCode(201)
  @ZodResponse({ status: 201, type: CustomerOrderDto })
  async place(
    @CurrentAppSession() session: AppSession,
    @IdempotencyKey() idempotencyKey: string,
    @Body() body: CustomerPlaceOrderDto,
  ) {
    try {
      const order = await this.orders.place(
        {
          accountId: session.accountId,
          idempotencyKey,
          quoteVersion: body.quoteVersion,
          request: {
            restaurantId: body.restaurantId,
            lines: body.lines.map((line) => ({
              ...line,
              knownUnitPrice: BigInt(line.knownUnitPrice),
            })),
            payIn: body.payIn,
            appVersion: body.appVersion,
          },
          address:
            body.addressId === null
              ? { fields: body.unsavedAddress! }
              : { addressId: body.addressId },
          note: body.note,
        },
        new Date(),
      );
      return { order: await this.withNames(order) };
    } catch (error) {
      if (!(error instanceof OrderRefusedError)) throw error;
      const { refusal, quote } = error;
      if (refusal === 'unknown_restaurant' || refusal === 'unknown_address') {
        throw new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, error: refusal });
      }
      if (refusal === 'idempotency_key_reused') {
        throw new UnprocessableEntityException({
          statusCode: HttpStatus.UNPROCESSABLE_ENTITY,
          error: refusal,
        });
      }
      throw new ConflictException({
        statusCode: HttpStatus.CONFLICT,
        error: refusal,
        ...(quote ? { quote: quoteBody(quote) } : {}),
      });
    }
  }

  // CU §11.4: «إلغاء الطلب» while the restaurant has not answered. 409
  // order_state_changed with the order as it is now: accepted in the
  // meantime, «قبل المطعم طلبك قبل لحظات. لإلغائه تواصل مع الدعم.»; 404
  // unknown_order; 400 unknown_reason, reason_note_required,
  // reason_note_not_allowed; 422 idempotency_key_reused.
  @Post('orders/:orderId/cancel')
  @AppSignedIn()
  @Idempotent()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: CustomerOrderDto })
  async cancel(
    @CurrentAppSession() session: AppSession,
    @IdempotencyKey() idempotencyKey: string,
    @Param() params: CustomerOrderParamsDto,
    @Body() body: CustomerCancelOrderDto,
  ) {
    try {
      const order = await this.commands.cancelByCustomer(
        {
          accountId: session.accountId,
          idempotencyKey,
          orderId: params.orderId,
          reason: body.reason,
          note: body.note,
        },
        new Date(),
      );
      return { order: await this.withNames(order) };
    } catch (error) {
      if (!(error instanceof OrderCommandRefusedError)) throw error;
      const { refusal } = error;
      if (refusal === 'unknown_order') {
        throw new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, error: refusal });
      }
      if (refusal === 'idempotency_key_reused') {
        throw new UnprocessableEntityException({
          statusCode: HttpStatus.UNPROCESSABLE_ENTITY,
          error: refusal,
        });
      }
      if (refusal === 'order_state_changed' && error.order !== null) {
        throw new ConflictException({
          statusCode: HttpStatus.CONFLICT,
          error: refusal,
          order: await this.withNames(error.order),
        });
      }
      throw new BadRequestException({
        statusCode: HttpStatus.BAD_REQUEST,
        error: refusal,
        message: error.message,
      });
    }
  }

  private async withNames(order: OrderView) {
    const [names, captains] = await Promise.all([
      this.merchants.names([order.restaurantId]),
      this.captainsOf([order]),
    ]);
    return orderBody(order, names, captains);
  }

  private async captainsOf(orders: OrderView[]): Promise<Map<string, Captain>> {
    const ids = [...new Set(orders.flatMap((order) => order.captainId ?? []))];
    const now = new Date();
    const found = await Promise.all(ids.map((id) => this.captains.captain(id, now)));
    return new Map(found.flatMap((captain) => (captain ? [[captain.id, captain] as const] : [])));
  }
}

// What the customer sees of the order: never the commission or the
// captain's pay (CU §11.1).
function orderBody(
  order: OrderView,
  names: Map<string, { nameAr: string; nameEn: string | null }>,
  captains: Map<string, Captain>,
) {
  const captain = order.captainId === null ? undefined : captains.get(order.captainId);
  const restaurant = names.get(order.restaurantId);
  if (!restaurant) throw new Error(`order ${order.id} has an unknown restaurant`);
  return {
    id: order.id,
    number: text(order.number),
    status: order.status,
    version: order.version,
    placedAt: order.placedAt.toISOString(),
    promisedAt: order.acceptance?.promisedAt.toISOString() ?? null,
    itemReport: order.itemReport && { at: order.itemReport.at.toISOString() },
    rejection: order.rejection && {
      at: order.rejection.at.toISOString(),
      reason: order.rejection.reason,
      text: order.rejection.customerText,
      unavailableItemIds: order.rejection.itemIds,
    },
    cancellation: order.cancellation && {
      at: order.cancellation.at.toISOString(),
      reason: order.cancellation.reason,
      text: order.cancellation.customerText ?? GENERIC_CUSTOMER_TEXT,
      byCustomer: order.cancellation.byCustomer,
    },
    delivery: order.delivery && {
      at: order.delivery.at.toISOString(),
      received: order.delivery.received.map((line) => ({
        amount: text(line.amount),
        currency: line.currency,
      })),
      change: order.delivery.change.map((line) => ({
        amount: text(line.amount),
        currency: line.currency,
      })),
    },
    restaurant: { id: order.restaurantId, ...restaurant },
    captain: captain
      ? {
          firstName: captain.name.split(' ')[0]!,
          vehicle: captain.vehicle,
          atRestaurant:
            order.captainTrack === 'at_merchant' || order.captainTrack === 'pickup_pending',
        }
      : null,
    currency: order.currency,
    money: {
      itemsValue: text(order.money.itemsValue),
      deliveryFee: text(order.money.deliveryFee),
      deliveryFree: order.deliveryFree,
      discount: text(order.money.discount),
      rounding: text(order.money.rounding),
      total: text(order.money.total),
    },
    equivalents: order.equivalents.map((entry) => ({
      currency: entry.currency,
      amount: text(entry.amount),
    })),
    lines: order.lines.map((line) => ({
      ...line,
      options: line.options.map((option) => ({ ...option, priceDelta: text(option.priceDelta) })),
      unitPrice: text(line.unitPrice),
      lineTotal: text(line.lineTotal),
    })),
    removedLines: order.removedLines,
    edited: order.edited,
    payIn: order.payIn,
    note: order.note,
    estimate: order.estimate,
    address: order.address,
  };
}

const text = (value: bigint) => value.toString();
