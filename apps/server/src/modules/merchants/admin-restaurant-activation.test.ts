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
import {
  ADMIN_SESSION_COOKIE,
  AdminSessionsService,
  MerchantAccountsService,
} from '../identity/index.js';
import { MerchantsService, ReceivingDevicesService } from './index.js';

// The wizard's step 8 (AP §9.6.3; slice 2.30b): the checklist with the reason
// of each missing item, OWN's waiver of the image rule, test mode and the
// activation.
let database: TestDatabase;
let cache: TestValkey;
let app: NestFastifyApplication;
let sql: pg.Pool;
let db: Database;
let azaz: string;
let accounts = 0;
let phones = 0;

const system = { type: 'system', id: null, role: null } as const;
const change = { actor: system, context: { ipAddress: null, device: null }, reason: 'test' };
const allWeek = [0, 1, 2, 3, 4, 5, 6].map((weekday) => ({ weekday, opensAt: 0, closesAt: 0 }));

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
    [`Admin ${accounts}`, `activation${accounts}@example.test`],
  );
  await sql.query(
    'INSERT INTO identity.admin_account_roles (account_id, role_code) VALUES ($1, $2)',
    [rows[0].id, role],
  );
  const { token } = await app
    .get(AdminSessionsService)
    .start(db.db, rows[0].id, { ipAddress: '203.0.113.9', device: 'test' }, new Date());
  const cookies = { [ADMIN_SESSION_COOKIE]: token };
  const call = (method: 'GET' | 'PUT' | 'POST', url: string, payload?: object) =>
    app.inject({
      method,
      url: `/v1/admin/restaurant-drafts${url}`,
      cookies,
      ...(payload ? { payload } : {}),
    });
  return Object.assign(call, { id: rows[0].id as string });
}

// A draft with its record and commission (steps 2–4), as the wizard leaves it.
async function draft(): Promise<string> {
  return app.get(MerchantsService).createRestaurant(
    azaz,
    {
      nameAr: `مطعم ${randomUUID()}`,
      location: { latitude: 36.5866, longitude: 37.0463 },
      coverage: { kind: 'radius', radiusMetres: 3000 },
      minimumOrder: { amount: 10_000n, currency: 'TRY' },
      commissionBp: 1500,
      defaultPrepMin: 20,
    },
    change,
  );
}

const states = (body: { items: { code: string; state: string }[] }) =>
  Object.fromEntries(body.items.map((item) => [item.code, item.state]));

