import 'reflect-metadata';
import { randomUUID } from 'node:crypto';
import { Test, type TestingModule } from '@nestjs/testing';
import pg from 'pg';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { startTestDatabase, type TestDatabase } from '../../database/test-database.js';
import { startTestValkey, type TestValkey } from '../../valkey/test-valkey.js';
import { type FxChange, FxService } from '../fx/index.js';
import { type GeoChange, GeoService, type Point } from '../geo/index.js';
import {
  type DraftOperations,
  type MerchantChange,
  MerchantsModule,
  MerchantsService,
  RestaurantDraftsService,
} from './index.js';

// The onboarding wizard's draft (AP §9.6.3 steps 1–3; slice 2.30a) on a
// fresh database and Valkey.
let database: TestDatabase;
let cache: TestValkey;
let moduleRef: TestingModule;
let drafts: RestaurantDraftsService;
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
  drafts = moduleRef.get(RestaurantDraftsService);
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

const change: MerchantChange & GeoChange = {
  actor: { type: 'admin', id: '0190f3a0-0000-7000-8000-0000000000a1', role: 'DATA' },
  context: { ipAddress: '203.0.113.7', device: 'Firefox 140 on Windows' },
};
const fxSystem: FxChange = {
  actor: { type: 'system', id: null, role: null },
  context: { ipAddress: null, device: null },
};

const pin = { latitude: 36.587, longitude: 37.046 };
let cities = 0;

function square({ latitude, longitude }: Point, half = 0.01): Point[] {
  return [
    { latitude: latitude - half, longitude: longitude - half },
    { latitude: latitude - half, longitude: longitude + half },
    { latitude: latitude + half, longitude: longitude + half },
    { latitude: latitude + half, longitude: longitude - half },
  ];
}

// A new city with TRY as its base and one active zone around the pin.
async function city(): Promise<{ cityId: string; zoneId: string }> {
  cities += 1;
  const { rows } = await sql.query<{ id: string }>(
    'INSERT INTO geo.cities (code, name) VALUES ($1, $2) RETURNING id',
    [`D${String.fromCharCode(64 + cities)}`, `draft city ${cities}`],
  );
  const cityId = rows[0]!.id;
  await fx.setCityCurrency(cityId, { currency: 'TRY', displayOrder: 1, enabled: true }, fxSystem);
  await fx.setBaseCurrency(cityId, 'TRY', fxSystem);
  const zoneId = await geo.createZone(
    cityId,
    { name: 'centre', area: square(pin), active: true },
    change,
  );
  return { cityId, zoneId };
}

const basics = { nameAr: ' مطعم الضيعة ', nameEn: null, categoryIds: [], description: '' };
const location = {
  location: pin,
  address: 'شارع السوق',
  phone: '+963211234567',
  ownerName: 'أبو أحمد',
  ownerPhone: '+963944000111',
};
const operations: DraftOperations = {
  periods: [
    { weekday: 0, opensAt: 600, closesAt: 900 },
    { weekday: 0, opensAt: 1080, closesAt: 1380 },
  ],
  defaultPrepMin: 20,
  minimumOrder: { amount: 5_000n, currency: 'TRY' },
  coverage: { kind: 'radius', radiusMetres: 3000 },
};

const refusal = (refusal: string) =>
  expect.objectContaining({ name: 'MerchantsRefusedError', refusal });

async function audits(id: string): Promise<string[]> {
  const { rows } = await sql.query<{ action: string }>(
    'SELECT action FROM audit.events WHERE target_id = $1 ORDER BY occurred_at, id',
    [id],
  );
  return rows.map((row) => row.action);
}

describe('step 1: the draft and its basics', () => {
  it('starts a draft with the id the panel names, and a retry adds none', async () => {
    const { cityId } = await city();
    const id = randomUUID();
    await drafts.saveBasics(id, cityId, basics, change);
    await drafts.saveBasics(id, cityId, basics, change);
    expect(await drafts.draft(id)).toMatchObject({
      id,
      cityId,
      accountStatus: 'draft',
      basics: { nameAr: 'مطعم الضيعة', nameEn: null, description: null, categoryIds: [] },
      location: { location: null, address: null },
      operations: { periods: [], defaultPrepMin: null, minimumOrder: null, coverage: null },
      steps: { basics: true, location: false, operations: false },
    });
    expect(await audits(id)).toEqual(['restaurant.create']);
    // No other reader meets a draft without its record.
    expect(await merchants.restaurant(id)).toBeNull();
    await drafts.saveBasics(id, cityId, { ...basics, nameEn: 'Al Daia' }, change);
    expect((await drafts.draft(id))?.basics.nameEn).toBe('Al Daia');
    expect(await audits(id)).toEqual(['restaurant.create', 'restaurant.basics']);
  });

  it('refuses an empty name, an unknown city, a draft of another city and an unknown category', async () => {
    const { cityId } = await city();
    const other = await city();
    const id = randomUUID();
    await expect(drafts.saveBasics(id, cityId, { ...basics, nameAr: ' ' }, change)).rejects.toEqual(
      refusal('invalid_restaurant'),
    );
    await expect(drafts.saveBasics(id, randomUUID(), basics, change)).rejects.toEqual(
      refusal('unknown_city'),
    );
    await drafts.saveBasics(id, cityId, basics, change);
    await expect(drafts.saveBasics(id, other.cityId, basics, change)).rejects.toEqual(
      refusal('not_a_draft'),
    );
    await expect(
      drafts.saveBasics(randomUUID(), cityId, { ...basics, categoryIds: [randomUUID()] }, change),
    ).rejects.toEqual(refusal('unknown_category'));
  });
});

