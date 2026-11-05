import 'reflect-metadata';
import { randomBytes, randomInt, randomUUID } from 'node:crypto';
import type { NestFastifyApplication } from '@nestjs/platform-fastify';
import { decodeProtectedHeader } from 'jose';
import pg from 'pg';
import { afterAll, beforeAll, beforeEach, describe, expect, it, vi } from 'vitest';
import { Valkey } from 'iovalkey';
import { ApiModule } from '../../api.module.js';
import { startTestDatabase, type TestDatabase } from '../../database/test-database.js';
import { createApiApp } from '../../http/create-api-app.js';
import { startTestValkey, type TestValkey } from '../../valkey/test-valkey.js';
import { type SettingKey, SettingsService } from '../settings/index.js';
import { AppSessionsService, RefreshRefusedError } from './app-sessions.service.js';
import {
  AppSignInService,
  CodeRequestRefusedError,
  SignInCodeRefusedError,
} from './app-sign-in.service.js';
import { CODE_SENDER, type DevelopmentCodeSender } from './code-sender.js';
import { ACCESS_TOKEN_MINUTES, KEY_ROTATION_DAYS } from './app-signing-keys.js';

// App phone sign-in (architecture §8.3.1–8.3.2, §15.1) on a fresh database and
// Valkey, served by the API app as in production, as the application role.
let database: TestDatabase;
let cache: TestValkey;
let app: NestFastifyApplication;
let sql: pg.Pool;
let valkey: Valkey;
let signIn: AppSignInService;
let sessions: AppSessionsService;
let settings: SettingsService;
let sender: DevelopmentCodeSender;

const context = { ipAddress: '203.0.113.9', device: 'FOX DROP customer 1.0 (Android 15)' };
const MINUTE = 60_000;

beforeAll(async () => {
  [database, cache] = await Promise.all([startTestDatabase(), startTestValkey()]);
  process.env.DATABASE_URL = database.appUrl;
  process.env.VALKEY_URL = cache.url;
  process.env.IDENTITY_ENCRYPTION_KEY = randomBytes(32).toString('base64');
  process.env.FOX_DROP_ENVIRONMENT = 'development';
  sql = new pg.Pool({ connectionString: database.appUrl });
  valkey = new Valkey(cache.url);
  app = await createApiApp(ApiModule);
  await app.init();
  await app.getHttpAdapter().getInstance().ready();
  signIn = app.get(AppSignInService);
  sessions = app.get(AppSessionsService);
  settings = app.get(SettingsService);
  sender = app.get(CODE_SENDER);
}, 300_000);

afterAll(async () => {
  await app?.close();
  valkey?.disconnect();
  await sql?.end();
  await Promise.all([database?.stop(), cache?.stop()]);
});

beforeEach(async () => {
  await valkey.flushall();
});

// A Syrian mobile no other test uses.
function newPhone(): string {
  return `+9639${randomInt(100_000_000).toString().padStart(8, '0')}`;
}

async function changeSetting(key: SettingKey, value: number) {
  await settings.update(key, {}, value, {
    editor: { id: '0190f3a0-0000-7000-8000-000000000001', roles: ['OWN'] },
    context,
    reason: 'test',
  });
}

function request(phone: string, deviceId: string, now: Date, ipAddress = context.ipAddress) {
  return signIn.requestCode({ party: 'customer', phone, deviceId }, { ...context, ipAddress }, now);
}

async function refusal(promise: Promise<unknown>): Promise<unknown> {
  try {
    await promise;
  } catch (error) {
    if (error instanceof CodeRequestRefusedError) {
      return { refusal: error.refusal, retryAfterSec: error.retryAfterSec };
    }
    if (error instanceof SignInCodeRefusedError) {
      return { refusal: error.refusal, attemptsLeft: error.attemptsLeft };
    }
    if (error instanceof RefreshRefusedError) return { refusal: 'refresh' };
    throw error;
  }
  return 'accepted';
}

async function signedIn(phone = newPhone(), deviceId = randomUUID(), now = new Date()) {
  await request(phone, deviceId, now);
  const code = sender.lastCode(phone)!;
  return signIn.signIn({ party: 'customer', phone, deviceId, code }, context, now);
}

