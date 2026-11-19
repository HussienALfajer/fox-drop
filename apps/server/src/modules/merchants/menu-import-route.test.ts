import 'reflect-metadata';
import { randomBytes, randomUUID } from 'node:crypto';
import type { NestFastifyApplication } from '@nestjs/platform-fastify';
import ExcelJS from 'exceljs';
import pg from 'pg';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { ApiModule } from '../../api.module.js';
import { createDatabase, type Database } from '../../database/database.js';
import { startTestDatabase, type TestDatabase } from '../../database/test-database.js';
import { createApiApp } from '../../http/create-api-app.js';
import { startTestStorage, type TestStorage } from '../../storage/test-storage.js';
import { startTestValkey, type TestValkey } from '../../valkey/test-valkey.js';
import { FxService } from '../fx/index.js';
import { ADMIN_SESSION_COOKIE, AdminSessionsService } from '../identity/index.js';
import { MerchantsService } from './index.js';

// AP §9.6.6 «استيراد من Excel» (slice 2.31): the template, the upload, the
// validation report, the dry run and the import, through the routes.
let database: TestDatabase;
let cache: TestValkey;
let storage: TestStorage;
let app: NestFastifyApplication;
let sql: pg.Pool;
let db: Database;
let azaz: string;
let accounts = 0;

const system = { type: 'system', id: null, role: null } as const;
const change = { actor: system, context: { ipAddress: null, device: null }, reason: 'test' };
const XLSX = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';

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

async function admin(role: string) {
  accounts += 1;
  const { rows } = await sql.query(
    `INSERT INTO identity.admin_accounts (name, email, status, password_hash, totp_secret_encrypted)
     VALUES ($1, $2, 'active', 'not used', 'not used') RETURNING id`,
    [`Importer ${accounts}`, `import${accounts}@example.test`],
  );
  await sql.query(
    'INSERT INTO identity.admin_account_roles (account_id, role_code) VALUES ($1, $2)',
    [rows[0].id, role],
  );
  const { token } = await app
    .get(AdminSessionsService)
    .start(db.db, rows[0].id, { ipAddress: '203.0.113.9', device: 'test' }, new Date());
  const cookies = { [ADMIN_SESSION_COOKIE]: token };
  return (
    method: 'GET' | 'POST' | 'PUT',
    url: string,
    payload?: object,
    headers: Record<string, string> = {},
  ) => app.inject({ method, url, cookies, headers, ...(payload ? { payload } : {}) });
}

type Call = Awaited<ReturnType<typeof admin>>;

const key = () => randomUUID().replaceAll('-', '');

// Asks for an upload and PUTs the bytes, as the panel does.
async function uploaded(call: Call, body: Buffer, contentType = XLSX): Promise<string> {
  const answer = await call('POST', '/v1/admin/uploads', {
    purpose: 'menu_import',
    contentType,
    sizeBytes: body.length,
  });
  expect(answer.statusCode).toBe(201);
  const { uploadId, url } = answer.json();
  const put = await fetch(url, { method: 'PUT', body, headers: { 'content-type': contentType } });
  expect(put.status).toBe(200);
  return uploadId as string;
}

async function workbookOf(rows: (string | number)[][]): Promise<Buffer> {
  const workbook = new ExcelJS.Workbook();
  const sheet = workbook.addWorksheet('القائمة');
  for (const row of rows) sheet.addRow(row);
  return Buffer.from(await workbook.xlsx.writeBuffer());
}

async function activeRestaurant(): Promise<string> {
  const merchants = app.get(MerchantsService);
  const id = await merchants.createRestaurant(
    azaz,
    {
      nameAr: 'مطعم الاستيراد',
      location: { latitude: 36.5866, longitude: 37.0463 },
      coverage: { kind: 'radius', radiusMetres: 3000 },
      minimumOrder: { amount: 10_000n, currency: 'TRY' },
      commissionBp: 1500,
      defaultPrepMin: 20,
    },
    change,
  );
  await merchants.setAccountStatus(id, 'test', change);
  await merchants.setAccountStatus(id, 'active', change);
  return id;
}

const menuUrl = (id: string) => `/v1/admin/restaurant-drafts/${id}/menu`;

