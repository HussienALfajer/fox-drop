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
import { CaptainsService, localClock, PeakBonusService } from '../captains/index.js';
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
import { SettingsService, type Vehicle, vehicles } from '../settings/index.js';

// The setup and helpers of delivery.test.ts and deliver.test.ts: one file each,
// so a test run spreads them across its workers. Each test file that imports
// this one gets its own app, database and Valkey.

// The way to the customer, the arrival at the door, the door payment and the
// delivery with its money (CA §9.5–9.8, K4, K16; AP §8.4–8.6, §9.1.3,
// §9.3.2), and the whole cycle against AP §8.4's worked example.

// Each test signs in the parties, places, accepts and assigns an order
// before its own steps: up to 3 s alone, so the default 5 s is too short for
// a full parallel run.
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
// About 330 m north of the restaurant, inside its 1 km.
export const home = { latitude: 36.59, longitude: 37.046 };
// About 1.1 km north of the restaurant.
export const captainSpot = { latitude: 36.597, longitude: 37.046 };
// About 55 m north of the restaurant, inside the 150 m.
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
export async function admin(roles: string[]) {
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
export interface Dish {
  itemId: string;
  unitPrice: string;
}

export async function acceptedOrder(
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
export async function onlineCaptain(point: Point = captainSpot) {
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
export async function assignedOrder(
  recipient: { recipientName: string; contactPhone: string } | null = null,
  dish?: Dish,
) {
  const order = await acceptedOrder(recipient, dish);
  const captain = await onlineCaptain();
  const ops = await admin(['OPS']);
  expect((await ops.assign(order.id, captain.captainId)).statusCode).toBe(200);
  return { order, captain, ops };
}

export const SECOND = 1000;
export const TRY = (amount: string) => [{ currency: 'TRY', amount }];

// An order whose captain is at the restaurant.
export async function captainAtRestaurant(dish?: Dish) {
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

export const eventTypes = async (orderId: string) =>
  (
    await sql.query(
      'SELECT type, reason FROM ordering.order_events WHERE order_id = $1 ORDER BY version',
      [orderId],
    )
  ).rows;

// About 55 m north of the customer's pin, inside the 200 m.
export const atCustomer = { latitude: 36.5905, longitude: 37.046 };
// About 555 m north of the pin.
export const farFromCustomer = { latitude: 36.595, longitude: 37.046 };

// An order the captain picked up, with the commands of the way to the
// customer.
export async function pickedUpOrder(dish?: Dish) {
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

export const arrivalRow = async (orderId: string) =>
  (
    await sql.query(
      'SELECT status, captain_track, arrived_at_customer_at, away_reason, away_note FROM ordering.orders WHERE id = $1',
      [orderId],
    )
  ).rows[0];

// ---- The door payment and the delivery (CA §9.7–9.8; AP §8.4–8.6, §9.3.2)

export const ledgerOf = () => app.get(LedgerService);

// A platform account's balance, as the specs show it, for the city.
export async function platform(purpose: AccountPurpose, currency = 'TRY'): Promise<bigint> {
  const id = await ledgerOf().openAccount({ cityId: azaz, purpose, ownerId: null, currency });
  return (await ledgerOf().balance(id)).amount;
}

// An owner's account balance (a captain's custody or earnings, a restaurant's
// account), as the specs show it.
export async function owned(
  ownerId: string,
  purpose: AccountPurpose,
  currency = 'TRY',
): Promise<bigint> {
  const accounts = await ledgerOf().ownerAccounts(azaz, ownerId, purpose);
  const account = accounts.find((each) => each.currency === currency);
  return account ? (await ledgerOf().balance(account.id)).amount : 0n;
}

export const PLATFORM: AccountPurpose[] = [
  'platform.order_clearing',
  'platform.revenue_delivery',
  'platform.revenue_commission',
  'platform.captain_pay',
  'platform.fx_rounding',
];

// The platform accounts now, to compare one order's effect.
export async function platformNow(currency = 'TRY') {
  const result: Partial<Record<AccountPurpose, bigint>> = {};
  for (const purpose of PLATFORM) result[purpose] = await platform(purpose, currency);
  return result as Record<AccountPurpose, bigint>;
}

export function delta(before: Record<string, bigint>, after: Record<string, bigint>) {
  return Object.fromEntries(Object.keys(before).map((key) => [key, after[key]! - before[key]!]));
}

// An order at the customer's door, with the delivery command.
export async function orderAtDoor(
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

export const deliveryRow = async (orderId: string) =>
  (
    await sql.query(
      'SELECT status, captain_track, delivered_at, outcome, away_reason FROM ordering.orders WHERE id = $1',
      [orderId],
    )
  ).rows[0];

export const collectionRow = async (orderId: string) =>
  (await sql.query('SELECT * FROM ordering.collections WHERE order_id = $1', [orderId])).rows;

// AP §9.12.5, D15 (slice 2.16): a peak window running now on Azaz's clock,
// every day, for every zone, and its end: a newer disabled version written
// by the migration role, so the bonus stops at once for the next tests (a
// disabling through the service waits for the window's end).
export async function peakNow(amount: bigint): Promise<() => Promise<void>> {
  const { minute } = localClock(new Date(), 'Asia/Damascus');
  await app.get(PeakBonusService).setPeakBonus(
    azaz,
    {
      enabled: true,
      windows: [
        {
          days: [1, 2, 3, 4, 5, 6, 7],
          startMinute: (minute - 60 + 1440) % 1440,
          endMinute: (minute + 60) % 1440,
          amount,
          zoneIds: [],
        },
      ],
    },
    change,
  );
  return async () => {
    const migrator = new pg.Client({ connectionString: database.migratorUrl });
    await migrator.connect();
    try {
      await migrator.query(
        "INSERT INTO captains.peak_bonus_versions (city_id, enabled, currency, effective_from, editor_type, created_at) VALUES ($1, false, 'TRY', now(), 'system', now())",
        [azaz],
      );
    } finally {
      await migrator.end();
    }
  };
}
