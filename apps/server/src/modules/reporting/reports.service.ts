import { Injectable } from '@nestjs/common';
import { CaptainsService } from '../captains/index.js';
import { periodFits } from '../cashdesk/index.js';
import { CustomersService, LostDemandService, maskedPhone } from '../customers/index.js';
import { DispatchService } from '../dispatch/index.js';
import { FxRefusedError, FxService } from '../fx/index.js';
import { cutoffOn, GeoService, lastCutoff } from '../geo/index.js';
import { CustomerAccountsService } from '../identity/index.js';
import { LedgerService } from '../ledger/index.js';
import { PromoCodeUsesService } from '../marketing/index.js';
import { MerchantsService } from '../merchants/index.js';
import { periodBounds, ReportOrdersService } from '../ordering/index.js';
import { ContentService } from '../content/index.js';
import { DailyReportService } from './daily-report.service.js';
import {
  captainsReport,
  codesReport,
  customersReport,
  lostDemandReport,
  ordersReport,
  type ReportTable,
  restaurantsReport,
  timingsReport,
  topCustomerIds,
} from './report-tables.js';
import { financeReport } from './finance-report.js';
import {
  type OwnerPeriod,
  type RestaurantFigures,
  restaurantFigures,
} from './restaurant-report.js';

// AP §9.17: the reports of «التقارير», each exported to Excel.
export const reportKinds = [
  'orders',
  'timings',
  'restaurants',
  'captains',
  'customers',
  'lost_demand',
  'codes',
  'finance',
] as const;
export type ReportKind = (typeof reportKinds)[number];

// AP §6.2 «Reports»: OWN all of them (`reports.all`), OPS the operations
// reports, SUP the support reports, FIN the financial reports. Which report
// is whose is decided by us (to confirm with the owner): the customers
// report is support's and operations'; the codes and finance reports are
// finance's.
export const reportPermissions: Record<ReportKind, readonly string[]> = {
  orders: ['reports.all', 'reports.operations'],
  timings: ['reports.all', 'reports.operations'],
  restaurants: ['reports.all', 'reports.operations'],
  captains: ['reports.all', 'reports.operations'],
  customers: ['reports.all', 'reports.operations', 'reports.support'],
  lost_demand: ['reports.all', 'reports.operations'],
  codes: ['reports.all', 'reports.financial'],
  finance: ['reports.all', 'reports.financial'],
};

export function mayRead(kind: ReportKind, permissions: readonly string[]): boolean {
  return reportPermissions[kind].some((permission) => permissions.includes(permission));
}

export interface Report {
  kind: ReportKind;
  cityId: string;
  fromDay: string;
  toDay: string;
  from: Date;
  to: Date;
  // The city's base: every `money` cell is in it unless its row names
  // another currency.
  currency: string;
  tables: ReportTable[];
}

export type ReportRefusal = 'invalid_period' | 'unknown_city' | 'no_base_currency' | 'rate_missing';

export class ReportRefusedError extends Error {
  override readonly name = 'ReportRefusedError';
  constructor(readonly refusal: ReportRefusal) {
    super(refusal);
  }
}

const DAY_MS = 86_400_000;

// The days a report opens on when no period is asked.
export const DEFAULT_REPORT_DAYS = 7;
const nextDay = (day: string) => new Date(Date.parse(day) + DAY_MS).toISOString().slice(0, 10);

// The business days from one to another, both included.
export function daysOf(fromDay: string, toDay: string): string[] {
  const days: string[] = [];
  for (let day = fromDay; day <= toDay; day = nextDay(day)) days.push(day);
  return days;
}

// AP §9.17 (slice 2.41): a report over the business days `from` to `to` on
// the city's clock, each included, read from the modules' public services.
// `fullPhones` answers the top customers' numbers in full (an export with
// `exports.phone_numbers`, AP §5.4); masked otherwise.
@Injectable()
export class ReportsService {
  constructor(
    private readonly days: DailyReportService,
    private readonly orders: ReportOrdersService,
    private readonly merchants: MerchantsService,
    private readonly geo: GeoService,
    private readonly fx: FxService,
    private readonly captains: CaptainsService,
    private readonly dispatch: DispatchService,
    private readonly ledger: LedgerService,
    private readonly customers: CustomersService,
    private readonly customerAccounts: CustomerAccountsService,
    private readonly lostDemand: LostDemandService,
    private readonly codes: PromoCodeUsesService,
    private readonly content: ContentService,
  ) {}

  // The period a report opens on: the last DEFAULT_REPORT_DAYS business
  // days, today's included (decided by us, as the cost report's).
  async defaultPeriod(cityId: string, now: Date): Promise<{ from: string; to: string } | null> {
    if ((await this.geo.cityTimeZone(cityId)) === null) return null;
    const clock = await this.days.clock(cityId);
    const to = new Intl.DateTimeFormat('en-CA', { timeZone: clock.timeZone }).format(
      lastCutoff(now, clock.cutoffMinutes, clock.timeZone),
    );
    const from = new Date(Date.parse(to) - (DEFAULT_REPORT_DAYS - 1) * DAY_MS)
      .toISOString()
      .slice(0, 10);
    return { from, to };
  }

