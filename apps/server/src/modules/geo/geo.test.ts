import 'reflect-metadata';
import { Test, type TestingModule } from '@nestjs/testing';
import pg from 'pg';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { startTestDatabase, type TestDatabase } from '../../database/test-database.js';
import { startTestValkey, type TestValkey } from '../../valkey/test-valkey.js';
import { type FxChange, FxRefusedError, FxService } from '../fx/index.js';
import { SettingsService } from '../settings/index.js';
import { ROAD_DISTANCES, type RoadDistances } from './distance.js';
import {
  type DeliveryFeeRule,
  type GeoChange,
  GeoModule,
  GeoRefusedError,
  GeoService,
  type Point,
} from './index.js';

// GeoService's distances, zones and delivery fees on a fresh database and
// Valkey, with a fake routing service in place of OSRM (architecture §7.1,
// AP §9.12.2–9.12.3).
let database: TestDatabase;
let cache: TestValkey;
let moduleRef: TestingModule;
let geo: GeoService;
let settings: SettingsService;
let fx: FxService;
let sql: pg.Pool;

const calls: unknown[][] = [];
const fakeRoad: RoadDistances = {
  metres: (...args) => {
    calls.push(args);
    return Promise.resolve(1500.4);
  },
  table: (sources, to, vehicle) => {
    calls.push(['table', sources.length, to, vehicle]);
    // The car has no route from its second point.
    return Promise.resolve(
      sources.map((_each, index) => (vehicle === 'car' && index === 1 ? null : 1000.6 + index)),
    );
  },
  route: (from, to, vehicle) => {
    calls.push(['route', vehicle]);
    return Promise.resolve({ metres: 1500.4, seconds: 180.6, line: [from, to] });
  },
};

beforeAll(async () => {
  [database, cache] = await Promise.all([startTestDatabase(), startTestValkey()]);
  process.env.DATABASE_URL = database.appUrl;
  process.env.VALKEY_URL = cache.url;
  moduleRef = await Test.createTestingModule({ imports: [GeoModule] })
    .overrideProvider(ROAD_DISTANCES)
    .useValue(fakeRoad)
    .compile();
  await moduleRef.init();
  geo = moduleRef.get(GeoService);
  settings = moduleRef.get(SettingsService);
  fx = moduleRef.get(FxService);
  sql = new pg.Pool({ connectionString: database.appUrl });
}, 300_000);

afterAll(async () => {
  await moduleRef?.close();
  await sql?.end();
  await Promise.all([database?.stop(), cache?.stop()]);
});

const from = { latitude: 36.5866, longitude: 37.0463 };
const to = { latitude: 36.5901, longitude: 37.0518 };
const system = { editor: 'system', context: { ipAddress: null, device: null } } as const;

describe('GeoService.activeCities (AP §7.2)', () => {
  it('lists the active cities with their clock, Azaz from the first migration', async () => {
    await expect(geo.activeCities()).resolves.toEqual([
      { id: expect.any(String), code: 'AZ', name: 'أعزاز', timeZone: 'Asia/Damascus' },
    ]);
  });
});

describe('GeoService.distance', () => {
  it('asks the routing service by default (pricing.distance_method road)', async () => {
    await expect(geo.distance(from, to, { vehicle: 'motorbike' })).resolves.toEqual({
      metres: 1500,
      method: 'road',
    });
    expect(calls).toEqual([[from, to, 'motorbike']]);
  });

  it('measures the straight line × 1.3 without asking when the method is straight_line', async () => {
    calls.length = 0;
    await settings.update('pricing.distance_method', {}, 'straight_line', system);
    const distance = await geo.distance(from, to, { vehicle: 'car' });
    expect(distance.method).toBe('straight_x1.3');
    expect(distance.metres).toBeGreaterThan(700);
    expect(distance.metres).toBeLessThan(900);
    expect(calls).toEqual([]);
  });
});

describe('GeoService.route (CA §4.6, CU §11.3)', () => {
  it('asks OSRM whatever pricing.distance_method says, and answers the line', async () => {
    calls.length = 0;
    await settings.update('pricing.distance_method', {}, 'straight_line', system);
    const [azaz] = await geo.activeCities();
    await expect(geo.route(azaz!.id, from, to, { vehicle: 'motorbike' })).resolves.toEqual({
      metres: 1500,
      seconds: 181,
      method: 'road',
      line: [from, to],
    });
    expect(calls).toEqual([['route', 'motorbike']]);
    await settings.update('pricing.distance_method', {}, 'road', system);
  });
});

describe('GeoService.distancesTo (AP §9.12.6: the dispatch matrix)', () => {
  const near = { latitude: 36.5871, longitude: 37.0468 };

  it('asks one matrix per vehicle and answers in the sources order', async () => {
    await settings.update('pricing.distance_method', {}, 'road', system);
    calls.length = 0;
    const distances = await geo.distancesTo(
      [
        { point: from, vehicle: 'motorbike' },
        { point: from, vehicle: 'car' },
        { point: near, vehicle: 'motorbike' },
        { point: near, vehicle: 'car' },
      ],
      to,
    );
    expect(distances[0]).toEqual({ metres: 1001, method: 'road' });
    expect(distances[2]).toEqual({ metres: 1002, method: 'road' });
    expect(distances[1]).toEqual({ metres: 1001, method: 'road' });
    // No route for the car's second point: the straight line × 1.3.
    expect(distances[3]?.method).toBe('straight_x1.3');
    expect(calls).toEqual([
      ['table', 2, to, 'motorbike'],
      ['table', 2, to, 'car'],
    ]);
  });

  it('measures every point by the straight line × 1.3 with straight_line, without asking', async () => {
    await settings.update('pricing.distance_method', {}, 'straight_line', system);
    calls.length = 0;
    const distances = await geo.distancesTo([{ point: from, vehicle: 'car' }], to);
    expect(distances).toEqual([{ metres: expect.any(Number), method: 'straight_x1.3' }]);
    expect(calls).toEqual([]);
    await expect(geo.distancesTo([], to)).resolves.toEqual([]);
  });
});

