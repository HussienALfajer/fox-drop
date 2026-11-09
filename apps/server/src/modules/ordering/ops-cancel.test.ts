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
import { CustomersService } from '../customers/index.js';
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

// AP §9.3.2 «إلغاء الطلب», AP §8.1, docs/domain/01, 08, 09; RA §8.14, §18;
// CA §9.10 (slice 2.8b): operations cancel a placed, accepted or ready order
// with a reason of Content's ops_cancel list, the responsible party, whether
// food was prepared, the captain's compensation and the cash question; the
// entries, the strike, the restaurant's «حسناً» and the captain's card.

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

const board = async (headers: Record<string, string>, orderId: string) =>
  (await app.inject({ method: 'GET', url: '/v1/merchant/orders', headers }))
    .json()
    .orders.find((entry: { id: string }) => entry.id === orderId);

const acknowledge = (headers: Record<string, string>, orderId: string, key = randomUUID()) =>
  app.inject({
    method: 'POST',
    url: `/v1/merchant/orders/${orderId}/acknowledge-cancellation`,
    headers: { ...headers, 'idempotency-key': key },
  });

async function balance(purpose: AccountPurpose, ownerId: string | null): Promise<bigint> {
  const ledger = app.get(LedgerService);
  if (ownerId === null) {
    const id = await ledger.openAccount({ cityId: azaz, purpose, ownerId, currency: 'TRY' });
    return (await ledger.balance(id)).amount;
  }
  const [account] = await ledger.ownerAccounts(azaz, ownerId, purpose);
  return account ? (await ledger.balance(account.id)).amount : 0n;
}

const row = async (orderId: string) =>
  (
    await sql.query(
      `SELECT status, cancel_reason, cancel_reason_label, cancel_customer_text, food_prepared,
              cancel_responsible, cancel_cash, cancel_merchant_credit, cancel_captain_compensation,
              cancel_acknowledged_at, cancel_acknowledged_device, cancel_captain_seen_at, captain_id
         FROM ordering.orders WHERE id = $1`,
      [orderId],
    )
  ).rows[0];

const events = async (orderId: string) =>
  (
    await sql.query(
      'SELECT type, actor_type, reason FROM ordering.order_events WHERE order_id = $1 ORDER BY version',
      [orderId],
    )
  ).rows;

const outboxReason = async (orderId: string, type: string) =>
  (
    await sql.query(
      "SELECT payload->>'reason' AS reason FROM ordering.outbox WHERE order_id = $1 AND type = $2",
      [orderId, type],
    )
  ).rows[0]?.reason;

const plain = {
  cancellation: 'emergency',
  responsible: 'platform',
  foodPrepared: false,
  compensateCaptain: false,
  cash: null,
  reason: 'ملاحظة العمليات',
};

