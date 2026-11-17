import { Inject, Injectable } from '@nestjs/common';
import { and, asc, desc, eq, gt, gte, inArray, lt, or, type SQL, sql } from 'drizzle-orm';
import type { NodePgDatabase } from 'drizzle-orm/node-postgres';
import { alias } from 'drizzle-orm/pg-core';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import {
  type AccountPurpose,
  type ActorType,
  accountPurposes,
  type JournalRule,
  type JournalType,
  journalRules,
  partyPurposes,
  type SourceKind,
} from './catalogue.js';
import { accounts, entries, journals } from './schema.js';

// One entry on an account, from the party's view, with its journal's type
// and source: a line of the captain's «عهدتي» (CA §10.2).
export interface AccountEntry {
  journalId: string;
  type: JournalType;
  sourceKind: SourceKind | null;
  sourceId: string | null;
  currency: string;
  amount: bigint;
  createdAt: Date;
  // The journal's reason, when it has one (a charge, a bonus, a correction).
  reason: string | null;
}

// A money movement the ledger refuses: the caller's bug, never the user's.
export class LedgerRefusal extends Error {
  override readonly name = 'LedgerRefusal';
}

export interface LedgerAccount {
  cityId: string;
  purpose: AccountPurpose;
  // The captain, restaurant or drawer that owns the account; empty for the
  // other platform accounts, which are one per city and currency.
  ownerId: string | null;
  currency: string;
}

export interface LedgerEntry {
  accountId: string;
  // The account's currency, stated on every amount (architecture §5.2).
  currency: string;
  // Integer minor units from the platform's side: + a debit, − a credit.
  amount: bigint;
}

// Who posts (AP D27); the system without an id.
export interface LedgerActor {
  type: ActorType;
  id: string | null;
}

export interface PostJournal {
  cityId: string;
  type: JournalType;
  // The record the money belongs to; an order for every journal that touches
  // the order clearing account.
  source: { kind: SourceKind; id: string } | null;
  actor: LedgerActor;
  // Required for a manual correction and a manual bonus (AP §8.5.2, §9.10.7).
  reason?: string | null;
  entries: LedgerEntry[];
  // A journal whose entries span two currencies or more: the rate version of
  // each of them but the base (AP §8.6, §8.11), the order's from its
  // snapshot, so platform.fx_rounding reads in the base. None otherwise.
  rates?: JournalRate[] | undefined;
}

export interface JournalRate {
  currency: string;
  rateVersionId: string;
}

export interface Balance {
  currency: string;
  // In minor units, from the party's view as the specs state it (AP §8.5,
  // §8.7, §8.11).
  amount: bigint;
}

// A journal as posted (`journalLines`).
export interface PostedJournal {
  id: string;
  type: JournalType;
  reason: string | null;
  entries: { purpose: AccountPurpose; ownerId: string | null; currency: string; amount: bigint }[];
}

// A journal with its links (`journalRecords`): what «القيود التصحيحية» lists.
export interface JournalRecord extends PostedJournal {
  cityId: string;
  source: { kind: SourceKind; id: string } | null;
  actor: LedgerActor;
  // The journal this one reverses, and the one that reversed it.
  reversesJournalId: string | null;
  reversedById: string | null;
  createdAt: Date;
}

// A city's entries of a period summed (`cityTotals`), from the platform's
// side; `period` is the index of the period among the bounds.
export interface CityTotal {
  period: number;
  purpose: AccountPurpose;
  type: JournalType;
  currency: string;
  rates: JournalRate[] | null;
  amount: bigint;
}

// A city's entries on some accounts in a period (`sourceCosts`), summed by
// journal, from the platform's side.
export interface SourceCost {
  // The journal; a reversal's is the journal it reverses.
  journalId: string;
  purpose: AccountPurpose;
  type: JournalType;
  // The journal's reason; a reversal's is the reason of the journal reversed.
  reason: string | null;
  // The order the journal belongs to; null for any other source.
  orderId: string | null;
  currency: string;
  amount: bigint;
}