const change: GeoChange = {
  actor: { type: 'admin', id: '0190f3a0-0000-7000-8000-0000000000a1', role: 'OWN' },
  context: { ipAddress: '203.0.113.7', device: 'Firefox 140 on Windows' },
};
const fxSystem: FxChange = {
  actor: { type: 'system', id: null, role: null },
  context: system.context,
};

let cities = 0;

// A new city with TRY as its base, so each test starts without zones or fees.
async function city(): Promise<string> {
  cities += 1;
  const { rows } = await sql.query<{ id: string }>(
    'INSERT INTO geo.cities (code, name) VALUES ($1, $2) RETURNING id',
    [
      `G${String.fromCharCode(65 + Math.floor(cities / 26))}${String.fromCharCode(65 + (cities % 26))}`,
      `test city ${cities}`,
    ],
  );
  const cityId = rows[0]!.id;
  await fx.setCityCurrency(cityId, { currency: 'TRY', displayOrder: 1, enabled: true }, fxSystem);
  await fx.setBaseCurrency(cityId, 'TRY', fxSystem);
  return cityId;
}

// A square around a centre, corner after corner; half = 0.005° is about 1 km
// across.
function square(latitude: number, longitude: number, half = 0.005): Point[] {
  return [
    { latitude: latitude - half, longitude: longitude - half },
    { latitude: latitude - half, longitude: longitude + half },
    { latitude: latitude + half, longitude: longitude + half },
    { latitude: latitude + half, longitude: longitude - half },
  ];
}

const centre = { latitude: 36.6, longitude: 37.05 };

describe('GeoService.zoneAt (AP §9.12.2, CU §7.1)', () => {
  it('names the active zone a point is inside, its edge included', async () => {
    const cityId = await city();
    const id = await geo.createZone(
      cityId,
      { name: 'north', area: square(36.6, 37.05), active: true },
      change,
    );
    await expect(geo.zoneAt(cityId, centre)).resolves.toEqual({ id, name: 'north' });
    await expect(geo.zoneAt(cityId, { latitude: 36.595, longitude: 37.05 })).resolves.toEqual({
      id,
      name: 'north',
    });
  });

  it('finds no zone for a point inside an inactive zone or outside every zone', async () => {
    const cityId = await city();
    await geo.createZone(
      cityId,
      { name: 'closed', area: square(36.6, 37.05), active: false },
      change,
    );
    await expect(geo.zoneAt(cityId, centre)).resolves.toBeNull();
    await expect(geo.zoneAt(cityId, { latitude: 36.7, longitude: 37.2 })).resolves.toBeNull();
  });

  it('finds no zone of another city', async () => {
    const cityId = await city();
    await geo.createZone(cityId, { name: 'here', area: square(36.6, 37.05), active: true }, change);
    await expect(geo.zoneAt(await city(), centre)).resolves.toBeNull();
  });

  it('refuses an active zone that overlaps another active one, not one that shares its edge', async () => {
    const cityId = await city();
    await geo.createZone(cityId, { name: 'town', area: square(36.6, 37.05), active: true }, change);
    await expect(
      geo.createZone(
        cityId,
        { name: 'inside', area: square(36.6, 37.05, 0.002), active: true },
        change,
      ),
    ).rejects.toMatchObject({ refusal: 'zones_overlap' });
    await expect(
      geo.createZone(
        cityId,
        { name: 'crossing', area: square(36.6, 37.058), active: true },
        change,
      ),
    ).rejects.toMatchObject({ refusal: 'zones_overlap' });
    // The square to the east shares the edge at longitude 37.055.
    await expect(
      geo.createZone(cityId, { name: 'east', area: square(36.6, 37.06), active: true }, change),
    ).resolves.toBeTypeOf('string');
    // An inactive zone may overlap, but stays inactive while it does.
    const draft = await geo.createZone(
      cityId,
      { name: 'draft', area: square(36.6, 37.05, 0.002), active: false },
      change,
    );
    await expect(geo.setZoneActive(cityId, draft, true, change)).rejects.toMatchObject({
      refusal: 'zones_overlap',
    });
  });

  it('activates and deactivates a zone, audited', async () => {
    const cityId = await city();
    const id = await geo.createZone(
      cityId,
      { name: 'later', area: square(36.6, 37.05), active: false },
      change,
    );
    await geo.setZoneActive(cityId, id, true, change);
    await expect(geo.zoneAt(cityId, centre)).resolves.toEqual({ id, name: 'later' });
    await geo.setZoneActive(cityId, id, true, change);
    await geo.setZoneActive(cityId, id, false, change);
    await expect(geo.zoneAt(cityId, centre)).resolves.toBeNull();
    const { rows } = await sql.query(
      "SELECT changes FROM audit.events WHERE target_id = $1 AND action = 'zone.update' ORDER BY id",
      [id],
    );
    expect(rows).toEqual([
      { changes: { active: { before: false, after: true } } },
      { changes: { active: { before: true, after: false } } },
    ]);
    await expect(geo.setZoneActive(await city(), id, true, change)).rejects.toMatchObject({
      refusal: 'unknown_zone',
    });
  });

  it('refuses an area that crosses itself or has too few corners, and a repeated name', async () => {
    const cityId = await city();
    const [a, b, c, d] = square(36.6, 37.05) as [Point, Point, Point, Point];
    const create = (area: Point[], name: string) =>
      geo.createZone(cityId, { name, area, active: true }, change).catch((error: unknown) => error);
    await expect(create([a, c, b, d], 'bow tie')).resolves.toMatchObject({
      refusal: 'invalid_area',
    });
    await expect(create([a, b], 'line')).resolves.toMatchObject({ refusal: 'invalid_area' });
    await expect(create([a, b, c, d], 'same')).resolves.toBeTypeOf('string');
    const repeated = await create(square(36.7, 37.1), 'same');
    expect(repeated).toBeInstanceOf(GeoRefusedError);
    expect(repeated).toMatchObject({ refusal: 'zone_name_taken' });
    await expect(create(square(36.8, 37.2), '  ')).resolves.toMatchObject({
      refusal: 'invalid_name',
    });
  });

  it('records the new zone in the audit log', async () => {
    const cityId = await city();
    const id = await geo.createZone(
      cityId,
      { name: 'audited', area: square(36.6, 37.05), active: true },
      change,
    );
    const { rows } = await sql.query(
      "SELECT action, target_id, changes FROM audit.events WHERE city_id = $1 AND action LIKE 'zone.%'",
      [cityId],
    );
    expect(rows).toEqual([
      {
        action: 'zone.create',
        target_id: id,
        changes: {
          name: { before: null, after: 'audited' },
          active: { before: null, after: true },
          area: { before: null, after: square(36.6, 37.05) },
        },
      },
    ]);
  });
});

