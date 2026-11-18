import 'reflect-metadata';
import { randomBytes, randomUUID } from 'node:crypto';
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
import { GeoService } from '../geo/index.js';
import { ADMIN_SESSION_COOKIE, AdminSessionsService } from '../identity/index.js';
import { LedgerService } from '../ledger/index.js';
import {
  AlertsService,
  PushQueue,
  type RealtimePublisher,
  RestaurantStateRelay,
} from '../notifications/index.js';
import { MerchantsService, RestaurantStatusService } from './index.js';

// The panel's actions on a restaurant's account (AP §9.6.5, slice 2.30c):
// suspend and reactivate with a reason and the restaurant's chime (RA §16
// #23), hide and show, the sort weight, the commission change by OWN for new
// orders with the owners' push (D16, RA §16 #33), and the termination by
// OWN at a zero balance.
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
    [`Operator ${accounts}`, `account${accounts}@example.test`],
  );
  await sql.query(
    'INSERT INTO identity.admin_account_roles (account_id, role_code) VALUES ($1, $2)',
    [rows[0].id, role],
  );
  const { token } = await app
    .get(AdminSessionsService)
    .start(db.db, rows[0].id, { ipAddress: '203.0.113.9', device: 'test' }, new Date());
  const cookies = { [ADMIN_SESSION_COOKIE]: token };
  return (method: 'GET' | 'POST' | 'PUT', url: string, payload?: object) =>
    app.inject({
      method,
      url: `/v1/admin/restaurants/${url}`,
      cookies,
      ...(payload ? { payload } : {}),
    });
}

async function restaurant(status: 'active' | 'test' = 'active') {
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
  await merchants.setAccountStatus(id, status, change);
  return id;
}

const kinds = async (id: string) =>
  (
    await sql.query(
      'SELECT kind, payload FROM merchants.state_outbox WHERE restaurant_id = $1 ORDER BY id',
      [id],
    )
  ).rows;

const published: { channels: string[]; payload: Record<string, unknown> }[] = [];

function relay(): RestaurantStateRelay {
  const publisher = {
    enabled: true,
    broadcast: (channels: string[], payload: Record<string, unknown>) => {
      published.push({ channels, payload });
      return Promise.resolve();
    },
  } as unknown as RealtimePublisher;
  return new RestaurantStateRelay(
    app.get(DATABASE),
    app.get(RestaurantStatusService),
    publisher,
    app.get(PushQueue),
    app.get(NotificationTexts),
    app.get(AlertsService),
    app.get(GeoService),
  );
}

const pushes = async (id: string) =>
  (
    await sql.query(
      `SELECT template_key, body, owners_only FROM notifications.push_messages
       WHERE restaurant_id = $1 ORDER BY id`,
      [id],
    )
  ).rows;

// What the restaurant owes (+) on its account, posted as one order journal.
async function owes(restaurantId: string, amount: bigint) {
  const ledger = app.get(LedgerService);
  await db.db.transaction(async (tx) => {
    const own = await ledger.openAccount(
      { cityId: azaz, purpose: 'merchant.account', ownerId: restaurantId, currency: 'TRY' },
      tx,
    );
    const other = await ledger.openAccount(
      { cityId: azaz, purpose: 'platform.order_clearing', ownerId: null, currency: 'TRY' },
      tx,
    );
    await ledger.post(
      {
        cityId: azaz,
        type: amount > 0n ? 'merchant.debit' : 'merchant.credit',
        source: { kind: 'order', id: randomUUID() },
        actor: { type: 'system', id: null },
        entries: [
          { accountId: own, currency: 'TRY', amount: -amount },
          { accountId: other, currency: 'TRY', amount },
        ],
      },
      tx,
    );
  });
}

