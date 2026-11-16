import {
  Body,
  Get,
  HttpCode,
  HttpStatus,
  NotFoundException,
  Param,
  Post,
  Query,
  Req,
} from '@nestjs/common';
import type { FastifyRequest } from 'fastify';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { CurrentAdminSession, RequirePermission } from '../../http/access.js';
import { Idempotent, IdempotencyKey } from '../../http/idempotency.js';
import { AdminController } from '../../http/route-groups.js';
import { type AdminSession, AdminSessionsService } from '../identity/index.js';
import { deskUser, refusalsAsHttp } from './desk-http.js';
import {
  type MerchantReceipt,
  MerchantSettlementService,
  type MerchantSettlementPreview,
} from './merchant-settlement.service.js';
import {
  MerchantStatementsService,
  type MerchantStatementView,
} from './merchant-statements.service.js';
import {
  merchantExceptionCauses,
  merchantStatementLineKinds,
  receiptMethods,
  sessionKinds,
} from './schema.js';

const minor = z.string().regex(/^\d{1,18}$/);
const signedMinor = z.string().regex(/^-?\d{1,18}$/);
const currency = z.string().regex(/^[A-Z]{3}$/);
// RA §12.3 «غير مسدّد», «مسدّد جزئياً», «مسدّد»; null when the statement asked
// nothing of the restaurant.
const statementStatus = z.enum(['unpaid', 'partly_paid', 'paid']).nullable();
const weekday = z.enum([
  'saturday',
  'sunday',
  'monday',
  'tuesday',
  'wednesday',
  'thursday',
  'friday',
]);

class AdminRestaurantSettlementsQueryDto extends createZodDto(z.object({ cityId: z.uuid() })) {}

class AdminRestaurantSettlementsDto extends createZodDto(
  z.object({
    currency: currency.nullable(),
    settlementWeekday: weekday,
    nextCutoff: z.iso.datetime(),
    restaurants: z.array(
      z.object({
        restaurantId: z.uuid(),
        restaurantName: z.string(),
        currency,
        balance: signedMinor.describe('+ the restaurant owes, − the platform owes it.'),
        latest: z
          .object({
            id: z.uuid(),
            cutoff: z.iso.datetime(),
            commission: signedMinor,
            discountShare: signedMinor,
            exceptions: signedMinor,
            totalDue: signedMinor,
            status: statementStatus,
          })
          .nullable(),
        unpaid: signedMinor.describe('What is left of the latest statement after the payments.'),
        overdueSince: z.iso.datetime().nullable(),
      }),
    ),
  }),
) {}

class AdminMerchantStatementParamsDto extends createZodDto(z.object({ statementId: z.uuid() })) {}

class AdminMerchantStatementDto extends createZodDto(
  z.object({
    id: z.uuid(),
    cityId: z.uuid(),
    restaurantId: z.uuid(),
    restaurantName: z.string(),
    cutoff: z.iso.datetime(),
    periodFrom: z.iso.datetime().nullable(),
    createdAt: z.iso.datetime(),
    currency,
    orders: z.int(),
    itemsValue: signedMinor,
    commission: signedMinor,
    discountShare: signedMinor,
    exceptions: signedMinor,
    weekTotal: signedMinor,
    previousDue: signedMinor,
    paid: signedMinor,
    earlierUnpaid: signedMinor,
    totalDue: signedMinor,
    status: statementStatus,
    unpaid: signedMinor.describe('What of the total due is still unpaid, oldest first.'),
    // Flat, since the Dart generator misnames an enum inside a nested object.
    lines: z.array(
      z.object({
        position: z.int(),
        kind: z.enum(merchantStatementLineKinds),
        at: z.iso.datetime(),
        orderId: z.uuid().nullable(),
        orderNumber: z.string().nullable(),
        itemsValue: signedMinor.nullable(),
        pickupLines: z.array(z.object({ currency, amount: signedMinor })).nullable(),
        commission: signedMinor.nullable(),
        discountShare: signedMinor.nullable(),
        cause: z.enum(merchantExceptionCauses).nullable(),
        amount: signedMinor.nullable(),
        reason: z.string().nullable(),
      }),
    ),
  }),
) {}

const rates = z
  .array(z.object({ currency, rateVersionId: z.uuid() }))
  .max(10)
  .describe('The rate version of each currency but the base, as the quote gave it.');

class AdminRestaurantSettlementPreviewRequestDto extends createZodDto(
  z.object({
    restaurantId: z.uuid(),
    lines: z
      .array(z.object({ currency, amount: minor }))
      .max(10)
      .describe('The cash per currency; none to read the balance alone.'),
  }),
) {}

