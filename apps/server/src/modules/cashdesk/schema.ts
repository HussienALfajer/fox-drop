import { sql } from 'drizzle-orm';
import {
  bigint,
  boolean,
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
export const receiptTypes = [
  'captain_hand_in',
  'captain_reimbursement',
  // «تصفية الخميس» (AP §8.5.5, slice 2.18a): the earnings paid out, and a
  // negative balance collected under captain.negative_earnings_policy.
  'captain_payout',
  'captain_earnings_collection',
] as const;

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
      sql`${table.type} IN ('captain_hand_in', 'captain_reimbursement', 'captain_payout', 'captain_earnings_collection')`,
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
    // The settlement's statement (slice 2.18a), which names its receipts.
    statementId: uuid('statement_id'),
    createdAt: timestamp('created_at', { withTimezone: true }).notNull(),
  },
  (table) => [primaryKey({ columns: [table.accountId, table.key] })],
);

// AP §9.10.3 cross-currency settlement (slice 2.17b): a conversion of the
// captain's custody from one currency into another at the current rate,
// shown on the screen and kept on the receipt it came with. Never changed.
export const receiptConversions = cashdesk.table(
  'receipt_conversions',
  {
    receiptId: uuid('receipt_id').notNull(),
    fromCurrency: text('from_currency').notNull(),
    // Of the from currency, above zero, taken off its balance towards zero.
    fromAmount: bigint('from_amount', { mode: 'bigint' }).notNull(),
    toCurrency: text('to_currency').notNull(),
    // Of the to currency, rounded by its rule (AP §8.6), above zero.
    toAmount: bigint('to_amount', { mode: 'bigint' }).notNull(),
    // The custody.fx_convert journal, which keeps the rate versions.
    journalId: uuid('journal_id').notNull(),
  },
  (table) => [
    primaryKey({ columns: [table.receiptId, table.fromCurrency] }),
    foreignKey({
      columns: [table.receiptId],
      foreignColumns: [receipts.id],
      name: 'receipt_conversions_receipt',
    }),
    check(
      'receipt_conversions_amounts',
      sql`${table.fromAmount} > 0 AND ${table.toAmount} > 0 AND ${table.fromCurrency} <> ${table.toCurrency}`,
    ),
  ],
);

// «تصفية الخميس» (AP §8.5.5 step 4, CA §10.7; slice 2.18a): the weekly
// statement, a snapshot taken by each settlement of the captain's earnings
// since the previous one, in the base currency. Never changed.
export const statements = cashdesk.table(
  'statements',
  {
    id: uuid('id')
      .primaryKey()
      .default(sql`uuidv7()`),
    cityId: uuid('city_id').notNull(),
    captainId: uuid('captain_id').notNull(),
    captainName: text('captain_name').notNull(),
    sessionId: uuid('session_id').notNull(),
    adminAccountId: uuid('admin_account_id').notNull(),
    // The previous statement's time (null for the first), and this one's.
    periodFrom: timestamp('period_from', { withTimezone: true }),
    createdAt: timestamp('created_at', { withTimezone: true }).notNull(),
    // The ledger's own times the period's entries were read between: the
    // previous statement's ledger_to, and this transaction's.
    ledgerFrom: timestamp('ledger_from', { withTimezone: true }),
    ledgerTo: timestamp('ledger_to', { withTimezone: true }).notNull(),
    currency: text('currency').notNull(),
    // The orders paid in the period.
    orders: integer('orders').notNull(),
    // Pay by part (base, distance, waiting, peak); the base includes the
    // minimum pay's top-up and the pay of an order that was not delivered.
    basePay: bigint('base_pay', { mode: 'bigint' }).notNull(),
    distancePay: bigint('distance_pay', { mode: 'bigint' }).notNull(),
    waitingPay: bigint('waiting_pay', { mode: 'bigint' }).notNull(),
    peakBonus: bigint('peak_bonus', { mode: 'bigint' }).notNull(),
    bonuses: bigint('bonuses', { mode: 'bigint' }).notNull(),
    // Taken off: charges and deposit instalments.
    charges: bigint('charges', { mode: 'bigint' }).notNull(),
    instalments: bigint('instalments', { mode: 'bigint' }).notNull(),
    adjustments: bigint('adjustments', { mode: 'bigint' }).notNull(),
    // The balance the period started from (a negative one carried forward),
    // the balance before the payout, what was paid (its base value), what
    // was collected of a negative one, and what is carried to the next.
    carriedIn: bigint('carried_in', { mode: 'bigint' }).notNull(),
    balance: bigint('balance', { mode: 'bigint' }).notNull(),
    paid: bigint('paid', { mode: 'bigint' }).notNull(),
    // The cash paid, in the currency the cashier recorded.
    payoutCurrency: text('payout_currency'),
    payoutAmount: bigint('payout_amount', { mode: 'bigint' }),
    collected: bigint('collected', { mode: 'bigint' }).notNull(),
    carriedOut: bigint('carried_out', { mode: 'bigint' }).notNull(),
    // Another day than captain.payout_weekday: OWN, with a reason.
    offCycle: boolean('off_cycle').notNull(),
    reason: text('reason'),
    receiptIds: uuid('receipt_ids').array().notNull(),
  },
  (table) => [
    index('statements_captain_created').on(table.captainId, table.createdAt),
    foreignKey({
      columns: [table.sessionId],
      foreignColumns: [drawerSessions.id],
      name: 'statements_session_fk',
    }),
    check(
      'statements_money',
      sql`${table.orders} >= 0 AND ${table.basePay} + ${table.distancePay} >= 0 AND ${table.distancePay} >= 0 AND ${table.peakBonus} >= 0 AND ${table.paid} >= 0 AND ${table.collected} >= 0`,
    ),
    check(
      'statements_sums',
      sql`${table.balance} = ${table.carriedIn} + ${table.basePay} + ${table.distancePay} + ${table.waitingPay} + ${table.peakBonus} + ${table.bonuses} - ${table.charges} - ${table.instalments} + ${table.adjustments} AND ${table.carriedOut} = ${table.balance} - ${table.paid} + ${table.collected}`,
    ),
    check(
      'statements_payout',
      sql`(${table.paid} > 0) = (${table.payoutCurrency} IS NOT NULL) AND (${table.payoutCurrency} IS NULL) = (${table.payoutAmount} IS NULL) AND (${table.payoutAmount} IS NULL OR ${table.payoutAmount} > 0)`,
    ),
    check(
      'statements_reason',
      sql`${table.offCycle} = (${table.reason} IS NOT NULL) AND (${table.reason} IS NULL OR char_length(${table.reason}) BETWEEN 1 AND 500)`,
    ),
  ],
);
