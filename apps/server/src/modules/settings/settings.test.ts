import 'reflect-metadata';
import { Test, type TestingModule } from '@nestjs/testing';
import { Valkey } from 'iovalkey';
import pg from 'pg';
import { afterAll, beforeAll, beforeEach, describe, expect, it } from 'vitest';
import { startTestDatabase, type TestDatabase } from '../../database/test-database.js';
import { startTestValkey, type TestValkey } from '../../valkey/test-valkey.js';
import {
  type AdminRole,
  SettingRefusedError,
  SettingsModule,
  SettingsService,
  type SettingChange,
} from './index.js';
import { SET_IF_NEWER } from './settings.service.js';

// The settings module on a fresh database and Valkey, connected as the
// application role, as the server connects.
let database: TestDatabase;
let cache: TestValkey;
let sql: pg.Pool;
let valkey: Valkey;
let moduleRef: TestingModule;
let settings: SettingsService;
let azaz: string;
let otherCity: string;

beforeAll(async () => {
  [database, cache] = await Promise.all([startTestDatabase(), startTestValkey()]);
  process.env.DATABASE_URL = database.appUrl;
  process.env.VALKEY_URL = cache.url;
  sql = new pg.Pool({ connectionString: database.appUrl });
  valkey = new Valkey(cache.url);
  azaz = (await sql.query("SELECT id FROM geo.cities WHERE code = 'AZ'")).rows[0].id;
  otherCity = (
    await sql.query("INSERT INTO geo.cities (code, name) VALUES ('TS', 'test city') RETURNING id")
  ).rows[0].id;
  moduleRef = await Test.createTestingModule({ imports: [SettingsModule] }).compile();
  await moduleRef.init();
  settings = moduleRef.get(SettingsService);
}, 300_000);

afterAll(async () => {
  await moduleRef?.close();
  valkey?.disconnect();
  await sql?.end();
  await Promise.all([database?.stop(), cache?.stop()]);
});

beforeEach(async () => {
  await valkey.flushall();
});

const ownerId = '0190f3a0-0000-7000-8000-000000000001';
const context = { ipAddress: '203.0.113.7', device: 'Firefox 140 on Windows' };

function by(roles: AdminRole[], reason?: string): SettingChange {
  return { editor: { id: ownerId, roles }, context, reason: reason ?? null };
}

async function history(key: string) {
  const { rows } = await sql.query(
    `SELECT city_id, action, before, after, editor_id, editor_roles, reason
       FROM settings.changes WHERE key = $1 ORDER BY changed_at, id`,
    [key],
  );
  return rows;
}

async function auditEvents(key: string) {
  const { rows } = await sql.query(
    `SELECT city_id, actor_id, actor_role, action, changes, reason, host(ip_address) AS ip
       FROM audit.events WHERE target_type = 'setting' AND target_id = $1 ORDER BY occurred_at, id`,
    [key],
  );
  return rows;
}

describe('reading a setting', () => {
  it('gives the default of a key never changed', async () => {
    expect(await settings.get('order.merchant_auto_cancel_min', { cityId: azaz })).toBe(7);
    expect(await settings.get('otp.validity_min')).toBe(5);
    expect(await settings.get('platform.hours', { cityId: azaz })).toMatchObject({
      friday: [{ open: '00:00', close: '24:00' }],
    });
  });

  it('gives null for a value still to be entered before launch', async () => {
    expect(await settings.get('merchant.default_min_order', { cityId: azaz })).toBeNull();
  });
});

describe('changing a setting', () => {
  it('takes effect at once in its city only, with its history and audit event', async () => {
    await settings.get('dispatch.offer_timeout_sec', { cityId: azaz });

    await settings.update(
      'dispatch.offer_timeout_sec',
      { cityId: azaz },
      60,
      by(['OWN'], 'Captains need more time'),
    );

    expect(await settings.get('dispatch.offer_timeout_sec', { cityId: azaz })).toBe(60);
    expect(await settings.get('dispatch.offer_timeout_sec', { cityId: otherCity })).toBe(45);
    expect(await history('dispatch.offer_timeout_sec')).toEqual([
      {
        city_id: azaz,
        action: 'update',
        before: 45,
        after: 60,
        editor_id: ownerId,
        editor_roles: ['OWN'],
        reason: 'Captains need more time',
      },
    ]);
    expect(await auditEvents('dispatch.offer_timeout_sec')).toEqual([
      {
        city_id: azaz,
        actor_id: ownerId,
        actor_role: 'OWN',
        action: 'setting.update',
        changes: {
          value: { before: 45, after: 60 },
          isDefault: { before: true, after: false },
        },
        reason: 'Captains need more time',
        ip: '203.0.113.7',
      },
    ]);
  });

  it('keeps one value per parameter of a key', async () => {
    await settings.update(
      'currency.<code>.rounding_unit',
      { cityId: azaz, parameter: 'TRY' },
      { amountMinor: 500 },
      by(['FIN'], 'Smallest coin in use'),
    );

    expect(
      await settings.get('currency.<code>.rounding_unit', { cityId: azaz, parameter: 'TRY' }),
    ).toEqual({ amountMinor: 500 });
    expect(
      await settings.get('currency.<code>.rounding_unit', { cityId: azaz, parameter: 'USD' }),
    ).toBeNull();
    expect(await history('currency.TRY.rounding_unit')).toHaveLength(1);
  });

  it('records nothing when the value does not change', async () => {
    await settings.update('captain.min_age', {}, 21, by(['OWN']));
    await settings.update('captain.min_age', {}, 21, by(['OWN']));

    expect(await history('captain.min_age')).toHaveLength(1);
  });

  it('serves the newest value after two changes', async () => {
    await settings.update('captain.waiting_threshold_min', { cityId: azaz }, 12, by(['OWN']));
    expect(await settings.get('captain.waiting_threshold_min', { cityId: azaz })).toBe(12);
    await settings.update('captain.waiting_threshold_min', { cityId: azaz }, 14, by(['OWN']));

    expect(await settings.get('captain.waiting_threshold_min', { cityId: azaz })).toBe(14);
  });
});

