import {
  Body,
  ConflictException,
  ForbiddenException,
  Get,
  HttpCode,
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
import {
  AppSignedIn,
  CurrentAdminSession,
  CurrentAppSession,
  RequirePermission,
} from '../../http/access.js';
import { Idempotent, IdempotencyKey } from '../../http/idempotency.js';
import { requestContext } from '../../http/request-context.js';
import { AdminController, CaptainController } from '../../http/route-groups.js';
import type { AdminSession, AppSession } from '../identity/index.js';
import {
  type CaptainOffer,
  DispatchRefusedError,
  DispatchService,
  type DispatchState,
  type PickerCaptain,
} from './dispatch.service.js';

const minor = z.string().regex(/^\d+$/).describe('Minor units of the currency, as a string.');
const money = z.object({ amount: minor, currency: z.string().length(3) });
const point = z.object({ latitude: z.number(), longitude: z.number() });

class AdminAssignParamsDto extends createZodDto(z.object({ orderId: z.uuid() })) {}

class AdminAssignDto extends createZodDto(
  z.object({ captainId: z.uuid().describe('An eligible captain from the assignment picker.') }),
) {}

class AdminHandoverDto extends createZodDto(
  z.object({
    captainId: z.uuid().describe('An eligible captain from the picker, measured from the first.'),
    reason: z
      .string()
      .trim()
      .min(1)
      .max(500)
      .describe('Operations’ internal note (AP §9.3.2: required; never shown to the apps).'),
    captainFault: z
      .boolean()
      .nullable()
      .default(null)
      .describe(
        "AP §9.7.6 (slices 2.13b, 2.13c): «بخطأ من الكابتن» (true) or «دون خطأ» (false), kept only while the first captain's «لا أستطيع إكمال الطلب» (the detail's cannotComplete; null counts as true) or «طوارئ» (the detail's emergency; null counts as false, also when both are open) is open; ignored otherwise.",
      ),
  }),
) {}

class AdminDispatchStateDto extends createZodDto(
  z.object({
    order: z.object({
      id: z.uuid(),
      number: z.string(),
      status: z.enum([
        'placed',
        'accepted',
        'ready',
        'picked_up',
        'arrived',
        'delivered',
        'rejected',
        'cancelled',
        'failed',
      ]),
      version: z.int(),
      captainTrack: z
        .enum([
          'searching',
          'offered',
          'assigned',
          'at_merchant',
          'pickup_pending',
          'picked_up',
          'at_customer',
          'done',
        ])
        .nullable()
        .describe('AP §8.2; searching is «بحاجة لتعيين» in manual mode.'),
      captainId: z.uuid().nullable().describe('From assignment.'),
      offer: z
        .object({
          id: z.uuid(),
          captainId: z.uuid(),
          expiresAt: z.iso.datetime(),
          handover: z.boolean().describe('«استلام من كابتن» (AP §9.3.2, CA §9.10.1).'),
        })
        .nullable()
        .describe('The open offer, while the captain decides (CA §8.4).'),
    }),
  }),
) {}

class AdminOrderOffersDto extends createZodDto(
  z.object({
    offers: z
      .array(
        z.object({
          id: z.uuid(),
          captain: z.object({ id: z.uuid(), name: z.string() }),
          kind: z
            .enum(['manual', 'auto'])
            .describe('Operations’ («تعيين من العمليات») or the automatic dispatcher’s.'),
          handover: z.boolean().describe('«استلام من كابتن» (AP §9.3.2, CA §9.10.1).'),
          offeredAt: z.iso.datetime(),
          expiresAt: z.iso.datetime(),
          status: z
            .enum(['open', 'accepted', 'declined', 'expired', 'withdrawn'])
            .describe('The answer: accepted, declined, expired («انتهت المهلة»), withdrawn.'),
          respondedAt: z.iso.datetime().nullable(),
          responseSec: z
            .int()
            .nullable()
            .describe('Seconds to an acceptance or a decline; null otherwise.'),
        }),
      )
      .describe('Every offer of the order, oldest first (AP §9.3.1, §9.7.4).'),
  }),
) {}

class AdminPickerDto extends createZodDto(
  z.object({
    assignsAsOffer: z
      .boolean()
      .describe(
        '«تعيين» reaches the captain as an offer (dispatch.manual_assign_requires_accept), the only way to send one greyed out only for «المبلغ أكبر مما يحمله» (CA §8.4, K2).',
      ),
    captains: z
      .array(
        z.object({
          captainId: z.uuid(),
          name: z.string(),
          vehicle: z.enum(['walking', 'bicycle', 'motorbike', 'car']),
          eligible: z.boolean(),
          reasons: z
            .array(
              z.enum([
                'busy',
                'last_order',
                'cash_limit',
                'closed_due',
                'simulated_location',
                'out_of_range',
                'vehicle_not_allowed',
                'above_max_pickup',
              ]),
            )
            .describe(
              'Why it is greyed out: «مشغول», over the cash limit, blocked for unhanded cash, a simulated location, out of range, vehicle not allowed, «المبلغ أكبر مما يحمله» (C4: the pickup payment above the captain’s maximum; alone, operations may still send an offer, CA §8.4).',
            ),
          distanceMetres: z
            .int()
            .describe(
              'To the restaurant (after the pickup, to the order’s captain at their latest point): by road within the search radius, else the straight line.',
            ),
          etaMin: z.int().nullable().describe('To the same point; null beyond the search radius.'),
          ordersToday: z.int(),
          custody: z.object({ usage: money, limit: money }).describe('Cash-limit usage.'),
          acceptanceRate: z
            .int()
            .nullable()
            .describe('A percentage over the last offers answered (CA §11.1); null without one.'),
        }),
      )
      .describe('Every online captain of the city, nearest to the restaurant first (AP §9.3.2).'),
  }),
) {}

function pickerBody(captain: PickerCaptain) {
  return {
    ...captain,
    custody: { usage: moneyBody(captain.custody.usage), limit: moneyBody(captain.custody.limit) },
  };
}

class CaptainOfferParamsDto extends createZodDto(z.object({ offerId: z.uuid() })) {}

const offer = z
  .object({
    id: z.uuid(),
    status: z.enum(['open', 'accepted', 'declined', 'expired', 'withdrawn']),
    orderId: z.uuid(),
    number: z.string(),
    fromOperations: z.boolean().describe('«تعيين من العمليات» (CA §8.4).'),
    offeredAt: z.iso.datetime(),
    expiresAt: z.iso.datetime().describe('The countdown ring runs to it (CA §8.2).'),
    pay: money
      .nullable()
      .describe(
        'The order pay, the largest text; «قد يُضاف أجر انتظار». Null without a pay table.',
      ),
    restaurant: z.object({
      name: z.string(),
      location: point,
      distanceMetres: z.int().describe('From the captain, by road, when the offer opened.'),
    }),
    customer: z
      .object({
        neighbourhood: z.string(),
        tripMetres: z.int().describe('Restaurant to customer.'),
      })
      .describe("Never the customer's name, phone or exact address before acceptance (C2)."),
    pickupPayment: money.describe(
      '«تدفع للمطعم» (D26: the items value); 0 on a handover, «لا تدفع شيئاً».',
    ),
    collect: money.describe('«تقبض من الزبون».'),
    preparation: z.object({
      ready: z.boolean().describe('«جاهز».'),
      readyAt: z.iso
        .datetime()
        .nullable()
        .describe('«قيد التحضير — جاهز بعد {د} د تقريباً» counts to it while not ready.'),
    }),
    handover: z
      .object({
        fromCaptainName: z.string(),
        location: z
          .object({
            latitude: z.number(),
            longitude: z.number(),
            recordedAt: z.iso.datetime().describe('When the first captain’s app recorded it.'),
          })
          .nullable()
          .describe('The first captain’s latest point; null without one.'),
      })
      .nullable()
      .describe(
        '«استلام من كابتن» (CA §9.10.1): the order is taken from this captain; restaurant.distanceMetres is then to them. Null for an ordinary offer.',
      ),
    aboveMaxPickup: z
      .boolean()
      .describe(
        'CA §8.4, K2: sent by operations above the captain’s «أقصى مبلغ أحمله»: «المبلغ أكبر من الحد الذي حددته — اقبل فقط إذا كان معك ما يكفي».',
      ),
  })
  .describe('An offer (CA §8.2).');

class CaptainCurrentOfferDto extends createZodDto(
  z.object({ offer: offer.nullable().describe('The open offer, or null.') }),
) {}

class CaptainOfferDto extends createZodDto(z.object({ offer })) {}

function stateBody(state: DispatchState) {
  return {
    order: {
      id: state.orderId,
      number: state.number.toString(),
      status: state.status,
      version: state.version,
      captainTrack: state.captainTrack,
      captainId: state.captainId,
      offer: state.offer && { ...state.offer, expiresAt: state.offer.expiresAt.toISOString() },
    },
  };
}

function moneyBody(value: { amount: bigint; currency: string }) {
  return { amount: value.amount.toString(), currency: value.currency };
}

function offerBody(value: CaptainOffer) {
  return {
    id: value.id,
    status: value.status,
    orderId: value.orderId,
    number: value.number.toString(),
    fromOperations: value.fromOperations,
    offeredAt: value.offeredAt.toISOString(),
    expiresAt: value.expiresAt.toISOString(),
    pay: value.pay && moneyBody(value.pay),
    restaurant: value.restaurant,
    customer: value.customer,
    pickupPayment: moneyBody(value.pickupPayment),
    aboveMaxPickup: value.aboveMaxPickup,
    collect: moneyBody(value.collect),
    preparation: {
      ready: value.preparation.ready,
      readyAt: value.preparation.readyAt?.toISOString() ?? null,
    },
    handover: value.handover && {
      fromCaptainName: value.handover.fromCaptainName,
      location: value.handover.location && {
        ...value.handover.location,
        recordedAt: value.handover.location.recordedAt.toISOString(),
      },
    },
  };
}

// The refusals as HTTP answers.
async function refusalsAsHttp<T>(run: () => Promise<T>): Promise<T> {
  try {
    return await run();
  } catch (error) {
    if (!(error instanceof DispatchRefusedError)) throw error;
    const { refusal } = error;
    if (
      refusal === 'unknown_order' ||
      refusal === 'unknown_captain' ||
      refusal === 'unknown_offer'
    ) {
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
      ...(refusal === 'captain_not_eligible' ? { reasons: error.reasons } : {}),
    });
  }
}

