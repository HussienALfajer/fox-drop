import 'reflect-metadata';
import { randomBytes, randomInt, randomUUID } from 'node:crypto';
import type { NestFastifyApplication } from '@nestjs/platform-fastify';
import pg from 'pg';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { ApiModule } from '../../api.module.js';
import { startTestDatabase, type TestDatabase } from '../../database/test-database.js';
import { createApiApp } from '../../http/create-api-app.js';
import { startTestValkey, type TestValkey } from '../../valkey/test-valkey.js';
import { FxService } from '../fx/index.js';
import {
  CODE_SENDER,
  type DevelopmentCodeSender,
  MerchantAccountsService,
} from '../identity/index.js';
import { MerchantsService } from './index.js';

// The restaurant app's restaurant, menu and availability switches (RA §5.4,
// §5.5, §9.3), called by a signed-in owner or cashier through the API app.
let database: TestDatabase;
let cache: TestValkey;
let app: NestFastifyApplication;
let sql: pg.Pool;
let merchants: MerchantsService;
let azaz: string;

const system = { type: 'system', id: null, role: null } as const;
const change = { actor: system, context: { ipAddress: null, device: null }, reason: 'test' };
const tryAmount = (amount: bigint) => ({ amount, currency: 'TRY' });

beforeAll(async () => {
  [database, cache] = await Promise.all([startTestDatabase(), startTestValkey()]);
  process.env.DATABASE_URL = database.appUrl;
  process.env.VALKEY_URL = cache.url;
  process.env.IDENTITY_ENCRYPTION_KEY = randomBytes(32).toString('base64');
  process.env.FOX_DROP_ENVIRONMENT = 'development';
  sql = new pg.Pool({ connectionString: database.appUrl });
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
  await sql?.end();
  await Promise.all([database?.stop(), cache?.stop()]);
});

// A signed-in owner or cashier: the Authorization header of its access token.
async function signedIn(restaurantId: string, role: 'owner' | 'cashier') {
  const phone = `+9639${randomInt(100_000_000).toString().padStart(8, '0')}`;
  const accountId = await app
    .get(MerchantAccountsService)
    .addAccount(restaurantId, { role, name: role, phone }, change);
  const deviceId = randomUUID();
  await app.inject({ method: 'POST', url: '/v1/merchant/auth/code', payload: { phone, deviceId } });
  const code = app.get<DevelopmentCodeSender>(CODE_SENDER).lastCode(phone);
  const response = await app.inject({
    method: 'POST',
    url: '/v1/merchant/auth/sign-in',
    payload: { phone, deviceId, code },
  });
  expect(response.statusCode).toBe(200);
  return {
    accountId,
    deviceId,
    headers: { authorization: `Bearer ${response.json().accessToken}` },
  };
}

// An active restaurant with a required size, a shawarma that takes it and a
// drink, and a signed-in cashier.
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
    { categoryId: meals, name: 'شاورما', price: tryAmount(12_000n), optionGroupIds: [size] },
    change,
  );
  const drink = await merchants.addItem(
    id,
    { categoryId: meals, name: 'عيران', price: tryAmount(2_500n) },
    change,
  );
  const menu = await merchants.menu(id);
  const optionIds = menu.categories[0]!.items[0]!.optionGroups[0]!.options.map((o) => o.id);
  return { id, meals, shawarma, drink, optionIds, cashier: await signedIn(id, 'cashier') };
}

function switchRow(
  headers: Record<string, string>,
  payload: { type: string; id: string; available: boolean; until?: string },
) {
  return app.inject({ method: 'PUT', url: '/v1/merchant/menu/availability', headers, payload });
}

function itemsOf(menu: Awaited<ReturnType<MerchantsService['menu']>>) {
  return Object.fromEntries(menu.categories[0]!.items.map((item) => [item.name, item]));
}

