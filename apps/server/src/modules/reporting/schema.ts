import { sql } from 'drizzle-orm';
import { check, jsonb, pgSchema, text, timestamp, uniqueIndex, uuid } from 'drizzle-orm/pg-core';

// Architecture §4.3: the reporting module owns the reporting schema.
export const reporting = pgSchema('reporting');

// What an export holds (architecture §5.9). Slice 2.19g: a restaurant's
// statement for a period (AP §9.10.5); slice 2.20d: the daily report
// (AP §9.10.1); slice 2.22d: the cost report (AP §9.10.6); slice 2.40:
// «سجل الطلبات» (AP §9.5).
export const exportKinds = [
  'restaurant_statement',
  'daily_report',
  'cost_report',
  'order_history',
] as const;
export type ExportKind = (typeof exportKinds)[number];

// pending: the worker has not written it yet; ready: in private-docs until
// expires_at; expired: removed from the storage after its 24 hours.
export const exportStatuses = ['pending', 'ready', 'expired'] as const;
export type ExportStatus = (typeof exportStatuses)[number];

// One Excel export (architecture §5.9): asked by an admin, written by a
// worker job to private-docs, kept 24 hours and downloaded through a short
// signed URL. The row stays once the file is gone, as the audit log's target.
export const exports = reporting.table(
  'exports',
  {
    id: uuid('id')
      .primaryKey()
      .default(sql`uuidv7()`),
    cityId: uuid('city_id').notNull(),
    kind: text('kind', { enum: exportKinds }).notNull(),
    // What was asked, by kind: { restaurantId, from, to } for a statement,
    // { cityId, day } for a daily report, { cityId, from, to } for a cost
    // report, the filters for the order history.
    params: jsonb('params').notNull(),
    // The admin account (identity's id, a plain column) that asked for it.
    requestedBy: uuid('requested_by').notNull(),
    // The request's Idempotency-Key (architecture §5.3), per admin account.
    idempotencyKey: text('idempotency_key').notNull(),
    // The name the browser saves it under.
    fileName: text('file_name').notNull(),
    status: text('status', { enum: exportStatuses }).notNull().default('pending'),
    // Its key in private-docs, once written.
    objectKey: text('object_key'),
    createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
    readyAt: timestamp('ready_at', { withTimezone: true }),
    expiresAt: timestamp('expires_at', { withTimezone: true }),
  },
  (table) => [
    uniqueIndex('exports_requester_key').on(table.requestedBy, table.idempotencyKey),
    check(
      'exports_kind_values',
      sql`${table.kind} IN ('restaurant_statement', 'daily_report', 'cost_report', 'order_history')`,
    ),
    check('exports_status_values', sql`${table.status} IN ('pending', 'ready', 'expired')`),
    check(
      'exports_written',
      sql`(${table.status} = 'pending') = (${table.objectKey} IS NULL AND ${table.readyAt} IS NULL AND ${table.expiresAt} IS NULL)`,
    ),
  ],
);
