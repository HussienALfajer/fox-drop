import 'reflect-metadata';
import { Test, type TestingModule } from '@nestjs/testing';
import pg from 'pg';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { startTestDatabase, type TestDatabase } from '../../database/test-database.js';
import { startTestValkey, type TestValkey } from '../../valkey/test-valkey.js';
import { type FxChange, FxRefusedError, FxService } from '../fx/index.js';
import { type GeoChange, GeoService, type Point } from '../geo/index.js';
import {
  type MerchantChange,
  MerchantsModule,
  MerchantsRefusedError,
  MerchantsService,
  type NewRestaurant,
} from './index.js';

// MerchantsService on a fresh database and Valkey: the restaurant record, its
// account status, hours, coverage, minimum order, commission and menu
// (AP §9.6, RA §7, §9, §10).
let database: TestDatabase;
let cache: TestValkey;
let moduleRef: TestingModule;
let merchants: MerchantsService;
let geo: GeoService;
let fx: FxService;
let sql: pg.Pool;

beforeAll(async () => {
  [database, cache] = await Promise.all([startTestDatabase(), startTestValkey()]);
  process.env.DATABASE_URL = database.appUrl;
  process.env.VALKEY_URL = cache.url;
  moduleRef = await Test.createTestingModule({ imports: [MerchantsModule] }).compile();
  await moduleRef.init();
  merchants = moduleRef.get(MerchantsService);
  geo = moduleRef.get(GeoService);
  fx = moduleRef.get(FxService);
  sql = new pg.Pool({ connectionString: database.appUrl });
}, 300_000);

afterAll(async () => {
  await moduleRef?.close();
  await sql?.end();
  await Promise.all([database?.stop(), cache?.stop()]);
});

const context = { ipAddress: '203.0.113.7', device: 'Firefox 140 on Windows' };
const change: MerchantChange & GeoChange = {
  actor: { type: 'admin', id: '0190f3a0-0000-7000-8000-0000000000a1', role: 'OWN' },
  context,
};
const fxSystem: FxChange = {
  actor: { type: 'system', id: null, role: null },
  context: { ipAddress: null, device: null },
};

// A square around a centre; half = 0.01° is about 2 km across.
function square({ latitude, longitude }: Point, half = 0.01): Point[] {
  return [
    { latitude: latitude - half, longitude: longitude - half },
    { latitude: latitude - half, longitude: longitude + half },
    { latitude: latitude + half, longitude: longitude + half },
    { latitude: latitude + half, longitude: longitude - half },
  ];
}

const pin = { latitude: 36.587, longitude: 37.046 };
let cities = 0;

// A new city with TRY as its base and one active zone around the pin.
async function city(): Promise<{ cityId: string; zoneId: string }> {
  cities += 1;
  const { rows } = await sql.query<{ id: string }>(
    'INSERT INTO geo.cities (code, name) VALUES ($1, $2) RETURNING id',
    [`M${String.fromCharCode(64 + cities)}`, `test city ${cities}`],
  );
  const cityId = rows[0]!.id;
  await fx.setCityCurrency(cityId, { currency: 'TRY', displayOrder: 1, enabled: true }, fxSystem);
  await fx.setCityCurrency(cityId, { currency: 'USD', displayOrder: 2, enabled: true }, fxSystem);
  await fx.setBaseCurrency(cityId, 'TRY', fxSystem);
  const zoneId = await geo.createZone(
    cityId,
    { name: 'centre', area: square(pin), active: true },
    change,
  );
  return { cityId, zoneId };
}

const restaurant: NewRestaurant = {
  nameAr: 'مطعم التجربة',
  location: pin,
  coverage: { kind: 'radius', radiusMetres: 1000 },
  minimumOrder: { amount: 10_000n, currency: 'TRY' },
  commissionBp: 1500,
  defaultPrepMin: 20,
};

const refusal = (refusal: string) =>
  expect.objectContaining({ name: 'MerchantsRefusedError', refusal });

