import 'reflect-metadata';
import { randomBytes, randomUUID } from 'node:crypto';
import type { NestFastifyApplication } from '@nestjs/platform-fastify';
import pg from 'pg';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { ApiModule } from '../../api.module.js';
import { DATABASE } from '../../database/database.module.js';
import { startTestDatabase, type TestDatabase } from '../../database/test-database.js';
import { createApiApp } from '../../http/create-api-app.js';
import { startTestValkey, type TestValkey } from '../../valkey/test-valkey.js';
import { CategoriesService } from '../content/index.js';
import { FxService } from '../fx/index.js';
import { GeoService, type Point } from '../geo/index.js';
import { ADMIN_SESSION_COOKIE, AdminSessionsService } from '../identity/index.js';
import { MerchantsService, type NewRestaurant } from '../merchants/index.js';

// CU §8.3 and AP §9.17 (slice 2.28a): the search over the restaurants that
// deliver to the point, «لم تجده؟ أخبرنا» and the panel's lost demand, on a
// fresh database. No OSRM runs, so distances are the straight line × 1.3.
let database: TestDatabase;
let cache: TestValkey;
let app: NestFastifyApplication;
let sql: pg.Pool;
let merchants: MerchantsService;
let azaz: string;
let openPlace: string;
let closedPlace: string;

const system = { type: 'system', id: null, role: null } as const;
const change = { actor: system, context: { ipAddress: null, device: null }, reason: 'test' };
const tryAmount = (amount: bigint) => ({ amount, currency: 'TRY' });
const centre = { latitude: 36.587, longitude: 37.046 };
const outside = { latitude: 36.7, longitude: 37.3 };
const allWeek = [0, 1, 2, 3, 4, 5, 6].map((weekday) => ({ weekday, opensAt: 0, closesAt: 0 }));

function square({ latitude, longitude }: Point, half = 0.02): Point[] {
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
      minimumOrder: tryAmount(10_000n),
      commissionBp: 1500,
      defaultPrepMin: 20,
      ...extra,
    },
    change,
  );
  await merchants.setAccountStatus(id, 'active', change);
  return id;
}

async function search(q: string, point: Point = centre) {
  const response = await app.inject({
    method: 'GET',
    url: `/v1/customer/search?latitude=${point.latitude}&longitude=${point.longitude}&q=${encodeURIComponent(q)}`,
  });
  expect(response.statusCode).toBe(200);
  return response.json() as {
    restaurants: { id: string; nameAr: string; state: { state: string } }[];
    items: {
      name: string;
      restaurantId: string;
      restaurantName: string;
      price: { amount: string };
      available: boolean;
      restaurantState: { state: string };
    }[];
  };
}

async function misses(): Promise<{ query: string; normalized: string }[]> {
  return (await sql.query('SELECT query, normalized FROM customers.search_misses ORDER BY at'))
    .rows;
}

async function owner() {
  const { rows } = await sql.query(
    "INSERT INTO identity.admin_accounts (name, email, status, password_hash, totp_secret_encrypted) VALUES ('مالك', $1, 'active', 'x', 'x') RETURNING id",
    [`${randomUUID()}@example.test`],
  );
  await sql.query(
    "INSERT INTO identity.admin_account_roles (account_id, role_code) VALUES ($1, 'OWN')",
    [rows[0].id],
  );
  const { token } = await app
    .get(AdminSessionsService)
    .start(
      app.get<{ db: never }>(DATABASE).db,
      rows[0].id,
      { ipAddress: null, device: null },
      new Date(),
    );
  return { [ADMIN_SESSION_COOKIE]: token };
}

function suggest(body: object, key = randomUUID()) {
  return app.inject({
    method: 'POST',
    url: '/v1/customer/restaurant-suggestions',
    headers: { 'idempotency-key': key },
    payload: { latitude: centre.latitude, longitude: centre.longitude, ...body },
  });
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
  const grills = await app.get(CategoriesService).create('مشاوي', 'system');

  // Created first, so only the state groups put it after the open one.
  closedPlace = await restaurant('شاورما الليل');
  openPlace = await restaurant('بيت الشاورمة', { nameEn: 'Shawarma House' });
  await merchants.setWeeklySchedule(openPlace, allWeek, change);
  await merchants.setRestaurantCategories(openPlace, [grills.id], change);
  // Far east, outside its 1 km radius of the point.
  await restaurant('شاورما بعيدة', {
    location: { latitude: centre.latitude, longitude: centre.longitude + 0.015 },
    coverage: { kind: 'radius', radiusMetres: 1000 },
  });

  const meals = await merchants.addCategory(openPlace, { name: 'وجبات' }, change);
  await merchants.addItem(
    openPlace,
    {
      categoryId: meals,
      name: 'صحن شاورما',
      description: 'مع بطاطا مقلية',
      price: tryAmount(12_000n),
    },
    change,
  );
  const hidden = await merchants.addItem(
    openPlace,
    { categoryId: meals, name: 'شاورما سرية', price: tryAmount(1_000n) },
    change,
  );
  await sql.query('UPDATE merchants.items SET hidden = true WHERE id = $1', [hidden]);
  const night = await merchants.addCategory(closedPlace, { name: 'سندويش' }, change);
  await merchants.addItem(
    closedPlace,
    { categoryId: night, name: 'سندويش شَاوِرْمَا', price: tryAmount(8_000n) },
    change,
  );
}, 120_000);

