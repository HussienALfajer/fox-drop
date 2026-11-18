import 'reflect-metadata';
import { randomBytes, randomUUID } from 'node:crypto';
import type { NestFastifyApplication } from '@nestjs/platform-fastify';
import pg from 'pg';
import { afterAll, beforeAll, describe, expect, it, vi } from 'vitest';
import { ApiModule } from '../../api.module.js';
import { createDatabase, type Database } from '../../database/database.js';
import { startTestDatabase, type TestDatabase } from '../../database/test-database.js';
import { createApiApp } from '../../http/create-api-app.js';
import { startTestValkey, type TestValkey } from '../../valkey/test-valkey.js';
import { CategoriesService } from '../content/index.js';
import { FilesRefusedError, FilesService } from '../files/index.js';
import { FxService } from '../fx/index.js';
import { ADMIN_SESSION_COOKIE, AdminSessionsService } from '../identity/index.js';
import { MerchantsService } from '../merchants/index.js';

// AP §9.11.2 «البانرات» (slice 2.27c, owner decisions 2026-11-18): DATA and
// OWN publish a banner with its image, title, target, period and zones, and
// order or remove them; OPS reads. The storage's half of linking (the copy
// and the 1200×500 check) is files.test.ts's, on a real Garage; here it is
// stubbed, and the upload's row is real. The customer's home that shows
// them: customers/home-banners.test.ts.
let database: TestDatabase;
let cache: TestValkey;
let app: NestFastifyApplication;
let sql: pg.Pool;
let db: Database;
let azaz: string;
let accounts = 0;

const DAY = 86_400_000;
const system = { type: 'system', id: null, role: null } as const;
const change = { actor: system, context: { ipAddress: null, device: null }, reason: 'test' };

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
  vi.spyOn(app.get(FilesService), 'prepare').mockResolvedValue();
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
    [`Banners ${accounts}`, `banners${accounts}@example.test`],
  );
  for (const role of roles) {
    await sql.query(
      'INSERT INTO identity.admin_account_roles (account_id, role_code) VALUES ($1, $2)',
      [rows[0].id, role],
    );
  }
  const accountId: string = rows[0].id;
  const { token } = await app
    .get(AdminSessionsService)
    .start(db.db, accountId, { ipAddress: '203.0.113.9', device: 'test' }, new Date());
  const cookies = { [ADMIN_SESSION_COOKIE]: token };
  // A create gets a fresh Idempotency-Key unless the test gives one.
  const call = (method: 'GET' | 'POST' | 'PUT', url: string, payload?: object, key?: string) =>
    app.inject({
      method,
      url,
      cookies,
      ...(method === 'POST' && url === '/v1/admin/banners'
        ? { headers: { 'idempotency-key': key ?? randomUUID() } }
        : {}),
      ...(payload ? { payload } : {}),
    });
  // A banner image this admin uploaded, its storage checks stubbed.
  const upload = async () => {
    const { rows: made } = await sql.query(
      `INSERT INTO files.uploads (purpose, key, content_type, size_bytes, created_by)
       VALUES ('banner_image', $1, 'image/jpeg', 1000, $2) RETURNING id`,
      [`incoming/${randomUUID()}.jpg`, accountId],
    );
    return made[0].id as string;
  };
  return { call, upload };
}

