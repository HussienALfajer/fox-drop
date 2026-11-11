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
import { LedgerService } from '../ledger/index.js';
import { MerchantsService } from '../merchants/index.js';
import { PickupBooking } from './pickup-booking.js';
import { SettingsService } from '../settings/index.js';

// The pickup (AP §8.1; RA §8.10; CA §9.4; AP §9.3.2 «تأكيد الاستلام نيابة عن
// المطعم»): the captain's request with its payment lines, the restaurant's
// answers, the automatic confirmation and custody.pay_merchant with
// picked_up in one transaction.

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

const pickupRow = async (orderId: string) =>
  (
    await sql.query(
      'SELECT status, captain_track, picked_up_at, ready_at, ready_by_pickup FROM ordering.orders WHERE id = $1',
      [orderId],
    )
  ).rows[0];

// The captain's custody in TRY, from the captain's view (AP §8.5.1).
async function custody(captainId: string): Promise<bigint> {
  const ledger = app.get(LedgerService);
  const [account] = await ledger.ownerAccounts(azaz, captainId, 'captain.custody');
  return account ? (await ledger.balance(account.id)).amount : 0n;
}

async function clearing(): Promise<bigint> {
  const ledger = app.get(LedgerService);
  const id = await ledger.openAccount({
    cityId: azaz,
    purpose: 'platform.order_clearing',
    ownerId: null,
    currency: 'TRY',
  });
  return (await ledger.balance(id)).amount;
}

const eventTypes = async (orderId: string) =>
  (
    await sql.query(
      'SELECT type, reason FROM ordering.order_events WHERE order_id = $1 ORDER BY version',
      [orderId],
    )
  ).rows;

describe('POST /v1/captain/orders/{orderId}/pickup-request (CA §9.4, RA §8.10)', () => {
  it('opens a request with the lines and its automatic confirmation a minute later', async () => {
    const at = await captainAtRestaurant();
    const active = await at.captain.active();
    expect(active.json().order.pickup).toEqual({
      proposedLines: TRY('24000'),
      currencies: TRY('24000'),
      request: null,
      pickedUpAt: null,
      disputedAt: null,
    });
    const started = Date.now();
    const answer = await at.requestPickup();
    expect(answer.statusCode).toBe(200);
    const { order } = answer.json();
    expect(order.captainTrack).toBe('pickup_pending');
    expect(order.pickup.request).toMatchObject({
      status: 'open',
      outcome: null,
      amount: { amount: '24000', currency: 'TRY' },
      lines: TRY('24000'),
    });
    const confirmBy = new Date(order.pickup.request.confirmBy).getTime();
    expect(confirmBy).toBeGreaterThanOrEqual(started + 60 * SECOND);
    const job = await sql.query(
      "SELECT start_after FROM pgboss.job WHERE name = 'ordering-pickup-auto-confirm' AND data->>'requestId' = $1",
      [order.pickup.request.id],
    );
    expect(new Date(job.rows[0].start_after).getTime()).toBe(confirmBy);
    // RA §8.10 item 3: every device of the restaurant sees the prompt.
    const board = await at.boardOrder();
    expect(board.pickup.request).toMatchObject({
      status: 'open',
      lines: TRY('24000'),
      baseEquivalent: '24000',
    });
    // One open request at a time.
    const again = await at.requestPickup();
    expect(again.statusCode).toBe(409);
    expect(again.json().error).toBe('order_state_changed');
  });

  it('refuses lines off the pickup payment by more than half the rounding unit (AP §8.1)', async () => {
    const at = await captainAtRestaurant();
    // TRY rounds to 5.00: within 2.50 passes, beyond it does not.
    const off = await at.requestPickup(TRY('24300'));
    expect(off.statusCode).toBe(409);
    expect(off.json().error).toBe('amount_mismatch');
    const usd = await at.requestPickup([{ currency: 'USD', amount: '600' }]);
    expect(usd.statusCode).toBe(409);
    expect(usd.json().error).toBe('currency_not_accepted');
    const twice = await at.requestPickup([
      { currency: 'TRY', amount: '12000' },
      { currency: 'TRY', amount: '12000' },
    ]);
    expect(twice.statusCode).toBe(400);
    expect((await at.requestPickup(TRY('24200'))).statusCode).toBe(200);
  });

  it('refuses a request before the captain reached the restaurant', async () => {
    const { order, captain } = await assignedOrder();
    const answer = await app.inject({
      method: 'POST',
      url: `/v1/captain/orders/${order.id}/pickup-request`,
      headers: { ...captain.headers, 'idempotency-key': randomUUID() },
      payload: {
        lines: TRY('24000'),
        location: {
          ...atDoor,
          accuracyMetres: 10,
          recordedAt: new Date().toISOString(),
          simulated: false,
        },
      },
    });
    expect(answer.statusCode).toBe(409);
    expect(answer.json().error).toBe('order_state_changed');
  });
});