// An account's balance at a moment (`cityBalancesAt`), from the party's view.
export interface OwnerBalance {
  ownerId: string | null;
  currency: string;
  amount: bigint;
}

// The index of the period an entry falls in among ascending bounds. Queries
// group by it as their first column (`1`): its parameters make each writing
// of it another expression to PostgreSQL.
function periodOf(bounds: readonly Date[]) {
  const array = sql.join(
    bounds.map((bound) => sql`${bound.toISOString()}::timestamptz`),
    sql`, `,
  );
  return sql<number>`(width_bucket(${entries.createdAt}, ARRAY[${array}]) - 1)::int`;
}

// The database, or the open transaction of the change the money belongs to.
export type LedgerExecutor = Pick<NodePgDatabase, 'insert' | 'select'>;

const currencyCode = /^[A-Z]{3}$/;
const uuid = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

// The only way money moves (architecture §4.3 item 5, §5.6): balanced
// double-entry journals, never changed or removed, and balances computed from
// their entries.
@Injectable()
export class LedgerService {
  constructor(@Inject(DATABASE) private readonly database: Database) {}

  // Opens the account, or gives the one already open for the same city,
  // purpose, owner and currency.
  async openAccount(
    account: LedgerAccount,
    executor: LedgerExecutor = this.database.db,
  ): Promise<string> {
    if (accountPurposes[account.purpose].owned !== (account.ownerId !== null)) {
      throw new LedgerRefusal(
        accountPurposes[account.purpose].owned
          ? `a ${account.purpose} account needs its owner`
          : `a ${account.purpose} account has no owner`,
      );
    }
    if (!currencyCode.test(account.currency)) {
      throw new LedgerRefusal(`${account.currency} is not a currency code`);
    }
    const [created] = await executor
      .insert(accounts)
      .values(account)
      .onConflictDoNothing()
      .returning({ id: accounts.id });
    if (created) return created.id;
    const [existing] = await executor
      .select({ id: accounts.id })
      .from(accounts)
      .where(
        sql`${accounts.cityId} = ${account.cityId} AND ${accounts.purpose} = ${account.purpose}
            AND ${accounts.ownerId} IS NOT DISTINCT FROM ${account.ownerId}
            AND ${accounts.currency} = ${account.currency}`,
      );
    // Only in a snapshot older than a concurrent open, such as a REPEATABLE
    // READ transaction.
    if (!existing) throw new Error('the account was neither created nor found');
    return existing.id;
  }

  // Posts one journal inside the caller's transaction, so the money moves
  // exactly when the change it belongs to commits (E3). It is not idempotent:
  // the caller's state change is what stops a second post.
  async post(journal: PostJournal, executor: LedgerExecutor): Promise<string> {
    await this.check(journal, executor);
    return this.insert(journal, null, executor);
  }

  // Posts the journal that cancels another one, entry by entry, with a reason
  // (architecture §5.6, AP §9.10.7). A journal is reversed once.
  async reverse(
    journalId: string,
    reversal: { actor: LedgerActor; reason: string },
    executor: LedgerExecutor,
  ): Promise<string> {
    if (!reversal.reason.trim()) throw new LedgerRefusal('a reversal needs a reason');
    const [original] = await executor.select().from(journals).where(eq(journals.id, journalId));
    if (!original) throw new LedgerRefusal(`journal ${journalId} does not exist`);
    const [reversed] = await executor
      .select({ id: journals.id })
      .from(journals)
      .where(eq(journals.reversesJournalId, journalId));
    if (reversed) throw new LedgerRefusal(`journal ${journalId} is already reversed`);
    const lines = await executor
      .select({ accountId: entries.accountId, currency: entries.currency, amount: entries.amount })
      .from(entries)
      .where(eq(entries.journalId, journalId));
    const journal: PostJournal = {
      cityId: original.cityId,
      type: original.type as JournalType,
      source:
        original.sourceKind && original.sourceId
          ? { kind: original.sourceKind, id: original.sourceId }
          : null,
      actor: reversal.actor,
      reason: reversal.reason,
      entries: lines.map((line) => ({ ...line, amount: -line.amount })),
      // The reversal undoes the conversion at the rates it was made at.
      rates: (original.rates as JournalRate[] | null) ?? undefined,
    };
    this.checkActor(journal.actor);
    return this.insert(journal, journalId, executor);
  }

