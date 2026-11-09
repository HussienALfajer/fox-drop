import 'reflect-metadata';
import { randomBytes } from 'node:crypto';
import type { NestFastifyApplication } from '@nestjs/platform-fastify';
import pg from 'pg';
import { GetObjectCommand, S3Client } from '@aws-sdk/client-s3';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { ApiModule } from '../../api.module.js';
import { createDatabase, type Database } from '../../database/database.js';
import { startTestDatabase, type TestDatabase } from '../../database/test-database.js';
import { createApiApp } from '../../http/create-api-app.js';
import { startTestStorage, type TestStorage } from '../../storage/test-storage.js';
import { startTestValkey, type TestValkey } from '../../valkey/test-valkey.js';
import { ADMIN_SESSION_COOKIE, AdminSessionsService } from '../identity/index.js';
import { FilesRefusedError, FilesService, hasImageSignature } from './files.service.js';

// Architecture §5.8 on a real Garage: the pre-signed upload, the storage
// refusing another body, and the checks before a record links the file.
let database: TestDatabase;
let cache: TestValkey;
let storage: TestStorage;
let app: NestFastifyApplication;
let sql: pg.Pool;
let db: Database;
let files: FilesService;
let accounts = 0;

const png = Buffer.concat([
  Buffer.from([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a]),
  randomBytes(40),
]);

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
  // The panel's origin forwards /public-media to the storage; here the test
  // uploads to the storage itself.
  process.env.STORAGE_URL = storage.url;
  process.env.STORAGE_KEY_ID = storage.key.id;
  process.env.STORAGE_SECRET = storage.key.secret;
  process.env.ADMIN_PANEL_URL = storage.url;
  sql = new pg.Pool({ connectionString: database.appUrl });
  db = createDatabase(database.appUrl);
  app = await createApiApp(ApiModule);
  await app.init();
  await app.getHttpAdapter().getInstance().ready();
  files = app.get(FilesService);
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
    [`Uploader ${accounts}`, `uploader${accounts}@example.test`],
  );
  const accountId: string = rows[0].id;
  for (const role of roles) {
    await sql.query(
      'INSERT INTO identity.admin_account_roles (account_id, role_code) VALUES ($1, $2)',
      [accountId, role],
    );
  }
  const { token } = await app
    .get(AdminSessionsService)
    .start(db.db, accountId, { ipAddress: '203.0.113.9', device: 'test' }, new Date());
  return { accountId, cookies: { [ADMIN_SESSION_COOKIE]: token } };
}

async function ask(roles: string[], payload: object) {
  const { cookies } = await admin(roles);
  return app.inject({ method: 'POST', url: '/v1/admin/uploads', cookies, payload });
}

const put = (url: string, body: Buffer, type = 'image/png') =>
  fetch(url, { method: 'PUT', body, headers: { 'content-type': type } });

// Both halves of linking, as the merchants module calls them.
const claim = async (uploadId: string, purpose = 'item_photo' as const, now?: Date) => {
  await files.prepare(uploadId, purpose, now);
  return db.db.transaction((tx) => files.link(tx, uploadId, now));
};

// The stored object, as imgproxy reads it.
const stored = async (key: string) =>
  Buffer.from(
    await new S3Client({
      endpoint: storage.url,
      region: 'garage',
      forcePathStyle: true,
      credentials: { accessKeyId: storage.reader.id, secretAccessKey: storage.reader.secret },
    })
      .send(new GetObjectCommand({ Bucket: 'public-media', Key: key }))
      .then((object) => object.Body!.transformToByteArray()),
  );

async function refusal(promise: Promise<unknown>) {
  const error = await promise.catch((caught: unknown) => caught);
  expect(error).toBeInstanceOf(FilesRefusedError);
  return (error as FilesRefusedError).refusal;
}

