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
  CODE_SENDER,
  type DevelopmentCodeSender,
  MerchantAccountsService,
} from '../identity/index.js';
import { MerchantsService, RestaurantStatusService } from '../merchants/index.js';
import { SettingsService } from '../settings/index.js';
import { rejectionProblem } from './order-commands.js';

// RA §8.6, §8.15; AP §9.3.2; CU §11.9: the restaurant rejects a placed order
// with one of three reasons and its side effects, and operations accept or
// reject on its behalf. Every command carries its Idempotency-Key, and a
// command the order's state no longer allows answers the current order.

vi.setConfig({ testTimeout: 30_000 });

let database: TestDatabase;
let db: Database;
let cache: TestValkey;
let app: NestFastifyApplication;
let sql: pg.Pool;
let azaz: string;
let restaurant: string;
let otherRestaurant: string;

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
  otherRestaurant = await newRestaurant(merchants, 'مطعم آخر');
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

const noSteps = { items: [], busyExtraMin: null, pauseMin: null };

const reject = (
  orderId: string,
  headers: Record<string, string>,
  payload: object,
  key: string = randomUUID(),
) =>
  app.inject({
    method: 'POST',
    url: `/v1/merchant/orders/${orderId}/reject`,
    headers: { ...headers, 'idempotency-key': key },
    payload,
  });

