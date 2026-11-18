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

// Architecture §4.3: the marketing module owns the marketing schema.
export const marketing = pgSchema('marketing');

// AP §9.11.1 «النوع»: a percentage of the items value, a fixed amount off
// the items value, or the delivery fee (AP §8.4's caps).
export const promoCodeKinds = ['percentage', 'fixed_amount', 'free_delivery'] as const;
export type PromoCodeKind = (typeof promoCodeKinds)[number];

// «الجمهور»: everyone, or new users only (an account with no delivered order).
export const promoCodeAudiences = ['everyone', 'new_users'] as const;
export type PromoCodeAudience = (typeof promoCodeAudiences)[number];

// «التمويل»: the platform 100%, the restaurant 100%, or shared by a ratio.
export const promoCodeFundings = ['platform', 'restaurant', 'shared'] as const;
export type PromoCodeFunding = (typeof promoCodeFundings)[number];

// «الظهور»: shown in the app, or secret (shared outside the app). A
// personal code (slice 2.22a) belongs to one customer: a compensation code
// or the automatic late code (AP §6.4, CU §12.4), never made by hand.
export const promoCodeVisibilities = ['visible', 'secret', 'personal'] as const;
export type PromoCodeVisibility = (typeof promoCodeVisibilities)[number];

// Set by OWN: a paused code is refused until resumed. The daily budget's
// pause (AP §9.11.1) is worked out from the day's cost, never stored here.
export const promoCodeStatuses = ['active', 'paused'] as const;
export type PromoCodeStatus = (typeof promoCodeStatuses)[number];

