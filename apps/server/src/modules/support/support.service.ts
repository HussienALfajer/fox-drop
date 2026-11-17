import { createHash } from 'node:crypto';
import { Inject, Injectable } from '@nestjs/common';
import { and, desc, eq, inArray, type SQL, sql } from 'drizzle-orm';
import type { NodePgDatabase } from 'drizzle-orm/node-postgres';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { type AuditActor, type AuditRequestContext, AuditService } from '../audit/index.js';
import { CaptainsService } from '../captains/index.js';
import { ContentRefusedError, ContentService, NOTE_MAX } from '../content/index.js';
import { CustomersService } from '../customers/index.js';
import {
  AdminSessionsService,
  CaptainAccountsService,
  CustomerAccountsService,
} from '../identity/index.js';
import { MerchantsService } from '../merchants/index.js';
import { SettingsService } from '../settings/index.js';
import { TicketSync } from './ticket-sync.js';
import { noteKeys, ticketNotes, ticketNumbers, tickets, type TicketSource } from './schema.js';
import {
  afterFirstHandling,
  canSetStatus,
  isUrgent,
  type SlaKind,
  slaAtOpening,
  slaStop,
  TICKET_TYPE_LISTS,
  type TicketParty,
  type TicketStatus,
} from './tickets.js';

type Tx = Parameters<Parameters<NodePgDatabase['transaction']>[0]>[0];
type TicketRow = typeof tickets.$inferSelect;

// The order a ticket is opened on, as ordering reads it under the order's
// lock: its parties and whether it is still active.
export interface TicketOrder {
  id: string;
  cityId: string;
  number: bigint;
  active: boolean;
  customerId: string;
  restaurantId: string;
  captainId: string | null;
}

// Who acts on a ticket.
export interface TicketAdmin {
  accountId: string;
  actor: AuditActor;
  context: AuditRequestContext;
}

export interface OpenTicket {
  cityId: string;
  party: TicketParty;
  // The party's id: from the order when the ticket names one.
  partyId: string | null;
  typeCode: string;
  description: string;
}

export interface TicketNote {
  id: string;
  authorId: string;
  authorName: string | null;
  body: string;
  createdAt: Date;
}

export interface Ticket {
  id: string;
  cityId: string;
  number: bigint;
  source: TicketSource;
  party: TicketParty;
  partyId: string;
  partyName: string;
  orderId: string | null;
  orderNumber: bigint | null;
  orderActive: boolean;
  urgent: boolean;
  typeCode: string;
  typeLabel: string;
  description: string;
  status: TicketStatus;
  assigneeId: string | null;
  assigneeName: string | null;
  sla: { kind: SlaKind; startedAt: Date; dueAt: Date; stoppedAt: Date | null };
  openedBy: string;
  openedByName: string | null;
  openedAt: Date;
  updatedAt: Date;
}

export interface TicketFilters {
  status: TicketStatus | null;
  typeCode: string | null;
  assigneeId: string | null;
  source: TicketSource | null;
  breached: boolean;
}

export type TicketRefusal =
  | 'unknown_ticket'
  | 'unknown_party'
  | 'no_captain'
  | 'unknown_assignee'
  | 'invalid_status_change'
  | 'ticket_not_open'
  | 'idempotency_key_reused';

export class TicketRefusedError extends Error {
  constructor(
    readonly refusal: TicketRefusal,
    message: string,
  ) {
    super(message);
  }
}

// The list's length: the newest first.
const LISTED = 200;

