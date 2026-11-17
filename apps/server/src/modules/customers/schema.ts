import { sql } from 'drizzle-orm';
import {
  bigint,
  boolean,
  check,
  customType,
  date,
  index,
  pgSchema,
  text,
  timestamp,
  uniqueIndex,
  uuid,
} from 'drizzle-orm/pg-core';

// Architecture §4.2–4.3: the customers module owns the customers' profiles
// and addresses. The account belongs to identity, cities and zones to geo:
// their ids are plain columns here.
export const customers = pgSchema('customers');

// A PostGIS point in WGS 84, written and read through SQL only.
const point = customType<{ data: string; driverData: string }>({
  dataType: () => 'geometry(Point,4326)',
});

export const genders = ['male', 'female'] as const;

// CU §5.3 «أكمل بياناتك»: one row per customer account, written when the
// customer completes their details. A customer belongs to no city.
export const profiles = customers.table(
  'profiles',
  {
    // The identity module's customer_accounts row.
    accountId: uuid('account_id').primaryKey(),
    firstName: text('first_name').notNull(),
    lastName: text('last_name'),
    gender: text('gender', { enum: genders }).notNull(),
    birthday: date('birthday', { mode: 'string' }),
    // When «أوافق على الشروط وسياسة الخصوصية» was ticked. The terms
    // versions (AP §9.13) join with the content slice.
    termsAcceptedAt: timestamp('terms_accepted_at', { withTimezone: true }).notNull(),
    createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
    updatedAt: timestamp('updated_at', { withTimezone: true }).notNull().defaultNow(),
  },
  (table) => [check('profiles_gender_values', sql`${table.gender} IN ('male', 'female')`)],
);

export const addressLabels = ['home', 'work', 'other'] as const;

// CU §7.3: a saved address. Never deleted: deleted_at hides it. An order
// keeps its own snapshot (Q6), so editing one changes no order.
export const addresses = customers.table(
  'addresses',
  {
    id: uuid('id')
      .primaryKey()
      .default(sql`uuidv7()`),
    accountId: uuid('account_id').notNull(),
    cityId: uuid('city_id').notNull(),
    location: point('location').notNull(),
    label: text('label', { enum: addressLabels }).notNull(),
    // «آخر» with a custom name.
    customLabel: text('custom_label'),
    street: text('street').notNull(),
    floor: text('floor'),
    landmark: text('landmark').notNull(),
    // Another mobile than the account's, encrypted (architecture §15.3);
    // null is the account's own number.
    contactPhoneEncrypted: text('contact_phone_encrypted'),
    recipientName: text('recipient_name'),
    directions: text('directions'),
    isDefault: boolean('is_default').notNull().default(false),
    deletedAt: timestamp('deleted_at', { withTimezone: true }),
    createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
    updatedAt: timestamp('updated_at', { withTimezone: true }).notNull().defaultNow(),
  },
  (table) => [
    index('addresses_account').on(table.accountId),
    uniqueIndex('addresses_one_default')
      .on(table.accountId)
      .where(sql`${table.isDefault} AND ${table.deletedAt} IS NULL`),
    check('addresses_label_values', sql`${table.label} IN ('home', 'work', 'other')`),
    check(
      'addresses_custom_label',
      sql`(${table.label} = 'other') = (${table.customLabel} IS NOT NULL)`,
    ),
    // Q5: a recipient's name with another contact number, and only then.
    check(
      'addresses_recipient',
      sql`(${table.contactPhoneEncrypted} IS NULL) = (${table.recipientName} IS NULL)`,
    ),
  ],
);

// docs/domain/08 (slice 2.8b): a late cancellation counted against the
// customer: operations cancelled an order after acceptance with the customer
// responsible (owner decision 2026-11-09). One per order; never changed.
export const lateCancelStrikes = customers.table(
  'late_cancel_strikes',
  {
    id: uuid('id')
      .primaryKey()
      .default(sql`uuidv7()`),
    // The identity module's customer_accounts row.
    customerAccountId: uuid('customer_account_id').notNull(),
    // The ordering module's order, and the order's city, whose settings
    // count the strikes.
    orderId: uuid('order_id').notNull(),
    cityId: uuid('city_id').notNull(),
    at: timestamp('at', { withTimezone: true }).notNull(),
  },
  (table) => [
    uniqueIndex('late_cancel_strikes_order').on(table.orderId),
    index('late_cancel_strikes_account_at').on(table.customerAccountId, table.at),
  ],
);

