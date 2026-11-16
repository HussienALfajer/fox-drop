import { createHash } from 'node:crypto';
import { Inject, Injectable } from '@nestjs/common';
import { and, desc, eq, sql } from 'drizzle-orm';
import type { NodePgDatabase } from 'drizzle-orm/node-postgres';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { type AuditActor, type AuditRequestContext, AuditService } from '../audit/index.js';
import { ContentService, formatMoney, NotificationTexts } from '../content/index.js';
import { FxService } from '../fx/index.js';
import { AlertsService, PushQueue } from '../notifications/index.js';
import { lockCityCurrencies, SettingsService } from '../settings/index.js';
import { generatedCode } from './promo-codes.js';
import {
  type CompensationKind,
  compensations,
  type CompensationStatus,
  promoCodes,
} from './schema.js';

type Tx = Parameters<Parameters<NodePgDatabase['transaction']>[0]>[0];
export type CompensationRow = typeof compensations.$inferSelect;

// An amount, or a percentage (basis points) with its maximum amount (AP §6.4).
export type CompensationValue =
  | { kind: 'fixed_amount'; amount: bigint }
  | { kind: 'percentage'; percentBp: number; maxDiscount: bigint };

// The order a compensation is linked to (AP §6.4), as ordering reads it.
export interface CompensationOrder {
  id: string;
  cityId: string;
  number: bigint;
  customerAccountId: string;
  // The order's customer total, which the caps are a percentage of.
  total: bigint;
  currency: string;
}

// Who compensates: their roles and permissions decide the cap.
export interface CompensationAdmin {
  accountId: string;
  roles: readonly string[];
  permissions: readonly string[];
  actor: AuditActor;
  context: AuditRequestContext;
}

export interface Compensation extends CompensationRow {
  // The personal code once issued.
  code: string | null;
  codeValidTo: Date | null;
}

export type CompensationRefusal =
  | 'unknown_compensation'
  | 'compensation_decided'
  | 'no_base_currency'
  | 'currency_changed'
  | 'idempotency_key_reused';

export class CompensationRefusedError extends Error {
  constructor(
    readonly refusal: CompensationRefusal,
    message: string,
  ) {
    super(message);
  }
}

const DAY_MS = 24 * 60 * 60 * 1000;
const DRAWS = 5;
// AP §6.4: the roles with a cap of their own; another role that may
// compensate has none, so every request of it waits for OWN.
const CAPPED_ROLES = ['SUP', 'OPS'] as const;

// What counts against a cap (AP §6.4): the amount, or a percentage's maximum.
export function countedValue(value: { amount: bigint | null; maxDiscount: bigint | null }) {
  return value.amount ?? value.maxDiscount ?? 0n;
}

