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
import { CategoriesService } from '../content/index.js';
import { FxService } from '../fx/index.js';
import { GeoService } from '../geo/index.js';
import { HomeSectionsService } from '../marketing/index.js';
import { MerchantsService } from '../merchants/index.js';

// CU §8.1, AP §9.11.2 (slice 2.27c, owner decisions 2026-11-18): the home
// shows the banners running in the point's zone, in the panel's order, at
// most 10, each one the customer can open here; «البانرات» is left out
// without one, and hiding it hides them. The panel's routes:
// marketing/banners.test.ts.
let database: TestDatabase;
let cache: TestValkey;
let app: NestFastifyApplication;
let sql: pg.Pool;
let db: Database;
let azaz: string;
let centreZone: string;
let farZone: string;
let adminId: string;

const DAY = 86_400_000;
const system = { type: 'system', id: null, role: null } as const;
const change = { actor: system, context: { ipAddress: null, device: null }, reason: 'test' };
const centre = { latitude: 36.5866, longitude: 37.0463 };
const point = `latitude=${centre.latitude}&longitude=${centre.longitude}`;
const allWeek = [0, 1, 2, 3, 4, 5, 6].map((weekday) => ({ weekday, opensAt: 0, closesAt: 0 }));

function square(latitude: number, longitude: number, half: number) {
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
  sql = new pg.Pool({ connectionString: database.appUrl });
  db = createDatabase(database.appUrl);
  app = await createApiApp(ApiModule);
  await app.init();
  await app.getHttpAdapter().getInstance().ready();
  azaz = (await sql.query("SELECT id FROM geo.cities WHERE code = 'AZ'")).rows[0].id;
  const fx = app.get(FxService);
  await fx.setCityCurrency(azaz, { currency: 'TRY', displayOrder: 1, enabled: true }, change);
  await fx.setBaseCurrency(azaz, 'TRY', change);
  const geo = app.get(GeoService);
  centreZone = await geo.createZone(
    azaz,
    { name: 'المركز', area: square(centre.latitude, centre.longitude, 0.02), active: true },
    change,
  );
  farZone = await geo.createZone(
    azaz,
    { name: 'البعيد', area: square(centre.latitude + 0.1, centre.longitude, 0.02), active: true },
    change,
  );
  adminId = (
    await sql.query(
      `INSERT INTO identity.admin_accounts (name, email, status, password_hash, totp_secret_encrypted)
       VALUES ('Owner', 'home-banners@example.test', 'active', 'not used', 'not used') RETURNING id`,
    )
  ).rows[0].id;
}, 300_000);

afterAll(async () => {
  await app?.close();
  await db?.pool.end();
  await sql?.end();
  await Promise.all([database?.stop(), cache?.stop()]);
});

// A restaurant `steps` hundred metres north of the point, delivering 3 km.
async function restaurant(name: string, steps: number, open = true) {
  const merchants = app.get(MerchantsService);
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
  return id;
}

let positions = 0;
// A banner written as the panel stores it.
async function banner(fields: {
  title: string;
  target: string;
  restaurantIds?: string[];
  categoryId?: string;
  codeId?: string;
  zoneIds?: string[];
  startsAt?: Date;
  endsAt?: Date;
}) {
  positions += 1;
  const { rows } = await sql.query(
    `INSERT INTO marketing.banners (city_id, title, image_key, target, restaurant_ids,
       category_id, code_id, zone_ids, position, starts_at, ends_at, created_by, updated_by)
     VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $12) RETURNING id`,
    [
      azaz,
      fields.title,
      `marketing/banners/${randomUUID()}.jpg`,
      fields.target,
      fields.restaurantIds ?? [],
      fields.categoryId ?? null,
      fields.codeId ?? null,
      fields.zoneIds ?? [],
      positions,
      fields.startsAt ?? new Date(Date.now() - 3_600_000),
      fields.endsAt ?? new Date(Date.now() + DAY),
      adminId,
    ],
  );
  return rows[0].id as string;
}

