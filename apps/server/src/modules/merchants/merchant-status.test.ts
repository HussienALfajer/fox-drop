import 'reflect-metadata';
import { randomBytes, randomInt, randomUUID } from 'node:crypto';
import type { NestFastifyApplication } from '@nestjs/platform-fastify';
import pg from 'pg';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { ApiModule } from '../../api.module.js';
import { startTestDatabase, type TestDatabase } from '../../database/test-database.js';
import { createApiApp } from '../../http/create-api-app.js';
import { startTestValkey, type TestValkey } from '../../valkey/test-valkey.js';
import { FxService } from '../fx/index.js';
import {
  CODE_SENDER,
  type DevelopmentCodeSender,
  MerchantAccountsService,
} from '../identity/index.js';
import { NotificationTexts } from '../content/index.js';
import { PushQueue, RealtimePublisher, RestaurantStateRelay } from '../notifications/index.js';
import { DATABASE } from '../../database/database.module.js';
import { MerchantsService, RestaurantStatusService } from './index.js';

// The restaurant's status sheet (RA §7.1–7.3, §18): pause, resume and busy
// mode from the restaurant app, by an owner or a cashier.
let database: TestDatabase;
let cache: TestValkey;
let app: NestFastifyApplication;
let sql: pg.Pool;
let merchants: MerchantsService;
let azaz: string;

const system = { type: 'system', id: null, role: null } as const;
const change = { actor: system, context: { ipAddress: null, device: null }, reason: 'test' };
// Every day, all day: the restaurant is open whenever the test runs.
const allWeek = [0, 1, 2, 3, 4, 5, 6].map((weekday) => ({ weekday, opensAt: 0, closesAt: 0 }));

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
  merchants = app.get(MerchantsService);
  azaz = (await sql.query("SELECT id FROM geo.cities WHERE code = 'AZ'")).rows[0].id;
  const fx = app.get(FxService);
  await fx.setCityCurrency(azaz, { currency: 'TRY', displayOrder: 1, enabled: true }, change);
  await fx.setBaseCurrency(azaz, 'TRY', change);
}, 300_000);

afterAll(async () => {
  await app?.close();
  await sql?.end();
  await Promise.all([database?.stop(), cache?.stop()]);
});

async function signedIn(restaurantId: string, role: 'owner' | 'cashier') {
  const phone = `+9639${randomInt(100_000_000).toString().padStart(8, '0')}`;
  const accountId = await app
    .get(MerchantAccountsService)
    .addAccount(restaurantId, { role, name: role, phone }, change);
  const deviceId = randomUUID();
  await app.inject({ method: 'POST', url: '/v1/merchant/auth/code', payload: { phone, deviceId } });
  const code = app.get<DevelopmentCodeSender>(CODE_SENDER).lastCode(phone);
  const response = await app.inject({
    method: 'POST',
    url: '/v1/merchant/auth/sign-in',
    payload: { phone, deviceId, code },
  });
  expect(response.statusCode).toBe(200);
  return {
    accountId,
    deviceId,
    headers: { authorization: `Bearer ${response.json().accessToken}` },
  };
}

// An active restaurant, open all week unless told otherwise, with a cashier.
async function restaurant({ open = true } = {}) {
  const id = await merchants.createRestaurant(
    azaz,
    {
      nameAr: `مطعم ${randomUUID()}`,
      location: { latitude: 36.5866, longitude: 37.0463 },
      coverage: { kind: 'radius', radiusMetres: 3000 },
      minimumOrder: { amount: 10_000n, currency: 'TRY' },
      commissionBp: 1500,
      defaultPrepMin: 20,
    },
    change,
  );
  await merchants.setAccountStatus(id, 'active', change);
  if (open) await merchants.setWeeklySchedule(id, allWeek, change);
  return { id, cashier: await signedIn(id, 'cashier') };
}

const call = (
  method: 'GET' | 'POST' | 'PUT' | 'DELETE',
  url: string,
  headers: Record<string, string>,
  payload?: object,
) =>
  app.inject({
    method,
    url: `/v1/merchant/restaurant/${url}`,
    headers,
    ...(payload === undefined ? {} : { payload }),
  });

