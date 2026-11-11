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
  real,
  text,
  timestamp,
  uniqueIndex,
  uuid,
} from 'drizzle-orm/pg-core';
import { vehicles } from '../settings/index.js';
import { captainStatuses, lastOrderBy } from './availability.js';

// Architecture §4.2–4.3: the captains module owns the captain record, its
// availability and the pay table. Cities belong to geo, the captain's sign-in
// to identity and the money to the ledger: their ids are plain columns here.
export const captains = pgSchema('captains');

// A PostGIS point in WGS 84, written and read through SQL only.
const point = customType<{ data: string; driverData: string }>({
  dataType: () => 'geometry(Point,4326)',
});

const createdAt = () => timestamp('created_at', { withTimezone: true }).notNull().defaultNow();
const vehicleValues = sql.raw(vehicles.map((vehicle) => `'${vehicle}'`).join(', '));

// Why an online period ended (CA §7.5–7.6).
// offers_expired: C3, after unanswered offers (AP §9.7.6).
// handed_over: K17, the captain handed their order to another (slice 2.12b).
// last_order: the captain's last-order mode, after the order (CA §7.3).
// forced: operations' «فصل من الاتصال», at once or after the order (CA §7.6).
export const onlineEndReasons = [
  'captain',
  'suspended',
  'terminated',
  'offers_expired',
  'handed_over',
  'last_order',
  'forced',
] as const;
const endReasonValues = sql.raw(onlineEndReasons.map((reason) => `'${reason}'`).join(', '));
const lastOrderValues = sql.raw(lastOrderBy.map((by) => `'${by}'`).join(', '));

// AP §9.7.1, §9.7.5, D10: an activated captain with its vehicle and cash
// limit.
export const captainRecords = captains.table(
  'captains',
  {
    id: uuid('id')
      .primaryKey()
      .default(sql`uuidv7()`),
    cityId: uuid('city_id').notNull(),
    // The full three-part name (AP §9.7.1).
    name: text('name').notNull(),
    vehicle: text('vehicle', { enum: vehicles }).notNull(),
    // Motor vehicles only.
    plateNumber: text('plate_number'),
    status: text('status', { enum: captainStatuses }).notNull().default('active'),
    // The latest suspension's reason, shown in the app, and its end; no end
    // means until further notice (AP §9.7.5).
    suspensionReason: text('suspension_reason'),
    suspendedUntil: timestamp('suspended_until', { withTimezone: true }),
    // D10, AP §8.5.3: in the city's base currency, required before
    // activation.
    custodyLimit: bigint('custody_limit', { mode: 'bigint' }).notNull(),
    custodyLimitCurrency: text('custody_limit_currency').notNull(),
    createdAt: createdAt(),
    updatedAt: timestamp('updated_at', { withTimezone: true }).notNull().defaultNow(),
  },
  (table) => [
    index('captains_city').on(table.cityId),
    check('captains_vehicle_values', sql`${table.vehicle} IN (${vehicleValues})`),
    check('captains_status_values', sql`${table.status} IN ('active', 'suspended', 'terminated')`),
    check(
      'captains_plate_number',
      sql`${table.vehicle} NOT IN ('motorbike', 'car') OR ${table.plateNumber} IS NOT NULL`,
    ),
    check(
      'captains_suspension',
      sql`(${table.status} = 'suspended') = (${table.suspensionReason} IS NOT NULL)
          AND (${table.suspendedUntil} IS NULL OR ${table.status} = 'suspended')`,
    ),
    check('captains_custody_limit', sql`${table.custodyLimit} > 0`),
  ],
);

