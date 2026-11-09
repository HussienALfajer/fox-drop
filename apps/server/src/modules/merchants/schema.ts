import { sql } from 'drizzle-orm';
import {
  bigint,
  boolean,
  check,
  customType,
  index,
  integer,
  jsonb,
  pgSchema,
  primaryKey,
  smallint,
  text,
  timestamp,
  unique,
  uniqueIndex,
  uuid,
} from 'drizzle-orm/pg-core';
import type { AnyPgColumn } from 'drizzle-orm/pg-core';
import { accountStatuses, pauseSources } from './operating-state.js';

// Architecture §4.2–4.3: the merchants module owns restaurants, their hours,
// states and menu. Cities and zones belong to geo: their ids are plain
// columns here.
export const merchants = pgSchema('merchants');

// A PostGIS point in WGS 84, written and read through SQL only.
const point = customType<{ data: string; driverData: string }>({
  dataType: () => 'geometry(Point,4326)',
});

const createdAt = () => timestamp('created_at', { withTimezone: true }).notNull().defaultNow();
const updatedAt = () => timestamp('updated_at', { withTimezone: true }).notNull().defaultNow();

// Who made a change: an admin, a restaurant user, or the system.
const changedByTypes = ['admin', 'merchant', 'system'] as const;
const changedByValues = (name: string, column: AnyPgColumn) =>
  check(name, sql`${column} IN ('admin', 'merchant', 'system')`);

// AP §9.6.3 steps 1–3, AP §9.6.1, RA §7 and §10: the restaurant record.
export const restaurants = merchants.table(
  'restaurants',
  {
    id: uuid('id')
      .primaryKey()
      .default(sql`uuidv7()`),
    cityId: uuid('city_id').notNull(),
    nameAr: text('name_ar').notNull(),
    nameEn: text('name_en'),
    category: text('category'),
    description: text('description'),
    // Keys in public-media (architecture §5.8), set from the panel's uploads.
    logoKey: text('logo_key'),
    coverKey: text('cover_key'),
    location: point('location').notNull(),
    address: text('address'),
    // E.164.
    phone: text('phone'),
    accountStatus: text('account_status', { enum: accountStatuses }).notNull().default('draft'),
    // The reason of the latest suspension, shown in the restaurant app (RA §5.5).
    suspensionReason: text('suspension_reason'),
    visible: boolean('visible').notNull().default(true),
    // AP §9.6.5: the position in a home section or the category list.
    sortWeight: integer('sort_weight').notNull().default(0),
    // Owner decision 2026-11-06: a radius around the pin, or chosen zones
    // (coverage_zones).
    coverageKind: text('coverage_kind', { enum: ['radius', 'zones'] }).notNull(),
    coverageRadiusMetres: integer('coverage_radius_metres'),
    // RA R13: in the city's base currency, compared with the items value
    // before discounts (CU §10.2).
    minimumOrder: bigint('minimum_order', { mode: 'bigint' }).notNull(),
    minimumOrderCurrency: text('minimum_order_currency').notNull(),
    defaultPrepMin: smallint('default_prep_min').notNull(),
    // RA §7.4: off, or 1 to 50.
    maxActiveOrders: smallint('max_active_orders'),
    // RA §7.3: busy mode adds minutes until it is turned off or the opening
    // period ends.
    busyExtraMin: smallint('busy_extra_min'),
    busyUntil: timestamp('busy_until', { withTimezone: true }),
    // When busy mode was last turned on: its hourly reminder (RA §7.3) acts
    // only for the busy mode it was set for.
    busyStartedAt: timestamp('busy_started_at', { withTimezone: true }),
    createdAt: createdAt(),
    updatedAt: updatedAt(),
  },
  (table) => [
    index('restaurants_city').on(table.cityId),
    index('restaurants_location').using('gist', table.location),
    check(
      'restaurants_account_status_values',
      sql`${table.accountStatus} IN ('draft', 'test', 'active', 'suspended', 'terminated')`,
    ),
    check('restaurants_coverage_kind_values', sql`${table.coverageKind} IN ('radius', 'zones')`),
    check(
      'restaurants_coverage_radius',
      sql`(${table.coverageKind} = 'radius') = (${table.coverageRadiusMetres} IS NOT NULL) AND ${table.coverageRadiusMetres} > 0`,
    ),
    check('restaurants_minimum_order', sql`${table.minimumOrder} >= 0`),
    check('restaurants_default_prep_min', sql`${table.defaultPrepMin} > 0`),
    check('restaurants_max_active_orders', sql`${table.maxActiveOrders} BETWEEN 1 AND 50`),
    check(
      'restaurants_busy_mode',
      sql`(${table.busyExtraMin} IS NULL) = (${table.busyUntil} IS NULL) AND ${table.busyExtraMin} > 0`,
    ),
  ],
);

