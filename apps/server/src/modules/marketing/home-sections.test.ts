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
import { ADMIN_SESSION_COOKIE, AdminSessionsService } from '../identity/index.js';
import { MerchantsService } from '../merchants/index.js';

// AP §9.11.3 «أقسام الرئيسية» (slice 2.27b): OWN orders the sections, hides
// one and writes a custom section with hand-picked restaurants; OPS reads.
// The customer's home that follows them: customers/home.test.ts.
let database: TestDatabase;
let cache: TestValkey;
let app: NestFastifyApplication;
let sql: pg.Pool;
let db: Database;
let azaz: string;
let accounts = 0;

const system = { type: 'system', id: null, role: null } as const;
const change = { actor: system, context: { ipAddress: null, device: null }, reason: 'test' };
const BUILT_IN = ['banners', 'categories', 'nearest', 'most_ordered', 'new', 'offers'];

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
  await withLira(azaz);
}, 300_000);

async function withLira(cityId: string) {
  const fx = app.get(FxService);
  await fx.setCityCurrency(cityId, { currency: 'TRY', displayOrder: 1, enabled: true }, change);
  await fx.setBaseCurrency(cityId, 'TRY', change);
}

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
    [`Marketer ${accounts}`, `sections${accounts}@example.test`],
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
  // A create gets a fresh Idempotency-Key unless the test gives one.
  return (method: 'GET' | 'POST' | 'PUT', url: string, payload?: object, key?: string) =>
    app.inject({
      method,
      url,
      cookies,
      ...(method === 'POST' && url === '/v1/admin/home-sections'
        ? { headers: { 'idempotency-key': key ?? randomUUID() } }
        : {}),
      ...(payload ? { payload } : {}),
    });
}

function restaurant(name: string, cityId = azaz) {
  return app.get(MerchantsService).createRestaurant(
    cityId,
    {
      nameAr: name,
      location: { latitude: 36.5866, longitude: 37.0463 },
      coverage: { kind: 'radius', radiusMetres: 3000 },
      minimumOrder: { amount: 10_000n, currency: 'TRY' },
      commissionBp: 1500,
      defaultPrepMin: 20,
    },
    change,
  );
}

type Section = { key: string; kind: string; title: string | null; visible: boolean };
const keys = (answer: { json(): { sections: Section[] } }) =>
  answer.json().sections.map((section) => section.key);

