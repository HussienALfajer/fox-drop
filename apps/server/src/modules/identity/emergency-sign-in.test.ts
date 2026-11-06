import 'reflect-metadata';
import { randomBytes, randomInt, randomUUID } from 'node:crypto';
import type { NestFastifyApplication } from '@nestjs/platform-fastify';
import pg from 'pg';
import { afterAll, beforeAll, beforeEach, describe, expect, it } from 'vitest';
import { Valkey } from 'iovalkey';
import { ApiModule } from '../../api.module.js';
import { createDatabase, type Database } from '../../database/database.js';
import { startTestDatabase, type TestDatabase } from '../../database/test-database.js';
import { createApiApp } from '../../http/create-api-app.js';
import { startTestValkey, type TestValkey } from '../../valkey/test-valkey.js';
import { CaptainsService } from '../captains/index.js';
import { FxService } from '../fx/index.js';
import { MerchantsService } from '../merchants/index.js';
import { SettingsService } from '../settings/index.js';
import { AdminSessionsService } from './admin-sessions.service.js';
import { AppSignInService } from './app-sign-in.service.js';
import { CaptainAccountsService } from './captain-accounts.service.js';
import { CODE_SENDER, type DevelopmentCodeSender } from './code-sender.js';
import { EMERGENCY_CODE_MINUTES, EmergencySignInService } from './emergency-sign-in.service.js';
import { MerchantAccountsService } from './merchant-accounts.service.js';
import { ADMIN_SESSION_COOKIE } from './route-access.guard.js';

// The emergency sign-in (W4, architecture §22 item 1; owner decisions
// 2026-11-07): OWN or OPS verify a captain or a restaurant user by phone and
// issue a one-time code bound to the number, which the person types in the
// app's usual code screen on any device.
let database: TestDatabase;
let cache: TestValkey;
let app: NestFastifyApplication;
let sql: pg.Pool;
let db: Database;
let valkey: Valkey;
let captains: CaptainsService;
let merchants: MerchantsService;
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
  db = createDatabase(database.appUrl);
  valkey = new Valkey(cache.url);
  app = await createApiApp(ApiModule);
  await app.init();
  await app.getHttpAdapter().getInstance().ready();
  captains = app.get(CaptainsService);
  merchants = app.get(MerchantsService);
  sender = app.get(CODE_SENDER);
  azaz = (await sql.query("SELECT id FROM geo.cities WHERE code = 'AZ'")).rows[0].id;
  const fx = app.get(FxService);
  await fx.setCityCurrency(azaz, { currency: 'TRY', displayOrder: 1, enabled: true }, change);
  await fx.setBaseCurrency(azaz, 'TRY', change);
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

function newPhone(): string {
  return `+9639${randomInt(100_000_000).toString().padStart(8, '0')}`;
}

async function captain(terminated = false) {
  const captainId = await captains.createCaptain(
    azaz,
    { name: 'كابتن', vehicle: 'walking', custodyLimit: { amount: 300_000n, currency: 'TRY' } },
    change,
  );
  if (terminated) await captains.setStatus(captainId, 'terminated', change, new Date());
  const phone = newPhone();
  const accountId = await app.get(CaptainAccountsService).addAccount(captainId, phone, change);
  return { phone, accountId };
}

async function restaurantUser(
  status: 'draft' | 'active' | 'terminated',
  role: 'owner' | 'cashier' = 'owner',
) {
  const restaurantId = await merchants.createRestaurant(
    azaz,
    {
      nameAr: `مطعم ${randomUUID()}`,
      location: { latitude: 36.5866, longitude: 37.0463 },
      coverage: { kind: 'radius', radiusMetres: 3000 },
      minimumOrder: { amount: 10_000n, currency: 'TRY' },
      commissionBp: 1500,
      defaultPrepMin: 20,
    },
    change,
  );
  const phone = newPhone();
  const accountId = await app
    .get(MerchantAccountsService)
    .addAccount(restaurantId, { role, name: 'سامر', phone }, change);
  if (status !== 'draft') await merchants.setAccountStatus(restaurantId, 'active', change);
  if (status === 'terminated') {
    await merchants.setAccountStatus(restaurantId, 'terminated', change);
  }
  return { phone, accountId };
}

