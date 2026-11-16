import { createHash } from 'node:crypto';
import { Inject, Injectable } from '@nestjs/common';
import { and, asc, desc, eq, inArray, isNotNull, isNull, lt, max, sql } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { type AuditActor, type AuditRequestContext, AuditService } from '../audit/index.js';
import {
  type CaptainBalance,
  CaptainsService,
  type CustodyCurrency,
  type DeskCaptain,
} from '../captains/index.js';
import { formatMoney, NotificationTexts, receiptTypeLabels } from '../content/index.js';
import {
  exchange,
  FxRefusedError,
  FxService,
  type Rate,
  type RateSnapshot,
  unitRate,
} from '../fx/index.js';
import { GeoService } from '../geo/index.js';
import { AdminSessionsService } from '../identity/index.js';
import { type JournalType, LedgerService } from '../ledger/index.js';
import { PushQueue } from '../notifications/index.js';
import {
  drawerSessionCurrencies,
  drawerSessions,
  idempotencyKeys,
  receiptConversions,
  receiptCounters,
  receiptLines,
  receipts,
  type captainReceiptTypes,
  type receiptTypes,
  type sessionKinds,
} from './schema.js';

export type CashDeskRefusal =
  | 'session_open'
  | 'no_open_session'
  | 'unknown_session'
  | 'not_your_session'
  | 'session_closed'
  | 'invalid_amounts'
  | 'note_required'
  | 'unknown_captain'
  | 'nothing_due'
  | 'above_custody'
  | 'drawer_short'
  | 'unknown_city'
  | 'rate_changed'
  | 'rate_missing'
  | 'idempotency_key_reused'
  // «تصفية الخميس» (slice 2.18a).
  | 'not_payout_day'
  | 'reason_required'
  | 'balance_changed'
  // «تسوية المطاعم» (slice 2.19b).
  | 'unknown_restaurant'
  | 'above_balance'
  // The field visit (slice 2.19c): a visitor not on the team, or one named
  // in a field session, whose visitor is its own user.
  | 'unknown_visitor'
  | 'invalid_visitor'
  // A field visit's receipt names its visitor: an account without a name
  // (the first OWN) cannot hold a field session.
  | 'name_required'
  // «القيود التصحيحية» (slice 2.20c).
  | 'unknown_party'
  | 'unknown_journal'
  | 'invalid_currency'
  | 'invalid_account'
  | 'no_base_currency'
  | 'already_reversed'
  | 'not_reversible';

export class CashDeskRefusedError extends Error {
  override readonly name = 'CashDeskRefusedError';
  constructor(
    readonly refusal: CashDeskRefusal,
    message: string,
  ) {
    super(message);
  }
}

// The admin at the drawer: who records, for the audit and the session.
export interface DeskUser {
  accountId: string;
  roles: readonly string[];
  actor: AuditActor;
  context: AuditRequestContext;
}

// Cash in one currency, in its minor units.
export interface CashLine {
  currency: string;
  amount: bigint;
}

export interface SessionCurrency {
  currency: string;
  openingFloat: bigint;
  // The float plus the cash the session's transactions moved: now while it
  // is open, as it was at the close after.
  expected: bigint;
  counted: bigint | null;
  // counted − expected, at the close.
  variance: bigint | null;
}

export interface DrawerSession {
  id: string;
  cityId: string;
  adminAccountId: string;
  adminName: string | null;
  kind: SessionKind;
  openedAt: Date;
  closedAt: Date | null;
  closeNote: string | null;
  currencies: SessionCurrency[];
}

export type ReceiptType = (typeof receiptTypes)[number];
export type SessionKind = (typeof sessionKinds)[number];
// A captain's receipt; a restaurant's is merchant-settlement.service.ts's.
export type CaptainReceiptType = (typeof captainReceiptTypes)[number];

export interface ReceiptLine {
  currency: string;
  // The custody the desk expected, from the captain's side: + to hand in,
  // − owed to them.
  expected: bigint;
  // The cash that changed hands, above zero.
  amount: bigint;
  // What stays open (AP §9.10.3: a difference is not hidden).
  remaining: bigint;
}

// AP §9.10.3 cross-currency settlement: the rate version of each currency of
// a conversion but the base, as the screen showed it.
export interface ConversionRate {
  currency: string;
  rateVersionId: string;
}

// Custody moved from one currency into another before the cash changes
// hands: `amount` of `from` taken off its balance towards zero, `converted`
// of `to` added in the same direction, at the rates shown.
export interface Conversion {
  from: string;
  to: string;
  amount: bigint;
  converted: bigint;
  rates: ConversionRate[];
}

// What the desk shows before the confirmation (AP §9.10.3: «at the current
// rate, shown on screen»): the converted amount, rounded by the target's
// rule (AP §8.6), the rate versions, and one unit of the dearer currency in
// the other as a decimal of up to 4 places.
export interface ConversionQuote extends Conversion {
  unit: { from: string; to: string; value: string };
}

export interface Receipt {
  id: string;
  cityId: string;
  number: string;
  type: CaptainReceiptType;
  sessionId: string;
  cashierId: string;
  cashierName: string | null;
  captainId: string;
  captainName: string;
  createdAt: Date;
  // The conversions made before its cash changed hands.
  conversions: { from: string; amount: bigint; to: string; converted: bigint }[];
  lines: ReceiptLine[];
}

// AP §9.10.2 «أرصدة الكباتن»: a captain's balance with the desk's dates.
export interface BalanceRow extends CaptainBalance {
  // The custody of every currency at the current rate, netted: the sort.
  custodyInBase: bigint;
  // The latest «تسليم نقد» receipt.
  lastHandInAt: Date | null;
  // The latest «صرف المستحقات» receipt (slice 2.18a).
  lastPayoutAt: Date | null;
}

