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
import {
  ADMIN_SESSION_COOKIE,
  AdminSessionsService,
  CODE_SENDER,
  type DevelopmentCodeSender,
} from '../identity/index.js';
import { MerchantsService } from './index.js';

// The restaurant profile (AP §9.6.4, slice 2.30d): the edits past the
// draft, the accounts and devices, the notes and the change log.
let database: TestDatabase;
let cache: TestValkey;
let app: NestFastifyApplication;
let sql: pg.Pool;
let db: Database;
let merchants: MerchantsService;
let azaz: string;
let accounts = 0;

const system = { type: 'system', id: null, role: null } as const;
const change = { actor: system, context: { ipAddress: null, device: null }, reason: 'test' };

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
  merchants = app.get(MerchantsService);
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

async function adminCookies(role: string) {
  accounts += 1;
  const { rows } = await sql.query(
    `INSERT INTO identity.admin_accounts (name, email, status, password_hash, totp_secret_encrypted)
     VALUES ($1, $2, 'active', 'not used', 'not used') RETURNING id`,
    [`Operator ${accounts}`, `account${accounts}@example.test`],
  );
  await sql.query(
    'INSERT INTO identity.admin_account_roles (account_id, role_code) VALUES ($1, $2)',
    [rows[0].id, role],
  );
  const { token } = await app
    .get(AdminSessionsService)
    .start(db.db, rows[0].id, { ipAddress: '203.0.113.9', device: 'test' }, new Date());
  return { accountId: rows[0].id as string, cookies: { [ADMIN_SESSION_COOKIE]: token } };
}

async function admin(role: string) {
  const { cookies } = await adminCookies(role);
  return (method: 'GET' | 'POST' | 'PUT', url: string, payload?: object) =>
    app.inject({
      method,
      url: `/v1/admin/restaurants/${url}`,
      cookies,
      ...(payload ? { payload } : {}),
    });
}

async function restaurant(status: 'active' | 'test' | 'terminated' = 'active') {
  const id = await merchants.createRestaurant(
    azaz,
    {
      nameAr: `مطعم ${randomUUID()}`,
      location: { latitude: 36.5866, longitude: 37.0463 },
      coverage: { kind: 'radius', radiusMetres: 3000 },
      minimumOrder: { amount: 10_000n, currency: 'TRY' },
      commissionBp: 1500,
      defaultPrepMin: 20,
    },
    change,
  );
  if (status === 'terminated') {
    await merchants.setAccountStatus(id, 'active', change);
    await merchants.setAccountStatus(id, 'terminated', change);
  } else {
    await merchants.setAccountStatus(id, status, change);
  }
  return id;
}

const kinds = async (id: string) =>
  (
    await sql.query('SELECT kind FROM merchants.state_outbox WHERE restaurant_id = $1 ORDER BY id', [
      id,
    ])
  ).rows.map((row) => row.kind);

const operations = (opensAt: number) => ({
  periods: [0, 1, 2, 3, 4, 5, 6].map((weekday) => ({ weekday, opensAt, closesAt: 1380 })),
  defaultPrepMin: 25,
  minimumOrder: { amount: '15000', currency: 'TRY' },
  coverage: { kind: 'radius', radiusMetres: 2500, zoneIds: [] },
});

