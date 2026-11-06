import 'reflect-metadata';
import { randomUUID } from 'node:crypto';
import { Module } from '@nestjs/common';
import { Test } from '@nestjs/testing';
import type { TestingModule } from '@nestjs/testing';
import pg from 'pg';
import { afterAll, beforeAll, beforeEach, describe, expect, it } from 'vitest';
import { startTestCentrifugo, type TestCentrifugo } from '../../centrifugo/test-centrifugo.js';
import { DatabaseModule } from '../../database/database.module.js';
import { startTestDatabase, type TestDatabase } from '../../database/test-database.js';
import { NotificationsWorkerModule, PublishFailedError } from '../notifications/index.js';
import { OutboxRelay } from './outbox-relay.js';

// Architecture §5.5, E4: the relay publishes every committed outbox row to
// Centrifugo at least once, to the restaurant's and the order's channels
// (§6.2), and marks it. Ids are taken at insert, not at commit, so it never
// keeps a «last published id»: a row committed late is still published.
let database: TestDatabase;
let centrifugo: TestCentrifugo;
let sql: pg.Pool;
let context: TestingModule;
let relay: OutboxRelay;
const city = randomUUID();

beforeAll(async () => {
  [database, centrifugo] = await Promise.all([startTestDatabase(), startTestCentrifugo()]);
  process.env.DATABASE_URL = database.appUrl;
  Object.assign(process.env, centrifugo.env);
  sql = new pg.Pool({ connectionString: database.appUrl });
  @Module({ imports: [DatabaseModule, NotificationsWorkerModule], providers: [OutboxRelay] })
  class RelayTestModule {}
  context = await Test.createTestingModule({ imports: [RelayTestModule] }).compile();
  relay = context.get(OutboxRelay);
}, 300_000);

afterAll(async () => {
  await context?.close();
  await sql?.end();
  await Promise.all([database?.stop(), centrifugo?.stop()]);
});

beforeEach(async () => {
  // Every test starts with nothing left to publish.
  Object.assign(process.env, centrifugo.env);
  await relay.drain(new Date());
});

interface Row {
  orderId: string;
  restaurantId: string;
  type: 'order.placed' | 'order.cancelled';
  version: number;
}

const payloadOf = (row: Row) => ({
  schema: 1,
  orderId: row.orderId,
  number: '10001',
  cityId: city,
  restaurantId: row.restaurantId,
  customerAccountId: randomUUID(),
  status: row.type === 'order.placed' ? 'placed' : 'cancelled',
  version: row.version,
  reason: null,
  at: new Date().toISOString(),
});

async function insert(row: Row, client: pg.Pool | pg.PoolClient = sql): Promise<string> {
  const result = await client.query(
    `INSERT INTO ordering.outbox (created_at, city_id, type, order_id, order_version, payload)
     VALUES (now(), $1, $2, $3, $4, $5) RETURNING id`,
    [city, row.type, row.orderId, row.version, JSON.stringify(payloadOf(row))],
  );
  return result.rows[0].id;
}

const unpublished = async (ids: string[]) =>
  (
    await sql.query('SELECT id FROM ordering.outbox WHERE id = ANY($1) AND published_at IS NULL', [
      ids,
    ])
  ).rows.length;

const versionsOn = async (channel: string) =>
  ((await centrifugo.history(channel)) as { version: number }[]).map((data) => data.version);

describe('the outbox relay (architecture §5.5, E4)', () => {
  it("publishes each row to its restaurant's and its order's channels, in id order, once", async () => {
    const order = { orderId: randomUUID(), restaurantId: randomUUID() };
    const placed = await insert({ ...order, type: 'order.placed', version: 1 });
    const cancelled = await insert({ ...order, type: 'order.cancelled', version: 2 });

    expect(await relay.drain(new Date())).toBe(2);

    expect(await unpublished([placed, cancelled])).toBe(0);
    expect(await versionsOn(`merchant:${order.restaurantId}`)).toEqual([1, 2]);
    expect(await versionsOn(`order:${order.orderId}`)).toEqual([1, 2]);
    const [first] = (await centrifugo.history(`order:${order.orderId}`)) as object[];
    expect(first).toMatchObject({ schema: 1, orderId: order.orderId, status: 'placed' });

    // A published row is never sent again.
    expect(await relay.drain(new Date())).toBe(0);
    expect(await versionsOn(`order:${order.orderId}`)).toEqual([1, 2]);
  });

  it('publishes a row committed after a later one, as no «last published id» is kept', async () => {
    const early = { orderId: randomUUID(), restaurantId: randomUUID() };
    const late = { orderId: randomUUID(), restaurantId: randomUUID() };
    const slow = await sql.connect();
    try {
      await slow.query('BEGIN');
      // Its id is taken now, before the other row's, but it commits after.
      const first = await insert({ ...early, type: 'order.placed', version: 1 }, slow);
      const second = await insert({ ...late, type: 'order.placed', version: 1 });
      expect(BigInt(first)).toBeLessThan(BigInt(second));

      expect(await relay.drain(new Date())).toBe(1);
      expect(await versionsOn(`order:${late.orderId}`)).toEqual([1]);

      await slow.query('COMMIT');
      expect(await relay.drain(new Date())).toBe(1);
      expect(await versionsOn(`order:${early.orderId}`)).toEqual([1]);
    } finally {
      slow.release();
    }
  });

  it('keeps the rows Centrifugo did not take and publishes them on a later run', async () => {
    const order = { orderId: randomUUID(), restaurantId: randomUUID() };
    const row = await insert({ ...order, type: 'order.placed', version: 1 });
    process.env.CENTRIFUGO_API_URL = 'http://127.0.0.1:1/api';

    await expect(relay.drain(new Date())).rejects.toBeInstanceOf(PublishFailedError);
    expect(await unpublished([row])).toBe(1);

    Object.assign(process.env, centrifugo.env);
    expect(await relay.drain(new Date())).toBe(1);
    expect(await unpublished([row])).toBe(0);
    expect(await versionsOn(`order:${order.orderId}`)).toEqual([1]);
  });

  it('lets relays run together without publishing a row twice at once', async () => {
    const order = { orderId: randomUUID(), restaurantId: randomUUID() };
    for (let version = 1; version <= 120; version++) {
      await insert({ ...order, type: 'order.placed', version });
    }

    const counts = await Promise.all([1, 2, 3].map(() => relay.drain(new Date())));

    expect(counts.reduce((sum, count) => sum + count, 0)).toBe(120);
    // The restaurant's channel keeps its last 100 (infra/centrifugo), none
    // twice.
    const kept = await versionsOn(`merchant:${order.restaurantId}`);
    expect(kept).toHaveLength(100);
    expect(new Set(kept).size).toBe(100);
  });
});