describe('the cache', () => {
  it('serves reads from Valkey until the setting changes', async () => {
    await settings.update('customer.no_answer_pings', { cityId: azaz }, 4, by(['OWN']));
    expect(await settings.get('customer.no_answer_pings', { cityId: azaz })).toBe(4);

    // A write that bypasses the service is not seen while the value is cached.
    await sql.query(
      "UPDATE settings.values SET value = '9' WHERE key = 'customer.no_answer_pings'",
    );
    expect(await settings.get('customer.no_answer_pings', { cityId: azaz })).toBe(4);

    await valkey.flushall();
    expect(await settings.get('customer.no_answer_pings', { cityId: azaz })).toBe(9);
  });

  it('never takes an older value over a newer one', async () => {
    await settings.update('customer.late_cancel_strikes', { cityId: azaz }, 3, by(['OWN']));
    await settings.update('customer.late_cancel_strikes', { cityId: azaz }, 4, by(['OWN']));
    const cacheKey = `settings:${azaz}:customer.late_cancel_strikes`;
    expect(await valkey.get(cacheKey)).toBe('2:{"value":4}');

    // A read that loaded version 1 before the change finishes after it.
    await valkey.eval(SET_IF_NEWER, 1, cacheKey, 1, '{"value":3}', 600);
    expect(await settings.get('customer.late_cancel_strikes', { cityId: azaz })).toBe(4);
  });
});

describe('resetting a setting to its default', () => {
  it('brings the default back and keeps the change in the history', async () => {
    await settings.update('merchant.default_prep_min', { cityId: azaz }, 25, by(['OWN']));

    await settings.reset('merchant.default_prep_min', { cityId: azaz }, by(['OWN']));

    expect(await settings.get('merchant.default_prep_min', { cityId: azaz })).toBe(20);
    expect((await history('merchant.default_prep_min')).map((row) => row.action)).toEqual([
      'update',
      'reset',
    ]);
    expect((await auditEvents('merchant.default_prep_min')).at(-1)).toMatchObject({
      action: 'setting.reset',
      changes: { value: { before: 25, after: 20 }, isDefault: { before: false, after: true } },
    });
  });

  it('records nothing for a setting already at its default', async () => {
    await settings.reset('merchant.no_device_alert_min', { cityId: azaz }, by(['OWN']));

    expect(await history('merchant.no_device_alert_min')).toEqual([]);
  });
});

describe('the refusals', () => {
  it('let OPS change the dispatch mode, its one setting (AP §6.2)', async () => {
    await settings.update('dispatch.mode', { cityId: azaz }, 'mixed', by(['OPS']));

    expect(await settings.get('dispatch.mode', { cityId: azaz })).toBe('mixed');
  });

  it.each([
    [
      'a role that may not edit the setting',
      'role_may_not_edit',
      () => settings.update('dispatch.offer_timeout_sec', { cityId: azaz }, 30, by(['OPS', 'SUP'])),
    ],
    [
      'a money setting changed without a reason',
      'reason_required',
      () =>
        settings.update('merchant.default_commission_pct', { cityId: azaz }, 12, by(['OWN'], ' ')),
    ],
    [
      'a value of the wrong type',
      'invalid_value',
      () => settings.update('dispatch.offer_timeout_sec', { cityId: azaz }, '30', by(['OWN'])),
    ],
    [
      'a city setting without its city',
      'wrong_scope',
      () => settings.get('dispatch.offer_timeout_sec'),
    ],
    [
      'a global setting with a city',
      'wrong_scope',
      () => settings.get('otp.validity_min', { cityId: azaz }),
    ],
    [
      'a key parameter out of its list',
      'wrong_parameter',
      () =>
        settings.get('captain.custody_limit_suggested.<vehicle>', {
          cityId: azaz,
          parameter: 'truck',
        }),
    ],
  ])('refuse %s', async (_, refusal, attempt) => {
    await expect(attempt()).rejects.toMatchObject({
      constructor: SettingRefusedError,
      refusal,
    });
  });

  it('write nothing when they refuse', async () => {
    expect(await history('dispatch.offer_timeout_sec')).toHaveLength(1);
    expect(await history('merchant.default_commission_pct')).toEqual([]);
  });
});
