import 'reflect-metadata';
import { randomBytes, randomInt, randomUUID } from 'node:crypto';
import type { NestFastifyApplication } from '@nestjs/platform-fastify';
import pg from 'pg';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { ApiModule } from '../../api.module.js';
import { startTestDatabase, type TestDatabase } from '../../database/test-database.js';
import { createApiApp } from '../../http/create-api-app.js';
import { startTestValkey, type TestValkey } from '../../valkey/test-valkey.js';
import { FxService } from '../fx/index.js';
import { MerchantsService } from '../merchants/index.js';
import { CODE_SENDER, type DevelopmentCodeSender, MerchantAccountsService } from './index.js';

// RA §14.1–14.2, §18 (slice 2.33): the owners' «الموظفون» and «الأجهزة» in
// the restaurant app.
let database: TestDatabase;
let cache: TestValkey;
let app: NestFastifyApplication;
let sql: pg.Pool;
let merchants: MerchantsService;
let azaz: string;

const system = { type: 'system', id: null, role: null } as const;
const change = { actor: system, context: { ipAddress: null, device: null }, reason: 'test' };

beforeAll(async () => {
  [database, cache] = await Promise.all([startTestDatabase(), startTestValkey()]);
  process.env.DATABASE_URL = database.appUrl;
  process.env.VALKEY_URL = cache.url;
  process.env.IDENTITY_ENCRYPTION_KEY = randomBytes(32).toString('base64');
  process.env.FOX_DROP_ENVIRONMENT = 'development';
  sql = new pg.Pool({ connectionString: database.appUrl });
  app = await createApiApp(ApiModule);
  await app.init();
  await app.getHttpAdapter().getInstance().ready();
  merchants = app.get(MerchantsService);
  azaz = (await sql.query("SELECT id FROM geo.cities WHERE code = 'AZ'")).rows[0].id;
  const fx = app.get(FxService);
  await fx.setCityCurrency(azaz, { currency: 'TRY', displayOrder: 1, enabled: true }, change);
  await fx.setBaseCurrency(azaz, 'TRY', change);
}, 300_000);

afterAll(async () => {
  await app?.close();
  await sql?.end();
  await Promise.all([database?.stop(), cache?.stop()]);
});

const newPhone = () => `+9639${randomInt(100_000_000).toString().padStart(8, '0')}`;

// Signs a number in on a new device and names the device (RA §5.2 item 5).
async function signIn(phone: string, deviceName: string) {
  const deviceId = randomUUID();
  await app.inject({ method: 'POST', url: '/v1/merchant/auth/code', payload: { phone, deviceId } });
  const code = app.get<DevelopmentCodeSender>(CODE_SENDER).lastCode(phone);
  const response = await app.inject({
    method: 'POST',
    url: '/v1/merchant/auth/sign-in',
    payload: { phone, deviceId, code },
  });
  expect(response.statusCode).toBe(200);
  const headers = { authorization: `Bearer ${response.json().accessToken}` };
  const named = await app.inject({
    method: 'PUT',
    url: '/v1/merchant/auth/device',
    headers,
    payload: { name: deviceName, platform: 'android', appVersion: '1.0.0' },
  });
  expect(named.statusCode).toBe(200);
  return { deviceId, headers };
}

// An active restaurant with a signed-in owner.
async function restaurant() {
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
  const phone = newPhone();
  const ownerId = await app
    .get(MerchantAccountsService)
    .addAccount(id, { role: 'owner', name: 'سامر', phone }, change);
  return { id, ownerId, owner: await signIn(phone, 'هاتف المالك') };
}

async function addCashier(owner: { headers: Record<string, string> }, phone = newPhone()) {
  const response = await app.inject({
    method: 'POST',
    url: '/v1/merchant/staff',
    headers: owner.headers,
    payload: { name: 'كاشير المساء', phone },
  });
  expect(response.statusCode).toBe(200);
  const cashier = response.json().staff.find((each: { phone: string }) => each.phone === phone) as {
    accountId: string;
  };
  return { phone, accountId: cashier.accountId };
}

