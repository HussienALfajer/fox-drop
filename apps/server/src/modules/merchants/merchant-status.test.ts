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
import { MerchantsService } from './index.js';

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
  method: 'GET' | 'POST' | 'PUT',
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
