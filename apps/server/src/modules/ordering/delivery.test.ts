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

// The way to the customer and the arrival at the door (CA §9.5–9.6, K4;
// AP §9.1.3 «تسليم بعيد عن العنوان»).
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
      nameAr: 'مطعم الاستلام',
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
    cookies,
    get: (url: string) => app.inject({ method: 'GET', url, cookies }),
    assign: (orderId: string, captainId: string) =>
      post(`/v1/admin/orders/${orderId}/assign`, { captainId }),
    recordArrival: (orderId: string, reason: string, key?: string) =>
      post(`/v1/admin/orders/${orderId}/record-arrival`, { reason }, key),
    confirmPickup: (orderId: string, lines: object[], reason: string) =>
      post(`/v1/admin/orders/${orderId}/confirm-pickup`, { lines, reason }),
  };
}

// A placed order the restaurant accepted, with the cashier who accepted it.
async function acceptedOrder(
  recipient: { recipientName: string; contactPhone: string } | null = null,
) {
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
        contactPhone: recipient?.contactPhone ?? null,
        recipientName: recipient?.recipientName ?? null,
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
  return { id: order.id as string, cashier };
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
  await captains.goOnline(captainId, { appVersion: '1.0.0', simulatedLocation: false }, now);
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
async function assignedOrder(
  recipient: { recipientName: string; contactPhone: string } | null = null,
) {
  const order = await acceptedOrder(recipient);
  const captain = await onlineCaptain();
  const ops = await admin(['OPS']);
  expect((await ops.assign(order.id, captain.captainId)).statusCode).toBe(200);
  return { order, captain, ops };
}

const SECOND = 1000;
const TRY = (amount: string) => [{ currency: 'TRY', amount }];

// An order whose captain is at the restaurant.
async function captainAtRestaurant() {
  const assigned = await assignedOrder();
  expect((await assigned.captain.arrive(assigned.order.id)).statusCode).toBe(200);
  const requestPickup = (lines = TRY('24000'), key: string = randomUUID()) =>
    app.inject({
      method: 'POST',
      url: `/v1/captain/orders/${assigned.order.id}/pickup-request`,
      headers: { ...assigned.captain.headers, 'idempotency-key': key },
      payload: {
        lines,
        location: {
          ...atDoor,
          accuracyMetres: 10,
          recordedAt: new Date().toISOString(),
          simulated: false,
        },
      },
    });
  const restaurant = (path: string, payload?: object, key: string = randomUUID()) =>
    app.inject({
      method: 'POST',
      url: `/v1/merchant/orders/${assigned.order.id}/pickup/${path}`,
      headers: { ...assigned.order.cashier, 'idempotency-key': key },
      ...(payload ? { payload } : {}),
    });
  const boardOrder = async () =>
    (
      await app.inject({
        method: 'GET',
        url: '/v1/merchant/orders',
        headers: assigned.order.cashier,
      })
    )
      .json()
      .orders.find((entry: { id: string }) => entry.id === assigned.order.id);
  return { ...assigned, requestPickup, restaurant, boardOrder };
}

const eventTypes = async (orderId: string) =>
  (
    await sql.query(
      'SELECT type, reason FROM ordering.order_events WHERE order_id = $1 ORDER BY version',
      [orderId],
    )
  ).rows;

// About 55 m north of the customer's pin, inside the 200 m.
const atCustomer = { latitude: 36.5905, longitude: 37.046 };
// About 555 m north of the pin.
const farFromCustomer = { latitude: 36.595, longitude: 37.046 };

// An order the captain picked up, with the commands of the way to the
// customer.
async function pickedUpOrder() {
  const at = await captainAtRestaurant();
  expect((await at.requestPickup()).statusCode).toBe(200);
  expect((await at.restaurant('confirm')).statusCode).toBe(200);
  const arriveAtCustomer = (
    where: Point = atCustomer,
    {
      away = null,
      accuracyMetres = 10,
      simulated = false,
      recordedAt = new Date(),
      key = randomUUID(),
    }: {
      away?: object | null;
      accuracyMetres?: number;
      simulated?: boolean;
      recordedAt?: Date;
      key?: string;
    } = {},
  ) =>
    app.inject({
      method: 'POST',
      url: `/v1/captain/orders/${at.order.id}/arrive-at-customer`,
      headers: { ...at.captain.headers, 'idempotency-key': key },
      payload: {
        location: { ...where, accuracyMetres, recordedAt: recordedAt.toISOString(), simulated },
        away,
      },
    });
  return { ...at, arriveAtCustomer };
}

const arrivalRow = async (orderId: string) =>
  (
    await sql.query(
      'SELECT status, captain_track, arrived_at_customer_at, away_reason, away_note FROM ordering.orders WHERE id = $1',
      [orderId],
    )
  ).rows[0];

describe('the captain on the way to the customer (CA §9.5)', () => {
  it('shows the customer block from assignment, with the number to call', async () => {
    const assigned = await assignedOrder();
    const { order } = (await assigned.captain.active()).json();
    expect(order.customer).toMatchObject({
      name: null,
      location: home,
      address: {
        neighbourhood: 'المركز',
        street: 'شارع السوق',
        floor: null,
        landmark: 'قرب الجامع',
        directions: null,
      },
      payIn: null,
      collectEquivalents: [],
      arrival: null,
    });
    expect(order.customer.phone).toMatch(/^\+9639\d{8}$/);
    expect(new Date(order.customer.promisedAt).getTime()).toBeGreaterThan(Date.now());
  });

  it("gives the recipient's name and number for an order for someone else (CU Q5)", async () => {
    const contactPhone = phoneNumber();
    const assigned = await assignedOrder({ recipientName: 'أبو أحمد', contactPhone });
    const { order } = (await assigned.captain.active()).json();
    expect(order.customer).toMatchObject({ name: 'أبو أحمد', phone: contactPhone });
  });
});

describe('POST /v1/captain/orders/{orderId}/arrive-at-customer (CA §9.6, K4)', () => {
  it('sets arrived and at_customer within the radius, with no reason kept', async () => {
    const picked = await pickedUpOrder();
    const answer = await picked.arriveAtCustomer(atCustomer, {
      away: { reason: 'pin_inaccurate', note: null },
    });
    expect(answer.statusCode).toBe(200);
    const { order } = answer.json();
    expect(order.status).toBe('arrived');
    expect(order.captainTrack).toBe('at_customer');
    expect(order.customer.arrival).toMatchObject({ awayReason: null });
    expect(await arrivalRow(picked.order.id)).toMatchObject({
      status: 'arrived',
      captain_track: 'at_customer',
      away_reason: null,
      away_note: null,
    });
    expect((await eventTypes(picked.order.id)).at(-1)).toEqual({
      type: 'order.arrived_at_customer',
      reason: null,
    });
    // The customer sees the status, «الكابتن عند الباب».
    const outbox = await sql.query(
      "SELECT payload FROM ordering.outbox WHERE order_id = $1 AND type = 'order.arrived_at_customer'",
      [picked.order.id],
    );
    expect(outbox.rows[0].payload).toMatchObject({ status: 'arrived', reason: null });
  });

  it('refuses beyond the radius without a reason, with the distance', async () => {
    const picked = await pickedUpOrder();
    const answer = await picked.arriveAtCustomer(farFromCustomer);
    expect(answer.statusCode).toBe(409);
    expect(answer.json().error).toBe('too_far_from_customer');
    expect(answer.json().distanceMetres).toBeGreaterThan(500);
    expect((await arrivalRow(picked.order.id)).status).toBe('picked_up');
  });

  it('accepts beyond the radius with a reason, which operations see', async () => {
    const picked = await pickedUpOrder();
    const answer = await picked.arriveAtCustomer(farFromCustomer, {
      away: { reason: 'other', note: 'الزبون نزل إلى الشارع' },
    });
    expect(answer.statusCode).toBe(200);
    expect(answer.json().order.customer.arrival.awayReason).toBe('other');
    expect(await arrivalRow(picked.order.id)).toMatchObject({
      away_reason: 'other',
      away_note: 'الزبون نزل إلى الشارع',
    });
    expect((await eventTypes(picked.order.id)).at(-1)).toEqual({
      type: 'order.arrived_at_customer',
      reason: 'other',
    });
    const outbox = await sql.query(
      "SELECT payload FROM ordering.outbox WHERE order_id = $1 AND type = 'order.arrived_at_customer'",
      [picked.order.id],
    );
    expect(outbox.rows[0].payload.reason).toBeNull();
    const card = (await picked.ops.get(`/v1/admin/orders?cityId=${azaz}`))
      .json()
      .orders.find((entry: { id: string }) => entry.id === picked.order.id);
    expect(card.alerts).toContain('away_from_address');
    // AP §9.2.1: the time in «الكابتن وصل» counts from the arrival.
    expect(card.statusSince).toBe(answer.json().order.customer.arrival.at);
    const detail = (await picked.ops.get(`/v1/admin/orders/${picked.order.id}`)).json().order;
    expect(detail.customer.arrival.away).toEqual({
      reason: 'other',
      note: 'الزبون نزل إلى الشارع',
    });
  });

  it('refuses a note without «أخرى», and «أخرى» without a note', async () => {
    const picked = await pickedUpOrder();
    const noted = await picked.arriveAtCustomer(farFromCustomer, {
      away: { reason: 'pin_inaccurate', note: 'نص' },
    });
    expect(noted.statusCode).toBe(400);
    const bare = await picked.arriveAtCustomer(farFromCustomer, {
      away: { reason: 'other', note: null },
    });
    expect(bare.statusCode).toBe(400);
  });

  it('refuses a simulated, stale or weak fix', async () => {
    const picked = await pickedUpOrder();
    const simulated = await picked.arriveAtCustomer(atCustomer, { simulated: true });
    expect(simulated.json().error).toBe('simulated_location');
    const stale = await picked.arriveAtCustomer(atCustomer, {
      recordedAt: new Date(Date.now() - 2 * 60 * SECOND),
    });
    expect(stale.json().error).toBe('stale_location');
    const weak = await picked.arriveAtCustomer(atCustomer, { accuracyMetres: 150 });
    expect(weak.json().error).toBe('weak_location');
    expect((await arrivalRow(picked.order.id)).status).toBe('picked_up');
  });

  it('refuses before the pickup, and answers a repeat of the key with the order', async () => {
    const assigned = await assignedOrder();
    const early = await app.inject({
      method: 'POST',
      url: `/v1/captain/orders/${assigned.order.id}/arrive-at-customer`,
      headers: { ...assigned.captain.headers, 'idempotency-key': randomUUID() },
      payload: {
        location: {
          ...home,
          accuracyMetres: 10,
          recordedAt: new Date().toISOString(),
          simulated: false,
        },
        away: null,
      },
    });
    expect(early.statusCode).toBe(409);
    expect(early.json().error).toBe('order_state_changed');

    const picked = await pickedUpOrder();
    const key = randomUUID();
    expect((await picked.arriveAtCustomer(atCustomer, { key })).statusCode).toBe(200);
    const again = await picked.arriveAtCustomer(atCustomer, { key });
    expect(again.statusCode).toBe(200);
    expect(again.json().order.status).toBe('arrived');
    const events = await eventTypes(picked.order.id);
    expect(events.filter((event) => event.type === 'order.arrived_at_customer')).toHaveLength(1);
  });

  it('answers no number to a command replayed once the order ended (C10)', async () => {
    const picked = await pickedUpOrder();
    const key = randomUUID();
    const first = await picked.arriveAtCustomer(atCustomer, { key });
    expect(first.json().order.customer.phone).toMatch(/^\+9639\d{8}$/);
    // The order ends (its delivery comes with the next pull request).
    await sql.query(
      "UPDATE ordering.orders SET status = 'cancelled', cancelled_at = now(), cancel_reason = 'test', food_prepared = false WHERE id = $1",
      [picked.order.id],
    );
    const replayed = await picked.arriveAtCustomer(atCustomer, { key });
    expect(replayed.statusCode).toBe(200);
    expect(replayed.json().order.customer.phone).toBeNull();
  });

  it('refuses a key reused with another reason', async () => {
    const picked = await pickedUpOrder();
    const key = randomUUID();
    const away = { reason: 'pin_inaccurate', note: null };
    expect((await picked.arriveAtCustomer(farFromCustomer, { key, away })).statusCode).toBe(200);
    const other = await picked.arriveAtCustomer(farFromCustomer, {
      key,
      away: { reason: 'customer_requested_other_place', note: null },
    });
    expect(other.statusCode).toBe(422);
  });

  it('keeps the arrival and its reason consistent in the database', async () => {
    const picked = await pickedUpOrder();
    const update = (set: string) =>
      sql.query(`UPDATE ordering.orders SET ${set} WHERE id = $1`, [picked.order.id]);
    await expect(update("status = 'arrived'")).rejects.toThrow(/orders_customer_arrival/);
    await expect(update("away_reason = 'other'")).rejects.toThrow(/orders_away_reason/);
    await expect(update("away_reason = 'pin_inaccurate', away_note = 'x'")).rejects.toThrow(
      /orders_away_reason/,
    );
    await expect(update("away_reason = 'elsewhere'")).rejects.toThrow(/orders_away_reason/);
  });

  it('refuses another captain with unknown_order', async () => {
    const picked = await pickedUpOrder();
    const other = await onlineCaptain();
    const answer = await app.inject({
      method: 'POST',
      url: `/v1/captain/orders/${picked.order.id}/arrive-at-customer`,
      headers: { ...other.headers, 'idempotency-key': randomUUID() },
      payload: {
        location: {
          ...atCustomer,
          accuracyMetres: 10,
          recordedAt: new Date().toISOString(),
          simulated: false,
        },
        away: null,
      },
    });
    expect(answer.statusCode).toBe(404);
  });
});
