import { createHash } from 'node:crypto';
import { Inject, Injectable } from '@nestjs/common';
import { and, desc, eq, gt, isNull, or, sql } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { AuditService } from '../audit/index.js';
import { CaptainsService, type CustodyCurrency, type DeskCaptain } from '../captains/index.js';
import { formatMoney, NotificationTexts } from '../content/index.js';
import { FxService } from '../fx/index.js';
import { GeoService, lastCutoff } from '../geo/index.js';
import { type AccountEntry, LedgerService } from '../ledger/index.js';
import { PushQueue } from '../notifications/index.js';
import { OrdersService } from '../ordering/index.js';
import { SettingsService } from '../settings/index.js';
import {
  type CashLine,
  CashDeskRefusedError,
  CashDeskService,
  cityYear,
  type ConversionRate,
  type DeskUser,
  type EarningsMove,
  type Executor,
  keepKey,
  nextNumber,
  quoteOf,
  type Receipt,
  type ReceiptType,
  type Tx,
} from './cashdesk.service.js';
import { drawerSessions, statements } from './schema.js';

export type PayoutWeekday =
  'saturday' | 'sunday' | 'monday' | 'tuesday' | 'wednesday' | 'thursday' | 'friday';

export type NegativeEarningsPolicy = 'carry_forward' | 'collect_at_desk';

// What the screen shows before «تأكيد التصفية» (AP §8.5.5, §9.10.3): the
// custody per currency and the earnings to settle, the payout in the
// currency asked at the current rate, a negative balance to collect, and the
// net per currency that changes hands (+ the captain gives, − the desk pays).
export interface SettlementPreview {
  captainId: string;
  name: string;
  cityId: string;
  payoutDay: boolean;
  payoutWeekday: PayoutWeekday;
  policy: NegativeEarningsPolicy;
  // The currencies not at zero, from the captain's side.
  custody: { currency: string; balance: bigint; balanceInBase: bigint }[];
  // + the platform owes the captain, in the base.
  earnings: { amount: bigint; currency: string };
  payout: {
    currency: string;
    amount: bigint;
    rates: ConversionRate[];
    unit: { from: string; to: string; value: string } | null;
  } | null;
  collect: bigint | null;
  net: { currency: string; amount: bigint }[];
}

// The settlement as the screen confirms it: what it showed, which the server
// checks again under the captain's lock.
export interface SettleCommand {
  captainId: string;
  custody: { currency: string; balance: bigint }[];
  earnings: bigint;
  payout: { currency: string; amount: bigint; rates: ConversionRate[] } | null;
  // Off the payout day: OWN's reason (AP §9.7, §6.3).
  reason: string | null;
  idempotencyKey: string;
}

// The weekly statement (AP §8.5.5 step 4), in the base currency.
export interface Statement {
  id: string;
  cityId: string;
  captainId: string;
  captainName: string;
  sessionId: string;
  cashierId: string;
  periodFrom: Date | null;
  createdAt: Date;
  currency: string;
  orders: number;
  basePay: bigint;
  distancePay: bigint;
  waitingPay: bigint;
  peakBonus: bigint;
  bonuses: bigint;
  charges: bigint;
  instalments: bigint;
  adjustments: bigint;
  carriedIn: bigint;
  balance: bigint;
  paid: bigint;
  payout: { currency: string; amount: bigint } | null;
  collected: bigint;
  carriedOut: bigint;
  offCycle: boolean;
  reason: string | null;
  receiptIds: string[];
}

export interface Settlement {
  statement: Statement;
  receipts: Receipt[];
}

// The «تصفية الخميس» tab (AP §9.10.3): the day, the policy and every captain
// with an earnings balance or open custody.
export interface SettlementList {
  payoutDay: boolean;
  payoutWeekday: PayoutWeekday;
  policy: NegativeEarningsPolicy;
  captains: Awaited<ReturnType<CashDeskService['balances']>>;
}

// How long a transaction may run: an entry stamped before a statement's
// ledger_to by more than this was committed when the statement read.
const PERIOD_OVERLAP_MS = 3_600_000;

const WEEKDAYS: Record<string, PayoutWeekday> = {
  Saturday: 'saturday',
  Sunday: 'sunday',
  Monday: 'monday',
  Tuesday: 'tuesday',
  Wednesday: 'wednesday',
  Thursday: 'thursday',
  Friday: 'friday',
};

