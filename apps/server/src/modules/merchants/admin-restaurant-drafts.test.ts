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

// The wizard's routes (AP §9.6.3; slice 2.30a): the drafts, the choices and
// each step's save, by the roles of each step.
let database: TestDatabase;
let cache: TestValkey;
let app: NestFastifyApplication;
let sql: pg.Pool;
let db: Database;
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

async function token(role: string): Promise<string> {
  accounts += 1;
  const { rows } = await sql.query(
    `INSERT INTO identity.admin_accounts (name, email, status, password_hash, totp_secret_encrypted)
     VALUES ($1, $2, 'active', 'not used', 'not used') RETURNING id`,
    [`Admin ${accounts}`, `drafts${accounts}@example.test`],
  );
  await sql.query(
    'INSERT INTO identity.admin_account_roles (account_id, role_code) VALUES ($1, $2)',
    [rows[0].id, role],
  );
  const { token } = await app
    .get(AdminSessionsService)
    .start(db.db, rows[0].id, { ipAddress: '203.0.113.9', device: 'test' }, new Date());
  return token;
}

async function admin(role: string) {
  const cookies = { [ADMIN_SESSION_COOKIE]: await token(role) };
  return (method: 'GET' | 'PUT' | 'POST', url: string, payload?: object) =>
    app.inject({
      method,
      url: `/v1/admin/restaurant-drafts${url}`,
      cookies,
      ...(payload ? { payload } : {}),
    });
}

const basics = { nameAr: 'مطعم الريف', nameEn: null, categoryIds: [], description: null };
const location = {
  location: { latitude: 36.587, longitude: 37.046 },
  address: null,
  phone: null,
  ownerName: 'أبو محمد',
};
const operations = {
  periods: [{ weekday: 5, opensAt: 660, closesAt: 120 }],
  defaultPrepMin: 25,
  minimumOrder: { amount: '7500', currency: 'TRY' },
  coverage: { kind: 'radius', radiusMetres: 2500 },
};

describe('the wizard routes, steps 1–3', () => {
  it('lets DATA start a draft, save each step, find it in the list and read it back', async () => {
    const data = await admin('DATA');
    const id = randomUUID();
    const started = await data('PUT', `/${id}/basics`, { cityId: azaz, ...basics });
    expect(started.statusCode).toBe(200);
    expect(started.json()).toMatchObject({
      id,
      accountStatus: 'draft',
      steps: { basics: true, location: false, operations: false },
    });
    expect((await data('PUT', `/${id}/location`, location)).statusCode).toBe(200);
    const saved = await data('PUT', `/${id}/operations`, operations);
    expect(saved.statusCode).toBe(200);
    expect(saved.json()).toMatchObject({
      location: location,
      operations,
      steps: { basics: true, location: true, operations: true },
    });
    const list = await data('GET', `?cityId=${azaz}`);
    expect(list.json().drafts).toContainEqual(
      expect.objectContaining({ id, nameAr: 'مطعم الريف' }),
    );
    expect((await data('GET', `/${id}`)).json()).toEqual(saved.json());
  });

  it('answers the choices of the city with the defaults', async () => {
    const ops = await admin('OPS');
    const response = await ops('GET', `/choices?cityId=${azaz}`);
    expect(response.statusCode).toBe(200);
    expect(response.json()).toMatchObject({
      baseCurrency: 'TRY',
      defaultCommissionBp: 1500,
      defaultPrepMin: 20,
      categoriesMax: 5,
    });
  });

  it('maps the refusals and keeps the steps from roles without restaurants.create', async () => {
    const data = await admin('DATA');
    const id = randomUUID();
    expect((await data('PUT', `/${id}/location`, location)).json()).toMatchObject({
      statusCode: 404,
      error: 'unknown_restaurant',
    });
    await data('PUT', `/${id}/basics`, { cityId: azaz, ...basics });
    expect(
      (
        await data('PUT', `/${id}/operations`, {
          ...operations,
          minimumOrder: { amount: '100', currency: 'USD' },
        })
      ).json(),
    ).toMatchObject({ statusCode: 409, error: 'not_in_base_currency' });
    expect(
      (await data('PUT', `/${id}/operations`, { ...operations, defaultPrepMin: 1 })).json(),
    ).toMatchObject({ statusCode: 400, error: 'invalid_prep_time' });
    const finance = await admin('FIN');
    expect((await finance('PUT', `/${id}/basics`, { cityId: azaz, ...basics })).statusCode).toBe(
      403,
    );
  });
});