// AP §6.4 (slice 2.22a): «تعويض الزبون», a next-order personal code within
// the issuer's cumulative cap for the order, or a request OWN approves,
// edits or rejects in «طلبات الموافقة».
@Injectable()
export class CompensationsService {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly audit: AuditService,
    private readonly content: ContentService,
    private readonly texts: NotificationTexts,
    private readonly pushes: PushQueue,
    private readonly alerts: AlertsService,
    private readonly fx: FxService,
    private readonly settings: SettingsService,
  ) {}

  // The admin's cap as a percentage of the order's customer total (AP §6.4):
  // none for OWN (who approves above caps), else the highest of their roles'.
  async capPct(cityId: string, admin: Pick<CompensationAdmin, 'roles' | 'permissions'>) {
    if (admin.permissions.includes('compensation.approve_above_cap')) return null;
    let cap = 0;
    for (const role of CAPPED_ROLES) {
      if (!admin.roles.includes(role)) continue;
      cap = Math.max(
        cap,
        await this.settings.get(`support.compensation_cap_pct.${role}`, { cityId }),
      );
    }
    return cap;
  }

  // The order's compensations, newest first, and what the admin may still
  // give on it without approval (null: no cap).
  async forOrder(
    order: CompensationOrder,
    admin: Pick<CompensationAdmin, 'roles' | 'permissions'>,
  ): Promise<{ compensations: Compensation[]; capLeft: bigint | null }> {
    const rows = await this.withCodes(eq(compensations.orderId, order.id));
    const cap = await this.capPct(order.cityId, admin);
    if (cap === null) return { compensations: rows, capLeft: null };
    const left = capAmount(order.total, cap) - issuedSum(rows);
    return { compensations: rows, capLeft: left > 0n ? left : 0n };
  }

  // «طلبات الموافقة»: the city's requests waiting for OWN, oldest first.
  async waiting(cityId: string): Promise<Compensation[]> {
    return (
      await this.withCodes(
        and(eq(compensations.cityId, cityId), eq(compensations.status, 'waiting')),
      )
    ).reverse();
  }

  // AP §6.4: issued with its code and push when the order's compensations,
  // this one included, stay within the admin's cap; else waiting for OWN,
  // with the alert «طلب موافقة تعويض». The reason is checked by content
  // (unknown_reason, invalid_value). 409 no_base_currency, currency_changed
  // (the order is in another currency than the city's base); 422
  // idempotency_key_reused.
  async request(
    order: CompensationOrder,
    value: CompensationValue,
    reason: { code: string; note: string | null },
    admin: CompensationAdmin,
    idempotencyKey: string,
    now: Date,
  ): Promise<Compensation> {
    const chosen = await this.content.choose('compensation', reason);
    const cap = await this.capPct(order.cityId, admin);
    const requestHash = hashOf([order.id, value, chosen.code, chosen.note]);
    return this.database.db.transaction(async (tx) => {
      await lock(tx, `marketing.compensation_key:${admin.accountId}:${idempotencyKey}`);
      const replayed = await this.replay(tx, admin.accountId, idempotencyKey, requestHash);
      if (replayed) return replayed;
      // One compensation of an order at a time, so two never pass its cap
      // together.
      await lock(tx, `marketing.compensation:${order.id}`);
      // The city's codes, then its currencies: PromoCodesService.create's
      // order, so the two never deadlock.
      await lock(tx, `marketing.codes:${order.cityId}`);
      await lockCityCurrencies(tx, order.cityId);
      const currency = await this.fx.baseCurrency(order.cityId, tx);
      if (currency === null) {
        throw new CompensationRefusedError('no_base_currency', 'the city has no base currency');
      }
      if (currency !== order.currency) {
        throw new CompensationRefusedError(
          'currency_changed',
          'the order is in another currency than the base',
        );
      }
      const issued = await tx
        .select({ amount: compensations.amount, maxDiscount: compensations.maxDiscount })
        .from(compensations)
        .where(and(eq(compensations.orderId, order.id), eq(compensations.status, 'issued')));
      const within =
        cap === null ||
        issuedSum(issued) + countedValue(stored(value)) <= capAmount(order.total, cap);
      const [row] = (await tx
        .insert(compensations)
        .values({
          cityId: order.cityId,
          orderId: order.id,
          orderNumber: order.number,
          customerAccountId: order.customerAccountId,
          ...stored(value),
          currency,
          reasonCode: chosen.code,
          reasonLabel: chosen.label,
          note: chosen.note,
          status: 'waiting',
          requestedBy: admin.accountId,
          requestedAt: now,
          idempotencyKey,
          requestHash,
        })
        .returning()) as [CompensationRow];
      const answer = within
        ? await this.issue(tx, row, admin.accountId, now)
        : { ...row, code: null, codeValidTo: null };
      await this.audit.recordWrite(
        {
          actor: admin.actor,
          context: admin.context,
          cityId: order.cityId,
          action: within ? 'compensation.issue' : 'compensation.request',
          target: { type: 'compensation', id: row.id },
          before: null,
          after: { orderNumber: order.number.toString(), code: answer.code, ...auditOf(answer) },
          reason: chosen.note,
        },
        tx,
      );
      if (!within) await this.syncAlert(tx, row, true, now);
      return answer;
    });
  }

  // OWN approves a waiting request, with the value as asked or edited (AP
  // §6.4 item 2), and the customer gets the code only then. 404
  // unknown_compensation; 409 compensation_decided, no_base_currency,
  // currency_changed.
  async approve(
    cityId: string,
    id: string,
    value: CompensationValue | null,
    admin: CompensationAdmin,
    now: Date,
  ): Promise<Compensation> {
    return this.database.db.transaction(async (tx) => {
      const before = await this.lockedWaiting(tx, cityId, id);
      // The order's lock, so a request on it meanwhile counts this one (AP
      // §6.4: every compensation of the order by anyone); then the codes and
      // the currencies, in request's order.
      await lock(tx, `marketing.compensation:${before.orderId}`);
      await lock(tx, `marketing.codes:${cityId}`);
      await lockCityCurrencies(tx, cityId);
      const currency = await this.fx.baseCurrency(cityId, tx);
      if (currency === null) {
        throw new CompensationRefusedError('no_base_currency', 'the city has no base currency');
      }
      if (currency !== before.currency) {
        throw new CompensationRefusedError('currency_changed', 'the base currency changed');
      }
      const row: CompensationRow = {
        ...before,
        ...(value ? stored(value) : {}),
        decidedBy: admin.accountId,
        decidedAt: now,
      };
      const issued = await this.issue(tx, row, admin.accountId, now);
      await this.audit.recordWrite(
        {
          actor: admin.actor,
          context: admin.context,
          cityId,
          action: 'compensation.approve',
          target: { type: 'compensation', id },
          before: auditOf(before),
          after: auditOf(issued),
          reason: null,
        },
        tx,
      );
      await this.syncAlert(tx, issued, false, now);
      return issued;
    });
  }

  // OWN rejects a waiting request; the customer hears nothing. 404
  // unknown_compensation; 409 compensation_decided.
  async reject(cityId: string, id: string, admin: CompensationAdmin, now: Date) {
    return this.database.db.transaction(async (tx) => {
      const before = await this.lockedWaiting(tx, cityId, id);
      const [row] = (await tx
        .update(compensations)
        .set({ status: 'rejected', decidedBy: admin.accountId, decidedAt: now })
        .where(eq(compensations.id, id))
        .returning()) as [CompensationRow];
      await this.audit.recordWrite(
        {
          actor: admin.actor,
          context: admin.context,
          cityId,
          action: 'compensation.reject',
          target: { type: 'compensation', id },
          before: { status: before.status },
          after: { status: row.status },
          reason: null,
        },
        tx,
      );
      await this.syncAlert(tx, row, false, now);
      return { ...row, code: null, codeValidTo: null };
    });
  }

  // The personal code (valid support.personal_code_valid_days from now) and
  // the push «لك كود تعويض {القيمة}: {الكود}» (CU §14 #16), in the
  // transaction that issues it. `row` carries OWN's decision and edited value
  // when approved, stored with the status in one statement.
  private async issue(
    tx: Tx,
    row: CompensationRow,
    createdBy: string,
    now: Date,
  ): Promise<Compensation> {
    // The caller holds the city's codes lock (`marketing.codes:<cityId>`).
    const days = await this.settings.get('support.personal_code_valid_days', {
      cityId: row.cityId,
    });
    let code: string | null = null;
    for (let i = 0; i < DRAWS && code === null; i += 1) {
      const candidate = generatedCode('');
      const [taken] = await tx
        .select({ id: promoCodes.id })
        .from(promoCodes)
        .where(and(eq(promoCodes.cityId, row.cityId), eq(promoCodes.code, candidate)));
      if (!taken) code = candidate;
    }
    if (code === null) throw new Error('could not draw a free code');
    const validTo = new Date(now.getTime() + days * DAY_MS);
    const [created] = (await tx
      .insert(promoCodes)
      .values({
        cityId: row.cityId,
        code,
        kind: row.kind,
        percentBp: row.percentBp,
        amount: row.amount,
        maxDiscount: row.maxDiscount,
        currency: row.currency,
        validFrom: now,
        validTo,
        totalLimit: 1,
        perCustomerLimit: 1,
        audience: 'everyone',
        restaurantIds: [],
        zoneIds: [],
        funding: 'platform',
        merchantShareBp: 0,
        visibility: 'personal',
        customerAccountId: row.customerAccountId,
        createdBy,
        updatedBy: createdBy,
      })
      .returning({ id: promoCodes.id })) as [{ id: string }];
    const [issued] = (await tx
      .update(compensations)
      .set({
        kind: row.kind,
        amount: row.amount,
        percentBp: row.percentBp,
        maxDiscount: row.maxDiscount,
        status: 'issued',
        codeId: created.id,
        decidedBy: row.decidedBy,
        decidedAt: row.decidedAt,
      })
      .where(eq(compensations.id, row.id))
      .returning()) as [CompensationRow];
    const known = new Map(
      (await this.fx.currencies()).map((each) => [
        each.code,
        { symbol: each.symbol, decimals: each.decimals },
      ]),
    );
    const templateKey = 'customer.compensation_code';
    const rendered = await this.texts.render(
      templateKey,
      { القيمة: valueText(issued, known), الكود: code },
      tx,
    );
    await this.pushes.enqueue(
      tx,
      [
        {
          source: `marketing:${templateKey}:${issued.id}`,
          recipient: { party: 'customer', accountId: issued.customerAccountId },
          templateKey,
          body: rendered.body,
          level: rendered.level,
          priority: rendered.priority,
          data: { target: 'codes' },
          at: now,
          // A phone off for a while still gets the code it can use.
          expiresAt: validTo,
        },
      ],
      now,
    );
    return { ...issued, code, codeValidTo: validTo };
  }

  private async syncAlert(tx: Tx, row: CompensationRow, open: boolean, now: Date) {
    await this.alerts.sync(
      tx,
      {
        type: 'compensation',
        id: row.id,
        cityId: row.cityId,
        details: { orderNumber: row.orderNumber.toString() },
      },
      ['compensation_approval'],
      open ? ['compensation_approval'] : [],
      now,
    );
  }

  private async lockedWaiting(tx: Tx, cityId: string, id: string): Promise<CompensationRow> {
    const [row] = await tx
      .select()
      .from(compensations)
      .where(and(eq(compensations.cityId, cityId), eq(compensations.id, id)))
      .for('update');
    if (!row) throw new CompensationRefusedError('unknown_compensation', 'no such compensation');
    if (row.status !== 'waiting') {
      throw new CompensationRefusedError('compensation_decided', 'the request was decided');
    }
    return row;
  }

  private async replay(
    tx: Tx,
    accountId: string,
    key: string,
    requestHash: string,
  ): Promise<Compensation | null> {
    const [row] = await tx
      .select()
      .from(compensations)
      .where(and(eq(compensations.requestedBy, accountId), eq(compensations.idempotencyKey, key)));
    // A key is kept with its request for good (one row per key), so a repeat
    // after 24 hours answers it too.
    if (!row) return null;
    if (row.requestHash !== requestHash) {
      throw new CompensationRefusedError('idempotency_key_reused', 'the key came with another');
    }
    const [answer] = await this.withCodes(eq(compensations.id, row.id), tx);
    return answer!;
  }

  private async withCodes(
    where: ReturnType<typeof eq> | undefined,
    executor: Pick<NodePgDatabase, 'select'> = this.database.db,
  ): Promise<Compensation[]> {
    const rows = await executor
      .select({ row: compensations, code: promoCodes.code, codeValidTo: promoCodes.validTo })
      .from(compensations)
      .leftJoin(promoCodes, eq(promoCodes.id, compensations.codeId))
      .where(where)
      .orderBy(desc(compensations.requestedAt), desc(compensations.id));
    return rows.map(({ row, code, codeValidTo }) => ({ ...row, code, codeValidTo }));
  }
}

