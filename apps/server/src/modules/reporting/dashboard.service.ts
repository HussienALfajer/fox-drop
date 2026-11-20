import { Injectable, Logger } from '@nestjs/common';
import { CaptainsService } from '../captains/index.js';
import { MerchantStatementsService, SettlementService } from '../cashdesk/index.js';
import { FxRefusedError } from '../fx/index.js';
import { cutoffOn, lastCutoff } from '../geo/index.js';
import { CustomerAccountsService } from '../identity/index.js';
import { ChangeRequestsService, MerchantsService } from '../merchants/index.js';
import { type AlertCode, AlertsService, receivedCodes } from '../notifications/index.js';
import { DashboardOrdersService } from '../ordering/index.js';
import type { DailyFigures } from './daily-figures.js';
import { DailyReportService } from './daily-report.service.js';
import {
  captainCounts,
  type DashboardRestaurantState,
  type DashboardTaskKey,
  dashboardRestaurantStates,
  dashboardTasks,
  hourlyCounts,
  type OrderTiles,
  orderTiles,
  restaurantCounts,
  taskForRoles,
  topRestaurants,
  troubledRestaurants,
} from './dashboard-figures.js';

const DAY_MS = 86_400_000;
const HOUR_MS = 3_600_000;
// AP §9.1.5: how many restaurants each list shows (decided by us).
export const DASHBOARD_LIST_SIZE = 10;

// The money tiles of AP §9.1.2, in the base.
export interface MoneyTiles {
  currency: string;
  gmv: bigint;
  itemsValue: bigint;
  deliveryFees: bigint;
  commission: bigint;
  margin: bigint;
}

export interface DashboardPeriod {
  from: Date;
  // Today: now; last week: the same moment of its business day.
  until: Date;
  orders: OrderTiles;
  // Null while an amount has no rate (rate_missing) or the city no base.
  money: MoneyTiles | null;
  newCustomers: number;
}

export interface Dashboard {
  cityId: string;
  // The business day running, YYYY-MM-DD on the city's clock, and the same
  // weekday a week before.
  day: string;
  lastWeekDay: string;
  status: {
    captains: ReturnType<typeof captainCounts>;
    restaurants: Record<DashboardRestaurantState, number>;
    // Open restaurants with no receiving device connected: null until the
    // presence of slice 2.42.
    withoutDevice: number | null;
  };
  today: DashboardPeriod;
  lastWeek: DashboardPeriod;
  tasks: { key: DashboardTaskKey; count: number }[];
  // Each hour of the business day on the city's clock (HH:MM, where it
  // starts), with the orders placed in it today and last week's whole hour.
  hours: { hour: string; today: number; lastWeek: number }[];
  topRestaurants: { restaurantId: string; name: string; orders: number }[];
  troubledRestaurants: { restaurantId: string; name: string; rejected: number; late: number }[];
}

// The alert each task counts (AP §9.1.3), open in the city.
const TASK_ALERTS: Partial<Record<DashboardTaskKey, readonly AlertCode[]>> = {
  compensationApprovals: ['compensation_approval'],
  applications: ['captain_application'],
  probationReviews: ['probation_ending', 'probation_overdue'],
  expiringDocuments: ['document_expiring'],
  acceptanceReviews: ['acceptance_review'],
  shortfalls: ['collection_shortfall'],
  overdueRestaurants: ['restaurant_settlement_overdue'],
};

// «لوحة التحكم» (AP §9.1.1–9.1.5; slice 2.40): the city's state now,
// today's figures against the same weekday last week up to the same moment
// of its business day, the tasks of the session's roles and the lists the
// charts will draw, each read from its module's public service.
@Injectable()
export class DashboardService {
  private readonly logger = new Logger('Dashboard');

  constructor(
    private readonly reports: DailyReportService,
    private readonly orders: DashboardOrdersService,
    private readonly captains: CaptainsService,
    private readonly merchants: MerchantsService,
    private readonly changeRequests: ChangeRequestsService,
    private readonly customers: CustomerAccountsService,
    private readonly alerts: AlertsService,
    private readonly statements: MerchantStatementsService,
    private readonly settlements: SettlementService,
  ) {}