  // The journals as posted, in the order of the ids given: their type,
  // reason and entries with each account's purpose and owner, for a preview
  // of their reversal (AP §8.9 «Changing an outcome»).
  async journalLines(
    journalIds: readonly string[],
    executor: LedgerExecutor = this.database.db,
  ): Promise<PostedJournal[]> {
    if (journalIds.length === 0) return [];
    const ids = [...journalIds];
    const [heads, lines] = await Promise.all([
      executor
        .select({ id: journals.id, type: journals.type, reason: journals.reason })
        .from(journals)
        .where(inArray(journals.id, ids)),
      executor
        .select({
          journalId: entries.journalId,
          purpose: accounts.purpose,
          ownerId: accounts.ownerId,
          currency: entries.currency,
          amount: entries.amount,
        })
        .from(entries)
        .innerJoin(accounts, eq(accounts.id, entries.accountId))
        .where(inArray(entries.journalId, ids))
        .orderBy(entries.id),
    ]);
    return ids.map((id) => {
      const head = heads.find((each) => each.id === id);
      if (!head) throw new LedgerRefusal(`journal ${id} does not exist`);
      return {
        id,
        type: head.type as JournalType,
        reason: head.reason,
        entries: lines
          .filter((line) => line.journalId === id)
          .map((line) => ({
            purpose: line.purpose as AccountPurpose,
            ownerId: line.ownerId,
            currency: line.currency,
            amount: line.amount,
          })),
      };
    });
  }

  // The journals as posted with their city, source, actor, time and links:
  // the journal each reverses and the one that reversed it (AP §9.10.7
  // «القيود التصحيحية»). In the order of the ids given; one not found is
  // left out.
  async journalRecords(
    journalIds: readonly string[],
    executor: LedgerExecutor = this.database.db,
  ): Promise<JournalRecord[]> {
    if (journalIds.length === 0) return [];
    const ids = [...new Set(journalIds)];
    const reversal = alias(journals, 'reversal');
    const [heads, lines] = await Promise.all([
      executor
        .select({ head: journals, reversedById: reversal.id })
        .from(journals)
        .leftJoin(reversal, eq(reversal.reversesJournalId, journals.id))
        .where(inArray(journals.id, ids)),
      executor
        .select({
          journalId: entries.journalId,
          purpose: accounts.purpose,
          ownerId: accounts.ownerId,
          currency: entries.currency,
          amount: entries.amount,
        })
        .from(entries)
        .innerJoin(accounts, eq(accounts.id, entries.accountId))
        .where(inArray(entries.journalId, ids))
        .orderBy(entries.id),
    ]);
    const byId = new Map(heads.map((row) => [row.head.id, row]));
    return ids.flatMap((id) => {
      const row = byId.get(id);
      if (!row) return [];
      const { head } = row;
      return [
        {
          id,
          cityId: head.cityId,
          type: head.type as JournalType,
          source:
            head.sourceKind && head.sourceId
              ? { kind: head.sourceKind as SourceKind, id: head.sourceId }
              : null,
          actor: { type: head.actorType as ActorType, id: head.actorId },
          reason: head.reason,
          reversesJournalId: head.reversesJournalId,
          reversedById: row.reversedById,
          createdAt: head.createdAt,
          entries: lines
            .filter((line) => line.journalId === id)
            .map((line) => ({
              purpose: line.purpose as AccountPurpose,
              ownerId: line.ownerId,
              currency: line.currency,
              amount: line.amount,
            })),
        },
      ];
    });
  }