let admins = 0;
// A signed-in admin holding these roles.
async function admin(roles: string[]) {
  admins += 1;
  const { rows } = await sql.query(
    `INSERT INTO identity.admin_accounts (name, email, status, password_hash, totp_secret_encrypted)
     VALUES ($1, $2, 'active', 'not used', 'not used') RETURNING id`,
    [`Operator ${admins}`, `operator${admins}@example.test`],
  );
  const accountId: string = rows[0].id;
  for (const role of roles) {
    await sql.query(
      'INSERT INTO identity.admin_account_roles (account_id, role_code) VALUES ($1, $2)',
      [accountId, role],
    );
  }
  const { token, session } = await app
    .get(AdminSessionsService)
    .start(db.db, accountId, { ipAddress: '203.0.113.9', device: 'test' }, new Date());
  const cookies = { [ADMIN_SESSION_COOKIE]: token };
  return {
    accountId,
    session,
    issue: (payload: Record<string, unknown>) =>
      app.inject({ method: 'POST', url: '/v1/admin/emergency-sign-in-codes', cookies, payload }),
  };
}

function signIn(
  party: 'captain' | 'merchant',
  phone: string,
  code: string,
  deviceId = randomUUID(),
) {
  return app.inject({
    method: 'POST',
    url: `/v1/${party}/auth/sign-in`,
    payload: { phone, deviceId, code },
  });
}

