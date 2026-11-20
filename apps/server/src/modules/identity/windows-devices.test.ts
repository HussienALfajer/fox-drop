import 'reflect-metadata';
import { generateKeyPairSync, randomBytes, randomInt, randomUUID, sign } from 'node:crypto';
import type { NestFastifyApplication } from '@nestjs/platform-fastify';
import pg from 'pg';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { ApiModule } from '../../api.module.js';
import { startTestDatabase, type TestDatabase } from '../../database/test-database.js';
import { createApiApp } from '../../http/create-api-app.js';
import { startTestValkey, type TestValkey } from '../../valkey/test-valkey.js';
import { FxService } from '../fx/index.js';
import { MerchantsService } from '../merchants/index.js';
import { SettingsService } from '../settings/index.js';
import { CODE_SENDER, type DevelopmentCodeSender, MerchantAccountsService } from './index.js';
import { codeRequestMessage, PAIRING_ATTEMPTS_PER_HOUR } from './windows-devices.service.js';

// RA §4.3, architecture §8.3.3 item 1 (slice 2.44; owner decision
// 2026-11-20): an owner's pairing code registers a Windows PC, whose signed
// code requests pass where App Check is required.
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
// Each test's own address, so the registrations' IP limit stays apart.
const newIp = () => `198.51.100.${randomInt(1, 255)}`;

async function appCheckRequired(on: boolean) {
  await app.get(SettingsService).update('otp.app_check_required', {}, on, {
    editor: { id: '0190f3a0-0000-7000-8000-000000000001', roles: ['OWN'] },
    context: { ipAddress: null, device: null },
    reason: 'test',
  });
}

async function signIn(phone: string, deviceId = randomUUID()) {
  await app.inject({ method: 'POST', url: '/v1/merchant/auth/code', payload: { phone, deviceId } });
  const code = app.get<DevelopmentCodeSender>(CODE_SENDER).lastCode(phone);
  const response = await app.inject({
    method: 'POST',
    url: '/v1/merchant/auth/sign-in',
    payload: { phone, deviceId, code },
  });
  expect(response.statusCode).toBe(200);
  return { headers: { authorization: `Bearer ${response.json().accessToken}` } };
}

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
  const accounts = app.get(MerchantAccountsService);
  const ownerPhone = newPhone();
  const cashierPhone = newPhone();
  await accounts.addAccount(id, { role: 'owner', name: 'سامر', phone: ownerPhone }, change);
  await accounts.addAccount(id, { role: 'cashier', name: 'كاشير', phone: cashierPhone }, change);
  return { id, ownerPhone, cashierPhone, owner: await signIn(ownerPhone) };
}

async function pairingCode(owner: { headers: Record<string, string> }): Promise<string> {
  const response = await app.inject({
    method: 'POST',
    url: '/v1/merchant/devices/windows-pairing',
    ...owner,
  });
  expect(response.statusCode).toBe(200);
  expect(response.headers['cache-control']).toBe('no-store');
  expect(response.json().code).toMatch(/^\d{8}$/);
  return response.json().code;
}

// A PC's key pair, as the app makes it: the raw public key in base64.
function newKey() {
  const { publicKey, privateKey } = generateKeyPairSync('ed25519');
  const raw = Buffer.from(publicKey.export({ format: 'jwk' }).x!, 'base64url');
  return { publicKey: raw.toString('base64'), privateKey };
}

function register(code: string, deviceId: string, publicKey: string, ip = newIp()) {
  return app.inject({
    method: 'POST',
    url: '/v1/merchant/auth/windows-registration',
    remoteAddress: ip,
    payload: { code, deviceId, publicKey },
  });
}

function codeRequest(
  phone: string,
  deviceId: string,
  privateKey: ReturnType<typeof newKey>['privateKey'] | null,
  signedAt = new Date().toISOString(),
) {
  return app.inject({
    method: 'POST',
    url: '/v1/merchant/auth/code',
    remoteAddress: newIp(),
    payload: {
      phone,
      deviceId,
      platform: 'windows',
      ...(privateKey && {
        deviceSignature: {
          signedAt,
          signature: sign(
            null,
            Buffer.from(codeRequestMessage(deviceId, signedAt)),
            privateKey,
          ).toString('base64'),
        },
      }),
    },
  });
}

