import 'reflect-metadata';
import { randomBytes, randomUUID } from 'node:crypto';
import type { NestFastifyApplication } from '@nestjs/platform-fastify';
import pg from 'pg';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { ApiModule } from '../../api.module.js';
import { createDatabase, type Database } from '../../database/database.js';
import { startTestDatabase, type TestDatabase } from '../../database/test-database.js';
import { createApiApp } from '../../http/create-api-app.js';
import { startTestValkey, type TestValkey } from '../../valkey/test-valkey.js';
import { FxService } from '../fx/index.js';
import { type CodeCart, PromoCodeUsesService } from './promo-code-uses.service.js';

// A code checked, held at placing and settled (AP §9.11.1, slice 2.21b):
// the limits, the new-user rule per number and device, and the daily budget
// on the business day, against the database.
let database: TestDatabase;
let cache: TestValkey;
let app: NestFastifyApplication;
let sql: pg.Pool;
let db: Database;
let uses: PromoCodeUsesService;
let azaz: string;
const restaurantId = randomUUID();
// Thursday 10 December 2026, 15:00 in Azaz (UTC+3).
const now = new Date('2026-12-10T12:00:00Z');

beforeAll(async () => {
  [database, cache] = await Promise.all([startTestDatabase(), startTestValkey()]);
  process.env.DATABASE_URL = database.appUrl;
  process.env.VALKEY_URL = cache.url;
  process.env.IDENTITY_ENCRYPTION_KEY = randomBytes(32).toString('base64');
  sql = new pg.Pool({ connectionString: database.appUrl });
  db = createDatabase(database.appUrl);
  app = await createApiApp(ApiModule);
  await app.init();
  uses = app.get(PromoCodeUsesService);
  azaz = (await sql.query("SELECT id FROM geo.cities WHERE code = 'AZ'")).rows[0].id;
}, 300_000);

afterAll(async () => {
  await app?.close();
  await db?.pool.end();
  await sql?.end();
  await Promise.all([database?.stop(), cache?.stop()]);
});

let codes = 0;
async function code(fields: Record<string, unknown> = {}): Promise<string> {
  codes += 1;
  const row = {
    code: `USE${codes}`,
    kind: 'percentage',
    percent_bp: 1000,
    max_discount: 3000,
    total_limit: null,
    per_customer_limit: null,
    audience: 'everyone',
    daily_budget: null,
    ...fields,
  };
  await sql.query(
    `INSERT INTO marketing.promo_codes (city_id, code, kind, percent_bp, max_discount, currency,
       valid_from, valid_to, total_limit, per_customer_limit, audience, restaurant_ids, zone_ids,
       funding, merchant_share_bp, daily_budget, visibility, created_by, updated_by)
     VALUES ($1, $2, $3, $4, $5, 'TRY', '2026-12-01', '2027-01-01', $6, $7, $8, '{}', '{}',
       'platform', 0, $9, 'visible', $10, $10)`,
    [
      azaz,
      row.code,
      row.kind,
      row.percent_bp,
      row.max_discount,
      row.total_limit,
      row.per_customer_limit,
      row.audience,
      row.daily_budget,
      randomUUID(),
    ],
  );
  return row.code;
}

function customer(overrides: Partial<NonNullable<CodeCart['customer']>> = {}) {
  return {
    accountId: randomUUID(),
    phoneHash: randomUUID(),
    deviceId: randomUUID(),
    newUser: true,
    ...overrides,
  };
}

async function cartAt(typed: string, at: Date) {
  return { ...cart(typed), clock: await uses.clock(azaz, at) };
}

function cart(typed: string, who: CodeCart['customer'] = customer()): CodeCart {
  return {
    cityId: azaz,
    // Azaz's clock on 10 December, the business day from 06:00.
    clock: { timeZone: 'Asia/Damascus', businessDay: new Date('2026-12-10T03:00:00Z') },
    code: typed,
    baseCurrency: 'TRY',
    restaurantId,
    zoneId: null,
    itemsValue: 40_000n,
    deliveryFee: 4_000n,
    customer: who,
  };
}

// Holds the code on a new order and records the use; the order's id back.
async function place(request: CodeCart, at = now) {
  const orderId = randomUUID();
  const held = await db.db.transaction(async (tx) => {
    const result = await uses.hold(tx, request, at);
    await result.record?.({ id: orderId, placedAt: at });
    return result;
  });
  return { orderId, held };
}