describe('the sign-in code (architecture §8.3.2)', () => {
  it('is 6 digits, stored only as a keyed hash with the number, device and expiry', async () => {
    const phone = newPhone();
    const deviceId = randomUUID();
    const now = new Date();
    const answer = await request(phone, deviceId, now);
    expect(answer).toEqual({
      channel: 'whatsapp',
      resendAfterSec: 60,
      expiresAt: new Date(now.getTime() + 5 * MINUTE),
    });
    const code = sender.lastCode(phone)!;
    expect(code).toMatch(/^\d{6}$/);
    const { rows } = await sql.query('SELECT * FROM identity.app_sign_in_codes');
    const stored = JSON.stringify(rows);
    expect(stored).not.toContain(code);
    expect(stored).not.toContain(phone);
    expect(stored).not.toContain(phone.slice(1));
    const row = rows.find((r) => r.device_id === deviceId)!;
    expect(row.expires_at).toEqual(new Date(now.getTime() + 5 * MINUTE));
  });

  it('signs in with the right code once, and never again with it', async () => {
    const phone = newPhone();
    const deviceId = randomUUID();
    const now = new Date();
    await request(phone, deviceId, now);
    const code = sender.lastCode(phone)!;
    const result = await signIn.signIn({ party: 'customer', phone, deviceId, code }, context, now);
    expect(result.newAccount).toBe(true);
    expect(result.accessToken).toBeTruthy();
    expect(result.refreshToken).toBeTruthy();
    expect(
      await refusal(signIn.signIn({ party: 'customer', phone, deviceId, code }, context, now)),
    ).toEqual({ refusal: 'code_expired', attemptsLeft: 0 });
  });

  it('signs an existing account in again, without a new account', async () => {
    const phone = newPhone();
    const first = await signedIn(phone, randomUUID(), new Date(Date.now() - 2 * MINUTE));
    const again = await signedIn(phone);
    expect(again.newAccount).toBe(false);
    expect(again.accountId).toBe(first.accountId);
  });

  it('refuses it after otp.validity_min', async () => {
    const phone = newPhone();
    const deviceId = randomUUID();
    const now = new Date();
    await request(phone, deviceId, now);
    const code = sender.lastCode(phone)!;
    const later = new Date(now.getTime() + 5 * MINUTE);
    expect(
      await refusal(signIn.signIn({ party: 'customer', phone, deviceId, code }, context, later)),
    ).toEqual({ refusal: 'code_expired', attemptsLeft: 0 });
  });

  it('refuses it from another device', async () => {
    const phone = newPhone();
    const now = new Date();
    await request(phone, randomUUID(), now);
    const code = sender.lastCode(phone)!;
    expect(
      await refusal(
        signIn.signIn({ party: 'customer', phone, deviceId: randomUUID(), code }, context, now),
      ),
    ).toEqual({ refusal: 'code_expired', attemptsLeft: 0 });
  });

  it('ends after otp.max_attempts wrong codes, the right one included after', async () => {
    const phone = newPhone();
    const deviceId = randomUUID();
    const now = new Date();
    await request(phone, deviceId, now);
    const code = sender.lastCode(phone)!;
    const wrong = code === '000000' ? '000001' : '000000';
    const answers = [];
    for (let attempt = 0; attempt < 5; attempt += 1) {
      answers.push(
        await refusal(
          signIn.signIn({ party: 'customer', phone, deviceId, code: wrong }, context, now),
        ),
      );
    }
    expect(answers).toEqual(
      [4, 3, 2, 1, 0].map((attemptsLeft) => ({ refusal: 'wrong_code', attemptsLeft })),
    );
    expect(
      await refusal(signIn.signIn({ party: 'customer', phone, deviceId, code }, context, now)),
    ).toEqual({ refusal: 'code_expired', attemptsLeft: 0 });
  });

  it('keeps one active code per number: a new request ends the old one', async () => {
    const phone = newPhone();
    const deviceId = randomUUID();
    const now = new Date();
    await request(phone, deviceId, now);
    const first = sender.lastCode(phone)!;
    const later = new Date(now.getTime() + MINUTE);
    await request(phone, deviceId, later);
    const second = sender.lastCode(phone)!;
    if (first !== second) {
      expect(
        await refusal(
          signIn.signIn({ party: 'customer', phone, deviceId, code: first }, context, later),
        ),
      ).toMatchObject({ refusal: 'wrong_code' });
    }
    const { rows } = await sql.query(
      'SELECT count(*)::int AS open FROM identity.app_sign_in_codes WHERE ended_at IS NULL AND device_id = $1',
      [deviceId],
    );
    expect(rows[0].open).toBe(1);
    expect(
      (await signIn.signIn({ party: 'customer', phone, deviceId, code: second }, context, later))
        .accessToken,
    ).toBeTruthy();
  });

  it('waits otp.resend_after_sec between two codes to one number', async () => {
    const phone = newPhone();
    const deviceId = randomUUID();
    const now = new Date();
    await request(phone, deviceId, now);
    expect(await refusal(request(phone, deviceId, new Date(now.getTime() + 20_000)))).toEqual({
      refusal: 'resend_wait',
      retryAfterSec: 40,
    });
    expect(await refusal(request(phone, deviceId, new Date(now.getTime() + 60_000)))).toBe(
      'accepted',
    );
  });

  it('reads the code settings at each request', async () => {
    await changeSetting('otp.validity_min', 2);
    await changeSetting('otp.max_attempts', 1);
    try {
      const phone = newPhone();
      const deviceId = randomUUID();
      const now = new Date();
      expect((await request(phone, deviceId, now)).expiresAt).toEqual(
        new Date(now.getTime() + 2 * MINUTE),
      );
      const code = sender.lastCode(phone)!;
      const wrong = code === '000000' ? '000001' : '000000';
      expect(
        await refusal(
          signIn.signIn({ party: 'customer', phone, deviceId, code: wrong }, context, now),
        ),
      ).toEqual({ refusal: 'wrong_code', attemptsLeft: 0 });
    } finally {
      await changeSetting('otp.validity_min', 5);
      await changeSetting('otp.max_attempts', 5);
    }
  });

  it('answers alike whether the number has an account or not', async () => {
    const known = newPhone();
    await signedIn(known, randomUUID(), new Date(Date.now() - 2 * MINUTE));
    const now = new Date();
    const forKnown = await request(known, randomUUID(), now);
    const forNew = await request(newPhone(), randomUUID(), now);
    expect(forKnown).toEqual(forNew);
  });
});

