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
import { DATABASE } from '../../database/database.module.js';
import { NotificationTexts } from '../content/index.js';
import { FxService } from '../fx/index.js';
import { GeoService } from '../geo/index.js';
import { ADMIN_SESSION_COOKIE, AdminSessionsService } from '../identity/index.js';
import {
  AlertsService,
  PushQueue,
  type RealtimePublisher,
  RestaurantStateRelay,
} from '../notifications/index.js';
import { MerchantsService, RestaurantStatusService } from './index.js';

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
  return (
    method: 'GET' | 'PUT' | 'POST',
    url: string,
    payload?: object,
    headers: Record<string, string> = {},
  ) =>
    app.inject({
      method,
      // The profile's routes are named whole; the menu's under the drafts.
      url: url.startsWith('/v1/') ? url : `/v1/admin/restaurant-drafts${url}`,
      cookies,
      headers,
      ...(payload ? { payload } : {}),
    });
}

const key = () => randomUUID().replaceAll('-', '');

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

async function activeRestaurant(): Promise<string> {
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
  await merchants.setAccountStatus(id, 'test', change);
  await merchants.setAccountStatus(id, 'active', change);
  return id;
}

const try_ = (amount: string) => ({ amount, currency: 'TRY' });

describe('option groups and add-ons (AP §9.6.6)', () => {
  it('builds a group, its options and its links to many items', async () => {
    const data = await admin('DATA');
    const id = await draft(data);
    const meals = randomUUID();
    const [a, b] = [randomUUID(), randomUUID()];
    await data('PUT', `/${id}/menu/categories/${meals}`, category('وجبات'));
    await data('PUT', `/${id}/menu/items/${a}`, item(meals, 'برغر'));
    await data('PUT', `/${id}/menu/items/${b}`, item(meals, 'شاورما'));
    const size = randomUUID();
    const extras = randomUUID();
    const [small, large] = [randomUUID(), randomUUID()];
    expect(
      (
        await data('PUT', `/${id}/menu/option-groups/${size}`, {
          name: 'الحجم',
          minChoices: 1,
          maxChoices: 1,
        })
      ).statusCode,
    ).toBe(200);
    await data('PUT', `/${id}/menu/option-groups/${size}/options/${small}`, {
      name: 'صغير',
      priceDelta: try_('0'),
      removed: false,
    });
    await data('PUT', `/${id}/menu/option-groups/${size}/options/${large}`, {
      name: 'كبير',
      priceDelta: try_('2000'),
      removed: false,
    });
    await data('PUT', `/${id}/menu/option-groups/${extras}`, {
      name: 'إضافات',
      minChoices: 0,
      maxChoices: 3,
    });
    const linked = await data('PUT', `/${id}/menu/option-groups/${size}/items`, {
      itemIds: [a, b],
    });
    expect(linked.statusCode).toBe(200);
    await data('PUT', `/${id}/menu/items/${a}/option-groups`, { groupIds: [extras, size] });
    await data('PUT', `/${id}/menu/option-groups/${size}/option-order`, {
      optionIds: [large, small],
    });
    const menu = (await data('GET', `/${id}/menu`)).json();
    expect(menu.categories[0].items).toMatchObject([
      { id: a, optionGroupIds: [extras, size] },
      { id: b, optionGroupIds: [size] },
    ]);
    expect(menu.optionGroups).toEqual([
      { id: extras, name: 'إضافات', minChoices: 0, maxChoices: 3, options: [], itemIds: [a] },
      {
        id: size,
        name: 'الحجم',
        minChoices: 1,
        maxChoices: 1,
        options: [
          { id: large, name: 'كبير', priceDelta: try_('2000'), switchedOff: null },
          { id: small, name: 'صغير', priceDelta: try_('0'), switchedOff: null },
        ],
        itemIds: [a, b],
      },
    ]);

    // A maximum above the options' count, a negative delta, another's group.
    expect(
      (
        await data('PUT', `/${id}/menu/option-groups/${size}`, {
          name: 'الحجم',
          minChoices: 1,
          maxChoices: 3,
        })
      ).json(),
    ).toMatchObject({ statusCode: 400, error: 'invalid_menu' });
    expect(
      (
        await data('PUT', `/${id}/menu/option-groups/${size}/options/${randomUUID()}`, {
          name: 'سالب',
          priceDelta: try_('0'),
          removed: true,
        })
      ).json(),
    ).toMatchObject({ statusCode: 404, error: 'unknown_menu_row' });
    const other = await draft(data);
    expect(
      (await data('PUT', `/${other}/menu/option-groups/${size}/items`, { itemIds: [] })).json(),
    ).toMatchObject({ statusCode: 404, error: 'unknown_menu_row' });

    // Unlinking one item, removing an option, switching one off.
    await data('PUT', `/${id}/menu/option-groups/${size}/items`, { itemIds: [b] });
    await data('PUT', `/${id}/menu/option-groups/${size}/options/${small}`, {
      name: 'صغير',
      priceDelta: try_('0'),
      removed: true,
    });
    await data('PUT', `/${id}/menu/availability`, { type: 'option', id: large, available: false });
    const after = (await data('GET', `/${id}/menu`)).json();
    expect(after.categories[0].items[0].optionGroupIds).toEqual([extras]);
    expect(after.optionGroups[1]).toMatchObject({
      itemIds: [b],
      options: [{ id: large, switchedOff: { until: null } }],
    });
    // Linking it again puts it at the end of the item's groups.
    await data('PUT', `/${id}/menu/option-groups/${size}/items`, { itemIds: [a, b] });
    expect((await data('GET', `/${id}/menu`)).json().categories[0].items[0].optionGroupIds).toEqual(
      [extras, size],
    );
  });

  it('logs and tells a delta change past test mode, which DATA cannot make', async () => {
    const id = await activeRestaurant();
    const ops = await admin('OPS');
    const data = await admin('DATA');
    const group = randomUUID();
    const cheese = randomUUID();
    await data('PUT', `/${id}/menu/option-groups/${group}`, {
      name: 'إضافات',
      minChoices: 0,
      maxChoices: 2,
    });
    expect(
      (
        await data('PUT', `/${id}/menu/option-groups/${group}/options/${cheese}`, {
          name: 'جبنة',
          priceDelta: try_('500'),
          removed: false,
        })
      ).json(),
    ).toMatchObject({ statusCode: 403, error: 'price_edit_not_allowed' });
    await ops('PUT', `/${id}/menu/option-groups/${group}/options/${cheese}`, {
      name: 'جبنة',
      priceDelta: try_('500'),
      removed: false,
    });
    // DATA renames it, but changes no delta.
    expect(
      (
        await data('PUT', `/${id}/menu/option-groups/${group}/options/${cheese}`, {
          name: 'جبنة إضافية',
          priceDelta: try_('500'),
          removed: false,
        })
      ).statusCode,
    ).toBe(200);
    expect(
      (
        await data('PUT', `/${id}/menu/option-groups/${group}/options/${cheese}`, {
          name: 'جبنة إضافية',
          priceDelta: try_('700'),
          removed: false,
        })
      ).json(),
    ).toMatchObject({ statusCode: 403, error: 'price_edit_not_allowed' });
    await ops('PUT', `/${id}/menu/option-groups/${group}/options/${cheese}`, {
      name: 'جبنة إضافية',
      priceDelta: try_('750'),
      removed: false,
    });
    const { rows } = await sql.query(
      `SELECT old_price::text AS old, new_price::text AS new, item_id
         FROM merchants.price_changes WHERE option_id = $1`,
      [cheese],
    );
    expect(rows).toEqual([{ old: '500', new: '750', item_id: null }]);
    const told = await sql.query(
      `SELECT payload FROM merchants.state_outbox WHERE restaurant_id = $1 AND kind = 'price_change'`,
      [id],
    );
    expect(told.rows.map((row) => row.payload.values)).toEqual([
      { optionId: cheese, name: 'جبنة إضافية', oldPrice: '500', newPrice: '750', currency: 'TRY' },
    ]);
  });
});