describe('the pickup (AP §8.1, RA §8.10 item 4)', () => {
  it('books custody.pay_merchant and picked_up together when the restaurant confirms', async () => {
    const at = await captainAtRestaurant();
    expect((await at.requestPickup()).statusCode).toBe(200);
    const clearingBefore = await clearing();
    const key = randomUUID();
    const confirmed = await at.restaurant('confirm', undefined, key);
    expect(confirmed.statusCode).toBe(200);
    expect(confirmed.json().order).toMatchObject({
      status: 'picked_up',
      captainTrack: 'picked_up',
      pickup: {
        request: {
          status: 'confirmed',
          outcome: 'restaurant',
          closedByUserName: 'cashier',
          closedByDeviceName: 'كاشير',
        },
        readyNotPressed: true,
        disputedAt: null,
      },
    });
    const row = await pickupRow(at.order.id);
    expect(row).toMatchObject({ status: 'picked_up', ready_by_pickup: true });
    // «لم يُضغط جاهز»: ready recorded at the pickup's moment.
    expect(new Date(row.ready_at).getTime()).toBe(new Date(row.picked_up_at).getTime());
    // The captain paid 240.00 out of their own cash: the platform owes it.
    expect(await custody(at.captain.captainId)).toBe(-24_000n);
    expect((await clearing()) - clearingBefore).toBe(24_000n);
    expect((await eventTypes(at.order.id)).slice(-1)).toEqual([
      { type: 'order.picked_up', reason: 'restaurant' },
    ]);
    // A repeat of the key answers the order; nothing is booked twice.
    expect((await at.restaurant('confirm', undefined, key)).statusCode).toBe(200);
    expect(await custody(at.captain.captainId)).toBe(-24_000n);
    // The other devices find it answered.
    const late = await at.restaurant('confirm');
    expect(late.statusCode).toBe(409);
    expect(late.json().error).toBe('order_state_changed');
    // The captain's step 3; the restaurant's dispute window opens.
    expect((await at.captain.active()).json().order.pickup.pickedUpAt).not.toBeNull();
    const board = await at.boardOrder();
    expect(new Date(board.pickup.disputeUntil).getTime()).toBe(
      new Date(row.picked_up_at).getTime() + 10 * 60 * SECOND,
    );
  });

  it('books a rounding gap to platform.fx_rounding, so clearing holds the items value', async () => {
    const at = await captainAtRestaurant();
    expect((await at.requestPickup(TRY('24200'))).statusCode).toBe(200);
    const clearingBefore = await clearing();
    expect((await at.restaurant('confirm')).statusCode).toBe(200);
    expect(await custody(at.captain.captainId)).toBe(-24_200n);
    expect((await clearing()) - clearingBefore).toBe(24_000n);
  });

  it('confirms automatically once the minute has passed («تأكيد تلقائي»)', async () => {
    const at = await captainAtRestaurant();
    const request = (await at.requestPickup()).json().order.pickup.request;
    const job = { requestId: request.id, orderId: at.order.id, placedAt: '' };
    job.placedAt = (
      await sql.query('SELECT placed_at FROM ordering.orders WHERE id = $1', [at.order.id])
    ).rows[0].placed_at.toISOString();
    const booking = app.get(PickupBooking);
    // Early by both clocks: sent again for its moment, the restaurant keeps
    // its minute.
    expect(await booking.autoConfirm(job, new Date())).toBe(false);
    const jobs = await sql.query(
      "SELECT start_after FROM pgboss.job WHERE name = 'ordering-pickup-auto-confirm' AND data->>'requestId' = $1",
      [request.id],
    );
    expect(jobs.rows).toHaveLength(2);
    expect((await pickupRow(at.order.id)).status).toBe('accepted');
    const due = new Date(new Date(request.confirmBy).getTime() + SECOND);
    expect(await booking.autoConfirm(job, due)).toBe(true);
    expect(await booking.autoConfirm(job, due)).toBe(false);
    const order = (await at.captain.active()).json().order;
    expect(order.pickup.request).toMatchObject({ status: 'confirmed', outcome: 'automatic' });
    expect(await custody(at.captain.captainId)).toBe(-24_000n);
    // The restaurant answers too late.
    expect((await at.restaurant('confirm')).statusCode).toBe(409);
  });

  it('records ready as pressed when the restaurant pressed it', async () => {
    const at = await captainAtRestaurant();
    await app.inject({
      method: 'POST',
      url: `/v1/merchant/orders/${at.order.id}/ready`,
      headers: { ...at.order.cashier, 'idempotency-key': randomUUID() },
    });
    expect((await at.requestPickup()).statusCode).toBe(200);
    const confirmed = await at.restaurant('confirm');
    expect(confirmed.json().order.pickup.readyNotPressed).toBe(false);
    expect((await pickupRow(at.order.id)).ready_by_pickup).toBe(false);
  });
});

