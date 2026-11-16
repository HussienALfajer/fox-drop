import { createHash, randomUUID } from 'node:crypto';
import { Inject, Injectable, type OnModuleInit } from '@nestjs/common';
import { and, desc, eq, gt, inArray, sql } from 'drizzle-orm';
import type { NodePgDatabase } from 'drizzle-orm/node-postgres';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { type AuditActor, type AuditRequestContext, AuditService } from '../audit/index.js';
import { FxService } from '../fx/index.js';
import { GeoService } from '../geo/index.js';
import { MerchantsService } from '../merchants/index.js';
import { lockCityCurrencies } from '../settings/index.js';
import {
  checkPromoFields,
  CODE_PATTERN,
  generatedCode,
  merchantShareBp,
  normalizeCode,
  type PromoFields,
} from './promo-codes.js';
import { idempotencyKeys, promoCodes, type PromoCodeStatus } from './schema.js';

type Tx = Parameters<Parameters<NodePgDatabase['transaction']>[0]>[0];
export type PromoCode = typeof promoCodes.$inferSelect;

export type PromoRefusal =
  | 'invalid_promo_code'
  | 'code_taken'
  | 'unknown_city'
  | 'unknown_promo_code'
  | 'no_base_currency'
  | 'currency_changed'
  | 'idempotency_key_reused';

export class PromoRefusedError extends Error {
  constructor(
    readonly refusal: PromoRefusal,
    message: string,
  ) {
    super(message);
  }
}

export interface PromoChange {
  accountId: string;
  actor: AuditActor;
  context: AuditRequestContext;
}

const KEY_LIFETIME_MS = 24 * 60 * 60 * 1000;
// A generated code that collides with an existing one is drawn again.
const DRAWS_PER_CODE = 5;

