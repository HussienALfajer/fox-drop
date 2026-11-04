import { sql } from 'drizzle-orm';
import {
  check,
  inet,
  jsonb,
  pgSchema,
  primaryKey,
  text,
  timestamp,
  uuid,
} from 'drizzle-orm/pg-core';

// Architecture §4.3: the audit module owns the audit schema.
export const audit = pgSchema('audit');

export const actorTypes = ['admin', 'merchant', 'captain', 'customer', 'system'] as const;
export const eventKinds = ['write', 'view'] as const;

// AP §9.16. Append-only: the application role may only add and read rows
// (architecture §15.3). Partitioned by month on occurred_at (architecture
// §5.4); the migration declares the partitioning, which Drizzle cannot.
export const events = audit.table(
  'events',
  {
    id: uuid('id')
      .notNull()
      .default(sql`uuidv7()`),
    occurredAt: timestamp('occurred_at', { withTimezone: true }).notNull().defaultNow(),
    // Empty for an action on the whole platform (AP D28).
    cityId: uuid('city_id'),
    // Who acted: the kind of account, its id and its role at that moment
    // (AP D27). The system acts without an id.
    actorType: text('actor_type', { enum: actorTypes }).notNull(),
    actorId: uuid('actor_id'),
    actorRole: text('actor_role'),
    // A write action changes the target; a view reveals sensitive data
    // (a phone number, an export with phone numbers, a document file).
    kind: text('kind', { enum: eventKinds }).notNull(),
    action: text('action').notNull(),
    targetType: text('target_type').notNull(),
    targetId: text('target_id').notNull(),
    // The changed fields only, each as { before, after }.
    changes: jsonb('changes').$type<Record<string, { before: unknown; after: unknown }>>(),
    reason: text('reason'),
    ipAddress: inet('ip_address'),
    device: text('device'),
  },
  (table) => [
    // A partitioned table's key includes its partition column.
    primaryKey({ columns: [table.id, table.occurredAt] }),
    check(
      'events_actor_type_values',
      sql`${table.actorType} IN ('admin', 'merchant', 'captain', 'customer', 'system')`,
    ),
    check(
      'events_actor_id_present',
      sql`(${table.actorType} = 'system') = (${table.actorId} IS NULL)`,
    ),
    check('events_kind_values', sql`${table.kind} IN ('write', 'view')`),
    check(
      'events_changes_on_writes_only',
      sql`${table.kind} = 'write' OR ${table.changes} IS NULL`,
    ),
  ],
);
