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
import { GeoService, type Point } from '../geo/index.js';
import { ADMIN_SESSION_COOKIE, AdminSessionsService } from '../identity/index.js';
import { MerchantsService } from '../merchants/index.js';

// «أكواد الخصم» (AP §9.11.1, slice 2.21a) served by the API app: the list,
// a typed code, a generated batch, the edit, pause and resume, by role.
let database: TestDatabase;
let cache: TestValkey;
let app: NestFastifyApplication;
let sql: pg.Pool;
let db: Database;
let azaz: string;
let zoneId: string;
let restaurantId: string;
const system = { type: 'system', id: null, role: null } as const;
const change = { actor: system, context: { ipAddress: null, device: null }, reason: 'test' };

function square({ latitude, longitude }: Point, half = 0.05): Point[] {
  return [
    { latitude: latitude - half, longitude: longitude - half },
    { latitude: latitude - half, longitude: longitude + half },
    { latitude: latitude + half, longitude: longitude + half },
    { latitude: latitude + half, longitude: longitude - half },
  ];
}

beforeAll(async () => {
  [database, cache] = await Promise.all([startTestDatabase(), startTestValkey()]);
  process.env.DATABASE_URL = database.appUrl;
  process.env.VALKEY_URL = cache.url;
  process.env.IDENTITY_ENCRYPTION_KEY = randomBytes(32).toString('base64');
  process.env.FOX_DROP_ENVIRONMENT = 'development';
  sql = new pg.Pool({ connectionString: database.appUrl });
  db = createDatabase(database.appUrl);
  app = await createApiApp(ApiModule);
  await app.init();
  await app.getHttpAdapter().getInstance().ready();
  azaz = (await sql.query("SELECT id FROM geo.cities WHERE code = 'AZ'")).rows[0].id;
  const fx = app.get(FxService);
  await fx.setCityCurrency(azaz, { currency: 'TRY', displayOrder: 1, enabled: true }, change);
  await fx.setBaseCurrency(azaz, 'TRY', change);
  zoneId = await app
    .get(GeoService)
    .createZone(
      azaz,
      { name: 'المركز', area: square({ latitude: 36.587, longitude: 37.046 }), active: true },
      change,
    );
  restaurantId = await app.get(MerchantsService).createRestaurant(
    azaz,
    {
      nameAr: 'مطعم الأكواد',
      location: { latitude: 36.5866, longitude: 37.0463 },
      coverage: { kind: 'radius', radiusMetres: 3000 },
      minimumOrder: { amount: 10_000n, currency: 'TRY' },
      commissionBp: 1500,
      defaultPrepMin: 20,
    },
    change,
  );
}, 300_000);

afterAll(async () => {
  await app?.close();
  await db?.pool.end();
  await sql?.end();
  await Promise.all([database?.stop(), cache?.stop()]);
});

let accounts = 0;
async function admin(roles: string[]) {
  accounts += 1;
  const { rows } = await sql.query(
    `INSERT INTO identity.admin_accounts (name, email, status, password_hash, totp_secret_encrypted)
     VALUES ($1, $2, 'active', 'not used', 'not used') RETURNING id`,
    [`Marketing ${accounts}`, `codes${accounts}@example.test`],
  );
  const accountId: string = rows[0].id;
  for (const role of roles) {
    await sql.query(
      'INSERT INTO identity.admin_account_roles (account_id, role_code) VALUES ($1, $2)',
      [accountId, role],
    );
  }
  const { token } = await app
    .get(AdminSessionsService)
    .start(db.db, accountId, { ipAddress: '203.0.113.9', device: 'test' }, new Date());
  const cookies = { [ADMIN_SESSION_COOKIE]: token };
  return {
    accountId,
    cookie: token,
    list: () => app.inject({ method: 'GET', url: `/v1/admin/promo-codes?cityId=${azaz}`, cookies }),
    post: (url: string, payload: object, key: string | null = randomUUID()) =>
      app.inject({
        method: 'POST',
        url: `/v1/admin/promo-codes${url}`,
        cookies,
        payload,
        headers: key ? { 'idempotency-key': key } : {},
      }),
    put: (id: string, payload: object) =>
      app.inject({ method: 'PUT', url: `/v1/admin/promo-codes/${id}`, cookies, payload }),
  };
}

