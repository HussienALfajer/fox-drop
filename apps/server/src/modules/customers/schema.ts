import { sql } from 'drizzle-orm';
import {
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
