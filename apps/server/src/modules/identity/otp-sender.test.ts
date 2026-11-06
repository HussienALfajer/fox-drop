import 'reflect-metadata';
import { randomBytes, randomInt, randomUUID } from 'node:crypto';
import type { NestFastifyApplication } from '@nestjs/platform-fastify';
import { Test, type TestingModule } from '@nestjs/testing';
import { Valkey } from 'iovalkey';
import pg from 'pg';
import { afterAll, beforeAll, beforeEach, describe, expect, it } from 'vitest';
import { ApiModule } from '../../api.module.js';
import { createDatabase, type Database } from '../../database/database.js';
import { startTestDatabase, type TestDatabase } from '../../database/test-database.js';
import { createApiApp } from '../../http/create-api-app.js';
import { startTestValkey, type TestValkey } from '../../valkey/test-valkey.js';
import {
  encodeSendRequest,
  QueuedCodeSender,
  SEND_ANSWER_TIMEOUT_MS,
  SEND_REQUESTS_KEY,
} from './code-send-queue.js';
import { codeMessage, replyMessage } from './otp-messages.js';
import { OtpSenderNumbers } from './otp-sender-numbers.js';
import { OtpSenderModule } from './otp-sender.module.js';
import { ON_WHATSAPP_CACHE_DAYS, OtpSenderService } from './otp-sender.service.js';
import { IdentitySecrets } from './secrets.js';
import {
  WHATSAPP_CONNECT,
  type WhatsAppConnect,
  type WhatsAppEvents,
  type WhatsAppSessionStore,
} from './whatsapp-client.js';

// The WhatsApp sender of architecture §8.3.1 and §8.3.3 items 3, 8–10: the
// otp-sender process with a fake WhatsApp library, the API's code requests
// through Valkey, and the session stored encrypted in PostgreSQL.
class FakeWhatsApp {
  readonly onWhatsApp = new Set<string>();
  readonly sent: { phone: string; text: string }[] = [];
  readonly replies: { chat: string; text: string }[] = [];
  checks = 0;
  connects = 0;
  closes = 0;
  failSend = false;
  events: WhatsAppEvents | undefined;
  session: WhatsAppSessionStore | undefined;

