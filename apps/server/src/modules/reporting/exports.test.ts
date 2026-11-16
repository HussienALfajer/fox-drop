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

// «التقرير اليومي» (AP §9.10.1, slice 2.20d): the routes over the ledger's
// day, today's state, the comparison and the Excel export.
describe('the daily report', () => {
  it("answers today's figures from the ledger, the days before and today's state", async () => {
    const ledger = app.get(LedgerService);
    const system = { type: 'system', id: null } as const;
    const captainId = randomUUID();
    const orderId = randomUUID();
    await db.db.transaction(async (tx) => {
      const open = (
        purpose: Parameters<LedgerService['openAccount']>[0]['purpose'],
        ownerId: string | null = null,
      ) => ledger.openAccount({ cityId: azaz, purpose, ownerId, currency: 'TRY' }, tx);
      const custody = await open('captain.custody', captainId);
      const earnings = await open('captain.earnings', captainId);
      const clearing = await open('platform.order_clearing');
      const fees = await open('platform.revenue_delivery');
      const pay = await open('platform.captain_pay');
      const drawer = await open('platform.cash', randomUUID());
      const order = { kind: 'order', id: orderId } as const;
      const post = (
        type: Parameters<LedgerService['post']>[0]['type'],
        source: typeof order | null,
        entries: [string, bigint][],
      ) =>
        ledger.post(
          {
            cityId: azaz,
            type,
            source,
            actor: system,
            entries: entries.map(([accountId, amount]) => ({ accountId, currency: 'TRY', amount })),
          },
          tx,
        );
      await post('custody.pay_merchant', order, [
        [custody, -40_000n],
        [clearing, 40_000n],
      ]);
      await post('custody.collect', order, [
        [custody, 44_000n],
        [clearing, -44_000n],
      ]);
      await post('platform.revenue_delivery', order, [
        [clearing, 4_000n],
        [fees, -4_000n],
      ]);
      await post('earn.order_pay', order, [
        [earnings, -2_500n],
        [pay, 2_500n],
      ]);
      await post('custody.hand_in', null, [
        [custody, -3_000n],
        [drawer, 3_000n],
      ]);
    });

    const fin = await admin(['FIN']);
    const answer = await fin.get(`/v1/admin/daily-report?cityId=${azaz}`);
    expect(answer.statusCode).toBe(200);
    const report = answer.json();
    expect(report).toMatchObject({
      cityId: azaz,
      today: true,
      currency: 'TRY',
      // No order row was delivered here: the ledger's figures stand alone.
      orders: { count: 0, gmv: '0', itemsValue: '0' },
      deliveryFees: '4000',
      // The setup's commission of 25.
      commission: '2500',
      captainPay: { base: '2500', distance: '0', total: '2500' },
      // 25 + 40 − 25.
      margin: '4000',
      cash: [
        {
          currency: 'TRY',
          custodyCreated: '4000',
          handedIn: '3000',
          reimbursed: '0',
          openCustody: '1000',
          owedToCaptains: '0',
        },
      ],
      restaurants: { commission: '2500', owedByRestaurants: '2500', owedToRestaurants: '0' },
      now: { captainsBlocked: 0, overdueRestaurants: [] },
    });
    expect(report.previous).toHaveLength(6);
    const before = new Date(Date.parse(report.day) - 86_400_000).toISOString().slice(0, 10);
    expect(report.previous[0]).toMatchObject({ day: before, margin: '0', to: report.from });

    // A past day: no state now, nothing earned.
    const past = (await fin.get(`/v1/admin/daily-report?cityId=${azaz}&day=${before}`)).json();
    expect(past).toMatchObject({ day: before, today: false, now: null, margin: '0' });
    expect(past.cash).toEqual([]);

    // The day not started, a day that does not exist, an unknown city, OPS.
    const after = new Date(Date.parse(report.day) + 86_400_000).toISOString().slice(0, 10);
    const future = await fin.get(`/v1/admin/daily-report?cityId=${azaz}&day=${after}`);
    expect(future.statusCode).toBe(400);
    expect(future.json()).toMatchObject({ error: 'invalid_day' });
    expect(
      (await fin.get(`/v1/admin/daily-report?cityId=${azaz}&day=2026-02-30`)).json(),
    ).toMatchObject({ error: 'invalid_day' });
    const unknown = await fin.get(`/v1/admin/daily-report?cityId=${randomUUID()}`);
    expect(unknown.statusCode).toBe(404);
    expect(unknown.json()).toMatchObject({ error: 'unknown_city' });
    const ops = await admin(['OPS']);
    expect((await ops.get(`/v1/admin/daily-report?cityId=${azaz}`)).statusCode).toBe(403);
  });

  it('exports the day to Excel, read by its requester while they hold finance.read', async () => {
    const fin = await admin(['FIN']);
    const { day } = (await fin.get(`/v1/admin/daily-report?cityId=${azaz}`)).json();
    const key = randomUUID();
    const asked = await fin.post('/v1/admin/daily-report/exports', { cityId: azaz, day }, key);
    expect(asked.statusCode).toBe(202);
    expect(asked.json()).toMatchObject({
      kind: 'daily_report',
      status: 'pending',
      fileName: `التقرير اليومي ${day}.xlsx`,
    });
    const id: string = asked.json().id;
    expect(await auditActions(id)).toEqual(['export.create']);
    expect(
      (await fin.post('/v1/admin/daily-report/exports', { cityId: azaz, day }, key)).json().id,
    ).toBe(id);
    const after = new Date(Date.parse(day) + 86_400_000).toISOString().slice(0, 10);
    const reused = await fin.post(
      '/v1/admin/daily-report/exports',
      { cityId: azaz, day: after },
      key,
    );
    expect(reused.statusCode).toBe(422);
    const future = await fin.post('/v1/admin/daily-report/exports', { cityId: azaz, day: after });
    expect(future.statusCode).toBe(400);
    expect(future.json()).toMatchObject({ error: 'invalid_day' });

    expect(await exportsService.build(id, new Date())).toBe(true);
    const ready = await fin.get(`/v1/admin/exports/${id}?download=true`);
    expect(ready.json()).toMatchObject({ status: 'ready', url: expect.any(String) });
    const workbook = new ExcelJS.Workbook();
    await workbook.xlsx.load(await (await fetch(new URL(ready.json().url))).arrayBuffer());
    const sheet = workbook.worksheets[0]!;
    expect(sheet.getRow(2).values).toEqual([undefined, 'اليوم التجاري', day]);
    const rows = sheet
      .getSheetValues()
      .filter((row): row is ExcelJS.CellValue[] => Array.isArray(row))
      .map((row) => row.slice(1));
    expect(rows.find((row) => row[0] === 'هامش المنصة')?.[1]).toBe(40);
    expect(rows.find((row) => row[0] === 'سُلّم اليوم')).toEqual(['سُلّم اليوم', 30]);

    // An export is read with its kind's permission: a requester who holds
    // only the statements' no longer sees this one.
    const user = {
      accountId: fin.accountId,
      actor: { type: 'admin', id: fin.accountId, role: 'FIN' },
      context: { ipAddress: null, device: null },
    } as const;
    await expect(
      exportsService.view(id, { ...user, permissions: ['restaurants.statements'] }, new Date()),
    ).rejects.toMatchObject({ refusal: 'unknown_export' });
    expect(
      (await exportsService.view(id, { ...user, permissions: ['finance.read'] }, new Date()))
        .status,
    ).toBe('ready');
  });
});