describe("the restaurant's refusals (RA §8.10 items 6-7)", () => {
  it('«المبلغ غير صحيح» rejects the request with the lines received and alerts operations', async () => {
    const at = await captainAtRestaurant();
    expect((await at.requestPickup()).statusCode).toBe(200);
    const disputed = await at.restaurant('dispute', { receivedLines: TRY('20000') });
    expect(disputed.statusCode).toBe(200);
    expect(disputed.json().order).toMatchObject({
      status: 'accepted',
      captainTrack: 'at_merchant',
      pickup: { request: { status: 'rejected', outcome: 'amount_incorrect' } },
    });
    const captainView = (await at.captain.active()).json().order.pickup.request;
    expect(captainView).toMatchObject({
      outcome: 'amount_incorrect',
      receivedLines: TRY('20000'),
    });
    expect(await custody(at.captain.captainId)).toBe(0n);
    const card = (await at.ops.get(`/v1/admin/orders?cityId=${azaz}`))
      .json()
      .orders.find((entry: { id: string }) => entry.id === at.order.id);
    expect(card.alerts).toContain('pickup_disputed');
    // AP §8.1: the customer's channel never learns of it.
    const rejected = await sql.query(
      "SELECT payload FROM ordering.outbox WHERE order_id = $1 AND type = 'order.pickup_rejected'",
      [at.order.id],
    );
    expect(rejected.rows[0].payload.reason).toBeNull();
    // The alert stays while the captain asks again, until the pickup.
    expect((await at.requestPickup()).statusCode).toBe(200);
    const waiting = (await at.ops.get(`/v1/admin/orders/${at.order.id}`)).json().order;
    expect(waiting.alerts).toContain('pickup_disputed');
    expect(waiting.badges.pickupPending).toBe(true);
    expect((await at.restaurant('confirm')).statusCode).toBe(200);
    const after = (await at.ops.get(`/v1/admin/orders/${at.order.id}`)).json().order;
    expect(after.alerts).not.toContain('pickup_disputed');
    expect(after.pickup.requests.map((entry: { status: string }) => entry.status)).toEqual([
      'confirmed',
      'rejected',
    ]);
  });

  it('«الطلب غير مكتمل» rejects the request without amounts or an alert', async () => {
    const at = await captainAtRestaurant();
    expect((await at.requestPickup()).statusCode).toBe(200);
    const answer = await at.restaurant('incomplete');
    expect(answer.statusCode).toBe(200);
    expect(answer.json().order.pickup.request).toMatchObject({
      status: 'rejected',
      outcome: 'incomplete',
    });
    const card = (await at.ops.get(`/v1/admin/orders?cityId=${azaz}`))
      .json()
      .orders.find((entry: { id: string }) => entry.id === at.order.id);
    expect(card.alerts).not.toContain('pickup_disputed');
    expect((await eventTypes(at.order.id)).slice(-1)).toEqual([
      { type: 'order.pickup_rejected', reason: 'incomplete' },
    ]);
  });
});

