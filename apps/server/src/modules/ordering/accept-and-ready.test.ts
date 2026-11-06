import 'reflect-metadata';
import { randomBytes, randomInt, randomUUID } from 'node:crypto';
import type { NestFastifyApplication } from '@nestjs/platform-fastify';
import pg from 'pg';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { ApiModule } from '../../api.module.js';
import { startTestDatabase, type TestDatabase } from '../../database/test-database.js';
import { createApiApp } from '../../http/create-api-app.js';
import { QUEUES } from '../../jobs/job-queue.js';
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

// RA §8.5, §8.7–8.8, §18, §4.7; AP §8.3; docs/domain/03: the restaurant
// accepts a placed order with a prep time, which sets the promised time and
// the search-start moment, then marks it ready. Owners and cashiers alike;
// every command carries its Idempotency-Key, and a command the order's state
// no longer allows answers the current order.
let database: TestDatabase;
let cache: TestValkey;
let app: NestFastifyApplication;
let sql: pg.Pool;
let azaz: string;
let restaurant: string;
let otherRestaurant: string;
let item: string;

const system = { type: 'system', id: null, role: null } as const;
const change = { actor: system, context: { ipAddress: null, device: null }, reason: 'test' };
const bySystem = { editor: 'system', context: change.context, reason: 'test' } as const;
const centre = { latitude: 36.587, longitude: 37.046 };
// About 330 m north of the restaurant, inside its 1 km.
const home = { latitude: 36.59, longitude: 37.046 };
const allWeek = [0, 1, 2, 3, 4, 5, 6].map((weekday) => ({ weekday, opensAt: 0, closesAt: 0 }));
const MINUTE = 60_000;

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
  app = await createApiApp(ApiModule);
  await app.init();
  await app.getHttpAdapter().getInstance().ready();
  azaz = (await sql.query("SELECT id FROM geo.cities WHERE code = 'AZ'")).rows[0].id;
  const fx = app.get(FxService);
  await fx.setCityCurrency(azaz, { currency: 'TRY', displayOrder: 1, enabled: true }, change);
  await fx.setBaseCurrency(azaz, 'TRY', change);
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
  const category = await merchants.addCategory(restaurant, { name: 'وجبات' }, change);
  item = await merchants.addItem(
    restaurant,
    { categoryId: category, name: 'شاورما', price: { amount: 12_000n, currency: 'TRY' } },
    change,
  );
}, 300_000);

