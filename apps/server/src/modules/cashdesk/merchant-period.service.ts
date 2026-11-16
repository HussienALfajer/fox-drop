import { Inject, Injectable } from '@nestjs/common';
import { eq, inArray } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { FxService } from '../fx/index.js';
import { cutoffOn, GeoService } from '../geo/index.js';
import { LedgerService } from '../ledger/index.js';
import { MerchantsService } from '../merchants/index.js';
import { merchantEntryCause, OrdersService } from '../ordering/index.js';
import { SettingsService } from '../settings/index.js';
import { buildStatement, type StatementLine } from './merchant-statement.js';
import { receiptLines, receipts } from './schema.js';

// The longest period one statement covers (decided by us: a year and a day,
// so a leap year's whole year fits).
export const PERIOD_MAX_DAYS = 366;

// A payment's or payout's receipt (AP §9.10.5 «Saturday settlements with
// receipts»).
export interface PeriodReceipt {
  id: string;
  number: string;
}

export type PeriodStatementLine = StatementLine & { receipt: PeriodReceipt | null };

// AP §9.10.5 «كشوف المطاعم» (slice 2.19g): a restaurant's statement for any
// period of business days, every amount from the restaurant's side (+ it
// owes, − the platform owes it), in the city's base.
export interface RestaurantPeriodStatement {
  restaurantId: string;
  restaurantName: string;
  cityId: string;
  // Null before the city has a base (nothing is owed then).
  currency: string | null;
  // The business days asked (YYYY-MM-DD on the city's clock) and the
  // instants they run between: the cutoff of the first day to the cutoff of
  // the day after the last.
  fromDay: string;
  toDay: string;
  from: Date;
  to: Date;
  opening: bigint;
  orders: number;
  itemsValue: bigint;
  commission: bigint;
  discountShare: bigint;
  // Credits, debits, corrections and payouts.
  exceptions: bigint;
  // What the restaurant paid at the desk.
  paid: bigint;
  closing: bigint;
  lines: PeriodStatementLine[];
}

export type PeriodRefusal = 'invalid_period';

// A calendar day written YYYY-MM-DD (2026-02-30 is not one).
function isDay(day: string): boolean {
  const at = Date.parse(`${day}T00:00:00Z`);
  return (
    /^\d{4}-\d{2}-\d{2}$/.test(day) &&
    !Number.isNaN(at) &&
    new Date(at).toISOString().startsWith(day)
  );
}

@Injectable()
export class MerchantPeriodService {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly ledger: LedgerService,
    private readonly merchants: MerchantsService,
    private readonly orders: OrdersService,
    private readonly fx: FxService,
    private readonly geo: GeoService,
    private readonly settings: SettingsService,
  ) {}

  // Null for an unknown restaurant; `invalid_period` when the last day is
  // before the first or the period is longer than PERIOD_MAX_DAYS.
  async statement(
    restaurantId: string,
    fromDay: string,
    toDay: string,
  ): Promise<RestaurantPeriodStatement | PeriodRefusal | null> {
    const days = (Date.parse(toDay) - Date.parse(fromDay)) / 86_400_000 + 1;
    if (!isDay(fromDay) || !isDay(toDay) || !(days >= 1 && days <= PERIOD_MAX_DAYS)) {
      return 'invalid_period';
    }
    const restaurant = await this.merchants.restaurant(restaurantId);
    if (!restaurant) return null;
    const { cityId } = restaurant;
    const [timeZone, cutoff] = await Promise.all([
      this.geo.cityTimeZone(cityId),
      this.settings.get('finance.business_day_cutoff', { cityId }),
    ]);
    if (timeZone === null) throw new Error(`city ${cityId} does not exist`);
    const [hours, minutes] = cutoff.split(':').map(Number) as [number, number];
    const cutoffMinutes = hours * 60 + minutes;
    const from = cutoffOn(fromDay, cutoffMinutes, timeZone);
    const dayAfter = new Date(Date.parse(toDay) + 86_400_000).toISOString().slice(0, 10);
    const to = cutoffOn(dayAfter, cutoffMinutes, timeZone);
    return { fromDay, toDay, ...(await this.between(restaurantId, from, to)) };
  }

  // The statement between two instants, `from` included and `to` excluded.
  async between(
    restaurantId: string,
    from: Date,
    to: Date,
  ): Promise<Omit<RestaurantPeriodStatement, 'fromDay' | 'toDay'>> {
    const restaurant = await this.merchants.restaurant(restaurantId);
    if (!restaurant) throw new Error(`restaurant ${restaurantId} does not exist`);
    const { cityId } = restaurant;
    const currency = await this.fx.baseCurrency(cityId);
    const base = {
      restaurantId,
      restaurantName: restaurant.nameAr,
      cityId,
      currency,
      from,
      to,
    };
    const accounts = await this.ledger.ownerAccounts(cityId, restaurantId, 'merchant.account');
    const account = accounts.find((each) => each.currency === currency);
    if (!account) {
      return {
        ...base,
        opening: 0n,
        orders: 0,
        itemsValue: 0n,
        commission: 0n,
        discountShare: 0n,
        exceptions: 0n,
        paid: 0n,
        closing: 0n,
        lines: [],
      };
    }
    // One snapshot, so the opening and the period's entries agree and the
    // closing is their sum.
    const { opening, entries } = await this.database.db.transaction(
      async (tx) => {
        const [held, period] = await Promise.all([
          this.ledger.balanceAt(account.id, from, [], tx),
          this.ledger.rangeEntries([account.id], 'merchant.account', from, to, tx),
        ]);
        // The party's view is − the restaurant owes.
        return { opening: -held.amount, entries: period };
      },
      { isolationLevel: 'repeatable read', accessMode: 'read only' },
    );
    const orderIds = entries.flatMap((entry) =>
      entry.sourceKind === 'order' && entry.sourceId !== null ? [entry.sourceId] : [],
    );
    const pickups = await this.orders.pickups(orderIds);
    const built = buildStatement(entries, opening, pickups, merchantEntryCause);
    const byJournal = await this.receiptsOf(
      built.lines.flatMap((line) => (line.kind === 'payment' ? [line.journalId] : [])),
    );
    const { totals } = built;
    return {
      ...base,
      opening,
      orders: totals.orders,
      itemsValue: totals.itemsValue,
      commission: totals.commission,
      discountShare: totals.discountShare,
      exceptions: totals.exceptions,
      paid: totals.paid,
      closing: totals.totalDue,
      lines: built.lines.map((line) => ({
        ...line,
        receipt: line.kind === 'payment' ? (byJournal.get(line.journalId) ?? null) : null,
      })),
    };
  }

  // The receipt each desk journal was posted for.
  private async receiptsOf(journalIds: string[]): Promise<Map<string, PeriodReceipt>> {
    if (journalIds.length === 0) return new Map();
    const rows = await this.database.db
      .select({ journalId: receiptLines.journalId, id: receipts.id, number: receipts.number })
      .from(receiptLines)
      .innerJoin(receipts, eq(receipts.id, receiptLines.receiptId))
      .where(inArray(receiptLines.journalId, journalIds));
    return new Map(rows.map((row) => [row.journalId, { id: row.id, number: row.number }]));
  }
}
