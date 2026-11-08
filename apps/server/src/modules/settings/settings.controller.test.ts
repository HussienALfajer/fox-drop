import 'reflect-metadata';
import type { NestFastifyApplication } from '@nestjs/platform-fastify';
import pg from 'pg';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { ApiModule } from '../../api.module.js';
import { createDatabase, type Database } from '../../database/database.js';
import { startTestDatabase, type TestDatabase } from '../../database/test-database.js';
import { createApiApp } from '../../http/create-api-app.js';
import { startTestValkey, type TestValkey } from '../../valkey/test-valkey.js';
import { FxService } from '../fx/index.js';
import { ADMIN_SESSION_COOKIE, AdminSessionsService } from '../identity/index.js';

// The settings routes of AP §9.14 through the whole API, as each role calls
// them (owner decision 2026-11-05: each role sees and edits the settings
// whose Appendix A edit roles hold it).
let database: TestDatabase;
let cache: TestValkey;
let app: NestFastifyApplication;
let sql: pg.Pool;
let db: Database;
let sessions: AdminSessionsService;
let azaz: string;

const context = { ipAddress: '203.0.113.9', device: 'Firefox 140 on Windows' };

beforeAll(async () => {
  [database, cache] = await Promise.all([startTestDatabase(), startTestValkey()]);
  process.env.DATABASE_URL = database.appUrl;
  process.env.VALKEY_URL = cache.url;
  process.env.IDENTITY_ENCRYPTION_KEY = Buffer.alloc(32, 7).toString('base64');
  sql = new pg.Pool({ connectionString: database.appUrl });
  db = createDatabase(database.appUrl);
  azaz = (await sql.query("SELECT id FROM geo.cities WHERE code = 'AZ'")).rows[0].id;
  app = await createApiApp(ApiModule);
  await app.init();
  // Azaz's currencies (AP §8.6): TRY as its base.
  const fx = app.get(FxService);
  const system = { actor: { type: 'system', id: null, role: null }, context } as const;
  await fx.setCityCurrency(azaz, { currency: 'TRY', displayOrder: 1, enabled: true }, system);
  await fx.setBaseCurrency(azaz, 'TRY', system);
  await app.getHttpAdapter().getInstance().ready();
  sessions = app.get(AdminSessionsService);
}, 300_000);

afterAll(async () => {
  await app?.close();
  await db?.pool.end();
  await sql?.end();
  await Promise.all([database?.stop(), cache?.stop()]);
});

let accounts = 0;

// A signed-in admin holding these roles. The identity tables are written as
// rows here: this test needs a session, not the sign-in.
async function admin(roles: string[]) {
  accounts += 1;
  const { rows } = await sql.query(
    `INSERT INTO identity.admin_accounts (name, email, status, password_hash, totp_secret_encrypted)
     VALUES ($1, $2, 'active', 'not used', 'not used') RETURNING id`,
    [`Settings ${accounts}`, `settings${accounts}@example.test`],
  );
  const accountId: string = rows[0].id;
  for (const role of roles) {
    await sql.query(
      'INSERT INTO identity.admin_account_roles (account_id, role_code) VALUES ($1, $2)',
      [accountId, role],
    );
  }
  const { token } = await sessions.start(db.db, accountId, context, new Date());
  const cookies = { [ADMIN_SESSION_COOKIE]: token };
  return {
    accountId,
    get: (url: string) => app.inject({ method: 'GET', url, cookies }),
    put: (url: string, payload: object) => app.inject({ method: 'PUT', url, cookies, payload }),
    post: (url: string, payload: object) => app.inject({ method: 'POST', url, cookies, payload }),
  };
}

interface Entry {
  key: string;
  group: string;
  value: unknown;
  isDefault: boolean;
  default: unknown;
}