describe('suspend and reactivate (AP §9.6.5, RA §16 #23)', () => {
  it('suspends with a reason the restaurant hears, and reactivates with one', async () => {
    const id = await restaurant();
    const ops = await admin('OPS');
    expect((await ops('POST', `${id}/suspend`, { reason: ' ' })).statusCode).toBe(400);
    const suspended = await ops('POST', `${id}/suspend`, { reason: 'مخالفة الأسعار' });
    expect(suspended.statusCode).toBe(200);
    expect(suspended.json()).toMatchObject({
      accountStatus: 'suspended',
      suspensionReason: 'مخالفة الأسعار',
    });
    // Suspended again changes nothing.
    expect((await ops('POST', `${id}/suspend`, { reason: 'again' })).statusCode).toBe(200);
    expect(
      await merchants.coveringRestaurants(azaz, { latitude: 36.5866, longitude: 37.0463 }),
    ).not.toContain(id);
    const reactivated = await ops('POST', `${id}/reactivate`, { reason: 'صحّح الأسعار' });
    expect(reactivated.json()).toMatchObject({ accountStatus: 'active', suspensionReason: null });
    expect((await kinds(id)).map((row) => row.kind)).toEqual([
      'suspended_by_operations',
      'reactivated_by_operations',
    ]);
    await relay().drain(new Date());
    expect((await pushes(id)).map((row) => [row.template_key, row.body, row.owners_only])).toEqual([
      ['merchant.suspended_by_operations', 'علّقت العمليات حساب مطعمك: مخالفة الأسعار', false],
      ['merchant.reactivated_by_operations', 'أعادت العمليات تفعيل حساب مطعمك', false],
    ]);
    const audit = await sql.query(
      `SELECT reason FROM audit.events WHERE target_id = $1 AND action = 'restaurant.status' ORDER BY occurred_at`,
      [id],
    );
    expect(audit.rows.slice(-2)).toEqual([
      { reason: 'مخالفة الأسعار' },
      { reason: 'صحّح الأسعار' },
    ]);
  });

  it('never reactivates a restaurant in test mode past its checklist', async () => {
    const id = await restaurant('test');
    const own = await admin('OWN');
    const refused = await own('POST', `${id}/reactivate`, { reason: 'go' });
    expect(refused.statusCode).toBe(409);
    expect(refused.json().error).toBe('status_change_not_allowed');
    expect((await own('POST', `${id}/suspend`, { reason: 'x' })).statusCode).toBe(409);
  });

  it('keeps the actions from roles without restaurants.manage', async () => {
    const id = await restaurant();
    for (const role of ['FIN', 'SUP', 'DATA']) {
      const user = await admin(role);
      expect((await user('POST', `${id}/suspend`, { reason: 'x' })).statusCode).toBe(403);
      expect((await user('PUT', `${id}/visibility`, { visible: false })).statusCode).toBe(403);
    }
  });
});

describe('hide, show and the sort weight (AP §9.6.5)', () => {
  it('sets each one and answers the account', async () => {
    const id = await restaurant();
    const ops = await admin('OPS');
    const hidden = await ops('PUT', `${id}/visibility`, { visible: false });
    expect(hidden.json()).toMatchObject({ visible: false, accountStatus: 'active' });
    const weighted = await ops('PUT', `${id}/sort-weight`, { sortWeight: 50 });
    expect(weighted.json()).toMatchObject({ sortWeight: 50, sortWeightMax: 1000 });
    const refused = await ops('PUT', `${id}/sort-weight`, { sortWeight: 5000 });
    expect(refused.statusCode).toBe(400);
    expect(refused.json().error).toBe('invalid_sort_weight');
    expect((await ops('GET', `${id}/account`)).json()).toMatchObject({
      visible: false,
      sortWeight: 50,
    });
    expect((await ops('GET', `${randomUUID()}/account`)).statusCode).toBe(404);
  });
});

