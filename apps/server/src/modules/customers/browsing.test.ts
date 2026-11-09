import 'reflect-metadata';
import { randomBytes, randomUUID } from 'node:crypto';
import type { NestFastifyApplication } from '@nestjs/platform-fastify';
import pg from 'pg';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { ApiModule } from '../../api.module.js';
import { startTestDatabase, type TestDatabase } from '../../database/test-database.js';
import { createApiApp } from '../../http/create-api-app.js';
import { startTestValkey, type TestValkey } from '../../valkey/test-valkey.js';
import { FxService } from '../fx/index.js';
import { GeoService, type Point } from '../geo/index.js';
import { MerchantsService, type NewRestaurant } from '../merchants/index.js';

// The customer's browsing (CU §8.2, §8.4, §9.1–9.4), served by the API app as
// in production, on a fresh database. No OSRM runs, so distances are the
// straight line × 1.3.
let database: TestDatabase;
let cache: TestValkey;
let app: NestFastifyApplication;
let sql: pg.Pool;
let merchants: MerchantsService;
let azaz: string;

const system = { type: 'system', id: null, role: null } as const;
const change = { actor: system, context: { ipAddress: null, device: null }, reason: 'test' };
const tryAmount = (amount: bigint) => ({ amount, currency: 'TRY' });

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

// The weekday and minute of the day on Azaz's clock now, so the fixtures
// never depend on when the tests run.
function azazNow(): { weekday: number; minute: number } {
  const parts = Object.fromEntries(
    new Intl.DateTimeFormat('en-US', {
      timeZone: 'Asia/Damascus',
      weekday: 'short',
      hour: '2-digit',
      minute: '2-digit',
      hourCycle: 'h23',
    })
      .formatToParts(new Date())
      .map((part) => [part.type, part.value]),
  );
  const weekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  return {
    weekday: weekdays.indexOf(parts.weekday!),
    minute: Number(parts.hour) * 60 + Number(parts.minute),
  };
}

let open: string;
let busy: string;
let holiday: string;
let closed: string;
let paused: string;
let distant: string;
let ids: Record<string, string>;

