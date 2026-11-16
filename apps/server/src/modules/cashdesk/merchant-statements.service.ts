import { Inject, Injectable, Logger } from '@nestjs/common';
import { desc, eq, sql } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { reportError } from '../../observability/error-tracking.js';
import { formatMoney, NotificationTexts } from '../content/index.js';
import { FxService } from '../fx/index.js';
import { GeoService, nextCutoff } from '../geo/index.js';
import { type AccountEntry, LedgerService } from '../ledger/index.js';
import { MerchantsService } from '../merchants/index.js';
import { merchantEntryCause, OrdersService } from '../ordering/index.js';
import { PushQueue } from '../notifications/index.js';
import { SettingsService } from '../settings/index.js';
import type { Tx } from './cashdesk.service.js';
import { payoutCycle } from './earnings.js';
import {
  buildStatement,
  type ExceptionCause,
  oldestUnpaid,
  type StatementLine,
  type StatementStatus,
  statementStatuses,
} from './merchant-statement.js';
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
// The statements read back to find the oldest one still unpaid: a year.
const OVERDUE_LOOKBACK = 52;

// A restaurant's account, held while its statement is taken or a payment
// is recorded (slice 2.19b), so a payment is never half in a statement and
// two desks never settle one balance twice.
export async function lockRestaurantAccount(tx: Tx, restaurantId: string): Promise<void> {
  await tx.execute(
    sql`SELECT pg_advisory_xact_lock(hashtext(${`merchant-statement:${restaurantId}`}))`,
  );
}

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
  // RA §12.3, by the oldest-first rule: null when it asked nothing of the
  // restaurant; and what of its total due is still unpaid.
  status: StatementStatus | null;
  unpaid: bigint;
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
  latest: {
    id: string;
    cutoff: Date;
    commission: bigint;
    discountShare: bigint;
    exceptions: bigint;
    totalDue: bigint;
    status: StatementStatus | null;
  } | null;
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
  private readonly reported = new Set<string>();

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
    // No base yet: no restaurant account either; the sweep tries again.
    const currency = await this.fx.baseCurrency(cityId);
    if (currency === null) return false;
    let complete = true;
    for (const restaurant of await this.merchants.restaurantIds(cityId)) {
      try {
        await this.closeOne(cityId, restaurant, currency, cutoff, now, notify);
      } catch (error) {
        complete = false;
        // The sweep tries again every minute: one report per restaurant and
        // cutoff, the rest logged.
        const key = `${restaurant.id}:${cutoff.getTime()}`;
        if (!this.reported.has(key)) {
          this.reported.add(key);
          reportError(error);
        }
        this.logger.error(
          { err: error, cityId, restaurantId: restaurant.id },
          'restaurant statement failed',
        );
      }
    }
    return complete;
  }

  // One restaurant's statement, under its advisory lock, so two workers
  // never build two statements from the same previous one.
  private async closeOne(
    cityId: string,
    restaurant: { id: string; nameAr: string },
    currency: string,
    cutoff: Date,
    now: Date,
    notify: boolean,
  ): Promise<void> {
    const known = notify ? await this.knownCurrencies() : null;
    await this.database.db.transaction(async (tx) => {
      await lockRestaurantAccount(tx, restaurant.id);
      const [previous] = await tx
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
      const accounts = await this.ledger.ownerAccounts(
        cityId,
        restaurant.id,
        'merchant.account',
        tx,
      );
      if (accounts.some((account) => account.currency !== currency)) {
        throw new Error(`restaurant ${restaurant.id} has an account outside the base ${currency}`);
      }
      const covered = new Set(previous?.journalIds ?? []);
      const entries = (
        await this.ledger.periodEntries(
          accounts.map((account) => account.id),
          'merchant.account',
          previous ? new Date(previous.cutoff.getTime() - STATEMENT_OVERLAP_MS) : null,
          tx,
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
        merchantEntryCause,
      );
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
        .returning({ id: merchantStatements.id });
      if (!inserted) throw new Error('the statement was not inserted');
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
      // RA §16 #30: only when something is due (to confirm with the owner: a
      // statement that owes the restaurant waits for the desk to pay it).
      if (known && built.totals.totalDue > 0n) {
        const rendered = await this.texts.render(
          'merchant.weekly_statement',
          { المبلغ: formatMoney(built.totals.totalDue, currency, known) },
          tx,
        );
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
      const { statements, unpaid } = await this.standing(restaurant.id, account.id);
      const latest = statements[0];
      const oldest = oldestUnpaid(statements, unpaid);
      const overdueAt = oldest ? new Date(oldest.cutoff.getTime() + overdueDays * DAY_MS) : null;
      rows.push({
        restaurantId: restaurant.id,
        restaurantName: restaurant.nameAr,
        currency: account.currency,
        balance,
        latest: latest
          ? {
              id: latest.id,
              cutoff: latest.cutoff,
              commission: latest.commission,
              discountShare: latest.discountShare,
              exceptions: latest.exceptions,
              totalDue: latest.totalDue,
              status: statementStatuses(statements, unpaid).get(latest.id)!.status,
            }
          : null,
        unpaid,
        overdueSince: overdueAt && overdueAt <= now ? overdueAt : null,
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
    const accounts = await this.ledger.ownerAccounts(
      row.cityId,
      row.restaurantId,
      'merchant.account',
    );
    const account = accounts.find((each) => each.currency === row.currency);
    const standing = account
      ? await this.standing(row.restaurantId, account.id)
      : { statements: [], unpaid: 0n };
    // Older than the statements read back (a year): long settled.
    const { status, unpaid } = statementStatuses(standing.statements, standing.unpaid).get(
      row.id,
    ) ?? { status: row.totalDue > 0n ? 'paid' : null, unpaid: 0n };
    const lines = await this.database.db
      .select()
      .from(merchantStatementLines)
      .where(eq(merchantStatementLines.statementId, statementId))
      .orderBy(merchantStatementLines.position);
    return {
      ...row,
      status,
      unpaid,
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

  // The restaurant's latest statements, newest first (the latest is the one
  // paid against, the older ones tell which statement the unpaid amount is
  // from), and what is still unpaid of the latest. A payment and a credit
  // since its cutoff settle the oldest first (owner decision 2026-11-16),
  // while what raised the balance since (a commission, a payout) is next
  // week's: so the unpaid part is the balance now less what the entries
  // since its cutoff raised, between zero and its total due.
  async standing(restaurantId: string, accountId: string) {
    const statements = await this.database.db
      .select({
        id: merchantStatements.id,
        cutoff: merchantStatements.cutoff,
        periodFrom: merchantStatements.periodFrom,
        currency: merchantStatements.currency,
        commission: merchantStatements.commission,
        discountShare: merchantStatements.discountShare,
        exceptions: merchantStatements.exceptions,
        weekTotal: merchantStatements.weekTotal,
        totalDue: merchantStatements.totalDue,
        journalIds: merchantStatements.journalIds,
      })
      .from(merchantStatements)
      .where(eq(merchantStatements.restaurantId, restaurantId))
      .orderBy(desc(merchantStatements.cutoff))
      .limit(OVERDUE_LOOKBACK);
    const latest = statements[0];
    let unpaid = 0n;
    if (latest && latest.totalDue > 0n) {
      // Read from before the cutoff: the journals of any statement taken.
      const covered = new Set(statements.flatMap((statement) => statement.journalIds));
      const entries = await this.ledger.periodEntries(
        [accountId],
        'merchant.account',
        new Date(latest.cutoff.getTime() - STATEMENT_OVERLAP_MS),
      );
      // The party's view is − the restaurant owes.
      const balance = -(await this.ledger.balance(accountId)).amount;
      const raised = entries
        .filter(
          (entry) =>
            !covered.has(entry.journalId) &&
            !(entry.type === 'merchant.settlement' && entry.amount > 0n),
        )
        .reduce((sum, entry) => sum - entry.amount, 0n);
      const left = balance - (raised > 0n ? raised : 0n);
      unpaid = left <= 0n ? 0n : left < latest.totalDue ? left : latest.totalDue;
    }
    return { statements, unpaid };
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
