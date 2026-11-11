import 'reflect-metadata';
import { randomBytes, randomInt, randomUUID } from 'node:crypto';
import type { NestFastifyApplication } from '@nestjs/platform-fastify';
import pg from 'pg';
import { afterAll, afterEach, beforeAll, describe, expect, it, vi } from 'vitest';
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
import { AutoDispatcher, DispatchService } from './index.js';

// Manual dispatch (D6; AP §9.3.2, §9.12.6, §8.3; CA §8, §15): operations
// offer an accepted order to an eligible captain, who accepts or declines it
// within dispatch.offer_timeout_sec, or it expires; or, with
// dispatch.manual_assign_requires_accept off, assign it directly.
// Each test signs in the three parties, places and accepts an order and
// waits on the offer timers: up to 3 s alone, so the default 5 s is too short
// for a full parallel run.
vi.setConfig({ testTimeout: 30_000 });

let database: TestDatabase;
let cache: TestValkey;
let app: NestFastifyApplication;
let sql: pg.Pool;
// The migration role, to move an offer back in time.
let migrator: pg.Pool;
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
async function acceptedOrder(
  at: { restaurant: string; item: string; home: Point } = { restaurant, item, home },
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
      const due = new Date(Date.now() + 46 * SECOND);
      expect(await dispatch.expire(job, due)).toBe(true);
      expect(await dispatch.expire(job, due)).toBe(false);
      expect((await offerRow(offer.id)).status).toBe('expired');
      // Its search had not started yet: no track until it does.
      expect(await orderRow(order.id)).toMatchObject({ captain_track: null });
      const late = await captain.call('POST', `/v1/captain/offers/${offer.id}/accept`);
      expect(late.json().error).toBe('offer_unavailable');
      const state = (await captain.call('GET', '/v1/captain/availability')).json().availability;
      expect(state.state).toBe(round < 3 ? 'online_available' : 'offline');
      // CA §7.4: the app says why until the captain is online again.
      expect(state.offersExpired).toBe(round < 3 ? null : 3);
    }
    const ended = await sql.query(
      'SELECT end_reason FROM captains.online_periods WHERE captain_id = $1',
      [captain.captainId],
    );
    expect(ended.rows).toEqual([{ end_reason: 'offers_expired' }]);
    // CA §7.4, §14 #3: the push and its chime, once.
    const { rows: pushes } = await sql.query(
      `SELECT body, level FROM notifications.push_messages WHERE captain_id = $1
        AND template_key = 'captain.auto_offline'`,
      [captain.captainId],
    );
    expect(pushes).toEqual([
      {
        body: 'لم ترد على 3 عروض متتالية، فأصبحت غير متصل. اضغط «متصل» عندما تكون جاهزاً.',
        level: 'chime',
      },
    ]);
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

describe('the assignment picker (AP §9.3.2)', () => {
  it('lists the eligible captains with their distance, ETA and cash, and greys out the rest', async () => {
    const order = await acceptedOrder();
    const near = await onlineCaptain();
    const far = await onlineCaptain({ latitude: 36.587, longitude: 37.108 });
    const ops = await admin(['OPS']);
    const answer = await ops.get(`/v1/admin/orders/${order.id}/captains`);
    expect(answer.statusCode).toBe(200);
    const listed = new Map(
      (
        answer.json().captains as { captainId: string; distanceMetres: number; etaMin: number }[]
      ).map((each) => [each.captainId, each]),
    );
    expect(listed.get(near.captainId)).toMatchObject({
      name: 'كابتن التوزيع',
      vehicle: 'motorbike',
      eligible: true,
      reasons: [],
      ordersToday: 0,
      custody: { usage: { amount: '0', currency: 'TRY' }, limit: { amount: '300000' } },
      acceptanceRate: null,
    });
    const nearDistance = listed.get(near.captainId)!.distanceMetres;
    expect(nearDistance).toBeGreaterThan(1000);
    expect(listed.get(near.captainId)!.etaMin).toBeGreaterThan(0);
    expect(listed.get(far.captainId)).toMatchObject({
      eligible: false,
      reasons: ['out_of_range'],
      etaMin: null,
    });
    // Nearest first.
    const order_ = [...listed.keys()];
    expect(order_.indexOf(near.captainId)).toBeLessThan(order_.indexOf(far.captainId));
    expect((await ops.get(`/v1/admin/orders/${randomUUID()}/captains`)).statusCode).toBe(404);
    expect(
      (await (await admin(['SUP'])).get(`/v1/admin/orders/${order.id}/captains`)).statusCode,
    ).toBe(403);
  });
});