describe('the owners’ staff (RA §14.1)', () => {
  it('adds a cashier who signs in, lists them with their devices, and removes them at once', async () => {
    const { owner, ownerId } = await restaurant();
    const { phone, accountId } = await addCashier(owner);
    const cashier = await signIn(phone, 'كاشير 1');

    const listed = await app.inject({ method: 'GET', url: '/v1/merchant/staff', ...owner });
    expect(listed.statusCode).toBe(200);
    expect(listed.json().staff).toMatchObject([
      { accountId: ownerId, role: 'owner', devices: 1 },
      { accountId, role: 'cashier', name: 'كاشير المساء', phone, devices: 1 },
    ]);
    expect(listed.json().staff[1].lastActiveAt).not.toBeNull();

    // RA §5.4: staff are the owners'.
    const refused = await app.inject({ method: 'GET', url: '/v1/merchant/staff', ...cashier });
    expect(refused.statusCode).toBe(403);
    expect(refused.json().error).toBe('owner_only');

    const removed = await app.inject({
      method: 'POST',
      url: `/v1/merchant/staff/${accountId}/remove`,
      ...owner,
    });
    expect(removed.statusCode).toBe(200);
    expect(removed.json().staff.map((each: { accountId: string }) => each.accountId)).toEqual([
      ownerId,
    ]);
    // Signed out at once (RA §14.1).
    const after = await app.inject({ method: 'GET', url: '/v1/merchant/auth/session', ...cashier });
    expect(after.statusCode).toBe(401);
    const { rows } = await sql.query(
      'SELECT end_reason FROM identity.app_sessions WHERE account_id = $1',
      [accountId],
    );
    expect(rows).toEqual([{ end_reason: 'account_removed' }]);
    const audit = await sql.query(
      "SELECT actor_type, actor_id FROM audit.events WHERE action = 'merchant_account.remove' AND target_id = $1",
      [accountId],
    );
    expect(audit.rows).toEqual([{ actor_type: 'merchant', actor_id: ownerId }]);

    // Gone: a second removal finds nobody.
    const again = await app.inject({
      method: 'POST',
      url: `/v1/merchant/staff/${accountId}/remove`,
      ...owner,
    });
    expect(again.statusCode).toBe(404);
  });

  it('never removes an owner (S5) and refuses a number of another restaurant (S6)', async () => {
    const { owner, ownerId } = await restaurant();
    const removed = await app.inject({
      method: 'POST',
      url: `/v1/merchant/staff/${ownerId}/remove`,
      ...owner,
    });
    expect(removed.statusCode).toBe(409);
    expect(removed.json().error).toBe('not_a_cashier');
    const { rows } = await sql.query(
      'SELECT removed_at FROM identity.merchant_accounts WHERE id = $1',
      [ownerId],
    );
    expect(rows).toEqual([{ removed_at: null }]);

    const other = await restaurant();
    const { phone } = await addCashier(other.owner);
    const taken = await app.inject({
      method: 'POST',
      url: '/v1/merchant/staff',
      headers: owner.headers,
      payload: { name: 'كاشير', phone },
    });
    expect(taken.statusCode).toBe(409);
    expect(taken.json().error).toBe('phone_taken');
  });
});

describe('the owners’ devices (RA §14.2)', () => {
  it('renames a device and signs it out, leaving its cashier', async () => {
    const { owner, ownerId } = await restaurant();
    const { phone, accountId } = await addCashier(owner);
    const cashier = await signIn(phone, 'كاشير 1');

    const listed = await app.inject({ method: 'GET', url: '/v1/merchant/devices', ...owner });
    expect(listed.statusCode).toBe(200);
    expect(listed.json().devices).toMatchObject([
      { deviceId: cashier.deviceId, name: 'كاشير 1', signedIn: true, thisDevice: false },
      { deviceId: owner.deviceId, name: 'هاتف المالك', signedIn: true, thisDevice: true },
    ]);

    const renamed = await app.inject({
      method: 'PUT',
      url: `/v1/merchant/devices/${cashier.deviceId}/name`,
      headers: owner.headers,
      payload: { name: 'تابلت المطبخ' },
    });
    expect(renamed.statusCode).toBe(200);
    expect(
      renamed
        .json()
        .devices.find((each: { deviceId: string }) => each.deviceId === cashier.deviceId).name,
    ).toBe('تابلت المطبخ');
    const audit = await sql.query(
      "SELECT actor_id, changes FROM audit.events WHERE action = 'merchant_device.rename' AND actor_id = $1",
      [ownerId],
    );
    expect(audit.rows).toEqual([
      { actor_id: ownerId, changes: { name: { before: 'كاشير 1', after: 'تابلت المطبخ' } } },
    ]);

    // RA §5.4: a cashier renames nothing.
    const refused = await app.inject({
      method: 'PUT',
      url: `/v1/merchant/devices/${cashier.deviceId}/name`,
      headers: cashier.headers,
      payload: { name: 'جهازي' },
    });
    expect(refused.statusCode).toBe(403);
    const unknown = await app.inject({
      method: 'PUT',
      url: `/v1/merchant/devices/${randomUUID()}/name`,
      headers: owner.headers,
      payload: { name: 'جهاز' },
    });
    expect(unknown.statusCode).toBe(404);
    expect(unknown.json().error).toBe('unknown_device');

    const signedOut = await app.inject({
      method: 'POST',
      url: `/v1/merchant/devices/${cashier.deviceId}/sign-out`,
      ...owner,
    });
    expect(signedOut.statusCode).toBe(200);
    expect(
      signedOut
        .json()
        .devices.find((each: { deviceId: string }) => each.deviceId === cashier.deviceId).signedIn,
    ).toBe(false);
    const after = await app.inject({ method: 'GET', url: '/v1/merchant/auth/session', ...cashier });
    expect(after.statusCode).toBe(401);
    const { rows } = await sql.query(
      'SELECT end_reason FROM identity.app_sessions WHERE device_id = $1',
      [cashier.deviceId],
    );
    expect(rows).toEqual([{ end_reason: 'signed_out_by_owner' }]);
    // The cashier stays.
    const staff = await app.inject({ method: 'GET', url: '/v1/merchant/staff', ...owner });
    expect(staff.json().staff[1]).toMatchObject({ accountId, devices: 0 });

    const again = await app.inject({
      method: 'POST',
      url: `/v1/merchant/devices/${cashier.deviceId}/sign-out`,
      ...owner,
    });
    expect(again.statusCode).toBe(409);
    expect(again.json().error).toBe('no_device');
  });

  it('keeps a terminated restaurant’s owners out (RA §5.5)', async () => {
    const { id, owner } = await restaurant();
    await sql.query(
      "UPDATE merchants.restaurants SET account_status = 'terminated' WHERE id = $1",
      [id],
    );
    for (const url of ['/v1/merchant/staff', '/v1/merchant/devices']) {
      const response = await app.inject({ method: 'GET', url, ...owner });
      expect(response.statusCode).toBe(403);
      expect(response.json().error).toBe('restaurant_terminated');
    }
  });
});