async function code(text: string, status: 'active' | 'paused') {
  const { rows } = await sql.query(
    `INSERT INTO marketing.promo_codes (city_id, code, kind, percent_bp, currency, valid_from,
       valid_to, audience, restaurant_ids, zone_ids, funding, merchant_share_bp, visibility,
       status, created_by, updated_by)
     VALUES ($1, $2, 'percentage', 1000, 'TRY', now() - interval '1 hour',
       now() + interval '3 days', 'everyone', '{}', '{}', 'platform', 0, 'visible', $3, $4, $4)
     RETURNING id`,
    [azaz, text, status, adminId],
  );
  return rows[0].id as string;
}

type Home = {
  restaurants: { id: string }[];
  sections: { kind: string }[];
  banners: {
    id: string;
    title: string;
    target: string;
    restaurantIds: string[];
    categoryId: string | null;
    code: string | null;
  }[];
};
const home = async (): Promise<Home> => {
  const answer = await app.inject({
    method: 'GET',
    url: `/v1/customer/restaurants?${point}&home=true`,
  });
  expect(answer.statusCode).toBe(200);
  return answer.json();
};

describe('the home banners', () => {
  it('leaves «البانرات» out without a banner, and answers no banners without home', async () => {
    await restaurant('مطعم القائمة', 1);
    const body = await home();
    expect(body.banners).toEqual([]);
    expect(body.sections.map((section) => section.kind)).not.toContain('banners');
    const list = await app.inject({ method: 'GET', url: `/v1/customer/restaurants?${point}` });
    expect(list.json().banners).toBeNull();
  });

  it('shows the banners running in the zone, in order, each one the customer can open', async () => {
    const near = await restaurant('القريب', 2);
    const closed = await restaurant('المغلق', 3, false);
    const away = await restaurant('خارج التغطية', 60);
    const category = await app.get(CategoriesService).create('مشاوي', 'system');
    const running = await code('BANR10', 'active');
    const paused = await code('BANR20', 'paused');

    const forZone = await banner({
      title: 'للمركز',
      target: 'restaurant',
      restaurantIds: [near],
      zoneIds: [centreZone],
    });
    await banner({
      title: 'للبعيد',
      target: 'restaurant',
      restaurantIds: [near],
      zoneIds: [farZone],
    });
    const list = await banner({
      title: 'قائمتنا',
      target: 'restaurants',
      restaurantIds: [closed, away, near],
    });
    const byCategory = await banner({
      title: 'مشاوي',
      target: 'category',
      categoryId: category.id,
    });
    const byCode = await banner({ title: 'الكود', target: 'code', codeId: running });
    await banner({ title: 'كود موقوف', target: 'code', codeId: paused });
    await banner({ title: 'لا يوصل', target: 'restaurant', restaurantIds: [away] });
    await banner({
      title: 'لم يبدأ',
      target: 'restaurant',
      restaurantIds: [near],
      startsAt: new Date(Date.now() + DAY),
      endsAt: new Date(Date.now() + 2 * DAY),
    });
    await banner({
      title: 'انتهى',
      target: 'restaurant',
      restaurantIds: [near],
      startsAt: new Date(Date.now() - 2 * DAY),
      endsAt: new Date(Date.now() - DAY),
    });

    const body = await home();
    expect(body.sections[0]!.kind).toBe('banners');
    expect(body.banners.map((each) => each.id)).toEqual([forZone, list, byCategory, byCode]);
    // The list: open first, closed last; a restaurant away from the point left out.
    expect(body.banners[1]!.restaurantIds).toEqual([near, closed]);
    expect(body.banners[2]).toMatchObject({ target: 'category', categoryId: category.id });
    expect(body.banners[3]).toMatchObject({ target: 'code', code: 'BANR10' });

    // A removed category's banner goes too.
    await sql.query('UPDATE content.categories SET active = false WHERE id = $1', [category.id]);
    expect((await home()).banners.map((each) => each.id)).not.toContain(byCategory);
  });

  it('shows at most 10, and none while «البانرات» is hidden', async () => {
    const near = await restaurant('العاشر', 4);
    for (let i = 0; i < 12; i += 1) {
      await banner({ title: `بانر ${i}`, target: 'restaurant', restaurantIds: [near] });
    }
    expect((await home()).banners).toHaveLength(10);
    await app.get(HomeSectionsService).setVisible(azaz, 'banners', false, {
      accountId: adminId,
      actor: system,
      context: change.context,
    });
    const hidden = await home();
    expect(hidden.banners).toEqual([]);
    expect(hidden.sections.map((section) => section.kind)).not.toContain('banners');
  });
});
