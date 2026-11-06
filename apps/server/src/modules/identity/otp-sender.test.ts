import 'reflect-metadata';
import { randomBytes, randomInt, randomUUID } from 'node:crypto';
import type { NestFastifyApplication } from '@nestjs/platform-fastify';
import { Test, type TestingModule } from '@nestjs/testing';
import { Valkey } from 'iovalkey';
import pg from 'pg';
import { afterAll, beforeAll, beforeEach, describe, expect, it, vi } from 'vitest';
import { ApiModule } from '../../api.module.js';
import { reportAlert } from '../../observability/error-tracking.js';
import { createDatabase, type Database } from '../../database/database.js';
import { startTestDatabase, type TestDatabase } from '../../database/test-database.js';
import { createApiApp } from '../../http/create-api-app.js';
import { startTestValkey, type TestValkey } from '../../valkey/test-valkey.js';
import { SettingsService } from '../settings/index.js';
import { AdminSessionsService } from './admin-sessions.service.js';
import { ADMIN_SESSION_COOKIE } from './route-access.guard.js';
import {
  encodeSendRequest,
  MAX_WAITING_SENDS,
  QueuedCodeSender,
  SEND_ANSWER_TIMEOUT_MS,
  SEND_DEADLINE_MARGIN_MS,
  SEND_REQUESTS_KEY,
} from './code-send-queue.js';
import { codeMessage, replyMessage } from './otp-messages.js';
import { OtpSenderNumbers } from './otp-sender-numbers.js';
import { connectedKey, senderDay, THROTTLE_MINUTES } from './otp-sender-pool.js';
import { OtpSenderModule } from './otp-sender.module.js';
import { ON_WHATSAPP_CACHE_DAYS, OtpSenderService } from './otp-sender.service.js';
import { IdentitySecrets } from './secrets.js';
import {
  WHATSAPP_CONNECT,
  type WhatsAppConnect,
  type WhatsAppEvents,
  type WhatsAppSessionStore,
} from './whatsapp-client.js';

// The WhatsApp sender of architecture §8.3.1 and §8.3.3 items 3, 6–12, 14:
// the otp-sender process with a fake WhatsApp library, the API's code
// requests through Valkey, and the sessions stored encrypted in PostgreSQL.

// The alerts that would reach Sentry (§8.3.3 item 14).
vi.mock('../../observability/error-tracking.js', async (original) => ({
  ...(await original<typeof import('../../observability/error-tracking.js')>()),
  reportAlert: vi.fn(),
}));
const alerts = vi.mocked(reportAlert);

// One sending number as the fake library sees it, found by the phone its
// stored session names.
class FakeNumber {
  readonly sent: { phone: string; text: string; id: string }[] = [];
  readonly replies: { chat: string; text: string }[] = [];
  connects = 0;
  closes = 0;
  failSend = false;
  // The on-WhatsApp check never answers.
  hang = false;
  // The session never opens.
  neverOpen = false;
  events: WhatsAppEvents | undefined;
  session: WhatsAppSessionStore | undefined;

  constructor(readonly phone: string) {}
}

class FakeWhatsApp {
  readonly onWhatsApp = new Set<string>();
  readonly numbers = new Map<string, FakeNumber>();
  checks = 0;
  private messages = 0;

  number(phone: string): FakeNumber {
    let number = this.numbers.get(phone);
    if (!number) {
      number = new FakeNumber(phone);
      this.numbers.set(phone, number);
    }
    return number;
  }

  // Every send of every number, in order.
  sentBy(): { from: string; to: string }[] {
    return [...this.numbers.values()]
      .flatMap((number) => number.sent.map((sent) => ({ ...sent, from: number.phone })))
      .sort((a, b) => Number(a.id.slice(2)) - Number(b.id.slice(2)))
      .map((sent) => ({ from: sent.from, to: sent.phone }));
  }