describe('the dispute after the pickup (RA §8.10 item 8)', () => {
  it('records one report within the window and tells the captain', async () => {
    const at = await captainAtRestaurant();
    expect((await at.requestPickup()).statusCode).toBe(200);
    expect((await at.restaurant('confirm')).statusCode).toBe(200);
    const disputed = await at.restaurant('dispute', { receivedLines: TRY('23000') });
    expect(disputed.statusCode).toBe(200);
    expect(disputed.json().order).toMatchObject({
      status: 'picked_up',
      pickup: { disputeUntil: null },
    });
    expect(disputed.json().order.pickup.disputedAt).not.toBeNull();
    const report = await sql.query(
      'SELECT received_lines, status FROM ordering.pickup_disputes WHERE order_id = $1',
      [at.order.id],
    );
    expect(report.rows).toEqual([{ received_lines: TRY('23000'), status: 'open' }]);
    const outbox = await sql.query(
      "SELECT payload FROM ordering.outbox WHERE order_id = $1 AND type = 'order.pickup_disputed'",
      [at.order.id],
    );
    expect(outbox.rows[0].payload.captainId).toBe(at.captain.captainId);
    expect((await at.captain.active()).json().order.pickup.disputedAt).not.toBeNull();
    const again = await at.restaurant('dispute', { receivedLines: TRY('23000') });
    expect(again.statusCode).toBe(409);
    expect(again.json().error).toBe('pickup_already_disputed');
    // AP §9.3.1: operations see the report with the amount received.
    const detail = (await at.ops.get(`/v1/admin/orders/${at.order.id}`)).json().order;
    expect(detail.pickup.dispute).toMatchObject({ receivedLines: TRY('23000') });
  });

  it('refuses a dispute once the window has closed', async () => {
    const at = await captainAtRestaurant();
    expect((await at.requestPickup()).statusCode).toBe(200);
    expect((await at.restaurant('confirm')).statusCode).toBe(200);
    await sql.query(
      "UPDATE ordering.orders SET picked_up_at = now() - interval '11 minutes', ready_at = now() - interval '11 minutes' WHERE id = $1",
      [at.order.id],
    );
    const late = await at.restaurant('dispute', { receivedLines: TRY('23000') });
    expect(late.statusCode).toBe(409);
    expect(late.json().error).toBe('order_state_changed');
  });
});