// docs/domain/08: customer.late_cancel_strikes within
// customer.late_cancel_window_days stop the account's ordering «موقوف حتى
// مراجعة الدعم» until support ends the stop (slice 2.25). One open per
// account; the application role may change only the end columns.
export const reviewStops = customers.table(
  'review_stops',
  {
    id: uuid('id')
      .primaryKey()
      .default(sql`uuidv7()`),
    customerAccountId: uuid('customer_account_id').notNull(),
    startedAt: timestamp('started_at', { withTimezone: true }).notNull(),
    // The order whose strike reached the threshold.
    orderId: uuid('order_id').notNull(),
    endedAt: timestamp('ended_at', { withTimezone: true }),
    // The admin account that ended it.
    endedBy: uuid('ended_by'),
    // The admin's required reason (AP §9.8, slice 2.25b); null on a stop
    // ended before it.
    endNote: text('end_note'),
  },
  (table) => [
    uniqueIndex('review_stops_one_open')
      .on(table.customerAccountId)
      .where(sql`${table.endedAt} IS NULL`),
    check('review_stops_end', sql`(${table.endedAt} IS NULL) = (${table.endedBy} IS NULL)`),
    check(
      'review_stops_end_note',
      sql`${table.endNote} IS NULL OR (${table.endedAt} IS NOT NULL AND length(${table.endNote}) BETWEEN 1 AND 500)`,
    ),
  ],
);

// AP §9.8 «مسح المخالفات» (slice 2.25b; owner decision 2026-11-17): the
// late-cancellation strikes count again from the latest clear; nothing is
// deleted. Never changed.
export const strikeClears = customers.table(
  'strike_clears',
  {
    id: uuid('id')
      .primaryKey()
      .default(sql`uuidv7()`),
    customerAccountId: uuid('customer_account_id').notNull(),
    at: timestamp('at', { withTimezone: true }).notNull(),
    // The admin account and its required reason.
    by: uuid('by').notNull(),
    note: text('note').notNull(),
  },
  (table) => [
    index('strike_clears_account_at').on(table.customerAccountId, table.at),
    check('strike_clears_note', sql`length(${table.note}) BETWEEN 1 AND 500`),
  ],
);

// AP §9.8, §8.8 «توثيق» and «إزالة الثقة» (slice 2.25b; owner decisions
// 2026-11-17): the latest mark overrides D23's count (`trustBasis`). Never
// changed.
export const trustMarks = customers.table(
  'trust_marks',
  {
    id: uuid('id')
      .primaryKey()
      .default(sql`uuidv7()`),
    customerAccountId: uuid('customer_account_id').notNull(),
    trusted: boolean('trusted').notNull(),
    at: timestamp('at', { withTimezone: true }).notNull(),
    by: uuid('by').notNull(),
    note: text('note').notNull(),
  },
  (table) => [
    index('trust_marks_account_at').on(table.customerAccountId, table.at),
    check('trust_marks_note', sql`length(${table.note}) BETWEEN 1 AND 500`),
  ],
);

// AP §9.8 «حظر» (slice 2.25a): for a duration («حتى {التاريخ}»), until
// further notice, or until dues of a set amount are paid. The last posts a
// dues.charge of the amount in the city's base (owner decision 2026-11-17),
// so the dues balance is that block: its row is the record of the charge,
// never ends and never stops ordering by itself. The other two stop
// ordering while open and, for a duration, until `until`. One open per
// account (`blocks_one_open`); the application role may change only the end
// columns: «فك الحظر» names its admin and note, and a block whose time
// passed is closed at its `until` with no admin when the next one starts.
export const blockKinds = ['until', 'indefinite', 'dues'] as const;

