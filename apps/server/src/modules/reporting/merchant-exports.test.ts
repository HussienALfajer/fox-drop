import 'reflect-metadata';
import { randomBytes, randomInt, randomUUID } from 'node:crypto';
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
import { MerchantStatementsService } from '../cashdesk/index.js';
import { FxService } from '../fx/index.js';
import {
  ADMIN_SESSION_COOKIE,
  AdminSessionsService,
  CODE_SENDER,
  type DevelopmentCodeSender,
  MerchantAccountsService,
  PORTAL_SESSION_COOKIE,
} from '../identity/index.js';
import { LedgerService } from '../ledger/index.js';
import { MerchantsService } from '../merchants/index.js';
import { ExportsService } from './exports.service.js';

// The owner web portal's Excel files (RA §17, architecture §5.9; slice
// 2.45d, owner decision 2026-11-20): the reports, «السجل» and a weekly
// statement, asked from the portal by an owner, written by the worker,
// downloaded through a URL signed for the portal's origin, audited.
vi.setConfig({ testTimeout: 30_000 });

let database: TestDatabase;
let cache: TestValkey;
let storage: TestStorage;
let app: NestFastifyApplication;
let sql: pg.Pool;
let db: Database;
let azaz: string;
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
  process.env.ADMIN_PANEL_URL = 'http://127.0.0.1:1';
  process.env.APP_UPLOAD_URL = 'http://127.0.0.1:2';
  // The portal's origin forwards /private-docs/exports/ to the storage.
  process.env.MERCHANT_PORTAL_URL = storage.url;
  sql = new pg.Pool({ connectionString: database.appUrl });
  db = createDatabase(database.appUrl);
  app = await createApiApp(ApiModule);
  await app.init();
  await app.getHttpAdapter().getInstance().ready();
  azaz = (await sql.query("SELECT id FROM geo.cities WHERE code = 'AZ'")).rows[0].id;
  const fx = app.get(FxService);
  await fx.setCityCurrency(azaz, { currency: 'TRY', displayOrder: 1, enabled: true }, change);
  await fx.setBaseCurrency(azaz, 'TRY', change);
  exportsService = app.get(ExportsService);
}, 300_000);

afterAll(async () => {
  await app?.close();
  await db?.pool.end();
  await sql?.end();
  await Promise.all([database?.stop(), cache?.stop(), storage?.stop()]);
});

const newPhone = () => `+9639${randomInt(100_000_000).toString().padStart(8, '0')}`;