async function restaurant(name: string, extra: Partial<NewRestaurant> = {}) {
  const id = await merchants.createRestaurant(
    azaz,
    {
      nameAr: name,
      location: centre,
      coverage: { kind: 'radius', radiusMetres: 3000 },
      minimumOrder: tryAmount(10_000n),
      commissionBp: 1500,
      defaultPrepMin: 20,
      ...extra,
    },
    change,
  );
  await merchants.setAccountStatus(id, 'active', change);
  return id;
}

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
  const geo = app.get(GeoService);
  await geo.createZone(azaz, { name: 'المركز', area: square(centre), active: true }, change);
  await geo.setDeliveryFeeRule(
    azaz,
    { kind: 'flat', currency: 'TRY', flatFee: 4000n, minimumFee: null, freeDeliveryFrom: 50_000n },
    change,
  );

  // Created in reverse, so the list's own order (the oldest first among
  // equal weights) would put the closed one first without the state groups.
  const now = azazNow();
  closed = await restaurant('مطعم مغلق');
  // Open three days from now only.
  await merchants.setWeeklySchedule(
    closed,
    [{ weekday: (now.weekday + 3) % 7, opensAt: 600, closesAt: 840 }],
    change,
  );
  holiday = await restaurant('مطعم في عطلة');
  await merchants.setWeeklySchedule(holiday, allWeek, change);
  await sql.query(
    "INSERT INTO merchants.holiday_closes (restaurant_id, starts_at, ends_at, message, set_by_type) VALUES ($1, now() - interval '1 minute', now() + interval '2 days', 'عطلة العيد', 'admin')",
    [holiday],
  );
  paused = await restaurant('مطعم متوقف');
  await merchants.setWeeklySchedule(paused, allWeek, change);
  await sql.query(
    "INSERT INTO merchants.pauses (restaurant_id, source, starts_at, message, reason) VALUES ($1, 'ops', now() - interval '1 minute', 'نعود بعد الصيانة', 'test')",
    [paused],
  );
  open = await restaurant('مطعم مفتوح', { nameEn: 'Open place' });
  await merchants.setWeeklySchedule(open, allWeek, change);
  busy = await restaurant('مطعم مزدحم');
  await merchants.setWeeklySchedule(busy, allWeek, change);
  await sql.query(
    "UPDATE merchants.restaurants SET busy_extra_min = 15, busy_until = now() + interval '1 hour' WHERE id = $1",
    [busy],
  );
  // Far east, outside its 1 km radius of the point.
  distant = await restaurant('مطعم بعيد', {
    location: { latitude: centre.latitude, longitude: centre.longitude + 0.015 },
    coverage: { kind: 'radius', radiusMetres: 1000 },
  });

  const size = await merchants.addOptionGroup(
    open,
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
  const meals = await merchants.addCategory(open, { name: 'وجبات' }, change);
  const shawarma = await merchants.addItem(
    open,
    { categoryId: meals, name: 'شاورما', price: tryAmount(12_000n), optionGroupIds: [size] },
    change,
  );
  const drink = await merchants.addItem(
    open,
    { categoryId: meals, name: 'عيران', price: tryAmount(3_000n) },
    change,
  );
  const water = await merchants.addItem(
    open,
    { categoryId: meals, name: 'ماء', price: tryAmount(1_000n) },
    change,
  );
  const hidden = await merchants.addItem(
    open,
    { categoryId: meals, name: 'مخفي', price: tryAmount(1_000n) },
    change,
  );
  const secret = await merchants.addCategory(open, { name: 'قسم مخفي' }, change);
  await sql.query('UPDATE merchants.items SET hidden = true WHERE id = $1', [hidden]);
  await sql.query('UPDATE merchants.categories SET hidden = true WHERE id = $1', [secret]);
  await merchants.setAvailability(
    open,
    { type: 'item', id: drink },
    { available: false, until: 'tomorrow' },
    change,
  );
  await merchants.setAvailability(
    open,
    { type: 'item', id: water },
    { available: false, until: 'turned_back_on' },
    change,
  );
  // A required extra whose cheaper option is off: «من» skips it.
  const extra = await merchants.addOptionGroup(
    open,
    {
      name: 'الإضافة',
      minChoices: 1,
      maxChoices: 1,
      options: [
        { name: 'جبنة', priceDelta: tryAmount(1_000n) },
        { name: 'لحمة', priceDelta: tryAmount(2_000n) },
      ],
    },
    change,
  );
  const pie = await merchants.addItem(
    open,
    { categoryId: meals, name: 'فطيرة', price: tryAmount(5_000n), optionGroupIds: [extra] },
    change,
  );
  const cheese = (
    await sql.query('SELECT id FROM merchants.options WHERE group_id = $1 ORDER BY position', [
      extra,
    ])
  ).rows[0].id;
  await merchants.setAvailability(
    open,
    { type: 'option', id: cheese },
    { available: false, until: 'turned_back_on' },
    change,
  );
  // Off until tomorrow, in a category off until turned back on.
  const drinks = await merchants.addCategory(open, { name: 'مشروبات' }, change);
  const laban = await merchants.addItem(
    open,
    { categoryId: drinks, name: 'لبن', price: tryAmount(2_000n) },
    change,
  );
  await merchants.setAvailability(
    open,
    { type: 'item', id: laban },
    { available: false, until: 'tomorrow' },
    change,
  );
  await merchants.setAvailability(
    open,
    { type: 'category', id: drinks },
    { available: false, until: 'turned_back_on' },
    change,
  );
  // A window two to three hours from now.
  const breakfast = await merchants.addCategory(
    open,
    {
      name: 'فطور',
      window: { startsAt: (now.minute + 120) % 1440, endsAt: (now.minute + 180) % 1440 },
    },
    change,
  );
  const beans = await merchants.addItem(
    open,
    { categoryId: breakfast, name: 'فول', price: tryAmount(4_000n) },
    change,
  );
  ids = { shawarma, drink, water, hidden, pie, laban, beans };
}, 300_000);

afterAll(async () => {
  await app?.close();
  await sql?.end();
  await Promise.all([database?.stop(), cache?.stop()]);
});

const query = ({ latitude, longitude }: Point) => `latitude=${latitude}&longitude=${longitude}`;

