import 'reflect-metadata';
import { randomBytes, randomInt, randomUUID } from 'node:crypto';
import type { NestFastifyApplication } from '@nestjs/platform-fastify';
import pg from 'pg';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { ApiModule } from '../../api.module.js';
import { createDatabase, type Database } from '../../database/database.js';
import { DATABASE } from '../../database/database.module.js';
import { startTestDatabase, type TestDatabase } from '../../database/test-database.js';
import { createApiApp } from '../../http/create-api-app.js';
import { startTestValkey, type TestValkey } from '../../valkey/test-valkey.js';
import { NotificationTexts } from '../content/index.js';
import { FxService } from '../fx/index.js';
import { GeoService } from '../geo/index.js';
import {
  ADMIN_SESSION_COOKIE,
  AdminSessionsService,
  CODE_SENDER,
  type DevelopmentCodeSender,
  MerchantAccountsService,
} from '../identity/index.js';
import {
  AlertsService,
  PushQueue,
  type RealtimePublisher,
  RestaurantStateRelay,
} from '../notifications/index.js';
import { MerchantsService, RestaurantStatusService } from './index.js';

// Change requests and their review (RA §9.2 «After admin review», §9.5, §16
// #22, §18; AP §9.6.7; slice 2.32b): what the owners ask waits as a request
// «بانتظار المراجعة», one per field, until OWN or OPS approve it (with a text
// correction) or reject it (with a reason) in the panel; customers see it
// only after approval.
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
const tryAmount = (amount: bigint) => ({ amount, currency: 'TRY' });
const price = (amount: string) => ({ amount, currency: 'TRY' });

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
}, 300_000);

afterAll(async () => {
  await app?.close();
  await db?.pool.end();
  await sql?.end();
  await Promise.all([database?.stop(), cache?.stop()]);
});

async function signedIn(restaurantId: string, role: 'owner' | 'cashier') {
  const phone = `+9639${randomInt(100_000_000).toString().padStart(8, '0')}`;
  await app
    .get(MerchantAccountsService)
    .addAccount(restaurantId, { role, name: `${role} ${randomUUID().slice(0, 6)}`, phone }, change);
  const deviceId = randomUUID();
  await app.inject({ method: 'POST', url: '/v1/merchant/auth/code', payload: { phone, deviceId } });
  const code = app.get<DevelopmentCodeSender>(CODE_SENDER).lastCode(phone);
  const response = await app.inject({
    method: 'POST',
    url: '/v1/merchant/auth/sign-in',
    payload: { phone, deviceId, code },
  });
  expect(response.statusCode).toBe(200);
  const headers = { authorization: `Bearer ${response.json().accessToken}` };
  return (method: 'GET' | 'PUT' | 'POST', url: string, payload?: object) =>
    app.inject({
      method,
      url: `/v1/merchant/menu${url}`,
      headers,
      ...(payload === undefined ? {} : { payload }),
    });
}

async function admin(role: string) {
  accounts += 1;
  const { rows } = await sql.query(
    `INSERT INTO identity.admin_accounts (name, email, status, password_hash, totp_secret_encrypted)
     VALUES ($1, $2, 'active', 'not used', 'not used') RETURNING id`,
    [`Reviewer ${accounts}`, `review${accounts}@example.test`],
  );
  await sql.query(
    'INSERT INTO identity.admin_account_roles (account_id, role_code) VALUES ($1, $2)',
    [rows[0].id, role],
  );
  const { token } = await app
    .get(AdminSessionsService)
    .start(db.db, rows[0].id, { ipAddress: '203.0.113.9', device: 'test' }, new Date());
  const cookies = { [ADMIN_SESSION_COOKIE]: token };
  const call = (method: 'GET' | 'POST', url: string, payload?: object) =>
    app.inject({
      method,
      url: `/v1/admin/menu-change-requests${url}`,
      cookies,
      ...(payload === undefined ? {} : { payload }),
    });
  // «قبول» sends the version the reviewer saw, as the panel does.
  return async (method: 'GET' | 'POST', url: string, payload?: object) => {
    if (!url.endsWith('/approve') || (payload !== undefined && 'seen' in payload)) {
      return call(method, url, payload);
    }
    const view = await call('GET', url.replace(/\/approve$/, ''));
    return call(method, url, { ...payload, seen: view.json().updatedAt });
  };
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
  const size = await merchants.addOptionGroup(
    id,
    {
      name: 'الحجم',
      minChoices: 1,
      maxChoices: 1,
      options: [
        { name: 'وسط', priceDelta: tryAmount(0n) },
        { name: 'كبير', priceDelta: tryAmount(2_000n) },
      ],
    },
    change,
  );
  const meals = await merchants.addCategory(id, { name: 'وجبات' }, change);
  const shawarma = await merchants.addItem(
    id,
    { categoryId: meals, name: 'شاورما', price: tryAmount(10_000n), optionGroupIds: [size] },
    change,
  );
  const falafel = await merchants.addItem(
    id,
    { categoryId: meals, name: 'فلافل', price: tryAmount(5_000n) },
    change,
  );
  const menu = await merchants.menu(id);
  const optionIds = menu.categories[0]!.items[0]!.optionGroups[0]!.options.map((o) => o.id);
  return {
    id,
    size,
    meals,
    shawarma,
    falafel,
    optionIds,
    owner: await signedIn(id, 'owner'),
  };
}