const fields = {
  kind: 'percentage',
  percentBp: 2000,
  amount: null,
  maxDiscount: '5000',
  minOrder: '15000',
  validFrom: '2026-12-01T00:00:00.000Z',
  validTo: '2099-12-31T00:00:00.000Z',
  startMinute: null,
  endMinute: null,
  totalLimit: 100,
  perCustomerLimit: 1,
  audience: 'everyone',
  restaurantIds: [],
  zoneIds: [],
  funding: 'platform',
  sharedMerchantBp: null,
  dailyBudget: '100000',
  visibility: 'visible',
};

describe('«أكواد الخصم»', () => {
  it('lets OWN create a typed code, answers a repeat with it, and refuses the code twice', async () => {
    const own = await admin(['OWN']);
    const key = randomUUID();
    const created = await own.post('', { cityId: azaz, code: ' fox20 ', ...fields }, key);
    expect(created.statusCode).toBe(201);
    const [code] = created.json().codes;
    expect(code).toMatchObject({
      code: 'FOX20',
      batchId: null,
      kind: 'percentage',
      percentBp: 2000,
      maxDiscount: '5000',
      minOrder: '15000',
      currency: 'TRY',
      status: 'active',
      uses: 0,
      costToDate: '0',
    });
    const again = await own.post('', { cityId: azaz, code: ' fox20 ', ...fields }, key);
    expect(again.statusCode).toBe(201);
    expect(again.json().codes[0].id).toBe(code.id);
    const reused = await own.post('', { cityId: azaz, code: 'OTHER', ...fields }, key);
    expect(reused.statusCode).toBe(422);
    const taken = await own.post('', { cityId: azaz, code: 'Fox20', ...fields });
    expect(taken.statusCode).toBe(409);
    expect(taken.json().error).toBe('code_taken');

    const audit = await sql.query(
      "SELECT actor_id FROM audit.events WHERE action = 'promo_code.create' AND target_id = $1",
      [code.id],
    );
    expect(audit.rows).toEqual([{ actor_id: own.accountId }]);
  });

  it('generates a batch of unique codes with the prefix', async () => {
    const own = await admin(['OWN']);
    const batch = await own.post('/batch', {
      cityId: azaz,
      count: 20,
      prefix: 'eid',
      ...fields,
      totalLimit: 1,
      visibility: 'secret',
    });
    expect(batch.statusCode).toBe(201);
    const codes: { code: string; batchId: string }[] = batch.json().codes;
    expect(codes).toHaveLength(20);
    expect(new Set(codes.map((each) => each.code)).size).toBe(20);
    expect(codes.every((each) => /^EID[A-Z0-9]{8}$/.test(each.code))).toBe(true);
    expect(new Set(codes.map((each) => each.batchId)).size).toBe(1);
  });

  it('refuses fields that break a rule, a restaurant of no city, and a restaurant code without restaurants', async () => {
    const own = await admin(['OWN']);
    const late = await own.post('', {
      cityId: azaz,
      code: 'LATE1',
      ...fields,
      validTo: fields.validFrom,
    });
    expect(late.statusCode).toBe(400);
    expect(late.json().error).toBe('invalid_promo_code');
    const stranger = await own.post('', {
      cityId: azaz,
      code: 'LATE2',
      ...fields,
      restaurantIds: [randomUUID()],
    });
    expect(stranger.statusCode).toBe(400);
    const unnamed = await own.post('', {
      cityId: azaz,
      code: 'LATE3',
      ...fields,
      funding: 'restaurant',
    });
    expect(unnamed.statusCode).toBe(400);
  });

  it('edits a shared code limited to a restaurant and a zone, pauses and resumes it', async () => {
    const own = await admin(['OWN']);
    const created = await own.post('', { cityId: azaz, code: 'SHARE40', ...fields });
    const id: string = created.json().codes[0].id;
    const edited = await own.put(id, {
      cityId: azaz,
      ...fields,
      kind: 'free_delivery',
      percentBp: null,
      maxDiscount: null,
      startMinute: 1200,
      endMinute: 120,
      audience: 'new_users',
      restaurantIds: [restaurantId],
      zoneIds: [zoneId],
      funding: 'shared',
      sharedMerchantBp: 4000,
    });
    expect(edited.statusCode).toBe(200);
    expect(edited.json()).toMatchObject({
      code: 'SHARE40',
      kind: 'free_delivery',
      percentBp: null,
      startMinute: 1200,
      endMinute: 120,
      audience: 'new_users',
      restaurantIds: [restaurantId],
      zoneIds: [zoneId],
      funding: 'shared',
      sharedMerchantBp: 4000,
    });

    const paused = await own.post(`/${id}/pause`, { cityId: azaz }, null);
    expect(paused.statusCode).toBe(200);
    expect(paused.json()).toMatchObject({ status: 'paused', state: 'paused' });
    const resumed = await own.post(`/${id}/resume`, { cityId: azaz }, null);
    expect(resumed.json().status).toBe('active');
    const unknown = await own.post(`/${randomUUID()}/pause`, { cityId: azaz }, null);
    expect(unknown.statusCode).toBe(404);
  });

  it('lets OPS read without costs, FIN read with costs, and neither change', async () => {
    const ops = await admin(['OPS']);
    const fin = await admin(['FIN']);
    const opsList = await ops.list();
    expect(opsList.statusCode).toBe(200);
    const body = opsList.json();
    expect(body.canManage).toBe(false);
    expect(body.baseCurrency).toBe('TRY');
    expect(body.restaurants).toContainEqual({ id: restaurantId, name: 'مطعم الأكواد' });
    expect(body.zones).toContainEqual({ id: zoneId, name: 'المركز', active: true });
    expect(body.codes.length).toBeGreaterThan(0);
    expect(body.codes.every((each: { costToDate: null }) => each.costToDate === null)).toBe(true);
    const finList = (await fin.list()).json();
    expect(finList.codes.every((each: { costToDate: string }) => each.costToDate === '0')).toBe(
      true,
    );
    expect((await ops.post('', { cityId: azaz, code: 'NOPE1', ...fields })).statusCode).toBe(403);
    expect((await fin.post('', { cityId: azaz, code: 'NOPE2', ...fields })).statusCode).toBe(403);
    expect((await (await admin(['SUP'])).list()).statusCode).toBe(403);
  });
});