// AP §9.3.2 «تعيين كابتن» and «تسليم لكابتن آخر», for OWN and OPS.
@AdminController('orders')
export class AdminDispatchController {
  constructor(private readonly dispatch: DispatchService) {}

  // The assignment picker: eligible captains, and the others greyed out.
  @Get(':orderId/captains')
  @RequirePermission('operations.manage')
  @ZodResponse({ status: 200, type: AdminPickerDto })
  picker(@Param() params: AdminAssignParamsDto) {
    return refusalsAsHttp(async () => {
      const [captains, assignsAsOffer] = await Promise.all([
        this.dispatch.picker(params.orderId, new Date()),
        this.dispatch.assignsAsOffer(params.orderId),
      ]);
      return { captains: captains.map(pickerBody), assignsAsOffer };
    });
  }

  // An offer to the captain, or the order assigned at once when
  // dispatch.manual_assign_requires_accept is off. Refused 409
  // order_not_assignable (a captain or an open offer already, or not accepted
  // or ready), captain_not_eligible with its reasons, captain_has_offer.
  @Post(':orderId/assign')
  @RequirePermission('operations.manage')
  @Idempotent()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: AdminDispatchStateDto })
  assign(
    @Param() params: AdminAssignParamsDto,
    @Body() body: AdminAssignDto,
    @IdempotencyKey() idempotencyKey: string,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return refusalsAsHttp(async () =>
      stateBody(
        await this.dispatch.assign(
          {
            orderId: params.orderId,
            captainId: body.captainId,
            admin: { accountId: session.accountId, roles: session.roles },
            context: requestContext(request),
            idempotencyKey,
          },
          new Date(),
        ),
      ),
    );
  }

  // AP §9.3.2 «توزيع يدوي لهذا الطلب» (slice 2.15c): the order leaves
  // automatic dispatch, «بحاجة لتعيين»; an open offer keeps its time.
  // Refused 409 order_not_assignable (a captain, or past ready),
  // order_not_automatic («يدوي», or it already left).
  @Post(':orderId/manual-dispatch')
  @RequirePermission('operations.manage')
  @Idempotent()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: AdminDispatchStateDto })
  manualDispatch(
    @Param() params: AdminAssignParamsDto,
    @IdempotencyKey() idempotencyKey: string,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return refusalsAsHttp(async () =>
      stateBody(
        await this.dispatch.manualDispatch(
          {
            orderId: params.orderId,
            admin: { accountId: session.accountId, roles: session.roles },
            context: requestContext(request),
            idempotencyKey,
          },
          new Date(),
        ),
      ),
    );
  }

  // AP §9.3.1, §9.7.4 (slice 2.15c): the order's offers log.
  @Get(':orderId/offers')
  @RequirePermission('operations.read')
  @ZodResponse({ status: 200, type: AdminOrderOffersDto })
  offers(@Param() params: AdminAssignParamsDto) {
    return refusalsAsHttp(async () => ({
      offers: (await this.dispatch.orderOffers(params.orderId, new Date())).map((each) => ({
        ...each,
        offeredAt: each.offeredAt.toISOString(),
        expiresAt: each.expiresAt.toISOString(),
        respondedAt: each.respondedAt?.toISOString() ?? null,
      })),
    }));
  }

  // AP §9.3.2 «تسليم لكابتن آخر» (slice 2.12b): a picked-up or arrived
  // order offered, or assigned, to a second captain who takes it from the
  // first. Refused 409 order_not_handoverable, captain_not_eligible with its
  // reasons, captain_has_offer.
  @Post(':orderId/handover')
  @RequirePermission('operations.manage')
  @Idempotent()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: AdminDispatchStateDto })
  handover(
    @Param() params: AdminAssignParamsDto,
    @Body() body: AdminHandoverDto,
    @IdempotencyKey() idempotencyKey: string,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return refusalsAsHttp(async () =>
      stateBody(
        await this.dispatch.handover(
          {
            orderId: params.orderId,
            captainId: body.captainId,
            reason: body.reason,
            captainFault: body.captainFault,
            admin: { accountId: session.accountId, roles: session.roles },
            context: requestContext(request),
            idempotencyKey,
          },
          new Date(),
        ),
      ),
    );
  }
}