describe('MerchantsService.createRestaurant (AP §9.6.3)', () => {
  it('creates a visible draft with its coverage, minimum order and commission', async () => {
    const { cityId } = await city();
    const id = await merchants.createRestaurant(cityId, restaurant, change);
    expect(await merchants.restaurant(id)).toMatchObject({
      id,
      cityId,
      nameAr: 'مطعم التجربة',
      accountStatus: 'draft',
      visible: true,
      coverage: { kind: 'radius', radiusMetres: 1000 },
      minimumOrder: { amount: 10_000n, currency: 'TRY' },
      commissionBp: 1500,
      defaultPrepMin: 20,
      schedule: [],
    });
    const { rows } = await sql.query(
      "SELECT actor_type, changes FROM audit.events WHERE target_id = $1 AND action = 'restaurant.create'",
      [id],
    );
    expect(rows).toMatchObject([
      {
        actor_type: 'admin',
        changes: { minimumOrder: { before: null, after: { amount: '10000', currency: 'TRY' } } },
      },
    ]);
  });

  it('refuses a minimum order outside the city currencies, an empty name and a bad commission', async () => {
    const { cityId } = await city();
    await expect(
      merchants.createRestaurant(
        cityId,
        { ...restaurant, minimumOrder: { amount: 100n, currency: 'SYP' } },
        change,
      ),
    ).rejects.toEqual(refusal('not_in_base_currency'));
    await expect(
      merchants.createRestaurant(cityId, { ...restaurant, nameAr: '  ' }, change),
    ).rejects.toEqual(refusal('invalid_restaurant'));
    await expect(
      merchants.createRestaurant(cityId, { ...restaurant, commissionBp: 10_001 }, change),
    ).rejects.toEqual(refusal('invalid_commission'));
  });

  it("refuses coverage by zones that are not the city's", async () => {
    const { cityId } = await city();
    const other = await city();
    await expect(
      merchants.createRestaurant(
        cityId,
        { ...restaurant, coverage: { kind: 'zones', zoneIds: [other.zoneId] } },
        change,
      ),
    ).rejects.toEqual(refusal('invalid_coverage'));
    await expect(
      merchants.createRestaurant(
        cityId,
        { ...restaurant, coverage: { kind: 'radius', radiusMetres: 0 } },
        change,
      ),
    ).rejects.toBeInstanceOf(MerchantsRefusedError);
  });

  it('keeps the base currency from changing while a minimum order is in it', async () => {
    const { cityId } = await city();
    await merchants.createRestaurant(cityId, restaurant, change);
    await expect(fx.setBaseCurrency(cityId, 'USD', fxSystem)).rejects.toEqual(
      expect.objectContaining({ refusal: 'amounts_in_other_currency' }),
    );
    await expect(fx.setBaseCurrency(cityId, 'USD', fxSystem)).rejects.toBeInstanceOf(
      FxRefusedError,
    );
  });
});

describe('MerchantsService.covers (RA R13, owner decision 2026-11-06)', () => {
  it('covers a point inside the radius and inside an active zone', async () => {
    const { cityId } = await city();
    const id = await merchants.createRestaurant(cityId, restaurant, change);
    // About 550 m north of the pin.
    await expect(merchants.covers(id, { latitude: 36.592, longitude: 37.046 })).resolves.toBe(true);
    // About 1.1 km north: outside the 1 km radius, inside the zone.
    await expect(merchants.covers(id, { latitude: 36.597, longitude: 37.046 })).resolves.toBe(
      false,
    );
  });

  it('never covers a point outside every active zone, whatever the radius', async () => {
    const { cityId } = await city();
    const id = await merchants.createRestaurant(
      cityId,
      { ...restaurant, coverage: { kind: 'radius', radiusMetres: 5000 } },
      change,
    );
    // About 2.2 km north, past the zone's edge.
    await expect(merchants.covers(id, { latitude: 36.607, longitude: 37.046 })).resolves.toBe(
      false,
    );
  });

  it('covers the points of its chosen zones only', async () => {
    const { cityId, zoneId } = await city();
    const north = { latitude: pin.latitude + 0.02, longitude: pin.longitude };
    await geo.createZone(cityId, { name: 'north', area: square(north), active: true }, change);
    const id = await merchants.createRestaurant(
      cityId,
      { ...restaurant, coverage: { kind: 'zones', zoneIds: [zoneId] } },
      change,
    );
    await expect(merchants.covers(id, { latitude: 36.596, longitude: 37.05 })).resolves.toBe(true);
    await expect(merchants.covers(id, north)).resolves.toBe(false);
  });
});

