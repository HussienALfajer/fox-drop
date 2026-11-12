import { createHash } from 'node:crypto';
import { Inject, Injectable } from '@nestjs/common';
import { and, asc, desc, eq, inArray, isNull, lt, sql } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { type AuditActor, type AuditRequestContext, AuditService } from '../audit/index.js';
import { CaptainsService, type CustodyCurrency, type DeskCaptain } from '../captains/index.js';
import { formatMoney, NotificationTexts, receiptTypeLabels } from '../content/index.js';
import { FxService } from '../fx/index.js';
import { GeoService } from '../geo/index.js';
import { AdminSessionsService } from '../identity/index.js';
import { type JournalType, LedgerService } from '../ledger/index.js';
import { PushQueue } from '../notifications/index.js';
import {
  drawerSessionCurrencies,
  drawerSessions,
  idempotencyKeys,
  receiptCounters,
  receiptLines,
  receipts,
  type receiptTypes,
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
  | 'idempotency_key_reused';

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
  kind: 'office';
  openedAt: Date;
  closedAt: Date | null;
  closeNote: string | null;
  currencies: SessionCurrency[];
}

export type ReceiptType = (typeof receiptTypes)[number];

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

export interface Receipt {
  id: string;
  cityId: string;
  number: string;
  type: ReceiptType;
  sessionId: string;
  cashierId: string;
  cashierName: string | null;
  captainId: string;
  captainName: string;
  createdAt: Date;
  lines: ReceiptLine[];
}

export interface HandInCommand {
  captainId: string;
  // What is physically received (or paid back) per currency.
  lines: CashLine[];
  idempotencyKey: string;
}

type Tx = Parameters<Parameters<Database['db']['transaction']>[0]>[0];
type Executor = Tx | Database['db'];

// A key is answered again for 24 hours (architecture §5.3).
const KEY_LIFETIME_MS = 24 * 3_600_000;