// The zones a restaurant covers when its coverage is by zones. A zone taken
// out keeps its row with removed_at.
export const coverageZones = merchants.table(
  'coverage_zones',
  {
    restaurantId: uuid('restaurant_id')
      .notNull()
      .references(() => restaurants.id),
    zoneId: uuid('zone_id').notNull(),
    removedAt: timestamp('removed_at', { withTimezone: true }),
  },
  (table) => [
    primaryKey({ columns: [table.restaurantId, table.zoneId] }),
    index('coverage_zones_zone').on(table.zoneId),
  ],
);

// RA §10: a version of the weekly schedule, never changed; the newest is in
// force. No version, or one without periods, is closed every day.
export const weeklySchedules = merchants.table(
  'weekly_schedules',
  {
    id: uuid('id')
      .primaryKey()
      .default(sql`uuidv7()`),
    restaurantId: uuid('restaurant_id')
      .notNull()
      .references(() => restaurants.id),
    changedByType: text('changed_by_type', { enum: changedByTypes }).notNull(),
    changedById: uuid('changed_by_id'),
    createdAt: createdAt(),
  },
  (table) => [
    index('weekly_schedules_current').on(table.restaurantId, table.id.desc()),
    changedByValues('weekly_schedules_changed_by_type_values', table.changedByType),
  ],
);

// One opening period of a schedule version (hours.ts): weekday 0 is Sunday;
// the times are minutes after midnight on the city's clock.
export const openingPeriods = merchants.table(
  'opening_periods',
  {
    scheduleId: uuid('schedule_id')
      .notNull()
      .references(() => weeklySchedules.id),
    weekday: smallint('weekday').notNull(),
    opensAt: smallint('opens_at').notNull(),
    closesAt: smallint('closes_at').notNull(),
  },
  (table) => [
    primaryKey({ columns: [table.scheduleId, table.weekday, table.opensAt] }),
    check('opening_periods_weekday', sql`${table.weekday} BETWEEN 0 AND 6`),
    check('opening_periods_opens_at', sql`${table.opensAt} BETWEEN 0 AND 1439`),
    check('opening_periods_closes_at', sql`${table.closesAt} BETWEEN 0 AND 1440`),
  ],
);

// RA §10, AP §9.6.5: closed from a moment until a moment, with an optional
// message to customers. Ending it early sets ended_at.
export const holidayCloses = merchants.table(
  'holiday_closes',
  {
    id: uuid('id')
      .primaryKey()
      .default(sql`uuidv7()`),
    restaurantId: uuid('restaurant_id')
      .notNull()
      .references(() => restaurants.id),
    startsAt: timestamp('starts_at', { withTimezone: true }).notNull(),
    endsAt: timestamp('ends_at', { withTimezone: true }).notNull(),
    message: text('message'),
    reason: text('reason'),
    setByType: text('set_by_type', { enum: changedByTypes }).notNull(),
    setById: uuid('set_by_id'),
    endedAt: timestamp('ended_at', { withTimezone: true }),
    endedByType: text('ended_by_type', { enum: changedByTypes }),
    endedById: uuid('ended_by_id'),
    createdAt: createdAt(),
  },
  (table) => [
    index('holiday_closes_restaurant').on(table.restaurantId, table.endsAt),
    check('holiday_closes_period', sql`${table.endsAt} > ${table.startsAt}`),
    check('holiday_closes_message', sql`char_length(${table.message}) <= 100`),
    changedByValues('holiday_closes_set_by_type_values', table.setByType),
    changedByValues('holiday_closes_ended_by_type_values', table.endedByType),
  ],
);