// A promo code «كود خصم» (AP §9.11.1, slice 2.21a): one row per code, a
// generated batch sharing a batch id. Amounts are minor units of `currency`,
// the city's base when it was saved (AP §8.6). Restaurants and zones are the
// merchants and geo modules' ids, plain values (architecture §4.3); none
// means all.
export const promoCodes = marketing.table(
  'promo_codes',
  {
    id: uuid('id')
      .primaryKey()
      .default(sql`uuidv7()`),
    cityId: uuid('city_id').notNull(),
    // Upper-case Latin letters and digits, unique in the city.
    code: text('code').notNull(),
    // The codes generated together share it; null for a code typed by hand.
    batchId: uuid('batch_id'),
    kind: text('kind', { enum: promoCodeKinds }).notNull(),
    // A percentage in basis points (2000 is 20%).
    percentBp: integer('percent_bp'),
    // A fixed amount's value.
    amount: bigint('amount', { mode: 'bigint' }),
    // A percentage's cap «الحد الأقصى».
    maxDiscount: bigint('max_discount', { mode: 'bigint' }),
    currency: text('currency').notNull(),
    // Compared with the items value before discounts.
    minOrder: bigint('min_order', { mode: 'bigint' }),
    validFrom: timestamp('valid_from', { withTimezone: true }).notNull(),
    validTo: timestamp('valid_to', { withTimezone: true }).notNull(),
    // Optional hours of the day, minutes from midnight on the city clock; at
    // or before the start the hours run past midnight.
    startMinute: integer('start_minute'),
    endMinute: integer('end_minute'),
    // Null: no limit.
    totalLimit: integer('total_limit'),
    perCustomerLimit: integer('per_customer_limit'),
    audience: text('audience', { enum: promoCodeAudiences }).notNull(),
    restaurantIds: uuid('restaurant_ids').array().notNull(),
    zoneIds: uuid('zone_ids').array().notNull(),
    funding: text('funding', { enum: promoCodeFundings }).notNull(),
    // The restaurant's share of the discount in basis points: 0 for the
    // platform, 10000 for the restaurant, between them when shared.
    merchantShareBp: integer('merchant_share_bp').notNull(),
    // The code pauses for the rest of the business day once the day's cost
    // reaches it (owner decision 2026-11-16: the daily report's business day).
    dailyBudget: bigint('daily_budget', { mode: 'bigint' }),
    visibility: text('visibility', { enum: promoCodeVisibilities }).notNull(),
    // A personal code's customer (identity's account id, a plain value).
    customerAccountId: uuid('customer_account_id'),
    status: text('status', { enum: promoCodeStatuses }).notNull().default('active'),
    // The admin accounts (identity's ids, plain values); null for a code the
    // system issued, the late code (slice 2.22c).
    createdBy: uuid('created_by'),
    createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
    updatedBy: uuid('updated_by'),
    updatedAt: timestamp('updated_at', { withTimezone: true }).notNull().defaultNow(),
  },
  (table) => [
    uniqueIndex('promo_codes_city_code').on(table.cityId, table.code),
    // «أكوادي» (slice 2.22b): a customer's personal codes.
    index('promo_codes_customer').on(table.customerAccountId),
    index('promo_codes_batch').on(table.batchId),
    check('promo_codes_code_format', sql`${table.code} ~ '^[A-Z0-9]{3,20}$'`),
    check(
      'promo_codes_kind_values',
      sql`${table.kind} IN ('percentage', 'fixed_amount', 'free_delivery')`,
    ),
    check(
      'promo_codes_value',
      sql`COALESCE(CASE ${table.kind}
            WHEN 'percentage' THEN ${table.percentBp} BETWEEN 1 AND 10000 AND ${table.amount} IS NULL
              AND (${table.maxDiscount} IS NULL OR ${table.maxDiscount} > 0)
            WHEN 'fixed_amount' THEN ${table.amount} > 0 AND ${table.percentBp} IS NULL
              AND ${table.maxDiscount} IS NULL
            ELSE ${table.percentBp} IS NULL AND ${table.amount} IS NULL AND ${table.maxDiscount} IS NULL
          END, false)`,
    ),
    check('promo_codes_currency', sql`${table.currency} ~ '^[A-Z]{3}$'`),
    check(
      'promo_codes_amounts',
      sql`(${table.minOrder} IS NULL OR ${table.minOrder} > 0)
          AND (${table.dailyBudget} IS NULL OR ${table.dailyBudget} > 0)`,
    ),
    check('promo_codes_validity', sql`${table.validTo} > ${table.validFrom}`),
    check(
      'promo_codes_hours',
      sql`(${table.startMinute} IS NULL) = (${table.endMinute} IS NULL)
          AND (${table.startMinute} IS NULL OR (${table.startMinute} BETWEEN 0 AND 1439
            AND ${table.endMinute} BETWEEN 0 AND 1439 AND ${table.startMinute} <> ${table.endMinute}))`,
    ),
    check(
      'promo_codes_limits',
      sql`(${table.totalLimit} IS NULL OR ${table.totalLimit} > 0)
          AND (${table.perCustomerLimit} IS NULL OR ${table.perCustomerLimit} > 0)
          AND (${table.totalLimit} IS NULL OR ${table.perCustomerLimit} IS NULL
            OR ${table.perCustomerLimit} <= ${table.totalLimit})`,
    ),
    check('promo_codes_audience_values', sql`${table.audience} IN ('everyone', 'new_users')`),
    check(
      'promo_codes_funding',
      sql`CASE ${table.funding}
            WHEN 'platform' THEN ${table.merchantShareBp} = 0
            WHEN 'restaurant' THEN ${table.merchantShareBp} = 10000
              AND cardinality(${table.restaurantIds}) > 0
            WHEN 'shared' THEN ${table.merchantShareBp} BETWEEN 1 AND 9999
              AND cardinality(${table.restaurantIds}) > 0
            ELSE false
          END`,
    ),
    check(
      'promo_codes_visibility_values',
      sql`${table.visibility} IN ('visible', 'secret', 'personal')`,
    ),
    // A personal code (slice 2.22a): one use by its customer, an amount or a
    // percentage, funded by the platform, with no other rule. A compensation's
    // percentage has its maximum (`compensations_value`); the late code's may
    // have none (AP Appendix A, slice 2.22c).
    check(
      'promo_codes_personal',
      sql`(${table.visibility} = 'personal') = (${table.customerAccountId} IS NOT NULL)
          AND (${table.visibility} <> 'personal' OR (${table.kind} <> 'free_delivery'
            AND ${table.totalLimit} = 1 AND ${table.perCustomerLimit} = 1
            AND ${table.audience} = 'everyone' AND ${table.funding} = 'platform'
            AND cardinality(${table.restaurantIds}) = 0 AND cardinality(${table.zoneIds}) = 0
            AND ${table.minOrder} IS NULL AND ${table.dailyBudget} IS NULL
            AND ${table.startMinute} IS NULL AND ${table.batchId} IS NULL))`,
    ),
    check('promo_codes_status_values', sql`${table.status} IN ('active', 'paused')`),
    // Only a personal code is issued by the system, without an admin.
    check(
      'promo_codes_admins',
      sql`${table.visibility} = 'personal'
          OR (${table.createdBy} IS NOT NULL AND ${table.updatedBy} IS NOT NULL)`,
    ),
  ],
);

