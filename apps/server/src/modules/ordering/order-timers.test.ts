import 'reflect-metadata';
import { randomBytes, randomInt, randomUUID } from 'node:crypto';
import type { INestApplicationContext } from '@nestjs/common';
import type { NestFastifyApplication } from '@nestjs/platform-fastify';
import pg from 'pg';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { ApiModule } from '../../api.module.js';
import { startTestDatabase, type TestDatabase } from '../../database/test-database.js';
import { createApiApp } from '../../http/create-api-app.js';
import { Jobs } from '../../jobs/jobs.module.js';
import { QUEUES } from '../../jobs/job-queue.js';
import { createBackgroundContext } from '../../roles/start-role.js';
import { startTestValkey, type TestValkey } from '../../valkey/test-valkey.js';
import { FxService } from '../fx/index.js';
import { GeoService, type Point } from '../geo/index.js';
import { CODE_SENDER, type DevelopmentCodeSender } from '../identity/index.js';
import { MerchantsService } from '../merchants/index.js';
import { OrderTimers } from './order-timers.js';

// AP §8.3: the order the restaurant does not accept within
// order.merchant_auto_cancel_min (7) is cancelled by the system with
// «المطعم لم يستجب». The timer is a pg-boss job written in the order's
// transaction, and it acts only on the state and version it was set for
// (architecture §5.5).
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

const jobOf = async (orderId: string) =>
  (
    await sql.query(
      "SELECT data, start_after, created_on FROM pgboss.job WHERE name = $1 AND data->>'orderId' = $2",
      [QUEUES.merchantAutoCancel, orderId],
    )
  ).rows;

const orderOf = async (id: string) =>
  (
    await sql.query(
      'SELECT status, version, cancel_reason, food_prepared FROM ordering.orders WHERE id = $1',
      [id],
    )
  ).rows[0];

describe('the automatic cancellation (AP §8.3)', () => {
  it('is set when the order is placed, 7 minutes later, with an order.placed event', async () => {
    const order = await placed();
    const jobs = await jobOf(order.id);
    expect(jobs).toHaveLength(1);
    expect(jobs[0].data).toEqual({ orderId: order.id, placedAt: order.placedAt, version: 1 });
    expect(new Date(jobs[0].start_after).getTime() - new Date(order.placedAt).getTime()).toBe(
      7 * 60_000,
    );
    const { rows } = await sql.query(
      'SELECT type, order_version, payload FROM ordering.outbox WHERE order_id = $1',
      [order.id],
    );
    expect(rows).toEqual([
      {
        type: 'order.placed',
        order_version: 1,
        payload: expect.objectContaining({ orderId: order.id, status: 'placed', version: 1 }),
      },
    ]);
    await app
      .get(OrderTimers)
      .merchantAutoCancel({ orderId: order.id, placedAt: order.placedAt, version: 1 }, new Date());
  });

  it('cancels a placed order once, as the system, with an order.cancelled event', async () => {
    const order = await placed();
    const timers = app.get(OrderTimers);
    const job = { orderId: order.id, placedAt: order.placedAt, version: 1 };
    expect(await timers.merchantAutoCancel(job, new Date())).toBe(true);
    expect(await orderOf(order.id)).toEqual({
      status: 'cancelled',
      version: 2,
      cancel_reason: 'merchant_auto_cancel',
      food_prepared: false,
    });
    const events = await sql.query(
      'SELECT version, from_status, to_status, actor_type, reason FROM ordering.order_events WHERE order_id = $1 ORDER BY version',
      [order.id],
    );
    expect(events.rows[1]).toEqual({
      version: 2,
      from_status: 'placed',
      to_status: 'cancelled',
      actor_type: 'system',
      reason: 'merchant_auto_cancel',
    });
    const outbox = await sql.query(
      'SELECT type, payload FROM ordering.outbox WHERE order_id = $1 ORDER BY id',
      [order.id],
    );
    expect(outbox.rows.map((row) => row.type)).toEqual(['order.placed', 'order.cancelled']);
    expect(outbox.rows[1].payload).toMatchObject({
      status: 'cancelled',
      version: 2,
      reason: 'merchant_auto_cancel',
    });
    // A repeated or late job is harmless.
    expect(await timers.merchantAutoCancel(job, new Date())).toBe(false);
    expect((await orderOf(order.id)).version).toBe(2);
  });

  it('leaves an order that moved on since the timer was set', async () => {
    const order = await placed();
    // Acceptance itself is proved through its route (accept-and-ready.test.ts).
    await sql.query("UPDATE ordering.orders SET status = 'rejected', version = 2 WHERE id = $1", [
      order.id,
    ]);
    expect(
      await app
        .get(OrderTimers)
        .merchantAutoCancel(
          { orderId: order.id, placedAt: order.placedAt, version: 1 },
          new Date(),
        ),
    ).toBe(false);
    expect((await orderOf(order.id)).status).toBe('rejected');
  });

  it('runs in the worker when the job is due', async () => {
    const order = await placed();
    let worker: INestApplicationContext | undefined;
    process.env.PROCESS_ROLE = 'worker';
    try {
      worker = await createBackgroundContext('worker');
      await app
        .get(Jobs)
        .send(
          QUEUES.merchantAutoCancel,
          { orderId: order.id, placedAt: order.placedAt, version: 1 },
          { startAfter: new Date() },
        );
      for (let attempt = 0; attempt < 60; attempt += 1) {
        if ((await orderOf(order.id)).status === 'cancelled') break;
        await new Promise((resolve) => setTimeout(resolve, 500));
      }
      expect(await orderOf(order.id)).toMatchObject({
        status: 'cancelled',
        cancel_reason: 'merchant_auto_cancel',
      });
    } finally {
      delete process.env.PROCESS_ROLE;
      await worker?.close();
    }
  }, 60_000);
});
