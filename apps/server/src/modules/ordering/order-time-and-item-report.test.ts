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
  CaptainAccountsService,
  CODE_SENDER,
  type DevelopmentCodeSender,
  MerchantAccountsService,
} from '../identity/index.js';
import { MerchantsService } from '../merchants/index.js';
import { SettingsService } from '../settings/index.js';

// AP §9.3.2 «تعديل الوقت» and «إغلاق بلاغ صنف نفد», RA §8.12, §8.10, CU §11.6,
// CA §9, docs/domain/03 (slice 2.9): operations move an order's times, and the
// restaurant reports an item unavailable after acceptance, which blocks the
// pickup until it is withdrawn, closed or the order cancelled.

vi.setConfig({ testTimeout: 30_000 });

let database: TestDatabase;
let cache: TestValkey;
let app: NestFastifyApplication;
let sql: pg.Pool;
let db: Database;
let azaz: string;
let restaurant: string;
let item: string;

const system = { type: 'system', id: null, role: null } as const;
const change = { actor: system, context: { ipAddress: null, device: null }, reason: 'test' };
const bySystem = { editor: 'system', context: change.context, reason: 'test' } as const;
const centre = { latitude: 36.587, longitude: 37.046 };
const home = { latitude: 36.59, longitude: 37.046 };
const captainSpot = { latitude: 36.597, longitude: 37.046 };
const atDoor = { latitude: 36.5875, longitude: 37.046 };
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
  await settings.update(
    'dispatch.manual_assign_requires_accept',
    { cityId: azaz },
    false,
    bySystem,
  );
  await settings.update('customer.late_cancel_strikes', { cityId: azaz }, 2, bySystem);
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
      nameAr: 'مطعم البلاغ',
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

async function appSignIn(party: 'customer' | 'merchant' | 'captain', phone: string) {
  const deviceId = randomUUID();
  await app.inject({ method: 'POST', url: `/v1/${party}/auth/code`, payload: { phone, deviceId } });
  const code = app.get<DevelopmentCodeSender>(CODE_SENDER).lastCode(phone);
  const answer = await app.inject({
    method: 'POST',
    url: `/v1/${party}/auth/sign-in`,
    payload: { phone, deviceId, code },
  });
  expect(answer.statusCode).toBe(200);
  if (party !== 'merchant') {
    await app.inject({
      method: 'POST',
      url: `/v1/${party}/terms/accept`,
      headers: { authorization: `Bearer ${answer.json().accessToken}` },
      payload: { version: 1 },
    });
  }
  return { authorization: `Bearer ${answer.json().accessToken}` };
}

