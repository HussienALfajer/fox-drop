import {
  BadRequestException,
  ConflictException,
  Get,
  HttpStatus,
  NotFoundException,
  Query,
} from '@nestjs/common';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { RequirePermission } from '../../http/access.js';
import { AdminController } from '../../http/route-groups.js';
import { day } from './admin-restaurant-statements.controller.js';
import type { DailyFigures } from './daily-figures.js';
import {
  type DailyReport,
  DailyReportRefusedError,
  DailyReportService,
  type DayFigures,
} from './daily-report.service.js';

const signedMinor = z.string().regex(/^-?\d{1,18}$/);
const currency = z.string().regex(/^[A-Z]{3}$/);

class AdminDailyReportQueryDto extends createZodDto(
  z.object({
    cityId: z.uuid(),
    day: day.optional().describe('The business day; today’s when left out.'),
  }),
) {}

const dayFigures = z.object({
  day,
  from: z.iso.datetime().describe('The cutoff that starts the day.'),
  to: z.iso.datetime().describe('The cutoff that ends it.'),
  currency: currency.describe('The city’s base: every amount but the cash is in it.'),
  orders: z.object({ count: z.int(), gmv: signedMinor, itemsValue: signedMinor }),
  deliveryFees: signedMinor,
  discounts: z.object({ platform: signedMinor, restaurant: signedMinor }),
  commission: signedMinor.describe('Earned by the platform.'),
  captainPay: z.object({
    base: signedMinor,
    distance: signedMinor,
    waiting: signedMinor,
    peak: signedMinor,
    bonuses: signedMinor,
    total: signedMinor,
  }),
  compensation: signedMinor,
  operatingCost: signedMinor,
  testCost: signedMinor,
  fxRounding: signedMinor.describe('+ a gain for the platform.'),
  adjustments: signedMinor.describe('+ a gain for the platform.'),
  withheldDeposits: signedMinor.describe('Kit deposits withheld at termination, a revenue.'),
  margin: signedMinor,
  cash: z.array(
    z.object({
      currency,
      custodyCreated: signedMinor,
      handedIn: signedMinor,
      reimbursed: signedMinor,
      openCustody: signedMinor,
      owedToCaptains: signedMinor,
      captainPayouts: signedMinor,
      restaurantPayments: signedMinor,
    }),
  ),
  restaurants: z.object({
    commission: signedMinor,
    discountShare: signedMinor,
    owedByRestaurants: signedMinor,
    owedToRestaurants: signedMinor,
  }),
});

class AdminDailyReportDto extends createZodDto(
  dayFigures.extend({
    cityId: z.uuid(),
    today: z.boolean().describe('The day is still running.'),
    now: z
      .object({
        captainsBlocked: z.int(),
        overdueRestaurants: z.array(
          z.object({
            restaurantId: z.uuid(),
            name: z.string(),
            balance: signedMinor.describe('+ the restaurant owes.'),
            overdueSince: z.iso.datetime(),
          }),
        ),
      })
      .nullable()
      .describe('Today’s state; null for a past day.'),
    previous: z.array(dayFigures).describe('The days before, the nearest first.'),
  }),
) {}

function figuresBody(figures: DayFigures) {
  const text = (amount: bigint) => amount.toString();
  const all = <T extends Record<string, bigint>>(values: T) =>
    Object.fromEntries(Object.entries(values).map(([key, value]) => [key, text(value)])) as {
      [K in keyof T]: string;
    };
  const f: DailyFigures = figures;
  return {
    day: figures.day,
    from: figures.from.toISOString(),
    to: figures.to.toISOString(),
    currency: f.currency,
    orders: {
      count: f.orders.count,
      gmv: text(f.orders.gmv),
      itemsValue: text(f.orders.itemsValue),
    },
    deliveryFees: text(f.deliveryFees),
    discounts: all(f.discounts),
    commission: text(f.commission),
    captainPay: all(f.captainPay),
    compensation: text(f.compensation),
    operatingCost: text(f.operatingCost),
    testCost: text(f.testCost),
    fxRounding: text(f.fxRounding),
    adjustments: text(f.adjustments),
    withheldDeposits: text(f.withheldDeposits),
    margin: text(f.margin),
    cash: f.cash.map(({ currency: code, ...amounts }) => ({ currency: code, ...all(amounts) })),
    restaurants: all(f.restaurants),
  };
}

function reportBody(report: DailyReport) {
  return {
    ...figuresBody(report),
    cityId: report.cityId,
    today: report.today,
    now:
      report.now === null
        ? null
        : {
            captainsBlocked: report.now.captainsBlocked,
            overdueRestaurants: report.now.overdueRestaurants.map((row) => ({
              restaurantId: row.restaurantId,
              name: row.name,
              balance: row.balance.toString(),
              overdueSince: row.overdueSince.toISOString(),
            })),
          },
    previous: report.previous.map(figuresBody),
  };
}

// «التقرير اليومي» (AP §9.10.1, slice 2.20d): OWN and FIN (`finance.read`).
@AdminController('daily-report')
export class AdminDailyReportController {
  constructor(private readonly reports: DailyReportService) {}

  // A business day's report with the six days before. 400 invalid_day (a
  // day that does not exist or has not started); 404 unknown_city; 409
  // no_base_currency, rate_missing (an amount in a currency with no rate by
  // the day's end).
  @Get()
  @RequirePermission('finance.read')
  @ZodResponse({ status: 200, type: AdminDailyReportDto })
  async report(@Query() query: AdminDailyReportQueryDto) {
    const now = new Date();
    try {
      const day = query.day ?? (await this.reports.today(query.cityId, now));
      return reportBody(await this.reports.report(query.cityId, day, now));
    } catch (error) {
      if (!(error instanceof DailyReportRefusedError)) throw error;
      throw dailyReportRefusal(error.refusal);
    }
  }
}

export function dailyReportRefusal(refusal: DailyReportRefusedError['refusal']) {
  switch (refusal) {
    case 'invalid_day':
      return new BadRequestException({ statusCode: HttpStatus.BAD_REQUEST, error: refusal });
    case 'unknown_city':
      return new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, error: refusal });
    case 'no_base_currency':
    case 'rate_missing':
      return new ConflictException({ statusCode: HttpStatus.CONFLICT, error: refusal });
  }
}