const rejection = async (id: string) =>
  (
    await sql.query(
      `SELECT status, version, rejected_at, reject_reason, reject_reason_label,
              reject_customer_text, reject_item_ids
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

const itemSwitch = async (id: string) =>
  (await sql.query('SELECT available, unavailable_until FROM merchants.items WHERE id = $1', [id]))
    .rows[0];

let accounts = 0;
async function admin(roles: string[]) {
  accounts += 1;
  const { rows } = await sql.query(
    `INSERT INTO identity.admin_accounts (name, email, status, password_hash, totp_secret_encrypted)
     VALUES ($1, $2, 'active', 'not used', 'not used') RETURNING id`,
    [`Operator ${accounts}`, `reject${accounts}@example.test`],
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
  return { accountId, post, cookies };
}

describe('the rule of a rejection (RA §8.6)', () => {
  const order = ['a', 'b'];
  it('takes the items only for «صنف غير متوفر», each once and from the order', () => {
    const items = (...ids: string[]) =>
      ids.map((itemId) => ({ itemId, until: 'tomorrow' as const }));
    expect(rejectionProblem({ code: 'item_unavailable', ...noSteps }, order)).toBe(
      'pick the unavailable items',
    );
    expect(
      rejectionProblem({ code: 'item_unavailable', ...noSteps, items: items('a') }, order),
    ).toBeNull();
    expect(
      rejectionProblem({ code: 'item_unavailable', ...noSteps, items: items('a', 'a') }, order),
    ).toBe('each item once');
    expect(
      rejectionProblem({ code: 'item_unavailable', ...noSteps, items: items('c') }, order),
    ).not.toBeNull();
    expect(
      rejectionProblem({ code: 'too_busy', ...noSteps, items: items('a') }, order),
    ).not.toBeNull();
  });

  it('takes busy mode or a 30-minute pause, not both, only for «ضغط طلبات»', () => {
    expect(rejectionProblem({ code: 'other', ...noSteps }, order)).toBe('unknown_reason');
    expect(rejectionProblem({ code: 'restaurant_closed', ...noSteps }, order)).toBeNull();
    expect(
      rejectionProblem({ code: 'restaurant_closed', ...noSteps, pauseMin: 30 }, order),
    ).not.toBeNull();
    expect(rejectionProblem({ code: 'too_busy', ...noSteps, busyExtraMin: 10 }, order)).toBeNull();
    expect(rejectionProblem({ code: 'too_busy', ...noSteps, pauseMin: 30 }, order)).toBeNull();
    expect(rejectionProblem({ code: 'too_busy', ...noSteps, pauseMin: 15 }, order)).not.toBeNull();
    expect(
      rejectionProblem({ code: 'too_busy', ...noSteps, busyExtraMin: 10, pauseMin: 30 }, order),
    ).toBe('busy mode or a pause, not both');
  });
});

describe('POST /v1/merchant/orders/{orderId}/reject (RA §8.6)', () => {
  it('rejects with «صنف غير متوفر» and switches the items off at once', async () => {
    const menu = await menuOf('مطعم الأصناف');
    const cashier = await signedIn('merchant', { restaurantId: menu.id });
    const order = await placedAt(menu.id, menu.items);
    const answer = await reject(order.id, cashier, {
      reason: 'item_unavailable',
      items: [
        { itemId: menu.items[0], until: 'tomorrow' },
        { itemId: menu.items[1], until: 'turned_back_on' },
      ],
      busyExtraMin: null,
      pauseMin: null,
    });
    expect(answer.statusCode).toBe(200);
    expect(answer.json().order).toMatchObject({ status: 'rejected', version: 2 });

    expect(await rejection(order.id)).toMatchObject({
      status: 'rejected',
      reject_reason: 'item_unavailable',
      reject_reason_label: 'صنف غير متوفر',
      reject_customer_text: 'بعض الأصناف غير متوفرة: شاورما، فلافل',
      reject_item_ids: menu.items,
    });
    const tomorrow = await itemSwitch(menu.items[0]!);
    expect(tomorrow.available).toBe(false);
    expect(tomorrow.unavailable_until.getTime()).toBeGreaterThan(Date.now());
    expect(await itemSwitch(menu.items[1]!)).toEqual({
      available: false,
      unavailable_until: null,
    });
    expect(await lastEvent(order.id)).toMatchObject({
      type: 'order.rejected',
      actor_type: 'restaurant',
      reason: 'item_unavailable',
      payload: { status: 'rejected', reason: 'item_unavailable', byOperations: false },
    });

    // CU §11.9: the customer's order gives the text and the items left out.
    const customerOrder = await app.inject({
      method: 'GET',
      url: `/v1/customer/orders/${order.id}`,
      headers: order.customer,
    });
    expect(customerOrder.json().order.rejection).toMatchObject({
      reason: 'item_unavailable',
      text: 'بعض الأصناف غير متوفرة: شاورما، فلافل',
      unavailableItemIds: menu.items,
    });
    // The board no longer lists it.
    const board = await app.inject({ method: 'GET', url: '/v1/merchant/orders', headers: cashier });
    expect(board.json().orders.map((each: { id: string }) => each.id)).not.toContain(order.id);
  });

  it('pauses the restaurant «حتى أعيد الفتح» with «المطعم مغلق» (S2)', async () => {
    const menu = await menuOf('مطعم يغلق');
    const cashier = await signedIn('merchant', { restaurantId: menu.id });
    const order = await placedAt(menu.id, [menu.items[0]!]);
    expect(
      (await reject(order.id, cashier, { reason: 'restaurant_closed', ...noSteps })).statusCode,
    ).toBe(200);
    expect((await rejection(order.id)).reject_customer_text).toBe(
      'المطعم أغلق ولا يستقبل طلبات الآن',
    );
    const { state } = await app.get(MerchantsService).storefrontState(menu.id);
    expect(state).toMatchObject({ state: 'paused', source: 'restaurant' });
  });

  it('sets busy mode or «إيقاف 30 د» with «ضغط طلبات», and nothing else without one', async () => {
    const merchants = app.get(MerchantsService);
    const busy = await menuOf('مطعم مزدحم');
    const busyCashier = await signedIn('merchant', { restaurantId: busy.id });
    const first = await placedAt(busy.id, [busy.items[0]!]);
    expect(
      (await reject(first.id, busyCashier, { reason: 'too_busy', ...noSteps, busyExtraMin: 20 }))
        .statusCode,
    ).toBe(200);
    expect(await merchants.operatingState(busy.id)).toMatchObject({
      state: 'open',
      busyExtraMin: 20,
    });
    // Busy mode keeps the restaurant open: the next one is rejected alone.
    const second = await placedAt(busy.id, [busy.items[0]!]);
    expect(
      (await reject(second.id, busyCashier, { reason: 'too_busy', ...noSteps })).statusCode,
    ).toBe(200);
    expect((await merchants.storefrontState(busy.id)).state.state).toBe('open');

    const paused = await menuOf('مطعم يتوقف');
    const pausedCashier = await signedIn('merchant', { restaurantId: paused.id });
    const third = await placedAt(paused.id, [paused.items[0]!]);
    expect(
      (await reject(third.id, pausedCashier, { reason: 'too_busy', ...noSteps, pauseMin: 30 }))
        .statusCode,
    ).toBe(200);
    expect((await merchants.storefrontState(paused.id)).state).toMatchObject({
      state: 'paused',
      source: 'restaurant',
    });
  });

  it('refuses a reason not on the list, steps that do not fit and a busy mode not offered', async () => {
    const menu = await menuOf('مطعم الرفض الخاطئ');
    const cashier = await signedIn('merchant', { restaurantId: menu.id });
    const order = await placedAt(menu.id, [menu.items[0]!]);
    const other = { itemId: menu.items[1], until: 'tomorrow' };
    for (const [payload, error] of [
      [{ reason: 'other', ...noSteps }, 'unknown_reason'],
      [{ reason: 'item_unavailable', ...noSteps }, 'invalid_rejection'],
      [{ reason: 'item_unavailable', ...noSteps, items: [other] }, 'invalid_rejection'],
      [{ reason: 'too_busy', ...noSteps, busyExtraMin: 15 }, 'invalid_rejection'],
    ] as const) {
      const refused = await reject(order.id, cashier, payload);
      expect(refused.statusCode).toBe(400);
      expect(refused.json().error).toBe(error);
    }
    expect((await rejection(order.id)).status).toBe('placed');
    expect((await itemSwitch(menu.items[1]!)).available).toBe(true);
  });

  it('answers a repeat of its key with the order, and refuses an accepted order', async () => {
    const menu = await menuOf('مطعم التكرار');
    const cashier = await signedIn('merchant', { restaurantId: menu.id });
    const order = await placedAt(menu.id, [menu.items[0]!]);
    const key = randomUUID();
    const payload = { reason: 'too_busy', ...noSteps };
    expect((await reject(order.id, cashier, payload, key)).statusCode).toBe(200);
    const repeat = await reject(order.id, cashier, payload, key);
    expect(repeat.statusCode).toBe(200);
    expect(repeat.json().order).toMatchObject({ status: 'rejected', version: 2 });
    expect((await reject(order.id, cashier, { ...payload, pauseMin: 30 }, key)).statusCode).toBe(
      422,
    );

    const accepted = await placedAt(menu.id, [menu.items[0]!]);
    const accept = await app.inject({
      method: 'POST',
      url: `/v1/merchant/orders/${accepted.id}/accept`,
      headers: { ...cashier, 'idempotency-key': randomUUID() },
      payload: { prepMin: 20 },
    });
    expect(accept.statusCode).toBe(200);
    const late = await reject(accepted.id, cashier, payload);
    expect(late.statusCode).toBe(409);
    expect(late.json()).toMatchObject({
      error: 'order_state_changed',
      order: { status: 'accepted' },
    });
  });

  it("refuses another restaurant's order", async () => {
    const menu = await menuOf('مطعم ثالث');
    const order = await placedAt(menu.id, [menu.items[0]!]);
    const stranger = await signedIn('merchant', { restaurantId: otherRestaurant });
    expect((await reject(order.id, stranger, { reason: 'too_busy', ...noSteps })).statusCode).toBe(
      404,
    );
  });

  it('leaves an operations pause alone: the rejection stands, nothing else changes (S2)', async () => {
    const menu = await menuOf('مطعم أوقفته العمليات');
    const cashier = await signedIn('merchant', { restaurantId: menu.id });
    const order = await placedAt(menu.id, [menu.items[0]!]);
    await app
      .get(RestaurantStatusService)
      .operationsPause(
        menu.id,
        { minutes: null, until: null, message: null, reason: 'فحص' },
        change,
      );
    for (const payload of [{ reason: 'restaurant_closed', ...noSteps }]) {
      expect((await reject(order.id, cashier, payload)).statusCode).toBe(200);
    }
    expect((await rejection(order.id)).status).toBe('rejected');
    const { rows } = await sql.query(
      `SELECT source, ended_at FROM merchants.pauses WHERE restaurant_id = $1 ORDER BY starts_at`,
      [menu.id],
    );
    expect(rows).toEqual([{ source: 'ops', ended_at: null }]);
  });

  it('keeps a rejected order whole (a CHECK)', async () => {
    const menu = await menuOf('مطعم القيد');
    const order = await placedAt(menu.id, [menu.items[0]!]);
    await expect(
      sql.query(
        "UPDATE ordering.orders SET status = 'rejected', rejected_at = now() WHERE id = $1",
        [order.id],
      ),
    ).rejects.toThrow(/violates check constraint/);
  });
});

describe('operations accept or reject for the restaurant (AP §9.3.2, RA §8.15)', () => {
  it('accepts with a prep time and a reason; the board shows «قبلته العمليات»', async () => {
    const menu = await menuOf('مطعم تقبل له العمليات');
    const cashier = await signedIn('merchant', { restaurantId: menu.id });
    const order = await placedAt(menu.id, [menu.items[0]!]);
    const ops = await admin(['OPS']);
    const answer = await ops.post(`/v1/admin/orders/${order.id}/accept`, {
      prepMin: 25,
      reason: 'المطعم لا يرد على الهاتف',
    });
    expect(answer.statusCode).toBe(200);
    expect(answer.json().order.status).toBe('accepted');
    expect(await lastEvent(order.id)).toMatchObject({
      type: 'order.accepted',
      actor_type: 'admin',
      actor_id: ops.accountId,
      reason: 'المطعم لا يرد على الهاتف',
      payload: { reason: null, byOperations: true },
    });
    const board = await app.inject({ method: 'GET', url: '/v1/merchant/orders', headers: cashier });
    const card = board.json().orders.find((each: { id: string }) => each.id === order.id);
    expect(card.acceptance).toMatchObject({ prepMin: 25, deviceName: null, byOperations: true });
    const { rows } = await sql.query(
      "SELECT reason FROM audit.events WHERE target_id = $1 AND action = 'order.accept'",
      [order.id],
    );
    expect(rows).toEqual([{ reason: 'المطعم لا يرد على الهاتف' }]);
    // The restaurant's own acceptance is not by operations.
    const own = await placedAt(menu.id, [menu.items[0]!]);
    await app.inject({
      method: 'POST',
      url: `/v1/merchant/orders/${own.id}/accept`,
      headers: { ...cashier, 'idempotency-key': randomUUID() },
      payload: { prepMin: 20 },
    });
    const after = await app.inject({ method: 'GET', url: '/v1/merchant/orders', headers: cashier });
    expect(
      after.json().orders.find((each: { id: string }) => each.id === own.id).acceptance
        .byOperations,
    ).toBe(false);
  });

  it('rejects with the reason and its side effect, the note kept apart', async () => {
    const menu = await menuOf('مطعم ترفض له العمليات');
    const order = await placedAt(menu.id, [menu.items[0]!]);
    const ops = await admin(['OPS']);
    const answer = await ops.post(`/v1/admin/orders/${order.id}/reject`, {
      rejection: 'restaurant_closed',
      ...noSteps,
      reason: 'اتصل المطعم: مغلق اليوم',
    });
    expect(answer.statusCode).toBe(200);
    expect(answer.json().order.status).toBe('rejected');
    expect(await lastEvent(order.id)).toMatchObject({
      type: 'order.rejected',
      actor_type: 'admin',
      reason: 'اتصل المطعم: مغلق اليوم',
      payload: { reason: 'restaurant_closed', byOperations: true },
    });
    expect((await app.get(MerchantsService).storefrontState(menu.id)).state).toMatchObject({
      state: 'paused',
      source: 'restaurant',
    });
    const { rows } = await sql.query(
      "SELECT reason FROM audit.events WHERE target_id = $1 AND action = 'order.reject'",
      [order.id],
    );
    expect(rows).toEqual([{ reason: 'اتصل المطعم: مغلق اليوم' }]);
    // A second decision finds the order rejected.
    const again = await ops.post(`/v1/admin/orders/${order.id}/accept`, {
      prepMin: 20,
      reason: 'خطأ',
    });
    expect(again.statusCode).toBe(409);
    expect(again.json()).toMatchObject({ error: 'order_state_changed' });
  });

  it('switches the items off for «صنف غير متوفر», audited with the admin', async () => {
    const menu = await menuOf('مطعم أصناف العمليات');
    const order = await placedAt(menu.id, [menu.items[0]!]);
    const ops = await admin(['OPS']);
    const answer = await ops.post(`/v1/admin/orders/${order.id}/reject`, {
      rejection: 'item_unavailable',
      ...noSteps,
      items: [{ itemId: menu.items[0], until: 'tomorrow' }],
      reason: 'اتصل المطعم: نفدت الشاورما',
    });
    expect(answer.statusCode).toBe(200);
    expect((await itemSwitch(menu.items[0]!)).available).toBe(false);
    const { rows } = await sql.query(
      "SELECT actor_type, actor_id, reason FROM audit.events WHERE target_id = $1 AND action = 'menu.item.availability'",
      [menu.items[0]],
    );
    expect(rows).toEqual([
      { actor_type: 'admin', actor_id: ops.accountId, reason: 'اتصل المطعم: نفدت الشاورما' },
    ]);
    // AP §9.3.1: the detail shows the rejection with its reason.
    const detail = await app.inject({
      method: 'GET',
      url: `/v1/admin/orders/${order.id}`,
      cookies: ops.cookies,
    });
    expect(detail.json().order.rejection).toMatchObject({
      reason: 'item_unavailable',
      label: 'صنف غير متوفر',
      itemIds: [menu.items[0]],
      byOperations: true,
    });
  });

  it("rejects a terminated restaurant's order, leaving its status alone", async () => {
    const menu = await menuOf('مطعم منتهٍ');
    const order = await placedAt(menu.id, [menu.items[0]!]);
    await app.get(MerchantsService).setAccountStatus(menu.id, 'terminated', change);
    const ops = await admin(['OPS']);
    for (const [rejectionCode, steps] of [['restaurant_closed', {}]] as const) {
      const answer = await ops.post(`/v1/admin/orders/${order.id}/reject`, {
        rejection: rejectionCode,
        ...noSteps,
        ...steps,
        reason: 'المطعم أنهى عقده',
      });
      expect(answer.statusCode).toBe(200);
    }
    expect((await rejection(order.id)).status).toBe('rejected');
    const { rows } = await sql.query('SELECT 1 FROM merchants.pauses WHERE restaurant_id = $1', [
      menu.id,
    ]);
    expect(rows).toEqual([]);
  });

  it("gives the dialogs' choices in the detail while the order is placed", async () => {
    const menu = await menuOf('مطعم خيارات العمليات');
    const order = await placedAt(menu.id, [menu.items[0]!]);
    const ops = await admin(['OPS']);
    const detail = async () =>
      (
        await app.inject({
          method: 'GET',
          url: `/v1/admin/orders/${order.id}`,
          cookies: ops.cookies,
        })
      ).json().order;
    expect((await detail()).lines[0].itemId).toBe(menu.items[0]);
    expect((await detail()).onBehalf).toEqual({
      prepTime: {
        options: [10, 15, 20, 30, 45],
        stepMin: 5,
        floorMin: 5,
        ceilingMin: 90,
        defaultMin: 20,
      },
      rejectionReasons: [
        { code: 'item_unavailable', label: 'صنف غير متوفر' },
        { code: 'restaurant_closed', label: 'المطعم مغلق' },
        { code: 'too_busy', label: 'ضغط طلبات' },
      ],
      busyExtraOptionsMin: [10, 20],
    });
    await ops.post(`/v1/admin/orders/${order.id}/accept`, { prepMin: 20, reason: 'test' });
    expect((await detail()).onBehalf).toBeNull();
  });

  it('needs operations.manage', async () => {
    const menu = await menuOf('مطعم الصلاحيات');
    const order = await placedAt(menu.id, [menu.items[0]!]);
    const support = await admin(['SUP']);
    expect(
      (
        await support.post(`/v1/admin/orders/${order.id}/reject`, {
          rejection: 'too_busy',
          ...noSteps,
          reason: 'x',
        })
      ).statusCode,
    ).toBe(403);
  });
});