// «تصفية الخميس» (AP §8.5.5, §9.10.3, D12; slice 2.18a): one flow settles a
// captain's custody to zero in every currency (custody.hand_in or
// custody.reimburse) and pays the full positive earnings (earn.payout) in
// the base or another accepted currency at the current rate, the cash netted
// on screen while the ledger keeps each journal apart (owner decision
// 2026-11-15); a negative balance is carried forward or collected
// (captain.negative_earnings_policy). Each kind has its receipt, and the
// weekly statement is kept as a snapshot. On another day than
// captain.payout_weekday only OWN settles, with a reason.
@Injectable()
export class SettlementService {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly desk: CashDeskService,
    private readonly captains: CaptainsService,
    private readonly ledger: LedgerService,
    private readonly fx: FxService,
    private readonly geo: GeoService,
    private readonly settings: SettingsService,
    private readonly audit: AuditService,
    private readonly texts: NotificationTexts,
    private readonly pushes: PushQueue,
    private readonly orders: OrdersService,
  ) {}

  async list(cityId: string, now: Date): Promise<SettlementList> {
    const [day, rows] = await Promise.all([
      this.dayRules(cityId, now),
      this.desk.balances(cityId, now),
    ]);
    return {
      ...day,
      captains: rows.filter(
        (row) =>
          row.earnings.amount !== 0n || row.custody.currencies.some((line) => line.balance !== 0n),
      ),
    };
  }

  async preview(
    captainId: string,
    payoutCurrency: string | null,
    now: Date,
  ): Promise<SettlementPreview> {
    const found = await this.captains.deskCustody(captainId, now).catch(unknownCaptain);
    const [day, earnings] = await Promise.all([
      this.dayRules(found.cityId, now),
      this.earnings(this.database.db, found.cityId, captainId),
    ]);
    const custody = found.custody.currencies.filter((line) => line.balance !== 0n);
    let payout: SettlementPreview['payout'] = null;
    if (earnings.amount > 0n) {
      const currency = payoutCurrency ?? earnings.currency;
      if (currency === earnings.currency) {
        payout = { currency, amount: earnings.amount, rates: [], unit: null };
      } else {
        const quote = quoteOf(await this.desk.snapshotOf(found.cityId, this.database.db), {
          from: earnings.currency,
          to: currency,
          amount: earnings.amount,
        });
        payout = { currency, amount: quote.converted, rates: quote.rates, unit: quote.unit };
      }
    }
    const collect =
      earnings.amount < 0n && day.policy === 'collect_at_desk' ? -earnings.amount : null;
    return {
      captainId,
      name: found.name,
      cityId: found.cityId,
      ...day,
      custody: custody.map(({ currency, balance, balanceInBase }) => ({
        currency,
        balance,
        balanceInBase,
      })),
      earnings: { amount: earnings.amount, currency: earnings.currency },
      payout,
      collect,
      net: netOf(
        custody,
        payout,
        collect === null ? null : { currency: earnings.currency, amount: collect },
      ),
    };
  }

  async settle(user: DeskUser, command: SettleCommand, now: Date): Promise<Settlement> {
    const reason = command.reason?.trim() || null;
    const requestHash = createHash('sha256')
      .update(
        JSON.stringify({
          settle: command.captainId,
          custody: command.custody.map((line) => [line.currency, line.balance.toString()]),
          earnings: command.earnings.toString(),
          payout: command.payout && [
            command.payout.currency,
            command.payout.amount.toString(),
            command.payout.rates.map((rate) => [rate.currency, rate.rateVersionId]),
          ],
          reason,
        }),
      )
      .digest('hex');
    const replayed = await this.desk.replay(
      this.database.db,
      user.accountId,
      command,
      requestHash,
      now,
    );
    if (replayed?.statementId) return this.settlementOf(replayed.statementId);

    const deskLock = await this.captains.deskLock(command.captainId, now).catch(unknownCaptain);
    const captain = deskLock.captain;
    const day = await this.dayRules(captain.cityId, now);
    if (!day.payoutDay) {
      if (!user.roles.includes('OWN')) {
        throw new CashDeskRefusedError('not_payout_day', 'only OWN pays on another day');
      }
      if (reason === null) {
        throw new CashDeskRefusedError('reason_required', 'an off-cycle payout needs a reason');
      }
    }
    const [city, currencies] = await Promise.all([
      this.geo.cityCode(captain.cityId),
      this.fx.currencies(),
    ]);
    if (!city) throw new Error(`city ${captain.cityId} does not exist`);
    const known = new Map(
      currencies.map((each) => [each.code, { symbol: each.symbol, decimals: each.decimals }]),
    );

    const statementId = await this.database.db.transaction(async (tx) => {
      const [session] = await tx
        .select()
        .from(drawerSessions)
        .where(
          and(eq(drawerSessions.adminAccountId, user.accountId), isNull(drawerSessions.closedAt)),
        )
        .for('share');
      if (!session) throw new CashDeskRefusedError('no_open_session', 'open the drawer first');
      if (session.cityId !== captain.cityId) {
        throw new CashDeskRefusedError('unknown_captain', 'the captain is of another city');
      }
      const custody = await deskLock.lock(tx);
      const again = await this.desk.replay(tx, user.accountId, command, requestHash, now);
      if (again?.statementId) return again.statementId;
      // The period's earnings since the previous actual payout, read with
      // the balance before anything is posted (owner decision 2026-11-15).
      const [anchor] = await tx
        .select()
        .from(statements)
        .where(
          and(
            eq(statements.captainId, captain.id),
            or(gt(statements.paid, 0n), gt(statements.collected, 0n)),
          ),
        )
        .orderBy(desc(statements.ledgerTo))
        .limit(1);
      const period = await this.period(tx, captain, anchor ?? null);
      const ledgerTo = await transactionTime(tx);
      const earnings = { amount: period.balance, currency: period.currency };
      const held = custody.currencies.filter((line) => line.balance !== 0n);
      if (held.length === 0 && earnings.amount === 0n) {
        throw new CashDeskRefusedError('nothing_due', 'no custody and no earnings to settle');
      }
      if (!sameCustody(held, command.custody) || earnings.amount !== command.earnings) {
        throw new CashDeskRefusedError('balance_changed', 'the balances moved since the screen');
      }
      const payout = await this.checkPayout(tx, captain.cityId, earnings, command.payout);
      const collect =
        earnings.amount < 0n && day.policy === 'collect_at_desk' ? -earnings.amount : 0n;

      // The drawer pays out only the cash it holds in each currency, net of
      // what the captain hands in at the same counter.
      const drawer = await this.desk.drawerCash(tx, session);
      const net = netOf(
        held,
        payout && { currency: payout.currency, amount: payout.amount },
        collect === 0n ? null : { currency: earnings.currency, amount: collect },
      );
      for (const line of net) {
        if (line.amount < 0n && -line.amount > (drawer.get(line.currency) ?? 0n)) {
          throw new CashDeskRefusedError('drawer_short', `the drawer lacks ${line.currency}`);
        }
      }

      const year = cityYear(now, city.timeZone);
      const issued: string[] = [];
      const issue = async (
        type: ReceiptType,
        lines: { line: CashLine; held: CustodyCurrency }[],
        move?: EarningsMove,
      ) => {
        if (lines.length === 0) return;
        const receipt = await this.desk.issue(tx, {
          user,
          session,
          captain,
          type,
          conversions: [],
          lines,
          number: await nextNumber(tx, captain.cityId, city.code, year),
          year,
          now,
          ...(move ? { earnings: move } : {}),
        });
        await this.desk.notify(tx, captain.id, receipt, lines, known, now);
        issued.push(receipt.id);
      };
      const whole = (line: CustodyCurrency) => ({
        line: { currency: line.currency, amount: line.balance > 0n ? line.balance : -line.balance },
        held: line,
      });
      await issue('captain_hand_in', held.filter((line) => line.balance > 0n).map(whole));
      await issue('captain_reimbursement', held.filter((line) => line.balance < 0n).map(whole));
      if (payout) {
        await issue(
          'captain_payout',
          [
            {
              line: { currency: payout.currency, amount: payout.amount },
              held: placeholder(payout.currency, -payout.amount),
            },
          ],
          { base: earnings.amount, baseCurrency: earnings.currency, rates: payout.rates },
        );
      }
      if (collect > 0n) {
        await issue(
          'captain_earnings_collection',
          [
            {
              line: { currency: earnings.currency, amount: collect },
              held: placeholder(earnings.currency, collect),
            },
          ],
          { base: collect, baseCurrency: earnings.currency, rates: [] },
        );
      }

      const paid = payout ? earnings.amount : 0n;
      const [created] = await tx
        .insert(statements)
        .values({
          cityId: captain.cityId,
          captainId: captain.id,
          captainName: captain.name,
          sessionId: session.id,
          adminAccountId: user.accountId,
          periodFrom: anchor?.createdAt ?? null,
          createdAt: now,
          ledgerFrom: anchor?.ledgerTo ?? null,
          ledgerTo,
          currency: earnings.currency,
          ...period.lines,
          carriedIn: period.carriedIn,
          journalIds: period.journalIds,
          balance: earnings.amount,
          paid,
          payoutCurrency: payout?.currency ?? null,
          payoutAmount: payout?.amount ?? null,
          collected: collect,
          carriedOut: earnings.amount - paid + collect,
          offCycle: !day.payoutDay,
          reason: day.payoutDay ? null : reason,
          receiptIds: issued,
        })
        .returning({ id: statements.id });
      const id = created!.id;
      await this.audit.recordWrite(
        {
          actor: user.actor,
          context: user.context,
          cityId: captain.cityId,
          action: 'cash_desk.settlement',
          target: { type: 'statement', id },
          before: null,
          after: {
            captainId: captain.id,
            sessionId: session.id,
            earnings: earnings.amount.toString(),
            paid: paid.toString(),
            payout: payout && { currency: payout.currency, amount: payout.amount.toString() },
            collected: collect.toString(),
            offCycle: !day.payoutDay,
            receiptIds: issued,
          },
          reason: day.payoutDay ? null : reason,
        },
        tx,
      );
      // CA §14 #20 «قبضت {المبلغ}»: only when something was paid; the
      // statement itself is kept either way.
      if (payout) await this.notifyStatement(tx, captain.id, id, payout, known, now);
      if (held.length > 0) await this.captains.custodyChanged(tx, captain, now);
      await keepKey(tx, user.accountId, command.idempotencyKey, requestHash, issued, id, now);
      return id;
    });
    return this.settlementOf(statementId);
  }

  async statement(statementId: string): Promise<Statement | null> {
    const [row] = await this.database.db
      .select()
      .from(statements)
      .where(eq(statements.id, statementId));
    return row ? statementOf(row) : null;
  }

  private async settlementOf(statementId: string): Promise<Settlement> {
    const statement = (await this.statement(statementId))!;
    return { statement, receipts: await this.desk.receiptsOf(statement.receiptIds) };
  }

  // The payout the screen showed: the whole positive balance in the base,
  // or in another accepted currency at the rate now (rate_changed when it
  // moved); none for a balance at zero or below.
  private async checkPayout(
    tx: Tx,
    cityId: string,
    earnings: { amount: bigint; currency: string },
    asked: SettleCommand['payout'],
  ): Promise<{ currency: string; amount: bigint; rates: ConversionRate[] } | null> {
    if (earnings.amount <= 0n) {
      if (asked !== null) throw new CashDeskRefusedError('balance_changed', 'nothing to pay');
      return null;
    }
    if (asked === null) throw new CashDeskRefusedError('balance_changed', 'the payout is due');
    if (asked.currency === earnings.currency) {
      if (asked.amount !== earnings.amount || asked.rates.length > 0) {
        throw new CashDeskRefusedError('balance_changed', 'the payout is the whole balance');
      }
      return { currency: asked.currency, amount: asked.amount, rates: [] };
    }
    const quote = quoteOf(await this.desk.snapshotOf(cityId, tx), {
      from: earnings.currency,
      to: asked.currency,
      amount: earnings.amount,
    });
    if (quote.converted !== asked.amount || !sameRates(quote.rates, asked.rates)) {
      throw new CashDeskRefusedError('rate_changed', 'the rate is not the one shown');
    }
    return { currency: asked.currency, amount: quote.converted, rates: quote.rates };
  }

  // The captain's earnings now (AP §8.5.2), in the base: + owed to them,
  // with the base account (none before the first entry).
  private async earnings(
    executor: Executor,
    cityId: string,
    captainId: string,
  ): Promise<{ amount: bigint; currency: string; accountId: string | null }> {
    const base = await this.fx.baseCurrency(cityId, executor);
    if (base === null) throw new CashDeskRefusedError('rate_missing', 'the city has no base');
    let amount = 0n;
    let accountId: string | null = null;
    for (const account of await this.ledger.ownerAccounts(
      cityId,
      captainId,
      'captain.earnings',
      executor,
    )) {
      const balance = await this.ledger.balance(account.id, executor);
      if (account.currency !== base) {
        if (balance.amount !== 0n) throw new Error(`earnings held in ${account.currency}`);
        continue;
      }
      accountId = account.id;
      amount += balance.amount;
    }
    return { amount, currency: base, accountId };
  }

  // AP §8.5.5 step 4: the period's earnings by kind since the previous
  // actual payout (`anchor`, a statement that paid or collected). The
  // ledger stamps an entry with its transaction's start, so one committed
  // after the anchor read the ledger may carry an earlier time: the period
  // reads from PERIOD_OVERLAP_MS before the anchor's ledger_to and leaves
  // out the journals the anchor covered and its own receipts' journals. The
  // entries and the balance are separate reads, so they are read again
  // while a commit between them leaves them apart; what the entries still
  // do not explain is the balance carried in.
  private async period(
    tx: Tx,
    captain: DeskCaptain,
    anchor: typeof statements.$inferSelect | null,
  ) {
    const covered = new Set(anchor?.journalIds ?? []);
    const anchorReceipts = new Set(anchor?.receiptIds ?? []);
    const after = anchor ? new Date(anchor.ledgerTo.getTime() - PERIOD_OVERLAP_MS) : null;
    const opening = anchor?.carriedOut ?? 0n;
    let entries: AccountEntry[] = [];
    let now = await this.earnings(tx, captain.cityId, captain.id);
    for (let attempt = 0; attempt < 3; attempt += 1) {
      entries = (
        now.accountId === null
          ? []
          : await this.ledger.periodEntries([now.accountId], 'captain.earnings', after, tx)
      ).filter(
        (entry) =>
          !covered.has(entry.journalId) &&
          !(entry.sourceKind === 'receipt' && entry.sourceId && anchorReceipts.has(entry.sourceId)),
      );
      const balance = await this.earnings(tx, captain.cityId, captain.id);
      const explained = entries.reduce((total, entry) => total + entry.amount, opening);
      const settled = balance.amount === now.amount && balance.amount === explained;
      now = balance;
      if (settled) break;
    }
    const balance = now.amount;
    const sum = (type: string) =>
      entries
        .filter((entry) => entry.type === type)
        .reduce((total, entry) => total + entry.amount, 0n);
    const orderPay = new Map<string, bigint>();
    for (const entry of entries) {
      if (entry.type !== 'earn.order_pay' || entry.sourceKind !== 'order' || !entry.sourceId) {
        continue;
      }
      orderPay.set(entry.sourceId, (orderPay.get(entry.sourceId) ?? 0n) + entry.amount);
    }
    const paidOrders = [...orderPay].filter(([, amount]) => amount > 0n);
    const distances = await this.orders.distancePay(paidOrders.map(([id]) => id));
    let distancePay = 0n;
    for (const [id, amount] of paidOrders) {
      const distance = distances.get(id) ?? 0n;
      distancePay += distance < amount ? distance : amount;
    }
    const lines = {
      orders: paidOrders.length,
      basePay: sum('earn.order_pay') - distancePay,
      distancePay,
      waitingPay: sum('earn.waiting_pay'),
      peakBonus: sum('earn.peak_bonus'),
      bonuses: sum('earn.bonus'),
      charges: -sum('earn.charge'),
      instalments: -sum('earn.deposit_instalment'),
      adjustments: sum('earn.adjustment'),
    };
    const moved =
      lines.basePay +
      lines.distancePay +
      lines.waitingPay +
      lines.peakBonus +
      lines.bonuses -
      lines.charges -
      lines.instalments +
      lines.adjustments;
    return {
      currency: now.currency,
      balance,
      lines,
      carriedIn: balance - moved,
      journalIds: [...new Set(entries.map((entry) => entry.journalId))],
    };
  }

  // CA §14 #20: «كشف الأسبوع جاهز: قبضت {المبلغ}», silent.
  private async notifyStatement(
    tx: Tx,
    captainId: string,
    statementId: string,
    payout: { currency: string; amount: bigint },
    known: ReadonlyMap<string, { symbol: string; decimals: number }>,
    now: Date,
  ): Promise<void> {
    const templateKey = 'captain.weekly_statement';
    const rendered = await this.texts.render(
      templateKey,
      { المبلغ: formatMoney(payout.amount, payout.currency, known) },
      tx,
    );
    await this.pushes.enqueue(
      tx,
      [
        {
          source: `cashdesk:statement:${statementId}`,
          recipient: { party: 'captain', captainId },
          templateKey,
          body: rendered.body,
          level: rendered.level,
          priority: rendered.priority,
          data: { target: 'statement', statementId },
          at: now,
        },
      ],
      now,
    );
  }

  // captain.payout_weekday against the business day on the city's clock
  // (finance.business_day_cutoff), and captain.negative_earnings_policy.
  private async dayRules(
    cityId: string,
    now: Date,
  ): Promise<{ payoutDay: boolean; payoutWeekday: PayoutWeekday; policy: NegativeEarningsPolicy }> {
    const timeZone = await this.geo.cityTimeZone(cityId);
    if (timeZone === null) throw new CashDeskRefusedError('unknown_city', 'no such city');
    const [cutoff, payoutWeekday, policy] = await Promise.all([
      this.settings.get('finance.business_day_cutoff', { cityId }),
      this.settings.get('captain.payout_weekday', { cityId }),
      this.settings.get('captain.negative_earnings_policy', { cityId }),
    ]);
    const [hours, minutes] = cutoff.split(':').map(Number) as [number, number];
    const dayStart = lastCutoff(now, hours * 60 + minutes, timeZone);
    const weekday =
      WEEKDAYS[new Intl.DateTimeFormat('en-US', { timeZone, weekday: 'long' }).format(dayStart)];
    return { payoutDay: weekday === payoutWeekday, payoutWeekday, policy };
  }
}

