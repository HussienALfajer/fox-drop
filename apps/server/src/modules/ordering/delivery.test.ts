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
import { type AccountPurpose, type JournalType, LedgerService } from '../ledger/index.js';
import { MerchantsService } from '../merchants/index.js';
import { OrdersService } from './orders.service.js';
import { SettingsService, type Vehicle, vehicles } from '../settings/index.js';

// The way to the customer, the arrival at the door, the door payment and the
// delivery with its money (CA §9.5–9.8, K4, K16; AP §8.4–8.6, §9.1.3,
// §9.3.2), and the whole cycle against AP §8.4's worked example.
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
  // AP §9.12.5: the placeholder pay table, 25 TRY including the first 3 km
  // and 5 TRY per extra km, the minimum 25 TRY.
  const rate = {
    basePay: 2_500n,
    includedMetres: 3_000,
    perExtraKm: 500n,
    waitingPerMinute: 0n,
    minimumPay: 2_500n,
  };
  await app.get(CaptainsService).setPayTable(
    azaz,
    {
      currency: 'TRY',
      rates: Object.fromEntries(vehicles.map((vehicle) => [vehicle, rate])) as Record<
        Vehicle,
        typeof rate
      >,
    },
    change,
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
    post,
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
// The dish ordered, twice.
interface Dish {
  itemId: string;
  unitPrice: string;
}

async function acceptedOrder(
  recipient: { recipientName: string; contactPhone: string } | null = null,
  dish: Dish = { itemId: item, unitPrice: '12000' },
) {
  const customer = await appSignIn('customer', phoneNumber());
  const lines = [
    {
      itemId: dish.itemId,
      optionIds: [],
      quantity: 2,
      note: 'بدون بصل',
      knownUnitPrice: dish.unitPrice,
    },
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
  dish?: Dish,
) {
  const order = await acceptedOrder(recipient, dish);
  const captain = await onlineCaptain();
  const ops = await admin(['OPS']);
  expect((await ops.assign(order.id, captain.captainId)).statusCode).toBe(200);
  return { order, captain, ops };
}

const SECOND = 1000;
const TRY = (amount: string) => [{ currency: 'TRY', amount }];

// An order whose captain is at the restaurant.
async function captainAtRestaurant(dish?: Dish) {
  const assigned = await assignedOrder(null, dish);
  expect((await assigned.captain.arrive(assigned.order.id)).statusCode).toBe(200);
  const itemsValue = (BigInt(dish?.unitPrice ?? '12000') * 2n).toString();
  const requestPickup = (lines = TRY(itemsValue), key: string = randomUUID()) =>
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
async function pickedUpOrder(dish?: Dish) {
  const at = await captainAtRestaurant(dish);
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
      label: 'أخرى',
      note: 'الزبون نزل إلى الشارع',
    });
  });

  it('refuses a note without «أخرى», «أخرى» without a note, and a code outside the list', async () => {
    const picked = await pickedUpOrder();
    const noted = await picked.arriveAtCustomer(farFromCustomer, {
      away: { reason: 'pin_inaccurate', note: 'نص' },
    });
    expect(noted.statusCode).toBe(400);
    expect(noted.json().error).toBe('reason_note_not_allowed');
    const bare = await picked.arriveAtCustomer(farFromCustomer, {
      away: { reason: 'other', note: null },
    });
    expect(bare.statusCode).toBe(400);
    expect(bare.json().error).toBe('reason_note_required');
    const unknown = await picked.arriveAtCustomer(farFromCustomer, {
      away: { reason: 'counting_error', note: null },
    });
    expect(unknown.statusCode).toBe(400);
    expect(unknown.json().error).toBe('unknown_reason');
  });

  it("keeps the reason's label as chosen when Content renames it", async () => {
    const picked = await pickedUpOrder();
    const answer = await picked.arriveAtCustomer(farFromCustomer, {
      away: { reason: 'pin_inaccurate', note: null },
    });
    expect(answer.statusCode).toBe(200);
    await sql.query(
      "UPDATE content.reasons SET label = 'الدبوس بعيد' WHERE list = 'captain_away' AND code = 'pin_inaccurate'",
    );
    try {
      const detail = (await picked.ops.get(`/v1/admin/orders/${picked.order.id}`)).json().order;
      expect(detail.customer.arrival.away).toEqual({
        reason: 'pin_inaccurate',
        label: 'موقع الزبون على الخريطة غير دقيق',
        note: null,
      });
    } finally {
      await sql.query(
        "UPDATE content.reasons SET label = 'موقع الزبون على الخريطة غير دقيق' WHERE list = 'captain_away' AND code = 'pin_inaccurate'",
      );
    }
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
    // Content checks the reason itself (AP §9.13); the row keeps a label and
    // a note only with a reason, and a note of 1 to 200 characters.
    await expect(update("away_reason_label = 'أخرى'")).rejects.toThrow(/orders_away_reason/);
    await expect(update("away_note = 'x'")).rejects.toThrow(/orders_away_reason/);
    await expect(update("away_reason = 'other', away_note = ''")).rejects.toThrow(
      /orders_away_reason/,
    );
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

// ---- The door payment and the delivery (CA §9.7–9.8; AP §8.4–8.6, §9.3.2)

const ledgerOf = () => app.get(LedgerService);

// A platform account's balance, as the specs show it, for the city.
async function platform(purpose: AccountPurpose, currency = 'TRY'): Promise<bigint> {
  const id = await ledgerOf().openAccount({ cityId: azaz, purpose, ownerId: null, currency });
  return (await ledgerOf().balance(id)).amount;
}

// An owner's account balance (a captain's custody or earnings, a restaurant's
// account), as the specs show it.
async function owned(ownerId: string, purpose: AccountPurpose, currency = 'TRY'): Promise<bigint> {
  const accounts = await ledgerOf().ownerAccounts(azaz, ownerId, purpose);
  const account = accounts.find((each) => each.currency === currency);
  return account ? (await ledgerOf().balance(account.id)).amount : 0n;
}

const PLATFORM: AccountPurpose[] = [
  'platform.order_clearing',
  'platform.revenue_delivery',
  'platform.revenue_commission',
  'platform.captain_pay',
  'platform.fx_rounding',
];

// The platform accounts now, to compare one order's effect.
async function platformNow(currency = 'TRY') {
  const result: Partial<Record<AccountPurpose, bigint>> = {};
  for (const purpose of PLATFORM) result[purpose] = await platform(purpose, currency);
  return result as Record<AccountPurpose, bigint>;
}

function delta(before: Record<string, bigint>, after: Record<string, bigint>) {
  return Object.fromEntries(Object.keys(before).map((key) => [key, after[key]! - before[key]!]));
}

// An order at the customer's door, with the delivery command.
async function orderAtDoor(
  options: { away?: object | null; dish?: Dish; tripMetres?: number } = {},
) {
  const picked = await pickedUpOrder(options.dish);
  if (options.tripMetres !== undefined) {
    // The trip kept at placing, as the pay of AP §8.4's example needs it.
    await sql.query('UPDATE ordering.orders SET trip_metres = $2 WHERE id = $1', [
      picked.order.id,
      options.tripMetres,
    ]);
  }
  const arrived = await picked.arriveAtCustomer(options.away ? farFromCustomer : atCustomer, {
    away: options.away ?? null,
  });
  expect(arrived.statusCode).toBe(200);
  const deliver = (
    payment: {
      received?: object[];
      change?: object[];
      amountDue?: string;
      amountDueCurrency?: string;
      shortfall?: object | null;
      away?: object | null;
    } = {},
    where: Point = atCustomer,
    key: string = randomUUID(),
  ) =>
    app.inject({
      method: 'POST',
      url: `/v1/captain/orders/${picked.order.id}/deliver`,
      headers: { ...picked.captain.headers, 'idempotency-key': key },
      payload: {
        received: payment.received ?? TRY('28000'),
        change: payment.change ?? [],
        amountDue: {
          amount: payment.amountDue ?? '28000',
          currency: payment.amountDueCurrency ?? 'TRY',
        },
        shortfall: payment.shortfall ?? null,
        away: payment.away ?? null,
        location: {
          ...where,
          accuracyMetres: 10,
          recordedAt: new Date().toISOString(),
          simulated: false,
        },
      },
    });
  return { ...picked, deliver };
}

const deliveryRow = async (orderId: string) =>
  (
    await sql.query(
      'SELECT status, captain_track, delivered_at, outcome, away_reason FROM ordering.orders WHERE id = $1',
      [orderId],
    )
  ).rows[0];

const collectionRow = async (orderId: string) =>
  (await sql.query('SELECT * FROM ordering.collections WHERE order_id = $1', [orderId])).rows;

describe('POST /v1/captain/orders/{orderId}/deliver (CA §9.7–9.8)', () => {
  it('delivers with outcome normal, books the money and answers the summary', async () => {
    const door = await orderAtDoor();
    const before = await platformNow();
    const restaurantBefore = await owned(restaurant, 'merchant.account');
    const answer = await door.deliver();
    expect(answer.statusCode).toBe(200);
    // Items 2 × 120, fee 40, total 280 TRY; a trip within the 3 km.
    expect(answer.json().summary).toMatchObject({
      orderId: door.order.id,
      pay: {
        base: '2500',
        distance: '0',
        topUp: '0',
        waiting: '0',
        total: '2500',
        currency: 'TRY',
      },
      custodyChange: { amount: '4000', currency: 'TRY' },
      handInToday: { amount: '4000', currency: 'TRY' },
    });
    expect(await deliveryRow(door.order.id)).toMatchObject({
      status: 'delivered',
      captain_track: 'done',
      outcome: 'normal',
    });
    const [collection] = await collectionRow(door.order.id);
    expect(collection).toMatchObject({
      amount_due: '28000',
      net_received: '28000',
      shortfall: '0',
      shortfall_reason: null,
      recorded_by_type: 'captain',
      recorded_by_id: door.captain.captainId,
    });
    // AP §8.5: the captain's custody keeps the 40 gained, the pay is owed.
    expect(await owned(door.captain.captainId, 'captain.custody')).toBe(4_000n);
    expect(await owned(door.captain.captainId, 'captain.earnings')).toBe(2_500n);
    // AP §8.7: the restaurant owes its 15% commission on 240.
    expect((await owned(restaurant, 'merchant.account')) - restaurantBefore).toBe(-3_600n);
    // The order's clearing returns to zero; the fee, commission and pay land.
    expect(delta(before, await platformNow())).toEqual({
      'platform.order_clearing': -24_000n, // the pickup's +240 settled
      'platform.revenue_delivery': 4_000n,
      'platform.revenue_commission': 3_600n,
      'platform.captain_pay': 2_500n,
      'platform.fx_rounding': 0n,
    });
    // The captain is free: no active order, the customer sees «تم التسليم».
    expect((await door.captain.active()).json().order).toBeNull();
    const events = await eventTypes(door.order.id);
    expect(events.at(-1)).toEqual({ type: 'order.delivered', reason: null });
    const outbox = await sql.query(
      "SELECT payload FROM ordering.outbox WHERE order_id = $1 AND type = 'order.delivered'",
      [door.order.id],
    );
    expect(outbox.rows[0].payload).toMatchObject({ status: 'delivered', reason: null });
  });

  it('shows the customer what was received and given back (CU §11.8, Q23)', async () => {
    const door = await orderAtDoor();
    const answer = await door.deliver({ received: TRY('30000'), change: TRY('2000') });
    expect(answer.statusCode).toBe(200);
    expect(answer.json().summary.custodyChange.amount).toBe('4000');
    const customerId = (
      await sql.query('SELECT customer_account_id FROM ordering.orders WHERE id = $1', [
        door.order.id,
      ])
    ).rows[0].customer_account_id;
    const view = await app.get(OrdersService).customerOrder(customerId, door.order.id);
    expect(view?.delivery).toMatchObject({
      outcome: 'normal',
      received: [{ currency: 'TRY', amount: 30_000n }],
      change: [{ currency: 'TRY', amount: 2_000n }],
      netReceived: 28_000n,
      shortfall: null,
    });
    // The custody holds the 300 received less the 20 given back and the 240.
    expect(await owned(door.captain.captainId, 'captain.custody')).toBe(4_000n);
  });

  it('books a gap within rounding to platform.fx_rounding', async () => {
    const door = await orderAtDoor();
    const before = await platformNow();
    // 2.50 TRY short, within half the 5 TRY unit.
    expect((await door.deliver({ received: TRY('27750') })).statusCode).toBe(200);
    const moved = delta(before, await platformNow());
    expect(moved['platform.order_clearing']).toBe(-24_000n);
    expect(moved['platform.fx_rounding']).toBe(-250n); // a loss of 2.50 for the platform
  });

  it('needs a reason for a shortfall, which stays open in the clearing account', async () => {
    const door = await orderAtDoor();
    const missing = await door.deliver({ received: TRY('25000') });
    expect(missing.statusCode).toBe(409);
    expect(missing.json()).toMatchObject({
      error: 'shortfall_reason_required',
      shortfall: { amount: '3000', currency: 'TRY' },
    });
    const before = await platformNow();
    const answer = await door.deliver({
      received: TRY('25000'),
      shortfall: { reason: 'customer_short', note: null },
    });
    expect(answer.statusCode).toBe(200);
    expect(answer.json().summary.custodyChange.amount).toBe('1000');
    // AP §8.6: the missing 30 waits in the clearing account for operations.
    expect(delta(before, await platformNow())['platform.order_clearing']).toBe(-21_000n);
    const detail = (await door.ops.get(`/v1/admin/orders/${door.order.id}`)).json().order;
    expect(detail.delivery).toMatchObject({
      outcome: 'normal',
      received: TRY('25000'),
      change: [],
      netReceived: { amount: '25000', currency: 'TRY' },
      shortfall: {
        amount: { amount: '3000', currency: 'TRY' },
        reason: 'customer_short',
        label: 'الزبون لا يملك المبلغ كاملاً',
        note: null,
      },
      recordedBy: { type: 'captain', id: door.captain.captainId, reason: null },
    });
    const list = (await door.ops.get(`/v1/admin/orders/shortfalls?cityId=${azaz}`)).json();
    expect(
      list.shortfalls.find((each: { orderId: string }) => each.orderId === door.order.id),
    ).toMatchObject({
      captainId: door.captain.captainId,
      amountDue: { amount: '28000', currency: 'TRY' },
      netReceived: { amount: '25000', currency: 'TRY' },
      shortfall: { amount: '3000', currency: 'TRY' },
      reason: 'customer_short',
      label: 'الزبون لا يملك المبلغ كاملاً',
    });
  });

  it("refuses another captain's delivery with unknown_order", async () => {
    const door = await orderAtDoor();
    const other = await onlineCaptain();
    const answer = await app.inject({
      method: 'POST',
      url: `/v1/captain/orders/${door.order.id}/deliver`,
      headers: { ...other.headers, 'idempotency-key': randomUUID() },
      payload: {
        received: TRY('28000'),
        change: [],
        amountDue: { amount: '28000', currency: 'TRY' },
        shortfall: null,
        away: null,
        location: {
          ...atCustomer,
          accuracyMetres: 10,
          recordedAt: new Date().toISOString(),
          simulated: false,
        },
      },
    });
    expect(answer.statusCode).toBe(404);
  });

  it("books a test order's pay to platform.test_cost, with no commission (AP §9.6.3)", async () => {
    const door = await orderAtDoor();
    await sql.query('UPDATE ordering.orders SET test_order = true WHERE id = $1', [door.order.id]);
    const testCost = await platform('platform.test_cost');
    const before = await platformNow();
    const restaurantBefore = await owned(restaurant, 'merchant.account');
    expect((await door.deliver()).statusCode).toBe(200);
    expect((await platform('platform.test_cost')) - testCost).toBe(2_500n);
    const moved = delta(before, await platformNow());
    expect(moved['platform.revenue_commission']).toBe(0n);
    expect(moved['platform.captain_pay']).toBe(0n);
    expect(moved['platform.order_clearing']).toBe(-24_000n);
    expect((await owned(restaurant, 'merchant.account')) - restaurantBefore).toBe(0n);
    expect(await owned(door.captain.captainId, 'captain.earnings')).toBe(2_500n);
  });

  it('refuses a net above the amount due, and a stale amount due', async () => {
    const door = await orderAtDoor();
    const over = await door.deliver({ received: TRY('30000') });
    expect(over.statusCode).toBe(409);
    expect(over.json().error).toBe('overpaid');
    const stale = await door.deliver({ amountDue: '27000', received: TRY('27000') });
    expect(stale.statusCode).toBe(409);
    expect(stale.json().error).toBe('amount_due_changed');
    expect(stale.json().order.collect).toEqual({ amount: '28000', currency: 'TRY' });
    const otherCurrency = await door.deliver({ amountDueCurrency: 'USD' });
    expect(otherCurrency.json().error).toBe('amount_due_changed');
    const huge = await door.deliver({ received: TRY('1234567890123456') });
    expect(huge.statusCode).toBe(400);
    const odd = await door.deliver({ received: [{ currency: 'EUR', amount: '1000' }] });
    expect(odd.json().error).toBe('currency_not_accepted');
    const repeated = await door.deliver({ received: [...TRY('14000'), ...TRY('14000')] });
    expect(repeated.statusCode).toBe(400);
    expect((await deliveryRow(door.order.id)).status).toBe('arrived');
    expect(await collectionRow(door.order.id)).toHaveLength(0);
  });

  it('needs a reason away from the pin, unless one was given at the arrival (K4)', async () => {
    const near = await orderAtDoor();
    const far = await near.deliver({}, farFromCustomer);
    expect(far.statusCode).toBe(409);
    expect(far.json().error).toBe('too_far_from_customer');
    const withReason = await near.deliver(
      { away: { reason: 'customer_requested_other_place', note: null } },
      farFromCustomer,
    );
    expect(withReason.statusCode).toBe(200);
    expect((await deliveryRow(near.order.id)).away_reason).toBe('customer_requested_other_place');

    const awayAtArrival = await orderAtDoor({ away: { reason: 'pin_inaccurate', note: null } });
    expect((await awayAtArrival.deliver({}, farFromCustomer)).statusCode).toBe(200);
    expect((await deliveryRow(awayAtArrival.order.id)).away_reason).toBe('pin_inaccurate');
  });

  it('refuses before the arrival at the door, and answers a repeat of the key once', async () => {
    const picked = await pickedUpOrder();
    const early = await app.inject({
      method: 'POST',
      url: `/v1/captain/orders/${picked.order.id}/deliver`,
      headers: { ...picked.captain.headers, 'idempotency-key': randomUUID() },
      payload: {
        received: TRY('28000'),
        change: [],
        amountDue: { amount: '28000', currency: 'TRY' },
        shortfall: null,
        away: null,
        location: {
          ...atCustomer,
          accuracyMetres: 10,
          recordedAt: new Date().toISOString(),
          simulated: false,
        },
      },
    });
    expect(early.statusCode).toBe(409);
    expect(early.json().error).toBe('order_state_changed');

    const door = await orderAtDoor();
    const key = randomUUID();
    const first = await door.deliver({}, atCustomer, key);
    const again = await door.deliver({}, atCustomer, key);
    expect(again.statusCode).toBe(200);
    expect(again.json().summary).toEqual(first.json().summary);
    expect(await collectionRow(door.order.id)).toHaveLength(1);
    expect(await owned(door.captain.captainId, 'captain.earnings')).toBe(2_500n);
  });

  it('pays the waiting past the threshold apart from the order pay (docs/domain/04)', async () => {
    const door = await orderAtDoor();
    // The pay table pays 1 TRY a minute of waiting; the captain waited 30
    // minutes at the restaurant, arriving 10 minutes after the food was due.
    const migrator = new pg.Client({ connectionString: database.migratorUrl });
    await migrator.connect();
    try {
      await migrator.query(
        'UPDATE captains.pay_rates SET waiting_per_minute = 100 WHERE table_id = (SELECT pay_table_id FROM ordering.orders WHERE id = $1)',
        [door.order.id],
      );
    } finally {
      await migrator.end();
    }
    await sql.query(
      `UPDATE ordering.orders SET
         accepted_at = picked_up_at - interval '60 minutes',
         arrived_at_merchant_at = picked_up_at - interval '30 minutes',
         captain_waiting_alert_at = picked_up_at - interval '20 minutes'
       WHERE id = $1`,
      [door.order.id],
    );
    const answer = await door.deliver();
    expect(answer.statusCode).toBe(200);
    // Due 40 minutes before the pickup, arrived 30 before: paid from 20 before.
    expect(answer.json().summary.pay).toMatchObject({
      base: '2500',
      waiting: '2000',
      total: '4500',
    });
    expect(await owned(door.captain.captainId, 'captain.earnings')).toBe(4_500n);
    expect((await collectionRow(door.order.id))[0].waiting_minutes).toBe(20);
  });
});

describe('POST /v1/admin/orders/{orderId}/record-delivery (AP §9.3.2)', () => {
  it('records the delivery for a picked-up order, with the same entries, audited', async () => {
    const picked = await pickedUpOrder();
    const answer = await picked.ops.post(`/v1/admin/orders/${picked.order.id}/record-delivery`, {
      received: TRY('30000'),
      change: TRY('2000'),
      amountDue: { amount: '28000', currency: 'TRY' },
      shortfall: null,
      reason: 'هاتف الكابتن معطل',
    });
    expect(answer.statusCode).toBe(200);
    expect(answer.json().order.status).toBe('delivered');
    expect(await owned(picked.captain.captainId, 'captain.custody')).toBe(4_000n);
    expect(await owned(picked.captain.captainId, 'captain.earnings')).toBe(2_500n);
    const [collection] = await collectionRow(picked.order.id);
    expect(collection).toMatchObject({
      recorded_by_type: 'admin',
      recorded_by_id: picked.ops.accountId,
      reason: 'هاتف الكابتن معطل',
    });
    const audit = await sql.query(
      "SELECT reason FROM audit.events WHERE action = 'order.record_delivery' AND target_id = $1",
      [picked.order.id],
    );
    expect(audit.rows).toEqual([{ reason: 'هاتف الكابتن معطل' }]);
    const again = await picked.ops.post(`/v1/admin/orders/${picked.order.id}/record-delivery`, {
      received: TRY('28000'),
      change: [],
      amountDue: { amount: '28000', currency: 'TRY' },
      shortfall: null,
      reason: 'مرة ثانية',
    });
    expect(again.statusCode).toBe(409);
    expect(again.json().error).toBe('order_state_changed');
  });

  it('records it from arrived too, and needs a reason for a shortfall', async () => {
    const door = await orderAtDoor();
    const body = {
      received: TRY('25000'),
      change: [],
      amountDue: { amount: '28000', currency: 'TRY' },
      reason: 'الكابتن بلا هاتف',
    };
    const missing = await door.ops.post(`/v1/admin/orders/${door.order.id}/record-delivery`, {
      ...body,
      shortfall: null,
    });
    expect(missing.statusCode).toBe(409);
    expect(missing.json()).toMatchObject({
      error: 'shortfall_reason_required',
      shortfall: { amount: '3000', currency: 'TRY' },
    });
    const answer = await door.ops.post(`/v1/admin/orders/${door.order.id}/record-delivery`, {
      ...body,
      shortfall: { reason: 'counting_error', note: null },
    });
    expect(answer.statusCode).toBe(200);
    expect((await collectionRow(door.order.id))[0]).toMatchObject({
      shortfall: '3000',
      shortfall_reason: 'counting_error',
      recorded_by_type: 'admin',
    });
  });

  it('needs operations.manage', async () => {
    const picked = await pickedUpOrder();
    const support = await admin(['SUP']);
    const answer = await support.post(`/v1/admin/orders/${picked.order.id}/record-delivery`, {
      received: TRY('28000'),
      change: [],
      amountDue: { amount: '28000', currency: 'TRY' },
      shortfall: null,
      reason: 'x',
    });
    expect(answer.statusCode).toBe(403);
  });
});

describe("the restaurant's board after the delivery (RA §8.10 item 8)", () => {
  it('keeps a delivered order until the pickup dispute window ends', async () => {
    const door = await orderAtDoor();
    expect((await door.deliver()).statusCode).toBe(200);
    const onBoard = await door.boardOrder();
    expect(onBoard).toMatchObject({ status: 'delivered' });
    expect(new Date(onBoard.pickup.disputeUntil).getTime()).toBeGreaterThan(Date.now());
    await sql.query(
      "UPDATE ordering.orders SET picked_up_at = picked_up_at - interval '11 minutes' WHERE id = $1",
      [door.order.id],
    );
    expect(await door.boardOrder()).toBeUndefined();
  });
});

describe('the whole cycle against the worked example of AP §8.4', () => {
  it('leaves every account as the example says, and the platform cash equals its margin', async () => {
    // Items 400 (2 × 200), fee 40, commission 15%, a 5 km trip: base 25 for
    // the first 3 km and 2 extra km × 5. There are no codes before Phase 2,
    // so the example's platform code of 30 is left out: the customer pays
    // 440, the custody gains 40 and the margin is 60 + 40 − 35 = 65.
    const merchants = app.get(MerchantsService);
    const category = await merchants.addCategory(restaurant, { name: 'مثال' }, change);
    const dish = await merchants.addItem(
      restaurant,
      { categoryId: category, name: 'وجبة المثال', price: { amount: 20_000n, currency: 'TRY' } },
      change,
    );
    const door = await orderAtDoor({
      dish: { itemId: dish, unitPrice: '20000' },
      tripMetres: 5_000,
    });
    const before = await platformNow();
    const restaurantBefore = await owned(restaurant, 'merchant.account');
    const answer = await door.deliver({ received: TRY('44000'), amountDue: '44000' });
    expect(answer.statusCode).toBe(200);
    expect(answer.json().summary.pay).toMatchObject({
      base: '2500',
      distance: '1000',
      total: '3500',
    });

    const custody = await owned(door.captain.captainId, 'captain.custody');
    const earnings = await owned(door.captain.captainId, 'captain.earnings');
    const restaurantOwes = (await owned(restaurant, 'merchant.account')) - restaurantBefore;
    const moved = delta(before, await platformNow());
    expect({ custody, earnings, restaurantOwes }).toEqual({
      custody: 4_000n, // handed in the same business day
      earnings: 3_500n, // paid on Thursday
      restaurantOwes: -6_000n, // the commission, collected on Saturday
    });
    expect(moved).toEqual({
      'platform.order_clearing': -40_000n, // the pickup's +400: the order is settled
      'platform.revenue_delivery': 4_000n,
      'platform.revenue_commission': 6_000n,
      'platform.captain_pay': 3_500n,
      'platform.fx_rounding': 0n,
    });
    const margin =
      moved['platform.revenue_commission']! +
      moved['platform.revenue_delivery']! -
      moved['platform.captain_pay']!;
    expect(margin).toBe(6_500n);

    // When each amount reaches the platform: the desk's hand-in, Thursday's
    // payout and Saturday's settlement (their screens come with the finance
    // slices; posted here as the desk will).
    const drawer = await ledgerOf().openAccount({
      cityId: azaz,
      purpose: 'platform.cash',
      ownerId: randomUUID(),
      currency: 'TRY',
    });
    const desk = { type: 'admin', id: randomUUID() } as const;
    const account = async (purpose: AccountPurpose, ownerId: string) =>
      (await ledgerOf().ownerAccounts(azaz, ownerId, purpose)).find(
        (each) => each.currency === 'TRY',
      )!.id;
    const custodyAccount = await account('captain.custody', door.captain.captainId);
    const earningsAccount = await account('captain.earnings', door.captain.captainId);
    const restaurantAccount = await account('merchant.account', restaurant);
    const post = (type: JournalType, entries: [string, bigint][]) =>
      db.db.transaction((tx) =>
        ledgerOf().post(
          {
            cityId: azaz,
            type,
            source: null,
            actor: desk,
            entries: entries.map(([accountId, amount]) => ({ accountId, currency: 'TRY', amount })),
          },
          tx,
        ),
      );
    await post('custody.hand_in', [
      [custodyAccount, -4_000n],
      [drawer, 4_000n],
    ]);
    await post('earn.payout', [
      [earningsAccount, 3_500n],
      [drawer, -3_500n],
    ]);
    await post('merchant.settlement', [
      [restaurantAccount, -6_000n],
      [drawer, 6_000n],
    ]);
    expect((await ledgerOf().balance(drawer)).amount).toBe(margin);
    expect(await owned(door.captain.captainId, 'captain.custody')).toBe(0n);
    expect(await owned(door.captain.captainId, 'captain.earnings')).toBe(0n);
  });
});

describe('the door payment in another currency (AP §8.6, CA §9.7)', () => {
  it('keeps the custody per currency and settles the clearing account in the base', async () => {
    const fx = app.get(FxService);
    const fin = { ...change, actor: { type: 'admin', id: randomUUID(), role: 'FIN' } } as const;
    await fx.setCityCurrency(azaz, { currency: 'USD', displayOrder: 2, enabled: false }, change);
    await fx.setRate(azaz, 'USD', { value: '41.20', direction: 'base_per_unit' }, fin);
    await app
      .get(SettingsService)
      .update(
        'currency.<code>.rounding_unit',
        { cityId: azaz, parameter: 'USD' },
        { amountMinor: 50 },
        bySystem,
      );
    await fx.setCityCurrency(azaz, { currency: 'USD', displayOrder: 2, enabled: true }, change);
    const door = await orderAtDoor();
    const beforeTry = await platformNow();
    const beforeUsd = await platformNow('USD');
    // 7 USD = 288.40 TRY; 8.40 TRY back.
    const answer = await door.deliver({
      received: [{ currency: 'USD', amount: '700' }],
      change: TRY('840'),
    });
    expect(answer.statusCode).toBe(200);
    expect(answer.json().summary.custodyChange.amount).toBe('4000');
    // CA §10.2: every currency at its current rate, so 7 USD less 248.40 TRY.
    expect(answer.json().summary.handInToday).toEqual({ amount: '4000', currency: 'TRY' });
    // AP §8.6: the captain hands back exactly the currencies received.
    expect(await owned(door.captain.captainId, 'captain.custody', 'USD')).toBe(700n);
    expect(await owned(door.captain.captainId, 'captain.custody')).toBe(-24_840n);
    expect(delta(beforeTry, await platformNow())['platform.order_clearing']).toBe(-24_000n);
    const usd = delta(beforeUsd, await platformNow('USD'));
    expect(usd['platform.order_clearing']).toBe(0n);
    // The platform's USD position against its TRY value.
    expect(usd['platform.fx_rounding']).toBe(700n);
    expect(delta(beforeTry, await platformNow())['platform.fx_rounding']).toBe(-28_840n);
  });

  it('books a gap within rounding beside the conversion', async () => {
    const door = await orderAtDoor();
    const beforeTry = await platformNow();
    // 7 USD = 288.40 TRY; 8 TRY back leaves 280.40: 0.40 over, within half
    // of 0.50 USD (10.30 TRY).
    const answer = await door.deliver({
      received: [{ currency: 'USD', amount: '700' }],
      change: TRY('800'),
    });
    expect(answer.statusCode).toBe(200);
    const moved = delta(beforeTry, await platformNow());
    expect(moved['platform.order_clearing']).toBe(-24_000n);
    // −288.40 for the USD's value, +0.40 gained in rounding.
    expect(moved['platform.fx_rounding']).toBe(-28_800n);
  });
});
