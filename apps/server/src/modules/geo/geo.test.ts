import 'reflect-metadata';
import { Test, type TestingModule } from '@nestjs/testing';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { startTestDatabase, type TestDatabase } from '../../database/test-database.js';
import { startTestValkey, type TestValkey } from '../../valkey/test-valkey.js';
import { SettingsService } from '../settings/index.js';
import { ROAD_DISTANCES, type RoadDistances } from './distance.js';
import { GeoModule, GeoService } from './index.js';

// GeoService.distance on a fresh database and Valkey, with a fake routing
// service in place of OSRM (architecture §7.1, AP §9.12.3).
let database: TestDatabase;
let cache: TestValkey;
let moduleRef: TestingModule;
let geo: GeoService;
let settings: SettingsService;

const calls: unknown[][] = [];
const fakeRoad: RoadDistances = {
  metres: (...args) => {
    calls.push(args);
    return Promise.resolve(1500.4);
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
}, 300_000);

afterAll(async () => {
  await moduleRef?.close();
  await Promise.all([database?.stop(), cache?.stop()]);
});

const from = { latitude: 36.5866, longitude: 37.0463 };
const to = { latitude: 36.5901, longitude: 37.0518 };
const system = { editor: 'system', context: { ipAddress: null, device: null } } as const;

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
