import { sql } from 'drizzle-orm';
import {
  boolean,
  check,
  index,
  integer,
  jsonb,
  pgSchema,
  text,
  timestamp,
  unique,
  uuid,
} from 'drizzle-orm/pg-core';

// Architecture §4.3: the settings module owns the settings schema.
export const settings = pgSchema('settings');

// The stored value of a setting (AP §4.4), one row per key and scope: the city
// for a city setting, none for a global one. A key without a row, or with
// is_default set after a reset, takes the catalogue's default.
export const values = settings.table(
  'values',
  {
    id: uuid('id')
      .primaryKey()
      .default(sql`uuidv7()`),
    // A concrete catalogue key, such as dispatch.mode or currency.TRY.rounding_unit.
    key: text('key').notNull(),
    // Empty for a global setting (AP Appendix A, scope G).
    cityId: uuid('city_id'),
    // The value in the shape its catalogue entry parses; null is a value of its
    // own (such as push.daily_limit «none») unless is_default is set.
    value: jsonb('value'),
    isDefault: boolean('is_default').notNull().default(false),
    // Counts the changes of this row, so the cache never takes an older value
    // over a newer one.
    version: integer('version').notNull().default(1),
    updatedAt: timestamp('updated_at', { withTimezone: true }).notNull().defaultNow(),
  },
  (table) => [
    unique('values_key_city').on(table.key, table.cityId).nullsNotDistinct(),
    check('values_default_has_no_value', sql`NOT ${table.isDefault} OR ${table.value} IS NULL`),
  ],
);

export const changeActions = ['update', 'reset'] as const;

// Every change of a setting (AP §4.4): the old and new value in effect, the
// editor, the time and the reason. Append-only: the application role may only
// add and read rows.
export const changes = settings.table(
  'changes',
  {
    id: uuid('id')
      .primaryKey()
      .default(sql`uuidv7()`),
    key: text('key').notNull(),
    cityId: uuid('city_id'),
    action: text('action', { enum: changeActions }).notNull(),
    before: jsonb('before'),
    after: jsonb('after'),
    // An admin account (slice 0.7) and the roles it held at that moment.
    editorId: uuid('editor_id').notNull(),
    editorRoles: text('editor_roles').array().notNull(),
    reason: text('reason'),
    changedAt: timestamp('changed_at', { withTimezone: true }).notNull().defaultNow(),
  },
  (table) => [
    index('changes_key_city_changed_at').on(table.key, table.cityId, table.changedAt),
    check('changes_action_values', sql`${table.action} IN ('update', 'reset')`),
  ],
);