describe('the owner’s pairing code', () => {
  it('is an owner’s only, audited without the code', async () => {
    const { cashierPhone } = await restaurant();
    const cashier = await signIn(cashierPhone);
    const refused = await app.inject({
      method: 'POST',
      url: '/v1/merchant/devices/windows-pairing',
      ...cashier,
    });
    expect(refused.statusCode).toBe(403);
    expect(refused.json()).toMatchObject({ error: 'owner_only' });

    const { owner } = await restaurant();
    const code = await pairingCode(owner);
    const audited = await sql.query(
      "SELECT changes::text FROM audit.events WHERE action = 'merchant_device.windows_pairing'",
    );
    expect(audited.rows.length).toBeGreaterThan(0);
    expect(JSON.stringify(audited.rows)).not.toContain(code);
    const stored = await sql.query('SELECT code_hash FROM identity.windows_pairings');
    expect(JSON.stringify(stored.rows)).not.toContain(code);
  });
});

describe('the registration', () => {
  it('registers a PC once per code, and the same PC again with a new code and key', async () => {
    const { owner, id } = await restaurant();
    const deviceId = randomUUID();
    const first = newKey();
    const code = await pairingCode(owner);
    const registered = await register(code, deviceId, first.publicKey);
    expect(registered.statusCode).toBe(200);
    expect(registered.json()).toEqual({ status: 'registered' });

    const reused = await register(code, randomUUID(), newKey().publicKey);
    expect(reused.statusCode).toBe(400);
    expect(reused.json()).toMatchObject({ error: 'invalid_code' });

    const second = newKey();
    expect((await register(await pairingCode(owner), deviceId, second.publicKey)).statusCode).toBe(
      200,
    );
    const rows = await sql.query(
      'SELECT restaurant_id, public_key FROM identity.windows_devices WHERE device_id = $1',
      [deviceId],
    );
    expect(rows.rows).toEqual([{ restaurant_id: id, public_key: second.publicKey }]);
  });

  it('refuses a wrong or expired code and a key of another length', async () => {
    const { owner } = await restaurant();
    const wrong = await register('00000000', randomUUID(), newKey().publicKey);
    expect(wrong.json()).toMatchObject({ error: 'invalid_code' });

    const code = await pairingCode(owner);
    const shortKey = await register(code, randomUUID(), randomBytes(16).toString('base64'));
    expect(shortKey.statusCode).toBe(400);
    expect(shortKey.json()).toMatchObject({ error: 'invalid_key' });

    await sql.query(
      "UPDATE identity.windows_pairings SET expires_at = now() - interval '1 second' WHERE used_at IS NULL",
    );
    const expired = await register(code, randomUUID(), newKey().publicKey);
    expect(expired.json()).toMatchObject({ error: 'invalid_code' });
  });

  it('lets one IP address try PAIRING_ATTEMPTS_PER_HOUR codes an hour', async () => {
    const ip = '203.0.113.9';
    for (let i = 0; i < PAIRING_ATTEMPTS_PER_HOUR; i += 1) {
      expect((await register('12345678', randomUUID(), newKey().publicKey, ip)).statusCode).toBe(
        400,
      );
    }
    const limited = await register('12345678', randomUUID(), newKey().publicKey, ip);
    expect(limited.statusCode).toBe(429);
    expect(limited.json()).toMatchObject({ error: 'too_many' });
    expect(Number(limited.headers['retry-after'])).toBeGreaterThan(0);
  });
});

describe('a registered PC’s code request (architecture §8.3.3 item 1)', () => {
  it('passes where App Check is required only with a fresh signature of its own key', async () => {
    // The cashier's number: the owner's had a code at sign-in, within its
    // resend wait.
    const { owner, cashierPhone: phone } = await restaurant();
    const deviceId = randomUUID();
    const key = newKey();
    expect((await register(await pairingCode(owner), deviceId, key.publicKey)).statusCode).toBe(
      200,
    );
    await appCheckRequired(true);
    try {
      expect((await codeRequest(phone, deviceId, key.privateKey)).statusCode).toBe(200);

      const refusals = [
        await codeRequest(phone, deviceId, null),
        await codeRequest(phone, deviceId, newKey().privateKey),
        await codeRequest(phone, randomUUID(), key.privateKey),
        await codeRequest(
          phone,
          deviceId,
          key.privateKey,
          new Date(Date.now() - 6 * 60 * 1000).toISOString(),
        ),
      ];
      for (const refused of refusals) {
        expect(refused.statusCode).toBe(403);
        expect(refused.json()).toMatchObject({ error: 'app_check_failed' });
      }
    } finally {
      await appCheckRequired(false);
    }
  });
});
