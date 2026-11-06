import 'reflect-metadata';
import { randomBytes, randomUUID } from 'node:crypto';
import type { NestFastifyApplication } from '@nestjs/platform-fastify';
import pg from 'pg';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { ApiModule } from '../../api.module.js';
import { startTestDatabase, type TestDatabase } from '../../database/test-database.js';
import { createApiApp } from '../../http/create-api-app.js';
import { startTestValkey, type TestValkey } from '../../valkey/test-valkey.js';
import { CaptainsService } from '../captains/index.js';
import { FxService } from '../fx/index.js';
import { GeoService, type Point } from '../geo/index.js';
import { MerchantsService } from '../merchants/index.js';
import { SettingsService } from '../settings/index.js';

// The quote (CU §10.1–10.6, AP §8.4, §8.6), served by the API app as in
// production, on a fresh database. TRY is the base with a 5 TRY rounding
// unit; USD is accepted at 40 TRY, rounded to 0.50 USD.
let database: TestDatabase;
let cache: TestValkey;
let app: NestFastifyApplication;
let sql: pg.Pool;
let settings: SettingsService;
let azaz: string;

const system = { type: 'system', id: null, role: null } as const;
const change = { actor: system, context: { ipAddress: null, device: null }, reason: 'test' };
const fin = {
  actor: { type: 'admin', id: randomUUID(), role: 'FIN' },
  context: change.context,
} as const;
const tryAmount = (amount: bigint) => ({ amount, currency: 'TRY' });
const bySystem = { editor: 'system', context: change.context, reason: 'test' } as const;

function square({ latitude, longitude }: Point, half = 0.02): Point[] {
  return [
    { latitude: latitude - half, longitude: longitude - half },
    { latitude: latitude - half, longitude: longitude + half },
    { latitude: latitude + half, longitude: longitude + half },
    { latitude: latitude + half, longitude: longitude - half },
  ];
}

const centre = { latitude: 36.587, longitude: 37.046 };
const allWeek = [0, 1, 2, 3, 4, 5, 6].map((weekday) => ({ weekday, opensAt: 0, closesAt: 0 }));

let restaurant: string;
let closed: string;
let paused: string;
let inUsd: string;
let ids: Record<string, string>;

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
  settings = app.get(SettingsService);
  azaz = (await sql.query("SELECT id FROM geo.cities WHERE code = 'AZ'")).rows[0].id;
  const fx = app.get(FxService);
  await fx.setCityCurrency(azaz, { currency: 'TRY', displayOrder: 1, enabled: true }, change);
  await fx.setBaseCurrency(azaz, 'TRY', change);
  // AP §9.12.5: a pay table in force, which placing needs (captain_pay_unset).
  const payRate = {
    basePay: 2500n,
    includedMetres: 3000,
    perExtraKm: 500n,
    waitingPerMinute: 0n,
    minimumPay: 2500n,
  };
  await app.get(CaptainsService).setPayTable(
    azaz,
    {
      currency: 'TRY',
      rates: { walking: payRate, bicycle: payRate, motorbike: payRate, car: payRate },
    },
    change,
  );
  await fx.setCityCurrency(azaz, { currency: 'USD', displayOrder: 2, enabled: false }, change);
  await fx.setRate(azaz, 'USD', { value: '40', direction: 'base_per_unit' }, fin);
  await fx.setCityCurrency(azaz, { currency: 'USD', displayOrder: 2, enabled: true }, change);
  for (const [code, amountMinor] of [
    ['TRY', 500],
    ['USD', 50],
  ] as const) {
    await settings.update(
      'currency.<code>.rounding_unit',
      { cityId: azaz, parameter: code },
      { amountMinor },
      bySystem,
    );
  }
  // The capacity check has its own tests (capacity-check.test.ts).
  await settings.update('dispatch.capacity_check', { cityId: azaz }, false, bySystem);
  const geo = app.get(GeoService);
  await geo.createZone(azaz, { name: 'المركز', area: square(centre), active: true }, change);
  await geo.setDeliveryFeeRule(
    azaz,
    { kind: 'flat', currency: 'TRY', flatFee: 4000n, minimumFee: null, freeDeliveryFrom: 50_000n },
    change,
  );

  const merchants = app.get(MerchantsService);
  const create = async (name: string) => {
    const id = await merchants.createRestaurant(
      azaz,
      {
        nameAr: name,
        location: centre,
        coverage: { kind: 'radius', radiusMetres: 1000 },
        minimumOrder: tryAmount(10_000n),
        commissionBp: 1500,
        defaultPrepMin: 20,
      },
      change,
    );
    await merchants.setAccountStatus(id, 'active', change);
    return id;
  };
  restaurant = await create('مطعم الاختبار');
  await merchants.setWeeklySchedule(restaurant, allWeek, change);
  closed = await create('مطعم مغلق');
  paused = await create('مطعم متوقف');
  await merchants.setWeeklySchedule(paused, allWeek, change);
  await sql.query(
    "INSERT INTO merchants.pauses (restaurant_id, source, starts_at, ends_at) VALUES ($1, 'restaurant', now() - interval '1 minute', now() + interval '1 hour')",
    [paused],
  );
  // Until the first order locks the base, a minimum may be in USD.
  inUsd = await merchants.createRestaurant(
    azaz,
    {
      nameAr: 'مطعم بالدولار',
      location: centre,
      coverage: { kind: 'radius', radiusMetres: 1000 },
      minimumOrder: { amount: 500n, currency: 'USD' },
      commissionBp: 1500,
      defaultPrepMin: 20,
    },
    change,
  );
  await merchants.setAccountStatus(inUsd, 'active', change);
  await merchants.setWeeklySchedule(inUsd, allWeek, change);
  const size = await merchants.addOptionGroup(
    restaurant,
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
  const [medium, large] = (
    await sql.query('SELECT id FROM merchants.options WHERE group_id = $1 ORDER BY position', [
      size,
    ])
  ).rows.map((row) => row.id as string);
  const meals = await merchants.addCategory(restaurant, { name: 'وجبات' }, change);
  const shawarma = await merchants.addItem(
    restaurant,
    { categoryId: meals, name: 'شاورما', price: tryAmount(12_000n), optionGroupIds: [size] },
    change,
  );
  const drink = await merchants.addItem(
    restaurant,
    { categoryId: meals, name: 'عيران', price: tryAmount(3_000n) },
    change,
  );
  const tea = await merchants.addItem(
    restaurant,
    { categoryId: meals, name: 'شاي', price: tryAmount(1_230n) },
    change,
  );
  ids = { shawarma, drink, tea, medium: medium!, large: large! };
}, 300_000);

