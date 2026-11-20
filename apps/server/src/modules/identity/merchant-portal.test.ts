import 'reflect-metadata';
import { randomBytes, randomInt, randomUUID } from 'node:crypto';
import type { NestFastifyApplication } from '@nestjs/platform-fastify';
import pg from 'pg';
import { afterAll, beforeAll, beforeEach, describe, expect, it } from 'vitest';
import { Valkey } from 'iovalkey';
import { ApiModule } from '../../api.module.js';
import { startTestDatabase, type TestDatabase } from '../../database/test-database.js';
import { createApiApp } from '../../http/create-api-app.js';
import { createOpenApiDocument } from '../../http/openapi.js';
import { startTestValkey, type TestValkey } from '../../valkey/test-valkey.js';
import { FxService } from '../fx/index.js';
import { MerchantsService } from '../merchants/index.js';
import { SettingsService } from '../settings/index.js';
import { CODE_SENDER, type DevelopmentCodeSender } from './code-sender.js';
import { MerchantAccountsService } from './merchant-accounts.service.js';
import { PORTAL_SESSION_COOKIE } from './route-access.guard.js';

// The owner web portal's sign-in and session (RA §17, §5.2–5.3, S14; slice
// 2.45a), served by the API app as in production, on a fresh database and
// Valkey.
let database: TestDatabase;
let cache: TestValkey;
let app: NestFastifyApplication;
let sql: pg.Pool;
let valkey: Valkey;
let merchants: MerchantsService;
let accounts: MerchantAccountsService;
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
  merchants = app.get(MerchantsService);
  accounts = app.get(MerchantAccountsService);
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

const newPhone = () => `+9639${randomInt(100_000_000).toString().padStart(8, '0')}`;

