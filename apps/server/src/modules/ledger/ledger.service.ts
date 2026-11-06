import { Inject, Injectable } from '@nestjs/common';
import { and, eq, gte, inArray, lt, or, sql } from 'drizzle-orm';
import type { NodePgDatabase } from 'drizzle-orm/node-postgres';
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
}

export interface Balance {
  currency: string;
  // In minor units, from the party's view as the specs state it (AP §8.5,
  // §8.7, §8.11).
  amount: bigint;
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
    };
    this.checkActor(journal.actor);
    return this.insert(journal, journalId, executor);
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
    ownerId: string,
    purpose: AccountPurpose,
    executor: LedgerExecutor = this.database.db,
  ): Promise<{ id: string; currency: string }[]> {
    return executor
      .select({ id: accounts.id, currency: accounts.currency })
      .from(accounts)
      .where(and(eq(accounts.ownerId, ownerId), eq(accounts.purpose, purpose)));
  }

  // The balance at a moment, plus the entries of the given types posted since,
  // from the party's view: the cash due from closed days is the custody at the
  // last cutoff plus the desk entries after it (AP §8.5.4). An entry's moment
  // is its transaction's.
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