describe('the request limits (architecture §8.3.3 item 2, AP Appendix A)', () => {
  it('allows otp.number_hourly_max codes per number per hour', async () => {
    const phone = newPhone();
    const start = new Date();
    for (let i = 0; i < 3; i += 1) {
      await request(phone, randomUUID(), new Date(start.getTime() + i * 2 * MINUTE));
    }
    expect(
      await refusal(request(phone, randomUUID(), new Date(start.getTime() + 10 * MINUTE))),
    ).toEqual({ refusal: 'hourly_limit', retryAfterSec: 50 * 60 });
    expect(
      await refusal(request(phone, randomUUID(), new Date(start.getTime() + 60 * MINUTE))),
    ).toBe('accepted');
  });

  it('allows otp.number_daily_max codes per number per day', async () => {
    const phone = newPhone();
    const start = new Date();
    for (let i = 0; i < 6; i += 1) {
      await request(phone, randomUUID(), new Date(start.getTime() + i * 61 * MINUTE));
    }
    const day = new Date(start.getTime() + 7 * 61 * MINUTE);
    expect(await refusal(request(phone, randomUUID(), day))).toMatchObject({
      refusal: 'daily_limit',
    });
  });

  it('allows otp.device_daily_max codes per device per day', async () => {
    const deviceId = randomUUID();
    const now = new Date();
    for (let i = 0; i < 6; i += 1) await request(newPhone(), deviceId, now);
    expect(await refusal(request(newPhone(), deviceId, now))).toMatchObject({
      refusal: 'daily_limit',
    });
  });

  it('allows otp.ip_hourly_max requests per IP address per hour, refused ones included', async () => {
    await changeSetting('otp.ip_hourly_max', 3);
    try {
      const now = new Date();
      const phone = newPhone();
      await request(phone, randomUUID(), now, '198.51.100.4');
      await refusal(request(phone, randomUUID(), now, '198.51.100.4'));
      await request(newPhone(), randomUUID(), now, '198.51.100.4');
      expect(await refusal(request(newPhone(), randomUUID(), now, '198.51.100.4'))).toMatchObject({
        refusal: 'ip_limit',
      });
      expect(await refusal(request(newPhone(), randomUUID(), now, '198.51.100.5'))).toBe(
        'accepted',
      );
    } finally {
      await changeSetting('otp.ip_hourly_max', 30);
    }
  });
});

