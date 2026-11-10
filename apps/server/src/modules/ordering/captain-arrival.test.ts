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

// The captain's active order and their arrival at the restaurant (CA §9.1–9.3,
// §15, C6; RA §8.9; AP §9.3.2 «تسجيل وصول الكابتن», §9.1.3).

// Each test signs in the parties, places, accepts and assigns an order
// before its own steps: up to 3 s alone, so the default 5 s is too short for
// a full parallel run.
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
// About 330 m north of the restaurant, inside its 1 km.
const home = { latitude: 36.59, longitude: 37.046 };
// About 1.1 km north of the restaurant.
const captainSpot = { latitude: 36.597, longitude: 37.046 };
// About 55 m north of the restaurant, inside the 150 m.
const atDoor = { latitude: 36.5875, longitude: 37.046 };
const allWeek = [0, 1, 2, 3, 4, 5, 6].map((weekday) => ({ weekday, opensAt: 0, closesAt: 0 }));
const MINUTE = 60_000;

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
  // AP §9.12.5: a pay table in force, which placing needs (captain_pay_unset).
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
      nameAr: 'مطعم الوصول',
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
  // A customer orders (CU §4.7) and a captain goes online (K7) once the terms
  // in force (the seeded version 1) are accepted.
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
    get: (url: string) => app.inject({ method: 'GET', url, cookies }),
    assign: (orderId: string, captainId: string) =>
      post(`/v1/admin/orders/${orderId}/assign`, { captainId }),
    recordArrival: (orderId: string, reason: string, key?: string) =>
      post(`/v1/admin/orders/${orderId}/record-arrival`, { reason }, key),
  };
}

