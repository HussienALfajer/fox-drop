import 'reflect-metadata';
import { randomBytes, randomInt, randomUUID } from 'node:crypto';
import type { NestFastifyApplication } from '@nestjs/platform-fastify';
import pg from 'pg';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { ApiModule } from '../../api.module.js';
import { startTestDatabase, type TestDatabase } from '../../database/test-database.js';
import { createApiApp } from '../../http/create-api-app.js';
import { Jobs } from '../../jobs/jobs.module.js';
import { QUEUES } from '../../jobs/job-queue.js';
import { startTestValkey, type TestValkey } from '../../valkey/test-valkey.js';
import { CaptainsService } from '../captains/index.js';
import { FxService } from '../fx/index.js';
import { GeoService, type Point } from '../geo/index.js';
import { CODE_SENDER, type DevelopmentCodeSender } from '../identity/index.js';
import { MerchantsService } from '../merchants/index.js';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { SettingsService } from '../settings/index.js';
import { type AlertCode, AlertsService } from '../notifications/index.js';
import { ADMIN_SESSION_COOKIE, AdminSessionsService } from '../identity/index.js';
import { OrderAlerts, timerId } from './order-alerts.js';
import { OrderTimers } from './order-timers.js';

// AP §7.3, §9.1.3: an order's alerts follow it. Every transition sends a
// sync (recordTransition); the sync raises what holds now, resolves what
// cleared and sends the timer of the next moment, in the order's lock.
let database: TestDatabase;
let cache: TestValkey;
let app: NestFastifyApplication;
let sql: pg.Pool;
let restaurant: string;
let item: string;

const system = { type: 'system', id: null, role: null } as const;
const change = { actor: system, context: { ipAddress: null, device: null }, reason: 'test' };
const bySystem = { editor: 'system', context: change.context, reason: 'test' } as const;
const centre = { latitude: 36.587, longitude: 37.046 };
const allWeek = [0, 1, 2, 3, 4, 5, 6].map((weekday) => ({ weekday, opensAt: 0, closesAt: 0 }));

function square({ latitude, longitude }: Point, half = 0.02): Point[] {
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
  app = await createApiApp(ApiModule);
  await app.init();
  await app.getHttpAdapter().getInstance().ready();
  const azaz = (await sql.query("SELECT id FROM geo.cities WHERE code = 'AZ'")).rows[0].id;
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
  const { SettingsService } = await import('../settings/index.js');
  const settings = app.get(SettingsService);
  await settings.update('dispatch.capacity_check', { cityId: azaz }, false, bySystem);
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
      nameAr: 'مطعم الاختبار',
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
  await sql?.end();
  await Promise.all([database?.stop(), cache?.stop()]);
});