describe('«أكواد الخصم» out of scope and replayed', () => {
  it('answers a code of another city as unknown', async () => {
    const own = await admin(['OWN']);
    const id: string = (await own.post('', { cityId: azaz, code: 'SCOPE1', ...fields })).json()
      .codes[0].id;
    const elsewhere = randomUUID();
    expect((await own.post(`/${id}/pause`, { cityId: elsewhere }, null)).statusCode).toBe(404);
    expect((await own.post(`/${id}/resume`, { cityId: elsewhere }, null)).statusCode).toBe(404);
    expect((await own.put(id, { cityId: elsewhere, ...fields })).statusCode).toBe(404);
  });

  it('answers a batch sent again with its key with the same codes', async () => {
    const own = await admin(['OWN']);
    const key = randomUUID();
    const body = { cityId: azaz, count: 3, prefix: 'RE', ...fields };
    const first = (await own.post('/batch', body, key))
      .json()
      .codes.map((c: { id: string }) => c.id);
    const again = (await own.post('/batch', body, key))
      .json()
      .codes.map((c: { id: string }) => c.id);
    expect(again.sort()).toEqual([...first].sort());
  });

  it('keeps the base currency while a code runs (AP §8.6)', async () => {
    const fx = app.get(FxService);
    await fx.setCityCurrency(azaz, { currency: 'USD', displayOrder: 2, enabled: false }, change);
    await expect(fx.setBaseCurrency(azaz, 'USD', change)).rejects.toThrow(/promo_code:FOX20/);
  });
});

