import 'reflect-metadata';
import type { NestFastifyApplication } from '@nestjs/platform-fastify';
import pg from 'pg';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { ApiModule } from '../../api.module.js';
import { startTestDatabase, type TestDatabase } from '../../database/test-database.js';
import { createApiApp } from '../../http/create-api-app.js';
import { startTestValkey, type TestValkey } from '../../valkey/test-valkey.js';
import { GeoService, type Point } from '../geo/index.js';
import { catalogue, SettingsService } from '../settings/index.js';

// Slice D.11a (D.11's owner's answers (b) and (d)): GET platform answers the
// required version, the maintenance return time and, for the customer app at
// a selected point, the platform hours (CU §4.2, §4.7; AP §9.14).
let database: TestDatabase;
let cache: TestValkey;
let app: NestFastifyApplication;
let sql: pg.Pool;
let settings: SettingsService;
let azaz: string;

const context = { ipAddress: null, device: null };
const change = {
  actor: { type: 'system', id: null, role: null },
  context,
  reason: 'test',
} as const;
const bySystem = { editor: 'system', context, reason: 'test' } as const;
const centre = { latitude: 36.5866, longitude: 37.0463 };
const HOUR = 3_600_000;

function square({ latitude, longitude }: Point, half = 0.02): Point[] {
  return [
    { latitude: latitude - half, longitude: longitude - half },
    { latitude: latitude - half, longitude: longitude + half },
    { latitude: latitude + half, longitude: longitude + half },
    { latitude: latitude + half, longitude: longitude - half },
  ];
}

beforeAll(async () => {
  [database, cache] = await Promise.all([startTestDatabase(), startTestValkey()]);
  process.env.DATABASE_URL = database.appUrl;
  process.env.VALKEY_URL = cache.url;
  process.env.IDENTITY_ENCRYPTION_KEY = Buffer.alloc(32, 7).toString('base64');
  sql = new pg.Pool({ connectionString: database.appUrl });
  azaz = (await sql.query("SELECT id FROM geo.cities WHERE code = 'AZ'")).rows[0].id;
  app = await createApiApp(ApiModule);
  await app.init();
  await app.getHttpAdapter().getInstance().ready();
  settings = app.get(SettingsService);
}, 300_000);

afterAll(async () => {
  await app?.close();
  await sql?.end();
  await Promise.all([database?.stop(), cache?.stop()]);
});

const read = (party: string, query = '') =>
  app.inject({ method: 'GET', url: `/v1/${party}/platform?version=1.0.0${query}` });

describe('the required version (CU §4.2)', () => {
  it('is answered when min_version is set, and absent when not', async () => {
    expect((await read('captain')).json()).not.toHaveProperty('minVersion');
    await settings.update('app.<app>.min_version', { parameter: 'captain' }, '2.1.0', bySystem);
    try {
      expect((await read('captain')).json()).toMatchObject({
        updateNeed: 'required',
        minVersion: '2.1.0',
      });
      expect((await read('merchant')).json()).not.toHaveProperty('minVersion');
    } finally {
      await settings.reset('app.<app>.min_version', { parameter: 'captain' }, bySystem);
    }
  });
});

describe('the maintenance return time (CU §4.7, AP §9.14)', () => {
  const maintenance = (value: object) =>
    settings.update('app.<app>.maintenance', { parameter: 'merchant' }, value, bySystem);

  it('is answered while maintenance is on and the time is ahead', async () => {
    const returnsAt = new Date(Date.now() + 2 * HOUR).toISOString();
    await maintenance({ enabled: true, message: 'صيانة', returnsAt });
    try {
      expect((await read('merchant')).json()).toMatchObject({
        maintenance: true,
        maintenanceMessage: 'صيانة',
        maintenanceReturnsAt: returnsAt,
      });
    } finally {
      await settings.reset('app.<app>.maintenance', { parameter: 'merchant' }, bySystem);
    }
  });

  it('is absent once the time has passed, and while maintenance is off', async () => {
    await maintenance({
      enabled: true,
      message: null,
      returnsAt: new Date(Date.now() - HOUR).toISOString(),
    });
    try {
      const passed = (await read('merchant')).json();
      expect(passed).toMatchObject({ maintenance: true });
      expect(passed).not.toHaveProperty('maintenanceReturnsAt');
      await maintenance({
        enabled: false,
        message: null,
        returnsAt: new Date(Date.now() + HOUR).toISOString(),
      });
      expect((await read('merchant')).json()).not.toHaveProperty('maintenanceReturnsAt');
    } finally {
      await settings.reset('app.<app>.maintenance', { parameter: 'merchant' }, bySystem);
    }
  });

  it('keeps a value stored before the return time existed: maintenance stays on', () => {
    expect(
      catalogue['app.<app>.maintenance'].schema.parse({ enabled: true, message: 'صيانة' }),
    ).toEqual({ enabled: true, message: 'صيانة', returnsAt: null });
  });
});

describe('the platform hours at the selected point (CU §4.7)', () => {
  const at = (point: Point) => `&latitude=${point.latitude}&longitude=${point.longitude}`;

  it('are absent without a point, and while no city has a zone', async () => {
    expect((await read('customer')).json()).not.toHaveProperty('hours');
    expect((await read('customer', at(centre))).json()).not.toHaveProperty('hours');
  });

  it('refuse a point with only one coordinate', async () => {
    expect((await read('customer', `&latitude=${centre.latitude}`)).statusCode).toBe(400);
    expect((await read('customer', `&longitude=${centre.longitude}`)).statusCode).toBe(400);
  });

  it("answer open, or closed with the next opening, by the city's platform.hours", async () => {
    await app
      .get(GeoService)
      .createZone(azaz, { name: 'المركز', area: square(centre), active: true }, change);
    expect((await read('customer', at(centre))).json().hours).toEqual({
      open: true,
      opensAt: null,
    });
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
      const closed = (await read('customer', at(centre))).json().hours;
      expect(closed.open).toBe(false);
      const opensAt = new Date(closed.opensAt);
      expect(opensAt.getTime()).toBeGreaterThan(Date.now() + 36 * HOUR);
      expect(opensAt.getTime()).toBeLessThan(Date.now() + 4 * 24 * HOUR);
      // Only the customer app reads the hours.
      expect((await read('captain', at(centre))).json()).not.toHaveProperty('hours');
    } finally {
      await settings.reset('platform.hours', { cityId: azaz }, bySystem);
    }
  });
});
