import 'reflect-metadata';
import { randomBytes, randomUUID } from 'node:crypto';
import { readFileSync } from 'node:fs';
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

// AP §9.13 «التصنيفات», AP §9.6.3 step 1 and CU §8.2 (slice 2.27a): the
// owner adds a category (its image: category-image.test.ts) and reorders the list, links a
// restaurant to it, and the customer finds it on the cards and the category
// page, open restaurants first and closed ones last.
let database: TestDatabase;
let cache: TestValkey;
let app: NestFastifyApplication;
let sql: pg.Pool;
let db: Database;
let merchants: MerchantsService;
let azaz: string;
let accounts = 0;

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
  process.env.FOX_DROP_ENVIRONMENT = 'development';
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

async function admin(roles: string[]) {
  accounts += 1;
  const { rows } = await sql.query(
    `INSERT INTO identity.admin_accounts (name, email, status, password_hash, totp_secret_encrypted)
     VALUES ($1, $2, 'active', 'not used', 'not used') RETURNING id`,
    [`Editor ${accounts}`, `categories${accounts}@example.test`],
  );
  for (const role of roles) {
    await sql.query(
      'INSERT INTO identity.admin_account_roles (account_id, role_code) VALUES ($1, $2)',
      [rows[0].id, role],
    );
  }
  const { token } = await app
    .get(AdminSessionsService)
    .start(db.db, rows[0].id, { ipAddress: '203.0.113.9', device: 'test' }, new Date());
  const cookies = { [ADMIN_SESSION_COOKIE]: token };
  return (method: 'GET' | 'POST' | 'PUT', url: string, payload?: object) =>
    app.inject({ method, url, cookies, ...(payload ? { payload } : {}) });
}

async function restaurant(name: string, hours = allWeek) {
  const id = await merchants.createRestaurant(
    azaz,
    {
      nameAr: name,
      location: centre,
      coverage: { kind: 'radius', radiusMetres: 3000 },
      minimumOrder: { amount: 10_000n, currency: 'TRY' },
      commissionBp: 1500,
      defaultPrepMin: 20,
    },
    change,
  );
  await merchants.setAccountStatus(id, 'active', change);
  if (hours.length > 0) await merchants.setWeeklySchedule(id, hours, change);
  return id;
}

const customer = (url: string) => app.inject({ method: 'GET', url: `/v1/customer/${url}` });
const ids = (answer: { json(): { restaurants: { id: string }[] } }) =>
  answer.json().restaurants.map((card) => card.id);

describe("the panel's «التصنيفات»", () => {
  it('adds, renames, reorders and removes categories, audited', async () => {
    const owner = await admin(['OWN']);
    const added = await owner('POST', '/v1/admin/content/categories', { name: ' شاورما ' });
    expect(added.statusCode).toBe(201);
    const shawarma = added.json();
    expect(shawarma).toEqual({ id: shawarma.id, name: 'شاورما', imageKey: null, active: true });
    const pizza = (await owner('POST', '/v1/admin/content/categories', { name: 'بيتزا' })).json();

    // Two active categories never share a name.
    const twice = await owner('POST', '/v1/admin/content/categories', { name: 'شاورما' });
    expect(twice.statusCode).toBe(400);
    expect(twice.json().error).toBe('duplicate_label');

    const order = await owner('POST', '/v1/admin/content/categories/order', {
      ids: [pizza.id, shawarma.id],
    });
    expect(order.statusCode).toBe(200);
    expect(order.json().categories.map((entry: { name: string }) => entry.name)).toEqual([
      'بيتزا',
      'شاورما',
    ]);
    const partial = await owner('POST', '/v1/admin/content/categories/order', {
      ids: [pizza.id],
    });
    expect(partial.json().error).toBe('invalid_order');

    const removed = await owner('PUT', `/v1/admin/content/categories/${pizza.id}`, {
      name: 'بيتزا',
      active: false,
    });
    expect(removed.json()).toMatchObject({ active: false });
    // Removed, the name is free again; the panel still lists the removed one.
    const again = await owner('POST', '/v1/admin/content/categories', { name: 'بيتزا' });
    expect(again.statusCode).toBe(201);
    const back = await owner('PUT', `/v1/admin/content/categories/${pizza.id}`, {
      name: 'بيتزا',
      active: true,
    });
    expect(back.json().error).toBe('duplicate_label');
    const list = (await owner('GET', '/v1/admin/content/categories')).json().categories;
    expect(
      list.map((entry: { name: string; active: boolean }) => [entry.name, entry.active]),
    ).toEqual([
      ['بيتزا', false],
      ['شاورما', true],
      ['بيتزا', true],
    ]);
    // The customer sees the active ones in order.
    const offered = (await customer('categories')).json().categories;
    expect(offered.map((entry: { name: string }) => entry.name)).toEqual(['شاورما', 'بيتزا']);

    const unknown = await owner('PUT', `/v1/admin/content/categories/${randomUUID()}`, {
      name: 'x',
      active: true,
    });
    expect(unknown.statusCode).toBe(404);
    const { rows } = await sql.query(
      "SELECT action FROM audit.events WHERE target_type = 'content' AND target_id = $1 ORDER BY occurred_at",
      [`category:${pizza.id}`],
    );
    expect(rows.map((row) => row.action)).toEqual([
      'content.category.create',
      'content.category.update',
    ]);
  });

  it('lets OPS read only, and keeps SUP out', async () => {
    const ops = await admin(['OPS']);
    expect((await ops('GET', '/v1/admin/content/categories')).statusCode).toBe(200);
    expect((await ops('POST', '/v1/admin/content/categories', { name: 'ممنوع' })).statusCode).toBe(
      403,
    );
    const sup = await admin(['SUP']);
    expect((await sup('GET', '/v1/admin/content/categories')).statusCode).toBe(403);
  });
});

