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
import { OrderTimers } from './order-timers.js';

// CU §11.4, §11.9; RA §8.3: the customer cancels their own order while the
// restaurant has not answered, with a reason from Content's self-cancel list
// (AP Appendix B); once the restaurant accepted, the server refuses with the
// order as it is now, and support cancels instead.

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
): Promise<{ id: string; customer: Record<string, string> }> {
  const headers = await signedIn('customer');
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

const cancel = (
  orderId: string,
  headers: Record<string, string>,
  payload: object,
  key: string = randomUUID(),
) =>
  app.inject({
    method: 'POST',
    url: `/v1/customer/orders/${orderId}/cancel`,
    headers: { ...headers, 'idempotency-key': key },
    payload,
  });

const cancellation = async (id: string) =>
  (
    await sql.query(
      `SELECT status, version, cancel_reason, cancel_customer_text, food_prepared,
              cancelled_at IS NOT NULL AS cancelled
         FROM ordering.orders WHERE id = $1`,
      [id],
    )
  ).rows[0];

const lastEvent = async (id: string) =>
  (
    await sql.query(
      `SELECT e.type, e.actor_type, e.actor_id, e.reason, o.payload
         FROM ordering.order_events e
         JOIN ordering.outbox o ON o.order_id = e.order_id AND o.order_version = e.version
        WHERE e.order_id = $1 ORDER BY e.version DESC LIMIT 1`,
      [id],
    )
  ).rows[0];

describe('POST /v1/customer/orders/{orderId}/cancel (CU §11.4)', () => {
  it('cancels a placed order with the reason, as the customer, without food prepared', async () => {
    const menu = await menuOf('مطعم الإلغاء');
    const cashier = await signedIn('merchant', { restaurantId: menu.id });
    const order = await placedAt(menu.id, [menu.items[0]!]);
    const answer = await cancel(order.id, order.customer, { reason: 'changed_mind', note: null });
    expect(answer.statusCode).toBe(200);
    expect(answer.json().order).toMatchObject({
      status: 'cancelled',
      version: 2,
      cancellation: { reason: 'changed_mind', byCustomer: true },
    });
    expect(await cancellation(order.id)).toEqual({
      status: 'cancelled',
      version: 2,
      cancel_reason: 'changed_mind',
      cancel_customer_text: null,
      food_prepared: false,
      cancelled: true,
    });
    expect(await lastEvent(order.id)).toMatchObject({
      type: 'order.cancelled',
      actor_type: 'customer',
      reason: 'changed_mind',
      payload: {
        status: 'cancelled',
        reason: 'changed_mind',
        byOperations: false,
        byCustomer: true,
      },
    });
    // RA §8.3: the restaurant's board drops it.
    const board = await app.inject({ method: 'GET', url: '/v1/merchant/orders', headers: cashier });
    expect(board.json().orders.map((each: { id: string }) => each.id)).not.toContain(order.id);
    // The automatic cancellation's job finds the order moved on.
    const job = { orderId: order.id, placedAt: answer.json().order.placedAt, version: 1 };
    expect(await app.get(OrderTimers).merchantAutoCancel(job, new Date())).toBe(false);
  });

  it('keeps the text of «سبب آخر» in the event, and refuses a reason off the list or a text it does not take', async () => {
    const menu = await menuOf('مطعم السبب');
    const order = await placedAt(menu.id, [menu.items[0]!]);
    const unknown = await cancel(order.id, order.customer, { reason: 'too_busy', note: null });
    expect(unknown.statusCode).toBe(400);
    expect(unknown.json().error).toBe('unknown_reason');
    const notAllowed = await cancel(order.id, order.customer, {
      reason: 'changed_mind',
      note: 'لا شيء',
    });
    expect(notAllowed.statusCode).toBe(400);
    expect(notAllowed.json().error).toBe('reason_note_not_allowed');
    expect((await cancellation(order.id)).status).toBe('placed');

    const other = await cancel(order.id, order.customer, {
      reason: 'other',
      note: 'تأخرت في الطلب',
    });
    expect(other.statusCode).toBe(200);
    expect(await lastEvent(order.id)).toMatchObject({
      actor_type: 'customer',
      reason: 'تأخرت في الطلب',
      payload: { reason: 'other' },
    });
    expect((await cancellation(order.id)).cancel_reason).toBe('other');
  });

  it('refuses once the restaurant accepted, with the order as it is now (the race)', async () => {
    const menu = await menuOf('مطعم السباق');
    const cashier = await signedIn('merchant', { restaurantId: menu.id });
    const order = await placedAt(menu.id, [menu.items[0]!]);
    const accepted = await app.inject({
      method: 'POST',
      url: `/v1/merchant/orders/${order.id}/accept`,
      headers: { ...cashier, 'idempotency-key': randomUUID() },
      payload: { prepMin: 20 },
    });
    expect(accepted.statusCode).toBe(200);
    const answer = await cancel(order.id, order.customer, { reason: 'changed_mind', note: null });
    expect(answer.statusCode).toBe(409);
    expect(answer.json()).toMatchObject({
      error: 'order_state_changed',
      order: { id: order.id, status: 'accepted', cancellation: null },
    });
    expect((await cancellation(order.id)).status).toBe('accepted');
  });

  it("answers a repeat with the first's order, and never cancels another customer's order", async () => {
    const menu = await menuOf('مطعم التكرار');
    const order = await placedAt(menu.id, [menu.items[0]!]);
    const stranger = await signedIn('customer');
    const theirs = await cancel(order.id, stranger, { reason: 'changed_mind', note: null });
    expect(theirs.statusCode).toBe(404);
    expect(theirs.json().error).toBe('unknown_order');

    const key = randomUUID();
    const body = { reason: 'ordered_by_mistake', note: null };
    expect((await cancel(order.id, order.customer, body, key)).statusCode).toBe(200);
    const repeat = await cancel(order.id, order.customer, body, key);
    expect(repeat.statusCode).toBe(200);
    expect(repeat.json().order).toMatchObject({ status: 'cancelled', version: 2 });
    const reused = await cancel(
      order.id,
      order.customer,
      { reason: 'changed_mind', note: null },
      key,
    );
    expect(reused.statusCode).toBe(422);
    expect(reused.json().error).toBe('idempotency_key_reused');
  });

  it('needs the Idempotency-Key', async () => {
    const menu = await menuOf('مطعم المفتاح');
    const order = await placedAt(menu.id, [menu.items[0]!]);
    const answer = await app.inject({
      method: 'POST',
      url: `/v1/customer/orders/${order.id}/cancel`,
      headers: order.customer,
      payload: { reason: 'changed_mind', note: null },
    });
    expect(answer.statusCode).toBe(400);
    expect(answer.json().error).toBe('idempotency_key_required');
  });
});
