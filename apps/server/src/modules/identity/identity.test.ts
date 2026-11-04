import 'reflect-metadata';
import { randomBytes } from 'node:crypto';
import type { NestFastifyApplication } from '@nestjs/platform-fastify';
import { Valkey } from 'iovalkey';
import { generate } from 'otplib';
import pg from 'pg';
import { afterAll, beforeAll, beforeEach, describe, expect, it } from 'vitest';
import { ApiModule } from '../../api.module.js';
import { createDatabase, type Database } from '../../database/database.js';
import { startTestDatabase, type TestDatabase } from '../../database/test-database.js';
import { createApiApp } from '../../http/create-api-app.js';
import { startTestValkey, type TestValkey } from '../../valkey/test-valkey.js';
import { AuditService } from '../audit/index.js';
import { type SettingKey, SettingsService } from '../settings/index.js';
import { ADMIN_SESSION_COOKIE } from './route-access.guard.js';
import { AdminSessionsService } from './admin-sessions.service.js';
import { AdminSetupService, SetupRefusedError } from './admin-setup.service.js';
import { AdminSignInService, SignInRefusedError } from './admin-sign-in.service.js';
import { createFirstOwner, FirstOwnerExistsError } from './first-owner.js';
import { OWNER_COMMAND_USAGE, parseOwnerArguments } from './owner-arguments.js';
import { adminAccountRoles, adminAccounts, adminSetupLinks } from './schema.js';
import { IdentitySecrets, newToken, tokenHash } from './secrets.js';
import { setupLinkUrl } from './setup-link-url.js';
import type { SignInName } from './sign-in-name.js';

// The identity module on a fresh database and Valkey, served by the API app as
// in production, connected as the application role.
let database: TestDatabase;
let cache: TestValkey;
let app: NestFastifyApplication;
let sql: pg.Pool;
let valkey: Valkey;
let db: Database;
let setup: AdminSetupService;
let signIn: AdminSignInService;
let sessions: AdminSessionsService;
let settings: SettingsService;
let audit: AuditService;

const key = randomBytes(32);
const secrets = new IdentitySecrets(key);
const context = { ipAddress: '203.0.113.7', device: 'Firefox 140 on Windows' };
const password = 'correct horse battery';

beforeAll(async () => {
  [database, cache] = await Promise.all([startTestDatabase(), startTestValkey()]);
  process.env.DATABASE_URL = database.appUrl;
  process.env.VALKEY_URL = cache.url;
  process.env.IDENTITY_ENCRYPTION_KEY = key.toString('base64');
  sql = new pg.Pool({ connectionString: database.appUrl });
  valkey = new Valkey(cache.url);
  db = createDatabase(database.appUrl);
  app = await createApiApp(ApiModule);
  await app.init();
  await app.getHttpAdapter().getInstance().ready();
  setup = app.get(AdminSetupService);
  signIn = app.get(AdminSignInService);
  sessions = app.get(AdminSessionsService);
  settings = app.get(SettingsService);
  audit = app.get(AuditService);
}, 300_000);

afterAll(async () => {
  await app?.close();
  valkey?.disconnect();
  await db?.pool.end();
  await sql?.end();
  await Promise.all([database?.stop(), cache?.stop()]);
});

beforeEach(async () => {
  await valkey.flushall();
});

async function changeSetting(key: SettingKey, value: number) {
  await settings.update(key, {}, value, {
    editor: { id: '0190f3a0-0000-7000-8000-000000000001', roles: ['OWN'] },
    context,
    reason: 'test',
  });
}

async function resetSetting(key: SettingKey) {
  await settings.reset(
    key,
    {},
    {
      editor: { id: '0190f3a0-0000-7000-8000-000000000001', roles: ['OWN'] },
      context,
      reason: 'test',
    },
  );
}

function totpCode(secret: string, at: Date): Promise<string> {
  return generate({ secret, epoch: Math.floor(at.getTime() / 1000) });
}

let accounts = 0;
function newEmail(): string {
  accounts += 1;
  return `admin${accounts}@example.test`;
}

