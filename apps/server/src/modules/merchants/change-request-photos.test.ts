import 'reflect-metadata';
import { randomBytes, randomInt, randomUUID } from 'node:crypto';
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
import {
  ADMIN_SESSION_COOKIE,
  AdminSessionsService,
  CODE_SENDER,
  type DevelopmentCodeSender,
  MerchantAccountsService,
} from '../identity/index.js';
import { MerchantsService } from './index.js';

// The owners' photos (RA §9.2 «New or replaced photo», §9.5; slice 2.32b):
// uploaded from the restaurant app, shown to customers only once approved;
// the old photo stays until then. An owner adds an item with a photo, and
// customers see it only after the panel approves it (the slice's check).
let database: TestDatabase;
let cache: TestValkey;
let storage: TestStorage;
let app: NestFastifyApplication;
let sql: pg.Pool;
let db: Database;
let merchants: MerchantsService;
let azaz: string;

const system = { type: 'system', id: null, role: null } as const;
const change = { actor: system, context: { ipAddress: null, device: null }, reason: 'test' };
const tryAmount = (amount: bigint) => ({ amount, currency: 'TRY' });
const jpeg = () => Buffer.concat([Buffer.from([0xff, 0xd8, 0xff, 0xe0]), randomBytes(60)]);

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
  process.env.APP_UPLOAD_URL = storage.url;
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
}, 300_000);

afterAll(async () => {
  await app?.close();
  await db?.pool.end();
  await sql?.end();
  await Promise.all([database?.stop(), cache?.stop(), storage?.stop()]);
});

async function owner(restaurantId: string) {
  const phone = `+9639${randomInt(100_000_000).toString().padStart(8, '0')}`;
  await app
    .get(MerchantAccountsService)
    .addAccount(restaurantId, { role: 'owner', name: 'المالك', phone }, change);
  const deviceId = randomUUID();
  await app.inject({ method: 'POST', url: '/v1/merchant/auth/code', payload: { phone, deviceId } });
  const code = app.get<DevelopmentCodeSender>(CODE_SENDER).lastCode(phone);
  const signedIn = await app.inject({
    method: 'POST',
    url: '/v1/merchant/auth/sign-in',
    payload: { phone, deviceId, code },
  });
  const headers = { authorization: `Bearer ${signedIn.json().accessToken}` };
  return (method: 'GET' | 'PUT' | 'POST', url: string, payload?: object) =>
    app.inject({ method, url, headers, ...(payload === undefined ? {} : { payload }) });
}

async function ops() {
  const { rows } = await sql.query(
    `INSERT INTO identity.admin_accounts (name, email, status, password_hash, totp_secret_encrypted)
     VALUES ('Reviewer', $1, 'active', 'not used', 'not used') RETURNING id`,
    [`photos-${randomUUID()}@example.test`],
  );
  await sql.query(
    "INSERT INTO identity.admin_account_roles (account_id, role_code) VALUES ($1, 'OPS')",
    [rows[0].id],
  );
  const { token } = await app
    .get(AdminSessionsService)
    .start(db.db, rows[0].id, { ipAddress: '203.0.113.9', device: 'test' }, new Date());
  const call = (method: 'GET' | 'POST', url: string, payload?: object) =>
    app.inject({
      method,
      url: `/v1/admin/menu-change-requests${url}`,
      cookies: { [ADMIN_SESSION_COOKIE]: token },
      ...(payload === undefined ? {} : { payload }),
    });
  // «قبول» sends the version the reviewer saw, as the panel does.
  return async (method: 'GET' | 'POST', url: string, payload?: object) => {
    if (!url.endsWith('/approve')) return call(method, url, payload);
    const view = await call('GET', url.replace(/\/approve$/, ''));
    return call(method, url, { ...payload, seen: view.json().updatedAt });
  };
}

type Owner = Awaited<ReturnType<typeof owner>>;

// Asks for an upload and PUTs the bytes, as the restaurant app does.
async function uploaded(call: Owner): Promise<{ uploadId: string; key: string }> {
  const body = jpeg();
  const answer = await call('POST', '/v1/merchant/uploads/item-photo', {
    contentType: 'image/jpeg',
    sizeBytes: body.length,
  });
  expect(answer.statusCode).toBe(201);
  const { uploadId, url } = answer.json();
  const put = await fetch(url, { method: 'PUT', body, headers: { 'content-type': 'image/jpeg' } });
  expect(put.status).toBe(200);
  return { uploadId, key: `menu/items/${new URL(url).pathname.split('/').at(-1)}` };
}

async function restaurant() {
  const id = await merchants.createRestaurant(
    azaz,
    {
      nameAr: `مطعم ${randomUUID()}`,
      location: { latitude: 36.5866, longitude: 37.0463 },
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
    { categoryId: meals, name: 'شاورما', price: tryAmount(10_000n) },
    change,
  );
  return { id, meals, shawarma, owner: await owner(id) };
}

const customerItems = async (restaurantId: string) =>
  (await merchants.menu(restaurantId)).categories.flatMap((category) => category.items);

describe("the owners' photos (RA §9.2, §9.5)", () => {
  it('shows a new item with its photo to customers only after approval', async () => {
    const r = await restaurant();
    const photo = await uploaded(r.owner);
    const kebab = randomUUID();
    const asked = await r.owner('PUT', `/v1/merchant/menu/requests/items/${kebab}`, {
      categoryId: r.meals,
      name: 'كباب',
      description: null,
      price: { amount: '12000', currency: 'TRY' },
      uploadId: photo.uploadId,
    });
    expect(asked.statusCode).toBe(200);
    expect(asked.json().categories[0].items[1]).toMatchObject({
      id: kebab,
      photoKey: photo.key,
      pending: [expect.objectContaining({ field: 'created', photoKey: photo.key })],
    });
    expect((await customerItems(r.id)).map((item) => item.id)).toEqual([r.shawarma]);
    const reviewer = await ops();
    const [request] = (await reviewer('GET', `?cityId=${azaz}`))
      .json()
      .requests.filter((each: { restaurantId: string }) => each.restaurantId === r.id);
    expect((await reviewer('GET', `/${request.id}`)).json().after.photoKey).toBe(photo.key);
    await reviewer('POST', `/${request.id}/approve`, {});
    expect(await customerItems(r.id)).toEqual([
      expect.objectContaining({ id: r.shawarma }),
      expect.objectContaining({ id: kebab, photoKey: photo.key }),
    ]);
  });

  it('keeps the old photo until the new one is approved', async () => {
    const r = await restaurant();
    const first = await uploaded(r.owner);
    const second = await uploaded(r.owner);
    const photoOf = async () => (await customerItems(r.id))[0]!.photoKey;
    await r.owner('PUT', `/v1/merchant/menu/requests/items/${r.shawarma}/photo`, {
      uploadId: first.uploadId,
    });
    // A newer photo replaces the one waiting: one request per field.
    const replaced = await r.owner('PUT', `/v1/merchant/menu/requests/items/${r.shawarma}/photo`, {
      uploadId: second.uploadId,
    });
    expect(replaced.json().categories[0].items[0].pending).toEqual([
      expect.objectContaining({ field: 'photo', photoKey: second.key }),
    ]);
    expect(await photoOf()).toBeNull();
    const reviewer = await ops();
    const requests = (await reviewer('GET', `?cityId=${azaz}`))
      .json()
      .requests.filter((each: { restaurantId: string }) => each.restaurantId === r.id);
    expect(requests).toHaveLength(1);
    await reviewer('POST', `/${requests[0].id}/approve`, {});
    expect(await photoOf()).toBe(second.key);
  });
});
