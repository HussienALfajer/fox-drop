import 'reflect-metadata';
import { randomBytes, randomInt, randomUUID } from 'node:crypto';
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
  MerchantAccountsService,
} from '../identity/index.js';
import { MerchantsService } from '../merchants/index.js';

// AP §9.13 «الشروط والخصوصية»: a versioned document per audience, read by the
// apps, accepted per account and published again in the panel.
let database: TestDatabase;
let cache: TestValkey;
let app: NestFastifyApplication;
let sql: pg.Pool;
let db: Database;
let restaurant: string;

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
  const azaz = (await sql.query("SELECT id FROM geo.cities WHERE code = 'AZ'")).rows[0].id;
  const fx = app.get(FxService);
  await fx.setCityCurrency(azaz, { currency: 'TRY', displayOrder: 1, enabled: true }, change);
  await fx.setBaseCurrency(azaz, 'TRY', change);
  const merchants = app.get(MerchantsService);
  restaurant = await merchants.createRestaurant(
    azaz,
    {
      nameAr: 'مطعم الشروط',
      location: { latitude: 36.587, longitude: 37.046 },
      coverage: { kind: 'radius', radiusMetres: 1000 },
      minimumOrder: { amount: 10_000n, currency: 'TRY' },
      commissionBp: 1500,
      defaultPrepMin: 20,
    },
    change,
  );
  await merchants.setAccountStatus(restaurant, 'active', change);
}, 300_000);

afterAll(async () => {
  await app?.close();
  await db?.pool.end();
  await sql?.end();
  await Promise.all([database?.stop(), cache?.stop()]);
});

const phoneNumber = () => `+9639${randomInt(100_000_000).toString().padStart(8, '0')}`;

async function signIn(party: 'customer' | 'merchant' | 'captain', phone: string) {
  const deviceId = randomUUID();
  await app.inject({ method: 'POST', url: `/v1/${party}/auth/code`, payload: { phone, deviceId } });
  const code = app.get<DevelopmentCodeSender>(CODE_SENDER).lastCode(phone);
  const answer = await app.inject({
    method: 'POST',
    url: `/v1/${party}/auth/sign-in`,
    payload: { phone, deviceId, code },
  });
  expect(answer.statusCode).toBe(200);
  return { authorization: `Bearer ${answer.json().accessToken}` };
}

async function owner() {
  const { rows } = await sql.query(
    `INSERT INTO identity.admin_accounts (name, email, status, password_hash, totp_secret_encrypted)
     VALUES ('Owner', $1, 'active', 'not used', 'not used') RETURNING id`,
    [`owner-${randomUUID()}@example.test`],
  );
  const accountId: string = rows[0].id;
  await sql.query(
    "INSERT INTO identity.admin_account_roles (account_id, role_code) VALUES ($1, 'OWN')",
    [accountId],
  );
  const { token } = await app
    .get(AdminSessionsService)
    .start(db.db, accountId, { ipAddress: '203.0.113.9', device: 'test' }, new Date());
  const cookies = { [ADMIN_SESSION_COOKIE]: token };
  return (method: 'GET' | 'POST', url: string, payload?: object) =>
    app.inject({ method, url, cookies, ...(payload ? { payload } : {}) });
}

const read = (party: string, headers: Record<string, string> = {}) =>
  app.inject({ method: 'GET', url: `/v1/${party}/terms`, headers });

const accept = (party: string, headers: Record<string, string>, version: number) =>
  app.inject({
    method: 'POST',
    url: `/v1/${party}/terms/accept`,
    headers,
    payload: { version },
  });

describe('terms and privacy (AP §9.13)', () => {
  it('starts each audience from its draft, read without a session', async () => {
    for (const party of ['customer', 'captain', 'merchant']) {
      const answer = await read(party);
      expect(answer.statusCode).toBe(200);
      expect(answer.json()).toMatchObject({ version: 1, pending: false });
      expect(answer.json().body.length).toBeGreaterThan(100);
    }
  });

  it('is pending for an account until it accepts the version in force', async () => {
    const customer = await signIn('customer', phoneNumber());
    expect((await read('customer', customer)).json().pending).toBe(true);
    const outdated = await accept('customer', customer, 2);
    expect(outdated.statusCode).toBe(409);
    expect(outdated.json()).toMatchObject({ error: 'terms_outdated' });
    expect((await accept('customer', customer, 1)).json()).toEqual({ status: 'accepted' });
    // Accepting again changes nothing.
    expect((await accept('customer', customer, 1)).statusCode).toBe(200);
    expect((await read('customer', customer)).json().pending).toBe(false);
  });

  it("asks a restaurant's owners, never its cashiers (RA §4.10, S13)", async () => {
    const accounts = app.get(MerchantAccountsService);
    const ownerPhone = phoneNumber();
    const cashierPhone = phoneNumber();
    await accounts.addAccount(
      restaurant,
      { role: 'owner', name: 'مالك', phone: ownerPhone },
      change,
    );
    await accounts.addAccount(
      restaurant,
      { role: 'cashier', name: 'كاشير', phone: cashierPhone },
      change,
    );
    expect((await read('merchant', await signIn('merchant', ownerPhone))).json().pending).toBe(
      true,
    );
    expect((await read('merchant', await signIn('merchant', cashierPhone))).json().pending).toBe(
      false,
    );
  });

  it('publishes a new version that every account accepts again, audited', async () => {
    const admin = await owner();
    const customer = await signIn('customer', phoneNumber());
    await accept('customer', customer, (await read('customer')).json().version);
    const before = (await admin('GET', '/v1/admin/content/terms')).json();
    expect(Object.keys(before).sort()).toEqual(['captain', 'customer', 'merchant']);

    const unchanged = await admin('POST', '/v1/admin/content/terms/customer', {
      body: before.customer.body,
    });
    expect(unchanged.statusCode).toBe(400);
    expect(unchanged.json()).toMatchObject({ error: 'terms_unchanged' });

    const published = await admin('POST', '/v1/admin/content/terms/customer', {
      body: 'الشروط الجديدة',
    });
    expect(published.statusCode).toBe(201);
    expect(published.json()).toMatchObject({
      version: before.customer.version + 1,
      body: 'الشروط الجديدة',
    });
    expect((await read('customer', customer)).json()).toMatchObject({
      version: before.customer.version + 1,
      pending: true,
    });
    // The other audiences keep theirs.
    expect((await admin('GET', '/v1/admin/content/terms')).json().captain).toEqual(before.captain);
    const { rows } = await sql.query(
      "SELECT target_id, changes FROM audit.events WHERE action = 'content.terms.publish'",
    );
    expect(rows).toEqual([
      {
        target_id: 'terms.customer',
        changes: {
          version: { before: before.customer.version, after: before.customer.version + 1 },
        },
      },
    ]);
  });

  it('never changes a version or an acceptance', async () => {
    await expect(
      sql.query("UPDATE content.terms_versions SET body = 'x' WHERE audience = 'captain'"),
    ).rejects.toThrow(/permission denied/);
    await expect(sql.query('UPDATE content.terms_acceptances SET version = 1')).rejects.toThrow(
      /permission denied/,
    );
  });
});
