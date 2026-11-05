import 'reflect-metadata';
import { Test, type TestingModule } from '@nestjs/testing';
import pg from 'pg';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { createDatabase, type Database } from '../../database/database.js';
import { startTestDatabase, type TestDatabase } from '../../database/test-database.js';
import { startTestValkey, type TestValkey } from '../../valkey/test-valkey.js';
import { SettingRefusedError, SettingsService } from '../settings/index.js';
import { type FxChange, FxModule, FxRefusedError, FxService } from './index.js';

// The fx module on a fresh database and Valkey, connected as the
// application role, as the server connects (AP §8.6).
let database: TestDatabase;
let cache: TestValkey;
let sql: pg.Pool;
let db: Database;
let moduleRef: TestingModule;
let fx: FxService;
let settings: SettingsService;

beforeAll(async () => {
  [database, cache] = await Promise.all([startTestDatabase(), startTestValkey()]);
  process.env.DATABASE_URL = database.appUrl;
  process.env.VALKEY_URL = cache.url;
  sql = new pg.Pool({ connectionString: database.appUrl });
  db = createDatabase(database.appUrl);
  moduleRef = await Test.createTestingModule({ imports: [FxModule] }).compile();
  await moduleRef.init();
  fx = moduleRef.get(FxService);
  settings = moduleRef.get(SettingsService);
}, 300_000);

afterAll(async () => {
  await moduleRef?.close();
  await db?.pool.end();
  await sql?.end();
  await Promise.all([database?.stop(), cache?.stop()]);
});

const finId = '0190f3a0-0000-7000-8000-0000000000f1';
const context = { ipAddress: '203.0.113.7', device: 'Firefox 140 on Windows' };
const fin: FxChange = { actor: { type: 'admin', id: finId, role: 'FIN' }, context };
const system: FxChange = {
  actor: { type: 'system', id: null, role: null },
  context: { ipAddress: null, device: null },
};
const usdRate = { value: '41.20', direction: 'base_per_unit' } as const;

let cities = 0;

// A new city, so each test starts without currencies.
async function city(): Promise<string> {
  cities += 1;
  const { rows } = await sql.query(
    'INSERT INTO geo.cities (code, name) VALUES ($1, $2) RETURNING id',
    [`Q${String.fromCharCode(64 + cities)}`, `test city ${cities}`],
  );
  return rows[0].id;
}

function accept(cityId: string, currency: string, displayOrder: number, enabled: boolean) {
  return fx.setCityCurrency(cityId, { currency, displayOrder, enabled }, system);
}

// A city with TRY as its base and, when asked, USD at 41.20 TRY.
async function lira(options: { usd?: boolean } = {}): Promise<string> {
  const cityId = await city();
  await accept(cityId, 'TRY', 1, true);
  await fx.setBaseCurrency(cityId, 'TRY', system);
  if (options.usd) {
    await accept(cityId, 'USD', 2, false);
    await fx.setRate(cityId, 'USD', usdRate, fin);
    await accept(cityId, 'USD', 2, true);
  }
  return cityId;
}

function setRounding(cityId: string, code: string, amountMinor: number) {
  return settings.update(
    'currency.<code>.rounding_unit',
    { cityId, parameter: code },
    { amountMinor },
    { editor: { id: finId, roles: ['FIN'] }, context, reason: 'Smallest note in use' },
  );
}

async function refusal(action: Promise<unknown>): Promise<string> {
  const error = await action.then(
    () => null,
    (caught: unknown) => caught,
  );
  if (error instanceof FxRefusedError || error instanceof SettingRefusedError) {
    return error.refusal;
  }
  throw error ?? new Error('expected a refusal');
}

describe('currencies', () => {
  it('are seeded as data with their Arabic name, symbol and ISO decimals', async () => {
    const rows = (await fx.currencies()).map(({ code, nameAr, symbol, decimals, status }) => ({
      code,
      nameAr,
      symbol,
      decimals,
      status,
    }));
    expect(rows).toEqual([
      { code: 'SYP', nameAr: 'ليرة سورية', symbol: 'ل.س', decimals: 2, status: 'active' },
      { code: 'TRY', nameAr: 'ليرة تركية', symbol: '₺', decimals: 2, status: 'active' },
      { code: 'USD', nameAr: 'دولار أمريكي', symbol: '$', decimals: 2, status: 'active' },
    ]);
  });

  it('refuses a currency that is not supported', async () => {
    expect(await refusal(accept(await city(), 'EUR', 1, true))).toBe('unknown_currency');
  });
});

