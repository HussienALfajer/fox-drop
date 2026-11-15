import { Get, HttpStatus, NotFoundException, Param, Query } from '@nestjs/common';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { RequirePermission } from '../../http/access.js';
import { AdminController } from '../../http/route-groups.js';
import {
  MerchantStatementsService,
  type MerchantStatementView,
} from './merchant-statements.service.js';
import { merchantExceptionCauses, merchantStatementLineKinds } from './schema.js';

const signedMinor = z.string().regex(/^-?\d{1,18}$/);
const currency = z.string().regex(/^[A-Z]{3}$/);
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
          .object({ id: z.uuid(), cutoff: z.iso.datetime(), totalDue: signedMinor })
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

function statementBody(found: MerchantStatementView) {
  return {
    id: found.id,
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

// «تسوية المطاعم» (AP §9.10.3 tab 3, AP §8.7; slice 2.19a), read-only until
// the settlement (2.19b): the restaurants with a balance and their weekly
// statements. Money travels as strings of minor units.
@AdminController('cash-desk')
export class AdminRestaurantSettlementController {
  constructor(private readonly statements: MerchantStatementsService) {}

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
          totalDue: row.latest.totalDue.toString(),
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