describe('the request limits under parallel requests', () => {
  it('let no more than otp.ip_hourly_max through at once', async () => {
    await changeSetting('otp.ip_hourly_max', 3);
    try {
      const now = new Date();
      const answers = await Promise.all(
        Array.from({ length: 8 }, () =>
          refusal(request(newPhone(), randomUUID(), now, '198.51.100.8')),
        ),
      );
      expect(answers.filter((answer) => answer === 'accepted')).toHaveLength(3);
    } finally {
      await changeSetting('otp.ip_hourly_max', 30);
    }
  });

  it('let no more than otp.device_daily_max through for one device at once', async () => {
    const deviceId = randomUUID();
    const now = new Date();
    const answers = await Promise.all(
      Array.from({ length: 10 }, () => refusal(request(newPhone(), deviceId, now))),
    );
    expect(answers.filter((answer) => answer === 'accepted')).toHaveLength(6);
  });

  it('count no code that was not sent, and keep the open one', async () => {
    const phone = newPhone();
    const deviceId = randomUUID();
    const start = new Date();
    await request(phone, deviceId, start);
    const first = sender.lastCode(phone)!;
    const send = vi.spyOn(sender, 'send');
    send.mockResolvedValueOnce('not_on_whatsapp');
    send.mockResolvedValueOnce('unavailable');
    expect(await refusal(request(phone, deviceId, new Date(start.getTime() + MINUTE)))).toEqual({
      refusal: 'not_on_whatsapp',
      retryAfterSec: undefined,
    });
    expect(await refusal(request(phone, deviceId, new Date(start.getTime() + 2 * MINUTE)))).toEqual(
      { refusal: 'unavailable', retryAfterSec: undefined },
    );
    send.mockRestore();
    // Two more codes fit in the hour: the two refused sends did not count.
    for (const minutes of [3, 4]) {
      expect(
        await refusal(request(phone, deviceId, new Date(start.getTime() + minutes * MINUTE))),
      ).toBe('accepted');
    }
    // The first code stayed open until the next one was sent.
    const { rows } = await sql.query(
      "SELECT count(*)::int AS replaced FROM identity.app_sign_in_codes WHERE device_id = $1 AND end_reason = 'replaced'",
      [deviceId],
    );
    expect(rows[0].replaced).toBe(2);
    expect(first).toMatch(/^\d{6}$/);
  });

  it('answer a refused send on the route', async () => {
    const send = vi.spyOn(sender, 'send');
    try {
      send.mockResolvedValueOnce('not_on_whatsapp');
      const notOnWhatsApp = await app.inject({
        method: 'POST',
        url: '/v1/customer/auth/code',
        payload: { phone: newPhone(), deviceId: randomUUID() },
      });
      expect(notOnWhatsApp.statusCode).toBe(400);
      expect(notOnWhatsApp.json()).toMatchObject({ error: 'not_on_whatsapp' });
      send.mockResolvedValueOnce('unavailable');
      const unavailable = await app.inject({
        method: 'POST',
        url: '/v1/customer/auth/code',
        payload: { phone: newPhone(), deviceId: randomUUID() },
      });
      expect(unavailable.statusCode).toBe(503);
      expect(unavailable.json()).toMatchObject({ error: 'unavailable' });
    } finally {
      send.mockRestore();
    }
  });
});

