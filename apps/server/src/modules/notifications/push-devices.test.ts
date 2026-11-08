import 'reflect-metadata';
import { randomBytes, randomInt, randomUUID } from 'node:crypto';
import type { NestFastifyApplication } from '@nestjs/platform-fastify';
import pg from 'pg';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { ApiModule } from '../../api.module.js';
import { startTestDatabase, type TestDatabase } from '../../database/test-database.js';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { createApiApp } from '../../http/create-api-app.js';
import { startTestValkey, type TestValkey } from '../../valkey/test-valkey.js';
import { CaptainsService } from '../captains/index.js';
import { FxService } from '../fx/index.js';
import {
  CaptainAccountsService,
  CODE_SENDER,
  type DevelopmentCodeSender,
  MerchantAccountsService,
} from '../identity/index.js';
import { MerchantsService } from '../merchants/index.js';
import { PushDevices } from './push-devices.js';
import { PushQueue } from './push-queue.js';

// Architecture §8.1: each app installation registers its push token; a push
// reaches the live tokens of its recipient's open sessions only.
let database: TestDatabase;
let cache: TestValkey;
let app: NestFastifyApplication;
let sql: pg.Pool;
let devices: PushDevices;
let restaurant: string;

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
  devices = app.get(PushDevices);
  await app.init();
  const azaz = (await sql.query("SELECT id FROM geo.cities WHERE code = 'AZ'")).rows[0].id;
  const fx = app.get(FxService);
  await fx.setCityCurrency(azaz, { currency: 'TRY', displayOrder: 1, enabled: true }, change);
  await fx.setBaseCurrency(azaz, 'TRY', change);
  const merchants = app.get(MerchantsService);
  restaurant = await merchants.createRestaurant(
    azaz,
    {
      nameAr: 'مطعم الإشعارات',
      location: { latitude: 36.587, longitude: 37.046 },
      coverage: { kind: 'radius', radiusMetres: 1000 },
      minimumOrder: { amount: 10_000n, currency: 'TRY' },
      commissionBp: 1500,
      defaultPrepMin: 20,
    },
    change,
  );
  await merchants.setAccountStatus(restaurant, 'active', change);
}, 300_000);

afterAll(async () => {
  await app?.close();
  await sql?.end();
  await Promise.all([database?.stop(), cache?.stop()]);
});

const phoneNumber = () => `+9639${randomInt(100_000_000).toString().padStart(8, '0')}`;

async function signIn(party: 'customer' | 'merchant' | 'captain', phone: string) {
  const deviceId = randomUUID();
  await app.inject({ method: 'POST', url: `/v1/${party}/auth/code`, payload: { phone, deviceId } });
  const code = app.get<DevelopmentCodeSender>(CODE_SENDER).lastCode(phone);
  const answer = await app.inject({
    method: 'POST',
    url: `/v1/${party}/auth/sign-in`,
    payload: { phone, deviceId, code },
  });
  expect(answer.statusCode).toBe(200);
  return { authorization: `Bearer ${answer.json().accessToken}` };
}

async function register(
  party: 'customer' | 'merchant' | 'captain',
  headers: Record<string, string>,
  token: string,
) {
  const answer = await app.inject({
    method: 'PUT',
    url: `/v1/${party}/push-token`,
    headers,
    payload: { token, platform: 'android' },
  });
  expect(answer.statusCode).toBe(200);
  expect(answer.json()).toEqual({ status: 'registered' });
}

const accountOf = async (headers: Record<string, string>) =>
  (await app.inject({ method: 'GET', url: '/v1/customer/auth/session', headers })).json()
    .accountId as string;

const tokens = async (recipient: Parameters<PushDevices['targets']>[0]) =>
  (await devices.targets(recipient)).map((target) => target.token).sort();