// A pending account with its setup link, as the admin team creates them.
async function pendingAccount(name: SignInName, now = new Date(), roles = ['OPS']) {
  const phone = 'phone' in name ? name.phone : null;
  const [account] = await db.db
    .insert(adminAccounts)
    .values({
      email: 'email' in name ? name.email : null,
      phoneEncrypted: phone && secrets.encrypt(phone),
      phoneHash: phone && secrets.phoneHash(phone),
    })
    .returning({ id: adminAccounts.id });
  await db.db
    .insert(adminAccountRoles)
    .values(roles.map((roleCode) => ({ accountId: account!.id, roleCode })));
  const token = newToken();
  await db.db.insert(adminSetupLinks).values({
    accountId: account!.id,
    tokenHash: tokenHash(token),
    expiresAt: new Date(now.getTime() + 24 * 3_600_000),
  });
  return { accountId: account!.id, token };
}

async function activeAccount(now = new Date(), name: SignInName = { email: newEmail() }) {
  const { accountId, token } = await pendingAccount(name, now);
  const { secret } = await setup.startTotpEnrolment(token, now);
  const backupCodes = await setup.completeSetup(
    { token, password, code: await totpCode(secret, now) },
    context,
    now,
  );
  const login = 'email' in name ? name.email : name.phone;
  return { accountId, login, secret, backupCodes, setupAt: now };
}

// A minute after the setup, so the TOTP step the setup used is behind.
function later(from: Date, minutes = 1): Date {
  return new Date(from.getTime() + minutes * 60_000);
}

async function auditActions(targetId: string): Promise<string[]> {
  const { rows } = await sql.query(
    'SELECT action FROM audit.events WHERE target_id = $1 ORDER BY occurred_at, id',
    [targetId],
  );
  return rows.map((row) => row.action);
}

describe('the first OWN account (AP §5.3)', () => {
  it('is created pending with a setup link valid 24 hours, and audited', async () => {
    const now = new Date('2026-11-05T10:00:00Z');
    const owner = await createFirstOwner(
      { db: db.db, audit, secrets },
      { email: 'owner@example.test', phone: '+963944000009' },
      now,
    );
    const { rows } = await sql.query(
      `SELECT array(SELECT role_code FROM identity.admin_account_roles r WHERE r.account_id = a.id) AS roles,
              a.status, l.token_hash, l.expires_at
         FROM identity.admin_accounts a JOIN identity.admin_setup_links l ON l.account_id = a.id
        WHERE a.id = $1`,
      [owner.accountId],
    );
    expect(rows).toEqual([
      {
        roles: ['OWN'],
        status: 'pending',
        token_hash: tokenHash(owner.setupToken),
        expires_at: new Date('2026-11-06T10:00:00Z'),
      },
    ]);
    expect(await auditActions(owner.accountId)).toEqual(['admin_account.create']);
  });

  it('refuses another name while one exists', async () => {
    for (const name of [
      { email: null, phone: '+963944000001' },
      { email: 'owner@example.test', phone: null },
    ]) {
      await expect(createFirstOwner({ db: db.db, audit, secrets }, name)).rejects.toThrow(
        FirstOwnerExistsError,
      );
    }
  });

  it('replaces the link of a pending owner with the same name, then refuses once set up', async () => {
    const name = { email: 'owner@example.test', phone: '+963944000009' };
    const now = new Date();
    const first = await createFirstOwner({ db: db.db, audit, secrets }, name, now);
    const second = await createFirstOwner({ db: db.db, audit, secrets }, name, now);
    expect(second).toMatchObject({ accountId: first.accountId, reissued: true });
    await expect(setup.startTotpEnrolment(first.setupToken, now)).rejects.toMatchObject({
      refusal: 'link_invalid',
    });
    expect(await auditActions(first.accountId)).toEqual([
      'admin_account.create',
      'admin_account.setup_link_reissue',
      'admin_account.setup_link_reissue',
    ]);

    const { secret } = await setup.startTotpEnrolment(second.setupToken, now);
    await setup.completeSetup(
      { token: second.setupToken, password, code: await totpCode(secret, now) },
      context,
      now,
    );
    await expect(createFirstOwner({ db: db.db, audit, secrets }, name, now)).rejects.toThrow(
      FirstOwnerExistsError,
    );
  });

  it('takes an email, a phone or both on the command line', () => {
    expect(parseOwnerArguments(['--email', 'Owner@Example.test'])).toEqual({
      email: 'owner@example.test',
      phone: null,
    });
    expect(
      parseOwnerArguments(['--email', 'o@example.test', '--phone', '+963 944 000 009']),
    ).toEqual({ email: 'o@example.test', phone: '+963944000009' });
    expect(parseOwnerArguments([])).toBe(OWNER_COMMAND_USAGE);
    expect(parseOwnerArguments(['--name', 'x'])).toBe(OWNER_COMMAND_USAGE);
    expect(parseOwnerArguments(['--email', 'nope'])).toMatch(/email/);
    expect(parseOwnerArguments(['--phone', '0944000009'])).toMatch(/international/);
  });

  it('gets a link with the token in the fragment, never sent to a server', () => {
    expect(setupLinkUrl('https://admin.example.test/', 'abc')).toBe(
      'https://admin.example.test/setup#token=abc',
    );
  });
});

