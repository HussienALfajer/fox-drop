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
import { type AccountPurpose, LedgerService } from '../ledger/index.js';
import { MerchantsService } from '../merchants/index.js';
import { SettingsService } from '../settings/index.js';
import { ActiveOrders } from './active-orders.js';

// AP §9.3.3 «تعديل الطلب» before the pickup, RA §8.13, §8.10, §8.12, CA §9.3,
// §9.10, CU §11.6 (slice 2.10a; owner decisions 2026-11-10): operations edit
// an order's lines and delivery fee, the money is recalculated, the
// restaurant acknowledges, and an unacknowledged addition blocks the pickup.
// Also «تحديد النتيجة» (AP §9.3.2, §8.9, slice 2.11a), whose money counts the
// edits after the pickup, so it shares this file's picked-up orders.

vi.setConfig({ testTimeout: 30_000 });

let database: TestDatabase;
let cache: TestValkey;
let app: NestFastifyApplication;
let sql: pg.Pool;
let db: Database;
let azaz: string;
let restaurant: string;
let item: string;
let fries: string;
let soldOut: string;

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
      nameAr: 'مطعم التعديل',
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
  fries = await merchants.addItem(
    restaurant,
    { categoryId: category, name: 'بطاطا', price: { amount: 7_300n, currency: 'TRY' } },
    change,
  );
  soldOut = await merchants.addItem(
    restaurant,
    { categoryId: category, name: 'كبة', price: { amount: 5_000n, currency: 'TRY' } },
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
    assign: (orderId: string, captainId: string) =>
      post(`/v1/admin/orders/${orderId}/assign`, { captainId }),
    cancel: (orderId: string, body: object, key?: string) =>
      post(`/v1/admin/orders/${orderId}/cancel`, body, key),
    changeTime: (orderId: string, body: object, key?: string) =>
      post(`/v1/admin/orders/${orderId}/change-time`, body, key),
    closeItemReport: (orderId: string, body: object) =>
      post(`/v1/admin/orders/${orderId}/item-report/close`, body),
    // The dialog sends the order's version it showed (AP §9.3.3).
    edit: async (orderId: string, body: object, key?: string) => {
      const shown = await app.inject({
        method: 'GET',
        url: `/v1/admin/orders/${orderId}`,
        cookies,
      });
      const version = shown.statusCode === 200 ? shown.json().order.version : 1;
      return post(
        `/v1/admin/orders/${orderId}/edit`,
        { reason: 'اتفقنا مع الزبون', version, ...body },
        key,
      );
    },
    // The dialog sends the order's version it previewed (AP §8.9).
    outcome: async (orderId: string, body: object, key?: string) => {
      const shown = await app.inject({
        method: 'GET',
        url: `/v1/admin/orders/${orderId}`,
        cookies,
      });
      const version = shown.statusCode === 200 ? shown.json().order.version : 1;
      return post(
        `/v1/admin/orders/${orderId}/outcome`,
        { reason: 'اتصلنا بالزبون', version, ...body },
        key,
      );
    },
    outcomePreview: (orderId: string, body: object) =>
      app.inject({
        method: 'POST',
        url: `/v1/admin/orders/${orderId}/outcome-preview`,
        cookies,
        payload: body,
      }),
    editPreview: (orderId: string, body: object) =>
      app.inject({
        method: 'POST',
        url: `/v1/admin/orders/${orderId}/edit-preview`,
        cookies,
        payload: body,
      }),
    cookies,
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
      name: 'كابتن التعديل',
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
    active: () => app.inject({ method: 'GET', url: '/v1/captain/orders/active', headers }),
  };
}

// An accepted order whose captain is at the restaurant.
async function captainAtRestaurant(customer?: Record<string, string>) {
  const order = await acceptedOrder(customer);
  const captain = await onlineCaptain();
  const ops = await admin(['OPS']);
  expect((await ops.assign(order.id, captain.captainId)).statusCode).toBe(200);
  expect((await captain.arrive(order.id)).statusCode).toBe(200);
  return { order, captain, ops };
}

const board = async (headers: Record<string, string>, orderId: string) =>
  (await app.inject({ method: 'GET', url: '/v1/merchant/orders', headers }))
    .json()
    .orders.find((entry: { id: string }) => entry.id === orderId);

const events = async (orderId: string) =>
  (
    await sql.query(
      'SELECT type, actor_type, reason FROM ordering.order_events WHERE order_id = $1 ORDER BY version',
      [orderId],
    )
  ).rows;

// The newest event of the type.
const outboxReason = async (orderId: string, type: string) =>
  (
    await sql.query(
      "SELECT payload->>'reason' AS reason FROM ordering.outbox WHERE order_id = $1 AND type = $2 ORDER BY id DESC",
      [orderId, type],
    )
  ).rows[0]?.reason;

const times = async (orderId: string) =>
  (
    await sql.query(
      `SELECT status, promised_at, prep_min, prep_late_alert_at, search_start_at, search_started_at
         FROM ordering.orders WHERE id = $1`,
      [orderId],
    )
  ).rows[0];

const MINUTE = 60_000;
const moved = (after: Date, before: Date) => (after.getTime() - before.getTime()) / MINUTE;

const ready = (headers: Record<string, string>, orderId: string) =>
  app.inject({
    method: 'POST',
    url: `/v1/merchant/orders/${orderId}/ready`,
    headers: { ...headers, 'idempotency-key': randomUUID() },
  });

const customerOrder = async (headers: Record<string, string>, orderId: string) =>
  (await app.inject({ method: 'GET', url: `/v1/customer/orders/${orderId}`, headers })).json()
    .order;

const report = (
  headers: Record<string, string>,
  orderId: string,
  body: object = {
    items: [{ itemId: item, until: 'turned_back_on' }],
    note: 'insufficient_quantity',
  },
) =>
  app.inject({
    method: 'POST',
    url: `/v1/merchant/orders/${orderId}/item-report`,
    headers: { ...headers, 'idempotency-key': randomUUID() },
    payload: body,
  });

// Every case orders the same item: switch it on again after a report that
// leaves it off.
const switchOn = async (headers: Record<string, string>) => {
  const answer = await app.inject({
    method: 'PUT',
    url: '/v1/merchant/menu/availability',
    headers,
    payload: { type: 'item', id: item, available: true },
  });
  expect(answer.statusCode).toBe(200);
};

