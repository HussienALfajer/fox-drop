import { Injectable } from '@nestjs/common';
import { CaptainsService } from '../captains/index.js';
import { isDay, MerchantStatementsService } from '../cashdesk/index.js';
import { FxRefusedError, FxService } from '../fx/index.js';
import { cutoffOn, GeoService, lastCutoff } from '../geo/index.js';
import { LedgerService } from '../ledger/index.js';
import { OrdersService } from '../ordering/index.js';
import { SettingsService } from '../settings/index.js';
import { dailyFigures, type DailyFigures } from './daily-figures.js';

// The previous business days the report compares with (AP §9.10.1
// «Comparison with previous days»; decided by us: the week before).
export const COMPARED_DAYS = 6;

const DAY_MS = 86_400_000;

export interface DayFigures extends DailyFigures {
  // The business day, YYYY-MM-DD on the city's clock, and the instants it
  // runs between: its cutoff to the next day's.
  day: string;
  from: Date;
  to: Date;
}

// What only today's report shows: the state now, which no ledger entry
// dates (AP §9.10.1 «captains blocked», «overdue restaurants»).
export interface ReportNow {
  captainsBlocked: number;
  overdueRestaurants: {
    restaurantId: string;
    name: string;
    // What the restaurant owes now, in the base, and since when it is
    // overdue.
    balance: bigint;
    overdueSince: Date;
  }[];
}

export interface DailyReport extends DayFigures {
  cityId: string;
  // The day is today's business day, still running.
  today: boolean;
  // Today's only, null for a past day.
  now: ReportNow | null;
  // The days before, the nearest first.
  previous: DayFigures[];
}

export type DailyReportRefusal =
  | 'invalid_day'
  | 'unknown_city'
  | 'no_base_currency'
  // An amount in a currency with no rate by the day's end.
  | 'rate_missing';

export class DailyReportRefusedError extends Error {
  override readonly name = 'DailyReportRefusedError';
  constructor(readonly refusal: DailyReportRefusal) {
    super(refusal);
  }
}

// «التقرير اليومي» (AP §9.10.1, slice 2.20d): a business day's figures from
// the ledger and the orders, compared with the days before.
@Injectable()
export class DailyReportService {
  constructor(
    private readonly ledger: LedgerService,
    private readonly orders: OrdersService,
    private readonly fx: FxService,
    private readonly geo: GeoService,
    private readonly settings: SettingsService,
    private readonly captains: CaptainsService,
    private readonly restaurants: MerchantStatementsService,
  ) {}

  // The business day running now on the city's clock.
  async today(cityId: string, now: Date): Promise<string> {
    const { timeZone, cutoffMinutes } = await this.clock(cityId);
    return dayOf(lastCutoff(now, cutoffMinutes, timeZone), timeZone);
  }

  // Why a day's report cannot be read, or null: `invalid_day` for a day that
  // does not exist or has not started, `unknown_city`, `no_base_currency`.
  async check(cityId: string, day: string, now: Date): Promise<DailyReportRefusal | null> {
    if (!isDay(day)) return 'invalid_day';
    const clock = await this.clock(cityId).catch((error: unknown) => {
      if (error instanceof DailyReportRefusedError) return null;
      throw error;
    });
    if (clock === null) return 'unknown_city';
    if (day > dayOf(lastCutoff(now, clock.cutoffMinutes, clock.timeZone), clock.timeZone)) {
      return 'invalid_day';
    }
    if ((await this.fx.baseCurrency(cityId)) === null) return 'no_base_currency';
    return null;
  }

  // The report of a business day up to today.
  async report(cityId: string, day: string, now: Date): Promise<DailyReport> {
    const refusal = await this.check(cityId, day, now);
    if (refusal !== null) throw new DailyReportRefusedError(refusal);
    const clock = await this.clock(cityId);
    const today = dayOf(lastCutoff(now, clock.cutoffMinutes, clock.timeZone), clock.timeZone);
    // The day and the days before, oldest first, read in one scan each.
    const days: string[] = [];
    for (let back = COMPARED_DAYS; back >= 0; back -= 1) {
      days.push(new Date(Date.parse(day) - back * DAY_MS).toISOString().slice(0, 10));
    }
    const figures = await this.figures(cityId, days, clock, now).catch((error: unknown) => {
      if (error instanceof FxRefusedError && error.refusal === 'rate_missing') {
        throw new DailyReportRefusedError('rate_missing');
      }
      throw error;
    });
    const asked = figures.at(-1)!;
    const isToday = day === today;
    return {
      cityId,
      ...asked,
      today: isToday,
      now: isToday ? await this.stateNow(cityId, now) : null,
      previous: figures.slice(0, -1).reverse(),
    };
  }

