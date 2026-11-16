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
import { MerchantsService } from '../merchants/index.js';
import { SettingsService } from '../settings/index.js';

// The setup and helpers of dispatch.test.ts and auto-dispatch.test.ts: one file
// each, so a test run spreads them across its workers. Each test file that
// imports this one gets its own app, database and Valkey.

// Manual dispatch (D6; AP §9.3.2, §9.12.6, §8.3; CA §8, §15): operations
// offer an accepted order to an eligible captain, who accepts or declines it
// within dispatch.offer_timeout_sec, or it expires; or, with
// dispatch.manual_assign_requires_accept off, assign it directly.
// Each test signs in the three parties, places and accepts an order and
// waits on the offer timers: up to 3 s alone, so the default 5 s is too short
// for a full parallel run.
vi.setConfig({ testTimeout: 30_000 });

export let database: TestDatabase;
export let cache: TestValkey;
export let app: NestFastifyApplication;
export let sql: pg.Pool;
// The migration role, to move an offer back in time.
export let migrator: pg.Pool;
export let db: Database;
export let azaz: string;
export let restaurant: string;
export let item: string;

export const system = { type: 'system', id: null, role: null } as const;
export const change = { actor: system, context: { ipAddress: null, device: null }, reason: 'test' };
export const bySystem = { editor: 'system', context: change.context, reason: 'test' } as const;
export const centre = { latitude: 36.587, longitude: 37.046 };
// About 330 m north of the restaurant, inside its 1 km.
export const home = { latitude: 36.59, longitude: 37.046 };
// About 1.1 km north of the restaurant.
export const captainSpot = { latitude: 36.597, longitude: 37.046 };
export const allWeek = [0, 1, 2, 3, 4, 5, 6].map((weekday) => ({
  weekday,
  opensAt: 0,
  closesAt: 0,
}));
export const SECOND = 1000;

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
  migrator = new pg.Pool({ connectionString: database.migratorUrl });
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
  const captains = app.get(CaptainsService);
  const rate = {
    basePay: 2500n,
    includedMetres: 3000,
    perExtraKm: 500n,
    waitingPerMinute: 0n,
    minimumPay: 2500n,
  };
  await captains.setPayTable(
    azaz,
    {
      currency: 'TRY',
      rates: { walking: rate, bicycle: rate, motorbike: rate, car: rate },
    },
    change,
  );
  const merchants = app.get(MerchantsService);
  restaurant = await merchants.createRestaurant(
    azaz,
    {
      nameAr: 'مطعم التوزيع',
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
  await migrator?.end();
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

export let accounts = 0;
// A signed-in admin holding these roles (the identity rows written here).
export async function admin(roles: string[]) {
  accounts += 1;
  const { rows } = await sql.query(
    `INSERT INTO identity.admin_accounts (name, email, status, password_hash, totp_secret_encrypted)
     VALUES ($1, $2, 'active', 'not used', 'not used') RETURNING id`,
    [`Dispatcher ${accounts}`, `dispatcher${accounts}@example.test`],
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
  return {
    accountId,
    get: (url: string) => app.inject({ method: 'GET', url, cookies }),
    assign: (orderId: string, captainId: string, key: string = randomUUID()) =>
      app.inject({
        method: 'POST',
        url: `/v1/admin/orders/${orderId}/assign`,
        cookies,
        headers: { 'idempotency-key': key },
        payload: { captainId },
      }),
    manualDispatch: (orderId: string, key: string = randomUUID()) =>
      app.inject({
        method: 'POST',
        url: `/v1/admin/orders/${orderId}/manual-dispatch`,
        cookies,
        headers: { 'idempotency-key': key },
      }),
  };
}

// A placed order the restaurant accepted, its search started.
// At the main restaurant unless another is given (automatic dispatch's,
// apart from the manual tests' captains).
// With accept false, the order stays placed.
export async function acceptedOrder(
  at: { restaurant: string; item: string; home: Point } = { restaurant, item, home },
  { accept = true }: { accept?: boolean } = {},
): Promise<{ id: string; placedAt: string }> {
  const customer = await appSignIn('customer', phoneNumber());
  const lines = [
    { itemId: at.item, optionIds: [], quantity: 1, note: null, knownUnitPrice: '12000' },
  ];
  const quote = await app.inject({
    method: 'POST',
    url: '/v1/customer/quote',
    payload: {
      restaurantId: at.restaurant,
      location: at.home,
      lines,
      payIn: null,
      appVersion: '1.0.0',
    },
  });
  const placed = await app.inject({
    method: 'POST',
    url: '/v1/customer/orders',
    headers: { ...customer, 'idempotency-key': randomUUID() },
    payload: {
      restaurantId: at.restaurant,
      lines,
      payIn: null,
      appVersion: '1.0.0',
      quoteVersion: quote.json().version,
      addressId: null,
      unsavedAddress: {
        location: at.home,
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
  if (!accept) return { id: order.id, placedAt: order.placedAt };
  const phone = phoneNumber();
  await app
    .get(MerchantAccountsService)
    .addAccount(at.restaurant, { role: 'cashier', name: 'cashier', phone }, change);
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
  return { id: order.id, placedAt: order.placedAt };
}

// An activated motorbike captain, signed in and online at the point.
export async function onlineCaptain(point: Point = captainSpot) {
  const captains = app.get(CaptainsService);
  const captainId = await captains.createCaptain(
    azaz,
    {
      name: 'كابتن التوزيع',
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
  const call = (method: 'GET' | 'POST', url: string, key: string = randomUUID()) =>
    app.inject({
      method,
      url,
      headers: method === 'GET' ? headers : { ...headers, 'idempotency-key': key },
    });
  return { captainId, headers, call };
}

export const orderRow = async (id: string) =>
  (
    await sql.query(
      'SELECT status, version, captain_track, captain_id, assigned_at FROM ordering.orders WHERE id = $1',
      [id],
    )
  ).rows[0];

export const outboxTypes = async (id: string) =>
  (
    await sql.query('SELECT type FROM ordering.outbox WHERE order_id = $1 ORDER BY id', [id])
  ).rows.map((entry) => entry.type);

export const offerRow = async (id: string) =>
  (await sql.query('SELECT * FROM dispatch.offers WHERE id = $1', [id])).rows[0];