describe('bulk changes (AP §9.6.6 «تعديل جماعي», «توفر جماعي»)', () => {
  it('previews, applies once per key and tells the owners one summary', async () => {
    const { SettingsService } = await import('../settings/index.js');
    await app
      .get(SettingsService)
      .update(
        'currency.<code>.rounding_unit',
        { cityId: azaz, parameter: 'TRY' },
        { amountMinor: 100 },
        { editor: 'system', context: change.context, reason: 'test' },
      );
    const id = await activeRestaurant();
    const ops = await admin('OPS');
    const data = await admin('DATA');
    const meals = randomUUID();
    const drinks = randomUUID();
    const [a, b, c] = [randomUUID(), randomUUID(), randomUUID()];
    await ops('PUT', `/${id}/menu/categories/${meals}`, category('وجبات'));
    await ops('PUT', `/${id}/menu/categories/${drinks}`, category('مشروبات'));
    await ops('PUT', `/${id}/menu/items/${a}`, item(meals, 'برغر', { price: try_('12000') }));
    await ops('PUT', `/${id}/menu/items/${b}`, item(meals, 'شاورما', { price: try_('9950') }));
    await ops('PUT', `/${id}/menu/items/${c}`, item(drinks, 'عصير', { price: try_('3000') }));
    const body = { categoryId: meals, kind: 'percent', direction: 'up', value: '1000' };
    const preview = await ops('POST', `/${id}/menu/bulk-price/preview`, body);
    expect(preview.statusCode).toBe(200);
    expect(preview.json()).toEqual({
      currency: 'TRY',
      roundingUnit: '100',
      rows: [
        {
          itemId: a,
          code: 'I0001',
          name: 'برغر',
          categoryId: meals,
          before: '12000',
          after: '13200',
        },
        {
          itemId: b,
          code: 'I0002',
          name: 'شاورما',
          categoryId: meals,
          before: '9950',
          after: '10900',
        },
      ],
      changed: 2,
      unchanged: 0,
      refused: 0,
    });
    // DATA previews but applies no price change past test mode; no key is 400.
    expect(
      (await data('POST', `/${id}/menu/bulk-price`, body, { 'idempotency-key': key() })).json(),
    ).toMatchObject({ statusCode: 403, error: 'price_edit_not_allowed' });
    expect((await ops('POST', `/${id}/menu/bulk-price`, body)).json()).toMatchObject({
      statusCode: 400,
      error: 'idempotency_key_required',
    });
    const once = key();
    const applied = await ops('POST', `/${id}/menu/bulk-price`, body, { 'idempotency-key': once });
    expect(applied.json()).toEqual({ changed: 2, unchanged: 0 });
    // The same key answers the first result and changes nothing again.
    expect(
      (await ops('POST', `/${id}/menu/bulk-price`, body, { 'idempotency-key': once })).json(),
    ).toEqual({ changed: 2, unchanged: 0 });
    expect(
      (
        await ops(
          'POST',
          `/${id}/menu/bulk-price`,
          { ...body, value: '500' },
          { 'idempotency-key': once },
        )
      ).json(),
    ).toMatchObject({ statusCode: 422, error: 'idempotency_key_reused' });
    const menu = (await ops('GET', `/${id}/menu`)).json();
    expect(
      menu.categories.flatMap((each: { items: { price: { amount: string } }[] }) =>
        each.items.map((one) => one.price.amount),
      ),
    ).toEqual(['13200', '10900', '3000']);
    const logged = await sql.query(
      'SELECT count(*)::int AS count FROM merchants.price_changes WHERE restaurant_id = $1',
      [id],
    );
    expect(logged.rows[0].count).toBe(2);
    const told = await sql.query(
      `SELECT kind, payload FROM merchants.state_outbox
        WHERE restaurant_id = $1 AND kind LIKE 'price_change%'`,
      [id],
    );
    expect(told.rows).toEqual([
      { kind: 'price_change_bulk', payload: { schema: 1, values: { count: 2 } } },
    ]);
    expect(await audits('menu.bulk_price', id)).toBe(1);

    // A change that would bring a price to 0 is shown and refused whole.
    const tooLow = { categoryId: null, kind: 'amount', direction: 'down', value: '5000' };
    expect((await ops('POST', `/${id}/menu/bulk-price/preview`, tooLow)).json()).toMatchObject({
      changed: 2,
      refused: 1,
    });
    expect(
      (await ops('POST', `/${id}/menu/bulk-price`, tooLow, { 'idempotency-key': key() })).json(),
    ).toMatchObject({ statusCode: 409, error: 'price_reaches_zero' });
  });

  it('switches many items at once, each audited', async () => {
    const data = await admin('DATA');
    const id = await activeRestaurant();
    const meals = randomUUID();
    const [a, b] = [randomUUID(), randomUUID()];
    const ops = await admin('OPS');
    await ops('PUT', `/${id}/menu/categories/${meals}`, category('وجبات'));
    await ops('PUT', `/${id}/menu/items/${a}`, item(meals, 'أ'));
    await ops('PUT', `/${id}/menu/items/${b}`, item(meals, 'ب'));
    const off = await data('PUT', `/${id}/menu/bulk-availability`, {
      itemIds: [a, b],
      available: false,
      until: 'tomorrow',
    });
    expect(off.statusCode).toBe(200);
    expect(
      off.json().categories[0].items.map((each: { switchedOff: unknown }) => each.switchedOff),
    ).toEqual([{ until: expect.any(String) }, { until: expect.any(String) }]);
    expect(await audits('menu.item.availability', a)).toBe(1);
    expect(await audits('menu.item.availability', b)).toBe(1);
    expect(
      (
        await data('PUT', `/${id}/menu/bulk-availability`, {
          itemIds: [a, randomUUID()],
          available: true,
        })
      ).json(),
    ).toMatchObject({ statusCode: 404, error: 'unknown_menu_row' });
    // Nothing switched on: the refusal rolls every row back.
    expect(await audits('menu.item.availability', a)).toBe(1);
  });
});

