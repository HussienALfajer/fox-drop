import 'reflect-metadata';
import { randomBytes, randomInt, randomUUID } from 'node:crypto';
import type { NestFastifyApplication } from '@nestjs/platform-fastify';
import pg from 'pg';
import { afterAll, beforeAll, describe, expect, it, vi } from 'vitest';
import { ApiModule } from '../../api.module.js';
import { createDatabase, type Database } from '../../database/database.js';
import { startTestDatabase, type TestDatabase } from '../../database/test-database.js';
import { createApiApp } from '../../http/create-api-app.js';
import { startTestValkey, type TestValkey } from '../../valkey/test-valkey.js';
import { CaptainsService } from '../captains/index.js';
import { FxService } from '../fx/index.js';
import { GeoService, type Point } from '../geo/index.js';
import {
  ADMIN_SESSION_COOKIE,
  AdminSessionsService,
  CODE_SENDER,
  type DevelopmentCodeSender,
} from '../identity/index.js';
import { MerchantsService } from '../merchants/index.js';
import { reportLabels } from '../content/index.js';
import { SettingsService } from '../settings/index.js';

// «التقارير» (AP §9.17, §6.2; slice 2.41): every report over a period of
// business days, read by each role's reports only, and exported to Excel.

vi.setConfig({ testTimeout: 30_000 });

let database: TestDatabase;
let db: Database;
let cache: TestValkey;
let app: NestFastifyApplication;
let sql: pg.Pool;
let azaz: string;
let day: string;

const system = { type: 'system', id: null, role: null } as const;
const change = { actor: system, context: { ipAddress: null, device: null }, reason: 'test' };
const bySystem = { editor: 'system', context: change.context, reason: 'test' } as const;
const centre = { latitude: 36.587, longitude: 37.046 };
const home = { latitude: 36.59, longitude: 37.046 };
const allWeek = [0, 1, 2, 3, 4, 5, 6].map((weekday) => ({ weekday, opensAt: 0, closesAt: 0 }));

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
  const payRate = {
    basePay: 2500n,
    includedMetres: 3000,
    perExtraKm: 500n,
    waitingPerMinute: 0n,
    minimumPay: 2500n,
  };
  await app.get(CaptainsService).setPayTable(
    azaz,
    {
      currency: 'TRY',
      rates: { walking: payRate, bicycle: payRate, motorbike: payRate, car: payRate },
    },
    change,
  );
  const settings = app.get(SettingsService);
  await settings.update('dispatch.capacity_check', { cityId: azaz }, false, bySystem);
  await settings.update('otp.ip_hourly_max', {}, 1000, bySystem);
  await settings.update(
    'currency.<code>.rounding_unit',
    { cityId: azaz, parameter: 'TRY' },
    { amountMinor: 500 },
    bySystem,
  );
  const geo = app.get(GeoService);
  await geo.createZone(azaz, { name: 'المركز', area: square(centre), active: true }, change);
  await geo.setDeliveryFeeRule(
    azaz,
    { kind: 'flat', currency: 'TRY', flatFee: 4000n, minimumFee: null, freeDeliveryFrom: null },
    change,
  );
}, 300_000);

afterAll(async () => {
  await app?.close();
  await db?.pool.end();
  await sql?.end();
  await Promise.all([database?.stop(), cache?.stop()]);
});

const phoneNumber = () => `+9639${randomInt(100_000_000).toString().padStart(8, '0')}`;

