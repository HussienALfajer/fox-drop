import 'reflect-metadata';
import { randomBytes, randomInt, randomUUID } from 'node:crypto';
import type { NestFastifyApplication } from '@nestjs/platform-fastify';
import pg from 'pg';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { ApiModule } from '../../api.module.js';
import { startTestDatabase, type TestDatabase } from '../../database/test-database.js';
import { createApiApp } from '../../http/create-api-app.js';
import { startTestValkey, type TestValkey } from '../../valkey/test-valkey.js';
import { CaptainsService } from '../captains/index.js';
import { FxService } from '../fx/index.js';
import { GeoService, type Point } from '../geo/index.js';
import { CODE_SENDER, type DevelopmentCodeSender } from '../identity/index.js';
import { MerchantsService } from '../merchants/index.js';
import { SettingsService } from '../settings/index.js';

// AP §9.12.6: while dispatch.capacity_check is on, the quote, and so the
// order, is refused without an eligible captain within
// dispatch.search_radius_km (3) of the restaurant: «الضغط عالٍ الآن، جرّب بعد
// دقائق» (CU §10.6). Eligible is online and receiving offers, with a vehicle
// allowed for the trip.
let database: TestDatabase;
let cache: TestValkey;
let app: NestFastifyApplication;
let sql: pg.Pool;
let azaz: string;
let settings: SettingsService;
let captains: CaptainsService;
let restaurant: string;
let item: string;

const system = { type: 'system', id: null, role: null } as const;
const change = { actor: system, context: { ipAddress: null, device: null }, reason: 'test' };
const bySystem = { editor: 'system', context: change.context, reason: 'test' } as const;
const centre = { latitude: 36.587, longitude: 37.046 };
// About 330 m north of the restaurant, inside its 1 km.
const customer = { latitude: 36.59, longitude: 37.046 };
const allWeek = [0, 1, 2, 3, 4, 5, 6].map((weekday) => ({ weekday, opensAt: 0, closesAt: 0 }));

function square({ latitude, longitude }: Point, half = 0.05): Point[] {
  return [
    { latitude: latitude - half, longitude: longitude - half },
    { latitude: latitude - half, longitude: longitude + half },
    { latitude: latitude + half, longitude: longitude + half },
    { latitude: latitude + half, longitude: longitude - half },
  ];
}

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
  settings = app.get(SettingsService);
  captains = app.get(CaptainsService);
  azaz = (await sql.query("SELECT id FROM geo.cities WHERE code = 'AZ'")).rows[0].id;
  const fx = app.get(FxService);
  await fx.setCityCurrency(azaz, { currency: 'TRY', displayOrder: 1, enabled: true }, change);
  await fx.setBaseCurrency(azaz, 'TRY', change);
  // AP §9.12.5: a pay table in force, which placing needs (captain_pay_unset).
  const payRate = {
    basePay: 2500n,
    includedMetres: 3000,
    perExtraKm: 500n,
    waitingPerMinute: 0n,
    minimumPay: 2500n,
  };
  await app.get(CaptainsService).setPayTable(
    azaz,
    {
      currency: 'TRY',
      rates: { walking: payRate, bicycle: payRate, motorbike: payRate, car: payRate },
    },
    change,
  );
  await settings.update(
    'currency.<code>.rounding_unit',
    { cityId: azaz, parameter: 'TRY' },
    { amountMinor: 500 },
    bySystem,
  );
  const geo = app.get(GeoService);
  await geo.createZone(azaz, { name: 'المركز', area: square(centre), active: true }, change);
  await geo.setDeliveryFeeRule(
    azaz,
    { kind: 'flat', currency: 'TRY', flatFee: 4000n, minimumFee: null, freeDeliveryFrom: null },
    change,
  );
  const merchants = app.get(MerchantsService);
  restaurant = await merchants.createRestaurant(
    azaz,
    {
      nameAr: 'مطعم الاختبار',
      location: centre,
      coverage: { kind: 'radius', radiusMetres: 1000 },
      minimumOrder: { amount: 10_000n, currency: 'TRY' },
      commissionBp: 1500,
      defaultPrepMin: 20,
    },
    change,
  );
  await merchants.setAccountStatus(restaurant, 'active', change);
  await merchants.setWeeklySchedule(restaurant, allWeek, change);
  const category = await merchants.addCategory(restaurant, { name: 'وجبات' }, change);
  item = await merchants.addItem(
    restaurant,
    { categoryId: category, name: 'شاورما', price: { amount: 12_000n, currency: 'TRY' } },
    change,
  );
}, 300_000);

afterAll(async () => {
  await app?.close();
  await sql?.end();
  await Promise.all([database?.stop(), cache?.stop()]);
});

const problems = async () => {
  const answer = await app.inject({
    method: 'POST',
    url: '/v1/customer/quote',
    payload: {
      restaurantId: restaurant,
      location: customer,
      lines: [{ itemId: item, optionIds: [], quantity: 1, note: null, knownUnitPrice: '12000' }],
      payIn: null,
      appVersion: '1.0.0',
    },
  });
  return (answer.json().problems as { code: string }[]).map((entry) => entry.code);
};

