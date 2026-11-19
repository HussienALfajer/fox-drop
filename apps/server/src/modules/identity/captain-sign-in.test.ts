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
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { AuditService } from '../audit/index.js';
import { AdminSessionsService } from './admin-sessions.service.js';
import { AppSessionsService } from './app-sessions.service.js';
import { changePlaceholderPhone } from './placeholder-phone.js';
import { ADMIN_SESSION_COOKIE } from './route-access.guard.js';
import { createOpenApiDocument } from '../../http/openapi.js';
import { IDENTITY_SECRETS, type IdentitySecrets } from './secrets.js';

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

  it('finds the captain a number belongs to, for the desk (AP §9.10.3)', async () => {
    const { captainId, phone } = await captain();
    expect(await accounts.captainByPhone(phone)).toBe(captainId);
    expect(await accounts.captainByPhone(newPhone())).toBeNull();
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

let admins = 0;
// A signed-in admin holding these roles, and their «تحرير الجهاز».
async function admin(roles: string[]) {
  admins += 1;
  const { rows } = await sql.query(
    `INSERT INTO identity.admin_accounts (name, email, status, password_hash, totp_secret_encrypted)
     VALUES ($1, $2, 'active', 'not used', 'not used') RETURNING id`,
    [`Operator ${admins}`, `device-operator${admins}@example.test`],
  );
  const accountId: string = rows[0].id;
  for (const role of roles) {
    await sql.query(
      'INSERT INTO identity.admin_account_roles (account_id, role_code) VALUES ($1, $2)',
      [accountId, role],
    );
  }
  const { token } = await app
    .get(AdminSessionsService)
    .start(
      app.get<Database>(DATABASE).db,
      accountId,
      { ipAddress: '203.0.113.9', device: 'test' },
      new Date(),
    );
  const cookies = { [ADMIN_SESSION_COOKIE]: token };
  return {
    accountId,
    device: (captainId: string) =>
      app.inject({ method: 'GET', url: `/v1/admin/captains/${captainId}/device`, cookies }),
    release: (captainId: string, payload: Record<string, unknown>) =>
      app.inject({
        method: 'POST',
        url: `/v1/admin/captains/${captainId}/release-device`,
        cookies,
        payload,
      }),
    issueCode: (phone: string) =>
      app.inject({
        method: 'POST',
        url: '/v1/admin/emergency-sign-in-codes',
        cookies,
        payload: { party: 'captain', phone, reason: 'ضاع هاتفه' },
      }),
  };
}

// Past the resend wait of the codes already sent, and the hourly limits.
async function pastResendWait() {
  await valkey.flushall();
  await sql.query(
    "UPDATE identity.app_sign_in_codes SET created_at = created_at - interval '2 minutes'",
  );
}

// CA §4.9 «During an active order», AP §9.7.5 «تحرير الجهاز» (slice 2.12c).
// Which captains have an active order is ordering's lookup (proved by its own
// tests); here a stand-in names them.
describe('joining (CA §5.1, slice 2.34a; owner decision 2026-11-19)', () => {
  function joinCode(phone: string, deviceId: string) {
    return app.inject({
      method: 'POST',
      url: '/v1/captain/auth/code',
      payload: { phone, deviceId, join: true },
    });
  }

  async function join(phone: string, deviceId = randomUUID()) {
    expect((await joinCode(phone, deviceId)).statusCode).toBe(200);
    return app.inject({
      method: 'POST',
      url: '/v1/captain/auth/sign-in',
      payload: { phone, deviceId, code: sender.lastCode(phone) },
    });
  }

  it('sends «انضم ككابتن» a code and makes an applicant who keeps the number', async () => {
    const phone = newPhone();
    const signedIn = await join(phone);
    expect(signedIn.statusCode).toBe(200);
    const body = signedIn.json();
    expect(body.captainId).toBeNull();
    const current = await session(body.accessToken);
    expect(current.statusCode).toBe(200);
    expect(current.json()).toMatchObject({ accountId: body.accountId, captainId: null });
    // The account is a captain_accounts row without a captain or a city.
    const { rows } = await sql.query(
      'SELECT captain_id, city_id FROM identity.captain_accounts WHERE id = $1',
      [body.accountId],
    );
    expect(rows).toEqual([{ captain_id: null, city_id: null }]);
    // «تسجيل الدخول» now sends the applicant a code and signs in the same
    // account.
    await sql.query(
      "UPDATE identity.app_sign_in_codes SET created_at = created_at - interval '2 minutes'",
    );
    const again = (await signIn(phone)).json();
    expect(again).toMatchObject({ accountId: body.accountId, captainId: null });
    // The refresh works as a captain's.
    const refreshed = await app.inject({
      method: 'POST',
      url: '/v1/captain/auth/refresh',
      payload: { refreshToken: again.refreshToken },
    });
    expect(refreshed.statusCode).toBe(200);
  });

  it('stores a code sent to no one as no code, so a guess never makes an applicant', async () => {
    const phone = newPhone();
    const deviceId = randomUUID();
    expect((await requestCode(phone, deviceId)).statusCode).toBe(200);
    const secrets = app.get<IdentitySecrets>(IDENTITY_SECRETS);
    const { rows } = await sql.query(
      'SELECT code_hash FROM identity.app_sign_in_codes WHERE phone_hash = $1 AND ended_at IS NULL',
      [secrets.phoneHash(phone)],
    );
    const stored: string = rows[0].code_hash;
    // No 6-digit code matches it.
    for (let code = 0; code < 1_000_000; code += 1) {
      if (secrets.signInCodeHash(phone, code.toString().padStart(6, '0')) === stored) {
        throw new Error('a code matches the silent code');
      }
    }
    const guessed = await app.inject({
      method: 'POST',
      url: '/v1/captain/auth/sign-in',
      payload: { phone, deviceId, code: '123456' },
    });
    expect(guessed.json()).toMatchObject({ error: 'wrong_code' });
    const accounts = await sql.query(
      'SELECT count(*)::int AS n FROM identity.captain_accounts WHERE phone_hash = $1',
      [secrets.phoneHash(phone)],
    );
    expect(accounts.rows).toEqual([{ n: 0 }]);
  }, 60_000);

  it('answers an applicant 403 applicant on every captain route but its own', async () => {
    const { accessToken } = (await join(newPhone())).json();
    const document = createOpenApiDocument(app);
    // The routes an applicant may call (CA §5.1–5.2): the session, the
    // terms, the application and its pushes (and the sign-out, left out here since it
    // ends the session; the next test calls it).
    const allowed = [
      'GET /v1/captain/auth/session',
      'POST /v1/captain/terms/accept',
      'GET /v1/captain/application',
      'GET /v1/captain/application/zones',
      'PUT /v1/captain/application/personal',
      'PUT /v1/captain/application/vehicle',
      'POST /v1/captain/application/documents/upload',
      'PUT /v1/captain/application/documents/{kind}',
      'POST /v1/captain/application/submit',
      // The stage pushes (CA §14 #29, slice 2.34b).
      'PUT /v1/captain/push-token',
    ];
    const reached: string[] = [];
    for (const [path, item] of Object.entries(document.paths)) {
      if (!path.startsWith('/v1/captain/')) continue;
      for (const method of ['get', 'put', 'post'] as const) {
        const operation = item[method];
        if (!operation || path === '/v1/captain/auth/sign-out') continue;
        const response = await app.inject({
          method: method.toUpperCase() as 'GET',
          url: path.replaceAll(/\{[^}]+\}/g, randomUUID()),
          headers: { authorization: `Bearer ${accessToken}` },
          ...(method === 'get' ? {} : { payload: {} }),
        });
        const refused = response.statusCode === 403 && response.json().error === 'applicant';
        if (!refused) reached.push(`${method.toUpperCase()} ${path}`);
      }
    }
    const open = reached.filter((route) => !allowed.includes(route));
    // The rest it reaches are the public and guest routes, which take no
    // session.
    for (const route of open) {
      const [method, path] = route.split(' ') as [string, string];
      const anonymous = await app.inject({
        method: method as 'GET',
        url: path.replaceAll(/\{[^}]+\}/g, randomUUID()),
        ...(method === 'GET' ? {} : { payload: {} }),
      });
      expect([route, anonymous.statusCode === 401]).toEqual([route, false]);
    }
    expect(allowed.filter((route) => !reached.includes(route))).toEqual([]);
  }, 120_000);

  it('keeps an applicant to the routes that take applicants', async () => {
    const { accessToken } = (await join(newPhone())).json();
    const availability = await app.inject({
      method: 'GET',
      url: '/v1/captain/availability',
      headers: { authorization: `Bearer ${accessToken}` },
    });
    expect(availability.statusCode).toBe(403);
    expect(availability.json()).toMatchObject({ error: 'applicant' });
    const terms = await app.inject({
      method: 'GET',
      url: '/v1/captain/terms',
      headers: { authorization: `Bearer ${accessToken}` },
    });
    expect(terms.statusCode).toBe(200);
    expect(terms.json()).toMatchObject({ pending: true });
    const out = await app.inject({
      method: 'POST',
      url: '/v1/captain/auth/sign-out',
      headers: { authorization: `Bearer ${accessToken}` },
    });
    expect(out.statusCode).toBe(200);
    expect((await session(accessToken)).statusCode).toBe(401);
  });

  it('sends a terminated captain nothing even to join, and never makes a second account', async () => {
    const { captainId, phone, accountId } = await captain();
    await captains.setStatus(captainId, 'terminated', change, new Date());
    const deviceId = randomUUID();
    expect((await joinCode(phone, deviceId)).statusCode).toBe(200);
    expect(sender.lastCode(phone)).toBeUndefined();
    const { rows } = await sql.query(
      'SELECT count(*)::int AS n FROM identity.captain_accounts WHERE id = $1 OR captain_id = $2',
      [accountId, captainId],
    );
    expect(rows).toEqual([{ n: 1 }]);
  });

  it('refuses an applicant the emergency code (W4)', async () => {
    const phone = newPhone();
    expect((await join(phone)).statusCode).toBe(200);
    const code = await (await admin(['OPS'])).issueCode(phone);
    expect(code.statusCode).toBe(409);
    expect(code.json()).toMatchObject({ error: 'not_registered' });
  });
});