describe('GeoService.saveZone (AP §9.12.2: drawing and editing a zone)', () => {
  it('creates a zone under the id the panel chose, and saving it again changes nothing', async () => {
    const cityId = await city();
    const id = crypto.randomUUID();
    const zone = { name: 'drawn', area: square(36.6, 37.05), active: false };
    await expect(geo.saveZone(cityId, id, zone, change)).resolves.toBe('created');
    await expect(geo.saveZone(cityId, id, zone, change)).resolves.toBe('updated');
    await expect(geo.zoneOutlines(cityId)).resolves.toEqual([{ id, ...zone }]);
    const { rows } = await sql.query(
      "SELECT action FROM audit.events WHERE target_id = $1 AND action LIKE 'zone.%'",
      [id],
    );
    expect(rows).toEqual([{ action: 'zone.create' }]);
  });

  it('renames a zone and moves its outline, audited with what changed', async () => {
    const cityId = await city();
    const id = await geo.createZone(
      cityId,
      { name: 'old name', area: square(36.6, 37.05), active: true },
      change,
    );
    await geo.saveZone(
      cityId,
      id,
      { name: ' new name ', area: square(36.6, 37.05, 0.003), active: true },
      change,
    );
    await expect(geo.zoneAt(cityId, { latitude: 36.604, longitude: 37.05 })).resolves.toBeNull();
    await expect(geo.zoneAt(cityId, centre)).resolves.toEqual({ id, name: 'new name' });
    await expect(geo.zoneOutlines(cityId)).resolves.toEqual([
      { id, name: 'new name', active: true, area: square(36.6, 37.05, 0.003) },
    ]);
    // The same value again changes and records nothing.
    await geo.saveZone(
      cityId,
      id,
      { name: 'new name', area: square(36.6, 37.05, 0.003), active: true },
      change,
    );
    const { rows } = await sql.query(
      "SELECT changes FROM audit.events WHERE target_id = $1 AND action = 'zone.update'",
      [id],
    );
    expect(rows).toEqual([
      {
        changes: {
          name: { before: 'old name', after: 'new name' },
          area: { before: square(36.6, 37.05), after: square(36.6, 37.05, 0.003) },
        },
      },
    ]);
  });

  it('writes and audits a new order of the same corners', async () => {
    const cityId = await city();
    const id = await geo.createZone(
      cityId,
      { name: 'order', area: square(36.6, 37.05), active: false },
      change,
    );
    const [a, b, c, d] = square(36.6, 37.05) as [Point, Point, Point, Point];
    await geo.saveZone(cityId, id, { name: 'order', area: [b, c, d, a], active: false }, change);
    await expect(geo.zoneOutlines(cityId)).resolves.toEqual([
      { id, name: 'order', active: false, area: [b, c, d, a] },
    ]);
  });

  it('refuses taking another city code', async () => {
    const one = await city();
    const two = await city();
    const other = (await geo.city(two))!;
    await geo.updateCity(one, { ...(await geo.city(one))!, code: 'QZ' }, change);
    await expect(geo.updateCity(two, { ...other, code: 'QZ' }, change)).rejects.toMatchObject({
      refusal: 'city_code_taken',
    });
  });

  it('activates a zone with its new outline, refusing one that overlaps an active zone', async () => {
    const cityId = await city();
    await geo.createZone(cityId, { name: 'west', area: square(36.6, 37.05), active: true }, change);
    const id = await geo.createZone(
      cityId,
      { name: 'east', area: square(36.6, 37.058), active: false },
      change,
    );
    await expect(
      geo.saveZone(cityId, id, { name: 'east', area: square(36.6, 37.058), active: true }, change),
    ).rejects.toMatchObject({ refusal: 'zones_overlap' });
    // Moved to share the edge at longitude 37.055, it may be active.
    await geo.saveZone(
      cityId,
      id,
      { name: 'east', area: square(36.6, 37.06), active: true },
      change,
    );
    await expect(geo.zoneAt(cityId, { latitude: 36.6, longitude: 37.06 })).resolves.toEqual({
      id,
      name: 'east',
    });
    // An active zone's outline cannot move over another active one.
    await expect(
      geo.saveZone(cityId, id, { name: 'east', area: square(36.6, 37.058), active: true }, change),
    ).rejects.toMatchObject({ refusal: 'zones_overlap' });
  });

  it('refuses a bad outline, an empty or repeated name and a zone of another city', async () => {
    const cityId = await city();
    const id = await geo.createZone(
      cityId,
      { name: 'one', area: square(36.6, 37.05), active: false },
      change,
    );
    await geo.createZone(cityId, { name: 'two', area: square(36.7, 37.1), active: false }, change);
    const [a, b, c, d] = square(36.6, 37.05) as [Point, Point, Point, Point];
    const update = (zone: { name: string; area: Point[] }, inCity = cityId) =>
      geo.saveZone(inCity, id, { ...zone, active: false }, change).catch((error: unknown) => error);
    await expect(update({ name: 'one', area: [a, c, b, d] })).resolves.toMatchObject({
      refusal: 'invalid_area',
    });
    await expect(update({ name: 'one', area: [a, b] })).resolves.toMatchObject({
      refusal: 'invalid_area',
    });
    await expect(update({ name: ' ', area: [a, b, c, d] })).resolves.toMatchObject({
      refusal: 'invalid_name',
    });
    await expect(update({ name: 'two', area: [a, b, c, d] })).resolves.toMatchObject({
      refusal: 'zone_name_taken',
    });
    await expect(update({ name: 'one', area: [a, b, c, d] }, await city())).resolves.toMatchObject({
      refusal: 'unknown_zone',
    });
  });
});