describe("the owners' notice of an admin price change (D17, RA §16 #21)", () => {
  it('pushes the owners the item with its old and new price, and keeps the values off the channel', async () => {
    const id = await activeRestaurant();
    const ops = await admin('OPS');
    const meals = randomUUID();
    const shawarma = randomUUID();
    await ops('PUT', `/${id}/menu/categories/${meals}`, category('وجبات'));
    await ops('PUT', `/${id}/menu/items/${shawarma}`, item(meals, 'شاورما'));
    await ops(
      'PUT',
      `/${id}/menu/items/${shawarma}`,
      item(meals, 'شاورما', { price: try_('15050') }),
    );
    const published: Record<string, unknown>[] = [];
    const publisher = {
      enabled: true,
      broadcast: (_channels: string[], payload: Record<string, unknown>) => {
        published.push(payload);
        return Promise.resolve();
      },
    } as unknown as RealtimePublisher;
    await new RestaurantStateRelay(
      app.get(DATABASE),
      app.get(RestaurantStatusService),
      publisher,
      app.get(PushQueue),
      app.get(NotificationTexts),
      app.get(AlertsService),
      app.get(GeoService),
      app.get(FxService),
    ).drain(new Date());
    const { rows } = await sql.query(
      `SELECT template_key, body, owners_only FROM notifications.push_messages
        WHERE restaurant_id = $1 ORDER BY id`,
      [id],
    );
    expect(rows).toContainEqual({
      template_key: 'merchant.admin_price_change',
      body: 'عدّلت FOX DROP سعر شاورما: 120 ₺ ← 150.50 ₺',
      owners_only: true,
    });
    expect(published).toContainEqual(
      expect.objectContaining({ restaurantId: id, kind: 'price_change', values: {} }),
    );
  });
});