describe('step 8, the checklist and the activation', () => {
  it('names what is missing, then starts test mode and activates once everything is met', async () => {
    const ops = await admin('OPS');
    const own = await admin('OWN');
    const id = await draft();
    const first = await ops('GET', `/${id}/checklist`);
    expect(first.statusCode).toBe(200);
    expect(states(first.json())).toEqual({
      record: 'met',
      commission: 'met',
      contract: 'missing',
      hours: 'missing',
      menu: 'missing',
      menu_images: 'missing',
      owner_account: 'missing',
      device_check: 'missing',
      test_order: 'missing',
    });
    expect(first.json()).toMatchObject({
      accountStatus: 'draft',
      canStartTest: false,
      canActivate: false,
    });
    expect((await ops('POST', `/${id}/test-mode`)).json()).toMatchObject({
      statusCode: 409,
      error: 'checklist_incomplete',
    });

    // Steps 3, 5, 6 and 7.
    await app.get(MerchantsService).setWeeklySchedule(id, allWeek, change);
    await sql.query(
      `INSERT INTO merchants.contracts (restaurant_id, signed_on, duration_months, contract_key,
         confirmed_at, confirmed_by, updated_by)
       VALUES ($1, '2026-11-01', 12, 'restaurants/contract.jpg', now(), $2, $2)`,
      [id, own.id],
    );
    phones += 1;
    await app
      .get(MerchantAccountsService)
      .addAccount(
        id,
        { role: 'owner', name: 'أبو محمد', phone: `+9639440${String(phones).padStart(5, '0')}` },
        change,
      );
    const meals = randomUUID();
    await ops('PUT', `/${id}/menu/categories/${meals}`, {
      name: 'وجبات',
      hidden: false,
      window: null,
    });
    const items = [randomUUID(), randomUUID(), randomUUID(), randomUUID(), randomUUID()];
    for (const item of items) {
      await ops('PUT', `/${id}/menu/items/${item}`, {
        categoryId: meals,
        code: null,
        name: 'صنف',
        description: null,
        price: { amount: '5000', currency: 'TRY' },
        hidden: false,
        badge: null,
      });
    }
    // Photos on 3 of 5 items: 60%, below the rule's 80%.
    await sql.query("UPDATE merchants.items SET photo_key = 'items/a.jpg' WHERE id = ANY($1)", [
      items.slice(0, 3),
    ]);
    const filled = (await ops('GET', `/${id}/checklist`)).json();
    expect(states(filled)).toMatchObject({
      contract: 'met',
      hours: 'met',
      menu: 'met',
      menu_images: 'missing',
      owner_account: 'met',
    });
    expect(filled).toMatchObject({
      images: { withPhoto: 3, total: 5, requiredPct: 80 },
      imagesWaiver: null,
      canStartTest: false,
    });

    // Only OWN waives the image rule.
    expect((await ops('PUT', `/${id}/menu-images-waiver`, { waived: true })).statusCode).toBe(403);
    const waived = await own('PUT', `/${id}/menu-images-waiver`, { waived: true });
    expect(waived.statusCode).toBe(200);
    expect(states(waived.json()).menu_images).toBe('waived');
    expect(waived.json()).toMatchObject({
      imagesWaiver: { by: own.id },
      canStartTest: true,
      canActivate: false,
    });

    // Activation comes from test mode only, after a delivered test order.
    expect((await ops('POST', `/${id}/activate`)).json()).toMatchObject({
      statusCode: 409,
      error: 'status_change_not_allowed',
    });
    const testMode = await ops('POST', `/${id}/test-mode`);
    expect(testMode.statusCode).toBe(200);
    expect(testMode.json()).toMatchObject({ accountStatus: 'test' });
    expect((await ops('POST', `/${id}/test-mode`)).statusCode).toBe(200);
    expect((await ops('POST', `/${id}/activate`)).json()).toMatchObject({
      statusCode: 409,
      error: 'checklist_incomplete',
    });
    // The test drafts list keeps the restaurant in test mode.
    const list = (await ops('GET', `?cityId=${azaz}`)).json();
    expect(list.drafts).toContainEqual(expect.objectContaining({ id, accountStatus: 'test' }));

    // ordering's count, delivered-counts.test.ts proves the real one.
    const merchants = app.get(MerchantsService);
    merchants.countDeliveredTestOrders((restaurantId) =>
      Promise.resolve(restaurantId === id ? 1 : 0),
    );
    // RA §4.5: a device must pass its check before the activation.
    const noDevice = await ops('POST', `/${id}/activate`);
    expect(noDevice.json()).toMatchObject({ statusCode: 409, error: 'checklist_incomplete' });
    const deviceId = randomUUID();
    await merchants.nameDevice(
      id,
      deviceId,
      { name: 'كاشير 1', platform: 'android', appVersion: '1.0.0' },
      { accountId: randomUUID(), role: 'cashier' },
    );
    const devices = app.get(ReceivingDevicesService);
    await devices.recordCheck(id, deviceId, { failed: ['battery'], delayMs: 90 });
    expect((await ops('POST', `/${id}/activate`)).statusCode).toBe(409);
    await devices.recordCheck(id, deviceId, { failed: [], delayMs: 90 });
    const activated = await ops('POST', `/${id}/activate`);
    expect(activated.statusCode).toBe(200);
    expect(activated.json()).toMatchObject({
      accountStatus: 'active',
      canActivate: true,
    });
    expect(states(activated.json()).test_order).toBe('met');
    expect((await merchants.restaurant(id))?.activatedAt).toBeInstanceOf(Date);
    const { rows } = await sql.query(
      `SELECT actor_id, changes FROM audit.events
       WHERE action = 'restaurant.status' AND target_id = $1 ORDER BY occurred_at, id`,
      [id],
    );
    expect(rows.map((row) => row.actor_id)).toEqual([ops.id, ops.id]);
    // The waiver belongs to the onboarding.
    expect((await own('PUT', `/${id}/menu-images-waiver`, { waived: false })).json()).toMatchObject(
      { statusCode: 409, error: 'menu_locked' },
    );
    expect((await ops('POST', `/${id}/activate`)).statusCode).toBe(200);
  });

  it('keeps the commands from roles without restaurants.activate', async () => {
    const id = await draft();
    const data = await admin('DATA');
    expect((await data('GET', `/${id}/checklist`)).statusCode).toBe(200);
    expect((await data('POST', `/${id}/test-mode`)).statusCode).toBe(403);
    expect((await data('POST', `/${id}/activate`)).statusCode).toBe(403);
    const fin = await admin('FIN');
    expect((await fin('GET', `/${id}/checklist`)).statusCode).toBe(403);
    const ops = await admin('OPS');
    expect((await ops('GET', `/${randomUUID()}/checklist`)).json()).toMatchObject({
      statusCode: 404,
      error: 'unknown_restaurant',
    });
  });

  it('counts a hidden item out of the image rule and a switched-off category out of the menu', async () => {
    const ops = await admin('OPS');
    const id = await draft();
    const meals = randomUUID();
    const hiddenItem = randomUUID();
    const shown = randomUUID();
    await ops('PUT', `/${id}/menu/categories/${meals}`, {
      name: 'وجبات',
      hidden: false,
      window: null,
    });
    for (const [item, hidden] of [
      [shown, false],
      [hiddenItem, true],
    ] as const) {
      await ops('PUT', `/${id}/menu/items/${item}`, {
        categoryId: meals,
        code: null,
        name: 'صنف',
        description: null,
        price: { amount: '5000', currency: 'TRY' },
        hidden,
        badge: null,
      });
    }
    await sql.query("UPDATE merchants.items SET photo_key = 'items/a.jpg' WHERE id = $1", [shown]);
    const read = (await ops('GET', `/${id}/checklist`)).json();
    expect(read.images).toMatchObject({ withPhoto: 1, total: 1 });
    expect(states(read)).toMatchObject({ menu: 'met', menu_images: 'met' });
    await ops('PUT', `/${id}/menu/availability`, { type: 'category', id: meals, available: false });
    expect(states((await ops('GET', `/${id}/checklist`)).json()).menu).toBe('missing');
  });

  it('counts an item out whose required group has every option switched off', async () => {
    const merchants = app.get(MerchantsService);
    const ops = await admin('OPS');
    const id = await draft();
    const category = await merchants.addCategory(id, { name: 'وجبات' }, change);
    const group = await merchants.addOptionGroup(
      id,
      {
        name: 'الحجم',
        minChoices: 1,
        maxChoices: 1,
        options: [{ name: 'كبير', priceDelta: { amount: 0n, currency: 'TRY' } }],
      },
      change,
    );
    await merchants.addItem(
      id,
      {
        categoryId: category,
        name: 'شاورما',
        price: { amount: 5000n, currency: 'TRY' },
        optionGroupIds: [group],
      },
      change,
    );
    expect(states((await ops('GET', `/${id}/checklist`)).json()).menu).toBe('met');
    const [option] = (await merchants.menu(id)).categories[0]!.items[0]!.optionGroups[0]!.options;
    await merchants.setAvailability(
      id,
      { type: 'option', id: option!.id },
      { available: false, until: 'turned_back_on' },
      change,
    );
    expect(states((await ops('GET', `/${id}/checklist`)).json()).menu).toBe('missing');
  });

  it('lets DATA read the onboarding only: a draft or test mode, never an active restaurant', async () => {
    const merchants = app.get(MerchantsService);
    const data = await admin('DATA');
    const id = await draft();
    await merchants.setAccountStatus(id, 'test', change);
    expect((await data('GET', `/${id}`)).statusCode).toBe(200);
    expect((await data('GET', `/${id}/checklist`)).statusCode).toBe(200);
    await merchants.setAccountStatus(id, 'active', change);
    expect((await data('GET', `/${id}`)).statusCode).toBe(404);
    expect((await data('GET', `/${id}/checklist`)).json()).toMatchObject({
      statusCode: 404,
      error: 'unknown_restaurant',
    });
  });
});