afterAll(async () => {
  await app?.close();
  await sql?.end();
  await Promise.all([database?.stop(), cache?.stop()]);
});

describe('GET /v1/customer/search (CU §8.3)', () => {
  it('finds restaurants and items alike, spelling variants and diacritics ignored, closed last', async () => {
    // «شاورمه» finds «الشاورمة» and not «شاورما»; the far one does not
    // deliver to the point.
    const variant = await search('شاورمه');
    expect(variant.restaurants.map((card) => card.nameAr)).toEqual(['بيت الشاورمة']);
    expect(variant.items).toEqual([]);

    // The closed one comes last, though created first.
    const part = await search('شاورم');
    expect(part.restaurants.map((card) => card.nameAr)).toEqual(['بيت الشاورمة', 'شاورما الليل']);
    expect(part.restaurants.map((card) => card.state.state)).toEqual(['open', 'closed']);

    // Diacritics ignored; the hidden item never shows.
    const both = await search('شاورما');
    expect(both.restaurants.map((card) => card.nameAr)).toEqual(['شاورما الليل']);
    expect(both.items).toMatchObject([
      { name: 'صحن شاورما', restaurantName: 'بيت الشاورمة', price: { amount: '12000' } },
      {
        name: 'سندويش شَاوِرْمَا',
        restaurantId: closedPlace,
        restaurantState: { state: 'closed' },
      },
    ]);
  });

  it('matches an English name, a category and an item description', async () => {
    expect((await search('shawarma')).restaurants.map((card) => card.id)).toEqual([openPlace]);
    expect((await search('مشاوي')).restaurants.map((card) => card.id)).toEqual([openPlace]);
    expect((await search('بطاطا')).items.map((item) => item.name)).toEqual(['صحن شاورما']);
  });

  it('records a search that found nothing at a served point, and nothing outside the zones', async () => {
    const before = (await misses()).length;
    expect(await search('سوشي')).toEqual({ restaurants: [], items: [] });
    expect(await search('  سُوشي ')).toEqual({ restaurants: [], items: [] });
    expect(await search('سوشي', outside)).toEqual({ restaurants: [], items: [] });
    expect((await misses()).slice(before)).toEqual([
      { query: 'سوشي', normalized: 'سوشي' },
      { query: 'سُوشي', normalized: 'سوشي' },
    ]);
  });

  it('refuses a search shorter than 2 characters', async () => {
    const response = await app.inject({
      method: 'GET',
      url: `/v1/customer/search?latitude=${centre.latitude}&longitude=${centre.longitude}&q=a`,
    });
    expect(response.statusCode).toBe(400);
  });
});

describe('«لم تجده؟ أخبرنا» and «الطلب الضائع» (CU §8.3, AP §9.17)', () => {
  it('records a suggestion once per key and lists it with the missed searches', async () => {
    const key = randomUUID();
    const body = { restaurantName: ' مطعم السوشي ', note: '', query: 'سوشي' };
    for (let attempt = 0; attempt < 2; attempt++) {
      const response = await suggest(body, key);
      expect(response.statusCode).toBe(200);
      expect(response.json()).toEqual({ status: 'received' });
    }
    expect((await suggest({ ...body, restaurantName: 'آخر' }, key)).statusCode).toBe(422);
    expect((await suggest({ restaurantName: '', note: null, query: null })).statusCode).toBe(400);
    expect((await suggest({ restaurantName: 'مطعم', note: null, query: null })).statusCode).toBe(
      200,
    );
    const far = await app.inject({
      method: 'POST',
      url: '/v1/customer/restaurant-suggestions',
      headers: { 'idempotency-key': randomUUID() },
      payload: { ...outside, restaurantName: 'بعيد', note: null, query: null },
    });
    expect(far.statusCode).toBe(409);
    expect(far.json()).toMatchObject({ error: 'outside_zones' });

    const report = await app.inject({
      method: 'GET',
      url: `/v1/admin/lost-demand?cityId=${azaz}`,
      cookies: await owner(),
    });
    expect(report.statusCode).toBe(200);
    const { searches, suggestions } = report.json();
    expect(searches).toEqual([{ query: 'سُوشي', count: 2, lastAt: expect.any(String) }]);
    expect(suggestions).toMatchObject([
      { restaurantName: 'مطعم', note: null, query: null },
      { restaurantName: 'مطعم السوشي', note: null, query: 'سوشي' },
    ]);

    const unknown = await app.inject({
      method: 'GET',
      url: `/v1/admin/lost-demand?cityId=${randomUUID()}`,
      cookies: await owner(),
    });
    expect(unknown.statusCode).toBe(404);
  });
});