  // Who posted each journal (AP D27): «من قرّر» on a restaurant's exception
  // (RA §12.5). A journal not found is left out.
  async journalActors(journalIds: readonly string[]): Promise<Map<string, LedgerActor>> {
    if (journalIds.length === 0) return new Map();
    const rows = await this.database.db
      .select({ id: journals.id, type: journals.actorType, actorId: journals.actorId })
      .from(journals)
      .where(inArray(journals.id, [...new Set(journalIds)]));
    return new Map(
      rows.map((row) => [row.id, { type: row.type as ActorType, id: row.actorId }] as const),
    );
  }

  // The sum of the account's entries, shown from the party's view.
  async balance(accountId: string, executor: LedgerExecutor = this.database.db): Promise<Balance> {
    const [account] = await executor
      .select({ purpose: accounts.purpose, currency: accounts.currency })
      .from(accounts)
      .where(eq(accounts.id, accountId));
    if (!account) throw new LedgerRefusal(`account ${accountId} does not exist`);
    const [total] = await executor
      .select({ sum: sql<string>`coalesce(sum(${entries.amount}), 0)::text` })
      .from(entries)
      .where(eq(entries.accountId, accountId));
    const sign = accountPurposes[account.purpose as AccountPurpose].sign;
    return { currency: account.currency, amount: BigInt(total?.sum ?? '0') * sign };
  }

  // One owner's accounts of a purpose, one per currency, such as a captain's
  // custody (AP §8.5.1).
  async ownerAccounts(
    cityId: string,
    ownerId: string,
    purpose: AccountPurpose,
    executor: LedgerExecutor = this.database.db,
  ): Promise<{ id: string; currency: string }[]> {
    return executor
      .select({ id: accounts.id, currency: accounts.currency })
      .from(accounts)
      .where(
        and(
          eq(accounts.cityId, cityId),
          eq(accounts.purpose, purpose),
          eq(accounts.ownerId, ownerId),
        ),
      );
  }

  // The newest entries of some accounts of one purpose, newest first, at
  // most `limit`, from the party's view (CA §10.2: every entry of the
  // custody).
  async accountEntries(
    accountIds: readonly string[],
    purpose: AccountPurpose,
    limit: number,
    executor: LedgerExecutor = this.database.db,
  ): Promise<AccountEntry[]> {
    if (accountIds.length === 0) return [];
    const rows = await executor
      .select({
        journalId: entries.journalId,
        type: journals.type,
        sourceKind: journals.sourceKind,
        sourceId: journals.sourceId,
        reason: journals.reason,
        currency: entries.currency,
        amount: entries.amount,
        createdAt: entries.createdAt,
      })
      .from(entries)
      .innerJoin(journals, eq(journals.id, entries.journalId))
      .innerJoin(accounts, eq(accounts.id, entries.accountId))
      .where(and(inArray(entries.accountId, [...accountIds]), eq(accounts.purpose, purpose)))
      .orderBy(desc(entries.createdAt), desc(entries.id))
      .limit(limit);
    const sign = accountPurposes[purpose].sign;
    return rows.map((row) => ({
      ...row,
      type: row.type as JournalType,
      sourceKind: row.sourceKind as SourceKind | null,
      amount: row.amount * sign,
    }));
  }

  // The balance at a moment, plus the entries of the given types posted since,
  // from the party's view: the cash due from closed days is the custody at the
  // last cutoff plus the desk entries after it (AP §8.5.4). An entry's moment
  // is its transaction's.
  // The entries of some accounts of one purpose posted after a time (the
  // ledger's own: an entry's transaction time), oldest first, from the
  // party's view: a period of the captain's weekly statement (AP §8.5.5).
  async periodEntries(
    accountIds: readonly string[],
    purpose: AccountPurpose,
    after: Date | null,
    executor: LedgerExecutor = this.database.db,
  ): Promise<AccountEntry[]> {
    return this.entriesWhere(
      accountIds,
      purpose,
      after === null ? undefined : gt(entries.createdAt, after),
      executor,
    );
  }

