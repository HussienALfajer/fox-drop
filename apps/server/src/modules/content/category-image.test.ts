import 'reflect-metadata';
import { randomBytes } from 'node:crypto';
import type { NestFastifyApplication } from '@nestjs/platform-fastify';
import pg from 'pg';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { ApiModule } from '../../api.module.js';
import { createDatabase, type Database } from '../../database/database.js';
import { startTestDatabase, type TestDatabase } from '../../database/test-database.js';
import { createApiApp } from '../../http/create-api-app.js';
import { startTestStorage, type TestStorage } from '../../storage/test-storage.js';
import { startTestValkey, type TestValkey } from '../../valkey/test-valkey.js';
import { ADMIN_SESSION_COOKIE, AdminSessionsService } from '../identity/index.js';

// AP §9.13 «التصنيفات» (slice 2.27a): a category's icon or image, uploaded
// from the panel to public-media as a restaurant's logo is.
let database: TestDatabase;
let cache: TestValkey;
let storage: TestStorage;
let app: NestFastifyApplication;
let sql: pg.Pool;
let db: Database;

const jpeg = Buffer.concat([Buffer.from([0xff, 0xd8, 0xff, 0xe0]), randomBytes(60)]);

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
}, 300_000);

afterAll(async () => {
  await app?.close();
  await db?.pool.end();
  await sql?.end();
  await Promise.all([database?.stop(), cache?.stop(), storage?.stop()]);
});

async function admin(roles: string[]) {
  const { rows } = await sql.query(
    `INSERT INTO identity.admin_accounts (name, email, status, password_hash, totp_secret_encrypted)
     VALUES ('Editor', $1, 'active', 'not used', 'not used') RETURNING id`,
    [`image${roles.join()}@example.test`],
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

describe('a category’s image', () => {
  it('sets a category’s image from an upload, once', async () => {
    const data = await admin(['DATA']);
    const category = (
      await data('POST', '/v1/admin/content/categories', { name: 'حلويات' })
    ).json();
    const upload = await data('POST', '/v1/admin/uploads', {
      purpose: 'category_image',
      contentType: 'image/jpeg',
      sizeBytes: jpeg.length,
    });
    expect(upload.statusCode).toBe(201);
    const { uploadId, url } = upload.json();
    const put = await fetch(url, {
      method: 'PUT',
      body: jpeg,
      headers: { 'content-type': 'image/jpeg' },
    });
    expect(put.status).toBe(200);
    const set = await data('PUT', `/v1/admin/content/categories/${category.id}/image`, {
      uploadId,
    });
    expect(set.statusCode).toBe(200);
    const key = `content/categories/${new URL(url).pathname.split('/').at(-1)}`;
    expect(set.json().imageKey).toBe(key);
    // Again changes nothing; on another category it is taken.
    expect(
      (await data('PUT', `/v1/admin/content/categories/${category.id}/image`, { uploadId })).json(),
    ).toMatchObject({ imageKey: key });
    const other = (await data('POST', '/v1/admin/content/categories', { name: 'مشروبات' })).json();
    const used = await data('PUT', `/v1/admin/content/categories/${other.id}/image`, { uploadId });
    expect(used.statusCode).toBe(409);
    expect(used.json().error).toBe('upload_used');
  });
});
