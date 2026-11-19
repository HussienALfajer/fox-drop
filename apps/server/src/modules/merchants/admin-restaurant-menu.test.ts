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
import { MerchantsService } from './index.js';

// The wizard's step 7 (AP §9.6.3, §9.6.6; slice 2.30b): the basic menu of a
// draft or a restaurant in test mode, set by the ids the panel names.
let database: TestDatabase;
let cache: TestValkey;
let app: NestFastifyApplication;
let sql: pg.Pool;
let db: Database;
let azaz: string;
let accounts = 0;

const system = { type: 'system', id: null, role: null } as const;
const change = { actor: system, context: { ipAddress: null, device: null }, reason: 'test' };

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
  azaz = (await sql.query("SELECT id FROM geo.cities WHERE code = 'AZ'")).rows[0].id;
  const fx = app.get(FxService);
  await fx.setCityCurrency(azaz, { currency: 'TRY', displayOrder: 1, enabled: true }, change);
  await fx.setBaseCurrency(azaz, 'TRY', change);
}, 300_000);

afterAll(async () => {
  await app?.close();
  await db?.pool.end();
  await sql?.end();
  await Promise.all([database?.stop(), cache?.stop()]);
});

async function admin(role: string) {
  accounts += 1;
  const { rows } = await sql.query(
    `INSERT INTO identity.admin_accounts (name, email, status, password_hash, totp_secret_encrypted)
     VALUES ($1, $2, 'active', 'not used', 'not used') RETURNING id`,
    [`Admin ${accounts}`, `menu${accounts}@example.test`],
  );
  await sql.query(
    'INSERT INTO identity.admin_account_roles (account_id, role_code) VALUES ($1, $2)',
    [rows[0].id, role],
  );
  const { token } = await app
    .get(AdminSessionsService)
    .start(db.db, rows[0].id, { ipAddress: '203.0.113.9', device: 'test' }, new Date());
  const cookies = { [ADMIN_SESSION_COOKIE]: token };
  return (method: 'GET' | 'PUT', url: string, payload?: object) =>
    app.inject({
      method,
      url: `/v1/admin/restaurant-drafts${url}`,
      cookies,
      ...(payload ? { payload } : {}),
    });
}

type Call = Awaited<ReturnType<typeof admin>>;

async function draft(data: Call): Promise<string> {
  const id = randomUUID();
  const started = await data('PUT', `/${id}/basics`, {
    cityId: azaz,
    nameAr: 'مطعم القائمة',
    nameEn: null,
    categoryIds: [],
    description: null,
  });
  expect(started.statusCode).toBe(200);
  return id;
}

const category = (name: string, extra: object = {}) => ({
  name,
  hidden: false,
  window: null,
  ...extra,
});

const item = (categoryId: string, name: string, extra: object = {}) => ({
  categoryId,
  code: null,
  name,
  description: null,
  price: { amount: '12000', currency: 'TRY' },
  hidden: false,
  badge: null,
  ...extra,
});

async function audits(action: string, target: string): Promise<number> {
  const { rows } = await sql.query(
    'SELECT count(*)::int AS count FROM audit.events WHERE action = $1 AND target_id = $2',
    [action, target],
  );
  return rows[0].count;
}