describe('emergency sign-in codes (W4, architecture §22 item 1)', () => {
  it('let OPS sign a captain in on any device once, audited without the code or the number', async () => {
    const ops = await admin(['OPS']);
    const { phone, accountId } = await captain();
    const issued = await ops.issue({
      party: 'captain',
      phone,
      reason: 'أرقام الإرسال متوقفة، تحققت منه هاتفياً',
    });
    expect(issued.statusCode).toBe(200);
    const body = issued.json();
    expect(body.code).toMatch(/^\d{6}$/);
    expect(body.accountId).toBe(accountId);
    expect(new Date(body.expiresAt).getTime() - Date.now()).toBeGreaterThan(9 * 60_000);

    const signedIn = await signIn('captain', phone, body.code);
    expect(signedIn.statusCode).toBe(200);
    const again = await signIn('captain', phone, body.code);
    expect(again.json().error).toBe('code_expired');

    const stored = await sql.query(
      `SELECT * FROM identity.app_sign_in_codes WHERE issued_by = $1`,
      [ops.accountId],
    );
    expect(stored.rows).toHaveLength(1);
    expect(stored.rows[0]).toMatchObject({
      device_id: null,
      issue_reason: 'أرقام الإرسال متوقفة، تحققت منه هاتفياً',
      end_reason: 'used',
    });
    expect(JSON.stringify(stored.rows[0])).not.toContain(body.code);

    const events = await sql.query(
      `SELECT actor_id, actor_role, target_type, city_id, reason, changes::text AS changes
       FROM audit.events WHERE action = 'app_sign_in_code.emergency_issue' AND target_id = $1`,
      [accountId],
    );
    expect(events.rows).toEqual([
      expect.objectContaining({
        actor_id: ops.accountId,
        actor_role: 'OPS',
        target_type: 'captain_account',
        city_id: azaz,
        reason: 'أرقام الإرسال متوقفة، تحققت منه هاتفياً',
      }),
    ]);
    expect(events.rows[0].changes).not.toContain(body.code);
    expect(events.rows[0].changes).not.toContain(phone.slice(1));
  });

  it('replace the number’s open WhatsApp code, and are replaced by a new one', async () => {
    const owner = await admin(['OWN']);
    const { phone } = await captain();
    const deviceId = randomUUID();
    const requested = await app.inject({
      method: 'POST',
      url: '/v1/captain/auth/code',
      payload: { phone, deviceId },
    });
    expect(requested.statusCode).toBe(200);
    const whatsapp = sender.lastCode(phone)!;
    const first = (await owner.issue({ party: 'captain', phone, reason: 'لم يصله الرمز' })).json();
    expect((await signIn('captain', phone, whatsapp, deviceId)).statusCode).toBe(400);
    const second = (await owner.issue({ party: 'captain', phone, reason: 'مرة ثانية' })).json();
    expect((await signIn('captain', phone, first.code)).statusCode).toBe(400);
    expect((await signIn('captain', phone, second.code)).statusCode).toBe(200);
  });

  it('are kept while open: a code request waits until the emergency code expires', async () => {
    const ops = await admin(['OPS']);
    const service = app.get(EmergencySignInService);
    const signInService = app.get(AppSignInService);
    const { phone } = await captain();
    const now = new Date();
    const issued = await service.issue(
      { party: 'captain', phone, reason: 'لم يصله الرمز' },
      ops.session,
      noRequest,
      now,
    );
    const request = { party: 'captain' as const, phone, deviceId: randomUUID() };
    const later = new Date(now.getTime() + 5 * 60_000);
    await expect(signInService.requestCode(request, noRequest, later)).rejects.toMatchObject({
      refusal: 'resend_wait',
      retryAfterSec: 5 * 60,
    });
    // The emergency code still signs in.
    expect((await signIn('captain', phone, issued.code)).statusCode).toBe(200);

    // Once it expired, a code request replaces it as usual.
    const next = await service.issue(
      { party: 'captain', phone, reason: 'مرة ثانية' },
      ops.session,
      noRequest,
      now,
    );
    const expired = new Date(now.getTime() + 10 * 60_000);
    await signInService.requestCode(request, noRequest, expired);
    const replaced = await sql.query(
      `SELECT end_reason FROM identity.app_sign_in_codes WHERE issue_reason = 'مرة ثانية' AND issued_by = $1`,
      [ops.accountId],
    );
    expect(replaced.rows).toEqual([{ end_reason: 'replaced' }]);
    await expect(
      signInService.signIn({ ...request, code: sender.lastCode(phone)! }, noRequest, expired),
    ).resolves.toBeDefined();
    expect(next.code).toMatch(/^\d{6}$/);
  });

  it('expire after 10 minutes and end after otp.max_attempts wrong codes', async () => {
    const ops = await admin(['OPS']);
    const service = app.get(EmergencySignInService);
    const signInService = app.get(AppSignInService);
    const { phone } = await captain();
    const now = new Date();
    const expired = await service.issue(
      { party: 'captain', phone, reason: 'اختبار' },
      ops.session,
      noRequest,
      now,
    );
    expect(EMERGENCY_CODE_MINUTES).toBe(10);
    await expect(
      signInService.signIn(
        { party: 'captain', phone, deviceId: randomUUID(), code: expired.code },
        noRequest,
        new Date(now.getTime() + 10 * 60_000),
      ),
    ).rejects.toMatchObject({ refusal: 'code_expired' });

    const issued = await service.issue(
      { party: 'captain', phone, reason: 'اختبار' },
      ops.session,
      noRequest,
    );
    const wrong = issued.code === '000000' ? '111111' : '000000';
    const maxAttempts = await app.get(SettingsService).get('otp.max_attempts');
    for (let attempt = 0; attempt < maxAttempts; attempt += 1) {
      await signIn('captain', phone, wrong);
    }
    expect((await signIn('captain', phone, issued.code)).statusCode).toBe(400);
  });

  it('sign a restaurant owner in, and refuse a number that cannot sign in', async () => {
    const ops = await admin(['OPS']);
    const owner = await restaurantUser('active');
    const issued = await ops.issue({ party: 'merchant', phone: owner.phone, reason: 'هاتف جديد' });
    expect(issued.statusCode).toBe(200);
    expect((await signIn('merchant', owner.phone, issued.json().code)).statusCode).toBe(200);

    const draft = await restaurantUser('draft');
    const refusedDraft = await ops.issue({ party: 'merchant', phone: draft.phone, reason: 'x' });
    expect(refusedDraft.statusCode).toBe(409);
    expect(refusedDraft.json().error).toBe('restaurant_draft');

    const cashier = await restaurantUser('terminated', 'cashier');
    const refusedCashier = await ops.issue({
      party: 'merchant',
      phone: cashier.phone,
      reason: 'x',
    });
    expect(refusedCashier.json().error).toBe('restaurant_terminated');

    const ended = await captain(true);
    const refusedEnded = await ops.issue({ party: 'captain', phone: ended.phone, reason: 'x' });
    expect(refusedEnded.statusCode).toBe(409);
    expect(refusedEnded.json().error).toBe('contract_ended');

    const unknown = await ops.issue({ party: 'captain', phone: newPhone(), reason: 'x' });
    expect(unknown.statusCode).toBe(409);
    expect(unknown.json().error).toBe('not_registered');
    // A captain's number is not a restaurant user's.
    const wrongParty = await ops.issue({ party: 'merchant', phone: ended.phone, reason: 'x' });
    expect(wrongParty.json().error).toBe('not_registered');
  });

  it('cover no customers, need a reason and the permission', async () => {
    const ops = await admin(['OPS']);
    const { phone } = await captain();
    expect((await ops.issue({ party: 'customer', phone, reason: 'x' })).statusCode).toBe(400);
    expect((await ops.issue({ party: 'captain', phone })).statusCode).toBe(400);
    expect((await ops.issue({ party: 'captain', phone, reason: '   ' })).statusCode).toBe(400);
    const sup = await admin(['SUP']);
    expect((await sup.issue({ party: 'captain', phone, reason: 'x' })).statusCode).toBe(403);
    await expect(
      sql.query(
        `INSERT INTO identity.app_sign_in_codes (party, phone_hash, code_hash, expires_at, issued_by, issue_reason)
         VALUES ('customer', 'h', 'c', now(), $1, 'x')`,
        [ops.accountId],
      ),
    ).rejects.toThrow(/app_sign_in_codes_device_or_issuer/);
  });
});