  // Each day's figures, the days consecutive and oldest first.
  private async figures(
    cityId: string,
    days: readonly string[],
    clock: { timeZone: string; cutoffMinutes: number },
    now: Date,
  ): Promise<DayFigures[]> {
    const dayAfter = new Date(Date.parse(days.at(-1)!) + DAY_MS).toISOString().slice(0, 10);
    const bounds = [...days, dayAfter].map((each) =>
      cutoffOn(each, clock.cutoffMinutes, clock.timeZone),
    );
    const ends = bounds.slice(1);
    const [totals, orderPay, delivered, custody, restaurants] = await Promise.all([
      this.ledger.cityTotals(cityId, bounds),
      // The pay booked to platform.captain_pay, as the figures count it.
      this.ledger.sourceTotals(cityId, 'platform.captain_pay', 'earn.order_pay', bounds),
      Promise.all(
        days.map((_, index) =>
          this.orders.deliveredTotals(cityId, bounds[index]!, bounds[index + 1]!),
        ),
      ),
      this.ledger.cityBalancesAt(cityId, 'captain.custody', ends),
      this.ledger.cityBalancesAt(cityId, 'merchant.account', ends),
    ]);
    const paid = [...new Set(orderPay.flatMap((each) => [...each.keys()]))];
    const distances = await this.orders.distancePay(paid);
    return Promise.all(
      days.map(async (each, index) => {
        const from = bounds[index]!;
        const to = bounds[index + 1]!;
        const dayTotals = totals.filter((row) => row.period === index);
        const versionIds = [
          ...new Set(
            dayTotals.flatMap((row) => (row.rates ?? []).map((rate) => rate.rateVersionId)),
          ),
        ];
        const { base, toBase } = await this.fx.valueAt(cityId, to < now ? to : now, versionIds);
        // Each order's distance part is what its collection recorded, never
        // above the day's pay of the order (as the captain's weekly
        // statement counts it, AP §8.5.5).
        let distancePay = 0n;
        for (const [id, amount] of orderPay[index]!) {
          if (amount <= 0n) continue;
          const distance = distances.get(id) ?? 0n;
          distancePay += distance < amount ? distance : amount;
        }
        const inBase = delivered[index]!.filter((row) => row.currency === base);
        return {
          day: each,
          from,
          to,
          ...dailyFigures({
            base,
            orders: {
              count: inBase.reduce((total, row) => total + row.count, 0),
              gmv: inBase.reduce((total, row) => total + row.gmv, 0n),
              itemsValue: inBase.reduce((total, row) => total + row.itemsValue, 0n),
            },
            totals: dayTotals,
            distancePay,
            toBase,
            custody: custody[index]!,
            restaurants: restaurants[index]!,
          }),
        };
      }),
    );
  }

  private async stateNow(cityId: string, now: Date): Promise<ReportNow> {
    const [balances, list] = await Promise.all([
      this.captains.balances(cityId, now),
      this.restaurants.restaurants(cityId, now),
    ]);
    return {
      // A terminated captain cannot go online anyway.
      captainsBlocked: balances.filter(
        (captain) => captain.status !== 'terminated' && captain.blocks.length > 0,
      ).length,
      overdueRestaurants: list.restaurants.flatMap((row) =>
        row.overdueSince === null
          ? []
          : [
              {
                restaurantId: row.restaurantId,
                name: row.restaurantName,
                balance: row.balance,
                overdueSince: row.overdueSince,
              },
            ],
      ),
    };
  }

  // The city's clock and its business day's cutoff (`unknown_city` without
  // the city).
  async clock(cityId: string) {
    const [timeZone, cutoff] = await Promise.all([
      this.geo.cityTimeZone(cityId),
      this.settings.get('finance.business_day_cutoff', { cityId }),
    ]);
    if (timeZone === null) throw new DailyReportRefusedError('unknown_city');
    const [hours, minutes] = cutoff.split(':').map(Number) as [number, number];
    return { timeZone, cutoffMinutes: hours * 60 + minutes };
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
