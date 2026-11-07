import { sql } from 'drizzle-orm';
import {
  check,
  index,
  jsonb,
  pgSchema,
  text,
  timestamp,
  uniqueIndex,
  uuid,
} from 'drizzle-orm/pg-core';
import { alertCodes, alertSeverities, alertSubjects } from './alert-rules.js';

// Architecture §4.3: the notifications module owns the notifications schema.
export const notifications = pgSchema('notifications');

// AP §7.3, §9.1.3: one alert, raised by its rule for a subject (an order, a
// captain, the code senders) and kept after it closes, as the alerts history.
// One alert per rule and subject is open at a time (a partial unique index).
// Closed means resolved: by itself once its condition cleared, or by its
// acknowledgment for a rule whose condition never clears (alert-rules.ts).
export const alerts = notifications.table(
  'alerts',
  {
    id: uuid('id')
      .primaryKey()
      .default(sql`uuidv7()`),
    // Null for an alert of the whole platform (the code senders), shown in
    // every city.
    cityId: uuid('city_id'),
    code: text('code', { enum: alertCodes }).notNull(),
    // The rule's severity when it was raised.
    severity: text('severity', { enum: alertSeverities }).notNull(),
    subjectType: text('subject_type', { enum: alertSubjects }).notNull(),
    subjectId: text('subject_id').notNull(),
    // What the panel shows beside the rule's label: the order's number, the
    // captain's name.
    details: jsonb('details').notNull().default({}),
    raisedAt: timestamp('raised_at', { withTimezone: true }).notNull(),
    acknowledgedAt: timestamp('acknowledged_at', { withTimezone: true }),
    // The admin account that took it («استلام»).
    acknowledgedBy: uuid('acknowledged_by'),
    resolvedAt: timestamp('resolved_at', { withTimezone: true }),
  },
  (table) => [
    uniqueIndex('alerts_open_one')
      .on(table.code, table.subjectType, table.subjectId)
      .where(sql`${table.resolvedAt} IS NULL`),
    index('alerts_subject').on(table.subjectType, table.subjectId),
    // The open list and the history of a city.
    index('alerts_open_city')
      .on(table.cityId)
      .where(sql`${table.resolvedAt} IS NULL`),
    index('alerts_closed_city')
      .on(table.cityId, table.resolvedAt.desc())
      .where(sql`${table.resolvedAt} IS NOT NULL`),
    check(
      'alerts_severity',
      sql`${table.severity} IN (${sql.raw(alertSeverities.map((value) => `'${value}'`).join(', '))})`,
    ),
    check(
      'alerts_subject_type',
      sql`${table.subjectType} IN (${sql.raw(alertSubjects.map((value) => `'${value}'`).join(', '))})`,
    ),
    check('alerts_code', sql`${table.code} ~ '^[a-z0-9_]{1,40}$'`),
    check(
      'alerts_acknowledged',
      sql`(${table.acknowledgedAt} IS NULL) = (${table.acknowledgedBy} IS NULL)`,
    ),
  ],
);