describe('«سجل الأسعار» and «سجل التغييرات» (AP §9.6.4, §9.6.6)', () => {
  it('lists every price change with its row and who made it, and the menu in the change log', async () => {
    const id = await activeRestaurant();
    const ops = await admin('OPS');
    const data = await admin('DATA');
    const meals = randomUUID();
    const shawarma = randomUUID();
    const group = randomUUID();
    const cheese = randomUUID();
    await ops('PUT', `/${id}/menu/categories/${meals}`, category('وجبات'));
    await ops('PUT', `/${id}/menu/items/${shawarma}`, item(meals, 'شاورما'));
    await ops(
      'PUT',
      `/${id}/menu/items/${shawarma}`,
      item(meals, 'شاورما', { price: try_('13000') }),
    );
    await ops('PUT', `/${id}/menu/option-groups/${group}`, {
      name: 'إضافات',
      minChoices: 0,
      maxChoices: 1,
    });
    await ops('PUT', `/${id}/menu/option-groups/${group}/options/${cheese}`, {
      name: 'جبنة',
      priceDelta: try_('500'),
      removed: false,
    });
    await ops('PUT', `/${id}/menu/option-groups/${group}/options/${cheese}`, {
      name: 'جبنة',
      priceDelta: try_('700'),
      removed: false,
    });
    const log = await data('GET', `/v1/admin/restaurants/${id}/menu/price-log`);
    expect(log.statusCode).toBe(200);
    const { rows } = await sql.query(
      'SELECT name FROM identity.admin_accounts ORDER BY created_at DESC LIMIT 2',
    );
    const opsName = rows[1].name;
    expect(log.json().entries).toMatchObject([
      {
        targetType: 'option',
        targetId: cheese,
        name: 'جبنة',
        groupName: 'إضافات',
        oldPrice: try_('500'),
        newPrice: try_('700'),
        byType: 'admin',
        byName: opsName,
      },
      {
        targetType: 'item',
        targetId: shawarma,
        name: 'شاورما',
        groupName: null,
        oldPrice: try_('12000'),
        newPrice: try_('13000'),
      },
    ]);
    // FIN reads no menu.
    const fin = await admin('FIN');
    expect((await fin('GET', `/v1/admin/restaurants/${id}/menu/price-log`)).statusCode).toBe(403);
    // OPS reads the change log with the menu's own events.
    const changes = (await ops('GET', `/v1/admin/restaurants/${id}/change-log`)).json().entries;
    expect(changes.map((entry: { action: string }) => entry.action)).toEqual(
      expect.arrayContaining([
        'menu.category.create',
        'menu.item.create',
        'menu.item.update',
        'menu.option_group.create',
        'menu.option.update',
      ]),
    );
  });
});

