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
import { DispatchService } from '../dispatch/index.js';
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

// AP §9.3.2 «تسليم لكابتن آخر», CA §9.10.1, §15, docs/domain/01, K17 (slice
// 2.12b): operations hand a picked-up order to a second captain, as an offer
// or an assignment; the second captain receives it near the first, collects
// at the door and earns the order pay; the first keeps the pickup payment in
// custody and goes offline.

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

// About 55 m north of the customer's pin, inside the 200 m.
const atCustomer = { latitude: 36.5905, longitude: 37.046 };
// Where the first captain stopped (a breakdown), and a spot 80 m from it.
const brokenDown = { latitude: 36.5885, longitude: 37.046 };
const besideThem = { latitude: 36.58922, longitude: 37.046 };

// An online captain at a point, whose commands send a fix where they are.
async function onlineCaptain(name: string, point: Point = captainSpot) {
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

async function admin(roles: string[]) {
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

const requireAccept = (on: boolean) =>
  app
    .get(SettingsService)
    .update('dispatch.manual_assign_requires_accept', { cityId: azaz }, on, bySystem);

// A picked-up order (two shawarma, 24000; fee 4000; total 28000) whose
// captain then broke down, and operations.
async function pickedUpOrder() {
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

async function balance(purpose: AccountPurpose, ownerId: string): Promise<bigint> {
  const ledger = app.get(LedgerService);
  const [account] = await ledger.ownerAccounts(azaz, ownerId, purpose);
  return account ? (await ledger.balance(account.id)).amount : 0n;
}

const events = async (orderId: string) =>
  (
    await sql.query(
      `SELECT type, actor_type, reason, captain_id, from_status, to_status
         FROM ordering.order_events WHERE order_id = $1 ORDER BY version`,
      [orderId],
    )
  ).rows;

const handoverRows = async (orderId: string) =>
  (
    await sql.query(
      `SELECT from_captain_id, to_captain_id, offer_id IS NOT NULL AS offered, note,
              assigned_at IS NOT NULL AS assigned, received_at IS NOT NULL AS received,
              close_reason, from_seen_at IS NOT NULL AS seen
         FROM ordering.handovers WHERE order_id = $1 ORDER BY opened_at`,
      [orderId],
    )
  ).rows;

const orderRow = async (orderId: string) =>
  (
    await sql.query(
      `SELECT status, captain_id, captain_track, arrived_at_customer_at, away_reason
         FROM ordering.orders WHERE id = $1`,
      [orderId],
    )
  ).rows[0];

describe('POST /v1/admin/orders/{orderId}/handover (AP §9.3.2, CA §9.10.1)', () => {
  it('offers the order «استلام من كابتن» to a second captain, who pays nothing', async () => {
    const { order, first, ops } = await pickedUpOrder();
    const second = await onlineCaptain('باسل الثاني', besideThem);
    // The picker after the pickup measures from the first captain and leaves
    // them out.
    const picker = await ops.picker(order.id);
    expect(picker.map((each: { captainId: string }) => each.captainId)).not.toContain(
      first.captainId,
    );
    const listed = picker.find(
      (each: { captainId: string }) => each.captainId === second.captainId,
    );
    expect(listed.eligible).toBe(true);
    expect(listed.distanceMetres).toBeLessThan(200);

    await requireAccept(true);
    try {
      const answer = await ops.handover(order.id, second.captainId);
      expect(answer.statusCode).toBe(200);
      expect(answer.json().order).toMatchObject({
        status: 'picked_up',
        captainId: first.captainId,
        captainTrack: 'picked_up',
        offer: { captainId: second.captainId, handover: true },
      });
      const offer = await second.currentOffer();
      expect(offer).toMatchObject({
        orderId: order.id,
        fromOperations: true,
        pickupPayment: { amount: '0', currency: 'TRY' },
        collect: { amount: '28000', currency: 'TRY' },
        handover: { fromCaptainName: 'سامر الأول', location: expect.objectContaining(brokenDown) },
      });
      expect(await handoverRows(order.id)).toEqual([
        {
          from_captain_id: first.captainId,
          to_captain_id: second.captainId,
          offered: true,
          note: 'تعطلت الدراجة',
          assigned: false,
          received: false,
          close_reason: null,
          seen: false,
        },
      ]);
      expect((await second.accept(offer.id)).statusCode).toBe(200);
      expect((await handoverRows(order.id))[0]).toMatchObject({ assigned: true });
      // The second captain is busy; the order stays the first's until the
      // receipt (owner decision 2026-11-11).
      expect((await second.availability()).state).toBe('busy');
      expect(await orderRow(order.id)).toMatchObject({
        status: 'picked_up',
        captain_id: first.captainId,
      });
      expect((await events(order.id)).slice(-2)).toEqual([
        {
          type: 'order.handover_offered',
          actor_type: 'admin',
          reason: 'تعطلت الدراجة',
          captain_id: second.captainId,
          from_status: 'picked_up',
          to_status: 'picked_up',
        },
        {
          type: 'order.handover_assigned',
          actor_type: 'captain',
          reason: null,
          captain_id: second.captainId,
          from_status: 'picked_up',
          to_status: 'picked_up',
        },
      ]);
    } finally {
      await requireAccept(false);
    }
  });

  it('closes the handover when the offer is declined, and opens another', async () => {
    const { order, ops } = await pickedUpOrder();
    const second = await onlineCaptain('رافض', besideThem);
    await requireAccept(true);
    try {
      expect((await ops.handover(order.id, second.captainId)).statusCode).toBe(200);
      const offer = await second.currentOffer();
      expect((await second.decline(offer.id)).statusCode).toBe(200);
      expect(await handoverRows(order.id)).toMatchObject([{ close_reason: 'declined' }]);
      expect((await events(order.id)).at(-1)).toMatchObject({
        type: 'order.handover_closed',
        reason: 'declined',
      });
      expect((await second.availability()).state).toBe('online_available');
      const third = await onlineCaptain('قابل', besideThem);
      expect((await ops.handover(order.id, third.captainId)).statusCode).toBe(200);
    } finally {
      await requireAccept(false);
    }
  });

  it('assigns the handover at once without manual_assign_requires_accept', async () => {
    const { order, first, ops } = await pickedUpOrder();
    const second = await onlineCaptain('مباشر', besideThem);
    const custody = await balance('captain.custody', first.captainId);
    expect((await ops.detail(order.id)).handover).toEqual({ allowed: true, handovers: [] });
    const answer = await ops.handover(order.id, second.captainId);
    expect(answer.statusCode).toBe(200);
    expect(answer.json().order.offer).toBeNull();
    // AP §9.3.1: the detail lists it; another would replace it.
    expect((await ops.detail(order.id)).handover).toMatchObject({
      allowed: true,
      handovers: [
        {
          fromCaptainId: first.captainId,
          fromCaptainName: 'سامر الأول',
          toCaptainId: second.captainId,
          toCaptainName: 'مباشر',
          offered: false,
          receivedAt: null,
          closeReason: null,
          note: 'تعطلت الدراجة',
          adminId: ops.accountId,
        },
      ],
    });
    expect(await handoverRows(order.id)).toMatchObject([{ offered: false, assigned: true }]);
    expect((await second.availability()).state).toBe('busy');
    // Nothing moves in the ledger until the delivery: the pickup payment
    // stays in the first captain's custody.
    expect(await balance('captain.custody', first.captainId)).toBe(custody);
  });

  it('refuses before the pickup and the order’s own captain', async () => {
    const order = await acceptedOrder();
    const ops = await admin(['OPS']);
    const second = await onlineCaptain('مبكر', besideThem);
    const early = await ops.handover(order.id, second.captainId);
    expect(early.statusCode).toBe(409);
    expect(early.json().error).toBe('order_not_handoverable');

    const picked = await pickedUpOrder();
    const own = await picked.ops.handover(picked.order.id, picked.first.captainId);
    expect(own.statusCode).toBe(409);
    expect(own.json()).toMatchObject({ error: 'captain_not_eligible', reasons: ['busy'] });
  });
});

describe('POST /v1/captain/orders/{orderId}/receive-handover (CA §9.10.1, §15)', () => {
  it('hands an arrived order to the second captain near the first, who delivers it', async () => {
    const { order, first, ops } = await pickedUpOrder();
    expect((await first.arriveAtCustomer(order.id)).statusCode).toBe(200);
    await first.moveTo(brokenDown);
    const custody = await balance('captain.custody', first.captainId);
    expect(custody).toBe(-24_000n);
    const second = await onlineCaptain('باسل الثاني', captainSpot);
    expect((await ops.handover(order.id, second.captainId)).statusCode).toBe(200);

    // The first captain waits: their screen names the second, with a call
    // button, and their own steps are refused meanwhile.
    const giving = (await first.active()).order;
    expect(giving.handover).toMatchObject({
      role: 'giving',
      assigned: true,
      captain: { name: 'باسل الثاني', phone: expect.stringMatching(/^\+9639/) },
    });
    const early = await first.deliver(order.id);
    expect(early.statusCode).toBe(409);
    expect(early.json().error).toBe('order_state_changed');
    await first.moveTo(brokenDown);

    // The second captain is led to the first and pays nothing.
    const receiving = (await second.active()).order;
    expect(receiving).toMatchObject({
      id: order.id,
      pickupPayment: { amount: '0', currency: 'TRY' },
      collect: { amount: '28000', currency: 'TRY' },
      handover: {
        role: 'receiving',
        assigned: true,
        captain: {
          name: 'سامر الأول',
          location: expect.objectContaining(brokenDown),
        },
      },
    });
    // Too far from the first captain.
    const far = await second.receive(order.id);
    expect(far.statusCode).toBe(409);
    expect(far.json()).toMatchObject({ error: 'too_far_from_captain' });
    expect(far.json().distanceMetres).toBeGreaterThan(200);

    await second.moveTo(besideThem);
    const received = await second.receive(order.id);
    expect(received.statusCode).toBe(200);
    expect(received.json().order).toMatchObject({
      status: 'picked_up',
      captainTrack: 'picked_up',
      handover: null,
      customer: { arrival: null },
    });
    // docs/domain/01: arrived back to picked_up with the door arrival
    // cleared; the order is the second captain's now.
    expect(await orderRow(order.id)).toEqual({
      status: 'picked_up',
      captain_id: second.captainId,
      captain_track: 'picked_up',
      arrived_at_customer_at: null,
      away_reason: null,
    });
    expect((await events(order.id)).at(-1)).toEqual({
      type: 'order.handed_over',
      actor_type: 'captain',
      reason: null,
      captain_id: second.captainId,
      from_status: 'arrived',
      to_status: 'picked_up',
    });
    expect(await handoverRows(order.id)).toMatchObject([{ received: true, seen: false }]);

    // K17: the first captain is offline, the order gone from their app,
    // and the card «سلّمت الطلب للكابتن {الاسم}» shows until «حسناً».
    expect((await first.availability()).state).toBe('offline');
    const { rows: periods } = await sql.query(
      `SELECT end_reason FROM captains.online_periods
         WHERE captain_id = $1 ORDER BY started_at DESC LIMIT 1`,
      [first.captainId],
    );
    expect(periods).toEqual([{ end_reason: 'handed_over' }]);
    const firstNow = await first.active();
    expect(firstNow.order).toBeNull();
    expect(firstNow.handedOver).toMatchObject({
      orderId: order.id,
      toCaptainName: 'باسل الثاني',
    });
    const seen = await first.acknowledgeHandover(order.id);
    expect(seen.statusCode).toBe(200);
    expect(seen.json().handedOver).toBeNull();

    // The second captain collects at the door and earns the order pay; the
    // pickup payment stays in the first captain's custody (AP §9.3.2).
    expect((await second.arriveAtCustomer(order.id)).statusCode).toBe(200);
    const delivered = await second.deliver(order.id);
    expect(delivered.statusCode).toBe(200);
    expect(delivered.json().summary).toMatchObject({
      pay: { total: '2500', waiting: '0' },
      custodyChange: { amount: '28000' },
    });
    expect(await balance('captain.custody', second.captainId)).toBe(28_000n);
    expect(await balance('captain.earnings', second.captainId)).toBe(2_500n);
    expect(await balance('captain.custody', first.captainId)).toBe(-24_000n);
    expect(await balance('captain.earnings', first.captainId)).toBe(0n);
  });

  it('refuses a captain who is not the handover’s second captain', async () => {
    const { order, ops } = await pickedUpOrder();
    const second = await onlineCaptain('ثاني', besideThem);
    const stranger = await onlineCaptain('غريب', besideThem);
    expect((await ops.handover(order.id, second.captainId)).statusCode).toBe(200);
    expect((await stranger.receive(order.id)).statusCode).toBe(404);
    expect((await stranger.active()).order).toBeNull();
  });

  it('ends an open handover when operations record the delivery', async () => {
    const { order, ops } = await pickedUpOrder();
    const second = await onlineCaptain('منتظر', besideThem);
    expect((await ops.handover(order.id, second.captainId)).statusCode).toBe(200);
    // The assigned handover is the second captain's active order (K18).
    expect((await second.lastOrder()).json().availability.state).toBe('last_order');
    const recorded = await ops.post(`/v1/admin/orders/${order.id}/record-delivery`, {
      received: [{ currency: 'TRY', amount: '28000' }],
      change: [],
      amountDue: { amount: '28000', currency: 'TRY' },
      shortfall: null,
      reason: 'سلّمه الكابتن الأول بنفسه',
    });
    expect(recorded.statusCode).toBe(200);
    expect(await handoverRows(order.id)).toMatchObject([{ close_reason: 'ended' }]);
    // Slice 2.13a: the order left them with the handover, so their last
    // order ended.
    expect((await second.availability()).state).toBe('offline');
    expect((await second.active()).order).toBeNull();
  });
});

describe('the handover tables (AP §9.7.4)', () => {
  it('lets the application role change only the steps of a handover', async () => {
    const { order, ops } = await pickedUpOrder();
    const second = await onlineCaptain('جدول', besideThem);
    expect((await ops.handover(order.id, second.captainId)).statusCode).toBe(200);
    await expect(
      sql.query("UPDATE ordering.handovers SET note = 'x' WHERE order_id = $1", [order.id]),
    ).rejects.toThrow(/permission denied/);
  });
});

// docs/domain/04: the first captain waited 30 minutes at the restaurant,
// 20 of them paid at 1 TRY a minute (the pay table's rate raised as the
// migration role, the moments moved back as the delivery test does).
async function waitedAtRestaurant(orderId: string) {
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

describe('the handover’s pay and its other ways out (slice 2.12b)', () => {
  it('pays the first captain’s waiting to nobody after a handover (AP §9.3.2)', async () => {
    // Without a handover the waiting is paid (the control).
    const control = await pickedUpOrder();
    await waitedAtRestaurant(control.order.id);
    expect((await control.first.arriveAtCustomer(control.order.id)).statusCode).toBe(200);
    const paid = await control.first.deliver(control.order.id);
    expect(paid.json().summary.pay).toMatchObject({ waiting: '2000', total: '4500' });

    const { order, first, ops } = await pickedUpOrder();
    await waitedAtRestaurant(order.id);
    const second = await onlineCaptain('بلا انتظار', besideThem);
    expect((await ops.handover(order.id, second.captainId)).statusCode).toBe(200);
    expect((await second.receive(order.id)).statusCode).toBe(200);
    expect((await second.arriveAtCustomer(order.id)).statusCode).toBe(200);
    const delivered = await second.deliver(order.id);
    expect(delivered.json().summary.pay).toMatchObject({ waiting: '0', total: '2500' });
    expect(await balance('captain.earnings', second.captainId)).toBe(2_500n);
    expect(await balance('captain.earnings', first.captainId)).toBe(0n);
  });

  it('replaces an assigned handover with another captain (owner decision 2026-11-11)', async () => {
    const { order, ops } = await pickedUpOrder();
    const second = await onlineCaptain('لم يصل', besideThem);
    const third = await onlineCaptain('البديل', besideThem);
    expect((await ops.handover(order.id, second.captainId)).statusCode).toBe(200);
    expect((await second.lastOrder()).statusCode).toBe(200);
    expect((await ops.detail(order.id)).handover.allowed).toBe(true);
    expect((await ops.handover(order.id, third.captainId)).statusCode).toBe(200);
    expect(await handoverRows(order.id)).toMatchObject([
      { to_captain_id: second.captainId, close_reason: 'replaced' },
      { to_captain_id: third.captainId, assigned: true, close_reason: null },
    ]);
    // Slice 2.13a: replaced while in last-order mode, the second captain is
    // offline.
    expect((await second.availability()).state).toBe('offline');
    expect((await second.active()).order).toBeNull();
    expect((await third.active()).order.handover).toMatchObject({ role: 'receiving' });
    expect((await second.receive(order.id)).statusCode).toBe(404);
  });

  it('replaces an offered handover, withdrawing its offer', async () => {
    const { order, ops } = await pickedUpOrder();
    const second = await onlineCaptain('معروض عليه', besideThem);
    const third = await onlineCaptain('بديل العرض', besideThem);
    await requireAccept(true);
    try {
      expect((await ops.handover(order.id, second.captainId)).statusCode).toBe(200);
      const offered = await second.currentOffer();
      // Not accepted yet: the second captain cannot receive it.
      expect((await second.receive(order.id)).statusCode).toBe(409);
      expect((await ops.handover(order.id, third.captainId)).statusCode).toBe(200);
      expect(await second.currentOffer()).toBeNull();
      expect((await second.accept(offered.id)).statusCode).toBe(409);
      expect(await handoverRows(order.id)).toMatchObject([
        { close_reason: 'replaced' },
        { to_captain_id: third.captainId, offered: true, close_reason: null },
      ]);
    } finally {
      await requireAccept(false);
    }
  });

  it('closes a handover whose offer expires or whose captain goes offline', async () => {
    const expiring = await pickedUpOrder();
    const leaving = await pickedUpOrder();
    await requireAccept(true);
    try {
      const late = await onlineCaptain('لم يرد', besideThem);
      const state = await expiring.ops.handover(expiring.order.id, late.captainId);
      const { offer } = state.json().order;
      const [{ placed_at: placedAt }] = (
        await sql.query('SELECT placed_at FROM ordering.orders WHERE id = $1', [expiring.order.id])
      ).rows;
      const dispatch = app.get(DispatchService);
      const job = {
        offerId: offer.id,
        orderId: expiring.order.id,
        orderPlacedAt: new Date(placedAt).toISOString(),
      };
      const after = new Date(Date.parse(offer.expiresAt) + 1000);
      expect(await dispatch.expire(job, after)).toBe(true);
      // A late or repeated job changes nothing.
      expect(await dispatch.expire(job, after)).toBe(false);
      expect(await handoverRows(expiring.order.id)).toMatchObject([{ close_reason: 'expired' }]);

      const gone = await onlineCaptain('خرج', besideThem);
      expect((await leaving.ops.handover(leaving.order.id, gone.captainId)).statusCode).toBe(200);
      await app.get(CaptainsService).goOffline(gone.captainId, new Date());
      expect(await handoverRows(leaving.order.id)).toMatchObject([{ close_reason: 'withdrawn' }]);
    } finally {
      await requireAccept(false);
    }
  });

  it('ends an open handover with «تحديد النتيجة», its offer included', async () => {
    const { order, ops } = await pickedUpOrder();
    await requireAccept(true);
    try {
      const second = await onlineCaptain('عرض انتهى', besideThem);
      expect((await ops.handover(order.id, second.captainId)).statusCode).toBe(200);
      const { version } = await ops.detail(order.id);
      const outcome = await ops.post(`/v1/admin/orders/${order.id}/outcome`, {
        outcome: 'failed_other',
        responsible: 'platform',
        delivered: false,
        food: 'kept_by_captain',
        version,
        reason: 'تلف الطعام في الحادث',
      });
      expect(outcome.statusCode).toBe(200);
      expect(await handoverRows(order.id)).toMatchObject([{ close_reason: 'ended' }]);
      expect(await second.currentOffer()).toBeNull();
    } finally {
      await requireAccept(false);
    }
  });

  // CA §7.3 (slice 2.13a): «تحديد النتيجة» takes the order from its captain,
  // so their last order ends.
  it('takes a captain in last-order mode offline when operations set a failed outcome', async () => {
    const { order, first, ops } = await pickedUpOrder();
    expect((await first.lastOrder()).statusCode).toBe(200);
    const { version } = await ops.detail(order.id);
    const outcome = await ops.post(`/v1/admin/orders/${order.id}/outcome`, {
      outcome: 'failed_other',
      responsible: 'platform',
      delivered: false,
      food: 'kept_by_captain',
      version,
      reason: 'تعذّر الوصول إلى الزبون',
    });
    expect(outcome.statusCode).toBe(200);
    expect((await first.availability()).state).toBe('offline');
  });

  it('holds the first captain’s steps and gives a giver no details before the acceptance', async () => {
    const { order, first, ops } = await pickedUpOrder();
    const second = await onlineCaptain('لم يقبل بعد', besideThem);
    await requireAccept(true);
    try {
      expect((await ops.handover(order.id, second.captainId)).statusCode).toBe(200);
      const giving = (await first.active()).order.handover;
      expect(giving).toMatchObject({
        role: 'giving',
        assigned: false,
        captain: { name: 'لم يقبل بعد', phone: null, location: null },
      });
      const arrive = await first.arriveAtCustomer(order.id);
      expect(arrive.statusCode).toBe(409);
      expect(arrive.json().error).toBe('order_state_changed');
    } finally {
      await requireAccept(false);
    }
  });

  it('answers a repeated receipt with the order, and 404 to a captain who never handed over', async () => {
    const { order, first, ops } = await pickedUpOrder();
    const second = await onlineCaptain('مكرر', besideThem);
    expect((await ops.handover(order.id, second.captainId)).statusCode).toBe(200);
    const key = randomUUID();
    const receive = () =>
      app.inject({
        method: 'POST',
        url: `/v1/captain/orders/${order.id}/receive-handover`,
        headers: { ...second.headers, 'idempotency-key': key },
        payload: {
          location: {
            ...besideThem,
            accuracyMetres: 10,
            recordedAt: new Date().toISOString(),
            simulated: false,
          },
        },
      });
    expect((await receive()).statusCode).toBe(200);
    const again = await receive();
    expect(again.statusCode).toBe(200);
    expect(again.json().order.status).toBe('picked_up');
    expect((await events(order.id)).filter((e) => e.type === 'order.handed_over')).toHaveLength(1);
    expect((await second.acknowledgeHandover(order.id)).statusCode).toBe(404);
    expect((await first.acknowledgeHandover(order.id)).statusCode).toBe(200);
  });
});

describe('the handover after «لا أستطيع إكمال الطلب» (CA §9.11, AP §9.7.6; slice 2.13b)', () => {
  const faults = async (orderId: string) =>
    (
      await sql.query(
        'SELECT captain_fault FROM ordering.handovers WHERE order_id = $1 ORDER BY opened_at',
        [orderId],
      )
    ).rows.map((row) => row.captain_fault);

  it('keeps the fault operations chose while the request is open, and the receipt closes it', async () => {
    const { order, first, ops } = await pickedUpOrder();
    const asked = await app.inject({
      method: 'POST',
      url: `/v1/captain/orders/${order.id}/cannot-complete`,
      headers: { ...first.headers, 'idempotency-key': randomUUID() },
      payload: {
        location: {
          ...brokenDown,
          accuracyMetres: 10,
          recordedAt: new Date().toISOString(),
          simulated: false,
        },
        reason: 'vehicle_breakdown',
        note: null,
      },
    });
    expect(asked.statusCode).toBe(200);
    expect((await ops.detail(order.id)).cannotComplete).toMatchObject({
      captainId: first.captainId,
    });
    const second = await onlineCaptain('بلا خطأ', besideThem);
    const handedOver = await ops.post(`/v1/admin/orders/${order.id}/handover`, {
      captainId: second.captainId,
      reason: 'حادث',
      captainFault: false,
    });
    expect(handedOver.statusCode).toBe(200);
    expect(await faults(order.id)).toEqual([false]);
    expect((await ops.detail(order.id)).handover.handovers[0].captainFault).toBe(false);
    expect((await second.receive(order.id)).statusCode).toBe(200);
    const { rows } = await sql.query(
      'SELECT closed_how FROM ordering.cannot_complete_requests WHERE order_id = $1',
      [order.id],
    );
    expect(rows).toEqual([{ closed_how: 'handed_over' }]);
    expect((await first.availability()).state).toBe('offline');
  });

  const ask = (captain: { headers: Record<string, string> }, orderId: string, path = '') =>
    app.inject({
      method: 'POST',
      url: `/v1/captain/orders/${orderId}/cannot-complete${path}`,
      headers: { ...captain.headers, 'idempotency-key': randomUUID() },
      payload: {
        location: {
          ...brokenDown,
          accuracyMetres: 10,
          recordedAt: new Date().toISOString(),
          simulated: false,
        },
        ...(path === '' ? { reason: 'vehicle_breakdown', note: null } : {}),
      },
    });
  const periodEnd = async (captainId: string) =>
    (
      await sql.query(
        `SELECT end_reason FROM captains.online_periods WHERE captain_id = $1
          ORDER BY started_at DESC LIMIT 1`,
        [captainId],
      )
    ).rows[0].end_reason;
  const closedHow = async (orderId: string) =>
    (
      await sql.query(
        'SELECT closed_how FROM ordering.cannot_complete_requests WHERE order_id = $1',
        [orderId],
      )
    ).rows.map((row) => row.closed_how);

  it('takes the captain offline when the order is delivered with the request open (K17)', async () => {
    const { order, first, ops } = await pickedUpOrder();
    expect((await ask(first, order.id)).statusCode).toBe(200);
    const recorded = await ops.post(`/v1/admin/orders/${order.id}/record-delivery`, {
      received: [{ currency: 'TRY', amount: '28000' }],
      change: [],
      amountDue: { amount: '28000', currency: 'TRY' },
      shortfall: null,
      reason: 'أوصله الكابتن بنفسه',
    });
    expect(recorded.statusCode).toBe(200);
    expect(await closedHow(order.id)).toEqual(['ended']);
    expect(await periodEnd(first.captainId)).toBe('cannot_complete');
  });

  it('ends a last order with cannot_complete after an outcome, and refuses another captain’s «تراجع»', async () => {
    const { order, first, ops } = await pickedUpOrder();
    expect((await first.lastOrder()).statusCode).toBe(200);
    expect((await ask(first, order.id)).statusCode).toBe(200);
    const stranger = await onlineCaptain('غريب', besideThem);
    expect((await ask(stranger, order.id, '/withdraw')).statusCode).toBe(404);
    const { version } = await ops.detail(order.id);
    const outcome = await ops.post(`/v1/admin/orders/${order.id}/outcome`, {
      outcome: 'failed_other',
      responsible: 'platform',
      delivered: false,
      food: 'kept_by_captain',
      version,
      reason: 'تعطلت الدراجة',
    });
    expect(outcome.statusCode).toBe(200);
    expect(await closedHow(order.id)).toEqual(['ended']);
    expect(await periodEnd(first.captainId)).toBe('cannot_complete');
    // The order ended: nothing left to withdraw.
    expect((await ask(first, order.id, '/withdraw')).json()).toMatchObject({
      error: 'order_state_changed',
    });
  });

  it('keeps no fault on a handover without a request', async () => {
    const plain = await pickedUpOrder();
    const second = await onlineCaptain('عادي', besideThem);
    expect(
      (
        await plain.ops.post(`/v1/admin/orders/${plain.order.id}/handover`, {
          captainId: second.captainId,
          reason: 'تأخر',
          captainFault: false,
        })
      ).statusCode,
    ).toBe(200);
    expect(await faults(plain.order.id)).toEqual([null]);
  });
});

describe('the handover after «طوارئ» (CA §9.11, AP §9.7.6; slice 2.13c)', () => {
  const press = (captain: { headers: Record<string, string> }, orderId: string) =>
    app.inject({
      method: 'POST',
      url: `/v1/captain/orders/${orderId}/emergency`,
      headers: { ...captain.headers, 'idempotency-key': randomUUID() },
      payload: {
        location: {
          ...brokenDown,
          accuracyMetres: 10,
          recordedAt: new Date().toISOString(),
          simulated: false,
        },
      },
    });

  it('counts no fault by default, and the receipt closes it and takes the first captain offline', async () => {
    const { order, first, ops } = await pickedUpOrder();
    expect((await press(first, order.id)).statusCode).toBe(200);
    const second = await onlineCaptain('بعد الطوارئ', besideThem);
    const handedOver = await ops.post(`/v1/admin/orders/${order.id}/handover`, {
      captainId: second.captainId,
      reason: 'حادث',
      captainFault: null,
    });
    expect(handedOver.statusCode).toBe(200);
    const { rows: faults } = await sql.query(
      'SELECT captain_fault FROM ordering.handovers WHERE order_id = $1',
      [order.id],
    );
    expect(faults).toEqual([{ captain_fault: false }]);
    expect((await second.receive(order.id)).statusCode).toBe(200);
    const { rows } = await sql.query(
      'SELECT closed_how FROM ordering.emergencies WHERE order_id = $1',
      [order.id],
    );
    expect(rows).toEqual([{ closed_how: 'handed_over' }]);
    expect((await first.availability()).state).toBe('offline');
  });

  it('takes the captain offline when operations record the delivery with it open (K17)', async () => {
    const { order, first, ops } = await pickedUpOrder();
    expect((await press(first, order.id)).statusCode).toBe(200);
    const recorded = await ops.post(`/v1/admin/orders/${order.id}/record-delivery`, {
      received: [{ currency: 'TRY', amount: '28000' }],
      change: [],
      amountDue: { amount: '28000', currency: 'TRY' },
      shortfall: null,
      reason: 'أوصله الكابتن بعد الطوارئ',
    });
    expect(recorded.statusCode).toBe(200);
    const { rows } = await sql.query(
      'SELECT closed_how FROM ordering.emergencies WHERE order_id = $1',
      [order.id],
    );
    expect(rows).toEqual([{ closed_how: 'ended' }]);
    const { rows: periods } = await sql.query(
      `SELECT end_reason FROM captains.online_periods WHERE captain_id = $1
        ORDER BY started_at DESC LIMIT 1`,
      [first.captainId],
    );
    expect(periods).toEqual([{ end_reason: 'emergency' }]);
  });

  it('ends the period with emergency after an outcome', async () => {
    const { order, first, ops } = await pickedUpOrder();
    expect((await press(first, order.id)).statusCode).toBe(200);
    const { version } = await ops.detail(order.id);
    const outcome = await ops.post(`/v1/admin/orders/${order.id}/outcome`, {
      outcome: 'failed_other',
      responsible: 'platform',
      delivered: false,
      food: 'kept_by_captain',
      version,
      reason: 'حادث',
    });
    expect(outcome.statusCode).toBe(200);
    expect((await first.availability()).state).toBe('offline');
  });
});