describe('the restaurant list (CU §8.2)', () => {
  it('lists the restaurants that cover the point, open first, then paused, then closed', async () => {
    const answer = await app.inject({
      method: 'GET',
      url: `/v1/customer/restaurants?${query(centre)}`,
    });
    expect(answer.statusCode).toBe(200);
    const { restaurants } = answer.json();
    expect(restaurants.map((card: { id: string }) => card.id)).toEqual([
      open,
      busy,
      paused,
      closed,
      holiday,
    ]);
    expect(restaurants[0]).toEqual({
      id: open,
      nameAr: 'مطعم مفتوح',
      nameEn: 'Open place',
      category: null,
      logoKey: null,
      coverKey: null,
      rating: null,
      ratingCount: null,
      // 20 prep + 0 trip + 10 buffer.
      estimate: { fromMin: 30, toMin: 40 },
      deliveryFee: { fee: { amount: '4000', currency: 'TRY' }, free: false },
      state: { state: 'open', busyMode: false, until: null, opensAt: null, message: null },
    });
    expect(restaurants[1]).toMatchObject({
      // 20 prep + 15 busy + 0 trip + 10 buffer.
      estimate: { fromMin: 45, toMin: 55 },
      state: { state: 'open', busyMode: true },
    });
    expect(restaurants[2].state).toEqual({
      state: 'paused',
      busyMode: false,
      until: null,
      opensAt: null,
      message: 'نعود بعد الصيانة',
    });
    expect(restaurants[3].state).toMatchObject({ state: 'closed', opensAt: expect.any(String) });
    expect(restaurants[4].state).toEqual({
      state: 'holiday',
      busyMode: false,
      until: expect.any(String),
      opensAt: null,
      message: 'عطلة العيد',
    });
  });

  it('adds the trip to the estimate', async () => {
    // About 1.11 km north: 1.11 km × 1.3 ÷ 20 km/h is about 4.3 minutes.
    const north = { latitude: centre.latitude + 0.01, longitude: centre.longitude };
    const { restaurants } = (
      await app.inject({ method: 'GET', url: `/v1/customer/restaurants?${query(north)}` })
    ).json();
    expect(restaurants[0].estimate).toEqual({ fromMin: 35, toMin: 45 });
  });

  it('is empty outside every zone', async () => {
    const far = { latitude: 36.7, longitude: 37.3 };
    const answer = await app.inject({
      method: 'GET',
      url: `/v1/customer/restaurants?${query(far)}`,
    });
    expect(answer.json()).toEqual({ restaurants: [] });
  });
});

describe('the restaurant page (CU §9.1–9.4)', () => {
  const page = (id: string, point: Point = centre) =>
    app.inject({ method: 'GET', url: `/v1/customer/restaurants/${id}?${query(point)}` });

  it('shows the header, the hours and the menu without hidden rows', async () => {
    const answer = await page(open);
    expect(answer.statusCode).toBe(200);
    const body = answer.json();
    expect(body).toMatchObject({
      id: open,
      minimumOrder: { amount: '10000', currency: 'TRY' },
      freeDeliveryFrom: { amount: '50000', currency: 'TRY' },
      deliversHere: true,
      schedule: allWeek,
    });
    expect(body.menu.map((category: { name: string }) => category.name)).toEqual([
      'وجبات',
      'مشروبات',
      'فطور',
    ]);
    const items = body.menu[0].items;
    expect(items.map((item: { id: string }) => item.id)).toEqual([
      ids.shawarma,
      ids.drink,
      ids.water,
      ids.pie,
    ]);
    expect(items[0]).toMatchObject({
      price: { amount: '12000', currency: 'TRY' },
      fromPrice: { amount: '12000', currency: 'TRY' },
      available: true,
      unavailableReason: null,
      optionGroups: [
        {
          name: 'الحجم',
          minChoices: 1,
          maxChoices: 1,
          options: [
            { name: 'وسط', priceDelta: { amount: '0', currency: 'TRY' }, available: true },
            { name: 'كبير', priceDelta: { amount: '2000', currency: 'TRY' }, available: true },
          ],
        },
      ],
    });
    expect(items[1]).toMatchObject({
      fromPrice: null,
      available: false,
      unavailableReason: 'tomorrow',
    });
    expect(items[2]).toMatchObject({ available: false, unavailableReason: 'unavailable' });
    expect(items[3]).toMatchObject({
      fromPrice: { amount: '7000', currency: 'TRY' },
      available: true,
      photoKey: null,
    });
    expect(body.menu[1].items[0]).toMatchObject({
      id: ids.laban,
      available: false,
      unavailableReason: 'unavailable',
    });
    expect(body.menu[2]).toMatchObject({ window: { startsAt: expect.any(Number) } });
    expect(body.menu[2].items[0]).toMatchObject({
      id: ids.beans,
      available: false,
      unavailableReason: 'window',
    });
  });

  it('says when it does not deliver to the point', async () => {
    expect((await page(distant)).json()).toMatchObject({ deliversHere: false });
  });

  it('answers 404 for a restaurant customers do not see', async () => {
    const draft = await merchants.createRestaurant(
      azaz,
      {
        nameAr: 'مسودة',
        location: centre,
        coverage: { kind: 'radius', radiusMetres: 3000 },
        minimumOrder: tryAmount(0n),
        commissionBp: 1500,
        defaultPrepMin: 20,
      },
      change,
    );
    expect((await page(draft)).statusCode).toBe(404);
    const suspended = await restaurant('مطعم موقوف');
    await merchants.setAccountStatus(suspended, 'suspended', { ...change, reason: 'test' });
    expect((await page(suspended)).statusCode).toBe(404);
    const invisible = await restaurant('مطعم غير ظاهر');
    await sql.query('UPDATE merchants.restaurants SET visible = false WHERE id = $1', [invisible]);
    expect((await page(invisible)).statusCode).toBe(404);
    expect((await page(randomUUID())).statusCode).toBe(404);
  });
});