describe('the tokens (architecture §15.1)', () => {
  it('gives a 15-minute access token signed with the current key', async () => {
    const now = new Date();
    const result = await signedIn(newPhone(), randomUUID(), now);
    expect(result.accessTokenExpiresAt).toEqual(
      new Date(Math.floor(now.getTime() / 1000) * 1000 + ACCESS_TOKEN_MINUTES * MINUTE),
    );
    const session = await sessions.authenticate('customer', result.accessToken, now);
    expect(session).toMatchObject({ accountId: result.accountId });
    const expired = new Date(now.getTime() + ACCESS_TOKEN_MINUTES * MINUTE + 1000);
    expect(await sessions.authenticate('customer', result.accessToken, expired)).toBeNull();
    expect(await sessions.authenticate('customer', `${result.accessToken}x`, now)).toBeNull();
  });

  it('rotates the signing key every 30 days, and the old one verifies its tokens until they expire', async () => {
    await signedIn();
    const { rows: keys } = await sql.query(
      'SELECT max(created_at) AS created_at FROM identity.app_signing_keys',
    );
    const rotation = new Date(keys[0].created_at.getTime() + KEY_ROTATION_DAYS * 24 * 60 * MINUTE);
    const late = await signedIn(newPhone(), randomUUID(), new Date(rotation.getTime() - 1000));
    const after = await sessions.refresh(late.refreshToken, rotation);
    expect(decodeProtectedHeader(after.accessToken).kid).not.toBe(
      decodeProtectedHeader(late.accessToken).kid,
    );
    // The token the old key signed just before the rotation still verifies.
    expect(await sessions.authenticate('customer', late.accessToken, rotation)).not.toBeNull();
    expect(await sessions.authenticate('customer', after.accessToken, rotation)).not.toBeNull();
    const { rows } = await sql.query('SELECT private_key_encrypted FROM identity.app_signing_keys');
    expect(rows.length).toBeGreaterThanOrEqual(2);
    for (const row of rows) expect(row.private_key_encrypted).not.toContain('PRIVATE KEY');
  });

  it('rotates the refresh token on every use, and a reused one ends the session', async () => {
    const now = new Date();
    const first = await signedIn(newPhone(), randomUUID(), now);
    const second = await sessions.refresh(first.refreshToken, now);
    expect(second.refreshToken).not.toBe(first.refreshToken);
    const third = await sessions.refresh(second.refreshToken, now);
    expect(await refusal(sessions.refresh(first.refreshToken, now))).toEqual({
      refusal: 'refresh',
    });
    // The whole family is revoked, the newest token included.
    expect(await refusal(sessions.refresh(third.refreshToken, now))).toEqual({
      refusal: 'refresh',
    });
    const { rows } = await sql.query('SELECT token_hash FROM identity.app_refresh_tokens');
    const stored = JSON.stringify(rows);
    for (const token of [first, second, third]) expect(stored).not.toContain(token.refreshToken);
  });

  it('lets one of two concurrent refreshes with one token through, and ends the session', async () => {
    const now = new Date();
    const first = await signedIn(newPhone(), randomUUID(), now);
    const answers = await Promise.allSettled([
      sessions.refresh(first.refreshToken, now),
      sessions.refresh(first.refreshToken, now),
    ]);
    const passed = answers.filter((answer) => answer.status === 'fulfilled');
    expect(passed).toHaveLength(1);
    const tokens = (
      passed[0] as PromiseFulfilledResult<{ refreshToken: string; accessToken: string }>
    ).value;
    expect(await refusal(sessions.refresh(tokens.refreshToken, now))).toEqual({
      refusal: 'refresh',
    });
    expect(await sessions.authenticate('customer', tokens.accessToken, now)).toBeNull();
  });

  it('signs out one device, or every device of the account', async () => {
    const phone = newPhone();
    const now = new Date();
    const phoneA = await signedIn(phone, randomUUID(), new Date(now.getTime() - 4 * MINUTE));
    const phoneB = await signedIn(phone, randomUUID(), new Date(now.getTime() - 2 * MINUTE));
    const phoneC = await signedIn(phone, randomUUID(), now);
    const sessionA = (await sessions.authenticate('customer', phoneA.accessToken, now))!;
    await sessions.signOut(sessionA, now);
    expect(await refusal(sessions.refresh(phoneA.refreshToken, now))).toEqual({
      refusal: 'refresh',
    });
    const sessionB = (await sessions.authenticate('customer', phoneB.accessToken, now))!;
    expect(await sessions.authenticate('customer', phoneA.accessToken, now)).toBeNull();
    expect(await sessions.signOutEverywhere(sessionB, now)).toBe(2);
    for (const device of [phoneB, phoneC]) {
      expect(await refusal(sessions.refresh(device.refreshToken, now))).toEqual({
        refusal: 'refresh',
      });
      // At once, not when the access token expires (CU §5.4).
      expect(await sessions.authenticate('customer', device.accessToken, now)).toBeNull();
    }
  });

  it('ends the earlier session of a device that signs in again', async () => {
    const deviceId = randomUUID();
    const first = await signedIn(newPhone(), deviceId, new Date(Date.now() - 2 * MINUTE));
    await signedIn(newPhone(), deviceId);
    expect(await refusal(sessions.refresh(first.refreshToken, new Date()))).toEqual({
      refusal: 'refresh',
    });
  });
});