const reportRow = async (orderId: string) =>
  (
    await sql.query(
      `SELECT items, note, closed_how, closed_by_type, close_reason
         FROM ordering.item_reports WHERE order_id = $1 ORDER BY reported_at DESC`,
      [orderId],
    )
  ).rows[0];

const boardOrder = board;

// «اطلعت على التعديل» on the edits the prompt showed: through the newest one
// on the board, or the time given.
const acknowledge = async (headers: Record<string, string>, orderId: string, through?: string) => {
  const card = await board(headers, orderId);
  return app.inject({
    method: 'POST',
    url: `/v1/merchant/orders/${orderId}/acknowledge-edit`,
    headers: { ...headers, 'idempotency-key': randomUUID() },
    payload: { through: through ?? card?.edits.at(-1)?.at ?? new Date().toISOString() },
  });
};

const money = async (orderId: string) =>
  (
    await sql.query(
      'SELECT items_value, delivery_fee, rounding, total FROM ordering.orders WHERE id = $1',
      [orderId],
    )
  ).rows[0];

const editRow = async (orderId: string) =>
  (
    await sql.query('SELECT * FROM ordering.order_edits WHERE order_id = $1 ORDER BY at DESC', [
      orderId,
    ])
  ).rows[0];

// The order's two shawarma raised to three, and one fries added.
const addFries = {
  keep: [{ position: 0, quantity: 3 }],
  add: [{ itemId: '', optionIds: [], quantity: 1 }],
  deliveryFee: null,
  extraPrepMin: null,
};

beforeAll(() => {
  addFries.add[0]!.itemId = fries;
});