describe('pause and resume (RA §7.1, §7.2)', () => {
  it('lets a cashier pause for 30 minutes, closes the restaurant to customers, then resume', async () => {
    const { id, cashier } = await restaurant();
    const before = await call('GET', 'status', cashier.headers);
    expect(before.statusCode).toBe(200);
    expect(before.json()).toMatchObject({
      state: 'open',
      pauseSource: null,
      busyMode: null,
      activeOrders: null,
      maxActiveOrders: null,
      holiday: null,
      pauseChoicesMin: [15, 30, 60],
      busyExtraOptionsMin: [10, 20],
      busyReminderMin: 60,
    });
    const closesAt = new Date(before.json().closesAt).getTime();

    const start = Date.now();
    const paused = await call('POST', 'status/pause', cashier.headers, { minutes: 30 });
    expect(paused.statusCode).toBe(200);
    expect(paused.json()).toMatchObject({ state: 'paused', pauseSource: 'restaurant' });
    const until = new Date(paused.json().stateUntil).getTime();
    expect(until).toBeLessThanOrEqual(Math.min(Date.now() + 30 * 60_000, closesAt));
    expect(until).toBeGreaterThanOrEqual(Math.min(start + 30 * 60_000, closesAt) - 1000);
    expect((await merchants.storefrontState(id)).state).toMatchObject({
      state: 'paused',
      source: 'restaurant',
    });

    const resumed = await call('POST', 'status/resume', cashier.headers);
    expect(resumed.statusCode).toBe(200);
    expect(resumed.json().state).toBe('open');
    // A repeat changes nothing.
    expect((await call('POST', 'status/resume', cashier.headers)).json().state).toBe('open');

    const { rows } = await sql.query(
      `SELECT action, actor_id, device FROM audit.events WHERE target_id = $1 AND action LIKE 'restaurant.%' ORDER BY id`,
      [id],
    );
    expect(rows.map((row) => row.action)).toEqual([
      'restaurant.create',
      'restaurant.status',
      'restaurant.hours',
      'restaurant.pause',
      'restaurant.resume',
    ]);
    expect(rows[3]).toMatchObject({ actor_id: cashier.accountId, device: cashier.deviceId });
  });

  it('ends «حتى أعيد الفتح» with the opening period, and a new pause replaces it', async () => {
    const { id, cashier } = await restaurant();
    const paused = await call('POST', 'status/pause', cashier.headers, { minutes: null });
    expect(paused.json().stateUntil).toBe(paused.json().closesAt);
    await call('POST', 'status/pause', cashier.headers, { minutes: 15 });
    const { rows } = await sql.query(
      'SELECT ended_at IS NOT NULL AS ended FROM merchants.pauses WHERE restaurant_id = $1 ORDER BY starts_at, id',
      [id],
    );
    expect(rows.map((row) => row.ended)).toEqual([true, false]);
  });

  it('refuses the restaurant’s buttons over an operations pause or the auto-pause (S4)', async () => {
    for (const source of ['ops', 'auto']) {
      const { id, cashier } = await restaurant();
      await sql.query(
        `INSERT INTO merchants.pauses (restaurant_id, source, starts_at) VALUES ($1, $2, now())`,
        [id, source],
      );
      const status = await call('GET', 'status', cashier.headers);
      expect(status.json()).toMatchObject({
        state: 'paused',
        pauseSource: source,
        stateUntil: null,
      });
      for (const [url, payload] of [
        ['status/pause', { minutes: 15 }],
        ['status/resume', undefined],
      ] as const) {
        const refused = await call('POST', url, cashier.headers, payload);
        expect(refused.statusCode).toBe(409);
        expect(refused.json().error).toBe('paused_by_operations');
      }
    }
  });

  it('refuses a pause while closed by the schedule, and a length off the choices', async () => {
    const closed = await restaurant({ open: false });
    const refused = await call('POST', 'status/pause', closed.cashier.headers, { minutes: 15 });
    expect(refused.statusCode).toBe(409);
    expect(refused.json().error).toBe('restaurant_closed');
    const open = await restaurant();
    const wrong = await call('POST', 'status/pause', open.cashier.headers, { minutes: 45 });
    expect(wrong.statusCode).toBe(400);
    expect(wrong.json().error).toBe('invalid_pause');
  });
});