describe('MerchantsService.setAccountStatus (AP §9.6.1)', () => {
  it('moves along the allowed changes and refuses the others', async () => {
    const { cityId } = await city();
    const id = await merchants.createRestaurant(cityId, restaurant, change);
    await expect(merchants.setAccountStatus(id, 'suspended', change)).rejects.toEqual(
      refusal('status_change_not_allowed'),
    );
    await merchants.setAccountStatus(id, 'test', change);
    await merchants.setAccountStatus(id, 'active', change);
    await merchants.setAccountStatus(id, 'suspended', { ...change, reason: 'price parity' });
    const { rows } = await sql.query(
      'SELECT account_status, suspension_reason FROM merchants.restaurants WHERE id = $1',
      [id],
    );
    expect(rows).toEqual([{ account_status: 'suspended', suspension_reason: 'price parity' }]);
    await merchants.setAccountStatus(id, 'terminated', { ...change, reason: 'contract ended' });
    await expect(merchants.setAccountStatus(id, 'active', change)).rejects.toEqual(
      refusal('status_change_not_allowed'),
    );
  });
});

describe('MerchantsService hours and state (RA §7.1, §10)', () => {
  it('is open inside a period on the city clock, closed outside it and while a draft', async () => {
    const { cityId } = await city();
    const id = await merchants.createRestaurant(cityId, restaurant, change);
    // Friday 10:00–02:00 (2026-11-06 is a Friday).
    await merchants.setWeeklySchedule(id, [{ weekday: 5, opensAt: 600, closesAt: 120 }], change);
    const friday = (time: string) => new Date(`2026-11-06T${time}+03:00`);
    await expect(merchants.operatingState(id, friday('12:00:00'))).resolves.toEqual({
      state: 'draft',
    });
    await merchants.setAccountStatus(id, 'active', change);
    await expect(merchants.operatingState(id, friday('12:00:00'))).resolves.toEqual({
      state: 'open',
      busyExtraMin: null,
    });
    await expect(merchants.operatingState(id, friday('09:59:00'))).resolves.toEqual({
      state: 'closed',
    });
    await expect(
      merchants.operatingState(id, new Date('2026-11-07T01:30:00+03:00')),
    ).resolves.toMatchObject({ state: 'open' });
  });

  it('keeps every schedule version and reads the newest', async () => {
    const { cityId } = await city();
    const id = await merchants.createRestaurant(cityId, restaurant, change);
    await merchants.setWeeklySchedule(id, [{ weekday: 1, opensAt: 600, closesAt: 900 }], change);
    await merchants.setWeeklySchedule(id, [{ weekday: 2, opensAt: 660, closesAt: 900 }], change);
    expect((await merchants.restaurant(id))?.schedule).toEqual([
      { weekday: 2, opensAt: 660, closesAt: 900 },
    ]);
    const { rows } = await sql.query(
      'SELECT count(*)::int AS count FROM merchants.weekly_schedules WHERE restaurant_id = $1',
      [id],
    );
    expect(rows).toEqual([{ count: 2 }]);
  });

  it('refuses overlapping or short periods', async () => {
    const { cityId } = await city();
    const id = await merchants.createRestaurant(cityId, restaurant, change);
    await expect(
      merchants.setWeeklySchedule(
        id,
        [
          { weekday: 1, opensAt: 600, closesAt: 900 },
          { weekday: 1, opensAt: 800, closesAt: 1000 },
        ],
        change,
      ),
    ).rejects.toEqual(refusal('invalid_schedule'));
  });

  it('puts a holiday close and a pause in the state', async () => {
    const { cityId } = await city();
    const id = await merchants.createRestaurant(cityId, restaurant, change);
    await merchants.setAccountStatus(id, 'active', change);
    await merchants.setWeeklySchedule(id, [{ weekday: 5, opensAt: 0, closesAt: 0 }], change);
    const noon = new Date('2026-11-06T12:00:00+03:00');
    await sql.query(
      "INSERT INTO merchants.pauses (restaurant_id, source, starts_at, ends_at) VALUES ($1, 'ops', '2026-11-06T11:00:00+03:00', '2026-11-06T13:00:00+03:00')",
      [id],
    );
    await expect(merchants.operatingState(id, noon)).resolves.toMatchObject({
      state: 'paused',
      source: 'ops',
    });
    await sql.query(
      "INSERT INTO merchants.holiday_closes (restaurant_id, starts_at, ends_at, set_by_type) VALUES ($1, '2026-11-06T00:00:00+03:00', '2026-11-08T00:00:00+03:00', 'admin')",
      [id],
    );
    await expect(merchants.operatingState(id, noon)).resolves.toEqual({
      state: 'holiday',
      until: new Date('2026-11-08T00:00:00+03:00'),
    });
  });
});

