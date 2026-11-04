import { sql } from 'drizzle-orm';
import { check, pgSchema, text, timestamp, uuid } from 'drizzle-orm/pg-core';

// Architecture §4.3: the geo module owns the geo schema.
export const geo = pgSchema('geo');

// AP §9.12.1. V1 has one city, Azaz, seeded by the migration that creates
// this table (AP §1.3 item 6). The base currency, the business-day cutoff,
// the office and the hours join with the slices that use them.
export const cities = geo.table(
  'cities',
  {
    id: uuid('id')
      .primaryKey()
      .default(sql`uuidv7()`),
    // Used in receipt numbers such as AZ-2026-000123 (AP §4.8).
    code: text('code').notNull().unique(),
    name: text('name').notNull(),
    timeZone: text('time_zone').notNull().default('Asia/Damascus'),
    status: text('status', { enum: ['active', 'inactive'] })
      .notNull()
      .default('active'),
    createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
  },
  (table) => [
    check('cities_code_format', sql`${table.code} ~ '^[A-Z]{2,3}$'`),
    check('cities_status_values', sql`${table.status} IN ('active', 'inactive')`),
  ],
);