describe('POST /v1/admin/orders/{orderId}/edit before the pickup (AP §9.3.3)', () => {
  it('recalculates the money from the lines and keeps a raised line at its unit price', async () => {
    const order = await acceptedOrder();
    const ops = await admin(['OPS']);
    const answer = await ops.edit(order.id, addFries);
    expect(answer.statusCode).toBe(200);
    // 3 × 12000 + 7300 = 43300; the fee 4000; rounded to 500.
    const after = await money(order.id);
    expect(after.items_value).toBe('43300');
    expect(after.delivery_fee).toBe('4000');
    expect(BigInt(after.total)).toBe(43_300n + 4_000n + BigInt(after.rounding));
    expect(BigInt(after.total) % 500n).toBe(0n);
    const lines = (
      await sql.query(
        `SELECT position, quantity, line_total, quantity_before, added_by_edit IS NOT NULL AS added
           FROM ordering.order_lines WHERE order_id = $1 ORDER BY position`,
        [order.id],
      )
    ).rows;
    expect(lines).toEqual([
      { position: 0, quantity: 3, line_total: '36000', quantity_before: 2, added: false },
      { position: 1, quantity: 1, line_total: '7300', quantity_before: null, added: true },
    ]);
    const edit = await editRow(order.id);
    expect(edit).toMatchObject({
      status: 'accepted',
      adds_items: true,
      items_value_before: '24000',
      items_value_after: '43300',
      extra_prep_min: null,
      acknowledged_at: null,
    });
    expect(edit.changes).toEqual([
      { kind: 'quantity', name: 'شاورما', options: [], quantity: 3, quantityBefore: 2 },
      { kind: 'added', name: 'بطاطا', options: [], quantity: 1 },
    ]);
    expect((await events(order.id)).at(-1)).toEqual({
      type: 'order.edited',
      actor_type: 'admin',
      reason: 'اتفقنا مع الزبون',
    });
    expect(await outboxReason(order.id, 'order.edited')).toBe('items_added');
    // The customer's summary: the new total, «أُضيف» and the quantity change.
    const seen = await customerOrder(order.customer, order.id);
    expect(seen.money.total).toBe(after.total);
    expect(
      seen.lines.map((line: { name: string; added: boolean; quantityBefore: number | null }) => [
        line.name,
        line.added,
        line.quantityBefore,
      ]),
    ).toEqual([
      ['شاورما', false, 2],
      ['بطاطا', true, null],
    ]);
    expect(seen.removedLines).toEqual([]);
  });

  it('removes a line, changes the delivery fee, and an edit without additions blocks nothing', async () => {
    const { order, captain, ops } = await captainAtRestaurant();
    expect((await ops.edit(order.id, addFries)).statusCode).toBe(200);
    expect((await acknowledge(order.cashier, order.id)).statusCode).toBe(200);
    // Fries out, the shawarma back to two, the fee down.
    const answer = await ops.edit(order.id, {
      keep: [{ position: 0, quantity: 2 }],
      add: [],
      deliveryFee: '2000',
      extraPrepMin: null,
    });
    expect(answer.statusCode).toBe(200);
    expect(await money(order.id)).toMatchObject({ items_value: '24000', delivery_fee: '2000' });
    expect(await editRow(order.id)).toMatchObject({
      adds_items: false,
      delivery_fee_before: '4000',
      delivery_fee_after: '2000',
    });
    expect(await outboxReason(order.id, 'order.edited')).toBe('changed');
    const seen = await customerOrder(order.customer, order.id);
    expect(seen.removedLines).toEqual([{ name: 'بطاطا', quantity: 1, options: [] }]);
    // The line is back at its first quantity: no change shows.
    expect(seen.lines[0].quantityBefore).toBeNull();
    // Not acknowledged, but it added nothing: the pickup goes on at the new amount.
    const card = await boardOrder(order.cashier, order.id);
    expect(card.edits).toHaveLength(1);
    expect(card.edits[0].addsItems).toBe(false);
    expect((await captain.active()).json().order.editUnacknowledged).toBe(false);
    expect((await captain.requestPickup(order.id, '24000')).statusCode).toBe(200);
    // And no edit while the request is open.
    const during = await ops.edit(order.id, addFries);
    expect(during.statusCode).toBe(409);
    expect(during.json().error).toBe('pickup_request_open');
  });

  it('blocks the pickup until «اطلعت على التعديل» when items were added, and clears an open item report', async () => {
    const { order, captain } = await captainAtRestaurant();
    const ops = await admin(['OPS']);
    expect((await report(order.cashier, order.id)).statusCode).toBe(200);
    // The reported shawarma replaced by fries.
    const answer = await ops.edit(order.id, {
      keep: [],
      add: [{ itemId: fries, optionIds: [], quantity: 2 }],
      deliveryFee: null,
      extraPrepMin: null,
    });
    expect(answer.statusCode).toBe(200);
    expect(await reportRow(order.id)).toMatchObject({
      closed_how: 'edited',
      closed_by_type: 'admin',
    });
    expect((await ops.detail(order.id)).alerts).not.toContain('item_unavailable');
    expect((await captain.active()).json().order).toMatchObject({
      itemReportOpen: false,
      editUnacknowledged: true,
    });
    const blocked = await captain.requestPickup(order.id, '14600');
    expect(blocked.statusCode).toBe(409);
    expect(blocked.json().error).toBe('edit_unacknowledged');
    const card = await boardOrder(order.cashier, order.id);
    expect(card.edits).toEqual([
      {
        at: expect.any(String),
        addsItems: true,
        changes: [
          { kind: 'removed', name: 'شاورما', options: [], quantity: 2 },
          { kind: 'added', name: 'بطاطا', options: [], quantity: 2 },
        ],
        itemsValue: '14600',
        extraPrepMin: null,
      },
    ]);
    const acknowledged = await acknowledge(order.cashier, order.id);
    expect(acknowledged.statusCode).toBe(200);
    expect(acknowledged.json().order.edits).toEqual([]);
    expect(await editRow(order.id)).toMatchObject({ acknowledged_device: expect.any(String) });
    expect((await events(order.id)).at(-1)).toMatchObject({
      type: 'order.edit_acknowledged',
      actor_type: 'restaurant',
    });
    // A second acknowledgement has nothing to acknowledge.
    expect((await acknowledge(order.cashier, order.id)).statusCode).toBe(409);
    // The captain's request carries the new amount.
    expect((await captain.requestPickup(order.id, '24000')).json().error).toBe('amount_mismatch');
    expect((await captain.requestPickup(order.id, '14600')).statusCode).toBe(200);
    await switchOn(order.cashier);
  });

  it('sends a ready order back to preparing with the extra prep time, and moves the promised time', async () => {
    const order = await acceptedOrder();
    expect((await ready(order.cashier, order.id)).statusCode).toBe(200);
    const before = await times(order.id);
    const ops = await admin(['OPS']);
    const missing = await ops.edit(order.id, addFries);
    expect(missing.statusCode).toBe(400);
    expect(missing.json().error).toBe('invalid_edit');
    const preview = await ops.editPreview(order.id, { ...addFries, extraPrepMin: 10 });
    expect(preview.statusCode).toBe(200);
    expect(preview.json()).toMatchObject({
      before: {
        itemsValue: '24000',
        deliveryFee: '4000',
        commission: '3600',
        merchantNet: '20400',
      },
      after: {
        itemsValue: '43300',
        deliveryFee: '4000',
        commission: '6495',
        merchantNet: '36805',
      },
      addsItems: true,
      backToPreparing: true,
    });
    expect(await money(order.id)).toMatchObject({ items_value: '24000' });
    const answer = await ops.edit(order.id, { ...addFries, extraPrepMin: 10 });
    expect(answer.statusCode).toBe(200);
    const after = await times(order.id);
    expect(after.status).toBe('accepted');
    expect(moved(after.promised_at, before.promised_at)).toBeGreaterThanOrEqual(10);
    expect(moved(after.promised_at, before.promised_at)).toBeLessThan(15);
    expect(after.promised_at.getTime() % (5 * MINUTE)).toBe(0);
    const row = (
      await sql.query('SELECT ready_at, no_captain_alert_at FROM ordering.orders WHERE id = $1', [
        order.id,
      ])
    ).rows[0];
    expect(row).toEqual({ ready_at: null, no_captain_alert_at: null });
    // The restaurant's countdown runs 10 minutes from now.
    const card = await boardOrder(order.cashier, order.id);
    const due = new Date(card.acceptance.prepDueAt).getTime();
    expect(due - Date.now()).toBeGreaterThan(9 * MINUTE);
    expect(due - Date.now()).toBeLessThanOrEqual(11 * MINUTE);
    expect(card.edits[0].extraPrepMin).toBe(10);
    expect(await editRow(order.id)).toMatchObject({
      status: 'ready',
      extra_prep_min: 10,
      prep_min_before: 20,
    });
    expect(await outboxReason(order.id, 'order.edited')).toBe('items_added_back_to_preparing');
  });

  it('refuses what an edit cannot do', async () => {
    const order = await acceptedOrder();
    const ops = await admin(['OPS']);
    const refused = async (body: object) => {
      const answer = await ops.edit(order.id, body);
      expect(answer.statusCode).toBe(400);
      return answer.json().error;
    };
    const base = {
      keep: [{ position: 0, quantity: 2 }],
      add: [],
      deliveryFee: null,
      extraPrepMin: null,
    };
    // Nothing changed, no line left, an unknown or repeated line.
    expect(await refused(base)).toBe('invalid_edit');
    expect(await refused({ ...base, keep: [] })).toBe('invalid_edit');
    expect(await refused({ ...base, keep: [{ position: 7, quantity: 1 }] })).toBe('invalid_edit');
    expect(
      await refused({
        ...base,
        keep: [
          { position: 0, quantity: 1 },
          { position: 0, quantity: 2 },
        ],
      }),
    ).toBe('invalid_edit');
    // Extra prep time only for a ready order with items added.
    expect(await refused({ ...addFries, extraPrepMin: 10 })).toBe('invalid_edit');
    // An item the menu has switched off.
    const unavailable = await app.inject({
      method: 'PUT',
      url: '/v1/merchant/menu/availability',
      headers: order.cashier,
      payload: { type: 'item', id: soldOut, available: false, until: 'turned_back_on' },
    });
    expect(unavailable.statusCode).toBe(200);
    expect(await refused({ ...base, add: [{ itemId: soldOut, optionIds: [], quantity: 1 }] })).toBe(
      'invalid_edit',
    );
    // A role without operations.manage, and an ended order.
    expect((await (await admin(['FIN'])).edit(order.id, addFries)).statusCode).toBe(403);
    const placed = await placedOrder();
    expect((await ops.edit(placed.id, addFries)).statusCode).toBe(200);
    const cancelled = await ops.cancel(placed.id, {
      cancellation: 'emergency',
      responsible: 'platform',
      foodPrepared: false,
      compensateCaptain: false,
      cash: null,
      reason: 'ملاحظة',
    });
    expect(cancelled.statusCode).toBe(200);
    const late = await ops.edit(placed.id, addFries);
    expect(late.statusCode).toBe(409);
    expect(late.json().error).toBe('order_state_changed');
  });

  it('answers a repeat of the key once', async () => {
    const order = await acceptedOrder();
    const ops = await admin(['OPS']);
    const key = randomUUID();
    const body = { ...addFries, version: (await ops.detail(order.id)).version };
    expect((await ops.edit(order.id, body, key)).statusCode).toBe(200);
    expect((await ops.edit(order.id, body, key)).statusCode).toBe(200);
    const count = await sql.query(
      'SELECT count(*)::int AS n FROM ordering.order_edits WHERE order_id = $1',
      [order.id],
    );
    expect(count.rows[0].n).toBe(1);
    expect((await money(order.id)).items_value).toBe('43300');
  });

  it("lets the application role change only an edit's acknowledgement, and the panel shows the edit", async () => {
    const order = await acceptedOrder();
    const ops = await admin(['OPS']);
    expect((await ops.edit(order.id, addFries)).statusCode).toBe(200);
    await expect(
      sql.query("UPDATE ordering.order_edits SET changes = '[]' WHERE order_id = $1", [order.id]),
    ).rejects.toThrow(/permission denied/);
    const detail = await ops.detail(order.id);
    expect(detail.edits).toHaveLength(1);
    expect(detail.edits[0]).toMatchObject({ addsItems: true, acknowledgedAt: null });
    expect(detail.timeline.at(-1)).toMatchObject({ type: 'order.edited' });
    expect(detail.editChoices).toMatchObject({ extraPrepMaxMin: expect.any(Number) });
  });

  it('acknowledges only the edits the prompt showed; a newer addition keeps blocking', async () => {
    const { order, captain } = await captainAtRestaurant();
    const ops = await admin(['OPS']);
    expect((await ops.edit(order.id, addFries)).statusCode).toBe(200);
    const shown = (await boardOrder(order.cashier, order.id)).edits[0].at;
    const more = await ops.edit(order.id, {
      keep: [
        { position: 0, quantity: 3 },
        { position: 1, quantity: 2 },
      ],
      add: [],
      deliveryFee: null,
      extraPrepMin: null,
    });
    expect(more.statusCode).toBe(200);
    expect((await acknowledge(order.cashier, order.id, shown)).statusCode).toBe(200);
    const card = await boardOrder(order.cashier, order.id);
    expect(card.edits).toHaveLength(1);
    expect(card.edits[0].addsItems).toBe(true);
    expect((await captain.requestPickup(order.id, '50600')).json().error).toBe(
      'edit_unacknowledged',
    );
  });

  it('refuses an edit of an order that moved since the dialog showed it', async () => {
    const order = await acceptedOrder();
    const ops = await admin(['OPS']);
    const shown = (await ops.detail(order.id)).version;
    expect((await ops.edit(order.id, addFries)).statusCode).toBe(200);
    const stale = await app.inject({
      method: 'POST',
      url: `/v1/admin/orders/${order.id}/edit`,
      cookies: ops.cookies,
      headers: { 'idempotency-key': randomUUID() },
      payload: { ...addFries, keep: [{ position: 0, quantity: 1 }], version: shown, reason: 'x' },
    });
    expect(stale.statusCode).toBe(409);
    expect(stale.json().error).toBe('order_state_changed');
    expect((await money(order.id)).items_value).toBe('43300');
    const huge = await ops.edit(order.id, { ...addFries, deliveryFee: '9'.repeat(30) });
    expect(huge.statusCode).toBe(400);
  });

  it('answers unknown_order for an unknown order and for another restaurant', async () => {
    const ops = await admin(['OPS']);
    const unknown = randomUUID();
    expect((await ops.edit(unknown, addFries)).statusCode).toBe(404);
    expect((await ops.editPreview(unknown, addFries)).statusCode).toBe(404);
    const order = await acceptedOrder();
    expect((await ops.edit(order.id, addFries)).statusCode).toBe(200);
    const merchants = app.get(MerchantsService);
    const other = await merchants.createRestaurant(
      azaz,
      {
        nameAr: 'مطعم آخر',
        address: 'شارع آخر',
        location: centre,
        coverage: { kind: 'radius', radiusMetres: 1000 },
        minimumOrder: { amount: 10_000n, currency: 'TRY' },
        commissionBp: 1500,
        defaultPrepMin: 20,
      },
      change,
    );
    await merchants.setAccountStatus(other, 'active', change);
    const stranger = await acknowledge(await cashier(other), order.id, new Date().toISOString());
    expect(stranger.statusCode).toBe(404);
  });

  it('raises «المطعم لم يؤكد التعديل» after order.merchant_accept_alert_min', async () => {
    const order = await acceptedOrder();
    const ops = await admin(['OPS']);
    expect((await ops.edit(order.id, addFries)).statusCode).toBe(200);
    expect((await ops.detail(order.id)).alerts).not.toContain('edit_unacknowledged');
    const owner = new pg.Pool({ connectionString: database.migratorUrl });
    await owner.query(
      "UPDATE ordering.order_edits SET at = at - interval '4 minutes' WHERE order_id = $1",
      [order.id],
    );
    await owner.end();
    expect((await ops.detail(order.id)).alerts).toContain('edit_unacknowledged');
    expect((await acknowledge(order.cashier, order.id)).statusCode).toBe(200);
    expect((await ops.detail(order.id)).alerts).not.toContain('edit_unacknowledged');
  });

  it("moves the assigned captain's prep due time when a ready order goes back to preparing", async () => {
    const { order, captain, ops } = await captainAtRestaurant();
    expect((await ready(order.cashier, order.id)).statusCode).toBe(200);
    expect((await captain.active()).json().order.preparation.ready).toBe(true);
    expect((await ops.edit(order.id, { ...addFries, extraPrepMin: 15 })).statusCode).toBe(200);
    const preparation = (await captain.active()).json().order.preparation;
    expect(preparation.ready).toBe(false);
    expect(new Date(preparation.prepDueAt).getTime() - Date.now()).toBeGreaterThan(14 * MINUTE);
    expect((await customerOrder(order.customer, order.id)).edited).toBe(true);
  });
});

