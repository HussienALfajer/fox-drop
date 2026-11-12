import { sql } from 'drizzle-orm';
import {
  bigint,
  check,
  foreignKey,
  index,
  integer,
  pgSchema,
  primaryKey,
  text,
  timestamp,
  uniqueIndex,
  uuid,
} from 'drizzle-orm/pg-core';

// Architecture §4.2–4.3: the cashdesk module owns the drawer sessions and
// the receipts. Cities, captains and admin accounts belong to other modules:
// their ids are plain columns here. The money itself is the ledger's: each
// session is the owner of its own `platform.cash` accounts.
export const cashdesk = pgSchema('cashdesk');

// AP §9.10.3: a user holds one office session at a time; the field session
// of a restaurant visit joins with slice 2.19.
export const sessionKinds = ['office'] as const;

// «جلسة الصندوق» (AP §9.10.3): opened by a desk user with a float counted per
// currency, closed with the counted cash. Every desk transaction belongs to
// the open session of the user who records it.
export const drawerSessions = cashdesk.table(
  'drawer_sessions',
  {
    id: uuid('id')
      .primaryKey()
      .default(sql`uuidv7()`),
    cityId: uuid('city_id').notNull(),
    // The admin account at the drawer.
    adminAccountId: uuid('admin_account_id').notNull(),
    kind: text('kind', { enum: sessionKinds }).notNull(),
    openedAt: timestamp('opened_at', { withTimezone: true }).notNull(),
    closedAt: timestamp('closed_at', { withTimezone: true }),
    // «إقفال الصندوق»: the note on any variance (AP §9.10.3; owner decision
    // 2026-11-12: the variance is kept here only, never in the ledger).
    closeNote: text('close_note'),
  },
  (table) => [
    uniqueIndex('drawer_sessions_one_open')
      .on(table.adminAccountId, table.kind)
      .where(sql`${table.closedAt} IS NULL`),
    index('drawer_sessions_city_opened').on(table.cityId, table.openedAt),
    check('drawer_sessions_kind_values', sql`${table.kind} IN ('office')`),
    check(
      'drawer_sessions_note_when_closed',
      sql`${table.closeNote} IS NULL OR ${table.closedAt} IS NOT NULL`,
    ),
  ],
);

// One currency of a session: the float counted at the opening, and at the
// close the cash the system expected and the cash counted (the variance is
// counted − expected).
export const drawerSessionCurrencies = cashdesk.table(
  'drawer_session_currencies',
  {
    sessionId: uuid('session_id').notNull(),
    currency: text('currency').notNull(),
    openingFloat: bigint('opening_float', { mode: 'bigint' }).notNull(),
    expected: bigint('expected', { mode: 'bigint' }),
    counted: bigint('counted', { mode: 'bigint' }),
  },
  (table) => [
    primaryKey({ columns: [table.sessionId, table.currency] }),
    foreignKey({
      columns: [table.sessionId],
      foreignColumns: [drawerSessions.id],
      name: 'drawer_session_currencies_session',
    }),
    check('drawer_session_currencies_float', sql`${table.openingFloat} >= 0`),
    check(
      'drawer_session_currencies_counted',
      sql`${table.counted} IS NULL OR ${table.counted} >= 0`,
    ),
    check(
      'drawer_session_currencies_closed',
      sql`(${table.expected} IS NULL) = (${table.counted} IS NULL)`,
    ),
  ],
);

// AP §4.8: one sequence per city per year for every receipt, taken by
// updating this row in the receipt's transaction, so a receipt that rolls
// back gives its number back and the numbers have no gap (a sequence would
// leave one).
export const receiptCounters = cashdesk.table(
  'receipt_counters',
  {
    cityId: uuid('city_id').notNull(),
    year: integer('year').notNull(),
    lastNumber: integer('last_number').notNull(),
  },
  (table) => [
    primaryKey({ columns: [table.cityId, table.year] }),
    check('receipt_counters_last', sql`${table.lastNumber} > 0`),
  ],
);

// AP §9.10.3, CA §14 #19: the type printed on the receipt. A captain's
// hand-in «تسليم نقد» (custody.hand_in) or the desk paying a negative
// custody back «صرف للكابتن» (custody.reimburse).
export const receiptTypes = ['captain_hand_in', 'captain_reimbursement'] as const;

// A desk receipt (AP §9.10.3), never changed: the application role may only
// insert. Its money is the journals of its lines.
export const receipts = cashdesk.table(
  'receipts',
  {
    id: uuid('id')
      .primaryKey()
      .default(sql`uuidv7()`),
    cityId: uuid('city_id').notNull(),
    year: integer('year').notNull(),
    sequence: integer('sequence').notNull(),
    // {CITY}-{YYYY}-{000001}, such as AZ-2026-000123.
    number: text('number').notNull(),
    type: text('type', { enum: receiptTypes }).notNull(),
    sessionId: uuid('session_id').notNull(),
    // The cashier: the session's user.
    adminAccountId: uuid('admin_account_id').notNull(),
    captainId: uuid('captain_id').notNull(),
    // As the receipt was issued.
    captainName: text('captain_name').notNull(),
    createdAt: timestamp('created_at', { withTimezone: true }).notNull(),
  },
  (table) => [
    uniqueIndex('receipts_city_year_sequence').on(table.cityId, table.year, table.sequence),
    uniqueIndex('receipts_number').on(table.number),
    index('receipts_session').on(table.sessionId),
    index('receipts_captain_created').on(table.captainId, table.createdAt),
    foreignKey({
      columns: [table.sessionId],
      foreignColumns: [drawerSessions.id],
      name: 'receipts_session_fk',
    }),
    check('receipts_sequence', sql`${table.sequence} > 0`),
    check(
      'receipts_type_values',
      sql`${table.type} IN ('captain_hand_in', 'captain_reimbursement')`,
    ),
  ],
);

// One currency of a receipt: the custody the desk expected (from the
// captain's side, + to hand in, − owed to them), the cash that changed hands
// (above zero) and the journal that moved it.
export const receiptLines = cashdesk.table(
  'receipt_lines',
  {
    receiptId: uuid('receipt_id').notNull(),
    currency: text('currency').notNull(),
    expected: bigint('expected', { mode: 'bigint' }).notNull(),
    amount: bigint('amount', { mode: 'bigint' }).notNull(),
    journalId: uuid('journal_id').notNull(),
  },
  (table) => [
    primaryKey({ columns: [table.receiptId, table.currency] }),
    foreignKey({
      columns: [table.receiptId],
      foreignColumns: [receipts.id],
      name: 'receipt_lines_receipt',
    }),
    check('receipt_lines_amount', sql`${table.amount} > 0`),
  ],
);

// Architecture §5.3: a desk command's Idempotency-Key, kept with the
// receipts it issued for 24 hours. A repeat within them answers those.
export const idempotencyKeys = cashdesk.table(
  'idempotency_keys',
  {
    accountId: uuid('account_id').notNull(),
    key: text('key').notNull(),
    // A hash of the command, so a key sent again with another is refused.
    requestHash: text('request_hash').notNull(),
    receiptIds: uuid('receipt_ids').array().notNull(),
    createdAt: timestamp('created_at', { withTimezone: true }).notNull(),
  },
  (table) => [primaryKey({ columns: [table.accountId, table.key] })],
);
