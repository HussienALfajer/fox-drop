import { Inject, Injectable, Logger } from '@nestjs/common';
import { desc, eq } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { reportError } from '../../observability/error-tracking.js';
import { formatMoney, NotificationTexts } from '../content/index.js';
import { FxService } from '../fx/index.js';
import { GeoService, nextCutoff } from '../geo/index.js';
import { type AccountEntry, LedgerService } from '../ledger/index.js';
import { MerchantsService } from '../merchants/index.js';
import { FOOD_CREDIT_REASON, OrdersService } from '../ordering/index.js';
import { PushQueue } from '../notifications/index.js';
import { SettingsService } from '../settings/index.js';
import { payoutCycle } from './earnings.js';
import { buildStatement, type ExceptionCause, type StatementLine } from './merchant-statement.js';
import { merchantStatementLines, merchantStatements } from './schema.js';
import type { PayoutWeekday } from './settlement.service.js';

// The ledger stamps an entry with its transaction's start, so an entry
// committed after a statement was taken may carry a time before its cutoff:
// the next statement reads from this long (the longest a transaction may
// run) before the previous cutoff and leaves out the journals it covered.
export const STATEMENT_OVERLAP_MS = 60 * 60_000;
// The owners hear of the statement only on the settlement day itself: a
// worker back after days, or the first deploy, takes the statement quietly.
const DAY_MS = 24 * 60 * 60_000;

export interface MerchantStatement {
  id: string;
  cityId: string;
  restaurantId: string;
  restaurantName: string;
  cutoff: Date;
  periodFrom: Date | null;
  createdAt: Date;
  currency: string;
  orders: number;
  itemsValue: bigint;
  commission: bigint;
  discountShare: bigint;
  exceptions: bigint;
  weekTotal: bigint;
  previousDue: bigint;
  paid: bigint;
  earlierUnpaid: bigint;
  totalDue: bigint;
}

export interface MerchantStatementView extends MerchantStatement {
  lines: (StatementLine & { position: number })[];
}

// A restaurant of «تسوية المطاعم» (AP §9.10.3 tab 3): its balance now (+ it
// owes), its latest statement, what is still unpaid of that statement (the
// payments since its cutoff settle it first) and whether that is overdue.
export interface RestaurantSettlementRow {
  restaurantId: string;
  restaurantName: string;
  currency: string;
  balance: bigint;
  latest: { id: string; cutoff: Date; totalDue: bigint } | null;
  unpaid: bigint;
  overdueSince: Date | null;
}

export interface RestaurantSettlementList {
  currency: string | null;
  // The settlement day (merchant.settlement_weekday) and the next cutoff that
  // closes a statement.
  settlementWeekday: PayoutWeekday;
  nextCutoff: Date;
  restaurants: RestaurantSettlementRow[];
}

