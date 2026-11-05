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
  smallint,
  text,
  timestamp,
  uuid,
} from 'drizzle-orm/pg-core';

// Architecture §4.3: the fx module owns the fx schema (architecture §4.2:
// exchange rates and rounding per currency).
export const fx = pgSchema('fx');

// The supported currencies (AP §8.6): data, so a redenomination is a new row.
// Seeded by the migration that creates this table: TRY, USD and SYP.
export const currencies = fx.table(
  'currencies',
  {
    code: text('code').primaryKey(),
    nameAr: text('name_ar').notNull(),
    symbol: text('symbol').notNull(),
    // The minor unit: amounts are integer units of 10^-decimals (architecture §5.2).
    decimals: smallint('decimals').notNull(),
    status: text('status', { enum: ['active', 'inactive'] })
      .notNull()
      .default('active'),
    createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
  },
  (table) => [
    check('currencies_code_format', sql`${table.code} ~ '^[A-Z]{3}$'`),
    check('currencies_decimals_range', sql`${table.decimals} BETWEEN 0 AND 4`),
    check('currencies_status_values', sql`${table.status} IN ('active', 'inactive')`),
  ],
);

// A city's accepted currencies, the base among them (AP §8.6), with their
// display order and enabled flag.
export const cityCurrencies = fx.table(
  'city_currencies',
  {
    cityId: uuid('city_id').notNull(),
    currency: text('currency')
      .notNull()
      .references(() => currencies.code),
    displayOrder: integer('display_order').notNull(),
    enabled: boolean('enabled').notNull(),
    createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
    updatedAt: timestamp('updated_at', { withTimezone: true }).notNull().defaultNow(),
  },
  (table) => [primaryKey({ columns: [table.cityId, table.currency] })],
);

// The city's base currency (AP §8.6, D25), one of its accepted currencies.
// locked_at is set by the city's first order; from then on it never changes.
export const cityBases = fx.table(
  'city_bases',
  {
    cityId: uuid('city_id').primaryKey(),
    currency: text('currency').notNull(),
    lockedAt: timestamp('locked_at', { withTimezone: true }),
    updatedAt: timestamp('updated_at', { withTimezone: true }).notNull().defaultNow(),
  },
  (table) => [
    foreignKey({
      name: 'city_bases_city_currency',
      columns: [table.cityId, table.currency],
      foreignColumns: [cityCurrencies.cityId, cityCurrencies.currency],
    }),
  ],
);

// Every rate a city has had (AP §8.6): a change is a new version, never an
// update, so the application role may only add and read rows. The rate is
// base_currency units per one unit of currency, as an exact fraction.
export const rateVersions = fx.table(
  'rate_versions',
  {
    id: uuid('id')
      .primaryKey()
      .default(sql`uuidv7()`),
    cityId: uuid('city_id').notNull(),
    currency: text('currency').notNull(),
    // The base the rate is against: a rate set before a base change never
    // applies to the new base.
    baseCurrency: text('base_currency')
      .notNull()
      .references(() => currencies.code),
    rateNumerator: bigint('rate_numerator', { mode: 'bigint' }).notNull(),
    rateDenominator: bigint('rate_denominator', { mode: 'bigint' }).notNull(),
    // The admin account that set it.
    editorId: uuid('editor_id').notNull(),
    reason: text('reason'),
    createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
  },
  (table) => [
    foreignKey({
      name: 'rate_versions_city_currency',
      columns: [table.cityId, table.currency],
      foreignColumns: [cityCurrencies.cityId, cityCurrencies.currency],
    }),
    // UUIDv7 ids are in time order, so the newest version is the largest id.
    index('rate_versions_current').on(table.cityId, table.currency, table.baseCurrency, table.id),
    check(
      'rate_versions_rate_positive',
      sql`${table.rateNumerator} > 0 AND ${table.rateDenominator} > 0`,
    ),
    check('rate_versions_not_base', sql`${table.currency} <> ${table.baseCurrency}`),
  ],
);