describe('the profile’s edits past the draft (AP §9.6.4)', () => {
  it('edits the data, the location and the hours, audited, the devices told', async () => {
    const id = await restaurant();
    const ops = await admin('OPS');
    const basics = await ops('PUT', `${id}/profile/basics`, {
      nameAr: 'مطعم الساحة',
      nameEn: 'Square',
      categoryIds: [],
      description: 'مشاوي',
    });
    expect(basics.statusCode).toBe(200);
    expect(basics.json().basics).toMatchObject({ nameAr: 'مطعم الساحة', description: 'مشاوي' });
    const location = await ops('PUT', `${id}/profile/location`, {
      location: { latitude: 36.588, longitude: 37.047 },
      address: 'الساحة',
      phone: '+963211234567',
      ownerName: 'أبو أحمد',
    });
    expect(location.statusCode).toBe(200);
    expect(location.json().location).toMatchObject({ address: 'الساحة', ownerName: 'أبو أحمد' });
    const hours = await ops('PUT', `${id}/profile/operations`, operations(600));
    expect(hours.statusCode).toBe(200);
    expect(hours.json().operations).toMatchObject({ defaultPrepMin: 25 });
    expect(hours.json().operations.periods[0]).toEqual({ weekday: 0, opensAt: 600, closesAt: 1380 });
    expect(await kinds(id)).toEqual(['hours', 'order_settings']);
    // The same values again change nothing.
    await ops('PUT', `${id}/profile/operations`, operations(600));
    expect(await kinds(id)).toEqual(['hours', 'order_settings']);
    const audited = await sql.query(
      `SELECT action FROM audit.events WHERE target_id = $1 AND action IN
         ('restaurant.basics', 'restaurant.location', 'restaurant.operations') ORDER BY occurred_at`,
      [id],
    );
    expect(audited.rows.map((row) => row.action)).toEqual([
      'restaurant.basics',
      'restaurant.location',
      'restaurant.operations',
    ]);
  });

  it('leaves a draft to the wizard and refuses a terminated restaurant or FIN', async () => {
    const ops = await admin('OPS');
    const draft = randomUUID();
    const created = await app.inject({
      method: 'PUT',
      url: `/v1/admin/restaurant-drafts/${draft}/basics`,
      cookies: (await adminCookies('OPS')).cookies,
      payload: { cityId: azaz, nameAr: 'مسودة', nameEn: null, categoryIds: [], description: null },
    });
    expect(created.statusCode).toBe(200);
    const refused = await ops('PUT', `${draft}/profile/operations`, operations(600));
    expect(refused.statusCode).toBe(409);
    expect(refused.json().error).toBe('still_a_draft');
    const ended = await restaurant('terminated');
    const terminated = await ops('PUT', `${ended}/profile/operations`, operations(600));
    expect(terminated.statusCode).toBe(403);
    expect(terminated.json().error).toBe('restaurant_terminated');
    const fin = await admin('FIN');
    const id = await restaurant();
    expect((await fin('PUT', `${id}/profile/operations`, operations(600))).statusCode).toBe(403);
    // The wizard still refuses a restaurant past its draft.
    const wizard = await app.inject({
      method: 'PUT',
      url: `/v1/admin/restaurant-drafts/${id}/operations`,
      cookies: (await adminCookies('OPS')).cookies,
      payload: operations(600),
    });
    expect(wizard.json().error).toBe('not_a_draft');
  });
});

async function merchantSignIn(phone: string) {
  const deviceId = randomUUID();
  // A second device of the same user: past the resend wait.
  await sql.query(
    "UPDATE identity.app_sign_in_codes SET created_at = created_at - interval '1 hour'",
  );
  await app.inject({ method: 'POST', url: '/v1/merchant/auth/code', payload: { phone, deviceId } });
  const code = app.get<DevelopmentCodeSender>(CODE_SENDER).lastCode(phone);
  const answer = await app.inject({
    method: 'POST',
    url: '/v1/merchant/auth/sign-in',
    payload: { phone, deviceId, code },
  });
  expect(answer.statusCode).toBe(200);
  const headers = { authorization: `Bearer ${answer.json().accessToken}` };
  const named = await app.inject({
    method: 'PUT',
    url: '/v1/merchant/auth/device',
    headers,
    payload: { name: 'جهاز الكاشير', platform: 'android', appVersion: '1.2.0' },
  });
  expect(named.statusCode).toBe(200);
  return { headers, deviceId };
}

const signedIn = async (headers: Record<string, string>) =>
  (await app.inject({ method: 'GET', url: '/v1/merchant/restaurant', headers })).statusCode;

