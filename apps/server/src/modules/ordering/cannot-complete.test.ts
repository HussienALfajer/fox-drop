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

// CA §9.11 «لا أستطيع إكمال الطلب» (C5, K17; AP §9.1.3, §9.3.2, §9.7.6;
// slice 2.13b): the captain asks operations to take the order with a reason;
// operations get the critical alert, the order shows «بانتظار العمليات» and
// stays the captain's until they act or the captain withdraws it with
// «تراجع»; an order that leaves the captain with the request open takes them
// offline.

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

const reassignmentRows = async (orderId: string) =>
  (
    await sql.query(
      `SELECT captain_id, reason, reason_label, captain_fault, cash, note, captain_seen_at
         FROM ordering.reassignments WHERE order_id = $1 ORDER BY at`,
      [orderId],
    )
  ).rows;

const withdrawal = {
  reassignment: 'captain_late',
  captainFault: true,
  cash: null,
  reason: 'الكابتن لم يتحرك',
};

const fixNow = () => ({
  ...atDoor,
  accuracyMetres: 10,
  recordedAt: new Date().toISOString(),
  simulated: false,
});

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

const cannotComplete = (
  captain: { headers: Record<string, string> },
  orderId: string,
  reason = 'vehicle_breakdown',
  note: string | null = null,
  key?: string,
) => captainPost(captain, orderId, 'cannot-complete', { location: fixNow(), reason, note }, key);

const withdrawRequest = (captain: { headers: Record<string, string> }, orderId: string) =>
  captainPost(captain, orderId, 'cannot-complete/withdraw', { location: fixNow() });

const requestRows = async (orderId: string) =>
  (
    await sql.query(
      `SELECT captain_id, reason, reason_label, note, closed_how
         FROM ordering.cannot_complete_requests WHERE order_id = $1 ORDER BY requested_at`,
      [orderId],
    )
  ).rows;

const periodEnd = async (captainId: string) =>
  (
    await sql.query(
      `SELECT end_reason FROM captains.online_periods WHERE captain_id = $1
        ORDER BY started_at DESC LIMIT 1`,
      [captainId],
    )
  ).rows[0].end_reason;

const availabilityOf = async (captainId: string) =>
  (await app.get(CaptainsService).state(captainId, new Date())).availability.state;

const storedAlerts = async (orderId: string) =>
  (
    await sql.query(
      `SELECT code, resolved_at FROM notifications.alerts
        WHERE subject_id = $1 AND code = 'captain_cannot_complete' ORDER BY raised_at`,
      [orderId],
    )
  ).rows;

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