  connect: WhatsAppConnect = async (session, events) => {
    this.connects += 1;
    this.session = session;
    this.events = events;
    await session.write({ creds: JSON.stringify({ restored: await session.read('creds') }) });
    setImmediate(() => events.open('+963900000001'));
    return {
      isOnWhatsApp: (phone) => {
        this.checks += 1;
        return Promise.resolve(this.onWhatsApp.has(phone));
      },
      sendText: (phone, text) => {
        if (this.failSend) return Promise.reject(new Error('socket closed'));
        this.sent.push({ phone, text });
        return Promise.resolve();
      },
      reply: (chat, text) => {
        this.replies.push({ chat, text });
        return Promise.resolve();
      },
      close: () => {
        this.closes += 1;
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

function newPhone(): string {
  return `+9639${randomInt(100_000_000).toString().padStart(8, '0')}`;
}

const pause = (ms: number) => new Promise((resolve) => setTimeout(resolve, ms));

async function until(check: () => boolean): Promise<void> {
  for (let attempt = 0; attempt < 100 && !check(); attempt += 1) await pause(20);
  expect(check()).toBe(true);
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

  it('waits ten seconds by default', () => {
    expect(SEND_ANSWER_TIMEOUT_MS).toBe(10_000);
  });
});

describe('the otp-sender', () => {
  let whatsapp: FakeWhatsApp;
  let senderModule: TestingModule;
  let sender: OtpSenderService;
  let queued: QueuedCodeSender;

  beforeAll(async () => {
    whatsapp = new FakeWhatsApp();
    senderModule = await Test.createTestingModule({ imports: [OtpSenderModule] })
      .overrideProvider(WHATSAPP_CONNECT)
      .useValue(whatsapp.connect)
      .compile();
    await senderModule.init();
    sender = senderModule.get(OtpSenderService);
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
    expect(whatsapp.connects).toBe(0);
  });

  describe('with a paired number', () => {
    let numberId: string;

    beforeAll(async () => {
      const paired = await numbers.savePaired(
        '+963900000001',
        new Map([['creds', '{"paired":true}']]),
        new Date(),
      );
      numberId = paired.id;
      await sender.supervise();
      await until(() => sender.connected);
    });

    beforeEach(() => {
      whatsapp.failSend = false;
    });

    it('restores the stored session and keeps it encrypted', async () => {
      expect(whatsapp.connects).toBe(1);
      expect(await whatsapp.session?.read('creds')).toBe('{"restored":"{\\"paired\\":true}"}');
      const { rows } = await sql.query<{ key: string; value_encrypted: string }>(
        'SELECT key, value_encrypted FROM identity.otp_sender_credentials WHERE number_id = $1',
        [numberId],
      );
      expect(rows.map((row) => row.key)).toEqual(['creds']);
      expect(rows[0]?.value_encrypted).not.toContain('restored');
      const { rows: stored } = await sql.query<{ phone_encrypted: string; phone_hash: string }>(
        'SELECT phone_encrypted, phone_hash FROM identity.otp_sender_numbers',
      );
      expect(JSON.stringify(stored)).not.toContain('963900000001');
    });

    it('sends the fixed message to a number on WhatsApp, checked once in 30 days', async () => {
      const phone = newPhone();
      whatsapp.onWhatsApp.add(phone);
      const checks = whatsapp.checks;
      expect(await queued.send(phone, '482913')).toBe('sent');
      expect(whatsapp.sent.at(-1)).toEqual({ phone, text: codeMessage('482913') });
      expect(codeMessage('482913')).toBe(
        'رمز الدخول إلى FOX DROP: 482913\nلا تشارك هذا الرمز مع أحد. إن لم تطلبه فتجاهل هذه الرسالة.',
      );
      expect(await queued.send(phone, '123456')).toBe('sent');
      expect(whatsapp.checks).toBe(checks + 1);

      const later = new Date(Date.now() + (ON_WHATSAPP_CACHE_DAYS + 1) * 24 * 60 * 60 * 1000);
      const request = encodeSendRequest(secrets, phone, '654321', later.getTime() + 1000);
      expect(await sender.answer(request, later)).toBe('sent');
      expect(whatsapp.checks).toBe(checks + 2);
    });

    it('sends nothing to a number without WhatsApp, and checks it again next time', async () => {
      const phone = newPhone();
      const sent = whatsapp.sent.length;
      expect(await queued.send(phone, '482913')).toBe('not_on_whatsapp');
      expect(await queued.send(phone, '482913')).toBe('not_on_whatsapp');
      expect(whatsapp.sent).toHaveLength(sent);
      const { rows } = await sql.query(
        'SELECT 1 FROM identity.otp_whatsapp_numbers WHERE phone_hash = $1',
        [secrets.phoneHash(phone)],
      );
      expect(rows).toHaveLength(0);
    });

    it('drops a request past its deadline unsent', async () => {
      const phone = newPhone();
      whatsapp.onWhatsApp.add(phone);
      const sent = whatsapp.sent.length;
      const request = encodeSendRequest(secrets, phone, '482913', Date.now() - 1);
      expect(await sender.answer(request)).toBeNull();
      expect(whatsapp.sent).toHaveLength(sent);
    });

    it('answers unavailable when the library fails to send', async () => {
      const phone = newPhone();
      whatsapp.onWhatsApp.add(phone);
      whatsapp.failSend = true;
      expect(await queued.send(phone, '482913')).toBe('unavailable');
    });

    it('replies once to someone who writes to the number', async () => {
      const chat = `${randomUUID()}@lid`;
      whatsapp.events?.incoming(chat);
      whatsapp.events?.incoming(chat);
      await until(() => whatsapp.replies.some((reply) => reply.chat === chat));
      await pause(100);
      expect(whatsapp.replies.filter((reply) => reply.chat === chat)).toEqual([
        { chat, text: replyMessage('+963911000000') },
      ]);
    });

    it('reconnects from the stored session after a lost connection', async () => {
      const connects = whatsapp.connects;
      whatsapp.events?.closed('lost');
      expect(sender.connected).toBe(false);
      await sender.supervise();
      await until(() => sender.connected);
      expect(whatsapp.connects).toBe(connects + 1);
    });

    it('marks a logged-out number disconnected and sends nothing more', async () => {
      whatsapp.events?.closed('logged_out');
      await until(() => !sender.connected);
      await pause(100);
      const { rows } = await sql.query<{ status: string }>(
        'SELECT status FROM identity.otp_sender_numbers WHERE id = $1',
        [numberId],
      );
      expect(rows[0]?.status).toBe('disconnected');
      const connects = whatsapp.connects;
      await sender.supervise();
      expect(whatsapp.connects).toBe(connects);
      expect(await queued.send(newPhone(), '482913')).toBe('unavailable');
    });
  });

  describe('serving the API', () => {
    let app: NestFastifyApplication;
    const environment = process.env.FOX_DROP_ENVIRONMENT;

    beforeAll(async () => {
      await numbers.savePaired('+963900000002', new Map(), new Date());
      await sender.supervise();
      await until(() => sender.connected);
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
      const phone = newPhone();
      whatsapp.onWhatsApp.add(phone);
      const sent = await app.inject({
        method: 'POST',
        url: '/v1/customer/auth/code',
        payload: { phone, deviceId: randomUUID() },
      });
      expect(sent.statusCode).toBe(200);
      expect(whatsapp.sent.at(-1)?.phone).toBe(phone);
      expect(whatsapp.sent.at(-1)?.text).toMatch(/^رمز الدخول إلى FOX DROP: \d{6}\n/);

      const none = await app.inject({
        method: 'POST',
        url: '/v1/customer/auth/code',
        payload: { phone: newPhone(), deviceId: randomUUID() },
      });
      expect(none.statusCode).toBe(400);
      expect(none.json()).toMatchObject({ error: 'not_on_whatsapp' });
    });
  });
});