describe('the restaurant and its menu (RA §5.4–5.5)', () => {
  it("shows the cashier the restaurant's status and its menu with prices", async () => {
    const { id, cashier } = await restaurant();
    const answer = await app.inject({
      method: 'GET',
      url: '/v1/merchant/restaurant',
      headers: cashier.headers,
    });
    expect(answer.statusCode).toBe(200);
    expect(answer.json()).toMatchObject({
      id,
      accountStatus: 'active',
      suspensionReason: null,
      state: 'closed',
      stateUntil: null,
    });
    const menu = await app.inject({
      method: 'GET',
      url: '/v1/merchant/menu',
      headers: cashier.headers,
    });
    expect(menu.statusCode).toBe(200);
    const [shawarma] = menu.json().categories[0].items;
    expect(shawarma).toMatchObject({
      name: 'شاورما',
      price: { amount: '12000', currency: 'TRY' },
      available: true,
      switchedOff: null,
    });
    expect(shawarma.optionGroups[0].options[1].priceDelta).toEqual({
      amount: '2000',
      currency: 'TRY',
    });
  });

  it("shows a suspension's reason", async () => {
    const { id, cashier } = await restaurant();
    await merchants.setAccountStatus(id, 'suspended', { ...change, reason: 'مستحقات متأخرة' });
    const answer = await app.inject({
      method: 'GET',
      url: '/v1/merchant/restaurant',
      headers: cashier.headers,
    });
    expect(answer.json()).toMatchObject({
      accountStatus: 'suspended',
      suspensionReason: 'مستحقات متأخرة',
      state: 'suspended',
    });
  });

  it("keeps a terminated restaurant's owner out of the menu (RA §5.5)", async () => {
    const { id } = await restaurant();
    const owner = await signedIn(id, 'owner');
    await merchants.setAccountStatus(id, 'terminated', { ...change, reason: 'end of contract' });
    const menu = await app.inject({
      method: 'GET',
      url: '/v1/merchant/menu',
      headers: owner.headers,
    });
    expect(menu.statusCode).toBe(403);
    expect(menu.json()).toMatchObject({ error: 'restaurant_terminated' });
  });

  it("refuses a customer's token and no token", async () => {
    const phone = `+9639${randomInt(100_000_000).toString().padStart(8, '0')}`;
    const deviceId = randomUUID();
    await app.inject({
      method: 'POST',
      url: '/v1/customer/auth/code',
      payload: { phone, deviceId },
    });
    const code = app.get<DevelopmentCodeSender>(CODE_SENDER).lastCode(phone);
    const customer = await app.inject({
      method: 'POST',
      url: '/v1/customer/auth/sign-in',
      payload: { phone, deviceId, code },
    });
    for (const url of ['/v1/merchant/menu', '/v1/merchant/restaurant']) {
      const withCustomer = await app.inject({
        method: 'GET',
        url,
        headers: { authorization: `Bearer ${customer.json().accessToken}` },
      });
      expect(withCustomer.statusCode).toBe(401);
      expect((await app.inject({ method: 'GET', url })).statusCode).toBe(401);
    }
  });
});

