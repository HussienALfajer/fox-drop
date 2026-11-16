import { Injectable } from '@nestjs/common';
import { CaptainsService } from '../captains/index.js';
import { FxService } from '../fx/index.js';
import { GeoService, lastCutoff } from '../geo/index.js';
import { LedgerService } from '../ledger/index.js';
import { MerchantsService } from '../merchants/index.js';
import { merchantEntryCause, OrdersService, type RestaurantPickup } from '../ordering/index.js';
import { SettingsService } from '../settings/index.js';
import { buildStatement, type StatementLine } from './merchant-statement.js';
import { MerchantStatementsService, STATEMENT_OVERLAP_MS } from './merchant-statements.service.js';

// RA §12.2 «الحساب» (slice 2.19d): what the owners see of their account.
export interface MerchantAccount {
  // The city's base, null before it has one (nothing is owed then).
  currency: string | null;
  // + the restaurant owes, − the platform owes it.
  balance: bigint;
  // «موعد التسوية»: the settlement day on the city's clock (YYYY-MM-DD): the
  // latest statement's while it is still unpaid, else the next one.
  settlementDate: string;
  commissionBp: number | null;
  nextCommission: { rateBp: number; from: Date } | null;
  // «قبضت اليوم من الكباتن»: since the business day's cutoff.
  todayFrom: Date;
  pickups: (RestaurantPickup & { captainName: string | null })[];
  // «هذا الأسبوع»: since the latest statement's cutoff (null before the
  // first), each line with its business day on the city's clock.
  weekFrom: Date | null;
  weekLines: (StatementLine & { day: string })[];
}

@Injectable()
export class MerchantAccountService {
  constructor(
    private readonly ledger: LedgerService,
    private readonly merchants: MerchantsService,
    private readonly orders: OrdersService,
    private readonly captains: CaptainsService,
    private readonly fx: FxService,
    private readonly geo: GeoService,
    private readonly settings: SettingsService,
    private readonly statements: MerchantStatementsService,
  ) {}

  async account(restaurantId: string, cityId: string, now: Date): Promise<MerchantAccount> {
    const [currency, timeZone, cutoff, cutoffs, commission] = await Promise.all([
      this.fx.baseCurrency(cityId),
      this.geo.cityTimeZone(cityId),
      this.settings.get('finance.business_day_cutoff', { cityId }),
      this.statements.cutoffs(cityId, now),
      this.merchants.commissionSchedule(restaurantId, now),
    ]);
    if (timeZone === null) throw new Error(`city ${cityId} does not exist`);
    const [hours, minutes] = cutoff.split(':').map(Number) as [number, number];
    const cutoffMinutes = hours * 60 + minutes;
    const dateOf = (at: Date) =>
      new Intl.DateTimeFormat('en-CA', {
        timeZone,
        year: 'numeric',
        month: '2-digit',
        day: '2-digit',
      }).format(at);
    const todayFrom = lastCutoff(now, cutoffMinutes, timeZone);
    const pickups = await this.orders.restaurantPickups(restaurantId, todayFrom);
    const names = new Map(
      (
        await Promise.all(
          [...new Set(pickups.map((pickup) => pickup.captainId))].map((id) =>
            this.captains.captain(id, now),
          ),
        )
      ).flatMap((captain) => (captain ? [[captain.id, captain.name] as const] : [])),
    );
    const base = {
      currency,
      commissionBp: commission.rateBp,
      nextCommission: commission.next,
      todayFrom,
      pickups: pickups.map((pickup) => ({
        ...pickup,
        // RA §8.9: the captain's first name, as on the board.
        captainName: names.get(pickup.captainId)?.split(' ')[0] ?? null,
      })),
    };
    const accounts = await this.ledger.ownerAccounts(cityId, restaurantId, 'merchant.account');
    const account = accounts.find((each) => each.currency === currency);
    if (!account) {
      return {
        ...base,
        balance: 0n,
        settlementDate: dateOf(cutoffs.next),
        weekFrom: null,
        weekLines: [],
      };
    }
    const [{ statements, unpaid }, held] = await Promise.all([
      this.statements.standing(restaurantId, account.id),
      this.ledger.balance(account.id),
    ]);
    const latest = statements[0] ?? null;
    // The entries since the latest statement, as the next statement will take
    // them: from an hour before its cutoff, outside the journals it covered.
    const covered = new Set(statements.flatMap((statement) => statement.journalIds));
    const entries = (
      await this.ledger.periodEntries(
        [account.id],
        'merchant.account',
        latest ? new Date(latest.cutoff.getTime() - STATEMENT_OVERLAP_MS) : null,
      )
    ).filter((entry) => !covered.has(entry.journalId));
    const orderIds = entries.flatMap((entry) =>
      entry.sourceKind === 'order' && entry.sourceId !== null ? [entry.sourceId] : [],
    );
    const known = await this.orders.pickups(orderIds);
    // One statement per business day, so an order's lines stay on its day.
    const days = new Map<string, typeof entries>();
    for (const entry of entries) {
      const day = dateOf(lastCutoff(entry.createdAt, cutoffMinutes, timeZone));
      days.set(day, [...(days.get(day) ?? []), entry]);
    }
    const weekLines = [...days.entries()]
      .sort(([a], [b]) => (a < b ? 1 : a > b ? -1 : 0))
      .flatMap(([day, dayEntries]) =>
        buildStatement(dayEntries, 0n, known, merchantEntryCause).lines.map((line) => ({
          ...line,
          day,
        })),
      );
    return {
      ...base,
      // The party's view is − the restaurant owes.
      balance: -held.amount,
      settlementDate: dateOf(latest && unpaid > 0n ? latest.cutoff : cutoffs.next),
      weekFrom: latest?.cutoff ?? null,
      weekLines,
    };
  }
}
