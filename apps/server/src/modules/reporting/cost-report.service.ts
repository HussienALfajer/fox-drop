import { Injectable } from '@nestjs/common';
import { periodFits } from '../cashdesk/index.js';
import { FxRefusedError, FxService } from '../fx/index.js';
import { cutoffOn } from '../geo/index.js';
import { LedgerService } from '../ledger/index.js';
import { CompensationsService } from '../marketing/index.js';
import { MerchantsService } from '../merchants/index.js';
import { OrdersService } from '../ordering/index.js';
import { costAccounts, costReport, type CostReportFigures } from './cost-report.js';
import { DailyReportRefusedError, DailyReportService } from './daily-report.service.js';

// The period the screen opens on: the business days of the last week, today
// included (the owner reads a week's compensation by reason; decided by us).
export const DEFAULT_PERIOD_DAYS = 7;

const DAY_MS = 86_400_000;

export interface CostReport extends Omit<CostReportFigures, 'restaurants'> {
  cityId: string;
  // The business days, YYYY-MM-DD on the city's clock, both included, and
  // the instants they run between: the first day's cutoff to the cutoff of
  // the day after the last.
  fromDay: string;
  toDay: string;
  from: Date;
  to: Date;
  restaurants: (CostReportFigures['restaurants'][number] & { name: string | null })[];
}

export type CostReportRefusal =
  | 'invalid_period'
  | 'unknown_city'
  | 'no_base_currency'
  // An amount in a currency with no rate by the period's end.
  | 'rate_missing';

export class CostReportRefusedError extends Error {
  override readonly name = 'CostReportRefusedError';
  constructor(readonly refusal: CostReportRefusal) {
    super(refusal);
  }
}

// «كلفة التعويضات والخصومات» (AP §9.10.6, slice 2.22d): a period's cost of
// codes, compensations and operating costs from the ledger, split with what
// ordering and marketing know of each entry's order and code.
@Injectable()
export class CostReportService {
  constructor(
    private readonly ledger: LedgerService,
    private readonly orders: OrdersService,
    private readonly compensations: CompensationsService,
    private readonly merchants: MerchantsService,
    private readonly fx: FxService,
    private readonly days: DailyReportService,
  ) {}

  // The period the screen opens on, ending with today's business day.
  async defaultPeriod(cityId: string, now: Date): Promise<{ from: string; to: string }> {
    const to = await this.today(cityId, now);
    const from = new Date(Date.parse(to) - (DEFAULT_PERIOD_DAYS - 1) * DAY_MS)
      .toISOString()
      .slice(0, 10);
    return { from, to };
  }

  // Why a period's report cannot be read, or null: `invalid_period` for a
  // day that does not exist, the last day before the first, a period longer
  // than a statement's (`periodFits`) or one that ends after today.
  async check(
    cityId: string,
    fromDay: string,
    toDay: string,
    now: Date,
  ): Promise<CostReportRefusal | null> {
    if (!periodFits(fromDay, toDay)) return 'invalid_period';
    const today = await this.today(cityId, now).catch((error: unknown) => {
      if (error instanceof CostReportRefusedError) return null;
      throw error;
    });
    if (today === null) return 'unknown_city';
    if (toDay > today) return 'invalid_period';
    if ((await this.fx.baseCurrency(cityId)) === null) return 'no_base_currency';
    return null;
  }

  async report(cityId: string, fromDay: string, toDay: string, now: Date): Promise<CostReport> {
    const refusal = await this.check(cityId, fromDay, toDay, now);
    if (refusal !== null) throw new CostReportRefusedError(refusal);
    const clock = await this.days.clock(cityId);
    const from = cutoffOn(fromDay, clock.cutoffMinutes, clock.timeZone);
    const dayAfter = new Date(Date.parse(toDay) + DAY_MS).toISOString().slice(0, 10);
    const to = cutoffOn(dayAfter, clock.cutoffMinutes, clock.timeZone);

    const entries = await this.ledger.sourceCosts(cityId, costAccounts, from, to);
    const orders = await this.orders.costOrders(
      entries.flatMap((entry) => (entry.orderId === null ? [] : [entry.orderId])),
    );
    // The personal codes behind the compensation cost, then the orders they
    // were given for.
    const origins = await this.compensations.codeOrigins(
      entries.flatMap((entry) => {
        const codeId =
          entry.purpose === 'platform.compensation_cost' && entry.orderId !== null
            ? orders.get(entry.orderId)?.promoCodeId
            : null;
        return codeId == null ? [] : [codeId];
      }),
    );
    const compensated = await this.orders.costOrders(
      [...origins.values()].map((origin) => origin.orderId).filter((id) => !orders.has(id)),
    );
    // An amount of an order placed in an earlier base converts at the rate
    // in force at the period's end (the cost journals carry no rates).
    const { base, toBase } = await this.fx.valueAt(cityId, to < now ? to : now, []);
    let figures: CostReportFigures;
    try {
      figures = costReport({
        base,
        toBase: (amount, currency) => toBase(amount, currency, null),
        entries,
        orders: new Map([...orders, ...compensated]),
        origins,
      });
    } catch (error) {
      if (error instanceof FxRefusedError && error.refusal === 'rate_missing') {
        throw new CostReportRefusedError('rate_missing');
      }
      throw error;
    }
    const names = await this.merchants.names(
      figures.restaurants.flatMap((row) => (row.restaurantId === null ? [] : [row.restaurantId])),
    );
    return {
      cityId,
      fromDay,
      toDay,
      from,
      to,
      ...figures,
      restaurants: figures.restaurants.map((row) => ({
        ...row,
        name: row.restaurantId === null ? null : (names.get(row.restaurantId)?.nameAr ?? null),
      })),
    };
  }

  private async today(cityId: string, now: Date): Promise<string> {
    try {
      return await this.days.today(cityId, now);
    } catch (error) {
      if (error instanceof DailyReportRefusedError && error.refusal === 'unknown_city') {
        throw new CostReportRefusedError('unknown_city');
      }
      throw error;
    }
  }
}