  // The entries posted from `from` (included) to `to` (excluded), oldest
  // first, from the party's view: a restaurant's statement for any period
  // (AP §9.10.5, slice 2.19g), whose opening is balanceAt(from).
  async rangeEntries(
    accountIds: readonly string[],
    purpose: AccountPurpose,
    from: Date,
    to: Date,
    executor: LedgerExecutor = this.database.db,
  ): Promise<AccountEntry[]> {
    return this.entriesWhere(
      accountIds,
      purpose,
      and(gte(entries.createdAt, from), lt(entries.createdAt, to)),
      executor,
    );
  }

  // The city's entries of consecutive periods (`bounds`, ascending: period
  // i runs from bounds[i], included, to bounds[i + 1], excluded), summed per
  // period by account purpose, journal type, currency and the journal's rate
  // versions, from the platform's side (+ a debit), in one scan: «التقرير
  // اليومي» and the days it compares with (AP §9.10.1, slice 2.20d). Entries
  // of a journal that carries rates are summed per journal, so each converts
  // to the base at its own rates as the ledger booked it (AP §8.6).
  async cityTotals(
    cityId: string,
    bounds: readonly Date[],
    executor: LedgerExecutor = this.database.db,
  ): Promise<CityTotal[]> {
    if (bounds.length < 2) return [];
    const period = periodOf(bounds);
    const journal = sql`CASE WHEN ${journals.rates} IS NULL THEN NULL ELSE ${journals.id} END`;
    const rows = await executor
      .select({
        period,
        purpose: accounts.purpose,
        type: journals.type,
        currency: entries.currency,
        rates: journals.rates,
        sum: sql<string>`sum(${entries.amount})::text`,
      })
      .from(entries)
      .innerJoin(journals, eq(journals.id, entries.journalId))
      .innerJoin(accounts, eq(accounts.id, entries.accountId))
      .where(
        and(
          eq(journals.cityId, cityId),
          gte(entries.createdAt, bounds[0]!),
          lt(entries.createdAt, bounds.at(-1)!),
        ),
      )
      .groupBy(sql`1`, accounts.purpose, journals.type, entries.currency, journals.rates, journal);
    return rows
      .map((row) => ({
        period: row.period,
        purpose: row.purpose as AccountPurpose,
        type: row.type as JournalType,
        currency: row.currency,
        rates: (row.rates as JournalRate[] | null) ?? null,
        amount: BigInt(row.sum),
      }))
      .filter((row) => row.amount !== 0n);
  }

  // The same periods' entries of one purpose and type, summed per period by
  // the journal's source, from the platform's side: the orders of each
  // day's order pay.
  async sourceTotals(
    cityId: string,
    purpose: AccountPurpose,
    type: JournalType,
    bounds: readonly Date[],
    executor: LedgerExecutor = this.database.db,
  ): Promise<Map<string, bigint>[]> {
    const totals = bounds.slice(1).map(() => new Map<string, bigint>());
    if (bounds.length < 2) return totals;
    const period = periodOf(bounds);
    const rows = await executor
      .select({
        period,
        sourceId: journals.sourceId,
        sum: sql<string>`sum(${entries.amount})::text`,
      })
      .from(entries)
      .innerJoin(journals, eq(journals.id, entries.journalId))
      .innerJoin(accounts, eq(accounts.id, entries.accountId))
      .where(
        and(
          eq(journals.cityId, cityId),
          eq(accounts.purpose, purpose),
          eq(journals.type, type),
          gte(entries.createdAt, bounds[0]!),
          lt(entries.createdAt, bounds.at(-1)!),
        ),
      )
      .groupBy(sql`1`, journals.sourceId);
    for (const row of rows) {
      if (row.sourceId !== null) totals[row.period]!.set(row.sourceId, BigInt(row.sum));
    }
    return totals;
  }