// About 55 m north of the customer's pin, inside the 200 m.
const atCustomer = { latitude: 36.5905, longitude: 37.046 };

// An order the captain picked up (two shawarma, 24000; fee 4000; total
// 28000), with the commands of the door.
async function pickedUpOrder(customer?: Record<string, string>) {
  const at = await captainAtRestaurant(customer);
  expect((await at.captain.requestPickup(at.order.id, '24000')).statusCode).toBe(200);
  const confirmed = await app.inject({
    method: 'POST',
    url: `/v1/merchant/orders/${at.order.id}/pickup/confirm`,
    headers: { ...at.order.cashier, 'idempotency-key': randomUUID() },
  });
  expect(confirmed.statusCode).toBe(200);
  const fix = () => ({
    ...atCustomer,
    accuracyMetres: 10,
    recordedAt: new Date().toISOString(),
    simulated: false,
  });
  const captainCommand = (path: string, payload: object) =>
    app.inject({
      method: 'POST',
      url: `/v1/captain/orders/${at.order.id}/${path}`,
      headers: { ...at.captain.headers, 'idempotency-key': randomUUID() },
      payload,
    });
  const arriveAtCustomer = () =>
    captainCommand('arrive-at-customer', { location: fix(), away: null });
  const deliver = (amount: string) =>
    captainCommand('deliver', {
      received: [{ currency: 'TRY', amount }],
      change: [],
      amountDue: { amount, currency: 'TRY' },
      shortfall: null,
      away: null,
      location: fix(),
    });
  return { ...at, arriveAtCustomer, deliver };
}