// A restaurant with a commission it owes, so a statement can be taken.
async function restaurant(name = 'مطعم البوابة'): Promise<string> {
  const merchants = app.get(MerchantsService);
  const id = await merchants.createRestaurant(
    azaz,
    {
      nameAr: name,
      location: { latitude: 36.5866, longitude: 37.0463 },
      coverage: { kind: 'radius', radiusMetres: 3000 },
      minimumOrder: { amount: 10_000n, currency: 'TRY' },
      commissionBp: 1500,
      defaultPrepMin: 20,
    },
    change,
  );
  await merchants.setAccountStatus(id, 'active', change);
  const ledger = app.get(LedgerService);
  await db.db.transaction(async (tx) => {
    const own = await ledger.openAccount(
      { cityId: azaz, purpose: 'merchant.account', ownerId: id, currency: 'TRY' },
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
  return id;
}

// An owner signed in to the portal (its cookie), or a cashier's app token.
async function portalOwner(restaurantId: string) {
  const phone = newPhone();
  await app
    .get(MerchantAccountsService)
    .addAccount(restaurantId, { role: 'owner', name: 'سامر', phone }, change);
  const browserId = randomUUID();
  await app.inject({
    method: 'POST',
    url: '/v1/merchant/auth/portal/code',
    payload: { phone, browserId },
  });
  const signedIn = await app.inject({
    method: 'POST',
    url: '/v1/merchant/auth/portal/sign-in',
    payload: {
      phone,
      browserId,
      code: app.get<DevelopmentCodeSender>(CODE_SENDER).lastCode(phone),
    },
  });
  const cookie = signedIn.cookies.find((each) => each.name === PORTAL_SESSION_COOKIE)!.value;
  return client({ cookies: { [PORTAL_SESSION_COOKIE]: cookie } });
}

async function appUser(restaurantId: string, role: 'owner' | 'cashier') {
  const phone = newPhone();
  await app
    .get(MerchantAccountsService)
    .addAccount(restaurantId, { role, name: role, phone }, change);
  const deviceId = randomUUID();
  await app.inject({ method: 'POST', url: '/v1/merchant/auth/code', payload: { phone, deviceId } });
  const signedIn = await app.inject({
    method: 'POST',
    url: '/v1/merchant/auth/sign-in',
    payload: {
      phone,
      deviceId,
      code: app.get<DevelopmentCodeSender>(CODE_SENDER).lastCode(phone),
    },
  });
  return client({ headers: { authorization: `Bearer ${signedIn.json().accessToken}` } });
}

function client(auth: { cookies?: Record<string, string>; headers?: Record<string, string> }) {
  return {
    get: (url: string) => app.inject({ method: 'GET', url, ...auth }),
    post: (url: string, payload: object, key: string = randomUUID()) =>
      app.inject({
        method: 'POST',
        url,
        ...(auth.cookies ? { cookies: auth.cookies } : {}),
        headers: { ...auth.headers, 'idempotency-key': key },
        payload,
      }),
  };
}

async function auditActions(targetId: string): Promise<string[]> {
  const { rows } = await sql.query(
    "SELECT action FROM audit.events WHERE target_type = 'export' AND target_id = $1 ORDER BY occurred_at",
    [targetId],
  );
  return rows.map((row: { action: string }) => row.action);
}

// Builds the export as the worker does, downloads it from the portal's
// origin and answers its first sheet's rows.
async function downloaded(owner: Awaited<ReturnType<typeof portalOwner>>, id: string) {
  expect(await exportsService.build(id, new Date())).toBe(true);
  const ready = await owner.get(`/v1/merchant/exports/${id}?download=true`);
  expect(ready.statusCode, ready.body).toBe(200);
  const url = new URL(ready.json().url);
  expect(url.origin).toBe(new URL(storage.url).origin);
  expect(url.pathname).toBe(`/private-docs/exports/${id}.xlsx`);
  const file = await fetch(url);
  expect(file.status).toBe(200);
  const workbook = new ExcelJS.Workbook();
  await workbook.xlsx.load(await file.arrayBuffer());
  const rows: unknown[][] = [];
  workbook.worksheets[0]!.eachRow((row) => rows.push((row.values as unknown[]).slice(1)));
  return rows;
}

// Today's business day on the city's clock, as «السجل» reads it by default.
async function businessDay(owner: ReturnType<typeof client>): Promise<string> {
  return (await owner.get('/v1/merchant/orders/history')).json().toDay as string;
}

describe('the portal’s Excel files (RA §17)', () => {
  it('exports the reports of a period and a custom range to their owner', async () => {
    const id = await restaurant();
    const owner = await portalOwner(id);
    const key = randomUUID();
    const asked = await owner.post(
      '/v1/merchant/exports/report',
      { period: 'today', from: null, to: null },
      key,
    );
    expect(asked.statusCode, asked.body).toBe(202);
    const day = await businessDay(owner);
    expect(asked.json()).toMatchObject({
      kind: 'merchant_report',
      status: 'pending',
      fileName: `تقارير المطعم ${day} - ${day}.xlsx`,
      url: null,
    });
    const exportId: string = asked.json().id;
    // The same key answers the same export; another body with it is refused.
    const again = await owner.post(
      '/v1/merchant/exports/report',
      { period: 'today', from: null, to: null },
      key,
    );
    expect(again.json().id).toBe(exportId);
    const reused = await owner.post(
      '/v1/merchant/exports/report',
      { period: 'yesterday', from: null, to: null },
      key,
    );
    expect(reused.statusCode).toBe(422);
    const { rows: stored } = await sql.query('SELECT params FROM reporting.exports WHERE id = $1', [
      exportId,
    ]);
    // The period's days are kept as asked, so the file covers what its
    // name says whenever the worker writes it.
    expect(stored[0].params).toMatchObject({ period: 'today', from: day, to: day });

    const rows = await downloaded(owner, exportId);
    expect(rows[0]).toEqual(['تقارير المطعم']);
    expect(rows[1]).toEqual(['مطعم البوابة']);
    expect(rows).toContainEqual(['العمولة', 25, 0]);
    expect(await auditActions(exportId)).toEqual(['export.create', 'export.download']);

    const range = await owner.post('/v1/merchant/exports/report', {
      period: null,
      from: day,
      to: day,
    });
    expect(range.statusCode, range.body).toBe(202);
    for (const body of [
      { period: null, from: day, to: '2999-01-01' },
      { period: null, from: '2020-01-01', to: day },
    ]) {
      const refused = await owner.post('/v1/merchant/exports/report', body);
      expect([refused.statusCode, refused.json().error]).toEqual([400, 'invalid_period']);
    }
    expect(
      (await owner.post('/v1/merchant/exports/report', { period: 'today', from: day, to: day }))
        .statusCode,
    ).toBe(400);
  });

  it('exports «السجل» of a range and a weekly statement', async () => {
    const id = await restaurant();
    const owner = await portalOwner(id);
    const day = await businessDay(owner);
    const history = await owner.post('/v1/merchant/exports/order-history', {
      from: day,
      to: day,
      status: null,
      number: null,
    });
    expect(history.statusCode, history.body).toBe(202);
    expect(history.json().fileName).toBe(`سجل الطلبات ${day} - ${day}.xlsx`);
    const historyRows = await downloaded(owner, history.json().id);
    expect(historyRows[0]).toEqual(['سجل الطلبات']);
    expect(historyRows[2]?.[0]).toBe('رقم الطلب');

    const cutoff = new Date();
    await app.get(MerchantStatementsService).closeAt(azaz, cutoff, cutoff, { notify: false });
    const { rows } = await sql.query(
      'SELECT id FROM cashdesk.merchant_statements WHERE restaurant_id = $1',
      [id],
    );
    const statementId: string = rows[0].id;
    const statement = await owner.post('/v1/merchant/exports/statement', { statementId });
    expect(statement.statusCode, statement.body).toBe(202);
    const statementRows = await downloaded(owner, statement.json().id);
    expect(statementRows[0]).toEqual(['كشف الأسبوع']);
    expect(statementRows).toContainEqual(['المجموع المستحق', 25]);
    expect(statementRows).toContainEqual(['الحالة', 'غير مسدّد']);

    // Another restaurant's statement is unknown.
    const other = await portalOwner(await restaurant('مطعم آخر'));
    const unknown = await other.post('/v1/merchant/exports/statement', { statementId });
    expect([unknown.statusCode, unknown.json().error]).toEqual([404, 'unknown_statement']);

    // A terminated restaurant's owners keep the statement only (RA §5.5).
    await sql.query(
      "UPDATE merchants.restaurants SET account_status = 'terminated' WHERE id = $1",
      [id],
    );
    expect((await owner.post('/v1/merchant/exports/statement', { statementId })).statusCode).toBe(
      202,
    );
    const refused = await owner.post('/v1/merchant/exports/report', {
      period: 'today',
      from: null,
      to: null,
    });
    expect([refused.statusCode, refused.json().error]).toEqual([403, 'restaurant_terminated']);
    const noHistory = await owner.post('/v1/merchant/exports/order-history', {
      from: day,
      to: day,
      status: null,
      number: null,
    });
    expect([noHistory.statusCode, noHistory.json().error]).toEqual([403, 'restaurant_terminated']);
    // The files made before the termination: the statement's only.
    expect((await owner.get(`/v1/merchant/exports/${statement.json().id}`)).statusCode).toBe(200);
    expect((await owner.get(`/v1/merchant/exports/${history.json().id}`)).statusCode).toBe(404);
  });

  it('serves the portal’s owners only, each their own exports', async () => {
    const id = await restaurant();
    const owner = await portalOwner(id);
    const asked = await owner.post('/v1/merchant/exports/report', {
      period: 'today',
      from: null,
      to: null,
    });
    const exportId: string = asked.json().id;

    // The app's owner and cashier: the portal's only, owners only.
    const appOwner = await appUser(id, 'owner');
    const fromApp = await appOwner.post('/v1/merchant/exports/report', {
      period: 'today',
      from: null,
      to: null,
    });
    expect([fromApp.statusCode, fromApp.json().error]).toEqual([403, 'not_in_portal']);
    const appRead = await appOwner.get(`/v1/merchant/exports/${exportId}`);
    expect([appRead.statusCode, appRead.json().error]).toEqual([403, 'not_in_portal']);
    const cashier = await appUser(id, 'cashier');
    expect((await cashier.get(`/v1/merchant/exports/${exportId}`)).json().error).toBe('owner_only');

    // Another owner, even of the same restaurant, never reads it.
    const second = await portalOwner(id);
    expect((await second.get(`/v1/merchant/exports/${exportId}`)).statusCode).toBe(404);
    expect((await owner.get(`/v1/merchant/exports/${exportId}`)).json()).toMatchObject({
      status: 'pending',
      url: null,
    });

    // The panel never reads a portal's export, whatever its permissions.
    const { rows } = await sql.query(
      `INSERT INTO identity.admin_accounts (name, email, status, password_hash, totp_secret_encrypted)
       VALUES ('Owner', 'owner-exports@example.test', 'active', 'not used', 'not used') RETURNING id`,
    );
    await sql.query(
      "INSERT INTO identity.admin_account_roles (account_id, role_code) VALUES ($1, 'OWN')",
      [rows[0].id],
    );
    const { token } = await app
      .get(AdminSessionsService)
      .start(db.db, rows[0].id, { ipAddress: '203.0.113.9', device: 'test' }, new Date());
    await sql.query('UPDATE reporting.exports SET requested_by = $1 WHERE id = $2', [
      rows[0].id,
      exportId,
    ]);
    const fromPanel = await app.inject({
      method: 'GET',
      url: `/v1/admin/exports/${exportId}`,
      cookies: { [ADMIN_SESSION_COOKIE]: token },
    });
    expect(fromPanel.statusCode).toBe(404);
  });
});
