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
import { GeoService, type Point } from '../geo/index.js';
import { CODE_SENDER, type DevelopmentCodeSender } from '../identity/index.js';
import { MerchantsService, type NewRestaurant } from '../merchants/index.js';

// CU §9.6, U18 (slice 2.28b): the heart and «المفضلة», kept with the account
// on a fresh database. No OSRM runs, so distances are the straight line × 1.3.
let database: TestDatabase;
let cache: TestValkey;
let app: NestFastifyApplication;
let sql: pg.Pool;
let merchants: MerchantsService;
let azaz: string;
let openPlace: string;
let closedPlace: string;
let farPlace: string;
let hiddenPlace: string;

const system = { type: 'system', id: null, role: null } as const;
const change = { actor: system, context: { ipAddress: null, device: null }, reason: 'test' };
const centre = { latitude: 36.587, longitude: 37.046 };
const allWeek = [0, 1, 2, 3, 4, 5, 6].map((weekday) => ({ weekday, opensAt: 0, closesAt: 0 }));

function square({ latitude, longitude }: Point, half = 0.03): Point[] {
  return [
    { latitude: latitude - half, longitude: longitude - half },
    { latitude: latitude - half, longitude: longitude + half },
    { latitude: latitude + half, longitude: longitude + half },
    { latitude: latitude + half, longitude: longitude - half },
  ];
}

async function restaurant(name: string, extra: Partial<NewRestaurant> = {}) {
  const id = await merchants.createRestaurant(
    azaz,
    {
      nameAr: name,
      location: centre,
      coverage: { kind: 'radius', radiusMetres: 3000 },
      minimumOrder: { amount: 10_000n, currency: 'TRY' },
      commissionBp: 1500,
      defaultPrepMin: 20,
      ...extra,
    },
    change,
  );
  await merchants.setAccountStatus(id, 'active', change);
  return id;
}

// One phone signed in on a device: the same phone on another device is the
// same account. The number's earlier code is moved past its resend wait
// (otp.resend_after_sec), so the second phone can ask for one at once.
async function signedIn(phone: string): Promise<Record<string, string>> {
  const deviceId = randomUUID();
  await sql.query(
    "UPDATE identity.app_sign_in_codes SET created_at = created_at - interval '2 minutes' WHERE party = 'customer'",
  );
  await app.inject({ method: 'POST', url: '/v1/customer/auth/code', payload: { phone, deviceId } });
  const code = app.get<DevelopmentCodeSender>(CODE_SENDER).lastCode(phone);
  const answer = await app.inject({
    method: 'POST',
    url: '/v1/customer/auth/sign-in',
    payload: { phone, deviceId, code },
  });
  return { authorization: `Bearer ${answer.json().accessToken}` };
}

const phoneNumber = () => `+9639${randomInt(100_000_000).toString().padStart(8, '0')}`;
const point = `latitude=${centre.latitude}&longitude=${centre.longitude}`;

const heart = (headers: Record<string, string>, id: string, method: 'PUT' | 'DELETE' = 'PUT') =>
  app.inject({ method, url: `/v1/customer/favourites/${id}`, headers });

async function favourites(headers: Record<string, string>): Promise<string[]> {
  const response = await app.inject({
    method: 'GET',
    url: `/v1/customer/favourites?${point}`,
    headers,
  });
  expect(response.statusCode).toBe(200);
  const { restaurants } = response.json() as {
    restaurants: { id: string; favourite: boolean; state: { state: string } }[];
  };
  expect(restaurants.every((each) => each.favourite)).toBe(true);
  return restaurants.map((each) => each.id);
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
  merchants = app.get(MerchantsService);
  azaz = (await sql.query("SELECT id FROM geo.cities WHERE code = 'AZ'")).rows[0].id;
  const fx = app.get(FxService);
  await fx.setCityCurrency(azaz, { currency: 'TRY', displayOrder: 1, enabled: true }, change);
  await fx.setBaseCurrency(azaz, 'TRY', change);
  const geo = app.get(GeoService);
  await geo.createZone(azaz, { name: 'المركز', area: square(centre), active: true }, change);
  await geo.setDeliveryFeeRule(
    azaz,
    { kind: 'flat', currency: 'TRY', flatFee: 4000n, minimumFee: null, freeDeliveryFrom: null },
    change,
  );
  closedPlace = await restaurant('مطعم الليل');
  openPlace = await restaurant('مطعم النهار');
  await merchants.setWeeklySchedule(openPlace, allWeek, change);
  // Far east, outside its 1 km radius of the point.
  farPlace = await restaurant('مطعم بعيد', {
    location: { latitude: centre.latitude, longitude: centre.longitude + 0.02 },
    coverage: { kind: 'radius', radiusMetres: 1000 },
  });
  hiddenPlace = await restaurant('مطعم مخفي');
  await merchants.setAccountStatus(hiddenPlace, 'suspended', change);
}, 120_000);

