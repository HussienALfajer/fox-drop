import { sql } from 'drizzle-orm';
import { noteModes, termsAudiences } from './lists.js';
import {
  boolean,
  check,
  integer,
  jsonb,
  pgSchema,
  primaryKey,
  text,
  timestamp,
  unique,
  uuid,
} from 'drizzle-orm/pg-core';

// Architecture §4.3: the content module owns the content schema.
export const content = pgSchema('content');

// One reason of a list of AP §9.13 (lists.ts names them). The code is stable:
// an order keeps it with a copy of the label as chosen (owner decision
// 2026-11-07). A reason is never deleted: removed from its list it is
// inactive, hidden from new choices and kept on the orders that have it.
export const reasons = content.table(
  'reasons',
  {
    id: uuid('id')
      .primaryKey()
      .default(sql`uuidv7()`),
    list: text('list').notNull(),
    code: text('code').notNull(),
    // The Arabic label the apps and the panel show.
    label: text('label').notNull(),
    // «نصوص الأسباب للزبون»: what the customer sees, in the lists that have it.
    customerText: text('customer_text'),
    // none, optional or required: whether the choice takes a note («أخرى»
    // with its text).
    note: text('note', { enum: noteModes }).notNull().default('none'),
    // A reason the code acts on (such as «مشكلة في مبلغ الاستلام», which
    // opens a pickup-dispute ticket) cannot be deactivated.
    fixed: boolean('fixed').notNull().default(false),
    active: boolean('active').notNull().default(true),
    position: integer('position').notNull(),
    updatedAt: timestamp('updated_at', { withTimezone: true }).notNull().defaultNow(),
  },
  (table) => [
    unique('reasons_list_code').on(table.list, table.code),
    check('reasons_code', sql`${table.code} ~ '^[a-z0-9_]{1,40}$'`),
    check('reasons_label', sql`char_length(${table.label}) BETWEEN 1 AND 100`),
    check(
      'reasons_customer_text',
      sql`${table.customerText} IS NULL OR char_length(${table.customerText}) BETWEEN 1 AND 300`,
    ),
    check('reasons_note', sql`${table.note} IN ('none', 'optional', 'required')`),
    check('reasons_fixed_active', sql`NOT ${table.fixed} OR ${table.active}`),
  ],
);

// The other texts of AP §9.13, one row per key: faq.customer, faq.captain,
// faq.merchant ([{ question, answer }]), captain_work_rules ({ body }) and
// contact ({ phone, whatsapp }). A key without a row has its default.
export const texts = content.table('texts', {
  key: text('key').primaryKey(),
  value: jsonb('value').notNull(),
  updatedAt: timestamp('updated_at', { withTimezone: true }).notNull().defaultNow(),
});

// AP §9.13 «الشروط والخصوصية»: one document per audience, versioned. A
// version is never changed: publishing writes the next one, which every
// account of the audience accepts again (append-only: no UPDATE for the
// application role). The first version of each is a draft written from the
// specs (owner decision 2026-11-08); it has no publisher.
export const termsVersions = content.table(
  'terms_versions',
  {
    id: uuid('id')
      .primaryKey()
      .default(sql`uuidv7()`),
    audience: text('audience', { enum: termsAudiences }).notNull(),
    version: integer('version').notNull(),
    body: text('body').notNull(),
    // The admin account; null for the seeded draft.
    publishedBy: uuid('published_by'),
    publishedAt: timestamp('published_at', { withTimezone: true }).notNull().defaultNow(),
  },
  (table) => [
    unique('terms_versions_audience_version').on(table.audience, table.version),
    check('terms_versions_audience', sql`${table.audience} IN ('customer', 'captain', 'merchant')`),
    check('terms_versions_version', sql`${table.version} >= 1`),
    check('terms_versions_body', sql`char_length(${table.body}) BETWEEN 1 AND 20000`),
  ],
);

// Which version an account accepted, and when (CU §15, CA §15, RA §4.10
// «Accept terms»). The account is the identity module's app account of the
// audience, kept as a plain id. Append-only.
export const termsAcceptances = content.table(
  'terms_acceptances',
  {
    audience: text('audience', { enum: termsAudiences }).notNull(),
    accountId: uuid('account_id').notNull(),
    version: integer('version').notNull(),
    acceptedAt: timestamp('accepted_at', { withTimezone: true }).notNull(),
  },
  (table) => [
    primaryKey({ columns: [table.audience, table.accountId, table.version] }),
    check(
      'terms_acceptances_audience',
      sql`${table.audience} IN ('customer', 'captain', 'merchant')`,
    ),
  ],
);