async function restaurant(): Promise<string> {
  const id = await merchants.createRestaurant(
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
  await merchants.setAccountStatus(id, 'active', change);
  return id;
}

async function user(restaurantId: string, role: 'owner' | 'cashier') {
  const phone = newPhone();
  const accountId = await accounts.addAccount(
    restaurantId,
    { role, name: role === 'owner' ? 'سامر' : 'كاشير 1', phone },
    change,
  );
  return { phone, accountId };
}

function requestCode(phone: string, browserId: string) {
  return app.inject({
    method: 'POST',
    url: '/v1/merchant/auth/portal/code',
    payload: { phone, browserId },
  });
}

// Asks for a code and signs in to the portal; the raw answer and the cookie.
async function portalSignIn(phone: string, browserId = randomUUID()) {
  expect((await requestCode(phone, browserId)).statusCode).toBe(200);
  const response = await app.inject({
    method: 'POST',
    url: '/v1/merchant/auth/portal/sign-in',
    payload: { phone, browserId, code: sender.lastCode(phone) },
  });
  const cookie = response.cookies.find((c) => c.name === PORTAL_SESSION_COOKIE);
  return { response, cookie, cookies: { [PORTAL_SESSION_COOKIE]: cookie?.value ?? '' } };
}

function session(cookies: Record<string, string>) {
  return app.inject({ method: 'GET', url: '/v1/merchant/auth/portal/session', cookies });
}

async function appCheckRequired(on: boolean) {
  await app.get(SettingsService).update('otp.app_check_required', {}, on, {
    editor: { id: '0190f3a0-0000-7000-8000-000000000001', roles: ['OWN'] },
    context: noRequest,
    reason: 'test',
  });
}

describe('the portal sign-in (RA §17, §5.2)', () => {
  it('sends an owner a code and refuses a cashier and an unknown number before sending', async () => {
    const id = await restaurant();
    const owner = await user(id, 'owner');
    const cashier = await user(id, 'cashier');
    expect((await requestCode(owner.phone, randomUUID())).statusCode).toBe(200);
    expect(sender.lastCode(owner.phone)).toMatch(/^\d{6}$/);
    const refused = await requestCode(cashier.phone, randomUUID());
    expect([refused.statusCode, refused.json().error]).toEqual([403, 'owner_only']);
    expect(sender.lastCode(cashier.phone)).toBeUndefined();
    const unknown = newPhone();
    const none = await requestCode(unknown, randomUUID());
    expect([none.statusCode, none.json().error]).toEqual([403, 'not_registered']);
    expect(sender.lastCode(unknown)).toBeUndefined();
  });

  it('needs no App Check while the apps need it (owner decision 2026-11-20)', async () => {
    const owner = await user(await restaurant(), 'owner');
    await appCheckRequired(true);
    try {
      const fromApp = await app.inject({
        method: 'POST',
        url: '/v1/merchant/auth/code',
        payload: { phone: owner.phone, deviceId: randomUUID() },
      });
      expect([fromApp.statusCode, fromApp.json().error]).toEqual([403, 'app_check_failed']);
      expect((await requestCode(owner.phone, randomUUID())).statusCode).toBe(200);
    } finally {
      await appCheckRequired(false);
    }
  });

  it('signs an owner in with an HTTP-only cookie for 30 days, and never as a device', async () => {
    const id = await restaurant();
    const owner = await user(id, 'owner');
    const { response, cookie, cookies } = await portalSignIn(owner.phone);
    expect(response.statusCode).toBe(200);
    expect(response.json()).toMatchObject({ accountId: owner.accountId, restaurantId: id });
    expect(cookie).toMatchObject({
      httpOnly: true,
      secure: true,
      sameSite: 'Strict',
      path: '/',
      maxAge: 30 * 86_400,
    });
    expect((await session(cookies)).json()).toMatchObject({
      accountId: owner.accountId,
      restaurantId: id,
      name: 'سامر',
    });
    // RA §4.6: no app session, so no device, no push and no ring.
    const devices = await sql.query(
      "SELECT count(*)::int AS n FROM identity.app_sessions WHERE party = 'merchant' AND account_id = $1",
      [owner.accountId],
    );
    expect(devices.rows).toEqual([{ n: 0 }]);
    // The token is kept as a hash only.
    const stored = await sql.query(
      'SELECT token_hash FROM identity.merchant_portal_sessions WHERE account_id = $1',
      [owner.accountId],
    );
    expect(stored.rows[0].token_hash).not.toBe(cookie?.value);
  });

  it('refuses a code asked for by another browser', async () => {
    const owner = await user(await restaurant(), 'owner');
    expect((await requestCode(owner.phone, randomUUID())).statusCode).toBe(200);
    const other = await app.inject({
      method: 'POST',
      url: '/v1/merchant/auth/portal/sign-in',
      payload: { phone: owner.phone, browserId: randomUUID(), code: sender.lastCode(owner.phone) },
    });
    expect([other.statusCode, other.json().error]).toEqual([400, 'code_expired']);
  });

  it('ends the session at its expiry, at sign-out and at the owner’s removal', async () => {
    const id = await restaurant();
    const first = await user(id, 'owner');
    const second = await user(id, 'owner');

    const expiring = await portalSignIn(first.phone);
    await sql.query(
      `UPDATE identity.merchant_portal_sessions SET expires_at = signed_in_at + interval '1 millisecond'
       WHERE account_id = $1`,
      [first.accountId],
    );
    expect((await session(expiring.cookies)).statusCode).toBe(401);

    const signingOut = await portalSignIn(first.phone);
    const out = await app.inject({
      method: 'POST',
      url: '/v1/merchant/auth/portal/sign-out',
      cookies: signingOut.cookies,
    });
    expect(out.statusCode).toBe(200);
    expect(out.cookies.find((c) => c.name === PORTAL_SESSION_COOKIE)?.value).toBe('');
    expect((await session(signingOut.cookies)).statusCode).toBe(401);

    const removed = await portalSignIn(second.phone);
    expect((await session(removed.cookies)).statusCode).toBe(200);
    await accounts.removeAccount(id, second.accountId, change);
    expect((await session(removed.cookies)).statusCode).toBe(401);
    const ended = await sql.query(
      'SELECT end_reason FROM identity.merchant_portal_sessions WHERE account_id = $1',
      [second.accountId],
    );
    expect(ended.rows).toEqual([{ end_reason: 'account_removed' }]);
  });

  it("answers an app's token 403 not_in_portal on the portal's own routes", async () => {
    const owner = await user(await restaurant(), 'owner');
    const deviceId = randomUUID();
    await app.inject({
      method: 'POST',
      url: '/v1/merchant/auth/code',
      payload: { phone: owner.phone, deviceId },
    });
    const signedIn = await app.inject({
      method: 'POST',
      url: '/v1/merchant/auth/sign-in',
      payload: { phone: owner.phone, deviceId, code: sender.lastCode(owner.phone) },
    });
    const response = await app.inject({
      method: 'GET',
      url: '/v1/merchant/auth/portal/session',
      headers: { authorization: `Bearer ${signedIn.json().accessToken}` },
    });
    expect([response.statusCode, response.json().error]).toEqual([403, 'not_in_portal']);
  });
});

describe('the routes the portal reaches (RA §17)', () => {
  it('answers the portal 403 not_in_portal on every restaurant route but its own', async () => {
    const owner = await user(await restaurant(), 'owner');
    const { cookies } = await portalSignIn(owner.phone);
    // RA §17 (slice 2.45a): the live orders read-only, the status and
    // holiday close, the terms, the emergency stop, real time and the
    // portal's own session (its sign-out is left out: it ends the session).
    // The owner features join with 2.45b–d; receiving orders never does.
    const allowed = [
      'GET /v1/merchant/auth/portal/session',
      'GET /v1/merchant/orders',
      'GET /v1/merchant/orders/{orderId}',
      'GET /v1/merchant/restaurant/status',
      'POST /v1/merchant/restaurant/status/pause',
      'POST /v1/merchant/restaurant/status/resume',
      'PUT /v1/merchant/restaurant/status/busy-mode',
      'PUT /v1/merchant/restaurant/holiday-close',
      'DELETE /v1/merchant/restaurant/holiday-close',
      'GET /v1/merchant/terms',
      'POST /v1/merchant/terms/accept',
      'GET /v1/merchant/emergency-stop',
      'POST /v1/merchant/realtime/token',
    ];
    const document = createOpenApiDocument(app);
    const reached: string[] = [];
    for (const [path, item] of Object.entries(document.paths)) {
      if (!path.startsWith('/v1/merchant/') || path === '/v1/merchant/auth/portal/sign-out') {
        continue;
      }
      for (const method of ['get', 'put', 'post', 'delete'] as const) {
        if (!item[method]) continue;
        const response = await app.inject({
          method: method.toUpperCase() as 'GET',
          url: path.replaceAll(/\{[^}]+\}/g, randomUUID()),
          cookies,
          ...(method === 'get' ? {} : { payload: {} }),
        });
        const refused = response.statusCode === 403 && response.json().error === 'not_in_portal';
        if (!refused) reached.push(`${method.toUpperCase()} ${path}`);
      }
    }
    // The rest it reaches are the public routes, which take no session.
    for (const route of reached.filter((route) => !allowed.includes(route))) {
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
});