describe('the Excel import (AP §9.6.6)', () => {
  it('downloads the filled template, reports the errors, previews and imports once', async () => {
    const id = await activeRestaurant();
    const ops = await admin('OPS');
    const meals = randomUUID();
    const shawarma = randomUUID();
    const size = randomUUID();
    await ops('PUT', `${menuUrl(id)}/categories/${meals}`, {
      name: 'وجبات',
      hidden: false,
      window: null,
    });
    await ops('PUT', `${menuUrl(id)}/items/${shawarma}`, {
      categoryId: meals,
      code: 'A1',
      name: 'شاورما',
      description: null,
      price: { amount: '12050', currency: 'TRY' },
      hidden: false,
      badge: null,
    });
    await ops('PUT', `${menuUrl(id)}/option-groups/${size}`, {
      name: 'الحجم',
      minChoices: 0,
      maxChoices: 1,
    });
    await ops('PUT', `${menuUrl(id)}/option-groups/${size}/items`, { itemIds: [shawarma] });

    // The template holds the menu as it is.
    const template = await ops('GET', `${menuUrl(id)}/import-template`);
    expect(template.statusCode).toBe(200);
    const read = new ExcelJS.Workbook();
    await read.xlsx.load(
      Buffer.from(template.json().contentBase64, 'base64') as unknown as ArrayBuffer,
    );
    const sheet = read.worksheets[0]!;
    expect(sheet.getRow(1).values).toEqual([
      undefined,
      'رمز الصنف',
      'التصنيف',
      'الصنف',
      'الوصف',
      'السعر',
      'مجموعات الخيارات',
    ]);
    expect(sheet.getRow(2).values).toEqual([
      undefined,
      'A1',
      'وجبات',
      'شاورما',
      '',
      120.5,
      'الحجم',
    ]);

    // A file with a row error is reported and cannot be imported.
    const header = ['رمز الصنف', 'التصنيف', 'الصنف', 'الوصف', 'السعر', 'مجموعات الخيارات'];
    const broken = await uploaded(
      ops,
      await workbookOf([
        header,
        ['A1', 'وجبات', 'شاورما', '', 130, 'الحجم'],
        ['', 'حلويات', 'كنافة', '', 0, ''],
      ]),
    );
    const report = await ops('POST', `${menuUrl(id)}/import/dry-run`, { uploadId: broken });
    expect(report.statusCode).toBe(200);
    expect(report.json().errors).toEqual([{ row: 3, column: 'price', error: 'invalid_price' }]);
    expect(
      (
        await ops(
          'POST',
          `${menuUrl(id)}/import`,
          { uploadId: broken },
          { 'idempotency-key': key() },
        )
      ).json(),
    ).toMatchObject({ statusCode: 409, error: 'import_invalid' });

    // A good one: one price changed, a new category and item, nothing deleted.
    const good = await uploaded(
      ops,
      await workbookOf([
        header,
        ['A1', 'وجبات', 'شاورما', '', 130, 'الحجم'],
        ['', 'حلويات', 'كنافة', 'بالقشطة', '80.25', ''],
      ]),
    );
    const preview = (await ops('POST', `${menuUrl(id)}/import/dry-run`, { uploadId: good })).json();
    expect(preview).toMatchObject({
      fileError: null,
      errors: [],
      categoriesAdded: ['حلويات'],
      added: [{ row: 3, code: null, name: 'كنافة', price: '8025' }],
      changed: [{ row: 2, itemId: shawarma, fields: ['price'], price: '13000', oldPrice: '12050' }],
      unchanged: 0,
    });
    // DATA cannot change an active restaurant's prices by an import.
    const data = await admin('DATA');
    expect(
      (
        await data(
          'POST',
          `${menuUrl(id)}/import`,
          { uploadId: good },
          { 'idempotency-key': key() },
        )
      ).json(),
    ).toMatchObject({ statusCode: 403, error: 'price_edit_not_allowed' });
    const once = key();
    const imported = await ops(
      'POST',
      `${menuUrl(id)}/import`,
      { uploadId: good },
      { 'idempotency-key': once },
    );
    expect(imported.statusCode).toBe(200);
    expect(imported.json()).toEqual({ added: 1, changed: 1, unchanged: 0, categoriesAdded: 1 });
    expect(
      (
        await ops('POST', `${menuUrl(id)}/import`, { uploadId: good }, { 'idempotency-key': once })
      ).json(),
    ).toEqual({ added: 1, changed: 1, unchanged: 0, categoriesAdded: 1 });
    // The same file under another key was imported already.
    expect(
      (
        await ops('POST', `${menuUrl(id)}/import`, { uploadId: good }, { 'idempotency-key': key() })
      ).json(),
    ).toMatchObject({ statusCode: 409, error: 'upload_used' });

    const menu = (await ops('GET', menuUrl(id))).json();
    expect(menu.categories).toMatchObject([
      {
        name: 'وجبات',
        items: [{ id: shawarma, price: { amount: '13000' }, optionGroupIds: [size] }],
      },
      { name: 'حلويات', items: [{ code: 'I0002', name: 'كنافة', description: 'بالقشطة' }] },
    ]);
    const log = await sql.query(
      'SELECT old_price::text AS old, new_price::text AS new FROM merchants.price_changes WHERE restaurant_id = $1',
      [id],
    );
    expect(log.rows).toEqual([{ old: '12050', new: '13000' }]);
    const audit = await sql.query(
      "SELECT count(*)::int AS count FROM audit.events WHERE action = 'menu.import' AND target_id = $1",
      [id],
    );
    expect(audit.rows[0].count).toBe(1);
  });

  it('refuses a file that is not a workbook, and an upload too large', async () => {
    const id = await activeRestaurant();
    const ops = await admin('OPS');
    const fake = await uploaded(ops, Buffer.from('not a workbook at all'));
    expect(
      (await ops('POST', `${menuUrl(id)}/import/dry-run`, { uploadId: fake })).json(),
    ).toMatchObject({ statusCode: 400, error: 'upload_invalid' });
    expect(
      (
        await ops('POST', '/v1/admin/uploads', {
          purpose: 'menu_import',
          contentType: XLSX,
          sizeBytes: 3 * 1024 * 1024,
        })
      ).json(),
    ).toMatchObject({ statusCode: 400, error: 'invalid_upload' });
    expect(
      (
        await ops('POST', '/v1/admin/uploads', {
          purpose: 'menu_import',
          contentType: 'image/png',
          sizeBytes: 100,
        })
      ).json(),
    ).toMatchObject({ statusCode: 400, error: 'invalid_upload' });
  });
});