describe('step 2: the pin and the contacts', () => {
  it('saves the pin, the address and the numbers, keeping the numbers out of the audit', async () => {
    const { cityId } = await city();
    const id = randomUUID();
    await drafts.saveBasics(id, cityId, basics, change);
    await drafts.saveLocation(id, location, change);
    await drafts.saveLocation(id, location, change);
    expect(await drafts.draft(id)).toMatchObject({
      location: { ...location, location: pin },
      steps: { location: true, operations: false },
    });
    const { rows } = await sql.query(
      "SELECT changes::text AS changes FROM audit.events WHERE target_id = $1 AND action = 'restaurant.location'",
      [id],
    );
    expect(rows).toHaveLength(1);
    expect(rows[0].changes).not.toContain('963');
  });

  it('refuses a pin off the map and a number not in E.164', async () => {
    const { cityId } = await city();
    const id = randomUUID();
    await drafts.saveBasics(id, cityId, basics, change);
    await expect(
      drafts.saveLocation(id, { ...location, location: { latitude: 91, longitude: 0 } }, change),
    ).rejects.toEqual(refusal('invalid_restaurant'));
    await expect(
      drafts.saveLocation(id, { ...location, ownerPhone: '0944000111' }, change),
    ).rejects.toEqual(refusal('invalid_restaurant'));
  });
});

describe('step 3: the operations', () => {
  it('saves the hours, prep time, minimum order and coverage, then the restaurant is whole', async () => {
    const { cityId, zoneId } = await city();
    const id = randomUUID();
    await drafts.saveBasics(id, cityId, basics, change);
    await drafts.saveOperations(id, operations, change);
    // Still without its pin: no reader meets it.
    expect(await merchants.restaurant(id)).toBeNull();
    await drafts.saveLocation(id, location, change);
    expect(await merchants.restaurant(id)).toMatchObject({
      accountStatus: 'draft',
      coverage: { kind: 'radius', radiusMetres: 3000 },
      minimumOrder: { amount: 5_000n, currency: 'TRY' },
      defaultPrepMin: 20,
      schedule: operations.periods,
    });
    await drafts.saveOperations(
      id,
      { ...operations, coverage: { kind: 'zones', zoneIds: [zoneId] } },
      change,
    );
    await drafts.saveOperations(
      id,
      { ...operations, coverage: { kind: 'zones', zoneIds: [zoneId] } },
      change,
    );
    expect(await drafts.draft(id)).toMatchObject({
      operations: { coverage: { kind: 'zones', zoneIds: [zoneId] }, periods: operations.periods },
      steps: { basics: true, location: true, operations: true },
    });
    expect(await merchants.covers(id, pin)).toBe(true);
    await drafts.saveOperations(id, operations, change);
    expect((await merchants.restaurant(id))?.coverage).toEqual({
      kind: 'radius',
      radiusMetres: 3000,
    });
    const { rows } = await sql.query(
      'SELECT count(*)::int AS versions FROM merchants.weekly_schedules WHERE restaurant_id = $1',
      [id],
    );
    // The hours never changed after the first save: one version.
    expect(rows[0].versions).toBe(1);
    expect(await audits(id)).toEqual([
      'restaurant.create',
      'restaurant.operations',
      'restaurant.location',
      'restaurant.operations',
      'restaurant.operations',
    ]);
  });

  it('refuses no hours, overlapping hours, a prep time out of bounds, another currency and unknown zones', async () => {
    const { cityId } = await city();
    const id = randomUUID();
    await drafts.saveBasics(id, cityId, basics, change);
    const cases: [DraftOperations, string][] = [
      [{ ...operations, periods: [] }, 'invalid_schedule'],
      [
        {
          ...operations,
          periods: [
            { weekday: 1, opensAt: 600, closesAt: 900 },
            { weekday: 1, opensAt: 800, closesAt: 1000 },
          ],
        },
        'invalid_schedule',
      ],
      [{ ...operations, defaultPrepMin: 1 }, 'invalid_prep_time'],
      [{ ...operations, minimumOrder: { amount: 100n, currency: 'USD' } }, 'not_in_base_currency'],
      [{ ...operations, coverage: { kind: 'zones', zoneIds: [randomUUID()] } }, 'invalid_coverage'],
    ];
    for (const [wrong, why] of cases) {
      await expect(drafts.saveOperations(id, wrong, change)).rejects.toEqual(refusal(why));
    }
  });
});

describe('the list and the status', () => {
  it("lists the city's drafts, the latest saved first, and never a restaurant past its draft", async () => {
    const { cityId } = await city();
    const first = randomUUID();
    const second = randomUUID();
    await drafts.saveBasics(first, cityId, basics, change);
    await drafts.saveBasics(second, cityId, { ...basics, nameAr: 'الثاني' }, change);
    await drafts.saveLocation(first, location, change);
    expect(await drafts.drafts(cityId)).toMatchObject([
      { id: first, steps: { location: true, operations: false } },
      { id: second, nameAr: 'الثاني', steps: { location: false } },
    ]);
    // A draft cannot leave its status before its record is whole.
    await expect(merchants.setAccountStatus(first, 'test', change)).rejects.toEqual(
      refusal('status_change_not_allowed'),
    );
    await drafts.saveOperations(first, operations, change);
    await merchants.setAccountStatus(first, 'test', change);
    expect((await drafts.drafts(cityId)).map((draft) => draft.id)).toEqual([second]);
    await expect(drafts.saveLocation(first, location, change)).rejects.toEqual(
      refusal('not_a_draft'),
    );
  });
});
