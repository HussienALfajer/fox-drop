import 'reflect-metadata';
import { randomBytes } from 'node:crypto';
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

// «أسعار الصرف» (AP §9.10.4, §8.6) served by the API app: the board, the
// history and the rate edit with its large-change confirmation.
let database: TestDatabase;
let cache: TestValkey;
let app: NestFastifyApplication;
let sql: pg.Pool;
let db: Database;
let azaz: string;
const system = { type: 'system', id: null, role: null } as const;
const change = { actor: system, context: { ipAddress: null, device: null } };

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
  await fx.setCityCurrency(azaz, { currency: 'USD', displayOrder: 2, enabled: false }, change);
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
    [`Finance ${accounts}`, `rates${accounts}@example.test`],
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
    name: `Finance ${accounts}`,
    get: (url: string) => app.inject({ method: 'GET', url, cookies }),
    put: (payload: object) =>
      app.inject({ method: 'PUT', url: '/v1/admin/exchange-rates', cookies, payload }),
  };
}

describe('«أسعار الصرف»', () => {
  it('sets a rate, names its editor and asks again for a large change', async () => {
    const fin = await admin(['FIN']);
    const first = await fin.put({
      cityId: azaz,
      currency: 'USD',
      value: '41.20',
      direction: 'base_per_unit',
      reason: 'Morning rate',
    });
    expect(first.statusCode).toBe(200);
    const usd = first.json().currencies.find((row: { currency: string }) => row.currency === 'USD');
    expect(usd).toMatchObject({
      rate: {
        baseCurrency: 'TRY',
        numerator: '206',
        denominator: '5',
        editorId: fin.accountId,
        editorName: fin.name,
        reason: 'Morning rate',
      },
      stale: false,
      roundingMode: 'nearest',
    });

    const large = { cityId: azaz, currency: 'USD', value: '50', direction: 'base_per_unit' };
    const refused = await fin.put(large);
    expect(refused.statusCode).toBe(409);
    expect(refused.json().error).toBe('large_change_unconfirmed');
    expect((await fin.put({ ...large, confirmLargeChange: true })).statusCode).toBe(200);
    // The same rate again is a new version that confirms it.
    expect((await fin.put({ ...large, value: '50.00' })).statusCode).toBe(200);

    const history = await fin.get(`/v1/admin/exchange-rates/history?cityId=${azaz}&currency=USD`);
    expect(history.statusCode).toBe(200);
    expect(
      history
        .json()
        .versions.map((row: { numerator: string; denominator: string }) => [
          row.numerator,
          row.denominator,
        ]),
    ).toEqual([
      ['50', '1'],
      ['50', '1'],
      ['206', '5'],
    ]);
  });

  it('refuses a malformed rate, the base and an unknown city', async () => {
    const own = await admin(['OWN']);
    const body = { cityId: azaz, currency: 'USD', direction: 'base_per_unit' };
    const malformed = await own.put({ ...body, value: '41,20' });
    expect([malformed.statusCode, malformed.json().error]).toEqual([400, 'invalid_rate']);
    const base = await own.put({ ...body, currency: 'TRY', value: '1' });
    expect([base.statusCode, base.json().error]).toEqual([400, 'invalid_rate']);
    const unknown = await own.get(
      '/v1/admin/exchange-rates?cityId=0190f3a0-0000-7000-8000-00000000dead',
    );
    expect([unknown.statusCode, unknown.json().error]).toEqual([404, 'unknown_city']);
    const history = await own.get(
      '/v1/admin/exchange-rates/history?cityId=0190f3a0-0000-7000-8000-00000000dead&currency=USD',
    );
    expect([history.statusCode, history.json().error]).toEqual([404, 'unknown_city']);
    const other = await own.put({ ...body, currency: 'SYP', value: '290' });
    expect([other.statusCode, other.json().error]).toEqual([400, 'not_city_currency']);
  });

  it('is for OWN and FIN only', async () => {
    const ops = await admin(['OPS']);
    expect((await ops.get(`/v1/admin/exchange-rates?cityId=${azaz}`)).statusCode).toBe(403);
    expect(
      (await ops.put({ cityId: azaz, currency: 'USD', value: '41', direction: 'base_per_unit' }))
        .statusCode,
    ).toBe(403);
  });
});