let accounts = 0;
async function admin(roles: string[]) {
  accounts += 1;
  const { rows } = await sql.query(
    `INSERT INTO identity.admin_accounts (name, email, status, password_hash, totp_secret_encrypted)
     VALUES ($1, $2, 'active', 'not used', 'not used') RETURNING id`,
    [`Admin ${accounts}`, `reports${accounts}@example.test`],
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

async function signIn(party: 'customer' | 'merchant', phone: string) {
  const deviceId = randomUUID();
  await app.inject({ method: 'POST', url: `/v1/${party}/auth/code`, payload: { phone, deviceId } });
  const code = app.get<DevelopmentCodeSender>(CODE_SENDER).lastCode(phone);
  const answer = await app.inject({
    method: 'POST',
    url: `/v1/${party}/auth/sign-in`,
    payload: { phone, deviceId, code },
  });
  expect(answer.statusCode).toBe(200);
  const headers = { authorization: `Bearer ${answer.json().accessToken}` };
  if (party === 'customer') {
    await app.inject({
      method: 'POST',
      url: '/v1/customer/terms/accept',
      headers,
      payload: { version: 1 },
    });
  } else {
    await app.inject({
      method: 'PUT',
      url: '/v1/merchant/auth/device',
      headers,
      payload: { name: 'كاشير', platform: 'android', appVersion: '1.0.0' },
    });
  }
  return headers;
}

async function restaurant(nameAr: string) {
  const merchants = app.get(MerchantsService);
  const id = await merchants.createRestaurant(
    azaz,
    {
      nameAr,
      location: centre,
      coverage: { kind: 'radius', radiusMetres: 1000 },
      minimumOrder: { amount: 10_000n, currency: 'TRY' },
      commissionBp: 1500,
      defaultPrepMin: 20,
    },
    change,
  );
  await merchants.setAccountStatus(id, 'active', change);
  await merchants.setWeeklySchedule(id, allWeek, change);
  const category = await merchants.addCategory(id, { name: 'وجبات' }, change);
  const item = await merchants.addItem(
    id,
    { categoryId: category, name: 'شاورما', price: { amount: 12_000n, currency: 'TRY' } },
    change,
  );
  return { id, item };
}

async function place(restaurantId: string, itemId: string, customer: Record<string, string>) {
  const lines = [{ itemId, optionIds: [], quantity: 1, note: null, knownUnitPrice: '12000' }];
  const quote = await app.inject({
    method: 'POST',
    url: '/v1/customer/quote',
    payload: { restaurantId, location: home, lines, payIn: null, appVersion: '1.0.0' },
  });
  const answer = await app.inject({
    method: 'POST',
    url: '/v1/customer/orders',
    headers: { ...customer, 'idempotency-key': randomUUID() },
    payload: {
      restaurantId,
      lines,
      payIn: null,
      appVersion: '1.0.0',
      quoteVersion: quote.json().version,
      addressId: null,
      unsavedAddress: {
        location: home,
        street: 'شارع السوق',
        floor: null,
        landmark: 'قرب الجامع',
        contactPhone: null,
        recipientName: null,
        directions: null,
      },
      note: null,
    },
  });
  expect(answer.statusCode).toBe(201);
  return answer.json().order as { id: string; number: string };
}

async function cancel(orderId: string, customer: Record<string, string>) {
  const answer = await app.inject({
    method: 'POST',
    url: `/v1/customer/orders/${orderId}/cancel`,
    headers: { ...customer, 'idempotency-key': randomUUID() },
    payload: { reason: 'changed_mind', note: null },
  });
  expect(answer.statusCode).toBe(200);
}

async function report(user: Awaited<ReturnType<typeof admin>>, kind: string, from = day, to = day) {
  return user.get(`/v1/admin/reports/${kind}?cityId=${azaz}&from=${from}&to=${to}`);
}

type Table = {
  key: string;
  rows: { code: string | null; label: string | null; cells: (string | null)[] }[];
};
const tableOf = (body: { tables: Table[] }, key: string) =>
  body.tables.find((table) => table.key === key)!;

describe('«التقارير» (AP §9.17)', () => {
  it('reads every report of the period from the orders placed, test orders left out', async () => {
    const own = await admin(['OWN']);
    day = (await own.get(`/v1/admin/dashboard?cityId=${azaz}`)).json().day;
    const { id, item } = await restaurant('مطعم التقارير');
    // A new account has one order at a time (D23): two customers.
    const first = await signIn('customer', phoneNumber());
    const second = await signIn('customer', phoneNumber());
    await place(id, item, first);
    const cancelled = await place(id, item, second);
    await cancel(cancelled.id, second);

    const orders = await report(own, 'orders');
    expect(orders.statusCode, orders.body).toBe(200);
    expect(orders.json()).toMatchObject({
      report: 'orders',
      fromDay: day,
      toDay: day,
      currency: 'TRY',
    });
    // Placed 2: none delivered, 1 cancelled, 1 still waiting for the restaurant.
    expect(tableOf(orders.json(), 'summary').rows[0]!.cells).toEqual([
      '2',
      '0',
      '1',
      '0',
      '0',
      '1',
      '0',
    ]);
    expect(tableOf(orders.json(), 'by_zone').rows).toEqual([
      { code: null, label: 'المركز', currency: null, cells: ['2', '0', '1', '0', '0', '1', '0'] },
    ]);
    expect(tableOf(orders.json(), 'cancellations').rows[0]).toMatchObject({
      code: 'changed_mind',
      label: expect.any(String),
      cells: ['1', 'customer', null],
    });
    expect(
      orders.json().tables.find((table: { key: string }) => table.key === 'outcomes').rowCodes,
    ).toBe('outcome');

    const restaurants = await report(own, 'restaurants');
    expect(tableOf(restaurants.json(), 'ranking').rows).toContainEqual(
      expect.objectContaining({ label: 'مطعم التقارير', cells: expect.arrayContaining(['2']) }),
    );
    const customers = await report(own, 'customers');
    expect(tableOf(customers.json(), 'summary').rows[0]!.cells.slice(0, 3)).toEqual([
      '2',
      '2',
      '0',
    ]);
    for (const kind of [
      'orders',
      'timings',
      'restaurants',
      'captains',
      'customers',
      'lost_demand',
      'codes',
      'finance',
    ]) {
      const answer = await report(own, kind);
      expect(answer.statusCode, `${kind}: ${answer.body}`).toBe(200);
      // Every table, header and column has its Arabic words (the file's and
      // the panel's).
      for (const table of answer.json().tables as (Table & {
        rowKind: string;
        columns: { key: string }[];
      })[]) {
        const key = `${kind}.${table.key}`;
        expect(reportLabels.table, key).toHaveProperty([key]);
        if (table.rowKind !== 'none') expect(reportLabels.rowHeader, key).toHaveProperty([key]);
        for (const column of table.columns) {
          expect(reportLabels.column, column.key).toHaveProperty([column.key]);
        }
      }
    }
  });

  it('answers each role its own reports only', async () => {
    const [ops, sup, fin, data] = await Promise.all([
      admin(['OPS']),
      admin(['SUP']),
      admin(['FIN']),
      admin(['DATA']),
    ]);
    expect((await report(ops, 'orders')).statusCode).toBe(200);
    expect((await report(ops, 'finance')).json()).toMatchObject({ error: 'report_not_allowed' });
    expect((await report(sup, 'customers')).statusCode).toBe(200);
    expect((await report(sup, 'orders')).statusCode).toBe(403);
    expect((await report(fin, 'finance')).statusCode).toBe(200);
    expect((await report(fin, 'codes')).statusCode).toBe(200);
    expect((await report(fin, 'captains')).statusCode).toBe(403);
    expect((await report(data, 'orders')).statusCode).toBe(403);
  });

  it('opens on the last 7 business days, and refuses a wrong period and an unknown city', async () => {
    const own = await admin(['OWN']);
    const opened = (await own.get(`/v1/admin/reports/timings?cityId=${azaz}`)).json();
    expect(opened.toDay).toBe(day);
    expect(Date.parse(opened.toDay) - Date.parse(opened.fromDay)).toBe(6 * 86_400_000);
    const half = await own.get(`/v1/admin/reports/timings?cityId=${azaz}&from=${day}`);
    expect(half.statusCode).toBe(400);
    const after = new Date(Date.parse(day) + 86_400_000).toISOString().slice(0, 10);
    for (const [from, to] of [
      [day, after],
      [after, day],
      ['2026-02-30', '2026-03-01'],
    ] as const) {
      const refused = await report(own, 'orders', from, to);
      expect(refused.statusCode, `${from} ${to}`).toBe(400);
      expect(refused.json()).toMatchObject({ error: 'invalid_period' });
    }
    expect(
      (await own.get(`/v1/admin/reports/orders?cityId=${randomUUID()}&from=${day}&to=${day}`))
        .statusCode,
    ).toBe(404);
  });

  it('records an export, with the numbers in full only for exports.phone_numbers', async () => {
    const own = await admin(['OWN']);
    const fin = await admin(['FIN']);
    const period = { cityId: azaz, from: day, to: day };
    const key = randomUUID();
    const asked = await own.post('/v1/admin/reports/customers/exports', period, key);
    expect(asked.statusCode, asked.body).toBe(202);
    expect(asked.json()).toMatchObject({
      kind: 'report',
      status: 'pending',
      fileName: `تقرير الزبائن ${day} - ${day}.xlsx`,
    });
    expect((await own.post('/v1/admin/reports/customers/exports', period, key)).json().id).toBe(
      asked.json().id,
    );
    const { rows } = await sql.query(
      "SELECT changes FROM audit.events WHERE target_type = 'export' AND target_id = $1",
      [asked.json().id],
    );
    expect(rows[0].changes).toMatchObject({
      kind: { after: 'report' },
      report: { after: 'customers' },
      phones: { after: true },
    });
    expect((await fin.post('/v1/admin/reports/customers/exports', period)).statusCode).toBe(403);
    const finance = await fin.post('/v1/admin/reports/finance/exports', period);
    expect(finance.statusCode).toBe(202);
    // Another report's reader never reads it.
    const ops = await admin(['OPS']);
    expect((await ops.get(`/v1/admin/exports/${finance.json().id}`)).statusCode).toBe(404);
    expect((await fin.get(`/v1/admin/exports/${finance.json().id}`)).statusCode).toBe(200);
  });
});