export interface HandInCommand {
  captainId: string;
  // AP §9.10.3: converted first, each `from` once (FIN and OWN, who hold
  // cash_desk.record).
  conversions?: Conversion[];
  // What is physically received (or paid back) per currency.
  lines: CashLine[];
  idempotencyKey: string;
}

export type Tx = Parameters<Parameters<Database['db']['transaction']>[0]>[0];
export type Executor = Tx | Database['db'];

// A key is answered again for 24 hours (architecture §5.3).
export const KEY_LIFETIME_MS = 24 * 3_600_000;

// The journal of each receipt type and the sign of its cash from the
// captain's side: a hand-in lowers their custody and a reimbursement raises
// a negative one to zero; a payout pays the earnings the platform owes them
// (the line's expected is that amount, below zero) and a collection takes
// a negative balance back (above zero).
const kinds: Record<CaptainReceiptType, { journal: JournalType; sign: 1n | -1n }> = {
  captain_hand_in: { journal: 'custody.hand_in', sign: 1n },
  captain_reimbursement: { journal: 'custody.reimburse', sign: -1n },
  captain_payout: { journal: 'earn.payout', sign: -1n },
  captain_earnings_collection: { journal: 'earn.payout', sign: 1n },
};

// What an earnings receipt moves in the base (the payout's value when paid
// in another currency, with the rate versions shown).
export interface EarningsMove {
  base: bigint;
  baseCurrency: string;
  rates: ConversionRate[];
}