afterAll(async () => {
  await app?.close();
  await sql?.end();
  await Promise.all([database?.stop(), cache?.stop()]);
});

describe('favourites (CU §9.6)', () => {
  it('asks a guest to sign in', async () => {
    for (const response of [
      await app.inject({ method: 'GET', url: `/v1/customer/favourites?${point}` }),
      await app.inject({ method: 'PUT', url: `/v1/customer/favourites/${openPlace}` }),
      await app.inject({ method: 'DELETE', url: `/v1/customer/favourites/${openPlace}` }),
    ]) {
      expect(response.statusCode).toBe(401);
    }
  });

  it('keeps the hearts with the account, on every device, open first and those that deliver only', async () => {
    const phone = phoneNumber();
    const phoneOne = await signedIn(phone);
    expect(await favourites(phoneOne)).toEqual([]);

    for (const id of [openPlace, closedPlace, farPlace]) {
      const response = await heart(phoneOne, id);
      expect(response.statusCode).toBe(200);
      expect(response.json()).toEqual({ restaurantId: id, favourite: true });
    }
    // A repeat changes nothing.
    expect((await heart(phoneOne, openPlace)).statusCode).toBe(200);
    // One customers do not see cannot be hearted.
    const hidden = await heart(phoneOne, hiddenPlace);
    expect(hidden.statusCode).toBe(404);
    expect(hidden.json().error).toBe('unknown_restaurant');

    // Another phone signed in on the same number: the same favourites; the
    // far one does not deliver to the point and is left out.
    const phoneTwo = await signedIn(phone);
    expect(await favourites(phoneTwo)).toEqual([openPlace, closedPlace]);

    // The cards, the page and the search carry the heart.
    const list = await app.inject({
      method: 'GET',
      url: `/v1/customer/restaurants?${point}`,
      headers: phoneTwo,
    });
    const cards = list.json().restaurants as { id: string; favourite: boolean }[];
    expect(cards.find((each) => each.id === openPlace)?.favourite).toBe(true);
    const page = await app.inject({
      method: 'GET',
      url: `/v1/customer/restaurants/${openPlace}?${point}`,
      headers: phoneTwo,
    });
    expect(page.json().favourite).toBe(true);
    const search = await app.inject({
      method: 'GET',
      url: `/v1/customer/search?${point}&q=${encodeURIComponent('مطعم')}`,
      headers: phoneTwo,
    });
    const found = search.json().restaurants as { id: string; favourite: boolean }[];
    expect(found.find((each) => each.id === closedPlace)?.favourite).toBe(true);
    // A guest's cards have none.
    const guest = await app.inject({ method: 'GET', url: `/v1/customer/restaurants?${point}` });
    expect(
      (guest.json().restaurants as { favourite: boolean }[]).every((each) => !each.favourite),
    ).toBe(true);

    // Removing from one phone removes it on the other; a repeat changes
    // nothing, and the heart again brings it back.
    const removed = await heart(phoneTwo, openPlace, 'DELETE');
    expect(removed.json()).toEqual({ restaurantId: openPlace, favourite: false });
    expect((await heart(phoneTwo, openPlace, 'DELETE')).statusCode).toBe(200);
    expect(await favourites(phoneOne)).toEqual([closedPlace]);
    await heart(phoneOne, openPlace);
    expect(await favourites(phoneTwo)).toEqual([openPlace, closedPlace]);

    // Another customer has none of them.
    expect(await favourites(await signedIn(phoneNumber()))).toEqual([]);
  });
});