  // RA §11 (slice 2.41): a restaurant's figures over an owner's period, or a
  // business day (`day`, the daily summary), with the previous period of
  // the same length for the arrows: «اليوم» so far against the same length
  // of yesterday from its cutoff, a whole day or 7 or 30 days against those
  // just before. A day not started yet (or not a day) is null.
  async restaurantReport(
    restaurant: { id: string; cityId: string },
    asked: { period: OwnerPeriod } | { day: string },
    now: Date,
  ): Promise<{
    from: Date;
    to: Date;
    currency: string;
    current: RestaurantFigures;
    previous: RestaurantFigures;
  } | null> {
    const clock = await this.days.clock(restaurant.cityId);
    let from: Date;
    let to: Date;
    if ('period' in asked) {
      const bounds = periodBounds(asked.period, now, clock.cutoffMinutes, clock.timeZone);
      from = bounds.from!;
      to = bounds.to ?? now;
    } else {
      from = cutoffOn(asked.day, clock.cutoffMinutes, clock.timeZone);
      if (from > now) return null;
      const end = cutoffOn(nextDay(asked.day), clock.cutoffMinutes, clock.timeZone);
      to = end < now ? end : now;
    }
    const length = to.getTime() - from.getTime();
    const before = new Date(from.getTime() - length);
    const currency = (await this.fx.baseCurrency(restaurant.cityId)) ?? '';
    const [current, previous] = await Promise.all([
      this.restaurantFigures(restaurant, from, to, currency, clock),
      this.restaurantFigures(restaurant, before, from, currency, clock),
    ]);
    return { from, to, currency, current, previous };
  }

  private async restaurantFigures(
    restaurant: { id: string; cityId: string },
    from: Date,
    to: Date,
    currency: string,
    clock: { timeZone: string; cutoffMinutes: number },
  ): Promise<RestaurantFigures> {
    const [orders, items, ratings, pauses, money] = await Promise.all([
      this.orders.placedBetween({ restaurantId: restaurant.id }, from, to),
      this.orders.deliveredItems(restaurant.id, from, to),
      this.orders.ratingsBetween('restaurant', [restaurant.id], from, to),
      this.merchants.pauseMinutes([restaurant.id], from, to),
      this.ledger.ownerTotals(
        restaurant.cityId,
        'merchant.account',
        ['merchant.commission', 'merchant.discount_share'],
        from,
        to,
        restaurant.id,
      ),
    ]);
    const sum = (type: string) =>
      money
        .filter((row) => row.type === type && row.currency === currency)
        .reduce((total, row) => total + row.amount, 0n);
    return restaurantFigures({
      orders,
      items: items.filter((item) => item.currency === currency),
      rating: ratings.get(restaurant.id),
      pauses: pauses.get(restaurant.id),
      money: { commission: sum('merchant.commission'), discounts: sum('merchant.discount_share') },
      currency,
      clock,
    });
  }

  // Why a period's report cannot be read, or null: as the cost report's.
  async check(
    cityId: string,
    fromDay: string,
    toDay: string,
    now: Date,
  ): Promise<ReportRefusal | null> {
    if (!periodFits(fromDay, toDay)) return 'invalid_period';
    if ((await this.geo.cityTimeZone(cityId)) === null) return 'unknown_city';
    const clock = await this.days.clock(cityId);
    if (cutoffOn(toDay, clock.cutoffMinutes, clock.timeZone) > now) return 'invalid_period';
    if ((await this.fx.baseCurrency(cityId)) === null) return 'no_base_currency';
    return null;
  }

