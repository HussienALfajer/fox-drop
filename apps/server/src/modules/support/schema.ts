import { sql } from 'drizzle-orm';
import {
  bigint,
  boolean,
  check,
  index,
  jsonb,
  primaryKey,
  pgSchema,
  text,
  timestamp,
  uniqueIndex,
  uuid,
} from 'drizzle-orm/pg-core';
import {
  responsibleParties,
  slaKinds,
  ticketParties,
  ticketResolutions,
  ticketStatuses,
} from './tickets.js';

// Architecture §4.3: the support module owns the support schema.
export const support = pgSchema('support');

// Where a ticket came from (AP §9.9.1). 2.23a builds «تذكرة يدوية», 2.23b
// the restaurant's dispute after the pickup, 2.24a the customer app's
// «الإبلاغ عن مشكلة» (`customer_report`) and «أبلغ عن سعر مختلف»
// (`price_report`).
export const ticketSources = ['manual', 'pickup_dispute', 'customer_report', 'price_report'] as const;
export type TicketSource = (typeof ticketSources)[number];

const inList = (values: readonly string[]) =>
  sql.raw(values.map((value) => `'${value}'`).join(', '));

// AP §4.8: the ticket number, sequential per city, shown as `T-5521`.
export const ticketNumbers = support.table('ticket_numbers', {
  cityId: uuid('city_id').primaryKey(),
  lastNumber: bigint('last_number', { mode: 'bigint' }).notNull(),
});