describe('the customer sign-in routes', () => {
  it('request a code, sign in, refresh, read the session and sign out everywhere', async () => {
    const phone = newPhone();
    const deviceId = randomUUID();
    const code = await app.inject({
      method: 'POST',
      url: '/v1/customer/auth/code',
      payload: { phone, deviceId },
    });
    expect(code.statusCode).toBe(200);
    expect(code.json()).toMatchObject({ channel: 'whatsapp', resendAfterSec: 60 });

    const wrong = await app.inject({
      method: 'POST',
      url: '/v1/customer/auth/sign-in',
      payload: { phone, deviceId, code: sender.lastCode(phone) === '000000' ? '000001' : '000000' },
    });
    expect(wrong.statusCode).toBe(400);
    expect(wrong.json()).toMatchObject({ error: 'wrong_code', attemptsLeft: 4 });

    const signInResponse = await app.inject({
      method: 'POST',
      url: '/v1/customer/auth/sign-in',
      payload: { phone, deviceId, code: sender.lastCode(phone) },
    });
    expect(signInResponse.statusCode).toBe(200);
    const tokens = signInResponse.json<{ accessToken: string; refreshToken: string }>();
    expect(signInResponse.json()).toMatchObject({ newAccount: true });

    const refreshed = await app.inject({
      method: 'POST',
      url: '/v1/customer/auth/refresh',
      payload: { refreshToken: tokens.refreshToken },
    });
    expect(refreshed.statusCode).toBe(200);
    const next = refreshed.json<{ accessToken: string; refreshToken: string }>();

    const session = await app.inject({
      method: 'GET',
      url: '/v1/customer/auth/session',
      headers: { authorization: `Bearer ${next.accessToken}` },
    });
    expect(session.statusCode).toBe(200);
    expect(session.json()).toMatchObject({ accountId: signInResponse.json().accountId });

    const everywhere = await app.inject({
      method: 'POST',
      url: '/v1/customer/auth/sign-out-everywhere',
      headers: { authorization: `Bearer ${next.accessToken}` },
    });
    expect(everywhere.statusCode).toBe(200);
    const ended = await app.inject({
      method: 'GET',
      url: '/v1/customer/auth/session',
      headers: { authorization: `Bearer ${next.accessToken}` },
    });
    expect(ended.statusCode).toBe(401);
    const after = await app.inject({
      method: 'POST',
      url: '/v1/customer/auth/refresh',
      payload: { refreshToken: next.refreshToken },
    });
    expect(after.statusCode).toBe(401);
  });

  it('refuses a missing or malformed token, and a number outside Syria and Turkey', async () => {
    const none = await app.inject({ method: 'GET', url: '/v1/customer/auth/session' });
    expect(none.statusCode).toBe(401);
    const junk = await app.inject({
      method: 'GET',
      url: '/v1/customer/auth/session',
      headers: { authorization: 'Bearer junk' },
    });
    expect(junk.statusCode).toBe(401);
    for (const phone of ['+4915112345678', '+963812345678', '0912345678', '+90412345678']) {
      const response = await app.inject({
        method: 'POST',
        url: '/v1/customer/auth/code',
        payload: { phone, deviceId: randomUUID() },
      });
      expect(response.statusCode).toBe(400);
    }
  });

  it('answers the daily limit with 429 and its refusal', async () => {
    const deviceId = randomUUID();
    for (let i = 0; i < 6; i += 1) await request(newPhone(), deviceId, new Date());
    const response = await app.inject({
      method: 'POST',
      url: '/v1/customer/auth/code',
      payload: { phone: newPhone(), deviceId },
    });
    expect(response.statusCode).toBe(429);
    expect(response.json()).toMatchObject({ error: 'daily_limit' });
    expect(Number(response.headers['retry-after'])).toBeGreaterThan(0);
  });
});