  async report(
    kind: ReportKind,
    cityId: string,
    fromDay: string,
    toDay: string,
    now: Date,
    options: { fullPhones: boolean } = { fullPhones: false },
  ): Promise<Report> {
    const refusal = await this.check(cityId, fromDay, toDay, now);
    if (refusal !== null) throw new ReportRefusedError(refusal);
    const clock = await this.days.clock(cityId);
    const from = cutoffOn(fromDay, clock.cutoffMinutes, clock.timeZone);
    const end = cutoffOn(nextDay(toDay), clock.cutoffMinutes, clock.timeZone);
    // A period running today is read up to now.
    const to = end < now ? end : now;
    const currency = (await this.fx.baseCurrency(cityId))!;
    const scope = { cityId };
    const restaurantNames = async () =>
      new Map((await this.merchants.listRows(cityId)).map((row) => [row.id, row.nameAr] as const));
    let tables: ReportTable[];
    switch (kind) {
      case 'orders': {
        const [orders, names, zones, customerReasons] = await Promise.all([
          this.orders.placedBetween(scope, from, to),
          restaurantNames(),
          this.geo.zones(cityId),
          this.content.reasonsOf('customer_cancel'),
        ]);
        tables = ordersReport({
          cancelLabels: new Map(customerReasons.map((reason) => [reason.code, reason.label])),
          orders,
          clock,
          days: daysOf(fromDay, toDay),
          zoneNames: new Map(zones.map((zone) => [zone.id, zone.name])),
          restaurantNames: names,
        });
        break;
      }
      case 'timings':
        tables = timingsReport(await this.orders.placedBetween(scope, from, to));
        break;
      case 'restaurants': {
        const [orders, rows] = await Promise.all([
          this.orders.placedBetween(scope, from, to),
          this.merchants.listRows(cityId),
        ]);
        const ordered = new Set(orders.map((row) => row.restaurantId));
        const restaurants = rows
          .filter(
            (row) =>
              ordered.has(row.id) ||
              row.accountStatus === 'active' ||
              row.accountStatus === 'suspended',
          )
          .map((row) => ({ id: row.id, name: row.nameAr }));
        const ids = restaurants.map((row) => row.id);
        const [ratings, pauses] = await Promise.all([
          this.orders.ratingsBetween('restaurant', ids, from, to),
          this.merchants.pauseMinutes(ids, from, to),
        ]);
        tables = restaurantsReport({
          orders,
          restaurants,
          ratings,
          pauses: new Map(
            [...pauses].map(([id, sources]) => [
              id,
              [...sources.values()].reduce((total, minutes) => total + minutes, 0),
            ]),
          ),
          currency,
        });
        break;
      }
      case 'captains': {
        const [orders, captains, offers, earnings, online] = await Promise.all([
          this.orders.placedBetween(scope, from, to),
          this.captains.captainIds(cityId),
          this.dispatch.acceptanceBetween(cityId, from, to),
          this.ledger.ownerTotals(
            cityId,
            'captain.earnings',
            ['earn.order_pay', 'earn.waiting_pay', 'earn.peak_bonus', 'earn.bonus', 'earn.charge'],
            from,
            to,
          ),
          this.captains.onlineMinutesOfCity(cityId, from, to),
        ]);
        const notTerminated = new Set(await this.captains.captainsNotTerminated(cityId));
        const delivered = new Set(
          orders.flatMap((row) => (row.captainId === null ? [] : [row.captainId])),
        );
        const earned = new Map<string, bigint>();
        for (const row of earnings) {
          if (row.currency === currency) {
            earned.set(row.ownerId, (earned.get(row.ownerId) ?? 0n) + row.amount);
          }
        }
        const listed = captains.filter(
          (captain) =>
            notTerminated.has(captain.id) ||
            delivered.has(captain.id) ||
            earned.has(captain.id) ||
            (online.get(captain.id) ?? 0) > 0,
        );
        const ids = listed.map((captain) => captain.id);
        const [faults, ratings] = await Promise.all([
          this.orders.captainFaults(ids, from, to),
          this.orders.ratingsBetween('captain', ids, from, to),
        ]);
        tables = captainsReport({
          captains: listed,
          orders,
          offers,
          faults,
          earnings: earned,
          onlineMinutes: online,
          ratings,
        });
        break;
      }
      case 'customers': {
        const [orders, blocks] = await Promise.all([
          this.orders.placedBetween(scope, from, to),
          this.customers.blocksBetween(from, to),
        ]);
        const accountIds = [...new Set(orders.map((row) => row.customerAccountId))];
        const profiles = await this.customers.reportProfiles(accountIds);
        const phones = new Map<string, string>();
        await Promise.all(
          topCustomerIds(orders, currency).map(async (accountId) => {
            const phone = await this.customerAccounts.phone(accountId);
            if (phone !== null) {
              phones.set(accountId, options.fullPhones ? phone : maskedPhone(phone));
            }
          }),
        );
        tables = customersReport({
          orders,
          profiles,
          phones,
          blocks,
          lastDay: toDay,
          currency,
        });
        break;
      }
      case 'lost_demand': {
        const [votes, demand, emergency] = await Promise.all([
          this.geo.votesBetween(cityId, from, to),
          this.lostDemand.between(cityId, from, to),
          this.orders.emergencyAttempts(cityId, from, to),
        ]);
        tables = lostDemandReport({
          votes,
          searches: demand.searches,
          suggestions: demand.suggestions,
          emergency,
        });
        break;
      }
      case 'codes':
        tables = codesReport({
          codes: await this.codes.periodReport(cityId, from, to),
          currency,
        });
        break;
      case 'finance': {
        try {
          const [period, days] = await Promise.all([
            this.days.periodFigures(cityId, from, to, now),
            this.days.figures(cityId, daysOf(fromDay, toDay), clock, now),
          ]);
          tables = financeReport(period, days);
        } catch (error) {
          if (error instanceof FxRefusedError && error.refusal === 'rate_missing') {
            throw new ReportRefusedError('rate_missing');
          }
          throw error;
        }
        break;
      }
    }
    return { kind, cityId, fromDay, toDay, from, to, currency, tables };
  }
}