// RA §7.1, AP §9.6.5: a pause, by the restaurant, operations or the
// auto-pause rule. No end means until operations resume it; a restaurant
// pause always ends, at the latest when its opening period does (S3).
// Ending it early sets ended_at.
export const pauses = merchants.table(
  'pauses',
  {
    id: uuid('id')
      .primaryKey()
      .default(sql`uuidv7()`),
    restaurantId: uuid('restaurant_id')
      .notNull()
      .references(() => restaurants.id),
    source: text('source', { enum: pauseSources }).notNull(),
    startsAt: timestamp('starts_at', { withTimezone: true }).notNull(),
    endsAt: timestamp('ends_at', { withTimezone: true }),
    // An operations pause carries a message to customers and a reason.
    message: text('message'),
    reason: text('reason'),
    setById: uuid('set_by_id'),
    endedAt: timestamp('ended_at', { withTimezone: true }),
    endedByType: text('ended_by_type', { enum: changedByTypes }),
    endedById: uuid('ended_by_id'),
    createdAt: createdAt(),
  },
  (table) => [
    index('pauses_restaurant').on(table.restaurantId, table.startsAt.desc()),
    check('pauses_source_values', sql`${table.source} IN ('restaurant', 'ops', 'auto')`),
    check('pauses_period', sql`${table.endsAt} > ${table.startsAt}`),
    check(
      'pauses_restaurant_ends',
      sql`${table.source} <> 'restaurant' OR ${table.endsAt} IS NOT NULL`,
    ),
    changedByValues('pauses_ended_by_type_values', table.endedByType),
  ],
);

// RA §18, architecture §5.5, E4: a change of a restaurant's state, written in
// the transaction of the change; the worker's RestaurantStateRelay publishes
// it to the restaurant's and the city's operations channels and queues its
// push, then sets relayed_at, the only column the application role changes.
export const stateOutbox = merchants.table(
  'state_outbox',
  {
    id: bigint('id', { mode: 'bigint' }).primaryKey().generatedAlwaysAsIdentity(),
    createdAt: timestamp('created_at', { withTimezone: true }).notNull(),
    restaurantId: uuid('restaurant_id').notNull(),
    cityId: uuid('city_id').notNull(),
    // What changed (state-events.ts), such as paused or auto_paused.
    kind: text('kind').notNull(),
    payload: jsonb('payload').notNull(),
    relayedAt: timestamp('relayed_at', { withTimezone: true }),
  },
  (table) => [
    index('state_outbox_unrelayed')
      .on(table.id)
      .where(sql`${table.relayedAt} IS NULL`),
  ],
);

// AP §9.6.5, D16: a commission version in basis points of the items value
// (1500 is 15%), in effect from its start for new orders. Never changed.
export const commissionRates = merchants.table(
  'commission_rates',
  {
    id: uuid('id')
      .primaryKey()
      .default(sql`uuidv7()`),
    restaurantId: uuid('restaurant_id')
      .notNull()
      .references(() => restaurants.id),
    rateBp: integer('rate_bp').notNull(),
    effectiveFrom: timestamp('effective_from', { withTimezone: true }).notNull(),
    changedByType: text('changed_by_type', { enum: changedByTypes }).notNull(),
    changedById: uuid('changed_by_id'),
    reason: text('reason'),
    createdAt: createdAt(),
  },
  (table) => [
    index('commission_rates_restaurant').on(table.restaurantId, table.effectiveFrom),
    check('commission_rates_rate', sql`${table.rateBp} BETWEEN 0 AND 10000`),
    changedByValues('commission_rates_changed_by_type_values', table.changedByType),
  ],
);

export const devicePlatforms = ['android', 'ios', 'windows'] as const;

// A device of a restaurant (RA §5.2 item 5, §5.3): named on its first sign-in,
// such as «كاشير 1». The account that named it belongs to identity: a plain
// column. The ring setting, the device check and the last seen time join with
// staff and devices (RA §14).
export const devices = merchants.table(
  'devices',
  {
    id: uuid('id')
      .primaryKey()
      .default(sql`uuidv7()`),
    restaurantId: uuid('restaurant_id')
      .notNull()
      .references(() => restaurants.id),
    // The app installation, as at sign-in.
    deviceId: text('device_id').notNull(),
    name: text('name').notNull(),
    platform: text('platform', { enum: devicePlatforms }).notNull(),
    appVersion: text('app_version').notNull(),
    // The restaurant user who named or renamed it last.
    namedById: uuid('named_by_id').notNull(),
    createdAt: createdAt(),
    updatedAt: updatedAt(),
  },
  (table) => [
    uniqueIndex('devices_restaurant_device').on(table.restaurantId, table.deviceId),
    check('devices_platform_values', sql`${table.platform} IN ('android', 'ios', 'windows')`),
  ],
);