describe('the wizard routes, steps 4–6', () => {
  it('keeps the commission to OWN and the contract confirmation to OWN and OPS', async () => {
    const data = await admin('DATA');
    const id = randomUUID();
    await data('PUT', `/${id}/basics`, { cityId: azaz, ...basics });
    const commission = { rateBp: 1500, launch: null };
    expect((await data('PUT', `/${id}/commission`, commission)).statusCode).toBe(403);
    const owner = await admin('OWN');
    const saved = await owner('PUT', `/${id}/commission`, commission);
    expect(saved.json()).toMatchObject({ commission, steps: { commission: true } });
    const contract = {
      signedOn: '2026-11-15',
      durationMonths: 6,
      contractUploadId: null,
      licenceUploadId: null,
    };
    expect((await data('PUT', `/${id}/contract`, contract)).json()).toMatchObject({
      contract: { signedOn: '2026-11-15', durationMonths: 6, contractUrl: null },
    });
    expect((await data('POST', `/${id}/contract/confirm`, { parityPledge: true })).statusCode).toBe(
      403,
    );
    expect(
      (await owner('POST', `/${id}/contract/confirm`, { parityPledge: true })).json(),
    ).toMatchObject({ statusCode: 400, error: 'invalid_contract' });
  });

  it("adds a draft's owner and cashier once, refuses a number in use and removes one", async () => {
    const data = await admin('DATA');
    const id = randomUUID();
    await data('PUT', `/${id}/basics`, { cityId: azaz, ...basics });
    const opsToken = await token('OPS');
    const dataToken = await token('DATA');
    const accounts = (method: 'GET' | 'POST', path = '', payload?: object) =>
      app.inject({
        method,
        url: `/v1/admin/restaurants/${id}/accounts${path}`,
        cookies: { [ADMIN_SESSION_COOKIE]: opsToken },
        ...(payload ? { payload } : {}),
      });
    const owner = { role: 'owner', name: 'أبو محمد', phone: '+963944000301' };
    const added = await accounts('POST', '', owner);
    expect(added.json()).toMatchObject({ accounts: [{ role: 'owner' }] });
    const repeated = await accounts('POST', '', owner);
    expect(repeated.json().accounts).toEqual([
      { id: expect.any(String), role: 'owner', name: 'أبو محمد', phone: '+963944000301' },
    ]);
    const cashier = await accounts('POST', '', {
      role: 'cashier',
      name: 'كاشير',
      phone: '+905321112233',
    });
    expect(cashier.json().accounts.map((account: { role: string }) => account.role)).toEqual([
      'owner',
      'cashier',
    ]);
    const other = randomUUID();
    await data('PUT', `/${other}/basics`, { cityId: azaz, ...basics });
    const taken = await app.inject({
      method: 'POST',
      url: `/v1/admin/restaurants/${other}/accounts`,
      cookies: { [ADMIN_SESSION_COOKIE]: opsToken },
      payload: owner,
    });
    expect(taken.json()).toMatchObject({ statusCode: 409, error: 'phone_taken' });
    const cashierId = cashier.json().accounts[1].id;
    const removed = await accounts('POST', `/${cashierId}/remove`);
    expect(removed.json().accounts).toHaveLength(1);
    expect((await accounts('POST', `/${cashierId}/remove`)).json()).toMatchObject({
      statusCode: 404,
      error: 'unknown_account',
    });
    expect((await data('GET', `/${id}`)).statusCode).toBe(200);
    const forbidden = await app.inject({
      method: 'POST',
      url: `/v1/admin/restaurants/${id}/accounts`,
      cookies: { [ADMIN_SESSION_COOKIE]: dataToken },
      payload: owner,
    });
    expect(forbidden.statusCode).toBe(403);
  });
});
