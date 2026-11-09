import 'reflect-metadata';
import { randomBytes, randomInt, randomUUID } from 'node:crypto';
import type { NestFastifyApplication } from '@nestjs/platform-fastify';
import pg from 'pg';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { ApiModule } from '../../api.module.js';
import { DATABASE } from '../../database/database.module.js';
import { createDatabase, type Database } from '../../database/database.js';
import { startTestDatabase, type TestDatabase } from '../../database/test-database.js';
import { createApiApp } from '../../http/create-api-app.js';
import { startTestValkey, type TestValkey } from '../../valkey/test-valkey.js';
import { NotificationTexts } from '../content/index.js';
import { FxService } from '../fx/index.js';
import {
  ADMIN_SESSION_COOKIE,
  AdminSessionsService,
  CODE_SENDER,
  type DevelopmentCodeSender,
  MerchantAccountsService,
} from '../identity/index.js';
import {
  AlertsService,
  PushQueue,
  type RealtimePublisher,
  RestaurantStateRelay,
} from '../notifications/index.js';
import { MerchantsService, RestaurantStatusService } from './index.js';

// The panel's restaurant actions on its state (AP §9.6.5): operations pause
// with a reason and a message, resume any pause (the auto-pause's alert
// resolving at once, AP §9.1.3), end busy mode, close for a holiday and set
// the maximum active orders; the restaurant hears it (RA §16 #23) and
// customers see it (CU §9.2).
let database: TestDatabase;
let cache: TestValkey;
let app: NestFastifyApplication;
let sql: pg.Pool;
let db: Database;
let merchants: MerchantsService;
let azaz: string;
let accounts = 0;

const system = { type: 'system', id: null, role: null } as const;
const change = { actor: system, context: { ipAddress: null, device: null }, reason: 'test' };
const allWeek = [0, 1, 2, 3, 4, 5, 6].map((weekday) => ({ weekday, opensAt: 0, closesAt: 0 }));

beforeAll(async () => {
  [database, cache] = await Promise.all([startTestDatabase(), startTestValkey()]);
  process.env.DATABASE_URL = database.appUrl;
  process.env.VALKEY_URL = cache.url;
  process.env.IDENTITY_ENCRYPTION_KEY = randomBytes(32).toString('base64');
  process.env.FOX_DROP_ENVIRONMENT = 'development';
  sql = new pg.Pool({ connectionString: database.appUrl });
  db = createDatabase(database.appUrl);
  app = await createApiApp(ApiModule);
  await app.init();
  await app.getHttpAdapter().getInstance().ready();
  merchants = app.get(MerchantsService);
  azaz = (await sql.query("SELECT id FROM geo.cities WHERE code = 'AZ'")).rows[0].id;
  const fx = app.get(FxService);
  await fx.setCityCurrency(azaz, { currency: 'TRY', displayOrder: 1, enabled: true }, change);
  await fx.setBaseCurrency(azaz, 'TRY', change);
}, 300_000);

afterAll(async () => {
  await app?.close();
  await db?.pool.end();
  await sql?.end();
  await Promise.all([database?.stop(), cache?.stop()]);
});

async function admin(role: string) {
  accounts += 1;
  const { rows } = await sql.query(
    `INSERT INTO identity.admin_accounts (name, email, status, password_hash, totp_secret_encrypted)
     VALUES ($1, $2, 'active', 'not used', 'not used') RETURNING id`,
    [`Operator ${accounts}`, `status${accounts}@example.test`],
  );
  await sql.query(
    'INSERT INTO identity.admin_account_roles (account_id, role_code) VALUES ($1, $2)',
    [rows[0].id, role],
  );
  const { token } = await app
    .get(AdminSessionsService)
    .start(db.db, rows[0].id, { ipAddress: '203.0.113.9', device: 'test' }, new Date());
  const cookies = { [ADMIN_SESSION_COOKIE]: token };
  return (method: 'GET' | 'POST' | 'PUT' | 'DELETE', url: string, payload?: object) =>
    app.inject({
      method,
      url: `/v1/admin/restaurants/${url}`,
      cookies,
      ...(payload ? { payload } : {}),
    });
}