describe('the commission change (AP §9.6.5, D16, RA §16 #33)', () => {
  it('schedules a rate for new orders, tells the owners, and keeps a repeat once', async () => {
    const id = await restaurant();
    const own = await admin('OWN');
    const from = new Date(Date.now() + 2 * 86_400_000);
    const body = { rateBp: 1250, effectiveFrom: from.toISOString(), reason: 'اتفاق جديد' };
    const scheduled = await own('POST', `${id}/commission`, body);
    expect(scheduled.statusCode).toBe(200);
    expect(scheduled.json()).toMatchObject({
      commissionBp: 1500,
      nextCommission: { rateBp: 1250, from: from.toISOString() },
    });
    expect(
      scheduled.json().commissionHistory.map((each: { rateBp: number }) => each.rateBp),
    ).toEqual([1250, 1500]);
    expect(scheduled.json().commissionHistory[0]).toMatchObject({
      reason: 'اتفاق جديد',
      byAdmin: true,
    });
    // A retry adds no version and no push.
    await own('POST', `${id}/commission`, body);
    expect((await merchants.commissionVersions(id)).length).toBe(2);
    await relay().drain(new Date());
    const day = new Intl.DateTimeFormat('en-GB', {
      timeZone: 'Asia/Damascus',
      day: '2-digit',
      month: '2-digit',
      year: 'numeric',
    }).format(from);
    expect(await pushes(id)).toEqual([
      {
        template_key: 'merchant.commission_change',
        body: `تتغيّر عمولتك إلى 12.5% اعتباراً من ${day}`,
        owners_only: true,
      },
    ]);
    // RA §16 #33, R10: the rate is the owners'; the channel every device
    // hears carries none.
    const told = published.filter((each) => each.payload.restaurantId === id);
    expect(told.map((each) => each.payload.values)).toEqual([{}]);
    // The same rate «now» after a version scheduled for later is a change.
    const sameNow = await own('POST', `${id}/commission`, {
      rateBp: 1250,
      effectiveFrom: null,
      reason: 'الآن بالنسبة نفسها',
    });
    expect(sameNow.json()).toMatchObject({ commissionBp: 1250 });
    const now = await own('POST', `${id}/commission`, {
      rateBp: 1400,
      effectiveFrom: null,
      reason: 'الآن',
    });
    expect(now.json()).toMatchObject({ commissionBp: 1400 });
    const past = await own('POST', `${id}/commission`, {
      rateBp: 1000,
      effectiveFrom: new Date(Date.now() - 3_600_000).toISOString(),
      reason: 'backdated',
    });
    expect(past.statusCode).toBe(400);
    expect(past.json().error).toBe('invalid_commission');
  });

  it('is OWN’s alone', async () => {
    const id = await restaurant();
    const ops = await admin('OPS');
    const refused = await ops('POST', `${id}/commission`, {
      rateBp: 1000,
      effectiveFrom: null,
      reason: 'x',
    });
    expect(refused.statusCode).toBe(403);
  });
});

describe('the termination (AP §9.6.5)', () => {
  it('waits for a zero balance, then ends the contract', async () => {
    const id = await restaurant();
    const own = await admin('OWN');
    await owes(id, 3_600n);
    const refused = await own('POST', `${id}/terminate`, { reason: 'انتهى العقد' });
    expect(refused.statusCode).toBe(409);
    expect(refused.json().error).toBe('balance_not_zero');
    await owes(id, -3_600n);
    const terminated = await own('POST', `${id}/terminate`, { reason: 'انتهى العقد' });
    expect(terminated.statusCode).toBe(200);
    expect(terminated.json()).toEqual({ restaurantId: id, accountStatus: 'terminated' });
    expect((await own('POST', `${id}/terminate`, { reason: 'again' })).statusCode).toBe(200);
    expect((await own('GET', `${id}/account`)).json().accountStatus).toBe('terminated');
    expect((await kinds(id)).map((row) => row.kind)).toEqual(['terminated']);
    expect((await own('PUT', `${id}/visibility`, { visible: false })).statusCode).toBe(403);
    expect((await own('POST', `${randomUUID()}/terminate`, { reason: 'x' })).statusCode).toBe(404);
  });

  it('is OWN’s alone', async () => {
    const id = await restaurant();
    const ops = await admin('OPS');
    expect((await ops('POST', `${id}/terminate`, { reason: 'x' })).statusCode).toBe(403);
  });

  it('never terminates a draft', async () => {
    const id = await merchants.createRestaurant(
      azaz,
      {
        nameAr: `مسودة ${randomUUID()}`,
        location: { latitude: 36.5866, longitude: 37.0463 },
        coverage: { kind: 'radius', radiusMetres: 3000 },
        minimumOrder: { amount: 10_000n, currency: 'TRY' },
        commissionBp: 1500,
        defaultPrepMin: 20,
      },
      change,
    );
    const own = await admin('OWN');
    const refused = await own('POST', `${id}/terminate`, { reason: 'x' });
    expect(refused.statusCode).toBe(409);
    expect(refused.json().error).toBe('status_change_not_allowed');
  });
});
