import { sql } from 'drizzle-orm';
import {
  bigint,
  boolean,
  check,
  index,
  integer,
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

// Architecture §8.1: the push token of one signed-in app installation, one row
// per app session (the session's id is its key), registered by the app at
// every start and whenever Firebase renews the token. A push reaches the
// tokens of the open sessions of its recipients: a customer's account, a
// restaurant's devices (RA §16 «All», or its owners' devices), a captain's.
// Ended when Firebase answers the token is no longer registered, or when
// another session registers the same token (a sign-in again on the device).
export const pushDeviceEndReasons = ['token_invalid', 'token_moved'] as const;
export const pushPlatforms = ['android'] as const;

export const pushDevices = notifications.table(
  'push_devices',
  {
    sessionId: uuid('session_id').primaryKey(),
    party: text('party', { enum: ['customer', 'merchant', 'captain'] }).notNull(),
    accountId: uuid('account_id').notNull(),
    // A restaurant user's restaurant and role when it registered (RA §5.1).
    restaurantId: uuid('restaurant_id'),
    merchantRole: text('merchant_role', { enum: ['owner', 'cashier'] }),
    captainId: uuid('captain_id'),
    platform: text('platform', { enum: pushPlatforms }).notNull(),
    token: text('token').notNull(),
    registeredAt: timestamp('registered_at', { withTimezone: true }).notNull(),
    endedAt: timestamp('ended_at', { withTimezone: true }),
    endReason: text('end_reason', { enum: pushDeviceEndReasons }),
  },
  (table) => [
    uniqueIndex('push_devices_token_live')
      .on(table.token)
      .where(sql`${table.endedAt} IS NULL`),
    index('push_devices_account')
      .on(table.party, table.accountId)
      .where(sql`${table.endedAt} IS NULL`),
    index('push_devices_restaurant')
      .on(table.restaurantId)
      .where(sql`${table.endedAt} IS NULL`),
    index('push_devices_captain')
      .on(table.captainId)
      .where(sql`${table.endedAt} IS NULL`),
    check('push_devices_party', sql`${table.party} IN ('customer', 'merchant', 'captain')`),
    check('push_devices_platform', sql`${table.platform} IN ('android')`),
    check(
      'push_devices_merchant',
      sql`(${table.party} = 'merchant') = (${table.restaurantId} IS NOT NULL AND ${table.merchantRole} IS NOT NULL)`,
    ),
    check(
      'push_devices_captain',
      sql`(${table.party} = 'captain') = (${table.captainId} IS NOT NULL)`,
    ),
    check(
      'push_devices_ended',
      sql`(${table.endedAt} IS NULL) = (${table.endReason} IS NULL) AND (${table.endReason} IS NULL OR ${table.endReason} IN ('token_invalid', 'token_moved'))`,
    ),
    check('push_devices_token', sql`length(${table.token}) BETWEEN 1 AND 4096`),
  ],
);

// Architecture §8.1: one push to send, queued in the transaction of what it
// tells (E4) and sent by the worker's push relay with retries. Its source
// names what queued it (such as `outbox:<id>:customer`), so queuing it again
// adds nothing. A customer's rows are also «الإشعارات» (CU §13, §14: every
// push is stored), read for 30 days; the other parties' are the send log.
export const pushMessages = notifications.table(
  'push_messages',
  {
    id: uuid('id')
      .primaryKey()
      .default(sql`uuidv7()`),
    createdAt: timestamp('created_at', { withTimezone: true }).notNull(),
    source: text('source').notNull().unique(),
    party: text('party', { enum: ['customer', 'merchant', 'captain'] }).notNull(),
    accountId: uuid('account_id'),
    restaurantId: uuid('restaurant_id'),
    // RA §16 «Owners»: the restaurant's owner devices only.
    ownersOnly: boolean('owners_only').notNull().default(false),
    captainId: uuid('captain_id'),
    templateKey: text('template_key').notNull(),
    body: text('body').notNull(),
    level: text('level').notNull(),
    priority: text('priority', { enum: ['high', 'normal'] }).notNull(),
    // What the app opens on a tap, as strings (FCM's data).
    data: jsonb('data').$type<Record<string, string>>().notNull(),
    // Not sent after this: a push about an order's step is no use later.
    expiresAt: timestamp('expires_at', { withTimezone: true }).notNull(),
    attempts: integer('attempts').notNull().default(0),
    nextAttemptAt: timestamp('next_attempt_at', { withTimezone: true }).notNull(),
    sentAt: timestamp('sent_at', { withTimezone: true }),
    // How many devices it reached.
    devices: integer('devices'),
    gaveUpAt: timestamp('gave_up_at', { withTimezone: true }),
  },
  (table) => [
    index('push_messages_pending')
      .on(table.nextAttemptAt)
      .where(sql`${table.sentAt} IS NULL AND ${table.gaveUpAt} IS NULL`),
    // «إعادة إرسال الإشعار» finds an order's latest push to a party.
    index('push_messages_order').on(sql`(${table.data}->>'orderId')`, table.createdAt.desc()),
    index('push_messages_customer')
      .on(table.accountId, table.createdAt.desc())
      .where(sql`${table.party} = 'customer'`),
    check('push_messages_party', sql`${table.party} IN ('customer', 'merchant', 'captain')`),
    check(
      'push_messages_recipient',
      sql`(${table.party} = 'customer') = (${table.accountId} IS NOT NULL) AND (${table.party} = 'merchant') = (${table.restaurantId} IS NOT NULL) AND (${table.party} = 'captain') = (${table.captainId} IS NOT NULL) AND (NOT ${table.ownersOnly} OR ${table.party} = 'merchant')`,
    ),
    check('push_messages_priority', sql`${table.priority} IN ('high', 'normal')`),
    check('push_messages_done', sql`${table.sentAt} IS NULL OR ${table.gaveUpAt} IS NULL`),
  ],
);