describe('busy mode (RA §7.3)', () => {
  it('adds minutes until the end of the opening period, then turns off', async () => {
    const { id, cashier } = await restaurant();
    const on = await call('PUT', 'status/busy-mode', cashier.headers, { extraMin: 20 });
    expect(on.statusCode).toBe(200);
    expect(on.json()).toMatchObject({ state: 'open', busyMode: { extraMin: 20 } });
    expect(on.json().busyMode.until).toBe(on.json().closesAt);
    expect(await merchants.operatingState(id)).toEqual({ state: 'open', busyExtraMin: 20 });

    const wrong = await call('PUT', 'status/busy-mode', cashier.headers, { extraMin: 15 });
    expect(wrong.statusCode).toBe(400);
    expect(wrong.json().error).toBe('invalid_busy_extra');

    const off = await call('PUT', 'status/busy-mode', cashier.headers, { extraMin: null });
    expect(off.json().busyMode).toBe(null);
    expect(await merchants.operatingState(id)).toEqual({ state: 'open', busyExtraMin: null });
  });

  it('refuses busy mode while closed', async () => {
    const { cashier } = await restaurant({ open: false });
    const refused = await call('PUT', 'status/busy-mode', cashier.headers, { extraMin: 10 });
    expect(refused.statusCode).toBe(409);
    expect(refused.json().error).toBe('restaurant_closed');
  });
});