describe('availability switches (RA §9.3)', () => {
  it('switches an item off until the next business-day cutoff, then it is back', async () => {
    const { id, shawarma, cashier } = await restaurant();
    const before = Date.now();
    const answer = await switchRow(cashier.headers, {
      type: 'item',
      id: shawarma,
      available: false,
      until: 'tomorrow',
    });
    expect(answer.statusCode).toBe(200);
    // The default cutoff is 06:00 on Azaz's clock (UTC+3), 03:00 UTC.
    const until = new Date(answer.json().switchedOff.until);
    expect(until.getUTCHours()).toBe(3);
    expect(until.getUTCMinutes()).toBe(0);
    expect(until.getTime() - before).toBeGreaterThan(0);
    expect(until.getTime() - before).toBeLessThanOrEqual(24 * 3_600_000);

    const now = itemsOf(await merchants.menu(id));
    expect(now['شاورما']).toMatchObject({ available: false, switchedOff: { until } });
    const atCutoff = itemsOf(await merchants.menu(id, until));
    expect(atCutoff['شاورما']).toMatchObject({ available: true, switchedOff: null });
  });

  it('switches an item off until turned back on, and on again', async () => {
    const { id, drink, cashier } = await restaurant();
    await switchRow(cashier.headers, {
      type: 'item',
      id: drink,
      available: false,
      until: 'turned_back_on',
    });
    const later = new Date(Date.now() + 7 * 24 * 3_600_000);
    expect(itemsOf(await merchants.menu(id, later))['عيران']).toMatchObject({
      available: false,
      switchedOff: { until: null },
    });
    await switchRow(cashier.headers, { type: 'item', id: drink, available: true });
    expect(itemsOf(await merchants.menu(id))['عيران']).toMatchObject({
      available: true,
      switchedOff: null,
    });
  });

  it("makes a category's items unavailable without changing their own switches", async () => {
    const { id, meals, cashier } = await restaurant();
    await switchRow(cashier.headers, {
      type: 'category',
      id: meals,
      available: false,
      until: 'turned_back_on',
    });
    const items = itemsOf(await merchants.menu(id));
    expect(items['شاورما']).toMatchObject({ available: false, switchedOff: null });
    expect(items['عيران']).toMatchObject({ available: false, switchedOff: null });
    await switchRow(cashier.headers, { type: 'category', id: meals, available: true });
    expect(itemsOf(await merchants.menu(id))['عيران']).toMatchObject({ available: true });
  });

  it('makes an item unavailable when every option of a required group is', async () => {
    const { id, optionIds, cashier } = await restaurant();
    await switchRow(cashier.headers, {
      type: 'option',
      id: optionIds[0]!,
      available: false,
      until: 'tomorrow',
    });
    expect(itemsOf(await merchants.menu(id))['شاورما']).toMatchObject({ available: true });
    await switchRow(cashier.headers, {
      type: 'option',
      id: optionIds[1]!,
      available: false,
      until: 'tomorrow',
    });
    const items = itemsOf(await merchants.menu(id));
    expect(items['شاورما']).toMatchObject({ available: false, switchedOff: null });
    expect(items['عيران']).toMatchObject({ available: true });
  });

  it('records the user, the device and the time', async () => {
    const { drink, cashier } = await restaurant();
    await switchRow(cashier.headers, {
      type: 'item',
      id: drink,
      available: false,
      until: 'turned_back_on',
    });
    const { rows } = await sql.query(
      "SELECT actor_type, actor_id, actor_role, device, occurred_at, changes FROM audit.events WHERE action = 'menu.item.availability' AND target_id = $1",
      [drink],
    );
    expect(rows).toEqual([
      {
        actor_type: 'merchant',
        actor_id: cashier.accountId,
        actor_role: 'cashier',
        device: cashier.deviceId,
        occurred_at: expect.any(Date),
        changes: { switchedOff: { before: null, after: { until: null } } },
      },
    ]);
  });

  it("refuses another restaurant's rows and a switch off without how long", async () => {
    const mine = await restaurant();
    const other = await restaurant();
    const foreign = await switchRow(mine.cashier.headers, {
      type: 'item',
      id: other.drink,
      available: false,
      until: 'tomorrow',
    });
    expect(foreign.statusCode).toBe(404);
    for (const [type, id] of [
      ['category', other.meals],
      ['option', other.optionIds[0]!],
    ] as const) {
      const answer = await switchRow(mine.cashier.headers, {
        type,
        id,
        available: false,
        until: 'tomorrow',
      });
      expect(answer.statusCode).toBe(404);
    }
    const untouched = (await merchants.menu(other.id)).categories[0]!;
    expect(untouched.switchedOff).toBeNull();
    expect(untouched.items[0]!.optionGroups[0]!.options[0]!.switchedOff).toBeNull();
    expect(itemsOf(await merchants.menu(other.id))['عيران']).toMatchObject({ available: true });
    const noUntil = await switchRow(mine.cashier.headers, {
      type: 'item',
      id: mine.drink,
      available: false,
    });
    expect(noUntil.statusCode).toBe(400);
  });
});