// The customers' menu: the published rows only.
async function customerNames(restaurantId: string) {
  const menu = await merchants.menu(restaurantId);
  return menu.categories.map((category) => ({
    name: category.name,
    items: category.items.map((item) => item.name),
  }));
}

async function queued(restaurantId: string) {
  const ops = await admin('OPS');
  const answer = await ops('GET', `?cityId=${azaz}`);
  expect(answer.statusCode).toBe(200);
  return answer
    .json()
    .requests.filter((request: { restaurantId: string }) => request.restaurantId === restaurantId);
}

async function relay(): Promise<void> {
  const publisher = {
    enabled: true,
    broadcast: () => Promise.resolve(),
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
}

async function pushes(restaurantId: string) {
  await relay();
  return (
    await sql.query(
      `SELECT template_key, body, owners_only, level FROM notifications.push_messages
        WHERE restaurant_id = $1 AND template_key LIKE 'merchant.menu_change_%' ORDER BY id`,
      [restaurantId],
    )
  ).rows;
}

async function audits(action: string, restaurantId: string): Promise<number> {
  const { rows } = await sql.query(
    `SELECT count(*)::int AS n FROM audit.events
      WHERE action = $1 AND changes->'restaurantId'->>'after' = $2`,
    [action, restaurantId],
  );
  return rows[0].n;
}

describe('a new category and a new item (RA §9.2, §9.5)', () => {
  it('waits for review, then publishes what the reviewer approved, corrected', async () => {
    const r = await restaurant();
    const desserts = randomUUID();
    const kunafa = randomUUID();
    expect(
      (await r.owner('PUT', `/requests/categories/${desserts}`, { name: 'حلويات' })).statusCode,
    ).toBe(200);
    const added = await r.owner('PUT', `/requests/items/${kunafa}`, {
      categoryId: desserts,
      name: 'كنافه',
      description: 'بالجبنة',
      price: price('7500'),
      uploadId: null,
    });
    expect(added.statusCode).toBe(200);
    // The owners see them with the badge; customers do not.
    const menu = added.json();
    const pendingCategory = menu.categories.find((c: { id: string }) => c.id === desserts);
    expect(pendingCategory.pending).toEqual([
      expect.objectContaining({ field: 'created', name: 'حلويات' }),
    ]);
    expect(pendingCategory.items[0]).toMatchObject({
      id: kunafa,
      name: 'كنافه',
      price: price('7500'),
      pending: [expect.objectContaining({ field: 'created', name: 'كنافه' })],
    });
    expect(await customerNames(r.id)).toEqual([{ name: 'وجبات', items: ['شاورما', 'فلافل'] }]);

    // A second edit of the new item replaces its request: one per field.
    await r.owner('PUT', `/requests/items/${kunafa}`, {
      categoryId: desserts,
      name: 'كنافه',
      description: 'بالجبنة النابلسية',
      price: price('8000'),
      uploadId: null,
    });
    const requests = await queued(r.id);
    expect(requests).toHaveLength(2);
    // Oldest first, with the restaurant, the row and the type of change.
    expect(requests.map((each: { targetType: string }) => each.targetType)).toEqual([
      'category',
      'item',
    ]);
    expect(requests[1]).toMatchObject({ field: 'created', targetName: 'كنافه' });

    const ops = await admin('OPS');
    const itemRequest = requests[1].id;
    const view = await ops('GET', `/${itemRequest}`);
    expect(view.statusCode).toBe(200);
    expect(view.json()).toMatchObject({
      before: null,
      after: { name: 'كنافه', description: 'بالجبنة النابلسية', price: price('8000') },
    });
    // The item waits for its category.
    expect((await ops('POST', `/${itemRequest}/approve`, {})).json()).toMatchObject({
      statusCode: 409,
      error: 'category_pending',
    });
    expect((await ops('POST', `/${requests[0].id}/approve`, {})).statusCode).toBe(200);
    const approved = await ops('POST', `/${itemRequest}/approve`, { name: 'كنافة' });
    expect(approved.statusCode).toBe(200);
    expect(await customerNames(r.id)).toEqual([
      { name: 'وجبات', items: ['شاورما', 'فلافل'] },
      { name: 'حلويات', items: ['كنافة'] },
    ]);
    // Approved once: a second decision is refused.
    expect((await ops('POST', `/${itemRequest}/reject`, { reason: 'لا' })).json()).toMatchObject({
      statusCode: 409,
      error: 'request_not_pending',
    });
    expect(await queued(r.id)).toEqual([]);
    expect(await pushes(r.id)).toEqual([
      {
        template_key: 'merchant.menu_change_approved',
        body: 'قُبل تعديلك على حلويات',
        owners_only: true,
        level: 'silent',
      },
      {
        template_key: 'merchant.menu_change_approved',
        body: 'قُبل تعديلك على كنافة',
        owners_only: true,
        level: 'silent',
      },
    ]);
    expect(await audits('menu.change_request.approve', r.id)).toBe(2);
    // The owners' menu shows the approved version, with no badge.
    const after = (await r.owner('GET', '')).json();
    expect(after.categories[1].items[0]).toMatchObject({ name: 'كنافة', pending: [] });
  });

  it('removes a new item the reviewer rejects, with the reason told to the owners', async () => {
    const r = await restaurant();
    const kebab = randomUUID();
    await r.owner('PUT', `/requests/items/${kebab}`, {
      categoryId: r.meals,
      name: 'كباب',
      description: null,
      price: price('12000'),
      uploadId: null,
    });
    const [request] = await queued(r.id);
    const ops = await admin('OPS');
    expect((await ops('POST', `/${request.id}/reject`, { reason: ' ' })).statusCode).toBe(400);
    expect(
      (await ops('POST', `/${request.id}/reject`, { reason: 'الصورة مطلوبة' })).statusCode,
    ).toBe(200);
    const menu = (await r.owner('GET', '')).json();
    expect(menu.categories[0].items.map((item: { id: string }) => item.id)).not.toContain(kebab);
    expect(await pushes(r.id)).toEqual([
      expect.objectContaining({
        template_key: 'merchant.menu_change_rejected',
        body: 'رُفض تعديلك على كباب: الصورة مطلوبة',
      }),
    ]);
    expect(await audits('menu.change_request.reject', r.id)).toBe(1);
  });
});

describe("a published row's text (RA §9.5)", () => {
  it('keeps the old name until approval, one request per field, withdrawn by the owner', async () => {
    const r = await restaurant();
    const renamed = await r.owner('PUT', `/requests/items/${r.shawarma}/text`, {
      name: 'شاورما دجاج',
      description: null,
    });
    expect(renamed.statusCode).toBe(200);
    const item = renamed.json().categories[0].items[0];
    expect(item.name).toBe('شاورما');
    expect(item.pending).toEqual([
      expect.objectContaining({ field: 'rename', name: 'شاورما دجاج' }),
    ]);
    await r.owner('PUT', `/requests/items/${r.shawarma}/text`, {
      name: 'شاورما عربي',
      description: 'مع ثوم',
    });
    const requests = await queued(r.id);
    expect(requests.map((each: { field: string }) => each.field).sort()).toEqual([
      'description',
      'rename',
    ]);
    expect(await customerNames(r.id)).toEqual([{ name: 'وجبات', items: ['شاورما', 'فلافل'] }]);
    // The published name again withdraws the name's request.
    const back = await r.owner('PUT', `/requests/items/${r.shawarma}/text`, {
      name: 'شاورما',
      description: 'مع ثوم',
    });
    expect(back.json().categories[0].items[0].pending).toEqual([
      expect.objectContaining({ field: 'description', description: 'مع ثوم' }),
    ]);
    const [description] = await queued(r.id);
    const withdrawn = await r.owner('POST', `/requests/${description.id}/withdraw`);
    expect(withdrawn.statusCode).toBe(200);
    expect(withdrawn.json().categories[0].items[0].pending).toEqual([]);
    expect((await r.owner('POST', `/requests/${description.id}/withdraw`)).json()).toMatchObject({
      statusCode: 409,
      error: 'request_not_pending',
    });
    expect(await queued(r.id)).toEqual([]);
    // The name's request, withdrawn by the published name, and the owner's.
    expect(await audits('menu.change_request.withdraw', r.id)).toBe(2);
  });

  it('renames a category on approval and refuses a cashier (RA §6)', async () => {
    const r = await restaurant();
    const cashier = await signedIn(r.id, 'cashier');
    expect(
      (await cashier('PUT', `/requests/categories/${r.meals}`, { name: 'وجبات رئيسية' })).json(),
    ).toMatchObject({ statusCode: 403, error: 'owner_only' });
    await r.owner('PUT', `/requests/categories/${r.meals}`, { name: 'وجبات رئيسية' });
    const [request] = await queued(r.id);
    const ops = await admin('OPS');
    expect((await ops('GET', `/${request.id}`)).json()).toMatchObject({
      before: { name: 'وجبات' },
      after: { name: 'وجبات رئيسية' },
    });
    // DATA does not review (AP §6.2).
    const data = await admin('DATA');
    expect((await data('POST', `/${request.id}/approve`, {})).statusCode).toBe(403);
    await ops('POST', `/${request.id}/approve`, {});
    expect((await customerNames(r.id))[0]!.name).toBe('وجبات رئيسية');
  });
});

describe('option groups (RA §9.2)', () => {
  it('publishes a new group with its options and items on approval', async () => {
    const r = await restaurant();
    const extras = randomUUID();
    const cheese = randomUUID();
    const answer = await r.owner('PUT', `/requests/option-groups/${extras}`, {
      name: 'إضافات',
      minChoices: 0,
      maxChoices: 1,
      itemIds: [r.falafel],
      options: [{ id: cheese, name: 'جبنة', priceDelta: price('1000') }],
    });
    expect(answer.statusCode).toBe(200);
    expect(
      answer.json().optionGroups.find((group: { id: string }) => group.id === extras),
    ).toMatchObject({
      name: 'إضافات',
      pending: [expect.objectContaining({ field: 'created' })],
    });
    expect((await merchants.menu(r.id)).categories[0]!.items[1]!.optionGroups).toEqual([]);
    const [request] = await queued(r.id);
    const ops = await admin('OPS');
    expect((await ops('POST', `/${request.id}/approve`, {})).statusCode).toBe(200);
    const falafel = (await merchants.menu(r.id)).categories[0]!.items[1]!;
    expect(falafel.optionGroups).toEqual([
      expect.objectContaining({
        id: extras,
        name: 'إضافات',
        options: [expect.objectContaining({ id: cheese, name: 'جبنة' })],
      }),
    ]);
  });

  it("asks a published group's name, choices, items and new options apart", async () => {
    const r = await restaurant();
    const large = randomUUID();
    const answer = await r.owner('PUT', `/requests/option-groups/${r.size}`, {
      name: 'الحجم',
      minChoices: 1,
      maxChoices: 1,
      itemIds: [r.shawarma, r.falafel],
      options: [
        { id: r.optionIds[0], name: 'وسط', priceDelta: price('0') },
        { id: r.optionIds[1], name: 'كبير جداً', priceDelta: price('2000') },
        { id: large, name: 'عائلي', priceDelta: price('5000') },
      ],
    });
    expect(answer.statusCode).toBe(200);
    const requests = await queued(r.id);
    expect(
      requests
        .map((each: { targetType: string; field: string }) => `${each.targetType}.${each.field}`)
        .sort(),
    ).toEqual(['option.created', 'option.rename', 'option_group.items']);
    // A delta changes through «تعديل السعر», never through a request.
    expect(
      (
        await r.owner('PUT', `/requests/option-groups/${r.size}`, {
          name: 'الحجم',
          minChoices: 1,
          maxChoices: 1,
          itemIds: [r.shawarma],
          options: [{ id: r.optionIds[1], name: 'كبير', priceDelta: price('2500') }],
        })
      ).json(),
    ).toMatchObject({ statusCode: 400, error: 'invalid_menu' });
    const ops = await admin('OPS');
    for (const request of requests) {
      expect((await ops('POST', `/${request.id}/approve`, {})).statusCode).toBe(200);
    }
    const menu = await merchants.menu(r.id);
    expect(menu.categories[0]!.items[1]!.optionGroups[0]!.options.map((o) => o.name)).toEqual([
      'وسط',
      'كبير جداً',
      'عائلي',
    ]);
  });
});

describe("the owners' reorder (RA §9.2)", () => {
  it('names the published rows only, past a new row waiting for review', async () => {
    const r = await restaurant();
    await r.owner('PUT', `/requests/items/${randomUUID()}`, {
      categoryId: r.meals,
      name: 'كباب',
      description: null,
      price: price('12000'),
      uploadId: null,
    });
    expect(
      (
        await r.owner('PUT', `/categories/${r.meals}/item-order`, {
          itemIds: [r.falafel, r.shawarma],
        })
      ).statusCode,
    ).toBe(200);
    expect((await customerNames(r.id))[0]!.items).toEqual(['فلافل', 'شاورما']);
  });
});

describe('repeats, scope and cascades (RA §9.5; owner decision 2026-11-19)', () => {
  it('writes nothing for the same request again', async () => {
    const r = await restaurant();
    const kebab = randomUUID();
    const body = {
      categoryId: r.meals,
      name: 'كباب',
      description: 'مشوي',
      price: price('12000'),
      uploadId: null,
    };
    await r.owner('PUT', `/requests/items/${kebab}`, body);
    await r.owner('PUT', `/requests/items/${kebab}`, body);
    const choices = {
      name: 'الحجم',
      minChoices: 0,
      maxChoices: 2,
      itemIds: [r.shawarma],
      options: [],
    };
    await r.owner('PUT', `/requests/option-groups/${r.size}`, choices);
    await r.owner('PUT', `/requests/option-groups/${r.size}`, choices);
    expect(await audits('menu.change_request', r.id)).toBe(2);
  });

  it("refuses another restaurant's rows and requests", async () => {
    const a = await restaurant();
    const b = await restaurant();
    await a.owner('PUT', `/requests/categories/${a.meals}`, { name: 'وجبات رئيسية' });
    const [request] = await queued(a.id);
    expect((await b.owner('POST', `/requests/${request.id}/withdraw`)).json()).toMatchObject({
      statusCode: 404,
      error: 'unknown_change_request',
    });
    expect(
      (await b.owner('PUT', `/requests/categories/${a.meals}`, { name: 'x' })).statusCode,
    ).toBe(404);
    expect(
      (await b.owner('PUT', `/requests/items/${a.shawarma}/text`, { name: 'x', description: null }))
        .statusCode,
    ).toBe(404);
    expect(
      (
        await b.owner('PUT', `/requests/option-groups/${a.size}`, {
          name: 'x',
          minChoices: 0,
          maxChoices: 1,
          itemIds: [],
          options: [],
        })
      ).statusCode,
    ).toBe(404);
  });

  it('withdraws a new category with its new items', async () => {
    const r = await restaurant();
    const desserts = randomUUID();
    const kunafa = randomUUID();
    await r.owner('PUT', `/requests/categories/${desserts}`, { name: 'حلويات' });
    await r.owner('PUT', `/requests/items/${kunafa}`, {
      categoryId: desserts,
      name: 'كنافة',
      description: null,
      price: price('7500'),
      uploadId: null,
    });
    const [category] = await queued(r.id);
    await r.owner('POST', `/requests/${category.id}/withdraw`);
    expect(await queued(r.id)).toEqual([]);
    const { rows } = await sql.query(
      'SELECT deleted_at IS NOT NULL AS gone FROM merchants.items WHERE id = $1',
      [kunafa],
    );
    expect(rows).toEqual([{ gone: true }]);
    const menu = (await r.owner('GET', '')).json();
    expect(menu.categories.map((c: { id: string }) => c.id)).not.toContain(desserts);
  });

  it('refuses an approval of a value the owner replaced since it was seen', async () => {
    const r = await restaurant();
    await r.owner('PUT', `/requests/categories/${r.meals}`, { name: 'وجبات رئيسية' });
    const [request] = await queued(r.id);
    const ops = await admin('OPS');
    const seen = (await ops('GET', `/${request.id}`)).json().updatedAt;
    await r.owner('PUT', `/requests/categories/${r.meals}`, { name: 'وجبات ساخنة' });
    expect((await ops('POST', `/${request.id}/approve`, { seen })).json()).toMatchObject({
      statusCode: 409,
      error: 'request_changed',
    });
    expect((await customerNames(r.id))[0]!.name).toBe('وجبات');
  });

  it('leaves a terminated restaurant out of the queue and its requests refused', async () => {
    const r = await restaurant();
    await r.owner('PUT', `/requests/categories/${r.meals}`, { name: 'وجبات رئيسية' });
    await sql.query(
      "UPDATE merchants.restaurants SET account_status = 'terminated' WHERE id = $1",
      [r.id],
    );
    expect(await queued(r.id)).toEqual([]);
    expect(
      (await r.owner('PUT', `/requests/categories/${r.meals}`, { name: 'x' })).json(),
    ).toMatchObject({ statusCode: 403, error: 'restaurant_terminated' });
  });
});
