import 'reflect-metadata';
import { randomBytes, randomUUID } from 'node:crypto';
import type { NestFastifyApplication } from '@nestjs/platform-fastify';
import ExcelJS from 'exceljs';
import pg from 'pg';
import { afterAll, beforeAll, describe, expect, it, vi } from 'vitest';
import { ApiModule } from '../../api.module.js';
import { createDatabase, type Database } from '../../database/database.js';
import { startTestDatabase, type TestDatabase } from '../../database/test-database.js';
import { createApiApp } from '../../http/create-api-app.js';
import { startTestStorage, type TestStorage } from '../../storage/test-storage.js';
import { startTestValkey, type TestValkey } from '../../valkey/test-valkey.js';
import { FxService } from '../fx/index.js';
import { ADMIN_SESSION_COOKIE, AdminSessionsService } from '../identity/index.js';
import { LedgerService } from '../ledger/index.js';
import { MerchantsService } from '../merchants/index.js';
import { EXPORT_KEEP_MS, ExportsService } from './exports.service.js';

// The Excel export of a restaurant's statement (architecture §5.9, AP §9.10.5,
// AP §5.4; slice 2.19g): asked and audited, written by the worker's job to
// private-docs, downloaded through a short signed URL by its requester only,
// and removed after 24 hours.
vi.setConfig({ testTimeout: 30_000 });

let database: TestDatabase;
let cache: TestValkey;
let storage: TestStorage;
let app: NestFastifyApplication;
let sql: pg.Pool;
let db: Database;
let azaz: string;
let restaurantId: string;
let exportsService: ExportsService;

const system = { type: 'system', id: null, role: null } as const;
const change = { actor: system, context: { ipAddress: null, device: null }, reason: 'test' };

beforeAll(async () => {
  [database, cache, storage] = await Promise.all([
    startTestDatabase(),
    startTestValkey(),
    startTestStorage(),
  ]);
  process.env.DATABASE_URL = database.appUrl;
  process.env.VALKEY_URL = cache.url;
  process.env.IDENTITY_ENCRYPTION_KEY = randomBytes(32).toString('base64');
  process.env.FOX_DROP_ENVIRONMENT = 'development';
  process.env.STORAGE_URL = storage.url;
  process.env.STORAGE_KEY_ID = storage.key.id;
  process.env.STORAGE_SECRET = storage.key.secret;
  // The panel's origin forwards /private-docs/exports/ to the storage.
  process.env.ADMIN_PANEL_URL = storage.url;
  sql = new pg.Pool({ connectionString: database.appUrl });
  db = createDatabase(database.appUrl);
  app = await createApiApp(ApiModule);
  await app.init();
  await app.getHttpAdapter().getInstance().ready();
  azaz = (await sql.query("SELECT id FROM geo.cities WHERE code = 'AZ'")).rows[0].id;
  const fx = app.get(FxService);
  await fx.setCityCurrency(azaz, { currency: 'TRY', displayOrder: 1, enabled: true }, change);
  await fx.setBaseCurrency(azaz, 'TRY', change);
  const merchants = app.get(MerchantsService);
  restaurantId = await merchants.createRestaurant(
    azaz,
    {
      nameAr: 'مطعم التصدير/الأول',
      location: { latitude: 36.5866, longitude: 37.0463 },
      coverage: { kind: 'radius', radiusMetres: 3000 },
      minimumOrder: { amount: 10_000n, currency: 'TRY' },
      commissionBp: 1500,
      defaultPrepMin: 20,
    },
    change,
  );
  const ledger = app.get(LedgerService);
  await db.db.transaction(async (tx) => {
    const own = await ledger.openAccount(
      { cityId: azaz, purpose: 'merchant.account', ownerId: restaurantId, currency: 'TRY' },
      tx,
    );
    const revenue = await ledger.openAccount(
      { cityId: azaz, purpose: 'platform.revenue_commission', ownerId: null, currency: 'TRY' },
      tx,
    );
    await ledger.post(
      {
        cityId: azaz,
        type: 'merchant.commission',
        source: { kind: 'order', id: randomUUID() },
        actor: { type: 'system', id: null },
        entries: [
          { accountId: own, currency: 'TRY', amount: 2_500n },
          { accountId: revenue, currency: 'TRY', amount: -2_500n },
        ],
      },
      tx,
    );
  });
  exportsService = app.get(ExportsService);
}, 300_000);

afterAll(async () => {
  await app?.close();
  await db?.pool.end();
  await sql?.end();
  await Promise.all([database?.stop(), cache?.stop(), storage?.stop()]);
});

let accounts = 0;
async function admin(roles: string[]) {
  accounts += 1;
  const { rows } = await sql.query(
    `INSERT INTO identity.admin_accounts (name, email, status, password_hash, totp_secret_encrypted)
     VALUES ($1, $2, 'active', 'not used', 'not used') RETURNING id`,
    [`Exports ${accounts}`, `exports${accounts}@example.test`],
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
    get: (url: string) => app.inject({ method: 'GET', url, cookies }),
    post: (url: string, payload: object, key: string | null = randomUUID()) =>
      app.inject({
        method: 'POST',
        url,
        cookies,
        headers: key === null ? {} : { 'idempotency-key': key },
        payload,
      }),
  };
}

