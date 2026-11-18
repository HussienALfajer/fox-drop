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
  CODE_SENDER,
  type DevelopmentCodeSender,
  MerchantAccountsService,
} from '../identity/index.js';
import { MerchantsService } from '../merchants/index.js';
import { SettingsService } from '../settings/index.js';

// CU §12.3 «طلباتي» (slice 2.28b): the customer's orders, active first and
// then past, newest first, in pages of 20, and the detail's timeline.

vi.setConfig({ testTimeout: 30_000 });

let database: TestDatabase;
let db: Database;
let cache: TestValkey;
let app: NestFastifyApplication;
let sql: pg.Pool;
let azaz: string;
let restaurant: string;

const system = { type: 'system', id: null, role: null } as const;
const change = { actor: system, context: { ipAddress: null, device: null }, reason: 'test' };
const bySystem = { editor: 'system', context: change.context, reason: 'test' } as const;
const centre = { latitude: 36.587, longitude: 37.046 };
// About 330 m north of the restaurant, inside its 1 km.
const home = { latitude: 36.59, longitude: 37.046 };
const allWeek = [0, 1, 2, 3, 4, 5, 6].map((weekday) => ({ weekday, opensAt: 0, closesAt: 0 }));

function square({ latitude, longitude }: Point, half = 0.05): Point[] {
  return [
    { latitude: latitude - half, longitude: longitude - half },
    { latitude: latitude - half, longitude: longitude + half },
    { latitude: latitude + half, longitude: longitude + half },
    { latitude: latitude + half, longitude: longitude - half },
  ];
}

async function newRestaurant(merchants: MerchantsService, nameAr: string): Promise<string> {
  const id = await merchants.createRestaurant(
    azaz,
    {
      nameAr,
      location: centre,
      coverage: { kind: 'radius', radiusMetres: 1000 },
      minimumOrder: { amount: 10_000n, currency: 'TRY' },
      commissionBp: 1500,
      defaultPrepMin: 20,
    },
    change,
  );
  await merchants.setAccountStatus(id, 'active', change);
  await merchants.setWeeklySchedule(id, allWeek, change);
  return id;
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
  // Every case signs in its own users, all from one test IP.
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
  restaurant = await newRestaurant(merchants, 'مطعم الاختبار');
}, 300_000);

afterAll(async () => {
  await app?.close();
  await db?.pool.end();
  await sql?.end();
  await Promise.all([database?.stop(), cache?.stop()]);
});

const phoneNumber = () => `+9639${randomInt(100_000_000).toString().padStart(8, '0')}`;

// A signed-in app user: the headers of its calls. A restaurant user's device
// is named, as on its first sign-in (RA §5.2).
async function signedIn(
  party: 'customer' | 'merchant',
  { restaurantId = restaurant, role = 'cashier' as 'owner' | 'cashier', device = 'كاشير 1' } = {},
): Promise<Record<string, string>> {
  const phone = phoneNumber();
  if (party === 'merchant') {
    await app
      .get(MerchantAccountsService)
      .addAccount(restaurantId, { role, name: role, phone }, change);
  }
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
  const headers = { authorization: `Bearer ${answer.json().accessToken}` };
  if (party === 'merchant') {
    const named = await app.inject({
      method: 'PUT',
      url: '/v1/merchant/auth/device',
      headers,
      payload: { name: device, platform: 'android', appVersion: '1.0.0' },
    });
    expect(named.statusCode).toBe(200);
  }
  return headers;
}

// A restaurant of its own with two items, so one case's pause or busy mode
// never blocks another's orders.
async function menuOf(nameAr: string): Promise<{ id: string; items: string[] }> {
  const merchants = app.get(MerchantsService);
  const id = await newRestaurant(merchants, nameAr);
  const category = await merchants.addCategory(id, { name: 'وجبات' }, change);
  const items = [];
  for (const [name, amount] of [
    ['شاورما', 12_000n],
    ['فلافل', 8_000n],
  ] as const) {
    items.push(
      await merchants.addItem(
        id,
        { categoryId: category, name, price: { amount, currency: 'TRY' } },
        change,
      ),
    );
  }
  return { id, items };
}