describe('status and hours, the owners’ (RA §10)', () => {
  it('lets only an owner read and change the hours, holiday close and limits', async () => {
    const { id, cashier } = await restaurant();
    for (const [method, url, payload] of [
      ['GET', 'hours', undefined],
      ['PUT', 'hours', { periods: [] }],
      ['PUT', 'order-settings', { defaultPrepMin: 25, maxActiveOrders: 5 }],
      ['PUT', 'holiday-close', { startsAt: null, endsAt: new Date().toISOString(), message: null }],
    ] as const) {
      const refused = await call(method, url, cashier.headers, payload);
      expect(refused.statusCode).toBe(403);
      expect(refused.json().error).toBe('owner_only');
    }
    const owner = await signedIn(id, 'owner');
    const hours = await call('GET', 'hours', owner.headers);
    expect(hours.statusCode).toBe(200);
    expect(hours.json()).toEqual({
      periods: allWeek,
      holiday: null,
      defaultPrepMin: 20,
      prepFloorMin: 5,
      prepCeilingMin: 90,
      maxActiveOrders: null,
      minimumOrder: { amount: '10000', currency: 'TRY' },
      coverage: { kind: 'radius', radiusMetres: 3000, zoneCount: null },
      commissionBp: 1500,
      settlementWeekday: 'saturday',
    });
  });

  it('sets several and overnight periods, and refuses overlapping ones', async () => {
    const { id } = await restaurant();
    const owner = await signedIn(id, 'owner');
    // Friday 12:00–15:00 and 18:00–02:00; Saturday closed all day.
    const periods = [
      { weekday: 5, opensAt: 720, closesAt: 900 },
      { weekday: 5, opensAt: 1080, closesAt: 120 },
    ];
    const saved = await call('PUT', 'hours', owner.headers, { periods });
    expect(saved.statusCode).toBe(200);
    expect(saved.json().periods).toEqual(periods);
    const overlapping = await call('PUT', 'hours', owner.headers, {
      periods: [...periods, { weekday: 6, opensAt: 60, closesAt: 600 }],
    });
    expect(overlapping.statusCode).toBe(400);
    expect(overlapping.json().error).toBe('invalid_schedule');
  });

  it('sets the default prep time within the chooser and the maximum active orders', async () => {
    const { id } = await restaurant();
    const owner = await signedIn(id, 'owner');
    const saved = await call('PUT', 'order-settings', owner.headers, {
      defaultPrepMin: 30,
      maxActiveOrders: 3,
    });
    expect(saved.json()).toMatchObject({ defaultPrepMin: 30, maxActiveOrders: 3 });
    const status = await call('GET', 'status', owner.headers);
    expect(status.json()).toMatchObject({ state: 'open', activeOrders: 0, maxActiveOrders: 3 });
    for (const [payload, error] of [
      [{ defaultPrepMin: 2, maxActiveOrders: null }, 'invalid_prep_time'],
      [{ defaultPrepMin: 120, maxActiveOrders: null }, 'invalid_prep_time'],
      [{ defaultPrepMin: 20, maxActiveOrders: 0 }, 'invalid_max_active_orders'],
      [{ defaultPrepMin: 20, maxActiveOrders: 51 }, 'invalid_max_active_orders'],
    ] as const) {
      const refused = await call('PUT', 'order-settings', owner.headers, payload);
      expect(refused.statusCode).toBe(400);
      expect(refused.json().error).toBe(error);
    }
    const off = await call('PUT', 'order-settings', owner.headers, {
      defaultPrepMin: 30,
      maxActiveOrders: null,
    });
    expect(off.json().maxActiveOrders).toBe(null);
  });

  it('closes for a holiday with a message, shown to customers, until ended early', async () => {
    const { id } = await restaurant();
    const owner = await signedIn(id, 'owner');
    const endsAt = new Date(Date.now() + 3 * 86_400_000).toISOString();
    const closed = await call('PUT', 'holiday-close', owner.headers, {
      startsAt: null,
      endsAt,
      message: 'إجازة العيد',
    });
    expect(closed.statusCode).toBe(200);
    expect(closed.json()).toMatchObject({
      state: 'holiday',
      stateUntil: endsAt,
      holiday: { endsAt, message: 'إجازة العيد' },
    });
    expect(await merchants.storefrontState(id)).toMatchObject({
      state: { state: 'holiday' },
      message: 'إجازة العيد',
    });
    // The restaurant cannot pause while closed.
    const pause = await call('POST', 'status/pause', owner.headers, { minutes: 15 });
    expect(pause.json().error).toBe('restaurant_closed');

    const ended = await call('DELETE', 'holiday-close', owner.headers);
    expect(ended.json()).toMatchObject({ state: 'open', holiday: null });
  });

  it('sets a later holiday close, replaced by a new one, and refuses one ending first', async () => {
    const { id } = await restaurant();
    const owner = await signedIn(id, 'owner');
    const day = 86_400_000;
    const start = Date.now();
    const at = (days: number) => new Date(start + days * day).toISOString();
    const later = await call('PUT', 'holiday-close', owner.headers, {
      startsAt: at(2),
      endsAt: at(4),
      message: null,
    });
    expect(later.json()).toMatchObject({ state: 'open', holiday: { startsAt: at(2) } });
    await call('PUT', 'holiday-close', owner.headers, {
      startsAt: at(5),
      endsAt: at(6),
      message: null,
    });
    const { rows } = await sql.query(
      'SELECT ended_at IS NULL AS live FROM merchants.holiday_closes WHERE restaurant_id = $1 ORDER BY created_at, id',
      [id],
    );
    expect(rows.map((row) => row.live)).toEqual([false, true]);
    const wrong = await call('PUT', 'holiday-close', owner.headers, {
      startsAt: at(3),
      endsAt: at(2),
      message: null,
    });
    expect(wrong.statusCode).toBe(400);
    expect(wrong.json().error).toBe('invalid_holiday_close');
  });
});

