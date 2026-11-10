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
import type { PickupRequestView } from './pickup-views.js';
import {
  type CaptainActiveOrder,
  type CaptainCancellation,
  type CaptainOutcome,
  CaptainOrderRefusedError,
  CaptainOrders,
  type DeliverySummary,
  WEAK_GPS_METRES,
} from './captain-orders.js';
import { minor } from './customer-quote.controller.js';
import { captainTracks, cashAnswers, orderStatuses } from './schema.js';

const money = z.object({ amount: minor, currency: z.string().length(3) });
// RA §8.10: one line per currency, the amounts in minor units.
export const paymentLines = z.array(money).min(1).max(5);

const pickupRequest = z
  .object({
    id: z.uuid(),
    status: z.enum(['open', 'confirmed', 'rejected', 'voided']),
    outcome: z
      .enum([
        'restaurant',
        'automatic',
        'operations',
        'amount_incorrect',
        'incomplete',
        'cancelled',
      ])
      .nullable()
      .describe(
        'confirmed: «تم الاستلام», or «أكّدت العمليات الاستلام» for operations; rejected: amount_incorrect «المطعم يفيد بأنه استلم {المبلغ}. أكمل المبلغ ثم أعد التأكيد.», incomplete «المطعم يفيد بأن الطلب غير مكتمل. راجع الأصناف معه.»',
      ),
    amount: money.describe('The pickup payment of the request.'),
    lines: paymentLines.describe('The lines the captain paid.'),
    receivedLines: paymentLines
      .nullable()
      .describe('What the restaurant says it received, on «المبلغ غير صحيح».'),
    openedAt: z.iso.datetime(),
    confirmBy: z.iso
      .datetime()
      .describe('«بانتظار تأكيد المطعم» counts down to it while open (CA §9.4).'),
    closedAt: z.iso.datetime().nullable(),
  })
  .describe('A pickup request (RA §8.10).');

export function linesBody(lines: { currency: string; amount: bigint }[]) {
  return lines.map((line) => ({ currency: line.currency, amount: line.amount.toString() }));
}

export function linesOfBody(lines: { currency: string; amount: string }[]) {
  return lines.map((line) => ({ currency: line.currency, amount: BigInt(line.amount) }));
}

