import { sql } from 'drizzle-orm';
import {
  boolean,
  check,
  integer,
  jsonb,
  pgSchema,
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
    // «أخرى» with its text: the choice needs a note.
    needsText: boolean('needs_text').notNull().default(false),
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