describe("a city's currencies", () => {
  it('lists them in display order with the base marked', async () => {
    const cityId = await lira({ usd: true });
    await accept(cityId, 'SYP', 0, false);

    expect(await fx.cityCurrencies(cityId)).toEqual([
      { currency: 'SYP', displayOrder: 0, enabled: false, isBase: false },
      { currency: 'TRY', displayOrder: 1, enabled: true, isBase: true },
      { currency: 'USD', displayOrder: 2, enabled: true, isBase: false },
    ]);
  });

  it('enables another currency only with a rate against the base', async () => {
    expect(await refusal(accept(await lira(), 'USD', 2, true))).toBe('rate_missing');
  });

  it('keeps the base currency enabled', async () => {
    expect(await refusal(accept(await lira(), 'TRY', 1, false))).toBe('base_disabled');
  });

  it('records each change in the audit log', async () => {
    const cityId = await lira();
    const { rows } = await sql.query(
      `SELECT action, actor_type, target_id FROM audit.events
        WHERE city_id = $1 ORDER BY occurred_at, id`,
      [cityId],
    );
    expect(rows).toEqual([
      { action: 'city_currency.set', actor_type: 'system', target_id: 'TRY' },
      { action: 'base_currency.set', actor_type: 'system', target_id: cityId },
    ]);
  });
});

describe('rates', () => {
  it('stores each change as a new version and serves the newest', async () => {
    const cityId = await lira({ usd: true });
    // «1 TRY = 0.0245 USD»
    const second = await fx.setRate(
      cityId,
      'USD',
      { value: '0.0245', direction: 'units_per_base' },
      { ...fin, reason: 'Morning rate' },
    );

    const { rows } = await sql.query(
      'SELECT rate_numerator, rate_denominator FROM fx.rate_versions WHERE city_id = $1 ORDER BY id',
      [cityId],
    );
    expect(rows).toEqual([
      { rate_numerator: '206', rate_denominator: '5' },
      { rate_numerator: '2000', rate_denominator: '49' },
    ]);
    expect(await fx.currentRates(cityId)).toEqual([
      {
        currency: 'USD',
        baseCurrency: 'TRY',
        rate: { numerator: 2000n, denominator: 49n },
        versionId: second,
        editorId: finId,
        reason: 'Morning rate',
        setAt: expect.any(Date),
      },
    ]);
    const { rows: audit } = await sql.query(
      "SELECT actor_id, changes FROM audit.events WHERE city_id = $1 AND action = 'rate.set' ORDER BY occurred_at, id",
      [cityId],
    );
    expect(audit.at(-1)).toEqual({
      actor_id: finId,
      changes: { rate: { before: '206/5', after: '2000/49' } },
    });
  });

  it('can never be changed or removed by the application role', async () => {
    await lira({ usd: true });
    await expect(sql.query("UPDATE fx.rate_versions SET reason = 'x'")).rejects.toThrow(
      /permission denied/,
    );
    await expect(sql.query('DELETE FROM fx.rate_versions')).rejects.toThrow(/permission denied/);
  });

  it('needs a second confirmation for a change above fx.large_change_confirm_pct', async () => {
    const cityId = await lira({ usd: true });
    // 41.20 → 45.33 moves 10.02 %, above the default 10 %.
    const large = { value: '45.33', direction: 'base_per_unit' } as const;
    expect(await refusal(fx.setRate(cityId, 'USD', large, fin))).toBe('large_change_unconfirmed');
    // 41.20 → 45.32 moves exactly 10 %.
    await fx.setRate(cityId, 'USD', { value: '45.32', direction: 'base_per_unit' }, fin);
    await fx.setRate(
      cityId,
      'USD',
      { value: '30', direction: 'base_per_unit' },
      {
        ...fin,
        confirmLargeChange: true,
      },
    );
    expect((await fx.currentRates(cityId))[0]!.rate).toEqual({ numerator: 30n, denominator: 1n });
  });

  it('is refused for the base, outside the city, from the system and when malformed', async () => {
    const cityId = await lira();
    expect(await refusal(fx.setRate(cityId, 'TRY', usdRate, fin))).toBe('invalid_rate');
    expect(await refusal(fx.setRate(cityId, 'USD', usdRate, fin))).toBe('not_city_currency');
    expect(await refusal(fx.setRate(cityId, 'USD', usdRate, system))).toBe('editor_required');
    await accept(cityId, 'USD', 2, false);
    const malformed = { value: '41,20', direction: 'base_per_unit' } as const;
    expect(await refusal(fx.setRate(cityId, 'USD', malformed, fin))).toBe('invalid_rate');
    expect(await refusal(fx.setRate(await city(), 'USD', usdRate, fin))).toBe('no_base_currency');
  });
});