  // AP §9.10.6 (slice 2.22d): the city's entries on some platform accounts
  // from `from` (included) to `to` (excluded), summed by journal, account
  // purpose and currency, from the platform's side. A reversal counts with
  // the journal it reverses, under its id and reason, so the two cancel when
  // both fall in the period and the reversal alone shows what it took back;
  // `orderId` is null for a journal whose source is no order.
  async sourceCosts(
    cityId: string,
    purposes: readonly AccountPurpose[],
    from: Date,
    to: Date,
    executor: LedgerExecutor = this.database.db,
  ): Promise<SourceCost[]> {
    if (purposes.length === 0) return [];
    const reversed = alias(journals, 'reversed');
    const reason = sql<
      string | null
    >`CASE WHEN ${journals.reversesJournalId} IS NULL THEN ${journals.reason} ELSE ${reversed.reason} END`;
    const journalId = sql<string>`coalesce(${journals.reversesJournalId}, ${journals.id})`;
    const orderId = sql<
      string | null
    >`CASE WHEN ${journals.sourceKind} = 'order' THEN ${journals.sourceId} END`;
    const rows = await executor
      .select({
        journalId,
        purpose: accounts.purpose,
        type: journals.type,
        reason,
        orderId,
        currency: entries.currency,
        sum: sql<string>`sum(${entries.amount})::text`,
      })
      .from(entries)
      .innerJoin(journals, eq(journals.id, entries.journalId))
      .innerJoin(accounts, eq(accounts.id, entries.accountId))
      .leftJoin(reversed, eq(reversed.id, journals.reversesJournalId))
      .where(
        and(
          eq(journals.cityId, cityId),
          inArray(accounts.purpose, [...purposes]),
          gte(entries.createdAt, from),
          lt(entries.createdAt, to),
        ),
      )
      .groupBy(sql`1`, accounts.purpose, journals.type, sql`4`, sql`5`, entries.currency);
    return rows
      .map((row) => ({
        journalId: row.journalId,
        purpose: row.purpose as AccountPurpose,
        type: row.type as JournalType,
        reason: row.reason,
        orderId: row.orderId,
        currency: row.currency,
        amount: BigInt(row.sum),
      }))
      .filter((row) => row.amount !== 0n);
  }

  // Every account of one purpose in the city at each of some moments (the
  // entries before it), by owner and currency, from the party's view, in
  // one scan; accounts at zero are left out: the open custody and
  // restaurant balances at each business day's cutoff (AP §9.10.1). It sums
  // the city's whole history of the purpose: no balance is cached yet.
  async cityBalancesAt(
    cityId: string,
    purpose: AccountPurpose,
    moments: readonly Date[],
    executor: LedgerExecutor = this.database.db,
  ): Promise<OwnerBalance[][]> {
    if (moments.length === 0) return [];
    const latest = moments.reduce((a, b) => (a > b ? a : b));
    const sums = moments.map(
      (at) =>
        sql<string>`coalesce(sum(${entries.amount}) FILTER (WHERE ${entries.createdAt} < ${at.toISOString()}::timestamptz), 0)::text`,
    );
    const rows = await executor
      .select({
        ownerId: accounts.ownerId,
        currency: accounts.currency,
        sums: sql<string[]>`ARRAY[${sql.join(sums, sql`, `)}]`,
      })
      .from(entries)
      .innerJoin(accounts, eq(accounts.id, entries.accountId))
      .where(
        and(
          eq(accounts.cityId, cityId),
          eq(accounts.purpose, purpose),
          lt(entries.createdAt, latest),
        ),
      )
      .groupBy(accounts.ownerId, accounts.currency);
    const sign = accountPurposes[purpose].sign;
    return moments.map((_, index) =>
      rows
        .map((row) => ({
          ownerId: row.ownerId,
          currency: row.currency,
          amount: BigInt(row.sums[index]!) * sign,
        }))
        .filter((row) => row.amount !== 0n),
    );
  }