// A ticket (AP §9.9; slice 2.23a). The party, the order and the accounts are
// other modules' ids, plain values (architecture §4.3).
export const tickets = support.table(
  'tickets',
  {
    id: uuid('id')
      .primaryKey()
      .default(sql`uuidv7()`),
    cityId: uuid('city_id').notNull(),
    number: bigint('number', { mode: 'bigint' }).notNull(),
    source: text('source', { enum: ticketSources }).notNull(),
    // Who the ticket is about, and who gets the resolution message (owner
    // decision 2026-11-17).
    party: text('party', { enum: ticketParties }).notNull(),
    partyId: uuid('party_id').notNull(),
    // The linked order, optional (owner decision 2026-11-17).
    orderId: uuid('order_id'),
    orderNumber: bigint('order_number', { mode: 'bigint' }),
    // Whether the linked order is still active: the priority «عاجلة» and the
    // alert «تذكرة عاجلة» follow it; ordering clears it when the order ends.
    orderActive: boolean('order_active').notNull(),
    // The type, from the party's list (AP Appendix B), as chosen.
    typeCode: text('type_code').notNull(),
    typeLabel: text('type_label').notNull(),
    // What the party said (the customer's note, AP §9.9.3).
    description: text('description').notNull(),
    status: text('status', { enum: ticketStatuses }).notNull(),
    assigneeId: uuid('assignee_id'),
    // AP §9.9.2: the timer chosen at the opening, from the opening.
    slaKind: text('sla_kind', { enum: slaKinds }).notNull(),
    slaDueAt: timestamp('sla_due_at', { withTimezone: true }).notNull(),
    slaStoppedAt: timestamp('sla_stopped_at', { withTimezone: true }),
    openedBy: uuid('opened_by').notNull(),
    openedAt: timestamp('opened_at', { withTimezone: true }).notNull(),
    updatedAt: timestamp('updated_at', { withTimezone: true }).notNull(),
    // The opening's Idempotency-Key, kept for good, and its request's hash.
    // A pickup dispute's ticket is opened by the restaurant's user
    // (`opened_by`) with the key `pickup_dispute:<dispute id>`.
    idempotencyKey: text('idempotency_key').notNull(),
    requestHash: text('request_hash').notNull(),
    // «سعر مختلف عن المحل»: the restaurant it is about (AP §9.9.1), no order.
    restaurantId: uuid('restaurant_id'),
    // «خلاف على دفعة الاستلام»: ordering's pickup_disputes row.
    pickupDisputeId: uuid('pickup_dispute_id'),
    // AP §9.9.3 (slice 2.23b): the resolution, the responsible party (a
    // general ticket's), the message sent to the party, for «تصحيح في
    // الحسابات» the lines the restaurant received as corrected and the
    // journals posted, who resolved it and when.
    resolution: text('resolution', { enum: ticketResolutions }),
    responsible: text('responsible', { enum: responsibleParties }),
    message: text('message'),
    correctedLines: jsonb('corrected_lines'),
    journalIds: jsonb('journal_ids'),
    resolvedBy: uuid('resolved_by'),
    resolvedAt: timestamp('resolved_at', { withTimezone: true }),
    // «إغلاق» without a resolution (owner decision 2026-11-17): the internal
    // reason, who and when.
    closeReason: text('close_reason'),
    closedBy: uuid('closed_by'),
    closedAt: timestamp('closed_at', { withTimezone: true }),
    // AP §8.10, §9.9.3 (slice 2.23c): a problem after a normal delivery. The
    // affected lines as chosen (position, name, quantity, value) and their
    // value `V`, the wrong change `M` the customer was short, in the order's
    // currency, and the compensation «كود تعويض» asked for (marketing's
    // row, issued or waiting for OWN).
    affectedLines: jsonb('affected_lines'),
    affectedValue: bigint('affected_value', { mode: 'bigint' }),
    shortAmount: bigint('short_amount', { mode: 'bigint' }),
    moneyCurrency: text('money_currency'),
    compensationId: uuid('compensation_id'),
    // The customer app's reports (CU §12.2, §9.5; slice 2.24a), set at the
    // opening and never changed: the lines the customer named (position,
    // name, quantity), the photos' keys in private-docs, and a price
    // report's item (its id and name as then) and the shop's price in the
    // base currency.
    reportedLines: jsonb('reported_lines'),
    photoKeys: jsonb('photo_keys'),
    reportedItemId: uuid('reported_item_id'),
    reportedItemName: text('reported_item_name'),
    shopPrice: bigint('shop_price', { mode: 'bigint' }),
    shopPriceCurrency: text('shop_price_currency'),
  },
  (table) => [
    uniqueIndex('tickets_city_number').on(table.cityId, table.number),
    uniqueIndex('tickets_opened_by_key').on(table.openedBy, table.idempotencyKey),
    index('tickets_city_opened').on(table.cityId, table.openedAt),
    index('tickets_order').on(table.orderId),
    check('tickets_source_values', sql`${table.source} IN (${inList(ticketSources)})`),
    check('tickets_party_values', sql`${table.party} IN (${inList(ticketParties)})`),
    check('tickets_status_values', sql`${table.status} IN (${inList(ticketStatuses)})`),
    check('tickets_sla_kind_values', sql`${table.slaKind} IN (${inList(slaKinds)})`),
    uniqueIndex('tickets_pickup_dispute').on(table.pickupDisputeId),
    check('tickets_resolution_values', sql`${table.resolution} IN (${inList(ticketResolutions)})`),
    check(
      'tickets_responsible_values',
      sql`${table.responsible} IN (${inList(responsibleParties)})`,
    ),
    check(
      'tickets_resolved',
      sql`(${table.status} = 'resolved') = (${table.resolution} IS NOT NULL AND ${table.message} IS NOT NULL AND ${table.resolvedBy} IS NOT NULL AND ${table.resolvedAt} IS NOT NULL) AND (${table.resolution} IS NOT NULL OR (${table.responsible} IS NULL AND ${table.correctedLines} IS NULL AND ${table.journalIds} IS NULL))`,
    ),
    check(
      'tickets_money',
      sql`(${table.affectedLines} IS NULL) = (${table.affectedValue} IS NULL) AND (${table.affectedValue} IS NULL OR ${table.affectedValue} > 0) AND (${table.shortAmount} IS NULL OR ${table.shortAmount} > 0) AND ((${table.affectedValue} IS NULL AND ${table.shortAmount} IS NULL) = (${table.moneyCurrency} IS NULL)) AND (${table.resolution} IS NOT NULL OR (${table.moneyCurrency} IS NULL AND ${table.compensationId} IS NULL)) AND (${table.compensationId} IS NULL OR ${table.resolution} = 'compensation_code')`,
    ),
    check(
      'tickets_closed',
      sql`(${table.status} = 'closed') = (${table.closeReason} IS NOT NULL AND ${table.closedBy} IS NOT NULL AND ${table.closedAt} IS NOT NULL)`,
    ),
    check(
      'tickets_pickup_dispute_source',
      sql`(${table.source} = 'pickup_dispute') = (${table.pickupDisputeId} IS NOT NULL) AND (${table.pickupDisputeId} IS NULL OR ${table.orderId} IS NOT NULL)`,
    ),
    check(
      'tickets_restaurant',
      sql`${table.restaurantId} IS NULL OR (${table.orderId} IS NULL AND ${table.party} = 'customer')`,
    ),
    // CU §12.2, Q17: one report per order.
    uniqueIndex('tickets_customer_report')
      .on(table.orderId)
      .where(sql`${table.source} = 'customer_report'`),
    // CU §9.5: a customer's price reports on a restaurant, by day.
    index('tickets_price_reports')
      .on(table.partyId, table.restaurantId, table.openedAt)
      .where(sql`${table.source} = 'price_report'`),
    check(
      'tickets_app_sources',
      sql`(${table.source} <> 'customer_report' OR (${table.party} = 'customer' AND ${table.orderId} IS NOT NULL)) AND (${table.source} <> 'price_report' OR ${table.typeCode} = 'price_difference')`,
    ),
    check(
      'tickets_price_report',
      sql`(${table.shopPrice} IS NULL) = (${table.shopPriceCurrency} IS NULL) AND (${table.shopPrice} IS NULL OR ${table.shopPrice} > 0) AND (${table.reportedItemId} IS NULL) = (${table.reportedItemName} IS NULL) AND ((${table.shopPrice} IS NULL AND ${table.reportedItemId} IS NULL) OR ${table.typeCode} = 'price_difference')`,
    ),
    check(
      'tickets_order',
      sql`(${table.orderId} IS NULL) = (${table.orderNumber} IS NULL) AND (${table.orderId} IS NOT NULL OR NOT ${table.orderActive})`,
    ),
  ],
);

// AP §4.5: the internal notes of a ticket, seen only by panel users. Never
// changed: the application role has no UPDATE.
export const ticketNotes = support.table(
  'ticket_notes',
  {
    id: uuid('id')
      .primaryKey()
      .default(sql`uuidv7()`),
    ticketId: uuid('ticket_id')
      .notNull()
      .references(() => tickets.id),
    authorId: uuid('author_id').notNull(),
    body: text('body').notNull(),
    createdAt: timestamp('created_at', { withTimezone: true }).notNull(),
  },
  (table) => [index('ticket_notes_ticket').on(table.ticketId, table.createdAt)],
);

// The notes' Idempotency-Keys (a note is a command that adds a row).
export const noteKeys = support.table(
  'note_keys',
  {
    accountId: uuid('account_id').notNull(),
    key: text('key').notNull(),
    requestHash: text('request_hash').notNull(),
    noteId: uuid('note_id').notNull(),
    createdAt: timestamp('created_at', { withTimezone: true }).notNull(),
  },
  (table) => [primaryKey({ columns: [table.accountId, table.key] })],
);