describe('the base currency', () => {
  it('moves before the first order, leaving the old rates behind', async () => {
    const cityId = await lira({ usd: true });
    await fx.setBaseCurrency(cityId, 'USD', system);

    expect(await fx.baseCurrency(cityId)).toBe('USD');
    // TRY's rate was never set against USD, so TRY waits for one.
    expect(await fx.cityCurrencies(cityId)).toEqual([
      { currency: 'TRY', displayOrder: 1, enabled: false, isBase: false },
      { currency: 'USD', displayOrder: 2, enabled: true, isBase: true },
    ]);
    expect(await fx.currentRates(cityId)).toEqual([]);
  });

  it('is one of the city currencies', async () => {
    expect(await refusal(fx.setBaseCurrency(await lira(), 'SYP', system))).toBe(
      'not_city_currency',
    );
  });

  it('is locked by the first order and never changes after it', async () => {
    const cityId = await lira();
    await accept(cityId, 'SYP', 2, false);
    await setRounding(cityId, 'TRY', 500);

    await db.db.transaction((tx) => fx.snapshotForOrder(cityId, tx));

    expect(await refusal(fx.setBaseCurrency(cityId, 'SYP', system))).toBe('base_locked');
    await db.db.transaction((tx) => fx.snapshotForOrder(cityId, tx));
    expect(await fx.baseCurrency(cityId)).toBe('TRY');
  });

  it('stays free when the order that took the snapshot rolls back', async () => {
    const cityId = await lira();
    await accept(cityId, 'SYP', 2, false);
    await setRounding(cityId, 'TRY', 500);

    await expect(
      db.db.transaction(async (tx) => {
        await fx.snapshotForOrder(cityId, tx);
        throw new Error('the order failed');
      }),
    ).rejects.toThrow('the order failed');

    await fx.setBaseCurrency(cityId, 'SYP', system);
    expect(await fx.baseCurrency(cityId)).toBe('SYP');
  });
});

describe('the rate snapshot', () => {
  it('keeps every enabled currency with its rate version and rounding rule', async () => {
    const cityId = await lira({ usd: true });
    await accept(cityId, 'SYP', 3, false);
    await setRounding(cityId, 'TRY', 500);
    await setRounding(cityId, 'USD', 50);
    await settings.update('currency.<code>.rounding_mode', { cityId, parameter: 'USD' }, 'up', {
      editor: { id: finId, roles: ['FIN'] },
      context,
      reason: 'Never short',
    });
    const [usd] = await fx.currentRates(cityId);

    expect(await fx.snapshot(cityId)).toEqual({
      cityId,
      baseCurrency: 'TRY',
      takenAt: expect.any(Date),
      currencies: [
        {
          code: 'TRY',
          decimals: 2,
          rate: { numerator: 1n, denominator: 1n },
          rateVersionId: null,
          roundingUnitMinor: 500n,
          roundingMode: 'nearest',
        },
        {
          code: 'USD',
          decimals: 2,
          rate: { numerator: 206n, denominator: 5n },
          rateVersionId: usd!.versionId,
          roundingUnitMinor: 50n,
          roundingMode: 'up',
        },
      ],
    });
  });

  it('is refused while a currency has no rounding unit (owner decision 2026-11-05)', async () => {
    const cityId = await lira({ usd: true });
    await setRounding(cityId, 'TRY', 500);
    expect(await refusal(fx.snapshot(cityId))).toBe('rounding_unit_missing');
  });

  it('is refused for a city without a base currency', async () => {
    const cityId = await city();
    expect(await refusal(fx.snapshot(cityId))).toBe('no_base_currency');
    expect(await refusal(db.db.transaction((tx) => fx.snapshotForOrder(cityId, tx)))).toBe(
      'no_base_currency',
    );
  });
});

describe('the settings, through the city currencies', () => {
  const owner = { editor: { id: finId, roles: ['OWN'] as const }, context, reason: 'Set' };

  it('take a currency key only for a currency of the city, enabled or not', async () => {
    const cityId = await lira();
    await accept(cityId, 'SYP', 2, false);
    await setRounding(cityId, 'SYP', 50_000);
    expect(await refusal(setRounding(cityId, 'USD', 50))).toBe('wrong_currency');
  });

  it('take a city amount only in its base currency', async () => {
    const cityId = await lira();
    const tolerance = (currency: string) =>
      settings.update('captain.remit_tolerance', { cityId }, { amountMinor: 500, currency }, owner);
    expect(await refusal(tolerance('USD'))).toBe('wrong_currency');
    await tolerance('TRY');
    expect(await settings.get('captain.remit_tolerance', { cityId })).toEqual({
      amountMinor: 500,
      currency: 'TRY',
    });
    expect(
      await refusal(
        settings.update(
          'captain.remit_tolerance',
          { cityId: await city() },
          { amountMinor: 500, currency: 'TRY' },
          owner,
        ),
      ),
    ).toBe('wrong_currency');
  });

  it('list a currency key once per currency of the city', async () => {
    const cityId = await lira();
    await accept(cityId, 'SYP', 2, false);
    const keys = (await settings.list(cityId, ['FIN'])).map((entry) => entry.key);
    expect(keys).toEqual([
      'currency.<code>.rounding_unit',
      'currency.SYP.rounding_unit',
      'currency.TRY.rounding_unit',
      'currency.<code>.rounding_mode',
      'currency.SYP.rounding_mode',
      'currency.TRY.rounding_mode',
    ]);
  });
});
