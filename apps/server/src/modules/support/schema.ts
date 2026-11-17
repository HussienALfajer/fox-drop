import { sql } from 'drizzle-orm';
import {
  bigint,
  boolean,
  check,
  index,
  primaryKey,
  pgSchema,
  text,
  timestamp,
  uniqueIndex,
  uuid,
} from 'drizzle-orm/pg-core';
import { slaKinds, ticketParties, ticketStatuses } from './tickets.js';

// Architecture §4.3: the support module owns the support schema.
export const support = pgSchema('support');

// Where a ticket came from (AP §9.9.1). 2.23a builds «تذكرة يدوية»; the
// apps' sources and the pickup dispute join with their slices.
export const ticketSources = ['manual'] as const;
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
    idempotencyKey: text('idempotency_key').notNull(),
    requestHash: text('request_hash').notNull(),
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