export const blocks = customers.table(
  'blocks',
  {
    id: uuid('id')
      .primaryKey()
      .default(sql`uuidv7()`),
    customerAccountId: uuid('customer_account_id').notNull(),
    kind: text('kind', { enum: blockKinds }).notNull(),
    // A code of Content's customer_block list (AP Appendix B) with its label
    // and customer text as chosen (CU Appendix C).
    reason: text('reason').notNull(),
    reasonLabel: text('reason_label').notNull(),
    customerText: text('customer_text').notNull(),
    // The admin's required reason (AP §9.8: «Reason: Required»), internal.
    note: text('note').notNull(),
    until: timestamp('until', { withTimezone: true }),
    // The dues block: the city of the dues account, the amount in its base
    // and the dues.charge journal.
    cityId: uuid('city_id'),
    duesAmount: bigint('dues_amount', { mode: 'bigint' }),
    duesCurrency: text('dues_currency'),
    duesJournalId: uuid('dues_journal_id'),
    startedAt: timestamp('started_at', { withTimezone: true }).notNull(),
    // The admin account that blocked.
    startedBy: uuid('started_by').notNull(),
    endedAt: timestamp('ended_at', { withTimezone: true }),
    endedBy: uuid('ended_by'),
    endNote: text('end_note'),
    // The command's Idempotency-Key and request hash, kept for good (a
    // dues block must never charge twice).
    idempotencyKey: text('idempotency_key').notNull(),
    requestHash: text('request_hash').notNull(),
  },
  (table) => [
    uniqueIndex('blocks_key').on(table.startedBy, table.idempotencyKey),
    index('blocks_account').on(table.customerAccountId, table.startedAt),
    uniqueIndex('blocks_one_open')
      .on(table.customerAccountId)
      .where(sql`${table.endedAt} IS NULL AND ${table.kind} <> 'dues'`),
    check('blocks_kind_values', sql`${table.kind} IN ('until', 'indefinite', 'dues')`),
    check('blocks_until', sql`(${table.kind} = 'until') = (${table.until} IS NOT NULL)`),
    check(
      'blocks_dues',
      sql`CASE WHEN ${table.kind} = 'dues' THEN ${table.cityId} IS NOT NULL AND ${table.duesAmount} > 0 AND ${table.duesCurrency} IS NOT NULL AND ${table.duesJournalId} IS NOT NULL AND ${table.endedAt} IS NULL ELSE ${table.cityId} IS NULL AND ${table.duesAmount} IS NULL AND ${table.duesCurrency} IS NULL AND ${table.duesJournalId} IS NULL END`,
    ),
    check(
      'blocks_end',
      sql`(${table.endedAt} IS NOT NULL OR (${table.endedBy} IS NULL AND ${table.endNote} IS NULL)) AND (${table.endedBy} IS NULL) = (${table.endNote} IS NULL)`,
    ),
    check('blocks_note', sql`length(${table.note}) BETWEEN 1 AND 500`),
  ],
);

// AP §9.8 «ملاحظات داخلية» (slice 2.25b): an admin's note on the customer,
// such as «يفضل الاتصال قبل الوصول». Never changed; the command's
// Idempotency-Key is kept with it, so a retry adds no second note.
export const notes = customers.table(
  'notes',
  {
    id: uuid('id')
      .primaryKey()
      .default(sql`uuidv7()`),
    customerAccountId: uuid('customer_account_id').notNull(),
    body: text('body').notNull(),
    // The admin account that wrote it.
    authorId: uuid('author_id').notNull(),
    createdAt: timestamp('created_at', { withTimezone: true }).notNull(),
    idempotencyKey: text('idempotency_key').notNull(),
    requestHash: text('request_hash').notNull(),
  },
  (table) => [
    uniqueIndex('notes_key').on(table.authorId, table.idempotencyKey),
    index('notes_account').on(table.customerAccountId, table.createdAt),
    check('notes_body', sql`length(${table.body}) BETWEEN 1 AND 500`),
  ],
);

// AP §9.8 «حساب تجريبي للإدارة» (slice 2.25b; OWN): the latest row says
// whether the account sees the restaurants in test mode (AP §9.6.3) and may
// order from them. Never changed.
export const testAccountFlags = customers.table(
  'test_account_flags',
  {
    id: uuid('id')
      .primaryKey()
      .default(sql`uuidv7()`),
    customerAccountId: uuid('customer_account_id').notNull(),
    flagged: boolean('flagged').notNull(),
    at: timestamp('at', { withTimezone: true }).notNull(),
    by: uuid('by').notNull(),
  },
  (table) => [index('test_account_flags_account_at').on(table.customerAccountId, table.at)],
);