  connect: WhatsAppConnect = async (session, events) => {
    const stored = await session.read('creds');
    const { phone } = JSON.parse(stored ?? '{}') as { phone: string };
    const number = this.number(phone);
    number.connects += 1;
    number.session = session;
    number.events = events;
    await session.write({ restored: 'yes' });
    if (!number.neverOpen) setImmediate(() => events.open(phone));
    return {
      isOnWhatsApp: (to) => {
        if (number.hang) return new Promise<boolean>(() => undefined);
        this.checks += 1;
        return Promise.resolve(this.onWhatsApp.has(to));
      },
      sendText: (to, text) => {
        if (number.failSend) return Promise.reject(new Error('socket closed'));
        this.messages += 1;
        const id = `m-${this.messages}`;
        number.sent.push({ phone: to, text, id });
        return Promise.resolve(id);
      },
      reply: (chat, text) => {
        number.replies.push({ chat, text });
        return Promise.resolve();
      },
      close: () => {
        number.closes += 1;
        return Promise.resolve();
      },
    };
  };
}

let database: TestDatabase;
let cache: TestValkey;
let sql: pg.Pool;
let db: Database;
let valkey: Valkey;
let secrets: IdentitySecrets;
let numbers: OtpSenderNumbers;

const system = { editor: 'system', context: { ipAddress: null, device: null } } as const;

function newPhone(): string {
  return `+9639${randomInt(100_000_000).toString().padStart(8, '0')}`;
}

const pause = (ms: number) => new Promise((resolve) => setTimeout(resolve, ms));

async function until(check: () => boolean): Promise<void> {
  for (let attempt = 0; attempt < 100 && !check(); attempt += 1) await pause(20);
  expect(check()).toBe(true);
}

// Pairs a number, as the pairing command does: its session names its phone.
function pair(phone: string, now = new Date()) {
  return numbers.savePaired(phone, new Map([['creds', JSON.stringify({ phone })]]), now);
}

async function statusOf(numberId: string): Promise<string | undefined> {
  const { rows } = await sql.query<{ status: string }>(
    'SELECT status FROM identity.otp_sender_numbers WHERE id = $1',
    [numberId],
  );
  return rows[0]?.status;
}

async function countsOf(numberId: string) {
  const { rows } = await sql.query<{
    sent: number;
    failed: number;
    delivered: number;
    read: number;
  }>(
    'SELECT sent, failed, delivered, read FROM identity.otp_sender_daily_counts WHERE number_id = $1 AND day = $2',
    [numberId, senderDay(new Date())],
  );
  return rows[0] ?? { sent: 0, failed: 0, delivered: 0, read: 0 };
}

beforeAll(async () => {
  [database, cache] = await Promise.all([startTestDatabase(), startTestValkey()]);
  const key = randomBytes(32);
  process.env.DATABASE_URL = database.appUrl;
  process.env.VALKEY_URL = cache.url;
  process.env.IDENTITY_ENCRYPTION_KEY = key.toString('base64');
  process.env.SUPPORT_WHATSAPP_NUMBER = '+963911000000';
  sql = new pg.Pool({ connectionString: database.appUrl });
  db = createDatabase(database.appUrl);
  valkey = new Valkey(cache.url);
  await valkey.ping();
  secrets = new IdentitySecrets(key);
  numbers = new OtpSenderNumbers(db, secrets);
}, 300_000);

afterAll(async () => {
  valkey?.disconnect();
  await db?.pool.end();
  await sql?.end();
  await Promise.all([database?.stop(), cache?.stop()]);
});

describe('without an otp-sender', () => {
  it('answers unavailable after the timeout, with nothing in clear on the queue', async () => {
    const queued = new QueuedCodeSender(valkey, secrets, 300);
    const phone = newPhone();
    const answer = queued.send(phone, '482913');
    await pause(50);
    const [request] = await valkey.lrange(SEND_REQUESTS_KEY, 0, -1);
    expect(request).toBeDefined();
    expect(request).not.toContain('482913');
    expect(request).not.toContain(phone.slice(1));
    expect(await answer).toBe('unavailable');
    await queued.onApplicationShutdown();
    await valkey.del(SEND_REQUESTS_KEY);
  });

  it('answers unavailable at once beyond three waiting requests, or while Valkey is away', async () => {
    const queued = new QueuedCodeSender(valkey, secrets, 500);
    const waiting = [1, 2, 3].map(() => queued.send(newPhone(), '482913'));
    await pause(50);
    const started = Date.now();
    expect(await queued.send(newPhone(), '482913')).toBe('unavailable');
    expect(Date.now() - started).toBeLessThan(100);
    expect(await Promise.all(waiting)).toEqual(['unavailable', 'unavailable', 'unavailable']);
    expect(await valkey.llen(SEND_REQUESTS_KEY)).toBe(MAX_WAITING_SENDS);
    await queued.onApplicationShutdown();
    await valkey.del(SEND_REQUESTS_KEY);

    const away = new Valkey(cache.url, { lazyConnect: true, enableOfflineQueue: false });
    const offline = new QueuedCodeSender(away, secrets);
    const before = Date.now();
    expect(await offline.send(newPhone(), '482913')).toBe('unavailable');
    expect(Date.now() - before).toBeLessThan(100);
    away.disconnect();
  });

  it('waits ten seconds by default', () => {
    expect(SEND_ANSWER_TIMEOUT_MS).toBe(10_000);
  });
});