// AP §9.6.6, RA §9: a menu category. An unpublished one waits for its change
// request (RA §9.2). Availability off with an end is «حتى الغد»; without an
// end, until turned back on (RA §9.3). The availability window is minutes
// after midnight, such as breakfast until 12:00.
export const categories = merchants.table(
  'categories',
  {
    id: uuid('id')
      .primaryKey()
      .default(sql`uuidv7()`),
    restaurantId: uuid('restaurant_id')
      .notNull()
      .references(() => restaurants.id),
    name: text('name').notNull(),
    position: integer('position').notNull(),
    hidden: boolean('hidden').notNull().default(false),
    available: boolean('available').notNull().default(true),
    unavailableUntil: timestamp('unavailable_until', { withTimezone: true }),
    windowStartsAt: smallint('window_starts_at'),
    windowEndsAt: smallint('window_ends_at'),
    published: boolean('published').notNull(),
    deletedAt: timestamp('deleted_at', { withTimezone: true }),
    createdAt: createdAt(),
    updatedAt: updatedAt(),
  },
  (table) => [
    index('categories_restaurant').on(table.restaurantId, table.position),
    check(
      'categories_window',
      sql`(${table.windowStartsAt} IS NULL) = (${table.windowEndsAt} IS NULL) AND ${table.windowStartsAt} BETWEEN 0 AND 1439 AND ${table.windowEndsAt} BETWEEN 0 AND 1440`,
    ),
  ],
);

// AP §9.6.6, RA §9.1: a menu item, priced in the city's base currency.
export const items = merchants.table(
  'items',
  {
    id: uuid('id')
      .primaryKey()
      .default(sql`uuidv7()`),
    restaurantId: uuid('restaurant_id')
      .notNull()
      .references(() => restaurants.id),
    categoryId: uuid('category_id')
      .notNull()
      .references(() => categories.id),
    // Unique within the restaurant, for the Excel import.
    code: text('code').notNull(),
    name: text('name').notNull(),
    description: text('description'),
    price: bigint('price', { mode: 'bigint' }).notNull(),
    currency: text('currency').notNull(),
    photoKey: text('photo_key'),
    position: integer('position').notNull(),
    available: boolean('available').notNull().default(true),
    unavailableUntil: timestamp('unavailable_until', { withTimezone: true }),
    hidden: boolean('hidden').notNull().default(false),
    badge: text('badge', { enum: ['new', 'most_ordered', 'spicy'] }),
    published: boolean('published').notNull(),
    deletedAt: timestamp('deleted_at', { withTimezone: true }),
    createdAt: createdAt(),
    updatedAt: updatedAt(),
  },
  (table) => [
    unique('items_restaurant_code').on(table.restaurantId, table.code),
    index('items_category').on(table.categoryId, table.position),
    check('items_price', sql`${table.price} > 0`),
    check('items_badge_values', sql`${table.badge} IN ('new', 'most_ordered', 'spicy')`),
  ],
);

// AP §9.6.6, RA §9.1: an option group of a restaurant, linked to many items.
// Required when its minimum is 1 or more; add-ons have a minimum of 0.
export const optionGroups = merchants.table(
  'option_groups',
  {
    id: uuid('id')
      .primaryKey()
      .default(sql`uuidv7()`),
    restaurantId: uuid('restaurant_id')
      .notNull()
      .references(() => restaurants.id),
    name: text('name').notNull(),
    minChoices: smallint('min_choices').notNull(),
    maxChoices: smallint('max_choices').notNull(),
    published: boolean('published').notNull(),
    deletedAt: timestamp('deleted_at', { withTimezone: true }),
    createdAt: createdAt(),
    updatedAt: updatedAt(),
  },
  (table) => [
    index('option_groups_restaurant').on(table.restaurantId),
    check(
      'option_groups_choices',
      sql`${table.minChoices} >= 0 AND ${table.maxChoices} >= 1 AND ${table.maxChoices} >= ${table.minChoices}`,
    ),
  ],
);

// An option of a group, with its price delta in the base currency (0 or more).
export const options = merchants.table(
  'options',
  {
    id: uuid('id')
      .primaryKey()
      .default(sql`uuidv7()`),
    groupId: uuid('group_id')
      .notNull()
      .references(() => optionGroups.id),
    name: text('name').notNull(),
    priceDelta: bigint('price_delta', { mode: 'bigint' }).notNull(),
    currency: text('currency').notNull(),
    position: integer('position').notNull(),
    available: boolean('available').notNull().default(true),
    unavailableUntil: timestamp('unavailable_until', { withTimezone: true }),
    published: boolean('published').notNull(),
    deletedAt: timestamp('deleted_at', { withTimezone: true }),
    createdAt: createdAt(),
    updatedAt: updatedAt(),
  },
  (table) => [
    index('options_group').on(table.groupId, table.position),
    check('options_price_delta', sql`${table.priceDelta} >= 0`),
  ],
);