async function cashierOf(restaurantId: string) {
  const phone = `+9639${randomInt(100_000_000).toString().padStart(8, '0')}`;
  await app
    .get(MerchantAccountsService)
    .addAccount(restaurantId, { role: 'cashier', name: 'cashier', phone }, change);
  const deviceId = randomUUID();
  await app.inject({ method: 'POST', url: '/v1/merchant/auth/code', payload: { phone, deviceId } });
  const code = app.get<DevelopmentCodeSender>(CODE_SENDER).lastCode(phone);
  const response = await app.inject({
    method: 'POST',
    url: '/v1/merchant/auth/sign-in',
    payload: { phone, deviceId, code },
  });
  const headers = { authorization: `Bearer ${response.json().accessToken}` };
  return (method: 'POST' | 'PUT', url: string, payload?: object) =>
    app.inject({
      method,
      url: `/v1/merchant/restaurant/${url}`,
      headers,
      ...(payload ? { payload } : {}),
    });
}

async function restaurant({ open = true } = {}) {
  const id = await merchants.createRestaurant(
    azaz,
    {
      nameAr: `مطعم ${randomUUID()}`,
      location: { latitude: 36.5866, longitude: 37.0463 },
      coverage: { kind: 'radius', radiusMetres: 3000 },
      minimumOrder: { amount: 10_000n, currency: 'TRY' },
      commissionBp: 1500,
      defaultPrepMin: 20,
    },
    change,
  );
  await merchants.setAccountStatus(id, 'active', change);
  if (open) await merchants.setWeeklySchedule(id, allWeek, change);
  return id;
}

const kinds = async (id: string) =>
  (
    await sql.query(
      'SELECT kind, payload FROM merchants.state_outbox WHERE restaurant_id = $1 ORDER BY id',
      [id],
    )
  ).rows;

function relay(): RestaurantStateRelay {
  const publisher = {
    enabled: true,
    broadcast: () => Promise.resolve(),
  } as unknown as RealtimePublisher;
  return new RestaurantStateRelay(
    app.get(DATABASE),
    app.get(RestaurantStatusService),
    publisher,
    app.get(PushQueue),
    app.get(NotificationTexts),
    app.get(AlertsService),
  );
}

