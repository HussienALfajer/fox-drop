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
import { ADMIN_SESSION_COOKIE, AdminSessionsService } from '../identity/index.js';
import { SettingsService } from '../settings/index.js';
import { PromoCodeUsesService } from './promo-code-uses.service.js';
import {
  type CompensationAdmin,
  type CompensationOrder,
  CompensationRefusedError,
  CompensationsService,
} from './compensations.service.js';

// «تعويض الزبون» (AP §6.4, §9.3.2; slice 2.22a): the cumulative cap per
// order and role, OWN's approval above it, the personal code and its push.
let database: TestDatabase;
let cache: TestValkey;
let app: NestFastifyApplication;
let sql: pg.Pool;
let db: Database;
let compensations: CompensationsService;
let azaz: string;
const now = new Date('2026-12-10T12:00:00Z');
const system = { type: 'system', id: null, role: null } as const;
const change = { actor: system, context: { ipAddress: null, device: null }, reason: 'test' };
const bySystem = { editor: 'system', context: change.context, reason: 'test' } as const;

beforeAll(async () => {
  [database, cache] = await Promise.all([startTestDatabase(), startTestValkey()]);
  process.env.DATABASE_URL = database.appUrl;
  process.env.VALKEY_URL = cache.url;
  process.env.IDENTITY_ENCRYPTION_KEY = randomBytes(32).toString('base64');
  sql = new pg.Pool({ connectionString: database.appUrl });
  db = createDatabase(database.appUrl);
  app = await createApiApp(ApiModule);
  await app.init();
  await app.getHttpAdapter().getInstance().ready();
  compensations = app.get(CompensationsService);
  azaz = (await sql.query("SELECT id FROM geo.cities WHERE code = 'AZ'")).rows[0].id;
  const fx = app.get(FxService);
  await fx.setCityCurrency(azaz, { currency: 'TRY', displayOrder: 1, enabled: true }, change);
  await fx.setBaseCurrency(azaz, 'TRY', change);
}, 300_000);

afterAll(async () => {
  await app?.close();
  await db?.pool.end();
  await sql?.end();
  await Promise.all([database?.stop(), cache?.stop()]);
});

let orders = 0;
// An order of 400.00 (the compensations read nothing else of it).
function order(total = 40_000n): CompensationOrder {
  orders += 1;
  return {
    id: randomUUID(),
    cityId: azaz,
    number: BigInt(20000 + orders),
    customerAccountId: randomUUID(),
    total,
    currency: 'TRY',
  };
}

function admin(roles: string[]): CompensationAdmin {
  const accountId = randomUUID();
  return {
    accountId,
    roles,
    permissions: roles.includes('OWN')
      ? ['operations.compensate', 'compensation.approve_above_cap']
      : ['operations.compensate'],
    actor: { type: 'admin', id: accountId, role: roles.join(',') },
    context: { ipAddress: null, device: null },
  };
}

const late = { code: 'late', note: null };
const amount = (minor: bigint) => ({ kind: 'fixed_amount' as const, amount: minor });

async function pushes(accountId: string) {
  return (
    await sql.query(
      "SELECT body, data FROM notifications.push_messages WHERE account_id = $1 AND template_key = 'customer.compensation_code'",
      [accountId],
    )
  ).rows;
}

async function openAlerts(id: string) {
  return (
    await sql.query(
      "SELECT code FROM notifications.alerts WHERE subject_type = 'compensation' AND subject_id = $1 AND resolved_at IS NULL",
      [id],
    )
  ).rows;
}