// The groups of an item, in order. Unlinking sets removed_at.
export const itemOptionGroups = merchants.table(
  'item_option_groups',
  {
    itemId: uuid('item_id')
      .notNull()
      .references(() => items.id),
    groupId: uuid('group_id')
      .notNull()
      .references(() => optionGroups.id),
    position: integer('position').notNull(),
    removedAt: timestamp('removed_at', { withTimezone: true }),
  },
  (table) => [
    primaryKey({ columns: [table.itemId, table.groupId] }),
    index('item_option_groups_group').on(table.groupId),
  ],
);

// AP §9.6.6, RA §9.4: «سجل الأسعار», every change of an item price or an
// option delta, with who made it. Never changed.
export const priceChanges = merchants.table(
  'price_changes',
  {
    id: uuid('id')
      .primaryKey()
      .default(sql`uuidv7()`),
    restaurantId: uuid('restaurant_id')
      .notNull()
      .references(() => restaurants.id),
    itemId: uuid('item_id').references(() => items.id),
    optionId: uuid('option_id').references(() => options.id),
    currency: text('currency').notNull(),
    oldPrice: bigint('old_price', { mode: 'bigint' }).notNull(),
    newPrice: bigint('new_price', { mode: 'bigint' }).notNull(),
    changedByType: text('changed_by_type', { enum: changedByTypes }).notNull(),
    changedById: uuid('changed_by_id'),
    createdAt: createdAt(),
  },
  (table) => [
    index('price_changes_restaurant').on(table.restaurantId, table.id.desc()),
    index('price_changes_item').on(table.itemId),
    index('price_changes_option').on(table.optionId),
    check('price_changes_target', sql`num_nonnulls(${table.itemId}, ${table.optionId}) = 1`),
    changedByValues('price_changes_changed_by_type_values', table.changedByType),
  ],
);

export const changeRequestTargets = ['category', 'item', 'option_group', 'option'] as const;
export const changeRequestStatuses = ['pending', 'approved', 'rejected', 'withdrawn'] as const;

// RA §9.5, AP §9.6.7: «طلبات تعديل القائمة». A change that needs review, one
// pending per field of a target; a new item or category is its own
// unpublished row with the field `created`. A newer edit replaces the pending
// value. The approved value may be the reviewer's correction.
export const changeRequests = merchants.table(
  'change_requests',
  {
    id: uuid('id')
      .primaryKey()
      .default(sql`uuidv7()`),
    restaurantId: uuid('restaurant_id')
      .notNull()
      .references(() => restaurants.id),
    targetType: text('target_type', { enum: changeRequestTargets }).notNull(),
    targetId: uuid('target_id').notNull(),
    // Such as created, name, description, photo, choices or groups.
    field: text('field').notNull(),
    pendingValue: jsonb('pending_value').notNull(),
    status: text('status', { enum: changeRequestStatuses }).notNull().default('pending'),
    requestedById: uuid('requested_by_id').notNull(),
    reviewedById: uuid('reviewed_by_id'),
    reviewedAt: timestamp('reviewed_at', { withTimezone: true }),
    approvedValue: jsonb('approved_value'),
    rejectionReason: text('rejection_reason'),
    createdAt: createdAt(),
    updatedAt: updatedAt(),
  },
  (table) => [
    uniqueIndex('change_requests_one_pending')
      .on(table.targetType, table.targetId, table.field)
      .where(sql`${table.status} = 'pending'`),
    index('change_requests_queue').on(table.status, table.createdAt),
    index('change_requests_restaurant').on(table.restaurantId, table.status),
    check(
      'change_requests_target_type_values',
      sql`${table.targetType} IN ('category', 'item', 'option_group', 'option')`,
    ),
    check(
      'change_requests_status_values',
      sql`${table.status} IN ('pending', 'approved', 'rejected', 'withdrawn')`,
    ),
    check(
      'change_requests_rejection_reason',
      sql`(${table.status} = 'rejected') = (${table.rejectionReason} IS NOT NULL)`,
    ),
  ],
);