// AP §8.7, RA §12.3 (slice 2.19a): the restaurant's weekly statement, taken
// at the business-day cutoff that starts merchant.settlement_weekday, and
// what «تسوية المطاعم» reads.
@Injectable()
export class MerchantStatementsService {
  private readonly logger = new Logger('MerchantStatements');

  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly ledger: LedgerService,
    private readonly merchants: MerchantsService,
    private readonly orders: OrdersService,
    private readonly fx: FxService,
    private readonly geo: GeoService,
    private readonly settings: SettingsService,
    private readonly texts: NotificationTexts,
    private readonly pushes: PushQueue,
  ) {}

  // The latest settlement cutoff at or before now, and the next one.
  async cutoffs(cityId: string, now: Date) {
    const timeZone = await this.geo.cityTimeZone(cityId);
    if (timeZone === null) throw new Error(`city ${cityId} does not exist`);
    const [cutoff, weekday] = await Promise.all([
      this.settings.get('finance.business_day_cutoff', { cityId }),
      this.settings.get('merchant.settlement_weekday', { cityId }),
    ]);
    const [hours, minutes] = cutoff.split(':').map(Number) as [number, number];
    const cutoffMinutes = hours * 60 + minutes;
    const cycle = payoutCycle(now, cutoffMinutes, timeZone, weekday);
    let next = nextCutoff(cycle.weekFrom, cutoffMinutes, timeZone);
    // Seven business days later is the next settlement day's cutoff.
    for (let step = 1; step < 7; step += 1) next = nextCutoff(next, cutoffMinutes, timeZone);
    return { last: cycle.weekFrom, next, weekday };
  }

  // The worker's sweep: every restaurant of the city gets its statement for
  // the latest settlement cutoff, once. The owners are told on that day only.
  async closeDue(cityId: string, now: Date): Promise<{ cutoff: Date; complete: boolean }> {
    const { last } = await this.cutoffs(cityId, now);
    const complete = await this.closeAt(cityId, last, now, {
      notify: now.getTime() - last.getTime() < DAY_MS,
    });
    return { cutoff: last, complete };
  }

  // The statements of a cutoff, one restaurant at a time: a failure of one
  // never holds back the others. Whether every restaurant was closed.
  async closeAt(
    cityId: string,
    cutoff: Date,
    now: Date,
    { notify }: { notify: boolean },
  ): Promise<boolean> {
    const currency = await this.fx.baseCurrency(cityId);
    if (currency === null) return true;
    let complete = true;
    for (const restaurant of await this.merchants.restaurantIds(cityId)) {
      try {
        await this.closeOne(cityId, restaurant, currency, cutoff, now, notify);
      } catch (error) {
        complete = false;
        this.logger.error(
          { err: error, cityId, restaurantId: restaurant.id },
          'restaurant statement failed',
        );
        reportError(error);
      }
    }
    return complete;
  }

  private async closeOne(
    cityId: string,
    restaurant: { id: string; nameAr: string },
    currency: string,
    cutoff: Date,
    now: Date,
    notify: boolean,
  ): Promise<void> {
    const [previous] = await this.database.db
      .select({
        cutoff: merchantStatements.cutoff,
        totalDue: merchantStatements.totalDue,
        journalIds: merchantStatements.journalIds,
      })
      .from(merchantStatements)
      .where(eq(merchantStatements.restaurantId, restaurant.id))
      .orderBy(desc(merchantStatements.cutoff))
      .limit(1);
    if (previous && previous.cutoff.getTime() >= cutoff.getTime()) return;
    const accounts = await this.ledger.ownerAccounts(cityId, restaurant.id, 'merchant.account');
    const others = accounts.filter((account) => account.currency !== currency);
    if (others.length > 0) {
      throw new Error(`restaurant ${restaurant.id} has an account outside the base ${currency}`);
    }
    const covered = new Set(previous?.journalIds ?? []);
    const entries = (
      await this.ledger.periodEntries(
        accounts.map((account) => account.id),
        'merchant.account',
        previous ? new Date(previous.cutoff.getTime() - STATEMENT_OVERLAP_MS) : null,
      )
    ).filter(
      (entry: AccountEntry) =>
        entry.createdAt.getTime() < cutoff.getTime() && !covered.has(entry.journalId),
    );
    const previousDue = previous?.totalDue ?? 0n;
    if (entries.length === 0 && previousDue === 0n) return;
    const orderIds = entries.flatMap((entry) =>
      entry.sourceKind === 'order' && entry.sourceId !== null ? [entry.sourceId] : [],
    );
    const built = buildStatement(
      entries,
      previousDue,
      await this.orders.pickups(orderIds),
      FOOD_CREDIT_REASON,
    );
    const rendered = notify
      ? await this.texts.render('merchant.weekly_statement', {
          المبلغ: formatMoney(built.totals.totalDue, currency, await this.knownCurrencies()),
        })
      : null;
    await this.database.db.transaction(async (tx) => {
      const [inserted] = await tx
        .insert(merchantStatements)
        .values({
          cityId,
          restaurantId: restaurant.id,
          restaurantName: restaurant.nameAr,
          cutoff,
          periodFrom: previous?.cutoff ?? null,
          createdAt: now,
          currency,
          ...built.totals,
          journalIds: built.journalIds,
        })
        .onConflictDoNothing()
        .returning({ id: merchantStatements.id });
      // Another worker took it first.
      if (!inserted) return;
      if (built.lines.length > 0) {
        await tx.insert(merchantStatementLines).values(
          built.lines.map((line, position) =>
            line.kind === 'order'
              ? {
                  statementId: inserted.id,
                  position,
                  kind: line.kind,
                  at: line.at,
                  orderId: line.orderId,
                  orderNumber: line.orderNumber,
                  itemsValue: line.itemsValue,
                  pickupLines: line.pickupLines?.map((each) => ({
                    currency: each.currency,
                    amount: each.amount.toString(),
                  })),
                  commission: line.commission,
                  discountShare: line.discountShare,
                }
              : {
                  statementId: inserted.id,
                  position,
                  kind: line.kind,
                  at: line.at,
                  orderId: line.orderId,
                  orderNumber: line.orderNumber,
                  cause: line.cause,
                  amount: line.amount,
                  reason: line.reason,
                  journalId: line.journalId,
                },
          ),
        );
      }
      // RA §16 #30: only when something is due (a statement that owes the
      // restaurant waits for the desk to pay it).
      if (rendered && built.totals.totalDue > 0n) {
        await this.pushes.enqueue(
          tx,
          [
            {
              source: `cashdesk:merchant-statement:${inserted.id}`,
              recipient: { party: 'merchant', restaurantId: restaurant.id, owners: true },
              templateKey: 'merchant.weekly_statement',
              body: rendered.body,
              level: rendered.level,
              priority: rendered.priority,
              data: { target: 'statement', statementId: inserted.id },
              at: now,
              expiresAt: new Date(cutoff.getTime() + DAY_MS),
            },
          ],
          now,
        );
      }
    });
  }

  // «تسوية المطاعم»: every restaurant with a balance not at zero, the
  // overdue first, then the largest owed.
  async restaurants(cityId: string, now: Date): Promise<RestaurantSettlementList> {
    const [currency, { next, weekday }, overdueDays] = await Promise.all([
      this.fx.baseCurrency(cityId),
      this.cutoffs(cityId, now),
      this.settings.get('merchant.settlement_overdue_days', { cityId }),
    ]);
    const rows: RestaurantSettlementRow[] = [];
    for (const restaurant of await this.merchants.restaurantIds(cityId)) {
      const accounts = await this.ledger.ownerAccounts(cityId, restaurant.id, 'merchant.account');
      const account = accounts.find((each) => each.currency === currency);
      if (!account) continue;
      // The party's view is − the restaurant owes.
      const balance = -(await this.ledger.balance(account.id)).amount;
      if (balance === 0n) continue;
      const [latest] = await this.database.db
        .select({
          id: merchantStatements.id,
          cutoff: merchantStatements.cutoff,
          totalDue: merchantStatements.totalDue,
          journalIds: merchantStatements.journalIds,
        })
        .from(merchantStatements)
        .where(eq(merchantStatements.restaurantId, restaurant.id))
        .orderBy(desc(merchantStatements.cutoff))
        .limit(1);
      let unpaid = 0n;
      if (latest && latest.totalDue > 0n) {
        const covered = new Set(latest.journalIds);
        const paidSince = (
          await this.ledger.periodEntries(
            [account.id],
            'merchant.account',
            new Date(latest.cutoff.getTime() - STATEMENT_OVERLAP_MS),
          )
        )
          .filter((entry) => entry.type === 'merchant.settlement' && !covered.has(entry.journalId))
          .reduce((sum, entry) => sum + entry.amount, 0n);
        unpaid = latest.totalDue - paidSince > 0n ? latest.totalDue - paidSince : 0n;
      }
      const overdueAt = latest ? new Date(latest.cutoff.getTime() + overdueDays * DAY_MS) : null;
      rows.push({
        restaurantId: restaurant.id,
        restaurantName: restaurant.nameAr,
        currency: account.currency,
        balance,
        latest: latest ? { id: latest.id, cutoff: latest.cutoff, totalDue: latest.totalDue } : null,
        unpaid,
        overdueSince: unpaid > 0n && overdueAt && overdueAt <= now ? overdueAt : null,
      });
    }
    rows.sort(
      (a, b) =>
        Number(b.overdueSince !== null) - Number(a.overdueSince !== null) ||
        (b.balance > a.balance ? 1 : b.balance < a.balance ? -1 : 0) ||
        a.restaurantName.localeCompare(b.restaurantName, 'ar'),
    );
    return { currency, settlementWeekday: weekday, nextCutoff: next, restaurants: rows };
  }

  // A statement with its lines, in the order shown.
  async statement(statementId: string): Promise<MerchantStatementView | null> {
    const [row] = await this.database.db
      .select()
      .from(merchantStatements)
      .where(eq(merchantStatements.id, statementId));
    if (!row) return null;
    const lines = await this.database.db
      .select()
      .from(merchantStatementLines)
      .where(eq(merchantStatementLines.statementId, statementId))
      .orderBy(merchantStatementLines.position);
    return {
      ...row,
      lines: lines.map((line) =>
        line.kind === 'order'
          ? {
              kind: 'order' as const,
              position: line.position,
              at: line.at,
              orderId: line.orderId!,
              orderNumber: line.orderNumber,
              itemsValue: line.itemsValue,
              pickupLines:
                (line.pickupLines as { currency: string; amount: string }[] | null)?.map(
                  (each) => ({ currency: each.currency, amount: BigInt(each.amount) }),
                ) ?? null,
              commission: line.commission!,
              discountShare: line.discountShare!,
            }
          : {
              kind: line.kind,
              position: line.position,
              at: line.at,
              orderId: line.orderId,
              orderNumber: line.orderNumber,
              cause: line.cause as ExceptionCause | null,
              amount: line.amount!,
              reason: line.reason,
              journalId: line.journalId!,
            },
      ),
    };
  }

  private async knownCurrencies() {
    return new Map(
      (await this.fx.currencies()).map((each) => [
        each.code,
        { symbol: each.symbol, decimals: each.decimals },
      ]),
    );
  }
}