// The cash desk (AP §9.10.3): drawer sessions and the daily hand-in, each
// transaction a numbered receipt (AP §4.8) whose money is posted through the
// ledger against the session's own `platform.cash`.
@Injectable()
export class CashDeskService {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly ledger: LedgerService,
    private readonly captains: CaptainsService,
    private readonly fx: FxService,
    private readonly geo: GeoService,
    private readonly audit: AuditService,
    private readonly admins: AdminSessionsService,
    private readonly texts: NotificationTexts,
    private readonly pushes: PushQueue,
  ) {}

  // «فتح الصندوق»: an office session with its float counted per currency;
  // every enabled currency of the city gets a row (0 when not given). A
  // field session (AP §9.10.3 «زيارة ميدانية», slice 2.19c) opens beside it
  // with a zero float in every currency.
  async openSession(
    user: DeskUser,
    cityId: string,
    floats: CashLine[],
    now: Date,
    kind: SessionKind = 'office',
  ): Promise<DrawerSession> {
    if (!(await this.geo.cityCode(cityId))) {
      throw new CashDeskRefusedError('unknown_city', 'no such city');
    }
    const enabled = await this.deskCurrencies(cityId);
    checkLines(floats, enabled, 0n);
    if (kind === 'field') {
      if (floats.some((line) => line.amount !== 0n)) {
        throw new CashDeskRefusedError('invalid_amounts', 'a field session opens with zero');
      }
      if (!(await this.admins.names([user.accountId])).get(user.accountId)) {
        throw new CashDeskRefusedError('name_required', 'the visitor is named on the receipt');
      }
    }
    const id = await this.database.db.transaction(async (tx) => {
      await tx.execute(
        sql`SELECT pg_advisory_xact_lock(hashtextextended(${`cashdesk.session:${user.accountId}`}, 0))`,
      );
      const [open] = await tx
        .select({ id: drawerSessions.id })
        .from(drawerSessions)
        .where(
          and(
            eq(drawerSessions.adminAccountId, user.accountId),
            eq(drawerSessions.kind, kind),
            isNull(drawerSessions.closedAt),
          ),
        );
      if (open) throw new CashDeskRefusedError('session_open', 'a session is already open');
      const [created] = await tx
        .insert(drawerSessions)
        .values({ cityId, adminAccountId: user.accountId, kind, openedAt: now })
        .returning({ id: drawerSessions.id });
      const sessionId = created!.id;
      const given = new Map(floats.map((line) => [line.currency, line.amount]));
      if (enabled.length > 0) {
        await tx.insert(drawerSessionCurrencies).values(
          enabled.map((currency) => ({
            sessionId,
            currency,
            openingFloat: given.get(currency) ?? 0n,
          })),
        );
      }
      await this.audit.recordWrite(
        {
          actor: user.actor,
          context: user.context,
          cityId,
          action: 'cash_desk.session_open',
          target: { type: 'drawer_session', id: sessionId },
          before: null,
          after: { kind, floats: kind === 'field' ? [] : floats.map(moneyOf) },
        },
        tx,
      );
      return sessionId;
    });
    return (await this.session(id))!;
  }

  // The city's enabled currencies in display order: what a float counts.
  async deskCurrencies(cityId: string): Promise<string[]> {
    return (await this.fx.cityCurrencies(cityId))
      .filter((entry) => entry.enabled)
      .map((entry) => entry.currency);
  }

  // The user's open session of that kind, or null.
  async openSessionOf(
    adminAccountId: string,
    kind: SessionKind = 'office',
  ): Promise<DrawerSession | null> {
    const [row] = await this.database.db
      .select({ id: drawerSessions.id })
      .from(drawerSessions)
      .where(openOf(adminAccountId, kind));
    return row ? this.session(row.id) : null;
  }

  // «إقفال الصندوق»: the counted cash of every currency of the session; any
  // variance needs a note (owner decision 2026-11-12: kept here only, never
  // in the ledger). It waits for a running transaction of the session (the
  // hand-in holds the session FOR SHARE), so none is left unconfirmed.
  async closeSession(
    user: DeskUser,
    sessionId: string,
    counted: CashLine[],
    note: string | null,
    now: Date,
  ): Promise<DrawerSession> {
    const trimmed = note?.trim() || null;
    await this.database.db.transaction(async (tx) => {
      const [session] = await tx
        .select()
        .from(drawerSessions)
        .where(eq(drawerSessions.id, sessionId))
        .for('update');
      if (!session) throw new CashDeskRefusedError('unknown_session', 'no such session');
      if (session.adminAccountId !== user.accountId) {
        throw new CashDeskRefusedError('not_your_session', 'a user closes their own session');
      }
      if (session.closedAt) throw new CashDeskRefusedError('session_closed', 'already closed');
      const rows = await tx
        .select()
        .from(drawerSessionCurrencies)
        .where(eq(drawerSessionCurrencies.sessionId, sessionId));
      const currencies = rows.map((row) => row.currency);
      checkLines(counted, currencies, 0n);
      if (counted.length !== currencies.length) {
        throw new CashDeskRefusedError('invalid_amounts', 'count every currency of the session');
      }
      const cash = await this.cash(tx, session.cityId, sessionId);
      const byCurrency = new Map(counted.map((line) => [line.currency, line.amount]));
      const closing = rows.map((row) => ({
        currency: row.currency,
        expected: row.openingFloat + (cash.get(row.currency) ?? 0n),
        counted: byCurrency.get(row.currency)!,
      }));
      if (closing.some((line) => line.counted !== line.expected) && trimmed === null) {
        throw new CashDeskRefusedError('note_required', 'a variance needs a note');
      }
      for (const line of closing) {
        await tx
          .update(drawerSessionCurrencies)
          .set({ expected: line.expected, counted: line.counted })
          .where(
            and(
              eq(drawerSessionCurrencies.sessionId, sessionId),
              eq(drawerSessionCurrencies.currency, line.currency),
            ),
          );
      }
      await tx
        .update(drawerSessions)
        .set({ closedAt: now, closeNote: trimmed })
        .where(eq(drawerSessions.id, sessionId));
      await this.audit.recordWrite(
        {
          actor: user.actor,
          context: user.context,
          cityId: session.cityId,
          action: 'cash_desk.session_close',
          target: { type: 'drawer_session', id: sessionId },
          before: null,
          after: {
            currencies: closing.map((line) => ({
              currency: line.currency,
              expected: line.expected.toString(),
              counted: line.counted.toString(),
              variance: (line.counted - line.expected).toString(),
            })),
            note: trimmed,
          },
        },
        tx,
      );
    });
    return (await this.session(sessionId))!;
  }

  // The city's sessions, newest first: every user's for OWN (AP §9.10.3),
  // one user's otherwise.
  async sessions(
    cityId: string,
    adminAccountId: string | null,
    limit: number,
  ): Promise<DrawerSession[]> {
    const rows = await this.database.db
      .select({ id: drawerSessions.id })
      .from(drawerSessions)
      .where(
        and(
          eq(drawerSessions.cityId, cityId),
          adminAccountId === null ? undefined : eq(drawerSessions.adminAccountId, adminAccountId),
        ),
      )
      .orderBy(desc(drawerSessions.openedAt))
      .limit(limit);
    const sessions = await Promise.all(rows.map((row) => this.session(row.id)));
    return sessions.filter((session): session is DrawerSession => session !== null);
  }

  async session(sessionId: string): Promise<DrawerSession | null> {
    const [session] = await this.database.db
      .select()
      .from(drawerSessions)
      .where(eq(drawerSessions.id, sessionId));
    if (!session) return null;
    const [rows, cash, names] = await Promise.all([
      this.database.db
        .select()
        .from(drawerSessionCurrencies)
        .where(eq(drawerSessionCurrencies.sessionId, sessionId)),
      session.closedAt
        ? new Map<string, bigint>()
        : this.cash(this.database.db, session.cityId, sessionId),
      this.admins.names([session.adminAccountId]),
    ]);
    const order = await this.currencyOrder(session.cityId);
    return {
      id: session.id,
      cityId: session.cityId,
      adminAccountId: session.adminAccountId,
      adminName: names.get(session.adminAccountId) ?? null,
      kind: session.kind,
      openedAt: session.openedAt,
      closedAt: session.closedAt,
      closeNote: session.closeNote,
      currencies: rows
        .map((row) => {
          const expected = row.expected ?? row.openingFloat + (cash.get(row.currency) ?? 0n);
          return {
            currency: row.currency,
            openingFloat: row.openingFloat,
            expected,
            counted: row.counted,
            variance: row.counted === null ? null : row.counted - expected,
          };
        })
        .sort((a, b) => order(a.currency) - order(b.currency)),
    };
  }

  // «تسليم النقد اليومي» (AP §9.10.3): the cash received from the captain in
  // each currency they must hand in (custody.hand_in), or paid back in each
  // one the office owes them (custody.reimburse), never more than the
  // custody; the rest stays open. One receipt per type, numbered in order.
  async handIn(user: DeskUser, command: HandInCommand, now: Date): Promise<Receipt[]> {
    for (const line of command.lines) {
      if (line.amount <= 0n) {
        throw new CashDeskRefusedError('invalid_amounts', 'an amount is above zero');
      }
    }
    if (
      command.lines.length === 0 ||
      new Set(command.lines.map((line) => line.currency)).size !== command.lines.length
    ) {
      throw new CashDeskRefusedError('invalid_amounts', 'one line per currency, one at least');
    }
    const conversions = command.conversions ?? [];
    checkConversions(conversions);
    const requestHash = createHash('sha256')
      .update(
        JSON.stringify({
          captainId: command.captainId,
          lines: command.lines.map((line) => [line.currency, line.amount.toString()]),
          conversions: conversions.map((each) => [
            each.from,
            each.to,
            each.amount.toString(),
            each.converted.toString(),
            each.rates.map((rate) => [rate.currency, rate.rateVersionId]),
          ]),
        }),
      )
      .digest('hex');
    const replayed = await this.replay(this.database.db, user.accountId, command, requestHash, now);
    if (replayed) return this.receiptsOf(replayed.receiptIds);

    const deskLock = await this.captains
      .deskLock(command.captainId, now)
      .catch((error: unknown) => {
        if ((error as { refusal?: string }).refusal === 'unknown_captain') {
          throw new CashDeskRefusedError('unknown_captain', 'no such captain');
        }
        throw error;
      });
    const captain = deskLock.captain;
    const [city, currencies] = await Promise.all([
      this.geo.cityCode(captain.cityId),
      this.fx.currencies(),
    ]);
    if (!city) throw new Error(`city ${captain.cityId} does not exist`);
    const known = new Map(
      currencies.map((each) => [each.code, { symbol: each.symbol, decimals: each.decimals }]),
    );

    const ids = await this.database.db.transaction(async (tx) => {
      const [session] = await tx
        .select()
        .from(drawerSessions)
        .where(openOf(user.accountId, 'office'))
        .for('share');
      if (!session) throw new CashDeskRefusedError('no_open_session', 'open the drawer first');
      if (session.cityId !== captain.cityId) {
        throw new CashDeskRefusedError('unknown_captain', 'the captain is of another city');
      }
      const custody = await deskLock.lock(tx);
      // Again under the captain's lock (a key names one captain): a request
      // sent twice at once waits for the first and answers its receipts.
      const again = await this.replay(tx, user.accountId, command, requestHash, now);
      if (again) return again.receiptIds;
      const drawer = await this.drawerCash(tx, session);
      const held = new Map(custody.currencies.map((line) => [line.currency, { ...line }]));
      const converting = await this.convertHeld(tx, captain.cityId, conversions, held);
      const grouped = new Map<ReceiptType, { line: CashLine; held: CustodyCurrency }[]>();
      for (const line of command.lines) {
        const position = held.get(line.currency);
        if (!position || position.balance === 0n) {
          throw new CashDeskRefusedError('nothing_due', `no custody in ${line.currency}`);
        }
        const type: ReceiptType =
          position.balance > 0n ? 'captain_hand_in' : 'captain_reimbursement';
        if (line.amount > (position.balance > 0n ? position.balance : -position.balance)) {
          throw new CashDeskRefusedError(
            'above_custody',
            `more than the custody in ${line.currency}`,
          );
        }
        // The drawer pays back only the cash it holds in that currency.
        if (type === 'captain_reimbursement' && line.amount > (drawer.get(line.currency) ?? 0n)) {
          throw new CashDeskRefusedError('drawer_short', `the drawer lacks ${line.currency}`);
        }
        grouped.set(type, [...(grouped.get(type) ?? []), { line, held: position }]);
      }
      const year = cityYear(now, city.timeZone);
      const issued: string[] = [];
      for (const type of ['captain_hand_in', 'captain_reimbursement'] as const) {
        const lines = grouped.get(type);
        if (!lines) continue;
        const receipt = await this.issue(tx, {
          user,
          session,
          captain,
          type,
          // The conversions go on the first receipt.
          conversions: issued.length === 0 ? converting : [],
          lines,
          number: await nextNumber(tx, captain.cityId, city.code, year),
          year,
          now,
        });
        await this.notify(tx, captain.id, receipt, lines, known, now);
        issued.push(receipt.id);
      }
      await this.captains.custodyChanged(tx, captain, now);
      await keepKey(tx, user.accountId, command.idempotencyKey, requestHash, issued, null, now);
      return issued;
    });
    return this.receiptsOf(ids);
  }

  // AP §9.10.3: the conversion at the current rate, to show before the
  // confirmation; the hand-in refuses it once the rate or rounding changed.
  async quoteConversion(
    cityId: string,
    asked: { from: string; to: string; amount: bigint },
  ): Promise<ConversionQuote> {
    checkConversions([{ ...asked, converted: 1n, rates: [] }]);
    return quoteOf(await this.snapshotOf(cityId, this.database.db), asked);
  }

  // Applies the conversions to the custody held (mutated), under the
  // captain's lock, checking each against its custody and the rate now.
  private async convertHeld(
    tx: Tx,
    cityId: string,
    conversions: Conversion[],
    held: Map<string, CustodyCurrency>,
  ): Promise<(Conversion & { sign: 1n | -1n })[]> {
    if (conversions.length === 0) return [];
    const snapshot = await this.snapshotOf(cityId, tx);
    const converting: (Conversion & { sign: 1n | -1n })[] = [];
    for (const conversion of conversions) {
      const position = held.get(conversion.from);
      if (!position || position.balance === 0n) {
        throw new CashDeskRefusedError('nothing_due', `no custody in ${conversion.from}`);
      }
      const sign = position.balance > 0n ? 1n : -1n;
      if (conversion.amount > sign * position.balance) {
        throw new CashDeskRefusedError(
          'above_custody',
          `more than the custody in ${conversion.from}`,
        );
      }
      const now = quoteOf(snapshot, conversion);
      if (now.converted !== conversion.converted || !sameRates(now.rates, conversion.rates)) {
        throw new CashDeskRefusedError('rate_changed', 'the rate is not the one shown');
      }
      position.balance -= sign * conversion.amount;
      const target = held.get(conversion.to) ?? {
        currency: conversion.to,
        balance: 0n,
        closedDue: 0n,
        today: 0n,
        balanceInBase: 0n,
      };
      target.balance += sign * conversion.converted;
      held.set(conversion.to, target);
      converting.push({ ...conversion, rates: now.rates, sign });
    }
    return converting;
  }

  // custody.fx_convert (AP §8.6, the ledger's rules): the captain's custody
  // leaves one currency and enters the other through platform.fx_rounding,
  // which keeps the rounding difference, with the rates' versions.
  private async postConversion(
    tx: Tx,
    user: DeskUser,
    captain: DeskCaptain,
    receiptId: string,
    conversion: Conversion & { sign: 1n | -1n },
  ): Promise<void> {
    const account = (purpose: 'captain.custody' | 'platform.fx_rounding', currency: string) =>
      this.ledger.openAccount(
        {
          cityId: captain.cityId,
          purpose,
          ownerId: purpose === 'captain.custody' ? captain.id : null,
          currency,
        },
        tx,
      );
    const { from, to, amount, converted, sign } = conversion;
    const entries = [
      { accountId: await account('captain.custody', from), currency: from, amount: -sign * amount },
      {
        accountId: await account('platform.fx_rounding', from),
        currency: from,
        amount: sign * amount,
      },
      { accountId: await account('captain.custody', to), currency: to, amount: sign * converted },
      {
        accountId: await account('platform.fx_rounding', to),
        currency: to,
        amount: -sign * converted,
      },
    ];
    const journalId = await this.ledger.post(
      {
        cityId: captain.cityId,
        type: 'custody.fx_convert',
        source: { kind: 'receipt', id: receiptId },
        actor: { type: 'admin', id: user.accountId },
        entries,
        rates: conversion.rates,
      },
      tx,
    );
    await tx.insert(receiptConversions).values({
      receiptId,
      fromCurrency: from,
      fromAmount: amount,
      toCurrency: to,
      toAmount: converted,
      journalId,
    });
  }

  async snapshotOf(cityId: string, executor: Executor): Promise<RateSnapshot> {
    try {
      return await this.fx.snapshot(cityId, executor);
    } catch (error) {
      if (error instanceof FxRefusedError) {
        throw new CashDeskRefusedError('rate_missing', error.message);
      }
      throw error;
    }
  }

  // AP §9.10.2: every captain's balance, the highest custody first; «سجّل
  // تسليماً» opens the desk for one.
  async balances(cityId: string, now: Date): Promise<BalanceRow[]> {
    const listed = await this.captains.balances(cityId, now);
    if (listed.length === 0) return [];
    const handIns = await this.database.db
      .select({ captainId: receipts.captainId, at: max(receipts.createdAt) })
      .from(receipts)
      .where(
        and(
          eq(receipts.cityId, cityId),
          eq(receipts.type, 'captain_hand_in'),
          inArray(
            receipts.captainId,
            listed.map((row) => row.captainId),
          ),
        ),
      )
      .groupBy(receipts.captainId);
    const lastHandIn = new Map(handIns.map((row) => [row.captainId, row.at]));
    const payouts = await this.database.db
      .select({ captainId: receipts.captainId, at: max(receipts.createdAt) })
      .from(receipts)
      .where(
        and(
          eq(receipts.cityId, cityId),
          eq(receipts.type, 'captain_payout'),
          inArray(
            receipts.captainId,
            listed.map((row) => row.captainId),
          ),
        ),
      )
      .groupBy(receipts.captainId);
    const lastPayout = new Map(payouts.map((row) => [row.captainId, row.at]));
    return listed
      .map((row) => ({
        ...row,
        custodyInBase: row.custody.currencies.reduce((sum, line) => sum + line.balanceInBase, 0n),
        lastHandInAt: lastHandIn.get(row.captainId) ?? null,
        lastPayoutAt: lastPayout.get(row.captainId) ?? null,
      }))
      .sort((a, b) =>
        a.custodyInBase === b.custodyInBase
          ? a.name.localeCompare(b.name, 'ar')
          : a.custodyInBase > b.custodyInBase
            ? -1
            : 1,
      );
  }

  async receipt(receiptId: string): Promise<Receipt | null> {
    return (await this.receiptsOf([receiptId]))[0] ?? null;
  }

  // A receipt with its lines, each posted as its type's journal, and the
  // audit. Earnings receipts take `earnings`.
  async issue(
    tx: Tx,
    input: {
      user: DeskUser;
      session: typeof drawerSessions.$inferSelect;
      captain: DeskCaptain;
      type: CaptainReceiptType;
      conversions: (Conversion & { sign: 1n | -1n })[];
      lines: { line: CashLine; held: CustodyCurrency }[];
      number: { sequence: number; number: string };
      year: number;
      now: Date;
      earnings?: EarningsMove;
    },
  ): Promise<{ id: string; number: string; type: CaptainReceiptType }> {
    const { user, session, captain, type, lines, now } = input;
    const [created] = await tx
      .insert(receipts)
      .values({
        cityId: captain.cityId,
        year: input.year,
        sequence: input.number.sequence,
        number: input.number.number,
        type,
        sessionId: session.id,
        adminAccountId: user.accountId,
        captainId: captain.id,
        captainName: captain.name,
        createdAt: now,
      })
      .returning({ id: receipts.id });
    const receiptId = created!.id;
    for (const conversion of input.conversions) {
      await this.postConversion(tx, user, captain, receiptId, conversion);
    }
    const { journal, sign } = kinds[type];
    for (const { line, held } of lines) {
      if (journal === 'earn.payout') {
        const journalId = await this.postEarnings(tx, {
          user,
          session,
          captain,
          receiptId,
          sign,
          line,
          earnings: input.earnings!,
        });
        await this.keepLine(tx, session.id, receiptId, line, { expected: held.balance }, journalId);
        continue;
      }
      const custodyAccount = await this.ledger.openAccount(
        {
          cityId: captain.cityId,
          purpose: 'captain.custody',
          ownerId: captain.id,
          currency: line.currency,
        },
        tx,
      );
      const cashAccount = await this.ledger.openAccount(
        {
          cityId: captain.cityId,
          purpose: 'platform.cash',
          ownerId: session.id,
          currency: line.currency,
        },
        tx,
      );
      // From the platform's side: a hand-in takes the captain's custody down
      // and puts the cash in the drawer; a reimbursement the other way.
      const journalId = await this.ledger.post(
        {
          cityId: captain.cityId,
          type: journal,
          source: { kind: 'receipt', id: receiptId },
          actor: { type: 'admin', id: user.accountId },
          entries: [
            { accountId: custodyAccount, currency: line.currency, amount: -sign * line.amount },
            { accountId: cashAccount, currency: line.currency, amount: sign * line.amount },
          ],
        },
        tx,
      );
      await this.keepLine(tx, session.id, receiptId, line, { expected: held.balance }, journalId);
    }
    await this.audit.recordWrite(
      {
        actor: user.actor,
        context: user.context,
        cityId: captain.cityId,
        action: 'cash_desk.receipt',
        target: { type: 'receipt', id: receiptId },
        before: null,
        after: {
          number: input.number.number,
          type,
          captainId: captain.id,
          sessionId: session.id,
          conversions: input.conversions.map((each) => ({
            from: each.from,
            amount: each.amount.toString(),
            to: each.to,
            converted: each.converted.toString(),
            rates: each.rates,
          })),
          lines: lines.map(({ line, held }) => ({
            currency: line.currency,
            expected: held.balance.toString(),
            amount: line.amount.toString(),
          })),
        },
      },
      tx,
    );
    return { id: receiptId, number: input.number.number, type };
  }

  // A receipt's line: a captain's with the custody expected, a restaurant's
  // with its value in the base.
  async keepLine(
    tx: Tx,
    sessionId: string,
    receiptId: string,
    line: CashLine,
    kept: { expected: bigint } | { baseAmount: bigint },
    journalId: string,
  ): Promise<void> {
    await tx.insert(receiptLines).values({
      receiptId,
      currency: line.currency,
      ...kept,
      amount: line.amount,
      journalId,
    });
    // A currency enabled after the session opened starts at a zero float.
    await tx
      .insert(drawerSessionCurrencies)
      .values({ sessionId, currency: line.currency, openingFloat: 0n })
      .onConflictDoNothing();
  }

  // earn.payout (AP §8.5.2, §8.5.5): the earnings the platform owes paid
  // from the drawer (sign −1), in the base or in another currency through
  // platform.fx_rounding at the rate shown; or a negative balance collected
  // into it (sign +1, captain.negative_earnings_policy collect_at_desk), in
  // the base. Amounts from the platform's side.
  private async postEarnings(
    tx: Tx,
    input: {
      user: DeskUser;
      session: typeof drawerSessions.$inferSelect;
      captain: DeskCaptain;
      receiptId: string;
      sign: 1n | -1n;
      line: CashLine;
      earnings: EarningsMove;
    },
  ): Promise<string> {
    const { user, session, captain, receiptId, sign, line, earnings } = input;
    const account = (
      purpose: 'captain.earnings' | 'platform.cash' | 'platform.fx_rounding',
      currency: string,
    ) =>
      this.ledger.openAccount(
        {
          cityId: captain.cityId,
          purpose,
          ownerId:
            purpose === 'captain.earnings'
              ? captain.id
              : purpose === 'platform.cash'
                ? session.id
                : null,
          currency,
        },
        tx,
      );
    const base = earnings.baseCurrency;
    const entries = [
      {
        accountId: await account('captain.earnings', base),
        currency: base,
        amount: -sign * earnings.base,
      },
      {
        accountId: await account('platform.cash', line.currency),
        currency: line.currency,
        amount: sign * line.amount,
      },
    ];
    if (line.currency !== base) {
      entries.push(
        {
          accountId: await account('platform.fx_rounding', base),
          currency: base,
          amount: sign * earnings.base,
        },
        {
          accountId: await account('platform.fx_rounding', line.currency),
          currency: line.currency,
          amount: -sign * line.amount,
        },
      );
    }
    return this.ledger.post(
      {
        cityId: captain.cityId,
        type: 'earn.payout',
        source: { kind: 'receipt', id: receiptId },
        actor: { type: 'admin', id: user.accountId },
        entries,
        ...(line.currency === base ? {} : { rates: earnings.rates }),
      },
      tx,
    );
  }

  // CA §14 #19: «إيصال {رقم}: {النوع} {المبلغ}», silent, to the captain.
  async notify(
    tx: Tx,
    captainId: string,
    receipt: { id: string; number: string; type: CaptainReceiptType },
    lines: { line: CashLine }[],
    known: ReadonlyMap<string, { symbol: string; decimals: number }>,
    now: Date,
  ): Promise<void> {
    const templateKey = 'captain.desk_receipt';
    const rendered = await this.texts.render(
      templateKey,
      {
        رقم: receipt.number,
        النوع: receiptTypeLabels[receipt.type],
        المبلغ: lines.map(({ line }) => formatMoney(line.amount, line.currency, known)).join(' + '),
      },
      tx,
    );
    await this.pushes.enqueue(
      tx,
      [
        {
          source: `cashdesk:receipt:${receipt.id}`,
          recipient: { party: 'captain', captainId },
          templateKey,
          body: rendered.body,
          level: rendered.level,
          priority: rendered.priority,
          data: { target: 'custody', receiptId: receipt.id },
          at: now,
        },
      ],
      now,
    );
  }

  // The cash in the session's drawer now, per currency: the float plus
  // what its transactions moved.
  async drawerCash(
    tx: Tx,
    session: typeof drawerSessions.$inferSelect,
  ): Promise<Map<string, bigint>> {
    const [floats, cash] = await Promise.all([
      tx
        .select()
        .from(drawerSessionCurrencies)
        .where(eq(drawerSessionCurrencies.sessionId, session.id)),
      this.cash(tx, session.cityId, session.id),
    ]);
    const drawer = new Map(cash);
    for (const row of floats) {
      drawer.set(row.currency, row.openingFloat + (drawer.get(row.currency) ?? 0n));
    }
    return drawer;
  }

  // The cash each currency of the session's drawer took in, net.
  private async cash(executor: Executor, cityId: string, sessionId: string) {
    const accounts = await this.ledger.ownerAccounts(cityId, sessionId, 'platform.cash', executor);
    const cash = new Map<string, bigint>();
    for (const account of accounts) {
      cash.set(account.currency, (await this.ledger.balance(account.id, executor)).amount);
    }
    return cash;
  }

  async currencyOrder(cityId: string): Promise<(currency: string) => number> {
    const city = await this.fx.cityCurrencies(cityId);
    const order = new Map(city.map((entry, index) => [entry.currency, index]));
    return (currency) => order.get(currency) ?? city.length;
  }

  // CA §10.2, AP §9.10.3: the captain's newest custody receipts, newest
  // first, at most `limit`, for «عهدتي»; a payout belongs to «أرباحي» (CA
  // §10.6, slice 2.18b).
  async captainReceipts(captainId: string, limit: number): Promise<Receipt[]> {
    const rows = await this.database.db
      .select({ id: receipts.id })
      .from(receipts)
      .where(
        and(
          eq(receipts.captainId, captainId),
          inArray(receipts.type, ['captain_hand_in', 'captain_reimbursement']),
        ),
      )
      .orderBy(desc(receipts.createdAt), desc(receipts.id))
      .limit(limit);
    // By time, newest first: the numbers start again each year (AP §4.8).
    return (await this.receiptsOf(rows.map((row) => row.id))).sort(
      (a, b) => b.createdAt.getTime() - a.createdAt.getTime() || b.id.localeCompare(a.id),
    );
  }

  // The numbers of some receipts, such as AZ-2026-000123; an unknown id is
  // left out.
  async receiptNumbers(receiptIds: readonly string[]): Promise<Map<string, string>> {
    if (receiptIds.length === 0) return new Map();
    const rows = await this.database.db
      .select({ id: receipts.id, number: receipts.number })
      .from(receipts)
      .where(inArray(receipts.id, [...new Set(receiptIds)]));
    return new Map(rows.map((row) => [row.id, row.number]));
  }

  async receiptsOf(ids: readonly string[]): Promise<Receipt[]> {
    if (ids.length === 0) return [];
    const rows = await this.database.db
      .select()
      .from(receipts)
      // A captain's: a restaurant's receipt has its own reader.
      .where(and(inArray(receipts.id, [...ids]), isNotNull(receipts.captainId)))
      .orderBy(asc(receipts.sequence));
    if (rows.length === 0) return [];
    const [lines, conversions, names] = await Promise.all([
      this.database.db
        .select()
        .from(receiptLines)
        .where(inArray(receiptLines.receiptId, [...ids])),
      this.database.db
        .select()
        .from(receiptConversions)
        .where(inArray(receiptConversions.receiptId, [...ids])),
      this.admins.names([...new Set(rows.map((row) => row.adminAccountId))]),
    ]);
    const order = await this.currencyOrder(rows[0]!.cityId);
    return rows.map((row) => ({
      id: row.id,
      cityId: row.cityId,
      number: row.number,
      type: row.type as CaptainReceiptType,
      sessionId: row.sessionId,
      cashierId: row.adminAccountId,
      cashierName: names.get(row.adminAccountId) ?? null,
      // receipts_party: a captain's receipt names the captain.
      captainId: row.captainId!,
      captainName: row.captainName!,
      createdAt: row.createdAt,
      conversions: conversions
        .filter((each) => each.receiptId === row.id)
        .sort((a, b) => order(a.fromCurrency) - order(b.fromCurrency))
        .map((each) => ({
          from: each.fromCurrency,
          amount: each.fromAmount,
          to: each.toCurrency,
          converted: each.toAmount,
        })),
      lines: lines
        .filter((line) => line.receiptId === row.id)
        .sort((a, b) => order(a.currency) - order(b.currency))
        .map((line) => {
          // receipt_lines_expected_or_base: a captain's line has expected.
          const expected = line.expected!;
          return {
            currency: line.currency,
            expected,
            amount: line.amount,
            remaining: expected - kinds[row.type as CaptainReceiptType].sign * line.amount,
          };
        }),
    }));
  }

  // The kept answer of a key used again within 24 hours with the same
  // command; another command is refused.
  async replay(
    executor: Executor,
    accountId: string,
    command: { idempotencyKey: string },
    requestHash: string,
    now: Date,
  ): Promise<{
    receiptIds: string[];
    statementId: string | null;
    manualEntryId: string | null;
  } | null> {
    const [row] = await executor
      .select()
      .from(idempotencyKeys)
      .where(
        and(
          eq(idempotencyKeys.accountId, accountId),
          eq(idempotencyKeys.key, command.idempotencyKey),
        ),
      );
    if (!row || row.createdAt.getTime() < now.getTime() - KEY_LIFETIME_MS) return null;
    if (row.requestHash !== requestHash) {
      throw new CashDeskRefusedError('idempotency_key_reused', 'the key came with another command');
    }
    return {
      receiptIds: row.receiptIds,
      statementId: row.statementId,
      manualEntryId: row.manualEntryId,
    };
  }
}

