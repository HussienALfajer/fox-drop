import 'reflect-metadata';
import { randomBytes, randomUUID } from 'node:crypto';
import type { NestFastifyApplication } from '@nestjs/platform-fastify';
import pg from 'pg';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { ApiModule } from '../../api.module.js';
import { createDatabase, type Database } from '../../database/database.js';
import { startTestDatabase, type TestDatabase } from '../../database/test-database.js';
import { createApiApp } from '../../http/create-api-app.js';
import { startTestStorage, type TestStorage } from '../../storage/test-storage.js';
import { startTestValkey, type TestValkey } from '../../valkey/test-valkey.js';
import { FxService } from '../fx/index.js';
import { GeoService } from '../geo/index.js';
import { ADMIN_SESSION_COOKIE, AdminSessionsService } from '../identity/index.js';
import { MerchantsService } from './index.js';

// The panel's «الصور» (slice 2.5; AP §9.6.3, §9.6.6): an admin uploads a logo,
// a cover and an item photo, and the customer's restaurant page shows them.
let database: TestDatabase;
let cache: TestValkey;
let storage: TestStorage;
let app: NestFastifyApplication;
let sql: pg.Pool;
let db: Database;
let merchants: MerchantsService;
let azaz: string;
let accounts = 0;

const system = { type: 'system', id: null, role: null } as const;
const change = { actor: system, context: { ipAddress: null, device: null }, reason: 'test' };
const tryAmount = (amount: bigint) => ({ amount, currency: 'TRY' });
const jpeg = Buffer.concat([Buffer.from([0xff, 0xd8, 0xff, 0xe0]), randomBytes(60)]);
const point = { latitude: 36.5866, longitude: 37.0463 };

beforeAll(async () => {
  [database, cache, storage] = await Promise.all([
    startTestDatabase(),
    startTestValkey(),
    startTestStorage(),
  ]);
  process.env.DATABASE_URL = database.appUrl;
  process.env.VALKEY_URL = cache.url;
  process.env.IDENTITY_ENCRYPTION_KEY = randomBytes(32).toString('base64');
  process.env.FOX_DROP_ENVIRONMENT = 'development';
  process.env.STORAGE_URL = storage.url;
  process.env.STORAGE_KEY_ID = storage.key.id;
  process.env.STORAGE_SECRET = storage.key.secret;
  process.env.ADMIN_PANEL_URL = storage.url;
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
    { latitude: point.latitude - half, longitude: point.longitude - half },
    { latitude: point.latitude - half, longitude: point.longitude + half },
    { latitude: point.latitude + half, longitude: point.longitude + half },
    { latitude: point.latitude + half, longitude: point.longitude - half },
  ];
  await app.get(GeoService).createZone(azaz, { name: 'المركز', area, active: true }, change);
}, 300_000);

afterAll(async () => {
  await app?.close();
  await db?.pool.end();
  await sql?.end();
  await Promise.all([database?.stop(), cache?.stop(), storage?.stop()]);
});

