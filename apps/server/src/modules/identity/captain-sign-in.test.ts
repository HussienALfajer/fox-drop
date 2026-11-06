import 'reflect-metadata';
import { randomBytes, randomInt, randomUUID } from 'node:crypto';
import type { NestFastifyApplication } from '@nestjs/platform-fastify';
import pg from 'pg';
import { afterAll, beforeAll, beforeEach, describe, expect, it } from 'vitest';
import { Valkey } from 'iovalkey';
import { ApiModule } from '../../api.module.js';
import { startTestDatabase, type TestDatabase } from '../../database/test-database.js';
import { createApiApp } from '../../http/create-api-app.js';
import { startTestValkey, type TestValkey } from '../../valkey/test-valkey.js';
import { CaptainsService } from '../captains/index.js';
import { FxService } from '../fx/index.js';
import { CaptainAccountRefusedError, CaptainAccountsService } from './captain-accounts.service.js';
import { CODE_SENDER, type DevelopmentCodeSender } from './code-sender.js';

// The captain app's sign-in (CA §4.9) on the app sign-in engine, served by the
// API app as in production, on a fresh database and Valkey.
let database: TestDatabase;
let cache: TestValkey;
let app: NestFastifyApplication;
let sql: pg.Pool;
let valkey: Valkey;
let captains: CaptainsService;
let accounts: CaptainAccountsService;
let sender: DevelopmentCodeSender;
let azaz: string;

const system = { type: 'system', id: null, role: null } as const;
const noRequest = { ipAddress: null, device: null };
const change = { actor: system, context: noRequest, reason: 'test' };

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
  captains = app.get(CaptainsService);
  accounts = app.get(CaptainAccountsService);
  sender = app.get(CODE_SENDER);
  azaz = (await sql.query("SELECT id FROM geo.cities WHERE code = 'AZ'")).rows[0].id;
  const fx = app.get(FxService);
  await fx.setCityCurrency(azaz, { currency: 'TRY', displayOrder: 1, enabled: true }, change);
  await fx.setBaseCurrency(azaz, 'TRY', change);
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

function newPhone(): string {
  return `+9639${randomInt(100_000_000).toString().padStart(8, '0')}`;
}

// An activated captain with a sign-in number.
async function captain() {
  const captainId = await captains.createCaptain(
    azaz,
    {
      name: 'كابتن اختبار',
      vehicle: 'walking',
      custodyLimit: { amount: 300_000n, currency: 'TRY' },
    },
    change,
  );
  const phone = newPhone();
  const accountId = await accounts.addAccount(captainId, phone, change);
  return { captainId, phone, accountId };
}

function requestCode(phone: string, deviceId: string) {
  return app.inject({
    method: 'POST',
    url: '/v1/captain/auth/code',
    payload: { phone, deviceId },
  });
}

async function signIn(phone: string, deviceId = randomUUID()) {
  const code = await requestCode(phone, deviceId);
  expect(code.statusCode).toBe(200);
  return app.inject({
    method: 'POST',
    url: '/v1/captain/auth/sign-in',
    payload: { phone, deviceId, code: sender.lastCode(phone) },
  });
}

function session(accessToken: string) {
  return app.inject({
    method: 'GET',
    url: '/v1/captain/auth/session',
    headers: { authorization: `Bearer ${accessToken}` },
  });
}

describe('captain accounts (CA §4.9)', () => {
  it('keeps one number per captain and one captain per number, without the phone in the audit', async () => {
    const { captainId, phone, accountId } = await captain();
    const other = await captains.createCaptain(
      azaz,
      { name: 'آخر', vehicle: 'walking', custodyLimit: { amount: 1_000n, currency: 'TRY' } },
      change,
    );
    await expect(accounts.addAccount(other, phone, change)).rejects.toMatchObject({
      refusal: 'phone_taken',
    });
    await expect(accounts.addAccount(captainId, newPhone(), change)).rejects.toMatchObject({
      refusal: 'account_exists',
    });
    await expect(accounts.addAccount(randomUUID(), newPhone(), change)).rejects.toBeInstanceOf(
      CaptainAccountRefusedError,
    );
    await expect(accounts.addAccount(other, '+4915112345678', change)).rejects.toMatchObject({
      refusal: 'invalid_account',
    });
    const { rows } = await sql.query(
      "SELECT changes::text AS changes FROM audit.events WHERE action = 'captain_account.create' AND target_id = $1",
      [accountId],
    );
    expect(rows[0].changes).not.toContain(phone.slice(1));
    const stored = await sql.query('SELECT * FROM identity.captain_accounts WHERE id = $1', [
      accountId,
    ]);
    expect(JSON.stringify(stored.rows[0])).not.toContain(phone.slice(1));
  });
});