describe('«تعويض الزبون»', () => {
  it('issues a code within the cap, with its push, and counts every compensation of the order', async () => {
    const target = order();
    const sup = admin(['SUP']);
    // 30% of 400.00 is 120.00: 80.00 then 40.00 fit, by anyone.
    const first = await compensations.request(target, amount(8_000n), late, sup, randomUUID(), now);
    expect(first).toMatchObject({ status: 'issued', reasonLabel: 'تأخير' });
    expect(first.code).toMatch(/^[A-Z2-9]{8}$/);
    expect(first.codeValidTo).toEqual(new Date(now.getTime() + 30 * 24 * 60 * 60 * 1000));
    const [code] = (
      await sql.query(
        'SELECT visibility, customer_account_id, total_limit, per_customer_limit, funding FROM marketing.promo_codes WHERE id = $1',
        [first.codeId],
      )
    ).rows;
    expect(code).toEqual({
      visibility: 'personal',
      customer_account_id: target.customerAccountId,
      total_limit: 1,
      per_customer_limit: 1,
      funding: 'platform',
    });
    expect(await pushes(target.customerAccountId)).toEqual([
      { body: `لك كود تعويض 80 ₺: ${first.code}`, data: { target: 'codes' } },
    ]);
    const ops = admin(['OPS']);
    expect(
      (await compensations.request(target, amount(4_000n), late, ops, randomUUID(), now)).status,
    ).toBe('issued');
    expect((await compensations.forOrder(target, sup)).capLeft).toBe(0n);
  });

  it('counts a percentage by its maximum and sends a request above the cap to OWN', async () => {
    const target = order();
    const sup = admin(['SUP']);
    const asked = await compensations.request(
      target,
      { kind: 'percentage', percentBp: 2000, maxDiscount: 12_001n },
      { code: 'other', note: 'الزبون انتظر طويلاً' },
      sup,
      randomUUID(),
      now,
    );
    expect(asked).toMatchObject({ status: 'waiting', code: null, note: 'الزبون انتظر طويلاً' });
    expect(await pushes(target.customerAccountId)).toEqual([]);
    expect(await openAlerts(asked.id)).toEqual([{ code: 'compensation_approval' }]);
    expect((await compensations.waiting(azaz)).map((each) => each.id)).toContain(asked.id);
    // A waiting request does not count against the cap.
    expect((await compensations.forOrder(target, sup)).capLeft).toBe(12_000n);

    const own = admin(['OWN']);
    const approved = await compensations.approve(azaz, asked.id, amount(5_000n), own, now);
    expect(approved).toMatchObject({
      status: 'issued',
      kind: 'fixed_amount',
      amount: 5_000n,
      decidedBy: own.accountId,
    });
    expect(await openAlerts(asked.id)).toEqual([]);
    expect(await pushes(target.customerAccountId)).toEqual([
      { body: `لك كود تعويض 50 ₺: ${approved.code}`, data: { target: 'codes' } },
    ]);
    await expect(compensations.reject(azaz, asked.id, own, now)).rejects.toMatchObject({
      refusal: 'compensation_decided',
    });
  });

  it('rejects a request without telling the customer', async () => {
    const target = order(1_000n);
    const asked = await compensations.request(
      target,
      amount(500n),
      late,
      admin(['OPS']),
      randomUUID(),
      now,
    );
    expect(asked.status).toBe('waiting');
    const rejected = await compensations.reject(azaz, asked.id, admin(['OWN']), now);
    expect(rejected).toMatchObject({ status: 'rejected', code: null });
    expect(await openAlerts(asked.id)).toEqual([]);
    expect(await pushes(target.customerAccountId)).toEqual([]);
  });

  it('gives OWN no cap and the highest cap of several roles, and follows the setting', async () => {
    const own = admin(['OWN']);
    expect(await compensations.capPct(azaz, own)).toBeNull();
    const target = order(1_000n);
    expect(
      (await compensations.request(target, amount(100_000n), late, own, randomUUID(), now)).status,
    ).toBe('issued');
    await app
      .get(SettingsService)
      .update('support.compensation_cap_pct.OPS', { cityId: azaz }, 50, bySystem);
    expect(await compensations.capPct(azaz, admin(['SUP', 'OPS']))).toBe(50);
    expect(await compensations.capPct(azaz, admin(['SUP']))).toBe(30);
    await app
      .get(SettingsService)
      .update('support.compensation_cap_pct.OPS', { cityId: azaz }, 30, bySystem);
  });

  it('answers a repeated key with the first request, and refuses it with another', async () => {
    const target = order();
    const sup = admin(['SUP']);
    const key = randomUUID();
    const first = await compensations.request(target, amount(1_000n), late, sup, key, now);
    const again = await compensations.request(target, amount(1_000n), late, sup, key, now);
    expect(again.id).toBe(first.id);
    expect(await pushes(target.customerAccountId)).toHaveLength(1);
    await expect(
      compensations.request(target, amount(2_000n), late, sup, key, now),
    ).rejects.toBeInstanceOf(CompensationRefusedError);
  });

  it('lets only its customer use a personal code, and lists it for them alone (slice 2.22b)', async () => {
    const target = order();
    const issued = await compensations.request(
      target,
      amount(2_500n),
      late,
      admin(['SUP']),
      randomUUID(),
      now,
    );
    const uses = app.get(PromoCodeUsesService);
    const clock = await uses.clock(azaz, now);
    const customer = (accountId: string) => ({
      accountId,
      phoneHash: `hash-${accountId}`,
      deviceId: `device-${accountId}`,
      newUser: false,
    });
    const cart = {
      cityId: azaz,
      clock,
      baseCurrency: 'TRY',
      restaurantId: randomUUID(),
      zoneId: null,
      itemsValue: 50_000n,
      deliveryFee: 1_000n,
    };
    const check = (who: ReturnType<typeof customer> | null) =>
      uses.check({ ...cart, code: issued.code!.toLowerCase(), customer: who }, now);
    // CU Appendix C: to anyone else, a guest included, the code does not exist.
    expect(await check(null)).toMatchObject({ applied: false, refusal: 'unknown_code' });
    expect(await check(customer(randomUUID()))).toMatchObject({
      applied: false,
      refusal: 'unknown_code',
    });
    expect(await check(customer(target.customerAccountId))).toMatchObject({
      applied: true,
      code: {
        code: issued.code,
        terms: { kind: 'fixed_amount', amount: 2_500n, compensation: true, merchantShareBp: 0 },
        discount: { total: 2_500n, merchant: 0n },
      },
    });
    // Placing holds it under its lock for its customer only, too.
    const hold = (who: ReturnType<typeof customer>) =>
      db.db.transaction((tx) => uses.hold(tx, { ...cart, code: issued.code!, customer: who }, now));
    expect(await hold(customer(randomUUID()))).toMatchObject({
      applied: false,
      refusal: 'unknown_code',
    });
    expect(await hold(customer(target.customerAccountId))).toMatchObject({ applied: true });
    // «الأكواد المتاحة لك» and «أكوادي» (CU §10.4, §12.4).
    const mine = customer(target.customerAccountId);
    const other = customer(randomUUID());
    const listed = async (who: typeof mine) =>
      (await uses.available({ ...cart, customer: who }, now)).map((each) => each.code);
    expect(await listed(mine)).toContain(issued.code);
    expect(await listed(other)).not.toContain(issued.code);
    const myCodes = (who: typeof mine) =>
      uses.mine({ cityId: azaz, baseCurrency: 'TRY', clock, customer: who }, now);
    expect((await myCodes(mine)).find((each) => each.code === issued.code)).toMatchObject({
      ended: null,
      usesLeft: 1,
      amount: 2_500n,
    });
    expect((await myCodes(other)).map((each) => each.code)).not.toContain(issued.code);
  });

  it('says where a personal code came from, for the cost report (slice 2.22d)', async () => {
    const target = order();
    const sup = admin(['SUP']);
    const given = await compensations.request(target, amount(2_000n), late, sup, randomUUID(), now);
    // A late code is a personal code with its row in late_codes.
    const other = order();
    const second = await compensations.request(other, amount(1_000n), late, sup, randomUUID(), now);
    const lateOrder = randomUUID();
    await sql.query(
      `INSERT INTO marketing.late_codes (order_id, city_id, order_number, customer_account_id, code_id, promised_at, issued_at)
       VALUES ($1, $2, 30001, $3, $4, $5, $5)`,
      [lateOrder, azaz, other.customerAccountId, second.codeId, now],
    );
    const origins = await compensations.codeOrigins([given.codeId!, second.codeId!, randomUUID()]);
    expect([...origins]).toEqual([
      [
        given.codeId,
        { kind: 'compensation', reasonCode: 'late', reasonLabel: 'تأخير', orderId: target.id },
      ],
      [second.codeId, { kind: 'late', orderId: lateOrder }],
    ]);
  });

  it('refuses an unknown reason', async () => {
    await expect(
      compensations.request(
        order(),
        amount(100n),
        { code: 'nope', note: null },
        admin(['SUP']),
        randomUUID(),
        now,
      ),
    ).rejects.toMatchObject({ refusal: 'unknown_reason' });
  });

  it('never lets the application role delete a compensation', async () => {
    await expect(sql.query('DELETE FROM marketing.compensations')).rejects.toThrow(
      /permission denied/,
    );
  });
});