describe('push tokens (architecture §8.1)', () => {
  it("reaches a customer's signed-in device, not once it signed out", async () => {
    const device = await signIn('customer', phoneNumber());
    const accountId = await accountOf(device);
    await register('customer', device, 'token-a');
    // The app registers again at every start and when Firebase renews it.
    await register('customer', device, 'token-a2');
    expect(await tokens({ party: 'customer', accountId })).toEqual(['token-a2']);

    await app.inject({ method: 'POST', url: '/v1/customer/auth/sign-out', headers: device });
    expect(await tokens({ party: 'customer', accountId })).toEqual([]);
  });

  it('moves a token to the session that registers it last', async () => {
    const one = await signIn('customer', phoneNumber());
    const other = await signIn('customer', phoneNumber());
    await register('customer', one, 'token-shared');
    await register('customer', other, 'token-shared');
    expect(await tokens({ party: 'customer', accountId: await accountOf(one) })).toEqual([]);
    expect(await tokens({ party: 'customer', accountId: await accountOf(other) })).toEqual([
      'token-shared',
    ]);
    const { rows } = await sql.query(
      "SELECT end_reason FROM notifications.push_devices WHERE token = 'token-shared' ORDER BY registered_at",
    );
    expect(rows.map((row) => row.end_reason)).toEqual(['token_moved', null]);
  });

  it("reaches a restaurant's devices, or its owners' alone (RA §16)", async () => {
    const accounts = app.get(MerchantAccountsService);
    const ownerPhone = phoneNumber();
    const cashierPhone = phoneNumber();
    await accounts.addAccount(
      restaurant,
      { role: 'owner', name: 'مالك', phone: ownerPhone },
      change,
    );
    await accounts.addAccount(
      restaurant,
      { role: 'cashier', name: 'كاشير', phone: cashierPhone },
      change,
    );
    await register('merchant', await signIn('merchant', ownerPhone), 'token-owner');
    await register('merchant', await signIn('merchant', cashierPhone), 'token-cashier');
    expect(await tokens({ party: 'merchant', restaurantId: restaurant, owners: false })).toEqual([
      'token-cashier',
      'token-owner',
    ]);
    expect(await tokens({ party: 'merchant', restaurantId: restaurant, owners: true })).toEqual([
      'token-owner',
    ]);
  });

  it("reaches a captain's device, and forgets a token Firebase no longer knows", async () => {
    const phone = phoneNumber();
    const azaz = (await sql.query("SELECT id FROM geo.cities WHERE code = 'AZ'")).rows[0].id;
    const captainId = await app.get(CaptainsService).createCaptain(
      azaz,
      {
        name: 'كابتن الإشعارات',
        vehicle: 'motorbike',
        plateNumber: randomUUID().slice(0, 6),
        custodyLimit: { amount: 300_000n, currency: 'TRY' },
      },
      change,
    );
    await app.get(CaptainAccountsService).addAccount(captainId, phone, change);
    await register('captain', await signIn('captain', phone), 'token-captain');
    expect(await tokens({ party: 'captain', captainId })).toEqual(['token-captain']);

    await devices.invalidate(app.get<Database>(DATABASE).db, ['token-captain'], new Date());
    expect(await tokens({ party: 'captain', captainId })).toEqual([]);
  });

  it("answers the customer's stored notifications (CU §13)", async () => {
    const device = await signIn('customer', phoneNumber());
    const accountId = await accountOf(device);
    await app.get(PushQueue).enqueue(
      app.get<Database>(DATABASE).db,
      [
        {
          source: `test:${randomUUID()}`,
          recipient: { party: 'customer', accountId },
          templateKey: 'customer.delivered',
          body: 'تم التسليم. قيّم طلبك',
          level: 'default',
          priority: 'normal',
          data: { target: 'order', orderId: 'order-1' },
        },
      ],
      new Date(),
    );
    const answer = await app.inject({
      method: 'GET',
      url: '/v1/customer/notifications',
      headers: device,
    });
    expect(answer.statusCode).toBe(200);
    expect(answer.json().notifications).toEqual([
      {
        id: expect.any(String),
        at: expect.any(String),
        body: 'تم التسليم. قيّم طلبك',
        data: { target: 'order', orderId: 'order-1' },
      },
    ]);
  });

  it('refuses a call without a session', async () => {
    const answer = await app.inject({
      method: 'PUT',
      url: '/v1/customer/push-token',
      payload: { token: 'x', platform: 'android' },
    });
    expect(answer.statusCode).toBe(401);
  });
});
