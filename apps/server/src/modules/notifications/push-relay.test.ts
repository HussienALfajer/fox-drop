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
import { channelOf, interruptionOf, PushRelay, retryDelayMs } from './push-relay.js';

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
  recipient.party === 'customer' || recipient.party === 'applicant'
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
      (devicesOf.get(keyOf(recipient)) ?? []).map((token) => ({
        sessionId: token,
        token,
        ringingOff: token.startsWith('quiet'),
      })),
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

// CA §4.4 (slice 2.43): a captain's offer rings on the captain app's
// channel with the bundled offer sound; every other push on its level.
describe('the channel of a push', () => {
  it('sends a captain’s offer to ring_offer', () => {
    expect(channelOf({ party: 'captain', level: 'offer' }, false)).toBe('ring_offer');
    expect(channelOf({ party: 'captain', level: 'chime' }, false)).toBe('chime');
    expect(channelOf({ party: 'customer', level: 'offer' }, false)).toBe('offer');
  });
});

// Architecture §8.1, CA §4.4 (K15), CU §4.4, §14 #4–#5 (slice 2.46): on an
// iPhone a captain's offer and the customer's arrival and door ping are
// time-sensitive, the offer critical once Apple granted it.
describe('the interruption level of a push', () => {
  type Party = 'customer' | 'merchant' | 'captain';
  const of = (row: { party: Party; level: string; templateKey: string }, critical = false) =>
    interruptionOf(row, false, critical);
  it('makes the offer, the arrival and the door ping time-sensitive', () => {
    const offer = { party: 'captain' as const, level: 'offer', templateKey: 'captain.new_offer' };
    expect(of(offer)).toBe('time-sensitive');
    expect(of(offer, true)).toBe('critical');
    for (const key of [
      'customer.captain_arrived',
      'customer.captain_arrived_recipient',
      'customer.door_ping',
      'customer.door_ping_recipient',
    ]) {
      expect(of({ party: 'customer', level: 'default', templateKey: key }, true)).toBe(
        'time-sensitive',
      );
    }
    expect(of({ party: 'customer', level: 'default', templateKey: 'customer.accepted' })).toBe(
      'active',
    );
    expect(of({ party: 'captain', level: 'silent', templateKey: 'captain.pay_table_change' })).toBe(
      'passive',
    );
    expect(
      interruptionOf(
        { party: 'merchant', level: 'ring', templateKey: 'merchant.new_order' },
        true,
        false,
      ),
    ).toBe('passive');
  });
});

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
      interruption: 'active',
    });
    expect(await relay.drain(now)).toBe(0);
  });

  // RA §4.4, §16 (slice 2.42): an owner's device with ringing off.
  it('sends a restaurant’s ring on its bundled sound’s channel, silently with ringing off', async () => {
    const restaurantId = randomUUID();
    devicesOf.set(restaurantId, ['cashier', 'quiet-owner']);
    const recipient = { party: 'merchant' as const, restaurantId, owners: false };
    const ring = push('', { recipient, level: 'ring', priority: 'high' });
    const chime = push('', { recipient, level: 'chime' });
    const now = new Date();
    await queue.enqueue(db, [ring, chime], now);
    await relay.drain(now);
    expect(sent.map((one) => [one.token, one.channel])).toEqual([
      ['cashier', 'ring_order'],
      ['quiet-owner', 'silent'],
      ['cashier', 'chime'],
      ['quiet-owner', 'chime'],
    ]);
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

  it('sends a mass push with its own title, after every other due push, from its time (AP §9.11.4)', async () => {
    const campaignId = randomUUID();
    const now = new Date();
    const customers = Array.from({ length: 25 }, () => randomUUID());
    for (const id of customers) devicesOf.set(id, [`phone-${id}`]);
    const later = new Date(now.getTime() + 60_000);
    const mass = customers.map((id) =>
      push(id, { title: 'عرض الشتاء', campaignId, at: later, data: { target: 'home' } }),
    );
    await queue.enqueue(db, mass, now);
    expect(await relay.drain(now)).toBe(0);
    expect(await queue.inbox(customers[0]!, later)).toEqual([]);

    const orderCustomer = randomUUID();
    devicesOf.set(orderCustomer, ['order-phone']);
    const order = push(orderCustomer, { at: later });
    await queue.enqueue(db, [order], later);
    expect(await relay.drain(later)).toBe(26);
    expect(sent[0]!.token).toBe('order-phone');
    expect(sent[0]!.title).toBe('FOX DROP');
    expect(sent[1]!.title).toBe('عرض الشتاء');
    expect((await queue.inbox(customers[0]!, later)).map((entry) => entry.body)).toEqual([
      mass[0]!.body,
    ]);

    // The first receipt counts; another id or a repeat changes nothing.
    const { id } = await row(mass[0]!.source);
    await queue.acknowledge(id, later);
    await queue.acknowledge(id, new Date(later.getTime() + 1000));
    await queue.acknowledge(randomUUID(), later);
    devicesOf.delete(customers[1]!);
    expect(await queue.campaignCounts([campaignId, randomUUID()])).toEqual(
      new Map([[campaignId, { recipients: 25, sent: 25, delivered: 1 }]]),
    );
  });

  it('never sends or shows a cancelled mass push (AP §9.11.4)', async () => {
    const campaignId = randomUUID();
    const accountId = randomUUID();
    devicesOf.set(accountId, ['phone']);
    const now = new Date();
    const at = new Date(now.getTime() + 3_600_000);
    const mass = push(accountId, { campaignId, at });
    await queue.enqueue(db, [mass], now);
    await queue.cancelCampaign(db, campaignId, now);

    expect(await relay.drain(at)).toBe(0);
    expect(sent).toEqual([]);
    expect(await queue.inbox(accountId, at)).toEqual([]);
    await queue.acknowledge((await row(mass.source)).id, at);
    expect(await queue.campaignCounts([campaignId])).toEqual(
      new Map([[campaignId, { recipients: 1, sent: 0, delivered: 0 }]]),
    );
  });

  it('takes a push queued during a campaign at the next batch, not after the campaign', async () => {
    const campaignId = randomUUID();
    const now = new Date();
    const customers = Array.from({ length: 45 }, () => randomUUID());
    for (const id of customers) devicesOf.set(id, [`phone-${id}`]);
    await queue.enqueue(
      db,
      customers.map((id) => push(id, { campaignId, data: { target: 'home' } })),
      now,
    );
    const orderCustomer = randomUUID();
    devicesOf.set(orderCustomer, ['order-phone']);
    let queued = false;
    answer = () => {
      // While the first batch is sent, an order's push is queued.
      if (!queued) {
        queued = true;
        void queue.enqueue(db, [push(orderCustomer)], new Date());
      }
      return 'sent';
    };
    await relay.drain(now);
    const at = sent.findIndex((one) => one.token === 'order-phone');
    expect(at).toBeGreaterThanOrEqual(20);
    expect(at).toBeLessThanOrEqual(21);
  });
});