describe('«طلبات الموافقة» routes', () => {
  async function session(roles: string[]) {
    const { rows } = await sql.query(
      `INSERT INTO identity.admin_accounts (name, email, status, password_hash, totp_secret_encrypted)
       VALUES ($1, $2, 'active', 'not used', 'not used') RETURNING id`,
      [`Comp ${roles.join('')}`, `${randomUUID()}@example.test`],
    );
    for (const role of roles) {
      await sql.query(
        'INSERT INTO identity.admin_account_roles (account_id, role_code) VALUES ($1, $2)',
        [rows[0].id, role],
      );
    }
    const { token } = await app
      .get(AdminSessionsService)
      .start(db.db, rows[0].id, { ipAddress: '203.0.113.9', device: 'test' }, new Date());
    return { [ADMIN_SESSION_COOKIE]: token };
  }

  it('lists the waiting requests to OWN, who approves one with a new value', async () => {
    const asked = await compensations.request(
      order(1_000n),
      amount(900n),
      late,
      admin(['SUP']),
      randomUUID(),
      now,
    );
    const own = await session(['OWN']);
    const list = await app.inject({
      method: 'GET',
      url: `/v1/admin/compensations?cityId=${azaz}`,
      cookies: own,
    });
    expect(list.statusCode).toBe(200);
    expect(list.json().requests).toContainEqual(
      expect.objectContaining({ id: asked.id, status: 'waiting', amount: '900', code: null }),
    );
    const sup = await session(['SUP']);
    expect(
      (
        await app.inject({
          method: 'GET',
          url: `/v1/admin/compensations?cityId=${azaz}`,
          cookies: sup,
        })
      ).statusCode,
    ).toBe(403);
    const approved = await app.inject({
      method: 'POST',
      url: `/v1/admin/compensations/${asked.id}/approve`,
      cookies: own,
      payload: {
        cityId: azaz,
        value: { kind: 'percentage', amount: null, percentBp: 1000, maxDiscount: '300' },
      },
    });
    expect(approved.statusCode).toBe(200);
    expect(approved.json()).toMatchObject({
      status: 'issued',
      kind: 'percentage',
      percentBp: 1000,
      maxDiscount: '300',
      decidedBy: 'Comp OWN',
    });
    const again = await app.inject({
      method: 'POST',
      url: `/v1/admin/compensations/${asked.id}/reject`,
      cookies: own,
      payload: { cityId: azaz },
    });
    expect(again.statusCode).toBe(409);
    expect(again.json().error).toBe('compensation_decided');
  });

  it('answers an unknown order with 404', async () => {
    const sup = await session(['SUP']);
    const reply = await app.inject({
      method: 'POST',
      url: `/v1/admin/orders/${randomUUID()}/compensations`,
      cookies: sup,
      headers: { 'idempotency-key': randomUUID() },
      payload: {
        value: { kind: 'fixed_amount', amount: '100', percentBp: null, maxDiscount: null },
        reason: late,
      },
    });
    expect(reply.statusCode).toBe(404);
  });
});