// The balances an order after the pickup moves, as the specs show them
// (the restaurant account − what it owes, earnings + what the captain is
// owed, the platform's revenue + and its costs +). The cases run in turn, so
// a delta is one order's.
async function balances(captainId: string | null = null) {
  const ledger = app.get(LedgerService);
  const platform = async (purpose: AccountPurpose) =>
    (
      await ledger.balance(
        await ledger.openAccount({ cityId: azaz, purpose, ownerId: null, currency: 'TRY' }),
      )
    ).amount;
  const owned = async (ownerId: string, purpose: AccountPurpose) => {
    const account = (await ledger.ownerAccounts(azaz, ownerId, purpose)).find(
      (each) => each.currency === 'TRY',
    );
    return account ? (await ledger.balance(account.id)).amount : 0n;
  };
  return {
    clearing: await platform('platform.order_clearing'),
    commission: await platform('platform.revenue_commission'),
    delivery: await platform('platform.revenue_delivery'),
    operatingCost: await platform('platform.operating_cost'),
    restaurant: await owned(restaurant, 'merchant.account'),
    earnings: captainId === null ? 0n : await owned(captainId, 'captain.earnings'),
    captainPay: await platform('platform.captain_pay'),
  };
}

// AP §8.8: what a customer owes, from their dues account.
async function duesOf(customerAccountId: string) {
  const ledger = app.get(LedgerService);
  const [account] = await ledger.ownerAccounts(azaz, customerAccountId, 'customer.dues');
  return account ? (await ledger.balance(account.id)).amount : 0n;
}

type Balances = Awaited<ReturnType<typeof balances>>;

const moneyMoved = (before: Balances, after: Balances) =>
  Object.fromEntries(
    (Object.keys(before) as (keyof Balances)[]).map((key) => [key, after[key] - before[key]]),
  );

// One shawarma of the two removed: 12000 out; commission 15%.
const oneShawarma = {
  keep: [{ position: 0, quantity: 1 }],
  add: [],
  deliveryFee: null,
  extraPrepMin: null,
};

// The captain's order pay on these short trips (the pay table's minimum).
const ORDER_PAY = 2_500n;