class AdminRestaurantSettlementPreviewDto extends createZodDto(
  z.object({
    restaurantId: z.uuid(),
    restaurantName: z.string(),
    cityId: z.uuid(),
    currency,
    due: signedMinor.describe('+ the restaurant owes, − the platform owes it.'),
    lines: z.array(
      z.object({
        currency,
        amount: minor,
        base: minor.describe('The value in the base at the current rate.'),
        rates,
        unit: z.object({ from: currency, to: currency, value: z.string() }).nullable(),
      }),
    ),
    total: minor,
    remaining: signedMinor.describe('What stays on the account, of the sign of due.'),
  }),
) {}

class AdminRestaurantSettleDto extends createZodDto(
  z.object({
    restaurantId: z.uuid(),
    session: z
      .enum(sessionKinds)
      .default('office')
      .describe("The user's session it is recorded in: the office's, or the field's on a visit."),
    // At the office: the staff member without FIN who visited (AP §9.10.3).
    visitorId: z.uuid().nullable().default(null),
    due: signedMinor.describe('The balance the screen showed.'),
    lines: z
      .array(z.object({ currency, amount: minor, base: minor, rates }))
      .min(1)
      .max(10),
  }),
) {}

class AdminFieldVisitorsDto extends createZodDto(
  z.object({ visitors: z.array(z.object({ id: z.uuid(), name: z.string() })) }),
) {}

class AdminRestaurantReceiptParamsDto extends createZodDto(z.object({ receiptId: z.uuid() })) {}

class AdminRestaurantReceiptDto extends createZodDto(
  z.object({
    id: z.uuid(),
    cityId: z.uuid(),
    number: z.string(),
    type: z.enum(['merchant_settlement', 'merchant_payout']),
    sessionId: z.uuid(),
    method: z.enum(receiptMethods).describe('«في المكتب» or «زيارة ميدانية».'),
    // The staff member who visited, on a field visit.
    visitorId: z.uuid().nullable(),
    visitorName: z.string().nullable(),
    cashierId: z.uuid(),
    cashierName: z.string().nullable(),
    restaurantId: z.uuid(),
    restaurantName: z.string(),
    currency,
    dueBefore: signedMinor,
    total: minor,
    dueAfter: signedMinor,
    createdAt: z.iso.datetime(),
    lines: z.array(z.object({ currency, amount: minor, base: minor })),
  }),
) {}

function previewBody(found: MerchantSettlementPreview) {
  return {
    restaurantId: found.restaurantId,
    restaurantName: found.restaurantName,
    cityId: found.cityId,
    currency: found.currency,
    due: found.due.toString(),
    lines: found.lines.map((line) => ({
      currency: line.currency,
      amount: line.amount.toString(),
      base: line.base.toString(),
      rates: line.rates,
      unit: line.unit,
    })),
    total: found.total.toString(),
    remaining: found.remaining.toString(),
  };
}

function receiptBody(found: MerchantReceipt) {
  return {
    ...found,
    dueBefore: found.dueBefore.toString(),
    total: found.total.toString(),
    dueAfter: found.dueAfter.toString(),
    createdAt: found.createdAt.toISOString(),
    lines: found.lines.map((line) => ({
      currency: line.currency,
      amount: line.amount.toString(),
      base: line.base.toString(),
    })),
  };
}

function statementBody(found: MerchantStatementView) {
  return {
    id: found.id,
    cityId: found.cityId,
    restaurantId: found.restaurantId,
    restaurantName: found.restaurantName,
    cutoff: found.cutoff.toISOString(),
    periodFrom: found.periodFrom?.toISOString() ?? null,
    createdAt: found.createdAt.toISOString(),
    currency: found.currency,
    orders: found.orders,
    itemsValue: found.itemsValue.toString(),
    commission: found.commission.toString(),
    discountShare: found.discountShare.toString(),
    exceptions: found.exceptions.toString(),
    weekTotal: found.weekTotal.toString(),
    previousDue: found.previousDue.toString(),
    paid: found.paid.toString(),
    earlierUnpaid: found.earlierUnpaid.toString(),
    totalDue: found.totalDue.toString(),
    status: found.status,
    unpaid: found.unpaid.toString(),
    lines: found.lines.map((line) =>
      line.kind === 'order'
        ? {
            position: line.position,
            kind: line.kind,
            at: line.at.toISOString(),
            orderId: line.orderId,
            orderNumber: line.orderNumber?.toString() ?? null,
            itemsValue: line.itemsValue?.toString() ?? null,
            pickupLines:
              line.pickupLines?.map((each) => ({
                currency: each.currency,
                amount: each.amount.toString(),
              })) ?? null,
            commission: line.commission.toString(),
            discountShare: line.discountShare.toString(),
            cause: null,
            amount: null,
            reason: null,
          }
        : {
            position: line.position,
            kind: line.kind,
            at: line.at.toISOString(),
            orderId: line.orderId,
            orderNumber: line.orderNumber?.toString() ?? null,
            itemsValue: null,
            pickupLines: null,
            commission: null,
            discountShare: null,
            cause: line.cause,
            amount: line.amount.toString(),
            reason: line.reason,
          },
    ),
  };
}