describe('the setup link (AP §5.1 item 3)', () => {
  it('sets the password, enrols TOTP and shows 10 backup codes, over HTTP', async () => {
    const { accountId, token } = await pendingAccount({ email: newEmail() });
    const enrolment = await app.inject({
      method: 'POST',
      url: '/v1/admin/auth/setup/totp',
      payload: { token },
    });
    expect(enrolment.statusCode).toBe(200);
    const { secret, otpauthUri } = enrolment.json<{ secret: string; otpauthUri: string }>();
    expect(otpauthUri).toMatch(/^otpauth:\/\/totp\/.*secret=/);

    const completed = await app.inject({
      method: 'POST',
      url: '/v1/admin/auth/setup/complete',
      payload: { token, password, code: await totpCode(secret, new Date()) },
    });
    expect(completed.statusCode).toBe(200);
    const { backupCodes } = completed.json<{ backupCodes: string[] }>();
    expect(new Set(backupCodes).size).toBe(10);

    const { rows } = await sql.query(
      `SELECT status, password_hash, totp_secret_encrypted FROM identity.admin_accounts WHERE id = $1`,
      [accountId],
    );
    expect(rows[0].status).toBe('active');
    expect(await auditActions(accountId)).toEqual(['admin_account.setup']);
  });

  it('stores no password, TOTP secret, token, backup code or phone in clear', async () => {
    const phone = '+963944000002';
    const { accountId, secret, backupCodes } = await activeAccount(new Date(), { phone });
    const { rows } = await sql.query(
      `SELECT to_jsonb(a) AS account,
              (SELECT jsonb_agg(c) FROM identity.admin_backup_codes c WHERE c.account_id = a.id) AS codes,
              (SELECT jsonb_agg(l) FROM identity.admin_setup_links l WHERE l.account_id = a.id) AS links,
              (SELECT jsonb_agg(e) FROM audit.events e WHERE e.target_id = a.id::text) AS events
         FROM identity.admin_accounts a WHERE a.id = $1`,
      [accountId],
    );
    const stored = JSON.stringify(rows[0]);
    expect(rows[0].account.password_hash).toMatch(/^\$argon2id\$/);
    for (const clear of [password, secret, phone, '944000002', ...backupCodes]) {
      expect(stored).not.toContain(clear);
    }
    for (const code of backupCodes) expect(stored).not.toContain(code.replace('-', ''));
  });

  it('works once only', async () => {
    const now = new Date();
    const { token } = await pendingAccount({ email: newEmail() }, now);
    const { secret } = await setup.startTotpEnrolment(token, now);
    await setup.completeSetup({ token, password, code: await totpCode(secret, now) }, context, now);

    await expect(setup.startTotpEnrolment(token, now)).rejects.toMatchObject({
      refusal: 'link_invalid',
    });
    await expect(
      setup.completeSetup({ token, password, code: await totpCode(secret, now) }, context, now),
    ).rejects.toMatchObject({ refusal: 'link_invalid' });
  });

  it('expires 24 hours after it was made', async () => {
    const madeAt = new Date('2026-11-05T10:00:00Z');
    const { token } = await pendingAccount({ email: newEmail() }, madeAt);
    const lastSecond = new Date('2026-11-06T09:59:59Z');
    await setup.startTotpEnrolment(token, lastSecond);

    const expiry = new Date('2026-11-06T10:00:00Z');
    await expect(setup.startTotpEnrolment(token, expiry)).rejects.toMatchObject({
      refusal: 'link_invalid',
    });
    const old = await pendingAccount({ email: newEmail() }, new Date(Date.now() - 25 * 3_600_000));
    const response = await app.inject({
      method: 'POST',
      url: '/v1/admin/auth/setup/totp',
      payload: { token: old.token },
    });
    expect(response.statusCode).toBe(400);
    expect(response.json()).toMatchObject({ error: 'link_invalid' });
  });

  it('refuses a password shorter than admin.password_min_length', async () => {
    await changeSetting('admin.password_min_length', 24);
    try {
      const now = new Date();
      const { token } = await pendingAccount({ email: newEmail() }, now);
      const { secret } = await setup.startTotpEnrolment(token, now);
      const attempt = setup.completeSetup(
        { token, password: 'x'.repeat(23), code: await totpCode(secret, now) },
        context,
        now,
      );
      await expect(attempt).rejects.toBeInstanceOf(SetupRefusedError);
      await expect(attempt).rejects.toMatchObject({
        refusal: 'password_too_short',
        passwordMinLength: 24,
      });
      await setup.completeSetup(
        { token, password: 'x'.repeat(24), code: await totpCode(secret, now) },
        context,
        now,
      );
    } finally {
      await resetSetting('admin.password_min_length');
    }
  });

  it('checks the code against the last secret offered', async () => {
    const now = new Date();
    const { token } = await pendingAccount({ email: newEmail() }, now);
    const first = await setup.startTotpEnrolment(token, now);
    const second = await setup.startTotpEnrolment(token, now);
    expect(second.secret).not.toBe(first.secret);

    await expect(
      setup.completeSetup(
        { token, password, code: await totpCode(first.secret, now) },
        context,
        now,
      ),
    ).rejects.toMatchObject({ refusal: 'code_invalid' });
    await setup.completeSetup(
      { token, password, code: await totpCode(second.secret, now) },
      context,
      now,
    );
  });

  it('lets one of two setups at once use the link', async () => {
    const now = new Date();
    const { token } = await pendingAccount({ email: newEmail() }, now);
    const { secret } = await setup.startTotpEnrolment(token, now);
    const code = await totpCode(secret, now);
    const results = await Promise.allSettled(
      [0, 1].map(() => setup.completeSetup({ token, password, code }, context, now)),
    );
    expect(results.map((result) => result.status).sort()).toEqual(['fulfilled', 'rejected']);
  });

  it('refuses the link of an account that is no longer pending', async () => {
    const { accountId, token } = await pendingAccount({ email: newEmail() });
    await sql.query(`UPDATE identity.admin_accounts SET status = 'disabled' WHERE id = $1`, [
      accountId,
    ]);
    await expect(setup.startTotpEnrolment(token)).rejects.toMatchObject({
      refusal: 'link_invalid',
    });
  });

  it('needs the TOTP enrolment first', async () => {
    const { token } = await pendingAccount({ email: newEmail() });
    await expect(
      setup.completeSetup({ token, password, code: '123456' }, context),
    ).rejects.toMatchObject({ refusal: 'enrolment_not_started' });
  });
});