// Each currency once, among those allowed, at least `minimum`.
function checkLines(lines: CashLine[], allowed: readonly string[], minimum: bigint): void {
  const seen = new Set<string>();
  for (const line of lines) {
    if (!allowed.includes(line.currency) || seen.has(line.currency) || line.amount < minimum) {
      throw new CashDeskRefusedError('invalid_amounts', `an amount in ${line.currency} is refused`);
    }
    seen.add(line.currency);
  }
}

// AP §4.8: the next number of the city's year, {CITY}-{YYYY}-{000001}. The
// counter row is updated in the receipt's transaction, so a rollback gives
// the number back and the sequence keeps no gap.
// The user's open session of a kind: a captain's hand-in and settlement are
// at the office; a restaurant's payment in either (slice 2.19c).
export function openOf(adminAccountId: string, kind: SessionKind) {
  return and(
    eq(drawerSessions.adminAccountId, adminAccountId),
    eq(drawerSessions.kind, kind),
    isNull(drawerSessions.closedAt),
  );
}

export async function nextNumber(
  tx: Tx,
  cityId: string,
  code: string,
  year: number,
): Promise<{ sequence: number; number: string }> {
  const [row] = await tx
    .insert(receiptCounters)
    .values({ cityId, year, lastNumber: 1 })
    .onConflictDoUpdate({
      target: [receiptCounters.cityId, receiptCounters.year],
      set: { lastNumber: sql`${receiptCounters.lastNumber} + 1` },
    })
    .returning({ lastNumber: receiptCounters.lastNumber });
  const sequence = row!.lastNumber;
  return { sequence, number: `${code}-${year}-${sequence.toString().padStart(6, '0')}` };
}

