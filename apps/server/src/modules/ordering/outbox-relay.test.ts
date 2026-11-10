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
  type:
    | 'order.placed'
    | 'order.cancelled'
    | 'order.offered'
    | 'order.assigned'
    | 'order.item_report_closed'
    | 'order.reassigned'
    | 'order.handover_assigned'
    | 'order.handed_over';
  version: number;
  captainTrack?: string;
  captainId?: string;
  otherCaptainId?: string;
  byCustomer?: boolean;
  reason?: string;
}

const payloadOf = (row: Row) => ({
  schema: 1,
  orderId: row.orderId,
  number: '10001',
  cityId: city,
  restaurantId: row.restaurantId,
  customerAccountId: randomUUID(),
  status: row.type === 'order.cancelled' ? 'cancelled' : 'placed',
  version: row.version,
  ...(row.captainTrack ? { captainTrack: row.captainTrack, captainId: row.captainId ?? null } : {}),
  ...(row.otherCaptainId ? { otherCaptainId: row.otherCaptainId } : {}),
  ...(row.byCustomer === undefined ? {} : { byCustomer: row.byCustomer }),
  reason: row.reason ?? null,
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
  it("keeps operations' reason for closing an item report to the restaurant and the panel (RA §16 #37, AP §10)", async () => {
    const order = { orderId: randomUUID(), restaurantId: randomUUID() };
    const captainId = randomUUID();
    await insert({
      ...order,
      type: 'order.item_report_closed',
      version: 5,
      captainTrack: 'at_merchant',
      captainId,
      reason: 'وجد المطعم الصنف',
    });
    await relay.drain(new Date());
    const reasonOn = async (channel: string) =>
      ((await centrifugo.history(channel)) as { reason: string | null }[]).map(
        (data) => data.reason,
      );
    expect(await reasonOn(`merchant:${order.restaurantId}`)).toEqual(['وجد المطعم الصنف']);
    expect(await reasonOn(`ops:city.${city}`)).toContain('وجد المطعم الصنف');
    expect(await reasonOn(`captain:${captainId}`)).toEqual([null]);
    expect(await reasonOn(`order:${order.orderId}`)).toEqual([null]);
  });

  it("keeps a withdrawal's reason to operations and the withdrawn captain (AP §10, slice 2.12a)", async () => {
    const order = { orderId: randomUUID(), restaurantId: randomUUID() };
    const captainId = randomUUID();
    await insert({
      ...order,
      type: 'order.reassigned',
      version: 6,
      captainTrack: 'searching',
      captainId,
      reason: 'captain_late',
    });
    await relay.drain(new Date());
    const reasonOn = async (channel: string) =>
      ((await centrifugo.history(channel)) as { reason: string | null }[]).map(
        (data) => data.reason,
      );
    expect(await reasonOn(`captain:${captainId}`)).toEqual(['captain_late']);
    expect(await reasonOn(`ops:city.${city}`)).toContain('captain_late');
    expect(await reasonOn(`merchant:${order.restaurantId}`)).toEqual([null]);
    expect(await reasonOn(`order:${order.orderId}`)).toEqual([null]);
  });

  it('sends a handover’s steps to both captains and the panel only, and its receipt to all (slice 2.12b)', async () => {
    const order = { orderId: randomUUID(), restaurantId: randomUUID() };
    const first = randomUUID();
    const second = randomUUID();
    const handover = {
      ...order,
      captainTrack: 'picked_up',
      captainId: second,
      otherCaptainId: first,
    };
    await insert({ ...handover, type: 'order.handover_assigned', version: 9 });
    await insert({ ...handover, type: 'order.handed_over', version: 10 });
    await relay.drain(new Date());
    expect(await versionsOn(`captain:${first}`)).toEqual([9, 10]);
    expect(await versionsOn(`captain:${second}`)).toEqual([9, 10]);
    expect(await versionsOn(`ops:city.${city}`)).toEqual(expect.arrayContaining([10, 9]));
    expect(await versionsOn(`merchant:${order.restaurantId}`)).toEqual([10]);
    expect(await versionsOn(`order:${order.orderId}`)).toEqual([10]);
  });

  it("tells the restaurant the customer's own cancellation, and false for a row before slice 2.8a (RA §8.3)", async () => {
    const order = { orderId: randomUUID(), restaurantId: randomUUID() };
    await insert({ ...order, type: 'order.placed', version: 1 });
    await insert({ ...order, type: 'order.cancelled', version: 2, byCustomer: true });
    await relay.drain(new Date());
    const history = (await centrifugo.history(`merchant:${order.restaurantId}`)) as {
      version: number;
      byCustomer: boolean;
    }[];
    expect(history.map(({ version, byCustomer }) => ({ version, byCustomer }))).toEqual([
      { version: 1, byCustomer: false },
      { version: 2, byCustomer: true },
    ]);
  });

  it("publishes each row to its restaurant's, its city's and its order's channels, in id order, once", async () => {
    const order = { orderId: randomUUID(), restaurantId: randomUUID() };
    const placed = await insert({ ...order, type: 'order.placed', version: 1 });
    const cancelled = await insert({ ...order, type: 'order.cancelled', version: 2 });

    expect(await relay.drain(new Date())).toBe(2);

    expect(await unpublished([placed, cancelled])).toBe(0);
    expect(await versionsOn(`merchant:${order.restaurantId}`)).toEqual([1, 2]);
    expect(await versionsOn(`order:${order.orderId}`)).toEqual([1, 2]);
    // The panel's board and detail of the city (architecture §6.2), with the
    // captain track the customer's channel leaves out.
    const ops = (await centrifugo.history(`ops:city.${city}`)) as {
      orderId: string;
      version: number;
    }[];
    expect(
      ops.filter((data) => data.orderId === order.orderId).map((data) => data.version),
    ).toEqual([1, 2]);
    const [first] = (await centrifugo.history(`order:${order.orderId}`)) as object[];
    expect(first).toMatchObject({ schema: 1, orderId: order.orderId, status: 'placed' });

    // A published row is never sent again.
    expect(await relay.drain(new Date())).toBe(0);
    expect(await versionsOn(`order:${order.orderId}`)).toEqual([1, 2]);
  });

  it("keeps the captain track and the captain's own steps off the customer's channel (CU §11.2)", async () => {
    const order = { orderId: randomUUID(), restaurantId: randomUUID() };
    await insert({ ...order, type: 'order.placed', version: 1 });
    await insert({ ...order, type: 'order.offered', version: 2, captainTrack: 'offered' });
    await insert({ ...order, type: 'order.assigned', version: 3, captainTrack: 'assigned' });

    expect(await relay.drain(new Date())).toBe(3);

    expect(await versionsOn(`merchant:${order.restaurantId}`)).toEqual([1, 2, 3]);
    const merchant = (await centrifugo.history(`merchant:${order.restaurantId}`)) as object[];
    expect(merchant[2]).toMatchObject({ type: 'order.assigned', captainTrack: 'assigned' });
    // The customer gets the assignment, which changes the captain card, but
    // neither the offer nor the track.
    expect(await versionsOn(`order:${order.orderId}`)).toEqual([1, 3]);
    for (const data of (await centrifugo.history(`order:${order.orderId}`)) as object[]) {
      expect(data).not.toHaveProperty('captainTrack');
    }
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
