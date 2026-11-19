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