// + the captain gives, − the desk pays, per currency, the zeros left out.
function netOf(
  custody: readonly { currency: string; balance: bigint }[],
  payout: { currency: string; amount: bigint } | null,
  collect: { currency: string; amount: bigint } | null,
): { currency: string; amount: bigint }[] {
  const net = new Map<string, bigint>();
  const add = (currency: string, amount: bigint) =>
    net.set(currency, (net.get(currency) ?? 0n) + amount);
  for (const line of custody) add(line.currency, line.balance);
  if (payout) add(payout.currency, -payout.amount);
  if (collect) add(collect.currency, collect.amount);
  return [...net]
    .filter(([, amount]) => amount !== 0n)
    .map(([currency, amount]) => ({ currency, amount }));
}

function sameCustody(
  held: readonly CustodyCurrency[],
  shown: readonly { currency: string; balance: bigint }[],
): boolean {
  const asShown = shown.filter((line) => line.balance !== 0n);
  return (
    new Set(asShown.map((line) => line.currency)).size === asShown.length &&
    asShown.length === held.length &&
    asShown.every((line) =>
      held.some((each) => each.currency === line.currency && each.balance === line.balance),
    )
  );
}

function sameRates(a: readonly ConversionRate[], b: readonly ConversionRate[]): boolean {
  const key = (rates: readonly ConversionRate[]) =>
    JSON.stringify([...rates].map((rate) => [rate.currency, rate.rateVersionId]).sort());
  return key(a) === key(b);
}

