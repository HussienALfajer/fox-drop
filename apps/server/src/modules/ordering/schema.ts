import { sql } from 'drizzle-orm';
import {
  bigint,
  boolean,
  check,
  customType,
  foreignKey,
  index,
  integer,
  jsonb,
  pgSchema,
  primaryKey,
  smallint,
  text,
  timestamp,
  uuid,
} from 'drizzle-orm/pg-core';

// Architecture §4.2–4.3: the ordering module owns the orders, their lines and
// events. Cities, restaurants, items, customers, fee rules and pay tables
// belong to other modules: their ids are plain columns here.
export const ordering = pgSchema('ordering');

// A PostGIS point in WGS 84, written and read through SQL only.
const point = customType<{ data: string; driverData: string }>({
  dataType: () => 'geometry(Point,4326)',
});

// AP §8.1.
export const orderStatuses = [
  'placed',
  'accepted',
  'ready',
  'picked_up',
  'arrived',
  'delivered',
  'rejected',
  'cancelled',
  'failed',
] as const;

export const addressLabels = ['home', 'work', 'other'] as const;

// AP §4.8: the order numbers are sequential per city, from 10001 (owner
// decision 2026-11-06). The row is taken last in the order's transaction, so
// a refused order leaves no gap and the lock is held briefly.
export const orderNumbers = ordering.table('order_numbers', {
  cityId: uuid('city_id').primaryKey(),
  lastNumber: bigint('last_number', { mode: 'bigint' }).notNull(),
});

// An order as it was placed (CU §10.7, AP §8.1), partitioned by the UTC month
// it was placed (architecture §5.4). Money is in the city's base currency in
// minor units (AP §8.4); the order keeps the rates, the fee rule, the
// commission and the pay table version it was placed with (architecture
// §5.2), and the address as it was (Q6).
export const orders = ordering.table(
  'orders',
  {
    id: uuid('id')
      .notNull()
      .default(sql`uuidv7()`),
    placedAt: timestamp('placed_at', { withTimezone: true }).notNull(),
    cityId: uuid('city_id').notNull(),
    number: bigint('number', { mode: 'bigint' }).notNull(),
    // The identity module's customer_accounts row.
    customerAccountId: uuid('customer_account_id').notNull(),
    restaurantId: uuid('restaurant_id').notNull(),
    status: text('status', { enum: orderStatuses }).notNull(),
    // Architecture §5.3, §5.5: every transition increments it.
    version: integer('version').notNull(),
    currency: text('currency').notNull(),
    itemsValue: bigint('items_value', { mode: 'bigint' }).notNull(),
    deliveryFee: bigint('delivery_fee', { mode: 'bigint' }).notNull(),
    discount: bigint('discount', { mode: 'bigint' }).notNull(),
    rounding: bigint('rounding', { mode: 'bigint' }).notNull(),
    total: bigint('total', { mode: 'bigint' }).notNull(),
    deliveryFree: boolean('delivery_free').notNull(),
    // geo's fee rule version the fee was priced with.
    feeRuleId: uuid('fee_rule_id').notNull(),
    commissionBp: integer('commission_bp').notNull(),
    // captains' pay table in force at placing; null while the city has none.
    payTableId: uuid('pay_table_id'),
    // fx's RateSnapshot, its bigints as strings (AP §8.6).
    rateSnapshot: jsonb('rate_snapshot').notNull(),
    // «سأدفع بـ» (CU §10.5); null for «لم أحدد».
    payIn: text('pay_in'),
    // CU §10.3: to the restaurant and the captain, up to 200 characters.
    note: text('note'),
    estimateFromMin: smallint('estimate_from_min').notNull(),
    estimateToMin: smallint('estimate_to_min').notNull(),
    // The address snapshot (CU §7.3–7.4, Q6): the saved address it was copied
    // from, or null for an unsaved one; «الحي» is the zone at placing.
    addressId: uuid('address_id'),
    location: point('location').notNull(),
    zoneId: uuid('zone_id').notNull(),
    neighbourhood: text('neighbourhood').notNull(),
    label: text('label', { enum: addressLabels }),
    customLabel: text('custom_label'),
    street: text('street').notNull(),
    floor: text('floor'),
    landmark: text('landmark').notNull(),
    // Another mobile than the account's, encrypted with identity's key
    // (architecture §15.3); null is the account's own number.
    contactPhoneEncrypted: text('contact_phone_encrypted'),
    recipientName: text('recipient_name'),
    directions: text('directions'),
  },
  (table) => [
    primaryKey({ columns: [table.id, table.placedAt] }),
    index('orders_city_number').on(table.cityId, table.number),
    index('orders_customer_status').on(table.customerAccountId, table.status),
    index('orders_restaurant_status').on(table.restaurantId, table.status),
    check(
      'orders_status_values',
      sql`${table.status} IN ('placed', 'accepted', 'ready', 'picked_up', 'arrived', 'delivered', 'rejected', 'cancelled', 'failed')`,
    ),
    check('orders_version', sql`${table.version} >= 1`),
    check(
      'orders_money',
      sql`${table.itemsValue} >= 0 AND ${table.deliveryFee} >= 0 AND ${table.discount} >= 0 AND ${table.total} >= 0 AND ${table.total} = ${table.itemsValue} + ${table.deliveryFee} - ${table.discount} + ${table.rounding}`,
    ),
    check('orders_note', sql`char_length(${table.note}) BETWEEN 1 AND 200`),
    check(
      'orders_label_values',
      sql`${table.label} IS NULL OR ${table.label} IN ('home', 'work', 'other')`,
    ),
    check(
      'orders_recipient',
      sql`${table.contactPhoneEncrypted} IS NULL OR ${table.recipientName} IS NOT NULL`,
    ),
  ],
);