// AP §9.9 (slice 2.23a): manual tickets, their list, page, notes, assignee
// and status, their SLA timer and the alert «تذكرة عاجلة». Ordering opens a
// ticket on an order under the order's lock and tells this module when an
// order ends (`orderEnded`), since this module cannot read orders.
@Injectable()
export class SupportService {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly audit: AuditService,
    private readonly content: ContentService,
    private readonly settings: SettingsService,
    private readonly sync: TicketSync,
    private readonly admins: AdminSessionsService,
    private readonly captains: CaptainsService,
    private readonly merchants: MerchantsService,
    private readonly customers: CustomersService,
    private readonly captainAccounts: CaptainAccountsService,
    private readonly customerAccounts: CustomerAccountsService,
  ) {}

  // The type lists of the three parties (AP Appendix B), active reasons only.
  async types(): Promise<Record<TicketParty, { code: string; label: string }[]>> {
    const [customer, restaurant, captain] = await Promise.all(
      (['customer', 'restaurant', 'captain'] as const).map(async (party) =>
        (await this.content.reasonsOf(TICKET_TYPE_LISTS[party]))
          .filter((reason) => reason.active)
          .map(({ code, label }) => ({ code, label })),
      ),
    );
    return { customer: customer!, restaurant: restaurant!, captain: captain! };
  }

  // Whom a ticket may be assigned to: the team that manages support.
  assignees(): Promise<{ id: string; name: string }[]> {
    return this.admins.teamWith('support.manage');
  }

  // A party of a city: a captain by a part of the name or the number, a
  // restaurant by a part of the name, a customer by the number only.
  async findParties(
    cityId: string,
    party: TicketParty,
    query: { text: string; phone: string | null },
    now: Date,
  ): Promise<{ id: string; name: string }[]> {
    switch (party) {
      case 'captain': {
        if (query.phone !== null) {
          const id = await this.captainAccounts.captainByPhone(query.phone);
          const found = id ? await this.captains.captain(id, now) : null;
          return found && found.cityId === cityId ? [{ id: found.id, name: found.name }] : [];
        }
        const found = await this.captains.findByName(cityId, query.text, 20);
        return found.map(({ id, name }) => ({ id, name }));
      }
      case 'restaurant': {
        const text = query.text.toLocaleLowerCase('ar');
        return (await this.merchants.restaurantIds(cityId))
          .filter((each) => each.nameAr.toLocaleLowerCase('ar').includes(text))
          .slice(0, 20)
          .map(({ id, nameAr }) => ({ id, name: nameAr }));
      }
      case 'customer': {
        if (query.phone === null) return [];
        const id = await this.customerAccounts.customerByPhone(query.phone);
        if (id === null) return [];
        const names = await this.customers.firstNames([id]);
        return [{ id, name: names.get(id) ?? '' }];
      }
    }
  }

  // «تذكرة يدوية» without an order, from the list. 400 unknown_reason;
  // 404 unknown_party; 422 idempotency_key_reused.
  async open(
    input: OpenTicket & { partyId: string },
    admin: TicketAdmin,
    idempotencyKey: string,
    now: Date,
  ): Promise<Ticket> {
    if (!(await this.partyInCity(input.cityId, input.party, input.partyId, now))) {
      throw new TicketRefusedError('unknown_party', 'no such party in the city');
    }
    const prepared = await this.prepare(input);
    const id = await this.database.db.transaction((tx) =>
      this.openIn(tx, prepared, null, admin, idempotencyKey, now),
    );
    return this.ticket(input.cityId, id);
  }

  // What an opening reads through the pool before its transaction: the type
  // (400 unknown_reason) and the timers' settings. A type that asks for its
  // text («أخرى») takes the ticket's description as it.
  async prepare(input: OpenTicket) {
    const list = TICKET_TYPE_LISTS[input.party];
    const chosen = await this.content
      .choose(list, { code: input.typeCode, note: null })
      .catch((error: unknown) => {
        if (error instanceof ContentRefusedError && error.refusal === 'reason_note_required') {
          return this.content.choose(list, {
            code: input.typeCode,
            note: input.description.trim().slice(0, NOTE_MAX),
          });
        }
        throw error;
      });
    const [firstResponseMinutes, resolutionHours] = await Promise.all([
      this.settings.get('support.first_response_active_min', { cityId: input.cityId }),
      this.settings.get('support.resolution_post_delivery_hours', { cityId: input.cityId }),
    ]);
    return { input, chosen, firstResponseMinutes, resolutionHours };
  }

  // The opening in the caller's transaction: ordering's holds the order's
  // lock, so the order is active exactly when the ticket says it is. Answers
  // the ticket's id. 409 no_captain (the order has none for a captain's
  // ticket); 422 idempotency_key_reused.
  async openIn(
    tx: Tx,
    prepared: Awaited<ReturnType<SupportService['prepare']>>,
    order: TicketOrder | null,
    admin: TicketAdmin,
    idempotencyKey: string,
    now: Date,
  ): Promise<string> {
    const { input, chosen } = prepared;
    const partyId = order === null ? input.partyId : orderParty(order, input.party);
    if (partyId === null) {
      throw new TicketRefusedError('no_captain', 'the order has no captain');
    }
    const description = input.description.trim();
    const requestHash = hashOf([order?.id ?? null, input.party, partyId, chosen.code, description]);
    await tx.execute(
      sql`SELECT pg_advisory_xact_lock(hashtext(${`support.ticket_key:${admin.accountId}:${idempotencyKey}`}))`,
    );
    const [replayed] = await tx
      .select({ id: tickets.id, requestHash: tickets.requestHash })
      .from(tickets)
      .where(
        and(eq(tickets.openedBy, admin.accountId), eq(tickets.idempotencyKey, idempotencyKey)),
      );
    if (replayed) {
      if (replayed.requestHash !== requestHash) {
        throw new TicketRefusedError(
          'idempotency_key_reused',
          'the key was used for another ticket',
        );
      }
      return replayed.id;
    }
    const active = order?.active ?? false;
    const sla = slaAtOpening({
      orderActive: active,
      openedAt: now,
      firstResponseMinutes: prepared.firstResponseMinutes,
      resolutionHours: prepared.resolutionHours,
    });
    const [{ number }] = (await tx
      .insert(ticketNumbers)
      .values({ cityId: input.cityId, lastNumber: 1n })
      .onConflictDoUpdate({
        target: ticketNumbers.cityId,
        set: { lastNumber: sql`${ticketNumbers.lastNumber} + 1` },
      })
      .returning({ number: ticketNumbers.lastNumber })) as [{ number: bigint }];
    const [row] = (await tx
      .insert(tickets)
      .values({
        cityId: input.cityId,
        number,
        source: 'manual',
        party: input.party,
        partyId,
        orderId: order?.id ?? null,
        orderNumber: order?.number ?? null,
        orderActive: active,
        typeCode: chosen.code,
        typeLabel: chosen.label,
        description,
        status: 'new',
        slaKind: sla.kind,
        slaDueAt: sla.dueAt,
        openedBy: admin.accountId,
        openedAt: now,
        updatedAt: now,
        idempotencyKey,
        requestHash,
      })
      .returning()) as [TicketRow];
    await this.audit.recordWrite(
      {
        actor: admin.actor,
        context: admin.context,
        cityId: input.cityId,
        action: 'ticket.open',
        target: { type: 'ticket', id: row.id },
        before: null,
        after: auditOf(row),
        reason: null,
      },
      tx,
    );
    await this.sync.changed(tx, row, now);
    return row.id;
  }

  // The city's tickets, newest first, with the filters of AP §9.9.2.
  async list(cityId: string, filters: TicketFilters, now: Date): Promise<Ticket[]> {
    const where: SQL[] = [eq(tickets.cityId, cityId)];
    if (filters.status !== null) where.push(eq(tickets.status, filters.status));
    if (filters.typeCode !== null) where.push(eq(tickets.typeCode, filters.typeCode));
    if (filters.assigneeId !== null) where.push(eq(tickets.assigneeId, filters.assigneeId));
    if (filters.source !== null) where.push(eq(tickets.source, filters.source));
    if (filters.breached) {
      where.push(sql`coalesce(${tickets.slaStoppedAt}, ${now}) >= ${tickets.slaDueAt}`);
    }
    const rows = await this.database.db
      .select()
      .from(tickets)
      .where(and(...where))
      .orderBy(desc(tickets.openedAt))
      .limit(LISTED);
    return this.views(rows);
  }

  // One ticket with its internal notes, oldest first. 404 unknown_ticket.
  async ticket(cityId: string, id: string): Promise<Ticket & { notes: TicketNote[] }> {
    const [row] = await this.database.db
      .select()
      .from(tickets)
      .where(and(eq(tickets.id, id), eq(tickets.cityId, cityId)));
    if (!row) throw new TicketRefusedError('unknown_ticket', 'no such ticket');
    const notes = await this.database.db
      .select()
      .from(ticketNotes)
      .where(eq(ticketNotes.ticketId, id))
      .orderBy(ticketNotes.createdAt, ticketNotes.id);
    const [view] = await this.views([row]);
    const names = await this.admins.names(notes.map((note) => note.authorId));
    return {
      ...view!,
      notes: notes.map((note) => ({
        id: note.id,
        authorId: note.authorId,
        authorName: names.get(note.authorId) ?? null,
        body: note.body,
        createdAt: note.createdAt,
      })),
    };
  }

  // AP §9.3.1 (slice 2.23a): an order's tickets, newest first.
  async forOrder(orderId: string): Promise<Ticket[]> {
    const rows = await this.database.db
      .select()
      .from(tickets)
      .where(eq(tickets.orderId, orderId))
      .orderBy(desc(tickets.openedAt));
    return this.views(rows);
  }

  // AP §9.2 «لها تذكرة»: the orders among these with an open ticket.
  async ordersWithOpenTickets(orderIds: readonly string[]): Promise<Set<string>> {
    if (orderIds.length === 0) return new Set();
    const rows = await this.database.db
      .selectDistinct({ orderId: tickets.orderId })
      .from(tickets)
      .where(
        and(
          inArray(tickets.orderId, [...new Set(orderIds)]),
          inArray(tickets.status, ['new', 'in_progress', 'waiting']),
        ),
      );
    return new Set(rows.flatMap((row) => (row.orderId === null ? [] : [row.orderId])));
  }

  // AP §4.5: an internal note. The first turns «جديدة» into «قيد المعالجة».
  // 404 unknown_ticket; 409 ticket_not_open; 422 idempotency_key_reused.
  async addNote(
    cityId: string,
    id: string,
    body: string,
    admin: TicketAdmin,
    idempotencyKey: string,
    now: Date,
  ): Promise<Ticket & { notes: TicketNote[] }> {
    const text = body.trim();
    const requestHash = hashOf([id, text]);
    await this.database.db.transaction(async (tx) => {
      const before = await lockTicket(tx, cityId, id);
      const [replayed] = await tx
        .select()
        .from(noteKeys)
        .where(and(eq(noteKeys.accountId, admin.accountId), eq(noteKeys.key, idempotencyKey)));
      if (replayed) {
        if (replayed.requestHash !== requestHash) {
          throw new TicketRefusedError(
            'idempotency_key_reused',
            'the key was used for another note',
          );
        }
        return;
      }
      if (!isOpenStatus(before.status)) {
        throw new TicketRefusedError('ticket_not_open', 'the ticket is no longer open');
      }
      const [note] = await tx
        .insert(ticketNotes)
        .values({ ticketId: id, authorId: admin.accountId, body: text, createdAt: now })
        .returning({ id: ticketNotes.id });
      await tx.insert(noteKeys).values({
        accountId: admin.accountId,
        key: idempotencyKey,
        requestHash,
        noteId: note!.id,
        createdAt: now,
      });
      const after = await this.move(tx, before, afterFirstHandling(before.status), {}, now);
      await this.audit.recordWrite(
        {
          actor: admin.actor,
          context: admin.context,
          cityId,
          action: 'ticket.note',
          target: { type: 'ticket', id },
          before: { status: before.status },
          after: { status: after.status, noteId: note!.id },
          reason: null,
        },
        tx,
      );
    });
    return this.ticket(cityId, id);
  }

  // «المسؤول عن التذكرة»: sets the assignee (null: none). The first turns
  // «جديدة» into «قيد المعالجة». Sets a value, so it takes no key.
  // 400 unknown_assignee; 404 unknown_ticket; 409 ticket_not_open.
  async assign(
    cityId: string,
    id: string,
    assigneeId: string | null,
    admin: TicketAdmin,
    now: Date,
  ): Promise<Ticket & { notes: TicketNote[] }> {
    if (assigneeId !== null) {
      const team = await this.assignees();
      if (!team.some((member) => member.id === assigneeId)) {
        throw new TicketRefusedError('unknown_assignee', 'not a member who manages support');
      }
    }
    await this.database.db.transaction(async (tx) => {
      const before = await lockTicket(tx, cityId, id);
      if (!isOpenStatus(before.status)) {
        throw new TicketRefusedError('ticket_not_open', 'the ticket is no longer open');
      }
      if (before.assigneeId === assigneeId) return;
      const next = assigneeId === null ? before.status : afterFirstHandling(before.status);
      const after = await this.move(tx, before, next, { assigneeId }, now);
      await this.audit.recordWrite(
        {
          actor: admin.actor,
          context: admin.context,
          cityId,
          action: 'ticket.assign',
          target: { type: 'ticket', id },
          before: { assigneeId: before.assigneeId, status: before.status },
          after: { assigneeId: after.assigneeId, status: after.status },
          reason: null,
        },
        tx,
      );
    });
    return this.ticket(cityId, id);
  }

  // «بانتظار رد» and back to «قيد المعالجة», by hand. 404 unknown_ticket;
  // 409 invalid_status_change.
  async setStatus(
    cityId: string,
    id: string,
    status: TicketStatus,
    admin: TicketAdmin,
    now: Date,
  ): Promise<Ticket & { notes: TicketNote[] }> {
    await this.database.db.transaction(async (tx) => {
      const before = await lockTicket(tx, cityId, id);
      if (!canSetStatus(before.status, status)) {
        throw new TicketRefusedError(
          'invalid_status_change',
          `${before.status} cannot become ${status} by hand`,
        );
      }
      await this.move(tx, before, status, {}, now);
      await this.audit.recordWrite(
        {
          actor: admin.actor,
          context: admin.context,
          cityId,
          action: 'ticket.status',
          target: { type: 'ticket', id },
          before: { status: before.status },
          after: { status },
          reason: null,
        },
        tx,
      );
    });
    return this.ticket(cityId, id);
  }

  // The status move, the timer's stop and the change's alert and broadcast.
  private async move(
    tx: Tx,
    before: TicketRow,
    status: TicketStatus,
    fields: Partial<Pick<TicketRow, 'assigneeId'>>,
    now: Date,
  ): Promise<TicketRow> {
    const [after] = (await tx
      .update(tickets)
      .set({ ...fields, status, slaStoppedAt: slaStop(before, status, now), updatedAt: now })
      .where(eq(tickets.id, before.id))
      .returning()) as [TicketRow];
    await this.sync.changed(tx, after, now);
    return after;
  }

  private async partyInCity(
    cityId: string,
    party: TicketParty,
    partyId: string,
    now: Date,
  ): Promise<boolean> {
    switch (party) {
      case 'captain':
        return (await this.captains.captain(partyId, now))?.cityId === cityId;
      case 'restaurant':
        return (await this.merchants.restaurantIds(cityId)).some((each) => each.id === partyId);
      case 'customer':
        return (await this.customers.firstNames([partyId])).has(partyId);
    }
  }

  private async views(rows: TicketRow[]): Promise<Ticket[]> {
    if (rows.length === 0) return [];
    const of = (party: TicketParty) => [
      ...new Set(rows.filter((row) => row.party === party).map((row) => row.partyId)),
    ];
    const [admins, captains, restaurants, customers] = await Promise.all([
      this.admins.names(
        rows.flatMap((row) => [row.openedBy, ...(row.assigneeId ? [row.assigneeId] : [])]),
      ),
      this.captains.names(of('captain')),
      this.merchants.names(of('restaurant')),
      this.customers.firstNames(of('customer')),
    ]);
    const partyName = (row: TicketRow) =>
      row.party === 'captain'
        ? captains.get(row.partyId)
        : row.party === 'restaurant'
          ? restaurants.get(row.partyId)?.nameAr
          : customers.get(row.partyId);
    return rows.map((row) => ({
      id: row.id,
      cityId: row.cityId,
      number: row.number,
      source: row.source,
      party: row.party,
      partyId: row.partyId,
      partyName: partyName(row) ?? '',
      orderId: row.orderId,
      orderNumber: row.orderNumber,
      orderActive: row.orderActive,
      urgent: isUrgent({ status: row.status, orderActive: row.orderActive }),
      typeCode: row.typeCode,
      typeLabel: row.typeLabel,
      description: row.description,
      status: row.status,
      assigneeId: row.assigneeId,
      assigneeName: row.assigneeId === null ? null : (admins.get(row.assigneeId) ?? null),
      sla: {
        kind: row.slaKind,
        startedAt: row.openedAt,
        dueAt: row.slaDueAt,
        stoppedAt: row.slaStoppedAt,
      },
      openedBy: row.openedBy,
      openedByName: admins.get(row.openedBy) ?? null,
      openedAt: row.openedAt,
      updatedAt: row.updatedAt,
    }));
  }
}

function isOpenStatus(status: TicketStatus): boolean {
  return status === 'new' || status === 'in_progress' || status === 'waiting';
}

function orderParty(order: TicketOrder, party: TicketParty): string | null {
  return party === 'customer'
    ? order.customerId
    : party === 'restaurant'
      ? order.restaurantId
      : order.captainId;
}

async function lockTicket(tx: Tx, cityId: string, id: string): Promise<TicketRow> {
  const [row] = await tx
    .select()
    .from(tickets)
    .where(and(eq(tickets.id, id), eq(tickets.cityId, cityId)))
    .for('update');
  if (!row) throw new TicketRefusedError('unknown_ticket', 'no such ticket');
  return row;
}

function auditOf(row: TicketRow) {
  return {
    number: row.number.toString(),
    party: row.party,
    partyId: row.partyId,
    orderNumber: row.orderNumber?.toString() ?? null,
    typeCode: row.typeCode,
    status: row.status,
    slaKind: row.slaKind,
  };
}

function hashOf(parts: unknown[]): string {
  return createHash('sha256')
    .update(JSON.stringify(parts, (_, value) => (typeof value === 'bigint' ? `${value}n` : value)))
    .digest('hex');
}