// An earnings line's expected amount, from the captain's side.
function placeholder(currency: string, balance: bigint): CustodyCurrency {
  return { currency, balance, closedDue: 0n, today: 0n, balanceInBase: 0n };
}

// The transaction's own time, which the ledger's entries take.
async function transactionTime(tx: Tx): Promise<Date> {
  const result = await tx.execute<{ now: Date | string }>(sql`SELECT now() AS now`);
  return new Date(result.rows[0]!.now);
}

function unknownCaptain(error: unknown): never {
  if ((error as { refusal?: string }).refusal === 'unknown_captain') {
    throw new CashDeskRefusedError('unknown_captain', 'no such captain');
  }
  throw error;
}

function statementOf(row: typeof statements.$inferSelect): Statement {
  return {
    id: row.id,
    cityId: row.cityId,
    captainId: row.captainId,
    captainName: row.captainName,
    sessionId: row.sessionId,
    cashierId: row.adminAccountId,
    periodFrom: row.periodFrom,
    createdAt: row.createdAt,
    currency: row.currency,
    orders: row.orders,
    basePay: row.basePay,
    distancePay: row.distancePay,
    waitingPay: row.waitingPay,
    peakBonus: row.peakBonus,
    bonuses: row.bonuses,
    charges: row.charges,
    instalments: row.instalments,
    adjustments: row.adjustments,
    carriedIn: row.carriedIn,
    balance: row.balance,
    paid: row.paid,
    payout:
      row.payoutCurrency === null || row.payoutAmount === null
        ? null
        : { currency: row.payoutCurrency, amount: row.payoutAmount },
    collected: row.collected,
    carriedOut: row.carriedOut,
    offCycle: row.offCycle,
    reason: row.reason,
    receiptIds: row.receiptIds,
  };
}