describe('GeoService.voteMap (AP §9.12.2: votes from outside the zones)', () => {
  it("counts the city's votes by cells of about 100 m, the most voted first", async () => {
    const cityId = await city();
    // Far from the other tests' zones, so the votes belong to this city.
    await geo.createZone(cityId, { name: 'far', area: square(10, 10), active: true }, change);
    const device = () => crypto.randomUUID();
    await geo.castVote(device(), { latitude: 10.02011, longitude: 10.00021 });
    await geo.castVote(device(), { latitude: 10.02014, longitude: 10.00024 });
    await geo.castVote(device(), { latitude: 10.0301, longitude: 10.0102 });
    await expect(geo.voteMap(cityId)).resolves.toEqual([
      { latitude: 10.02, longitude: 10, votes: 2 },
      { latitude: 10.03, longitude: 10.01, votes: 1 },
    ]);
    await expect(geo.voteMap(await city())).resolves.toEqual([]);
    // A zone drawn over a vote and activated leaves it off the map.
    await geo.createZone(
      cityId,
      { name: 'covered', area: square(10.03, 10.01, 0.002), active: true },
      change,
    );
    await expect(geo.voteMap(cityId)).resolves.toEqual([
      { latitude: 10.02, longitude: 10, votes: 2 },
    ]);
  });
});

describe('GeoService.updateCity (AP §9.12.1 «المدن»)', () => {
  it('changes the name, code, clock and status, audited with what changed', async () => {
    const cityId = await city();
    await geo.updateCity(
      cityId,
      { name: ' renamed ', code: 'QQ', timeZone: 'Europe/Istanbul', status: 'inactive' },
      { ...change, reason: 'testing' },
    );
    await expect(geo.city(cityId)).resolves.toEqual({
      id: cityId,
      name: 'renamed',
      code: 'QQ',
      timeZone: 'Europe/Istanbul',
      status: 'inactive',
    });
    expect((await geo.activeCities()).map((each) => each.id)).not.toContain(cityId);
    expect(await geo.cities()).toContainEqual(await geo.city(cityId));
    // The same values again record nothing.
    await geo.updateCity(
      cityId,
      { name: 'renamed', code: 'QQ', timeZone: 'Europe/Istanbul', status: 'inactive' },
      change,
    );
    const { rows } = await sql.query(
      "SELECT changes, reason FROM audit.events WHERE target_id = $1 AND action = 'city.update'",
      [cityId],
    );
    expect(rows).toEqual([
      {
        changes: {
          name: { before: expect.stringMatching(/^test city/), after: 'renamed' },
          code: { before: expect.any(String), after: 'QQ' },
          timeZone: { before: 'Asia/Damascus', after: 'Europe/Istanbul' },
          status: { before: 'active', after: 'inactive' },
        },
        reason: 'testing',
      },
    ]);
  });

  it('refuses to deactivate the last active city', async () => {
    const { rows } = await sql.query<{ id: string }>(
      "SELECT id FROM geo.cities WHERE status = 'active'",
    );
    // Every other active city is made inactive by the application role's
    // own update, so Azaz is the last.
    const azaz = (await geo.cities()).find((each) => each.code === 'AZ')!;
    await sql.query("UPDATE geo.cities SET status = 'inactive' WHERE id <> $1", [azaz.id]);
    await expect(
      geo.updateCity(azaz.id, { ...azaz, status: 'inactive' }, change),
    ).rejects.toMatchObject({ refusal: 'last_active_city' });
    await sql.query("UPDATE geo.cities SET status = 'active' WHERE id = ANY($1)", [
      rows.map((row) => row.id),
    ]);
  });

  it('refuses an empty name, a malformed or taken code, an unknown clock and city', async () => {
    const cityId = await city();
    const current = (await geo.city(cityId))!;
    const update = (fields: Partial<typeof current>, id = cityId) =>
      geo.updateCity(id, { ...current, ...fields }, change).catch((error: unknown) => error);
    await expect(update({ name: '  ' })).resolves.toMatchObject({ refusal: 'invalid_name' });
    await expect(update({ code: 'az' })).resolves.toMatchObject({ refusal: 'invalid_city' });
    await expect(update({ code: 'AZ' })).resolves.toMatchObject({ refusal: 'city_code_taken' });
    await expect(update({ timeZone: 'Mars/Olympus' })).resolves.toMatchObject({
      refusal: 'invalid_city',
    });
    await expect(update({}, crypto.randomUUID())).resolves.toMatchObject({
      refusal: 'unknown_city',
    });
    await expect(geo.city(crypto.randomUUID())).resolves.toBeNull();
  });
});