describe('one device during an active order (CA §4.9, K5)', () => {
  const busy = new Set<string>();
  beforeAll(() => {
    captains.useActiveOrders((ids) => Promise.resolve(new Set(ids.filter((id) => busy.has(id)))));
  });

  it('refuses a second device while the captain has an active order, and uses the code up', async () => {
    const { captainId, phone } = await captain();
    const deviceId = randomUUID();
    const first = (await signIn(phone, deviceId)).json();
    busy.add(captainId);
    await pastResendWait();
    const refused = await signIn(phone);
    expect(refused.statusCode).toBe(403);
    expect(refused.json()).toMatchObject({ error: 'active_order_elsewhere' });
    // The first device keeps the order.
    expect((await session(first.accessToken)).statusCode).toBe(200);
    const { rows } = await sql.query(
      "SELECT end_reason FROM identity.app_sign_in_codes WHERE party = 'captain' AND ended_at IS NOT NULL ORDER BY created_at DESC LIMIT 1",
    );
    expect(rows).toEqual([{ end_reason: 'used' }]);
    // The same device signs in again; and with no order, a new one may.
    await pastResendWait();
    expect((await signIn(phone, deviceId)).statusCode).toBe(200);
    busy.delete(captainId);
    await pastResendWait();
    expect((await signIn(phone)).statusCode).toBe(200);
  });

  it('lets OWN and OPS release the device with a reason, audited, so a new phone signs in', async () => {
    const { captainId, phone, accountId } = await captain();
    const old = (await signIn(phone)).json();
    busy.add(captainId);
    // Owner decision 2026-11-11: the release keeps the captain online.
    await captains.goOnline(
      captainId,
      { appVersion: '1.0.0', simulatedLocation: false, termsPending: false },
      new Date(),
    );
    const ended: string[][] = [];
    app.get(AppSessionsService).onEnded((ids) => ended.push(ids));
    const ops = await admin(['OPS']);

    // An emergency code would be used up by the refusal: release first.
    const code = await ops.issueCode(phone);
    expect(code.statusCode).toBe(409);
    expect(code.json()).toMatchObject({ error: 'active_order_elsewhere' });

    const shown = (await ops.device(captainId)).json();
    expect(shown).toEqual({
      device: { sessionId: expect.any(String), signedInAt: expect.any(String) },
    });
    const { sessionId } = shown.device;
    expect((await ops.release(captainId, { sessionId, reason: ' ' })).statusCode).toBe(400);
    const released = await ops.release(captainId, { sessionId, reason: 'انكسر هاتفه' });
    expect(released.statusCode).toBe(200);
    expect(released.json()).toEqual({ status: 'released' });
    expect(ended).toEqual([[sessionId]]);
    expect((await ops.device(captainId)).json()).toEqual({ device: null });
    const { rows: online } = await sql.query(
      'SELECT ended_at FROM captains.online_periods WHERE captain_id = $1',
      [captainId],
    );
    expect(online).toEqual([{ ended_at: null }]);
    // The old device is signed out, not told of another device.
    const gone = await session(old.accessToken);
    expect(gone.statusCode).toBe(401);
    expect(gone.json().error).toBeUndefined();
    const { rows: reasons } = await sql.query(
      "SELECT end_reason FROM identity.app_sessions WHERE party = 'captain' AND account_id = $1",
      [accountId],
    );
    expect(reasons).toEqual([{ end_reason: 'device_released' }]);
    const { rows: audit } = await sql.query(
      `SELECT actor_id, actor_role, target_type, target_id, city_id, reason, changes::text AS changes
         FROM audit.events WHERE action = 'captain_account.release_device' AND target_id = $1`,
      [accountId],
    );
    expect(audit).toEqual([
      {
        actor_id: ops.accountId,
        actor_role: 'OPS',
        target_type: 'captain_account',
        target_id: accountId,
        city_id: azaz,
        reason: 'انكسر هاتفه',
        changes: expect.any(String),
      },
    ]);

    // The captain signs in on the new phone during the order; a second or
    // late release of the old device never signs the new one out.
    await pastResendWait();
    const fresh = await signIn(phone);
    expect(fresh.statusCode).toBe(200);
    const again = await ops.release(captainId, { sessionId, reason: 'مرة ثانية' });
    expect(again.statusCode).toBe(409);
    expect(again.json()).toMatchObject({ error: 'no_device' });
    expect((await session(fresh.json().accessToken)).statusCode).toBe(200);
    busy.delete(captainId);

    const owner = await admin(['OWN']);
    const current = (await owner.device(captainId)).json().device.sessionId;
    expect(current).not.toBe(sessionId);
    expect(
      (await owner.release(captainId, { sessionId: current, reason: 'هاتف جديد' })).statusCode,
    ).toBe(200);
    expect((await owner.device(randomUUID())).statusCode).toBe(404);
    expect(
      (await owner.release(randomUUID(), { sessionId: current, reason: 'x' })).statusCode,
    ).toBe(404);
    const support = await admin(['SUP']);
    expect((await support.device(captainId)).statusCode).toBe(403);
  });
});

