import 'reflect-metadata';
import { randomBytes, randomInt, randomUUID } from 'node:crypto';
import type { NestFastifyApplication } from '@nestjs/platform-fastify';
import pg from 'pg';
import { afterAll, beforeAll, beforeEach, describe, expect, it, vi } from 'vitest';
import { Valkey } from 'iovalkey';
import { ApiModule } from '../../api.module.js';
import { startTestDatabase, type TestDatabase } from '../../database/test-database.js';
import { createApiApp } from '../../http/create-api-app.js';
import { createOpenApiDocument } from '../../http/openapi.js';
import { startTestValkey, type TestValkey } from '../../valkey/test-valkey.js';
import { FxService } from '../fx/index.js';
import { MerchantsService } from '../merchants/index.js';
import { RealtimeAccess } from '../notifications/index.js';
import { SettingsService } from '../settings/index.js';
import { CODE_SENDER, type DevelopmentCodeSender } from './code-sender.js';
import { AppSessionsService } from './app-sessions.service.js';
import { MerchantAccountsService } from './merchant-accounts.service.js';
import { IDENTITY_SECRETS, type IdentitySecrets } from './secrets.js';
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
  // Signing an upload needs no storage: only its settings (slice 2.45c).
  process.env.STORAGE_URL ??= 'http://127.0.0.1:1';
  process.env.STORAGE_KEY_ID ??= 'GK000000000000000000000001';
  process.env.STORAGE_SECRET ??= '0'.repeat(64);
  process.env.ADMIN_PANEL_URL ??= 'http://127.0.0.1:1';
  process.env.APP_UPLOAD_URL ??= 'http://127.0.0.1:2';
  process.env.MERCHANT_PORTAL_URL = 'https://portal.example.test';
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
    // One owner per case: a number waits otp.resend_after_sec between codes.
    const expiringOwner = await user(id, 'owner');
    const leavingOwner = await user(id, 'owner');
    const removedOwner = await user(id, 'owner');

    const expiring = await portalSignIn(expiringOwner.phone);
    await sql.query(
      `UPDATE identity.merchant_portal_sessions SET expires_at = signed_in_at + interval '1 millisecond'
       WHERE account_id = $1`,
      [expiringOwner.accountId],
    );
    expect((await session(expiring.cookies)).statusCode).toBe(401);

    const signingOut = await portalSignIn(leavingOwner.phone);
    const out = await app.inject({
      method: 'POST',
      url: '/v1/merchant/auth/portal/sign-out',
      cookies: signingOut.cookies,
    });
    expect(out.statusCode).toBe(200);
    expect(out.cookies.find((c) => c.name === PORTAL_SESSION_COOKIE)?.value).toBe('');
    expect((await session(signingOut.cookies)).statusCode).toBe(401);

    const removed = await portalSignIn(removedOwner.phone);
    expect((await session(removed.cookies)).statusCode).toBe(200);
    await accounts.removeAccount(id, removedOwner.accountId, change);
    expect((await session(removed.cookies)).statusCode).toBe(401);
    const ended = await sql.query(
      'SELECT end_reason FROM identity.merchant_portal_sessions WHERE account_id = $1',
      [removedOwner.accountId],
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
    // The menu with its price log, preview and photos (slice 2.45b); the
    // hours, settings, staff, devices with the Windows pairing and the
    // portal sessions, and support (slice 2.45c); the reports, the history,
    // the ratings, the account, statements and receipts (slice 2.45d);
    // receiving orders never does.
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
      'GET /v1/merchant/menu',
      'PUT /v1/merchant/menu/availability',
      'PUT /v1/merchant/menu/items/{itemId}/price',
      'PUT /v1/merchant/menu/options/{optionId}/price',
      'PUT /v1/merchant/menu/items/{itemId}/hidden',
      'PUT /v1/merchant/menu/categories/{categoryId}/hidden',
      'PUT /v1/merchant/menu/categories/{categoryId}/window',
      'PUT /v1/merchant/menu/category-order',
      'PUT /v1/merchant/menu/categories/{categoryId}/item-order',
      'POST /v1/merchant/menu/bulk-price/preview',
      'POST /v1/merchant/menu/bulk-price',
      'PUT /v1/merchant/menu/requests/categories/{categoryId}',
      'PUT /v1/merchant/menu/requests/items/{itemId}',
      'PUT /v1/merchant/menu/requests/items/{itemId}/text',
      'PUT /v1/merchant/menu/requests/items/{itemId}/photo',
      'PUT /v1/merchant/menu/requests/option-groups/{groupId}',
      'POST /v1/merchant/menu/requests/{requestId}/withdraw',
      'POST /v1/merchant/uploads/item-photo',
      'GET /v1/merchant/menu/price-log',
      'GET /v1/merchant/menu/customer-preview',
      'GET /v1/merchant/restaurant/hours',
      'PUT /v1/merchant/restaurant/hours',
      'PUT /v1/merchant/restaurant/order-settings',
      'GET /v1/merchant/settings/pickup-currencies',
      'PUT /v1/merchant/settings/pickup-currencies',
      'GET /v1/merchant/staff',
      'POST /v1/merchant/staff',
      'POST /v1/merchant/staff/{accountId}/remove',
      'GET /v1/merchant/devices',
      'PUT /v1/merchant/devices/{deviceId}/name',
      'POST /v1/merchant/devices/{deviceId}/sign-out',
      'POST /v1/merchant/devices/windows-pairing',
      'GET /v1/merchant/portal-sessions',
      'POST /v1/merchant/portal-sessions/{sessionId}/sign-out',
      'POST /v1/merchant/uploads/report-photo',
      'POST /v1/merchant/reports',
      'GET /v1/merchant/reports',
      'GET /v1/merchant/figures',
      'GET /v1/merchant/orders/history',
      'GET /v1/merchant/ratings',
      'GET /v1/merchant/account',
      'GET /v1/merchant/account/overdue',
      'GET /v1/merchant/statements',
      'GET /v1/merchant/statements/{statementId}',
      'GET /v1/merchant/receipts',
      'GET /v1/merchant/receipts/{receiptId}',
      'POST /v1/merchant/exports/report',
      'POST /v1/merchant/exports/order-history',
      'POST /v1/merchant/exports/statement',
      'GET /v1/merchant/exports/{exportId}',
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

// An app's sign-in on a new device; the raw answer.
async function appSignIn(phone: string, deviceId = randomUUID()) {
  await app.inject({
    method: 'POST',
    url: '/v1/merchant/auth/code',
    payload: { phone, deviceId },
  });
  return app.inject({
    method: 'POST',
    url: '/v1/merchant/auth/sign-in',
    payload: { phone, deviceId, code: sender.lastCode(phone) },
  });
}

describe('codes stay where they were asked for (architecture §8.3.3 item 1)', () => {
  it('never signs in to the app with a portal code, nor to the portal with an app code', async () => {
    const owner = await user(await restaurant(), 'owner');
    const deviceId = randomUUID();
    expect((await requestCode(owner.phone, deviceId)).statusCode).toBe(200);
    const intoApp = await app.inject({
      method: 'POST',
      url: '/v1/merchant/auth/sign-in',
      payload: { phone: owner.phone, deviceId, code: sender.lastCode(owner.phone) },
    });
    expect([intoApp.statusCode, intoApp.json().error]).toEqual([400, 'code_expired']);

    const other = await user(await restaurant(), 'owner');
    const browserId = randomUUID();
    await app.inject({
      method: 'POST',
      url: '/v1/merchant/auth/code',
      payload: { phone: other.phone, deviceId: browserId },
    });
    const intoPortal = await app.inject({
      method: 'POST',
      url: '/v1/merchant/auth/portal/sign-in',
      payload: { phone: other.phone, browserId, code: sender.lastCode(other.phone) },
    });
    expect([intoPortal.statusCode, intoPortal.json().error]).toEqual([400, 'code_expired']);
  });

  it("refuses a cashier's code at the portal's sign-in and uses it up", async () => {
    const cashier = await user(await restaurant(), 'cashier');
    const secrets = app.get<IdentitySecrets>(IDENTITY_SECRETS);
    const browserId = randomUUID();
    await sql.query(
      `INSERT INTO identity.app_sign_in_codes
         (party, phone_hash, device_id, portal, code_hash, expires_at, created_at)
       VALUES ('merchant', $1, $2, true, $3, now() + interval '5 minutes', now())`,
      [
        secrets.phoneHash(cashier.phone),
        browserId,
        secrets.signInCodeHash(cashier.phone, '123456'),
      ],
    );
    const refused = await app.inject({
      method: 'POST',
      url: '/v1/merchant/auth/portal/sign-in',
      payload: { phone: cashier.phone, browserId, code: '123456' },
    });
    expect([refused.statusCode, refused.json().error]).toEqual([403, 'owner_only']);
    const code = await sql.query(
      'SELECT end_reason FROM identity.app_sign_in_codes WHERE device_id = $1',
      [browserId],
    );
    expect(code.rows).toEqual([{ end_reason: 'used' }]);
  });
});

describe('the portal session at work (RA §17)', () => {
  it('answers the restaurant and its clock, and keeps one session per browser', async () => {
    const id = await restaurant();
    const owner = await user(id, 'owner');
    const browserId = randomUUID();
    const first = await portalSignIn(owner.phone, browserId);
    expect((await session(first.cookies)).json()).toMatchObject({
      restaurantId: id,
      timeZone: 'Asia/Damascus',
    });
    await sql.query(
      "UPDATE identity.app_sign_in_codes SET created_at = now() - interval '1 hour' WHERE device_id = $1",
      [browserId],
    );
    const second = await portalSignIn(owner.phone, browserId);
    expect((await session(second.cookies)).statusCode).toBe(200);
    expect((await session(first.cookies)).statusCode).toBe(401);
  });

  it('closes the restaurant for a holiday from the portal, audited with the owner', async () => {
    const id = await restaurant();
    const owner = await user(id, 'owner');
    const { cookies } = await portalSignIn(owner.phone);
    const endsAt = new Date(Date.now() + 2 * 86_400_000).toISOString();
    const closed = await app.inject({
      method: 'PUT',
      url: '/v1/merchant/restaurant/holiday-close',
      cookies,
      payload: { startsAt: null, endsAt, message: null },
    });
    expect(closed.statusCode).toBe(200);
    expect(closed.json().holiday).toMatchObject({ endsAt });
    const audited = await sql.query(
      `SELECT actor_id, device FROM audit.events
       WHERE action = 'restaurant.holiday_close' AND actor_type = 'merchant' AND actor_id = $1`,
      [owner.accountId],
    );
    expect(audited.rows[0]?.device).toMatch(/^portal:/);
    const ended = await app.inject({
      method: 'DELETE',
      url: '/v1/merchant/restaurant/holiday-close',
      cookies,
    });
    expect(ended.statusCode).toBe(200);
  });

  it("lists the restaurant's portal sessions and signs another browser out (RA §14.2)", async () => {
    const id = await restaurant();
    const owner = await user(id, 'owner');
    const partner = await user(id, 'owner');
    const mine = await portalSignIn(owner.phone);
    const lost = await portalSignIn(partner.phone);
    const listed = await app.inject({
      method: 'GET',
      url: '/v1/merchant/portal-sessions',
      cookies: mine.cookies,
    });
    expect(listed.statusCode).toBe(200);
    const sessions = listed.json().sessions as { sessionId: string; thisSession: boolean }[];
    expect(sessions).toHaveLength(2);
    expect(sessions.filter((each) => each.thisSession)).toHaveLength(1);
    const lostId = sessions.find((each) => !each.thisSession)!.sessionId;

    // Another restaurant's owner never reaches it.
    const stranger = await portalSignIn((await user(await restaurant(), 'owner')).phone);
    const foreign = await app.inject({
      method: 'POST',
      url: `/v1/merchant/portal-sessions/${lostId}/sign-out`,
      cookies: stranger.cookies,
    });
    expect([foreign.statusCode, foreign.json().error]).toEqual([404, 'unknown_session']);

    const signedOut = await app.inject({
      method: 'POST',
      url: `/v1/merchant/portal-sessions/${lostId}/sign-out`,
      cookies: mine.cookies,
    });
    expect(signedOut.statusCode).toBe(200);
    expect(signedOut.json().sessions).toHaveLength(1);
    expect((await session(lost.cookies)).statusCode).toBe(401);
    expect((await session(mine.cookies)).statusCode).toBe(200);
    const ended = await sql.query(
      'SELECT end_reason FROM identity.merchant_portal_sessions WHERE id = $1',
      [lostId],
    );
    expect(ended.rows).toEqual([{ end_reason: 'signed_out_by_owner' }]);
    const audited = await sql.query(
      `SELECT actor_id, device FROM audit.events
       WHERE action = 'merchant_portal_session.sign_out' AND target_id = $1`,
      [id],
    );
    expect(audited.rows).toEqual([
      { actor_id: owner.accountId, device: expect.stringMatching(/^portal:/) },
    ]);
    const again = await app.inject({
      method: 'POST',
      url: `/v1/merchant/portal-sessions/${lostId}/sign-out`,
      cookies: mine.cookies,
    });
    expect([again.statusCode, again.json().error]).toEqual([404, 'unknown_session']);
  });

  it('pairs a Windows PC, sets the prep time and signs a report photo for the portal (slice 2.45c)', async () => {
    const id = await restaurant();
    const owner = await user(id, 'owner');
    const { cookies } = await portalSignIn(owner.phone);
    const pairing = await app.inject({
      method: 'POST',
      url: '/v1/merchant/devices/windows-pairing',
      cookies,
    });
    expect(pairing.statusCode).toBe(200);
    expect(pairing.json().code).toMatch(/^\d{8}$/);
    expect(pairing.headers['cache-control']).toBe('no-store');

    const hours = await app.inject({
      method: 'GET',
      url: '/v1/merchant/restaurant/hours',
      cookies,
    });
    const settings = await app.inject({
      method: 'PUT',
      url: '/v1/merchant/restaurant/order-settings',
      cookies,
      payload: { defaultPrepMin: hours.json().prepFloorMin, maxActiveOrders: 5 },
    });
    expect(settings.statusCode).toBe(200);
    expect(settings.json()).toMatchObject({
      defaultPrepMin: hours.json().prepFloorMin,
      maxActiveOrders: 5,
    });

    const photo = await app.inject({
      method: 'POST',
      url: '/v1/merchant/uploads/report-photo',
      cookies,
      payload: { contentType: 'image/png', sizeBytes: 100 },
    });
    expect(photo.statusCode).toBe(201);
    const url = new URL(photo.json().url);
    expect(url.origin).toBe('https://portal.example.test');
    expect(url.pathname).toMatch(/^\/private-docs\/incoming\//);
  });

  it("answers another restaurant's order 404, and refuses a cross-origin request", async () => {
    const owner = await user(await restaurant(), 'owner');
    const { cookies } = await portalSignIn(owner.phone);
    const order = await app.inject({
      method: 'GET',
      url: `/v1/merchant/orders/${randomUUID()}`,
      cookies,
    });
    expect([order.statusCode, order.json().error]).toEqual([404, 'unknown_order']);
    const cross = await app.inject({
      method: 'GET',
      url: '/v1/merchant/orders',
      cookies,
      headers: { 'sec-fetch-site': 'same-site' },
    });
    expect([cross.statusCode, cross.json().error]).toEqual([403, 'cross_origin']);
  });

  it("takes an app's token when a request carries both, and keeps the portal's sign-out the portal's", async () => {
    const id = await restaurant();
    const owner = await user(id, 'owner');
    const appOwner = await user(id, 'owner');
    const { cookies } = await portalSignIn(owner.phone);
    const { accessToken } = (await appSignIn(appOwner.phone)).json();
    const both = await app.inject({
      method: 'GET',
      url: '/v1/merchant/auth/session',
      cookies,
      headers: { authorization: `Bearer ${accessToken}` },
    });
    expect([both.statusCode, both.json().accountId]).toEqual([200, appOwner.accountId]);
    const appSignOut = await app.inject({
      method: 'POST',
      url: '/v1/merchant/auth/portal/sign-out',
      headers: { authorization: `Bearer ${accessToken}` },
    });
    expect([appSignOut.statusCode, appSignOut.json().error]).toEqual([403, 'not_in_portal']);
  });
});

describe("the portal's real time (architecture §6.1, RA §4.3)", () => {
  it("subscribes to its own restaurant's channel only, and ends with the session", async () => {
    const id = await restaurant();
    const owner = await user(id, 'owner');
    const { cookies } = await portalSignIn(owner.phone);
    const { sessionId } = (await session(cookies)).json();
    const access = app.get(RealtimeAccess);
    const meta = { party: 'merchant', accountId: owner.accountId };
    const subscribe = (channel: string) =>
      access.subscribe('merchant', { user: sessionId, channel, meta });
    expect(await subscribe(`merchant:${id}`)).toEqual({ result: {} });
    expect(await subscribe(`merchant:${await restaurant()}`)).toMatchObject({
      error: { code: 403 },
    });

    const ended = vi.spyOn(app.get(AppSessionsService), 'notifyEnded');
    await app.inject({ method: 'POST', url: '/v1/merchant/auth/portal/sign-out', cookies });
    expect(ended).toHaveBeenCalledWith([sessionId]);
    ended.mockRestore();
    expect(await subscribe(`merchant:${id}`)).toHaveProperty('disconnect');
  });
});