describe('the otp-sender', () => {
  let whatsapp: FakeWhatsApp;
  let senderModule: TestingModule;
  let sender: OtpSenderService;
  let settings: SettingsService;
  let queued: QueuedCodeSender;

  // Answers one request as the request loop would, with ten seconds left.
  const request = (phone: string, code = '482913', now = new Date(), left = 10_000) =>
    sender.answer(encodeSendRequest(secrets, phone, code, now.getTime() + left), now);

  const reachable = () => {
    const phone = newPhone();
    whatsapp.onWhatsApp.add(phone);
    return phone;
  };

  // Ends every number of the earlier tests, so each test has its own pool.
  async function emptyPool(): Promise<void> {
    await sql.query(
      'UPDATE identity.otp_sender_numbers SET disabled_at = now() WHERE disabled_at IS NULL',
    );
    await sender.supervise();
    expect(sender.connectedNumbers()).toEqual([]);
  }

  async function activate(numberId: string): Promise<void> {
    await sql.query(
      "UPDATE identity.otp_sender_numbers SET status = 'active', warmup_started_at = NULL WHERE id = $1",
      [numberId],
    );
  }

  async function connected(...numberIds: string[]): Promise<void> {
    await sender.supervise();
    await until(() => numberIds.every((id) => sender.connectedNumbers().includes(id)));
  }

  beforeAll(async () => {
    whatsapp = new FakeWhatsApp();
    senderModule = await Test.createTestingModule({ imports: [OtpSenderModule] })
      .overrideProvider(WHATSAPP_CONNECT)
      .useValue(whatsapp.connect)
      .compile();
    await senderModule.init();
    sender = senderModule.get(OtpSenderService);
    settings = senderModule.get(SettingsService);
    // No jitter, unless a test asks for it.
    await settings.update('otp.send_jitter_sec', {}, { min: 0, max: 0 }, system);
    queued = new QueuedCodeSender(valkey, secrets);
  });

  afterAll(async () => {
    await queued?.onApplicationShutdown();
    await senderModule?.close();
  });

  it('answers unavailable at once while no number is paired', async () => {
    const started = Date.now();
    expect(await queued.send(newPhone(), '111111')).toBe('unavailable');
    expect(Date.now() - started).toBeLessThan(SEND_ANSWER_TIMEOUT_MS);
    expect(whatsapp.numbers.size).toBe(0);
  });

  it('says once that no number can send, after the sessions had a supervision to open', async () => {
    // The module's start ran the first supervision: no alert yet.
    expect(alerts).not.toHaveBeenCalled();
    await sender.supervise();
    await sender.supervise();
    expect(alerts.mock.calls).toEqual([
      ['لا يمكن إرسال رموز الدخول: no sending number can send', 'fatal'],
    ]);
  });

  describe('with a paired number', () => {
    const own = '+963900000001';
    let numberId: string;
    let fake: FakeNumber;

    beforeAll(async () => {
      numberId = (await pair(own)).id;
      fake = whatsapp.number(own);
      await connected(numberId);
    });

    beforeEach(() => {
      fake.failSend = false;
    });

    it('starts it warming, restores the stored session and keeps it encrypted', async () => {
      expect(await statusOf(numberId)).toBe('warming');
      expect(fake.connects).toBe(1);
      expect(await fake.session?.read('creds')).toBe(JSON.stringify({ phone: own }));
      const { rows } = await sql.query<{ key: string; value_encrypted: string }>(
        'SELECT key, value_encrypted FROM identity.otp_sender_credentials WHERE number_id = $1 ORDER BY key',
        [numberId],
      );
      expect(rows.map((row) => row.key)).toEqual(['creds', 'restored']);
      expect(JSON.stringify(rows)).not.toContain('963900000001');
      expect(JSON.stringify(rows)).not.toContain('yes');
      const { rows: stored } = await sql.query<{ phone_encrypted: string; phone_hash: string }>(
        'SELECT phone_encrypted, phone_hash FROM identity.otp_sender_numbers',
      );
      expect(JSON.stringify(stored)).not.toContain('963900000001');
    });

    it('marks it connected for the API', async () => {
      expect(await valkey.get(connectedKey(numberId))).toBe('1');
    });

    it('sends the fixed message to a number on WhatsApp, checked once in 30 days', async () => {
      const phone = reachable();
      const checks = whatsapp.checks;
      expect(await queued.send(phone, '482913')).toBe('sent');
      expect(fake.sent.at(-1)).toMatchObject({ phone, text: codeMessage('482913') });
      expect(codeMessage('482913')).toBe(
        'رمز الدخول إلى FOX DROP: 482913\nلا تشارك هذا الرمز مع أحد. إن لم تطلبه فتجاهل هذه الرسالة.',
      );
      expect(await queued.send(phone, '123456')).toBe('sent');
      expect(whatsapp.checks).toBe(checks + 1);

      const later = new Date(Date.now() + (ON_WHATSAPP_CACHE_DAYS + 1) * 24 * 60 * 60 * 1000);
      expect(await request(phone, '654321', later)).toBe('sent');
      expect(whatsapp.checks).toBe(checks + 2);
    });

    it('sends nothing to a number without WhatsApp, and checks it again next time', async () => {
      const phone = newPhone();
      const sent = fake.sent.length;
      expect(await queued.send(phone, '482913')).toBe('not_on_whatsapp');
      expect(await queued.send(phone, '482913')).toBe('not_on_whatsapp');
      expect(fake.sent).toHaveLength(sent);
      const { rows } = await sql.query(
        'SELECT 1 FROM identity.otp_whatsapp_numbers WHERE phone_hash = $1',
        [secrets.phoneHash(phone)],
      );
      expect(rows).toHaveLength(0);
    });

    it('drops a request too close to its deadline unsent', async () => {
      const sent = fake.sent.length;
      const late = encodeSendRequest(
        secrets,
        reachable(),
        '482913',
        Date.now() + SEND_DEADLINE_MARGIN_MS - 1,
      );
      expect(await sender.answer(late)).toBeNull();
      expect(fake.sent).toHaveLength(sent);
    });

    it('answers unavailable when the library fails to send, and counts the failure', async () => {
      const before = await countsOf(numberId);
      fake.failSend = true;
      expect(await queued.send(reachable(), '482913')).toBe('unavailable');
      expect(await countsOf(numberId)).toEqual({ ...before, failed: before.failed + 1 });
    });

    it('replies once to someone who writes to the number', async () => {
      const chat = `${randomUUID()}@lid`;
      fake.events?.incoming(chat);
      fake.events?.incoming(chat);
      await until(() => fake.replies.some((reply) => reply.chat === chat));
      await pause(100);
      expect(fake.replies.filter((reply) => reply.chat === chat)).toEqual([
        { chat, text: replyMessage('+963911000000') },
      ]);
    });

    it('reconnects from the stored session after a lost connection', async () => {
      const connects = fake.connects;
      fake.events?.closed('lost');
      expect(sender.connectedNumbers()).toEqual([]);
      await connected(numberId);
      expect(fake.connects).toBe(connects + 1);
    });

    it('marks a logged-out number disconnected and sends nothing more', async () => {
      fake.events?.closed('logged_out');
      await until(() => sender.connectedNumbers().length === 0);
      await pause(100);
      expect(await statusOf(numberId)).toBe('disconnected');
      expect(await valkey.get(connectedKey(numberId))).toBeNull();
      const connects = fake.connects;
      await sender.supervise();
      expect(fake.connects).toBe(connects);
      expect(await queued.send(newPhone(), '482913')).toBe('unavailable');
    });
  });

  describe('with several numbers (§8.3.3 items 6, 7, 11, 12)', () => {
    beforeEach(async () => {
      await emptyPool();
      await settings.reset('otp.sender_per_minute_max', {}, system);
      await settings.update('otp.send_jitter_sec', {}, { min: 0, max: 0 }, system);
    });

    async function activeNumbers(count: number) {
      const paired = [];
      for (let index = 0; index < count; index += 1) {
        const phone = newPhone();
        const { id } = await pair(phone);
        await activate(id);
        paired.push({ id, phone, fake: whatsapp.number(phone) });
      }
      await connected(...paired.map((number) => number.id));
      return paired;
    }

    it('take turns', async () => {
      const [first, second] = await activeNumbers(2);
      const to = [reachable(), reachable(), reachable(), reachable()];
      for (const phone of to) expect(await request(phone)).toBe('sent');
      const senders = whatsapp
        .sentBy()
        .filter((sent) => to.includes(sent.to))
        .map((sent) => sent.from);
      expect(new Set(senders.slice(0, 2))).toEqual(new Set([first!.phone, second!.phone]));
      expect(senders.slice(2)).toEqual(senders.slice(0, 2));
      expect((await countsOf(first!.id)).sent).toBe(2);
      expect((await countsOf(second!.id)).sent).toBe(2);
    });

    it('move to the next number when a send fails', async () => {
      const [first, second] = await activeNumbers(2);
      first!.fake.failSend = true;
      second!.fake.failSend = true;
      const phone = reachable();
      expect(await request(phone)).toBe('unavailable');
      second!.fake.failSend = false;
      expect(await request(phone)).toBe('sent');
      expect(second!.fake.sent.at(-1)?.phone).toBe(phone);
      expect(await countsOf(first!.id)).toMatchObject({ sent: 0, failed: 2 });
      expect(await countsOf(second!.id)).toMatchObject({ sent: 1, failed: 1 });
    });

    it('send from a warming number only when no active one can', async () => {
      const [active] = await activeNumbers(1);
      const warmingPhone = newPhone();
      const { id: warmingId } = await pair(warmingPhone);
      await connected(warmingId);
      expect(await request(reachable())).toBe('sent');
      expect(await request(reachable())).toBe('sent');
      expect(whatsapp.number(warmingPhone).sent).toHaveLength(0);
      await sql.query("UPDATE identity.otp_sender_numbers SET status = 'standby' WHERE id = $1", [
        active!.id,
      ]);
      expect(await request(reachable())).toBe('sent');
      expect(whatsapp.number(warmingPhone).sent).toHaveLength(1);
    });

    it('stop a number at its warm-up cap, and send nothing from a standby one', async () => {
      const phone = newPhone();
      const { id } = await pair(phone);
      await connected(id);
      await sql.query(
        'INSERT INTO identity.otp_sender_daily_counts (number_id, day, sent, failed) VALUES ($1, $2, 49, 0)',
        [id, senderDay(new Date())],
      );
      expect(await request(reachable())).toBe('sent');
      expect(await request(reachable())).toBe('unavailable');
      expect(whatsapp.number(phone).sent).toHaveLength(1);

      await sql.query("UPDATE identity.otp_sender_numbers SET status = 'standby' WHERE id = $1", [
        id,
      ]);
      const standby = (await pair(newPhone())).id;
      await sql.query(
        "UPDATE identity.otp_sender_numbers SET status = 'standby', warmup_started_at = NULL WHERE id = $1",
        [standby],
      );
      await connected(standby);
      expect(await request(reachable())).toBe('unavailable');
    });

    it('pace each number per minute', async () => {
      await settings.update('otp.sender_per_minute_max', {}, 2, system);
      const [only] = await activeNumbers(1);
      expect(await request(reachable())).toBe('sent');
      expect(await request(reachable())).toBe('sent');
      const started = Date.now();
      expect(await request(reachable())).toBe('unavailable');
      expect(Date.now() - started).toBeLessThan(1_000);
      expect(only!.fake.sent).toHaveLength(2);
    });

    it('wait the jitter between two sends of one number', async () => {
      await settings.update('otp.send_jitter_sec', {}, { min: 1, max: 1 }, system);
      await activeNumbers(1);
      expect(await request(reachable())).toBe('sent');
      const started = Date.now();
      expect(await request(reachable())).toBe('sent');
      expect(Date.now() - started).toBeGreaterThanOrEqual(900);
    });

    it('throttle a number whose sends fail, and bring it back after an hour', async () => {
      const [failing] = await activeNumbers(1);
      failing!.fake.failSend = true;
      for (let attempt = 0; attempt < 9; attempt += 1) {
        expect(await request(reachable())).toBe('unavailable');
      }
      expect(await statusOf(failing!.id)).toBe('active');
      expect(await request(reachable())).toBe('unavailable');
      expect(await statusOf(failing!.id)).toBe('throttled');
      failing!.fake.failSend = false;
      expect(await request(reachable())).toBe('unavailable');
      expect(failing!.fake.sent).toHaveLength(0);

      await sender.supervise(new Date(Date.now() + (THROTTLE_MINUTES - 1) * 60_000));
      expect(await statusOf(failing!.id)).toBe('throttled');
      await sender.supervise(new Date(Date.now() + (THROTTLE_MINUTES + 1) * 60_000));
      expect(await statusOf(failing!.id)).toBe('active');
      expect(await request(reachable())).toBe('sent');
    });

    it('mark a number WhatsApp refuses banned, and send from the others', async () => {
      const [banned, other] = await activeNumbers(2);
      banned!.fake.events?.closed('banned');
      await until(() => !sender.connectedNumbers().includes(banned!.id));
      await pause(100);
      expect(await statusOf(banned!.id)).toBe('banned');
      expect(await request(reachable())).toBe('sent');
      expect(other!.fake.sent).toHaveLength(1);
    });

    it('end the warm-up after its last step', async () => {
      const { id } = await pair(newPhone(), new Date(Date.now() - 16 * 24 * 60 * 60 * 1000));
      await connected(id);
      expect(await statusOf(id)).toBe('active');
      const { rows } = await sql.query<{ warmup_started_at: Date | null }>(
        'SELECT warmup_started_at FROM identity.otp_sender_numbers WHERE id = $1',
        [id],
      );
      expect(rows[0]?.warmup_started_at).toBeNull();
    });

    it('count the delivery and read receipts once', async () => {
      const [only] = await activeNumbers(1);
      expect(await request(reachable())).toBe('sent');
      const messageId = only!.fake.sent.at(-1)!.id;
      only!.fake.events?.receipt(messageId, 'delivered');
      only!.fake.events?.receipt(messageId, 'delivered');
      await pause(100);
      only!.fake.events?.receipt(messageId, 'read');
      only!.fake.events?.receipt(messageId, 'read');
      only!.fake.events?.receipt('unknown', 'read');
      await pause(100);
      expect(await countsOf(only!.id)).toEqual({ sent: 1, failed: 0, delivered: 1, read: 1 });
    });

    it('count a check that does not answer before the deadline as the number failing', async () => {
      const [hung] = await activeNumbers(1);
      hung!.fake.hang = true;
      const started = Date.now();
      expect(await request(newPhone(), '482913', new Date(), 3_500)).toBe('unavailable');
      expect(Date.now() - started).toBeLessThan(1_500);
      expect(await countsOf(hung!.id)).toMatchObject({ sent: 0, failed: 1 });
    });

    it('report each stopped number to Sentry once, without its phone', async () => {
      const [banned, throttled] = await activeNumbers(2);
      alerts.mockClear();
      banned!.fake.events?.closed('banned');
      await until(() => alerts.mock.calls.length === 1);
      throttled!.fake.failSend = true;
      for (let attempt = 0; attempt < 10; attempt += 1) await request(reachable());
      expect(await statusOf(throttled!.id)).toBe('throttled');
      expect(alerts.mock.calls).toEqual([
        ['رقم إرسال الرموز متوقف: a sending number is banned', 'warning'],
        ['رقم إرسال الرموز متوقف: a sending number is throttled', 'warning'],
      ]);
      expect(JSON.stringify(alerts.mock.calls)).not.toContain(banned!.phone.slice(1));
    });

    it('report a number whose session does not open within a minute', async () => {
      const phone = newPhone();
      whatsapp.number(phone).neverOpen = true;
      const { id } = await pair(phone);
      alerts.mockClear();
      const now = Date.now();
      await sender.supervise(new Date(now));
      await sender.supervise(new Date(now + 30_000));
      expect(alerts).not.toHaveBeenCalledWith(expect.stringContaining('not connected'), 'warning');
      await sender.supervise(new Date(now + 61_000));
      await sender.supervise(new Date(now + 71_000));
      expect(alerts.mock.calls.filter(([message]) => message.includes('not connected'))).toEqual([
        ['رقم إرسال الرموز متوقف: a sending number is not connected', 'warning'],
      ]);
      expect(sender.connectedNumbers()).not.toContain(id);
    });

    it('close a disabled number', async () => {
      const [only] = await activeNumbers(1);
      const closes = only!.fake.closes;
      await sql.query('UPDATE identity.otp_sender_numbers SET disabled_at = now() WHERE id = $1', [
        only!.id,
      ]);
      await sender.supervise();
      expect(sender.connectedNumbers()).toEqual([]);
      expect(only!.fake.closes).toBe(closes + 1);
      expect(await valkey.get(connectedKey(only!.id))).toBeNull();
      expect(await request(reachable())).toBe('unavailable');
    });
  });

  describe('serving the API', () => {
    let app: NestFastifyApplication;
    const environment = process.env.FOX_DROP_ENVIRONMENT;

    beforeAll(async () => {
      await emptyPool();
      const { id } = await pair('+963900000002');
      await connected(id);
      process.env.FOX_DROP_ENVIRONMENT = 'staging';
      app = await createApiApp(ApiModule);
      await app.init();
      await app.getHttpAdapter().getInstance().ready();
    });

    afterAll(async () => {
      await app?.close();
      process.env.FOX_DROP_ENVIRONMENT = environment;
    });

    it('delivers a customer code over WhatsApp, or tells the app the number has none', async () => {
      const phone = reachable();
      const fake = whatsapp.number('+963900000002');
      const sent = await app.inject({
        method: 'POST',
        url: '/v1/customer/auth/code',
        payload: { phone, deviceId: randomUUID() },
      });
      expect(sent.statusCode).toBe(200);
      expect(fake.sent.at(-1)?.phone).toBe(phone);
      expect(fake.sent.at(-1)?.text).toMatch(/^رمز الدخول إلى FOX DROP: \d{6}\n/);

      const none = await app.inject({
        method: 'POST',
        url: '/v1/customer/auth/code',
        payload: { phone: newPhone(), deviceId: randomUUID() },
      });
      expect(none.statusCode).toBe(400);
      expect(none.json()).toMatchObject({ error: 'not_on_whatsapp' });
    });

    describe('«أرقام إرسال الرموز» (§8.3.3 items 13–14, AP §9.14)', () => {
      let owner: { cookies: Record<string, string>; accountId: string };
      const url = '/v1/admin/otp-sender-numbers';
      const call = (method: 'GET' | 'PUT' | 'POST', path = '', payload: object = {}) =>
        app.inject({
          method,
          url: `${url}${path}`,
          cookies: owner.cookies,
          ...(method === 'GET' ? {} : { payload }),
        });

      beforeAll(async () => {
        const { rows } = await sql.query<{ id: string }>(
          `INSERT INTO identity.admin_accounts (name, email, status, password_hash, totp_secret_encrypted)
           VALUES ('Pool owner', 'pool-owner@example.test', 'active', 'not used', 'not used') RETURNING id`,
        );
        const accountId = rows[0]!.id;
        await sql.query(
          "INSERT INTO identity.admin_account_roles (account_id, role_code) VALUES ($1, 'OWN')",
          [accountId],
        );
        const { token } = await app
          .get(AdminSessionsService)
          .start(db.db, accountId, { ipAddress: null, device: null }, new Date());
        owner = { accountId, cookies: { [ADMIN_SESSION_COOKIE]: token } };
      });

      beforeEach(async () => {
        await emptyPool();
      });

      it('lists each number with its state, warm-up and counts of the day', async () => {
        const warmingPhone = newPhone();
        const { id: warmingId } = await pair(warmingPhone);
        const { id: activeId } = await pair(newPhone());
        await activate(activeId);
        await connected(warmingId, activeId);
        expect(await request(reachable())).toBe('sent');
        const listed = await call('GET');
        expect(listed.statusCode).toBe(200);
        const body = listed.json<{
          numbers: { id: string; phone: string; status: string }[];
          alerts: unknown[];
        }>();
        expect(body.alerts).toEqual([]);
        expect(body.numbers).toEqual([
          expect.objectContaining({
            id: warmingId,
            phone: warmingPhone,
            status: 'warming',
            connected: true,
            warmup: expect.objectContaining({ step: 1, cap: 50 }),
            dailyCap: 50,
            today: { sent: 0, failed: 0, delivered: 0, read: 0 },
          }),
          expect.objectContaining({
            id: activeId,
            status: 'active',
            warmup: null,
            dailyCap: 1500,
            today: { sent: 1, failed: 0, delivered: 0, read: 0 },
          }),
        ]);
      });

      it('sets a number standby or active, with an audit event', async () => {
        const { id } = await pair(newPhone());
        await connected(id);
        const standby = await call('PUT', `/${id}/status`, { status: 'standby' });
        expect(standby.statusCode).toBe(200);
        expect(standby.json()).toMatchObject({
          numbers: [{ id, status: 'standby' }],
          alerts: [{ type: 'cannot_send', severity: 'critical', numberIds: [] }],
        });
        expect(await request(reachable())).toBe('unavailable');

        const active = await call('PUT', `/${id}/status`, { status: 'active' });
        expect(active.json()).toMatchObject({ numbers: [{ id, status: 'active', warmup: null }] });
        expect(await request(reachable())).toBe('sent');
        const { rows } = await sql.query<{ action: string; actor_id: string; changes: unknown }>(
          'SELECT action, actor_id, changes FROM audit.events WHERE target_id = $1 ORDER BY occurred_at, id',
          [id],
        );
        expect(rows).toEqual([
          expect.objectContaining({
            action: 'otp_sender_number.status_change',
            actor_id: owner.accountId,
          }),
          expect.objectContaining({ action: 'otp_sender_number.status_change' }),
        ]);
      });

      it('shows a stopped number in its alert, and needs a pairing to bring it back', async () => {
        const phone = newPhone();
        const { id } = await pair(phone);
        await connected(id);
        whatsapp.number(phone).events?.closed('banned');
        await until(() => !sender.connectedNumbers().includes(id));
        await pause(100);
        const listed = await call('GET');
        expect(listed.json()).toMatchObject({
          numbers: [{ id, status: 'banned', connected: false }],
          alerts: [
            { type: 'number_stopped', severity: 'warning', numberIds: [id] },
            { type: 'cannot_send', severity: 'critical', numberIds: [] },
          ],
        });
        const refused = await call('PUT', `/${id}/status`, { status: 'active' });
        expect(refused.statusCode).toBe(409);
        expect(refused.json()).toMatchObject({ error: 'needs_pairing' });
      });

      it('disables a number, which the otp-sender closes', async () => {
        const phone = newPhone();
        const { id } = await pair(phone);
        await connected(id);
        const disabled = await call('POST', `/${id}/disable`);
        expect(disabled.statusCode).toBe(200);
        expect(disabled.json()).toMatchObject({ numbers: [] });
        await sender.supervise();
        expect(sender.connectedNumbers()).toEqual([]);
        expect((await call('POST', `/${id}/disable`)).statusCode).toBe(404);
        expect(
          (await call('PUT', `/${randomUUID()}/status`, { status: 'active' })).statusCode,
        ).toBe(404);
      });
    });
  });
});

