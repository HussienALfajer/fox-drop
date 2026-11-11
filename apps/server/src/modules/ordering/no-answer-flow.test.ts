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
import { DATABASE } from '../../database/database.module.js';
import { Jobs } from '../../jobs/jobs.module.js';
import { AlertsService } from '../notifications/index.js';
import { SettingsService } from '../settings/index.js';
import { OrderAlerts } from './order-alerts.js';

// CA §9.9, CU §11.7, AP §9.1.3 (slice 2.13d; owner decisions 2026-11-11):
// the captain at the door pings the customer up to customer.no_answer_pings
// times, customer.no_answer_ping_interval_min apart; the customer answers
// «أنا قادم» (or «سأتصل بالمستلم»); after every ping and pings × interval
// since the arrival, «الزبون لا يستجيب» raises «زبون لا يرد» until
// operations answer «انتظر» with a message.

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
      nameAr: 'مطعم الإلغاء',
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
    [`Canceller ${accounts}`, `canceller${accounts}@example.test`],
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
    cookies,
    assign: (orderId: string, captainId: string) =>
      post(`/v1/admin/orders/${orderId}/assign`, { captainId }),
    cancel: (orderId: string, body: object, key?: string) =>
      post(`/v1/admin/orders/${orderId}/cancel`, body, key),
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
    reassign: (orderId: string, body: object, key?: string) =>
      post(`/v1/admin/orders/${orderId}/reassign`, body, key),
    forceOffline: (captainId: string, reason: string) =>
      app.inject({
        method: 'POST',
        url: `/v1/admin/captains/${captainId}/force-offline`,
        cookies,
        payload: { reason },
      }),
    reassignPreview: (orderId: string, body: object) =>
      app.inject({
        method: 'POST',
        url: `/v1/admin/orders/${orderId}/reassign-preview`,
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
      name: 'كابتن الإلغاء',
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
    acknowledge: (orderId: string, key: string = randomUUID()) =>
      app.inject({
        method: 'POST',
        url: `/v1/captain/orders/${orderId}/acknowledge-cancellation`,
        headers: { ...headers, 'idempotency-key': key },
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

const events = async (orderId: string) =>
  (
    await sql.query(
      'SELECT type, actor_type, reason FROM ordering.order_events WHERE order_id = $1 ORDER BY version',
      [orderId],
    )
  ).rows;

const captainPost = (
  captain: { headers: Record<string, string> },
  orderId: string,
  path: string,
  payload: object,
  key: string = randomUUID(),
) =>
  app.inject({
    method: 'POST',
    url: `/v1/captain/orders/${orderId}/${path}`,
    headers: { ...captain.headers, 'idempotency-key': key },
    payload,
  });

const syncAlerts = async (order: { id: string }) => {
  const { rows } = await sql.query('SELECT placed_at FROM ordering.orders WHERE id = $1', [
    order.id,
  ]);
  await new OrderAlerts(
    app.get(DATABASE),
    app.get(Jobs),
    app.get(AlertsService),
    app.get(CaptainsService),
    app.get(SettingsService),
  ).sync({ orderId: order.id, placedAt: rows[0].placed_at.toISOString() }, new Date(), false);
};

const MINUTE = 60_000;
const atHome = () => ({
  ...home,
  accuracyMetres: 10,
  recordedAt: new Date().toISOString(),
  simulated: false,
});

// An order the captain picked up and brought to the customer's door.
async function atTheDoor() {
  const { order, captain, ops } = await captainAtRestaurant();
  expect((await captain.requestPickup(order.id)).statusCode).toBe(200);
  const confirmed = await app.inject({
    method: 'POST',
    url: `/v1/merchant/orders/${order.id}/pickup/confirm`,
    headers: { ...order.cashier, 'idempotency-key': randomUUID() },
  });
  expect(confirmed.statusCode).toBe(200);
  const now = new Date();
  await app
    .get(CaptainsService)
    .recordLocations(
      captain.captainId,
      [{ ...home, accuracyMetres: 8, recordedAt: now, simulated: false }],
      new Date(now.getTime() + 1),
    );
  const arrived = await captainPost(captain, order.id, 'arrive-at-customer', {
    location: atHome(),
    away: null,
  });
  expect(arrived.statusCode).toBe(200);
  return { order, captain, ops };
}

const ping = (captain: { headers: Record<string, string> }, orderId: string, key?: string) =>
  captainPost(captain, orderId, 'ping-customer', { location: atHome() }, key);
const report = (captain: { headers: Record<string, string> }, orderId: string) =>
  captainPost(captain, orderId, 'customer-not-answering', { location: atHome() });
const answer = (customer: Record<string, string>, orderId: string, key: string = randomUUID()) =>
  app.inject({
    method: 'POST',
    url: `/v1/customer/orders/${orderId}/answer-ping`,
    headers: { ...customer, 'idempotency-key': key },
  });
const wait = (ops: { cookies: Record<string, string> }, orderId: string, message: string) =>
  app.inject({
    method: 'POST',
    url: `/v1/admin/orders/${orderId}/no-answer/wait`,
    cookies: ops.cookies,
    headers: { 'idempotency-key': randomUUID() },
    payload: { message },
  });

// Moves the arrival back, as if the captain had waited at the door.
async function waitedAtDoor(orderId: string, minutes: number) {
  await sql.query(
    `UPDATE ordering.orders SET arrived_at_customer_at = arrived_at_customer_at - $2::interval
      WHERE id = $1`,
    [orderId, `${minutes} minutes`],
  );
}

async function earlierPings(orderId: string, captainId: string, minutesAgo: number[]) {
  const { rows } = await sql.query('SELECT placed_at FROM ordering.orders WHERE id = $1', [
    orderId,
  ]);
  for (const minutes of minutesAgo) {
    await sql.query(
      `INSERT INTO ordering.door_pings (order_id, order_placed_at, captain_id, sent_at)
       VALUES ($1, $2, $3, now() - $4::interval)`,
      [orderId, rows[0].placed_at, captainId, `${minutes} minutes`],
    );
  }
}

const openAlerts = async (orderId: string) =>
  (
    await sql.query(
      `SELECT code FROM notifications.alerts WHERE subject_id = $1 AND resolved_at IS NULL
        ORDER BY code`,
      [orderId],
    )
  ).rows.map((row) => row.code);

const customerOrder = async (customer: Record<string, string>, orderId: string) =>
  (
    await app.inject({ method: 'GET', url: `/v1/customer/orders/${orderId}`, headers: customer })
  ).json().order;

describe('«تنبيه الزبون» (CA §9.9, CU §11.7)', () => {
  it('rings the customer, spaces the pings and carries «أنا قادم» to the captain', async () => {
    const { order, captain } = await atTheDoor();
    const before = (await captain.active()).json().order.noAnswer;
    expect(before).toMatchObject({ pingsLeft: 3, answer: null, reportableAt: null, report: null });

    const sent = await ping(captain, order.id);
    expect(sent.statusCode).toBe(200);
    const door = sent.json().order.noAnswer;
    expect(door.pingsLeft).toBe(2);
    const gap = new Date(door.nextPingAt).getTime() - Date.now();
    expect(gap).toBeGreaterThan(4 * MINUTE);
    expect(gap).toBeLessThanOrEqual(5 * MINUTE);

    // A second ping before the interval is refused with the door's state.
    const early = await ping(captain, order.id);
    expect(early.statusCode).toBe(409);
    expect(early.json()).toMatchObject({ error: 'order_state_changed' });
    expect(early.json().order.noAnswer.pingsLeft).toBe(2);

    const seen = await customerOrder(order.customer, order.id);
    expect(seen.doorPing).toEqual({ at: expect.any(String), answer: null, answeredAt: null });
    // «اتصال بالكابتن» of the ring (CU §11.3, §11.7).
    expect(seen.captain.phone).toMatch(/^\+963/);

    const key = randomUUID();
    const answered = await answer(order.customer, order.id, key);
    expect(answered.statusCode).toBe(200);
    expect(answered.json().order.doorPing.answer).toBe('coming');
    // The same key replays; another device's answer finds none waiting.
    expect((await answer(order.customer, order.id, key)).statusCode).toBe(200);
    expect((await answer(order.customer, order.id)).statusCode).toBe(409);

    const after = (await captain.active()).json().order.noAnswer;
    expect(after.answer).toEqual({ answer: 'coming', at: expect.any(String) });
    expect((await events(order.id)).slice(-2)).toEqual([
      { type: 'order.customer_pinged', actor_type: 'captain', reason: null },
      { type: 'order.ping_answered', actor_type: 'customer', reason: 'coming' },
    ]);
  });

  it('answers «سأتصل بالمستلم» for an order with a recipient', async () => {
    const { order, captain } = await atTheDoor();
    await sql.query("UPDATE ordering.orders SET recipient_name = 'أحمد' WHERE id = $1", [order.id]);
    expect((await ping(captain, order.id)).statusCode).toBe(200);
    const answered = await answer(order.customer, order.id);
    expect(answered.json().order.doorPing.answer).toBe('contacting_recipient');
    expect((await captain.active()).json().order.noAnswer.answer.answer).toBe(
      'contacting_recipient',
    );
  });

  it('refuses a ping before the arrival and an answer without a ping', async () => {
    const { order, captain } = await captainAtRestaurant();
    expect((await ping(captain, order.id)).statusCode).toBe(409);
    expect((await answer(order.customer, order.id)).statusCode).toBe(409);
    expect((await captain.active()).json().order.noAnswer).toBeNull();
  });

  it('allows no fourth ping', async () => {
    const { order, captain } = await atTheDoor();
    await waitedAtDoor(order.id, 20);
    await earlierPings(order.id, captain.captainId, [18, 12, 6]);
    const door = (await captain.active()).json().order.noAnswer;
    expect(door).toMatchObject({ pingsLeft: 0, nextPingAt: null });
    expect((await ping(captain, order.id)).statusCode).toBe(409);
  });
});

describe('«الزبون لا يستجيب» and «انتظر» (CA §9.9, AP §9.1.3)', () => {
  it('opens «زبون لا يرد» after three pings and 15 minutes, until operations answer «انتظر»', async () => {
    const { order, captain, ops } = await atTheDoor();
    // Three pings but under 15 minutes since the arrival: too early.
    await waitedAtDoor(order.id, 12);
    await earlierPings(order.id, captain.captainId, [11, 6, 1]);
    expect((await report(captain, order.id)).statusCode).toBe(409);

    await waitedAtDoor(order.id, 4);
    const reported = await report(captain, order.id);
    expect(reported.statusCode).toBe(200);
    expect(reported.json().order.noAnswer).toMatchObject({
      reportableAt: null,
      report: { at: expect.any(String), waitedAt: null, waitMessage: null },
    });
    expect((await report(captain, order.id)).statusCode).toBe(409);
    await syncAlerts(order);
    expect(await openAlerts(order.id)).toContain('customer_not_answering');
    expect((await ops.detail(order.id)).noAnswer).toMatchObject({
      waitAllowed: true,
      pings: [{}, {}, {}],
      reports: [{ captainId: captain.captainId, waitedAt: null }],
    });

    const waited = await wait(ops, order.id, 'الزبون في الطريق، انتظره 5 دقائق');
    expect(waited.statusCode).toBe(200);
    await syncAlerts(order);
    expect(await openAlerts(order.id)).not.toContain('customer_not_answering');
    const door = (await captain.active()).json().order.noAnswer;
    expect(door.report.waitMessage).toBe('الزبون في الطريق، انتظره 5 دقائق');
    const again = new Date(door.reportableAt).getTime() - new Date(door.report.waitedAt).getTime();
    expect(again).toBe(15 * MINUTE);
    expect((await events(order.id)).slice(-2)).toEqual([
      { type: 'order.customer_not_answering', actor_type: 'captain', reason: null },
      {
        type: 'order.no_answer_waited',
        actor_type: 'admin',
        reason: 'الزبون في الطريق، انتظره 5 دقائق',
      },
    ]);
    // Nothing waits now.
    expect((await wait(ops, order.id, 'مرة ثانية')).statusCode).toBe(409);
    expect((await ops.detail(order.id)).noAnswer.waitAllowed).toBe(false);
  });

  it('closes «زبون لا يرد» once the order leaves the door', async () => {
    const { order, captain } = await atTheDoor();
    await waitedAtDoor(order.id, 16);
    await earlierPings(order.id, captain.captainId, [15, 10, 5]);
    expect((await report(captain, order.id)).statusCode).toBe(200);
    await syncAlerts(order);
    expect(await openAlerts(order.id)).toContain('customer_not_answering');
    const delivered = await captainPost(captain, order.id, 'deliver', {
      received: [{ currency: 'TRY', amount: '28000' }],
      change: [],
      amountDue: { amount: '28000', currency: 'TRY' },
      shortfall: null,
      away: null,
      location: atHome(),
    });
    expect(delivered.statusCode).toBe(200);
    await syncAlerts(order);
    expect(await openAlerts(order.id)).not.toContain('customer_not_answering');
  });

  it('lets the application role change only the answer and the wait', async () => {
    const { order, captain } = await atTheDoor();
    expect((await ping(captain, order.id)).statusCode).toBe(200);
    await expect(
      sql.query('UPDATE ordering.door_pings SET sent_at = now() WHERE order_id = $1', [order.id]),
    ).rejects.toThrow(/permission denied/);
    await expect(
      sql.query('UPDATE ordering.no_answer_reports SET reported_at = now() WHERE order_id = $1', [
        order.id,
      ]),
    ).rejects.toThrow(/permission denied/);
  });
});
