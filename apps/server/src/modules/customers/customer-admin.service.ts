import { createHash } from 'node:crypto';
import { Inject, Injectable } from '@nestjs/common';
import { and, count, desc, eq, gte, ilike, inArray, isNull, or, sql } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { type AuditActor, type AuditRequestContext, AuditService } from '../audit/index.js';
import { ContentRefusedError, ContentService } from '../content/index.js';
import { FxService } from '../fx/index.js';
import { GeoService } from '../geo/index.js';
import {
  AdminSessionsService,
  CustomerAccountRefusedError,
  CustomerAccountsService,
} from '../identity/index.js';
import { LedgerService } from '../ledger/index.js';
import { type CustomerCodeUse, PromoCodeUsesService } from '../marketing/index.js';
import { SettingsService } from '../settings/index.js';
import {
  type AccountStatus,
  accountStatus,
  type BlockCommand,
  type BlockKind,
  blockInForce,
  blockProblem,
  maskedPhone,
} from './blocks.js';
import {
  type ActiveBlock,
  type Address,
  type CustomerOrders,
  type CustomerTicket,
  CustomersService,
} from './customers.service.js';
import type { NodePgDatabase } from 'drizzle-orm/node-postgres';
import {
  blocks,
  type genders,
  lateCancelStrikes,
  notes,
  profiles,
  reviewStops,
  strikeClears,
  testAccountFlags,
  trustMarks,
} from './schema.js';
import { strikesSince } from './trust.js';

export type CustomerAdminRefusal =
  | 'unknown_customer'
  | 'invalid_block'
  | 'already_blocked'
  | 'not_blocked'
  | 'not_stopped'
  | 'nothing_to_clear'
  | 'no_base_currency'
  | 'unknown_reason'
  | 'unknown_city'
  | 'active_order'
  | 'account_closed'
  | 'idempotency_key_reused';

export class CustomerAdminRefusedError extends Error {
  override readonly name = 'CustomerAdminRefusedError';
  constructor(
    readonly refusal: CustomerAdminRefusal,
    message: string,
  ) {
    super(message);
  }
}

export interface CustomerAdmin {
  accountId: string;
  actor: AuditActor;
  context: AuditRequestContext;
}

// AP §9.8 «البحث»: one customer found by the number or the name.
export interface FoundCustomer {
  id: string;
  name: string | null;
  maskedPhone: string | null;
  status: AccountStatus;
}

// A block as the profile lists it, newest first.
export interface BlockRecord {
  id: string;
  kind: BlockKind;
  reason: string;
  reasonLabel: string;
  note: string;
  until: Date | null;
  duesAmount: bigint | null;
  duesCurrency: string | null;
  startedAt: Date;
  startedByName: string | null;
  endedAt: Date | null;
  endedByName: string | null;
  endNote: string | null;
  inForce: boolean;
}

// AP §9.8 «ملف الزبون», what slice 2.25a shows: the name, the masked phone,
// gender and birthday, the status with the block in force, the review stop,
// the trust (D23), the strikes, the dues in the city and the blocks.
export interface CustomerProfileView {
  id: string;
  firstName: string | null;
  lastName: string | null;
  gender: (typeof genders)[number] | null;
  birthday: string | null;
  maskedPhone: string | null;
  status: AccountStatus;
  block: ActiveBlock | null;
  reviewStop: { id: string; startedAt: Date } | null;
  // D19 (slice 2.25c): when, by whom and why it was closed; null while open.
  // The admin is null when the customer closed it from the app.
  closed: { at: Date; byName: string | null; reason: string | null } | null;
  // AP §9.8 «linked closed accounts» (AP §8.8): the other accounts of the
  // line, newest first: the closed ones it continues, or the account that
  // continues a closed one.
  linkedAccounts: {
    id: string;
    status: 'active' | 'closed';
    createdAt: Date;
    closedAt: Date | null;
  }[];
  trusted: boolean;
  delivered: number;
  trustedAfter: number;
  // The latest «توثيق» or «إزالة الثقة» (slice 2.25b), or null.
  trustMark: (AdminMark & { trusted: boolean }) | null;
  // inWindow counts from the latest clear (`strikesSince`); total is every
  // strike ever, nothing being deleted.
  lateCancels: {
    inWindow: number;
    total: number;
    limit: number;
    windowDays: number;
    cleared: AdminMark | null;
  };
  fakeOrders: number;
  // What the customer owes in the city's base (+ owes, − a credit), 0 with
  // no dues account.
  dues: { amount: bigint; currency: string | null };
  blocks: BlockRecord[];
  // Content's active customer_block reasons, for «حظر» (AP Appendix B).
  blockReasons: { code: string; label: string }[];
  // «حساب تجريبي للإدارة» (AP §9.8, slice 2.25b).
  testAccount: boolean;
  // Slice 2.25b: the orders in the city, the tickets, the codes used, the
  // saved addresses and the internal notes, newest first.
  orders: Pick<CustomerOrders, 'count' | 'spent' | 'last'>;
  tickets: CustomerTicket[];
  codes: CustomerCodeUse[];
  addresses: Address[];
  notes: { id: string; body: string; authorName: string | null; createdAt: Date }[];
}