describe('sign-in (AP §5.1)', () => {
  it('takes the email, the password and a TOTP code', async () => {
    const account = await activeAccount();
    const at = later(account.setupAt);
    const { token, session } = await signIn.signIn(
      { login: account.login.toUpperCase(), password, code: await totpCode(account.secret, at) },
      context,
      at,
    );
    expect(token).not.toBe('');
    expect(session.accountId).toBe(account.accountId);
    expect(await auditActions(session.id)).toEqual(['admin_session.sign_in']);
  });

  it('takes the phone in another spelling', async () => {
    const account = await activeAccount(new Date(), { phone: '+963944000003' });
    const at = later(account.setupAt);
    const { session } = await signIn.signIn(
      { login: '00963 944 000 003', password, code: await totpCode(account.secret, at) },
      context,
      at,
    );
    expect(session.accountId).toBe(account.accountId);
  });

  it('refuses a wrong password, a wrong code, an unknown name and a pending account alike', async () => {
    const account = await activeAccount();
    const pending = await pendingAccount({ email: newEmail() });
    const at = later(account.setupAt);
    const code = await totpCode(account.secret, at);
    for (const input of [
      { login: account.login, password: 'wrong password!', code },
      { login: account.login, password, code: '000000' },
      { login: 'nobody@example.test', password, code },
      { login: 'not a name', password, code },
    ]) {
      await expect(signIn.signIn(input, context, at)).rejects.toMatchObject({
        refusal: 'invalid',
      });
    }
    const { rows } = await sql.query('SELECT email FROM identity.admin_accounts WHERE id = $1', [
      pending.accountId,
    ]);
    await expect(
      signIn.signIn({ login: rows[0].email, password, code }, context, at),
    ).rejects.toMatchObject({ refusal: 'invalid' });
  });

  it('never takes one TOTP code twice', async () => {
    const account = await activeAccount();
    const at = later(account.setupAt);
    const code = await totpCode(account.secret, at);
    await signIn.signIn({ login: account.login, password, code }, context, at);
    await expect(
      signIn.signIn({ login: account.login, password, code }, context, at),
    ).rejects.toBeInstanceOf(SignInRefusedError);
  });

  it('takes one TOTP code once even when sent twice at once', async () => {
    const account = await activeAccount();
    const at = later(account.setupAt);
    const code = await totpCode(account.secret, at);
    const results = await Promise.allSettled(
      [0, 1].map(() => signIn.signIn({ login: account.login, password, code }, context, at)),
    );
    expect(results.map((result) => result.status).sort()).toEqual(['fulfilled', 'rejected']);
  });

  it('refuses a code when the last accepted step is ahead of this clock', async () => {
    const account = await activeAccount();
    const behind = new Date(account.setupAt.getTime() - 10 * 60_000);
    await expect(
      signIn.signIn(
        { login: account.login, password, code: await totpCode(account.secret, behind) },
        context,
        behind,
      ),
    ).rejects.toMatchObject({ refusal: 'invalid' });
  });

  it('takes each backup code once', async () => {
    const account = await activeAccount();
    const at = later(account.setupAt);
    const [code] = account.backupCodes;
    await signIn.signIn(
      { login: account.login, password, code: code!.toLowerCase().replace('-', ' ') },
      context,
      at,
    );
    await expect(
      signIn.signIn({ login: account.login, password, code: code! }, context, at),
    ).rejects.toMatchObject({ refusal: 'invalid' });
  });

  it('keeps a backup code when the password is wrong', async () => {
    const account = await activeAccount();
    const at = later(account.setupAt);
    const [code] = account.backupCodes;
    await expect(
      signIn.signIn(
        { login: account.login, password: 'wrong password!', code: code! },
        context,
        at,
      ),
    ).rejects.toBeInstanceOf(SignInRefusedError);
    await signIn.signIn({ login: account.login, password, code: code! }, context, at);
  });
});