// The order's lines as priced at placing (CU §10.1), in the order's currency,
// partitioned with their order.
export const orderLines = ordering.table(
  'order_lines',
  {
    orderId: uuid('order_id').notNull(),
    orderPlacedAt: timestamp('order_placed_at', { withTimezone: true }).notNull(),
    position: smallint('position').notNull(),
    cityId: uuid('city_id').notNull(),
    // The merchants module's item, and its name at placing.
    itemId: uuid('item_id').notNull(),
    itemName: text('item_name').notNull(),
    quantity: smallint('quantity').notNull(),
    // { id, name, priceDelta } per chosen option, the deltas as strings.
    options: jsonb('options').notNull(),
    unitPrice: bigint('unit_price', { mode: 'bigint' }).notNull(),
    lineTotal: bigint('line_total', { mode: 'bigint' }).notNull(),
    note: text('note'),
  },
  (table) => [
    primaryKey({ columns: [table.orderId, table.orderPlacedAt, table.position] }),
    foreignKey({
      columns: [table.orderId, table.orderPlacedAt],
      foreignColumns: [orders.id, orders.placedAt],
    }),
    check('order_lines_quantity', sql`${table.quantity} BETWEEN 1 AND 20`),
    check(
      'order_lines_money',
      sql`${table.unitPrice} >= 0 AND ${table.lineTotal} = ${table.unitPrice} * ${table.quantity}`,
    ),
  ],
);

// Architecture §5.5: one row per transition of an order, append-only and
// partitioned with the order. The version is the order's after it.
export const orderEvents = ordering.table(
  'order_events',
  {
    orderId: uuid('order_id').notNull(),
    orderPlacedAt: timestamp('order_placed_at', { withTimezone: true }).notNull(),
    version: integer('version').notNull(),
    cityId: uuid('city_id').notNull(),
    at: timestamp('at', { withTimezone: true }).notNull(),
    fromStatus: text('from_status', { enum: orderStatuses }),
    toStatus: text('to_status', { enum: orderStatuses }).notNull(),
    // customer, restaurant, captain, admin or system, and its id.
    actorType: text('actor_type').notNull(),
    actorId: uuid('actor_id'),
    reason: text('reason'),
  },
  (table) => [
    primaryKey({ columns: [table.orderId, table.orderPlacedAt, table.version] }),
    foreignKey({
      columns: [table.orderId, table.orderPlacedAt],
      foreignColumns: [orders.id, orders.placedAt],
    }),
    check(
      'order_events_status_values',
      sql`(${table.fromStatus} IS NULL OR ${table.fromStatus} IN ('placed', 'accepted', 'ready', 'picked_up', 'arrived', 'delivered', 'rejected', 'cancelled', 'failed')) AND ${table.toStatus} IN ('placed', 'accepted', 'ready', 'picked_up', 'arrived', 'delivered', 'rejected', 'cancelled', 'failed')`,
    ),
    check(
      'order_events_actor_values',
      sql`${table.actorType} IN ('customer', 'restaurant', 'captain', 'admin', 'system')`,
    ),
  ],
);

// Architecture §5.3: a command's Idempotency-Key, kept with the order it
// placed for 24 hours. A repeat within them answers that order; an older key
// may be used again.
export const idempotencyKeys = ordering.table(
  'idempotency_keys',
  {
    accountId: uuid('account_id').notNull(),
    key: text('key').notNull(),
    // A hash of the command, so a key sent again with another command is
    // refused.
    requestHash: text('request_hash').notNull(),
    orderId: uuid('order_id').notNull(),
    orderPlacedAt: timestamp('order_placed_at', { withTimezone: true }).notNull(),
    createdAt: timestamp('created_at', { withTimezone: true }).notNull(),
  },
  (table) => [primaryKey({ columns: [table.accountId, table.key] })],
);
