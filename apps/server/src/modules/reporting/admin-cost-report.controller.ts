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
import { operatingCostCauses } from '../ordering/index.js';
import { day } from './admin-restaurant-statements.controller.js';
import { compensationLineKinds } from './cost-report.js';
import {
  type CostReport,
  CostReportRefusedError,
  CostReportService,
} from './cost-report.service.js';

const signedMinor = z.string().regex(/^-?\d{1,18}$/);
const currency = z.string().regex(/^[A-Z]{3}$/);

class AdminCostReportQueryDto extends createZodDto(
  z.object({
    cityId: z.uuid(),
    from: day.optional().describe('The first business day; with `to`, or neither.'),
    to: day.optional().describe('The last business day; the last 7 days when both are left out.'),
  }),
) {}

const totals = {
  discounts: signedMinor.describe('Platform-funded discounts of the promo codes.'),
  compensation: signedMinor,
  operating: signedMinor,
  total: signedMinor,
};

class AdminCostReportDto extends createZodDto(
  z.object({
    cityId: z.uuid(),
    fromDay: day,
    toDay: day,
    from: z.iso.datetime().describe('The cutoff that starts the first day.'),
    to: z.iso.datetime().describe('The cutoff that ends the last day.'),
    currency: currency.describe('The city’s base: every amount is in it, + a cost.'),
    totals: z.object(totals),
    compensationReasons: z.array(
      z.object({
        kind: z
          .enum(compensationLineKinds)
          .describe(
            '`reason`: a reason of the compensation list; `late_delivery`: the automatic late codes; `other`: the rest.',
          ),
        reason: z.string().nullable().describe('The reason’s code, for `reason` only.'),
        label: z
          .string()
          .nullable()
          .describe('The reason’s label as chosen; null for the two fixed lines.'),
        orders: z.int().describe('The orders the codes were used on.'),
        amount: signedMinor,
      }),
    ),
    operatingReasons: z.array(
      z.object({ reason: z.enum(operatingCostCauses), orders: z.int(), amount: signedMinor }),
    ),
    codes: z.array(
      z.object({
        codeId: z.uuid().nullable(),
        code: z.string().nullable(),
        orders: z.int(),
        amount: signedMinor,
      }),
    ),
    parties: z.array(
      z.object({
        party: z
          .enum(['restaurant', 'captain', 'customer', 'platform'])
          .nullable()
          .describe('Who operations named responsible; null where nobody was named.'),
        orders: z.int(),
        amount: signedMinor,
      }),
    ),
    restaurants: z.array(
      z.object({
        restaurantId: z.uuid().nullable(),
        name: z.string().nullable(),
        ...totals,
      }),
    ),
  }),
) {}

const text = (amount: bigint) => amount.toString();

function reportBody(report: CostReport) {
  return {
    cityId: report.cityId,
    fromDay: report.fromDay,
    toDay: report.toDay,
    from: report.from.toISOString(),
    to: report.to.toISOString(),
    currency: report.currency,
    totals: {
      discounts: text(report.totals.discounts),
      compensation: text(report.totals.compensation),
      operating: text(report.totals.operating),
      total: text(report.totals.total),
    },
    compensationReasons: report.compensationReasons.map((row) => ({
      ...row,
      amount: text(row.amount),
    })),
    operatingReasons: report.operatingReasons.map((row) => ({ ...row, amount: text(row.amount) })),
    codes: report.codes.map((row) => ({ ...row, amount: text(row.amount) })),
    parties: report.parties.map((row) => ({ ...row, amount: text(row.amount) })),
    restaurants: report.restaurants.map((row) => ({
      restaurantId: row.restaurantId,
      name: row.name,
      discounts: text(row.discounts),
      compensation: text(row.compensation),
      operating: text(row.operating),
      total: text(row.total),
    })),
  };
}

// «كلفة التعويضات والخصومات» (AP §9.10.6, slice 2.22d): OWN and FIN
// (`finance.read`).
@AdminController('cost-report')
export class AdminCostReportController {
  constructor(private readonly reports: CostReportService) {}

  // The cost of codes, compensations and operating costs of the business
  // days `from` to `to`, split by reason, by code, by responsible party and
  // by restaurant. 400 invalid_period (one day without the other, a day that
  // does not exist, the last before the first, longer than 366 days, or
  // ending after today); 404 unknown_city; 409 no_base_currency,
  // rate_missing.
  @Get()
  @RequirePermission('finance.read')
  @ZodResponse({ status: 200, type: AdminCostReportDto })
  async report(@Query() query: AdminCostReportQueryDto) {
    const now = new Date();
    try {
      if ((query.from === undefined) !== (query.to === undefined)) {
        throw new CostReportRefusedError('invalid_period');
      }
      const period =
        query.from !== undefined && query.to !== undefined
          ? { from: query.from, to: query.to }
          : await this.reports.defaultPeriod(query.cityId, now);
      return reportBody(await this.reports.report(query.cityId, period.from, period.to, now));
    } catch (error) {
      if (!(error instanceof CostReportRefusedError)) throw error;
      throw costReportRefusal(error.refusal);
    }
  }
}

export function costReportRefusal(refusal: CostReportRefusedError['refusal']) {
  switch (refusal) {
    case 'invalid_period':
      return new BadRequestException({ statusCode: HttpStatus.BAD_REQUEST, error: refusal });
    case 'unknown_city':
      return new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, error: refusal });
    case 'no_base_currency':
    case 'rate_missing':
      return new ConflictException({ statusCode: HttpStatus.CONFLICT, error: refusal });
  }
}