function pickupRequestBody(request: PickupRequestView) {
  return {
    id: request.id,
    status: request.status,
    outcome: request.outcome,
    amount: { amount: request.amount.amount.toString(), currency: request.amount.currency },
    lines: linesBody(request.lines),
    receivedLines: request.receivedLines && linesBody(request.receivedLines),
    openedAt: request.openedAt.toISOString(),
    confirmBy: request.confirmBy.toISOString(),
    closedAt: request.closedAt?.toISOString() ?? null,
  };
}
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
        'The step (CA §9.1): assigned «إلى المطعم», at_merchant and pickup_pending «عند المطعم», picked_up «إلى الزبون», at_customer «عند الزبون».',
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
    itemReportOpen: z
      .boolean()
      .describe(
        'The restaurant reported an item unavailable (RA §8.12): the screen shows «بانتظار تعديل الطلب من العمليات» and the pickup request waits (409 item_report_open) until operations edit, cancel or close the report (CA §9 step 2).',
      ),
    editUnacknowledged: z
      .boolean()
      .describe(
        'Operations added items and the restaurant has not pressed «اطلعت على التعديل» (RA §8.13): the screen shows «بانتظار تأكيد المطعم للتعديل» and the pickup request waits (409 edit_unacknowledged) (CA §9 step 2).',
      ),
    outcomeToCollect: z
      .object({
        outcome: z.enum(['free', 'damaged']),
        amount: money.describe('The amount due on the payment screen (CA §9.7).'),
        equivalents: z
          .array(money)
          .describe('The amount in the other accepted currencies, each by its rounding (CA §9.7).'),
      })
      .nullable()
      .describe(
        'Operations ended the order with an amount to collect (CA §9.10, K9): «أنهت العمليات الطلب: {النتيجة}. اقبض {المبلغ}.», the payment screen for this amount and the badge «بانتظار تسجيل التحصيل»; record it with POST .../outcome-payment.',
      ),
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
    pickup: z
      .object({
        proposedLines: paymentLines.describe(
          '«ادفع للمطعم: {المبلغ}» proposes them (CA §10.5): the whole amount in the base currency in Phase 1.',
        ),
        request: pickupRequest.nullable().describe('The latest request, or null.'),
        pickedUpAt: z.iso.datetime().nullable(),
        disputedAt: z.iso
          .datetime()
          .nullable()
          .describe('«فتح المطعم بلاغاً عن مبلغ الاستلام — ستتواصل معك العمليات».'),
      })
      .describe('Step 2 and the pickup request (CA §9.3–9.4).'),
    customer: z
      .object({
        name: z
          .string()
          .nullable()
          .describe(
            "The recipient's name when the order is for someone else, else the customer's.",
          ),
        phone: z
          .string()
          .nullable()
          .describe(
            '«اتصال بالزبون» and «واتساب الزبون» (C10) open it; the app shows it nowhere else.',
          ),
        location: point.describe('The exact pin, with the route and «ابدأ الملاحة».'),
        address: z.object({
          neighbourhood: z.string().describe('«الحي».'),
          street: z.string(),
          floor: z.string().nullable(),
          landmark: z.string(),
          directions: z.string().nullable().describe("The customer's directions."),
        }),
        payIn: z
          .string()
          .nullable()
          .describe('«الزبون سيدفع بـ {العملة}», an indication only (CU U10).'),
        collectEquivalents: z
          .array(money)
          .describe('«تقبض من الزبون» in the other accepted currencies, each by its rounding.'),
        promisedAt: z.iso.datetime().describe('«التسليم المتوقع قبل {الساعة}».'),
        arrival: z
          .object({
            at: z.iso.datetime(),
            awayReason: z
              .string()
              .nullable()
              .describe('The reason given away from the pin; it covers the delivery too (K4).'),
          })
          .nullable()
          .describe('Null until «وصلت» at the customer (CA §9.6).'),
      })
      .describe('Steps 3 and 4, to and at the customer (CA §9.5–9.6).'),
    radii: z
      .object({
        restaurantMetres: z
          .int()
          .describe('captain.merchant_arrival_radius_m: «وصلت إلى المطعم» within it (C6).'),
        customerMetres: z
          .int()
          .describe(
            'captain.customer_radius_m: «وصلت» and «تم التسليم» need no reason within it (K4, C9).',
          ),
      })
      .describe('The arrival radii, by the straight line from the latest fix.'),
  })
  .describe('The active order (CA §9).');

// CA §9.10 (slice 2.8b): the order operations cancelled, until the captain's
// «حسناً».
const cancelledTask = z
  .object({
    orderId: z.uuid(),
    number: z.string().describe('Shown as #10423 (AP §4.8).'),
    reason: z
      .string()
      .describe('{السبب} of «أُلغيت المهمة: {السبب}»: the reason as operations chose it.'),
    cash: z
      .enum(cashAnswers)
      .nullable()
      .describe(
        'returned «استرجع المبلغ من المطعم»; not_returned «لا تسترجع المبلغ، يُخصم من المطعم في التسوية»; not_paid or null: no cash line.',
      ),
    compensation: money
      .nullable()
      .describe('«تعويض: {المبلغ}» when operations compensated the captain.'),
    at: z.iso.datetime(),
  })
  .nullable()
  .describe(
    'The latest order operations cancelled within 12 hours that the captain has not acknowledged (POST …/acknowledge-cancellation); the app plays the cancellation sound when one appears.',
  );

const minorMoney = z.object({ amount: z.string().regex(/^\d+$/), currency: z.string().length(3) });

const endedTask = z
  .object({
    orderId: z.uuid(),
    number: z.string(),
    outcome: z
      .enum(['free', 'fake', 'damaged', 'wrong_refused', 'failed_other'])
      .describe('«أنهت العمليات الطلب: {النتيجة}.» with the label of AP Appendix C.'),
    status: z.enum(['delivered', 'failed']),
    food: z
      .enum(['kept_by_captain', 'returned_to_restaurant', 'destroyed'])
      .nullable()
      .describe("Where a failed order's food goes (CA §9.12), by Content's food_after_failed."),
    pay: minorMoney.nullable().describe('The pay the order still brings (CA §9.12).'),
    charge: minorMoney
      .nullable()
      .describe('With the captain responsible: the charge on the earnings (CA §10.6).'),
    at: z.iso.datetime(),
  })
  .nullable()
  .describe(
    'The latest order operations ended with an outcome within 12 hours that the captain has not acknowledged (POST …/acknowledge-outcome).',
  );