// AP §9.11.1 «أكواد الخصم» (slice 2.21a): the codes OWN creates, edits,
// pauses and resumes. Using a code in an order comes with 2.21b.
@Injectable()
export class PromoCodesService implements OnModuleInit {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly audit: AuditService,
    private readonly fx: FxService,
    private readonly geo: GeoService,
    private readonly merchants: MerchantsService,
  ) {}

  // A code's amounts are in the city's base currency (AP §8.6), so fx refuses
  // a base change while a code that has not ended keeps one in another.
  onModuleInit(): void {
    this.fx.useCityAmounts(async (cityId, executor) => {
      const rows = await executor
        .select({ code: promoCodes.code, currency: promoCodes.currency })
        .from(promoCodes)
        .where(and(eq(promoCodes.cityId, cityId), gt(promoCodes.validTo, sql`now()`)));
      return rows.map((row) => ({ key: `promo_code:${row.code}`, currency: row.currency }));
    });
  }

  // Every code of the city, newest first.
  async list(cityId: string): Promise<PromoCode[]> {
    return this.database.db
      .select()
      .from(promoCodes)
      .where(eq(promoCodes.cityId, cityId))
      .orderBy(desc(promoCodes.createdAt), promoCodes.code);
  }

  async code(cityId: string, id: string): Promise<PromoCode | null> {
    const [row] = await this.database.db
      .select()
      .from(promoCodes)
      .where(and(eq(promoCodes.cityId, cityId), eq(promoCodes.id, id)));
    return row ?? null;
  }

  // One code typed by hand, or a batch of `count` generated codes with the
  // prefix, all with the same fields. 400 invalid_promo_code; 404
  // unknown_city; 409 code_taken, no_base_currency; 422 idempotency_key_reused.
  async create(
    cityId: string,
    what: { code: string } | { count: number; prefix: string },
    fields: PromoFields,
    idempotencyKey: string,
    change: PromoChange,
  ): Promise<PromoCode[]> {
    const typed = 'code' in what ? normalizeCode(what.code) : null;
    if (typed !== null && !CODE_PATTERN.test(typed)) {
      throw new PromoRefusedError('invalid_promo_code', 'a code is 3 to 20 letters and digits');
    }
    const prefix = 'prefix' in what ? normalizeCode(what.prefix) : '';
    await this.checkFields(cityId, fields);
    const requestHash = hashOf([cityId, typed ?? what, fields]);
    const replayed = await this.replay(
      this.database.db,
      change.accountId,
      idempotencyKey,
      requestHash,
    );
    if (replayed) return this.codesById(replayed);

    return this.database.db.transaction(async (tx) => {
      await tx.execute(
        sql`SELECT pg_advisory_xact_lock(hashtextextended(${`marketing.key:${change.accountId}:${idempotencyKey}`}, 0))`,
      );
      const again = await this.replay(tx, change.accountId, idempotencyKey, requestHash);
      if (again) return this.codesById(again, tx);
      // One writer of the city's codes at a time, so a code is never taken
      // twice, and none while its base currency changes.
      await tx.execute(
        sql`SELECT pg_advisory_xact_lock(hashtextextended(${`marketing.codes:${cityId}`}, 0))`,
      );
      await lockCityCurrencies(tx, cityId);
      const currency = await this.baseCurrency(cityId, tx);
      const taken = new Set(
        (
          await tx
            .select({ code: promoCodes.code })
            .from(promoCodes)
            .where(eq(promoCodes.cityId, cityId))
        ).map((row) => row.code),
      );
      let codes: string[];
      if (typed !== null) {
        if (taken.has(typed)) throw new PromoRefusedError('code_taken', 'the code exists already');
        codes = [typed];
      } else {
        codes = [];
        const count = (what as { count: number }).count;
        while (codes.length < count) {
          let drawn: string | null = null;
          for (let i = 0; i < DRAWS_PER_CODE && drawn === null; i += 1) {
            const candidate = generatedCode(prefix);
            if (!taken.has(candidate)) drawn = candidate;
          }
          if (drawn === null) throw new Error('could not draw a free code');
          taken.add(drawn);
          codes.push(drawn);
        }
      }
      const batchId = typed === null ? randomUUID() : null;
      const created = await tx
        .insert(promoCodes)
        .values(
          codes.map((code) => ({
            cityId,
            code,
            batchId,
            ...stored(fields),
            currency,
            createdBy: change.accountId,
            updatedBy: change.accountId,
          })),
        )
        .returning();
      await tx
        .insert(idempotencyKeys)
        .values({
          accountId: change.accountId,
          key: idempotencyKey,
          requestHash,
          codeIds: created.map((row) => row.id),
          createdAt: new Date(),
        })
        .onConflictDoUpdate({
          target: [idempotencyKeys.accountId, idempotencyKeys.key],
          set: {
            requestHash,
            codeIds: created.map((row) => row.id),
            createdAt: new Date(),
          },
        });
      await this.audit.recordWrite(
        {
          actor: change.actor,
          context: change.context,
          cityId,
          action: batchId ? 'promo_code.generate' : 'promo_code.create',
          target: batchId
            ? { type: 'promo_code_batch', id: batchId }
            : { type: 'promo_code', id: created[0]!.id },
          before: null,
          after: { codes: codes.length === 1 ? codes[0] : codes.length, ...auditOf(fields) },
          reason: null,
        },
        tx,
      );
      return created;
    });
  }

  // Replaces a code's fields (not the code itself); setting them again
  // changes nothing. 400 invalid_promo_code; 404 unknown_promo_code;
  // 409 no_base_currency, currency_changed (its amounts are in an earlier
  // base: a new code is made in the new one).
  async edit(cityId: string, id: string, fields: PromoFields, change: PromoChange) {
    await this.checkFields(cityId, fields);
    return this.database.db.transaction(async (tx) => {
      await lockCityCurrencies(tx, cityId);
      const before = await this.locked(tx, cityId, id);
      const currency = await this.baseCurrency(cityId, tx);
      if (before.currency !== currency) {
        throw new PromoRefusedError('currency_changed', 'the code is in an earlier base currency');
      }
      const [after] = (await tx
        .update(promoCodes)
        .set({
          ...stored(fields),
          currency,
          updatedBy: change.accountId,
          updatedAt: new Date(),
        })
        .where(eq(promoCodes.id, id))
        .returning()) as [PromoCode];
      await this.audit.recordWrite(
        {
          actor: change.actor,
          context: change.context,
          cityId,
          action: 'promo_code.edit',
          target: { type: 'promo_code', id },
          before: auditOfRow(before),
          after: auditOfRow(after),
          reason: null,
        },
        tx,
      );
      return after;
    });
  }

  // Pauses or resumes a code; the same status again changes nothing.
  // 404 unknown_promo_code.
  async setStatus(cityId: string, id: string, status: PromoCodeStatus, change: PromoChange) {
    return this.database.db.transaction(async (tx) => {
      const before = await this.locked(tx, cityId, id);
      if (before.status === status) return before;
      const [after] = (await tx
        .update(promoCodes)
        .set({ status, updatedBy: change.accountId, updatedAt: new Date() })
        .where(eq(promoCodes.id, id))
        .returning()) as [PromoCode];
      await this.audit.recordWrite(
        {
          actor: change.actor,
          context: change.context,
          cityId,
          action: status === 'paused' ? 'promo_code.pause' : 'promo_code.resume',
          target: { type: 'promo_code', id },
          before: { status: before.status },
          after: { status },
          reason: null,
        },
        tx,
      );
      return after;
    });
  }

  // AP §9.11.1 «Code report» (slice 2.21d): «تمديد» moves the end later,
  // past now and past the end it had, so an ended code runs again. It sets a
  // value, so no key. 400 invalid_promo_code; 404 unknown_promo_code; 409
  // currency_changed for a code saved in an earlier base.
  async extend(cityId: string, id: string, validTo: Date, change: PromoChange) {
    return this.database.db.transaction(async (tx) => {
      await lockCityCurrencies(tx, cityId);
      const before = await this.locked(tx, cityId, id);
      if (validTo.getTime() <= Math.max(before.validTo.getTime(), Date.now())) {
        throw new PromoRefusedError(
          'invalid_promo_code',
          'the new end must come after the current end and after now',
        );
      }
      if (before.currency !== (await this.baseCurrency(cityId, tx))) {
        throw new PromoRefusedError('currency_changed', 'the code is in an earlier base currency');
      }
      const [after] = (await tx
        .update(promoCodes)
        .set({ validTo, updatedBy: change.accountId, updatedAt: new Date() })
        .where(eq(promoCodes.id, id))
        .returning()) as [PromoCode];
      await this.audit.recordWrite(
        {
          actor: change.actor,
          context: change.context,
          cityId,
          action: 'promo_code.extend',
          target: { type: 'promo_code', id },
          before: { validTo: before.validTo.toISOString() },
          after: { validTo: validTo.toISOString() },
          reason: null,
        },
        tx,
      );
      return after;
    });
  }

  private async locked(tx: Tx, cityId: string, id: string): Promise<PromoCode> {
    const [row] = await tx
      .select()
      .from(promoCodes)
      .where(and(eq(promoCodes.cityId, cityId), eq(promoCodes.id, id)))
      .for('update');
    if (!row) throw new PromoRefusedError('unknown_promo_code', 'no such code in the city');
    return row;
  }

  // The rules of the fields, then the restaurants and zones of the city.
  private async checkFields(cityId: string, fields: PromoFields): Promise<void> {
    const problem = checkPromoFields(fields);
    if (problem !== null) throw new PromoRefusedError('invalid_promo_code', problem);
    if ((await this.geo.cityTimeZone(cityId)) === null) {
      throw new PromoRefusedError('unknown_city', 'no such city');
    }
    const [restaurants, zones] = await Promise.all([
      fields.restaurantIds.length > 0 ? this.merchants.restaurantIds(cityId) : [],
      fields.zoneIds.length > 0 ? this.geo.zones(cityId) : [],
    ]);
    const restaurantIds = new Set(restaurants.map((each) => each.id));
    if (fields.restaurantIds.some((id) => !restaurantIds.has(id))) {
      throw new PromoRefusedError('invalid_promo_code', 'a restaurant is not one of the city');
    }
    const zoneIds = new Set(zones.map((each) => each.id));
    if (fields.zoneIds.some((id) => !zoneIds.has(id))) {
      throw new PromoRefusedError('invalid_promo_code', 'a zone is not one of the city');
    }
  }

  private async baseCurrency(cityId: string, tx: Tx): Promise<string> {
    const currency = await this.fx.baseCurrency(cityId, tx);
    if (currency === null) {
      throw new PromoRefusedError('no_base_currency', 'the city has no base currency yet');
    }
    return currency;
  }

  private async replay(
    executor: Pick<NodePgDatabase, 'select'>,
    accountId: string,
    key: string,
    requestHash: string,
  ): Promise<string[] | null> {
    const [row] = await executor
      .select()
      .from(idempotencyKeys)
      .where(and(eq(idempotencyKeys.accountId, accountId), eq(idempotencyKeys.key, key)));
    if (!row || row.createdAt.getTime() < Date.now() - KEY_LIFETIME_MS) return null;
    if (row.requestHash !== requestHash) {
      throw new PromoRefusedError('idempotency_key_reused', 'the key came with another command');
    }
    return row.codeIds;
  }

  private async codesById(
    ids: string[],
    executor: Pick<NodePgDatabase, 'select'> = this.database.db,
  ): Promise<PromoCode[]> {
    return executor
      .select()
      .from(promoCodes)
      .where(inArray(promoCodes.id, ids))
      .orderBy(promoCodes.code);
  }
}

