import 'reflect-metadata';
import { randomBytes, randomUUID } from 'node:crypto';
import type { NestFastifyApplication } from '@nestjs/platform-fastify';
import pg from 'pg';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { ApiModule } from '../../api.module.js';
import { createDatabase, type Database } from '../../database/database.js';
import { startTestDatabase, type TestDatabase } from '../../database/test-database.js';
import { createApiApp } from '../../http/create-api-app.js';
import { startTestValkey, type TestValkey } from '../../valkey/test-valkey.js';
import { FxService } from '../fx/index.js';
import { GeoService } from '../geo/index.js';
import { ADMIN_SESSION_COOKIE, AdminSessionsService } from '../identity/index.js';
import { MerchantsService } from '../merchants/index.js';
import { CustomersService } from './customers.service.js';

// CU §8.1, §8.2, AP §9.11.3 (slice 2.27b, owner decisions 2026-11-18): the
// customer's home shows the shown sections in the panel's order: the 10
// nearest, the 10 most delivered in 30 days, the 10 activated in 30 days
// newest first, every restaurant of a visible code limited to restaurants,
// and the custom sections; each takes its restaurants by its own rule, then
// shows open first and closed last. The owner reorders and the home follows.
let database: TestDatabase;
let cache: TestValkey;
let app: NestFastifyApplication;
let sql: pg.Pool;
let db: Database;
let merchants: MerchantsService;
let azaz: string;

const DAY = 86_400_000;
const system = { type: 'system', id: null, role: null } as const;
const change = { actor: system, context: { ipAddress: null, device: null }, reason: 'test' };
const centre = { latitude: 36.5866, longitude: 37.0463 };
const point = `latitude=${centre.latitude}&longitude=${centre.longitude}`;
const allWeek = [0, 1, 2, 3, 4, 5, 6].map((weekday) => ({ weekday, opensAt: 0, closesAt: 0 }));

beforeAll(async () => {
  [database, cache] = await Promise.all([startTestDatabase(), startTestValkey()]);
  process.env.DATABASE_URL = database.appUrl;
  process.env.VALKEY_URL = cache.url;
  process.env.IDENTITY_ENCRYPTION_KEY = randomBytes(32).toString('base64');
  sql = new pg.Pool({ connectionString: database.appUrl });
  db = createDatabase(database.appUrl);
  app = await createApiApp(ApiModule);
  await app.init();
  await app.getHttpAdapter().getInstance().ready();
  merchants = app.get(MerchantsService);
  azaz = (await sql.query("SELECT id FROM geo.cities WHERE code = 'AZ'")).rows[0].id;
  const fx = app.get(FxService);
  await fx.setCityCurrency(azaz, { currency: 'TRY', displayOrder: 1, enabled: true }, change);
  await fx.setBaseCurrency(azaz, 'TRY', change);
  const half = 0.02;
  const area = [
    { latitude: centre.latitude - half, longitude: centre.longitude - half },
    { latitude: centre.latitude - half, longitude: centre.longitude + half },
    { latitude: centre.latitude + half, longitude: centre.longitude + half },
    { latitude: centre.latitude + half, longitude: centre.longitude - half },
  ];
  await app.get(GeoService).createZone(azaz, { name: 'المركز', area, active: true }, change);
}, 300_000);

afterAll(async () => {
  await app?.close();
  await db?.pool.end();
  await sql?.end();
  await Promise.all([database?.stop(), cache?.stop()]);
});

