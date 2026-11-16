import 'reflect-metadata';
import { randomBytes, randomInt, randomUUID } from 'node:crypto';
import type { NestFastifyApplication } from '@nestjs/platform-fastify';
import pg from 'pg';
import { afterAll, beforeAll, expect, vi } from 'vitest';
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
import { type AccountPurpose, LedgerService } from '../ledger/index.js';
import { MerchantsService } from '../merchants/index.js';
import { SettingsService } from '../settings/index.js';

// The setup and helpers of handover-flow.test.ts and handover-pay.test.ts: one
// file each, so a test run spreads them across its workers. Each test file that
// imports this one gets its own app, database and Valkey.

// AP §9.3.2 «تسليم لكابتن آخر», CA §9.10.1, §15, docs/domain/01, K17 (slice
// 2.12b): operations hand a picked-up order to a second captain, as an offer
// or an assignment; the second captain receives it near the first, collects
// at the door and earns the order pay; the first keeps the pickup payment in
// custody and goes offline.

vi.setConfig({ testTimeout: 30_000 });

export let database: TestDatabase;
export let cache: TestValkey;
export let app: NestFastifyApplication;
export let sql: pg.Pool;
export let db: Database;
export let azaz: string;
export let restaurant: string;
export let item: string;

export const system = { type: 'system', id: null, role: null } as const;
export const change = { actor: system, context: { ipAddress: null, device: null }, reason: 'test' };
export const bySystem = { editor: 'system', context: change.context, reason: 'test' } as const;
export const centre = { latitude: 36.587, longitude: 37.046 };
export const home = { latitude: 36.59, longitude: 37.046 };
export const captainSpot = { latitude: 36.597, longitude: 37.046 };
export const atDoor = { latitude: 36.5875, longitude: 37.046 };
export const allWeek = [0, 1, 2, 3, 4, 5, 6].map((weekday) => ({
  weekday,
  opensAt: 0,
  closesAt: 0,
}));