// The journal of each receipt type and its sign on the captain's custody:
// a hand-in lowers it, a reimbursement raises a negative one to zero.
const kinds: Record<ReceiptType, { journal: JournalType; sign: 1n | -1n }> = {
  captain_hand_in: { journal: 'custody.hand_in', sign: 1n },
  captain_reimbursement: { journal: 'custody.reimburse', sign: -1n },
};

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
  // every enabled currency of the city gets a row (0 when not given).
  async openSession(
    user: DeskUser,
    cityId: string,
    floats: CashLine[],
    now: Date,
  ): Promise<DrawerSession> {
    const enabled = (await this.fx.cityCurrencies(cityId))
      .filter((entry) => entry.enabled)
      .map((entry) => entry.currency);
    checkLines(floats, enabled, 0n);
    const id = await this.database.db.transaction(async (tx) => {
      await tx.execute(
        sql`SELECT pg_advisory_xact_lock(hashtextextended(${`cashdesk.session:${user.accountId}`}, 0))`,
      );
      const [open] = await tx
        .select({ id: drawerSessions.id })
        .from(drawerSessions)
        .where(
          and(eq(drawerSessions.adminAccountId, user.accountId), isNull(drawerSessions.closedAt)),
        );
      if (open) throw new CashDeskRefusedError('session_open', 'a session is already open');
      const [created] = await tx
        .insert(drawerSessions)
        .values({ cityId, adminAccountId: user.accountId, kind: 'office', openedAt: now })
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
          after: { floats: floats.map(moneyOf) },
        },
        tx,
      );
      return sessionId;
    });
    return (await this.session(id))!;
  }

  // The user's open office session, or null.
  async openSessionOf(adminAccountId: string): Promise<DrawerSession | null> {
    const [row] = await this.database.db
      .select({ id: drawerSessions.id })
      .from(drawerSessions)
      .where(
        and(eq(drawerSessions.adminAccountId, adminAccountId), isNull(drawerSessions.closedAt)),
      );
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
    const requestHash = createHash('sha256')
      .update(
        JSON.stringify({
          captainId: command.captainId,
          lines: command.lines.map((line) => [line.currency, line.amount.toString()]),
        }),
      )
      .digest('hex');
    const replayed = await this.replay(this.database.db, user.accountId, command, requestHash, now);
    if (replayed) return this.receiptsOf(replayed);

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
      // Within the transaction too: two requests with one key at once.
      const again = await this.replay(tx, user.accountId, command, requestHash, now);
      if (again) return again;
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
      const held = new Map(custody.currencies.map((line) => [line.currency, line]));
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
          lines,
          number: await nextNumber(tx, captain.cityId, city.code, year),
          year,
          now,
        });
        await this.notify(tx, captain.id, receipt, lines, known, now);
        issued.push(receipt.id);
      }
      await this.captains.custodyChanged(tx, captain, now);
      await keepKey(tx, user.accountId, command.idempotencyKey, requestHash, issued, now);
      return issued;
    });
    return this.receiptsOf(ids);
  }

  async receipt(receiptId: string): Promise<Receipt | null> {
    return (await this.receiptsOf([receiptId]))[0] ?? null;
  }

  private async issue(
    tx: Tx,
    input: {
      user: DeskUser;
      session: typeof drawerSessions.$inferSelect;
      captain: DeskCaptain;
      type: ReceiptType;
      lines: { line: CashLine; held: CustodyCurrency }[];
      number: { sequence: number; number: string };
      year: number;
      now: Date;
    },
  ): Promise<{ id: string; number: string; type: ReceiptType }> {
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
    const { journal, sign } = kinds[type];
    for (const { line, held } of lines) {
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
      await tx.insert(receiptLines).values({
        receiptId,
        currency: line.currency,
        expected: held.balance,
        amount: line.amount,
        journalId,
      });
      // A currency enabled after the session opened starts at a zero float.
      await tx
        .insert(drawerSessionCurrencies)
        .values({ sessionId: session.id, currency: line.currency, openingFloat: 0n })
        .onConflictDoNothing();
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

  // CA §14 #19: «إيصال {رقم}: {النوع} {المبلغ}», silent, to the captain.
  private async notify(
    tx: Tx,
    captainId: string,
    receipt: { id: string; number: string; type: ReceiptType },
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

  // The cash each currency of the session's drawer took in, net.
  private async cash(executor: Executor, cityId: string, sessionId: string) {
    const accounts = await this.ledger.ownerAccounts(cityId, sessionId, 'platform.cash', executor);
    const cash = new Map<string, bigint>();
    for (const account of accounts) {
      cash.set(account.currency, (await this.ledger.balance(account.id, executor)).amount);
    }
    return cash;
  }

  private async currencyOrder(cityId: string): Promise<(currency: string) => number> {
    const city = await this.fx.cityCurrencies(cityId);
    const order = new Map(city.map((entry, index) => [entry.currency, index]));
    return (currency) => order.get(currency) ?? city.length;
  }

  private async receiptsOf(ids: readonly string[]): Promise<Receipt[]> {
    if (ids.length === 0) return [];
    const rows = await this.database.db
      .select()
      .from(receipts)
      .where(inArray(receipts.id, [...ids]))
      .orderBy(asc(receipts.sequence));
    if (rows.length === 0) return [];
    const [lines, names] = await Promise.all([
      this.database.db
        .select()
        .from(receiptLines)
        .where(inArray(receiptLines.receiptId, [...ids])),
      this.admins.names([...new Set(rows.map((row) => row.adminAccountId))]),
    ]);
    const order = await this.currencyOrder(rows[0]!.cityId);
    return rows.map((row) => ({
      id: row.id,
      cityId: row.cityId,
      number: row.number,
      type: row.type,
      sessionId: row.sessionId,
      cashierId: row.adminAccountId,
      cashierName: names.get(row.adminAccountId) ?? null,
      captainId: row.captainId,
      captainName: row.captainName,
      createdAt: row.createdAt,
      lines: lines
        .filter((line) => line.receiptId === row.id)
        .sort((a, b) => order(a.currency) - order(b.currency))
        .map((line) => ({
          currency: line.currency,
          expected: line.expected,
          amount: line.amount,
          remaining: line.expected - kinds[row.type].sign * line.amount,
        })),
    }));
  }

  private async replay(
    executor: Executor,
    accountId: string,
    command: { idempotencyKey: string },
    requestHash: string,
    now: Date,
  ): Promise<string[] | null> {
    const [row] = await executor
      .select()
      .from(idempotencyKeys)
      .where(
        and(
          eq(idempotencyKeys.accountId, accountId),
          eq(idempotencyKeys.key, command.idempotencyKey),
        ),
      );
    if (!row || now.getTime() - row.createdAt.getTime() >= KEY_LIFETIME_MS) return null;
    if (row.requestHash !== requestHash) {
      throw new CashDeskRefusedError('idempotency_key_reused', 'the key came with another command');
    }
    return row.receiptIds;
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
async function nextNumber(
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

function cityYear(now: Date, timeZone: string): number {
  return Number(new Intl.DateTimeFormat('en-US', { timeZone, year: 'numeric' }).format(now));
}

// Keeps the key with its receipts, in the command's transaction, so a
// refused command keeps none. A key older than 24 hours is used again.
async function keepKey(
  tx: Tx,
  accountId: string,
  key: string,
  requestHash: string,
  receiptIds: string[],
  now: Date,
): Promise<void> {
  const kept = { requestHash, receiptIds, createdAt: now };
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
