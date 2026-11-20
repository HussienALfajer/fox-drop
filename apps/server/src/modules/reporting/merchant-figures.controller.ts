import { BadRequestException, ForbiddenException, Get, HttpStatus, Query } from '@nestjs/common';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { AppSignedIn, CurrentAppSession } from '../../http/access.js';
import { MerchantController } from '../../http/route-groups.js';
import type { AppSession } from '../identity/index.js';
import { MerchantsService } from '../merchants/index.js';
import { day } from './admin-restaurant-statements.controller.js';
import { ReportsService } from './reports.service.js';
import { ownerPeriods, type RestaurantFigures } from './restaurant-report.js';

class MerchantFiguresQueryDto extends createZodDto(
  z.object({
    period: z
      .enum(ownerPeriods)
      .optional()
      .describe('RA §11: «اليوم», «أمس», «آخر 7 أيام», «آخر 30 يوماً»; or `day`.'),
    day: day
      .optional()
      .describe('A business day on the city’s clock, for the daily summary; or `period`.'),
  }),
) {}

const minor = z.string().regex(/^-?\d{1,18}$/);
const item = z
  .object({
    itemId: z.uuid(),
    name: z.string().describe('Its name on the latest order.'),
    quantity: z.int(),
    sales: minor,
  })
  .meta({ id: 'MerchantFiguresItem' });

const figures = z
  .object({
    received: z.int().describe('Orders that reached the restaurant.'),
    acceptedByYou: z.int(),
    acceptedByOperations: z.int().describe('Accepted on the restaurant’s behalf (RA §8.15).'),
    rejected: z.int(),
    rejections: z.array(z.object({ label: z.string(), byOperations: z.boolean(), count: z.int() })),
    unanswered: z.int().describe('Cancelled automatically for no response (RA §8.3).'),
    acceptanceBp: z
      .int()
      .nullable()
      .describe('Accepted by you ÷ (received − cancelled by the customer before any answer).'),
    delivered: z.int(),
    sales: minor.describe('Items value of the delivered orders, after any edits.'),
    averageOrder: minor.nullable(),
    commission: minor.describe('From the restaurant account’s entries of the period (RA §12).'),
    discounts: minor.describe('Restaurant-funded discounts, from the same entries.'),
    net: minor.describe('Sales less the commission and the discounts.'),
    acceptMinutes: z.number().nullable().describe('Placed to accepted, by restaurant users only.'),
    prepActualMinutes: z.number().nullable(),
    prepChosenMinutes: z.number().nullable(),
    lateBp: z.int().nullable().describe('Ready (or picked up) after the time chosen ÷ accepted.'),
    readyNotPressed: z.int(),
    captainWaitMinutes: z.number().nullable(),
    rating: z.object({ count: z.int(), average: z.number().nullable() }),
    topByQuantity: z.array(item),
    topBySales: z.array(item),
    hours: z.array(z.object({ hour: z.int(), delivered: z.int() })),
    pauseMinutes: z.object({ restaurant: z.int(), ops: z.int(), auto: z.int() }),
  })
  .meta({ id: 'MerchantFigures' });

class MerchantFiguresDto extends createZodDto(
  z.object({
    from: z.iso.datetime(),
    to: z.iso.datetime().describe('The period’s end, or now while it runs.'),
    currency: z.string().describe('The money’s currency, the city’s base.'),
    current: figures,
    // The previous period of the same length, for the arrows.
    previous: figures,
  }),
) {}

function body(figures: RestaurantFigures) {
  const text = (amount: bigint) => amount.toString();
  const items = (list: RestaurantFigures['topBySales']) =>
    list.map(({ itemId, name, quantity, sales }) => ({
      itemId,
      name,
      quantity,
      sales: text(sales),
    }));
  return {
    ...figures,
    sales: text(figures.sales),
    averageOrder: figures.averageOrder === null ? null : text(figures.averageOrder),
    commission: text(figures.commission),
    discounts: text(figures.discounts),
    net: text(figures.net),
    topByQuantity: items(figures.topByQuantity),
    topBySales: items(figures.topBySales),
  };
}

// RA §11 (slice 2.41): the owners' reports in the restaurant app, and a
// day's figures for «الملخص اليومي». Owners only (a cashier gets 403
// owner_only); a terminated restaurant keeps only the money section (RA
// §5.5, 403 restaurant_terminated).
@MerchantController()
export class MerchantFiguresController {
  constructor(
    private readonly reports: ReportsService,
    private readonly merchants: MerchantsService,
  ) {}

  // One of `period` and `day` (400 invalid_period otherwise, or a day not
  // started yet).
  @Get('figures')
  @AppSignedIn()
  @ZodResponse({ status: 200, type: MerchantFiguresDto })
  async read(@CurrentAppSession() session: AppSession, @Query() query: MerchantFiguresQueryDto) {
    const merchant = session.merchant;
    if (!merchant) throw new Error('a merchant route without a restaurant user');
    if (merchant.role !== 'owner') {
      throw new ForbiddenException({ statusCode: HttpStatus.FORBIDDEN, error: 'owner_only' });
    }
    const restaurant = await this.merchants.restaurant(merchant.restaurantId);
    if (!restaurant) throw new Error('the session names no restaurant');
    if (restaurant.accountStatus === 'terminated') {
      throw new ForbiddenException({
        statusCode: HttpStatus.FORBIDDEN,
        error: 'restaurant_terminated',
      });
    }
    const invalid = () =>
      new BadRequestException({ statusCode: HttpStatus.BAD_REQUEST, error: 'invalid_period' });
    if ((query.period === undefined) === (query.day === undefined)) throw invalid();
    const report = await this.reports.restaurantReport(
      restaurant,
      query.period !== undefined ? { period: query.period } : { day: query.day! },
      new Date(),
    );
    if (report === null) throw invalid();
    return {
      from: report.from.toISOString(),
      to: report.to.toISOString(),
      currency: report.currency,
      current: body(report.current),
      previous: body(report.previous),
    };
  }
}