describe('state events and timers (RA §16 #24, #25, §18)', () => {
  const kinds = async (id: string) =>
    (
      await sql.query(
        'SELECT kind, payload FROM merchants.state_outbox WHERE restaurant_id = $1 ORDER BY id',
        [id],
      )
    ).rows;
  const jobsOf = async (name: string, id: string) =>
    (
      await sql.query(
        `SELECT data, start_after FROM pgboss.job WHERE name = $1 AND data->>'restaurantId' = $2`,
        [name, id],
      )
    ).rows;

  it('records a change for every command, and sets the timed pause’s end', async () => {
    const { id, cashier } = await restaurant();
    const owner = await signedIn(id, 'owner');
    await call('POST', 'status/pause', cashier.headers, { minutes: 15 });
    await call('POST', 'status/resume', cashier.headers);
    await call('PUT', 'status/busy-mode', cashier.headers, { extraMin: 10 });
    await call('PUT', 'hours', owner.headers, { periods: allWeek });
    await call('PUT', 'order-settings', owner.headers, { defaultPrepMin: 25, maxActiveOrders: 4 });
    expect((await kinds(id)).map((row) => row.kind)).toEqual([
      'hours',
      'paused',
      'resumed',
      'busy_mode',
      'hours',
      'order_settings',
    ]);
    const [pauseEnd] = await jobsOf('merchants-pause-end', id);
    expect(pauseEnd).toBeDefined();
    const [reminder] = await jobsOf('merchants-busy-reminder', id);
    expect(new Date(reminder.start_after).getTime() - Date.now()).toBeGreaterThan(59 * 60_000);
  });

  it('tells the restaurant its pause ended only when it ended on its own', async () => {
    const service = app.get(RestaurantStatusService);
    const { id, cashier } = await restaurant();
    await call('POST', 'status/pause', cashier.headers, { minutes: 15 });
    const [{ data }] = await jobsOf('merchants-pause-end', id);
    // Too early: nothing.
    expect(await service.pauseEnded(data)).toBe(false);
    const later = new Date(Date.now() + 16 * 60_000);
    expect(await service.pauseEnded(data, later)).toBe(true);
    expect((await kinds(id)).at(-1)).toEqual({
      kind: 'pause_ended',
      payload: { schema: 1, values: { push: true } },
    });

    // A pause resumed early has no end to tell.
    await call('POST', 'status/pause', cashier.headers, { minutes: 30 });
    await call('POST', 'status/resume', cashier.headers);
    const jobs = await jobsOf('merchants-pause-end', id);
    expect(await service.pauseEnded(jobs.at(-1)!.data, new Date(Date.now() + 31 * 60_000))).toBe(
      false,
    );
  });

  it('reminds of busy mode while it is the one the job was set for', async () => {
    const service = app.get(RestaurantStatusService);
    const { id, cashier } = await restaurant();
    await call('PUT', 'status/busy-mode', cashier.headers, { extraMin: 20 });
    const [{ data }] = await jobsOf('merchants-busy-reminder', id);
    expect(await service.busyReminder(data)).toBe(true);
    expect((await kinds(id)).at(-1)).toEqual({
      kind: 'busy_reminder',
      payload: { schema: 1, values: { extraMin: 20 } },
    });
    // Off, then on again: the old job is without effect.
    await call('PUT', 'status/busy-mode', cashier.headers, { extraMin: null });
    await call('PUT', 'status/busy-mode', cashier.headers, { extraMin: 10 });
    expect(await service.busyReminder(data)).toBe(false);
  });

  it('relays each change once to the restaurant and the city, with its push', async () => {
    const published: { channels: string[]; data: Record<string, unknown> }[] = [];
    const publisher = {
      enabled: true,
      broadcast: (channels: string[], data: Record<string, unknown>) => {
        published.push({ channels, data });
        return Promise.resolve();
      },
    } as unknown as RealtimePublisher;
    const relay = new RestaurantStateRelay(
      app.get(DATABASE),
      app.get(RestaurantStatusService),
      publisher,
      app.get(PushQueue),
      app.get(NotificationTexts),
    );
    await relay.drain(new Date());
    published.length = 0;
    const { id, cashier } = await restaurant();
    await call('PUT', 'status/busy-mode', cashier.headers, { extraMin: 20 });
    const [{ data }] = await jobsOf('merchants-busy-reminder', id);
    await app.get(RestaurantStatusService).busyReminder(data);
    expect(await relay.drain(new Date())).toBeGreaterThanOrEqual(3);
    const mine = published.filter((entry) => entry.data.restaurantId === id);
    expect(mine.map((entry) => entry.data.kind)).toEqual(['hours', 'busy_mode', 'busy_reminder']);
    expect(mine[0]!.channels).toEqual([`merchant:${id}`, `ops:city.${azaz}`]);
    expect(mine[0]!.data).toMatchObject({ type: 'restaurant.state_changed', schema: 1 });
    const pushes = await sql.query(
      `SELECT template_key, body FROM notifications.push_messages WHERE restaurant_id = $1`,
      [id],
    );
    expect(pushes.rows).toEqual([
      { template_key: 'merchant.busy_reminder', body: 'وضع الضغط ما زال مفعّلاً (+20 د)' },
    ]);
    expect(await relay.drain(new Date())).toBe(0);
  });
});
