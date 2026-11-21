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
  MerchantAccountsService,
} from '../identity/index.js';
import { MerchantsService } from '../merchants/index.js';
import { SettingsService } from '../settings/index.js';
import { type LateCodeJob, OrderTimers } from './order-timers.js';

// AP §8.3, §6.4, docs/domain/03, CU §11.6, §14 #15 (slice 2.22c): an order
// still not delivered at the promised time + order.delivery_late_compensation_min
// gets one late code, a personal code of order.late_compensation_value,
// outside every compensation cap; the timer moves with the promised time and
// an order that ended gets none.

vi.setConfig({ testTimeout: 30_000 });

let database: TestDatabase;
let cache: TestValkey;
let app: NestFastifyApplication;
let sql: pg.Pool;
let db: Database;
let azaz: string;
let restaurant: string;
let item: string;
let settings: SettingsService;

const system = { type: 'system', id: null, role: null } as const;
const change = { actor: system, context: { ipAddress: null, device: null }, reason: 'test' };
const bySystem = { editor: 'system', context: change.context, reason: 'test' } as const;
const centre = { latitude: 36.587, longitude: 37.046 };
const home = { latitude: 36.59, longitude: 37.046 };
const allWeek = [0, 1, 2, 3, 4, 5, 6].map((weekday) => ({ weekday, opensAt: 0, closesAt: 0 }));
const MINUTE_MS = 60_000;

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
  settings = app.get(SettingsService);
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
  const merchants = app.get(MerchantsService);
  restaurant = await merchants.createRestaurant(
    azaz,
    {
      nameAr: 'مطعم التأخير',
      address: 'شارع المطاعم',
      location: centre,
      coverage: { kind: 'radius', radiusMetres: 1000 },
      minimumOrder: { amount: 10_000n, currency: 'TRY' },
      commissionBp: 1500,
      defaultPrepMin: 20,
    },
    change,
  );
  await merchants.setAccountStatus(restaurant, 'active', change);
  await merchants.setWeeklySchedule(restaurant, allWeek, change);
  const category = await merchants.addCategory(restaurant, { name: 'وجبات' }, change);
  item = await merchants.addItem(
    restaurant,
    { categoryId: category, name: 'شاورما', price: { amount: 12_000n, currency: 'TRY' } },
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

async function appSignIn(party: 'customer' | 'merchant', phone: string) {
  const deviceId = randomUUID();
  await app.inject({ method: 'POST', url: `/v1/${party}/auth/code`, payload: { phone, deviceId } });
  const code = app.get<DevelopmentCodeSender>(CODE_SENDER).lastCode(phone);
  const answer = await app.inject({
    method: 'POST',
    url: `/v1/${party}/auth/sign-in`,
    payload: { phone, deviceId, code },
  });
  expect(answer.statusCode).toBe(200);
  if (party === 'customer') {
    await app.inject({
      method: 'POST',
      url: `/v1/${party}/terms/accept`,
      headers: { authorization: `Bearer ${answer.json().accessToken}` },
      payload: { version: 1 },
    });
  }
  return { authorization: `Bearer ${answer.json().accessToken}` };
}

async function operations(role = 'OPS') {
  const { rows } = await sql.query(
    `INSERT INTO identity.admin_accounts (name, email, status, password_hash, totp_secret_encrypted)
     VALUES ('Late ops', $1, 'active', 'not used', 'not used') RETURNING id`,
    [`${randomUUID()}@example.test`],
  );
  await sql.query(
    'INSERT INTO identity.admin_account_roles (account_id, role_code) VALUES ($1, $2)',
    [rows[0].id, role],
  );
  const { token } = await app
    .get(AdminSessionsService)
    .start(db.db, rows[0].id, { ipAddress: '203.0.113.9', device: 'test' }, new Date());
  const cookies = { [ADMIN_SESSION_COOKIE]: token };
  return {
    post: (path: string, payload: object) =>
      app.inject({
        method: 'POST',
        url: path,
        cookies,
        headers: { 'idempotency-key': randomUUID() },
        payload,
      }),
    get: (path: string) => app.inject({ method: 'GET', url: path, cookies }),
  };
}

const lines = () => [
  { itemId: item, optionIds: [], quantity: 2, note: null, knownUnitPrice: '12000' },
];

// A placed order the restaurant accepted, with its customer.
async function acceptedOrder() {
  const customer = await appSignIn('customer', phoneNumber());
  const quote = await app.inject({
    method: 'POST',
    url: '/v1/customer/quote',
    headers: customer,
    payload: {
      restaurantId: restaurant,
      location: home,
      lines: lines(),
      payIn: null,
      appVersion: '1.0.0',
    },
  });
  const placed = await app.inject({
    method: 'POST',
    url: '/v1/customer/orders',
    headers: { ...customer, 'idempotency-key': randomUUID() },
    payload: {
      restaurantId: restaurant,
      lines: lines(),
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
  expect(placed.statusCode, placed.body).toBe(201);
  const id: string = placed.json().order.id;
  const phone = phoneNumber();
  await app
    .get(MerchantAccountsService)
    .addAccount(restaurant, { role: 'cashier', name: 'cashier', phone }, change);
  const cashier = await appSignIn('merchant', phone);
  await app.inject({
    method: 'PUT',
    url: '/v1/merchant/auth/device',
    headers: cashier,
    payload: { name: 'كاشير', platform: 'android', appVersion: '1.0.0' },
  });
  const accepted = await app.inject({
    method: 'POST',
    url: `/v1/merchant/orders/${id}/accept`,
    headers: { ...cashier, 'idempotency-key': randomUUID() },
    payload: { prepMin: 20 },
  });
  expect(accepted.statusCode).toBe(200);
  const { rows } = await sql.query(
    'SELECT customer_account_id, promised_at FROM ordering.orders WHERE id = $1',
    [id],
  );
  return {
    id,
    customer,
    accountId: rows[0].customer_account_id as string,
    promisedAt: rows[0].promised_at as Date,
  };
}

// The order's late-code jobs, oldest first.
async function jobs(orderId: string) {
  const { rows } = await sql.query(
    "SELECT data, start_after FROM pgboss.job WHERE name = 'ordering-late-code' AND data->>'orderId' = $1 ORDER BY created_on",
    [orderId],
  );
  return rows as { data: LateCodeJob; start_after: Date }[];
}

async function lateCodes(orderId: string) {
  return (
    await sql.query(
      `SELECT c.code, c.kind, c.amount, c.percent_bp, c.max_discount, c.currency, c.visibility,
              c.customer_account_id, c.created_by, c.funding, c.total_limit, l.promised_at
         FROM marketing.late_codes l JOIN marketing.promo_codes c ON c.id = l.code_id
        WHERE l.order_id = $1`,
      [orderId],
    )
  ).rows;
}

async function pushes(accountId: string) {
  return (
    await sql.query(
      "SELECT body, data FROM notifications.push_messages WHERE account_id = $1 AND template_key = 'customer.late_code'",
      [accountId],
    )
  ).rows;
}

const setValue = (value: object) =>
  settings.update('order.late_compensation_value', { cityId: azaz }, value as never, bySystem);

describe('the late code', () => {
  it('issues nothing while order.late_compensation_value is unset', async () => {
    // «Before launch» (AP §13): no value until the owner enters one.
    const order = await acceptedOrder();
    const [job] = await jobs(order.id);
    expect(
      await app
        .get(OrderTimers)
        .lateCode(job!.data, new Date(order.promisedAt.getTime() + 45 * MINUTE_MS)),
    ).toBe('unset');
    expect(await lateCodes(order.id)).toEqual([]);
    expect(await pushes(order.accountId)).toEqual([]);
  });

  it('issues one code to an order still not delivered 45 minutes past its promised time', async () => {
    await setValue({ kind: 'amount', amountMinor: 2_500, currency: 'TRY' });
    const order = await acceptedOrder();
    const [job] = await jobs(order.id);
    expect(job!.data.promisedAt).toBe(order.promisedAt.toISOString());
    expect(job!.start_after).toEqual(new Date(order.promisedAt.getTime() + 45 * MINUTE_MS));

    const timers = app.get(OrderTimers);
    const at = new Date(order.promisedAt.getTime() + 45 * MINUTE_MS);
    const issued = await timers.lateCode(job!.data, at);
    expect(issued).toMatchObject({ kind: 'fixed_amount', amount: 2_500n, currency: 'TRY' });
    const [code] = await lateCodes(order.id);
    expect(code).toMatchObject({
      kind: 'fixed_amount',
      amount: '2500',
      visibility: 'personal',
      customer_account_id: order.accountId,
      created_by: null,
      funding: 'platform',
      total_limit: 1,
    });
    expect(code.code).toMatch(/^[A-Z2-9]{8}$/);
    expect(await pushes(order.accountId)).toEqual([
      {
        body: `تأخر طلبك، وهذا كود خصم لطلبك القادم: ${code.code}`,
        data: { target: 'order', orderId: order.id },
      },
    ]);
    // Once per order: a repeated job issues nothing more.
    expect(await timers.lateCode(job!.data, at)).toBe('already_issued');
    expect(await lateCodes(order.id)).toHaveLength(1);

    // CU §11.6: the customer's order shows it.
    const read = await app.inject({
      method: 'GET',
      url: `/v1/customer/orders/${order.id}`,
      headers: order.customer,
    });
    expect(read.json().order.lateCode).toMatchObject({
      code: code.code,
      kind: 'fixed_amount',
      amount: { amount: '2500', currency: 'TRY' },
      maxDiscount: null,
      issuedAt: at.toISOString(),
    });

    // AP §6.4: outside the cumulative total; the order's compensations list
    // none, and SUP's whole cap (30% of the total) is left.
    const [{ total }] = (
      await sql.query('SELECT total FROM ordering.orders WHERE id = $1', [order.id])
    ).rows;
    const sup = await operations('SUP');
    const compensations = await sup.get(`/v1/admin/orders/${order.id}/compensations`);
    expect(compensations.json()).toMatchObject({
      compensations: [],
      capLeft: ((BigInt(total) * 30n) / 100n).toString(),
    });
  });

  it('issues a percentage without a maximum', async () => {
    await setValue({ kind: 'percent', percent: 15 });
    const order = await acceptedOrder();
    const [job] = await jobs(order.id);
    await app
      .get(OrderTimers)
      .lateCode(job!.data, new Date(order.promisedAt.getTime() + 45 * MINUTE_MS));
    expect(await lateCodes(order.id)).toMatchObject([
      { kind: 'percentage', percent_bp: 1500, amount: null, max_discount: null },
    ]);
  });

  it('moves with «تعديل الوقت»: the job of the earlier time issues nothing', async () => {
    await setValue({ kind: 'amount', amountMinor: 2_500, currency: 'TRY' });
    const order = await acceptedOrder();
    const ops = await operations();
    const moved = await ops.post(`/v1/admin/orders/${order.id}/change-time`, {
      addMin: 10,
      reason: null,
    });
    expect(moved.statusCode).toBe(200);
    const [first, second] = await jobs(order.id);
    const newPromised = new Date(order.promisedAt.getTime() + 10 * MINUTE_MS);
    expect(second!.data.promisedAt).toBe(newPromised.toISOString());
    expect(second!.start_after).toEqual(new Date(newPromised.getTime() + 45 * MINUTE_MS));
    const timers = app.get(OrderTimers);
    expect(
      await timers.lateCode(first!.data, new Date(order.promisedAt.getTime() + 45 * MINUTE_MS)),
    ).toBe('not_late');
    expect(await lateCodes(order.id)).toEqual([]);
    await timers.lateCode(second!.data, new Date(newPromised.getTime() + 45 * MINUTE_MS));
    expect(await lateCodes(order.id)).toHaveLength(1);
  });

  it('gives an order that ended before the moment none', async () => {
    await setValue({ kind: 'amount', amountMinor: 2_500, currency: 'TRY' });
    const order = await acceptedOrder();
    const ops = await operations();
    const cancelled = await ops.post(`/v1/admin/orders/${order.id}/cancel`, {
      cancellation: 'emergency',
      responsible: 'platform',
      foodPrepared: false,
      compensateCaptain: false,
      cash: null,
      reason: 'اختبار',
    });
    expect(cancelled.statusCode).toBe(200);
    const [job] = await jobs(order.id);
    expect(
      await app
        .get(OrderTimers)
        .lateCode(job!.data, new Date(order.promisedAt.getTime() + 45 * MINUTE_MS)),
    ).toBe('not_late');
    expect(await lateCodes(order.id)).toEqual([]);
  });

  it('gives a test order none (decided by us: its code would cost real money)', async () => {
    await setValue({ kind: 'amount', amountMinor: 2_500, currency: 'TRY' });
    const order = await acceptedOrder();
    await sql.query('UPDATE ordering.orders SET test_order = true WHERE id = $1', [order.id]);
    const [job] = await jobs(order.id);
    expect(
      await app
        .get(OrderTimers)
        .lateCode(job!.data, new Date(order.promisedAt.getTime() + 45 * MINUTE_MS)),
    ).toBe('not_late');
    expect(await lateCodes(order.id)).toEqual([]);
  });

  it('issues nothing for an amount in another currency than the order', async () => {
    // The setting is saved in the city's base; an order placed in an earlier
    // base keeps its own currency.
    await setValue({ kind: 'amount', amountMinor: 2_500, currency: 'TRY' });
    const order = await acceptedOrder();
    await sql.query("UPDATE ordering.orders SET currency = 'USD' WHERE id = $1", [order.id]);
    const [job] = await jobs(order.id);
    expect(
      await app
        .get(OrderTimers)
        .lateCode(job!.data, new Date(order.promisedAt.getTime() + 45 * MINUTE_MS)),
    ).toBe('other_currency');
    expect(await lateCodes(order.id)).toEqual([]);
  });

  it('never lets the application role change or delete a late code', async () => {
    await expect(sql.query('UPDATE marketing.late_codes SET issued_at = now()')).rejects.toThrow(
      /permission denied/,
    );
    await expect(sql.query('DELETE FROM marketing.late_codes')).rejects.toThrow(
      /permission denied/,
    );
  });
});

// CU §11.6, §14 #14, docs/domain/03 (slice L.1b): an order still not
// delivered at the promised time + order.delivery_late_alert_min gets one
// apology, a push and a banner; the timer moves with the promised time.
describe('the late apology', () => {
  const APOLOGY = 'نعتذر، طلبك متأخر قليلاً. نتابعه الآن';

  async function apologyJobs(orderId: string) {
    const { rows } = await sql.query(
      "SELECT data, start_after FROM pgboss.job WHERE name = 'ordering-late-apology' AND data->>'orderId' = $1 ORDER BY created_on",
      [orderId],
    );
    return rows as { data: LateCodeJob; start_after: Date }[];
  }

  async function apologies(accountId: string) {
    return (
      await sql.query(
        "SELECT body, data FROM notifications.push_messages WHERE account_id = $1 AND template_key = 'customer.late_apology'",
        [accountId],
      )
    ).rows;
  }

  async function lateApologyAt(order: Awaited<ReturnType<typeof acceptedOrder>>) {
    const read = await app.inject({
      method: 'GET',
      url: `/v1/customer/orders/${order.id}`,
      headers: order.customer,
    });
    expect(read.statusCode).toBe(200);
    return read.json().order.lateApologyAt;
  }

  it('pushes one apology to an order still not delivered 20 minutes past its promised time', async () => {
    const order = await acceptedOrder();
    const at = new Date(order.promisedAt.getTime() + 20 * MINUTE_MS);
    const [job] = await apologyJobs(order.id);
    expect(job!.data.promisedAt).toBe(order.promisedAt.toISOString());
    expect(job!.start_after).toEqual(at);
    // The banner's moment is on the order from the acceptance.
    expect(await lateApologyAt(order)).toBe(at.toISOString());

    const timers = app.get(OrderTimers);
    expect(await timers.lateApology(job!.data, at)).toBe(true);
    // Once per order: a repeated job pushes nothing more.
    expect(await timers.lateApology(job!.data, at)).toBe(true);
    expect(await apologies(order.accountId)).toEqual([
      { body: APOLOGY, data: { target: 'order', orderId: order.id } },
    ]);
  });

  it('moves with «تعديل الوقت»: the job of the earlier time pushes nothing', async () => {
    const order = await acceptedOrder();
    const ops = await operations();
    const moved = await ops.post(`/v1/admin/orders/${order.id}/change-time`, {
      addMin: 10,
      reason: null,
    });
    expect(moved.statusCode).toBe(200);
    const [first, second] = await apologyJobs(order.id);
    const newPromised = new Date(order.promisedAt.getTime() + 10 * MINUTE_MS);
    const newAt = new Date(newPromised.getTime() + 20 * MINUTE_MS);
    expect(second!.start_after).toEqual(newAt);
    expect(await lateApologyAt(order)).toBe(newAt.toISOString());
    const timers = app.get(OrderTimers);
    expect(
      await timers.lateApology(first!.data, new Date(order.promisedAt.getTime() + 20 * MINUTE_MS)),
    ).toBe(false);
    expect(await apologies(order.accountId)).toEqual([]);
    expect(await timers.lateApology(second!.data, newAt)).toBe(true);
    expect(await apologies(order.accountId)).toHaveLength(1);
  });

  it('gives an order that ended before the moment none, and no banner', async () => {
    const order = await acceptedOrder();
    const ops = await operations();
    const cancelled = await ops.post(`/v1/admin/orders/${order.id}/cancel`, {
      cancellation: 'emergency',
      responsible: 'platform',
      foodPrepared: false,
      compensateCaptain: false,
      cash: null,
      reason: 'اختبار',
    });
    expect(cancelled.statusCode).toBe(200);
    const [job] = await apologyJobs(order.id);
    expect(
      await app
        .get(OrderTimers)
        .lateApology(job!.data, new Date(order.promisedAt.getTime() + 20 * MINUTE_MS)),
    ).toBe(false);
    expect(await apologies(order.accountId)).toEqual([]);
    expect(await lateApologyAt(order)).toBeNull();
  });
});
