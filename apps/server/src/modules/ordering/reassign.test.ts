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

// AP §9.3.2 «سحب وإعادة تعيين», AP §8.1, docs/domain/01, 02; CA §9.10, K17
// (slice 2.12a): operations take an accepted or ready order from its captain
// before the pickup, with a reassignment reason, the fault and the cash
// question; the order goes back to dispatch, the captain is free and sees the
// card, and a second captain takes it.

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

async function balance(purpose: AccountPurpose, ownerId: string | null): Promise<bigint> {
  const ledger = app.get(LedgerService);
  if (ownerId === null) {
    const id = await ledger.openAccount({ cityId: azaz, purpose, ownerId, currency: 'TRY' });
    return (await ledger.balance(id)).amount;
  }
  const [account] = await ledger.ownerAccounts(azaz, ownerId, purpose);
  return account ? (await ledger.balance(account.id)).amount : 0n;
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

const trackRow = async (orderId: string) =>
  (
    await sql.query(
      `SELECT status, captain_id, captain_track, assigned_at, arrived_at_merchant_at,
              captain_waiting_alert_at, search_started_at, search_alert_at
         FROM ordering.orders WHERE id = $1`,
      [orderId],
    )
  ).rows[0];

const withdrawal = {
  reassignment: 'captain_late',
  captainFault: true,
  cash: null,
  reason: 'الكابتن لم يتحرك',
};

describe('POST /v1/admin/orders/{orderId}/reassign (AP §9.3.2)', () => {
  it('takes an assigned order from its captain, who is free and sees the card', async () => {
    const order = await acceptedOrder();
    const first = await onlineCaptain();
    const ops = await admin(['OPS']);
    expect((await ops.assign(order.id, first.captainId)).statusCode).toBe(200);
    const detail = await ops.detail(order.id);
    expect(detail.reassignChoices.reasons).toContainEqual({
      code: 'captain_late',
      label: 'تأخر الكابتن',
      captainFault: true,
    });
    expect(detail.reassignChoices.reasons).toContainEqual({
      code: 'vehicle_breakdown',
      label: 'عطل في المركبة',
      captainFault: false,
    });
    const preview = await ops.reassignPreview(order.id, { cash: null });
    expect(preview.statusCode).toBe(200);
    expect(preview.json()).toEqual({ entries: [], cashAsked: false, cashLines: null });

    const answer = await ops.reassign(order.id, withdrawal);
    expect(answer.statusCode).toBe(200);
    expect(await trackRow(order.id)).toMatchObject({
      status: 'accepted',
      captain_id: null,
      captain_track: 'searching',
      assigned_at: null,
      arrived_at_merchant_at: null,
    });
    const after = await trackRow(order.id);
    expect(after.search_started_at).not.toBeNull();
    expect(after.search_alert_at).not.toBeNull();
    expect(await reassignmentRows(order.id)).toEqual([
      {
        captain_id: first.captainId,
        reason: 'captain_late',
        reason_label: 'تأخر الكابتن',
        captain_fault: true,
        cash: null,
        note: 'الكابتن لم يتحرك',
        captain_seen_at: null,
      },
    ]);
    // The event is about the withdrawn captain, keeps operations' note and
    // publishes the code with the track back to searching.
    const event = (await events(order.id)).at(-1);
    expect(event).toEqual({
      type: 'order.reassigned',
      actor_type: 'admin',
      reason: 'الكابتن لم يتحرك',
    });
    const { rows: outboxRows } = await sql.query(
      `SELECT payload->>'reason' AS reason, payload->>'captainId' AS captain,
              payload->>'captainTrack' AS track
         FROM ordering.outbox WHERE order_id = $1 AND type = 'order.reassigned'`,
      [order.id],
    );
    expect(outboxRows).toEqual([
      { reason: 'captain_late', captain: first.captainId, track: 'searching' },
    ]);

    // CA §9.10: the order leaves the captain's app with the card, until «حسناً».
    const active = (await first.active()).json();
    expect(active.order).toBeNull();
    expect(active.withdrawn).toMatchObject({
      orderId: order.id,
      reason: 'تأخر الكابتن',
      cash: null,
    });
    const acknowledged = await app.inject({
      method: 'POST',
      url: `/v1/captain/orders/${order.id}/acknowledge-withdrawal`,
      headers: first.headers,
    });
    expect(acknowledged.statusCode).toBe(200);
    expect(acknowledged.json().withdrawn).toBeNull();
    expect((await reassignmentRows(order.id))[0].captain_seen_at).not.toBeNull();

    // K17: the captain is free at once; a second captain takes the order.
    expect(
      (await app.get(CaptainsService).state(first.captainId, new Date())).availability.state,
    ).not.toBe('busy');
    const second = await onlineCaptain();
    expect((await ops.assign(order.id, second.captainId)).statusCode).toBe(200);
    expect((await second.active()).json().order.id).toBe(order.id);
    expect((await ops.detail(order.id)).reassignments).toMatchObject([
      { captainId: first.captainId, label: 'تأخر الكابتن', captainFault: true, cash: null },
    ]);
  });

  it('asks the cash question at the restaurant and books the payment the restaurant kept', async () => {
    const { order, captain, ops } = await captainAtRestaurant();
    const custodyBefore = await balance('captain.custody', captain.captainId);
    const merchantBefore = await balance('merchant.account', restaurant);
    // The preview asks before the answer is given.
    const asked = await ops.reassignPreview(order.id, { cash: null });
    expect(asked.json()).toEqual({
      entries: [],
      cashAsked: true,
      cashLines: [{ amount: '24000', currency: 'TRY' }],
    });
    expect((await ops.reassign(order.id, withdrawal)).json().error).toBe('cash_answer_required');
    const kept = await ops.reassignPreview(order.id, { cash: 'not_returned' });
    expect(kept.json().entries).toMatchObject([
      {
        type: 'custody.pay_merchant',
        account: 'captain.custody',
        party: { kind: 'captain', id: captain.captainId, name: 'كابتن الإلغاء' },
        amount: { amount: '-24000', currency: 'TRY' },
      },
      { type: 'custody.pay_merchant', account: 'platform.order_clearing' },
      {
        type: 'merchant.debit',
        account: 'merchant.account',
        party: { kind: 'merchant', id: restaurant, name: 'مطعم الإلغاء' },
        amount: { amount: '24000', currency: 'TRY' },
      },
      { type: 'merchant.debit', account: 'platform.order_clearing' },
    ]);

    const answer = await ops.reassign(order.id, {
      ...withdrawal,
      reassignment: 'vehicle_breakdown',
      captainFault: false,
      cash: 'not_returned',
    });
    expect(answer.statusCode).toBe(200);
    // As the cancellation books it (ops-cancel.test.ts).
    expect((await balance('captain.custody', captain.captainId)) - custodyBefore).toBe(-24_000n);
    expect((await balance('merchant.account', restaurant)) - merchantBefore).toBe(-24_000n);
    // The arrival is cleared, so the next captain does not show it.
    expect(await trackRow(order.id)).toMatchObject({
      arrived_at_merchant_at: null,
      captain_waiting_alert_at: null,
      captain_track: 'searching',
    });
    expect((await captain.active()).json().withdrawn).toMatchObject({
      reason: 'عطل في المركبة',
      cash: 'not_returned',
    });
    expect((await reassignmentRows(order.id))[0]).toMatchObject({
      captain_fault: false,
      cash: 'not_returned',
    });
  });

  it('refuses while a pickup request is open, a reason off the list, and no captain', async () => {
    const { order, captain, ops } = await captainAtRestaurant();
    expect(
      (
        await ops.reassign(order.id, { ...withdrawal, cash: 'returned', reassignment: 'nope' })
      ).json().error,
    ).toBe('unknown_reason');
    expect((await captain.requestPickup(order.id)).statusCode).toBe(200);
    const open = await ops.reassign(order.id, { ...withdrawal, cash: 'returned' });
    expect(open.statusCode).toBe(409);
    expect(open.json().error).toBe('pickup_request_open');
    expect((await ops.reassignPreview(order.id, { cash: null })).json().error).toBe(
      'pickup_request_open',
    );
    const unassigned = await acceptedOrder();
    expect((await ops.reassign(unassigned.id, withdrawal)).json().error).toBe(
      'order_state_changed',
    );
    expect((await ops.detail(unassigned.id)).reassignChoices).toBeNull();
  });

  it('replays a repeated key and lets the application role change only the «حسناً»', async () => {
    const order = await acceptedOrder();
    const captain = await onlineCaptain();
    const ops = await admin(['OPS']);
    expect((await ops.assign(order.id, captain.captainId)).statusCode).toBe(200);
    const key = randomUUID();
    expect((await ops.reassign(order.id, withdrawal, key)).statusCode).toBe(200);
    expect((await ops.reassign(order.id, withdrawal, key)).statusCode).toBe(200);
    expect(await reassignmentRows(order.id)).toHaveLength(1);
    await expect(
      sql.query("UPDATE ordering.reassignments SET note = 'x' WHERE order_id = $1", [order.id]),
    ).rejects.toThrow(/permission denied/);
    const { rows } = await sql.query(
      "SELECT action FROM audit.events WHERE target_type = 'order' AND target_id = $1 AND action = 'order.reassign'",
      [order.id],
    );
    expect(rows).toHaveLength(1);
  });
});