// An admin's mark with its reason, as the profile shows it.
export interface AdminMark {
  at: Date;
  byName: string | null;
  note: string;
}

type Tx = Parameters<Parameters<NodePgDatabase['transaction']>[0]>[0];

// The latest blocks the profile lists (decided by us).
const BLOCKS_LISTED = 20;
const SEARCH_RESULTS = 20;
// The codes used and the notes the profile lists (decided by us).
const CODES_LISTED = 20;
const NOTES_LISTED = 50;

// AP §9.8 (slice 2.25a): the panel's customers: the search, the profile,
// «حظر» and «فك الحظر».
@Injectable()
export class CustomerAdminService {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly customers: CustomersService,
    private readonly accounts: CustomerAccountsService,
    private readonly admins: AdminSessionsService,
    private readonly content: ContentService,
    private readonly ledger: LedgerService,
    private readonly fx: FxService,
    private readonly settings: SettingsService,
    private readonly audit: AuditService,
    private readonly geo: GeoService,
    private readonly promoCodes: PromoCodeUsesService,
  ) {}

  // The panel's city: 404 unknown_city for another id.
  private async checkCity(cityId: string): Promise<void> {
    if ((await this.geo.cityTimeZone(cityId)) === null) {
      throw new CustomerAdminRefusedError('unknown_city', 'no such city');
    }
  }

  // By the number (any of the forms the desk takes, `phone`), or else by a
  // part of the first or last name; the latest SEARCH_RESULTS. The dues are
  // the city's.
  async search(
    cityId: string,
    query: { text: string; phone: string | null },
    now: Date,
  ): Promise<FoundCustomer[]> {
    let ids: string[];
    if (query.phone !== null) {
      // Every account of the number, a closed one beside its new one (AP
      // §8.8, owner decision 2026-11-17).
      ids = (await this.accounts.customersByPhone(query.phone)).slice(0, SEARCH_RESULTS);
    } else {
      const text = query.text.trim();
      if (text.length < 2) return [];
      const pattern = `%${text.replace(/[\\%_]/g, (match) => `\\${match}`)}%`;
      const rows = await this.database.db
        .select({ id: profiles.accountId })
        .from(profiles)
        .where(
          or(
            ilike(profiles.firstName, pattern),
            ilike(profiles.lastName, pattern),
            ilike(sql`${profiles.firstName} || ' ' || coalesce(${profiles.lastName}, '')`, pattern),
          ),
        )
        .orderBy(desc(profiles.createdAt))
        .limit(SEARCH_RESULTS);
      ids = rows.map((row) => row.id);
    }
    return Promise.all(
      ids.map(async (id) => {
        const [profile, phone, status] = await Promise.all([
          this.customers.profile(id),
          this.accounts.phone(id),
          this.status(cityId, id, now),
        ]);
        return {
          id,
          name: profile ? [profile.firstName, profile.lastName].filter(Boolean).join(' ') : null,
          maskedPhone: phone === null ? null : maskedPhone(phone),
          status,
        };
      }),
    );
  }

  async profile(cityId: string, accountId: string, now: Date): Promise<CustomerProfileView> {
    await this.checkCity(cityId);
    if (!(await this.accounts.exists(accountId))) {
      throw new CustomerAdminRefusedError('unknown_customer', 'no such customer');
    }
    const [strikesLimit, windowDays] = await Promise.all([
      this.settings.get('customer.late_cancel_strikes', { cityId }),
      this.settings.get('customer.late_cancel_window_days', { cityId }),
    ]);
    const line = await this.customers.lineage(accountId);
    const [cleared, mark, states] = await Promise.all([
      this.lastClear(line),
      this.lastMark(line),
      this.accounts.states(line),
    ]);
    const state = states.get(accountId)!;
    const since = strikesSince(
      new Date(now.getTime() - windowDays * 24 * 60 * 60 * 1000),
      cleared?.at ?? null,
    );
    const [tickets, codes, addresses, noteRows, testAccount] = await Promise.all([
      this.customers.ticketsOf(accountId, cityId),
      this.promoCodes.usesOf(accountId, cityId, CODES_LISTED),
      this.customers.addresses(accountId),
      this.database.db
        .select()
        .from(notes)
        .where(eq(notes.customerAccountId, accountId))
        .orderBy(desc(notes.createdAt), desc(notes.id))
        .limit(NOTES_LISTED),
      this.customers.isTestAccount(accountId),
    ]);
    const [profile, phone, block, stop, orders, strikes, dues, records, reasons, names] =
      await Promise.all([
        this.customers.profile(accountId),
        this.accounts.phone(accountId),
        this.customers.activeBlock(accountId, now),
        this.database.db
          .select({ id: reviewStops.id, startedAt: reviewStops.startedAt })
          .from(reviewStops)
          .where(and(inArray(reviewStops.customerAccountId, line), isNull(reviewStops.endedAt))),
        this.customers.ordersOf(accountId, cityId),
        this.database.db
          .select({
            total: count(),
            inWindow:
              sql<number>`count(*) FILTER (WHERE ${gte(lateCancelStrikes.at, since)})`.mapWith(
                Number,
              ),
          })
          .from(lateCancelStrikes)
          .where(inArray(lateCancelStrikes.customerAccountId, line)),
        this.duesBalance(cityId, accountId),
        this.blockRecords(line, now),
        this.content.reasonsOf('customer_block'),
        this.admins.names([
          ...(cleared ? [cleared.by] : []),
          ...(mark ? [mark.by] : []),
          ...(state.closedBy ? [state.closedBy] : []),
          ...noteRows.map((row) => row.authorId),
        ]),
      ]);
    const asMark = (row: { at: Date; by: string; note: string }): AdminMark => ({
      at: row.at,
      byName: names.get(row.by) ?? null,
      note: row.note,
    });
    return {
      id: accountId,
      firstName: profile?.firstName ?? null,
      lastName: profile?.lastName ?? null,
      gender: profile?.gender ?? null,
      birthday: profile?.birthday ?? null,
      maskedPhone: phone === null ? null : maskedPhone(phone),
      status: accountStatus({
        closed: state.status === 'closed',
        blocked: block !== null,
        duesOwed: dues.amount > 0n,
        reviewStopped: stop.length > 0,
      }),
      block,
      reviewStop: stop[0] ?? null,
      closed:
        state.closedAt === null
          ? null
          : {
              at: state.closedAt,
              byName: state.closedBy === null ? null : (names.get(state.closedBy) ?? null),
              reason: state.closeReason,
            },
      linkedAccounts: [...states.values()]
        .filter((each) => each.id !== accountId)
        .toSorted((a, b) => b.createdAt.getTime() - a.createdAt.getTime())
        .map(({ id, status, createdAt, closedAt }) => ({ id, status, createdAt, closedAt })),
      trusted: orders.trusted,
      delivered: orders.delivered,
      trustedAfter: orders.trustedAfter,
      trustMark: mark && { ...asMark(mark), trusted: mark.trusted },
      lateCancels: {
        inWindow: strikes[0]?.inWindow ?? 0,
        total: strikes[0]?.total ?? 0,
        limit: strikesLimit,
        windowDays,
        cleared: cleared && asMark(cleared),
      },
      fakeOrders: orders.fakeOrders,
      dues,
      blocks: records,
      blockReasons: reasons
        .filter((reason) => reason.active)
        .map(({ code, label }) => ({ code, label })),
      testAccount,
      orders: { count: orders.count, spent: orders.spent, last: orders.last },
      tickets,
      codes,
      addresses,
      notes: noteRows.map((row) => ({
        id: row.id,
        body: row.body,
        authorName: names.get(row.authorId) ?? null,
        createdAt: row.createdAt,
      })),
    };
  }

  // «حظر» (AP §9.8, OWN and OPS, a reason required): a duration, until
  // further notice, or until dues of a set amount are paid (a dues.charge
  // of the amount in the city's base against platform.adjustments; owner
  // decision 2026-11-17). Under the customer's ordering lock, so a placing
  // reads it. A duration or «حتى إشعار آخر» while one is in force is 409
  // already_blocked; a duration whose time passed is closed at its end.
  async block(
    admin: CustomerAdmin,
    command: {
      cityId: string;
      accountId: string;
      block: BlockCommand;
      reason: string;
      note: string;
      idempotencyKey: string;
    },
    now: Date,
  ): Promise<void> {
    const requestHash = createHash('sha256')
      .update(
        JSON.stringify({
          cityId: command.cityId,
          accountId: command.accountId,
          kind: command.block.kind,
          until: command.block.kind === 'until' ? command.block.until.toISOString() : null,
          amount: command.block.kind === 'dues' ? command.block.amount.toString() : null,
          reason: command.reason,
          note: command.note,
        }),
      )
      .digest('hex');
    if (
      await this.replayed(this.database.db, admin.accountId, command.idempotencyKey, requestHash)
    ) {
      return;
    }
    await this.checkCity(command.cityId);
    if (!(await this.accounts.exists(command.accountId))) {
      throw new CustomerAdminRefusedError('unknown_customer', 'no such customer');
    }
    if (blockProblem(command.block, now) !== null) {
      throw new CustomerAdminRefusedError('invalid_block', 'the block does not fit its kind');
    }
    let chosen;
    try {
      chosen = await this.content.choose('customer_block', { code: command.reason, note: null });
    } catch (error) {
      // The list is closed and its reasons take no text (AP Appendix B).
      if (!(error instanceof ContentRefusedError)) throw error;
      throw new CustomerAdminRefusedError('unknown_reason', 'not a customer block reason');
    }
    const customerText = await this.content.customerText('customer_block', chosen.code);
    const base = command.block.kind === 'dues' ? await this.fx.baseCurrency(command.cityId) : null;
    if (command.block.kind === 'dues' && base === null) {
      throw new CustomerAdminRefusedError('no_base_currency', 'the city has no base currency');
    }

    await this.database.db.transaction(async (tx) => {
      const line = await this.customers.lockLine(tx, command.accountId);
      if (await this.replayed(tx, admin.accountId, command.idempotencyKey, requestHash)) return;
      const open = await tx
        .select()
        .from(blocks)
        .where(
          and(
            inArray(blocks.customerAccountId, line),
            isNull(blocks.endedAt),
            sql`${blocks.kind} <> 'dues'`,
          ),
        );
      for (const row of open) {
        if (blockInForce(row, now)) {
          if (command.block.kind !== 'dues') {
            throw new CustomerAdminRefusedError('already_blocked', 'a block is in force');
          }
        } else {
          // A duration that ran out: closed at its end, by nobody.
          await tx.update(blocks).set({ endedAt: row.until }).where(eq(blocks.id, row.id));
        }
      }
      let dues: { amount: bigint; currency: string; journalId: string } | null = null;
      if (command.block.kind === 'dues') {
        const currency = base!;
        const account = (purpose: 'customer.dues' | 'platform.adjustments') =>
          this.ledger.openAccount(
            {
              cityId: command.cityId,
              purpose,
              ownerId: purpose === 'customer.dues' ? command.accountId : null,
              currency,
            },
            tx,
          );
        const journalId = await this.ledger.post(
          {
            cityId: command.cityId,
            type: 'dues.charge',
            source: null,
            actor: { type: 'admin', id: admin.accountId },
            reason: `${chosen.label}: ${command.note}`,
            entries: [
              { accountId: await account('customer.dues'), currency, amount: command.block.amount },
              {
                accountId: await account('platform.adjustments'),
                currency,
                amount: -command.block.amount,
              },
            ],
          },
          tx,
        );
        dues = { amount: command.block.amount, currency, journalId };
      }
      const [created] = await tx
        .insert(blocks)
        .values({
          customerAccountId: command.accountId,
          kind: command.block.kind,
          reason: chosen.code,
          reasonLabel: chosen.label,
          customerText,
          note: command.note,
          until: command.block.kind === 'until' ? command.block.until : null,
          cityId: dues === null ? null : command.cityId,
          duesAmount: dues?.amount ?? null,
          duesCurrency: dues?.currency ?? null,
          duesJournalId: dues?.journalId ?? null,
          startedAt: now,
          startedBy: admin.accountId,
          idempotencyKey: command.idempotencyKey,
          requestHash,
        })
        .returning({ id: blocks.id });
      await this.audit.recordWrite(
        {
          actor: admin.actor,
          context: admin.context,
          cityId: command.cityId,
          action: 'customer.block',
          target: { type: 'customer', id: command.accountId },
          reason: command.note,
          before: null,
          after: {
            blockId: created!.id,
            kind: command.block.kind,
            reason: chosen.code,
            until: command.block.kind === 'until' ? command.block.until.toISOString() : null,
            duesAmount: dues?.amount.toString() ?? null,
            duesCurrency: dues?.currency ?? null,
          },
        },
        tx,
      );
    });
  }

  // «فك الحظر» (AP §9.8, OWN and OPS, a reason required): ends the block in
  // force, a duration or «حتى إشعار آخر», named by its id. The dues are
  // lifted by paying them at the desk or by «القيود التصحيحية», never here
  // (owner decision 2026-11-17); 409 not_blocked when that
  // block is not in force, so a repeat needs no key.
  async unblock(
    admin: CustomerAdmin,
    command: { cityId: string; accountId: string; blockId: string; note: string },
    now: Date,
  ): Promise<void> {
    await this.database.db.transaction(async (tx) => {
      await this.customers.lockLine(tx, command.accountId);
      // Names the block the panel showed, so a late retry never lifts a
      // newer one.
      const block = await this.customers.activeBlock(command.accountId, now, tx);
      if (block === null || block.id !== command.blockId) {
        throw new CustomerAdminRefusedError('not_blocked', 'that block is not in force');
      }
      await tx
        .update(blocks)
        .set({ endedAt: now, endedBy: admin.accountId, endNote: command.note })
        .where(eq(blocks.id, block.id));
      await this.audit.recordWrite(
        {
          actor: admin.actor,
          context: admin.context,
          cityId: command.cityId,
          action: 'customer.unblock',
          target: { type: 'customer', id: command.accountId },
          reason: command.note,
          before: { blockId: block.id, kind: block.kind, reason: block.reason },
          after: null,
        },
        tx,
      );
    });
  }

  // AP §9.8 «ملاحظة داخلية» (everyone with access to the customers): a note
  // the panel shows on the profile. Its Idempotency-Key is kept with it, so
  // a retry adds no second note; the same key with another body is 422.
  async addNote(
    admin: CustomerAdmin,
    command: { cityId: string; accountId: string; body: string; idempotencyKey: string },
    now: Date,
  ): Promise<void> {
    const requestHash = createHash('sha256')
      .update(JSON.stringify({ accountId: command.accountId, body: command.body }))
      .digest('hex');
    const earlier = async (executor: Pick<Database['db'], 'select'>) => {
      const [row] = await executor
        .select({ requestHash: notes.requestHash })
        .from(notes)
        .where(
          and(
            eq(notes.authorId, admin.accountId),
            eq(notes.idempotencyKey, command.idempotencyKey),
          ),
        );
      if (row && row.requestHash !== requestHash) {
        throw new CustomerAdminRefusedError('idempotency_key_reused', 'the key named another note');
      }
      return row !== undefined;
    };
    if (await earlier(this.database.db)) return;
    await this.checkCustomer(command.cityId, command.accountId);
    await this.database.db.transaction(async (tx) => {
      const inserted = await tx
        .insert(notes)
        .values({
          customerAccountId: command.accountId,
          body: command.body,
          authorId: admin.accountId,
          createdAt: now,
          idempotencyKey: command.idempotencyKey,
          requestHash,
        })
        .onConflictDoNothing({ target: [notes.authorId, notes.idempotencyKey] })
        .returning({ id: notes.id });
      // A repeat sent with the first wrote nothing: nothing to audit.
      if (inserted.length === 0) return;
      await this.audit.recordWrite(
        {
          actor: admin.actor,
          context: admin.context,
          cityId: command.cityId,
          action: 'customer.note',
          target: { type: 'customer', id: command.accountId },
          reason: null,
          before: null,
          after: { body: command.body },
        },
        tx,
      );
    });
    // A repeat sent with the first lands on the key's unique index: answer
    // as the first, or 422 for another body.
    await earlier(this.database.db);
  }

  // AP §9.8 «حساب تجريبي للإدارة» (OWN): the account sees the restaurants
  // in test mode (AP §9.6.3) and may order from them, or no longer. Sets a
  // value, so a repeat needs no key.
  async setTestAccount(
    admin: CustomerAdmin,
    command: { cityId: string; accountId: string; flagged: boolean },
    now: Date,
  ): Promise<void> {
    await this.checkCustomer(command.cityId, command.accountId);
    await this.database.db.transaction(async (tx) => {
      await tx.insert(testAccountFlags).values({
        customerAccountId: command.accountId,
        flagged: command.flagged,
        at: now,
        by: admin.accountId,
      });
      await this.audit.recordWrite(
        {
          actor: admin.actor,
          context: admin.context,
          cityId: command.cityId,
          action: 'customer.test_account',
          target: { type: 'customer', id: command.accountId },
          reason: null,
          before: null,
          after: { flagged: command.flagged },
        },
        tx,
      );
    });
  }

  // AP §9.8 «توثيق» and «إزالة الثقة» (OWN and OPS, a reason required):
  // overrides D23's rule from now (`trustBasis`; owner decisions
  // 2026-11-17). Sets the trust to a value (the same value again writes
  // nothing), so a repeat needs no key. Under
  // the customer's ordering lock, so a placing counts with it or before it.
  async markTrust(
    admin: CustomerAdmin,
    command: { cityId: string; accountId: string; trusted: boolean; note: string },
    now: Date,
  ): Promise<void> {
    await this.checkCustomer(command.cityId, command.accountId);
    await this.database.db.transaction(async (tx) => {
      await this.lockCustomer(tx, command.accountId);
      // The same value again changes nothing: a repeated «إزالة الثقة» would
      // otherwise restart the count a second time.
      const latest = await this.customers.trustMark(command.accountId, tx);
      if (latest?.trusted === command.trusted) return;
      await tx.insert(trustMarks).values({
        customerAccountId: command.accountId,
        trusted: command.trusted,
        at: now,
        by: admin.accountId,
        note: command.note,
      });
      await this.audit.recordWrite(
        {
          actor: admin.actor,
          context: admin.context,
          cityId: command.cityId,
          action: 'customer.trust_mark',
          target: { type: 'customer', id: command.accountId },
          reason: command.note,
          before: null,
          after: { trusted: command.trusted },
        },
        tx,
      );
    });
  }

  // AP §9.8 «مسح المخالفات» (OWN, OPS and SUP, after a support review, a
  // reason required; owner decision 2026-11-17): the strikes count again
  // from now and nothing is deleted; an open review stop ends with it, as it
  // stood on those strikes. 409 nothing_to_clear without a strike counted
  // since the latest clear nor a stop, so a repeat changes nothing.
  async clearStrikes(
    admin: CustomerAdmin,
    command: { cityId: string; accountId: string; note: string },
    now: Date,
  ): Promise<void> {
    await this.checkCustomer(command.cityId, command.accountId);
    await this.database.db.transaction(async (tx) => {
      const line = await this.lockCustomer(tx, command.accountId);
      const cleared = await this.customers.strikesClearedAt(command.accountId, tx);
      const [counted] = await tx
        .select({ n: count() })
        .from(lateCancelStrikes)
        .where(
          and(
            inArray(lateCancelStrikes.customerAccountId, line),
            cleared === null ? undefined : sql`${lateCancelStrikes.at} > ${cleared}`,
          ),
        );
      const stop = await this.openStop(tx, line);
      if ((counted?.n ?? 0) === 0 && stop === null) {
        throw new CustomerAdminRefusedError('nothing_to_clear', 'no strike to clear');
      }
      await tx.insert(strikeClears).values({
        customerAccountId: command.accountId,
        at: now,
        by: admin.accountId,
        note: command.note,
      });
      if (stop !== null) await this.endStop(tx, stop, admin.accountId, command.note, now);
      await this.audit.recordWrite(
        {
          actor: admin.actor,
          context: admin.context,
          cityId: command.cityId,
          action: 'customer.clear_strikes',
          target: { type: 'customer', id: command.accountId },
          reason: command.note,
          before: { strikes: counted?.n ?? 0, reviewStopId: stop },
          after: null,
        },
        tx,
      );
    });
  }

  // AP §9.8 «إنهاء الإيقاف» (OWN, OPS and SUP, a reason required): ends the
  // review stop the panel showed and leaves the strikes counted, so the next
  // late cancellation stops the account again. 409 not_stopped when that
  // stop is no longer open, so a repeat needs no key.
  async endReviewStop(
    admin: CustomerAdmin,
    command: { cityId: string; accountId: string; stopId: string; note: string },
    now: Date,
  ): Promise<void> {
    await this.checkCustomer(command.cityId, command.accountId);
    await this.database.db.transaction(async (tx) => {
      const line = await this.lockCustomer(tx, command.accountId);
      if ((await this.openStop(tx, line)) !== command.stopId) {
        throw new CustomerAdminRefusedError('not_stopped', 'that review stop is not open');
      }
      await this.endStop(tx, command.stopId, admin.accountId, command.note, now);
      await this.audit.recordWrite(
        {
          actor: admin.actor,
          context: admin.context,
          cityId: command.cityId,
          action: 'customer.end_review_stop',
          target: { type: 'customer', id: command.accountId },
          reason: command.note,
          before: { reviewStopId: command.stopId },
          after: null,
        },
        tx,
      );
    });
  }

  // AP §9.8 «إغلاق الحساب» (OWN, OPS, SUP, on the customer's request, a
  // reason required; D19, AP §8.8; slice 2.25c): as the app's «حذف الحساب»
  // (`closeAccount`). 409 active_order while an order is active,
  // account_closed when it is closed already, so a repeat needs no key.
  async close(
    admin: CustomerAdmin,
    command: { cityId: string; accountId: string; note: string },
    now: Date,
  ): Promise<void> {
    await this.checkCustomer(command.cityId, command.accountId);
    await this.closeAccount(
      command.accountId,
      {
        admin: {
          actor: admin.actor,
          context: admin.context,
          cityId: command.cityId,
          reason: command.note,
        },
        context: admin.context,
        cityId: command.cityId,
      },
      now,
    );
  }

  // D19, AP §8.8, CU §5.6: under the line's ordering lock (placing takes it
  // and checks the account again), refused with an active order; then
  // identity closes the account and ends every session, all in one
  // transaction, and the devices' connections end after the commit.
  async closeAccount(
    accountId: string,
    by: Omit<Parameters<CustomerAccountsService['close']>[1], 'accountId'>,
    now: Date,
  ): Promise<void> {
    const ended = await this.database.db.transaction(async (tx) => {
      await this.customers.lockLine(tx, accountId);
      if (await this.customers.hasActiveOrder(accountId, tx)) {
        throw new CustomerAdminRefusedError('active_order', 'the customer has an active order');
      }
      try {
        return await this.accounts.close(tx, { accountId, ...by }, now);
      } catch (error) {
        if (error instanceof CustomerAccountRefusedError && error.refusal === 'account_closed') {
          throw new CustomerAdminRefusedError('account_closed', 'the account is closed already');
        }
        throw error;
      }
    });
    this.accounts.notifyEnded(ended);
  }

  // 404 unknown_city, unknown_customer.
  async checkCustomer(cityId: string, accountId: string): Promise<void> {
    await this.checkCity(cityId);
    if (!(await this.accounts.exists(accountId))) {
      throw new CustomerAdminRefusedError('unknown_customer', 'no such customer');
    }
  }

  // The ordering lock of every account of the line (slice 2.25c).
  private lockCustomer(tx: Tx, accountId: string): Promise<string[]> {
    return this.customers.lockLine(tx, accountId);
  }

  // The line's open review stop (one per account; a closed account's
  // carries over, AP §8.8), or null.
  private async openStop(tx: Tx, line: string[]): Promise<string | null> {
    const [row] = await tx
      .select({ id: reviewStops.id })
      .from(reviewStops)
      .where(and(inArray(reviewStops.customerAccountId, line), isNull(reviewStops.endedAt)))
      .orderBy(desc(reviewStops.startedAt))
      .limit(1);
    return row?.id ?? null;
  }

  private async endStop(tx: Tx, id: string, by: string, note: string, now: Date): Promise<void> {
    await tx
      .update(reviewStops)
      .set({ endedAt: now, endedBy: by, endNote: note })
      .where(eq(reviewStops.id, id));
  }

  // The latest strike clear of the line, or null.
  private async lastClear(line: string[]) {
    const [row] = await this.database.db
      .select({ at: strikeClears.at, by: strikeClears.by, note: strikeClears.note })
      .from(strikeClears)
      .where(inArray(strikeClears.customerAccountId, line))
      .orderBy(desc(strikeClears.at), desc(strikeClears.id))
      .limit(1);
    return row ?? null;
  }

  // The latest trust mark of the line, or null.
  private async lastMark(line: string[]) {
    const [row] = await this.database.db
      .select({
        at: trustMarks.at,
        by: trustMarks.by,
        note: trustMarks.note,
        trusted: trustMarks.trusted,
      })
      .from(trustMarks)
      .where(inArray(trustMarks.customerAccountId, line))
      .orderBy(desc(trustMarks.at), desc(trustMarks.id))
      .limit(1);
    return row ?? null;
  }

  // AP §9.8 «الحالة» for the search's list.
  private async status(cityId: string, accountId: string, now: Date): Promise<AccountStatus> {
    const [block, dues, stopped, states] = await Promise.all([
      this.customers.activeBlock(accountId, now),
      this.customers.dues(cityId, accountId),
      this.customers.reviewStopped(accountId),
      this.accounts.states([accountId]),
    ]);
    return accountStatus({
      closed: states.get(accountId)?.status === 'closed',
      blocked: block !== null,
      duesOwed: dues !== null,
      reviewStopped: stopped,
    });
  }

  // The line's dues balance in the city, a credit included (+ owes, − a
  // credit; slice 2.25c).
  private async duesBalance(
    cityId: string,
    accountId: string,
  ): Promise<{ amount: bigint; currency: string | null }> {
    let found: { amount: bigint; currency: string | null } = {
      amount: 0n,
      currency: await this.fx.baseCurrency(cityId),
    };
    for (const balance of await this.customers.lineDues(cityId, accountId)) {
      if (balance.amount !== 0n || found.amount === 0n) found = balance;
    }
    return found;
  }

  // The line's blocks (a closed account's carry over, AP §8.8).
  private async blockRecords(line: string[], now: Date): Promise<BlockRecord[]> {
    const rows = await this.database.db
      .select()
      .from(blocks)
      .where(inArray(blocks.customerAccountId, line))
      .orderBy(desc(blocks.startedAt), desc(blocks.id))
      .limit(BLOCKS_LISTED);
    const names = await this.admins.names([
      ...new Set(rows.flatMap((row) => [row.startedBy, ...(row.endedBy ? [row.endedBy] : [])])),
    ]);
    return rows.map((row) => ({
      id: row.id,
      kind: row.kind,
      reason: row.reason,
      reasonLabel: row.reasonLabel,
      note: row.note,
      until: row.until,
      duesAmount: row.duesAmount,
      duesCurrency: row.duesCurrency,
      startedAt: row.startedAt,
      startedByName: names.get(row.startedBy) ?? null,
      endedAt: row.endedAt ?? (row.until !== null && !blockInForce(row, now) ? row.until : null),
      endedByName: row.endedBy === null ? null : (names.get(row.endedBy) ?? null),
      endNote: row.endNote,
      inForce: blockInForce(row, now),
    }));
  }

  // Whether the key already blocked (true), refused with another request
  // (422), or is new (false). Kept for good: a dues block never charges
  // twice.
  private async replayed(
    executor: Pick<Database['db'], 'select'>,
    adminId: string,
    key: string,
    requestHash: string,
  ): Promise<boolean> {
    const [row] = await executor
      .select({ requestHash: blocks.requestHash })
      .from(blocks)
      .where(and(eq(blocks.startedBy, adminId), eq(blocks.idempotencyKey, key)));
    if (!row) return false;
    if (row.requestHash !== requestHash) {
      throw new CustomerAdminRefusedError('idempotency_key_reused', 'the key named another block');
    }
    return true;
  }
}