describe('the browsing queries', () => {
  it.each([
    ['an empty latitude', 'latitude=&longitude=37.046'],
    ['no longitude', 'latitude=36.587'],
    ['a latitude past 90', 'latitude=91&longitude=37.046'],
  ])('refuse %s', async (_, search) => {
    const answer = await app.inject({ method: 'GET', url: `/v1/customer/restaurants?${search}` });
    expect(answer.statusCode).toBe(400);
  });
});

describe('similar restaurants (CU §11.9)', () => {
  const similar = (id: string, point: Point = centre) =>
    app.inject({
      method: 'GET',
      url: `/v1/customer/restaurants?${query(point)}&similarTo=${id}`,
    });
  const category = (id: string, name: string | null) =>
    sql.query('UPDATE merchants.restaurants SET category = $2 WHERE id = $1', [id, name]);
  let rejecting: string;
  let others: string[];

  beforeAll(async () => {
    rejecting = await restaurant('مطعم رفض الطلب');
    await merchants.setWeeklySchedule(rejecting, allWeek, change);
    for (const id of [rejecting, open, busy, paused, closed, holiday, distant]) {
      await category(id, 'مشاوي');
    }
    const sweets = await restaurant('حلويات مفتوحة');
    await merchants.setWeeklySchedule(sweets, allWeek, change);
    await category(sweets, 'حلويات');
    others = [];
    for (const name of ['مشاوي ١', 'مشاوي ٢', 'مشاوي ٣', 'مشاوي ٤']) {
      const id = await restaurant(name);
      await merchants.setWeeklySchedule(id, allWeek, change);
      await category(id, 'مشاوي');
      others.push(id);
    }
  });

  it('lists up to 5 open restaurants of the same category that deliver to the point', async () => {
    const answer = await similar(rejecting);
    expect(answer.statusCode).toBe(200);
    const { restaurants } = answer.json();
    // Open in busy mode is open; paused, closed, on holiday, not covering the
    // point, of another category or the restaurant itself are left out.
    expect(restaurants.map((card: { id: string }) => card.id)).toEqual([
      open,
      busy,
      ...others.slice(0, 3),
    ]);
    expect(restaurants[0]).toMatchObject({
      nameAr: 'مطعم مفتوح',
      category: 'مشاوي',
      state: { state: 'open' },
      estimate: { fromMin: 30, toMin: 40 },
    });
  });

  it('is empty without a category, for an unknown restaurant and outside every zone', async () => {
    await category(rejecting, null);
    expect((await similar(rejecting)).json()).toEqual({ restaurants: [] });
    await category(rejecting, 'مشاوي');
    expect((await similar(randomUUID())).json()).toEqual({ restaurants: [] });
    expect((await similar(rejecting, { latitude: 36.7, longitude: 37.3 })).json()).toEqual({
      restaurants: [],
    });
  });
});