async function placed(): Promise<{ id: string; placedAt: string }> {
  const phone = `+9639${randomInt(100_000_000).toString().padStart(8, '0')}`;
  const deviceId = randomUUID();
  await app.inject({ method: 'POST', url: '/v1/customer/auth/code', payload: { phone, deviceId } });
  const code = app.get<DevelopmentCodeSender>(CODE_SENDER).lastCode(phone);
  const signIn = await app.inject({
    method: 'POST',
    url: '/v1/customer/auth/sign-in',
    payload: { phone, deviceId, code },
  });
  // CU §4.7: a customer orders once the terms in force (the seeded version 1)
  // are accepted.
  await app.inject({
    method: 'POST',
    url: '/v1/customer/terms/accept',
    headers: { authorization: `Bearer ${signIn.json().accessToken}` },
    payload: { version: 1 },
  });
  const lines = [{ itemId: item, optionIds: [], quantity: 1, note: null, knownUnitPrice: '12000' }];
  const quote = await app.inject({
    method: 'POST',
    url: '/v1/customer/quote',
    payload: {
      restaurantId: restaurant,
      location: centre,
      lines,
      payIn: null,
      appVersion: '1.0.0',
    },
  });
  const answer = await app.inject({
    method: 'POST',
    url: '/v1/customer/orders',
    headers: {
      authorization: `Bearer ${signIn.json().accessToken}`,
      'idempotency-key': randomUUID(),
    },
    payload: {
      restaurantId: restaurant,
      lines,
      payIn: null,
      appVersion: '1.0.0',
      quoteVersion: quote.json().version,
      addressId: null,
      unsavedAddress: {
        location: centre,
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
  return answer.json().order;
}

const OPERATIONS = ['OPS'];
const FINANCE = ['FIN'];

function orderAlertsService(): OrderAlerts {
  return new OrderAlerts(
    app.get(DATABASE),
    app.get(Jobs),
    app.get(AlertsService),
    app.get(CaptainsService),
    app.get(SettingsService),
  );
}

const alertsOf = async (orderId: string) =>
  (
    await sql.query(
      'SELECT code, severity, city_id, details, acknowledged_by, resolved_at FROM notifications.alerts WHERE subject_id = $1 ORDER BY raised_at, code',
      [orderId],
    )
  ).rows;

const syncJobs = async (orderId: string) =>
  (
    await sql.query(
      "SELECT start_after, created_on FROM pgboss.job WHERE name = $1 AND data->>'orderId' = $2 ORDER BY start_after",
      [QUEUES.orderAlerts, orderId],
    )
  ).rows;

describe("the order's alerts (AP §7.3, §9.1.3)", () => {
  it('raises «مطعم لم يقبل» at the acceptance alert and resolves it when the order moves on', async () => {
    const order = await placed();
    const job = { orderId: order.id, placedAt: order.placedAt };
    // order.placed sent a sync with its transition.
    expect((await syncJobs(order.id)).length).toBeGreaterThanOrEqual(1);
    const sync = orderAlertsService();
    const placedAt = new Date(order.placedAt);
    await sync.sync(job, placedAt);
    expect(await alertsOf(order.id)).toEqual([]);
    // The timer of order.merchant_accept_alert_min (3) after placing.
    const timers = (await syncJobs(order.id)).map((row) => new Date(row.start_after).getTime());
    expect(timers).toContain(placedAt.getTime() + 3 * 60_000);

    const late = new Date(placedAt.getTime() + 3 * 60_000);
    await sync.sync(job, late);
    await sync.sync(job, late);
    const raised = await alertsOf(order.id);
    expect(raised).toEqual([
      expect.objectContaining({
        code: 'restaurant_not_accepted',
        severity: 'critical',
        resolved_at: null,
        details: { orderNumber: expect.any(String) },
      }),
    ]);
    const alerts = app.get(AlertsService);
    const [listed] = await alerts.list(raised[0].city_id, OPERATIONS, false);
    expect(listed).toMatchObject({ code: 'restaurant_not_accepted', subjectId: order.id });
    // A FIN user at the desk does not receive operations alarms.
    expect(
      (await alerts.list(raised[0].city_id, FINANCE, false)).filter(
        (alert) => alert.subjectId === order.id,
      ),
    ).toEqual([]);

    // The order ends: the alert closes itself and stays in the history.
    await app
      .get(OrderTimers)
      .merchantAutoCancel({ orderId: order.id, placedAt: order.placedAt, version: 1 }, late);
    await sync.sync(job, new Date(late.getTime() + 60_000));
    expect(await alertsOf(order.id)).toEqual([
      expect.objectContaining({ code: 'restaurant_not_accepted', resolved_at: expect.any(Date) }),
    ]);
    const history = await alerts.list(raised[0].city_id, OPERATIONS, true);
    expect(history.some((alert) => alert.subjectId === order.id)).toBe(true);
  });

  it('assigns «استلام» to the first recipient only, for everyone to see', async () => {
    const order = await placed();
    const job = { orderId: order.id, placedAt: order.placedAt };
    const late = new Date(new Date(order.placedAt).getTime() + 4 * 60_000);
    await orderAlertsService().sync(job, late);
    const alerts = app.get(AlertsService);
    const [alert] = (
      await alerts.list((await alertsOf(order.id))[0].city_id, OPERATIONS, false)
    ).filter((one) => one.subjectId === order.id);
    const first = randomUUID();
    const taken = await alerts.acknowledge(alert!.id, first, OPERATIONS, late);
    expect(taken).toMatchObject({ acknowledgedBy: first, resolvedAt: null });
    const again = await alerts.acknowledge(alert!.id, randomUUID(), ['OWN'], late);
    expect(again.acknowledgedBy).toBe(first);
    // Not a recipient: unknown to them.
    await expect(alerts.acknowledge(alert!.id, randomUUID(), FINANCE, late)).rejects.toThrow(
      'unknown_alert',
    );
  });
});

// An active admin account with these roles, signed in.
async function adminCookies(roles: string[], name: string | null) {
  const { rows } = await sql.query(
    "INSERT INTO identity.admin_accounts (name, email, status, password_hash, totp_secret_encrypted) VALUES ($1, $2, 'active', 'x', 'x') RETURNING id",
    [name, `${randomUUID()}@example.test`],
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
    .start(
      app.get<{ db: never }>(DATABASE).db,
      accountId,
      { ipAddress: null, device: null },
      new Date(),
    );
  return { accountId, cookies: { [ADMIN_SESSION_COOKIE]: token } };
}

describe('the alerts routes (AP §7.3, §9.1.3)', () => {
  it('lists what the roles receive, takes an alert and names who took it', async () => {
    const order = await placed();
    const job = { orderId: order.id, placedAt: order.placedAt };
    await orderAlertsService().sync(job, new Date(new Date(order.placedAt).getTime() + 4 * 60_000));
    const cityId: string = (await alertsOf(order.id))[0].city_id;
    const ops = await adminCookies(['OPS'], 'ليلى');
    const fin = await adminCookies(['FIN'], null);

    const anonymous = await app.inject({ method: 'GET', url: `/v1/admin/alerts?cityId=${cityId}` });
    expect(anonymous.statusCode).toBe(401);
    const malformed = await app.inject({
      method: 'GET',
      url: '/v1/admin/alerts?cityId=nope',
      cookies: ops.cookies,
    });
    expect(malformed.statusCode).toBe(400);
    const list = await app.inject({
      method: 'GET',
      url: `/v1/admin/alerts?cityId=${cityId}`,
      cookies: ops.cookies,
    });
    expect(list.statusCode).toBe(200);
    const listed = list
      .json<{ alerts: { id: string; subjectId: string }[] }>()
      .alerts.find((alert) => alert.subjectId === order.id)!;
    expect(listed).toMatchObject({
      code: 'restaurant_not_accepted',
      severity: 'critical',
      subjectType: 'order',
      orderNumber: expect.any(String),
      captainName: null,
      acknowledged: null,
      resolvedAt: null,
    });
    const finList = await app.inject({
      method: 'GET',
      url: `/v1/admin/alerts?cityId=${cityId}`,
      cookies: fin.cookies,
    });
    const finAlerts = finList.json<{ alerts: { subjectId: string }[] }>().alerts;
    expect(finAlerts.some((alert) => alert.subjectId === order.id)).toBe(false);
    // Not a recipient: 404.
    const refused = await app.inject({
      method: 'POST',
      url: `/v1/admin/alerts/${listed.id}/acknowledge`,
      cookies: fin.cookies,
    });
    expect(refused.statusCode).toBe(404);
    const taken = await app.inject({
      method: 'POST',
      url: `/v1/admin/alerts/${listed.id}/acknowledge`,
      cookies: ops.cookies,
    });
    expect(taken.statusCode).toBe(200);
    expect(taken.json().acknowledged).toMatchObject({ byId: ops.accountId, byName: 'ليلى' });

    // The history holds it once it closed.
    await app
      .get(OrderTimers)
      .merchantAutoCancel({ orderId: order.id, placedAt: order.placedAt, version: 1 }, new Date());
    await orderAlertsService().sync(job, new Date());
    const closed = await app.inject({
      method: 'GET',
      url: `/v1/admin/alerts?cityId=${cityId}&state=closed`,
      cookies: ops.cookies,
    });
    const closedAlerts = closed.json<{
      alerts: { subjectId: string; resolvedAt: string | null }[];
    }>().alerts;
    expect(closedAlerts.find((alert) => alert.subjectId === order.id)?.resolvedAt).toEqual(
      expect.any(String),
    );
  });
});

describe('the timers and the GPS (order-alerts.ts)', () => {
  it('keeps one timer per moment however many syncs send it', async () => {
    const order = await placed();
    const job = { orderId: order.id, placedAt: order.placedAt };
    const sync = orderAlertsService();
    const placedAt = new Date(order.placedAt);
    await sync.sync(job, placedAt);
    await sync.sync(job, placedAt);
    const moment = new Date(placedAt.getTime() + 3 * 60_000);
    const { rows } = await sql.query('SELECT count(*)::int AS n FROM pgboss.job WHERE id = $1', [
      timerId(order.id, moment),
    ]);
    expect(rows[0].n).toBe(1);
  });

  it('raises «انقطع اتصال كابتن أثناء طلب» without points and resolves it when one arrives', async () => {
    const order = await placed();
    const job = { orderId: order.id, placedAt: order.placedAt };
    const captainId = randomUUID();
    const now = new Date();
    const assignedAt = new Date(now.getTime() - 3 * 60_000);
    const promisedAt = new Date(now.getTime() + 60 * 60_000);
    // An order assigned 3 minutes ago (assignment is proved in dispatch.test.ts).
    await sql.query(
      "UPDATE ordering.orders SET status = 'accepted', accepted_at = $2, prep_min = 20, promised_at = $3, search_start_at = $2, prep_late_alert_at = $3, captain_id = $4, captain_track = 'assigned', assigned_at = $2 WHERE id = $1",
      [order.id, assignedAt, promisedAt, captainId],
    );
    const sync = orderAlertsService();
    await sync.sync(job, now, false);
    const raised = await alertsOf(order.id);
    expect(raised.map((alert) => alert.code)).toContain('captain_gps_lost');
    await sql.query(
      'INSERT INTO captains.locations (captain_id, city_id, recorded_at, received_at, location, accuracy_metres, simulated) VALUES ($1, $2, $3, $3, ST_SetSRID(ST_MakePoint(37.046, 36.587), 4326), 10, false)',
      [captainId, raised[0].city_id, now],
    );
    await sync.sync(job, new Date(now.getTime() + 1_000), false);
    expect(await alertsOf(order.id)).toContainEqual(
      expect.objectContaining({ code: 'captain_gps_lost', resolved_at: expect.any(Date) }),
    );
  });
});

describe('the alert records (notifications)', () => {
  it('raises an information alert once and closes it with its acknowledgment', async () => {
    const alerts = app.get(AlertsService);
    const subject = { type: 'order' as const, id: randomUUID(), cityId: null };
    const now = new Date();
    const { db } = app.get<Database>(DATABASE);
    const sync = (open: AlertCode[]) =>
      db.transaction((tx) => alerts.sync(tx, subject, ['away_from_address'], open, now));
    await sync(['away_from_address']);
    const [alert] = (await alerts.list(randomUUID(), OPERATIONS, false)).filter(
      (one) => one.subjectId === subject.id,
    );
    expect(alert).toMatchObject({ severity: 'information', resolvedAt: null });
    // Its condition still holds, yet it is not resolved by a sync.
    await sync([]);
    const closed = await alerts.acknowledge(alert!.id, randomUUID(), ['OWN'], now);
    expect(closed.resolvedAt).toEqual(now);
    // Raised once per subject.
    await sync(['away_from_address']);
    expect(await alertsOf(subject.id)).toHaveLength(1);
    // E4: each change left its outbox row for the panel's channel.
    const events = await sql.query(
      'SELECT type, city_id, payload FROM notifications.alert_outbox WHERE alert_id = $1 ORDER BY id',
      [alert!.id],
    );
    expect(events.rows.map((row: { type: string }) => row.type)).toEqual([
      'alert.raised',
      'alert.acknowledged',
    ]);
    expect(events.rows[0]).toMatchObject({
      city_id: null,
      payload: { schema: 1, alertId: alert!.id },
    });
  });

  it('writes the outbox row of an alert resolving itself in the same transaction (E4)', async () => {
    const alerts = app.get(AlertsService);
    const { db } = app.get<Database>(DATABASE);
    const subject = { type: 'order' as const, id: randomUUID(), cityId: randomUUID() };
    const now = new Date();
    const sync = (open: AlertCode[]) =>
      db.transaction((tx) => alerts.sync(tx, subject, ['prep_late'], open, now));
    await sync(['prep_late']);
    await sync([]);
    const events = await sql.query(
      `SELECT o.type, o.city_id FROM notifications.alert_outbox o
       JOIN notifications.alerts a ON a.id = o.alert_id WHERE a.subject_id = $1 ORDER BY o.id`,
      [subject.id],
    );
    expect(events.rows).toEqual([
      { type: 'alert.raised', city_id: subject.cityId },
      { type: 'alert.resolved', city_id: subject.cityId },
    ]);
    // A change rolled back leaves no row.
    await expect(
      db.transaction(async (tx) => {
        await alerts.sync(tx, subject, ['prep_late'], ['prep_late'], now);
        throw new Error('rolled back');
      }),
    ).rejects.toThrow('rolled back');
    expect(
      (
        await sql.query(
          `SELECT 1 FROM notifications.alert_outbox o
       JOIN notifications.alerts a ON a.id = o.alert_id WHERE a.subject_id = $1`,
          [subject.id],
        )
      ).rows,
    ).toHaveLength(2);
  });

  it('keeps alerts append-only for the application role', async () => {
    await expect(sql.query('DELETE FROM notifications.alerts')).rejects.toThrow(
      /permission denied/,
    );
  });
});