describe('POST /v1/admin/orders/{orderId}/confirm-pickup (AP §9.3.2)', () => {
  it('confirms an open request with the agreed lines and a reason, audited', async () => {
    const at = await captainAtRestaurant();
    expect((await at.requestPickup()).statusCode).toBe(200);
    expect((await at.restaurant('dispute', { receivedLines: TRY('20000') })).statusCode).toBe(200);
    const ops = await admin(['OPS']);
    const answer = await ops.confirmPickup(at.order.id, TRY('24000'), 'اتفقا بالهاتف');
    expect(answer.statusCode).toBe(200);
    expect(answer.json().order).toMatchObject({ status: 'picked_up', captainTrack: 'picked_up' });
    expect(await custody(at.captain.captainId)).toBe(-24_000n);
    const audit = await sql.query(
      "SELECT actor_id, reason FROM audit.events WHERE action = 'order.confirm_pickup' AND target_id = $1",
      [at.order.id],
    );
    expect(audit.rows).toEqual([{ actor_id: ops.accountId, reason: 'اتفقا بالهاتف' }]);
    const captainView = (await at.captain.active()).json().order.pickup.request;
    expect(captainView).toMatchObject({ status: 'confirmed', outcome: 'operations' });
    // The reason never leaves on the apps' channels.
    const outbox = await sql.query(
      "SELECT payload FROM ordering.outbox WHERE order_id = $1 AND type = 'order.picked_up'",
      [at.order.id],
    );
    expect(outbox.rows[0].payload.reason).toBeNull();
    const detail = (await ops.get(`/v1/admin/orders/${at.order.id}`)).json().order;
    expect(detail.pickup.requests[0]).toMatchObject({
      outcome: 'operations',
      bookedLines: TRY('24000'),
      closedBy: { type: 'admin', id: ops.accountId, device: null },
    });
  });

  it('confirms without a request, and refuses lines off the pickup payment', async () => {
    const at = await captainAtRestaurant();
    const ops = await admin(['OPS']);
    const off = await ops.confirmPickup(at.order.id, TRY('30000'), 'لا يرد المطعم');
    expect(off.statusCode).toBe(409);
    expect(off.json().error).toBe('amount_mismatch');
    const answer = await ops.confirmPickup(at.order.id, TRY('24000'), 'لا يرد المطعم');
    expect(answer.statusCode).toBe(200);
    expect(answer.json().order.status).toBe('picked_up');
    const again = await ops.confirmPickup(at.order.id, TRY('24000'), 'مرة ثانية');
    expect(again.statusCode).toBe(409);
    expect(again.json().error).toBe('order_state_changed');
  });
});