// Architecture §5.3: a create command's Idempotency-Key, kept with the codes
// it created for 24 hours. A repeat within them answers those codes.
export const idempotencyKeys = marketing.table(
  'idempotency_keys',
  {
    accountId: uuid('account_id').notNull(),
    key: text('key').notNull(),
    // A hash of the command, so a key sent again with another is refused.
    requestHash: text('request_hash').notNull(),
    codeIds: uuid('code_ids').array().notNull(),
    createdAt: timestamp('created_at', { withTimezone: true }).notNull(),
  },
  (table) => [primaryKey({ columns: [table.accountId, table.key] })],
);

// AP §9.11.1 «When a use counts»: held when the order is placed, spent when
// it ends delivered or failed with the customer responsible, given back when
// it ends rejected, cancelled or failed with another party responsible.
export const promoCodeUseStatuses = ['held', 'spent', 'returned'] as const;
export type PromoCodeUseStatus = (typeof promoCodeUseStatuses)[number];

// A code used on an order (slice 2.21b): one row per order. The order, the
// customer's account and the city are other modules' ids, plain values. The
// number is kept by its keyed hash and the app installation by its id, so a
// new-user code works once per number and once per device. The business day
// (from finance.business_day_cutoff) counts the daily budget; the cost is the
// discount the order got, the restaurant's share included.
export const promoCodeUses = marketing.table(
  'promo_code_uses',
  {
    id: uuid('id')
      .primaryKey()
      .default(sql`uuidv7()`),
    codeId: uuid('code_id')
      .notNull()
      .references(() => promoCodes.id),
    cityId: uuid('city_id').notNull(),
    orderId: uuid('order_id').notNull(),
    orderPlacedAt: timestamp('order_placed_at', { withTimezone: true }).notNull(),
    customerAccountId: uuid('customer_account_id').notNull(),
    phoneHash: text('phone_hash').notNull(),
    deviceId: text('device_id').notNull(),
    // The cutoff that started the business day it was held in.
    businessDay: timestamp('business_day', { withTimezone: true }).notNull(),
    currency: text('currency').notNull(),
    discount: bigint('discount', { mode: 'bigint' }).notNull(),
    merchantShare: bigint('merchant_share', { mode: 'bigint' }).notNull(),
    status: text('status', { enum: promoCodeUseStatuses }).notNull().default('held'),
    heldAt: timestamp('held_at', { withTimezone: true }).notNull(),
    settledAt: timestamp('settled_at', { withTimezone: true }),
    // The code report (AP §9.11.1, slice 2.21d): the customer was new at
    // placing (no delivered order on any account of the number), and the
    // order ended delivered. Both: a new customer the code acquired (owner
    // decision 2026-11-16). Uses before 2.21d read false.
    newUser: boolean('new_user').notNull().default(false),
    delivered: boolean('delivered').notNull().default(false),
  },
  (table) => [
    uniqueIndex('promo_code_uses_order').on(table.orderId),
    index('promo_code_uses_code_day').on(table.codeId, table.businessDay),
    index('promo_code_uses_code_customer').on(table.codeId, table.customerAccountId),
    // «أكوادي» (slice 2.21d): a customer's uses of the last 30 days.
    index('promo_code_uses_customer_held').on(table.customerAccountId, table.heldAt),
    check('promo_code_uses_status_values', sql`${table.status} IN ('held', 'spent', 'returned')`),
    check(
      'promo_code_uses_money',
      sql`${table.discount} >= 0 AND ${table.merchantShare} >= 0 AND ${table.merchantShare} <= ${table.discount}`,
    ),
    check(
      'promo_code_uses_settled',
      sql`(${table.status} = 'held') = (${table.settledAt} IS NULL)`,
    ),
  ],
);

// «تعويض الزبون» (AP §6.4, §9.3.2; slice 2.22a): what a compensation is
// worth and where it stands. Issued: within the issuer's cap, or approved by
// OWN, with its personal code. Waiting: above the cap, in «طلبات الموافقة».
// Rejected by OWN.
export const compensationStatuses = ['issued', 'waiting', 'rejected'] as const;
export type CompensationStatus = (typeof compensationStatuses)[number];

// An amount, or a percentage with a maximum amount (AP §6.4).
export const compensationKinds = ['fixed_amount', 'percentage'] as const;
export type CompensationKind = (typeof compensationKinds)[number];