async function owner() {
  const { rows } = await sql.query(
    `INSERT INTO identity.admin_accounts (name, email, status, password_hash, totp_secret_encrypted)
     VALUES ('Owner', 'home-owner@example.test', 'active', 'not used', 'not used') RETURNING id`,
  );
  await sql.query(
    "INSERT INTO identity.admin_account_roles (account_id, role_code) VALUES ($1, 'OWN')",
    [rows[0].id],
  );
  const { token } = await app
    .get(AdminSessionsService)
    .start(db.db, rows[0].id, { ipAddress: '203.0.113.9', device: 'test' }, new Date());
  const cookies = { [ADMIN_SESSION_COOKIE]: token };
  return (
    method: 'GET' | 'POST',
    url: string,
    payload?: object,
    headers?: Record<string, string>,
  ) =>
    app.inject({
      method,
      url,
      cookies,
      ...(headers ? { headers } : {}),
      ...(payload ? { payload } : {}),
    });
}

// A restaurant `steps` hundred metres north of the point, open all week
// unless closed, activated `daysAgo` days back.
async function restaurant(name: string, steps: number, daysAgo: number, open = true) {
  const id = await merchants.createRestaurant(
    azaz,
    {
      nameAr: name,
      location: { latitude: centre.latitude + steps * 0.0009, longitude: centre.longitude },
      coverage: { kind: 'radius', radiusMetres: 3000 },
      minimumOrder: { amount: 10_000n, currency: 'TRY' },
      commissionBp: 1500,
      defaultPrepMin: 20,
    },
    change,
  );
  await merchants.setAccountStatus(id, 'active', change);
  if (open) await merchants.setWeeklySchedule(id, allWeek, change);
  await sql.query('UPDATE merchants.restaurants SET activated_at = $2 WHERE id = $1', [
    id,
    new Date(Date.now() - daysAgo * DAY),
  ]);
  return id;
}

type Home = {
  restaurants: { id: string }[];
  sections: { kind: string; title: string | null; restaurantIds: string[] }[];
};
const home = async (): Promise<Home> => {
  const answer = await app.inject({
    method: 'GET',
    url: `/v1/customer/restaurants?${point}&home=true`,
  });
  expect(answer.statusCode).toBe(200);
  return answer.json();
};
const section = (body: Home, kind: string) =>
  body.sections.find((each) => each.kind === kind)?.restaurantIds;