async function placedAt(
  restaurantId: string,
  itemIds: string[],
  headers: Record<string, string>,
): Promise<{ id: string; customer: Record<string, string> }> {
  const prices: Record<number, string> = { 0: '12000', 1: '8000' };
  const lines = itemIds.map((itemId, index) => ({
    itemId,
    optionIds: [],
    quantity: 1,
    note: null,
    knownUnitPrice: prices[index]!,
  }));
  const quote = await app.inject({
    method: 'POST',
    url: '/v1/customer/quote',
    payload: { restaurantId, location: home, lines, payIn: null, appVersion: '1.0.0' },
  });
  const answer = await app.inject({
    method: 'POST',
    url: '/v1/customer/orders',
    headers: { ...headers, 'idempotency-key': randomUUID() },
    payload: {
      restaurantId,
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
  expect(answer.statusCode).toBe(201);
  return { id: answer.json().order.id, customer: headers };
}

const history = async (headers: Record<string, string>, cursor?: string) => {
  const response = await app.inject({
    method: 'GET',
    url: `/v1/customer/orders${cursor ? `?cursor=${cursor}` : ''}`,
    headers,
  });
  expect(response.statusCode).toBe(200);
  return response.json() as {
    orders: {
      id: string;
      number: string;
      restaurant: { id: string; nameAr: string };
      status: string;
      active: boolean;
      total: { amount: string; currency: string };
      redelivery: boolean;
    }[];
    next: string | null;
  };
};

const detail = async (orderId: string, headers: Record<string, string>) =>
  (await app.inject({ method: 'GET', url: `/v1/customer/orders/${orderId}`, headers })).json()
    .order as {
    timeline: { step: string; at: string }[];
    money: { total: string };
    orderAgain: boolean;
  };

describe('GET /v1/customer/orders (CU §12.3)', () => {
  it('lists the active orders first, then the past ones newest first, in pages of 20', async () => {
    const { id: restaurantId, items } = await menuOf('مطعم طلباتي');
    const customer = await signedIn('customer');
    expect(await history(customer)).toEqual({ orders: [], next: null });

    // 21 past orders: each placed, then cancelled by the customer.
    const past: string[] = [];
    for (let index = 0; index < 21; index += 1) {
      const order = await placedAt(restaurantId, [items[0]!], customer);
      const cancelled = await app.inject({
        method: 'POST',
        url: `/v1/customer/orders/${order.id}/cancel`,
        headers: { ...customer, 'idempotency-key': randomUUID() },
        payload: { reason: 'changed_mind', note: null },
      });
      expect(cancelled.statusCode).toBe(200);
      past.unshift(order.id);
    }
    // One active order, placed last.
    const active = await placedAt(restaurantId, items, customer);

    const first = await history(customer);
    expect(first.orders.map((order) => order.id)).toEqual([active.id, ...past.slice(0, 20)]);
    expect(first.orders[0]).toMatchObject({
      restaurant: { id: restaurantId, nameAr: 'مطعم طلباتي' },
      status: 'placed',
      active: true,
      // 12000 + 8000 + the 4000 fee.
      total: { amount: '24000', currency: 'TRY' },
      redelivery: false,
    });
    expect(first.orders[1]).toMatchObject({ status: 'cancelled', active: false });
    expect((await detail(past[0]!, customer)).timeline.map((step) => step.step)).toEqual([
      'placed',
      'cancelled',
    ]);
    expect(first.next).not.toBeNull();

    // The next page holds the past ones left, never the active one again.
    const second = await history(customer, first.next!);
    expect(second.orders.map((order) => order.id)).toEqual([past[20]]);
    expect(second.next).toBeNull();

    // «اطلب مرة أخرى» follows a cancelled order, never an active one, and
    // only while customers see the restaurant (CU §12.3).
    expect((await detail(past[0]!, customer)).orderAgain).toBe(true);
    expect((await detail(active.id, customer)).orderAgain).toBe(false);
    const merchants = app.get(MerchantsService);
    await merchants.setAccountStatus(restaurantId, 'suspended', change);
    expect((await detail(past[0]!, customer)).orderAgain).toBe(false);
    await merchants.setAccountStatus(restaurantId, 'active', change);

    // Another customer sees none of them.
    expect((await history(await signedIn('customer'))).orders).toEqual([]);

    // A guest has no orders to list.
    expect((await app.inject({ method: 'GET', url: '/v1/customer/orders' })).statusCode).toBe(401);

    // A cursor that is not one, or names no real moment, is refused.
    const unreal = await app.inject({
      method: 'GET',
      url: `/v1/customer/orders?cursor=2026-13-01T00:00:00.000Z_${randomUUID()}`,
      headers: customer,
    });
    expect(unreal.statusCode).toBe(400);
    // A cursor that is not one is refused.
    const wrong = await app.inject({
      method: 'GET',
      url: '/v1/customer/orders?cursor=yesterday',
      headers: customer,
    });
    expect(wrong.statusCode).toBe(400);
  });

  it("gives the detail's short timeline, oldest first", async () => {
    const { id: restaurantId, items } = await menuOf('مطعم الخط الزمني');
    const customer = await signedIn('customer');
    const order = await placedAt(restaurantId, [items[0]!], customer);
    const placed = await detail(order.id, customer);
    expect(placed.timeline.map((step) => step.step)).toEqual(['placed']);

    const accepted = await app.inject({
      method: 'POST',
      url: `/v1/merchant/orders/${order.id}/accept`,
      headers: {
        ...(await signedIn('merchant', { restaurantId })),
        'idempotency-key': randomUUID(),
      },
      payload: { prepMin: 20 },
    });
    expect(accepted.statusCode).toBe(200);
    const after = await detail(order.id, customer);
    expect(after.timeline.map((step) => step.step)).toEqual(['placed', 'accepted']);
    expect(Date.parse(after.timeline[0]!.at)).toBeLessThanOrEqual(
      Date.parse(after.timeline[1]!.at),
    );
  });
});