// A compensation of one customer, linked to one of their orders (AP §6.4:
// every compensation is). The order, the customer, the city and the admins
// are other modules' ids, plain values. Amounts are in `currency`, the
// city's base when requested; what counts against a cap is the amount, or a
// percentage's maximum. The reason is a copy of content's
// «تعويض الزبون» reason (owner decision 2026-11-17).
export const compensations = marketing.table(
  'compensations',
  {
    id: uuid('id')
      .primaryKey()
      .default(sql`uuidv7()`),
    cityId: uuid('city_id').notNull(),
    orderId: uuid('order_id').notNull(),
    orderNumber: bigint('order_number', { mode: 'bigint' }).notNull(),
    customerAccountId: uuid('customer_account_id').notNull(),
    kind: text('kind', { enum: compensationKinds }).notNull(),
    percentBp: integer('percent_bp'),
    amount: bigint('amount', { mode: 'bigint' }),
    maxDiscount: bigint('max_discount', { mode: 'bigint' }),
    currency: text('currency').notNull(),
    reasonCode: text('reason_code').notNull(),
    reasonLabel: text('reason_label').notNull(),
    note: text('note'),
    status: text('status', { enum: compensationStatuses }).notNull(),
    requestedBy: uuid('requested_by').notNull(),
    requestedAt: timestamp('requested_at', { withTimezone: true }).notNull(),
    // Architecture §5.3: the request's Idempotency-Key and a hash of it.
    idempotencyKey: text('idempotency_key').notNull(),
    requestHash: text('request_hash').notNull(),
    // OWN's approval or rejection of a request above the cap.
    decidedBy: uuid('decided_by'),
    decidedAt: timestamp('decided_at', { withTimezone: true }),
    codeId: uuid('code_id').references(() => promoCodes.id),
  },
  (table) => [
    uniqueIndex('compensations_key').on(table.requestedBy, table.idempotencyKey),
    index('compensations_order').on(table.orderId),
    index('compensations_city_status').on(table.cityId, table.status),
    index('compensations_code').on(table.codeId),
    check('compensations_kind_values', sql`${table.kind} IN ('fixed_amount', 'percentage')`),
    check(
      'compensations_value',
      sql`COALESCE(CASE ${table.kind}
            WHEN 'percentage' THEN ${table.percentBp} BETWEEN 1 AND 10000 AND ${table.amount} IS NULL
              AND ${table.maxDiscount} > 0
            ELSE ${table.amount} > 0 AND ${table.percentBp} IS NULL AND ${table.maxDiscount} IS NULL
          END, false)`,
    ),
    check('compensations_currency', sql`${table.currency} ~ '^[A-Z]{3}$'`),
    check(
      'compensations_note',
      sql`${table.note} IS NULL OR char_length(${table.note}) BETWEEN 1 AND 300`,
    ),
    check('compensations_status_values', sql`${table.status} IN ('issued', 'waiting', 'rejected')`),
    check(
      'compensations_state',
      sql`(${table.status} = 'issued') = (${table.codeId} IS NOT NULL)
          AND (${table.decidedBy} IS NULL) = (${table.decidedAt} IS NULL)
          AND (${table.status} <> 'waiting' OR ${table.decidedAt} IS NULL)
          AND (${table.status} <> 'rejected' OR ${table.decidedAt} IS NOT NULL)`,
    ),
  ],
);

// The late code (AP §8.3, §6.4, docs/domain/03; slice 2.22c): the personal
// code the system issues once per order still not delivered at the promised
// time + order.delivery_late_compensation_min. Outside every compensation cap
// and the order's cumulative total. The order, its customer and the city are
// other modules' ids, plain values. Never changed (no UPDATE).
export const lateCodes = marketing.table(
  'late_codes',
  {
    orderId: uuid('order_id').primaryKey(),
    cityId: uuid('city_id').notNull(),
    orderNumber: bigint('order_number', { mode: 'bigint' }).notNull(),
    customerAccountId: uuid('customer_account_id').notNull(),
    codeId: uuid('code_id')
      .notNull()
      .references(() => promoCodes.id),
    // The promised time the order was late against.
    promisedAt: timestamp('promised_at', { withTimezone: true }).notNull(),
    issuedAt: timestamp('issued_at', { withTimezone: true }).notNull(),
  },
  (table) => [uniqueIndex('late_codes_code').on(table.codeId)],
);

// AP §9.11.3 «أقسام الرئيسية» (slice 2.27b): the customer home's sections,
// per city. The six built-in ones, computed or filled elsewhere, and the
// custom ones the admin writes, each a title and hand-picked restaurants.
export const homeSectionKinds = [
  'banners',
  'categories',
  'nearest',
  'most_ordered',
  'new',
  'offers',
  'custom',
] as const;
export type HomeSectionKind = (typeof homeSectionKinds)[number];

