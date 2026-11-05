import 'reflect-metadata';
import { Test, type TestingModule } from '@nestjs/testing';
import pg from 'pg';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { startTestDatabase, type TestDatabase } from '../database/test-database.js';
import { FxService } from '../modules/fx/index.js';
import { GeoService } from '../modules/geo/index.js';
import { SettingsService } from '../modules/settings/index.js';
import { startTestValkey, type TestValkey } from '../valkey/test-valkey.js';
import { PlaceholderSeed, PlaceholderSeedModule, seedsPlaceholders } from './placeholder-seed.js';

// The placeholder data of development and staging (AP §13 items 4 and 5).
let database: TestDatabase;
let cache: TestValkey;
let sql: pg.Pool;
let moduleRef: TestingModule;
let azaz: string;

beforeAll(async () => {
  [database, cache] = await Promise.all([startTestDatabase(), startTestValkey()]);
  process.env.DATABASE_URL = database.appUrl;
  process.env.VALKEY_URL = cache.url;
  sql = new pg.Pool({ connectionString: database.appUrl });
  azaz = (await sql.query("SELECT id FROM geo.cities WHERE code = 'AZ'")).rows[0].id;
  moduleRef = await Test.createTestingModule({ imports: [PlaceholderSeedModule] }).compile();
  await moduleRef.init();
}, 300_000);

afterAll(async () => {
  await moduleRef?.close();
  await sql?.end();
  await Promise.all([database?.stop(), cache?.stop()]);
});

describe('the placeholder seed', () => {
  it('runs in development and staging only', () => {
    expect(seedsPlaceholders('development')).toBe(true);
    expect(seedsPlaceholders('staging')).toBe(true);
    expect(seedsPlaceholders('production')).toBe(false);
    expect(seedsPlaceholders(undefined)).toBe(false);
  });

  it("gives Azaz TRY as its base, USD and SYP disabled, and each currency's rounding unit", async () => {
    // Two servers starting together.
    await Promise.all([moduleRef.get(PlaceholderSeed).run(), moduleRef.get(PlaceholderSeed).run()]);
    const fx = moduleRef.get(FxService);
    const settings = moduleRef.get(SettingsService);

    expect(await fx.cityCurrencies(azaz)).toEqual([
      { currency: 'TRY', displayOrder: 1, enabled: true, isBase: true },
      { currency: 'USD', displayOrder: 2, enabled: false, isBase: false },
      { currency: 'SYP', displayOrder: 3, enabled: false, isBase: false },
    ]);
    const units = await Promise.all(
      ['TRY', 'USD', 'SYP'].map((parameter) =>
        settings.get('currency.<code>.rounding_unit', { cityId: azaz, parameter }),
      ),
    );
    expect(units).toEqual([{ amountMinor: 500 }, { amountMinor: 50 }, { amountMinor: 50_000 }]);
    // The base is marked as a placeholder in its audit event.
    const { rows } = await sql.query(
      "SELECT actor_type, reason FROM audit.events WHERE action = 'base_currency.set' AND city_id = $1",
      [azaz],
    );
    expect(rows).toEqual([
      { actor_type: 'system', reason: 'Placeholder until the field check (AP §13 item 4)' },
    ]);
    const { rows: added } = await sql.query(
      "SELECT target_id FROM audit.events WHERE action = 'city_currency.set' AND city_id = $1 ORDER BY target_id",
      [azaz],
    );
    expect(added.map((row) => row.target_id)).toEqual(['SYP', 'TRY', 'USD']);
  });

  it('gives Azaz one active zone and a flat delivery fee of 40 TRY', async () => {
    const geo = moduleRef.get(GeoService);
    expect(await geo.zones(azaz)).toEqual([
      { id: expect.any(String), name: 'أعزاز', active: true },
    ]);
    await expect(
      geo.zoneAt(azaz, { latitude: 36.5866, longitude: 37.0463 }),
    ).resolves.toMatchObject({ name: 'أعزاز' });
    await expect(geo.deliveryFeeRule(azaz)).resolves.toMatchObject({
      kind: 'flat',
      currency: 'TRY',
      flatFee: 4000n,
      minimumFee: null,
      freeDeliveryFrom: null,
    });
    const { rows } = await sql.query(
      "SELECT count(*)::int AS n FROM audit.events WHERE action = 'delivery_fee_rule.set' AND city_id = $1",
      [azaz],
    );
    expect(rows).toEqual([{ n: 1 }]);
  });

  it('never replaces a value someone entered, and changes nothing when run again', async () => {
    const settings = moduleRef.get(SettingsService);
    await settings.update(
      'currency.<code>.rounding_unit',
      { cityId: azaz, parameter: 'TRY' },
      { amountMinor: 100 },
      {
        editor: { id: '0190f3a0-0000-7000-8000-0000000000f1', roles: ['FIN'] },
        context: { ipAddress: null, device: null },
        reason: 'One lira coins are back',
      },
    );
    const events = async () =>
      Number((await sql.query('SELECT count(*) FROM audit.events')).rows[0].count);
    const before = await events();

    await moduleRef.get(PlaceholderSeed).run();

    expect(
      await settings.get('currency.<code>.rounding_unit', { cityId: azaz, parameter: 'TRY' }),
    ).toEqual({ amountMinor: 100 });
    expect(await events()).toBe(before);
  });
});