describe('POST /v1/admin/orders/{orderId}/edit after the pickup (AP §9.3.3)', () => {
  it('books a removal with the restaurant responsible: the value returned, its commission reversed', async () => {
    const before = await balances();
    const order = await pickedUpOrder();
    const preview = await order.ops.editPreview(order.order.id, {
      ...oneShawarma,
      responsible: 'restaurant',
    });
    expect(preview.statusCode).toBe(200);
    expect(preview.json()).toMatchObject({ afterPickup: true, addsItems: false });
    expect(
      preview
        .json()
        .entries.map((entry: { type: string; account: string; amount: { amount: string } }) => [
          entry.type,
          entry.account,
          entry.amount.amount,
        ]),
    ).toEqual([
      ['merchant.debit', 'merchant.account', '12000'],
      ['merchant.debit', 'platform.order_clearing', '-12000'],
      ['merchant.commission', 'merchant.account', '-1800'],
      ['merchant.commission', 'platform.revenue_commission', '1800'],
    ]);
    const answer = await order.ops.edit(order.order.id, {
      ...oneShawarma,
      responsible: 'restaurant',
    });
    expect(answer.statusCode).toBe(200);
    expect(await money(order.order.id)).toMatchObject({ items_value: '12000', total: '16000' });
    expect(await editRow(order.order.id)).toMatchObject({
      status: 'picked_up',
      responsible: 'restaurant',
      charge: '12000',
      commission_cut: '1800',
    });
    expect(await outboxReason(order.order.id, 'order.edited')).toBe('removed_after_pickup');
    // The panel: what the captain paid stays, and the edit names its party.
    const detail = await order.ops.detail(order.order.id);
    expect(detail.money.pickupPayment).toBe('24000');
    expect(detail.edits.at(-1)).toMatchObject({ responsible: 'restaurant', charge: '12000' });
    expect(detail.editChoices).toMatchObject({ afterPickup: true, items: [] });
    // The restaurant's prompt is for edits before the pickup only.
    expect((await board(order.order.cashier, order.order.id)).edits).toEqual([]);
    // The captain collects the new total, and the clearing account settles.
    expect((await order.captain.active()).json().order.collect.amount).toBe('16000');
    expect((await order.arriveAtCustomer()).statusCode).toBe(200);
    expect((await order.deliver('16000')).statusCode).toBe(200);
    expect(moneyMoved(before, await balances())).toMatchObject({
      clearing: 0n,
      // The restaurant returns 12000 and pays the commission on what it kept.
      restaurant: -(12_000n + 1_800n),
      commission: 1_800n,
      delivery: 4_000n,
      operatingCost: 0n,
    });
  });

  it('charges the captain the merchant net and a lower fee, and the commission recovers the rest', async () => {
    const before = await balances();
    const order = await pickedUpOrder();
    expect((await order.arriveAtCustomer()).statusCode).toBe(200);
    const answer = await order.ops.edit(order.order.id, {
      ...oneShawarma,
      deliveryFee: '2000',
      responsible: 'captain',
    });
    expect(answer.statusCode).toBe(200);
    expect(await money(order.order.id)).toMatchObject({
      items_value: '12000',
      delivery_fee: '2000',
      total: '14000',
    });
    expect(await editRow(order.order.id)).toMatchObject({
      status: 'arrived',
      responsible: 'captain',
      // 12000 − 1800 of merchant net, and the 2000 off the fee.
      charge: '12200',
      commission_cut: '1800',
    });
    expect(await outboxReason(order.order.id, 'order.edited')).toBe('removed_after_pickup');
    expect((await order.deliver('14000')).statusCode).toBe(200);
    expect(moneyMoved(before, await balances(order.captain.captainId))).toMatchObject({
      clearing: 0n,
      earnings: ORDER_PAY - 12_200n,
      // The restaurant was paid in full: it owes the commission on all
      // 24000, of which the removed items' 1800 recovers the pickup payment.
      restaurant: -3_600n,
      commission: 1_800n,
      // The fee at the pickup is the platform's revenue; the captain bore the cut.
      delivery: 4_000n,
      operatingCost: 0n,
    });
  });

  it('books a lower fee alone on the platform as an operating cost', async () => {
    const before = await balances();
    const order = await pickedUpOrder();
    const answer = await order.ops.edit(order.order.id, {
      keep: [{ position: 0, quantity: 2 }],
      add: [],
      deliveryFee: '1000',
      extraPrepMin: null,
      responsible: 'platform',
    });
    expect(answer.statusCode).toBe(200);
    expect(await outboxReason(order.order.id, 'order.edited')).toBe('fee_lowered_after_pickup');
    expect(await money(order.order.id)).toMatchObject({ total: '25000' });
    expect((await order.arriveAtCustomer()).statusCode).toBe(200);
    expect((await order.deliver('25000')).statusCode).toBe(200);
    expect(moneyMoved(before, await balances())).toMatchObject({
      clearing: 0n,
      operatingCost: 3_000n,
      restaurant: -3_600n,
      commission: 3_600n,
      delivery: 4_000n,
    });
  });

  it('settles several edits with different parties, and previews the frozen commission', async () => {
    const before = await balances();
    const order = await pickedUpOrder();
    expect(
      (await order.ops.edit(order.order.id, { ...oneShawarma, responsible: 'restaurant' }))
        .statusCode,
    ).toBe(200);
    const lowerFee = {
      keep: [{ position: 0, quantity: 1 }],
      add: [],
      deliveryFee: '1000',
      extraPrepMin: null,
      responsible: 'captain',
    };
    // The restaurant already gave back 12000 and its commission on them: it
    // owes 1800 and keeps 10200, and the captain's fee cut changes neither.
    const preview = (await order.ops.editPreview(order.order.id, lowerFee)).json();
    expect(preview.before).toMatchObject({ commission: '1800', merchantNet: '10200' });
    expect(preview.after).toMatchObject({ commission: '1800', merchantNet: '10200' });
    expect(preview.entries.map((entry: { reason: string }) => entry.reason)).toEqual([
      'خُفّضت أجرة التوصيل بعد الاستلام',
      'خُفّضت أجرة التوصيل بعد الاستلام',
    ]);
    expect((await order.ops.edit(order.order.id, lowerFee)).statusCode).toBe(200);
    expect(await money(order.order.id)).toMatchObject({ total: '13000' });
    expect((await order.arriveAtCustomer()).statusCode).toBe(200);
    expect((await order.deliver('13000')).statusCode).toBe(200);
    expect(moneyMoved(before, await balances(order.captain.captainId))).toMatchObject({
      clearing: 0n,
      restaurant: -(12_000n + 3_600n - 1_800n),
      earnings: ORDER_PAY - 3_000n,
      commission: 1_800n,
      delivery: 4_000n,
    });
  });

  it('previews a captain-responsible removal with the commission left on the restaurant', async () => {
    const order = await pickedUpOrder();
    const preview = (
      await order.ops.editPreview(order.order.id, { ...oneShawarma, responsible: 'captain' })
    ).json();
    expect(preview.before).toMatchObject({ commission: '3600', merchantNet: '20400' });
    expect(preview.after).toMatchObject({ commission: '3600', merchantNet: '20400' });
    expect(preview.entries[0]).toMatchObject({
      type: 'earn.charge',
      reason: 'أصناف حُذفت بعد الاستلام',
      account: 'captain.earnings',
      party: { kind: 'captain', name: 'كابتن التعديل' },
      amount: { amount: '10200', currency: 'TRY' },
    });
    // A dialog shown before the order moved is refused as such.
    const stale = await order.ops.edit(order.order.id, {
      ...oneShawarma,
      responsible: 'captain',
      version: (await order.ops.detail(order.order.id)).version - 1,
    });
    expect(stale.statusCode).toBe(409);
    expect(stale.json().error).toBe('order_state_changed');
  });

  it('refuses what an edit after the pickup cannot do', async () => {
    const order = await pickedUpOrder();
    const refused = async (body: object, status = 400) => {
      const answer = await order.ops.edit(order.order.id, body);
      expect(answer.statusCode).toBe(status);
      return answer.json().error;
    };
    // No responsible party, or the customer.
    expect(await refused(oneShawarma)).toBe('invalid_edit');
    await refused({ ...oneShawarma, responsible: 'customer' });
    // Additions, a raised quantity and a higher fee.
    expect(await refused({ ...addFries, responsible: 'platform' })).toBe('invalid_edit');
    expect(
      await refused({
        keep: [{ position: 0, quantity: 3 }],
        add: [],
        deliveryFee: null,
        extraPrepMin: null,
        responsible: 'platform',
      }),
    ).toBe('invalid_edit');
    expect(await refused({ ...oneShawarma, deliveryFee: '5000', responsible: 'platform' })).toBe(
      'invalid_edit',
    );
    expect(await editRow(order.order.id)).toBeUndefined();
    // Before the pickup, a responsible party is refused.
    const accepted = await acceptedOrder();
    const before = await order.ops.edit(accepted.id, { ...addFries, responsible: 'restaurant' });
    expect(before.statusCode).toBe(400);
    expect(before.json().error).toBe('invalid_edit');
  });
});

