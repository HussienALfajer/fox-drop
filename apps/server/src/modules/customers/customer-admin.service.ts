import { createHash } from 'node:crypto';
import { Inject, Injectable } from '@nestjs/common';
import { and, count, desc, eq, gte, ilike, isNull, or, sql } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { type AuditActor, type AuditRequestContext, AuditService } from '../audit/index.js';
import { ContentRefusedError, ContentService } from '../content/index.js';
import { FxService } from '../fx/index.js';
import { GeoService } from '../geo/index.js';
import { AdminSessionsService, CustomerAccountsService } from '../identity/index.js';
import { LedgerService } from '../ledger/index.js';
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
import { type ActiveBlock, CustomersService, customerOrderLock } from './customers.service.js';
import { blocks, type genders, lateCancelStrikes, profiles, reviewStops } from './schema.js';

export type CustomerAdminRefusal =
  | 'unknown_customer'
  | 'invalid_block'
  | 'already_blocked'
  | 'not_blocked'
  | 'no_base_currency'
  | 'unknown_reason'
  | 'unknown_city'
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
  reviewStop: { startedAt: Date } | null;
  trusted: boolean;
  delivered: number;
  trustedAfter: number;
  lateCancels: { inWindow: number; total: number; limit: number; windowDays: number };
  fakeOrders: number;
  // What the customer owes in the city's base (+ owes, − a credit), 0 with
  // no dues account.
  dues: { amount: bigint; currency: string | null };
  blocks: BlockRecord[];
  // Content's active customer_block reasons, for «حظر» (AP Appendix B).
  blockReasons: { code: string; label: string }[];
}

// The latest blocks the profile lists (decided by us).
const BLOCKS_LISTED = 20;
const SEARCH_RESULTS = 20;

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
      const id = await this.accounts.customerByPhone(query.phone);
      ids = id === null ? [] : [id];
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
    const since = new Date(now.getTime() - windowDays * 24 * 60 * 60 * 1000);
    const [profile, phone, block, stop, orders, strikes, dues, records, reasons] =
      await Promise.all([
        this.customers.profile(accountId),
        this.accounts.phone(accountId),
        this.customers.activeBlock(accountId, now),
        this.database.db
          .select({ startedAt: reviewStops.startedAt })
          .from(reviewStops)
          .where(and(eq(reviewStops.customerAccountId, accountId), isNull(reviewStops.endedAt))),
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
          .where(eq(lateCancelStrikes.customerAccountId, accountId)),
        this.duesBalance(cityId, accountId),
        this.blockRecords(accountId, now),
        this.content.reasonsOf('customer_block'),
      ]);
    return {
      id: accountId,
      firstName: profile?.firstName ?? null,
      lastName: profile?.lastName ?? null,
      gender: profile?.gender ?? null,
      birthday: profile?.birthday ?? null,
      maskedPhone: phone === null ? null : maskedPhone(phone),
      status: accountStatus({
        blocked: block !== null,
        duesOwed: dues.amount > 0n,
        reviewStopped: stop.length > 0,
      }),
      block,
      reviewStop: stop[0] ?? null,
      trusted: orders.trusted,
      delivered: orders.delivered,
      trustedAfter: orders.trustedAfter,
      lateCancels: {
        inWindow: strikes[0]?.inWindow ?? 0,
        total: strikes[0]?.total ?? 0,
        limit: strikesLimit,
        windowDays,
      },
      fakeOrders: orders.fakeOrders,
      dues,
      blocks: records,
      blockReasons: reasons
        .filter((reason) => reason.active)
        .map(({ code, label }) => ({ code, label })),
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
      await tx.execute(
        sql`SELECT pg_advisory_xact_lock(hashtextextended(${customerOrderLock(command.accountId)}, 0))`,
      );
      if (await this.replayed(tx, admin.accountId, command.idempotencyKey, requestHash)) return;
      const open = await tx
        .select()
        .from(blocks)
        .where(
          and(
            eq(blocks.customerAccountId, command.accountId),
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
  // (decided by us, to confirm with the owner); 409 not_blocked when that
  // block is not in force, so a repeat needs no key.
  async unblock(
    admin: CustomerAdmin,
    command: { cityId: string; accountId: string; blockId: string; note: string },
    now: Date,
  ): Promise<void> {
    await this.database.db.transaction(async (tx) => {
      await tx.execute(
        sql`SELECT pg_advisory_xact_lock(hashtextextended(${customerOrderLock(command.accountId)}, 0))`,
      );
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

  // AP §9.8 «الحالة» for the search's list.
  private async status(cityId: string, accountId: string, now: Date): Promise<AccountStatus> {
    const [block, dues, stopped] = await Promise.all([
      this.customers.activeBlock(accountId, now),
      this.customers.dues(cityId, accountId),
      this.customers.reviewStopped(accountId),
    ]);
    return accountStatus({
      blocked: block !== null,
      duesOwed: dues !== null,
      reviewStopped: stopped,
    });
  }

  // The dues balance in the city, a credit included (+ owes, − a credit).
  private async duesBalance(
    cityId: string,
    accountId: string,
  ): Promise<{ amount: bigint; currency: string | null }> {
    const accounts = await this.ledger.ownerAccounts(cityId, accountId, 'customer.dues');
    let found: { amount: bigint; currency: string | null } = {
      amount: 0n,
      currency: await this.fx.baseCurrency(cityId),
    };
    for (const account of accounts) {
      const balance = await this.ledger.balance(account.id);
      if (balance.amount !== 0n || found.amount === 0n) found = balance;
    }
    return found;
  }

  private async blockRecords(accountId: string, now: Date): Promise<BlockRecord[]> {
    const rows = await this.database.db
      .select()
      .from(blocks)
      .where(eq(blocks.customerAccountId, accountId))
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