afterAll(async () => {
  await app?.close();
  await sql?.end();
  await Promise.all([database?.stop(), cache?.stop()]);
});

// The unit price the app last showed: the menu's, with the large size.
// The cases of it.each are built before the fixtures, so an unknown item
// shows 0.
const shown = (itemId: string, optionIds: string[]) => {
  const prices: Record<string, number> = ids
    ? { [ids.shawarma!]: 12_000, [ids.drink!]: 3_000, [ids.tea!]: 1_230 }
    : {};
  return String((prices[itemId] ?? 0) + (ids && optionIds.includes(ids.large!) ? 2_000 : 0));
};

const line = (itemId: string, optionIds: string[] = [], extra: object = {}) => ({
  itemId,
  optionIds,
  quantity: 1,
  note: null,
  knownUnitPrice: shown(itemId, optionIds),
  ...extra,
});

const quote = (body: object) =>
  app.inject({
    method: 'POST',
    url: '/v1/customer/quote',
    payload: {
      restaurantId: restaurant,
      location: centre,
      payIn: null,
      appVersion: '1.0.0',
      ...body,
    },
  });

describe('the quote (CU §10.6)', () => {
  it('prices the cart, the fee, the rounding and the equivalents', async () => {
    const answer = await quote({
      lines: [line(ids.shawarma!, [ids.large!]), line(ids.drink!, [], { quantity: 2 })],
      payIn: 'USD',
    });
    expect(answer.statusCode).toBe(200);
    const body = answer.json();
    expect(body).toMatchObject({
      version: expect.stringMatching(/^[0-9a-f]{32}$/),
      restaurant: { id: restaurant, state: 'open' },
      currency: 'TRY',
      // 140 + 2 × 30 = 200 TRY, plus 40.
      money: {
        itemsValue: '20000',
        deliveryFee: '4000',
        deliveryFree: false,
        discount: '0',
        rounding: '0',
        total: '24000',
      },
      // 240 TRY ÷ 40 = 6.00 USD.
      equivalents: [{ amount: '600', currency: 'USD' }],
      payIn: { amount: '600', currency: 'USD' },
      // 20 prep + 0 trip + 10 buffer.
      estimate: { fromMin: 30, toMin: 40 },
      minimumOrder: { amount: '10000', currency: 'TRY', reached: true, missing: '0' },
      freeDelivery: { threshold: '50000', reached: false, missing: '30000' },
      rates: [
        { currency: 'TRY', rateVersionId: null },
        { currency: 'USD', rateVersionId: expect.any(String) },
      ],
      problems: [],
    });
    expect(body.lines[0]).toEqual({
      itemId: ids.shawarma,
      name: 'شاورما',
      quantity: 1,
      note: null,
      options: [{ id: ids.large, name: 'كبير', priceDelta: '2000' }],
      unitPrice: '14000',
      lineTotal: '14000',
    });
  });

  it('rounds the total to the base unit, and USD by its own rule', async () => {
    // 120 + 12.30 + 40 = 172.30 TRY: 170 to the nearest 5, rounding −2.30;
    // 170 ÷ 40 = 4.25 USD: 4.50 to the nearest 0.50, a half going up.
    const { money, equivalents } = (
      await quote({ lines: [line(ids.shawarma!, [ids.medium!]), line(ids.tea!)] })
    ).json();
    expect(money).toMatchObject({ itemsValue: '13230', rounding: '-230', total: '17000' });
    expect(equivalents).toEqual([{ amount: '450', currency: 'USD' }]);
  });

  it('keeps its version for the same cart and changes it with the money', async () => {
    const cart = { lines: [line(ids.shawarma!, [ids.medium!])] };
    const first = (await quote(cart)).json().version;
    expect((await quote(cart)).json().version).toBe(first);
    expect((await quote({ ...cart, payIn: 'USD' })).json().version).toBe(first);
    const more = { lines: [line(ids.shawarma!, [ids.medium!], { quantity: 2 })] };
    expect((await quote(more)).json().version).not.toBe(first);
  });

  it('lists every blocking problem, with its line', async () => {
    const { problems, lines, money, minimumOrder } = (
      await quote({
        lines: [
          line(ids.drink!),
          line(ids.shawarma!),
          line(randomUUID()),
          line(ids.tea!, [], { knownUnitPrice: '1000' }),
        ],
      })
    ).json();
    expect(problems).toEqual([
      { code: 'options_invalid', line: 1, opensAt: null },
      { code: 'item_not_found', line: 2, opensAt: null },
      { code: 'price_changed', line: 3, opensAt: null },
      { code: 'below_minimum_order', line: null, opensAt: null },
    ]);
    // The lines that cannot be ordered are not in the money: 30 + 12.30.
    expect(lines[1]).toMatchObject({ unitPrice: null, lineTotal: null });
    expect(money.itemsValue).toBe('4230');
    expect(minimumOrder).toEqual({
      amount: '10000',
      currency: 'TRY',
      reached: false,
      missing: '5770',
    });
  });

  it('refuses a point outside the coverage or every zone, and a closed restaurant', async () => {
    const cart = { lines: [line(ids.shawarma!, [ids.large!])] };
    const north = { latitude: centre.latitude + 0.015, longitude: centre.longitude };
    const far = { latitude: 36.7, longitude: 37.3 };
    const codes = async (body: object) =>
      (await quote({ ...cart, ...body }))
        .json()
        .problems.map((entry: { code: string }) => entry.code);
    expect(await codes({ location: north })).toEqual(['not_covered']);
    expect(await codes({ location: far })).toEqual(['outside_zones']);
    const answer = (await quote({ ...cart, restaurantId: closed, lines: [] })).statusCode;
    expect(answer).toBe(400);
    const closedQuote = (await quote({ restaurantId: closed, lines: [line(randomUUID())] })).json();
    expect(closedQuote.restaurant.state).toBe('closed');
    expect(closedQuote.problems.map((entry: { code: string }) => entry.code)).toContain(
      'restaurant_closed',
    );
  });

  it('asks for an update below the minimum version, and says when the platform opens', async () => {
    const cart = { lines: [line(ids.shawarma!, [ids.large!])] };
    await settings.update('app.<app>.min_version', { parameter: 'customer' }, '2.0.0', bySystem);
    // Open only for an hour three days from now, on Azaz's clock.
    const days = ['sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday'];
    const today = new Intl.DateTimeFormat('en-US', { timeZone: 'Asia/Damascus', weekday: 'long' })
      .format(new Date())
      .toLowerCase();
    const openDay = days[(days.indexOf(today) + 3) % 7]!;
    const hours = Object.fromEntries(days.map((day) => [day, [] as object[]]));
    await settings.update(
      'platform.hours',
      { cityId: azaz },
      { ...hours, [openDay]: [{ open: '08:00', close: '09:00' }] },
      bySystem,
    );
    try {
      const { problems } = (await quote(cart)).json();
      expect(problems).toEqual([
        { code: 'update_required', line: null, opensAt: null },
        { code: 'platform_closed', line: null, opensAt: expect.any(String) },
      ]);
    } finally {
      await settings.update('app.<app>.min_version', { parameter: 'customer' }, null, bySystem);
      await settings.reset('platform.hours', { cityId: azaz }, bySystem);
    }
  });

  it('shows «سأدفع بـ» in the base currency, and none for a currency no longer accepted', async () => {
    const cart = { lines: [line(ids.shawarma!, [ids.large!])] };
    expect((await quote({ ...cart, payIn: 'TRY' })).json().payIn).toEqual({
      amount: '18000',
      currency: 'TRY',
    });
    const syp = await quote({ ...cart, payIn: 'SYP' });
    expect(syp.statusCode).toBe(200);
    expect(syp.json().payIn).toBeNull();
  });

  it('refuses a paused restaurant, and lets busy mode order with a longer estimate and the same version', async () => {
    const cart = { lines: [line(ids.shawarma!, [ids.large!])] };
    const pausedQuote = (
      await quote({ ...cart, restaurantId: paused, lines: [line(randomUUID())] })
    ).json();
    expect(pausedQuote.restaurant.state).toBe('paused');
    expect(pausedQuote.problems.map((entry: { code: string }) => entry.code)).toContain(
      'restaurant_closed',
    );
    const before = (await quote(cart)).json();
    await sql.query(
      "UPDATE merchants.restaurants SET busy_extra_min = 15, busy_until = now() + interval '1 hour' WHERE id = $1",
      [restaurant],
    );
    try {
      const busy = (await quote(cart)).json();
      expect(busy).toMatchObject({
        restaurant: { state: 'open', busyMode: true },
        estimate: { fromMin: 45, toMin: 55 },
        problems: [],
      });
      // A new estimate alone does not change the version (CU §10.6).
      expect(busy.version).toBe(before.version);
    } finally {
      await sql.query(
        'UPDATE merchants.restaurants SET busy_extra_min = NULL, busy_until = NULL WHERE id = $1',
        [restaurant],
      );
    }
  });

  it('refuses a minimum order outside the base currency', async () => {
    const { problems } = (await quote({ restaurantId: inUsd, lines: [line(randomUUID())] })).json();
    expect(problems.map((entry: { code: string }) => entry.code)).toContain(
      'minimum_not_in_base_currency',
    );
  });

  it('shows maintenance, and rates_unavailable while a currency has no rounding unit', async () => {
    const cart = { lines: [line(ids.shawarma!, [ids.large!])] };
    const maintenance = { parameter: 'customer' };
    await settings.update(
      'app.<app>.maintenance',
      maintenance,
      { enabled: true, message: null },
      bySystem,
    );
    try {
      expect((await quote(cart)).json().problems).toEqual([
        { code: 'maintenance', line: null, opensAt: null },
      ]);
    } finally {
      await settings.reset('app.<app>.maintenance', maintenance, bySystem);
    }
    const fx = app.get(FxService);
    await fx.setCityCurrency(azaz, { currency: 'SYP', displayOrder: 3, enabled: false }, change);
    await fx.setRate(azaz, 'SYP', { value: '290', direction: 'units_per_base' }, fin);
    await fx.setCityCurrency(azaz, { currency: 'SYP', displayOrder: 3, enabled: true }, change);
    try {
      const body = (await quote({ ...cart, payIn: 'TRY' })).json();
      expect(body.problems).toEqual([{ code: 'rates_unavailable', line: null, opensAt: null }]);
      expect(body).toMatchObject({
        currency: 'TRY',
        money: { rounding: '0', total: '18000' },
        equivalents: [],
        payIn: { amount: '18000', currency: 'TRY' },
        rates: [],
      });
    } finally {
      await fx.setCityCurrency(azaz, { currency: 'SYP', displayOrder: 3, enabled: false }, change);
    }
  });

  it.each([
    ['an unknown restaurant', { restaurantId: randomUUID() }, 404],
    [
      'a phone number in an item note',
      { lines: [line(randomUUID(), [], { note: 'اتصل 0933123456' })] },
      400,
    ],
    ['a quantity above 20', { lines: [line(randomUUID(), [], { quantity: 21 })] }, 400],
  ])('refuses %s', async (_, body, status) => {
    const answer = await quote({ lines: [line(ids.tea!)], ...body });
    expect(answer.statusCode).toBe(status);
  });
});