// CA §8: the captain's open offer, accepting and declining it. A state the
// offer no longer allows answers 409 offer_unavailable («لم يعد العرض متاحاً»).
@CaptainController('offers')
export class CaptainOffersController {
  constructor(private readonly dispatch: DispatchService) {}

  @Get('current')
  @AppSignedIn()
  @ZodResponse({ status: 200, type: CaptainCurrentOfferDto })
  async current(@CurrentAppSession() session: AppSession) {
    const current = await this.dispatch.currentOffer(captainOf(session), new Date());
    return { offer: current && offerBody(current) };
  }

  @Post(':offerId/accept')
  @AppSignedIn()
  @Idempotent()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: CaptainOfferDto })
  accept(
    @Param() params: CaptainOfferParamsDto,
    @IdempotencyKey() idempotencyKey: string,
    @CurrentAppSession() session: AppSession,
  ) {
    return refusalsAsHttp(async () => ({
      offer: offerBody(
        await this.dispatch.accept(
          {
            offerId: params.offerId,
            captainId: captainOf(session),
            accountId: session.accountId,
            deviceId: session.deviceId,
            idempotencyKey,
          },
          new Date(),
        ),
      ),
    }));
  }

  @Post(':offerId/decline')
  @AppSignedIn()
  @Idempotent()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: CaptainOfferDto })
  decline(
    @Param() params: CaptainOfferParamsDto,
    @IdempotencyKey() idempotencyKey: string,
    @CurrentAppSession() session: AppSession,
  ) {
    return refusalsAsHttp(async () => ({
      offer: offerBody(
        await this.dispatch.decline(
          {
            offerId: params.offerId,
            captainId: captainOf(session),
            accountId: session.accountId,
            deviceId: session.deviceId,
            idempotencyKey,
          },
          new Date(),
        ),
      ),
    }));
  }
}

function captainOf(session: AppSession): string {
  if (session.captain === null) throw new ForbiddenException();
  return session.captain.captainId;
}
