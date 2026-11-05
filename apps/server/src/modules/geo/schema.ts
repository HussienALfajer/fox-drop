import { sql } from 'drizzle-orm';
import {
  bigint,
  boolean,
  check,
  customType,
  index,
  integer,
  pgSchema,
  primaryKey,
  smallint,
  text,
  timestamp,
  unique,
  uuid,
} from 'drizzle-orm/pg-core';

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

// A PostGIS polygon in WGS 84. Written and read through SQL (GeoService),
// never as a JavaScript value.
const polygon = customType<{ data: string; driverData: string }>({
  dataType: () => 'geometry(Polygon,4326)',
});

// AP §9.12.2: a service zone is a neighbourhood's polygon, active or not.
export const zones = geo.table(
  'zones',
  {
    id: uuid('id')
      .primaryKey()
      .default(sql`uuidv7()`),
    cityId: uuid('city_id')
      .notNull()
      .references(() => cities.id),
    name: text('name').notNull(),
    area: polygon('area').notNull(),
    active: boolean('active').notNull(),
    createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
    updatedAt: timestamp('updated_at', { withTimezone: true }).notNull().defaultNow(),
  },
  (table) => [
    unique('zones_city_name').on(table.cityId, table.name),
    index('zones_area').using('gist', table.area),
    check('zones_area_valid', sql`ST_IsValid(${table.area})`),
  ],
);

// AP §9.12.3: a city's delivery fee rule. A change adds a version, the newest
// in effect, so a quote can name the rule it priced with.
export const feeRules = geo.table(
  'fee_rules',
  {
    id: uuid('id')
      .primaryKey()
      .default(sql`uuidv7()`),
    cityId: uuid('city_id')
      .notNull()
      .references(() => cities.id),
    kind: text('kind', { enum: ['flat', 'distance_bands'] }).notNull(),
    // The city's base currency when the rule was set (AP §8.6).
    currency: text('currency').notNull(),
    flatFee: bigint('flat_fee', { mode: 'bigint' }),
    minimumFee: bigint('minimum_fee', { mode: 'bigint' }),
    freeDeliveryFrom: bigint('free_delivery_from', { mode: 'bigint' }),
    editorId: uuid('editor_id'),
    reason: text('reason'),
    createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
  },
  (table) => [
    index('fee_rules_current').on(table.cityId, table.id.desc()),
    check('fee_rules_kind_values', sql`${table.kind} IN ('flat', 'distance_bands')`),
    check(
      'fee_rules_flat_fee',
      sql`(${table.kind} = 'flat') = (${table.flatFee} IS NOT NULL) AND ${table.flatFee} >= 0`,
    ),
    check('fee_rules_minimum_fee', sql`${table.minimumFee} >= 0`),
    check('fee_rules_free_delivery_from', sql`${table.freeDeliveryFrom} > 0`),
  ],
);

// The bands of a distance-band rule, in order; the last has no upper edge.
export const feeBands = geo.table(
  'fee_bands',
  {
    ruleId: uuid('rule_id')
      .notNull()
      .references(() => feeRules.id),
    position: smallint('position').notNull(),
    upToMetres: integer('up_to_metres'),
    fee: bigint('fee', { mode: 'bigint' }).notNull(),
  },
  (table) => [
    primaryKey({ columns: [table.ruleId, table.position] }),
    check('fee_bands_up_to_positive', sql`${table.upToMetres} > 0`),
    check('fee_bands_fee', sql`${table.fee} >= 0`),
  ],
);
