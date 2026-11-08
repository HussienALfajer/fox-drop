import 'reflect-metadata';
import { randomUUID } from 'node:crypto';
import { Module } from '@nestjs/common';
import { Test, type TestingModule } from '@nestjs/testing';
import pg from 'pg';
import { afterAll, beforeAll, beforeEach, describe, expect, it } from 'vitest';
import { DATABASE, DatabaseModule } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { startTestDatabase, type TestDatabase } from '../../database/test-database.js';
import { PUSH_SENDER, type PushMessage, type PushResult } from './fcm-sender.js';
import { PushDevices, type PushRecipient } from './push-devices.js';
import { PushQueue, type QueuedPush } from './push-queue.js';
import { PushRelay, retryDelayMs } from './push-relay.js';

// Architecture §8.1: a queued push reaches every live device of its
// recipient at least once, is tried again on a passing failure until it
// expires, and a token Firebase no longer knows is forgotten.
let database: TestDatabase;
let sql: pg.Pool;
let context: TestingModule;
let relay: PushRelay;
let queue: PushQueue;
let db: Database['db'];

const sent: PushMessage[] = [];
let answer: (message: PushMessage) => PushResult = () => 'sent';
const devicesOf = new Map<string, string[]>();
const invalidated: string[] = [];

const keyOf = (recipient: PushRecipient) =>
  recipient.party === 'customer'
    ? recipient.accountId
    : recipient.party === 'captain'
      ? recipient.captainId
      : recipient.restaurantId;

beforeAll(async () => {
  database = await startTestDatabase();
  process.env.DATABASE_URL = database.appUrl;
  sql = new pg.Pool({ connectionString: database.appUrl });
  const devices = {
    targets: async (recipient: PushRecipient) =>
      (devicesOf.get(keyOf(recipient)) ?? []).map((token) => ({ sessionId: token, token })),
    invalidate: async (_executor: unknown, tokens: string[]) => {
      invalidated.push(...tokens);
    },
  };
  const sender = {
    send: async (message: PushMessage) => {
      sent.push(message);
      return answer(message);
    },
  };
  @Module({
    imports: [DatabaseModule],
    providers: [
      PushQueue,
      PushRelay,
      { provide: PushDevices, useValue: devices },
      { provide: PUSH_SENDER, useValue: sender },
    ],
  })
  class RelayTestModule {}
  context = await Test.createTestingModule({ imports: [RelayTestModule] }).compile();
  relay = context.get(PushRelay);
  queue = context.get(PushQueue);
  db = context.get<Database>(DATABASE).db;
}, 300_000);

afterAll(async () => {
  await context?.close();
  await sql?.end();
  await database?.stop();
});

beforeEach(async () => {
  // Pushes left by an earlier test are given up.
  await relay.drain(new Date(Date.now() + 3_600_000));
  sent.length = 0;
  invalidated.length = 0;
  answer = () => 'sent';
});

function push(accountId: string, fields: Partial<QueuedPush> = {}): QueuedPush {
  return {
    source: `test:${randomUUID()}`,
    recipient: { party: 'customer', accountId },
    templateKey: 'customer.accepted',
    body: 'المطعم يحضّر طلبك. يصل حوالي 9:45 م',
    level: 'default',
    priority: 'normal',
    data: { target: 'order', orderId: 'order-1' },
    ...fields,
  };
}

const row = async (source: string) =>
  (
    await sql.query(
      'SELECT id, sent_at, gave_up_at, attempts, devices FROM notifications.push_messages WHERE source = $1',
      [source],
    )
  ).rows[0];

describe('the push relay (architecture §8.1)', () => {
  it("sends to each of the recipient's devices once, with the app's channel and what a tap opens", async () => {
    const accountId = randomUUID();
    devicesOf.set(accountId, ['phone', 'tablet']);
    const message = push(accountId, { level: 'ring', priority: 'high' });
    const now = new Date();
    await queue.enqueue(db, [message, message], now);

    expect(await relay.drain(now)).toBe(1);
    const { id, sent_at, devices } = await row(message.source);
    expect(sent_at).not.toBeNull();
    expect(devices).toBe(2);
    expect(sent.map((one) => one.token)).toEqual(['phone', 'tablet']);
    expect(sent[0]).toEqual({
      token: 'phone',
      title: 'FOX DROP',
      body: message.body,
      channel: 'ring',
      priority: 'high',
      data: { target: 'order', orderId: 'order-1', messageId: id },
      ttlSeconds: 600,
    });
    expect(await relay.drain(now)).toBe(0);
  });

  it('is done without any device, and forgets the tokens Firebase no longer knows', async () => {
    const lonely = push(randomUUID());
    const accountId = randomUUID();
    devicesOf.set(accountId, ['old', 'new']);
    const message = push(accountId);
    answer = (one) => (one.token === 'old' ? 'invalid' : 'sent');
    const now = new Date();
    await queue.enqueue(db, [lonely, message], now);

    expect(await relay.drain(now)).toBe(2);
    expect((await row(lonely.source)).devices).toBe(0);
    expect((await row(message.source)).devices).toBe(1);
    expect(invalidated).toEqual(['old']);
  });

  it('tries again later when FCM fails for a passing reason, until the push expires', async () => {
    const accountId = randomUUID();
    devicesOf.set(accountId, ['phone']);
    const message = push(accountId);
    const now = new Date();
    await queue.enqueue(db, [message], now);
    answer = () => 'retry';

    expect(await relay.drain(now)).toBe(0);
    expect(await row(message.source)).toMatchObject({ sent_at: null, attempts: 1 });
    expect(await relay.drain(new Date(now.getTime() + retryDelayMs(1) - 1))).toBe(0);
    expect(sent).toHaveLength(1);

    answer = () => 'sent';
    expect(await relay.drain(new Date(now.getTime() + retryDelayMs(1)))).toBe(1);
    expect((await row(message.source)).devices).toBe(1);

    const late = push(accountId);
    await queue.enqueue(db, [late], now);
    expect(await relay.drain(new Date(now.getTime() + 600_000))).toBe(1);
    expect((await row(late.source)).gave_up_at).not.toBeNull();
  });

  it('counts its time and expiry from what it tells, so a late backlog is never sent', async () => {
    const accountId = randomUUID();
    devicesOf.set(accountId, ['phone']);
    const now = new Date();
    const stale = push(accountId, { at: new Date(now.getTime() - 3_600_000) });
    const offer = push(accountId, { expiresAt: new Date(now.getTime() + 30_000) });
    await queue.enqueue(db, [stale, offer], now);

    expect(await relay.drain(now)).toBe(2);
    expect((await row(stale.source)).gave_up_at).not.toBeNull();
    expect(sent.map((one) => one.ttlSeconds)).toEqual([30]);
  });

  it("keeps a customer's pushes as «الإشعارات» for 30 days, newest first (CU §13)", async () => {
    const accountId = randomUUID();
    const now = new Date();
    const old = push(accountId, { body: 'قديم' });
    const first = push(accountId, { body: 'أول' });
    const second = push(accountId, { body: 'ثانٍ' });
    await queue.enqueue(db, [old], new Date(now.getTime() - 31 * 86_400_000));
    await queue.enqueue(db, [first], new Date(now.getTime() - 60_000));
    await queue.enqueue(db, [second], now);
    await queue.enqueue(db, [push(randomUUID(), { body: 'لغيره' })], now);

    const inbox = await queue.inbox(accountId, now);
    expect(inbox.map((entry) => entry.body)).toEqual(['ثانٍ', 'أول']);
    expect(inbox[0]!.data).toEqual({ target: 'order', orderId: 'order-1' });
  });
});