describe('step 7, the basic menu', () => {
  it('lets DATA build a draft menu: categories, items, codes, order, hiding and availability', async () => {
    const data = await admin('DATA');
    const id = await draft(data);
    const meals = randomUUID();
    const drinks = randomUUID();
    const breakfast = { startsAt: 360, endsAt: 720 };
    expect(
      (await data('PUT', `/${id}/menu/categories/${meals}`, category('وجبات'))).statusCode,
    ).toBe(200);
    await data(
      'PUT',
      `/${id}/menu/categories/${drinks}`,
      category('مشروبات', { window: breakfast }),
    );
    const shawarma = randomUUID();
    const juice = randomUUID();
    const added = await data('PUT', `/${id}/menu/items/${shawarma}`, item(meals, 'شاورما'));
    expect(added.statusCode).toBe(200);
    await data('PUT', `/${id}/menu/items/${juice}`, item(meals, 'عصير', { code: 'J1' }));
    // The same save again changes nothing.
    await data('PUT', `/${id}/menu/categories/${meals}`, category('وجبات'));
    expect(await audits('menu.category.create', meals)).toBe(1);
    expect(await audits('menu.category.update', meals)).toBe(0);

    // The item moves to its category's end, with its badge, and hides.
    const edited = await data(
      'PUT',
      `/${id}/menu/items/${juice}`,
      item(drinks, 'عصير برتقال', {
        code: null,
        description: 'طازج',
        price: { amount: '9000', currency: 'TRY' },
        badge: 'new',
        hidden: true,
      }),
    );
    expect(edited.statusCode).toBe(200);
    await data('PUT', `/${id}/menu/category-order`, { categoryIds: [drinks, meals] });
    await data('PUT', `/${id}/menu/availability`, {
      type: 'item',
      id: shawarma,
      available: false,
    });
    const menu = await data('GET', `/${id}/menu`);
    expect(menu.statusCode).toBe(200);
    expect(menu.json()).toMatchObject({
      accountStatus: 'draft',
      editable: true,
      categories: [
        {
          id: drinks,
          name: 'مشروبات',
          window: breakfast,
          items: [
            {
              id: juice,
              code: 'J1',
              name: 'عصير برتقال',
              description: 'طازج',
              price: { amount: '9000', currency: 'TRY' },
              hidden: true,
              badge: 'new',
            },
          ],
        },
        {
          id: meals,
          items: [{ id: shawarma, code: 'I0001', switchedOff: { until: null } }],
        },
      ],
    });
    expect(await audits('menu.item.update', juice)).toBe(1);
  });

  it('orders the items of a category', async () => {
    const ops = await admin('OPS');
    const id = await draft(ops);
    const meals = randomUUID();
    await ops('PUT', `/${id}/menu/categories/${meals}`, category('وجبات'));
    const [a, b, c] = [randomUUID(), randomUUID(), randomUUID()];
    for (const [each, name] of [
      [a, 'أ'],
      [b, 'ب'],
      [c, 'ج'],
    ] as const) {
      await ops('PUT', `/${id}/menu/items/${each}`, item(meals, name));
    }
    const ordered = await ops('PUT', `/${id}/menu/categories/${meals}/item-order`, {
      itemIds: [c, a, b],
    });
    expect(ordered.json().categories[0].items.map((each: { id: string }) => each.id)).toEqual([
      c,
      a,
      b,
    ]);
    const missing = await ops('PUT', `/${id}/menu/categories/${meals}/item-order`, {
      itemIds: [c, a],
    });
    expect(missing.json()).toMatchObject({ statusCode: 400, error: 'invalid_menu' });
  });

  it('maps the refusals', async () => {
    const data = await admin('DATA');
    const id = await draft(data);
    const other = await draft(data);
    const meals = randomUUID();
    const elsewhere = randomUUID();
    await data('PUT', `/${id}/menu/categories/${meals}`, category('وجبات'));
    await data('PUT', `/${other}/menu/categories/${elsewhere}`, category('وجبات'));
    expect(
      (
        await data(
          'PUT',
          `/${id}/menu/items/${randomUUID()}`,
          item(meals, 'مجاني', { price: { amount: '0', currency: 'TRY' } }),
        )
      ).json(),
    ).toMatchObject({ statusCode: 400, error: 'invalid_menu' });
    expect(
      (
        await data('PUT', `/${id}/menu/categories/${randomUUID()}`, {
          ...category('فطور'),
          window: { startsAt: 600, endsAt: 600 },
        })
      ).json(),
    ).toMatchObject({ statusCode: 400, error: 'invalid_menu' });
    await data('PUT', `/${id}/menu/items/${randomUUID()}`, item(meals, 'أ', { code: 'A1' }));
    expect(
      (
        await data('PUT', `/${id}/menu/items/${randomUUID()}`, item(meals, 'ب', { code: 'A1' }))
      ).json(),
    ).toMatchObject({ statusCode: 409, error: 'item_code_taken' });
    // Another restaurant's category and row are not this one's.
    expect(
      (await data('PUT', `/${id}/menu/items/${randomUUID()}`, item(elsewhere, 'ج'))).json(),
    ).toMatchObject({ statusCode: 404, error: 'unknown_menu_row' });
    expect(
      (await data('PUT', `/${other}/menu/categories/${meals}`, category('سرقة'))).json(),
    ).toMatchObject({ statusCode: 404, error: 'unknown_menu_row' });
    expect(
      (await data('PUT', `/${randomUUID()}/menu/categories/${randomUUID()}`, category('x'))).json(),
    ).toMatchObject({ statusCode: 404, error: 'unknown_restaurant' });
    // FIN reads no menu and edits none.
    const fin = await admin('FIN');
    expect((await fin('GET', `/${id}/menu`)).statusCode).toBe(403);
    expect((await fin('PUT', `/${id}/menu/categories/${meals}`, category('x'))).statusCode).toBe(
      403,
    );
  });

  it('edits the menu past test mode, logs every price and tells the owners while active', async () => {
    const merchants = app.get(MerchantsService);
    const id = await merchants.createRestaurant(
      azaz,
      {
        nameAr: 'مطعم فعّال',
        location: { latitude: 36.5866, longitude: 37.0463 },
        coverage: { kind: 'radius', radiusMetres: 3000 },
        minimumOrder: { amount: 10_000n, currency: 'TRY' },
        commissionBp: 1500,
        defaultPrepMin: 20,
      },
      change,
    );
    const ops = await admin('OPS');
    const data = await admin('DATA');
    const meals = randomUUID();
    const shawarma = randomUUID();
    await ops('PUT', `/${id}/menu/categories/${meals}`, category('وجبات'));
    await ops('PUT', `/${id}/menu/items/${shawarma}`, item(meals, 'شاورما'));
    // A draft's price change is logged, and told to no one.
    await data(
      'PUT',
      `/${id}/menu/items/${shawarma}`,
      item(meals, 'شاورما', { price: { amount: '13000', currency: 'TRY' } }),
    );
    const log = async () =>
      (
        await sql.query(
          `SELECT old_price::text AS old, new_price::text AS new, currency, changed_by_type AS by
             FROM merchants.price_changes WHERE item_id = $1 ORDER BY id`,
          [shawarma],
        )
      ).rows;
    const told = async () =>
      (
        await sql.query(
          `SELECT payload FROM merchants.state_outbox
            WHERE restaurant_id = $1 AND kind = 'price_change' ORDER BY id`,
          [id],
        )
      ).rows.map((row) => row.payload.values);
    expect(await log()).toEqual([{ old: '12000', new: '13000', currency: 'TRY', by: 'admin' }]);
    expect(await told()).toEqual([]);

    await merchants.setAccountStatus(id, 'test', change);
    await merchants.setAccountStatus(id, 'active', change);
    expect((await ops('GET', `/${id}/menu`)).json()).toMatchObject({
      accountStatus: 'active',
      editable: true,
      pricesLocked: false,
    });
    expect((await data('GET', `/${id}/menu`)).json()).toMatchObject({ pricesLocked: true });
    // OPS changes the price of an active restaurant: logged and told.
    const raised = await ops(
      'PUT',
      `/${id}/menu/items/${shawarma}`,
      item(meals, 'شاورما', { price: { amount: '15000', currency: 'TRY' } }),
    );
    expect(raised.statusCode).toBe(200);
    // The same save again logs nothing.
    await ops(
      'PUT',
      `/${id}/menu/items/${shawarma}`,
      item(meals, 'شاورما', { price: { amount: '15000', currency: 'TRY' } }),
    );
    expect(await log()).toHaveLength(2);
    expect((await log())[1]).toEqual({ old: '13000', new: '15000', currency: 'TRY', by: 'admin' });
    expect(await told()).toEqual([
      { itemId: shawarma, name: 'شاورما', oldPrice: '13000', newPrice: '15000', currency: 'TRY' },
    ]);

    // DATA edits the names and the switches of an active restaurant, never
    // its prices (AP §9.6.5 «DATA only before activation»).
    expect(
      (await data('PUT', `/${id}/menu/categories/${meals}`, category('أطباق'))).statusCode,
    ).toBe(200);
    expect(
      (
        await data(
          'PUT',
          `/${id}/menu/items/${shawarma}`,
          item(meals, 'شاورما لحم', { price: { amount: '15000', currency: 'TRY' } }),
        )
      ).statusCode,
    ).toBe(200);
    expect(
      (
        await data(
          'PUT',
          `/${id}/menu/items/${shawarma}`,
          item(meals, 'شاورما لحم', { price: { amount: '16000', currency: 'TRY' } }),
        )
      ).json(),
    ).toMatchObject({ statusCode: 403, error: 'price_edit_not_allowed' });
    expect(
      (await data('PUT', `/${id}/menu/items/${randomUUID()}`, item(meals, 'جديد'))).json(),
    ).toMatchObject({ statusCode: 403, error: 'price_edit_not_allowed' });
    expect(
      (
        await data('PUT', `/${id}/menu/availability`, {
          type: 'item',
          id: shawarma,
          available: false,
        })
      ).statusCode,
    ).toBe(200);
    expect(await log()).toHaveLength(2);

    // A terminated restaurant's menu is read only.
    await merchants.setAccountStatus(id, 'terminated', change);
    expect(
      (await ops('PUT', `/${id}/menu/categories/${meals}`, category('وجبات'))).json(),
    ).toMatchObject({ statusCode: 403, error: 'restaurant_terminated' });
    expect((await ops('GET', `/${id}/menu`)).json()).toMatchObject({
      accountStatus: 'terminated',
      editable: false,
    });
  });
});
