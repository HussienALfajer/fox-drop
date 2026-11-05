import { sql } from 'drizzle-orm';
import {
  bigint,
  check,
  foreignKey,
  index,
  pgSchema,
  primaryKey,
  text,
  timestamp,
  unique,
  uuid,
} from 'drizzle-orm/pg-core';
import {
  accountPurposeNames,
  actorTypes,
  journalTypeNames,
  journalTypesWithReason,
  ownedPurposes,
  sourceKinds,
} from './catalogue.js';

// Architecture §4.3: the ledger module owns the ledger schema. Every table is
// append-only (architecture §5.6): the application role may only add and read
// rows, and a correction is a reversing journal.
export const ledger = pgSchema('ledger');

const inList = (values: readonly string[]) =>
  sql.raw(values.map((value) => `'${value}'`).join(', '));

// One account per city, purpose, owner and currency (AP §8.5, §8.7, §8.11).
export const accounts = ledger.table(
  'accounts',
  {
    id: uuid('id')
      .primaryKey()
      .default(sql`uuidv7()`),
    cityId: uuid('city_id').notNull(),
    // The party and what the account holds, such as captain.custody.
    purpose: text('purpose', { enum: accountPurposeNames as [string, ...string[]] }).notNull(),
    // The captain, the restaurant or the drawer that owns the account, kept
    // as a plain id of the owning module's record (architecture §4.3).
    ownerId: uuid('owner_id'),
    currency: text('currency').notNull(),
    createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
  },
  (table) => [
    unique('accounts_city_purpose_owner_currency')
      .on(table.cityId, table.purpose, table.ownerId, table.currency)
      .nullsNotDistinct(),
    // The target of the entries' key, so an entry's city and currency are its account's.
    unique('accounts_id_city_currency').on(table.id, table.cityId, table.currency),
    check('accounts_purpose_values', sql`${table.purpose} IN (${inList(accountPurposeNames)})`),
    check(
      'accounts_owner_present',
      sql`(${table.purpose} IN (${inList(ownedPurposes)})) = (${table.ownerId} IS NOT NULL)`,
    ),
    check('accounts_currency_code', sql`${table.currency} ~ '^[A-Z]{3}$'`),
  ],
);

// One money movement (architecture §5.6): its type, who posted it, why, and
// the record it comes from.
export const journals = ledger.table(
  'journals',
  {
    id: uuid('id')
      .primaryKey()
      .default(sql`uuidv7()`),
    cityId: uuid('city_id').notNull(),
    type: text('type', { enum: journalTypeNames as [string, ...string[]] }).notNull(),
    // The record the money belongs to, such as an order.
    sourceKind: text('source_kind', { enum: sourceKinds }),
    sourceId: uuid('source_id'),
    // Who posted it (AP D27). The system posts without an id.
    actorType: text('actor_type', { enum: actorTypes }).notNull(),
    actorId: uuid('actor_id'),
    reason: text('reason'),
    // The journal this one reverses (AP §9.10.7).
    reversesJournalId: uuid('reverses_journal_id'),
    createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
  },
  (table) => [
    unique('journals_id_city').on(table.id, table.cityId),
    // A reversal is in its journal's city, and a journal is reversed once.
    foreignKey({
      name: 'journals_reverses_journal',
      columns: [table.reversesJournalId, table.cityId],
      foreignColumns: [table.id, table.cityId],
    }),
    unique('journals_reversed_once').on(table.reversesJournalId),
    index('journals_by_source').on(table.sourceKind, table.sourceId),
    check('journals_type_values', sql`${table.type} IN (${inList(journalTypeNames)})`),
    check(
      'journals_source_kind_values',
      sql`${table.sourceKind} IS NULL OR ${table.sourceKind} IN (${inList(sourceKinds)})`,
    ),
    check(
      'journals_source_complete',
      sql`(${table.sourceKind} IS NULL) = (${table.sourceId} IS NULL)`,
    ),
    check('journals_actor_type_values', sql`${table.actorType} IN (${inList(actorTypes)})`),
    check(
      'journals_actor_id_present',
      sql`(${table.actorType} = 'system') = (${table.actorId} IS NULL)`,
    ),
    // A manual correction, a manual bonus and a reversal always say why
    // (AP §1.3 item 5, §8.5.2, §9.10.7).
    check(
      'journals_reason_required',
      sql`(${table.type} NOT IN (${inList(journalTypesWithReason)}) AND ${table.reversesJournalId} IS NULL) OR coalesce(btrim(${table.reason}), '') <> ''`,
    ),
  ],
);

// The lines of a journal, in integer minor units of the account's currency
// (architecture §5.2), from the platform's side: + a debit, − a credit.
// Partitioned by month on created_at (architecture §5.4); the migration
// declares the partitioning, which Drizzle cannot.
export const entries = ledger.table(
  'entries',
  {
    id: uuid('id')
      .notNull()
      .default(sql`uuidv7()`),
    journalId: uuid('journal_id').notNull(),
    cityId: uuid('city_id').notNull(),
    accountId: uuid('account_id').notNull(),
    currency: text('currency').notNull(),
    amount: bigint('amount', { mode: 'bigint' }).notNull(),
    createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
  },
  (table) => [
    // A partitioned table's key includes its partition column.
    primaryKey({ columns: [table.id, table.createdAt] }),
    foreignKey({
      name: 'entries_journal',
      columns: [table.journalId, table.cityId],
      foreignColumns: [journals.id, journals.cityId],
    }),
    foreignKey({
      name: 'entries_account',
      columns: [table.accountId, table.cityId, table.currency],
      foreignColumns: [accounts.id, accounts.cityId, accounts.currency],
    }),
    index('entries_by_account').on(table.accountId),
    index('entries_by_journal').on(table.journalId),
    check('entries_amount_not_zero', sql`${table.amount} <> 0`),
  ],
);