describe('«معاينة كما يراها الزبون» (AP §9.6.6)', () => {
  it('shows a draft menu as the restaurant page would, hidden rows left out', async () => {
    const data = await admin('DATA');
    const id = await draft(data);
    const meals = randomUUID();
    const secret = randomUUID();
    const [shown, hidden, off] = [randomUUID(), randomUUID(), randomUUID()];
    await data('PUT', `/${id}/menu/categories/${meals}`, category('وجبات'));
    await data('PUT', `/${id}/menu/categories/${secret}`, category('سرية', { hidden: true }));
    await data('PUT', `/${id}/menu/items/${shown}`, item(meals, 'شاورما'));
    await data('PUT', `/${id}/menu/items/${hidden}`, item(meals, 'مخفي', { hidden: true }));
    await data('PUT', `/${id}/menu/items/${off}`, item(meals, 'عصير'));
    await data('PUT', `/${id}/menu/availability`, { type: 'item', id: off, available: false });
    const preview = await data('GET', `/v1/admin/restaurants/${id}/menu/customer-preview`);
    expect(preview.statusCode).toBe(200);
    expect(preview.json()).toEqual({
      menu: [
        {
          id: meals,
          name: 'وجبات',
          window: null,
          items: [
            expect.objectContaining({ id: shown, available: true, unavailableReason: null }),
            expect.objectContaining({
              id: off,
              available: false,
              unavailableReason: 'unavailable',
            }),
          ],
        },
      ],
    });
    expect(
      (await data('GET', `/v1/admin/restaurants/${randomUUID()}/menu/customer-preview`)).json(),
    ).toMatchObject({ statusCode: 404, error: 'unknown_restaurant' });
  });
});