// A placed order the restaurant accepted, with the cashier who accepted it.
async function acceptedOrder() {
  const customer = await appSignIn('customer', phoneNumber());
  const lines = [
    { itemId: item, optionIds: [], quantity: 2, note: 'بدون بصل', knownUnitPrice: '12000' },
  ];
  const quote = await app.inject({
    method: 'POST',
    url: '/v1/customer/quote',
    payload: { restaurantId: restaurant, location: home, lines, payIn: null, appVersion: '1.0.0' },
  });
  const placed = await app.inject({
    method: 'POST',
    url: '/v1/customer/orders',
    headers: { ...customer, 'idempotency-key': randomUUID() },
    payload: {
      restaurantId: restaurant,
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
  expect(placed.statusCode).toBe(201);
  const order = placed.json().order;
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
    url: `/v1/merchant/orders/${order.id}/accept`,
    headers: { ...cashier, 'idempotency-key': randomUUID() },
    payload: { prepMin: 20 },
  });
  expect(accepted.statusCode).toBe(200);
  return { id: order.id as string, cashier, customer };
}

// An activated motorbike captain, signed in and online at the point.
async function onlineCaptain(point: Point = captainSpot) {
  const captains = app.get(CaptainsService);
  const captainId = await captains.createCaptain(
    azaz,
    {
      name: 'كابتن الوصول',
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
  const arrive = (
    orderId: string,
    where: Point = atDoor,
    { accuracyMetres = 10, simulated = false, key = randomUUID() } = {},
  ) =>
    app.inject({
      method: 'POST',
      url: `/v1/captain/orders/${orderId}/arrive`,
      headers: { ...headers, 'idempotency-key': key },
      payload: {
        location: { ...where, accuracyMetres, recordedAt: new Date().toISOString(), simulated },
      },
    });
  const active = () => app.inject({ method: 'GET', url: '/v1/captain/orders/active', headers });
  return { captainId, headers, arrive, active };
}

// An accepted order assigned directly to a new online captain.
async function assignedOrder() {
  const order = await acceptedOrder();
  const captain = await onlineCaptain();
  const ops = await admin(['OPS']);
  expect((await ops.assign(order.id, captain.captainId)).statusCode).toBe(200);
  return { order, captain, ops };
}

const orderRow = async (id: string) =>
  (
    await sql.query(
      'SELECT version, captain_track, arrived_at_merchant_at, captain_waiting_alert_at FROM ordering.orders WHERE id = $1',
      [id],
    )
  ).rows[0];

describe('GET /v1/captain/orders/active (CA §9.1–9.3)', () => {
  it('answers null without an order, then the assigned order with what steps 1 and 2 show', async () => {
    const captain = await onlineCaptain();
    expect((await captain.active()).json()).toEqual({
      order: null,
      cancelled: null,
      withdrawn: null,
      ended: null,
    });
    const order = await acceptedOrder();
    expect((await (await admin(['OPS'])).assign(order.id, captain.captainId)).statusCode).toBe(200);
    const answer = await captain.active();
    expect(answer.statusCode).toBe(200);
    expect(answer.json().order).toMatchObject({
      id: order.id,
      status: 'accepted',
      captainTrack: 'assigned',
      restaurant: { name: 'مطعم الوصول', address: 'شارع المطاعم', location: centre },
      preparation: { ready: false, readyAt: null },
      arrival: null,
      itemCount: 2,
      lines: [{ name: 'شاورما', quantity: 2, options: [], note: 'بدون بصل' }],
      pickupPayment: { amount: '24000', currency: 'TRY' },
      collect: { amount: '28000', currency: 'TRY' },
      // The seeded defaults of the settings catalogue (C6, K4).
      radii: { restaurantMetres: 150, customerMetres: 200 },
    });
  });
});

describe("the captain on the customer's order screen (CU §11.2–11.3)", () => {
  it('shows the first name and vehicle from assignment, and when the captain is at the restaurant', async () => {
    const order = await acceptedOrder();
    const read = async () =>
      (
        await app.inject({
          method: 'GET',
          url: `/v1/customer/orders/${order.id}`,
          headers: order.customer,
        })
      ).json().order;
    expect((await read()).captain).toBeNull();
    const captain = await onlineCaptain();
    expect((await (await admin(['OPS'])).assign(order.id, captain.captainId)).statusCode).toBe(200);
    const assigned = await read();
    expect(assigned.captain).toEqual({
      firstName: 'كابتن',
      vehicle: 'motorbike',
      atRestaurant: false,
    });
    // The captain track itself is never shown to the customer (CU §11.2).
    expect(assigned).not.toHaveProperty('captainTrack');
    expect((await captain.arrive(order.id)).statusCode).toBe(200);
    expect((await read()).captain).toMatchObject({ atRestaurant: true });
  });
});

describe('POST /v1/captain/orders/{orderId}/arrive (CA §9.2, C6)', () => {
  it('records the arrival within 150 m: at_merchant, the waiting moment and the fix', async () => {
    const { order, captain } = await assignedOrder();
    const before = await orderRow(order.id);
    const key = randomUUID();
    const started = Date.now();
    const answer = await captain.arrive(order.id, atDoor, { key });
    expect(answer.statusCode).toBe(200);
    expect(answer.json().order).toMatchObject({ captainTrack: 'at_merchant' });
    const arrivedAt = new Date(answer.json().order.arrival.at).getTime();
    expect(arrivedAt).toBeGreaterThanOrEqual(started);
    const row = await orderRow(order.id);
    expect(row.version).toBe(before.version + 1);
    // RA §8.9: captain.waiting_threshold_min (10) after the arrival.
    expect(new Date(row.captain_waiting_alert_at).getTime()).toBe(arrivedAt + 10 * MINUTE);
    const event = await sql.query(
      "SELECT actor_type, actor_id, actor_device, captain_id FROM ordering.order_events WHERE order_id = $1 AND type = 'order.captain_arrived'",
      [order.id],
    );
    expect(event.rows).toHaveLength(1);
    expect(event.rows[0]).toMatchObject({
      actor_type: 'captain',
      actor_id: captain.captainId,
      captain_id: captain.captainId,
    });
    expect(event.rows[0].actor_device).not.toBeNull();
    const outbox = await sql.query(
      "SELECT payload FROM ordering.outbox WHERE order_id = $1 AND type = 'order.captain_arrived'",
      [order.id],
    );
    expect(outbox.rows[0].payload).toMatchObject({
      captainTrack: 'at_merchant',
      captainId: captain.captainId,
    });
    // CA §15: the command's fix joins the route.
    const points = await sql.query(
      'SELECT accuracy_metres FROM captains.locations WHERE captain_id = $1 AND ST_Y(location) = $2',
      [captain.captainId, atDoor.latitude],
    );
    expect(points.rows).toHaveLength(1);

    // A repeat of the key answers the order; another key finds it arrived.
    const repeat = await captain.arrive(order.id, atDoor, { key });
    expect(repeat.statusCode).toBe(200);
    expect((await orderRow(order.id)).version).toBe(row.version);
    const again = await captain.arrive(order.id);
    expect(again.statusCode).toBe(409);
    expect(again.json()).toMatchObject({
      error: 'order_state_changed',
      order: { captainTrack: 'at_merchant' },
    });
  });

  it('refuses a fix beyond the radius, a weak one and a simulated one', async () => {
    const { order, captain } = await assignedOrder();
    const far = await captain.arrive(order.id, captainSpot);
    expect(far.statusCode).toBe(409);
    expect(far.json().error).toBe('too_far_from_restaurant');
    expect(far.json().distanceMetres).toBeGreaterThan(1000);
    const weak = await captain.arrive(order.id, atDoor, { accuracyMetres: 150 });
    expect(weak.statusCode).toBe(409);
    expect(weak.json()).toMatchObject({ error: 'weak_location', accuracyLimitMetres: 100 });
    const simulated = await captain.arrive(order.id, atDoor, { simulated: true });
    expect(simulated.statusCode).toBe(409);
    expect(simulated.json().error).toBe('simulated_location');
    expect((await orderRow(order.id)).captain_track).toBe('assigned');
  });

  it('refuses a fix older than a minute (C6: the latest fix)', async () => {
    const { order, captain } = await assignedOrder();
    const answer = await app.inject({
      method: 'POST',
      url: `/v1/captain/orders/${order.id}/arrive`,
      headers: { ...captain.headers, 'idempotency-key': randomUUID() },
      payload: {
        location: {
          ...atDoor,
          accuracyMetres: 10,
          recordedAt: new Date(Date.now() - 2 * MINUTE).toISOString(),
          simulated: false,
        },
      },
    });
    expect(answer.statusCode).toBe(409);
    expect(answer.json().error).toBe('stale_location');
  });

  it('records the arrival at a ready order, and refuses a reused key', async () => {
    const { order, captain } = await assignedOrder();
    const ready = await app.inject({
      method: 'POST',
      url: `/v1/merchant/orders/${order.id}/ready`,
      headers: { ...order.cashier, 'idempotency-key': randomUUID() },
    });
    expect(ready.statusCode).toBe(200);
    const key = randomUUID();
    const arrived = await captain.arrive(order.id, atDoor, { key });
    expect(arrived.statusCode).toBe(200);
    expect(arrived.json().order).toMatchObject({
      status: 'ready',
      captainTrack: 'at_merchant',
      preparation: { ready: true },
    });
    const other = await assignedOrder();
    expect((await other.captain.arrive(other.order.id, atDoor, { key })).statusCode).toBe(200);
    // The same key on another order is another command (architecture §5.3).
    expect((await captain.arrive(other.order.id, atDoor, { key })).statusCode).toBe(422);
  });

  it("answers 404 for another captain's order", async () => {
    const { order } = await assignedOrder();
    const other = await onlineCaptain();
    expect((await other.arrive(order.id)).statusCode).toBe(404);
  });
});

describe('the boards show the arrival and the waiting alert (RA §8.9, AP §9.1.3)', () => {
  it('gives the restaurant «وصل الكابتن» and operations «كابتن ينتظر عند المطعم» once passed', async () => {
    const { order, captain, ops } = await assignedOrder();
    expect((await captain.arrive(order.id)).statusCode).toBe(200);
    const board = await app.inject({
      method: 'GET',
      url: '/v1/merchant/orders',
      headers: order.cashier,
    });
    const card = board.json().orders.find((entry: { id: string }) => entry.id === order.id);
    const row = await orderRow(order.id);
    expect(card.captainArrival).toEqual({
      at: new Date(row.arrived_at_merchant_at).toISOString(),
      waitingAlertAt: new Date(row.captain_waiting_alert_at).toISOString(),
    });
    const opsCard = async () =>
      (await ops.get(`/v1/admin/orders?cityId=${azaz}`))
        .json()
        .orders.find((entry: { id: string }) => entry.id === order.id);
    expect((await opsCard()).alerts).not.toContain('captain_waiting');
    expect((await opsCard()).moments.captainArrivedAt).not.toBeNull();
    // Ten minutes later, not picked up.
    await sql.query(
      "UPDATE ordering.orders SET arrived_at_merchant_at = now() - interval '11 minutes', captain_waiting_alert_at = now() - interval '1 minute' WHERE id = $1",
      [order.id],
    );
    expect((await opsCard()).alerts).toContain('captain_waiting');
  });
});

describe('POST /v1/admin/orders/{orderId}/record-arrival (AP §9.3.2)', () => {
  it('records the arrival for a captain with a weak signal, with a reason, audited', async () => {
    const { order, captain, ops } = await assignedOrder();
    const answer = await ops.recordArrival(order.id, 'إشارة الموقع ضعيفة');
    expect(answer.statusCode).toBe(200);
    expect(answer.json().order).toMatchObject({ captainTrack: 'at_merchant' });
    expect(answer.json().order.moments.captainArrivedAt).not.toBeNull();
    const event = await sql.query(
      "SELECT actor_type, actor_id, reason FROM ordering.order_events WHERE order_id = $1 AND type = 'order.captain_arrived'",
      [order.id],
    );
    expect(event.rows).toEqual([
      { actor_type: 'admin', actor_id: ops.accountId, reason: 'إشارة الموقع ضعيفة' },
    ]);
    const audit = await sql.query(
      "SELECT actor_id, reason FROM audit.events WHERE action = 'order.record_arrival' AND target_id = $1",
      [order.id],
    );
    expect(audit.rows).toEqual([{ actor_id: ops.accountId, reason: 'إشارة الموقع ضعيفة' }]);
    expect((await captain.active()).json().order.captainTrack).toBe('at_merchant');
    // AP §10, RA §8.4: the note never leaves on the apps' channels.
    const outbox = await sql.query(
      "SELECT payload FROM ordering.outbox WHERE order_id = $1 AND type = 'order.captain_arrived'",
      [order.id],
    );
    expect(outbox.rows[0].payload.reason).toBeNull();
    const again = await ops.recordArrival(order.id, 'مرة ثانية');
    expect(again.statusCode).toBe(409);
    expect(again.json()).toMatchObject({
      error: 'order_state_changed',
      order: { captainTrack: 'at_merchant' },
    });
  });

  it('refuses an order without a captain, and needs a reason', async () => {
    const order = await acceptedOrder();
    const ops = await admin(['OPS']);
    const refused = await ops.recordArrival(order.id, 'لا كابتن');
    expect(refused.statusCode).toBe(409);
    expect(refused.json().error).toBe('order_state_changed');
    expect((await ops.recordArrival(order.id, ' ')).statusCode).toBe(400);
    expect((await ops.recordArrival(randomUUID(), 'لا طلب')).statusCode).toBe(404);
  });

  it('answers a repeat of the key with the order, and refuses it with another reason', async () => {
    const { order, ops } = await assignedOrder();
    const key = randomUUID();
    expect((await ops.recordArrival(order.id, 'إشارة ضعيفة', key)).statusCode).toBe(200);
    const version = (await orderRow(order.id)).version;
    const repeat = await ops.recordArrival(order.id, 'إشارة ضعيفة', key);
    expect(repeat.statusCode).toBe(200);
    expect(repeat.json().order.captainTrack).toBe('at_merchant');
    expect((await orderRow(order.id)).version).toBe(version);
    expect((await ops.recordArrival(order.id, 'سبب آخر', key)).statusCode).toBe(422);
  });

  it('lets one of a captain arrival and an operations arrival sent together through', async () => {
    const { order, captain, ops } = await assignedOrder();
    const answers = await Promise.all([
      captain.arrive(order.id),
      ops.recordArrival(order.id, 'إشارة ضعيفة'),
    ]);
    expect(answers.map((answer) => answer.statusCode).sort()).toEqual([200, 409]);
    const events = await sql.query(
      "SELECT count(*)::int AS n FROM ordering.order_events WHERE order_id = $1 AND type = 'order.captain_arrived'",
      [order.id],
    );
    expect(events.rows[0].n).toBe(1);
  });
});