export function cityYear(now: Date, timeZone: string): number {
  return Number(new Intl.DateTimeFormat('en-US', { timeZone, year: 'numeric' }).format(now));
}

// Keeps the key with its receipts, in the command's transaction, so a
// refused command keeps none. A key older than 24 hours is used again.
export async function keepKey(
  tx: Tx,
  accountId: string,
  key: string,
  requestHash: string,
  receiptIds: string[],
  statementId: string | null,
  now: Date,
  // A manual entry's key (slice 2.20c) keeps the entry, with no receipt.
  manualEntryId: string | null = null,
): Promise<void> {
  const kept = { requestHash, receiptIds, statementId, manualEntryId, createdAt: now };
  const [taken] = await tx
    .insert(idempotencyKeys)
    .values({ accountId, key, ...kept })
    .onConflictDoUpdate({
      target: [idempotencyKeys.accountId, idempotencyKeys.key],
      set: kept,
      setWhere: lt(idempotencyKeys.createdAt, new Date(now.getTime() - KEY_LIFETIME_MS)),
    })
    .returning({ key: idempotencyKeys.key });
  if (!taken) {
    throw new CashDeskRefusedError('idempotency_key_reused', 'the key came with another command');
  }
}

function moneyOf(line: CashLine) {
  return { amount: line.amount.toString(), currency: line.currency };
}

