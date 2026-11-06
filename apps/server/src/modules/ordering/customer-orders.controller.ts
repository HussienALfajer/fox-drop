import {
  Body,
  ConflictException,
  HttpCode,
  HttpStatus,
  NotFoundException,
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
import {
  appVersion,
  cartLines,
  minor,
  noPhone,
  payInCurrency,
  quoteBody,
} from './customer-quote.controller.js';
import { OrderRefusedError, OrdersService, type PlacedOrder } from './orders.service.js';
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

class CustomerPlacedOrderDto extends createZodDto(
  z.object({
    order: z.object({
      id: z.uuid(),
      number: z.string().describe('Shown as #10423 (AP §4.8).'),
      status: z.enum(orderStatuses).describe('AP §8.1; placed when it was placed.'),
      placedAt: z.iso.datetime(),
      restaurantId: z.uuid(),
      currency: z.string().length(3),
      money: z.object({
        itemsValue: minor,
        deliveryFee: minor,
        deliveryFree: z.boolean(),
        discount: minor,
        rounding: minor,
        total: minor,
      }),
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
      estimate: z.object({ fromMin: z.int(), toMin: z.int() }),
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
    }),
  }),
) {}

// CU §10.7: placing the order. A repeat of the command with its
// Idempotency-Key answers the order it placed.
@CustomerController()
export class CustomerOrdersController {
  constructor(private readonly orders: OrdersService) {}

  // 409 quote_changed or order_blocked with the new quote, which shows the
  // restaurant busy or the customer at the limit (CU §5.5); 404 unknown_restaurant or
  // unknown_address; 409 outside_zones; 422 idempotency_key_reused.
  @Post('orders')
  @AppSignedIn()
  @Idempotent()
  @HttpCode(201)
  @ZodResponse({ status: 201, type: CustomerPlacedOrderDto })
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
      return { order: orderBody(order) };
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
}

const text = (value: bigint) => value.toString();

function orderBody({ deliveryFree, ...order }: PlacedOrder) {
  return {
    ...order,
    number: text(order.number),
    placedAt: order.placedAt.toISOString(),
    money: {
      itemsValue: text(order.money.itemsValue),
      deliveryFee: text(order.money.deliveryFee),
      deliveryFree,
      discount: text(order.money.discount),
      rounding: text(order.money.rounding),
      total: text(order.money.total),
    },
    lines: order.lines.map((line) => ({
      ...line,
      options: line.options.map((option) => ({ ...option, priceDelta: text(option.priceDelta) })),
      unitPrice: text(line.unitPrice),
      lineTotal: text(line.lineTotal),
    })),
  };
}