describe('the marketing tables', () => {
  it('refuse a percentage without its value and never let the application role delete', async () => {
    const insert = (percent: string) =>
      sql.query(
        `INSERT INTO marketing.promo_codes (city_id, code, kind, percent_bp, currency, valid_from, valid_to,
           audience, restaurant_ids, zone_ids, funding, merchant_share_bp, visibility, created_by, updated_by)
         VALUES ($1, $2, 'percentage', ${percent}, 'TRY', now(), now() + interval '1 day',
           'everyone', '{}', '{}', 'platform', 0, 'visible', $3, $3)`,
        [azaz, `RAW${Math.floor(Math.random() * 1e6)}`, randomUUID()],
      );
    await expect(insert('NULL')).rejects.toThrow(/promo_codes_value/);
    await insert('1000');
    await expect(sql.query('DELETE FROM marketing.promo_codes')).rejects.toThrow(
      /permission denied/,
    );
  });
});

describe('the code report (AP §9.11.1, slice 2.21d)', () => {
  it('counts orders, customers, cost and new customers, and extends from it', async () => {
    const own = await admin(['OWN']);
    const ops = await admin(['OPS']);
    const created = await own.post('', { cityId: azaz, code: 'REPORT1', ...fields });
    const { id } = created.json().codes[0];
    const first = { account: randomUUID(), phone: randomUUID() };
    // A new customer delivered, the same customer again, an old customer,
    // and a use given back.
    const uses: [string, string, string, boolean, boolean][] = [
      [first.account, first.phone, 'spent', true, true],
      [first.account, first.phone, 'spent', false, true],
      [randomUUID(), randomUUID(), 'held', false, false],
      [randomUUID(), randomUUID(), 'returned', true, false],
    ];
    for (const [account, phone, status, newUser, delivered] of uses) {
      await sql.query(
        `INSERT INTO marketing.promo_code_uses (code_id, city_id, order_id, order_placed_at,
           customer_account_id, phone_hash, device_id, business_day, currency, discount,
           merchant_share, status, held_at, settled_at, new_user, delivered)
         VALUES ($1, $2, $3, now(), $4, $5, 'device', now(), 'TRY', 3000, 1000, $6, now(),
           CASE WHEN $6 = 'held' THEN NULL ELSE now() END, $7, $8)`,
        [id, azaz, randomUUID(), account, phone, status, newUser, delivered],
      );
    }
    const report = (who: typeof own) =>
      app.inject({
        method: 'GET',
        url: `/v1/admin/promo-codes/${id}/report?cityId=${azaz}`,
        cookies: { [ADMIN_SESSION_COOKIE]: who.cookie },
      });
    const owned = await report(own);
    expect(owned.statusCode, owned.body).toBe(200);
    expect(owned.json()).toMatchObject({
      code: { code: 'REPORT1', uses: 3, costToDate: '9000' },
      report: {
        orders: 3,
        returned: 1,
        customers: 2,
        newCustomers: 1,
        cost: '9000',
        merchantShare: '3000',
      },
      canManage: true,
    });
    const seen = (await report(ops)).json();
    expect(seen.report).toMatchObject({ orders: 3, cost: null, merchantShare: null });
    expect(seen.canManage).toBe(false);

    // «تمديد»: later than the end it had, by OWN only.
    const extend = (who: typeof own, validTo: string) =>
      app.inject({
        method: 'POST',
        url: `/v1/admin/promo-codes/${id}/extend`,
        cookies: { [ADMIN_SESSION_COOKIE]: who.cookie },
        payload: { cityId: azaz, validTo },
      });
    expect((await extend(ops, '2100-06-30T00:00:00.000Z')).statusCode).toBe(403);
    const earlier = await extend(own, '2099-06-30T00:00:00.000Z');
    expect(earlier.statusCode).toBe(400);
    expect(earlier.json().error).toBe('invalid_promo_code');
    const later = await extend(own, '2100-06-30T00:00:00.000Z');
    expect(later.statusCode, later.body).toBe(200);
    expect(later.json().validTo).toBe('2100-06-30T00:00:00.000Z');
    const audit = await sql.query(
      "SELECT changes FROM audit.events WHERE action = 'promo_code.extend' AND target_id = $1",
      [id],
    );
    expect(audit.rows).toEqual([
      {
        changes: {
          validTo: { before: '2099-12-31T00:00:00.000Z', after: '2100-06-30T00:00:00.000Z' },
        },
      },
    ]);
  });
});