const today = new Date().toISOString().slice(0, 10);
const tomorrow = new Date(Date.now() + 86_400_000).toISOString().slice(0, 10);
const yesterday = new Date(Date.now() - 86_400_000).toISOString().slice(0, 10);

async function auditActions(targetId: string): Promise<string[]> {
  const { rows } = await sql.query(
    "SELECT action FROM audit.events WHERE target_type = 'export' AND target_id = $1 ORDER BY occurred_at",
    [targetId],
  );
  return rows.map((row: { action: string }) => row.action);
}

describe('the Excel export of a restaurant statement', () => {
  it('is asked, written, downloaded by its requester and removed after a day', async () => {
    const fin = await admin(['FIN']);
    const key = randomUUID();
    const body = { restaurantId, from: yesterday, to: tomorrow };
    const asked = await fin.post('/v1/admin/restaurant-statements/exports', body, key);
    expect(asked.statusCode).toBe(202);
    expect(asked.json()).toMatchObject({
      kind: 'restaurant_statement',
      status: 'pending',
      fileName: `كشف مطعم التصدير-الأول ${yesterday} - ${tomorrow}.xlsx`,
      url: null,
    });
    const id: string = asked.json().id;
    const { rows: jobs } = await sql.query(
      "SELECT data FROM pgboss.job WHERE name = 'reporting-export-build' AND data->>'exportId' = $1",
      [id],
    );
    expect(jobs).toHaveLength(1);
    expect(await auditActions(id)).toEqual(['export.create']);

    // The same key answers the same export; with another body it is refused.
    const again = await fin.post('/v1/admin/restaurant-statements/exports', body, key);
    expect(again.json().id).toBe(id);
    const reused = await fin.post(
      '/v1/admin/restaurant-statements/exports',
      { ...body, from: today },
      key,
    );
    expect(reused.statusCode).toBe(422);

    // The worker's job writes it once.
    const now = new Date();
    expect(await exportsService.build(id, now)).toBe(true);
    expect(await exportsService.build(id, now)).toBe(false);

    // Reading the state signs and logs nothing; asking the download does.
    const state = await fin.get(`/v1/admin/exports/${id}`);
    expect(state.json()).toMatchObject({ status: 'ready', url: null });
    expect(await auditActions(id)).toEqual(['export.create']);
    const ready = await fin.get(`/v1/admin/exports/${id}?download=true`);
    expect(ready.statusCode).toBe(200);
    expect(ready.json()).toMatchObject({ status: 'ready', url: expect.any(String) });
    const url = new URL(ready.json().url);
    expect(url.pathname).toBe(`/private-docs/exports/${id}.xlsx`);
    const file = await fetch(url);
    expect(file.status).toBe(200);
    expect(file.headers.get('content-disposition')).toContain('attachment');
    const workbook = new ExcelJS.Workbook();
    await workbook.xlsx.load(await file.arrayBuffer());
    expect(workbook.worksheets[0]?.getRow(2).values).toEqual([
      undefined,
      'المطعم',
      'مطعم التصدير/الأول',
    ]);
    expect(await auditActions(id)).toEqual(['export.create', 'export.download']);

    // Nobody else reads it, not even another FIN.
    const other = await admin(['FIN']);
    expect((await other.get(`/v1/admin/exports/${id}?download=true`)).statusCode).toBe(404);

    // The removal job queued for 24 hours on removes the file, once.
    const { rows: expiry } = await sql.query(
      "SELECT start_after FROM pgboss.job WHERE name = 'reporting-export-expiry' AND data->>'exportId' = $1",
      [id],
    );
    expect(expiry[0].start_after.getTime()).toBe(now.getTime() + EXPORT_KEEP_MS);
    expect(await exportsService.expire(id)).toBe(true);
    expect(await exportsService.expire(id)).toBe(false);
    const expired = await fin.get(`/v1/admin/exports/${id}?download=true`);
    expect(expired.json()).toMatchObject({ status: 'expired', url: null });
    expect((await fetch(url)).status).toBe(404);
  });

  it('refuses an unknown restaurant, a wrong period and a user without the statements', async () => {
    const fin = await admin(['FIN']);
    const unknown = await fin.post('/v1/admin/restaurant-statements/exports', {
      restaurantId: randomUUID(),
      from: today,
      to: today,
    });
    expect(unknown.statusCode).toBe(404);
    expect(unknown.json()).toMatchObject({ error: 'unknown_restaurant' });
    const backwards = await fin.post('/v1/admin/restaurant-statements/exports', {
      restaurantId,
      from: tomorrow,
      to: today,
    });
    expect(backwards.statusCode).toBe(400);
    expect(backwards.json()).toMatchObject({ error: 'invalid_period' });
    const noKey = await fin.post(
      '/v1/admin/restaurant-statements/exports',
      { restaurantId, from: today, to: today },
      null,
    );
    expect(noKey.statusCode).toBe(400);

    const ops = await admin(['OPS']);
    expect(
      (
        await ops.post('/v1/admin/restaurant-statements/exports', {
          restaurantId,
          from: today,
          to: today,
        })
      ).statusCode,
    ).toBe(403);
  });
});