afterAll(async () => {
  await app?.close();
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

async function placed(
  customer?: Record<string, string>,
): Promise<{ id: string; placedAt: string; headers: Record<string, string> }> {
  const headers = customer ?? (await signedIn('customer'));
  const lines = [{ itemId: item, optionIds: [], quantity: 1, note: null, knownUnitPrice: '12000' }];
  const quote = await app.inject({
    method: 'POST',
    url: '/v1/customer/quote',
    payload: { restaurantId: restaurant, location: home, lines, payIn: null, appVersion: '1.0.0' },
  });
  const answer = await app.inject({
    method: 'POST',
    url: '/v1/customer/orders',
    headers: { ...headers, 'idempotency-key': randomUUID() },
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
  expect(answer.statusCode).toBe(201);
  return { ...answer.json().order, headers };
}

const command = (
  verb: 'accept' | 'ready',
  orderId: string,
  headers: Record<string, string>,
  { key = randomUUID() as string | null, payload = {} as object } = {},
) =>
  app.inject({
    method: 'POST',
    url: `/v1/merchant/orders/${orderId}/${verb}`,
    headers: key === null ? headers : { ...headers, 'idempotency-key': key },
    payload,
  });

const accept = (
  orderId: string,
  headers: Record<string, string>,
  prepMin = 20,
  key: string = randomUUID(),
) => command('accept', orderId, headers, { key, payload: { prepMin } });

const row = async (id: string) =>
  (
    await sql.query(
      `SELECT status, version, accepted_at, prep_min, promised_at, search_start_at,
              prep_late_alert_at, ready_at, no_captain_alert_at, trip_seconds, trip_metres
         FROM ordering.orders WHERE id = $1`,
      [id],
    )
  ).rows[0];

const outboxTypes = async (id: string) =>
  (
    await sql.query('SELECT type FROM ordering.outbox WHERE order_id = $1 ORDER BY id', [id])
  ).rows.map((entry) => entry.type);

const ceilTo5 = (ms: number) => Math.ceil(ms / (5 * MINUTE)) * 5 * MINUTE;

describe('placing keeps the trip of the estimate (docs/domain/03)', () => {
  it('keeps its duration and distance on the order', async () => {
    const order = await placed();
    const kept = await row(order.id);
    // About 330 m by the straight line × 1.3 at 20 km/h: about 77 s.
    expect(kept.trip_metres).toBeGreaterThan(400);
    expect(kept.trip_metres).toBeLessThan(500);
    expect(kept.trip_seconds).toBe(Math.ceil((kept.trip_metres / 1000 / 20) * 3600));
  });
});

describe('the order keeps its acceptance and ready time whole (CHECKs)', () => {
  it('refuses an accepted or ready order without them, and a part of them', async () => {
    const order = await placed();
    for (const change of [
      "status = 'accepted'",
      'accepted_at = now(), prep_min = 20',
      "status = 'ready', accepted_at = now(), prep_min = 20, promised_at = now(), search_start_at = now(), prep_late_alert_at = now()",
      'ready_at = now()',
    ]) {
      await expect(
        sql.query(`UPDATE ordering.orders SET ${change} WHERE id = $1`, [order.id]),
      ).rejects.toThrow(/violates check constraint/);
    }
  });
});

describe('POST /v1/merchant/orders/{orderId}/accept (RA §8.5, §18)', () => {
  it('accepts a placed order with its prep time and promised time, once', async () => {
    const order = await placed();
    const cashier = await signedIn('merchant');
    const key = randomUUID();
    const answer = await accept(order.id, cashier, 25, key);
    expect(answer.statusCode).toBe(200);
    const kept = await row(order.id);
    expect(kept).toMatchObject({ status: 'accepted', version: 2, prep_min: 25 });
    const acceptedAt = new Date(kept.accepted_at).getTime();
    // promised = accepted + prep + trip + order.eta_buffer_min (10), up to 5 min.
    expect(new Date(kept.promised_at).getTime()).toBe(
      ceilTo5(acceptedAt + 25 * MINUTE + kept.trip_seconds * 1000 + 10 * MINUTE),
    );
    // Operations' «تحضير متأخر» at order.prep_late_ops_alert_min (10) past it.
    expect(new Date(kept.prep_late_alert_at).getTime()).toBe(acceptedAt + 35 * MINUTE);
    // No captain online: the search starts at once.
    expect(new Date(kept.search_start_at).getTime()).toBe(acceptedAt);
    expect(answer.json().order).toMatchObject({
      id: order.id,
      status: 'accepted',
      version: 2,
      acceptance: {
        at: new Date(acceptedAt).toISOString(),
        prepMin: 25,
        prepDueAt: new Date(acceptedAt + 25 * MINUTE).toISOString(),
        deviceName: 'كاشير 1',
      },
      readyAt: null,
    });

    // The event, with the user and the device (RA §18), and its outbox row.
    const events = await sql.query(
      `SELECT version, from_status, to_status, actor_type, actor_id, actor_device
         FROM ordering.order_events WHERE order_id = $1 ORDER BY version`,
      [order.id],
    );
    expect(events.rows[1]).toMatchObject({
      version: 2,
      from_status: 'placed',
      to_status: 'accepted',
      actor_type: 'restaurant',
    });
    expect(events.rows[1].actor_id).not.toBeNull();
    expect(events.rows[1].actor_device).not.toBeNull();
    expect(await outboxTypes(order.id)).toEqual(['order.placed', 'order.accepted']);

    // The search-start timer, written with the acceptance.
    const jobs = await sql.query(
      "SELECT data, start_after FROM pgboss.job WHERE name = $1 AND data->>'orderId' = $2",
      [QUEUES.searchStart, order.id],
    );
    expect(jobs.rows).toHaveLength(1);
    expect(jobs.rows[0].data).toEqual({ orderId: order.id, placedAt: order.placedAt });
    expect(new Date(jobs.rows[0].start_after).getTime()).toBe(acceptedAt);

    // A repeat of the key answers the order and changes nothing (RA §4.7).
    const repeat = await accept(order.id, cashier, 25, key);
    expect(repeat.statusCode).toBe(200);
    expect(repeat.json().order).toMatchObject({ status: 'accepted', version: 2 });
    expect((await row(order.id)).version).toBe(2);
    // The key with another command is refused.
    expect((await accept(order.id, cashier, 30, key)).statusCode).toBe(422);
  });

  it('lets an owner accept too', async () => {
    const order = await placed();
    const owner = await signedIn('merchant', { role: 'owner', device: 'تابلت المطبخ' });
    const answer = await accept(order.id, owner, 15);
    expect(answer.statusCode).toBe(200);
    expect(answer.json().order.acceptance).toMatchObject({
      prepMin: 15,
      deviceName: 'تابلت المطبخ',
    });
  });

  it('answers a second accept from another device with 409 and the current order', async () => {
    const order = await placed();
    const first = await signedIn('merchant', { device: 'كاشير 1' });
    const second = await signedIn('merchant', { device: 'كاشير 2' });
    const [one, two] = await Promise.all([accept(order.id, first), accept(order.id, second, 30)]);
    const answers = [one, two].sort((a, b) => a.statusCode - b.statusCode);
    expect(answers.map((answer) => answer.statusCode)).toEqual([200, 409]);
    const accepted = answers[0]!.json().order;
    // «قُبل الطلب من جهاز {اسم الجهاز}»
    expect(answers[1]!.json()).toMatchObject({
      error: 'order_state_changed',
      order: { status: 'accepted', version: 2, acceptance: accepted.acceptance },
    });
    expect(await outboxTypes(order.id)).toEqual(['order.placed', 'order.accepted']);
  });

  it('answers repeats of one key sent together with the one acceptance', async () => {
    const order = await placed();
    const cashier = await signedIn('merchant');
    const key = randomUUID();
    const answers = await Promise.all([
      accept(order.id, cashier, 20, key),
      accept(order.id, cashier, 20, key),
    ]);
    expect(answers.map((answer) => answer.statusCode)).toEqual([200, 200]);
    expect((await row(order.id)).version).toBe(2);
  });

  it('refuses an accept after the automatic cancellation with 409 and the cancelled order', async () => {
    const order = await placed();
    await app
      .get(OrderTimers)
      .merchantAutoCancel({ orderId: order.id, placedAt: order.placedAt, version: 1 }, new Date());
    const answer = await accept(order.id, await signedIn('merchant'));
    expect(answer.statusCode).toBe(409);
    // «أُلغي الطلب قبل وصول قبولك»
    expect(answer.json()).toMatchObject({
      error: 'order_state_changed',
      order: { status: 'cancelled', version: 2, acceptance: null },
    });
  });

  it('leaves the accepted order to the automatic cancellation job (AP §8.3)', async () => {
    const order = await placed();
    expect((await accept(order.id, await signedIn('merchant'))).statusCode).toBe(200);
    expect(
      await app
        .get(OrderTimers)
        .merchantAutoCancel(
          { orderId: order.id, placedAt: order.placedAt, version: 1 },
          new Date(),
        ),
    ).toBe(false);
    expect((await row(order.id)).status).toBe('accepted');
  });

  it('refuses a prep time outside merchant.prep_time_floor_min and ceiling with 400', async () => {
    const order = await placed();
    const cashier = await signedIn('merchant');
    for (const prepMin of [4, 91]) {
      const answer = await accept(order.id, cashier, prepMin);
      expect(answer.statusCode).toBe(400);
      expect(answer.json().error).toBe('invalid_prep_time');
    }
    expect((await accept(order.id, cashier, 12.5)).statusCode).toBe(400);
    // Any whole minute between them, not only the chips (RA §8.5).
    expect((await accept(order.id, cashier, 17)).statusCode).toBe(200);
  });

  it("answers another restaurant's order with 404 unknown_order", async () => {
    const order = await placed();
    const other = await signedIn('merchant', { restaurantId: otherRestaurant });
    const answer = await accept(order.id, other);
    expect(answer.statusCode).toBe(404);
    expect(answer.json().error).toBe('unknown_order');
    expect((await accept(randomUUID(), other)).statusCode).toBe(404);
    expect((await row(order.id)).status).toBe('placed');
  });

  it('needs its Idempotency-Key', async () => {
    const order = await placed();
    const answer = await command('accept', order.id, await signedIn('merchant'), {
      key: null,
      payload: { prepMin: 20 },
    });
    expect(answer.statusCode).toBe(400);
    expect(answer.json().error).toBe('idempotency_key_required');
  });

  it("refuses a terminated restaurant's owner with 403 restaurant_terminated (RA §5.5)", async () => {
    const merchants = app.get(MerchantsService);
    const closing = await newRestaurant(merchants, 'مطعم يغلق');
    const owner = await signedIn('merchant', { restaurantId: closing, role: 'owner' });
    await merchants.setAccountStatus(closing, 'terminated', change);
    const answer = await accept(randomUUID(), owner);
    expect(answer.statusCode).toBe(403);
    expect(answer.json().error).toBe('restaurant_terminated');
  });
});

describe('the search-start moment (AP §8.3, §9.12.6; owner decision 2026-11-06)', () => {
  // A motorbike captain online at the point, its live position written.
  async function onlineAt(point: Point): Promise<string> {
    const captains = app.get(CaptainsService);
    const id = await captains.createCaptain(
      azaz,
      {
        name: 'كابتن الاختبار',
        vehicle: 'motorbike',
        plateNumber: randomUUID().slice(0, 6),
        custodyLimit: { amount: 300_000n, currency: 'TRY' },
      },
      change,
    );
    const now = new Date();
    await captains.goOnline(id, { appVersion: '1.0.0', simulatedLocation: false }, now);
    await captains.recordLocations(
      id,
      [{ ...point, accuracyMetres: 8, recordedAt: now, simulated: false }],
      new Date(now.getTime() + 1),
    );
    return id;
  }

  it("starts the search when the nearest captain's ETA plus the buffer covers the prep time left", async () => {
    // About 1.1 km north of the restaurant.
    const at = { latitude: 36.597, longitude: 37.046 };
    const captain = await onlineAt(at);
    try {
      const order = await placed();
      expect((await accept(order.id, await signedIn('merchant'), 30)).statusCode).toBe(200);
      const kept = await row(order.id);
      const acceptedAt = new Date(kept.accepted_at).getTime();
      const { metres } = await app.get(GeoService).distance(at, centre, { vehicle: 'motorbike' });
      // ETA at order.eta_speed_kmh (20), minus dispatch.search_start_buffer_min (5).
      const etaMs = (metres / 1000 / 20) * 3_600_000;
      expect(new Date(kept.search_start_at).getTime()).toBe(
        Math.round(acceptedAt + 30 * MINUTE - etaMs - 5 * MINUTE),
      );
    } finally {
      await app.get(CaptainsService).goOffline(captain, new Date());
    }
  });

  it('starts it at once when the prep time is shorter than the ETA and the buffer', async () => {
    const captain = await onlineAt({ latitude: 36.597, longitude: 37.046 });
    try {
      const order = await placed();
      expect((await accept(order.id, await signedIn('merchant'), 5)).statusCode).toBe(200);
      const kept = await row(order.id);
      expect(new Date(kept.search_start_at).getTime()).toBe(new Date(kept.accepted_at).getTime());
    } finally {
      await app.get(CaptainsService).goOffline(captain, new Date());
    }
  });

  it('leaves the timer harmless on an order that ended', async () => {
    const order = await placed();
    const timers = app.get(OrderTimers);
    expect((await accept(order.id, await signedIn('merchant'))).statusCode).toBe(200);
    expect(await timers.searchStart({ orderId: order.id, placedAt: order.placedAt })).toBe(true);
    await sql.query(
      "UPDATE ordering.orders SET status = 'cancelled', version = 3, cancelled_at = now(), cancel_reason = 'test', food_prepared = false WHERE id = $1",
      [order.id],
    );
    expect(await timers.searchStart({ orderId: order.id, placedAt: order.placedAt })).toBe(false);
  });
});

describe('POST /v1/merchant/orders/{orderId}/ready (RA §8.8, §18)', () => {
  it('marks an accepted order ready, with the no-captain moment, once and without undo', async () => {
    const order = await placed();
    const cashier = await signedIn('merchant');
    expect((await accept(order.id, cashier)).statusCode).toBe(200);
    const key = randomUUID();
    const answer = await command('ready', order.id, cashier, { key });
    expect(answer.statusCode).toBe(200);
    const kept = await row(order.id);
    expect(kept).toMatchObject({ status: 'ready', version: 3 });
    const readyAt = new Date(kept.ready_at).getTime();
    // dispatch.no_captain_after_ready_min (15): no captain is ever assigned yet.
    expect(new Date(kept.no_captain_alert_at).getTime()).toBe(readyAt + 15 * MINUTE);
    expect(answer.json().order).toMatchObject({
      status: 'ready',
      version: 3,
      readyAt: new Date(readyAt).toISOString(),
    });
    expect(await outboxTypes(order.id)).toEqual(['order.placed', 'order.accepted', 'order.ready']);
    const event = await sql.query(
      'SELECT from_status, to_status, actor_type FROM ordering.order_events WHERE order_id = $1 AND version = 3',
      [order.id],
    );
    expect(event.rows[0]).toEqual({
      from_status: 'accepted',
      to_status: 'ready',
      actor_type: 'restaurant',
    });
    expect((await command('ready', order.id, cashier, { key })).statusCode).toBe(200);
    // A second press with another key answers the current order.
    const again = await command('ready', order.id, cashier);
    expect(again.statusCode).toBe(409);
    expect(again.json()).toMatchObject({
      error: 'order_state_changed',
      order: { status: 'ready' },
    });
    expect((await row(order.id)).version).toBe(3);
  });

  it('allows pressing it early, right after acceptance', async () => {
    const order = await placed();
    const cashier = await signedIn('merchant');
    await accept(order.id, cashier, 45);
    expect((await command('ready', order.id, cashier)).statusCode).toBe(200);
  });

  it('refuses a placed order with 409 and the current order', async () => {
    const order = await placed();
    const answer = await command('ready', order.id, await signedIn('merchant'));
    expect(answer.statusCode).toBe(409);
    expect(answer.json()).toMatchObject({
      error: 'order_state_changed',
      order: { status: 'placed' },
    });
  });
});

describe('the reads show the acceptance to each party (RA §8.2–8.5, CU §11.1–11.2)', () => {
  it('gives the board the prep-time chooser, with the busy-mode minutes in its default', async () => {
    const cashier = await signedIn('merchant');
    const board = await app.inject({ method: 'GET', url: '/v1/merchant/orders', headers: cashier });
    expect(board.statusCode).toBe(200);
    expect(board.json().prepTime).toEqual({
      options: [10, 15, 20, 30, 45],
      stepMin: 5,
      floorMin: 5,
      ceilingMin: 90,
      defaultMin: 20,
    });
    await sql.query(
      "UPDATE merchants.restaurants SET busy_extra_min = 15, busy_until = now() + interval '1 hour' WHERE id = $1",
      [restaurant],
    );
    try {
      const busy = await app.inject({
        method: 'GET',
        url: '/v1/merchant/orders',
        headers: cashier,
      });
      expect(busy.json().prepTime.defaultMin).toBe(35);
      await sql.query('UPDATE merchants.restaurants SET busy_extra_min = 80 WHERE id = $1', [
        restaurant,
      ]);
      // Never past the ceiling.
      const busier = await app.inject({
        method: 'GET',
        url: '/v1/merchant/orders',
        headers: cashier,
      });
      expect(busier.json().prepTime.defaultMin).toBe(90);
    } finally {
      await sql.query(
        'UPDATE merchants.restaurants SET busy_extra_min = NULL, busy_until = NULL WHERE id = $1',
        [restaurant],
      );
    }
  });

  it('shows the board the acceptance and the ready time, and the customer the promised time only', async () => {
    const order = await placed();
    const before = await app.inject({
      method: 'GET',
      url: `/v1/customer/orders/${order.id}`,
      headers: order.headers,
    });
    expect(before.json().order.promisedAt).toBeNull();

    const cashier = await signedIn('merchant');
    await accept(order.id, cashier, 20);
    await command('ready', order.id, cashier);
    const kept = await row(order.id);

    const board = await app.inject({ method: 'GET', url: '/v1/merchant/orders', headers: cashier });
    const card = board.json().orders.find((entry: { id: string }) => entry.id === order.id);
    expect(card).toMatchObject({
      status: 'ready',
      acceptance: { prepMin: 20, deviceName: 'كاشير 1' },
      readyAt: new Date(kept.ready_at).toISOString(),
    });
    // The restaurant never sees the promised time, nor operations' moments.
    expect(card).not.toHaveProperty('promisedAt');
    expect(JSON.stringify(card)).not.toMatch(/searchStart|noCaptain|prepLateAlert/);

    const customer = await app.inject({
      method: 'GET',
      url: `/v1/customer/orders/${order.id}`,
      headers: order.headers,
    });
    expect(customer.json().order).toMatchObject({
      status: 'ready',
      promisedAt: new Date(kept.promised_at).toISOString(),
    });
    expect(JSON.stringify(customer.json().order)).not.toMatch(
      /acceptance|deviceName|searchStart|noCaptain|prepLateAlert/,
    );
  });
});