describe('POST /v1/admin/orders/{orderId}/cancel (AP §9.3.2)', () => {
  it('cancels an accepted order, credits the prepared food and keeps the note internal', async () => {
    const order = await acceptedOrder();
    const ops = await admin(['OPS']);
    const merchantBefore = await balance('merchant.account', restaurant);
    const body = { ...plain, foodPrepared: true };
    const preview = await ops.preview(order.id, {
      cancellation: 'emergency',
      responsible: 'platform',
      foodPrepared: true,
      compensateCaptain: false,
      cash: null,
    });
    expect(preview.statusCode).toBe(200);
    expect(preview.json()).toMatchObject({
      cashAsked: false,
      compensationAllowed: false,
      cashLines: null,
      entries: [
        {
          type: 'merchant.credit',
          account: 'merchant.account',
          party: { kind: 'merchant', id: restaurant, name: 'مطعم الإلغاء' },
          amount: { amount: '-20400', currency: 'TRY' },
        },
        { type: 'merchant.credit', account: 'platform.order_clearing' },
        { type: 'platform.operating_cost', account: 'platform.operating_cost' },
        { type: 'platform.operating_cost', account: 'platform.order_clearing' },
      ],
    });
    const answer = await ops.cancel(order.id, body);
    expect(answer.statusCode).toBe(200);
    expect(answer.json().order.status).toBe('cancelled');
    expect(await row(order.id)).toMatchObject({
      status: 'cancelled',
      cancel_reason: 'emergency',
      cancel_reason_label: 'ظرف طارئ',
      cancel_customer_text: 'ظرف طارئ منعنا من إكمال طلبك',
      food_prepared: true,
      cancel_responsible: 'platform',
      cancel_cash: null,
      cancel_merchant_credit: '20400',
      cancel_captain_compensation: null,
    });
    expect((await balance('merchant.account', restaurant)) - merchantBefore).toBe(20_400n);
    expect((await events(order.id)).at(-1)).toEqual({
      type: 'order.cancelled',
      actor_type: 'admin',
      reason: 'ملاحظة العمليات',
    });
    expect(await outboxReason(order.id, 'order.cancelled')).toBe('emergency');
    const audit = await sql.query(
      "SELECT reason, changes FROM audit.events WHERE target_id = $1 AND action = 'order.cancel'",
      [order.id],
    );
    expect(audit.rows[0].reason).toBe('ملاحظة العمليات');
    // The customer's order shows the reason's customer text.
    const mine = await app.inject({
      method: 'GET',
      url: `/v1/customer/orders/${order.id}`,
      headers: order.customer,
    });
    expect(mine.json().order.cancellation).toMatchObject({
      reason: 'emergency',
      text: 'ظرف طارئ منعنا من إكمال طلبك',
    });
  });

  it('keeps the order on the board, ringing, until «حسناً» on any device (RA §8.14, §18)', async () => {
    const order = await acceptedOrder();
    const ops = await admin(['OPS']);
    expect((await ops.cancel(order.id, plain)).statusCode).toBe(200);
    const shown = await board(order.cashier, order.id);
    expect(shown).toMatchObject({
      status: 'cancelled',
      cancellation: { reason: 'emergency', label: 'ظرف طارئ', byOperations: true },
    });
    expect(Object.keys(shown.cancellation).sort()).toEqual(
      ['at', 'byOperations', 'label', 'reason'].sort(),
    );
    const other = await cashier();
    const key = randomUUID();
    const first = await acknowledge(other, order.id, key);
    expect(first.statusCode).toBe(200);
    expect(first.json().order.id).toBe(order.id);
    // Acknowledged, the order rings no more.
    expect(first.json().order.cancellation).toBeNull();
    expect(await board(order.cashier, order.id)).toBeUndefined();
    const stored = await row(order.id);
    expect(stored.cancel_acknowledged_at).not.toBeNull();
    expect(stored.cancel_acknowledged_device).not.toBeNull();
    expect((await events(order.id)).at(-1)).toMatchObject({
      type: 'order.cancellation_acknowledged',
      actor_type: 'restaurant',
    });
    // Another device's «حسناً» after it answers quietly.
    expect((await acknowledge(order.cashier, order.id)).statusCode).toBe(200);
    expect((await acknowledge(other, order.id, key)).statusCode).toBe(200);
    expect((await events(order.id)).filter((e) => e.type.includes('acknowledged'))).toHaveLength(1);
  });

  it('refuses «حسناً» on an order operations did not cancel after acceptance', async () => {
    const order = await acceptedOrder();
    const answer = await acknowledge(order.cashier, order.id);
    expect(answer.statusCode).toBe(409);
    expect(answer.json().error).toBe('order_state_changed');
  });

  it('cancels a placed order without strike or entries, and refuses food prepared on it', async () => {
    const order = await placedOrder();
    const ops = await admin(['OPS']);
    const refused = await ops.cancel(order.id, { ...plain, foodPrepared: true });
    expect(refused.statusCode).toBe(400);
    expect(refused.json().error).toBe('invalid_cancellation');
    const unknown = await ops.cancel(order.id, { ...plain, cancellation: 'nope' });
    expect(unknown.statusCode).toBe(400);
    expect(unknown.json().error).toBe('unknown_reason');
    expect((await ops.cancel(order.id, { ...plain, responsible: 'customer' })).statusCode).toBe(
      200,
    );
    expect(await row(order.id)).toMatchObject({
      status: 'cancelled',
      cancel_merchant_credit: null,
    });
    const strikes = await sql.query(
      'SELECT count(*)::int AS n FROM customers.late_cancel_strikes WHERE order_id = $1',
      [order.id],
    );
    expect(strikes.rows[0].n).toBe(0);
    // A placed order never rang for «حسناً»: it leaves the board.
    expect(await board(await cashier(), order.id)).toBeUndefined();
  });

  it('answers a repeat of the key with the card, and a cancelled order with order_state_changed', async () => {
    const order = await acceptedOrder();
    const ops = await admin(['OPS']);
    const key = randomUUID();
    expect((await ops.cancel(order.id, plain, key)).statusCode).toBe(200);
    expect((await ops.cancel(order.id, plain, key)).statusCode).toBe(200);
    const again = await ops.cancel(order.id, plain);
    expect(again.statusCode).toBe(409);
    expect(again.json()).toMatchObject({
      error: 'order_state_changed',
      order: { status: 'cancelled' },
    });
  });

  it('withdraws an open offer before the cancellation (CA §9.10)', async () => {
    const settings = app.get(SettingsService);
    await settings.update(
      'dispatch.manual_assign_requires_accept',
      { cityId: azaz },
      true,
      bySystem,
    );
    try {
      const order = await acceptedOrder();
      const captain = await onlineCaptain();
      const ops = await admin(['OPS']);
      expect((await ops.assign(order.id, captain.captainId)).statusCode).toBe(200);
      expect((await ops.cancel(order.id, plain)).statusCode).toBe(200);
      const offer = await sql.query('SELECT status FROM dispatch.offers WHERE order_id = $1', [
        order.id,
      ]);
      expect(offer.rows[0].status).toBe('withdrawn');
      expect((await events(order.id)).slice(-2).map((event) => event.type)).toEqual([
        'order.offer_closed',
        'order.cancelled',
      ]);
      // An offered captain gets no cancellation card.
      expect((await captain.active()).json().cancelled).toBeNull();
    } finally {
      await settings.update(
        'dispatch.manual_assign_requires_accept',
        { cityId: azaz },
        false,
        bySystem,
      );
    }
  });
});