describe('the customer home', () => {
  // r[0] is the nearest and closed; r[1]..r[11] are open, farther each step.
  const r: string[] = [];
  let admin: Awaited<ReturnType<typeof owner>>;

  beforeAll(async () => {
    admin = await owner();
    r.push(await restaurant('مغلق قريب', 0, 1, false));
    for (let step = 1; step <= 11; step += 1) {
      // r[11] was activated 40 days back, r[10] 31: never new.
      r.push(
        await restaurant(`مطعم ${step}`, step, step === 11 ? 40 : step === 10 ? 31 : step + 1),
      );
    }
  }, 120_000);

  it('shows the built-in sections in the default order, open first, closed last', async () => {
    const body = await home();
    expect(body.restaurants).toHaveLength(12);
    // Nothing delivered, no code and no banner yet: those sections are left
    // out (slice 2.27c: «البانرات» too, home-banners.test.ts).
    expect(body.sections.map((each) => each.kind)).toEqual(['categories', 'nearest', 'new']);
    expect(body.banners).toEqual([]);
    // The 10 nearest whatever their state, the closed one last.
    expect(section(body, 'nearest')).toEqual([...r.slice(1, 10), r[0]]);
    // Activated within 30 days, newest first: r[0] a day back, then r[1]…
    expect(section(body, 'new')).toEqual([...r.slice(1, 10), r[0]]);
    // The plain list without home has no sections.
    const plain = await app.inject({ method: 'GET', url: `/v1/customer/restaurants?${point}` });
    expect(plain.json().sections).toBeNull();
  });

  it('shows the most delivered and the restaurants on offer', async () => {
    app.get(CustomersService).useDeliveredCounts(async (ids) => {
      const counts = new Map([
        [r[5]!, 3],
        [r[2]!, 7],
        [r[0]!, 9],
        [r[7]!, 3],
      ]);
      return new Map([...counts].filter(([id]) => ids.includes(id)));
    });
    const code = async (
      text: string,
      restaurantIds: string[],
      visibility: string,
      zoneIds: string[] = [],
    ) => {
      const created = await admin(
        'POST',
        '/v1/admin/promo-codes',
        {
          cityId: azaz,
          code: text,
          kind: 'percentage',
          percentBp: 1000,
          amount: null,
          maxDiscount: null,
          minOrder: null,
          validFrom: new Date(Date.now() - 3_600_000).toISOString(),
          validTo: new Date(Date.now() + DAY).toISOString(),
          startMinute: null,
          endMinute: null,
          totalLimit: null,
          perCustomerLimit: null,
          audience: 'everyone',
          restaurantIds,
          zoneIds,
          funding: 'platform',
          sharedMerchantBp: null,
          dailyBudget: null,
          visibility,
        },
        { 'idempotency-key': randomUUID() },
      );
      expect(created.json()).toMatchObject({ codes: [{ code: text }] });
    };
    await code('OFFER1', [r[8]!, r[0]!], 'visible');
    await code('SECRET1', [r[3]!], 'secret');
    await code('EVERYWHERE', [], 'visible');
    // A code for another zone only leaves its restaurant out here.
    const { rows } = await sql.query('SELECT id FROM geo.zones WHERE city_id = $1', [azaz]);
    const elsewhere = await app.get(GeoService).createZone(
      azaz,
      {
        name: 'بعيد',
        area: [
          { latitude: 36.7, longitude: 37.2 },
          { latitude: 36.7, longitude: 37.21 },
          { latitude: 36.71, longitude: 37.21 },
          { latitude: 36.71, longitude: 37.2 },
        ],
        active: true,
      },
      change,
    );
    expect(rows).toHaveLength(1);
    await code('FARAWAY', [r[6]!], 'visible', [elsewhere]);
    await code('HERE', [r[9]!], 'visible', [rows[0].id]);
    // «العروض» keeps the restaurants' own order: the sort weight first.
    await sql.query('UPDATE merchants.restaurants SET sort_weight = 5 WHERE id = $1', [r[9]]);
    const body = await home();
    // The most delivered first, ties in the list's order; the closed one last.
    expect(section(body, 'most_ordered')).toEqual([r[2], r[5], r[7], r[0]]);
    // A visible code limited to restaurants; never a secret one or one for all.
    expect(section(body, 'offers')).toEqual([r[9], r[8], r[0]]);
    await sql.query('UPDATE merchants.restaurants SET sort_weight = 0 WHERE id = $1', [r[9]]);
  });

  it('follows the panel: a custom section first, a section hidden', async () => {
    const added = await admin(
      'POST',
      '/v1/admin/home-sections',
      {
        cityId: azaz,
        title: 'أفضل شاورما في أعزاز',
        restaurantIds: [r[0], r[11], r[4], r[3]],
      },
      { 'idempotency-key': randomUUID() },
    );
    expect(added.statusCode).toBe(201);
    const keys: string[] = added.json().sections.map((each: { key: string }) => each.key);
    const custom = keys.at(-1)!;
    const order = [custom, ...keys.filter((key) => key !== custom)];
    expect(
      (await admin('POST', '/v1/admin/home-sections/order', { cityId: azaz, keys: order }))
        .statusCode,
    ).toBe(200);
    await admin('POST', '/v1/admin/home-sections/visibility', {
      cityId: azaz,
      key: 'nearest',
      visible: false,
    });
    // A suspended restaurant leaves every section (CU §8.2).
    await merchants.setAccountStatus(r[3]!, 'suspended', change);
    const body = await home();
    expect(body.sections.map((each) => each.kind)).toEqual([
      'custom',
      'categories',
      'most_ordered',
      'new',
      'offers',
    ]);
    // The admin's order, the closed one last.
    expect(body.sections[0]).toEqual({
      kind: 'custom',
      title: 'أفضل شاورما في أعزاز',
      restaurantIds: [r[11], r[4], r[0]],
    });
  });
});