describe('who may answer, keys and races (architecture §5.3)', () => {
  it("answers 404 for another captain's or another restaurant's order", async () => {
    const at = await captainAtRestaurant();
    const other = await captainAtRestaurant();
    expect((await at.requestPickup()).statusCode).toBe(200);
    const foreign = await app.inject({
      method: 'POST',
      url: `/v1/captain/orders/${at.order.id}/pickup-request`,
      headers: { ...other.captain.headers, 'idempotency-key': randomUUID() },
      payload: {
        lines: TRY('24000'),
        location: {
          ...atDoor,
          accuracyMetres: 10,
          recordedAt: new Date().toISOString(),
          simulated: false,
        },
      },
    });
    expect(foreign.statusCode).toBe(404);
    // A restaurant user of another restaurant.
    const merchants = app.get(MerchantsService);
    const elsewhere = await merchants.createRestaurant(
      azaz,
      {
        nameAr: 'مطعم آخر',
        location: centre,
        coverage: { kind: 'radius', radiusMetres: 1000 },
        minimumOrder: { amount: 10_000n, currency: 'TRY' },
        commissionBp: 1500,
        defaultPrepMin: 20,
      },
      change,
    );
    await merchants.setAccountStatus(elsewhere, 'active', change);
    const phone = phoneNumber();
    await app
      .get(MerchantAccountsService)
      .addAccount(elsewhere, { role: 'owner', name: 'owner', phone }, change);
    const stranger = await appSignIn('merchant', phone);
    for (const path of ['confirm', 'incomplete', 'dispute']) {
      const answer = await app.inject({
        method: 'POST',
        url: `/v1/merchant/orders/${at.order.id}/pickup/${path}`,
        headers: { ...stranger, 'idempotency-key': randomUUID() },
        ...(path === 'dispute' ? { payload: { receivedLines: TRY('20000') } } : {}),
      });
      expect(answer.statusCode).toBe(404);
    }
  });

  it('answers a repeated request with the order, and refuses the key with other lines', async () => {
    const at = await captainAtRestaurant();
    const key = randomUUID();
    expect((await at.requestPickup(TRY('24000'), key)).statusCode).toBe(200);
    const repeat = await at.requestPickup(TRY('24000'), key);
    expect(repeat.statusCode).toBe(200);
    expect(repeat.json().order.captainTrack).toBe('pickup_pending');
    const requests = await sql.query(
      'SELECT count(*)::int AS n FROM ordering.pickup_requests WHERE order_id = $1',
      [at.order.id],
    );
    expect(requests.rows[0].n).toBe(1);
    expect((await at.requestPickup(TRY('24100'), key)).statusCode).toBe(422);
    // The dispute's lines in another currency are refused as the captain's.
    const usd = await at.restaurant('dispute', {
      receivedLines: [{ currency: 'USD', amount: '500' }],
    });
    expect(usd.statusCode).toBe(409);
    expect(usd.json().error).toBe('currency_not_accepted');
  });

  it('books one pickup when the restaurant and the automatic confirmation run together', async () => {
    const at = await captainAtRestaurant();
    const request = (await at.requestPickup()).json().order.pickup.request;
    const placedAt = (
      await sql.query('SELECT placed_at FROM ordering.orders WHERE id = $1', [at.order.id])
    ).rows[0].placed_at.toISOString();
    const due = new Date(new Date(request.confirmBy).getTime() + SECOND);
    const [answer, automatic] = await Promise.all([
      at.restaurant('confirm'),
      app
        .get(PickupBooking)
        .autoConfirm({ requestId: request.id, orderId: at.order.id, placedAt }, due),
    ]);
    expect([answer.statusCode === 200, automatic].filter(Boolean)).toHaveLength(1);
    expect(await custody(at.captain.captainId)).toBe(-24_000n);
    const pickups = await sql.query(
      "SELECT count(*)::int AS n FROM ordering.order_events WHERE order_id = $1 AND type = 'order.picked_up'",
      [at.order.id],
    );
    expect(pickups.rows[0].n).toBe(1);
  });

  it('answers a repeated operations confirmation with the order', async () => {
    const at = await captainAtRestaurant();
    const ops = await admin(['OPS']);
    const key = randomUUID();
    const confirm = () =>
      app.inject({
        method: 'POST',
        url: `/v1/admin/orders/${at.order.id}/confirm-pickup`,
        cookies: ops.cookies,
        headers: { 'idempotency-key': key },
        payload: { lines: TRY('24000'), reason: 'لا يرد المطعم' },
      });
    expect((await confirm()).statusCode).toBe(200);
    const repeat = await confirm();
    expect(repeat.statusCode).toBe(200);
    expect(repeat.json().order.status).toBe('picked_up');
    expect(await custody(at.captain.captainId)).toBe(-24_000n);
  });
});

