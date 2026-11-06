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
import { FxService } from '../fx/index.js';
import { type AccountStatus, MerchantsService } from '../merchants/index.js';
import { CODE_SENDER, type DevelopmentCodeSender } from './code-sender.js';
import {
  MerchantAccountRefusedError,
  MerchantAccountsService,
  merchantSignInRefusal,
} from './merchant-accounts.service.js';

// The restaurant app's sign-in (RA §5.1–5.3, §5.5) on the app sign-in engine,
// served by the API app as in production, on a fresh database and Valkey.
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

function newPhone(): string {
  return `+9639${randomInt(100_000_000).toString().padStart(8, '0')}`;
}

// A restaurant in this status.
async function restaurant(status: AccountStatus): Promise<string> {
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
  if (status === 'draft') return id;
  await merchants.setAccountStatus(id, status === 'test' ? 'test' : 'active', change);
  if (status === 'suspended' || status === 'terminated') {
    await merchants.setAccountStatus(id, status, change);
  }
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

function requestCode(phone: string, deviceId: string) {
  return app.inject({
    method: 'POST',
    url: '/v1/merchant/auth/code',
    payload: { phone, deviceId },
  });
}

// Asks for a code and signs in with it; the raw answer of the sign-in.
async function signIn(phone: string, deviceId = randomUUID()) {
  const code = await requestCode(phone, deviceId);
  expect(code.statusCode).toBe(200);
  return app.inject({
    method: 'POST',
    url: '/v1/merchant/auth/sign-in',
    payload: { phone, deviceId, code: sender.lastCode(phone) },
  });
}

async function refresh(refreshToken: string) {
  return app.inject({
    method: 'POST',
    url: '/v1/merchant/auth/refresh',
    payload: { refreshToken },
  });
}

function nameDevice(headers: Record<string, string>, name: string) {
  return app.inject({
    method: 'PUT',
    url: '/v1/merchant/auth/device',
    headers,
    payload: { name, platform: 'android', appVersion: '1.0.0' },
  });
}

describe('who signs in to the restaurant app (RA §5.2, §5.5)', () => {
  it('follows the restaurant account status', () => {
    expect(merchantSignInRefusal('owner', 'draft')).toBe('restaurant_draft');
    expect(merchantSignInRefusal('cashier', 'draft')).toBe('restaurant_draft');
    for (const status of ['test', 'active', 'suspended'] as const) {
      expect(merchantSignInRefusal('owner', status)).toBeNull();
      expect(merchantSignInRefusal('cashier', status)).toBeNull();
    }
    expect(merchantSignInRefusal('owner', 'terminated')).toBeNull();
    expect(merchantSignInRefusal('cashier', 'terminated')).toBe('restaurant_terminated');
  });

  it('tells a number of no restaurant at once, and sends it nothing', async () => {
    const phone = newPhone();
    const response = await requestCode(phone, randomUUID());
    expect(response.statusCode).toBe(403);
    expect(response.json()).toMatchObject({ error: 'not_registered' });
    expect(sender.lastCode(phone)).toBeUndefined();
  });

  it('refuses a draft restaurant before sending a code', async () => {
    const { phone } = await user(await restaurant('draft'), 'owner');
    const response = await requestCode(phone, randomUUID());
    expect(response.statusCode).toBe(403);
    expect(response.json()).toMatchObject({ error: 'restaurant_draft' });
    expect(sender.lastCode(phone)).toBeUndefined();
  });

  it("refuses a terminated restaurant's cashiers and lets its owners in", async () => {
    const id = await restaurant('terminated');
    const cashier = await user(id, 'cashier');
    const owner = await user(id, 'owner');
    const refused = await requestCode(cashier.phone, randomUUID());
    expect(refused.statusCode).toBe(403);
    expect(refused.json()).toMatchObject({ error: 'restaurant_terminated' });
    const signedIn = await signIn(owner.phone);
    expect(signedIn.statusCode).toBe(200);
    // The owner keeps refreshing (RA §5.5, the money section).
    expect((await refresh(signedIn.json().refreshToken)).statusCode).toBe(200);
  });

  it('refuses at sign-in a status that changed after the code request', async () => {
    const id = await restaurant('active');
    const { phone } = await user(id, 'cashier');
    const deviceId = randomUUID();
    expect((await requestCode(phone, deviceId)).statusCode).toBe(200);
    await merchants.setAccountStatus(id, 'terminated', change);
    const response = await app.inject({
      method: 'POST',
      url: '/v1/merchant/auth/sign-in',
      payload: { phone, deviceId, code: sender.lastCode(phone) },
    });
    expect(response.statusCode).toBe(403);
    expect(response.json()).toMatchObject({ error: 'restaurant_terminated' });
  });

  it('lets a suspended restaurant sign in', async () => {
    const { phone } = await user(await restaurant('suspended'), 'cashier');
    expect((await signIn(phone)).statusCode).toBe(200);
  });

  it('signs an owner in with the restaurant and role, then names the device', async () => {
    const id = await restaurant('active');
    const { phone, accountId } = await user(id, 'owner');
    const deviceId = randomUUID();
    const response = await signIn(phone, deviceId);
    expect(response.statusCode).toBe(200);
    const body = response.json();
    expect(body).toMatchObject({
      accountId,
      restaurantId: id,
      role: 'owner',
      name: 'سامر',
      deviceNamed: false,
    });
    const headers = { authorization: `Bearer ${body.accessToken}` };
    expect((await nameDevice(headers, 'تابلت المطبخ')).statusCode).toBe(200);
    const session = await app.inject({ method: 'GET', url: '/v1/merchant/auth/session', headers });
    expect(session.json()).toMatchObject({ accountId, restaurantId: id, deviceNamed: true });
    // An owner renames it (RA §5.4, staff and devices).
    expect((await nameDevice(headers, 'كاشير 1')).statusCode).toBe(200);
    const { rows } = await sql.query(
      'SELECT name, platform, app_version, named_by_id FROM merchants.devices WHERE device_id = $1',
      [deviceId],
    );
    expect(rows).toEqual([
      { name: 'كاشير 1', platform: 'android', app_version: '1.0.0', named_by_id: accountId },
    ]);
  });

  it('lets a cashier name a device once, never rename it', async () => {
    const { phone } = await user(await restaurant('active'), 'cashier');
    const { accessToken } = (await signIn(phone)).json();
    const headers = { authorization: `Bearer ${accessToken}` };
    expect((await nameDevice(headers, 'كاشير 1')).statusCode).toBe(200);
    const renamed = await nameDevice(headers, 'كاشير 2');
    expect(renamed.statusCode).toBe(403);
    expect(renamed.json()).toMatchObject({ error: 'device_rename_not_allowed' });
  });

  it('refreshes, and signs out', async () => {
    const { phone } = await user(await restaurant('active'), 'cashier');
    const { refreshToken } = (await signIn(phone)).json();
    const refreshed = await refresh(refreshToken);
    expect(refreshed.statusCode).toBe(200);
    const headers = { authorization: `Bearer ${refreshed.json().accessToken}` };
    const out = await app.inject({ method: 'POST', url: '/v1/merchant/auth/sign-out', headers });
    expect(out.json()).toEqual({ status: 'signed_out' });
    const after = await app.inject({ method: 'GET', url: '/v1/merchant/auth/session', headers });
    expect(after.statusCode).toBe(401);
    expect((await refresh(refreshed.json().refreshToken)).statusCode).toBe(401);
  });

  it("ends a cashier's access at once when the restaurant is terminated", async () => {
    const id = await restaurant('active');
    const { phone } = await user(id, 'cashier');
    const { accessToken, refreshToken } = (await signIn(phone)).json();
    await merchants.setAccountStatus(id, 'terminated', change);
    const session = await app.inject({
      method: 'GET',
      url: '/v1/merchant/auth/session',
      headers: { authorization: `Bearer ${accessToken}` },
    });
    expect(session.statusCode).toBe(401);
    expect((await refresh(refreshToken)).statusCode).toBe(401);
  });

  it("keeps each app's tokens to its own routes", async () => {
    const { phone } = await user(await restaurant('active'), 'owner');
    const { accessToken } = (await signIn(phone)).json();
    const onCustomer = await app.inject({
      method: 'GET',
      url: '/v1/customer/auth/session',
      headers: { authorization: `Bearer ${accessToken}` },
    });
    expect(onCustomer.statusCode).toBe(401);

    const customerPhone = newPhone();
    const deviceId = randomUUID();
    await app.inject({
      method: 'POST',
      url: '/v1/customer/auth/code',
      payload: { phone: customerPhone, deviceId },
    });
    const customer = await app.inject({
      method: 'POST',
      url: '/v1/customer/auth/sign-in',
      payload: { phone: customerPhone, deviceId, code: sender.lastCode(customerPhone) },
    });
    expect(customer.statusCode).toBe(200);
    const onMerchant = await app.inject({
      method: 'GET',
      url: '/v1/merchant/auth/session',
      headers: { authorization: `Bearer ${customer.json().accessToken}` },
    });
    expect(onMerchant.statusCode).toBe(401);
  });
});

describe('the accounts of a restaurant (RA §5.1)', () => {
  it('gives a number to one restaurant only (S6)', async () => {
    const { phone } = await user(await restaurant('active'), 'owner');
    await expect(
      accounts.addAccount(
        await restaurant('active'),
        { role: 'cashier', name: 'x', phone },
        change,
      ),
    ).rejects.toMatchObject({ refusal: 'phone_taken' });
    await expect(
      accounts.addAccount(randomUUID(), { role: 'owner', name: 'x', phone: newPhone() }, change),
    ).rejects.toBeInstanceOf(MerchantAccountRefusedError);
  });

  it('keeps the phone only encrypted, in the rows and the audit log', async () => {
    const { phone, accountId } = await user(await restaurant('active'), 'owner');
    const { rows } = await sql.query('SELECT * FROM identity.merchant_accounts WHERE id = $1', [
      accountId,
    ]);
    const { rows: events } = await sql.query(
      "SELECT * FROM audit.events WHERE action = 'merchant_account.create' AND target_id = $1",
      [accountId],
    );
    expect(events).toHaveLength(1);
    for (const stored of [JSON.stringify(rows), JSON.stringify(events)]) {
      expect(stored).not.toContain(phone);
      expect(stored).not.toContain(phone.slice(1));
    }
  });
});