describe('PromoCodeUsesService', () => {
  it("checks a typed code in any case and gives AP §8.4's discount", async () => {
    const typed = await code();
    const checked = await uses.check(cart(` ${typed.toLowerCase()} `), now);
    expect(checked).toMatchObject({
      applied: true,
      code: { code: typed, discount: { total: 3000n, merchant: 0n }, fixedAmountAboveItems: false },
    });
    expect(await uses.check(cart('NOSUCH'), now)).toEqual({
      applied: false,
      refusal: 'unknown_code',
      missing: null,
    });
  });

  it('counts the per-customer and total limits, and gives a use back', async () => {
    const typed = await code({ total_limit: 2, per_customer_limit: 1 });
    const first = customer();
    const { orderId } = await place(cart(typed, first));
    expect(await uses.check(cart(typed, first), now)).toMatchObject({ refusal: 'used_before' });
    await place(cart(typed));
    expect(await uses.check(cart(typed), now)).toMatchObject({ refusal: 'uses_ended' });
    // Rejected: the use comes back.
    await db.db.transaction((tx) => uses.settle(tx, orderId, 'returned', now));
    expect(await uses.check(cart(typed, first), now)).toMatchObject({ applied: true });
    const { rows } = await sql.query(
      'SELECT status, settled_at FROM marketing.promo_code_uses WHERE order_id = $1',
      [orderId],
    );
    expect(rows).toEqual([{ status: 'returned', settled_at: now }]);
  });

  it('takes a new user once per number and once per device', async () => {
    const typed = await code({ audience: 'new_users' });
    const first = customer();
    await place(cart(typed, first));
    // Another account on the same number, or on the same device.
    expect(
      await uses.check(cart(typed, customer({ phoneHash: first.phoneHash })), now),
    ).toMatchObject({
      refusal: 'first_order_only',
    });
    expect(
      await uses.check(cart(typed, customer({ deviceId: first.deviceId })), now),
    ).toMatchObject({
      refusal: 'first_order_only',
    });
    expect(await uses.check(cart(typed, customer({ newUser: false })), now)).toMatchObject({
      refusal: 'first_order_only',
    });
    expect(await uses.check(cart(typed), now)).toMatchObject({ applied: true });
  });

  it("pauses for the rest of the business day once the day's cost reaches the cap", async () => {
    const typed = await code({ daily_budget: 5000 });
    await place(cart(typed));
    // 30.00 of 50.00 used: one more order passes and reaches it.
    const second = await place(cart(typed));
    expect(second.held).toMatchObject({ applied: true });
    expect(await uses.check(cart(typed), now)).toMatchObject({ refusal: 'budget_reached' });
    // 05:59 the next morning is the same business day; 06:00 starts another.
    const early = new Date('2026-12-11T02:59:00Z');
    const next = new Date('2026-12-11T03:00:00Z');
    expect(await uses.check(await cartAt(typed, early), early)).toMatchObject({
      refusal: 'budget_reached',
    });
    expect(await uses.check(await cartAt(typed, next), next)).toMatchObject({ applied: true });
  });

  it('tells the customer «أُعيد الكود {الكود} إلى أكوادك» when a use comes back', async () => {
    // The push names a code back in «متاحة», which needs the city's base.
    const fx = app.get(FxService);
    const change = {
      actor: { type: 'system', id: null, role: null } as const,
      context: { ipAddress: null, device: null },
      reason: 'test',
    };
    await fx.setCityCurrency(azaz, { currency: 'TRY', displayOrder: 1, enabled: true }, change);
    await fx.setBaseCurrency(azaz, 'TRY', change);
    const typed = await code();
    const who = customer();
    const pushes = async () =>
      (
        await sql.query(
          "SELECT body, data FROM notifications.push_messages WHERE account_id = $1 AND template_key = 'customer.code_returned'",
          [who.accountId],
        )
      ).rows;
    const spent = await place(cart(typed, who));
    await db.db.transaction((tx) => uses.settle(tx, spent.orderId, 'spent', now));
    expect(await pushes()).toEqual([]);
    const back = await place(cart(typed, who));
    await db.db.transaction((tx) => uses.settle(tx, back.orderId, 'returned', now));
    // Settled again the same way: nothing more.
    await db.db.transaction((tx) => uses.settle(tx, back.orderId, 'returned', now));
    expect(await pushes()).toEqual([
      { body: `أُعيد الكود ${typed} إلى أكوادك`, data: { target: 'codes' } },
    ]);
    // A secret code is not in «أكوادي»: no push.
    const secret = await code();
    await sql.query("UPDATE marketing.promo_codes SET visibility = 'secret' WHERE code = $1", [
      secret,
    ]);
    const hidden = await place(cart(secret, who));
    await db.db.transaction((tx) => uses.settle(tx, hidden.orderId, 'returned', now));
    // Nor is a paused one.
    const paused = await code();
    const stopped = await place(cart(paused, who));
    await sql.query("UPDATE marketing.promo_codes SET status = 'paused' WHERE code = $1", [paused]);
    await db.db.transaction((tx) => uses.settle(tx, stopped.orderId, 'returned', now));
    expect(await pushes()).toHaveLength(1);
  });

  it('keeps whether the customer was new and whether the order was delivered', async () => {
    const typed = await code();
    const { orderId } = await place(cart(typed, customer({ newUser: true })));
    const flags = async () =>
      (
        await sql.query(
          'SELECT new_user, delivered FROM marketing.promo_code_uses WHERE order_id = $1',
          [orderId],
        )
      ).rows[0];
    expect(await flags()).toEqual({ new_user: true, delivered: false });
    await db.db.transaction((tx) => uses.settle(tx, orderId, 'spent', now, true));
    expect(await flags()).toEqual({ new_user: true, delivered: true });
    // «تغيير النتيجة» to a fake order: still spent, no longer delivered.
    await db.db.transaction((tx) => uses.settle(tx, orderId, 'spent', now, false));
    expect(await flags()).toEqual({ new_user: true, delivered: false });
  });

  it('never lets two placings take the last use', async () => {
    const typed = await code({ total_limit: 1 });
    const results = await Promise.all([place(cart(typed)), place(cart(typed))]);
    expect(results.map(({ held }) => held.applied).sort()).toEqual([false, true]);
  });
});