describe('the lockout (AP §5.1 item 4)', () => {
  it('locks for admin.lockout_min after admin.login_max_attempts failures', async () => {
    await changeSetting('admin.login_max_attempts', 3);
    await changeSetting('admin.lockout_min', 2);
    try {
      const account = await activeAccount();
      const start = later(account.setupAt);
      const wrong = { login: account.login, password: 'wrong password!', code: '000000' };
      for (const refusal of ['invalid', 'invalid', 'locked']) {
        await expect(signIn.signIn(wrong, context, start)).rejects.toMatchObject({ refusal });
      }
      expect(await auditActions(account.accountId)).toContain('admin_account.lock');

      const stillLocked = later(start, 1);
      await expect(
        signIn.signIn(
          { login: account.login, password, code: await totpCode(account.secret, stillLocked) },
          context,
          stillLocked,
        ),
      ).rejects.toMatchObject({ refusal: 'locked' });

      const unlocked = later(start, 2);
      await signIn.signIn(
        { login: account.login, password, code: await totpCode(account.secret, unlocked) },
        context,
        unlocked,
      );
    } finally {
      await resetSetting('admin.login_max_attempts');
      await resetSetting('admin.lockout_min');
    }
  });

  it('counts again from zero after a success', async () => {
    await changeSetting('admin.login_max_attempts', 3);
    try {
      const account = await activeAccount();
      const at = later(account.setupAt);
      const wrong = { login: account.login, password: 'wrong password!', code: '000000' };
      await expect(signIn.signIn(wrong, context, at)).rejects.toMatchObject({ refusal: 'invalid' });
      await expect(signIn.signIn(wrong, context, at)).rejects.toMatchObject({ refusal: 'invalid' });
      await signIn.signIn(
        { login: account.login, password, code: account.backupCodes[0]! },
        context,
        at,
      );
      await expect(signIn.signIn(wrong, context, at)).rejects.toMatchObject({ refusal: 'invalid' });
      await expect(signIn.signIn(wrong, context, at)).rejects.toMatchObject({ refusal: 'invalid' });
    } finally {
      await resetSetting('admin.login_max_attempts');
    }
  });

  it('counts concurrent failures one by one', async () => {
    await changeSetting('admin.login_max_attempts', 3);
    try {
      const account = await activeAccount();
      const at = later(account.setupAt);
      const wrong = { login: account.login, password: 'wrong password!', code: '000000' };
      const results = await Promise.allSettled(
        Array.from({ length: 3 }, () => signIn.signIn(wrong, context, at)),
      );
      const refusals = results.map((result) =>
        result.status === 'rejected' ? (result.reason as SignInRefusedError).refusal : 'signed in',
      );
      expect(refusals.sort()).toEqual(['invalid', 'invalid', 'locked']);
    } finally {
      await resetSetting('admin.login_max_attempts');
    }
  });
});

