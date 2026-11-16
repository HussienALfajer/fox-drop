import { BadRequestException, Get, HttpStatus, NotFoundException, Query } from '@nestjs/common';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { RequirePermission } from '../../http/access.js';
import { AdminController } from '../../http/route-groups.js';
import {
  merchantExceptionCauses,
  MerchantPeriodService,
  merchantStatementLineKinds,
  type RestaurantPeriodStatement,
} from '../cashdesk/index.js';
import { MerchantsService } from '../merchants/index.js';

const signedMinor = z.string().regex(/^-?\d{1,18}$/);
const currency = z.string().regex(/^[A-Z]{3}$/);
export const day = z
  .string()
  .regex(/^\d{4}-\d{2}-\d{2}$/)
  .describe('A business day on the city’s clock, YYYY-MM-DD.');

class AdminStatementRestaurantsQueryDto extends createZodDto(z.object({ cityId: z.uuid() })) {}

class AdminStatementRestaurantsDto extends createZodDto(
  z.object({
    restaurants: z.array(z.object({ id: z.uuid(), name: z.string() })),
  }),
) {}

export const restaurantPeriodQuery = z.object({
  restaurantId: z.uuid(),
  from: day,
  to: day,
});

class AdminRestaurantPeriodQueryDto extends createZodDto(restaurantPeriodQuery) {}

class AdminRestaurantPeriodStatementDto extends createZodDto(
  z.object({
    restaurantId: z.uuid(),
    restaurantName: z.string(),
    cityId: z.uuid(),
    currency: currency.nullable(),
    fromDay: day,
    toDay: day,
    from: z.iso.datetime().describe('The cutoff that starts the first day.'),
    to: z.iso.datetime().describe('The cutoff that ends the last day.'),
    opening: signedMinor.describe('+ the restaurant owes, − the platform owes it.'),
    orders: z.int(),
    itemsValue: signedMinor,
    commission: signedMinor,
    discountShare: signedMinor,
    exceptions: signedMinor,
    paid: signedMinor,
    closing: signedMinor,
    // Flat, since the Dart generator misnames an enum inside a nested object.
    lines: z.array(
      z.object({
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
        receiptId: z.uuid().nullable(),
        receiptNumber: z.string().nullable(),
      }),
    ),
  }),
) {}

export function periodBody(statement: RestaurantPeriodStatement) {
  return {
    restaurantId: statement.restaurantId,
    restaurantName: statement.restaurantName,
    cityId: statement.cityId,
    currency: statement.currency,
    fromDay: statement.fromDay,
    toDay: statement.toDay,
    from: statement.from.toISOString(),
    to: statement.to.toISOString(),
    opening: statement.opening.toString(),
    orders: statement.orders,
    itemsValue: statement.itemsValue.toString(),
    commission: statement.commission.toString(),
    discountShare: statement.discountShare.toString(),
    exceptions: statement.exceptions.toString(),
    paid: statement.paid.toString(),
    closing: statement.closing.toString(),
    lines: statement.lines.map((line) =>
      line.kind === 'order'
        ? {
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
            receiptId: null,
            receiptNumber: null,
          }
        : {
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
            receiptId: line.receipt?.id ?? null,
            receiptNumber: line.receipt?.number ?? null,
          },
    ),
  };
}

// Throws the route's refusals: 404 unknown_restaurant, 400 invalid_period.
export async function periodOrRefuse(
  periods: MerchantPeriodService,
  query: z.infer<typeof restaurantPeriodQuery>,
): Promise<RestaurantPeriodStatement> {
  const found = await periods.statement(query.restaurantId, query.from, query.to);
  if (found === null) {
    throw new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, error: 'unknown_restaurant' });
  }
  if (found === 'invalid_period') {
    throw new BadRequestException({ statusCode: HttpStatus.BAD_REQUEST, error: 'invalid_period' });
  }
  return found;
}

// «كشوف المطاعم» (AP §9.10.5, slice 2.19g): any restaurant and any period,
// under «Statements and settlement» of AP §6.2 (OWN, FIN). Money travels as
// strings of minor units.
@AdminController('restaurant-statements')
export class AdminRestaurantStatementsController {
  constructor(
    private readonly periods: MerchantPeriodService,
    private readonly merchants: MerchantsService,
  ) {}

  // The city's restaurants to choose from, by name.
  @Get('restaurants')
  @RequirePermission('restaurants.statements')
  @ZodResponse({ status: 200, type: AdminStatementRestaurantsDto })
  async restaurants(@Query() query: AdminStatementRestaurantsQueryDto) {
    const rows = await this.merchants.restaurantIds(query.cityId);
    return { restaurants: rows.map((row) => ({ id: row.id, name: row.nameAr })) };
  }

  // The statement of the business days `from` to `to`, both included.
  // 404 unknown_restaurant; 400 invalid_period (the last day before the
  // first, a day that does not exist, or longer than a year and a day).
  @Get()
  @RequirePermission('restaurants.statements')
  @ZodResponse({ status: 200, type: AdminRestaurantPeriodStatementDto })
  async statement(@Query() query: AdminRestaurantPeriodQueryDto) {
    return periodBody(await periodOrRefuse(this.periods, query));
  }
}