function endedBody(ended: CaptainOutcome | null) {
  const text = (value: { amount: bigint; currency: string } | null) =>
    value && { amount: value.amount.toString(), currency: value.currency };
  return (
    ended && {
      orderId: ended.orderId,
      number: ended.number.toString(),
      outcome: ended.outcome,
      status: ended.status,
      food: ended.food,
      pay: text(ended.pay),
      charge: text(ended.charge),
      at: ended.at.toISOString(),
    }
  );
}

function cancelledBody(cancelled: CaptainCancellation | null) {
  return (
    cancelled && {
      orderId: cancelled.orderId,
      number: cancelled.number.toString(),
      reason: cancelled.reason,
      cash: cancelled.cash,
      compensation: cancelled.compensation && {
        amount: cancelled.compensation.amount.toString(),
        currency: cancelled.compensation.currency,
      },
      at: cancelled.at.toISOString(),
    }
  );
}

class CaptainActiveOrderDto extends createZodDto(
  z.object({
    order: activeOrder.nullable().describe('Null without an active order.'),
    cancelled: cancelledTask,
    ended: endedTask,
  }),
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

class CaptainPickupRequestDto extends createZodDto(
  z.object({
    lines: paymentLines.describe('The currency lines paid, the proposed ones or the own split.'),
    location: commandLocation,
  }),
) {}

class CaptainArriveDto extends createZodDto(z.object({ location: commandLocation })) {}

// A reason chosen from a Content list (AP §9.13): its code, and the text of
// a reason that needs one («أخرى»). ContentService checks it: 400
// unknown_reason, reason_note_required, reason_note_not_allowed.
const reasonCode = z
  .string()
  .regex(/^[a-z0-9_]{1,40}$/)
  .describe("The reason's code in its Content list.");
const reasonNote = z
  .string()
  .trim()
  .min(1)
  .max(200)
  .nullable()
  .describe('The text of a reason that needs one («أخرى»), and only of it.');

// CA Appendix C: arrival or delivery away from the pin (K4, C9), from the
// captain_away list.
export const awayGiven = z.object({ reason: reasonCode, note: reasonNote });

class CaptainArriveAtCustomerDto extends createZodDto(
  z.object({
    location: commandLocation,
    away: awayGiven
      .nullable()
      .describe(
        'Needed beyond captain.customer_radius_m of the pin: «الزبون طلب مكاناً آخر», «موقع الزبون على الخريطة غير دقيق», «أخرى».',
      ),
  }),
) {}

// CA Appendix C (K16): why the captain collected less than due, from the
// shortfall list.
export const shortfallGiven = z.object({ reason: reasonCode, note: reasonNote });

// AP §8.6, CA §9.7: the door payment, as the captain or operations record it.
// A line's amount, capped at 15 digits so it never nears the bigint limit.
const doorLine = z.object({
  amount: z
    .string()
    .regex(/^\d{1,15}$/)
    .describe('Integer minor units (AP §8.6).'),
  currency: z.string().length(3),
});

export const doorPayment = {
  received: z
    .array(doorLine)
    .min(1)
    .max(5)
    .describe('What the customer paid, one line per currency.'),
  change: z
    .array(doorLine)
    .max(5)
    .describe('The change given back, one line per currency; a tip is recorded as given (K14).'),
  amountDue: money.describe(
    'The amount due the screen showed; another one now answers 409 amount_due_changed.',
  ),
  shortfall: shortfallGiven
    .nullable()
    .describe(
      'Needed when the net received is short beyond rounding: «الزبون لا يملك المبلغ كاملاً», «خطأ في العد», «أخرى».',
    ),
};

export function doorCollection(body: {
  received: { currency: string; amount: string }[];
  change: { currency: string; amount: string }[];
  amountDue: { currency: string; amount: string };
  shortfall: { reason: string; note: string | null } | null;
}) {
  return {
    received: linesOfBody(body.received),
    change: linesOfBody(body.change),
    amountDue: { amount: BigInt(body.amountDue.amount), currency: body.amountDue.currency },
    shortfall: body.shortfall,
  };
}

class CaptainDeliverDto extends createZodDto(
  z.object({
    ...doorPayment,
    location: commandLocation,
    away: awayGiven
      .nullable()
      .describe(
        'Needed beyond captain.customer_radius_m of the pin, unless given at the arrival (K4).',
      ),
  }),
) {}

class CaptainOutcomePaymentDto extends createZodDto(
  z.object({
    ...doorPayment,
    location: commandLocation
      .nullable()
      .describe(
        'The latest fix, recorded with the command (CA §15); no radius applies, since the screen opens wherever the captain is.',
      ),
  }),
) {}

class CaptainDeliverySummaryDto extends createZodDto(
  z.object({
    summary: z
      .object({
        orderId: z.uuid(),
        number: z.string(),
        pay: z
          .object({
            base: minor,
            distance: minor,
            topUp: minor.describe('«إكمال للحد الأدنى», shown when above 0.'),
            waiting: minor,
            total: minor.describe('«ربحت من هذا الطلب: {الأجر}».'),
            currency: z.string().length(3),
          })
          .describe('The peak bonus comes with the peak windows.'),
        custodyChange: z
          .object({ amount: z.string().regex(/^-?\d+$/), currency: z.string().length(3) })
          .describe('«تغيّرت عهدتك: {+المبلغ}»: the net collected minus the pickup payment.'),
        handInToday: money.describe('«عليك تسليم اليوم: {المجموع}».'),
      })
      .describe('The order summary (CA §9.8); the captain is free for the next offer.'),
  }),
) {}

function summaryBody(summary: DeliverySummary) {
  const amount = (value: bigint) => value.toString();
  return {
    summary: {
      orderId: summary.orderId,
      number: summary.number.toString(),
      pay: {
        base: amount(summary.pay.base),
        distance: amount(summary.pay.distance),
        topUp: amount(summary.pay.topUp),
        waiting: amount(summary.pay.waiting),
        total: amount(summary.pay.total),
        currency: summary.currency,
      },
      custodyChange: { amount: amount(summary.custodyChange), currency: summary.currency },
      handInToday: {
        amount: amount(summary.handInToday.amount),
        currency: summary.handInToday.currency,
      },
    },
  };
}

function activeOrderBody({
  order,
  restaurant,
  customer,
  pickupRequest,
  pickupDispute,
  radii,
}: CaptainActiveOrder) {
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
    itemReportOpen: order.itemReport !== null,
    editUnacknowledged: order.pendingEdits.some((edit) => edit.addsItems),
    outcomeToCollect: order.outcome?.awaitingCollection
      ? {
          outcome: order.outcome.outcome as 'free' | 'damaged',
          amount: money(order.outcome.amountToCollect),
          equivalents: order.outcome.amountEquivalents.map((each) => ({
            amount: each.amount.toString(),
            currency: each.currency,
          })),
        }
      : null,
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
    pickup: {
      proposedLines: [money(order.money.itemsValue)],
      request: pickupRequest && pickupRequestBody(pickupRequest),
      pickedUpAt: order.pickup?.at.toISOString() ?? null,
      disputedAt: pickupDispute?.at.toISOString() ?? null,
    },
    customer: {
      name: customer.name,
      phone: customer.phone,
      location: order.address.location,
      address: {
        neighbourhood: order.address.neighbourhood,
        street: order.address.street,
        floor: order.address.floor,
        landmark: order.address.landmark,
        directions: order.address.directions,
      },
      payIn: order.payIn,
      collectEquivalents: order.equivalents.map((each) => ({
        amount: each.amount.toString(),
        currency: each.currency,
      })),
      promisedAt: order.acceptance.promisedAt.toISOString(),
      arrival: order.customerArrival && {
        at: order.customerArrival.at.toISOString(),
        awayReason: order.away?.reason ?? null,
      },
    },
    radii,
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
    const captainId = captainOf(session);
    const now = new Date();
    const [active, cancelled, ended] = await Promise.all([
      this.orders.active(captainId, now),
      this.orders.cancelled(captainId, now),
      this.orders.outcome(captainId, now),
    ]);
    return {
      order: active && activeOrderBody(active),
      cancelled: cancelledBody(cancelled),
      ended: endedBody(ended),
    };
  }

  // CA §9.12 «حسناً» on the outcome card (slice 2.11a): answers the active
  // read without it. Idempotent by its nature, so it takes no key, and it
  // needs no fix. 409 order_state_changed for an order without an outcome
  // operations set; 404 unknown_order for another captain's.
  @Post(':orderId/acknowledge-outcome')
  @AppSignedIn()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: CaptainActiveOrderDto })
  async acknowledgeOutcome(
    @CurrentAppSession() session: AppSession,
    @Param() params: CaptainOrderParamsDto,
  ) {
    const captainId = captainOf(session);
    return refusalsAsHttp(captainId, this.orders, async () => {
      await this.orders.acknowledgeOutcome(captainId, params.orderId, new Date());
      return this.active(session);
    });
  }

  // CA §9.10 «حسناً» on the cancellation card (slice 2.8b): answers the
  // active read without it. Idempotent by its nature (a repeat changes
  // nothing), so it takes no key, and it needs no fix. 409
  // order_state_changed for an order operations did not cancel; 404
  // unknown_order for another captain's.
  @Post(':orderId/acknowledge-cancellation')
  @AppSignedIn()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: CaptainActiveOrderDto })
  async acknowledgeCancellation(
    @CurrentAppSession() session: AppSession,
    @Param() params: CaptainOrderParamsDto,
  ) {
    const captainId = captainOf(session);
    return refusalsAsHttp(captainId, this.orders, async () => {
      const now = new Date();
      await this.orders.acknowledgeCancellation(captainId, params.orderId, now);
      return this.active(session);
    });
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

  // CA §9.6 «وصلت» at the customer: the customer sees «الكابتن عند الباب».
  // 409 too_far_from_customer with the distance (send a reason, `away`),
  // weak_location, simulated_location, stale_location, not_online,
  // order_state_changed; 404 unknown_order; 400 invalid_location; 422
  // idempotency_key_reused.
  @Post(':orderId/arrive-at-customer')
  @AppSignedIn()
  @Idempotent()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: CaptainOrderDto })
  async arriveAtCustomer(
    @CurrentAppSession() session: AppSession,
    @IdempotencyKey() idempotencyKey: string,
    @Param() params: CaptainOrderParamsDto,
    @Body() body: CaptainArriveAtCustomerDto,
  ) {
    const captainId = captainOf(session);
    return refusalsAsHttp(captainId, this.orders, async () => ({
      order: activeOrderBody(
        await this.orders.arriveAtCustomer(
          {
            orderId: params.orderId,
            captainId,
            accountId: session.accountId,
            deviceId: session.deviceId,
            idempotencyKey,
            location: { ...body.location, recordedAt: new Date(body.location.recordedAt) },
            away: body.away,
          },
          new Date(),
        ),
      ),
    }));
  }

  // CA §9.7–9.8 «تم التسليم» with the door payment: the order is delivered
  // and the captain gets the summary. 409 too_far_from_customer (send
  // `away`), shortfall_reason_required with `shortfall`, overpaid («سجّل
  // الباقي الذي أعدته للزبون»), amount_due_changed and order_state_changed
  // with the order as it is now, currency_not_accepted, weak_location,
  // simulated_location, stale_location, not_online; 400 invalid_lines,
  // invalid_location; 404 unknown_order; 422 idempotency_key_reused.
  @Post(':orderId/deliver')
  @AppSignedIn()
  @Idempotent()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: CaptainDeliverySummaryDto })
  async deliver(
    @CurrentAppSession() session: AppSession,
    @IdempotencyKey() idempotencyKey: string,
    @Param() params: CaptainOrderParamsDto,
    @Body() body: CaptainDeliverDto,
  ) {
    const captainId = captainOf(session);
    return refusalsAsHttp(captainId, this.orders, async () =>
      summaryBody(
        await this.orders.deliver(
          {
            orderId: params.orderId,
            captainId,
            accountId: session.accountId,
            deviceId: session.deviceId,
            idempotencyKey,
            ...doorCollection(body),
            location: { ...body.location, recordedAt: new Date(body.location.recordedAt) },
            away: body.away,
          },
          new Date(),
        ),
      ),
    );
  }

  // CA §9.10, §9.7 (K9): the payment of the amount operations set to collect
  // with an outcome; the outcome is posted from it and the captain gets the
  // summary. The fix is recorded, with no radius: the screen opens wherever
  // the captain is. 409
  // shortfall_reason_required with `shortfall`, overpaid, amount_due_changed
  // and order_state_changed (nothing waiting) with the order as it is now,
  // currency_not_accepted; 400 invalid_lines; 404 unknown_order; 422
  // idempotency_key_reused.
  @Post(':orderId/outcome-payment')
  @AppSignedIn()
  @Idempotent()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: CaptainDeliverySummaryDto })
  async collectOutcome(
    @CurrentAppSession() session: AppSession,
    @IdempotencyKey() idempotencyKey: string,
    @Param() params: CaptainOrderParamsDto,
    @Body() body: CaptainOutcomePaymentDto,
  ) {
    const captainId = captainOf(session);
    return refusalsAsHttp(captainId, this.orders, async () => {
      const now = new Date();
      const order = await this.orders.collectOutcome(
        {
          kind: 'captain',
          command: {
            orderId: params.orderId,
            captainId,
            accountId: session.accountId,
            deviceId: session.deviceId,
            idempotencyKey,
          },
          location: body.location && {
            ...body.location,
            recordedAt: new Date(body.location.recordedAt),
          },
        },
        doorCollection(body),
        now,
      );
      return summaryBody(await this.orders.deliverySummary(order, now));
    });
  }

  // CA §9.4 «دفعت للمطعم واستلمت الطلب», at the restaurant: the request waits
  // for the restaurant for order.pickup_confirm_timeout_sec. 409
  // amount_mismatch («المبلغ لا يطابق المطلوب»), currency_not_accepted (the
  // base currency only in Phase 1), order_state_changed (not at the
  // restaurant, a request already open, picked up); 400 invalid_lines,
  // invalid_location; 404 unknown_order; 422 idempotency_key_reused.
  @Post(':orderId/pickup-request')
  @AppSignedIn()
  @Idempotent()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: CaptainOrderDto })
  async requestPickup(
    @CurrentAppSession() session: AppSession,
    @IdempotencyKey() idempotencyKey: string,
    @Param() params: CaptainOrderParamsDto,
    @Body() body: CaptainPickupRequestDto,
  ) {
    const captainId = captainOf(session);
    return refusalsAsHttp(captainId, this.orders, async () => ({
      order: activeOrderBody(
        await this.orders.requestPickup(
          {
            orderId: params.orderId,
            captainId,
            accountId: session.accountId,
            deviceId: session.deviceId,
            idempotencyKey,
            lines: linesOfBody(body.lines),
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
    if (
      refusal === 'invalid_location' ||
      refusal === 'invalid_lines' ||
      refusal === 'unknown_reason' ||
      refusal === 'reason_note_required' ||
      refusal === 'reason_note_not_allowed'
    ) {
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
    if (refusal === 'order_state_changed' || refusal === 'amount_due_changed') {
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
      ...(refusal === 'too_far_from_restaurant' || refusal === 'too_far_from_customer'
        ? { distanceMetres: error.distanceMetres }
        : {}),
      ...(refusal === 'weak_location' ? { accuracyLimitMetres: WEAK_GPS_METRES } : {}),
      ...(error.shortfall
        ? {
            shortfall: {
              amount: error.shortfall.amount.toString(),
              currency: error.shortfall.currency,
            },
          }
        : {}),
    });
  }
}

function captainOf(session: AppSession): string {
  if (session.captain === null) throw new ForbiddenException();
  return session.captain.captainId;
}