describe('operations pause and resume (AP §9.6.5)', () => {
  it('pauses for 30 minutes with a reason and a message customers see, over the restaurant’s buttons', async () => {
    const id = await restaurant();
    const ops = await admin('OPS');
    const cashier = await cashierOf(id);
    const start = Date.now();
    const paused = await ops('POST', `${id}/status/pause`, {
      minutes: 30,
      until: null,
      message: 'نعود بعد صيانة الفرن',
      reason: 'عطل في الفرن',
    });
    expect(paused.statusCode).toBe(200);
    expect(paused.json()).toMatchObject({
      state: 'paused',
      pauseSource: 'ops',
      heldPauseSource: 'ops',
      pauseMessage: 'نعود بعد صيانة الفرن',
      pauseReason: 'عطل في الفرن',
      accountStatus: 'active',
    });
    const until = new Date(paused.json().stateUntil).getTime();
    expect(until).toBeGreaterThanOrEqual(start + 30 * 60_000 - 1000);
    expect(until).toBeLessThanOrEqual(Date.now() + 30 * 60_000);
    expect(await merchants.storefrontState(id)).toMatchObject({
      state: { state: 'paused', source: 'ops' },
      message: 'نعود بعد صيانة الفرن',
    });
    // S4: the restaurant cannot resume or pause over it.
    for (const url of ['status/resume', 'status/pause']) {
      const refused = await cashier('POST', url, { minutes: 15 });
      expect(refused.statusCode).toBe(409);
      expect(refused.json().error).toBe('paused_by_operations');
    }
    const audit = await sql.query(
      `SELECT action, reason, actor_type FROM audit.events WHERE target_id = $1 AND action = 'restaurant.pause'`,
      [id],
    );
    expect(audit.rows).toEqual([
      { action: 'restaurant.pause', reason: 'عطل في الفرن', actor_type: 'admin' },
    ]);
    expect((await kinds(id)).at(-1)).toEqual({
      kind: 'paused_by_operations',
      payload: { schema: 1, values: { reason: 'عطل في الفرن' } },
    });
    const jobs = await sql.query(
      `SELECT 1 FROM pgboss.job WHERE name = 'merchants-pause-end' AND data->>'restaurantId' = $1`,
      [id],
    );
    expect(jobs.rowCount).toBe(1);
    // A repeat (a retry after a lost answer) changes nothing.
    const again = await ops('POST', `${id}/status/pause`, {
      minutes: 30,
      until: null,
      message: 'نعود بعد صيانة الفرن',
      reason: 'عطل في الفرن',
    });
    expect(again.json().stateUntil).toBe(paused.json().stateUntil);
    expect(await kinds(id)).toHaveLength(2);

    const resumed = await ops('POST', `${id}/status/resume`);
    expect(resumed.statusCode).toBe(200);
    expect(resumed.json()).toMatchObject({
      state: 'open',
      pauseSource: null,
      heldPauseSource: null,
    });
    expect((await kinds(id)).at(-1)!.kind).toBe('resumed_by_operations');
    // Nothing to resume: nothing changes.
    expect((await ops('POST', `${id}/status/resume`)).statusCode).toBe(200);
    expect((await kinds(id)).at(-1)!.kind).toBe('resumed_by_operations');
    expect(await kinds(id)).toHaveLength(3);
  });

  it('replaces the restaurant’s pause, holds while closed, and pauses until a time', async () => {
    const id = await restaurant();
    const ops = await admin('OWN');
    const cashier = await cashierOf(id);
    await cashier('POST', 'status/pause', { minutes: 60 });
    const untilResumed = await ops('POST', `${id}/status/pause`, {
      minutes: null,
      until: null,
      message: null,
      reason: 'شكاوى',
    });
    expect(untilResumed.json()).toMatchObject({
      state: 'paused',
      pauseSource: 'ops',
      stateUntil: null,
      heldPauseSource: 'ops',
      heldPauseUntil: null,
      pauseMessage: null,
      pauseReason: 'شكاوى',
    });
    const { rows } = await sql.query(
      'SELECT source, ended_at IS NOT NULL AS ended, ended_by_type FROM merchants.pauses WHERE restaurant_id = $1 ORDER BY starts_at, source DESC',
      [id],
    );
    expect(rows).toEqual([
      { source: 'restaurant', ended: true, ended_by_type: 'admin' },
      { source: 'ops', ended: false, ended_by_type: null },
    ]);

    const closed = await restaurant({ open: false });
    const later = new Date(Date.now() + 5 * 3_600_000);
    const atTime = await ops('POST', `${closed}/status/pause`, {
      minutes: null,
      until: later.toISOString(),
      message: null,
      reason: 'تأخير',
    });
    expect(atTime.statusCode).toBe(200);
    // Closed by the schedule comes first (RA §7.1); the pause is kept, and
    // the panel sees it and can end it.
    expect(atTime.json()).toMatchObject({
      state: 'closed',
      heldPauseSource: 'ops',
      heldPauseUntil: later.toISOString(),
      pauseReason: 'تأخير',
    });
    const pause = await sql.query('SELECT ends_at FROM merchants.pauses WHERE restaurant_id = $1', [
      closed,
    ]);
    expect(new Date(pause.rows[0].ends_at).getTime()).toBe(later.getTime());
    const ended = await ops('POST', `${closed}/status/resume`);
    expect(ended.json()).toMatchObject({ state: 'closed', heldPauseSource: null });
  });

  it('ends a timed pause on its own, and refuses a terminated restaurant', async () => {
    const id = await restaurant();
    const ops = await admin('OPS');
    await ops('POST', `${id}/status/pause`, {
      minutes: 15,
      until: null,
      message: null,
      reason: 'x',
    });
    const [{ data }] = (
      await sql.query(
        `SELECT data FROM pgboss.job WHERE name = 'merchants-pause-end' AND data->>'restaurantId' = $1`,
        [id],
      )
    ).rows;
    const service = app.get(RestaurantStatusService);
    expect(await service.pauseEnded(data, new Date(Date.now() + 16 * 60_000))).toBe(true);
    expect((await kinds(id)).at(-1)).toEqual({
      kind: 'pause_ended',
      payload: { schema: 1, values: { push: true } },
    });

    await merchants.setAccountStatus(id, 'terminated', change);
    const refused = await ops('POST', `${id}/status/resume`);
    expect(refused.statusCode).toBe(403);
    expect(refused.json().error).toBe('restaurant_terminated');
  });

  it('pauses over an auto-pause, ending it and its alert, which a newer auto-pause keeps', async () => {
    const id = await restaurant();
    const ops = await admin('OPS');
    const alerts = app.get(AlertsService);
    const subject = { type: 'restaurant' as const, id, cityId: azaz };
    const raise = () =>
      db.db.transaction((tx) =>
        alerts.sync(
          tx,
          subject,
          ['restaurant_auto_paused'],
          ['restaurant_auto_paused'],
          new Date(),
        ),
      );
    const open = async () =>
      (
        await sql.query(
          `SELECT 1 FROM notifications.alerts WHERE subject_id = $1 AND resolved_at IS NULL`,
          [id],
        )
      ).rowCount;
    const autoPause = () =>
      sql.query(
        `INSERT INTO merchants.pauses (restaurant_id, source, starts_at) VALUES ($1, 'auto', now())`,
        [id],
      );
    await autoPause();
    await raise();
    await ops('POST', `${id}/status/pause`, {
      minutes: 30,
      until: null,
      message: null,
      reason: 'x',
    });
    expect((await kinds(id)).at(-1)).toEqual({
      kind: 'paused_by_operations',
      payload: { schema: 1, values: { reason: 'x', endedAuto: true } },
    });
    await relay().drain(new Date());
    expect(await open()).toBe(0);

    // Resumed, then auto-paused again before the resume is relayed: the new
    // alert stays open.
    await ops('POST', `${id}/status/resume`);
    await autoPause();
    await raise();
    await relay().drain(new Date());
    expect(await open()).toBe(1);
  });

  it('refuses a pause without a reason or off the choices, and anyone without restaurants.manage', async () => {
    const id = await restaurant();
    const ops = await admin('OPS');
    for (const body of [
      { minutes: 15, until: null, message: null, reason: ' ' },
      { minutes: 20, until: null, message: null, reason: 'x' },
      {
        minutes: null,
        until: new Date(Date.now() - 60_000).toISOString(),
        message: null,
        reason: 'x',
      },
    ]) {
      const refused = await ops('POST', `${id}/status/pause`, body);
      expect(refused.statusCode).toBe(400);
    }
    const support = await admin('SUP');
    expect((await support('GET', `${id}/status`)).statusCode).toBe(200);
    const forbidden = await support('POST', `${id}/status/pause`, {
      minutes: 15,
      until: null,
      message: null,
      reason: 'x',
    });
    expect(forbidden.statusCode).toBe(403);
    expect((await ops('GET', `${randomUUID()}/status`)).statusCode).toBe(404);
  });

  it('resumes an auto-pause, its alert resolving as soon as the change is relayed', async () => {
    const id = await restaurant();
    const ops = await admin('OPS');
    await sql.query(
      `INSERT INTO merchants.pauses (restaurant_id, source, starts_at) VALUES ($1, 'auto', now())`,
      [id],
    );
    const alerts = app.get(AlertsService);
    const subject = { type: 'restaurant' as const, id, cityId: azaz };
    await db.db.transaction((tx) =>
      alerts.sync(tx, subject, ['restaurant_auto_paused'], ['restaurant_auto_paused'], new Date()),
    );
    const open = async () =>
      (
        await sql.query(
          `SELECT 1 FROM notifications.alerts WHERE subject_id = $1 AND resolved_at IS NULL`,
          [id],
        )
      ).rowCount;
    expect(await open()).toBe(1);
    const resumed = await ops('POST', `${id}/status/resume`);
    expect(resumed.json()).toMatchObject({ state: 'open' });
    expect((await kinds(id)).at(-1)).toEqual({
      kind: 'resumed_by_operations',
      payload: { schema: 1, values: { endedAuto: true } },
    });
    await relay().drain(new Date());
    expect(await open()).toBe(0);
    const pushes = await sql.query(
      `SELECT template_key, body FROM notifications.push_messages WHERE restaurant_id = $1`,
      [id],
    );
    expect(pushes.rows).toEqual([
      { template_key: 'merchant.resumed_by_operations', body: 'أعادت العمليات تشغيل مطعمك' },
    ]);
  });
});