const outcomeRow = async (orderId: string) =>
  (await sql.query('SELECT * FROM ordering.order_outcomes WHERE order_id = $1', [orderId])).rows[0];

const orderRow = async (orderId: string) =>
  (
    await sql.query(
      'SELECT status, outcome, captain_track, customer_account_id, delivered_at FROM ordering.orders WHERE id = $1',
      [orderId],
    )
  ).rows[0];

type PreviewEntry = { type: string; account: string; amount: { amount: string } };
const previewLines = (entries: PreviewEntry[]) =>
  entries.map((entry) => [entry.type, entry.account, entry.amount.amount]);

// The order of pickedUpOrder: items 24000, fee 4000, commission 15 % 3600,
// merchant net 20400; the captain's pay 2500.
describe('POST /v1/admin/orders/{orderId}/outcome (AP §9.3.2, §8.9)', () => {
  const fake = {
    outcome: 'fake',
    responsible: 'customer',
    delivered: false,
    food: 'kept_by_captain',
  };

  it('fails a fake order: the entries match the preview, and the customer owes and is blocked', async () => {
    const before = await balances();
    const order = await pickedUpOrder();
    expect((await order.arriveAtCustomer()).statusCode).toBe(200);
    const preview = await order.ops.outcomePreview(order.order.id, fake);
    expect(preview.statusCode).toBe(200);
    const expected = [
      ['merchant.commission', 'merchant.account', '3600'],
      ['merchant.commission', 'platform.order_clearing', '-3600'],
      ['dues.charge', 'customer.dues', '24400'],
      ['dues.charge', 'platform.order_clearing', '-20400'],
      ['dues.charge', 'platform.revenue_delivery', '-4000'],
      ['earn.order_pay', 'captain.earnings', '-2500'],
      ['earn.order_pay', 'platform.captain_pay', '2500'],
    ];
    expect(previewLines(preview.json().entries)).toEqual(expected);
    expect(preview.json()).toMatchObject({
      status: 'failed',
      loss: { amount: '20400' },
      dues: { amount: '24400' },
      captainPay: { amount: '2500' },
    });
    const key = randomUUID();
    const shownVersion = (await order.ops.detail(order.order.id)).version;
    const answer = await order.ops.outcome(order.order.id, { ...fake, version: shownVersion }, key);
    expect(answer.statusCode).toBe(200);
    const row = await orderRow(order.order.id);
    expect(row).toMatchObject({ status: 'failed', outcome: 'fake', captain_track: 'done' });
    expect(await outcomeRow(order.order.id)).toMatchObject({
      outcome: 'fake',
      responsible: 'customer',
      status: 'failed',
      food: 'kept_by_captain',
      loss: '20400',
      dues: '24400',
      merchant_debit: null,
      captain_pay: '2500',
      customer_text: 'لم يُستلم الطلب',
      note: 'اتصلنا بالزبون',
    });
    // AP §8.4's check: the platform recovers its costs, without its margin.
    expect(moneyMoved(before, await balances(order.captain.captainId))).toMatchObject({
      clearing: 0n,
      restaurant: -3_600n,
      commission: 0n,
      delivery: 4_000n,
      captainPay: 2_500n,
      earnings: 2_500n,
    });
    expect(await duesOf(row.customer_account_id)).toBe(24_400n);
    expect(await outboxReason(order.order.id, 'order.outcome_set')).toBe('fake');
    // The customer: «تعذّر التسليم» with the reason, then blocked at checkout.
    expect((await customerOrder(order.order.customer, order.order.id)).outcome).toMatchObject({
      outcome: 'fake',
      status: 'failed',
      text: 'لم يُستلم الطلب',
      amountToCollect: { amount: '0', currency: 'TRY' },
    });
    const quote = (await quoteFor(order.order.customer)).json();
    expect(quote.problems).toContainEqual({
      code: 'dues_unpaid',
      line: null,
      opensAt: null,
      message: null,
      amount: { amount: '24400', currency: 'TRY' },
    });
    // The captain is free, with the card until «حسناً».
    const active = (await order.captain.active()).json();
    expect(active.order).toBeNull();
    expect(active.ended).toMatchObject({
      orderId: order.order.id,
      outcome: 'fake',
      status: 'failed',
      food: 'kept_by_captain',
      pay: { amount: '2500', currency: 'TRY' },
      charge: null,
    });
    const seen = await app.inject({
      method: 'POST',
      url: `/v1/captain/orders/${order.order.id}/acknowledge-outcome`,
      headers: order.captain.headers,
    });
    expect(seen.statusCode).toBe(200);
    expect(seen.json().ended).toBeNull();
    // The panel's detail.
    const detail = await order.ops.detail(order.order.id);
    expect(detail.outcome).toMatchObject({
      outcome: 'fake',
      responsible: 'customer',
      dues: { amount: '24400' },
      customerText: 'لم يُستلم الطلب',
    });
    expect(detail.outcomeChoices).toBeNull();
    // A repeat of the key answers the same; another outcome is refused.
    const repeat = await order.ops.outcome(order.order.id, { ...fake, version: shownVersion }, key);
    expect(repeat.statusCode).toBe(200);
    expect(repeat.json().order.status).toBe('failed');
    expect((await order.ops.outcome(order.order.id, fake)).statusCode).toBe(409);
    // «حسناً» on another captain's order, or one without an outcome.
    const other = await onlineCaptain();
    const foreign = await app.inject({
      method: 'POST',
      url: `/v1/captain/orders/${order.order.id}/acknowledge-outcome`,
      headers: other.headers,
    });
    expect(foreign.statusCode).toBe(404);
  });

  it('refuses «حسناً» on an order without an outcome', async () => {
    const order = await pickedUpOrder();
    const early = await app.inject({
      method: 'POST',
      url: `/v1/captain/orders/${order.order.id}/acknowledge-outcome`,
      headers: order.captain.headers,
    });
    expect(early.statusCode).toBe(409);
    expect(early.json().error).toBe('order_state_changed');
  });

  it('refuses an outcome previewed on an older version of the order', async () => {
    const order = await pickedUpOrder();
    const stale = (await order.ops.detail(order.order.id)).version;
    expect(
      (await order.ops.edit(order.order.id, { ...oneShawarma, responsible: 'platform' }))
        .statusCode,
    ).toBe(200);
    const answer = await order.ops.outcome(order.order.id, { ...fake, version: stale });
    expect(answer.statusCode).toBe(409);
    expect(answer.json().error).toBe('order_state_changed');
    expect(await outcomeRow(order.order.id)).toBeUndefined();
  });

  // docs/domain/08: a fake outcome removes the trust and starts the count
  // again (D23).
  it('removes the trust of a customer with a fake order', async () => {
    const settings = app.get(SettingsService);
    await settings.update('customer.trusted_after_delivered_orders', { cityId: azaz }, 1, bySystem);
    try {
      const first = await pickedUpOrder();
      expect((await first.arriveAtCustomer()).statusCode).toBe(200);
      expect((await first.deliver('28000')).statusCode).toBe(200);
      const customerId = (await orderRow(first.order.id)).customer_account_id;
      const limit = async () =>
        app.get(ActiveOrders).customer(customerId, await app.get(ActiveOrders).rules(azaz));
      expect((await limit()).trusted).toBe(true);
      const second = await pickedUpOrder(first.order.customer);
      expect((await second.ops.outcome(second.order.id, fake)).statusCode).toBe(200);
      expect((await limit()).trusted).toBe(false);
    } finally {
      await settings.update(
        'customer.trusted_after_delivered_orders',
        { cityId: azaz },
        3,
        bySystem,
      );
    }
  });

  it('has the restaurant return the pickup payment, and the food go back to it', async () => {
    const before = await balances();
    const order = await pickedUpOrder();
    const choices = {
      outcome: 'wrong_refused',
      responsible: 'restaurant',
      delivered: false,
      food: 'returned_to_restaurant',
    };
    const preview = await order.ops.outcomePreview(order.order.id, choices);
    expect(previewLines(preview.json().entries)).toEqual([
      ['merchant.debit', 'merchant.account', '24000'],
      ['merchant.debit', 'platform.order_clearing', '-24000'],
      ['earn.order_pay', 'captain.earnings', '-2500'],
      ['earn.order_pay', 'platform.operating_cost', '2500'],
    ]);
    expect(preview.json().entries[0].reason).toBe('استرداد مبلغ الاستلام');
    expect((await order.ops.outcome(order.order.id, choices)).statusCode).toBe(200);
    expect(moneyMoved(before, await balances())).toMatchObject({
      clearing: 0n,
      restaurant: -24_000n,
      commission: 0n,
      operatingCost: 2_500n,
    });
    expect(await outcomeRow(order.order.id)).toMatchObject({ merchant_debit: '24000', loss: '0' });
  });

  it('counts an edit after the pickup: nobody pays twice (owner decision 2026-11-10)', async () => {
    const before = await balances();
    const order = await pickedUpOrder();
    expect(
      (await order.ops.edit(order.order.id, { ...oneShawarma, responsible: 'restaurant' }))
        .statusCode,
    ).toBe(200);
    const choices = {
      outcome: 'failed_other',
      responsible: 'restaurant',
      delivered: false,
      food: 'destroyed',
    };
    expect((await order.ops.outcome(order.order.id, choices)).statusCode).toBe(200);
    // The edit debited 12000 and reversed 1800; the outcome returns the
    // other 12000 and restores the 1800: the restaurant ends with nothing.
    expect(moneyMoved(before, await balances())).toMatchObject({
      clearing: 0n,
      restaurant: -24_000n,
      commission: 0n,
    });
  });

  it('delivers a free order with the platform bearing the loss and the pay', async () => {
    const before = await balances();
    const order = await pickedUpOrder();
    const choices = { outcome: 'free', responsible: 'platform', delivered: true, food: null };
    expect((await order.ops.outcome(order.order.id, choices)).statusCode).toBe(200);
    const row = await orderRow(order.order.id);
    expect(row).toMatchObject({ status: 'delivered', outcome: 'free' });
    expect(row.delivered_at).not.toBeNull();
    expect(moneyMoved(before, await balances())).toMatchObject({
      clearing: 0n,
      restaurant: -3_600n,
      operatingCost: 20_400n + 2_500n,
    });
    const seen = await customerOrder(order.order.customer, order.order.id);
    expect(seen.status).toBe('delivered');
    expect(seen.outcome).toMatchObject({ outcome: 'free', status: 'delivered', text: null });
  });

  it('charges the captain the loss without pay when the captain is responsible', async () => {
    // A new captain's earnings start at 0.
    const before = await balances();
    const order = await pickedUpOrder();
    const choices = {
      outcome: 'damaged',
      responsible: 'captain',
      delivered: false,
      food: 'destroyed',
    };
    expect((await order.ops.outcome(order.order.id, choices)).statusCode).toBe(200);
    expect(moneyMoved(before, await balances(order.captain.captainId))).toMatchObject({
      clearing: 0n,
      earnings: -20_400n,
      restaurant: -3_600n,
    });
    expect((await order.captain.active()).json().ended).toMatchObject({
      pay: null,
      charge: { amount: '20400', currency: 'TRY' },
    });
  });

  it('refuses choices that do not fit, and an order not picked up', async () => {
    const order = await pickedUpOrder();
    const refused = async (body: object) => {
      const answer = await order.ops.outcome(order.order.id, body);
      expect(answer.statusCode).toBe(400);
      return answer.json().error;
    };
    expect(await refused({ ...fake, responsible: 'platform' })).toBe('invalid_outcome');
    expect(await refused({ ...fake, outcome: 'failed_other' })).toBe('invalid_outcome');
    expect(
      await refused({
        ...fake,
        outcome: 'failed_other',
        responsible: 'captain',
        food: 'returned_to_restaurant',
      }),
    ).toBe('invalid_outcome');
    expect(await outcomeRow(order.order.id)).toBeUndefined();
    expect((await order.ops.detail(order.order.id)).outcomeChoices.foods).toEqual([
      { code: 'kept_by_captain', label: 'يبقى مع الكابتن' },
      { code: 'returned_to_restaurant', label: 'أُعيد إلى المطعم' },
      { code: 'destroyed', label: 'أُتلف' },
    ]);
    const accepted = await acceptedOrder();
    const early = await order.ops.outcome(accepted.id, fake);
    expect(early.statusCode).toBe(409);
    expect(early.json().error).toBe('order_state_changed');
    // SUP cannot set an outcome.
    const sup = await admin(['SUP']);
    expect((await sup.outcome(order.order.id, fake)).statusCode).toBe(403);
  });
});
