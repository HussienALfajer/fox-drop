import { createHash } from 'node:crypto';
import { Inject, Injectable } from '@nestjs/common';
import { and, desc, eq, inArray, type SQL, sql } from 'drizzle-orm';
import type { NodePgDatabase } from 'drizzle-orm/node-postgres';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { type AuditActor, type AuditRequestContext, AuditService } from '../audit/index.js';
import { CaptainsService } from '../captains/index.js';
import {
  ContentRefusedError,
  ContentService,
  NOTE_MAX,
  NotificationTexts,
} from '../content/index.js';
import { CustomersService } from '../customers/index.js';
import {
  AdminSessionsService,
  CaptainAccountsService,
  CustomerAccountsService,
} from '../identity/index.js';
import {
  CompensationRefusedError,
  CompensationsService,
  type CompensationValue,
  type PreparedCompensation,
} from '../marketing/index.js';
import { MerchantsService } from '../merchants/index.js';
import { type PushRecipient, PushQueue } from '../notifications/index.js';
import { SettingsService } from '../settings/index.js';
import type { MoneyLine, PickupDisputeFacts, PickupDisputes } from './pickup-disputes.js';
import type {
  AffectedLine,
  StoredAffectedLine,
  TicketMoneyInput,
  TicketOrderFacts,
  TicketOrders,
} from './ticket-orders.js';
import { TicketSync } from './ticket-sync.js';
import { noteKeys, ticketNotes, ticketNumbers, tickets, type TicketSource } from './schema.js';
import {
  afterFirstHandling,
  canClose,
  canSetStatus,
  FIXED_TYPE_LABELS,
  isUrgent,
  managingPermission,
  moneyProblem,
  PICKUP_DISPUTE_TYPE,
  PRICE_DIFFERENCE_TYPE,
  resolutionProblem,
  type ResponsibleParty,
  ticketKind,
  type TicketKind,
  type TicketResolution,
  type SlaKind,
  slaAtOpening,
  slaStop,
  TICKET_TYPE_LISTS,
  type TicketParty,
  WRONG_CHANGE_TYPE,
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

// Who acts on a ticket, with what they may do (AP §6.3: a pickup dispute is
// resolved with support.resolve_pickup_dispute).
export interface TicketAdmin {
  accountId: string;
  actor: AuditActor;
  context: AuditRequestContext;
  permissions: readonly string[];
  // The roles decide a compensation code's cap (AP §6.4).
  roles: readonly string[];
}

export interface OpenTicket {
  cityId: string;
  party: TicketParty;
  // The party's id: from the order when the ticket names one.
  partyId: string | null;
  typeCode: string;
  description: string;
  // «سعر مختلف عن المحل»: the restaurant it is about; null for every other.
  restaurantId: string | null;
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
  kind: TicketKind;
  restaurantId: string | null;
  restaurantName: string | null;
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
  resolution: {
    code: TicketResolution;
    responsible: ResponsibleParty | null;
    message: string;
    correctedLines: MoneyLine[] | null;
    resolvedAt: Date;
    resolvedByName: string | null;
    // AP §8.10 (slice 2.23c): the affected lines and V, the wrong change M,
    // in `moneyCurrency`, and the compensation asked (marketing's id).
    affectedLines: StoredAffectedLine[] | null;
    affectedValue: bigint | null;
    shortAmount: bigint | null;
    moneyCurrency: string | null;
    compensationId: string | null;
  } | null;
  closure: { reason: string; closedAt: Date; closedByName: string | null } | null;
}

export interface TicketResolutionInput {
  resolution: TicketResolution;
  responsible: ResponsibleParty | null;
  message: string;
  // «تصحيح في الحسابات»: the lines the restaurant received, as corrected.
  lines: MoneyLine[] | null;
  // AP §8.10 (slice 2.23c): the affected lines, the wrong change M, and
  // «كود تعويض»'s value and reason (the wrong change's code is M itself).
  affected: AffectedLine[];
  shortAmount: bigint | null;
  code: { value: CompensationValue; reason: { code: string; note: string | null } } | null;
}

// The money a resolution's preview asks (slice 2.23c).
export interface TicketMoneyQuestion {
  responsible: ResponsibleParty;
  affected: AffectedLine[];
  shortAmount: bigint | null;
  code: boolean;
}

export type TicketPage = Ticket & {
  notes: TicketNote[];
  pickupDispute: PickupDisputeFacts | null;
  // A customer's general ticket on an order (slice 2.23c): the order's
  // lines, money and the captain's record at the door, for the affected
  // items, M and the code.
  order: TicketOrderFacts | null;
};

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
  | 'idempotency_key_reused'
  | 'invalid_restaurant'
  | 'invalid_resolution'
  | 'responsible_required'
  | 'lines_required'
  | 'invalid_lines'
  | 'no_difference'
  | 'not_pickup_dispute'
  | 'order_required'
  | 'not_delivered'
  | 'amount_required'
  | 'value_required'
  | 'invalid_affected'
  | 'invalid_value'
  | 'no_base_currency'
  | 'currency_changed'
  | 'forbidden';

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

// How long the resolution message's push may wait for a phone that is off.
const MESSAGE_PUSH_MS = 24 * 3_600_000;

const PUSH_TEMPLATES: Record<TicketParty, string> = {
  customer: 'customer.ticket_resolved',
  restaurant: 'merchant.ticket_resolved',
  captain: 'captain.ticket_resolved',
};

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
    private readonly pushes: PushQueue,
    private readonly texts: NotificationTexts,
    private readonly compensations: CompensationsService,
  ) {}

  private disputes: PickupDisputes | null = null;

  // Ordering registers what it reads and posts of a pickup dispute.
  usePickupDisputes(disputes: PickupDisputes): void {
    this.disputes = disputes;
  }

  private pickupDisputes(): PickupDisputes {
    if (this.disputes === null) throw new Error('no pickup disputes registered');
    return this.disputes;
  }

  private orders: TicketOrders | null = null;

  // Ordering registers what it reads and posts of a ticket's order (slice
  // 2.23c).
  useTicketOrders(orders: TicketOrders): void {
    this.orders = orders;
  }

  private ticketOrders(): TicketOrders {
    if (this.orders === null) throw new Error('no ticket orders registered');
    return this.orders;
  }

  // Whether the ticket's page reads its order's money: a customer's general
  // ticket on an order.
  private readsOrder(row: TicketRow): row is TicketRow & { orderId: string } {
    return (
      row.orderId !== null && row.party === 'customer' && ticketKind(row.typeCode) === 'general'
    );
  }

  // The type lists of the three parties (AP Appendix B), active reasons only.
  async types(): Promise<Record<TicketParty, { code: string; label: string }[]>> {
    const [customer, restaurant, captain] = await Promise.all(
      (['customer', 'restaurant', 'captain'] as const).map(async (party) =>
        (await this.content.reasonsOf(TICKET_TYPE_LISTS[party]))
          .filter((reason) => reason.active)
          .map(({ code, label }) => ({ code, label })),
      ),
    );
    // «سعر مختلف عن المحل» (AP §9.9.1) is a customer's ticket outside the
    // Content list, opened by hand until the app's report (owner decision
    // 2026-11-17).
    return {
      customer: [
        ...customer!,
        { code: PRICE_DIFFERENCE_TYPE, label: FIXED_TYPE_LABELS[PRICE_DIFFERENCE_TYPE] },
      ],
      restaurant: restaurant!,
      captain: captain!,
    };
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
    // A repeat answers its ticket before any refusal (a type deactivated
    // since, a party gone).
    const replayed = await this.replayed(admin.accountId, idempotencyKey, openingHash(input, null));
    if (replayed !== null) return this.ticket(input.cityId, replayed);
    if (!(await this.partyInCity(input.cityId, input.party, input.partyId, now))) {
      throw new TicketRefusedError('unknown_party', 'no such party in the city');
    }
    const prepared = await this.prepare(input);
    if (
      input.restaurantId !== null &&
      !(await this.merchants.restaurantIds(input.cityId)).some(
        (each) => each.id === input.restaurantId,
      )
    ) {
      throw new TicketRefusedError('unknown_party', 'no such restaurant in the city');
    }
    const id = await this.database.db.transaction((tx) =>
      this.openIn(tx, prepared, null, admin, idempotencyKey, now),
    );
    return this.ticket(input.cityId, id);
  }

  // The ticket an opening's key already opened, null for a new key; the key
  // with another request is 422 idempotency_key_reused.
  async replayed(
    accountId: string,
    idempotencyKey: string,
    requestHash: string,
  ): Promise<string | null> {
    const [row] = await this.database.db
      .select({ id: tickets.id, requestHash: tickets.requestHash })
      .from(tickets)
      .where(and(eq(tickets.openedBy, accountId), eq(tickets.idempotencyKey, idempotencyKey)));
    if (!row) return null;
    if (row.requestHash !== requestHash) {
      throw new TicketRefusedError('idempotency_key_reused', 'the key was used for another ticket');
    }
    return row.id;
  }

  // What an opening reads through the pool before its transaction: the type
  // (400 unknown_reason) and the timers' settings. A type that asks for its
  // text («أخرى») takes the ticket's description as it.
  async prepare(input: OpenTicket) {
    const list = TICKET_TYPE_LISTS[input.party];
    // «سعر مختلف عن المحل»: a customer's, naming the restaurant (400
    // invalid_restaurant otherwise); no other type names one.
    const priceDifference = input.typeCode === PRICE_DIFFERENCE_TYPE;
    if (
      priceDifference !== (input.restaurantId !== null) ||
      (priceDifference && input.party !== 'customer')
    ) {
      throw new TicketRefusedError(
        'invalid_restaurant',
        'a price difference names its restaurant, and only it',
      );
    }
    const chosen = priceDifference
      ? { code: PRICE_DIFFERENCE_TYPE, label: FIXED_TYPE_LABELS[PRICE_DIFFERENCE_TYPE] }
      : await this.content
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
    return { input, chosen, ...(await this.timers(input.cityId)) };
  }

  private async timers(cityId: string) {
    const [firstResponseMinutes, resolutionHours] = await Promise.all([
      this.settings.get('support.first_response_active_min', { cityId }),
      this.settings.get('support.resolution_post_delivery_hours', { cityId }),
    ]);
    return { firstResponseMinutes, resolutionHours };
  }

  // What the pickup dispute's ticket reads before ordering's transaction.
  preparePickupDispute(cityId: string) {
    return this.timers(cityId);
  }

  // RA §8.10 item 8, AP §9.9.1 (slice 2.23b): the restaurant's «المبلغ غير
  // صحيح» after the pickup opens «خلاف على دفعة الاستلام», always urgent and
  // linked to the order, in ordering's transaction under the order's lock.
  // The restaurant's user opens it; its key is the dispute's.
  async openPickupDisputeIn(
    tx: Tx,
    timers: Awaited<ReturnType<SupportService['preparePickupDispute']>>,
    input: { order: TicketOrder; disputeId: string; openedBy: string; device: string },
    now: Date,
  ): Promise<string> {
    const label = FIXED_TYPE_LABELS[PICKUP_DISPUTE_TYPE];
    return this.insertTicket(
      tx,
      {
        cityId: input.order.cityId,
        source: 'pickup_dispute',
        party: 'restaurant',
        partyId: input.order.restaurantId,
        order: input.order,
        typeCode: PICKUP_DISPUTE_TYPE,
        typeLabel: label,
        description: '',
        restaurantId: null,
        pickupDisputeId: input.disputeId,
        openedBy: input.openedBy,
        idempotencyKey: `pickup_dispute:${input.disputeId}`,
        requestHash: '',
      },
      timers,
      {
        actor: { type: 'merchant', id: input.openedBy, role: null },
        context: { ipAddress: null, device: input.device },
      },
      now,
    );
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
    // A price difference is linked to a restaurant, never an order.
    if (order !== null && input.restaurantId !== null) {
      throw new TicketRefusedError('invalid_restaurant', 'a price difference has no order');
    }
    const partyId = order === null ? input.partyId : orderParty(order, input.party);
    if (partyId === null) {
      throw new TicketRefusedError('no_captain', 'the order has no captain');
    }
    const requestHash = openingHash(input, order?.id ?? null);
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
    return this.insertTicket(
      tx,
      {
        cityId: input.cityId,
        source: 'manual',
        party: input.party,
        partyId,
        order,
        typeCode: chosen.code,
        typeLabel: chosen.label,
        description: input.description.trim(),
        restaurantId: input.restaurantId,
        pickupDisputeId: null,
        openedBy: admin.accountId,
        idempotencyKey,
        requestHash,
      },
      prepared,
      { actor: admin.actor, context: admin.context },
      now,
    );
  }

  // The new ticket: its number, row, audit line and alert.
  private async insertTicket(
    tx: Tx,
    fields: {
      cityId: string;
      source: TicketSource;
      party: TicketParty;
      partyId: string;
      order: TicketOrder | null;
      typeCode: string;
      typeLabel: string;
      description: string;
      restaurantId: string | null;
      pickupDisputeId: string | null;
      openedBy: string;
      idempotencyKey: string;
      requestHash: string;
    },
    timers: { firstResponseMinutes: number; resolutionHours: number },
    by: { actor: AuditActor; context: AuditRequestContext | null },
    now: Date,
  ): Promise<string> {
    const { order } = fields;
    const active = order?.active ?? false;
    const sla = slaAtOpening({
      orderActive: active,
      openedAt: now,
      firstResponseMinutes: timers.firstResponseMinutes,
      resolutionHours: timers.resolutionHours,
    });
    const [{ number }] = (await tx
      .insert(ticketNumbers)
      .values({ cityId: fields.cityId, lastNumber: 1n })
      .onConflictDoUpdate({
        target: ticketNumbers.cityId,
        set: { lastNumber: sql`${ticketNumbers.lastNumber} + 1` },
      })
      .returning({ number: ticketNumbers.lastNumber })) as [{ number: bigint }];
    const [row] = (await tx
      .insert(tickets)
      .values({
        cityId: fields.cityId,
        number,
        source: fields.source,
        party: fields.party,
        partyId: fields.partyId,
        orderId: order?.id ?? null,
        orderNumber: order?.number ?? null,
        orderActive: active,
        typeCode: fields.typeCode,
        typeLabel: fields.typeLabel,
        description: fields.description,
        status: 'new',
        slaKind: sla.kind,
        slaDueAt: sla.dueAt,
        openedBy: fields.openedBy,
        openedAt: now,
        updatedAt: now,
        idempotencyKey: fields.idempotencyKey,
        requestHash: fields.requestHash,
        restaurantId: fields.restaurantId,
        pickupDisputeId: fields.pickupDisputeId,
      })
      .returning()) as [TicketRow];
    await this.audit.recordWrite(
      {
        actor: by.actor,
        context: by.context ?? { ipAddress: null, device: null },
        cityId: fields.cityId,
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
  // A pickup dispute's adds what ordering reads of it (AP §9.9.3).
  async ticket(cityId: string, id: string): Promise<TicketPage> {
    const row = await this.row(cityId, id);
    const notes = await this.database.db
      .select()
      .from(ticketNotes)
      .where(eq(ticketNotes.ticketId, id))
      .orderBy(ticketNotes.createdAt, ticketNotes.id);
    const [[view], names, pickupDispute, order] = await Promise.all([
      this.views([row]),
      this.admins.names(notes.map((note) => note.authorId)),
      row.pickupDisputeId === null
        ? Promise.resolve(null)
        : this.pickupDisputes().facts(row.pickupDisputeId),
      this.readsOrder(row) ? this.ticketOrders().facts(row.orderId) : Promise.resolve(null),
    ]);
    return {
      ...view!,
      pickupDispute,
      order,
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
  ): Promise<TicketPage> {
    const text = body.trim();
    const requestHash = hashOf([id, text]);
    await this.database.db.transaction(async (tx) => {
      // The key is the account's across tickets: one use of it at a time.
      await tx.execute(
        sql`SELECT pg_advisory_xact_lock(hashtext(${`support.note_key:${admin.accountId}:${idempotencyKey}`}))`,
      );
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
  ): Promise<TicketPage> {
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
  ): Promise<TicketPage> {
    await this.database.db.transaction(async (tx) => {
      const before = await lockTicket(tx, cityId, id);
      if (!isOpenStatus(before.status)) {
        throw new TicketRefusedError('ticket_not_open', 'the ticket is no longer open');
      }
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

  // AP §9.9.3 «Preview» of «تصحيح في الحسابات»: the entries the lines the
  // restaurant received would post. 404 unknown_ticket; 409
  // not_pickup_dispute, ticket_not_open; 400 invalid_lines, no_difference.
  async previewCorrection(cityId: string, id: string, lines: MoneyLine[], now: Date) {
    const row = await this.row(cityId, id);
    if (row.pickupDisputeId === null) {
      throw new TicketRefusedError('not_pickup_dispute', 'not a pickup-dispute ticket');
    }
    if (!isOpenStatus(row.status)) {
      throw new TicketRefusedError('ticket_not_open', 'the ticket is no longer open');
    }
    return this.pickupDisputes().preview(row.pickupDisputeId, lines, now);
  }

  // AP §8.10, §9.9.3 «previewed before the ticket is resolved» (slice
  // 2.23c): the entries a problem after delivery would post for this
  // responsible party, affected lines and M. Writes nothing. 400
  // invalid_resolution, order_required, not_delivered, amount_required,
  // invalid_affected; 409 ticket_not_open; 404 unknown_ticket.
  async previewMoney(cityId: string, id: string, question: TicketMoneyQuestion) {
    const row = await this.row(cityId, id);
    if (!isOpenStatus(row.status)) {
      throw new TicketRefusedError('ticket_not_open', 'the ticket is no longer open');
    }
    const { money } = await this.checkMoney(row, {
      resolution: question.code ? 'compensation_code' : 'none_explained',
      responsible: question.responsible,
      affected: question.affected,
      shortAmount: question.shortAmount,
      // The value is the dialog's to fill; the preview's entries do not
      // depend on it.
      codeValue: question.code && row.typeCode !== WRONG_CHANGE_TYPE,
    });
    if (money === null) {
      return {
        currency: null,
        affectedValue: 0n,
        merchantDebit: 0n,
        captainCharge: 0n,
        entries: [],
      };
    }
    return this.ticketOrders().preview(row.orderId!, money);
  }

  // moneyProblem's checks with the order's facts, and the money to post
  // (null when the resolution has none).
  private async checkMoney(
    row: TicketRow,
    input: {
      resolution: TicketResolution;
      responsible: ResponsibleParty | null;
      affected: AffectedLine[];
      shortAmount: bigint | null;
      codeValue: boolean;
    },
  ): Promise<{ facts: TicketOrderFacts | null; money: TicketMoneyInput | null }> {
    const facts = this.readsOrder(row) ? await this.ticketOrders().facts(row.orderId) : null;
    const problem = moneyProblem({
      kind: ticketKind(row.typeCode),
      party: row.party,
      typeCode: row.typeCode,
      resolution: input.resolution,
      responsible: input.responsible,
      hasOrder: facts !== null,
      deliveredNormally: facts?.deliveredNormally ?? false,
      affectedLines: input.affected.length,
      shortAmount: input.shortAmount,
      codeValue: input.codeValue,
    });
    if (problem !== null) throw new TicketRefusedError(problem, `the money is ${problem}`);
    if (input.shortAmount !== null && input.shortAmount <= 0n) {
      throw new TicketRefusedError('invalid_value', 'M is above zero');
    }
    const money =
      facts !== null &&
      input.responsible !== null &&
      (input.affected.length > 0 || input.shortAmount !== null)
        ? {
            responsible: input.responsible,
            affected: input.affected,
            wrongChange:
              input.shortAmount === null
                ? null
                : { amount: input.shortAmount, code: input.resolution === 'compensation_code' },
          }
        : null;
    return { facts, money };
  }

  // «حل التذكرة» (AP §9.9.3; owner decision 2026-11-17): the resolution, the
  // responsible party of a general ticket and the message; the ticket
  // becomes «محلولة», its timer stops, «تصحيح في الحسابات» posts its entries
  // and the message goes to the ticket's party at once, all in one
  // transaction. A pickup dispute needs support.resolve_pickup_dispute (OWN,
  // OPS, FIN), every other ticket support.manage. A repeat is refused by
  // what the first changed (409 ticket_not_open), so it takes no key.
  // A problem after delivery (slice 2.23c, owner decisions 2026-11-17) posts
  // the responsible party's entries for V or M in the same transaction, and
  // «كود تعويض» asks marketing's compensation there: issued within the
  // resolver's cap (the wrong change's uncapped), else waiting for OWN while
  // the ticket is resolved all the same.
  // 400 invalid_resolution, responsible_required, lines_required,
  // invalid_lines, no_difference, order_required, not_delivered,
  // amount_required, value_required, invalid_affected, invalid_value,
  // unknown_reason; 403 forbidden; 404 unknown_ticket; 409 ticket_not_open,
  // no_base_currency, currency_changed.
  async resolve(
    cityId: string,
    id: string,
    input: TicketResolutionInput,
    admin: TicketAdmin,
    now: Date,
  ): Promise<TicketPage> {
    const found = await this.row(cityId, id);
    const kind = ticketKind(found.typeCode);
    const needed = managingPermission(kind);
    if (!admin.permissions.includes(needed)) {
      throw new TicketRefusedError('forbidden', `resolving this ticket needs ${needed}`);
    }
    const problem = resolutionProblem({
      kind,
      resolution: input.resolution,
      responsible: input.responsible,
      lines: input.lines,
    });
    if (problem !== null) throw new TicketRefusedError(problem, `the resolution is ${problem}`);
    if (input.code !== null && !admin.permissions.includes('operations.compensate')) {
      throw new TicketRefusedError('forbidden', 'a compensation code needs operations.compensate');
    }
    const { facts, money } = await this.checkMoney(found, {
      resolution: input.resolution,
      responsible: input.responsible,
      affected: input.affected,
      shortAmount: input.shortAmount,
      codeValue: input.code !== null,
    });
    // V's lines are checked before the transaction (invalid_affected).
    if (money !== null) await this.ticketOrders().preview(found.orderId!, money);
    const compensation =
      input.resolution === 'compensation_code'
        ? await this.prepareCode(found, facts, input, admin)
        : null;
    const message = input.message.trim();
    const lines = input.resolution === 'accounts_corrected' ? input.lines! : null;
    // The lines' checks (invalid_lines, no_difference) before the transaction.
    if (lines !== null) await this.pickupDisputes().preview(found.pickupDisputeId!, lines, now);
    const pushKey = PUSH_TEMPLATES[found.party];
    const rendered = await this.texts.render(pushKey, {
      رقم: found.number.toString(),
      الرد: message,
    });
    await this.database.db.transaction(async (tx) => {
      const before = await lockTicket(tx, cityId, id);
      if (!isOpenStatus(before.status)) {
        throw new TicketRefusedError('ticket_not_open', 'the ticket is no longer open');
      }
      const actor = { type: 'admin' as const, id: admin.accountId };
      let journalIds: string[] | null =
        lines === null
          ? null
          : await this.pickupDisputes().correct(tx, {
              disputeId: before.pickupDisputeId!,
              received: lines,
              actor,
              now,
            });
      let affected: { lines: StoredAffectedLine[]; value: bigint } | null = null;
      if (money !== null) {
        const posted = await this.ticketOrders().post(tx, {
          orderId: before.orderId!,
          ticketId: id,
          ticketNumber: before.number,
          money,
          actor,
          now,
        });
        journalIds = posted.journalIds;
        if (posted.affected.length > 0) {
          affected = { lines: posted.affected, value: posted.affectedValue };
        }
      }
      const asked =
        compensation === null
          ? null
          : await this.compensations
              .requestIn(tx, compensation, `ticket:${id}`, now)
              .catch((error: unknown) => {
                if (
                  error instanceof CompensationRefusedError &&
                  (error.refusal === 'no_base_currency' || error.refusal === 'currency_changed')
                ) {
                  throw new TicketRefusedError(error.refusal, error.message);
                }
                throw error;
              });
      const after = await this.move(
        tx,
        before,
        'resolved',
        {
          resolution: input.resolution,
          responsible: input.responsible,
          message,
          correctedLines: lines === null ? null : storedLines(lines),
          journalIds,
          resolvedBy: admin.accountId,
          resolvedAt: now,
          affectedLines:
            affected === null
              ? null
              : affected.lines.map((line) => ({ ...line, value: line.value.toString() })),
          affectedValue: affected?.value ?? null,
          shortAmount: input.shortAmount,
          moneyCurrency: affected !== null || input.shortAmount !== null ? facts!.currency : null,
          compensationId: asked?.id ?? null,
        },
        now,
      );
      await this.pushes.enqueue(
        tx,
        [
          {
            source: `support:ticket_resolved:${id}`,
            recipient: recipientOf(after),
            templateKey: pushKey,
            body: rendered.body,
            level: rendered.level,
            priority: rendered.priority,
            data: { target: 'ticket', ticketId: id },
            at: now,
            expiresAt: new Date(now.getTime() + MESSAGE_PUSH_MS),
          },
        ],
        now,
      );
      await this.audit.recordWrite(
        {
          actor: admin.actor,
          context: admin.context,
          cityId,
          action: 'ticket.resolve',
          target: { type: 'ticket', id },
          before: { status: before.status },
          after: {
            status: after.status,
            resolution: after.resolution,
            responsible: after.responsible,
            correctedLines: after.correctedLines,
            journalIds: after.journalIds,
            affectedLines: after.affectedLines,
            affectedValue: after.affectedValue?.toString() ?? null,
            shortAmount: after.shortAmount?.toString() ?? null,
            compensationId: after.compensationId,
          },
          reason: message,
        },
        tx,
      );
    });
    return this.ticket(cityId, id);
  }

  // «كود تعويض» read before the transaction (AP §6.4): the order it is
  // linked to, the value (the wrong change's is M, uncapped with its fixed
  // reason) and the resolver's cap.
  private async prepareCode(
    row: TicketRow,
    facts: TicketOrderFacts | null,
    input: TicketResolutionInput,
    admin: TicketAdmin,
  ): Promise<PreparedCompensation> {
    if (facts === null) throw new Error('a code is asked on a customer ticket with an order');
    const wrongChange = row.typeCode === WRONG_CHANGE_TYPE;
    const value: CompensationValue = wrongChange
      ? { kind: 'fixed_amount', amount: input.shortAmount! }
      : input.code!.value;
    return this.compensations.prepare(
      {
        id: facts.orderId,
        cityId: facts.cityId,
        number: facts.number,
        customerAccountId: facts.customerAccountId,
        total: facts.total,
        currency: facts.currency,
      },
      value,
      wrongChange ? 'wrong_change' : input.code!.reason,
      { ...admin, roles: admin.roles },
    );
  }

  // «إغلاق» (owner decision 2026-11-17): an open ticket ends without a
  // resolution, with an internal reason; no message, no entries. A pickup
  // dispute is closed by whoever may resolve it (403 forbidden). A repeat
  // is 409 ticket_not_open, so no key. 404 unknown_ticket.
  async close(
    cityId: string,
    id: string,
    reason: string,
    admin: TicketAdmin,
    now: Date,
  ): Promise<TicketPage> {
    const text = reason.trim();
    const needed = managingPermission(ticketKind((await this.row(cityId, id)).typeCode));
    if (!admin.permissions.includes(needed)) {
      throw new TicketRefusedError('forbidden', `closing this ticket needs ${needed}`);
    }
    await this.database.db.transaction(async (tx) => {
      const before = await lockTicket(tx, cityId, id);
      if (!canClose(before.status)) {
        throw new TicketRefusedError('ticket_not_open', 'the ticket is no longer open');
      }
      await this.move(
        tx,
        before,
        'closed',
        { closeReason: text, closedBy: admin.accountId, closedAt: now },
        now,
      );
      await this.audit.recordWrite(
        {
          actor: admin.actor,
          context: admin.context,
          cityId,
          action: 'ticket.close',
          target: { type: 'ticket', id },
          before: { status: before.status },
          after: { status: 'closed' },
          reason: text,
        },
        tx,
      );
    });
    return this.ticket(cityId, id);
  }

  private async row(cityId: string, id: string): Promise<TicketRow> {
    const [row] = await this.database.db
      .select()
      .from(tickets)
      .where(and(eq(tickets.id, id), eq(tickets.cityId, cityId)));
    if (!row) throw new TicketRefusedError('unknown_ticket', 'no such ticket');
    return row;
  }

  // The status move, the timer's stop and the change's alert and broadcast.
  private async move(
    tx: Tx,
    before: TicketRow,
    status: TicketStatus,
    fields: Partial<
      Pick<
        TicketRow,
        | 'assigneeId'
        | 'resolution'
        | 'responsible'
        | 'message'
        | 'correctedLines'
        | 'journalIds'
        | 'resolvedBy'
        | 'resolvedAt'
        | 'closeReason'
        | 'closedBy'
        | 'closedAt'
        | 'affectedLines'
        | 'affectedValue'
        | 'shortAmount'
        | 'moneyCurrency'
        | 'compensationId'
      >
    >,
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
        // An account, profile or not: a customer may call before «أكمل بياناتك».
        return this.customerAccounts.exists(partyId);
    }
  }

  private async views(rows: TicketRow[]): Promise<Ticket[]> {
    if (rows.length === 0) return [];
    const of = (party: TicketParty) => [
      ...new Set(rows.filter((row) => row.party === party).map((row) => row.partyId)),
    ];
    const [admins, captains, restaurants, customers] = await Promise.all([
      this.admins.names(
        rows.flatMap((row) => [
          row.openedBy,
          ...[row.assigneeId, row.resolvedBy, row.closedBy].filter((each) => each !== null),
        ]),
      ),
      this.captains.names(of('captain')),
      this.merchants.names([
        ...of('restaurant'),
        ...rows.flatMap((row) => (row.restaurantId === null ? [] : [row.restaurantId])),
      ]),
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
      urgent: isUrgent({
        status: row.status,
        orderActive: row.orderActive,
        kind: ticketKind(row.typeCode),
      }),
      kind: ticketKind(row.typeCode),
      restaurantId: row.restaurantId,
      restaurantName:
        row.restaurantId === null ? null : (restaurants.get(row.restaurantId)?.nameAr ?? null),
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
      // A pickup dispute's ticket is opened by the restaurant (its party).
      openedByName:
        row.source === 'pickup_dispute'
          ? (partyName(row) ?? null)
          : (admins.get(row.openedBy) ?? null),
      openedAt: row.openedAt,
      updatedAt: row.updatedAt,
      resolution:
        row.resolution === null
          ? null
          : {
              code: row.resolution,
              responsible: row.responsible,
              message: row.message!,
              correctedLines: row.correctedLines === null ? null : linesOf(row.correctedLines),
              resolvedAt: row.resolvedAt!,
              resolvedByName: admins.get(row.resolvedBy!) ?? null,
              affectedLines: row.affectedLines === null ? null : affectedLinesOf(row.affectedLines),
              affectedValue: row.affectedValue,
              shortAmount: row.shortAmount,
              moneyCurrency: row.moneyCurrency,
              compensationId: row.compensationId,
            },
      closure:
        row.closeReason === null
          ? null
          : {
              reason: row.closeReason,
              closedAt: row.closedAt!,
              closedByName: admins.get(row.closedBy!) ?? null,
            },
    }));
  }
}

function isOpenStatus(status: TicketStatus): boolean {
  return status === 'new' || status === 'in_progress' || status === 'waiting';
}

// The resolution message goes to the ticket's party (AP §9.9.3 «Close»): a
// restaurant's owners (RA §16 #29).
function recipientOf(row: TicketRow): PushRecipient {
  switch (row.party) {
    case 'customer':
      return { party: 'customer', accountId: row.partyId };
    case 'restaurant':
      return { party: 'merchant', restaurantId: row.partyId, owners: true };
    case 'captain':
      return { party: 'captain', captainId: row.partyId };
  }
}

function storedLines(lines: MoneyLine[]): { currency: string; amount: string }[] {
  return lines.map((line) => ({ currency: line.currency, amount: line.amount.toString() }));
}

function linesOf(stored: unknown): MoneyLine[] {
  return (stored as { currency: string; amount: string }[]).map((line) => ({
    currency: line.currency,
    amount: BigInt(line.amount),
  }));
}

function affectedLinesOf(stored: unknown): StoredAffectedLine[] {
  return (stored as { position: number; quantity: number; name: string; value: string }[]).map(
    (line) => ({ ...line, value: BigInt(line.value) }),
  );
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

// An opening's request: on an order its party is named by the order, so the
// hash leaves the party's id out and can be worked out before the lock.
export function openingHash(input: OpenTicket, orderId: string | null): string {
  return hashOf([
    orderId,
    input.party,
    orderId === null ? input.partyId : null,
    input.typeCode,
    input.description.trim(),
    // Only a price difference names a restaurant: the other tickets' hashes
    // stay as they were before 2.23b.
    ...(input.restaurantId === null ? [] : [input.restaurantId]),
  ]);
}

function hashOf(parts: unknown[]): string {
  return createHash('sha256')
    .update(JSON.stringify(parts, (_, value) => (typeof value === 'bigint' ? `${value}n` : value)))
    .digest('hex');
}
