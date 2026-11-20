import { Get, Query } from '@nestjs/common';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { CurrentAdminSession, RequirePermission } from '../../http/access.js';
import { AdminController } from '../../http/route-groups.js';
import type { AdminSession } from '../identity/index.js';
import { dailyReportRefusal } from './admin-daily-report.controller.js';
import { day } from './admin-restaurant-statements.controller.js';
import { dashboardRestaurantStates, dashboardTaskKeys } from './dashboard-figures.js';
import { type DashboardPeriod, DashboardService } from './dashboard.service.js';
import { DailyReportRefusedError } from './daily-report.service.js';

const signedMinor = z.string().regex(/^-?\d{1,18}$/);
const basisPoints = z.int().nullable().describe('In basis points; null without an order to count.');

class AdminDashboardQueryDto extends createZodDto(z.object({ cityId: z.uuid() })) {}

const period = z.object({
  from: z.iso.datetime().describe('The business day’s cutoff.'),
  until: z.iso.datetime().describe('Today: now; last week: the same moment of its day.'),
  orders: z.object({
    placed: z.int(),
    delivered: z.int(),
    inProgress: z.int().describe('Placed to arrived now.'),
    cancelled: z.int(),
    rejected: z.int(),
    failed: z.int(),
    deliveryMinutes: z
      .number()
      .nullable()
      .describe('Of the delivered: placing to delivery, one decimal.'),
    onTimeBp: basisPoints.describe('Of the delivered: at or before the promised time.'),
    successBp: basisPoints.describe('Delivered ÷ placed.'),
    firstOrders: z.int(),
  }),
  money: z
    .object({
      currency: z.string().regex(/^[A-Z]{3}$/),
      gmv: signedMinor.describe('The customer totals of the orders delivered.'),
      itemsValue: signedMinor,
      deliveryFees: signedMinor,
      commission: signedMinor,
      margin: signedMinor,
    })
    .nullable()
    .describe('In the base; null while an amount has no rate.'),
  newCustomers: z.int().describe('Accounts registered, every city’s.'),
});

class AdminDashboardDto extends createZodDto(
  z.object({
    cityId: z.uuid(),
    day,
    lastWeekDay: day,
    status: z.object({
      captains: z.object({
        online: z.int(),
        available: z.int(),
        busy: z.int(),
        cashBlocked: z.int(),
      }),
      restaurants: z.object(
        Object.fromEntries(dashboardRestaurantStates.map((state) => [state, z.int()])) as Record<
          (typeof dashboardRestaurantStates)[number],
          z.ZodInt
        >,
      ),
      withoutDevice: z.int().nullable().describe('Null until the receiving devices’ presence.'),
    }),
    today: period,
    lastWeek: period,
    tasks: z.array(z.object({ key: z.enum(dashboardTaskKeys), count: z.int() })),
    hours: z.array(z.object({ hour: z.string(), today: z.int(), lastWeek: z.int() })),
    topRestaurants: z.array(
      z.object({ restaurantId: z.uuid(), name: z.string(), orders: z.int() }),
    ),
    troubledRestaurants: z.array(
      z.object({
        restaurantId: z.uuid(),
        name: z.string(),
        rejected: z.int(),
        late: z.int(),
      }),
    ),
  }),
) {}

function periodBody(each: DashboardPeriod) {
  return {
    from: each.from.toISOString(),
    until: each.until.toISOString(),
    orders: each.orders,
    money: each.money && {
      currency: each.money.currency,
      gmv: each.money.gmv.toString(),
      itemsValue: each.money.itemsValue.toString(),
      deliveryFees: each.money.deliveryFees.toString(),
      commission: each.money.commission.toString(),
      margin: each.money.margin.toString(),
    },
    newCustomers: each.newCustomers,
  };
}

// «لوحة التحكم» (AP §9.1, §6.2; slice 2.40): OWN and OPS, SUP and FIN
// read (`dashboard.read`). The tasks follow the session's roles.
@AdminController('dashboard')
export class AdminDashboardController {
  constructor(private readonly dashboard: DashboardService) {}

  // 404 unknown_city.
  @Get()
  @RequirePermission('dashboard.read')
  @ZodResponse({ status: 200, type: AdminDashboardDto })
  async read(@Query() query: AdminDashboardQueryDto, @CurrentAdminSession() session: AdminSession) {
    try {
      const read = await this.dashboard.read(query.cityId, session.roles, new Date());
      return { ...read, today: periodBody(read.today), lastWeek: periodBody(read.lastWeek) };
    } catch (error) {
      if (!(error instanceof DailyReportRefusedError)) throw error;
      throw dailyReportRefusal(error.refusal);
    }
  }
}