describe('pairing a number again', () => {
  it('disables its earlier rows and resumes its warm-up, or its active state', async () => {
    const phone = '+963900000003';
    const first = await pair(phone, new Date(Date.now() - 4 * 24 * 60 * 60 * 1000));
    const second = await pair(phone);
    const { rows } = await sql.query<{
      id: string;
      status: string;
      disabled: boolean;
      warmup_started_at: Date | null;
    }>(
      'SELECT id, status, disabled_at IS NOT NULL AS disabled, warmup_started_at FROM identity.otp_sender_numbers WHERE phone_hash = $1 ORDER BY paired_at',
      [secrets.phoneHash(phone)],
    );
    expect(rows.map(({ id, status, disabled }) => ({ id, status, disabled }))).toEqual([
      { id: first.id, status: 'warming', disabled: true },
      { id: second.id, status: 'warming', disabled: false },
    ]);
    expect(rows[1]?.warmup_started_at).toEqual(rows[0]?.warmup_started_at);

    await sql.query(
      "UPDATE identity.otp_sender_numbers SET status = 'disconnected', disconnected_at = now(), warmup_started_at = NULL WHERE id = $1",
      [second.id],
    );
    expect((await pair(phone)).status).toBe('active');
  });

  it('keeps the counts of the day with the phone', async () => {
    const phone = newPhone();
    const first = await pair(phone);
    await sql.query(
      'INSERT INTO identity.otp_sender_daily_counts (number_id, day, sent, failed) VALUES ($1, $2, 40, 2)',
      [first.id, senderDay(new Date())],
    );
    const second = await pair(phone);
    expect(await countsOf(second.id)).toEqual({ sent: 40, failed: 2, delivered: 0, read: 0 });
  });
});
