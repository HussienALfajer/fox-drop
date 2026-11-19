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
import { SettingsService } from '../settings/index.js';
import { MerchantsService } from './index.js';

// The owners' menu commands in the restaurant app (RA §9.2–9.7, §18; slice
// 2.32a): prices, the option deltas, hiding, ordering, the category window,
// the bulk change, the price log, the customer preview and «تغيير أسعار كبير»
// (AP §9.1.3). Cashiers switch availability only (RA §6).
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
  await app
    .get(SettingsService)
    .update(
      'currency.<code>.rounding_unit',
      { cityId: azaz, parameter: 'TRY' },
      { amountMinor: 100 },
      { editor: 'system', context: change.context, reason: 'test' },
    );
}, 300_000);

afterAll(async () => {
  await app?.close();
  await sql?.end();
  await Promise.all([database?.stop(), cache?.stop()]);
});

async function signedIn(restaurantId: string, role: 'owner' | 'cashier') {
  const phone = `+9639${randomInt(100_000_000).toString().padStart(8, '0')}`;
  const name = `${role} ${randomUUID().slice(0, 6)}`;
  const accountId = await app
    .get(MerchantAccountsService)
    .addAccount(restaurantId, { role, name, phone }, change);
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
    name,
    deviceId,
    headers: { authorization: `Bearer ${response.json().accessToken}` },
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
  const drinks = await merchants.addCategory(id, { name: 'مشروبات' }, change);
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
  const ayran = await merchants.addItem(
    id,
    { categoryId: drinks, name: 'عيران', price: tryAmount(2_500n) },
    change,
  );
  const menu = await merchants.menu(id);
  const optionIds = menu.categories[0]!.items[0]!.optionGroups[0]!.options.map((o) => o.id);
  return {
    id,
    meals,
    drinks,
    shawarma,
    falafel,
    ayran,
    optionIds,
    owner: await signedIn(id, 'owner'),
    cashier: await signedIn(id, 'cashier'),
  };
}

function send(
  method: 'GET' | 'PUT' | 'POST',
  url: string,
  headers: Record<string, string>,
  payload?: object,
) {
  const url_ = `/v1/merchant/menu${url}`;
  return payload === undefined
    ? app.inject({ method, url: url_, headers })
    : app.inject({ method, url: url_, headers, payload });
}

async function openAlerts(restaurantId: string) {
  return (
    await sql.query(
      `SELECT code, severity, subject_type, details FROM notifications.alerts
        WHERE code = 'large_price_change' AND details->>'restaurantId' = $1 ORDER BY raised_at`,
      [restaurantId],
    )
  ).rows;
}

