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
import { LedgerService } from '../ledger/index.js';
import { MerchantsService } from '../merchants/index.js';
import { PickupBooking } from './pickup-booking.js';
import { SettingsService } from '../settings/index.js';

// The pickup (AP §8.1; RA §8.10; CA §9.4; AP §9.3.2 «تأكيد الاستلام نيابة عن
// المطعم»): the captain's request with its payment lines, the restaurant's
// answers, the automatic confirmation and custody.pay_merchant with
// picked_up in one transaction.
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
        request: { status: 'confirmed', outcome: 'restaurant', closedByDeviceName: 'كاشير' },
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
    // Early by the clock: tried again later, the restaurant keeps its minute.
    await expect(booking.autoConfirm(job, new Date())).rejects.toThrow('not due yet');
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
    // The captain pays the difference and asks again; the alert resolves.
    expect((await at.requestPickup()).statusCode).toBe(200);
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
    expect(outbox.rows[0].payload.reason).toBe('operations');
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