describe('sessions (AP §5.2)', () => {
  async function signedIn() {
    const account = await activeAccount();
    const at = later(account.setupAt);
    const { token, session } = await signIn.signIn(
      { login: account.login, password, code: await totpCode(account.secret, at) },
      context,
      at,
    );
    return { token, session, at };
  }

  async function sessionRow(id: string) {
    const { rows } = await sql.query(
      `SELECT user_agent, host(ip_address) AS ip_address, signed_in_at, last_activity_at, end_reason
         FROM identity.admin_sessions WHERE id = $1`,
      [id],
    );
    return rows[0];
  }

  it('records the device and browser, IP address, sign-in time and last activity', async () => {
    const { token, session, at } = await signedIn();
    const active = later(at, 5);
    expect(await sessions.authenticate(token, active)).toMatchObject({ id: session.id });
    expect(await sessionRow(session.id)).toEqual({
      user_agent: context.device,
      ip_address: context.ipAddress,
      signed_in_at: at,
      last_activity_at: active,
      end_reason: null,
    });
  });

  it('ends after admin.session_idle_min without activity', async () => {
    await changeSetting('admin.session_idle_min', 10);
    try {
      const { token, session, at } = await signedIn();
      const active = later(at, 9);
      expect(await sessions.authenticate(token, active)).toMatchObject({
        expiresAt: later(active, 10),
      });
      expect(await sessions.authenticate(token, later(active, 10))).toBeNull();
      expect(await sessionRow(session.id)).toMatchObject({ end_reason: 'idle' });
      expect(await sessions.authenticate(token, later(active, 11))).toBeNull();
    } finally {
      await resetSetting('admin.session_idle_min');
    }
  });

  it('ends admin.session_max_hours after sign-in, however active', async () => {
    await changeSetting('admin.session_max_hours', 1);
    try {
      const { token, session, at } = await signedIn();
      for (const minutes of [20, 40]) {
        expect(await sessions.authenticate(token, later(at, minutes))).not.toBeNull();
      }
      expect(await sessions.authenticate(token, later(at, 59))).toMatchObject({
        expiresAt: later(at, 60),
      });
      expect(await sessions.authenticate(token, later(at, 60))).toBeNull();
      expect(await sessionRow(session.id)).toMatchObject({ end_reason: 'max_lifetime' });
    } finally {
      await resetSetting('admin.session_max_hours');
    }
  });

  it('refuses a token it never issued', async () => {
    expect(await sessions.authenticate(newToken())).toBeNull();
  });
});

