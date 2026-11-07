import { sql } from 'drizzle-orm';
import {
  bigint,
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

// The alert changes the panel hears on ops:city.{city_id} (architecture §6.2,
// E4): one row per alert raised, acknowledged or resolved, written in the
// transaction of the change and published by the worker's relay
// (alerts-relay.ts). The application role inserts rows and may change only
// published_at.
export const alertEventTypes = ['alert.raised', 'alert.acknowledged', 'alert.resolved'] as const;
export type AlertEventType = (typeof alertEventTypes)[number];

export const alertOutbox = notifications.table(
  'alert_outbox',
  {
    id: bigint('id', { mode: 'bigint' }).primaryKey().generatedAlwaysAsIdentity(),
    createdAt: timestamp('created_at', { withTimezone: true }).notNull(),
    // The alert's city; null for the whole platform, published to every city.
    cityId: uuid('city_id'),
    type: text('type', { enum: alertEventTypes }).notNull(),
    alertId: uuid('alert_id').notNull(),
    // Its typed, versioned body (schema 1: the alert, its code, severity and time).
    payload: jsonb('payload').notNull(),
    publishedAt: timestamp('published_at', { withTimezone: true }),
  },
  (table) => [
    index('alert_outbox_unpublished')
      .on(table.id)
      .where(sql`${table.publishedAt} IS NULL`),
    check(
      'alert_outbox_type',
      sql`${table.type} IN (${sql.raw(alertEventTypes.map((value) => `'${value}'`).join(', '))})`,
    ),
  ],
);
