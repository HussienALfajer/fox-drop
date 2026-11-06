import 'reflect-metadata';
import { randomBytes, randomInt, randomUUID } from 'node:crypto';
import type { NestFastifyApplication } from '@nestjs/platform-fastify';
import pg from 'pg';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { ApiModule } from '../../api.module.js';
import { createDatabase, type Database } from '../../database/database.js';
import { startTestDatabase, type TestDatabase } from '../../database/test-database.js';
import { createApiApp } from '../../http/create-api-app.js';
import { QUEUES } from '../../jobs/job-queue.js';
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
import { DispatchService } from './index.js';

// Manual dispatch (D6; AP §9.3.2, §9.12.6, §8.3; CA §8, §15): operations
// offer an accepted order to an eligible captain, who accepts or declines it
// within dispatch.offer_timeout_sec, or it expires; or, with
// dispatch.manual_assign_requires_accept off, assign it directly.
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
// About 330 m north of the restaurant, inside its 1 km.
const home = { latitude: 36.59, longitude: 37.046 };
// About 1.1 km north of the restaurant.
const captainSpot = { latitude: 36.597, longitude: 37.046 };
const allWeek = [0, 1, 2, 3, 4, 5, 6].map((weekday) => ({ weekday, opensAt: 0, closesAt: 0 }));
const SECOND = 1000;

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
  return { authorization: `Bearer ${answer.json().accessToken}` };
}

let accounts = 0;
// A signed-in admin holding these roles (the identity rows written here).
async function admin(roles: string[]) {
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
    assign: (orderId: string, captainId: string, key: string = randomUUID()) =>
      app.inject({
        method: 'POST',
        url: `/v1/admin/orders/${orderId}/assign`,
        cookies,
        headers: { 'idempotency-key': key },
        payload: { captainId },
      }),
  };
}

// A placed order the restaurant accepted, its search started.
async function acceptedOrder(): Promise<{ id: string; placedAt: string }> {
  const customer = await appSignIn('customer', phoneNumber());
  const lines = [{ itemId: item, optionIds: [], quantity: 1, note: null, knownUnitPrice: '12000' }];
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
        contactPhone: null,
        recipientName: null,
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
  return { id: order.id, placedAt: order.placedAt };
}