describe("the owners' commands (RA §9.2, §18)", () => {
  it('refuses a cashier every command but availability (RA §6)', async () => {
    const r = await restaurant();
    const key = { ...r.cashier.headers, 'idempotency-key': randomUUID() };
    const refused = [
      send('PUT', `/items/${r.shawarma}/price`, r.cashier.headers, {
        price: { amount: '11000', currency: 'TRY' },
      }),
      send('PUT', `/options/${r.optionIds[1]}/price`, r.cashier.headers, {
        priceDelta: { amount: '2500', currency: 'TRY' },
      }),
      send('PUT', `/items/${r.shawarma}/hidden`, r.cashier.headers, { hidden: true }),
      send('PUT', `/categories/${r.meals}/hidden`, r.cashier.headers, { hidden: true }),
      send('PUT', `/categories/${r.meals}/window`, r.cashier.headers, { window: null }),
      send('PUT', '/category-order', r.cashier.headers, { categoryIds: [r.drinks, r.meals] }),
      send('PUT', `/categories/${r.meals}/item-order`, r.cashier.headers, {
        itemIds: [r.falafel, r.shawarma],
      }),
      send('POST', '/bulk-price/preview', r.cashier.headers, {
        categoryId: null,
        kind: 'percent',
        direction: 'up',
        value: '1000',
      }),
      send('POST', '/bulk-price', key, {
        categoryId: null,
        kind: 'percent',
        direction: 'up',
        value: '1000',
      }),
      send('GET', '/price-log', r.cashier.headers),
      send('GET', '/customer-preview', r.cashier.headers),
    ];
    for (const answer of await Promise.all(refused)) {
      expect(answer.statusCode).toBe(403);
      expect(answer.json()).toMatchObject({ error: 'owner_only' });
    }
    const switched = await send('PUT', '/availability', r.cashier.headers, {
      type: 'item',
      id: r.shawarma,
      available: false,
      until: 'tomorrow',
    });
    expect(switched.statusCode).toBe(200);
  });

  it('sets a price, logs it with the owner and tells every device (RA §9.4)', async () => {
    const r = await restaurant();
    const answer = await send('PUT', `/items/${r.shawarma}/price`, r.owner.headers, {
      price: { amount: '12000', currency: 'TRY' },
    });
    expect(answer.statusCode).toBe(200);
    const item = answer.json().categories[0].items[0];
    expect(item.price).toEqual({ amount: '12000', currency: 'TRY' });
    const logged = await sql.query(
      `SELECT old_price, new_price, changed_by_type, changed_by_id
         FROM merchants.price_changes WHERE item_id = $1`,
      [r.shawarma],
    );
    expect(logged.rows).toEqual([
      {
        old_price: '10000',
        new_price: '12000',
        changed_by_type: 'merchant',
        changed_by_id: r.owner.accountId,
      },
    ]);
    const kinds = await sql.query(
      'SELECT kind FROM merchants.state_outbox WHERE restaurant_id = $1 ORDER BY id',
      [r.id],
    );
    // The owners' own change never chimes «عدّلت FOX DROP سعر …» (D17).
    expect(kinds.rows.map((row) => row.kind)).toEqual(['menu_changed']);
    // 20% is within merchant.price_change_alert_pct (30).
    expect(await openAlerts(r.id)).toEqual([]);
    // The same price again changes nothing.
    await send('PUT', `/items/${r.shawarma}/price`, r.owner.headers, {
      price: { amount: '12000', currency: 'TRY' },
    });
    expect(
      (await sql.query('SELECT 1 FROM merchants.price_changes WHERE item_id = $1', [r.shawarma]))
        .rowCount,
    ).toBe(1);

    const log = await send('GET', '/price-log', r.owner.headers);
    expect(log.statusCode).toBe(200);
    expect(log.json().entries).toEqual([
      expect.objectContaining({
        name: 'شاورما',
        oldPrice: { amount: '10000', currency: 'TRY' },
        newPrice: { amount: '12000', currency: 'TRY' },
        byType: 'merchant',
        byName: r.owner.name,
      }),
    ]);

    const audit = await sql.query(
      `SELECT actor_type, actor_id FROM audit.events
        WHERE action = 'menu.item.update' AND target_id = $1`,
      [r.shawarma],
    );
    expect(audit.rows).toEqual([{ actor_type: 'merchant', actor_id: r.owner.accountId }]);
  });

  it('refuses a price of 0 and an unknown row (RA §9.4)', async () => {
    const r = await restaurant();
    const zero = await send('PUT', `/items/${r.shawarma}/price`, r.owner.headers, {
      price: { amount: '0', currency: 'TRY' },
    });
    expect(zero.statusCode).toBe(400);
    const other = await restaurant();
    const foreign = await send('PUT', `/items/${other.shawarma}/price`, r.owner.headers, {
      price: { amount: '9000', currency: 'TRY' },
    });
    expect(foreign.statusCode).toBe(404);
  });

  it('raises «تغيير أسعار كبير» past 30% either way, once per edit (AP §9.1.3)', async () => {
    const r = await restaurant();
    // A cashier switches an item off «حتى الغد» first (the roadmap's check).
    await send('PUT', '/availability', r.cashier.headers, {
      type: 'item',
      id: r.falafel,
      available: false,
      until: 'tomorrow',
    });
    // 10,000 → 14,000 is 40%.
    const raised = await send('PUT', `/items/${r.shawarma}/price`, r.owner.headers, {
      price: { amount: '14000', currency: 'TRY' },
    });
    expect(raised.statusCode).toBe(200);
    // 2,000 → 1,000 is a 50% fall.
    await send('PUT', `/options/${r.optionIds[1]}/price`, r.owner.headers, {
      priceDelta: { amount: '1000', currency: 'TRY' },
    });
    // Exactly 30% is not more than 30%.
    await send('PUT', `/items/${r.ayran}/price`, r.owner.headers, {
      price: { amount: '3250', currency: 'TRY' },
    });
    const alerts = await openAlerts(r.id);
    expect(alerts).toHaveLength(2);
    expect(alerts[0]).toMatchObject({
      severity: 'information',
      subject_type: 'price_change',
      details: { restaurantId: r.id, restaurantName: expect.stringContaining('مطعم') },
    });
    const listed = await sql.query(
      `SELECT count(*)::int AS count FROM notifications.alert_outbox o
         JOIN notifications.alerts a ON a.id = o.alert_id
        WHERE a.code = 'large_price_change' AND a.details->>'restaurantId' = $1`,
      [r.id],
    );
    expect(listed.rows[0].count).toBe(2);
  });

  it('sets an option delta of 0 or more (RA §9.4)', async () => {
    const r = await restaurant();
    const negative = await send('PUT', `/options/${r.optionIds[1]}/price`, r.owner.headers, {
      priceDelta: { amount: '-1', currency: 'TRY' },
    });
    expect(negative.statusCode).toBe(400);
    const zero = await send('PUT', `/options/${r.optionIds[1]}/price`, r.owner.headers, {
      priceDelta: { amount: '0', currency: 'TRY' },
    });
    expect(zero.statusCode).toBe(200);
    const option = zero.json().categories[0].items[0].optionGroups[0].options[1];
    expect(option.priceDelta).toEqual({ amount: '0', currency: 'TRY' });
  });

  it('hides, orders and sets a window at once (RA §9.2)', async () => {
    const r = await restaurant();
    const hidden = await send('PUT', `/items/${r.falafel}/hidden`, r.owner.headers, {
      hidden: true,
    });
    expect(hidden.statusCode).toBe(200);
    await send('PUT', `/categories/${r.drinks}/hidden`, r.owner.headers, { hidden: true });
    await send('PUT', '/category-order', r.owner.headers, { categoryIds: [r.drinks, r.meals] });
    await send('PUT', `/categories/${r.meals}/item-order`, r.owner.headers, {
      itemIds: [r.falafel, r.shawarma],
    });
    const windowed = await send('PUT', `/categories/${r.meals}/window`, r.owner.headers, {
      window: { startsAt: 360, endsAt: 720 },
    });
    expect(windowed.statusCode).toBe(200);
    const menu = windowed.json();
    expect(menu.categories.map((c: { id: string }) => c.id)).toEqual([r.drinks, r.meals]);
    expect(menu.categories[0].hidden).toBe(true);
    expect(menu.categories[1].window).toEqual({ startsAt: 360, endsAt: 720 });
    expect(menu.categories[1].items.map((i: { id: string }) => i.id)).toEqual([
      r.falafel,
      r.shawarma,
    ]);
    expect(menu.categories[1].items[0].hidden).toBe(true);
    const bad = await send('PUT', `/categories/${r.meals}/window`, r.owner.headers, {
      window: { startsAt: 360, endsAt: 360 },
    });
    expect(bad.statusCode).toBe(400);
    const preview = await send('GET', '/customer-preview', r.owner.headers);
    expect(preview.statusCode).toBe(200);
    // The customers do not see the hidden category nor the hidden item.
    expect(preview.json().menu.map((c: { id: string }) => c.id)).toEqual([r.meals]);
    expect(preview.json().menu[0].items.map((i: { id: string }) => i.id)).toEqual([r.shawarma]);
  });

  it('previews and applies the bulk change once per key, with one alert (RA §9.4)', async () => {
    const r = await restaurant();
    const body = { categoryId: r.meals, kind: 'percent', direction: 'up', value: '5000' };
    const preview = await send('POST', '/bulk-price/preview', r.owner.headers, body);
    expect(preview.statusCode).toBe(200);
    expect(preview.json()).toMatchObject({ roundingUnit: '100', changed: 2, refused: 0 });
    const headers = { ...r.owner.headers, 'idempotency-key': randomUUID() };
    const first = await send('POST', '/bulk-price', headers, body);
    expect(first.statusCode).toBe(200);
    expect(first.json()).toEqual({ changed: 2, unchanged: 0 });
    const again = await send('POST', '/bulk-price', headers, body);
    expect(again.json()).toEqual({ changed: 2, unchanged: 0 });
    const prices = await sql.query(
      'SELECT price FROM merchants.items WHERE category_id = $1 ORDER BY price',
      [r.meals],
    );
    expect(prices.rows.map((row) => row.price)).toEqual(['7500', '15000']);
    // Two prices crossed 30% in one bulk change: one alert.
    expect(await openAlerts(r.id)).toHaveLength(1);
    const noKey = await send('POST', '/bulk-price', r.owner.headers, body);
    expect(noKey.statusCode).toBe(400);
  });
});

