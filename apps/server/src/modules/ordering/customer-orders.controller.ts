import {
  BadRequestException,
  Body,
  ConflictException,
  Get,
  HttpCode,
  Inject,
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
import { GENERIC_CUSTOMER_TEXT, NOTE_MAX } from '../content/index.js';
import { AppSignedIn, CurrentAppSession } from '../../http/access.js';
import { Idempotent, IdempotencyKey } from '../../http/idempotency.js';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { requestContext } from '../../http/request-context.js';
import { CustomerController } from '../../http/route-groups.js';
import { FilesRefusedError } from '../files/index.js';
import {
  type CustomerReport,
  type CustomerReportView,
  type ReportedOrder,
  SupportService,
  ticketAnswered,
} from '../support/index.js';
import { lockOrder } from './order-events.js';
import { type Captain, CaptainsService } from '../captains/index.js';
import { unsavedAddressFields, withRecipient } from '../customers/index.js';
import { type AppSession, CaptainAccountsService } from '../identity/index.js';
import { MerchantsService } from '../merchants/index.js';
import {
  appVersion,
  cartLines,
  minor,
  noPhone,
  payInCurrency,
  promoCodeInput,
  quoteBody,
} from './customer-quote.controller.js';
import { OrderCommandRefusedError, OrderCommands } from './order-commands.js';
import type { OrderView } from './order-views.js';
import { OrderRefusedError, OrdersService } from './orders.service.js';
import {
  type Compensation,
  CompensationsService,
  type LateCode,
  LateCodesService,
} from '../marketing/index.js';
import { orderStatuses } from './schema.js';

// A personal code with its value (CU §11.6, §11.9): a compensation's or the
// late code.
const personalCode = z.object({
  code: z.string(),
  kind: z.enum(['fixed_amount', 'percentage']),
  amount: z
    .object({ amount: z.string(), currency: z.string() })
    .nullable()
    .describe('A fixed amount; null for a percentage.'),
  percentBp: z.number().int().nullable().describe('A percentage in basis points.'),
  maxDiscount: z
    .object({ amount: z.string(), currency: z.string() })
    .nullable()
    .describe("A percentage's maximum; null for the late code's without one."),
  validTo: z.iso.datetime(),
});

class CustomerPlaceOrderDto extends createZodDto(
  z
    .object({
      restaurantId: z.uuid(),
      lines: cartLines,
      payIn: payInCurrency,
      appVersion,
      code: promoCodeInput,
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
  redeliveryOf: z
    .object({ orderId: z.uuid(), number: z.string() })
    .nullable()
    .describe(
      'CU §11.2: «إعادة توصيل مجانية لطلب #{رقم}» (AP §9.9.3): the order whose items it re-delivers; a total of 0, never cancelled or rated.',
    ),
  status: z.enum(orderStatuses).describe('AP §8.1.'),
  version: z
    .int()
    .describe(
      'Increases with every change (architecture §5.3); ignore a real-time event not newer than the version shown (RA §4.3).',
    ),
  placedAt: z.iso.datetime(),
  report: z
    .object({
      ticketId: z.uuid(),
      number: z.string().describe('«بلاغك T-{رقم}: {الحالة}» (CU §12.2).'),
      status: z
        .enum(['new', 'in_progress', 'waiting', 'resolved', 'closed'])
        .describe('AP Appendix C: «جديدة», «قيد المعالجة», «بانتظار رد», «محلولة», «مغلقة».'),
      message: z.string().nullable().describe('The resolution message, once resolved.'),
      resolvedAt: z.iso.datetime().nullable(),
    })
    .nullable()
    .describe(
      "CU §12.2, Q17 (slice 2.24a): the customer's one report on the order; null without one.",
    ),
  reportUntil: z.iso
    .datetime()
    .nullable()
    .describe(
      '«الإبلاغ عن مشكلة» until then, on a delivered order without a report (CU §12.2: customer.report_problem_window_hours after the delivery); null otherwise, when the detail offers «تواصل مع الدعم».',
    ),
  redeliveries: z
    .array(z.object({ orderId: z.uuid(), number: z.string() }))
    .describe('CU §12.3: the free re-deliveries placed for this order, newest first.'),
  lateCode: personalCode
    .extend({ issuedAt: z.iso.datetime() })
    .nullable()
    .describe(
      'CU §11.6, AP §8.3 (slice 2.22c): the late code the order earned, still not delivered at the promised time + order.delivery_late_compensation_min; it is also in «أكوادي». Null without one, and in the list of active orders.',
    ),
  promisedAt: z.iso
    .datetime()
    .nullable()
    .describe(
      '«يصل حوالي {الساعة}» from acceptance (CU §11.1–11.2, docs/domain/03); null while placed, when the estimate range shows.',
    ),
  doorPing: z
    .object({
      at: z.iso.datetime(),
      answer: z
        .enum(['coming', 'contacting_recipient'])
        .nullable()
        .describe(
          '«أنا قادم», or «سأتصل بالمستلم» for an order with a recipient; null unanswered.',
        ),
      answeredAt: z.iso.datetime().nullable(),
    })
    .nullable()
    .describe(
      "CU §11.7 (slice 2.13d): the captain's latest «تنبيه الزبون» while at the door. Unanswered and under 30 seconds old, the open app rings full screen «الكابتن عند الباب ويحاول الوصول إليك» (or «… إلى {المستلم}») with «أنا قادم» (or «سأتصل بالمستلم») and «اتصال بالكابتن». Null without one.",
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
      compensation: personalCode
        .nullable()
        .describe(
          "CU §11.9 (slice 2.22b): the compensation code given on this order, the latest issued, shown on «أُلغي طلبك»; it is also in «أكوادي». Null without one, and while OWN's approval waits.",
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
  outcome: z
    .object({
      at: z.iso.datetime(),
      outcome: z.enum(['free', 'fake', 'damaged', 'wrong_refused', 'failed_other']),
      status: z.enum(['delivered', 'failed']),
      text: z
        .string()
        .nullable()
        .describe('A failed order: «تعذّر التسليم» with this reason (CU §11.9, Appendix C).'),
      amountToCollect: z
        .object({ amount: minor, currency: z.string().length(3) })
        .describe('CU §11.6: «المبلغ المطلوب الآن: {المبلغ}», or «لن تدفع شيئاً لهذا الطلب» at 0.'),
      awaitingCollection: z
        .boolean()
        .describe(
          'The captain has yet to collect the amount (K9): the order is still on its way or at the door.',
        ),
    })
    .nullable()
    .describe('Once operations set an outcome other than normal (AP §8.9).'),
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
      phone: z
        .string()
        .nullable()
        .describe(
          '«اتصال بالكابتن» (CU §11.3, §11.7, U12): the number the button dials from the pickup until the order ends; the app never prints it. Null before and after.',
        ),
    })
    .nullable()
    .describe(
      'The captain card from assignment (CU §11.3, Q14): «الكابتن {الاسم} في طريقه إلى المطعم»; never the captain track (CU §11.2). The photo comes with the object storage.',
    ),
  currency: z.string().length(3),
  money: z.object({
    itemsValue: minor,
    deliveryFee: minor,
    deliveryFree: z.boolean(),
    discount: minor.describe('«الخصم»; 0 without a code.'),
    rounding: minor,
    total: minor,
  }),
  promoCode: z.string().nullable().describe('The code of «الخصم» (CU §10.4); null without one.'),
  equivalents: z
    .array(z.object({ currency: z.string().length(3), amount: minor }))
    .describe("The total in the city's other currencies, by the order's own rates (CU §11.1)."),
  lines: z.array(
    z.object({
      position: z.int().describe("The line's place in the order, for a report's items (CU §12.2)."),
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

class CustomerReportOrderDto extends createZodDto(
  z.object({
    typeCode: z
      .string()
      .min(1)
      .max(64)
      .describe("A code of Content's customer_problem list (AP Appendix B)."),
    note: z
      .string()
      .max(NOTE_MAX)
      .nullable()
      .describe('Optional, up to 300 characters; required for «أخرى» (CU §12.2).'),
    items: z
      .array(z.object({ position: z.int().min(0), quantity: z.int().min(1).max(99) }))
      .max(50)
      .describe(
        "The order's lines by position with how many: required for «صنف ناقص», «صنف خطأ» and «الطلب تالف», empty for the others.",
      ),
    photoUploadIds: z
      .array(z.uuid())
      .max(3)
      .describe('Up to 3 photos, each from POST /v1/customer/uploads/report-photo once uploaded.'),
  }),
) {}

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
    private readonly captainAccounts: CaptainAccountsService,
    private readonly compensations: CompensationsService,
    private readonly lateCodes: LateCodesService,
    private readonly support: SupportService,
    @Inject(DATABASE) private readonly database: Database,
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
            code: body.code,
            deviceId: session.deviceId,
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

  // CU §11.7, CA §9.9 (slice 2.13d): «أنا قادم», or «سأتصل بالمستلم» for an
  // order with a recipient, to the captain's latest ping; the captain hears a
  // chime. 409 order_state_changed with the order (no ping waiting: answered
  // from another device, or the captain left the door); 404 unknown_order;
  // 422 idempotency_key_reused.
  @Post('orders/:orderId/answer-ping')
  @AppSignedIn()
  @Idempotent()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: CustomerOrderDto })
  async answerPing(
    @CurrentAppSession() session: AppSession,
    @IdempotencyKey() idempotencyKey: string,
    @Param() params: CustomerOrderParamsDto,
  ) {
    try {
      const order = await this.commands.answerPing(
        { accountId: session.accountId, idempotencyKey, orderId: params.orderId },
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
      throw error;
    }
  }

  // CU §12.2, AP §9.9.1 (slice 2.24a): «الإبلاغ عن مشكلة» on a delivered
  // order within customer.report_problem_window_hours, once (Q17). Answers
  // the order with its `report`; the app says «استلمنا بلاغك T-{رقم}…».
  // 404 unknown_order; 409 report_closed, already_reported, upload_used;
  // 400 unknown_reason, reason_note_required, items_required,
  // invalid_items, too_many_photos and the photo's upload_not_found,
  // upload_expired, upload_missing, upload_invalid; 422
  // idempotency_key_reused.
  @Post('orders/:orderId/report')
  @AppSignedIn()
  @Idempotent()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: CustomerOrderDto })
  async report(
    @CurrentAppSession() session: AppSession,
    @IdempotencyKey() idempotencyKey: string,
    @Param() params: CustomerOrderParamsDto,
    @Body() body: CustomerReportOrderDto,
    @Req() request: FastifyRequest,
  ) {
    const order = await this.orders.customerOrder(session.accountId, params.orderId);
    if (!order) {
      throw new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, error: 'unknown_order' });
    }
    const report: CustomerReport = {
      typeCode: body.typeCode,
      note: body.note,
      items: body.items,
      photoUploadIds: body.photoUploadIds,
    };
    const now = new Date();
    const facts = async (status: string, deliveredAt: Date | null): Promise<ReportedOrder> => ({
      id: order.id,
      cityId: order.cityId,
      number: order.number,
      active: false,
      customerId: session.accountId,
      restaurantId: order.restaurantId,
      captainId: order.captainId,
      status,
      deliveredAt,
      lines: order.lines.map(({ position, name, quantity }) => ({ position, name, quantity })),
    });
    await reportAnswered(async () => {
      // A repeat answers the order before any refusal.
      const replayed = await this.support.replayed(
        session.accountId,
        idempotencyKey,
        this.support.reportHash(order.id, report),
      );
      if (replayed !== null) return;
      const ready = await this.support.prepareReport(
        await facts(order.status, await this.orders.deliveredAt(order.id, order.placedAt)),
        report,
        now,
      );
      await this.database.db.transaction(async (tx) => {
        const locked = await lockOrder(tx, order.id, order.placedAt);
        if (!locked) {
          throw new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, error: 'unknown_order' });
        }
        const deliveredAt = await this.orders.deliveredAt(order.id, order.placedAt, tx);
        await this.support.openReportIn(
          tx,
          ready,
          await facts(locked.status, deliveredAt),
          { accountId: session.accountId, context: requestContext(request) },
          idempotencyKey,
          now,
        );
      });
    });
    const after = await this.orders.customerOrder(session.accountId, order.id);
    return { order: await this.withNames(after!) };
  }

  private async withNames(order: OrderView) {
    const delivered = order.status === 'delivered';
    const [names, captains, compensation, lateCode, report, deliveredAt, redeliveries] =
      await Promise.all([
        this.merchants.names([order.restaurantId]),
        this.captainsOf([order]),
        order.cancellation === null ? null : this.compensations.issuedCode(order.id),
        order.acceptance === null ? null : this.lateCodes.forOrder(order.id),
        delivered ? this.support.reportOn(order.id) : null,
        delivered ? this.orders.deliveredAt(order.id, order.placedAt) : null,
        this.orders.redeliveriesOf(order.id),
      ]);
    const until =
      report === null
        ? await this.support.reportUntil({
            cityId: order.cityId,
            status: order.status,
            deliveredAt,
          })
        : null;
    return orderBody(order, names, captains, compensation, lateCode, {
      report,
      // Past its end the window is closed: the detail offers «تواصل مع الدعم».
      reportUntil: until !== null && until.getTime() > Date.now() ? until : null,
      redeliveries,
    });
  }

  // The captains of these orders; with their number once one of their orders
  // is picked up (CU §11.3, U12: «اتصال بالكابتن» until the order ends).
  private async captainsOf(orders: OrderView[]): Promise<Map<string, CardCaptain>> {
    const ids = [...new Set(orders.flatMap((order) => order.captainId ?? []))];
    const calling = new Set(
      orders.flatMap((order) =>
        order.captainId !== null && CALL_CAPTAIN.includes(order.status) ? [order.captainId] : [],
      ),
    );
    const now = new Date();
    const found = await Promise.all(
      ids.map(async (id) => {
        const [captain, phone] = await Promise.all([
          this.captains.captain(id, now),
          calling.has(id) ? this.captainAccounts.phone(id) : null,
        ]);
        return captain && { ...captain, phone };
      }),
    );
    return new Map(found.flatMap((captain) => (captain ? [[captain.id, captain] as const] : [])));
  }
}