describe('MerchantsService.setCommission (AP §9.6.5, D16)', () => {
  it('keeps the current commission until a later one takes effect', async () => {
    const { cityId } = await city();
    const id = await merchants.createRestaurant(cityId, restaurant, change);
    const from = new Date(Date.now() + 86_400_000);
    await merchants.setCommission(id, { rateBp: 1000, effectiveFrom: from }, change);
    expect((await merchants.restaurant(id))?.commissionBp).toBe(1500);
    expect((await merchants.restaurant(id, new Date(from.getTime() + 1)))?.commissionBp).toBe(1000);
  });
});

describe('MerchantsService menu (AP §9.6.6, RA §9)', () => {
  it('builds categories, items and option groups and reads them in order', async () => {
    const { cityId } = await city();
    const id = await merchants.createRestaurant(cityId, restaurant, change);
    const mains = await merchants.addCategory(id, { name: 'وجبات' }, change);
    const drinks = await merchants.addCategory(id, { name: 'مشروبات' }, change);
    const size = await merchants.addOptionGroup(
      id,
      {
        name: 'الحجم',
        minChoices: 1,
        maxChoices: 1,
        options: [
          { name: 'وسط', priceDelta: { amount: 0n, currency: 'TRY' } },
          { name: 'كبير', priceDelta: { amount: 2_000n, currency: 'TRY' } },
        ],
      },
      change,
    );
    await merchants.addItem(
      id,
      {
        categoryId: mains,
        name: 'شاورما',
        price: { amount: 12_000n, currency: 'TRY' },
        optionGroupIds: [size],
      },
      change,
    );
    await merchants.addItem(
      id,
      {
        categoryId: drinks,
        code: 'AYRAN',
        name: 'عيران',
        price: { amount: 2_500n, currency: 'TRY' },
      },
      change,
    );
    const menu = await merchants.menu(id);
    expect(menu.currency).toBe('TRY');
    expect(menu.categories.map((category) => category.name)).toEqual(['وجبات', 'مشروبات']);
    expect(menu.categories[0]!.items).toMatchObject([
      {
        code: 'I0001',
        name: 'شاورما',
        price: 12_000n,
        available: true,
        optionGroups: [
          {
            name: 'الحجم',
            minChoices: 1,
            options: [
              { name: 'وسط', priceDelta: 0n },
              { name: 'كبير', priceDelta: 2_000n },
            ],
          },
        ],
      },
    ]);
    expect(menu.categories[1]!.items).toMatchObject([{ code: 'AYRAN', price: 2_500n }]);
  });

  it('makes an item unavailable when its category or every option of a required group is', async () => {
    const { cityId } = await city();
    const id = await merchants.createRestaurant(cityId, restaurant, change);
    const category = await merchants.addCategory(id, { name: 'وجبات' }, change);
    const group = await merchants.addOptionGroup(
      id,
      {
        name: 'الخبز',
        minChoices: 1,
        maxChoices: 1,
        options: [{ name: 'صاج', priceDelta: { amount: 0n, currency: 'TRY' } }],
      },
      change,
    );
    await merchants.addItem(
      id,
      {
        categoryId: category,
        name: 'شاورما',
        price: { amount: 12_000n, currency: 'TRY' },
        optionGroupIds: [group],
      },
      change,
    );
    await sql.query('UPDATE merchants.options SET available = false WHERE group_id = $1', [group]);
    expect((await merchants.menu(id)).categories[0]!.items[0]!.available).toBe(false);
  });

  it('refuses a price of 0, a negative delta, a repeated code and another currency', async () => {
    const { cityId } = await city();
    const id = await merchants.createRestaurant(cityId, restaurant, change);
    const category = await merchants.addCategory(id, { name: 'وجبات' }, change);
    const item = (code: string, amount: bigint, currency = 'TRY') =>
      merchants.addItem(
        id,
        { categoryId: category, code, name: 'x', price: { amount, currency } },
        change,
      );
    await expect(item('A', 0n)).rejects.toEqual(refusal('invalid_menu'));
    await item('A', 100n);
    await expect(item('A', 100n)).rejects.toEqual(refusal('item_code_taken'));
    await expect(item('B', 100n, 'SYP')).rejects.toEqual(refusal('not_in_base_currency'));
    await expect(
      merchants.addOptionGroup(
        id,
        {
          name: 'إضافات',
          minChoices: 0,
          maxChoices: 2,
          options: [{ name: 'جبن', priceDelta: { amount: -1n, currency: 'TRY' } }],
        },
        change,
      ),
    ).rejects.toEqual(refusal('invalid_menu'));
  });
});