describe('the grouped settings (AP §9.14)', () => {
  it('shows OWN every setting, by group, with its default, value, unit and scope', async () => {
    const own = await admin(['OWN']);
    const response = await own.get(`/v1/admin/settings?cityId=${azaz}`);
    expect(response.statusCode).toBe(200);
    const { settings } = response.json<{ settings: Entry[] }>();

    const groups = settings.map((entry) => entry.group);
    expect([...new Set(groups)]).toEqual([
      'timers_limits',
      'dispatch',
      'customers',
      'captains',
      'restaurants',
      'support',
      'finance',
      'security',
      'apps',
    ]);
    // A group's settings are together.
    expect(groups).toEqual([...groups].sort((a, b) => groups.indexOf(a) - groups.indexOf(b)));
    expect(settings.find((entry) => entry.key === 'dispatch.offer_timeout_sec')).toEqual({
      key: 'dispatch.offer_timeout_sec',
      template: 'dispatch.offer_timeout_sec',
      parameter: null,
      group: 'dispatch',
      type: 'duration',
      unit: 'sec',
      scope: 'city',
      cityId: azaz,
      editRoles: ['OWN'],
      reasonRequired: false,
      beforeLaunch: false,
      default: 45,
      value: 45,
      isDefault: true,
    });
    expect(settings.find((entry) => entry.key === 'otp.validity_min')).toMatchObject({
      group: 'security',
      scope: 'global',
      cityId: null,
    });
    // One entry per vehicle, per app and per currency of the city.
    const keys = settings.map((entry) => entry.key);
    expect(keys).toContain('captain.custody_limit_suggested.car');
    expect(keys).toContain('app.captain.maintenance');
    // A currency key with no currency, the panel's «أضف عملة», then the city's.
    expect(keys.filter((key) => key.startsWith('currency.'))).toEqual([
      'currency.<code>.rounding_unit',
      'currency.TRY.rounding_unit',
      'currency.<code>.rounding_mode',
      'currency.TRY.rounding_mode',
    ]);
    expect(settings.find((entry) => entry.key === 'currency.<code>.rounding_unit')).toMatchObject({
      parameter: null,
      beforeLaunch: true,
      value: null,
      isDefault: true,
      editRoles: ['OWN', 'FIN'],
    });
  });

  it('shows OPS only the dispatch mode and FIN only the currencies', async () => {
    const ops = await admin(['OPS']);
    const fin = await admin(['FIN']);
    const opsList = (await ops.get(`/v1/admin/settings?cityId=${azaz}`)).json<{
      settings: Entry[];
    }>();
    expect(opsList.settings.map((entry) => entry.key)).toEqual(['dispatch.mode']);

    const put = await fin.put('/v1/admin/settings/currency.TRY.rounding_mode', {
      cityId: azaz,
      value: 'up',
      reason: 'Round prices up to the coin',
    });
    expect(put.statusCode).toBe(200);
    expect(put.json()).toMatchObject({
      key: 'currency.TRY.rounding_mode',
      template: 'currency.<code>.rounding_mode',
      parameter: 'TRY',
      value: 'up',
      isDefault: false,
    });
    const finList = (await fin.get(`/v1/admin/settings?cityId=${azaz}`)).json<{
      settings: Entry[];
    }>();
    expect(finList.settings.map((entry) => entry.key)).toEqual([
      'currency.<code>.rounding_unit',
      'currency.TRY.rounding_unit',
      'currency.<code>.rounding_mode',
      'currency.TRY.rounding_mode',
    ]);
  });

  it('refuses a role that edits no setting, and a list without its city', async () => {
    for (const role of ['SUP', 'DATA']) {
      const caller = await admin([role]);
      expect((await caller.get(`/v1/admin/settings?cityId=${azaz}`)).statusCode).toBe(403);
    }
    const own = await admin(['OWN']);
    expect((await own.get('/v1/admin/settings')).statusCode).toBe(400);
  });
});