describe('busy mode, holiday close and the maximum (AP §9.6.5)', () => {
  it('ends the restaurant’s busy mode and tells it', async () => {
    const id = await restaurant();
    const ops = await admin('OPS');
    const cashier = await cashierOf(id);
    await cashier('PUT', 'status/busy-mode', { extraMin: 20 });
    const ended = await ops('DELETE', `${id}/status/busy-mode`);
    expect(ended.statusCode).toBe(200);
    expect(ended.json()).toMatchObject({ state: 'open', busyMode: null });
    expect((await kinds(id)).at(-1)!.kind).toBe('busy_ended_by_operations');
    await relay().drain(new Date());
    const pushes = await sql.query(
      `SELECT body FROM notifications.push_messages WHERE restaurant_id = $1`,
      [id],
    );
    expect(pushes.rows).toEqual([{ body: 'أنهت العمليات وضع الضغط' }]);
    // Off already: nothing to tell.
    const rows = (await kinds(id)).length;
    expect((await ops('DELETE', `${id}/status/busy-mode`)).statusCode).toBe(200);
    expect(await kinds(id)).toHaveLength(rows);
  });

  it('closes for a holiday with a message and a reason, then ends it', async () => {
    const id = await restaurant();
    const ops = await admin('OPS');
    const endsAt = new Date(Date.now() + 3 * 86_400_000).toISOString();
    const missing = await ops('PUT', `${id}/holiday-close`, {
      startsAt: null,
      endsAt,
      message: 'عطلة العيد',
      reason: '',
    });
    expect(missing.statusCode).toBe(400);
    const closed = await ops('PUT', `${id}/holiday-close`, {
      startsAt: null,
      endsAt,
      message: 'عطلة العيد',
      reason: 'طلب المالك',
    });
    expect(closed.statusCode).toBe(200);
    expect(closed.json()).toMatchObject({
      state: 'holiday',
      holiday: { endsAt, message: 'عطلة العيد' },
    });
    const stored = await sql.query(
      'SELECT reason, set_by_type FROM merchants.holiday_closes WHERE restaurant_id = $1',
      [id],
    );
    expect(stored.rows).toEqual([{ reason: 'طلب المالك', set_by_type: 'admin' }]);
    const emoji = await ops('PUT', `${id}/holiday-close`, {
      startsAt: null,
      endsAt,
      message: '🌙'.repeat(100),
      reason: 'طلب المالك',
    });
    expect(emoji.statusCode).toBe(200);
    const reopened = await ops('DELETE', `${id}/holiday-close`);
    expect(reopened.json()).toMatchObject({ state: 'open', holiday: null });
    await merchants.setAccountStatus(id, 'suspended', change);
    const suspended = await ops('PUT', `${id}/holiday-close`, {
      startsAt: null,
      endsAt,
      message: null,
      reason: 'x',
    });
    expect(suspended.statusCode).toBe(409);
  });

  it('sets the maximum active orders on the restaurant’s request, keeping its prep time', async () => {
    const id = await restaurant();
    const ops = await admin('OPS');
    const set = await ops('PUT', `${id}/max-active-orders`, { maxActiveOrders: 5 });
    expect(set.json()).toMatchObject({ maxActiveOrders: 5, activeOrders: 0 });
    expect((await merchants.restaurant(id))!.defaultPrepMin).toBe(20);
    expect((await ops('PUT', `${id}/max-active-orders`, { maxActiveOrders: 51 })).statusCode).toBe(
      400,
    );
    const off = await ops('PUT', `${id}/max-active-orders`, { maxActiveOrders: null });
    expect(off.json()).toMatchObject({ maxActiveOrders: null });
  });
});