describe('the profile’s «الحسابات» and devices (AP §9.6.4, RA §14)', () => {
  it('adds a cashier past the draft, lists the device, signs it out, removes the cashier', async () => {
    const id = await restaurant();
    const ops = await admin('OPS');
    const added = await ops('POST', `${id}/accounts`, {
      role: 'cashier',
      name: 'كاشير',
      phone: '+963944000777',
    });
    expect(added.statusCode).toBe(200);
    const cashierId = added.json().accounts[0].id;
    const first = await merchantSignIn('+963944000777');
    const devices = await ops('GET', `${id}/devices`);
    expect(devices.json().devices).toEqual([
      expect.objectContaining({
        deviceId: first.deviceId,
        name: 'جهاز الكاشير',
        platform: 'android',
        appVersion: '1.2.0',
        user: { name: 'كاشير', role: 'cashier' },
        signedIn: true,
        ringing: null,
        deviceCheck: null,
      }),
    ]);
    const out = await ops('POST', `${id}/devices/sign-out`, {
      deviceId: first.deviceId,
      reason: 'جهاز مفقود',
    });
    expect(out.statusCode).toBe(200);
    expect(out.json().devices[0].signedIn).toBe(false);
    expect(await signedIn(first.headers)).toBe(401);
    // A second sign-out finds nothing signed in.
    const again = await ops('POST', `${id}/devices/sign-out`, { deviceId: null, reason: 'x' });
    expect(again.json().error).toBe('no_device');
    // The cashier stays and signs in again; removing them signs them out.
    const second = await merchantSignIn('+963944000777');
    expect(await signedIn(second.headers)).toBe(200);
    const removed = await ops('POST', `${id}/accounts/${cashierId}/remove`);
    expect(removed.json().accounts).toEqual([]);
    expect(await signedIn(second.headers)).toBe(401);
    const reasons = await sql.query(
      `SELECT end_reason FROM identity.app_sessions WHERE device_id IN ($1, $2) ORDER BY signed_in_at`,
      [first.deviceId, second.deviceId],
    );
    expect(reasons.rows.map((row) => row.end_reason)).toEqual([
      'signed_out_by_operations',
      'account_removed',
    ]);
  });

  it('refuses accounts of a terminated restaurant and the sign-out to FIN', async () => {
    const ended = await restaurant('terminated');
    const ops = await admin('OPS');
    const refused = await ops('POST', `${ended}/accounts`, {
      role: 'owner',
      name: 'مالك',
      phone: '+963944000778',
    });
    expect(refused.statusCode).toBe(403);
    expect(refused.json().error).toBe('restaurant_terminated');
    const fin = await admin('FIN');
    expect(
      (await fin('POST', `${ended}/devices/sign-out`, { deviceId: null, reason: 'x' })).statusCode,
    ).toBe(403);
  });
});

describe('«ملاحظات» and «سجل التغييرات» (AP §9.6.4)', () => {
  it('adds a note once per key, by any reader of restaurants', async () => {
    const id = await restaurant();
    const fin = await admin('FIN');
    // FIN reads statements without restaurants.read (owner decision 2026-11-05).
    expect((await fin('GET', `${id}/notes`)).statusCode).toBe(403);
    const { cookies: opsCookies } = await adminCookies('OPS');
    const note = (body: string, key: string) =>
      app.inject({
        method: 'POST',
        url: `/v1/admin/restaurants/${id}/notes`,
        cookies: opsCookies,
        headers: { 'idempotency-key': key },
        payload: { body },
      });
    const key = randomUUID();
    const first = await note('يفضل الاتصال صباحاً', key);
    expect(first.statusCode).toBe(201);
    expect(first.json().notes).toEqual([
      expect.objectContaining({ body: 'يفضل الاتصال صباحاً', authorName: expect.any(String) }),
    ]);
    expect((await note('يفضل الاتصال صباحاً', key)).json().notes).toHaveLength(1);
    expect((await note('نص آخر', key)).statusCode).toBe(422);
  });

  it('lists the restaurant’s changes with who made them, newest first', async () => {
    const id = await restaurant();
    const ops = await admin('OPS');
    await ops('PUT', `${id}/profile/operations`, operations(540));
    await ops('POST', `${id}/accounts`, { role: 'owner', name: 'مالك', phone: '+963944000779' });
    const log = await ops('GET', `${id}/change-log`);
    expect(log.statusCode).toBe(200);
    const entries = log.json().entries;
    expect(entries.slice(0, 2).map((entry: { action: string }) => entry.action)).toEqual([
      'merchant_account.create',
      'restaurant.operations',
    ]);
    expect(entries[0]).toMatchObject({ actorType: 'admin', account: 'مالك' });
    expect(entries[0].actorName).toMatch(/^Operator/);
    const hours = entries[1].changes.find((change: { field: string }) => change.field === 'periods');
    expect(JSON.parse(hours.after)[0]).toEqual({ weekday: 0, opensAt: 540, closesAt: 1380 });
    expect(entries.at(-1).action).toBe('restaurant.create');
  });
});