describe("the limits of the owners' commands (RA §5.5, §6, §18)", () => {
  it("refuses another restaurant's rows on every command", async () => {
    const r = await restaurant();
    const other = await restaurant();
    const foreign = [
      send('PUT', `/options/${other.optionIds[1]}/price`, r.owner.headers, {
        priceDelta: { amount: '100', currency: 'TRY' },
      }),
      send('PUT', `/items/${other.shawarma}/hidden`, r.owner.headers, { hidden: true }),
      send('PUT', `/categories/${other.meals}/hidden`, r.owner.headers, { hidden: true }),
      send('PUT', `/categories/${other.meals}/window`, r.owner.headers, { window: null }),
      send('PUT', `/categories/${other.meals}/item-order`, r.owner.headers, {
        itemIds: [other.falafel, other.shawarma],
      }),
    ];
    for (const answer of await Promise.all(foreign)) {
      expect(answer.statusCode).toBe(404);
    }
    const order = await send('PUT', '/category-order', r.owner.headers, {
      categoryIds: [other.drinks, other.meals],
    });
    expect(order.statusCode).toBe(400);
    const body = { categoryId: other.meals, kind: 'percent', direction: 'up', value: '1000' };
    const preview = await send('POST', '/bulk-price/preview', r.owner.headers, body);
    expect(preview.json()).toMatchObject({ rows: [], changed: 0 });
    const applied = await send(
      'POST',
      '/bulk-price',
      { ...r.owner.headers, 'idempotency-key': randomUUID() },
      body,
    );
    expect(applied.json()).toEqual({ changed: 0, unchanged: 0 });
    const prices = await sql.query(
      'SELECT price FROM merchants.items WHERE category_id = $1 ORDER BY price',
      [other.meals],
    );
    expect(prices.rows.map((row) => row.price)).toEqual(['5000', '10000']);
  });

  it("keeps a terminated restaurant's owners out (RA §5.5)", async () => {
    const r = await restaurant();
    await merchants.setAccountStatus(r.id, 'terminated', { ...change, reason: 'end' });
    const key = { ...r.owner.headers, 'idempotency-key': randomUUID() };
    const bulk = { categoryId: null, kind: 'percent', direction: 'up', value: '1000' };
    const answers = await Promise.all([
      send('PUT', `/items/${r.shawarma}/price`, r.owner.headers, {
        price: { amount: '11000', currency: 'TRY' },
      }),
      send('PUT', `/items/${r.shawarma}/hidden`, r.owner.headers, { hidden: true }),
      send('PUT', '/category-order', r.owner.headers, { categoryIds: [r.drinks, r.meals] }),
      send('POST', '/bulk-price/preview', r.owner.headers, bulk),
      send('POST', '/bulk-price', key, bulk),
      send('GET', '/price-log', r.owner.headers),
      send('GET', '/customer-preview', r.owner.headers),
    ]);
    for (const answer of answers) {
      expect(answer.statusCode).toBe(403);
      expect(answer.json()).toMatchObject({ error: 'restaurant_terminated' });
    }
  });

  it('tells every device of a switch and of nothing when the order is the same', async () => {
    const r = await restaurant();
    await send('PUT', '/availability', r.cashier.headers, {
      type: 'option',
      id: r.optionIds[0],
      available: false,
      until: 'turned_back_on',
    });
    await send('PUT', '/category-order', r.owner.headers, { categoryIds: [r.meals, r.drinks] });
    const kinds = await sql.query(
      'SELECT kind FROM merchants.state_outbox WHERE restaurant_id = $1 ORDER BY id',
      [r.id],
    );
    expect(kinds.rows.map((row) => row.kind)).toEqual(['menu_changed']);
    const audited = await sql.query(
      `SELECT count(*)::int AS count FROM audit.events
        WHERE action = 'menu.category.order' AND target_id = $1`,
      [r.id],
    );
    expect(audited.rows[0].count).toBe(0);
  });

  it('refuses a key reused for another bulk change', async () => {
    const r = await restaurant();
    const headers = { ...r.owner.headers, 'idempotency-key': randomUUID() };
    const body = { categoryId: null, kind: 'percent', direction: 'up', value: '1000' };
    expect((await send('POST', '/bulk-price', headers, body)).statusCode).toBe(200);
    const reused = await send('POST', '/bulk-price', headers, { ...body, value: '2000' });
    expect(reused.statusCode).toBe(422);
    expect(reused.json()).toMatchObject({ error: 'idempotency_key_reused' });
  });
});