  private async entriesWhere(
    accountIds: readonly string[],
    purpose: AccountPurpose,
    when: SQL | undefined,
    executor: LedgerExecutor,
  ): Promise<AccountEntry[]> {
    if (accountIds.length === 0) return [];
    const rows = await executor
      .select({
        journalId: entries.journalId,
        type: journals.type,
        sourceKind: journals.sourceKind,
        sourceId: journals.sourceId,
        reason: journals.reason,
        currency: entries.currency,
        amount: entries.amount,
        createdAt: entries.createdAt,
      })
      .from(entries)
      .innerJoin(journals, eq(journals.id, entries.journalId))
      .innerJoin(accounts, eq(accounts.id, entries.accountId))
      .where(and(inArray(entries.accountId, [...accountIds]), eq(accounts.purpose, purpose), when))
      .orderBy(asc(entries.createdAt), asc(entries.id));
    const sign = accountPurposes[purpose].sign;
    return rows.map((row) => ({
      ...row,
      type: row.type as JournalType,
      sourceKind: row.sourceKind as SourceKind | null,
      amount: row.amount * sign,
    }));
  }

  async balanceAt(
    accountId: string,
    at: Date,
    plusSince: readonly JournalType[],
    executor: LedgerExecutor = this.database.db,
  ): Promise<Balance> {
    const [account] = await executor
      .select({ purpose: accounts.purpose, currency: accounts.currency })
      .from(accounts)
      .where(eq(accounts.id, accountId));
    if (!account) throw new LedgerRefusal(`account ${accountId} does not exist`);
    const since =
      plusSince.length === 0 ? sql`false` : inArray(journals.type, [...plusSince] as string[]);
    const [total] = await executor
      .select({ sum: sql<string>`coalesce(sum(${entries.amount}), 0)::text` })
      .from(entries)
      .innerJoin(journals, eq(journals.id, entries.journalId))
      .where(
        and(
          eq(entries.accountId, accountId),
          or(lt(entries.createdAt, at), and(gte(entries.createdAt, at), since)),
        ),
      );
    const sign = accountPurposes[account.purpose as AccountPurpose].sign;
    return { currency: account.currency, amount: BigInt(total?.sum ?? '0') * sign };
  }

  private checkActor(actor: LedgerActor): void {
    if ((actor.type === 'system') !== (actor.id === null)) {
      throw new LedgerRefusal(
        actor.type === 'system' ? 'the system posts without an id' : `${actor.type} needs an id`,
      );
    }
    if (actor.id !== null && !uuid.test(actor.id)) {
      throw new LedgerRefusal(`${actor.id} is not an actor id`);
    }
  }