// RA §12.7, CA §10.5, AP §8.6: the restaurant's pickup currencies, the
// captain's carried currencies, the proposed line and the journals across
// currencies with their rate versions. Last in the file: it enables USD for
// the city, which the orders placed after it keep in their snapshot.
describe('the pickup in another currency (RA §12.7, CA §10.5)', () => {
  it('proposes and books the dollars both accept, the clearing account in the base', async () => {
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
    const at = await captainAtRestaurant();
    const USD = [{ currency: 'USD', amount: '600' }];
    // The restaurant accepts the base only by default, and the captain
    // carries the base only.
    expect((await at.captain.active()).json().order.pickup.proposedLines).toEqual(TRY('24000'));
    const refused = await at.requestPickup(USD);
    expect(refused.statusCode).toBe(409);
    expect(refused.json().error).toBe('currency_not_accepted');

    const ops = await admin(['OPS']);
    const set = await app.inject({
      method: 'PUT',
      url: `/v1/admin/restaurants/${restaurant}/pickup-currencies`,
      cookies: ops.cookies,
      payload: { currencies: ['USD'] },
    });
    expect(set.statusCode).toBe(200);
    expect(set.json()).toMatchObject({
      pickupBaseCurrency: { currency: 'TRY', name: 'ليرة تركية' },
      pickupCurrencies: ['USD'],
      pickupCurrencyChoices: [{ currency: 'USD', name: 'دولار أمريكي' }],
    });
    const unknown = await app.inject({
      method: 'PUT',
      url: `/v1/admin/restaurants/${randomUUID()}/pickup-currencies`,
      cookies: ops.cookies,
      payload: { currencies: [] },
    });
    expect(unknown.statusCode).toBe(404);
    const invalid = await app.inject({
      method: 'PUT',
      url: `/v1/admin/restaurants/${restaurant}/pickup-currencies`,
      cookies: ops.cookies,
      payload: { currencies: ['TRY'] },
    });
    expect(invalid.statusCode).toBe(400);
    expect(invalid.json().error).toBe('invalid_pickup_currencies');
    const audit = await sql.query(
      "SELECT changes FROM audit.events WHERE action = 'restaurant.pickup_currencies' AND target_id = $1",
      [restaurant],
    );
    expect(audit.rows.map((row) => row.changes)).toEqual([
      { pickupCurrencies: { before: [], after: ['USD'] } },
    ]);
    // Both accept the base: the proposal stays in it.
    expect((await at.captain.active()).json().order.pickup.proposedLines).toEqual(TRY('24000'));

    const carried = (currencies: string[]) =>
      app.inject({
        method: 'PUT',
        url: '/v1/captain/settings/carried-currencies',
        headers: at.captain.headers,
        payload: { currencies },
      });
    const read = await app.inject({
      method: 'GET',
      url: '/v1/captain/settings/carried-currencies',
      headers: at.captain.headers,
    });
    expect(read.json()).toEqual({
      baseCurrency: 'TRY',
      carried: ['TRY'],
      choices: [
        { currency: 'TRY', name: 'ليرة تركية' },
        { currency: 'USD', name: 'دولار أمريكي' },
      ],
    });
    expect((await carried(['EUR'])).json().error).toBe('invalid_carried_currencies');
    expect((await carried([])).statusCode).toBe(400);
    expect((await carried(['USD'])).json()).toMatchObject({ carried: ['USD'] });
    // 240 TRY at 41.20 is 5.83 USD, 6.00 by 0.50 (247.20 TRY): within half
    // a 0.50 USD unit (10.30 TRY).
    const pickup = (await at.captain.active()).json().order.pickup;
    expect(pickup.proposedLines).toEqual(USD);
    // C8: what the captain may split across, with each equivalent.
    expect(pickup.currencies).toEqual([...TRY('24000'), ...USD]);

    const custodyUsd = async () => {
      const ledger = app.get(LedgerService);
      const id = await ledger.openAccount({
        cityId: azaz,
        purpose: 'captain.custody',
        ownerId: at.captain.captainId,
        currency: 'USD',
      });
      return (await ledger.balance(id)).amount;
    };
    const clearingIn = async (currency: string) => {
      const ledger = app.get(LedgerService);
      const id = await ledger.openAccount({
        cityId: azaz,
        purpose: 'platform.order_clearing',
        ownerId: null,
        currency,
      });
      return (await ledger.balance(id)).amount;
    };
    const [tryBefore, usdBefore] = [await clearing(), await clearingIn('USD')];
    // The ledger keeps the rates it is given (ledger.test.ts).
    const posted = vi.spyOn(app.get(LedgerService), 'post');
    const requested = await at.requestPickup(USD);
    expect(requested.statusCode).toBe(200);
    // RA §12.7: the restaurant sees the dollars and their base equivalent.
    expect((await at.boardOrder()).pickup.request).toMatchObject({
      lines: USD,
      baseEquivalent: '24720',
    });
    expect((await at.restaurant('confirm')).statusCode).toBe(200);
    expect(await custodyUsd()).toBe(-600n);
    // The items value in the base, nothing left in dollars.
    expect((await clearing()) - tryBefore).toBe(24_000n);
    expect((await clearingIn('USD')) - usdBefore).toBe(0n);
    const [usdRate] = (
      await sql.query(
        "SELECT id FROM fx.rate_versions WHERE city_id = $1 AND currency = 'USD' ORDER BY id DESC LIMIT 1",
        [azaz],
      )
    ).rows;
    expect(
      posted.mock.calls
        .map(([journal]) => journal)
        .filter((journal) => journal.source?.id === at.order.id)
        .map((journal) => ({ type: journal.type, rates: journal.rates })),
    ).toEqual([
      { type: 'custody.pay_merchant', rates: undefined },
      { type: 'platform.fx_rounding', rates: [{ currency: 'USD', rateVersionId: usdRate.id }] },
    ]);

    // C8: the captain splits it, 3 USD (123.60 TRY) and 116.50 TRY; the
    // ledger takes the payment across both currencies with its rate.
    const split = await captainAtRestaurant();
    const lines = [
      { currency: 'TRY', amount: '11650' },
      { currency: 'USD', amount: '300' },
    ];
    const tryBeforeSplit = await clearing();
    expect((await split.requestPickup(lines)).statusCode).toBe(200);
    expect((await split.restaurant('confirm')).statusCode).toBe(200);
    expect((await clearing()) - tryBeforeSplit).toBe(24_000n);
    expect((await clearingIn('USD')) - usdBefore).toBe(0n);
    expect(
      posted.mock.calls
        .map(([journal]) => journal)
        .filter((journal) => journal.source?.id === split.order.id)
        .map((journal) => journal.rates),
    ).toEqual([
      [{ currency: 'USD', rateVersionId: usdRate.id }],
      [{ currency: 'USD', rateVersionId: usdRate.id }],
    ]);

    // AP §8.1: cancelled while the split request waits, the restaurant
    // keeping the money: debited the lines' base total, 240.10 TRY.
    const kept = await captainAtRestaurant();
    expect((await kept.requestPickup(lines)).statusCode).toBe(200);
    const tryBeforeKept = await clearing();
    const ledger = app.get(LedgerService);
    const merchantAccount = await ledger.openAccount({
      cityId: azaz,
      purpose: 'merchant.account',
      ownerId: restaurant,
      currency: 'TRY',
    });
    const owedBefore = (await ledger.balance(merchantAccount)).amount;
    const cancelled = await app.inject({
      method: 'POST',
      url: `/v1/admin/orders/${kept.order.id}/cancel`,
      cookies: ops.cookies,
      headers: { 'idempotency-key': randomUUID() },
      payload: {
        cancellation: 'emergency',
        responsible: 'platform',
        foodPrepared: false,
        compensateCaptain: false,
        cash: 'not_returned',
        reason: 'ملاحظة العمليات',
      },
    });
    expect(cancelled.statusCode).toBe(200);
    expect((await clearing()) - tryBeforeKept).toBe(0n);
    expect((await clearingIn('USD')) - usdBefore).toBe(0n);
    // 116.50 TRY and 3 USD at 41.20: the restaurant owes 240.10 TRY more.
    expect((await ledger.balance(merchantAccount)).amount - owedBefore).toBe(-24_010n);
    posted.mockRestore();

    // Back to the base only, for the other files' restaurant.
    await app.inject({
      method: 'PUT',
      url: `/v1/admin/restaurants/${restaurant}/pickup-currencies`,
      cookies: ops.cookies,
      payload: { currencies: [] },
    });
  });
});