describe('the captain app sign-in (CA §4.9)', () => {
  it('signs a captain in and answers the session', async () => {
    const { captainId, phone, accountId } = await captain();
    const answer = await signIn(phone);
    expect(answer.statusCode).toBe(200);
    expect(answer.json()).toMatchObject({ accountId, captainId, accessToken: expect.any(String) });
    const current = await session(answer.json().accessToken);
    expect(current.json()).toMatchObject({ accountId, captainId });
  });

  it('answers a number of no captain as any other, and sends it nothing (owner decision 2026-11-06)', async () => {
    const { phone: registered } = await captain();
    const unknown = newPhone();
    const deviceId = randomUUID();
    const answers = [await requestCode(registered, deviceId), await requestCode(unknown, deviceId)];
    expect(answers.map((answer) => answer.statusCode)).toEqual([200, 200]);
    expect(Object.keys(answers[1]!.json()).sort()).toEqual(Object.keys(answers[0]!.json()).sort());
    expect(sender.lastCode(registered)).toEqual(expect.any(String));
    expect(sender.lastCode(unknown)).toBeUndefined();
    // The resend wait holds alike, so a second request tells nothing either.
    const again = [await requestCode(registered, deviceId), await requestCode(unknown, deviceId)];
    expect(again.map((answer) => [answer.statusCode, answer.json().error])).toEqual([
      [429, 'resend_wait'],
      [429, 'resend_wait'],
    ]);
    // A guessed code is a wrong code.
    const guessed = await app.inject({
      method: 'POST',
      url: '/v1/captain/auth/sign-in',
      payload: { phone: unknown, deviceId, code: '123456' },
    });
    expect(guessed.statusCode).toBe(400);
    expect(guessed.json()).toMatchObject({ error: 'wrong_code' });
  });

  it('signs out the other device when the captain signs in on a new one (K5)', async () => {
    const { phone } = await captain();
    const first = (await signIn(phone)).json();
    // Past the resend wait of the first code.
    await sql.query(
      "UPDATE identity.app_sign_in_codes SET created_at = created_at - interval '2 minutes'",
    );
    const second = (await signIn(phone)).json();
    // The old device can tell why: «سُجّل دخولك من جهاز آخر».
    const old = await session(first.accessToken);
    expect(old.statusCode).toBe(401);
    expect(old.json()).toMatchObject({ error: 'other_device' });
    expect((await session(second.accessToken)).statusCode).toBe(200);
    const refreshed = await app.inject({
      method: 'POST',
      url: '/v1/captain/auth/refresh',
      payload: { refreshToken: first.refreshToken },
    });
    expect(refreshed.statusCode).toBe(401);
    expect(refreshed.json()).toMatchObject({ error: 'other_device' });
    const { rows } = await sql.query(
      "SELECT end_reason FROM identity.app_sessions WHERE party = 'captain' AND account_id = $1 AND ended_at IS NOT NULL",
      [first.accountId],
    );
    expect(rows).toEqual([{ end_reason: 'other_device' }]);
  });

  it('lets a suspended captain in, and ends a terminated one at once', async () => {
    const { captainId, phone } = await captain();
    await captains.setStatus(captainId, 'suspended', change, new Date());
    const signedIn = await signIn(phone);
    expect(signedIn.statusCode).toBe(200);
    const { accessToken, refreshToken } = signedIn.json();

    await captains.setStatus(captainId, 'terminated', change, new Date());
    expect((await session(accessToken)).statusCode).toBe(401);
    const refreshed = await app.inject({
      method: 'POST',
      url: '/v1/captain/auth/refresh',
      payload: { refreshToken },
    });
    expect(refreshed.statusCode).toBe(401);
    expect((await session(accessToken)).json().error).toBeUndefined();
    // Past the resend wait: no code reaches a terminated captain.
    await sql.query(
      "UPDATE identity.app_sign_in_codes SET created_at = created_at - interval '2 minutes'",
    );
    const before = sender.lastCode(phone);
    const code = await requestCode(phone, randomUUID());
    expect(code.statusCode).toBe(200);
    expect(sender.lastCode(phone)).toBe(before);
  });

  it('refuses a captain token on the other apps, and theirs here', async () => {
    const { phone } = await captain();
    const { accessToken } = (await signIn(phone)).json();
    const elsewhere = await app.inject({
      method: 'GET',
      url: '/v1/merchant/auth/session',
      headers: { authorization: `Bearer ${accessToken}` },
    });
    expect(elsewhere.statusCode).toBe(401);
  });

  it('signs out', async () => {
    const { phone } = await captain();
    const { accessToken } = (await signIn(phone)).json();
    const out = await app.inject({
      method: 'POST',
      url: '/v1/captain/auth/sign-out',
      headers: { authorization: `Bearer ${accessToken}` },
    });
    expect(out.json()).toEqual({ status: 'signed_out' });
    expect((await session(accessToken)).statusCode).toBe(401);
  });
});