// CU §11.3, U12: «اتصال بالكابتن» from the pickup until the order ends.
const CALL_CAPTAIN: readonly OrderView['status'][] = ['picked_up', 'arrived'];

type CardCaptain = Captain & { phone: string | null };

// What the customer sees of the order: never the commission or the
// captain's pay (CU §11.1).
function orderBody(
  order: OrderView,
  names: Map<string, { nameAr: string; nameEn: string | null }>,
  captains: Map<string, CardCaptain>,
  // CU §11.9: the compensation code on a cancelled order (slice 2.22b).
  compensation: Compensation | null = null,
  // CU §11.6: the order's late code (slice 2.22c).
  lateCode: LateCode | null = null,
  // CU §12.2, §12.3 (slice 2.24a): its report, the report's window and its
  // re-deliveries; the active orders' list reads none.
  after: {
    report: CustomerReportView | null;
    reportUntil: Date | null;
    redeliveries: { orderId: string; number: bigint }[];
  } = { report: null, reportUntil: null, redeliveries: [] },
) {
  const captain = order.captainId === null ? undefined : captains.get(order.captainId);
  const restaurant = names.get(order.restaurantId);
  if (!restaurant) throw new Error(`order ${order.id} has an unknown restaurant`);
  return {
    id: order.id,
    number: text(order.number),
    redeliveryOf:
      order.redelivery === null
        ? null
        : { orderId: order.redelivery.ofOrderId, number: text(order.redelivery.ofNumber) },
    status: order.status,
    version: order.version,
    placedAt: order.placedAt.toISOString(),
    report: after.report && {
      ticketId: after.report.ticketId,
      number: text(after.report.number),
      status: after.report.status,
      message: after.report.message,
      resolvedAt: after.report.resolvedAt?.toISOString() ?? null,
    },
    reportUntil: after.reportUntil?.toISOString() ?? null,
    redeliveries: after.redeliveries.map((each) => ({
      orderId: each.orderId,
      number: text(each.number),
    })),
    promisedAt: order.acceptance?.promisedAt.toISOString() ?? null,
    lateCode: lateCode && {
      ...personalCodeBody(lateCode),
      issuedAt: lateCode.issuedAt.toISOString(),
    },
    doorPing: order.doorPing && {
      at: order.doorPing.at.toISOString(),
      answer: order.doorPing.answer,
      answeredAt: order.doorPing.answeredAt?.toISOString() ?? null,
    },
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
      compensation:
        compensation === null || compensation.code === null
          ? null
          : personalCodeBody({
              ...compensation,
              code: compensation.code,
              validTo: compensation.codeValidTo!,
            }),
    },
    outcome: order.outcome && {
      at: order.outcome.at.toISOString(),
      outcome: order.outcome.outcome,
      status: order.outcome.status,
      text: order.outcome.customerText,
      amountToCollect: {
        amount: text(order.outcome.amountToCollect),
        currency: order.outcome.currency,
      },
      awaitingCollection: order.outcome.awaitingCollection,
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
          phone: CALL_CAPTAIN.includes(order.status) ? captain.phone : null,
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
    promoCode: order.promoCode,
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

function personalCodeBody(value: {
  code: string;
  kind: 'fixed_amount' | 'percentage';
  amount: bigint | null;
  percentBp: number | null;
  maxDiscount: bigint | null;
  currency: string;
  validTo: Date;
}) {
  return {
    code: value.code,
    kind: value.kind,
    amount: value.amount === null ? null : { amount: text(value.amount), currency: value.currency },
    percentBp: value.percentBp,
    maxDiscount:
      value.maxDiscount === null
        ? null
        : { amount: text(value.maxDiscount), currency: value.currency },
    validTo: value.validTo.toISOString(),
  };
}

// The report's refusals as HTTP answers: the tickets' and the photos'.
async function reportAnswered(run: () => Promise<void>): Promise<void> {
  try {
    await ticketAnswered(run);
  } catch (error) {
    if (error instanceof FilesRefusedError) {
      throw new BadRequestException({ statusCode: HttpStatus.BAD_REQUEST, error: error.refusal });
    }
    throw error;
  }
}