describe('the captain at the restaurant (AP §8.1, CA §9.10)', () => {
  it('asks the cash question once the captain arrived', async () => {
    const { order, ops } = await captainAtRestaurant();
    const missing = await ops.cancel(order.id, plain);
    expect(missing.statusCode).toBe(409);
    expect(missing.json()).toMatchObject({
      error: 'cash_answer_required',
      order: { id: order.id },
    });
    const preview = await ops.preview(order.id, { ...plain, cash: 'returned', reason: undefined });
    expect(preview.json()).toMatchObject({
      cashAsked: true,
      compensationAllowed: true,
      cashLines: [{ amount: '24000', currency: 'TRY' }],
    });
    // The dialog previews before the cash question is answered: the preview
    // says which questions to ask instead of refusing.
    const unanswered = await ops.preview(order.id, { ...plain, reason: undefined });
    expect(unanswered.statusCode).toBe(200);
    expect(unanswered.json()).toMatchObject({
      cashAsked: true,
      compensationAllowed: true,
      cashLines: [{ amount: '24000', currency: 'TRY' }],
      entries: [],
    });
  });

  it('previews a compensation or a cash answer before the arrival without them', async () => {
    const order = await acceptedOrder();
    const ops = await admin(['OPS']);
    const preview = await ops.preview(order.id, {
      ...plain,
      compensateCaptain: true,
      cash: 'not_returned',
      reason: undefined,
    });
    expect(preview.statusCode).toBe(200);
    expect(preview.json()).toEqual({
      cashAsked: false,
      compensationAllowed: false,
      cashLines: null,
      entries: [],
      strike: false,
    });
  });

  it('refuses a cash answer or a compensation before the captain arrived', async () => {
    const order = await acceptedOrder();
    const ops = await admin(['OPS']);
    const cash = await ops.cancel(order.id, { ...plain, cash: 'returned' });
    expect(cash.statusCode).toBe(409);
    expect(cash.json().error).toBe('cash_answer_not_allowed');
    const pay = await ops.cancel(order.id, { ...plain, compensateCaptain: true });
    expect(pay.statusCode).toBe(409);
    expect(pay.json().error).toBe('compensation_not_allowed');
  });

  it('voids the open request, books the kept payment and the compensation, and frees the captain', async () => {
    const { order, captain, ops } = await captainAtRestaurant();
    expect((await captain.requestPickup(order.id, '24000')).statusCode).toBe(200);
    const custodyBefore = await balance('captain.custody', captain.captainId);
    const merchantBefore = await balance('merchant.account', restaurant);
    const earningsBefore = await balance('captain.earnings', captain.captainId);
    const clearingBefore = await balance('platform.order_clearing', null);
    const answer = await ops.cancel(order.id, {
      ...plain,
      responsible: 'restaurant',
      compensateCaptain: true,
      cash: 'not_returned',
    });
    expect(answer.statusCode).toBe(200);
    // docs/domain/02: the voided request returns the track to at_merchant,
    // which the cancellation publishes.
    const track = await sql.query(
      `SELECT o.captain_track AS stored, x.payload->>'captainTrack' AS published
         FROM ordering.orders o
         JOIN ordering.outbox x ON x.order_id = o.id AND x.type = 'order.cancelled'
        WHERE o.id = $1`,
      [order.id],
    );
    expect(track.rows[0]).toEqual({ stored: 'at_merchant', published: 'at_merchant' });
    // RA §8.9: a cancelled order on the board has no captain waiting.
    expect(await board(order.cashier, order.id)).toMatchObject({
      status: 'cancelled',
      captainArrival: null,
    });
    const request = await sql.query(
      'SELECT status, outcome, closed_by_type FROM ordering.pickup_requests WHERE order_id = $1',
      [order.id],
    );
    expect(request.rows[0]).toEqual({
      status: 'voided',
      outcome: 'cancelled',
      closed_by_type: 'admin',
    });
    expect((await balance('captain.custody', captain.captainId)) - custodyBefore).toBe(-24_000n);
    expect((await balance('merchant.account', restaurant)) - merchantBefore).toBe(-24_000n);
    expect((await balance('captain.earnings', captain.captainId)) - earningsBefore).toBe(2_500n);
    expect((await balance('platform.order_clearing', null)) - clearingBefore).toBe(0n);
    expect(await row(order.id)).toMatchObject({
      cancel_cash: 'not_returned',
      cancel_captain_compensation: '2500',
      captain_id: captain.captainId,
    });
    // The captain's card, then free once acknowledged.
    const active = (await captain.active()).json();
    expect(active.order).toBeNull();
    expect(active.cancelled).toMatchObject({
      orderId: order.id,
      reason: 'ظرف طارئ',
      cash: 'not_returned',
      compensation: { amount: '2500', currency: 'TRY' },
    });
    const seen = await captain.acknowledge(order.id);
    expect(seen.statusCode).toBe(200);
    expect(seen.json().cancelled).toBeNull();
    expect((await captain.acknowledge(order.id)).statusCode).toBe(200);
    expect((await row(order.id)).cancel_captain_seen_at).not.toBeNull();
    // The cancellation reached the captain's channel; the acknowledgement no.
    expect(
      (
        await sql.query(
          'SELECT captain_id FROM ordering.order_events WHERE order_id = $1 AND type = $2',
          [order.id, 'order.cancelled'],
        )
      ).rows[0].captain_id,
    ).toBe(captain.captainId);
  });
});