function restaurant(name: string) {
  return app.get(MerchantsService).createRestaurant(
    azaz,
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

const fields = (over: object = {}) => ({
  cityId: azaz,
  title: 'وجبات الشتاء',
  target: 'category',
  restaurantIds: [],
  categoryId: null,
  codeId: null,
  zoneIds: [],
  startsAt: new Date(Date.now() - 3_600_000).toISOString(),
  endsAt: new Date(Date.now() + 7 * DAY).toISOString(),
  ...over,
});

type Banners = {
  banners: { id: string; title: string; imageKey: string; target: string; code: string | null }[];
  canManage: boolean;
};

describe('«البانرات»', () => {
  it('lets DATA publish a banner for a category, and OPS only read', async () => {
    const category = await app.get(CategoriesService).create('حلويات', 'system');
    const data = await admin(['DATA']);
    const created = await data.call('POST', '/v1/admin/banners', {
      ...fields({ categoryId: category.id }),
      uploadId: await data.upload(),
    });
    expect(created.statusCode).toBe(201);
    const body: Banners = created.json();
    expect(body.canManage).toBe(true);
    expect(body.banners).toHaveLength(1);
    expect(body.banners[0]).toMatchObject({ title: 'وجبات الشتاء', target: 'category' });
    expect(body.banners[0]!.imageKey).toMatch(/^marketing\/banners\/[0-9a-f-]{36}\.jpg$/);

    const ops = await admin(['OPS']);
    const read = await ops.call('GET', `/v1/admin/banners?cityId=${azaz}`);
    expect(read.statusCode).toBe(200);
    expect((read.json() as Banners).canManage).toBe(false);
    const refused = await ops.call('POST', '/v1/admin/banners', {
      ...fields({ categoryId: category.id }),
      uploadId: await ops.upload(),
    });
    expect(refused.statusCode).toBe(403);
    const audit = await sql.query(
      "SELECT 1 FROM audit.events WHERE action = 'banner.create' AND target_id = $1",
      [body.banners[0]!.id],
    );
    expect(audit.rowCount).toBe(1);
  });

  it('refuses a wrong title, period or target, and a second use of the upload', async () => {
    const own = await admin(['OWN']);
    const id = await restaurant('مطعم البانر');
    const refusal = async (over: object) => {
      const answer = await own.call('POST', '/v1/admin/banners', {
        ...fields(over),
        uploadId: await own.upload(),
      });
      return [answer.statusCode, answer.json().error];
    };
    expect(await refusal({ title: '   ', target: 'restaurant', restaurantIds: [id] })).toEqual([
      400,
      'invalid_banner',
    ]);
    expect(
      await refusal({
        target: 'restaurant',
        restaurantIds: [id],
        endsAt: new Date(Date.now() - 1000).toISOString(),
      }),
    ).toEqual([400, 'invalid_banner']);
    expect(await refusal({ target: 'restaurant', restaurantIds: [id, id] })).toEqual([
      400,
      'invalid_banner',
    ]);
    expect(await refusal({ target: 'category', categoryId: randomUUID() })).toEqual([
      400,
      'invalid_banner',
    ]);
    expect(await refusal({ target: 'code', codeId: randomUUID() })).toEqual([
      400,
      'invalid_banner',
    ]);
    expect(
      await refusal({ target: 'restaurants', zoneIds: [randomUUID()], restaurantIds: [id] }),
    ).toEqual([400, 'invalid_banner']);

    const uploadId = await own.upload();
    const first = await own.call('POST', '/v1/admin/banners', {
      ...fields({ target: 'restaurant', restaurantIds: [id] }),
      uploadId,
    });
    expect(first.statusCode).toBe(201);
    const again = await own.call('POST', '/v1/admin/banners', {
      ...fields({ target: 'restaurant', restaurantIds: [id], title: 'آخر' }),
      uploadId,
    });
    expect([again.statusCode, again.json().error]).toEqual([409, 'upload_used']);
  });

  it('says an image that is not 1200×500 is the wrong size', async () => {
    const own = await admin(['OWN']);
    const id = await restaurant('مطعم المقاس');
    const files = app.get(FilesService);
    vi.mocked(files.prepare).mockRejectedValueOnce(
      new FilesRefusedError('upload_wrong_size', 'the image is 1280×500'),
    );
    const answer = await own.call('POST', '/v1/admin/banners', {
      ...fields({ target: 'restaurant', restaurantIds: [id] }),
      uploadId: await own.upload(),
    });
    expect([answer.statusCode, answer.json().error]).toEqual([400, 'upload_wrong_size']);
  });

  it('answers a repeated create from its key, and refuses the key with another body', async () => {
    const own = await admin(['OWN']);
    const id = await restaurant('مطعم المفتاح');
    const key = randomUUID();
    const body = {
      ...fields({ target: 'restaurant', restaurantIds: [id] }),
      uploadId: await own.upload(),
    };
    const first = await own.call('POST', '/v1/admin/banners', body, key);
    const count = (first.json() as Banners).banners.length;
    const repeat = await own.call('POST', '/v1/admin/banners', body, key);
    expect(repeat.statusCode).toBe(201);
    expect((repeat.json() as Banners).banners).toHaveLength(count);
    const other = await own.call('POST', '/v1/admin/banners', { ...body, title: 'غيره' }, key);
    expect([other.statusCode, other.json().error]).toEqual([422, 'idempotency_key_reused']);
  });

  it('targets a visible code by its code, orders, edits and removes', async () => {
    const own = await admin(['OWN']);
    const [{ id: codeId }] = (
      await sql.query(
        `INSERT INTO marketing.promo_codes (city_id, code, kind, percent_bp, currency, valid_from,
           valid_to, audience, restaurant_ids, zone_ids, funding, merchant_share_bp, visibility,
           created_by, updated_by)
         VALUES ($1, 'SHITA10', 'percentage', 1000, 'TRY', now() - interval '1 hour',
           now() + interval '3 days', 'everyone', '{}', '{}', 'platform', 0, 'visible',
           (SELECT id FROM identity.admin_accounts LIMIT 1), (SELECT id FROM identity.admin_accounts LIMIT 1))
         RETURNING id`,
        [azaz],
      )
    ).rows;
    const listed = await own.call('GET', `/v1/admin/banners?cityId=${azaz}`);
    expect(listed.json().codes).toContainEqual({ id: codeId, code: 'SHITA10' });
    const created = await own.call('POST', '/v1/admin/banners', {
      ...fields({ target: 'code', codeId, title: 'كود الشتاء' }),
      uploadId: await own.upload(),
    });
    expect(created.statusCode).toBe(201);
    const banners = (created.json() as Banners).banners;
    const last = banners.at(-1)!;
    expect(last).toMatchObject({ target: 'code', code: 'SHITA10' });

    const ids = banners.map((banner) => banner.id);
    const moved = [last.id, ...ids.slice(0, -1)];
    const ordered = await own.call('POST', '/v1/admin/banners/order', { cityId: azaz, ids: moved });
    expect((ordered.json() as Banners).banners.map((banner) => banner.id)).toEqual(moved);
    const stale = await own.call('POST', '/v1/admin/banners/order', {
      cityId: azaz,
      ids: ids.slice(1),
    });
    expect([stale.statusCode, stale.json().error]).toEqual([409, 'banners_changed']);

    const image = last.imageKey;
    const edited = await own.call('PUT', `/v1/admin/banners/${last.id}`, {
      ...fields({ target: 'code', codeId, title: 'كود الشتاء الجديد' }),
      uploadId: null,
    });
    expect(edited.statusCode).toBe(200);
    expect((edited.json() as Banners).banners[0]).toMatchObject({
      title: 'كود الشتاء الجديد',
      imageKey: image,
    });
    const newImage = await own.call('PUT', `/v1/admin/banners/${last.id}`, {
      ...fields({ target: 'code', codeId, title: 'كود الشتاء الجديد' }),
      uploadId: await own.upload(),
    });
    expect((newImage.json() as Banners).banners[0]!.imageKey).not.toBe(image);

    const removed = await own.call('POST', `/v1/admin/banners/${last.id}/remove`, { cityId: azaz });
    expect((removed.json() as Banners).banners.map((banner) => banner.id)).not.toContain(last.id);
    const twice = await own.call('POST', `/v1/admin/banners/${last.id}/remove`, { cityId: azaz });
    expect([twice.statusCode, twice.json().error]).toEqual([404, 'unknown_banner']);
  });

  it('never lets the application role delete a banner', async () => {
    await expect(sql.query('DELETE FROM marketing.banners')).rejects.toThrow(/permission denied/);
  });
});