describe('«لا أستطيع إكمال الطلب» (CA §9.11, C5)', () => {
  it('raises the alert, marks the order «بانتظار العمليات» and keeps it with the captain', async () => {
    const { order, captain, ops } = await captainAtRestaurant();
    const asked = await cannotComplete(captain, order.id);
    expect(asked.statusCode).toBe(200);
    expect(asked.json().order.cannotComplete).toEqual({
      reason: 'عطل في المركبة',
      note: null,
      at: expect.any(String),
    });
    expect((await captain.active()).json().order.cannotComplete.reason).toBe('عطل في المركبة');
    expect(await requestRows(order.id)).toEqual([
      {
        captain_id: captain.captainId,
        reason: 'vehicle_breakdown',
        reason_label: 'عطل في المركبة',
        note: null,
        closed_how: null,
      },
    ]);
    expect((await events(order.id)).at(-1)).toEqual({
      type: 'order.cannot_complete_requested',
      actor_type: 'captain',
      reason: 'vehicle_breakdown',
    });
    const detail = await ops.detail(order.id);
    expect(detail.badges.cannotComplete).toBe(true);
    expect(detail.alerts).toContain('captain_cannot_complete');
    expect(detail.cannotComplete).toMatchObject({
      captainId: captain.captainId,
      reason: 'vehicle_breakdown',
      label: 'عطل في المركبة',
      note: null,
    });
    await syncAlerts(order);
    expect(await storedAlerts(order.id)).toEqual([
      { code: 'captain_cannot_complete', resolved_at: null },
    ]);
    // Every step stays open (owner decision 2026-11-11).
    expect((await captain.requestPickup(order.id)).statusCode).toBe(200);
    // A second request while one is open is refused.
    expect((await cannotComplete(captain, order.id, 'accident')).json()).toMatchObject({
      error: 'order_state_changed',
    });
  });

  it('checks the reason against Content and replays a repeated key', async () => {
    const { order, captain } = await captainAtRestaurant();
    expect((await cannotComplete(captain, order.id, 'nonsense')).json()).toMatchObject({
      error: 'unknown_reason',
    });
    expect((await cannotComplete(captain, order.id, 'other')).json()).toMatchObject({
      error: 'reason_note_required',
    });
    const key = randomUUID();
    const first = await cannotComplete(captain, order.id, 'other', 'الإطار مثقوب', key);
    expect(first.statusCode).toBe(200);
    expect((await cannotComplete(captain, order.id, 'other', 'الإطار مثقوب', key)).statusCode).toBe(
      200,
    );
    expect(await requestRows(order.id)).toHaveLength(1);
    expect(first.json().order.cannotComplete).toMatchObject({
      reason: 'أخرى',
      note: 'الإطار مثقوب',
    });
    await expect(
      sql.query("UPDATE ordering.cannot_complete_requests SET reason = 'x' WHERE order_id = $1", [
        order.id,
      ]),
    ).rejects.toThrow(/permission denied/);
    const stranger = await onlineCaptain();
    expect((await cannotComplete(stranger, order.id)).statusCode).toBe(404);
  });

  it('withdraws with «تراجع»: the alert closes and a withdrawal later leaves the captain online', async () => {
    const { order, captain, ops } = await captainAtRestaurant();
    expect((await cannotComplete(captain, order.id)).statusCode).toBe(200);
    await syncAlerts(order);
    const withdrawn = await withdrawRequest(captain, order.id);
    expect(withdrawn.statusCode).toBe(200);
    expect(withdrawn.json().order.cannotComplete).toBeNull();
    expect((await requestRows(order.id))[0].closed_how).toBe('withdrawn');
    expect((await events(order.id)).at(-1)).toMatchObject({
      type: 'order.cannot_complete_withdrawn',
    });
    expect((await ops.detail(order.id)).alerts).not.toContain('captain_cannot_complete');
    await syncAlerts(order);
    expect((await storedAlerts(order.id))[0].resolved_at).not.toBeNull();
    expect((await withdrawRequest(captain, order.id)).json()).toMatchObject({
      error: 'order_state_changed',
    });
    expect((await ops.reassign(order.id, { ...withdrawal, cash: 'not_paid' })).statusCode).toBe(
      200,
    );
    expect(await availabilityOf(captain.captainId)).toBe('online_available');
  });

  it('takes the captain offline when operations reassign the order (K17)', async () => {
    const { order, captain, ops } = await captainAtRestaurant();
    expect((await cannotComplete(captain, order.id)).statusCode).toBe(200);
    const reassigned = await ops.reassign(order.id, {
      reassignment: 'captain_request',
      captainFault: true,
      cash: 'not_paid',
      reason: 'عطل في الدراجة',
    });
    expect(reassigned.statusCode).toBe(200);
    expect((await requestRows(order.id))[0].closed_how).toBe('reassigned');
    expect(await availabilityOf(captain.captainId)).toBe('offline');
    expect(await periodEnd(captain.captainId)).toBe('cannot_complete');
    expect((await reassignmentRows(order.id))[0].captain_fault).toBe(true);
    const { rows } = await sql.query(
      `SELECT type FROM notifications.platform_outbox WHERE payload->>'captainId' = $1`,
      [captain.captainId],
    );
    expect(rows.map((row) => row.type)).toEqual(['captain.availability_changed']);
  });

  it('takes the captain offline when the order ends another way while it is open', async () => {
    const { order, captain, ops } = await captainAtRestaurant();
    expect((await cannotComplete(captain, order.id, 'accident')).statusCode).toBe(200);
    const cancelled = await ops.cancel(order.id, {
      cancellation: 'emergency',
      responsible: 'platform',
      foodPrepared: false,
      compensateCaptain: false,
      cash: 'not_paid',
      reason: 'إلغاء للاختبار',
    });
    expect(cancelled.statusCode).toBe(200);
    expect((await requestRows(order.id))[0].closed_how).toBe('ended');
    expect(await periodEnd(captain.captainId)).toBe('cannot_complete');
    expect((await ops.detail(order.id)).cannotComplete).toBeNull();
  });
});