describe('editing a setting (AP §9.14, §14 item 28)', () => {
  it('lets OPS switch the dispatch mode, audited, and nothing else', async () => {
    const ops = await admin(['OPS']);
    const put = await ops.put('/v1/admin/settings/dispatch.mode', {
      cityId: azaz,
      value: 'mixed',
    });
    expect(put.statusCode).toBe(200);
    expect(put.json()).toMatchObject({ value: 'mixed', isDefault: false });
    const { rows } = await sql.query(
      `SELECT actor_id, actor_role, action, city_id FROM audit.events
        WHERE target_type = 'setting' AND target_id = 'dispatch.mode'`,
    );
    expect(rows).toEqual([
      { actor_id: ops.accountId, actor_role: 'OPS', action: 'setting.update', city_id: azaz },
    ]);

    const refused = await ops.put('/v1/admin/settings/dispatch.offer_timeout_sec', {
      cityId: azaz,
      value: 60,
    });
    expect(refused.statusCode).toBe(403);
    // The roles come first: a wrong value or a reset without a default on a
    // key OPS may not edit is refused for the role, not for the value.
    const wrongValue = await ops.put('/v1/admin/settings/dispatch.offer_timeout_sec', {
      cityId: azaz,
      value: 'soon',
    });
    expect(wrongValue.statusCode).toBe(403);
    const noDefault = await ops.post('/v1/admin/settings/merchant.default_min_order/reset', {});
    expect(noDefault.statusCode).toBe(403);
    expect(
      (await ops.get(`/v1/admin/settings/dispatch.offer_timeout_sec/history?cityId=${azaz}`))
        .statusCode,
    ).toBe(403);
  });

  it('asks a reason for a setting with money impact', async () => {
    const own = await admin(['OWN']);
    const url = '/v1/admin/settings/merchant.default_commission_pct';
    const missing = await own.put(url, { cityId: azaz, value: 12 });
    expect(missing.statusCode).toBe(400);
    expect(missing.json()).toMatchObject({ error: 'reason_required' });
    const blank = await own.put(url, { cityId: azaz, value: 12, reason: '   ' });
    expect(blank.json()).toMatchObject({ error: 'reason_required' });

    const given = await own.put(url, { cityId: azaz, value: 12, reason: 'Launch offer' });
    expect(given.statusCode).toBe(200);
    expect(given.json()).toMatchObject({ value: 12, reasonRequired: true });
  });

  it.each([
    ['a value its type refuses', 'dispatch.mode', { value: 'random' }, true, 400],
    ['a value out of range', 'merchant.prep_time_step_min', { value: 0 }, true, 400],
    ['a city on a global setting', 'otp.validity_min', { value: 6 }, true, 400],
    ['no city on a city setting', 'dispatch.mode', { value: 'auto' }, false, 400],
    ['a wrong parameter', 'app.watch.maintenance', { value: { enabled: true } }, false, 400],
    ['a key outside the catalogue', 'order.unknown_min', { value: 1 }, true, 404],
    ['a body without its value', 'otp.validity_min', {}, false, 400],
  ])('refuses %s', async (_, key, body, withCity, status) => {
    const own = await admin(['OWN']);
    const payload = withCity ? { ...body, cityId: azaz } : body;
    const response = await own.put(`/v1/admin/settings/${key}`, payload);
    expect(response.statusCode).toBe(status);
  });

  it('names the refusal of a wrong value', async () => {
    const own = await admin(['OWN']);
    const response = await own.put('/v1/admin/settings/dispatch.mode', {
      cityId: azaz,
      value: 'random',
    });
    expect(response.json()).toMatchObject({ statusCode: 400, error: 'invalid_value' });
  });
});