// An activated motorbike captain, signed in and online at the point.
async function onlineCaptain(point: Point = captainSpot) {
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
  await captains.goOnline(captainId, { appVersion: '1.0.0', simulatedLocation: false }, now);
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

const orderRow = async (id: string) =>
  (
    await sql.query(
      'SELECT status, version, captain_track, captain_id, assigned_at FROM ordering.orders WHERE id = $1',
      [id],
    )
  ).rows[0];

const outboxTypes = async (id: string) =>
  (
    await sql.query('SELECT type FROM ordering.outbox WHERE order_id = $1 ORDER BY id', [id])
  ).rows.map((entry) => entry.type);

const offerRow = async (id: string) =>
  (await sql.query('SELECT * FROM dispatch.offers WHERE id = $1', [id])).rows[0];

describe('POST /v1/admin/orders/{orderId}/assign as an offer (AP §9.3.2, CA §8.4)', () => {
  it('offers the order to the captain for 45 seconds, logged and audited', async () => {
    const order = await acceptedOrder();
    const captain = await onlineCaptain();
    const ops = await admin(['OPS']);
    const before = Date.now();
    const answer = await ops.assign(order.id, captain.captainId);
    expect(answer.statusCode).toBe(200);
    const { offer, ...state } = answer.json().order;
    expect(state).toMatchObject({ id: order.id, captainTrack: 'offered', captainId: null });
    expect(offer.captainId).toBe(captain.captainId);
    const expiresAt = new Date(offer.expiresAt).getTime();
    expect(expiresAt).toBeGreaterThanOrEqual(before + 45 * SECOND);
    expect(expiresAt).toBeLessThanOrEqual(Date.now() + 45 * SECOND);
    expect(await outboxTypes(order.id)).toContain('order.offered');
    const kept = await offerRow(offer.id);
    expect(kept).toMatchObject({ status: 'open', kind: 'manual', offered_by: ops.accountId });
    const job = await sql.query(
      "SELECT data, start_after FROM pgboss.job WHERE name = $1 AND data->>'offerId' = $2",
      [QUEUES.offerExpiry, offer.id],
    );
    expect(new Date(job.rows[0].start_after).getTime()).toBe(expiresAt);
    const audit = await sql.query(
      "SELECT actor_id FROM audit.events WHERE action = 'order.assign_captain' AND target_id = $1",
      [order.id],
    );
    expect(audit.rows).toEqual([{ actor_id: ops.accountId }]);

    // CA §8.2: what the captain sees, never the customer's name or pin.
    const current = await captain.call('GET', '/v1/captain/offers/current');
    expect(current.statusCode).toBe(200);
    expect(current.json().offer).toMatchObject({
      id: offer.id,
      status: 'open',
      fromOperations: true,
      // 25 TRY for the first 3 km.
      pay: { amount: '2500', currency: 'TRY' },
      restaurant: { name: 'مطعم التوزيع' },
      customer: { neighbourhood: 'المركز' },
      pickupPayment: { amount: '12000', currency: 'TRY' },
      collect: { amount: '16000', currency: 'TRY' },
      preparation: { ready: false },
    });
    expect(current.json().offer.restaurant.distanceMetres).toBeGreaterThan(1000);
    expect(JSON.stringify(current.json())).not.toMatch(/شارع السوق|قرب الجامع|36\.59\b/);
  });

  it('assigns the order when the captain accepts: the captain is busy', async () => {
    const order = await acceptedOrder();
    const captain = await onlineCaptain();
    const offer = (await (await admin(['OPS'])).assign(order.id, captain.captainId)).json().order
      .offer;
    const key = randomUUID();
    const accepted = await captain.call('POST', `/v1/captain/offers/${offer.id}/accept`, key);
    expect(accepted.statusCode).toBe(200);
    expect(accepted.json().offer.status).toBe('accepted');
    const row = await orderRow(order.id);
    expect(row).toMatchObject({ captain_track: 'assigned', captain_id: captain.captainId });
    expect(await outboxTypes(order.id)).toEqual(
      expect.arrayContaining(['order.offered', 'order.assigned']),
    );
    const event = await sql.query(
      "SELECT actor_type, actor_id, captain_id FROM ordering.order_events WHERE order_id = $1 AND type = 'order.assigned'",
      [order.id],
    );
    expect(event.rows).toEqual([
      { actor_type: 'captain', actor_id: captain.captainId, captain_id: captain.captainId },
    ]);
    const state = await captain.call('GET', '/v1/captain/availability');
    expect(state.json().availability.state).toBe('busy');
    // A repeat of the key answers the offer; another key finds it closed.
    expect(
      (await captain.call('POST', `/v1/captain/offers/${offer.id}/accept`, key)).statusCode,
    ).toBe(200);
    const again = await captain.call('POST', `/v1/captain/offers/${offer.id}/accept`);
    expect(again.statusCode).toBe(409);
    expect(again.json().error).toBe('offer_unavailable');
    // Busy: no going offline (CA §15), and no other order.
    expect((await captain.call('POST', '/v1/captain/availability/offline')).statusCode).toBe(409);
    const next = await acceptedOrder();
    const refused = await (await admin(['OPS'])).assign(next.id, captain.captainId);
    expect(refused.statusCode).toBe(409);
    expect(refused.json()).toMatchObject({ error: 'captain_not_eligible', reasons: ['busy'] });
  });

  it('returns the order to «بحاجة لتعيين» when the captain declines', async () => {
    const order = await acceptedOrder();
    // The search-start job (the worker's) has run.
    await sql.query(
      "UPDATE ordering.orders SET captain_track = 'searching', search_started_at = now(), search_alert_at = now() WHERE id = $1",
      [order.id],
    );
    const captain = await onlineCaptain();
    const offer = (await (await admin(['OPS'])).assign(order.id, captain.captainId)).json().order
      .offer;
    const declined = await captain.call('POST', `/v1/captain/offers/${offer.id}/decline`);
    expect(declined.statusCode).toBe(200);
    expect(declined.json().offer.status).toBe('declined');
    expect(await orderRow(order.id)).toMatchObject({
      captain_track: 'searching',
      captain_id: null,
    });
    expect((await captain.call('GET', '/v1/captain/offers/current')).json().offer).toBeNull();
    // Another captain's offer is unknown to this one.
    const other = await onlineCaptain();
    const second = (await (await admin(['OPS'])).assign(order.id, other.captainId)).json().order
      .offer;
    expect((await captain.call('POST', `/v1/captain/offers/${second.id}/accept`)).statusCode).toBe(
      404,
    );
  });

  it('expires an unanswered offer, and sets the captain offline after 3 in a row (C3)', async () => {
    const captain = await onlineCaptain();
    const dispatch = app.get(DispatchService);
    for (let round = 1; round <= 3; round += 1) {
      const order = await acceptedOrder();
      const offer = (await (await admin(['OPS'])).assign(order.id, captain.captainId)).json().order
        .offer;
      const job = { offerId: offer.id, orderId: order.id, orderPlacedAt: order.placedAt };
      expect(await dispatch.expire(job, new Date())).toBe(true);
      expect(await dispatch.expire(job, new Date())).toBe(false);
      expect((await offerRow(offer.id)).status).toBe('expired');
      // Its search had not started yet: no track until it does.
      expect(await orderRow(order.id)).toMatchObject({ captain_track: null });
      const late = await captain.call('POST', `/v1/captain/offers/${offer.id}/accept`);
      expect(late.json().error).toBe('offer_unavailable');
      const state = (await captain.call('GET', '/v1/captain/availability')).json().availability;
      expect(state.state).toBe(round < 3 ? 'online_available' : 'offline');
    }
    const ended = await sql.query(
      'SELECT end_reason FROM captains.online_periods WHERE captain_id = $1',
      [captain.captainId],
    );
    expect(ended.rows).toEqual([{ end_reason: 'offers_expired' }]);
  });
});

describe('the assignment refusals (AP §9.3.2, §9.12.6)', () => {
  it('refuses an order with an open offer, an unknown order and an unknown captain', async () => {
    const order = await acceptedOrder();
    const ops = await admin(['OPS']);
    const first = await onlineCaptain();
    expect((await ops.assign(order.id, first.captainId)).statusCode).toBe(200);
    const second = await onlineCaptain();
    const busy = await ops.assign(order.id, second.captainId);
    expect(busy.statusCode).toBe(409);
    expect(busy.json().error).toBe('order_not_assignable');
    expect((await ops.assign(randomUUID(), second.captainId)).statusCode).toBe(404);
    expect((await ops.assign((await acceptedOrder()).id, randomUUID())).statusCode).toBe(404);
  });

  it('refuses a captain out of range or offline, and one with an open offer', async () => {
    const ops = await admin(['OPS']);
    // About 5.5 km east, beyond the 3 km search radius.
    const far = await onlineCaptain({ latitude: 36.587, longitude: 37.108 });
    const outOfRange = await ops.assign((await acceptedOrder()).id, far.captainId);
    expect(outOfRange.json()).toMatchObject({
      error: 'captain_not_eligible',
      reasons: ['out_of_range'],
    });
    const gone = await onlineCaptain();
    await app.get(CaptainsService).goOffline(gone.captainId, new Date());
    const offline = await ops.assign((await acceptedOrder()).id, gone.captainId);
    expect(offline.json()).toMatchObject({ error: 'captain_not_eligible', reasons: ['offline'] });
    const captain = await onlineCaptain();
    expect((await ops.assign((await acceptedOrder()).id, captain.captainId)).statusCode).toBe(200);
    const second = await ops.assign((await acceptedOrder()).id, captain.captainId);
    expect(second.json().error).toBe('captain_has_offer');
  });

  it('lets OWN and OPS assign, and refuses SUP and FIN with 403', async () => {
    const captain = await onlineCaptain();
    for (const role of ['SUP', 'FIN']) {
      const refused = await (
        await admin([role])
      ).assign((await acceptedOrder()).id, captain.captainId);
      expect(refused.statusCode).toBe(403);
    }
    expect(
      (await (await admin(['OWN'])).assign((await acceptedOrder()).id, captain.captainId))
        .statusCode,
    ).toBe(200);
  });
});

describe('a direct assignment (dispatch.manual_assign_requires_accept off, CA §8.4)', () => {
  it("makes the order the captain's at once, with no offer", async () => {
    const settings = app.get(SettingsService);
    await settings.update(
      'dispatch.manual_assign_requires_accept',
      { cityId: azaz },
      false,
      bySystem,
    );
    try {
      const order = await acceptedOrder();
      const captain = await onlineCaptain();
      const ops = await admin(['OPS']);
      const answer = await ops.assign(order.id, captain.captainId);
      expect(answer.statusCode).toBe(200);
      expect(answer.json().order).toMatchObject({
        captainTrack: 'assigned',
        captainId: captain.captainId,
        offer: null,
      });
      const event = await sql.query(
        "SELECT actor_type, actor_id FROM ordering.order_events WHERE order_id = $1 AND type = 'order.assigned'",
        [order.id],
      );
      expect(event.rows).toEqual([{ actor_type: 'admin', actor_id: ops.accountId }]);
      const offers = await sql.query('SELECT 1 FROM dispatch.offers WHERE order_id = $1', [
        order.id,
      ]);
      expect(offers.rowCount).toBe(0);
    } finally {
      await settings.update(
        'dispatch.manual_assign_requires_accept',
        { cityId: azaz },
        true,
        bySystem,
      );
    }
  });
});