describe('«أقصى مبلغ أحمله» (C4, K2, CA §8.4, §10.5)', () => {
  const setMax = (captain: { headers: Record<string, string> }, amount: string | null) =>
    app.inject({
      method: 'PUT',
      url: '/v1/captain/settings/max-pickup-amount',
      headers: captain.headers,
      payload: { amount },
    });

  it('keeps the captain’s answer: none at first, a limit in the base, then no limit', async () => {
    const captain = await onlineCaptain();
    const first = await app.inject({
      method: 'GET',
      url: '/v1/captain/settings/max-pickup-amount',
      headers: captain.headers,
    });
    expect(first.statusCode).toBe(200);
    expect(first.json()).toEqual({ limit: null, answered: false, baseCurrency: 'TRY' });
    const set = await setMax(captain, '50000');
    expect(set.statusCode).toBe(200);
    expect(set.json()).toEqual({
      limit: { amount: '50000', currency: 'TRY' },
      answered: true,
      baseCurrency: 'TRY',
    });
    const none = await setMax(captain, null);
    expect(none.json()).toEqual({ limit: null, answered: true, baseCurrency: 'TRY' });
    expect((await setMax(captain, '0')).statusCode).toBe(400);
    expect((await setMax(captain, '-5')).statusCode).toBe(400);
    expect((await setMax(captain, '9223372036854775808')).statusCode).toBe(400);
  });

  it('greys the captain out in the picker, and lets operations send an offer with the warning', async () => {
    const order = await acceptedOrder();
    const captain = await onlineCaptain();
    const roomy = await onlineCaptain();
    // The order's items value is 12000 minor units.
    await setMax(captain, '11999');
    await setMax(roomy, '12000');
    const ops = await admin(['OPS']);
    const picker = await ops.get(`/v1/admin/orders/${order.id}/captains`);
    const listed = new Map(
      (picker.json().captains as { captainId: string }[]).map((each) => [each.captainId, each]),
    );
    expect(listed.get(captain.captainId)).toMatchObject({
      eligible: false,
      reasons: ['above_max_pickup'],
    });
    expect(listed.get(roomy.captainId)).toMatchObject({ eligible: true, reasons: [] });
    expect(picker.json().assignsAsOffer).toBe(true);
    // A handover, the capacity check and the search start ask with no
    // pickup payment, so the limit never greys the captain out (CA §9.10.1,
    // AP §9.12.6).
    const unpaid = await app.get(CaptainsService).candidates(azaz, centre, 0, new Date(), null);
    expect(unpaid.find((each) => each.captainId === captain.captainId)?.reasons).toEqual([]);

    const answer = await ops.assign(order.id, captain.captainId);
    expect(answer.statusCode).toBe(200);
    const offerId = answer.json().order.offer.id as string;
    expect((await offerRow(offerId)).above_max_pickup).toBe(true);
    const current = await captain.call('GET', '/v1/captain/offers/current');
    expect(current.json().offer).toMatchObject({
      id: offerId,
      aboveMaxPickup: true,
      pickupPayment: { amount: '12000', currency: 'TRY' },
    });
    // The captain may accept it (K2).
    expect((await captain.call('POST', `/v1/captain/offers/${offerId}/accept`)).statusCode).toBe(
      200,
    );
    // CA §10.5, §15: not changed during an order.
    const during = await setMax(captain, '20000');
    expect(during.statusCode).toBe(409);
    expect(during.json()).toMatchObject({ error: 'active_order' });
  });

  it('keeps the limit and its currency together and above zero (a CHECK)', async () => {
    const captain = await onlineCaptain();
    await expect(
      sql.query(
        'UPDATE captains.captains SET max_pickup_amount = 0, max_pickup_currency = $2, max_pickup_set_at = now() WHERE id = $1',
        [captain.captainId, 'TRY'],
      ),
    ).rejects.toThrow(/captains_max_pickup/);
    await expect(
      sql.query(
        'UPDATE captains.captains SET max_pickup_amount = 100, max_pickup_set_at = now() WHERE id = $1',
        [captain.captainId],
      ),
    ).rejects.toThrow(/captains_max_pickup/);
  });

  it('marks no warning on an offer within the limit', async () => {
    const order = await acceptedOrder();
    const captain = await onlineCaptain();
    await setMax(captain, '12000');
    const answer = await (await admin(['OPS'])).assign(order.id, captain.captainId);
    const current = await captain.call('GET', '/v1/captain/offers/current');
    expect(current.json().offer).toMatchObject({
      id: answer.json().order.offer.id,
      aboveMaxPickup: false,
    });
  });

  it('refuses a direct assignment above the limit, which the captain could not decline', async () => {
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
      await setMax(captain, '100');
      const answer = await (await admin(['OPS'])).assign(order.id, captain.captainId);
      expect(answer.statusCode).toBe(409);
      expect(answer.json()).toMatchObject({
        error: 'captain_not_eligible',
        reasons: ['above_max_pickup'],
      });
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

describe('the operations board and order detail (AP §9.2, §9.3.1)', () => {
  it('shows every live order of the city with its captain, badges and passed alerts', async () => {
    const order = await acceptedOrder();
    const sup = await admin(['SUP']);
    const board = await sup.get(`/v1/admin/orders?cityId=${azaz}`);
    expect(board.statusCode).toBe(200);
    const card = (board.json().orders as { id: string }[]).find((each) => each.id === order.id);
    expect(card).toMatchObject({
      status: 'accepted',
      restaurant: { id: restaurant, name: 'مطعم التوزيع' },
      neighbourhood: 'المركز',
      captainTrack: null,
      captain: null,
      total: { amount: '16000', currency: 'TRY' },
      badges: { needsAssignment: false, note: false, newCustomer: true },
      alerts: [],
    });
    // The search started 6 minutes ago (dispatch.no_captain_alert_min is 5).
    await sql.query(
      "UPDATE ordering.orders SET captain_track = 'searching', search_started_at = now() - interval '6 minutes', search_alert_at = now() - interval '1 minute' WHERE id = $1",
      [order.id],
    );
    const later = (
      (await sup.get(`/v1/admin/orders?cityId=${azaz}`)).json().orders as { id: string }[]
    ).find((each) => each.id === order.id);
    expect(later).toMatchObject({
      captainTrack: 'searching',
      badges: { needsAssignment: true },
      alerts: ['no_captain'],
    });

    // Assigned: the captain on the card, the alert gone, the timeline told.
    const captain = await onlineCaptain();
    const assigned = await (await admin(['OPS'])).assign(order.id, captain.captainId);
    const offerId = assigned.json().order.offer.id;
    expect((await captain.call('POST', `/v1/captain/offers/${offerId}/accept`)).statusCode).toBe(
      200,
    );
    const detail = await sup.get(`/v1/admin/orders/${order.id}`);
    expect(detail.statusCode).toBe(200);
    const shown = detail.json().order;
    expect(shown).toMatchObject({
      captainTrack: 'assigned',
      captain: { id: captain.captainId, name: 'كابتن التوزيع', vehicle: 'motorbike' },
      alerts: [],
      customer: { address: { street: 'شارع السوق', landmark: 'قرب الجامع' } },
      money: { itemsValue: '12000', total: '16000', pickupPayment: '12000' },
      lines: [{ name: 'شاورما', quantity: 1, lineTotal: '12000' }],
    });
    expect((shown.timeline as { type: string }[]).map((event) => event.type)).toEqual([
      'order.placed',
      'order.accepted',
      'order.offered',
      'order.assigned',
    ]);
    expect(shown.timeline[3]).toMatchObject({
      actor: { type: 'captain', id: captain.captainId },
      captainId: captain.captainId,
    });
    expect((await sup.get(`/v1/admin/orders/${randomUUID()}`)).statusCode).toBe(404);
    expect((await (await admin(['DATA'])).get(`/v1/admin/orders?cityId=${azaz}`)).statusCode).toBe(
      403,
    );
  });
});

describe('dispatch under races and repeats (AP §9.12.6, architecture §5.3)', () => {
  it('gives one captain one order when two assigns race, and one order one captain', async () => {
    const ops = await admin(['OPS']);
    const captain = await onlineCaptain();
    const [a, b] = [await acceptedOrder(), await acceptedOrder()];
    const both = await Promise.all([
      ops.assign(a.id, captain.captainId),
      ops.assign(b.id, captain.captainId),
    ]);
    expect(both.map((each) => each.statusCode).sort()).toEqual([200, 409]);
    const order = await acceptedOrder();
    const [first, second] = [await onlineCaptain(), await onlineCaptain()];
    const raced = await Promise.all([
      ops.assign(order.id, first.captainId),
      ops.assign(order.id, second.captainId),
    ]);
    expect(raced.map((each) => each.statusCode).sort()).toEqual([200, 409]);
    const open = await sql.query(
      "SELECT count(*)::int AS n FROM dispatch.offers WHERE order_id = $1 AND status = 'open'",
      [order.id],
    );
    expect(open.rows[0].n).toBe(1);
  });

  it('answers a repeated assign once, and refuses its key with another command (422)', async () => {
    const ops = await admin(['OPS']);
    const captain = await onlineCaptain();
    const order = await acceptedOrder();
    const key = randomUUID();
    const first = await ops.assign(order.id, captain.captainId, key);
    const repeat = await ops.assign(order.id, captain.captainId, key);
    expect(repeat.statusCode).toBe(200);
    expect(repeat.json().order.offer.id).toBe(first.json().order.offer.id);
    const other = await onlineCaptain();
    expect((await ops.assign(order.id, other.captainId, key)).statusCode).toBe(422);
  });

  it('refuses accepting an offer past its time before the worker expired it, and frees the order', async () => {
    const ops = await admin(['OPS']);
    const captain = await onlineCaptain();
    const order = await acceptedOrder();
    const offer = (await ops.assign(order.id, captain.captainId)).json().order.offer;
    await migrator.query(
      "UPDATE dispatch.offers SET offered_at = offered_at - interval '1 minute', expires_at = expires_at - interval '1 minute' WHERE id = $1",
      [offer.id],
    );
    const late = await captain.call('POST', `/v1/captain/offers/${offer.id}/accept`);
    expect(late.json().error).toBe('offer_unavailable');
    expect((await captain.call('GET', '/v1/captain/offers/current')).json().offer).toBeNull();
    // Operations may offer the order again at once: the late offer expires.
    const other = await onlineCaptain();
    const again = await ops.assign(order.id, other.captainId);
    expect(again.statusCode).toBe(200);
    expect((await offerRow(offer.id)).status).toBe('expired');
  });

  it('withdraws the open offer when the captain goes offline, freeing the order', async () => {
    const ops = await admin(['OPS']);
    const captain = await onlineCaptain();
    const order = await acceptedOrder();
    const offer = (await ops.assign(order.id, captain.captainId)).json().order.offer;
    expect((await captain.call('POST', '/v1/captain/availability/offline')).statusCode).toBe(200);
    expect((await offerRow(offer.id)).status).toBe('withdrawn');
    expect(await orderRow(order.id)).toMatchObject({ captain_track: null });
    expect((await ops.assign(order.id, (await onlineCaptain()).captainId)).statusCode).toBe(200);
  });

  it('starts the C3 run again after a decline and after going offline (CA §7.4)', async () => {
    const dispatch = app.get(DispatchService);
    const captain = await onlineCaptain();
    const ops = await admin(['OPS']);
    const offerAndExpire = async () => {
      const order = await acceptedOrder();
      const offer = (await ops.assign(order.id, captain.captainId)).json().order.offer;
      const job = { offerId: offer.id, orderId: order.id, orderPlacedAt: order.placedAt };
      await migrator.query(
        "UPDATE dispatch.offers SET offered_at = offered_at - interval '1 minute', expires_at = expires_at - interval '1 minute' WHERE id = $1",
        [offer.id],
      );
      expect(await dispatch.expire(job, new Date())).toBe(true);
    };
    await offerAndExpire();
    await offerAndExpire();
    const declined = await acceptedOrder();
    const offer = (await ops.assign(declined.id, captain.captainId)).json().order.offer;
    await captain.call('POST', `/v1/captain/offers/${offer.id}/decline`);
    await offerAndExpire();
    const state = async () =>
      (await captain.call('GET', '/v1/captain/availability')).json().availability.state;
    expect(await state()).toBe('online_available');
    // Offline and back: the earlier expired offers no longer count.
    await captain.call('POST', '/v1/captain/availability/offline');
    const captains = app.get(CaptainsService);
    const now = new Date();
    await captains.goOnline(
      captain.captainId,
      { appVersion: '1.0.0', simulatedLocation: false, termsPending: false },
      now,
    );
    await captains.recordLocations(
      captain.captainId,
      [{ ...captainSpot, accuracyMetres: 8, recordedAt: now, simulated: false }],
      new Date(now.getTime() + 1),
    );
    await offerAndExpire();
    expect(await state()).toBe('online_available');
  });

  it('refuses an order that ended, a captain of another city and a customer on the captain routes', async () => {
    const ops = await admin(['OPS']);
    const captain = await onlineCaptain();
    const order = await acceptedOrder();
    await sql.query(
      "UPDATE ordering.orders SET status = 'cancelled', version = version + 1, cancelled_at = now(), cancel_reason = 'test', food_prepared = false WHERE id = $1",
      [order.id],
    );
    expect((await ops.assign(order.id, captain.captainId)).json().error).toBe(
      'order_not_assignable',
    );
    const elsewhere = (
      await sql.query("INSERT INTO geo.cities (code, name) VALUES ('ZZ', 'أخرى') RETURNING id")
    ).rows[0].id as string;
    const stranger = (await onlineCaptain()).captainId;
    await sql.query('UPDATE captains.captains SET city_id = $1 WHERE id = $2', [
      elsewhere,
      stranger,
    ]);
    expect((await ops.assign((await acceptedOrder()).id, stranger)).statusCode).toBe(404);
    const customer = await appSignIn('customer', phoneNumber());
    const refused = await app.inject({
      method: 'GET',
      url: '/v1/captain/offers/current',
      headers: customer,
    });
    expect(refused.statusCode).toBe(401);
  });

  it('lets the application role change only the answer of an offer (AP §9.7.4)', async () => {
    const captain = await onlineCaptain();
    const order = await acceptedOrder();
    const offer = (await (await admin(['OPS'])).assign(order.id, captain.captainId)).json().order
      .offer;
    await expect(
      sql.query('UPDATE dispatch.offers SET pickup_metres = 1 WHERE id = $1', [offer.id]),
    ).rejects.toThrow(/permission denied/);
    await expect(
      sql.query('UPDATE dispatch.offers SET above_max_pickup = true WHERE id = $1', [offer.id]),
    ).rejects.toThrow(/permission denied/);
  });

  it('shows the restaurant the captain line (RA §8.1, §8.9)', async () => {
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
      await (await admin(['OPS'])).assign(order.id, captain.captainId);
      const phone = phoneNumber();
      await app
        .get(MerchantAccountsService)
        .addAccount(restaurant, { role: 'owner', name: 'owner', phone }, change);
      const board = await app.inject({
        method: 'GET',
        url: '/v1/merchant/orders',
        headers: await appSignIn('merchant', phone),
      });
      const card = (board.json().orders as { id: string }[]).find((each) => each.id === order.id);
      expect(card).toMatchObject({
        captainTrack: 'assigned',
        captain: { firstName: 'كابتن', vehicle: 'motorbike' },
      });
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

// AP §9.12.6 «آلي» and «مختلط» (slice 2.15b): the dispatcher's pass over the
// city, at a restaurant about 5 km north of the main one, so the manual
// tests' captains are beyond dispatch.search_radius_km.
describe('automatic dispatch (AP §9.12.6, CA §8.1)', () => {
  const north = { latitude: 36.632, longitude: 37.046 };
  const northHome = { latitude: 36.634, longitude: 37.046 };
  let at: { restaurant: string; item: string; home: Point };
  const started: Awaited<ReturnType<typeof onlineCaptain>>[] = [];
  const dispatch = () => app.get(DispatchService);
  const update = (key: 'dispatch.mode' | 'dispatch.max_offers_before_manual', value: unknown) =>
    app.get(SettingsService).update(key, { cityId: azaz }, value as never, bySystem);
  const mode = (value: 'manual' | 'auto' | 'mixed') => update('dispatch.mode', value);

  beforeAll(async () => {
    const merchants = app.get(MerchantsService);
    const id = await merchants.createRestaurant(
      azaz,
      {
        nameAr: 'مطعم الشمال',
        location: north,
        coverage: { kind: 'radius', radiusMetres: 1000 },
        minimumOrder: { amount: 10_000n, currency: 'TRY' },
        commissionBp: 1500,
        defaultPrepMin: 20,
      },
      change,
    );
    await merchants.setAccountStatus(id, 'active', change);
    await merchants.setWeeklySchedule(id, allWeek, change);
    const category = await merchants.addCategory(id, { name: 'وجبات' }, change);
    const northItem = await merchants.addItem(
      id,
      { categoryId: category, name: 'فلافل', price: { amount: 12_000n, currency: 'TRY' } },
      change,
    );
    at = { restaurant: id, item: northItem, home: northHome };
  });

  // Each test's orders leave automatic dispatch after it (the dispatcher
  // would otherwise offer a test's order still waiting to the next test's
  // nearest captain), its captains go offline (a busy one cannot, and is not
  // eligible anyway), and the city goes back to manual.
  afterEach(async () => {
    await sql.query(
      `INSERT INTO dispatch.manual_orders (order_id, order_placed_at, city_id, reason, failed_offers, at)
       SELECT id, placed_at, city_id, 'max_offers', 0, now() FROM ordering.orders WHERE restaurant_id = $1
       ON CONFLICT DO NOTHING`,
      [at.restaurant],
    );
    for (const captain of started.splice(0)) {
      await captain.call('POST', '/v1/captain/availability/offline');
    }
    await mode('manual');
    await update('dispatch.max_offers_before_manual', 5);
  });

  // A captain the given metres north of the restaurant.
  async function captainNorth(metres: number) {
    const captain = await onlineCaptain({
      latitude: north.latitude + metres / 111_195,
      longitude: north.longitude,
    });
    started.push(captain);
    return captain;
  }

  // An accepted order at the north restaurant, its search started (the
  // worker's job), «طلب بلا كابتن» an hour away.
  async function searchingOrder() {
    const order = await acceptedOrder(at);
    await sql.query(
      `UPDATE ordering.orders SET captain_track = 'searching', search_started_at = now(),
         search_alert_at = now() + interval '1 hour' WHERE id = $1`,
      [order.id],
    );
    return order;
  }

  const offersOf = async (orderId: string) =>
    (
      await sql.query(
        'SELECT captain_id, kind, offered_by, status FROM dispatch.offers WHERE order_id = $1 ORDER BY offered_at',
        [orderId],
      )
    ).rows;

  const openOffer = async (orderId: string) =>
    (await offersOf(orderId)).find((offer) => offer.status === 'open');

  const currentOffer = async (captain: Awaited<ReturnType<typeof onlineCaptain>>) =>
    (await captain.call('GET', '/v1/captain/offers/current')).json().offer;

  const manualRow = async (orderId: string) =>
    (
      await sql.query(
        'SELECT reason, failed_offers FROM dispatch.manual_orders WHERE order_id = $1',
        [orderId],
      )
    ).rows;

  it('sends nothing in manual mode (D6)', async () => {
    const order = await searchingOrder();
    await captainNorth(300);
    expect(await dispatch().autoDispatchCity(azaz, new Date())).toBe(0);
    expect(await offersOf(order.id)).toEqual([]);
  });

  it('offers the nearest eligible captain, passing over one above its «أقصى مبلغ أحمله» (C4)', async () => {
    await mode('auto');
    const order = await searchingOrder();
    await captainNorth(1500);
    const near = await captainNorth(600);
    const nearest = await captainNorth(200);
    // 100 TRY, below the order's 120 TRY of items.
    const limited = await app.inject({
      method: 'PUT',
      url: '/v1/captain/settings/max-pickup-amount',
      headers: nearest.headers,
      payload: { amount: '10000' },
    });
    expect(limited.statusCode).toBe(200);
    await dispatch().autoDispatchCity(azaz, new Date());
    expect(await offersOf(order.id)).toEqual([
      { captain_id: near.captainId, kind: 'auto', offered_by: null, status: 'open' },
    ]);
    expect(await orderRow(order.id)).toMatchObject({ captain_track: 'offered' });
    const event = await sql.query(
      "SELECT actor_type FROM ordering.order_events WHERE order_id = $1 AND type = 'order.offered'",
      [order.id],
    );
    expect(event.rows).toEqual([{ actor_type: 'system' }]);
    const job = await sql.query(
      "SELECT 1 FROM pgboss.job WHERE name = $1 AND data->>'orderId' = $2",
      [QUEUES.offerExpiry, order.id],
    );
    expect(job.rowCount).toBe(1);
    // CA §8.2: an automatic offer is not «تعيين من العمليات».
    const offer = await currentOffer(near);
    expect(offer).toMatchObject({ fromOperations: false, pay: { amount: '2500' } });
    expect(offer.restaurant.distanceMetres).toBeGreaterThan(500);
    // One offer at a time: the next pass leaves the order alone.
    await dispatch().autoDispatchCity(azaz, new Date());
    expect(await offersOf(order.id)).toHaveLength(1);
    // Accepted, the order is the captain's.
    const accepted = await near.call('POST', `/v1/captain/offers/${offer.id}/accept`);
    expect(accepted.statusCode).toBe(200);
    expect(await orderRow(order.id)).toMatchObject({ captain_id: near.captainId });
  });

  it('offers the next captain on a decline, an expiry or a withdrawal, never one already offered', async () => {
    await mode('auto');
    const order = await searchingOrder();
    const first = await captainNorth(200);
    const second = await captainNorth(400);
    const third = await captainNorth(600);
    const fourth = await captainNorth(800);

    await dispatch().autoDispatchCity(azaz, new Date());
    expect((await openOffer(order.id))?.captain_id).toBe(first.captainId);
    await first.call('POST', `/v1/captain/offers/${(await currentOffer(first)).id}/decline`);

    await dispatch().autoDispatchCity(azaz, new Date());
    expect((await openOffer(order.id))?.captain_id).toBe(second.captainId);
    const job = {
      offerId: (await currentOffer(second)).id,
      orderId: order.id,
      orderPlacedAt: order.placedAt,
    };
    expect(await dispatch().expire(job, new Date(Date.now() + 46 * SECOND))).toBe(true);

    await dispatch().autoDispatchCity(azaz, new Date());
    expect((await openOffer(order.id))?.captain_id).toBe(third.captainId);
    // Going offline withdraws the offer (CA §7.5).
    await third.call('POST', '/v1/captain/availability/offline');

    await dispatch().autoDispatchCity(azaz, new Date());
    expect((await openOffer(order.id))?.captain_id).toBe(fourth.captainId);
    await fourth.call('POST', `/v1/captain/offers/${(await currentOffer(fourth)).id}/decline`);

    // No captain left who was not offered: nothing, and no new search for
    // 30 seconds; one who comes online meanwhile gets it after them.
    const start = Date.now();
    expect(await dispatch().autoDispatchCity(azaz, new Date(start))).toBe(0);
    const fifth = await captainNorth(1000);
    await dispatch().autoDispatchCity(azaz, new Date(start + 20 * SECOND));
    expect(await openOffer(order.id)).toBeUndefined();
    await dispatch().autoDispatchCity(azaz, new Date(start + 31 * SECOND));
    expect((await openOffer(order.id))?.captain_id).toBe(fifth.captainId);
    expect((await offersOf(order.id)).map((offer) => offer.status)).toEqual([
      'declined',
      'expired',
      'withdrawn',
      'declined',
      'open',
    ]);
  });

  it('passes over a captain with another open offer', async () => {
    await mode('auto');
    const first = await searchingOrder();
    const second = await searchingOrder();
    const near = await captainNorth(200);
    const far = await captainNorth(900);
    await dispatch().autoDispatchCity(azaz, new Date());
    expect((await openOffer(first.id))?.captain_id).toBe(near.captainId);
    expect((await openOffer(second.id))?.captain_id).toBe(far.captainId);
  });

  it('«مختلط»: leaves automatic dispatch after dispatch.max_offers_before_manual failed offers', async () => {
    await mode('mixed');
    await update('dispatch.max_offers_before_manual', 2);
    const order = await searchingOrder();
    const first = await captainNorth(200);
    const second = await captainNorth(400);
    const third = await captainNorth(600);
    for (const captain of [first, second]) {
      await dispatch().autoDispatchCity(azaz, new Date());
      await captain.call('POST', `/v1/captain/offers/${(await currentOffer(captain)).id}/decline`);
    }
    expect(await dispatch().autoDispatchCity(azaz, new Date())).toBe(0);
    expect(await offersOf(order.id)).toHaveLength(2);
    expect(await manualRow(order.id)).toEqual([{ reason: 'max_offers', failed_offers: 2 }]);
    // «بحاجة لتعيين»: operations offer it by hand.
    expect(await orderRow(order.id)).toMatchObject({ captain_track: 'searching' });
    const assigned = await (await admin(['OPS'])).assign(order.id, third.captainId);
    expect(assigned.statusCode).toBe(200);
  });

  // The order's card on the board.
  const cardOf = async (orderId: string) =>
    (
      (await (await admin(['SUP'])).get(`/v1/admin/orders?cityId=${azaz}`)).json().orders as {
        id: string;
      }[]
    ).find((each) => each.id === orderId) as Record<string, unknown>;

  it('shows the dispatch state on the card: «بحاجة لتعيين» only once the order left automatic dispatch', async () => {
    await mode('mixed');
    await update('dispatch.max_offers_before_manual', 2);
    const order = await searchingOrder();
    expect(await cardOf(order.id)).toMatchObject({
      captainTrack: 'searching',
      badges: { needsAssignment: false },
      dispatch: { mode: 'mixed', manual: null, autoOffers: 0, maxOffers: 2 },
    });
    const first = await captainNorth(200);
    const second = await captainNorth(400);
    await dispatch().autoDispatchCity(azaz, new Date());
    expect(await cardOf(order.id)).toMatchObject({
      captainTrack: 'offered',
      dispatch: { autoOffers: 1, maxOffers: 2 },
    });
    for (const captain of [first, second]) {
      if (captain === second) await dispatch().autoDispatchCity(azaz, new Date());
      await captain.call('POST', `/v1/captain/offers/${(await currentOffer(captain)).id}/decline`);
    }
    await dispatch().autoDispatchCity(azaz, new Date());
    const card = await cardOf(order.id);
    expect(card).toMatchObject({
      badges: { needsAssignment: true },
      dispatch: { mode: 'mixed', manual: { reason: 'max_offers' }, autoOffers: 2 },
    });
    // The move is an event of the order, so the board hears it (AP §9.3.1).
    const event = await sql.query(
      "SELECT actor_type, reason FROM ordering.order_events WHERE order_id = $1 AND type = 'order.moved_to_manual'",
      [order.id],
    );
    expect(event.rows).toEqual([{ actor_type: 'system', reason: 'max_offers' }]);
    expect(await outboxTypes(order.id)).toContain('order.moved_to_manual');
    // In «آلي» there is no limit; in «يدوي» every searching order needs
    // assignment (D6).
    const other = await searchingOrder();
    await mode('auto');
    expect(await cardOf(other.id)).toMatchObject({
      badges: { needsAssignment: false },
      dispatch: { mode: 'auto', manual: null, maxOffers: null },
    });
    await mode('manual');
    expect(await cardOf(other.id)).toMatchObject({
      badges: { needsAssignment: true },
      dispatch: { mode: 'manual' },
    });
  });

  it('«توزيع يدوي لهذا الطلب»: takes the order out, its open offer keeping its time (AP §9.3.2)', async () => {
    await mode('auto');
    const order = await searchingOrder();
    const first = await captainNorth(200);
    await captainNorth(400);
    await dispatch().autoDispatchCity(azaz, new Date());
    const offer = await currentOffer(first);
    expect(offer).not.toBeNull();

    const ops = await admin(['OPS']);
    const key = randomUUID();
    const moved = await ops.manualDispatch(order.id, key);
    expect(moved.statusCode).toBe(200);
    expect(moved.json().order).toMatchObject({
      captainTrack: 'offered',
      offer: { id: offer.id, captainId: first.captainId },
    });
    const row = await sql.query(
      'SELECT reason, failed_offers, by FROM dispatch.manual_orders WHERE order_id = $1',
      [order.id],
    );
    expect(row.rows).toEqual([{ reason: 'operations', failed_offers: 0, by: ops.accountId }]);
    const event = await sql.query(
      "SELECT actor_type, actor_id, reason FROM ordering.order_events WHERE order_id = $1 AND type = 'order.moved_to_manual'",
      [order.id],
    );
    expect(event.rows).toEqual([
      { actor_type: 'admin', actor_id: ops.accountId, reason: 'operations' },
    ]);
    const audit = await sql.query(
      "SELECT 1 FROM audit.events WHERE action = 'order.manual_dispatch' AND target_id = $1",
      [order.id],
    );
    expect(audit.rowCount).toBe(1);
    // A repeat answers again; another key finds it out already.
    expect((await ops.manualDispatch(order.id, key)).statusCode).toBe(200);
    const again = await ops.manualDispatch(order.id);
    expect(again.statusCode).toBe(409);
    expect(again.json().error).toBe('order_not_automatic');

    // The open offer keeps its time; declined, no automatic offer follows.
    expect((await offerRow(offer.id)).status).toBe('open');
    await first.call('POST', `/v1/captain/offers/${offer.id}/decline`);
    expect(await dispatch().autoDispatchCity(azaz, new Date())).toBe(0);
    expect(await cardOf(order.id)).toMatchObject({
      captainTrack: 'searching',
      badges: { needsAssignment: true },
      dispatch: { mode: 'auto', manual: { reason: 'operations' }, autoOffers: 1 },
    });
  });

  it('refuses «توزيع يدوي لهذا الطلب» in manual mode, after assignment, and to SUP', async () => {
    const order = await searchingOrder();
    const ops = await admin(['OPS']);
    const manual = await ops.manualDispatch(order.id);
    expect(manual.statusCode).toBe(409);
    expect(manual.json().error).toBe('order_not_automatic');
    await mode('auto');
    expect((await (await admin(['SUP'])).manualDispatch(order.id)).statusCode).toBe(403);
    expect((await ops.manualDispatch(randomUUID())).statusCode).toBe(404);
    const captain = await captainNorth(200);
    expect((await ops.assign(order.id, captain.captainId)).statusCode).toBe(200);
    await captain.call('POST', `/v1/captain/offers/${(await currentOffer(captain)).id}/accept`);
    const assigned = await ops.manualDispatch(order.id);
    expect(assigned.statusCode).toBe(409);
    expect(assigned.json().error).toBe('order_not_assignable');
  });

  it("lists the order's offers with the captain, the answer and the response time (AP §9.7.4)", async () => {
    await mode('auto');
    const order = await searchingOrder();
    const first = await captainNorth(200);
    const second = await captainNorth(400);
    await dispatch().autoDispatchCity(azaz, new Date());
    await first.call('POST', `/v1/captain/offers/${(await currentOffer(first)).id}/decline`);
    await dispatch().autoDispatchCity(azaz, new Date());
    const sup = await admin(['SUP']);
    const log = await sup.get(`/v1/admin/orders/${order.id}/offers`);
    expect(log.statusCode).toBe(200);
    const offers = log.json().offers as Record<string, unknown>[];
    expect(offers).toMatchObject([
      {
        captain: { id: first.captainId, name: 'كابتن التوزيع' },
        kind: 'auto',
        handover: false,
        status: 'declined',
      },
      {
        captain: { id: second.captainId },
        kind: 'auto',
        status: 'open',
        respondedAt: null,
        responseSec: null,
      },
    ]);
    expect(offers[0]!.responseSec).toEqual(expect.any(Number));
    expect(offers[0]!.respondedAt).toEqual(expect.any(String));
    expect((await sup.get(`/v1/admin/orders/${randomUUID()}/offers`)).statusCode).toBe(404);
    expect(
      (await (await admin(['DATA'])).get(`/v1/admin/orders/${order.id}/offers`)).statusCode,
    ).toBe(403);
  });

  it('«مختلط»: leaves automatic dispatch at the no-captain alert, while «آلي» keeps searching', async () => {
    const order = await searchingOrder();
    const captain = await captainNorth(200);
    await sql.query(
      "UPDATE ordering.orders SET search_alert_at = now() - interval '1 second' WHERE id = $1",
      [order.id],
    );
    await mode('auto');
    await dispatch().autoDispatchCity(azaz, new Date());
    expect((await openOffer(order.id))?.captain_id).toBe(captain.captainId);
    await captain.call('POST', `/v1/captain/offers/${(await currentOffer(captain)).id}/decline`);

    await mode('mixed');
    await captainNorth(300);
    expect(await dispatch().autoDispatchCity(azaz, new Date())).toBe(0);
    expect(await manualRow(order.id)).toEqual([{ reason: 'no_captain_alert', failed_offers: 1 }]);
    // Back in «آلي», an order left to operations stays theirs.
    await mode('auto');
    expect(await dispatch().autoDispatchCity(azaz, new Date())).toBe(0);
    expect(await offersOf(order.id)).toHaveLength(1);
  });
});

describe('the dispatcher role (architecture §4.4)', () => {
  it('leads each city from one process at a time, and hands over when it stops', async () => {
    const passes: string[] = [];
    const counting = (name: string) =>
      ({
        autoDispatchCity: (cityId: string) => {
          if (cityId === azaz) passes.push(name);
          return Promise.resolve(0);
        },
      }) as unknown as DispatchService;
    const first = new AutoDispatcher(db, app.get(GeoService), counting('first'));
    const second = new AutoDispatcher(db, app.get(GeoService), counting('second'));
    try {
      await first.tick();
      await second.tick();
      await first.tick();
      expect(passes).toEqual(['first', 'first']);
      await first.onModuleDestroy();
      await second.tick();
      expect(passes).toEqual(['first', 'first', 'second']);
      // The leader's session ends on the server: it connects again and
      // takes the free lock at its next tick, so the city keeps one leader.
      await sql.query(
        "SELECT pg_terminate_backend(pid) FROM pg_locks WHERE locktype = 'advisory' AND pid <> pg_backend_pid()",
      );
      await second.tick();
      await second.tick();
      expect(passes.at(-1)).toBe('second');
      const third = new AutoDispatcher(db, app.get(GeoService), counting('third'));
      try {
        await third.tick();
        expect(passes).not.toContain('third');
      } finally {
        await third.onModuleDestroy();
      }
    } finally {
      await first.onModuleDestroy();
      await second.onModuleDestroy();
    }
  });

  it('keeps a fallback to manual as logged: the application role cannot change it', async () => {
    await expect(
      sql.query("UPDATE dispatch.manual_orders SET reason = 'max_offers'"),
    ).rejects.toThrow(/permission denied/);
    // Operations' move names its admin, and only it does (a CHECK).
    const insert = (reason: string, by: string | null) =>
      sql.query(
        `INSERT INTO dispatch.manual_orders (order_id, order_placed_at, city_id, reason, failed_offers, at, by)
         VALUES ($1, now(), $2, $3, 0, now(), $4)`,
        [randomUUID(), azaz, reason, by],
      );
    await expect(insert('operations', null)).rejects.toThrow(/manual_orders_by/);
    await expect(insert('max_offers', randomUUID())).rejects.toThrow(/manual_orders_by/);
  });
});