// Slice 1.14: the placeholder accounts of development and staging take a real
// number by a server command (placeholder-phone-command.ts).
function changePhone(from: string, to: string, environment = 'staging') {
  return changePlaceholderPhone(
    {
      db: app.get<Database>(DATABASE).db,
      audit: app.get(AuditService),
      secrets: app.get<IdentitySecrets>(IDENTITY_SECRETS),
    },
    { party: 'captain', from, to },
    environment,
  );
}

describe('the placeholder phone command (slice 1.14)', () => {
  it('moves the captain to the new number, which signs in, and audits no number', async () => {
    const { phone, accountId } = await captain();
    const next = newPhone();
    expect(await changePhone(phone, next)).toEqual({ accountId });
    const signedIn = await signIn(next);
    expect(signedIn.statusCode).toBe(200);
    expect(signedIn.json().accountId).toBe(accountId);
    expect((await requestCode(phone, randomUUID())).statusCode).toBe(200);
    expect(sender.lastCode(phone)).toBeUndefined();
    const { rows } = await sql.query(
      "SELECT changes::text AS changes FROM audit.events WHERE action = 'captain_account.phone_change' AND target_id = $1",
      [accountId],
    );
    expect(rows).toHaveLength(1);
    expect(rows[0].changes).not.toContain(next.slice(1));
    expect(rows[0].changes).not.toContain(phone.slice(1));
  });

  it('refuses a taken number, an unknown one, a malformed one and production', async () => {
    const first = await captain();
    const second = await captain();
    await expect(changePhone(first.phone, second.phone)).rejects.toMatchObject({
      refusal: 'phone_taken',
    });
    await expect(changePhone(newPhone(), newPhone())).rejects.toMatchObject({
      refusal: 'not_found',
    });
    await expect(changePhone(first.phone, '0944000000')).rejects.toMatchObject({
      refusal: 'invalid_phone',
    });
    await expect(changePhone(first.phone, newPhone(), 'production')).rejects.toMatchObject({
      refusal: 'wrong_environment',
    });
  });
});