function stored(fields: PromoFields) {
  return {
    kind: fields.kind,
    percentBp: fields.percentBp,
    amount: fields.amount,
    maxDiscount: fields.maxDiscount,
    minOrder: fields.minOrder,
    validFrom: fields.validFrom,
    validTo: fields.validTo,
    startMinute: fields.startMinute,
    endMinute: fields.endMinute,
    totalLimit: fields.totalLimit,
    perCustomerLimit: fields.perCustomerLimit,
    audience: fields.audience,
    restaurantIds: fields.restaurantIds,
    zoneIds: fields.zoneIds,
    funding: fields.funding,
    merchantShareBp: merchantShareBp(fields),
    dailyBudget: fields.dailyBudget,
    visibility: fields.visibility,
  };
}

// The audit log keeps amounts as strings and times as ISO text.
function auditOf(fields: PromoFields) {
  return JSON.parse(
    JSON.stringify(stored(fields), (_, each) =>
      typeof each === 'bigint' ? each.toString() : each,
    ),
  ) as Record<string, unknown>;
}

function auditOfRow(row: PromoCode) {
  const { kind, percentBp, amount, maxDiscount, minOrder, validFrom, validTo } = row;
  return auditOf({
    kind,
    percentBp,
    amount,
    maxDiscount,
    minOrder,
    validFrom,
    validTo,
    startMinute: row.startMinute,
    endMinute: row.endMinute,
    totalLimit: row.totalLimit,
    perCustomerLimit: row.perCustomerLimit,
    audience: row.audience,
    restaurantIds: row.restaurantIds,
    zoneIds: row.zoneIds,
    funding: row.funding,
    sharedMerchantBp: row.funding === 'shared' ? row.merchantShareBp : null,
    dailyBudget: row.dailyBudget,
    visibility: row.visibility,
  });
}

function hashOf(value: unknown): string {
  return createHash('sha256')
    .update(JSON.stringify(value, (_, each) => (typeof each === 'bigint' ? each.toString() : each)))
    .digest('hex');
}