describe('restoring the default and reading the history (AP §9.14, §4.4)', () => {
  it('resets a setting to its default and lists its changes, newest first', async () => {
    const own = await admin(['OWN']);
    const url = '/v1/admin/settings/customer.rating_window_days';
    await own.put(url, { cityId: azaz, value: 5 });
    await own.put(url, { cityId: azaz, value: 6, reason: 'More time to rate' });
    const reset = await own.post(`${url}/reset`, { cityId: azaz });
    expect(reset.statusCode).toBe(200);
    expect(reset.json()).toMatchObject({ value: 3, default: 3, isDefault: true });

    const history = await own.get(`${url}/history?cityId=${azaz}`);
    expect(history.statusCode).toBe(200);
    const { changes } = history.json<{ changes: Record<string, unknown>[] }>();
    expect(
      changes.map(({ action, before, after, reason }) => ({ action, before, after, reason })),
    ).toEqual([
      { action: 'reset', before: 6, after: 3, reason: null },
      { action: 'update', before: 5, after: 6, reason: 'More time to rate' },
      { action: 'update', before: 3, after: 5, reason: null },
    ]);
    expect(changes[0]).toMatchObject({ editorId: own.accountId, editorRoles: ['OWN'] });
    expect(
      (await sql.query("SELECT 1 FROM audit.events WHERE action = 'setting.reset'")).rowCount,
    ).toBe(1);
  });

  it('refuses to reset a value entered before launch, which has no default', async () => {
    const own = await admin(['OWN']);
    const url = '/v1/admin/settings/merchant.default_min_order';
    await own.put(url, {
      cityId: azaz,
      value: { amountMinor: 5000, currency: 'TRY' },
      reason: 'Minimum order at launch',
    });
    const reset = await own.post(`${url}/reset`, { cityId: azaz, reason: 'Undo' });
    expect(reset.statusCode).toBe(400);
    expect(reset.json()).toMatchObject({ error: 'no_default' });
  });

  it('edits the compensation cap per role (AP §9.15, §6.4)', async () => {
    const own = await admin(['OWN']);
    const put = await own.put('/v1/admin/settings/support.compensation_cap_pct.SUP', {
      cityId: azaz,
      value: 25,
      reason: 'Tighter cap for support',
    });
    expect(put.statusCode).toBe(200);
    expect(put.json()).toMatchObject({ group: 'support', value: 25 });
  });
});

describe("the apps' platform read (CU §4.2, §4.7, RA §4.2, §4.10, CA §4.2, §4.8)", () => {
  const read = (party: string, version: string) =>
    app.inject({ method: 'GET', url: `/v1/${party}/platform?version=${version}` });

  it('answers no update and no maintenance by default, without a session', async () => {
    const answer = await read('merchant', '1.0.0');
    expect(answer.statusCode).toBe(200);
    expect(answer.json()).toEqual({ updateNeed: 'none', maintenance: false });
  });

  it("answers the app's versions, update message and maintenance as OWN sets them", async () => {
    const own = await admin(['OWN']);
    const set = (key: string, value: unknown) =>
      own.put(`/v1/admin/settings/${key}`, { value, reason: null });
    expect((await set('app.captain.min_version', '1.4.0')).statusCode).toBe(200);
    expect((await set('app.captain.latest_version', '1.10.0')).statusCode).toBe(200);
    expect((await set('app.captain.update_message', 'حدّث التطبيق')).statusCode).toBe(200);
    expect(
      (await set('app.customer.maintenance', { enabled: true, message: 'صيانة قصيرة' })).statusCode,
    ).toBe(200);

    expect((await read('captain', '1.3.9')).json()).toEqual({
      updateNeed: 'required',
      updateMessage: 'حدّث التطبيق',
      maintenance: false,
    });
    expect((await read('captain', '1.9.0')).json()).toMatchObject({ updateNeed: 'suggested' });
    expect((await read('captain', '1.10.0')).json()).toMatchObject({ updateNeed: 'none' });
    // Each app has its own settings.
    expect((await read('customer', '1.0.0')).json()).toEqual({
      updateNeed: 'none',
      maintenance: true,
      maintenanceMessage: 'صيانة قصيرة',
    });
    expect((await read('merchant', '1.0.0')).json()).toEqual({
      updateNeed: 'none',
      maintenance: false,
    });
  });

  it('refuses a version not in the form 1.4.0', async () => {
    expect((await read('customer', '1.4')).statusCode).toBe(400);
  });
});