export function square({ latitude, longitude }: Point, half = 0.05): Point[] {
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

export const phoneNumber = () => `+9639${randomInt(100_000_000).toString().padStart(8, '0')}`;

export async function appSignIn(party: 'customer' | 'merchant' | 'captain', phone: string) {
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

export function cartLines() {
  return [{ itemId: item, optionIds: [], quantity: 2, note: null, knownUnitPrice: '12000' }];
}

export const quoteFor = (customer: Record<string, string>) =>
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

export async function place(customer: Record<string, string>) {
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

export async function cashier(restaurantId: string = restaurant) {
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
export async function placedOrder(customer?: Record<string, string>) {
  const headers = customer ?? (await appSignIn('customer', phoneNumber()));
  const placed = await place(headers);
  expect(placed.statusCode).toBe(201);
  return { id: placed.json().order.id as string, customer: headers };
}

// A placed order the restaurant accepted, with the cashier who accepted it.
export async function acceptedOrder(customer?: Record<string, string>) {
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

// About 55 m north of the customer's pin, inside the 200 m.
export const atCustomer = { latitude: 36.5905, longitude: 37.046 };
// Where the first captain stopped (a breakdown), and a spot 80 m from it.
export const brokenDown = { latitude: 36.5885, longitude: 37.046 };
export const besideThem = { latitude: 36.58922, longitude: 37.046 };

// An online captain at a point, whose commands send a fix where they are.
export async function onlineCaptain(name: string, point: Point = captainSpot) {
  const captains = app.get(CaptainsService);
  const captainId = await captains.createCaptain(
    azaz,
    {
      name,
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
  const state = { here: point };
  // Records the captain's point now, as the app does every 10 seconds.
  const moveTo = async (to: Point) => {
    state.here = to;
    const at = new Date();
    await captains.recordLocations(
      captainId,
      [{ ...to, accuracyMetres: 8, recordedAt: at, simulated: false }],
      new Date(at.getTime() + 1),
    );
  };
  await moveTo(point);
  const fix = () => ({
    ...state.here,
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
  const offerCommand = (offerId: string, verb: 'accept' | 'decline') =>
    app.inject({
      method: 'POST',
      url: `/v1/captain/offers/${offerId}/${verb}`,
      headers: { ...headers, 'idempotency-key': randomUUID() },
    });
  return {
    captainId,
    headers,
    moveTo,
    arrive: async (orderId: string) => {
      await moveTo(atDoor);
      return command(orderId, 'arrive', { location: fix() });
    },
    requestPickup: (orderId: string) =>
      command(orderId, 'pickup-request', {
        lines: [{ currency: 'TRY', amount: '24000' }],
        location: fix(),
      }),
    arriveAtCustomer: async (orderId: string) => {
      await moveTo(atCustomer);
      return command(orderId, 'arrive-at-customer', { location: fix(), away: null });
    },
    deliver: async (orderId: string) => {
      await moveTo(atCustomer);
      return command(orderId, 'deliver', {
        received: [{ currency: 'TRY', amount: '28000' }],
        change: [],
        amountDue: { amount: '28000', currency: 'TRY' },
        shortfall: null,
        away: null,
        location: fix(),
      });
    },
    receive: (orderId: string) => command(orderId, 'receive-handover', { location: fix() }),
    acknowledgeHandover: (orderId: string) =>
      app.inject({
        method: 'POST',
        url: `/v1/captain/orders/${orderId}/acknowledge-handover`,
        headers,
      }),
    currentOffer: async () =>
      (await app.inject({ method: 'GET', url: '/v1/captain/offers/current', headers })).json()
        .offer,
    accept: (offerId: string) => offerCommand(offerId, 'accept'),
    decline: (offerId: string) => offerCommand(offerId, 'decline'),
    active: async () =>
      (await app.inject({ method: 'GET', url: '/v1/captain/orders/active', headers })).json(),
    availability: async () =>
      (await app.inject({ method: 'GET', url: '/v1/captain/availability', headers })).json()
        .availability,
    // CA §7.3 (slice 2.13a): «لا أريد طلبات جديدة».
    lastOrder: () =>
      app.inject({
        method: 'POST',
        url: '/v1/captain/availability/last-order',
        headers,
        payload: { on: true },
      }),
  };
}

export async function admin(roles: string[]) {
  const { rows } = await sql.query(
    `INSERT INTO identity.admin_accounts (name, email, status, password_hash, totp_secret_encrypted)
     VALUES ('Handover', $1, 'active', 'not used', 'not used') RETURNING id`,
    [`handover-${randomUUID()}@example.test`],
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
    handover: (orderId: string, captainId: string, key?: string) =>
      post(`/v1/admin/orders/${orderId}/handover`, { captainId, reason: 'تعطلت الدراجة' }, key),
    picker: async (orderId: string) =>
      (
        await app.inject({ method: 'GET', url: `/v1/admin/orders/${orderId}/captains`, cookies })
      ).json().captains,
    detail: async (orderId: string) =>
      (await app.inject({ method: 'GET', url: `/v1/admin/orders/${orderId}`, cookies })).json()
        .order,
    post,
  };
}

export const requireAccept = (on: boolean) =>
  app
    .get(SettingsService)
    .update('dispatch.manual_assign_requires_accept', { cityId: azaz }, on, bySystem);

// A picked-up order (two shawarma, 24000; fee 4000; total 28000) whose
// captain then broke down, and operations.
export async function pickedUpOrder() {
  const order = await acceptedOrder();
  const first = await onlineCaptain('سامر الأول');
  const ops = await admin(['OPS']);
  expect((await ops.assign(order.id, first.captainId)).statusCode).toBe(200);
  expect((await first.arrive(order.id)).statusCode).toBe(200);
  expect((await first.requestPickup(order.id)).statusCode).toBe(200);
  const confirmed = await app.inject({
    method: 'POST',
    url: `/v1/merchant/orders/${order.id}/pickup/confirm`,
    headers: { ...order.cashier, 'idempotency-key': randomUUID() },
  });
  expect(confirmed.statusCode).toBe(200);
  await first.moveTo(brokenDown);
  return { order, first, ops };
}

export async function balance(purpose: AccountPurpose, ownerId: string): Promise<bigint> {
  const ledger = app.get(LedgerService);
  const [account] = await ledger.ownerAccounts(azaz, ownerId, purpose);
  return account ? (await ledger.balance(account.id)).amount : 0n;
}

export const events = async (orderId: string) =>
  (
    await sql.query(
      `SELECT type, actor_type, reason, captain_id, from_status, to_status
         FROM ordering.order_events WHERE order_id = $1 ORDER BY version`,
      [orderId],
    )
  ).rows;

export const handoverRows = async (orderId: string) =>
  (
    await sql.query(
      `SELECT from_captain_id, to_captain_id, offer_id IS NOT NULL AS offered, note,
              assigned_at IS NOT NULL AS assigned, received_at IS NOT NULL AS received,
              close_reason, from_seen_at IS NOT NULL AS seen
         FROM ordering.handovers WHERE order_id = $1 ORDER BY opened_at`,
      [orderId],
    )
  ).rows;

export const orderRow = async (orderId: string) =>
  (
    await sql.query(
      `SELECT status, captain_id, captain_track, arrived_at_customer_at, away_reason
         FROM ordering.orders WHERE id = $1`,
      [orderId],
    )
  ).rows[0];

// docs/domain/04: the first captain waited 30 minutes at the restaurant,
// 20 of them paid at 1 TRY a minute (the pay table's rate raised as the
// migration role, the moments moved back as the delivery test does).
export async function waitedAtRestaurant(orderId: string) {
  const migrator = new pg.Client({ connectionString: database.migratorUrl });
  await migrator.connect();
  try {
    await migrator.query(
      'UPDATE captains.pay_rates SET waiting_per_minute = 100 WHERE table_id = (SELECT pay_table_id FROM ordering.orders WHERE id = $1)',
      [orderId],
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
    [orderId],
  );
}