describe('the detail (AP §9.3.1, §9.3.2; slice 2.8c)', () => {
  it("offers Content's ops_cancel reasons while the order can be cancelled", async () => {
    const order = await acceptedOrder();
    const ops = await admin(['OPS']);
    const before = await ops.detail(order.id);
    expect(before.cancellation).toBeNull();
    expect(before.cancelChoices.reasons.map((r: { code: string }) => r.code)).toEqual([
      'customer_request',
      'restaurant_no_response',
      'restaurant_closed',
      'item_sold_out',
      'no_captain',
      'outside_zone',
      'emergency',
      'other',
    ]);
    expect(before.cancelChoices.reasons[6]).toEqual({ code: 'emergency', label: 'ظرف طارئ' });
    expect((await ops.cancel(order.id, plain)).statusCode).toBe(200);
    expect((await ops.detail(order.id)).cancelChoices).toBeNull();
  });

  it("shows operations' cancellation with its party, money, note and who", async () => {
    const order = await acceptedOrder();
    const ops = await admin(['OPS']);
    expect((await ops.cancel(order.id, { ...plain, foodPrepared: true })).statusCode).toBe(200);
    const { cancellation } = await ops.detail(order.id);
    expect(cancellation).toMatchObject({
      reason: 'emergency',
      label: 'ظرف طارئ',
      customerText: 'ظرف طارئ منعنا من إكمال طلبك',
      note: 'ملاحظة العمليات',
      by: { type: 'admin', id: ops.accountId },
      responsible: 'platform',
      foodPrepared: true,
      cash: null,
      merchantCredit: { amount: '20400', currency: 'TRY' },
      captainCompensation: null,
      acknowledgedAt: null,
      captainSeenAt: null,
    });
  });

  it("shows the customer's own reason and «سبب آخر» text", async () => {
    const order = await placedOrder();
    const cancelled = await app.inject({
      method: 'POST',
      url: `/v1/customer/orders/${order.id}/cancel`,
      headers: { ...order.customer, 'idempotency-key': randomUUID() },
      payload: { reason: 'other', note: 'تأخرت كثيراً' },
    });
    expect(cancelled.statusCode).toBe(200);
    const ops = await admin(['SUP']);
    const { cancellation } = await ops.detail(order.id);
    expect(cancellation).toMatchObject({
      reason: 'other',
      label: 'سبب آخر',
      note: 'تأخرت كثيراً',
      by: { type: 'customer' },
      customerText: null,
      responsible: null,
      foodPrepared: false,
      merchantCredit: null,
    });
  });

  it('previews the late-cancellation strike (docs/domain/08, 09)', async () => {
    const accepted = await acceptedOrder();
    const placed = await placedOrder();
    const ops = await admin(['OPS']);
    const byCustomer = { ...plain, responsible: 'customer', reason: undefined };
    expect((await ops.preview(accepted.id, byCustomer)).json().strike).toBe(true);
    expect(
      (await ops.preview(accepted.id, { ...byCustomer, responsible: 'platform' })).json().strike,
    ).toBe(false);
    expect((await ops.preview(placed.id, byCustomer)).json().strike).toBe(false);
  });
});