describe('GeoService.deliveryFee (AP §9.12.3)', () => {
  const flat = {
    kind: 'flat',
    currency: 'TRY',
    flatFee: 4000n,
    minimumFee: null,
    freeDeliveryFrom: null,
  } as const;

  it('charges the flat fee without measuring the distance', async () => {
    const cityId = await city();
    const ruleId = await geo.setDeliveryFeeRule(cityId, flat, change);
    calls.length = 0;
    await expect(
      geo.deliveryFee(cityId, { restaurantId: null, from, to, itemsValue: 20_000n }),
    ).resolves.toEqual({
      fee: 4000n,
      currency: 'TRY',
      free: false,
      ruleId,
      scope: 'city',
      freeDeliveryFrom: null,
      distance: null,
    });
    expect(calls).toEqual([]);
  });

  it('charges the band of the motorbike road distance, and nothing from the threshold', async () => {
    const cityId = await city();
    await settings.update('pricing.distance_method', {}, 'road', system);
    await geo.setDeliveryFeeRule(
      cityId,
      {
        kind: 'distance_bands',
        currency: 'TRY',
        bands: [
          { upToMetres: 1500, fee: 3000n },
          { upToMetres: null, fee: 5000n },
        ],
        minimumFee: null,
        freeDeliveryFrom: 50_000n,
      },
      change,
    );
    calls.length = 0;
    await expect(
      geo.deliveryFee(cityId, { restaurantId: null, from, to, itemsValue: 20_000n }),
    ).resolves.toMatchObject({
      fee: 3000n,
      free: false,
      distance: { metres: 1500, method: 'road' },
    });
    expect(calls).toEqual([[from, to, 'motorbike']]);
    await expect(
      geo.deliveryFee(cityId, { restaurantId: null, from, to, itemsValue: 50_000n }),
    ).resolves.toMatchObject({ fee: 0n, free: true });
  });

  it('uses the newest rule; a change is a new version', async () => {
    const cityId = await city();
    await geo.setDeliveryFeeRule(cityId, flat, change);
    const newer = await geo.setDeliveryFeeRule(cityId, { ...flat, flatFee: 4500n }, change);
    await expect(geo.deliveryFeeRule(cityId)).resolves.toMatchObject({
      id: newer,
      flatFee: 4500n,
    });
    await expect(
      geo.deliveryFee(cityId, { restaurantId: null, from, to, itemsValue: 1n }),
    ).resolves.toMatchObject({
      fee: 4500n,
      ruleId: newer,
    });
    const { rows } = await sql.query(
      "SELECT count(*)::int AS n FROM audit.events WHERE city_id = $1 AND action = 'delivery_fee_rule.set'",
      [cityId],
    );
    expect(rows).toEqual([{ n: 2 }]);
  });

  it('measures the bands by the straight line × 1.3 when the method says so', async () => {
    const cityId = await city();
    await settings.update('pricing.distance_method', {}, 'straight_line', system);
    await geo.setDeliveryFeeRule(
      cityId,
      {
        kind: 'distance_bands',
        currency: 'TRY',
        bands: [
          { upToMetres: 500, fee: 2000n },
          { upToMetres: null, fee: 3500n },
        ],
        minimumFee: null,
        freeDeliveryFrom: null,
      },
      change,
    );
    calls.length = 0;
    await expect(
      geo.deliveryFee(cityId, { restaurantId: null, from, to, itemsValue: 1n }),
    ).resolves.toMatchObject({
      fee: 3500n,
      distance: { method: 'straight_x1.3' },
    });
    expect(calls).toEqual([]);
    await settings.update('pricing.distance_method', {}, 'road', system);
  });

  it('adds no version for a rule that charges the same', async () => {
    const cityId = await city();
    const id = await geo.setDeliveryFeeRule(cityId, flat, change);
    await expect(geo.setDeliveryFeeRule(cityId, { ...flat }, change)).resolves.toBe(id);
    const { rows } = await sql.query(
      "SELECT count(*)::int AS n FROM audit.events WHERE city_id = $1 AND action = 'delivery_fee_rule.set'",
      [cityId],
    );
    expect(rows).toEqual([{ n: 1 }]);
  });

  it('refuses a fee while the city has no rule', async () => {
    const cityId = await city();
    await expect(geo.deliveryFeeRule(cityId)).resolves.toBeNull();
    await expect(
      geo.deliveryFee(cityId, { restaurantId: null, from, to, itemsValue: 1n }),
    ).rejects.toMatchObject({
      refusal: 'no_fee_rule',
    });
  });

  it('refuses a rule outside the base currency and a malformed one', async () => {
    const cityId = await city();
    await expect(
      geo.setDeliveryFeeRule(cityId, { ...flat, currency: 'USD' }, change),
    ).rejects.toMatchObject({ refusal: 'fee_not_in_base_currency' });
    await expect(
      geo.setDeliveryFeeRule(cityId, { ...flat, flatFee: -1n }, change),
    ).rejects.toMatchObject({ refusal: 'invalid_fee_rule' });
  });

  it('refuses a rule in a city with no currencies', async () => {
    const { rows } = await sql.query<{ id: string }>(
      "INSERT INTO geo.cities (code, name) VALUES ('GZZ', 'no currencies') RETURNING id",
    );
    await expect(geo.setDeliveryFeeRule(rows[0]!.id, flat, change)).rejects.toMatchObject({
      refusal: 'fee_not_in_base_currency',
    });
  });

  it('lets the base change once the rule is entered in the new base, until the first order', async () => {
    const cityId = await city();
    await geo.setDeliveryFeeRule(cityId, flat, change);
    await fx.setCityCurrency(
      cityId,
      { currency: 'USD', displayOrder: 2, enabled: false },
      fxSystem,
    );
    await geo.setDeliveryFeeRule(cityId, { ...flat, currency: 'USD', flatFee: 100n }, change);
    // Until the base follows, no fee is charged in another currency.
    await expect(
      geo.deliveryFee(cityId, { restaurantId: null, from, to, itemsValue: 1n }),
    ).rejects.toMatchObject({
      refusal: 'fee_not_in_base_currency',
    });
    await fx.setBaseCurrency(cityId, 'USD', fxSystem);
    await expect(
      geo.deliveryFee(cityId, { restaurantId: null, from, to, itemsValue: 1n }),
    ).resolves.toMatchObject({
      fee: 100n,
      currency: 'USD',
    });
    // Once the first order locks the base, the rule stays in it.
    await sql.query('UPDATE fx.city_bases SET locked_at = now() WHERE city_id = $1', [cityId]);
    await expect(
      geo.setDeliveryFeeRule(cityId, { ...flat, currency: 'TRY' }, change),
    ).rejects.toMatchObject({ refusal: 'fee_not_in_base_currency' });
  });

  it('keeps the base currency while the fee rule is in it (AP §8.6)', async () => {
    const cityId = await city();
    await geo.setDeliveryFeeRule(cityId, flat, change);
    await fx.setCityCurrency(
      cityId,
      { currency: 'USD', displayOrder: 2, enabled: false },
      fxSystem,
    );
    const refused = await fx
      .setBaseCurrency(cityId, 'USD', fxSystem)
      .catch((error: unknown) => error);
    expect(refused).toBeInstanceOf(FxRefusedError);
    expect(refused).toMatchObject({ refusal: 'amounts_in_other_currency' });
  });
});