// CA §7: a stretch of time online. The open one (no end) is the captain
// online now; one at most per captain.
export const onlinePeriods = captains.table(
  'online_periods',
  {
    id: uuid('id')
      .primaryKey()
      .default(sql`uuidv7()`),
    captainId: uuid('captain_id')
      .notNull()
      .references(() => captainRecords.id),
    startedAt: timestamp('started_at', { withTimezone: true }).notNull(),
    appVersion: text('app_version'),
    endedAt: timestamp('ended_at', { withTimezone: true }),
    endReason: text('end_reason', { enum: onlineEndReasons }),
    // CA §7.3, §7.6, K18: last-order mode, since when and who asked; a force
    // offline keeps operations' reason, shown to the captain.
    lastOrderBy: text('last_order_by', { enum: lastOrderBy }),
    lastOrderAt: timestamp('last_order_at', { withTimezone: true }),
    lastOrderReason: text('last_order_reason'),
  },
  (table) => [
    uniqueIndex('online_periods_one_open')
      .on(table.captainId)
      .where(sql`${table.endedAt} IS NULL`),
    index('online_periods_captain').on(table.captainId, table.startedAt.desc()),
    check(
      'online_periods_end',
      sql`(${table.endedAt} IS NULL) = (${table.endReason} IS NULL)
          AND (${table.endedAt} IS NULL OR ${table.endedAt} >= ${table.startedAt})`,
    ),
    check('online_periods_end_reason_values', sql`${table.endReason} IN (${endReasonValues})`),
    check(
      'online_periods_last_order',
      sql`(${table.lastOrderBy} IS NULL) = (${table.lastOrderAt} IS NULL)
          AND (coalesce(${table.lastOrderBy}, '') = 'forced') = (${table.lastOrderReason} IS NOT NULL)
          AND (${table.lastOrderBy} IS NULL OR ${table.lastOrderBy} IN (${lastOrderValues}))`,
    ),
  ],
);

// AP §9.12.5: a version of a city's pay table, never changed, in effect from
// its start; the latest start reached is in force.
export const payTables = captains.table(
  'pay_tables',
  {
    id: uuid('id')
      .primaryKey()
      .default(sql`uuidv7()`),
    cityId: uuid('city_id').notNull(),
    // The city's base currency when the table was set (AP §8.6).
    currency: text('currency').notNull(),
    effectiveFrom: timestamp('effective_from', { withTimezone: true }).notNull(),
    editorType: text('editor_type', { enum: ['admin', 'system'] }).notNull(),
    editorId: uuid('editor_id'),
    reason: text('reason'),
    createdAt: createdAt(),
  },
  (table) => [
    index('pay_tables_current').on(table.cityId, table.effectiveFrom.desc(), table.id.desc()),
    check('pay_tables_editor_type_values', sql`${table.editorType} IN ('admin', 'system')`),
    check('pay_tables_editor', sql`(${table.editorType} = 'system') = (${table.editorId} IS NULL)`),
  ],
);

// One vehicle's row of a pay table version (pay.ts); every vehicle has one.
export const payRates = captains.table(
  'pay_rates',
  {
    tableId: uuid('table_id')
      .notNull()
      .references(() => payTables.id),
    vehicle: text('vehicle', { enum: vehicles }).notNull(),
    basePay: bigint('base_pay', { mode: 'bigint' }).notNull(),
    includedMetres: integer('included_metres').notNull(),
    perExtraKm: bigint('per_extra_km', { mode: 'bigint' }).notNull(),
    waitingPerMinute: bigint('waiting_per_minute', { mode: 'bigint' }).notNull(),
    minimumPay: bigint('minimum_pay', { mode: 'bigint' }).notNull(),
  },
  (table) => [
    primaryKey({ columns: [table.tableId, table.vehicle] }),
    check('pay_rates_vehicle_values', sql`${table.vehicle} IN (${vehicleValues})`),
    check(
      'pay_rates_amounts',
      sql`${table.basePay} >= 0 AND ${table.perExtraKm} >= 0 AND ${table.waitingPerMinute} >= 0
          AND ${table.minimumPay} >= 0 AND ${table.includedMetres} >= 0`,
    ),
  ],
);

// CA §4.3, architecture §7.3: the points a captain's app sent while online,
// for routes and disputes; the live position is in Valkey. Partitioned by
// the month the point was recorded, append-only. A point sent again (a retry)
// is the same row.
export const locations = captains.table(
  'locations',
  {
    captainId: uuid('captain_id').notNull(),
    cityId: uuid('city_id').notNull(),
    // On the phone, which queues the points recorded without a signal.
    recordedAt: timestamp('recorded_at', { withTimezone: true }).notNull(),
    receivedAt: timestamp('received_at', { withTimezone: true }).notNull(),
    location: point('location').notNull(),
    accuracyMetres: real('accuracy_metres').notNull(),
    // A mock-location app on Android or isSimulatedBySoftware on iOS (CA §4.3).
    simulated: boolean('simulated').notNull(),
  },
  (table) => [
    primaryKey({ columns: [table.captainId, table.recordedAt] }),
    check('locations_accuracy', sql`${table.accuracyMetres} >= 0`),
  ],
);