  private async check(journal: PostJournal, executor: LedgerExecutor): Promise<void> {
    if (journal.entries.length < 2) {
      throw new LedgerRefusal('a journal needs two entries or more');
    }
    for (const entry of journal.entries) {
      if (typeof entry.amount !== 'bigint') {
        throw new LedgerRefusal('an amount is a bigint of minor units');
      }
      if (entry.amount === 0n) throw new LedgerRefusal('an entry of zero');
    }
    this.checkActor(journal.actor);
    this.checkRates(journal);

    const ids = [...new Set(journal.entries.map((entry) => entry.accountId))];
    const found = await executor.select().from(accounts).where(inArray(accounts.id, ids));
    const byId = new Map(found.map((account) => [account.id, account]));
    const rule: JournalRule = journalRules[journal.type];
    const allowed: readonly AccountPurpose[] = [rule.account, ...rule.counters];
    const reached = new Set<AccountPurpose>();
    const owners = new Set<string>();
    const sums = new Map<string, bigint>();

    for (const entry of journal.entries) {
      const account = byId.get(entry.accountId);
      if (!account) throw new LedgerRefusal(`account ${entry.accountId} does not exist`);
      if (account.cityId !== journal.cityId) {
        throw new LedgerRefusal(`account ${account.id} is in another city than the journal`);
      }
      if (account.currency !== entry.currency) {
        throw new LedgerRefusal(
          `an entry in currency ${entry.currency} on an account in ${account.currency}`,
        );
      }
      const purpose = account.purpose as AccountPurpose;
      if (!allowed.includes(purpose)) {
        throw new LedgerRefusal(`${purpose} cannot take a ${journal.type} entry`);
      }
      reached.add(purpose);
      if (partyPurposes.includes(purpose) && account.ownerId) owners.add(account.ownerId);
      sums.set(entry.currency, (sums.get(entry.currency) ?? 0n) + entry.amount);
    }

    for (const purpose of [rule.account, ...(rule.requires ?? [])]) {
      if (!reached.has(purpose)) {
        throw new LedgerRefusal(`a ${journal.type} journal needs an entry on ${purpose}`);
      }
    }
    const crossCurrency = sums.size > 1;
    if (rule.crossCurrency && !crossCurrency) {
      throw new LedgerRefusal(`a ${journal.type} journal converts between two currencies`);
    }
    // Exchange takes a party's other side only in a conversion.
    if (rule.account !== 'platform.fx_rounding' && reached.has('platform.fx_rounding')) {
      if (!crossCurrency) {
        throw new LedgerRefusal('platform.fx_rounding takes a side only between two currencies');
      }
    }
    // One journal moves the money of one captain or one restaurant.
    if (owners.size > 1) {
      throw new LedgerRefusal('a journal reaches the accounts of one owner only');
    }
    if (reached.has('platform.order_clearing') && journal.source?.kind !== 'order') {
      throw new LedgerRefusal('only an order journal touches the order clearing account');
    }
    if (rule.reason && !journal.reason?.trim()) {
      throw new LedgerRefusal(`a ${journal.type} journal needs a reason`);
    }
    for (const [currency, sum] of sums) {
      if (sum !== 0n) {
        throw new LedgerRefusal(`the journal does not balance to zero in currency ${currency}`);
      }
    }
  }

  // Every currency of a journal that spans several but one (the base) names
  // its rate version, once; a journal in one currency names none.
  private checkRates(journal: PostJournal): void {
    const currencies = new Set(journal.entries.map((entry) => entry.currency));
    const rates = journal.rates ?? [];
    if (currencies.size < 2) {
      if (rates.length > 0) throw new LedgerRefusal('a journal in one currency takes no rate');
      return;
    }
    const named = new Set(rates.map((rate) => rate.currency));
    if (
      named.size !== rates.length ||
      rates.some((rate) => !currencies.has(rate.currency) || !uuid.test(rate.rateVersionId))
    ) {
      throw new LedgerRefusal('a rate names a currency of the journal, once, by its version id');
    }
    if (currencies.size - named.size > 1) {
      throw new LedgerRefusal('a journal across currencies names the rate of each but the base');
    }
  }

  private async insert(
    journal: PostJournal,
    reversesJournalId: string | null,
    executor: LedgerExecutor,
  ): Promise<string> {
    const [posted] = await executor
      .insert(journals)
      .values({
        cityId: journal.cityId,
        type: journal.type,
        sourceKind: journal.source?.kind ?? null,
        sourceId: journal.source?.id ?? null,
        actorType: journal.actor.type,
        actorId: journal.actor.id,
        reason: journal.reason ?? null,
        reversesJournalId,
        rates: journal.rates && journal.rates.length > 0 ? journal.rates : null,
      })
      .returning({ id: journals.id });
    if (!posted) throw new Error('the journal was not inserted');
    await executor.insert(entries).values(
      journal.entries.map((entry) => ({
        journalId: posted.id,
        cityId: journal.cityId,
        accountId: entry.accountId,
        currency: entry.currency,
        amount: entry.amount,
      })),
    );
    return posted.id;
  }
}