// Each `from` once, never also a `to`, two currencies, amounts above zero.
function checkConversions(conversions: Conversion[]): void {
  const from = new Set(conversions.map((each) => each.from));
  if (
    from.size !== conversions.length ||
    conversions.some(
      (each) =>
        each.from === each.to || from.has(each.to) || each.amount <= 0n || each.converted <= 0n,
    )
  ) {
    throw new CashDeskRefusedError('invalid_amounts', 'a conversion is refused');
  }
}

// The conversion at the snapshot's rates: both currencies enabled in the
// city, the result above zero once rounded.
export function quoteOf(
  snapshot: RateSnapshot,
  asked: { from: string; to: string; amount: bigint },
): ConversionQuote {
  const of = (code: string) => snapshot.currencies.find((each) => each.code === code);
  const from = of(asked.from);
  const to = of(asked.to);
  if (!from || !to) {
    throw new CashDeskRefusedError('invalid_amounts', 'convert between accepted currencies');
  }
  const converted = exchange(snapshot, asked.amount, asked.from, asked.to);
  if (converted <= 0n) {
    throw new CashDeskRefusedError('invalid_amounts', 'too small to convert');
  }
  const rates = [from, to]
    .filter((each) => each.rateVersionId !== null)
    .map((each) => ({ currency: each.code, rateVersionId: each.rateVersionId! }));
  const forward = unitRate(snapshot, asked.from, asked.to);
  const unit =
    forward.numerator >= forward.denominator
      ? { from: asked.from, to: asked.to, value: decimalOf(forward) }
      : {
          from: asked.to,
          to: asked.from,
          value: decimalOf({ numerator: forward.denominator, denominator: forward.numerator }),
        };
  return { from: asked.from, to: asked.to, amount: asked.amount, converted, rates, unit };
}

// A rate as the screen shows it: up to 4 decimal places, nearest.
function decimalOf(rate: Rate): string {
  const scaled = (rate.numerator * 20_000n + rate.denominator) / (2n * rate.denominator);
  const whole = scaled / 10_000n;
  const fraction = (scaled % 10_000n).toString().padStart(4, '0').replace(/0+$/, '');
  return fraction === '' ? whole.toString() : `${whole}.${fraction}`;
}

function sameRates(a: readonly ConversionRate[], b: readonly ConversionRate[]): boolean {
  const key = (rates: readonly ConversionRate[]) =>
    JSON.stringify(
      [...rates]
        .map((rate) => [rate.currency, rate.rateVersionId] as const)
        .sort((x, y) => x[0].localeCompare(y[0])),
    );
  return key(a) === key(b);
}