let accounts = 0;
async function admin(roles: string[]) {
  accounts += 1;
  const { rows } = await sql.query(
    `INSERT INTO identity.admin_accounts (name, email, status, password_hash, totp_secret_encrypted)
     VALUES ($1, $2, 'active', 'not used', 'not used') RETURNING id`,
    [`Operator ${accounts}`, `operator${accounts}@example.test`],
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
  const post = (url: string, payload: object, key: string = randomUUID()) =>
    app.inject({ method: 'POST', url, cookies, headers: { 'idempotency-key': key }, payload });
  return {
    accountId,
    assign: (orderId: string, captainId: string) =>
      post(`/v1/admin/orders/${orderId}/assign`, { captainId }),
    cancel: (orderId: string, body: object, key?: string) =>
      post(`/v1/admin/orders/${orderId}/cancel`, body, key),
    changeTime: (orderId: string, body: object, key?: string) =>
      post(`/v1/admin/orders/${orderId}/change-time`, body, key),
    detail: async (orderId: string) =>
      (await app.inject({ method: 'GET', url: `/v1/admin/orders/${orderId}`, cookies })).json()
        .order,
    preview: (orderId: string, body: object) =>
      app.inject({
        method: 'POST',
        url: `/v1/admin/orders/${orderId}/cancel-preview`,
        cookies,
        payload: body,
      }),
  };
}

function cartLines() {
  return [{ itemId: item, optionIds: [], quantity: 2, note: null, knownUnitPrice: '12000' }];
}

const quoteFor = (customer: Record<string, string>) =>
  app.inject({
    method: 'POST',
    url: '/v1/customer/quote',
    headers: customer,
    payload: {
      restaurantId: restaurant,
      location: home,
      lines: cartLines(),
      payIn: null,
      appVersion: '1.0.0',
    },
  });

async function place(customer: Record<string, string>) {
  const quote = await quoteFor(customer);
  return app.inject({
    method: 'POST',
    url: '/v1/customer/orders',
    headers: { ...customer, 'idempotency-key': randomUUID() },
    payload: {
      restaurantId: restaurant,
      lines: cartLines(),
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
}

async function cashier(restaurantId: string = restaurant) {
  const phone = phoneNumber();
  await app
    .get(MerchantAccountsService)
    .addAccount(restaurantId, { role: 'cashier', name: 'cashier', phone }, change);
  const headers = await appSignIn('merchant', phone);
  await app.inject({
    method: 'PUT',
    url: '/v1/merchant/auth/device',
    headers,
    payload: { name: 'كاشير', platform: 'android', appVersion: '1.0.0' },
  });
  return headers;
}

// A placed order, and its customer.
async function placedOrder(customer?: Record<string, string>) {
  const headers = customer ?? (await appSignIn('customer', phoneNumber()));
  const placed = await place(headers);
  expect(placed.statusCode).toBe(201);
  return { id: placed.json().order.id as string, customer: headers };
}

// A placed order the restaurant accepted, with the cashier who accepted it.
async function acceptedOrder(customer?: Record<string, string>) {
  const order = await placedOrder(customer);
  const restaurantUser = await cashier();
  const accepted = await app.inject({
    method: 'POST',
    url: `/v1/merchant/orders/${order.id}/accept`,
    headers: { ...restaurantUser, 'idempotency-key': randomUUID() },
    payload: { prepMin: 20 },
  });
  expect(accepted.statusCode).toBe(200);
  return { ...order, cashier: restaurantUser };
}

async function onlineCaptain(point: Point = captainSpot) {
  const captains = app.get(CaptainsService);
  const captainId = await captains.createCaptain(
    azaz,
    {
      name: 'كابتن البلاغ',
      vehicle: 'motorbike',
      plateNumber: randomUUID().slice(0, 6),
      custodyLimit: { amount: 300_000n, currency: 'TRY' },
    },
    change,
  );
  const phone = phoneNumber();
  await app.get(CaptainAccountsService).addAccount(captainId, phone, change);
  const headers = await appSignIn('captain', phone);
  const now = new Date();
  await captains.goOnline(
    captainId,
    { appVersion: '1.0.0', simulatedLocation: false, termsPending: false },
    now,
  );
  await captains.recordLocations(
    captainId,
    [{ ...point, accuracyMetres: 8, recordedAt: now, simulated: false }],
    new Date(now.getTime() + 1),
  );
  const fix = () => ({
    ...atDoor,
    accuracyMetres: 10,
    recordedAt: new Date().toISOString(),
    simulated: false,
  });
  const command = (orderId: string, path: string, payload: object) =>
    app.inject({
      method: 'POST',
      url: `/v1/captain/orders/${orderId}/${path}`,
      headers: { ...headers, 'idempotency-key': randomUUID() },
      payload,
    });
  return {
    captainId,
    headers,
    arrive: (orderId: string) => command(orderId, 'arrive', { location: fix() }),
    requestPickup: (orderId: string, amount = '24000') =>
      command(orderId, 'pickup-request', {
        lines: [{ currency: 'TRY', amount }],
        location: fix(),
      }),
    active: () => app.inject({ method: 'GET', url: '/v1/captain/orders/active', headers }),
  };
}

// An accepted order whose captain is at the restaurant.
async function captainAtRestaurant() {
  const order = await acceptedOrder();
  const captain = await onlineCaptain();
  const ops = await admin(['OPS']);
  expect((await ops.assign(order.id, captain.captainId)).statusCode).toBe(200);
  expect((await captain.arrive(order.id)).statusCode).toBe(200);
  return { order, captain, ops };
}

const board = async (headers: Record<string, string>, orderId: string) =>
  (await app.inject({ method: 'GET', url: '/v1/merchant/orders', headers }))
    .json()
    .orders.find((entry: { id: string }) => entry.id === orderId);

const events = async (orderId: string) =>
  (
    await sql.query(
      'SELECT type, actor_type, reason FROM ordering.order_events WHERE order_id = $1 ORDER BY version',
      [orderId],
    )
  ).rows;

const outboxReason = async (orderId: string, type: string) =>
  (
    await sql.query(
      "SELECT payload->>'reason' AS reason FROM ordering.outbox WHERE order_id = $1 AND type = $2",
      [orderId, type],
    )
  ).rows[0]?.reason;

const times = async (orderId: string) =>
  (
    await sql.query(
      `SELECT status, promised_at, prep_min, prep_late_alert_at, search_start_at, search_started_at
         FROM ordering.orders WHERE id = $1`,
      [orderId],
    )
  ).rows[0];

const MINUTE = 60_000;
const moved = (after: Date, before: Date) => (after.getTime() - before.getTime()) / MINUTE;

const ready = (headers: Record<string, string>, orderId: string) =>
  app.inject({
    method: 'POST',
    url: `/v1/merchant/orders/${orderId}/ready`,
    headers: { ...headers, 'idempotency-key': randomUUID() },
  });

const customerOrder = async (headers: Record<string, string>, orderId: string) =>
  (await app.inject({ method: 'GET', url: `/v1/customer/orders/${orderId}`, headers })).json()
    .order;

describe('POST /v1/admin/orders/{orderId}/change-time (AP §9.3.2, docs/domain/03)', () => {
  it('moves the prep time, its alert, a search start still ahead and the promised time of an accepted order', async () => {
    // An online captain puts the search start after the acceptance.
    await onlineCaptain();
    const order = await acceptedOrder();
    const before = await times(order.id);
    expect(before.search_start_at.getTime()).toBeGreaterThan(Date.now());
    const ops = await admin(['OPS']);
    const answer = await ops.changeTime(order.id, { addMin: 10, reason: null });
    expect(answer.statusCode).toBe(200);
    expect(answer.json().order.id).toBe(order.id);
    const after = await times(order.id);
    expect(after.status).toBe('accepted');
    expect(after.prep_min).toBe(30);
    expect(moved(after.promised_at, before.promised_at)).toBe(10);
    expect(moved(after.prep_late_alert_at, before.prep_late_alert_at)).toBe(10);
    expect(moved(after.search_start_at, before.search_start_at)).toBe(10);
    // The search start's timer for its new moment.
    const { rows: jobs } = await sql.query(
      `SELECT start_after FROM pgboss.job
        WHERE name = 'ordering-search-start' AND data->>'orderId' = $1 ORDER BY start_after`,
      [order.id],
    );
    expect(jobs.at(-1).start_after.getTime()).toBe(after.search_start_at.getTime());
    // The restaurant's countdown and the customer's time follow.
    const card = await board(order.cashier, order.id);
    expect(new Date(card.acceptance.prepDueAt).getTime()).toBe(
      new Date(card.acceptance.at).getTime() + 30 * MINUTE,
    );
    const seen = await customerOrder(order.customer, order.id);
    expect(new Date(seen.promisedAt).getTime()).toBe(after.promised_at.getTime());
    expect((await events(order.id)).at(-1)).toEqual({
      type: 'order.time_changed',
      actor_type: 'admin',
      reason: null,
    });
    expect(await outboxReason(order.id, 'order.time_changed')).toBe('prep_time_changed');
    const { rows: audit } = await sql.query(
      `SELECT changes FROM audit.events WHERE action = 'order.change_time' AND target_id = $1`,
      [order.id],
    );
    expect(audit).toHaveLength(1);
    expect(audit[0].changes.prepMin).toEqual({ before: 20, after: 30 });
    expect(audit[0].changes.addMin).toEqual({ before: null, after: 10 });
  });

  it('moves only the promised time once the food is ready, rounded up to 5 minutes, with the note', async () => {
    const order = await acceptedOrder();
    expect((await ready(order.cashier, order.id)).statusCode).toBe(200);
    const before = await times(order.id);
    const ops = await admin(['OPS']);
    expect((await ops.changeTime(order.id, { addMin: 7, reason: 'زحمة سير' })).statusCode).toBe(
      200,
    );
    const after = await times(order.id);
    expect(after.prep_min).toBe(20);
    expect(after.prep_late_alert_at).toEqual(before.prep_late_alert_at);
    expect(after.search_start_at).toEqual(before.search_start_at);
    expect(moved(after.promised_at, before.promised_at)).toBe(10);
    expect((await events(order.id)).at(-1)).toEqual({
      type: 'order.time_changed',
      actor_type: 'admin',
      reason: 'زحمة سير',
    });
    expect(await outboxReason(order.id, 'order.time_changed')).toBe('promised_time_changed');
  });

  it('answers a repeat of the key once, and refuses minutes outside 1 to order.eta_change_max_min', async () => {
    const order = await acceptedOrder();
    const before = await times(order.id);
    const ops = await admin(['OPS']);
    const key = randomUUID();
    expect((await ops.changeTime(order.id, { addMin: 5, reason: null }, key)).statusCode).toBe(200);
    expect((await ops.changeTime(order.id, { addMin: 5, reason: null }, key)).statusCode).toBe(200);
    expect(moved((await times(order.id)).promised_at, before.promised_at)).toBe(5);
    for (const addMin of [0, 61, -5]) {
      const refused = await ops.changeTime(order.id, { addMin, reason: null });
      expect(refused.statusCode).toBe(400);
      expect(refused.json().error).toBe('invalid_time_change');
    }
  });

  it('refuses a placed order, and a role without operations.manage', async () => {
    const order = await placedOrder();
    const refused = await (await admin(['OPS'])).changeTime(order.id, { addMin: 5, reason: null });
    expect(refused.statusCode).toBe(409);
    expect(refused.json().error).toBe('order_state_changed');
    const accepted = await acceptedOrder();
    const fin = await (await admin(['FIN'])).changeTime(accepted.id, { addMin: 5, reason: null });
    expect(fin.statusCode).toBe(403);
  });
});