// A built-in section has a row only once the panel orders or hides one of
// the city's sections; until then it reads as the default order, shown.
// A custom section removed keeps its row with removed_at.
export const homeSections = marketing.table(
  'home_sections',
  {
    id: uuid('id')
      .primaryKey()
      .default(sql`uuidv7()`),
    cityId: uuid('city_id').notNull(),
    kind: text('kind', { enum: homeSectionKinds }).notNull(),
    title: text('title'),
    // A custom section's restaurants in the admin's order (plain ids).
    restaurantIds: uuid('restaurant_ids')
      .array()
      .notNull()
      .default(sql`'{}'::uuid[]`),
    position: integer('position').notNull(),
    visible: boolean('visible').notNull().default(true),
    removedAt: timestamp('removed_at', { withTimezone: true }),
    updatedAt: timestamp('updated_at', { withTimezone: true }).notNull().defaultNow(),
  },
  (table) => [
    uniqueIndex('home_sections_built_in')
      .on(table.cityId, table.kind)
      .where(sql`${table.kind} <> 'custom'`),
    index('home_sections_city').on(table.cityId, table.position),
    check(
      'home_sections_kind_values',
      sql`${table.kind} IN ('banners', 'categories', 'nearest', 'most_ordered', 'new', 'offers', 'custom')`,
    ),
    check(
      'home_sections_custom',
      sql`CASE WHEN ${table.kind} = 'custom'
        THEN ${table.title} IS NOT NULL AND char_length(${table.title}) BETWEEN 1 AND 40
        ELSE ${table.title} IS NULL AND cardinality(${table.restaurantIds}) = 0 AND ${table.removedAt} IS NULL
      END`,
    ),
  ],
);

// AP §9.11.2 «البانرات», CU §8.1 (slice 2.27c): what a banner's tap opens.
// `restaurants` is the banner's own hand-picked list, opened under its title
// (owner decision 2026-11-18); `code` opens «أكوادي» on that code.
export const bannerTargets = ['restaurant', 'category', 'restaurants', 'code'] as const;
export type BannerTarget = (typeof bannerTargets)[number];

// A banner of the customer home, per city: its image (a key in public-media,
// 1200×500), title, target, place in the strip, the period it runs and the
// zones it shows in (none: all). Restaurants, categories, codes and zones are
// plain ids. Removed for good with removed_at, never deleted.
export const banners = marketing.table(
  'banners',
  {
    id: uuid('id')
      .primaryKey()
      .default(sql`uuidv7()`),
    cityId: uuid('city_id').notNull(),
    title: text('title').notNull(),
    imageKey: text('image_key').notNull(),
    target: text('target', { enum: bannerTargets }).notNull(),
    // `restaurant`: one; `restaurants`: the list in the admin's order.
    restaurantIds: uuid('restaurant_ids')
      .array()
      .notNull()
      .default(sql`'{}'::uuid[]`),
    categoryId: uuid('category_id'),
    codeId: uuid('code_id'),
    zoneIds: uuid('zone_ids')
      .array()
      .notNull()
      .default(sql`'{}'::uuid[]`),
    position: integer('position').notNull(),
    startsAt: timestamp('starts_at', { withTimezone: true }).notNull(),
    endsAt: timestamp('ends_at', { withTimezone: true }).notNull(),
    // The admin accounts (identity's ids, plain values).
    createdBy: uuid('created_by').notNull(),
    createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
    updatedBy: uuid('updated_by').notNull(),
    updatedAt: timestamp('updated_at', { withTimezone: true }).notNull().defaultNow(),
    removedAt: timestamp('removed_at', { withTimezone: true }),
  },
  (table) => [
    index('banners_city').on(table.cityId, table.position),
    check(
      'banners_target_values',
      sql`${table.target} IN ('restaurant', 'category', 'restaurants', 'code')`,
    ),
    check('banners_title', sql`char_length(${table.title}) BETWEEN 1 AND 60`),
    check('banners_period', sql`${table.startsAt} < ${table.endsAt}`),
    check(
      'banners_target',
      sql`CASE ${table.target}
        WHEN 'restaurant' THEN cardinality(${table.restaurantIds}) = 1 AND ${table.categoryId} IS NULL AND ${table.codeId} IS NULL
        WHEN 'restaurants' THEN cardinality(${table.restaurantIds}) BETWEEN 1 AND 30 AND ${table.categoryId} IS NULL AND ${table.codeId} IS NULL
        WHEN 'category' THEN cardinality(${table.restaurantIds}) = 0 AND ${table.categoryId} IS NOT NULL AND ${table.codeId} IS NULL
        ELSE cardinality(${table.restaurantIds}) = 0 AND ${table.categoryId} IS NULL AND ${table.codeId} IS NOT NULL
      END`,
    ),
  ],
);