describe("GeoService.setRestaurantFeeRule (AP §9.12.3: a restaurant's own rule)", () => {
  const cityRule = {
    kind: 'flat',
    currency: 'TRY',
    flatFee: 4000n,
    minimumFee: null,
    freeDeliveryFrom: null,
  } as const;
  const ownRule: DeliveryFeeRule = {
    kind: 'distance_bands',
    currency: 'TRY',
    bands: [
      { upToMetres: 1000, fee: 1500n },
      { upToMetres: null, fee: 2500n },
    ],
    minimumFee: 2000n,
    freeDeliveryFrom: 30_000n,
  };
  const restaurant = '0190f3a0-0000-7000-8000-00000000f001';
  const other = '0190f3a0-0000-7000-8000-00000000f002';

  it("replaces the city's rule for that restaurant alone", async () => {
    const cityId = await city();
    const cityRuleId = await geo.setDeliveryFeeRule(cityId, cityRule, change);
    const ownId = await geo.setRestaurantFeeRule(cityId, restaurant, ownRule, change);
    await settings.update('pricing.distance_method', {}, 'road', system);
    // 1500 m: the second band, 2500.
    await expect(
      geo.deliveryFee(cityId, { restaurantId: restaurant, from, to, itemsValue: 1n }),
    ).resolves.toMatchObject({ fee: 2500n, ruleId: ownId, scope: 'restaurant' });
    await expect(
      geo.deliveryFee(cityId, { restaurantId: restaurant, from, to, itemsValue: 30_000n }),
    ).resolves.toMatchObject({ fee: 0n, free: true, freeDeliveryFrom: 30_000n });
    await expect(
      geo.deliveryFee(cityId, { restaurantId: other, from, to, itemsValue: 1n }),
    ).resolves.toMatchObject({ fee: 4000n, ruleId: cityRuleId, scope: 'city' });
  });

  it('prices a restaurant with its own rule while the city has none', async () => {
    const cityId = await city();
    await geo.setRestaurantFeeRule(cityId, restaurant, cityRule, change);
    await expect(
      geo.deliveryFee(cityId, { restaurantId: restaurant, from, to, itemsValue: 1n }),
    ).resolves.toMatchObject({ fee: 4000n, scope: 'restaurant' });
    await expect(
      geo.deliveryFee(cityId, { restaurantId: other, from, to, itemsValue: 1n }),
    ).rejects.toMatchObject({ refusal: 'no_fee_rule' });
  });

  it("returns the restaurant to the city's rule, each change a version, audited", async () => {
    const cityId = await city();
    const cityRuleId = await geo.setDeliveryFeeRule(cityId, cityRule, change);
    // Following the city already, null adds nothing.
    await expect(geo.setRestaurantFeeRule(cityId, restaurant, null, change)).resolves.toBeNull();
    const ownId = await geo.setRestaurantFeeRule(cityId, restaurant, ownRule, change);
    // The same rule again adds nothing.
    await expect(
      geo.setRestaurantFeeRule(cityId, restaurant, { ...ownRule }, change),
    ).resolves.toBe(ownId);
    await expect(geo.restaurantFeeRules(cityId)).resolves.toEqual([
      expect.objectContaining({
        restaurantId: restaurant,
        rule: expect.objectContaining({ id: ownId, kind: 'distance_bands', minimumFee: 2000n }),
        editorId: change.actor.id,
      }),
    ]);
    await expect(geo.setRestaurantFeeRule(cityId, restaurant, null, change)).resolves.toBeNull();
    await expect(geo.restaurantFeeRules(cityId)).resolves.toEqual([]);
    await expect(
      geo.deliveryFee(cityId, { restaurantId: restaurant, from, to, itemsValue: 1n }),
    ).resolves.toMatchObject({ ruleId: cityRuleId, scope: 'city' });
    const { rows } = await sql.query(
      "SELECT target_type, target_id, changes->'kind'->>'after' AS kind FROM audit.events WHERE city_id = $1 AND action = 'restaurant_fee_rule.set' ORDER BY id",
      [cityId],
    );
    expect(rows).toEqual([
      { target_type: 'restaurant', target_id: restaurant, kind: 'distance_bands' },
      { target_type: 'restaurant', target_id: restaurant, kind: 'city_rule' },
    ]);
  });

  it("keeps the city's rule apart from the restaurants' in its versions", async () => {
    const cityId = await city();
    const first = await geo.setDeliveryFeeRule(cityId, cityRule, change);
    await geo.setRestaurantFeeRule(cityId, restaurant, ownRule, change);
    const second = await geo.setDeliveryFeeRule(cityId, { ...cityRule, flatFee: 4500n }, change);
    await expect(geo.deliveryFeeRule(cityId)).resolves.toMatchObject({ id: second });
    const versions = await geo.deliveryFeeVersions(cityId);
    expect(versions.map((version) => version.rule.id)).toEqual([second, first]);
    expect(versions[0]).toMatchObject({ editorId: change.actor.id, createdAt: expect.any(Date) });
  });

  it('refuses a rule outside the base currency or malformed', async () => {
    const cityId = await city();
    await expect(
      geo.setRestaurantFeeRule(cityId, restaurant, { ...cityRule, currency: 'USD' }, change),
    ).rejects.toMatchObject({ refusal: 'fee_not_in_base_currency' });
    await expect(
      geo.setRestaurantFeeRule(cityId, restaurant, { ...ownRule, bands: [] }, change),
    ).rejects.toMatchObject({ refusal: 'invalid_fee_rule' });
  });

  it("keeps the base currency while a restaurant's rule is in it (AP §8.6)", async () => {
    const cityId = await city();
    await fx.setCityCurrency(
      cityId,
      { currency: 'USD', displayOrder: 2, enabled: false },
      fxSystem,
    );
    await geo.setDeliveryFeeRule(cityId, { ...cityRule, currency: 'USD', flatFee: 100n }, change);
    await geo.setRestaurantFeeRule(cityId, restaurant, cityRule, change);
    await expect(fx.setBaseCurrency(cityId, 'USD', fxSystem)).rejects.toMatchObject({
      refusal: 'amounts_in_other_currency',
    });
    await geo.setRestaurantFeeRule(cityId, restaurant, null, change);
    await expect(fx.setBaseCurrency(cityId, 'USD', fxSystem)).resolves.toBeUndefined();
  });
});

