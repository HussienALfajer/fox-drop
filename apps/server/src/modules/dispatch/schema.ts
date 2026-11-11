import { sql } from 'drizzle-orm';
import {
  bigint,
  boolean,
  check,
  index,
  integer,
  pgSchema,
  primaryKey,
  text,
  timestamp,
  uniqueIndex,
  uuid,
} from 'drizzle-orm/pg-core';

// Architecture §4.2–4.3: the dispatch module owns the offers. Orders,
// captains and admin accounts belong to other modules: their ids are plain
// columns here.
export const dispatch = pgSchema('dispatch');

// CA §8.3, AP §9.7.4: an offer is open until the captain accepts or declines
// it, or dispatch.offer_timeout_sec passes («انتهت المهلة»); withdrawn when
// the captain went offline first.
export const offerStatuses = ['open', 'accepted', 'declined', 'expired', 'withdrawn'] as const;

// AP §9.3.2: operations' manual offer; automatic offers join with automatic
// dispatch (D6: manual at launch).
export const offerKinds = ['manual'] as const;

// One offer of an order to one captain (CA §8, AP §9.12.6), with what the
// captain was shown: the distance to the restaurant and the pay estimate,
// both as they were when the offer opened. Every offer and response is kept
// (AP §9.7.4); the acceptance rate reads them (CA §11.1).
export const offers = dispatch.table(
  'offers',
  {
    id: uuid('id')
      .primaryKey()
      .default(sql`uuidv7()`),
    cityId: uuid('city_id').notNull(),
    // The ordering module's order, by its partition key.
    orderId: uuid('order_id').notNull(),
    orderPlacedAt: timestamp('order_placed_at', { withTimezone: true }).notNull(),
    // The captains module's record.
    captainId: uuid('captain_id').notNull(),
    kind: text('kind', { enum: offerKinds }).notNull(),
    // The identity module's admin account that sent a manual offer.
    offeredBy: uuid('offered_by'),
    offeredAt: timestamp('offered_at', { withTimezone: true }).notNull(),
    expiresAt: timestamp('expires_at', { withTimezone: true }).notNull(),
    status: text('status', { enum: offerStatuses }).notNull(),
    respondedAt: timestamp('responded_at', { withTimezone: true }),
    // CA §8.2: the road distance from the captain to the restaurant by its
    // vehicle, and the order pay of the pay table the order kept (null while
    // the city had none), in the order's currency.
    pickupMetres: integer('pickup_metres').notNull(),
    pay: bigint('pay', { mode: 'bigint' }),
    payCurrency: text('pay_currency'),
    // AP §9.3.2 «تسليم لكابتن آخر» (slice 2.12b): the offer of a picked-up
    // order from its captain, «استلام من كابتن»; pickup_metres is then to
    // the first captain.
    handover: boolean('handover').notNull().default(false),
    // CA §8.4, K2: a manual offer whose pickup payment was above the
    // captain's «أقصى مبلغ أحمله» when it opened; the captain sees «المبلغ
    // أكبر من الحد الذي حددته — اقبل فقط إذا كان معك ما يكفي».
    aboveMaxPickup: boolean('above_max_pickup').notNull().default(false),
  },
  (table) => [
    // CA §8.1: one offer at a time per captain, and per order.
    uniqueIndex('offers_one_open_per_order')
      .on(table.orderId)
      .where(sql`${table.status} = 'open'`),
    uniqueIndex('offers_one_open_per_captain')
      .on(table.captainId)
      .where(sql`${table.status} = 'open'`),
    index('offers_captain_offered').on(table.captainId, table.offeredAt.desc()),
    index('offers_order').on(table.orderId, table.offeredAt),
    check(
      'offers_status_values',
      sql`${table.status} IN ('open', 'accepted', 'declined', 'expired', 'withdrawn')`,
    ),
    check('offers_kind_values', sql`${table.kind} IN ('manual')`),
    check('offers_manual_by', sql`${table.kind} <> 'manual' OR ${table.offeredBy} IS NOT NULL`),
    check(
      'offers_response',
      sql`(${table.status} = 'open') = (${table.respondedAt} IS NULL) AND ${table.expiresAt} > ${table.offeredAt}`,
    ),
    check(
      'offers_pay',
      sql`(${table.pay} IS NULL) = (${table.payCurrency} IS NULL) AND ${table.pay} >= 0 AND ${table.pickupMetres} >= 0`,
    ),
  ],
);

// Architecture §5.3: a dispatch command's Idempotency-Key, kept with the
// order it acted on for 24 hours. A repeat within them answers that order's
// dispatch state, or the offer's.
export const idempotencyKeys = dispatch.table(
  'idempotency_keys',
  {
    // The admin account or the captain's app account.
    accountId: uuid('account_id').notNull(),
    key: text('key').notNull(),
    // A hash of the command, so a key sent again with another is refused.
    requestHash: text('request_hash').notNull(),
    orderId: uuid('order_id').notNull(),
    orderPlacedAt: timestamp('order_placed_at', { withTimezone: true }).notNull(),
    // The offer the command opened or answered; null for a direct
    // assignment.
    offerId: uuid('offer_id'),
    createdAt: timestamp('created_at', { withTimezone: true }).notNull(),
  },
  (table) => [primaryKey({ columns: [table.accountId, table.key] })],
);