async function admin(roles: string[]) {
  accounts += 1;
  const { rows } = await sql.query(
    `INSERT INTO identity.admin_accounts (name, email, status, password_hash, totp_secret_encrypted)
     VALUES ($1, $2, 'active', 'not used', 'not used') RETURNING id`,
    [`Editor ${accounts}`, `images${accounts}@example.test`],
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

type Call = Awaited<ReturnType<typeof admin>>;

// Asks for an upload and PUTs the bytes, as the panel does.
async function uploaded(call: Call, purpose: string, body = jpeg) {
  const answer = await call('POST', '/v1/admin/uploads', {
    purpose,
    contentType: 'image/jpeg',
    sizeBytes: body.length,
  });
  expect(answer.statusCode).toBe(201);
  const { uploadId, url, key } = answer.json();
  const put = await fetch(url, {
    method: 'PUT',
    body,
    headers: { 'content-type': 'image/jpeg' },
  });
  expect(put.status).toBe(200);
  return { uploadId: uploadId as string, key: key as string };
}

async function restaurant() {
  const id = await merchants.createRestaurant(
    azaz,
    {
      nameAr: `مطعم ${randomUUID()}`,
      location: point,
      coverage: { kind: 'radius', radiusMetres: 3000 },
      minimumOrder: tryAmount(10_000n),
      commissionBp: 1500,
      defaultPrepMin: 20,
    },
    change,
  );
  await merchants.setAccountStatus(id, 'active', change);
  const meals = await merchants.addCategory(id, { name: 'وجبات' }, change);
  const shawarma = await merchants.addItem(
    id,
    { categoryId: meals, name: 'شاورما', price: tryAmount(12_000n) },
    change,
  );
  return { id, shawarma };
}

describe('the panel’s images', () => {
  it('sets an item photo, a logo and a cover, and the customer sees them', async () => {
    const own = await admin(['OWN']);
    const { id, shawarma } = await restaurant();

    const photo = await uploaded(own, 'item_photo');
    const set = await own('PUT', `/v1/admin/restaurants/${id}/items/${shawarma}/photo`, {
      uploadId: photo.uploadId,
    });
    expect(set.statusCode).toBe(200);
    expect(set.json()).toEqual({ key: photo.key });
    const logo = await uploaded(own, 'restaurant_logo');
    expect(
      (await own('PUT', `/v1/admin/restaurants/${id}/logo`, { uploadId: logo.uploadId }))
        .statusCode,
    ).toBe(200);
    const cover = await uploaded(own, 'restaurant_cover');
    expect(
      (await own('PUT', `/v1/admin/restaurants/${id}/cover`, { uploadId: cover.uploadId }))
        .statusCode,
    ).toBe(200);

    const images = await own('GET', `/v1/admin/restaurants/${id}/images`);
    expect(images.json()).toEqual({
      logoKey: logo.key,
      coverKey: cover.key,
      categories: [
        expect.objectContaining({ items: [{ id: shawarma, name: 'شاورما', photoKey: photo.key }] }),
      ],
    });
    const list = await own('GET', `/v1/admin/restaurants?cityId=${azaz}`);
    expect(list.json().restaurants).toContainEqual({ id, nameAr: expect.any(String) });

    const page = await app.inject({
      method: 'GET',
      url: `/v1/customer/restaurants/${id}?latitude=${point.latitude}&longitude=${point.longitude}`,
    });
    expect(page.statusCode).toBe(200);
    expect(page.json()).toMatchObject({ logoKey: logo.key, coverKey: cover.key });
    expect(page.json().menu[0].items[0].photoKey).toBe(photo.key);

    const { rows } = await sql.query(
      `SELECT action, changes FROM audit.events
       WHERE target_id = $1 AND action IN ('menu.item.photo', 'restaurant.logo', 'restaurant.cover')
          OR target_id = $2 AND action = 'menu.item.photo'
       ORDER BY occurred_at`,
      [id, shawarma],
    );
    expect(rows.map((row) => row.action)).toEqual([
      'menu.item.photo',
      'restaurant.logo',
      'restaurant.cover',
    ]);
    expect(rows[0].changes).toEqual({ key: { before: null, after: photo.key } });
  });

  it('replaces a photo, takes a repeat as done, and refuses an upload used elsewhere', async () => {
    const own = await admin(['OWN']);
    const first = await restaurant();
    const second = await restaurant();
    const url = (r: { id: string; shawarma: string }) =>
      `/v1/admin/restaurants/${r.id}/items/${r.shawarma}/photo`;

    const photo = await uploaded(own, 'item_photo');
    expect((await own('PUT', url(first), { uploadId: photo.uploadId })).statusCode).toBe(200);
    expect((await own('PUT', url(first), { uploadId: photo.uploadId })).json()).toEqual({
      key: photo.key,
    });
    const used = await own('PUT', url(second), { uploadId: photo.uploadId });
    expect(used.statusCode).toBe(409);
    expect(used.json().error).toBe('upload_used');

    const newer = await uploaded(own, 'item_photo');
    expect((await own('PUT', url(first), { uploadId: newer.uploadId })).statusCode).toBe(200);
    const menu = await merchants.menu(first.id);
    expect(menu.categories[0]!.items[0]!.photoKey).toBe(newer.key);
  });

  it('refuses a logo upload as a cover, a file never uploaded and an unknown item', async () => {
    const own = await admin(['OWN']);
    const { id, shawarma } = await restaurant();
    const logo = await uploaded(own, 'restaurant_logo');
    const wrong = await own('PUT', `/v1/admin/restaurants/${id}/cover`, {
      uploadId: logo.uploadId,
    });
    expect([wrong.statusCode, wrong.json().error]).toEqual([400, 'upload_wrong_purpose']);

    const asked = await own('POST', '/v1/admin/uploads', {
      purpose: 'item_photo',
      contentType: 'image/jpeg',
      sizeBytes: jpeg.length,
    });
    const missing = await own('PUT', `/v1/admin/restaurants/${id}/items/${shawarma}/photo`, {
      uploadId: asked.json().uploadId,
    });
    expect([missing.statusCode, missing.json().error]).toEqual([409, 'upload_missing']);

    const photo = await uploaded(own, 'item_photo');
    const unknown = await own('PUT', `/v1/admin/restaurants/${id}/items/${randomUUID()}/photo`, {
      uploadId: photo.uploadId,
    });
    expect([unknown.statusCode, unknown.json().error]).toEqual([404, 'unknown_menu_row']);
  });
});