function stored(value: CompensationValue) {
  return value.kind === 'fixed_amount'
    ? {
        kind: 'fixed_amount' as CompensationKind,
        amount: value.amount,
        percentBp: null,
        maxDiscount: null,
      }
    : {
        kind: 'percentage' as CompensationKind,
        amount: null,
        percentBp: value.percentBp,
        maxDiscount: value.maxDiscount,
      };
}

function issuedSum(
  rows: readonly {
    amount: bigint | null;
    maxDiscount: bigint | null;
    status?: CompensationStatus;
  }[],
) {
  return rows
    .filter((row) => row.status === undefined || row.status === 'issued')
    .reduce((sum, row) => sum + countedValue(row), 0n);
}

// The cap's amount: pct% of the total, rounded down to the minor unit.
function capAmount(total: bigint, pct: number): bigint {
  return (total * BigInt(Math.round(pct * 100))) / 10000n;
}

// «{القيمة}» of the push: «25 ₺», or «20% بحد أقصى 50 ₺», as the panel
// and «أكواد الخصم» say it (the wording is ours, to confirm with the owner).
function valueText(
  row: CompensationRow,
  known: ReadonlyMap<string, { symbol: string; decimals: number }>,
): string {
  if (row.kind === 'fixed_amount') return formatMoney(row.amount!, row.currency, known);
  const pct = row.percentBp! / 100;
  return `${pct}% بحد أقصى ${formatMoney(row.maxDiscount!, row.currency, known)}`;
}

function auditOf(row: CompensationRow) {
  return {
    kind: row.kind,
    amount: row.amount?.toString() ?? null,
    percentBp: row.percentBp,
    maxDiscount: row.maxDiscount?.toString() ?? null,
    currency: row.currency,
    reason: row.reasonCode,
    status: row.status,
  };
}

async function lock(tx: Tx, key: string) {
  await tx.execute(sql`SELECT pg_advisory_xact_lock(hashtextextended(${key}, 0))`);
}

function hashOf(value: unknown): string {
  return createHash('sha256')
    .update(JSON.stringify(value, (_, each) => (typeof each === 'bigint' ? each.toString() : each)))
    .digest('hex');
}
