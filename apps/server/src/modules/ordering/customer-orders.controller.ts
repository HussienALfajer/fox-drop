import {
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
import { AppSignedIn, CurrentAppSession } from '../../http/access.js';
import { Idempotent, IdempotencyKey } from '../../http/idempotency.js';
import { CustomerController } from '../../http/route-groups.js';
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
  cancellation: z
    .object({
      at: z.iso.datetime(),
      reason: z
        .string()
        .describe('merchant_auto_cancel: «لم يرد المطعم على طلبك، نعتذر» (CU §11.9).'),
    })
    .nullable()
    .describe('While cancelled (CU §11.9).'),
  restaurant: z.object({ id: z.uuid(), nameAr: z.string(), nameEn: z.string().nullable() }),
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
    }),
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

// CU §10.7: placing the order. A repeat of the command with its
// Idempotency-Key answers the order it placed. CU §4.3, §11: the order
// screen's reads, which the app fetches on opening, after every reconnect
// and every 30 seconds while the socket is down.
@CustomerController()
export class CustomerOrdersController {
  constructor(
    private readonly orders: OrdersService,
    private readonly merchants: MerchantsService,
  ) {}

  @Get('orders/active')
  @AppSignedIn()
  @ZodResponse({ status: 200, type: CustomerActiveOrdersDto })
  async active(@CurrentAppSession() session: AppSession) {
    const orders = await this.orders.customerActiveOrders(session.accountId);
    const names = await this.merchants.names([
      ...new Set(orders.map((order) => order.restaurantId)),
    ]);
    return { orders: orders.map((order) => orderBody(order, names)) };
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

  private async withNames(order: OrderView) {
    return orderBody(order, await this.merchants.names([order.restaurantId]));
  }
}

// What the customer sees of the order: never the commission or the
// captain's pay (CU §11.1).
function orderBody(
  order: OrderView,
  names: Map<string, { nameAr: string; nameEn: string | null }>,
) {
  const restaurant = names.get(order.restaurantId);
  if (!restaurant) throw new Error(`order ${order.id} has an unknown restaurant`);
  return {
    id: order.id,
    number: text(order.number),
    status: order.status,
    version: order.version,
    placedAt: order.placedAt.toISOString(),
    promisedAt: order.acceptance?.promisedAt.toISOString() ?? null,
    cancellation: order.cancellation && {
      at: order.cancellation.at.toISOString(),
      reason: order.cancellation.reason,
    },
    restaurant: { id: order.restaurantId, ...restaurant },
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
    payIn: order.payIn,
    note: order.note,
    estimate: order.estimate,
    address: order.address,
  };
}

const text = (value: bigint) => value.toString();
