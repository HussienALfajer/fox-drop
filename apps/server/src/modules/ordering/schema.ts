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
  uniqueIndex,
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

// AP §8.2: the captain track, recorded apart from the order status. Null
// before the search starts and before any offer.
export const captainTracks = [
  'searching',
  'offered',
  'assigned',
  'at_merchant',
  'pickup_pending',
  'picked_up',
  'at_customer',
  'done',
] as const;

export const addressLabels = ['home', 'work', 'other'] as const;

// docs/domain/09, AP §8.1 (slice 2.8b): operations' cancellation's
// responsible party and the cash question's answer.
export const responsibleParties = ['restaurant', 'captain', 'customer', 'platform'] as const;
export const cashAnswers = ['returned', 'not_returned', 'not_paid'] as const;

// AP §8.9: every order that ends after pickup gets one.
export const orderOutcomes = [
  'normal',
  'free',
  'fake',
  'damaged',
  'wrong_refused',
  'failed_other',
] as const;

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
    // captains' pay table in force at placing; null only for an order placed
    // before slice 1.13, when placing did not need one.
    payTableId: uuid('pay_table_id'),
    // AP §9.6.3: placed at a test restaurant: no commission, the captain's pay
    // booked to platform.test_cost, and left out of the reports.
    testOrder: boolean('test_order').notNull().default(false),
    // fx's RateSnapshot, its bigints as strings (AP §8.6).
    rateSnapshot: jsonb('rate_snapshot').notNull(),
    // «سأدفع بـ» (CU §10.5); null for «لم أحدد».
    payIn: text('pay_in'),
    // CU §10.3: to the restaurant and the captain, up to 200 characters.
    note: text('note'),
    // RA §8.2–8.3, by the settings in force at placing; null for an order
    // placed before slice 1.9. The restaurant is late to answer from
    // accept_alert_at (the red card and «تأخرتم في الرد…»), and the
    // automatic cancellation job runs at auto_cancel_at (the countdown).
    acceptAlertAt: timestamp('accept_alert_at', { withTimezone: true }),
    autoCancelAt: timestamp('auto_cancel_at', { withTimezone: true }),
    estimateFromMin: smallint('estimate_from_min').notNull(),
    estimateToMin: smallint('estimate_to_min').notNull(),
    // The trip of the estimate shown at placing, in whole seconds rounded up
    // (docs/domain/03): the promised time at acceptance uses it (owner
    // decision 2026-11-06). Null for an order placed before slice 1.10.
    tripSeconds: integer('trip_seconds'),
    // And its motorbike distance in whole metres, for the captains eligible
    // for the trip (dispatch.max_distance_km.<vehicle>).
    tripMetres: integer('trip_metres'),
    // RA §8.5, AP §8.3, docs/domain/03: set together when the restaurant
    // accepts. The prep time chosen; the promised time; the search-start
    // moment of dispatch; operations' «تحضير متأخر» moment, prep_late_alert
    // past the prep time (owner decision 2026-11-06: its timer comes with the
    // operations board).
    acceptedAt: timestamp('accepted_at', { withTimezone: true }),
    prepMin: smallint('prep_min'),
    promisedAt: timestamp('promised_at', { withTimezone: true }),
    searchStartAt: timestamp('search_start_at', { withTimezone: true }),
    prepLateAlertAt: timestamp('prep_late_alert_at', { withTimezone: true }),
    // RA §8.8, AP §8.3: «الطلب جاهز», and operations' no-captain-after-ready
    // moment (its timer comes with the operations board).
    readyAt: timestamp('ready_at', { withTimezone: true }),
    noCaptainAlertAt: timestamp('no_captain_alert_at', { withTimezone: true }),
    // AP §8.2, §8.3, §9.12.6: the captain track; when the search started
    // (manual mode: «بحاجة لتعيين» while the track is searching), with
    // operations' «طلب بلا كابتن» moment dispatch.no_captain_alert_min after
    // it; the captain from assignment (the captains module's record) and
    // when. An offer's captain is the dispatch module's.
    captainTrack: text('captain_track', { enum: captainTracks }),
    searchStartedAt: timestamp('search_started_at', { withTimezone: true }),
    searchAlertAt: timestamp('search_alert_at', { withTimezone: true }),
    captainId: uuid('captain_id'),
    assignedAt: timestamp('assigned_at', { withTimezone: true }),
    // CA §9.2–9.3, RA §8.9: the captain's arrival at the restaurant (the
    // captain within captain.merchant_arrival_radius_m, or operations'
    // «تسجيل وصول الكابتن»), and the waiting alert's moment
    // captain.waiting_threshold_min after it (owner decision 2026-11-06: a
    // moment the reads show, AP §9.1.3).
    arrivedAtMerchantAt: timestamp('arrived_at_merchant_at', { withTimezone: true }),
    captainWaitingAlertAt: timestamp('captain_waiting_alert_at', { withTimezone: true }),
    // AP §8.1: the pickup, confirmed by the restaurant, automatically or by
    // operations, with custody.pay_merchant in its transaction. ready_by_pickup
    // is «لم يُضغط جاهز»: ready was recorded at the pickup (S8).
    pickedUpAt: timestamp('picked_up_at', { withTimezone: true }),
    readyByPickup: boolean('ready_by_pickup'),
    // CA §9.6: «وصلت» at the customer (status arrived, track at_customer).
    // Away from the pin beyond captain.customer_radius_m, the captain's reason
    // (CA Appendix C, K4), which covers the delivery too, with its text for
    // «أخرى»; operations see «تسليم بعيد عن العنوان» (AP §9.1.3).
    arrivedAtCustomerAt: timestamp('arrived_at_customer_at', { withTimezone: true }),
    // The reason's code in Content's captain_away list and its label as
    // chosen (owner decision 2026-11-07); ContentService checks the choice.
    awayReason: text('away_reason'),
    awayReasonLabel: text('away_reason_label'),
    awayNote: text('away_note'),
    // AP §8.1, §8.9: «تم التسليم» and the finished order's outcome; only
    // normal so far (the other outcomes come with «تحديد النتيجة»).
    deliveredAt: timestamp('delivered_at', { withTimezone: true }),
    outcome: text('outcome', { enum: orderOutcomes }),
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
    // AP §8.1: a cancelled order records why and whether food had been
    // prepared; merchant_auto_cancel is the automatic cancellation (§8.3),
    // an unanswered order of the restaurant.
    cancelledAt: timestamp('cancelled_at', { withTimezone: true }),
    cancelReason: text('cancel_reason'),
    // The text the customer sees for it (CU Appendix C), copied from Content
    // when the order is cancelled.
    cancelCustomerText: text('cancel_customer_text'),
    foodPrepared: boolean('food_prepared'),
    // AP §9.3.2 «إلغاء الطلب», docs/domain/09 (slice 2.8b): operations'
    // cancellation keeps the ops_cancel reason's label as chosen (the
    // restaurant's and the captain's «{السبب}», owner decision 2026-11-09),
    // the responsible party, the answer to «هل أعاد المطعم المبلغ للكابتن؟»,
    // and the food credit and the captain's compensation booked, in the base
    // currency's minor units. Only operations' path sets the label.
    cancelReasonLabel: text('cancel_reason_label'),
    cancelResponsible: text('cancel_responsible', { enum: responsibleParties }),
    cancelCash: text('cancel_cash', { enum: cashAnswers }),
    cancelMerchantCredit: bigint('cancel_merchant_credit', { mode: 'bigint' }),
    cancelCaptainCompensation: bigint('cancel_captain_compensation', { mode: 'bigint' }),
    // RA §8.14, §18: «حسناً» on a restaurant device (the user's app account
    // and the app installation) stops the ring on every device.
    cancelAcknowledgedAt: timestamp('cancel_acknowledged_at', { withTimezone: true }),
    cancelAcknowledgedBy: uuid('cancel_acknowledged_by'),
    cancelAcknowledgedDevice: text('cancel_acknowledged_device'),
    // CA §9.10: the captain's «حسناً» on the cancellation card.
    cancelCaptainSeenAt: timestamp('cancel_captain_seen_at', { withTimezone: true }),
    // RA §8.6, AP §9.3.2: a rejected order keeps when and why (the code of
    // Content's merchant_rejection list and its label as chosen), the text
    // the customer sees, filled with the items for «صنف غير متوفر» (CU
    // Appendix C), and those items' ids, which «اطلب بدون الأصناف غير
    // المتوفرة» leaves out (CU §11.9).
    rejectedAt: timestamp('rejected_at', { withTimezone: true }),
    rejectReason: text('reject_reason'),
    rejectReasonLabel: text('reject_reason_label'),
    rejectCustomerText: text('reject_customer_text'),
    rejectItemIds: jsonb('reject_item_ids'),
  },
  (table) => [
    primaryKey({ columns: [table.id, table.placedAt] }),
    check(
      'orders_cancellation',
      sql`(${table.status} = 'cancelled') = (${table.cancelledAt} IS NOT NULL AND ${table.cancelReason} IS NOT NULL AND ${table.foodPrepared} IS NOT NULL)`,
    ),
    check(
      'orders_ops_cancellation',
      sql`(${table.status} = 'cancelled' OR (${table.cancelReasonLabel} IS NULL AND ${table.cancelResponsible} IS NULL AND ${table.cancelCash} IS NULL AND ${table.cancelMerchantCredit} IS NULL AND ${table.cancelCaptainCompensation} IS NULL AND ${table.cancelAcknowledgedAt} IS NULL AND ${table.cancelCaptainSeenAt} IS NULL)) AND (${table.cancelResponsible} IS NULL OR ${table.cancelResponsible} IN ('restaurant', 'captain', 'customer', 'platform')) AND (${table.cancelCash} IS NULL OR ${table.cancelCash} IN ('returned', 'not_returned', 'not_paid')) AND (${table.cancelAcknowledgedAt} IS NULL) = (${table.cancelAcknowledgedBy} IS NULL) AND (${table.cancelAcknowledgedAt} IS NOT NULL OR ${table.cancelAcknowledgedDevice} IS NULL) AND ${table.cancelMerchantCredit} > 0 AND ${table.cancelCaptainCompensation} > 0`,
    ),
    check(
      'orders_rejection',
      sql`(${table.status} = 'rejected') = (${table.rejectedAt} IS NOT NULL AND ${table.rejectReason} IS NOT NULL AND ${table.rejectReasonLabel} IS NOT NULL AND ${table.rejectCustomerText} IS NOT NULL AND ${table.rejectItemIds} IS NOT NULL)`,
    ),
    index('orders_city_number').on(table.cityId, table.number),
    index('orders_customer_status').on(table.customerAccountId, table.status),
    index('orders_restaurant_status').on(table.restaurantId, table.status),
    index('orders_captain_status')
      .on(table.captainId, table.status)
      .where(sql`${table.captainId} IS NOT NULL`),
    index('orders_city_status').on(table.cityId, table.status),
    check(
      'orders_arrival',
      sql`(${table.arrivedAtMerchantAt} IS NULL) = (${table.captainWaitingAlertAt} IS NULL) AND (${table.captainTrack} NOT IN ('at_merchant', 'pickup_pending') OR ${table.arrivedAtMerchantAt} IS NOT NULL)`,
    ),
    check(
      'orders_captain_track_values',
      sql`${table.captainTrack} IS NULL OR ${table.captainTrack} IN ('searching', 'offered', 'assigned', 'at_merchant', 'pickup_pending', 'picked_up', 'at_customer', 'done')`,
    ),
    check(
      'orders_captain',
      sql`(${table.captainId} IS NULL) = (${table.assignedAt} IS NULL) AND (${table.captainId} IS NOT NULL) = (${table.captainTrack} IS NOT NULL AND ${table.captainTrack} NOT IN ('searching', 'offered')) AND (${table.searchStartedAt} IS NULL) = (${table.searchAlertAt} IS NULL) AND (${table.captainTrack} <> 'searching' OR ${table.searchStartedAt} IS NOT NULL)`,
    ),
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
      'orders_acceptance',
      sql`(${table.acceptedAt} IS NULL) = (${table.prepMin} IS NULL) AND (${table.acceptedAt} IS NULL) = (${table.promisedAt} IS NULL) AND (${table.acceptedAt} IS NULL) = (${table.searchStartAt} IS NULL) AND (${table.acceptedAt} IS NULL) = (${table.prepLateAlertAt} IS NULL) AND ${table.prepMin} > 0`,
    ),
    check(
      'orders_accepted_states',
      sql`${table.status} NOT IN ('accepted', 'ready', 'picked_up', 'arrived', 'delivered', 'failed') OR ${table.acceptedAt} IS NOT NULL`,
    ),
    check('orders_ready', sql`${table.status} <> 'ready' OR ${table.readyAt} IS NOT NULL`),
    check(
      'orders_pickup',
      sql`(${table.pickedUpAt} IS NULL) = (${table.readyByPickup} IS NULL) AND (${table.status} NOT IN ('picked_up', 'arrived', 'delivered', 'failed') OR (${table.pickedUpAt} IS NOT NULL AND ${table.readyAt} IS NOT NULL))`,
    ),
    check(
      'orders_customer_arrival',
      sql`(${table.status} <> 'arrived' OR ${table.arrivedAtCustomerAt} IS NOT NULL) AND (${table.captainTrack} IS DISTINCT FROM 'at_customer' OR ${table.arrivedAtCustomerAt} IS NOT NULL)`,
    ),
    check(
      'orders_away_reason',
      sql`(${table.awayReason} IS NOT NULL OR (${table.awayReasonLabel} IS NULL AND ${table.awayNote} IS NULL)) AND char_length(${table.awayNote}) BETWEEN 1 AND 200`,
    ),
    check(
      'orders_delivery',
      sql`(${table.status} = 'delivered') = (${table.deliveredAt} IS NOT NULL) AND (${table.status} IN ('delivered', 'failed')) = (${table.outcome} IS NOT NULL) AND (${table.outcome} IS NULL OR ${table.outcome} IN ('normal', 'free', 'fake', 'damaged', 'wrong_refused', 'failed_other'))`,
    ),
    check(
      'orders_trip',
      sql`(${table.tripSeconds} IS NULL) = (${table.tripMetres} IS NULL) AND ${table.tripSeconds} >= 0 AND ${table.tripMetres} >= 0`,
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
    // AP §9.3.3, CU §11.6 (slice 2.10a): operations' edits. The edit that
    // added the line («أُضيف»), the edit that removed it («حُذف»: the row
    // stays, out of the order's lines and money), and the quantity before an
    // edit first changed it (null while unchanged).
    addedByEdit: uuid('added_by_edit'),
    removedByEdit: uuid('removed_by_edit'),
    quantityBefore: smallint('quantity_before'),
  },
  (table) => [
    primaryKey({ columns: [table.orderId, table.orderPlacedAt, table.position] }),
    check('order_lines_quantity_before', sql`${table.quantityBefore} BETWEEN 1 AND 20`),
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
    // RA §18: the app installation a restaurant user ran the command on;
    // null for every other actor.
    actorDevice: text('actor_device'),
    reason: text('reason'),
    // The event's type, such as order.accepted or order.offered (the outbox's
    // type); null for an event written before slice 1.11.
    type: text('type'),
    // The captain the event is about: the offer's, or the one assigned.
    captainId: uuid('captain_id'),
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

// RA §8.10, AP §8.1: the captain's pickup requests. One is open at a time
// for an order; it closes confirmed (by the restaurant, automatically after
// order.pickup_confirm_timeout_sec, or by operations), rejected
// («المبلغ غير صحيح» with the lines received, «الطلب غير مكتمل») or voided.
// Operations confirming without an open request write a confirmed one.
export const pickupRequestStatuses = ['open', 'confirmed', 'rejected', 'voided'] as const;
export const pickupOutcomes = [
  'restaurant',
  'automatic',
  'operations',
  'amount_incorrect',
  'incomplete',
  'cancelled',
] as const;

export const pickupRequests = ordering.table(
  'pickup_requests',
  {
    id: uuid('id')
      .primaryKey()
      .default(sql`uuidv7()`),
    orderId: uuid('order_id').notNull(),
    orderPlacedAt: timestamp('order_placed_at', { withTimezone: true }).notNull(),
    cityId: uuid('city_id').notNull(),
    // The captains module's record.
    captainId: uuid('captain_id').notNull(),
    // The pickup payment when requested, set by the server (RA §8.10 item 2:
    // the full items value, D26), in the order's currency.
    currency: text('currency').notNull(),
    amount: bigint('amount', { mode: 'bigint' }).notNull(),
    // The currency lines the captain paid: [{ currency, amount }], the
    // amounts as strings of minor units.
    lines: jsonb('lines').notNull(),
    openedAt: timestamp('opened_at', { withTimezone: true }).notNull(),
    // The automatic confirmation's moment.
    confirmBy: timestamp('confirm_by', { withTimezone: true }).notNull(),
    status: text('status', { enum: pickupRequestStatuses }).notNull(),
    closedAt: timestamp('closed_at', { withTimezone: true }),
    outcome: text('outcome', { enum: pickupOutcomes }),
    // Who closed it: restaurant (an account and its app installation), admin
    // or system.
    closedByType: text('closed_by_type'),
    closedById: uuid('closed_by_id'),
    closedByDevice: text('closed_by_device'),
    // The lines booked at confirmation (operations may enter others, AP
    // §9.3.2), or the lines the restaurant says it received.
    bookedLines: jsonb('booked_lines'),
    receivedLines: jsonb('received_lines'),
    // Operations' reason for confirming on the restaurant's behalf.
    reason: text('reason'),
  },
  (table) => [
    foreignKey({
      columns: [table.orderId, table.orderPlacedAt],
      foreignColumns: [orders.id, orders.placedAt],
    }),
    index('pickup_requests_order').on(table.orderId, table.openedAt),
    uniqueIndex('pickup_requests_one_open_per_order')
      .on(table.orderId)
      .where(sql`${table.status} = 'open'`),
    check(
      'pickup_requests_status_values',
      sql`${table.status} IN ('open', 'confirmed', 'rejected', 'voided')`,
    ),
    check(
      'pickup_requests_outcome',
      sql`CASE ${table.status}
        WHEN 'open' THEN ${table.outcome} IS NULL AND ${table.closedAt} IS NULL
        WHEN 'confirmed' THEN ${table.outcome} IN ('restaurant', 'automatic', 'operations') AND ${table.closedAt} IS NOT NULL AND ${table.bookedLines} IS NOT NULL
        WHEN 'rejected' THEN ${table.outcome} IN ('amount_incorrect', 'incomplete') AND ${table.closedAt} IS NOT NULL
        ELSE ${table.outcome} = 'cancelled' AND ${table.closedAt} IS NOT NULL
      END`,
    ),
    check(
      'pickup_requests_received',
      sql`(${table.receivedLines} IS NOT NULL) = (${table.outcome} IS NOT DISTINCT FROM 'amount_incorrect')`,
    ),
    check('pickup_requests_amount', sql`${table.amount} >= 0`),
  ],
);

// RA §8.10 item 8: «المبلغ غير صحيح» within order.pickup_dispute_window_min
// after the pickup, one per order, with the lines the restaurant says it
// received. Owner decision 2026-11-06: recorded as a report linked to the
// order; its ticket and resolution (AP §9.9.3) come with the support module.
export const pickupDisputes = ordering.table(
  'pickup_disputes',
  {
    id: uuid('id')
      .primaryKey()
      .default(sql`uuidv7()`),
    orderId: uuid('order_id').notNull(),
    orderPlacedAt: timestamp('order_placed_at', { withTimezone: true }).notNull(),
    cityId: uuid('city_id').notNull(),
    pickupRequestId: uuid('pickup_request_id')
      .notNull()
      .references(() => pickupRequests.id),
    // The restaurant user (identity's merchant_accounts row) and the app
    // installation.
    accountId: uuid('account_id').notNull(),
    device: text('device').notNull(),
    receivedLines: jsonb('received_lines').notNull(),
    createdAt: timestamp('created_at', { withTimezone: true }).notNull(),
    status: text('status').notNull(),
  },
  (table) => [
    foreignKey({
      columns: [table.orderId, table.orderPlacedAt],
      foreignColumns: [orders.id, orders.placedAt],
    }),
    uniqueIndex('pickup_disputes_one_per_order').on(table.orderId),
    index('pickup_disputes_request').on(table.pickupRequestId),
    check('pickup_disputes_status_values', sql`${table.status} IN ('open')`),
  ],
);

// AP §9.3.2 «تعديل الوقت» (slice 2.9): one row per change, never changed:
// the minutes added and the promised time and prep time before and after,
// which the timeline shows (AP §9.3.1) and from which the captain's waiting
// counts the prep time as accepted (docs/domain/04).
export const timeChanges = ordering.table(
  'time_changes',
  {
    id: uuid('id')
      .primaryKey()
      .default(sql`uuidv7()`),
    orderId: uuid('order_id').notNull(),
    orderPlacedAt: timestamp('order_placed_at', { withTimezone: true }).notNull(),
    cityId: uuid('city_id').notNull(),
    at: timestamp('at', { withTimezone: true }).notNull(),
    adminId: uuid('admin_id').notNull(),
    addMin: smallint('add_min').notNull(),
    promisedBefore: timestamp('promised_before', { withTimezone: true }).notNull(),
    promisedAfter: timestamp('promised_after', { withTimezone: true }).notNull(),
    prepMinBefore: smallint('prep_min_before').notNull(),
    prepMinAfter: smallint('prep_min_after').notNull(),
  },
  (table) => [
    foreignKey({
      columns: [table.orderId, table.orderPlacedAt],
      foreignColumns: [orders.id, orders.placedAt],
    }),
    index('time_changes_order').on(table.orderId, table.orderPlacedAt),
    check(
      'time_changes_moved',
      sql`${table.addMin} > 0 AND ${table.promisedAfter} > ${table.promisedBefore} AND ${table.prepMinAfter} >= ${table.prepMinBefore}`,
    ),
  ],
);

// RA §8.12, AP §9.3.2 (slice 2.9): «صنف غير متوفر — اتصلوا بالزبون», the
// restaurant's report of items it ran out of after accepting, at most one
// open per order (a partial unique index). It blocks the pickup until it is
// closed: withdrawn by the restaurant («تراجع — الصنف متوفر»), closed by
// operations without an edit («إغلاق بلاغ صنف نفد», with their reason), or
// cleared by the order's cancellation or edit.
export const itemReports = ordering.table(
  'item_reports',
  {
    id: uuid('id')
      .primaryKey()
      .default(sql`uuidv7()`),
    orderId: uuid('order_id').notNull(),
    orderPlacedAt: timestamp('order_placed_at', { withTimezone: true }).notNull(),
    cityId: uuid('city_id').notNull(),
    // [{ itemId, until: 'tomorrow' | 'turned_back_on' }], the order's items.
    items: jsonb('items').notNull(),
    // A code of Content's item_unavailable_note list («يوجد بديل مشابه»,
    // «الكمية غير كافية»), with a copy of its label.
    note: text('note'),
    noteLabel: text('note_label'),
    // The restaurant user (identity's merchant_accounts row) and the app
    // installation.
    accountId: uuid('account_id').notNull(),
    device: text('device').notNull(),
    reportedAt: timestamp('reported_at', { withTimezone: true }).notNull(),
    closedAt: timestamp('closed_at', { withTimezone: true }),
    // withdrawn (the restaurant), closed (operations, with their reason),
    // cancelled (the order's cancellation) or edited (operations' edit, slice
    // 2.10a).
    closedHow: text('closed_how'),
    closedByType: text('closed_by_type'),
    closedById: uuid('closed_by_id'),
    closeReason: text('close_reason'),
  },
  (table) => [
    foreignKey({
      columns: [table.orderId, table.orderPlacedAt],
      foreignColumns: [orders.id, orders.placedAt],
    }),
    uniqueIndex('item_reports_one_open_per_order')
      .on(table.orderId)
      .where(sql`${table.closedAt} IS NULL`),
    index('item_reports_order').on(table.orderId, table.orderPlacedAt),
    check('item_reports_note_label', sql`(${table.note} IS NULL) = (${table.noteLabel} IS NULL)`),
    check(
      'item_reports_closed',
      sql`(${table.closedAt} IS NULL) = (${table.closedHow} IS NULL) AND (${table.closedHow} IS NULL OR ${table.closedHow} IN ('withdrawn', 'closed', 'cancelled', 'edited')) AND (${table.closedHow} IS NOT DISTINCT FROM 'closed') = (${table.closeReason} IS NOT NULL) AND (${table.closedHow} IS NULL OR (${table.closedByType} IS NOT NULL AND ${table.closedById} IS NOT NULL))`,
    ),
  ],
);

// AP §9.3.3, RA §8.13 (slice 2.10a): «تعديل الطلب» before the pickup, one
// row per edit: what changed (the restaurant's prompt and the panel's
// timeline), the money before and after, and, for items added to a ready
// order, the extra prep time and the times it moved. The restaurant
// acknowledges it with «اطلعت على التعديل» on any device; until then an edit
// that adds items rings, blocks the pickup request (RA §8.10) and raises
// «المطعم لم يؤكد التعديل» after order.merchant_accept_alert_min (AP §9.1.3).
// Only the acknowledgement columns ever change.
export const orderEdits = ordering.table(
  'order_edits',
  {
    id: uuid('id')
      .primaryKey()
      .default(sql`uuidv7()`),
    orderId: uuid('order_id').notNull(),
    orderPlacedAt: timestamp('order_placed_at', { withTimezone: true }).notNull(),
    cityId: uuid('city_id').notNull(),
    at: timestamp('at', { withTimezone: true }).notNull(),
    adminId: uuid('admin_id').notNull(),
    // The order's status when edited (placed, accepted or ready).
    status: text('status', { enum: orderStatuses }).notNull(),
    // [{ kind: 'added' | 'removed' | 'quantity', name, options: [name],
    // quantity, quantityBefore }], as order-edits.ts writes them.
    changes: jsonb('changes').notNull(),
    // Items added or a quantity raised: it rings and blocks the pickup.
    addsItems: boolean('adds_items').notNull(),
    currency: text('currency').notNull(),
    itemsValueBefore: bigint('items_value_before', { mode: 'bigint' }).notNull(),
    itemsValueAfter: bigint('items_value_after', { mode: 'bigint' }).notNull(),
    deliveryFeeBefore: bigint('delivery_fee_before', { mode: 'bigint' }).notNull(),
    deliveryFeeAfter: bigint('delivery_fee_after', { mode: 'bigint' }).notNull(),
    totalBefore: bigint('total_before', { mode: 'bigint' }).notNull(),
    totalAfter: bigint('total_after', { mode: 'bigint' }).notNull(),
    // A ready order back to accepted: the extra prep time operations entered,
    // the prep time and the promised time before and after.
    extraPrepMin: smallint('extra_prep_min'),
    prepMinBefore: smallint('prep_min_before'),
    prepMinAfter: smallint('prep_min_after'),
    promisedBefore: timestamp('promised_before', { withTimezone: true }),
    promisedAfter: timestamp('promised_after', { withTimezone: true }),
    // RA §8.13 «اطلعت على التعديل»: the restaurant user and the app
    // installation.
    acknowledgedAt: timestamp('acknowledged_at', { withTimezone: true }),
    acknowledgedBy: uuid('acknowledged_by'),
    acknowledgedDevice: text('acknowledged_device'),
  },
  (table) => [
    foreignKey({
      columns: [table.orderId, table.orderPlacedAt],
      foreignColumns: [orders.id, orders.placedAt],
    }),
    index('order_edits_order').on(table.orderId, table.orderPlacedAt),
    index('order_edits_unacknowledged')
      .on(table.orderId)
      .where(sql`${table.acknowledgedAt} IS NULL`),
    check('order_edits_status', sql`${table.status} IN ('placed', 'accepted', 'ready')`),
    check(
      'order_edits_money',
      sql`${table.itemsValueBefore} >= 0 AND ${table.itemsValueAfter} >= 0 AND ${table.deliveryFeeBefore} >= 0 AND ${table.deliveryFeeAfter} >= 0 AND ${table.totalBefore} >= 0 AND ${table.totalAfter} >= 0`,
    ),
    check(
      'order_edits_back_to_preparing',
      sql`(${table.extraPrepMin} IS NULL) = (${table.prepMinBefore} IS NULL) AND (${table.extraPrepMin} IS NULL) = (${table.prepMinAfter} IS NULL) AND (${table.extraPrepMin} IS NULL) = (${table.promisedBefore} IS NULL) AND (${table.extraPrepMin} IS NULL) = (${table.promisedAfter} IS NULL) AND ${table.extraPrepMin} > 0 AND (${table.extraPrepMin} IS NULL OR (${table.status} = 'ready' AND ${table.addsItems}))`,
    ),
    check(
      'order_edits_acknowledged',
      sql`(${table.acknowledgedAt} IS NULL) = (${table.acknowledgedBy} IS NULL) AND (${table.acknowledgedAt} IS NULL) = (${table.acknowledgedDevice} IS NULL)`,
    ),
  ],
);

// AP §8.6, CA §9.7–9.8, AP §9.3.2: the payment at the door, one per order,
// recorded by the captain at «تم التسليم» or by operations
// («تسجيل التسليم نيابة عن الكابتن»): the lines received and given back, their
// net in the base by the order's snapshot, any shortfall with its reason
// (K16, «نقص في التحصيل» until operations resolve it), and the captain's pay
// in its parts (CA §9.8, AP §8.5.5). The money itself is in the ledger.
export const collections = ordering.table(
  'collections',
  {
    id: uuid('id')
      .primaryKey()
      .default(sql`uuidv7()`),
    orderId: uuid('order_id').notNull(),
    orderPlacedAt: timestamp('order_placed_at', { withTimezone: true }).notNull(),
    cityId: uuid('city_id').notNull(),
    // The captains module's record.
    captainId: uuid('captain_id').notNull(),
    // The amount due (the order total) in the base currency.
    currency: text('currency').notNull(),
    amountDue: bigint('amount_due', { mode: 'bigint' }).notNull(),
    // [{ currency, amount }], the amounts as strings of minor units.
    receivedLines: jsonb('received_lines').notNull(),
    changeLines: jsonb('change_lines').notNull(),
    netReceived: bigint('net_received', { mode: 'bigint' }).notNull(),
    shortfall: bigint('shortfall', { mode: 'bigint' }).notNull(),
    // The code in Content's shortfall list and its label as chosen.
    shortfallReason: text('shortfall_reason'),
    shortfallReasonLabel: text('shortfall_reason_label'),
    shortfallNote: text('shortfall_note'),
    basePay: bigint('base_pay', { mode: 'bigint' }).notNull(),
    distancePay: bigint('distance_pay', { mode: 'bigint' }).notNull(),
    topUpPay: bigint('top_up_pay', { mode: 'bigint' }).notNull(),
    waitingPay: bigint('waiting_pay', { mode: 'bigint' }).notNull(),
    waitingMinutes: integer('waiting_minutes').notNull(),
    recordedAt: timestamp('recorded_at', { withTimezone: true }).notNull(),
    // captain (with the app installation) or admin.
    recordedByType: text('recorded_by_type').notNull(),
    recordedById: uuid('recorded_by_id').notNull(),
    recordedByDevice: text('recorded_by_device'),
    // Operations' reason (AP §9.3.2).
    reason: text('reason'),
  },
  (table) => [
    foreignKey({
      columns: [table.orderId, table.orderPlacedAt],
      foreignColumns: [orders.id, orders.placedAt],
    }),
    uniqueIndex('collections_one_per_order').on(table.orderId),
    index('collections_captain').on(table.captainId, table.recordedAt),
    index('collections_shortfalls')
      .on(table.cityId, table.recordedAt)
      .where(sql`${table.shortfall} > 0`),
    check(
      'collections_money',
      sql`${table.amountDue} >= 0 AND ${table.shortfall} >= 0 AND ${table.basePay} >= 0 AND ${table.distancePay} >= 0 AND ${table.topUpPay} >= 0 AND ${table.waitingPay} >= 0 AND ${table.waitingMinutes} >= 0`,
    ),
    check(
      'collections_shortfall',
      sql`(${table.shortfall} > 0) = (${table.shortfallReason} IS NOT NULL) AND (${table.shortfallReason} IS NOT NULL OR (${table.shortfallReasonLabel} IS NULL AND ${table.shortfallNote} IS NULL)) AND char_length(${table.shortfallNote}) BETWEEN 1 AND 200`,
    ),
    check(
      'collections_recorded_by',
      sql`(${table.recordedByType} = 'captain' AND ${table.reason} IS NULL) OR (${table.recordedByType} = 'admin' AND ${table.reason} IS NOT NULL AND ${table.recordedByDevice} IS NULL)`,
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

// Architecture §5.5, E4: the events that leave the server, written in the
// transaction of their change. The relay (slice 1.9) publishes them in id
// order to Centrifugo and push, at least once, and marks them published.
export const outbox = ordering.table(
  'outbox',
  {
    id: bigint('id', { mode: 'bigint' }).primaryKey().generatedAlwaysAsIdentity(),
    createdAt: timestamp('created_at', { withTimezone: true }).notNull(),
    cityId: uuid('city_id').notNull(),
    // Such as order.placed; the payload is its typed, versioned body.
    type: text('type').notNull(),
    orderId: uuid('order_id').notNull(),
    orderVersion: integer('order_version').notNull(),
    payload: jsonb('payload').notNull(),
    publishedAt: timestamp('published_at', { withTimezone: true }),
    // When its pushes were queued (architecture §8.1): the push relay turns
    // the event into each party's push, apart from the real-time relay, so a
    // Centrifugo outage never holds back a push or the other way round.
    pushQueuedAt: timestamp('push_queued_at', { withTimezone: true }),
  },
  (table) => [
    index('outbox_unpublished')
      .on(table.id)
      .where(sql`${table.publishedAt} IS NULL`),
    index('outbox_push_unqueued')
      .on(table.id)
      .where(sql`${table.pushQueuedAt} IS NULL`),
  ],
);

// AP §9.1.6, D7: a city's emergency stop «الإيقاف الطارئ», from its start
// to its end, kept after it ends as the history. One open stop per city.
export const emergencyStopEndKinds = ['manual', 'automatic'] as const;

export const emergencyStops = ordering.table(
  'emergency_stops',
  {
    id: uuid('id')
      .primaryKey()
      .default(sql`uuidv7()`),
    cityId: uuid('city_id').notNull(),
    startedAt: timestamp('started_at', { withTimezone: true }).notNull(),
    // The admin account that started it.
    startedBy: uuid('started_by').notNull(),
    internalReason: text('internal_reason').notNull(),
    // The message browsing customers see.
    browseMessage: text('browse_message').notNull(),
    // The delay notice for customers with an active order, with its
    // {السبب} placeholder.
    delayNotice: text('delay_notice').notNull(),
    // What fills {السبب}, such as «سوء الأحوال الجوية».
    customerReason: text('customer_reason').notNull(),
    // The optional automatic resume.
    resumeAt: timestamp('resume_at', { withTimezone: true }),
    endedAt: timestamp('ended_at', { withTimezone: true }),
    // null for the automatic resume.
    endedBy: uuid('ended_by'),
    endKind: text('end_kind', { enum: emergencyStopEndKinds }),
    // «الخدمة عادت» (CU §14 #19), when OPS sent it on resuming.
    serviceBackMessage: text('service_back_message'),
  },
  (table) => [
    uniqueIndex('emergency_stops_one_open')
      .on(table.cityId)
      .where(sql`${table.endedAt} IS NULL`),
    index('emergency_stops_city').on(table.cityId, table.startedAt),
    check(
      'emergency_stops_end',
      sql`(${table.endedAt} IS NULL AND ${table.endKind} IS NULL AND ${table.endedBy} IS NULL) OR (${table.endedAt} IS NOT NULL AND ${table.endKind} IS NOT NULL AND (${table.endKind} = 'manual') = (${table.endedBy} IS NOT NULL))`,
    ),
    check(
      'emergency_stops_service_back',
      sql`${table.serviceBackMessage} IS NULL OR ${table.endKind} = 'manual'`,
    ),
    check(
      'emergency_stops_resume_after_start',
      sql`${table.resumeAt} IS NULL OR ${table.resumeAt} > ${table.startedAt}`,
    ),
  ],
);

// AP §9.1.6 item 4, CU §10.6: each customer who opened checkout during the
// stop, once per stop: the attempts the dashboard counts, and who gets
// «الخدمة عادت» (CU §14 #19).
export const emergencyStopAttempts = ordering.table(
  'emergency_stop_attempts',
  {
    stopId: uuid('stop_id')
      .notNull()
      .references(() => emergencyStops.id),
    customerAccountId: uuid('customer_account_id').notNull(),
    at: timestamp('at', { withTimezone: true }).notNull(),
  },
  (table) => [primaryKey({ columns: [table.stopId, table.customerAccountId] })],
);