describe('GeoService.office (AP §9.12.1, CA C13, §7.5)', () => {
  const location = { latitude: 36.5862, longitude: 37.0471 };
  // Saturday to Thursday 09:00–23:00 on the city's clock, Friday closed.
  const hours = [6, 0, 1, 2, 3, 4].map((weekday) => ({
    weekday,
    opensAt: 9 * 60,
    closesAt: 23 * 60,
  }));

  it('has no office until one is saved', async () => {
    const cityId = await city();
    await expect(geo.office(cityId, new Date())).resolves.toBeNull();
  });

  it('answers whether the desk is open now, when it closes today, and when it opens next', async () => {
    const cityId = await city();
    await geo.setOffice(cityId, { location, hours }, change);
    // Thursday 22:00 in Azaz (UTC+3): open until 23:00.
    await expect(geo.office(cityId, new Date('2026-11-12T19:00:00Z'))).resolves.toEqual({
      location,
      landmark: null,
      hours: [0, 1, 2, 3, 4, 6].map((weekday) => ({ weekday, opensAt: 540, closesAt: 1380 })),
      timeZone: 'Asia/Damascus',
      open: true,
      closesAt: new Date('2026-11-12T20:00:00Z'),
      opensAt: null,
    });
    // Friday 00:00: closed until Saturday 09:00.
    await expect(geo.office(cityId, new Date('2026-11-12T21:00:00Z'))).resolves.toMatchObject({
      open: false,
      closesAt: null,
      opensAt: new Date('2026-11-14T06:00:00Z'),
    });
  });

  // Slice D.11a (D.11's owner's answer (d)): «وصف المكان», shown to the
  // customer and the captain.
  it('keeps the landmark in a new version, trimmed, an empty one as none, audited', async () => {
    const cityId = await city();
    await geo.setOffice(cityId, { location, hours, landmark: '  بجانب جامع الفاروق ' }, change);
    await expect(geo.office(cityId, new Date())).resolves.toMatchObject({
      landmark: 'بجانب جامع الفاروق',
    });
    await geo.setOffice(cityId, { location, hours, landmark: '   ' }, change);
    await expect(geo.office(cityId, new Date())).resolves.toMatchObject({ landmark: null });
    const { rows } = await sql.query(
      "SELECT changes FROM audit.events WHERE city_id = $1 AND action = 'city.office' ORDER BY id",
      [cityId],
    );
    expect(rows.map((row) => row.changes.landmark)).toEqual([
      { before: null, after: 'بجانب جامع الفاروق' },
      { before: 'بجانب جامع الفاروق', after: null },
    ]);
    const { rows: versions } = await sql.query(
      'SELECT landmark FROM geo.offices WHERE city_id = $1 ORDER BY id',
      [cityId],
    );
    expect(versions).toEqual([{ landmark: 'بجانب جامع الفاروق' }, { landmark: null }]);
  });

  it('refuses a landmark over 120 characters, and the database does too', async () => {
    const cityId = await city();
    await expect(
      geo.setOffice(cityId, { location, hours, landmark: 'م'.repeat(121) }, change),
    ).rejects.toMatchObject({ refusal: 'invalid_office' });
    await geo.setOffice(cityId, { location, hours, landmark: 'م'.repeat(120) }, change);
    await expect(
      sql.query(
        "INSERT INTO geo.offices (city_id, latitude, longitude, landmark) VALUES ($1, 36.5, 37.0, ' ')",
        [cityId],
      ),
    ).rejects.toThrow(/check constraint/);
  });

  it('keeps every version, the newest in force, audited, and the application role cannot change one', async () => {
    const cityId = await city();
    await geo.setOffice(cityId, { location, hours }, change);
    const moved = { latitude: 36.59, longitude: 37.05 };
    await geo.setOffice(cityId, { location: moved, hours: [] }, change);
    await expect(geo.office(cityId, new Date())).resolves.toMatchObject({
      location: moved,
      hours: [],
      open: false,
      opensAt: null,
    });
    const { rows } = await sql.query(
      "SELECT action, changes FROM audit.events WHERE city_id = $1 AND action = 'city.office' ORDER BY id",
      [cityId],
    );
    expect(rows).toHaveLength(2);
    expect(rows[1]).toEqual({
      action: 'city.office',
      changes: {
        location: { before: location, after: moved },
        hours: {
          before: [0, 1, 2, 3, 4, 6].map((weekday) => ({ weekday, opensAt: 540, closesAt: 1380 })),
          after: [],
        },
      },
    });
    await expect(sql.query('UPDATE geo.offices SET latitude = 0')).rejects.toThrow(
      /permission denied/,
    );
    await expect(sql.query('UPDATE geo.office_periods SET opens_at = 0')).rejects.toThrow(
      /permission denied/,
    );
  });

  it.each([
    [
      'two periods on one weekday',
      [
        { weekday: 1, opensAt: 540, closesAt: 600 },
        { weekday: 1, opensAt: 700, closesAt: 800 },
      ],
    ],
    ['a period shorter than 30 minutes', [{ weekday: 1, opensAt: 540, closesAt: 560 }]],
    ['a weekday out of range', [{ weekday: 7, opensAt: 540, closesAt: 600 }]],
    [
      'a period crossing into the next one',
      [
        { weekday: 1, opensAt: 1200, closesAt: 600 },
        { weekday: 2, opensAt: 540, closesAt: 900 },
      ],
    ],
  ])('refuses %s (invalid_office)', async (_, periods) => {
    const cityId = await city();
    await expect(geo.setOffice(cityId, { location, hours: periods }, change)).rejects.toMatchObject(
      {
        refusal: 'invalid_office',
      },
    );
  });

  it('refuses a point off the map and an unknown city', async () => {
    const cityId = await city();
    await expect(
      geo.setOffice(cityId, { location: { latitude: 91, longitude: 0 }, hours }, change),
    ).rejects.toMatchObject({ refusal: 'invalid_office' });
    await expect(
      geo.setOffice('0190f3a0-0000-7000-8000-00000000ffff', { location, hours }, change),
    ).rejects.toMatchObject({ refusal: 'unknown_city' });
  });
});