describe('the late-cancellation strike (docs/domain/08)', () => {
  it('stops ordering at customer.late_cancel_strikes until support reviews', async () => {
    const customer = await appSignIn('customer', phoneNumber());
    const ops = await admin(['OPS']);
    for (let n = 0; n < 2; n += 1) {
      const order = await acceptedOrder(customer);
      expect((await ops.cancel(order.id, { ...plain, responsible: 'customer' })).statusCode).toBe(
        200,
      );
    }
    const strikes = await sql.query(
      `SELECT count(*)::int AS n FROM customers.late_cancel_strikes s
         JOIN customers.review_stops r ON r.customer_account_id = s.customer_account_id
        WHERE r.ended_at IS NULL`,
    );
    expect(strikes.rows[0].n).toBeGreaterThanOrEqual(2);
    const quote = await quoteFor(customer);
    expect(quote.json().problems.map((problem: { code: string }) => problem.code)).toContain(
      'review_stop',
    );
    const placed = await place(customer);
    expect(placed.statusCode).toBe(409);
    expect(placed.json().error).toBe('order_blocked');
  });
});

describe("another party's order (architecture §15.2)", () => {
  it("answers another restaurant's or another captain's «حسناً» with 404 unknown_order", async () => {
    const { order, ops } = await captainAtRestaurant();
    expect((await ops.cancel(order.id, { ...plain, cash: 'returned' })).statusCode).toBe(200);
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
    const restaurantAnswer = await acknowledge(await cashier(other), order.id);
    expect(restaurantAnswer.statusCode).toBe(404);
    expect(restaurantAnswer.json().error).toBe('unknown_order');
    const captainAnswer = await (await onlineCaptain()).acknowledge(order.id);
    expect(captainAnswer.statusCode).toBe(404);
    expect(captainAnswer.json().error).toBe('unknown_order');
    const stored = await row(order.id);
    expect(stored.cancel_acknowledged_at).toBeNull();
    expect(stored.cancel_captain_seen_at).toBeNull();
  });
});