describe('«أقسام الرئيسية»', () => {
  it('reads the built-in sections in the default order, shown, before any edit', async () => {
    const ops = await admin(['OPS']);
    const read = await ops('GET', `/v1/admin/home-sections?cityId=${azaz}`);
    expect(read.statusCode).toBe(200);
    expect(read.json().sections).toEqual(
      BUILT_IN.map((kind) => ({ key: kind, kind, title: null, restaurantIds: [], visible: true })),
    );
    expect(read.json().canManage).toBe(false);
    // OPS reads only (AP §6).
    const refused = await ops('POST', '/v1/admin/home-sections/order', {
      cityId: azaz,
      keys: [...BUILT_IN].reverse(),
    });
    expect(refused.statusCode).toBe(403);
    const unknown = await ops('GET', `/v1/admin/home-sections?cityId=${randomUUID()}`);
    expect(unknown.statusCode).toBe(404);
  });

  it('orders, hides and writes custom sections, audited', async () => {
    const owner = await admin(['OWN']);
    const [shawarma, grill] = [await restaurant('شاورما الريف'), await restaurant('مشاوي الشام')];
    const added = await owner('POST', '/v1/admin/home-sections', {
      cityId: azaz,
      title: ' أفضل شاورما في أعزاز ',
      restaurantIds: [grill, shawarma],
    });
    expect(added.statusCode).toBe(201);
    const custom = added.json().sections.at(-1);
    expect(custom).toEqual({
      key: custom.key,
      kind: 'custom',
      title: 'أفضل شاورما في أعزاز',
      restaurantIds: [grill, shawarma],
      visible: true,
    });
    expect(added.json().canManage).toBe(true);
    expect(added.json().restaurants).toEqual(
      expect.arrayContaining([{ id: shawarma, name: 'شاورما الريف' }]),
    );

    const order = [custom.key, 'offers', ...BUILT_IN.filter((kind) => kind !== 'offers')];
    const ordered = await owner('POST', '/v1/admin/home-sections/order', {
      cityId: azaz,
      keys: order,
    });
    expect(ordered.statusCode).toBe(200);
    expect(keys(ordered)).toEqual(order);
    // A section left out, or one more, is a stale list.
    const stale = await owner('POST', '/v1/admin/home-sections/order', {
      cityId: azaz,
      keys: order.slice(1),
    });
    expect(stale.statusCode).toBe(409);
    expect(stale.json().error).toBe('sections_changed');

    const hidden = await owner('POST', '/v1/admin/home-sections/visibility', {
      cityId: azaz,
      key: 'nearest',
      visible: false,
    });
    expect(hidden.json().sections.find((each: Section) => each.key === 'nearest').visible).toBe(
      false,
    );
    expect(keys(hidden)).toEqual(order);

    const edited = await owner('PUT', `/v1/admin/home-sections/${custom.key}`, {
      cityId: azaz,
      title: 'شاورما',
      restaurantIds: [shawarma],
    });
    expect(edited.json().sections[0]).toMatchObject({ title: 'شاورما', restaurantIds: [shawarma] });

    const removed = await owner('POST', `/v1/admin/home-sections/${custom.key}/remove`, {
      cityId: azaz,
    });
    expect(keys(removed)).toEqual(order.slice(1));
    const again = await owner('POST', `/v1/admin/home-sections/${custom.key}/remove`, {
      cityId: azaz,
    });
    expect(again.statusCode).toBe(404);

    const { rows } = await sql.query(
      `SELECT action FROM audit.events WHERE target_type = 'home_section' ORDER BY occurred_at, id`,
    );
    expect(rows.map((row) => row.action)).toEqual([
      'home_section.create',
      'home_section.reorder',
      'home_section.visibility',
      'home_section.update',
      'home_section.remove',
    ]);
  });

  it('adds a custom section once per Idempotency-Key', async () => {
    const owner = await admin(['OWN']);
    const mine = await restaurant('بيتزا');
    const body = { cityId: azaz, title: 'بيتزا', restaurantIds: [mine] };
    const key = randomUUID();
    const first = await owner('POST', '/v1/admin/home-sections', body, key);
    const repeat = await owner('POST', '/v1/admin/home-sections', body, key);
    expect(repeat.statusCode).toBe(201);
    expect(keys(repeat)).toEqual(keys(first));
    const other = await owner('POST', '/v1/admin/home-sections', { ...body, title: 'أخرى' }, key);
    expect(other.statusCode).toBe(422);
    expect(other.json().error).toBe('idempotency_key_reused');
  });

  it('refuses a custom section without a title, restaurants or with another city’s', async () => {
    const owner = await admin(['OWN']);
    const mine = await restaurant('فلافل');
    const create = (title: string, restaurantIds: string[]) =>
      owner('POST', '/v1/admin/home-sections', { cityId: azaz, title, restaurantIds });
    expect((await create('   ', [mine])).json().error).toBe('invalid_section');
    expect((await create('عنوان', [])).json().error).toBe('invalid_section');
    expect((await create('عنوان', [mine, mine])).json().error).toBe('invalid_section');
    expect((await create('ع'.repeat(41), [mine])).statusCode).toBe(400);
    const { rows } = await sql.query(
      "INSERT INTO geo.cities (code, name) VALUES ('XX', 'مدينة أخرى') RETURNING id",
    );
    await withLira(rows[0].id);
    const elsewhere = await restaurant('مطعم بعيد', rows[0].id);
    expect((await create('عنوان', [elsewhere])).json().error).toBe('invalid_section');
  });

  it('keeps a custom title and built-in sections apart in the table', async () => {
    await expect(
      sql.query(
        `INSERT INTO marketing.home_sections (city_id, kind, position) VALUES ($1, 'custom', 1)`,
        [azaz],
      ),
    ).rejects.toThrow(/home_sections_custom/);
    await expect(
      sql.query(
        `INSERT INTO marketing.home_sections (city_id, kind, title, position) VALUES ($1, 'nearest', 'x', 1)`,
        [azaz],
      ),
    ).rejects.toThrow(/home_sections_custom/);
    await expect(sql.query('DELETE FROM marketing.home_sections')).rejects.toThrow(
      /permission denied/,
    );
  });
});