describe('the session cookie over HTTP (architecture §10.3)', () => {
  it('is HTTP-only, secure and same-site, lives at most admin.session_max_hours, and ends at sign-out', async () => {
    const account = await activeAccount();
    const response = await app.inject({
      method: 'POST',
      url: '/v1/admin/auth/sign-in',
      headers: { 'user-agent': 'Test Browser' },
      payload: { login: account.login, password, code: account.backupCodes[0] },
    });
    expect(response.statusCode).toBe(200);
    const [cookie] = response.cookies;
    expect(cookie).toMatchObject({
      name: ADMIN_SESSION_COOKIE,
      httpOnly: true,
      secure: true,
      sameSite: 'Strict',
      path: '/',
      maxAge: 12 * 3600,
    });
    expect(JSON.stringify(response.json())).not.toContain(cookie!.value);
    const cookies = { [ADMIN_SESSION_COOKIE]: cookie!.value };

    const current = await app.inject({ method: 'GET', url: '/v1/admin/auth/session', cookies });
    expect(current.statusCode).toBe(200);
    expect(current.json()).toMatchObject({ accountId: account.accountId, roles: ['OPS'] });

    const signedOut = await app.inject({
      method: 'POST',
      url: '/v1/admin/auth/sign-out',
      cookies,
    });
    expect(signedOut.statusCode).toBe(200);
    expect(signedOut.cookies[0]).toMatchObject({ name: ADMIN_SESSION_COOKIE, value: '' });
    const after = await app.inject({ method: 'GET', url: '/v1/admin/auth/session', cookies });
    expect(after.statusCode).toBe(401);

    const { rows } = await sql.query(
      `SELECT id FROM identity.admin_sessions WHERE account_id = $1`,
      [account.accountId],
    );
    expect(await auditActions(rows[0].id)).toEqual([
      'admin_session.sign_in',
      'admin_session.sign_out',
    ]);
  });

  it('lives as long as a changed admin.session_max_hours', async () => {
    await changeSetting('admin.session_max_hours', 2);
    try {
      const account = await activeAccount();
      const response = await app.inject({
        method: 'POST',
        url: '/v1/admin/auth/sign-in',
        payload: { login: account.login, password, code: account.backupCodes[0] },
      });
      expect(response.cookies[0]).toMatchObject({ maxAge: 2 * 3600 });
    } finally {
      await resetSetting('admin.session_max_hours');
    }
  });

  it('answers 401 without a cookie', async () => {
    const response = await app.inject({ method: 'GET', url: '/v1/admin/auth/session' });
    expect(response.statusCode).toBe(401);
  });

  // Owner decision 2026-11-05: a locked account answers like any refusal, so
  // a refusal never shows whether a sign-in name has an account.
  it('answers a wrong sign-in, a locked account and an unknown name alike', async () => {
    const account = await activeAccount();
    const attempts = [
      ...Array.from({ length: 6 }, () => ({
        login: account.login,
        password: 'wrong password!',
        code: '000000',
      })),
      { login: account.login, password, code: account.backupCodes[0] },
      { login: 'nobody@example.test', password, code: '000000' },
    ];
    const answers = [];
    for (const payload of attempts) {
      const response = await app.inject({
        method: 'POST',
        url: '/v1/admin/auth/sign-in',
        payload,
      });
      answers.push({ status: response.statusCode, body: response.body });
    }
    expect(new Set(answers.map((answer) => JSON.stringify(answer)))).toEqual(
      new Set([JSON.stringify({ status: 401, body: answers[0]!.body })]),
    );
    expect(answers[0]!.status).toBe(401);
  });
});