  // Throws DailyReportRefusedError unknown_city.
  async read(cityId: string, roles: readonly string[], now: Date): Promise<Dashboard> {
    const { timeZone, cutoffMinutes } = await this.reports.clock(cityId);
    const todayFrom = lastCutoff(now, cutoffMinutes, timeZone);
    const day = dayOf(todayFrom, timeZone);
    const shift = (days: number) =>
      new Date(Date.parse(day) + days * DAY_MS).toISOString().slice(0, 10);
    const lastWeekDay = shift(-7);
    const todayTo = cutoffOn(shift(1), cutoffMinutes, timeZone);
    const lastWeekFrom = cutoffOn(lastWeekDay, cutoffMinutes, timeZone);
    const lastWeekTo = cutoffOn(shift(-6), cutoffMinutes, timeZone);
    // The same moment of last week's business day.
    const lastWeekUntil = new Date(lastWeekFrom.getTime() + (now.getTime() - todayFrom.getTime()));

    const captainsRead = this.captains.mapCaptains(cityId, now);
    const [todayOrders, lastWeekOrders, captains, rows, tasks, todayMoney, lastWeekMoney] =
      await Promise.all([
        this.orders.placedBetween(cityId, todayFrom, todayTo, now),
        this.orders.placedBetween(cityId, lastWeekFrom, lastWeekTo, now),
        captainsRead,
        this.merchants.listRows(cityId),
        this.tasks(cityId, roles, now, captainsRead),
        this.money(cityId, todayFrom, now, now),
        this.money(cityId, lastWeekFrom, lastWeekUntil, now),
      ]);
    const [todayCustomers, lastWeekCustomers, states] = await Promise.all([
      this.customers.newCustomersBetween(todayFrom, now),
      this.customers.newCustomersBetween(lastWeekFrom, lastWeekUntil),
      Promise.all(
        rows.map((row) =>
          row.accountStatus === 'draft' || row.accountStatus === 'terminated'
            ? null
            : this.restaurantState(row.id, now),
        ),
      ),
    ]);
    const names = new Map(rows.map((row) => [row.id, row.nameAr]));
    const named = <T extends { restaurantId: string }>(each: T) => ({
      ...each,
      name: names.get(each.restaurantId) ?? '',
    });

    const hourCount = Math.round((todayTo.getTime() - todayFrom.getTime()) / HOUR_MS);
    const todayHours = hourlyCounts(todayOrders, todayFrom, hourCount);
    const lastWeekHours = hourlyCounts(lastWeekOrders, lastWeekFrom, hourCount);
    const clock = new Intl.DateTimeFormat('en-GB', {
      timeZone,
      hour: '2-digit',
      minute: '2-digit',
      hourCycle: 'h23',
    });

    return {
      cityId,
      day,
      lastWeekDay,
      status: {
        captains: captainCounts(captains),
        restaurants: restaurantCounts(
          states.filter((state): state is DashboardRestaurantState => state !== null),
        ),
        withoutDevice: null,
      },
      today: {
        from: todayFrom,
        until: now,
        orders: orderTiles(todayOrders, now),
        money: todayMoney,
        newCustomers: todayCustomers,
      },
      lastWeek: {
        from: lastWeekFrom,
        until: lastWeekUntil,
        orders: orderTiles(lastWeekOrders, lastWeekUntil),
        money: lastWeekMoney,
        newCustomers: lastWeekCustomers,
      },
      tasks,
      hours: todayHours.map((count, index) => ({
        hour: clock.format(new Date(todayFrom.getTime() + index * HOUR_MS)),
        today: count,
        lastWeek: lastWeekHours[index]!,
      })),
      topRestaurants: topRestaurants(todayOrders, DASHBOARD_LIST_SIZE).map(named),
      troubledRestaurants: troubledRestaurants(todayOrders, DASHBOARD_LIST_SIZE).map(named),
    };
  }

  private async money(
    cityId: string,
    from: Date,
    until: Date,
    now: Date,
  ): Promise<MoneyTiles | null> {
    let figures: DailyFigures;
    try {
      figures = await this.reports.periodFigures(cityId, from, until, now);
    } catch (error) {
      if (error instanceof FxRefusedError) return null;
      throw error;
    }
    return {
      currency: figures.currency,
      gmv: figures.orders.gmv,
      itemsValue: figures.orders.itemsValue,
      deliveryFees: figures.deliveryFees,
      commission: figures.commission,
      margin: figures.margin,
    };
  }

  // AP §9.1.4: only the tasks the roles get are read.
  private async tasks(
    cityId: string,
    roles: readonly string[],
    now: Date,
    captainsRead: Promise<{ blocks: unknown[] }[]>,
  ) {
    const wants = (key: DashboardTaskKey) => taskForRoles(key, roles);
    const received = new Set(receivedCodes(roles));
    const [alerts, menuChanges, captains, restaurants, payouts] = await Promise.all([
      this.alerts.list(cityId, roles, false),
      wants('menuChanges') ? this.changeRequests.queue(cityId) : null,
      wants('cashBlocked') ? captainsRead : null,
      wants('settlementsDue') ? this.statements.restaurants(cityId, now) : null,
      wants('payoutsDue') ? this.settlements.list(cityId, now) : null,
    ]);
    const counts = {} as Record<DashboardTaskKey, number | null>;
    for (const [key, codes] of Object.entries(TASK_ALERTS) as [DashboardTaskKey, AlertCode[]][]) {
      counts[key] = codes.some((code) => received.has(code))
        ? alerts.filter((alert) => codes.includes(alert.code)).length
        : 0;
    }
    counts.menuChanges = menuChanges?.length ?? 0;
    counts.cashBlocked = captains?.filter((captain) => captain.blocks.length > 0).length ?? 0;
    counts.settlementsDue =
      restaurants?.restaurants.filter((row) => row.unpaid > 0n && row.overdueSince === null)
        .length ?? 0;
    counts.payoutsDue = payouts === null || !payouts.payoutDay ? null : payouts.captains.length;
    return dashboardTasks(roles, counts);
  }

  // The restaurant's state now; null (left out) when it cannot be read, so
  // one restaurant never hides the strip (as the live map).
  private async restaurantState(
    restaurantId: string,
    now: Date,
  ): Promise<DashboardRestaurantState | null> {
    try {
      const { state } = (await this.merchants.storefrontState(restaurantId, now)).state;
      return (dashboardRestaurantStates as readonly string[]).includes(state)
        ? (state as DashboardRestaurantState)
        : null;
    } catch (error) {
      this.logger.warn({ err: error, restaurantId }, 'a restaurant was left out of the strip');
      return null;
    }
  }
}

// The calendar day of an instant on the city's clock, YYYY-MM-DD.
function dayOf(instant: Date, timeZone: string): string {
  return new Intl.DateTimeFormat('en-CA', {
    timeZone,
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
  }).format(instant);
}