describe('a restaurant’s categories and the category page (CU §8.2)', () => {
  it('lists the category’s restaurants, open first and closed last, with their categories', async () => {
    const owner = await admin(['OWN']);
    const add = async (name: string) =>
      (await owner('POST', '/v1/admin/content/categories', { name })).json().id as string;
    const grills = await add('مشاوي');
    const breakfast = await add('فطور');
    const closed = await restaurant('مشاوي مغلق', []);
    const open = await restaurant('مشاوي مفتوح');
    const other = await restaurant('فطور فقط');

    const link = (id: string, categoryIds: string[]) =>
      owner('PUT', `/v1/admin/restaurants/${id}/categories`, { categoryIds });
    expect((await link(closed, [grills])).json()).toEqual({ categoryIds: [grills] });
    await link(open, [breakfast, grills]);
    await link(other, [breakfast]);
    expect((await owner('GET', `/v1/admin/restaurants/${open}/categories`)).json()).toEqual({
      categoryIds: [breakfast, grills],
    });

    const page = await customer(`restaurants?${point}&categoryId=${grills}`);
    expect(page.statusCode).toBe(200);
    expect(ids(page)).toEqual([open, closed]);
    const [card] = page.json().restaurants;
    expect(card).toMatchObject({
      category: 'فطور',
      categories: [
        { id: breakfast, name: 'فطور' },
        { id: grills, name: 'مشاوي' },
      ],
    });

    // A removed category leaves the cards and its page, and cannot be linked.
    await owner('PUT', `/v1/admin/content/categories/${breakfast}`, {
      name: 'فطور',
      active: false,
    });
    const after = (await customer(`restaurants?${point}&categoryId=${grills}`)).json();
    expect(after.restaurants[0].categories).toEqual([{ id: grills, name: 'مشاوي' }]);
    expect(ids(await customer(`restaurants?${point}&categoryId=${breakfast}`))).toEqual([]);
    const refused = await link(other, [breakfast]);
    expect(refused.statusCode).toBe(400);
    expect(refused.json().error).toBe('unknown_category');
    expect((await link(other, [grills, grills])).json().error).toBe('unknown_category');
    expect((await link(randomUUID(), [grills])).statusCode).toBe(404);
  });

  it('lets DATA link categories and keeps FIN out', async () => {
    const owner = await admin(['OWN']);
    const id = (await owner('POST', '/v1/admin/content/categories', { name: 'برغر' })).json().id;
    const place = await restaurant('برغر');
    const data = await admin(['DATA']);
    expect(
      (await data('PUT', `/v1/admin/restaurants/${place}/categories`, { categoryIds: [id] }))
        .statusCode,
    ).toBe(200);
    const fin = await admin(['FIN']);
    expect(
      (await fin('PUT', `/v1/admin/restaurants/${place}/categories`, { categoryIds: [] }))
        .statusCode,
    ).toBe(403);
  });
});

describe('migration 0107 (owner decision 2026-11-18)', () => {
  it('carries the free-text categories over by name', async () => {
    // Its data statements, run again on restaurants that still have only
    // the free text, as the restaurants on staging had.
    const statements = readFileSync(
      new URL('../../../migrations/0107_content_categories.sql', import.meta.url),
      'utf8',
    )
      .split('--> statement-breakpoint')
      .filter((statement) => /^\s*(--.*\n)*\s*(INSERT|UPDATE)/.test(statement));
    expect(statements).toHaveLength(2);
    const first = await restaurant('نص حر ١');
    const second = await restaurant('نص حر ٢');
    const blank = await restaurant('نص حر ٣');
    const migrator = new pg.Pool({ connectionString: database.migratorUrl });
    try {
      await migrator.query(
        "UPDATE merchants.restaurants SET category = CASE id WHEN $1 THEN E'\\tكباب\\u00a0' WHEN $2 THEN 'كباب' ELSE '  ' END WHERE id IN ($1, $2, $3)",
        [first, second, blank],
      );
      await migrator.query(
        'UPDATE merchants.restaurants SET category = NULL WHERE id NOT IN ($1, $2, $3)',
        [first, second, blank],
      );
      for (const statement of statements) await migrator.query(statement);
    } finally {
      await migrator.end();
    }
    const { rows } = await sql.query(
      'SELECT r.id, c.name FROM merchants.restaurants r LEFT JOIN content.categories c ON c.id = r.category_ids[1] WHERE r.id IN ($1, $2, $3)',
      [first, second, blank],
    );
    const names = Object.fromEntries(rows.map((row) => [row.id, row.name]));
    expect(names).toEqual({ [first]: 'كباب', [second]: 'كباب', [blank]: null });
  });
});