// A motorbike captain online at the point, its live position written.
async function onlineAt(point: Point): Promise<string> {
  const id = await captains.createCaptain(
    azaz,
    {
      name: 'كابتن الاختبار',
      vehicle: 'motorbike',
      plateNumber: randomUUID().slice(0, 6),
      custodyLimit: { amount: 300_000n, currency: 'TRY' },
    },
    change,
  );
  const now = new Date();
  await captains.goOnline(id, { appVersion: '1.0.0', simulatedLocation: false }, now);
  await captains.recordLocations(
    id,
    [{ ...point, accuracyMetres: 8, recordedAt: now, simulated: false }],
    new Date(now.getTime() + 1),
  );
  return id;
}

// Each case leaves no captain online and every setting as it found it.
describe('the capacity check (AP §9.12.6)', () => {
  it('refuses the quote without any captain online', async () => {
    expect(await problems()).toContain('no_captain_nearby');
  });

  it('passes it with an eligible captain near the restaurant, and refuses one too far', async () => {
    // About 5.5 km east, beyond the 3 km radius.
    const far = await onlineAt({ latitude: 36.587, longitude: 37.108 });
    expect(await problems()).toContain('no_captain_nearby');
    await captains.goOffline(far, new Date());
    const near = await onlineAt({ latitude: 36.588, longitude: 37.047 });
    expect(await problems()).not.toContain('no_captain_nearby');
    await captains.goOffline(near, new Date());
    expect(await problems()).toContain('no_captain_nearby');
  });

  it('leaves out a captain whose vehicle is not allowed for the trip', async () => {
    const near = await onlineAt({ latitude: 36.588, longitude: 37.047 });
    await settings.update('dispatch.max_distance_km.motorbike', { cityId: azaz }, 0.1, bySystem);
    expect(await problems()).toContain('no_captain_nearby');
    await settings.reset('dispatch.max_distance_km.motorbike', { cityId: azaz }, bySystem);
    expect(await problems()).not.toContain('no_captain_nearby');
    await captains.goOffline(near, new Date());
  });

  it('leaves out a suspended captain', async () => {
    const near = await onlineAt({ latitude: 36.588, longitude: 37.047 });
    await captains.setStatus(near, 'suspended', change, new Date());
    expect(await problems()).toContain('no_captain_nearby');
    await captains.setStatus(near, 'terminated', change, new Date());
  });

  it('refuses the order at placing, and places it once a captain is near', async () => {
    const phone = `+9639${randomInt(100_000_000).toString().padStart(8, '0')}`;
    const deviceId = randomUUID();
    await app.inject({
      method: 'POST',
      url: '/v1/customer/auth/code',
      payload: { phone, deviceId },
    });
    const code = app.get<DevelopmentCodeSender>(CODE_SENDER).lastCode(phone);
    const signIn = await app.inject({
      method: 'POST',
      url: '/v1/customer/auth/sign-in',
      payload: { phone, deviceId, code },
    });
    const lines = [
      { itemId: item, optionIds: [], quantity: 1, note: null, knownUnitPrice: '12000' },
    ];
    const order = async () => {
      const quote = await app.inject({
        method: 'POST',
        url: '/v1/customer/quote',
        payload: {
          restaurantId: restaurant,
          location: customer,
          lines,
          payIn: null,
          appVersion: '1.0.0',
        },
      });
      return app.inject({
        method: 'POST',
        url: '/v1/customer/orders',
        headers: {
          authorization: `Bearer ${signIn.json().accessToken}`,
          'idempotency-key': randomUUID(),
        },
        payload: {
          restaurantId: restaurant,
          lines,
          payIn: null,
          appVersion: '1.0.0',
          quoteVersion: quote.json().version,
          addressId: null,
          unsavedAddress: {
            location: customer,
            street: 'شارع السوق',
            floor: null,
            landmark: 'قرب الجامع',
            contactPhone: null,
            recipientName: null,
            directions: null,
          },
          note: null,
        },
      });
    };
    const refused = await order();
    expect(refused.statusCode).toBe(409);
    expect(refused.json().error).toBe('order_blocked');
    expect(refused.json().quote.problems).toContainEqual(
      expect.objectContaining({ code: 'no_captain_nearby' }),
    );
    const near = await onlineAt({ latitude: 36.588, longitude: 37.047 });
    expect((await order()).statusCode).toBe(201);
    await captains.goOffline(near, new Date());
  });

  it('does not run while dispatch.capacity_check is off', async () => {
    await settings.update('dispatch.capacity_check', { cityId: azaz }, false, bySystem);
    expect(await problems()).not.toContain('no_captain_nearby');
    await settings.reset('dispatch.capacity_check', { cityId: azaz }, bySystem);
  });
});