// «تسوية المطاعم» (AP §9.10.3 tab 3, AP §8.7; slices 2.19a, 2.19b): the
// restaurants with a balance, their weekly statements, and the settlement at
// the office with its receipt. Money travels as strings of minor units.
@AdminController('cash-desk')
export class AdminRestaurantSettlementController {
  constructor(
    private readonly statements: MerchantStatementsService,
    private readonly settlements: MerchantSettlementService,
    private readonly admins: AdminSessionsService,
  ) {}

  // What the screen shows before the confirmation: the balance, each
  // currency's value in the base at the current rate and what stays due. A
  // read, so no Idempotency-Key. 404 unknown_restaurant; 409 rate_missing.
  @Post('restaurant-settlements/preview')
  @RequirePermission('cash_desk.record')
  @HttpCode(200)
  @ZodResponse({ status: 200, type: AdminRestaurantSettlementPreviewDto })
  preview(@Body() body: AdminRestaurantSettlementPreviewRequestDto) {
    return refusalsAsHttp(async () =>
      previewBody(
        await this.settlements.preview(
          body.restaurantId,
          body.lines.map((line) => ({ currency: line.currency, amount: BigInt(line.amount) })),
        ),
      ),
    );
  }

  // «تأكيد وإصدار الإيصال» (AP §8.7, RA §12.4): the receipt. Refused 409
  // above_balance, balance_changed (the balance moved since the preview),
  // rate_changed, nothing_due, drawer_short (a payout above the drawer's
  // cash), no_open_session; 404 unknown_restaurant.
  @Post('restaurant-settlements')
  @RequirePermission('cash_desk.record')
  @Idempotent()
  @ZodResponse({ status: 201, type: AdminRestaurantReceiptDto })
  settle(
    @Body() body: AdminRestaurantSettleDto,
    @IdempotencyKey() idempotencyKey: string,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return refusalsAsHttp(async () =>
      receiptBody(
        await this.settlements.settle(
          deskUser(session, request),
          {
            session: body.session,
            visitorId: body.visitorId,
            restaurantId: body.restaurantId,
            due: BigInt(body.due),
            lines: body.lines.map((line) => ({
              currency: line.currency,
              amount: BigInt(line.amount),
              base: BigInt(line.base),
              rates: line.rates,
            })),
            idempotencyKey,
          },
          new Date(),
        ),
      ),
    );
  }

  // The team members a desk can name as the visitor of a field visit.
  @Get('visitors')
  @RequirePermission('cash_desk.record')
  @ZodResponse({ status: 200, type: AdminFieldVisitorsDto })
  async visitors() {
    return { visitors: await this.admins.team() };
  }

  // A restaurant's receipt, to print on 80 mm or A4.
  @Get('restaurant-receipts/:receiptId')
  @RequirePermission('cash_desk.record')
  @ZodResponse({ status: 200, type: AdminRestaurantReceiptDto })
  async receipt(@Param() params: AdminRestaurantReceiptParamsDto) {
    const found = await this.settlements.receipt(params.receiptId);
    if (!found) {
      throw new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, error: 'unknown_receipt' });
    }
    return receiptBody(found);
  }

  @Get('restaurants')
  @RequirePermission('cash_desk.record')
  @ZodResponse({ status: 200, type: AdminRestaurantSettlementsDto })
  async restaurants(@Query() query: AdminRestaurantSettlementsQueryDto) {
    const list = await this.statements.restaurants(query.cityId, new Date());
    return {
      currency: list.currency,
      settlementWeekday: list.settlementWeekday,
      nextCutoff: list.nextCutoff.toISOString(),
      restaurants: list.restaurants.map((row) => ({
        restaurantId: row.restaurantId,
        restaurantName: row.restaurantName,
        currency: row.currency,
        balance: row.balance.toString(),
        latest: row.latest && {
          id: row.latest.id,
          cutoff: row.latest.cutoff.toISOString(),
          commission: row.latest.commission.toString(),
          discountShare: row.latest.discountShare.toString(),
          exceptions: row.latest.exceptions.toString(),
          totalDue: row.latest.totalDue.toString(),
          status: row.latest.status,
        },
        unpaid: row.unpaid.toString(),
        overdueSince: row.overdueSince?.toISOString() ?? null,
      })),
    };
  }

  // A restaurant's weekly statement, entry by entry, to show and print.
  @Get('merchant-statements/:statementId')
  @RequirePermission('cash_desk.record')
  @ZodResponse({ status: 200, type: AdminMerchantStatementDto })
  async statement(@Param() params: AdminMerchantStatementParamsDto) {
    const found = await this.statements.statement(params.statementId);
    if (!found) {
      throw new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, error: 'unknown_statement' });
    }
    return statementBody(found);
  }
}