describe('POST /v1/admin/uploads', () => {
  it('signs a PUT of the exact type and size, and the storage refuses another body', async () => {
    const response = await ask(['OWN'], {
      purpose: 'item_photo',
      contentType: 'image/png',
      sizeBytes: png.length,
    });
    expect(response.statusCode).toBe(201);
    const upload = response.json();
    const name = /^\/public-media\/incoming\/([0-9a-f-]{36}\.png)$/.exec(
      new URL(upload.url).pathname,
    )?.[1];
    expect(name).toBeDefined();

    expect((await put(upload.url, Buffer.concat([png, Buffer.from('x')]))).status).toBe(403);
    expect((await put(upload.url, png, 'image/jpeg')).status).toBe(403);
    expect((await put(upload.url, png)).status).toBe(200);

    const key = `menu/items/${name}`;
    expect(await claim(upload.uploadId)).toEqual({ key, alreadyLinked: false });
    const { rows } = await sql.query('SELECT linked_at FROM files.uploads WHERE id = $1', [
      upload.uploadId,
    ]);
    expect(rows[0].linked_at).not.toBeNull();
    expect(await claim(upload.uploadId)).toEqual({ key, alreadyLinked: true });

    // The URL still writes for its 10 minutes, but only to incoming/: the
    // published file, checked once, never changes.
    const other = Buffer.concat([png.subarray(0, 8), Buffer.alloc(png.length - 8)]);
    expect((await put(upload.url, other)).status).toBe(200);
    expect(await stored(key)).toEqual(png);
  });

  it('lets each role upload what it may set (AP §6.2, §9.6.3 step 1)', async () => {
    const body = { contentType: 'image/png', sizeBytes: 100 };
    expect((await ask(['DATA'], { ...body, purpose: 'item_photo' })).statusCode).toBe(201);
    expect((await ask(['DATA'], { ...body, purpose: 'restaurant_logo' })).statusCode).toBe(201);
    expect((await ask(['OPS'], { ...body, purpose: 'restaurant_cover' })).statusCode).toBe(201);
    // FIN reads no restaurant and edits no menu.
    expect((await ask(['FIN'], { ...body, purpose: 'item_photo' })).statusCode).toBe(403);
  });

  it('refuses another type and a file over 8 MB', async () => {
    const big = await ask(['OWN'], {
      purpose: 'item_photo',
      contentType: 'image/png',
      sizeBytes: 8 * 1024 * 1024 + 1,
    });
    expect(big.statusCode).toBe(400);
    const gif = await ask(['OWN'], {
      purpose: 'item_photo',
      contentType: 'image/gif',
      sizeBytes: 10,
    });
    expect(gif.statusCode).toBe(400);
  });
});

describe('FilesService.prepare and link', () => {
  async function upload(body: Buffer, purpose: 'item_photo' | 'restaurant_logo' = 'item_photo') {
    const { accountId } = await admin(['OWN']);
    return files.createUpload(
      { purpose, contentType: 'image/png', sizeBytes: body.length },
      accountId,
    );
  }

  it('refuses an unknown upload and one for another purpose', async () => {
    expect(await refusal(claim('00000000-0000-7000-8000-000000000000'))).toBe('upload_not_found');
    const logo = await upload(png, 'restaurant_logo');
    expect(await refusal(claim(logo.uploadId))).toBe('upload_wrong_purpose');
  });

  it('refuses a file never uploaded, and an upload older than an hour', async () => {
    const missing = await upload(png);
    expect(await refusal(claim(missing.uploadId))).toBe('upload_missing');
    const late = new Date(Date.now() + 61 * 60 * 1000);
    expect(await refusal(claim(missing.uploadId, 'item_photo', late))).toBe('upload_expired');
  });

  it('refuses bytes that are not the image type asked for', async () => {
    const text = Buffer.from('<html>not an image at all</html>');
    const fake = await upload(text);
    expect((await put(fake.url, text)).status).toBe(200);
    expect(await refusal(claim(fake.uploadId))).toBe('upload_invalid');
    const { rows } = await sql.query('SELECT linked_at FROM files.uploads WHERE id = $1', [
      fake.uploadId,
    ]);
    expect(rows[0].linked_at).toBeNull();
  });

  it('never lets the application role delete an upload', async () => {
    await expect(sql.query('DELETE FROM files.uploads')).rejects.toThrow(/permission denied/);
  });
});

describe('hasImageSignature', () => {
  it('reads the signatures of JPEG, PNG and WebP', () => {
    expect(hasImageSignature('image/jpeg', Uint8Array.from([0xff, 0xd8, 0xff, 0xe0]))).toBe(true);
    expect(hasImageSignature('image/png', png)).toBe(true);
    const webp = Buffer.from('RIFF\0\0\0\0WEBPVP8 ', 'latin1');
    expect(hasImageSignature('image/webp', webp)).toBe(true);
    expect(hasImageSignature('image/webp', Buffer.from('RIFF\0\0\0\0WAVE', 'latin1'))).toBe(false);
    expect(hasImageSignature('image/jpeg', png)).toBe(false);
  });
});