const DAY_MS = 24 * 60 * 60 * 1000;

const accountOf = async (orderId: string): Promise<string> =>
  (await sql.query('SELECT customer_account_id FROM ordering.orders WHERE id = $1', [orderId]))
    .rows[0].customer_account_id;

const openStops = async (accountId: string): Promise<number> =>
  (
    await sql.query(
      'SELECT count(*)::int AS n FROM customers.review_stops WHERE customer_account_id = $1 AND ended_at IS NULL',
      [accountId],
    )
  ).rows[0].n;

describe('the strike window and the placing re-check (docs/domain/08)', () => {
  it('does not count a strike older than customer.late_cancel_window_days', async () => {
    const customer = await appSignIn('customer', phoneNumber());
    const ops = await admin(['OPS']);
    const order = await acceptedOrder(customer);
    const accountId = await accountOf(order.id);
    const windowDays = await app
      .get(SettingsService)
      .get('customer.late_cancel_window_days', { cityId: azaz });
    await db.db.transaction((tx) =>
      app.get(CustomersService).recordLateCancel(tx, {
        accountId,
        orderId: randomUUID(),
        cityId: azaz,
        at: new Date(Date.now() - windowDays * DAY_MS - 1000),
        strikes: 2,
        windowDays,
      }),
    );
    expect((await ops.cancel(order.id, { ...plain, responsible: 'customer' })).statusCode).toBe(
      200,
    );
    expect(await openStops(accountId)).toBe(0);
    const quote = await quoteFor(customer);
    expect(quote.json().problems.map((problem: { code: string }) => problem.code)).not.toContain(
      'review_stop',
    );
  });

  it('refuses the order when a review stop opens between the quote and the placing', async () => {
    const customer = await appSignIn('customer', phoneNumber());
    const ops = await admin(['OPS']);
    const first = await placedOrder(customer);
    const accountId = await accountOf(first.id);
    expect((await ops.cancel(first.id, plain)).statusCode).toBe(200);
    // The stop opens after the placing priced the order, before its
    // transaction takes the customer's lock: the placing alone reads
    // order.merchant_auto_cancel_min, between the two.
    const settings = app.get(SettingsService);
    const get = settings.get.bind(settings);
    let opened = false;
    const spy = vi.spyOn(settings, 'get').mockImplementation((async (
      ...args: Parameters<typeof get>
    ) => {
      if (args[0] === 'order.merchant_auto_cancel_min' && !opened) {
        opened = true;
        await db.db.transaction((tx) =>
          app.get(CustomersService).recordLateCancel(tx, {
            accountId,
            orderId: randomUUID(),
            cityId: azaz,
            at: new Date(),
            strikes: 1,
            windowDays: 30,
          }),
        );
      }
      return get(...args);
    }) as typeof get);
    try {
      const placed = await place(customer);
      expect(opened).toBe(true);
      expect(placed.statusCode).toBe(409);
      expect(placed.json().error).toBe('order_blocked');
      expect(placed.json().quote.problems).toContainEqual(
        expect.objectContaining({ code: 'review_stop' }),
      );
    } finally {
      spy.mockRestore();
    }
  });
});
