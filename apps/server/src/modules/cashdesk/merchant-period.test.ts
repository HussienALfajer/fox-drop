import 'reflect-metadata';
import { randomBytes, randomUUID } from 'node:crypto';
import type { NestFastifyApplication } from '@nestjs/platform-fastify';
import pg from 'pg';
import { afterAll, beforeAll, describe, expect, it, vi } from 'vitest';
import { ApiModule } from '../../api.module.js';
import { createDatabase, type Database } from '../../database/database.js';
import { startTestDatabase, type TestDatabase } from '../../database/test-database.js';
import { createApiApp } from '../../http/create-api-app.js';
import { startTestValkey, type TestValkey } from '../../valkey/test-valkey.js';
import { FxService } from '../fx/index.js';
import { ADMIN_SESSION_COOKIE, AdminSessionsService } from '../identity/index.js';
import { type AccountPurpose, type JournalType, LedgerService } from '../ledger/index.js';
import { MerchantsService } from '../merchants/index.js';
import { SettingsService } from '../settings/index.js';
import {
  CashDeskService,
  type DeskUser,
  MerchantPeriodService,
  MerchantSettlementService,
} from './index.js';

// «كشوف المطاعم» (AP §9.10.5, slice 2.19g): a restaurant's statement for any
// period, from its opening balance through the orders, exceptions and
// settlements with their receipts to its closing balance.
vi.setConfig({ testTimeout: 30_000 });

let database: TestDatabase;
let cache: TestValkey;
let app: NestFastifyApplication;
let sql: pg.Pool;
let db: Database;
let azaz: string;
let periods: MerchantPeriodService;
let ledger: LedgerService;
let merchants: MerchantsService;
let desk: CashDeskService;
let settlements: MerchantSettlementService;

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
  azaz = (await sql.query("SELECT id FROM geo.cities WHERE code = 'AZ'")).rows[0].id;
  const fx = app.get(FxService);
  await fx.setCityCurrency(azaz, { currency: 'TRY', displayOrder: 1, enabled: true }, change);
  await fx.setBaseCurrency(azaz, 'TRY', change);
  await app
    .get(SettingsService)
    .update(
      'currency.<code>.rounding_unit',
      { cityId: azaz, parameter: 'TRY' },
      { amountMinor: 100 },
      { editor: 'system', context: change.context, reason: 'test' },
    );
  periods = app.get(MerchantPeriodService);
  ledger = app.get(LedgerService);
  merchants = app.get(MerchantsService);
  desk = app.get(CashDeskService);
  settlements = app.get(MerchantSettlementService);
}, 300_000);

afterAll(async () => {
  await app?.close();
  await db?.pool.end();
  await sql?.end();
  await Promise.all([database?.stop(), cache?.stop()]);
});

let accounts = 0;
async function admin(roles: string[]) {
  accounts += 1;
  const { rows } = await sql.query(
    `INSERT INTO identity.admin_accounts (name, email, status, password_hash, totp_secret_encrypted)
     VALUES ($1, $2, 'active', 'not used', 'not used') RETURNING id`,
    [`Period ${accounts}`, `period${accounts}@example.test`],
  );
  const accountId: string = rows[0].id;
  for (const role of roles) {
    await sql.query(
      'INSERT INTO identity.admin_account_roles (account_id, role_code) VALUES ($1, $2)',
      [accountId, role],
    );
  }
  const { token } = await app
    .get(AdminSessionsService)
    .start(db.db, accountId, { ipAddress: '203.0.113.9', device: 'test' }, new Date());
  const user: DeskUser = {
    accountId,
    roles,
    actor: { type: 'admin', id: accountId, role: roles.join(',') },
    context: { ipAddress: '203.0.113.9', device: 'test' },
  };
  return {
    user,
    get: (url: string) =>
      app.inject({ method: 'GET', url, cookies: { [ADMIN_SESSION_COOKIE]: token } }),
  };
}

async function restaurant() {
  const id = await merchants.createRestaurant(
    azaz,
    {
      nameAr: `مطعم الكشف ${randomUUID()}`,
      location: { latitude: 36.5866, longitude: 37.0463 },
      coverage: { kind: 'radius', radiusMetres: 3000 },
      minimumOrder: { amount: 10_000n, currency: 'TRY' },
      commissionBp: 1500,
      defaultPrepMin: 20,
    },
    change,
  );
  await merchants.setAccountStatus(id, 'active', change);
  return id;
}

// One journal of an order on the restaurant's account: + the restaurant owes.
async function post(
  restaurantId: string,
  type: JournalType,
  owes: bigint,
  { orderId = randomUUID(), reason = null }: { orderId?: string; reason?: string | null } = {},
) {
  const counter: AccountPurpose =
    type === 'merchant.commission' ? 'platform.revenue_commission' : 'platform.order_clearing';
  await db.db.transaction(async (tx) => {
    const own = await ledger.openAccount(
      { cityId: azaz, purpose: 'merchant.account', ownerId: restaurantId, currency: 'TRY' },
      tx,
    );
    const other = await ledger.openAccount(
      { cityId: azaz, purpose: counter, ownerId: null, currency: 'TRY' },
      tx,
    );
    await ledger.post(
      {
        cityId: azaz,
        type,
        source: { kind: 'order', id: orderId },
        actor: { type: 'system', id: null },
        reason,
        entries: [
          { accountId: own, currency: 'TRY', amount: owes },
          { accountId: other, currency: 'TRY', amount: -owes },
        ],
      },
      tx,
    );
  });
}

// The restaurant pays at the office, as the screen confirms it.
async function pay(user: DeskUser, restaurantId: string, amount: bigint) {
  const preview = await settlements.preview(restaurantId, [{ currency: 'TRY', amount }]);
  return settlements.settle(
    user,
    {
      session: 'office',
      visitorId: null,
      restaurantId,
      due: preview.due,
      lines: preview.lines.map(({ currency, amount: each, base, rates }) => ({
        currency,
        amount: each,
        base,
        rates,
      })),
      idempotencyKey: randomUUID(),
    },
    new Date(),
  );
}

// A moment between two transactions, by the database's clock.
async function databaseNow(): Promise<Date> {
  await sql.query('SELECT pg_sleep(0.002)');
  const { rows } = await sql.query<{ now: Date }>('SELECT clock_timestamp() AS now');
  await sql.query('SELECT pg_sleep(0.002)');
  return rows[0]!.now;
}

const dayOffset = (days: number) =>
  new Date(Date.now() + days * 86_400_000).toISOString().slice(0, 10);

describe('a restaurant statement for a period', () => {
  it('runs from the opening balance to the closing one, receipts on the payments', async () => {
    const id = await restaurant();
    const cashier = await admin(['FIN']);
    await desk.openSession(cashier.user, azaz, [{ currency: 'TRY', amount: 0n }], new Date());
    await post(id, 'merchant.commission', 1_000n);
    const from = await databaseNow();
    const order = randomUUID();
    await post(id, 'merchant.commission', 2_000n, { orderId: order });
    await post(id, 'merchant.discount_share', 300n, { orderId: order });
    await post(id, 'merchant.credit', -500n, { reason: 'food_credit' });
    const receipt = await pay(cashier.user, id, 1_500n);
    const to = await databaseNow();
    await post(id, 'merchant.commission', 700n);

    const statement = await periods.between(id, from, to);
    expect(statement).toMatchObject({
      restaurantId: id,
      currency: 'TRY',
      opening: 1_000n,
      orders: 1,
      commission: 2_000n,
      discountShare: 300n,
      exceptions: -500n,
      paid: 1_500n,
      closing: 1_300n,
    });
    expect(statement.lines.map((line) => line.kind)).toEqual(['order', 'exception', 'payment']);
    expect(statement.lines[0]).toMatchObject({
      orderId: order,
      commission: 2_000n,
      discountShare: 300n,
      receipt: null,
    });
    expect(statement.lines[1]).toMatchObject({ amount: -500n, reason: 'food_credit' });
    expect(statement.lines[2]).toMatchObject({
      amount: -1_500n,
      receipt: { id: receipt.id, number: receipt.number },
    });

    // The closing is the balance at the end; the next period opens on it.
    const next = await periods.between(id, to, await databaseNow());
    expect(next).toMatchObject({ opening: 1_300n, commission: 700n, closing: 2_000n });
  });

  it('takes business days, and refuses a period that is not one', async () => {
    const id = await restaurant();
    await post(id, 'merchant.commission', 900n);
    const statement = await periods.statement(id, dayOffset(-2), dayOffset(1));
    expect(statement).toMatchObject({
      fromDay: dayOffset(-2),
      toDay: dayOffset(1),
      opening: 0n,
      closing: 900n,
    });

    expect(await periods.statement(id, dayOffset(0), dayOffset(-1))).toBe('invalid_period');
    expect(await periods.statement(id, '2026-02-30', '2026-03-02')).toBe('invalid_period');
    expect(await periods.statement(id, '2025-01-01', '2026-01-02')).toBe('invalid_period');
    expect(await periods.statement(id, '2025-01-01', '2026-01-01')).not.toBe('invalid_period');
    expect(await periods.statement(randomUUID(), dayOffset(0), dayOffset(0))).toBeNull();
  });

  it('answers a restaurant without entries with zeros', async () => {
    const id = await restaurant();
    expect(await periods.statement(id, dayOffset(0), dayOffset(0))).toMatchObject({
      opening: 0n,
      closing: 0n,
      lines: [],
    });
  });
});

describe('the routes of «كشوف المطاعم»', () => {
  it('answers the restaurants and a statement to FIN, money as strings', async () => {
    const id = await restaurant();
    await post(id, 'merchant.commission', 2_500n);
    const { get } = await admin(['FIN']);

    const list = await get(`/v1/admin/restaurant-statements/restaurants?cityId=${azaz}`);
    expect(list.statusCode).toBe(200);
    expect(list.json().restaurants).toContainEqual({ id, name: expect.any(String) });

    const url = `/v1/admin/restaurant-statements?restaurantId=${id}&from=${dayOffset(-1)}&to=${dayOffset(1)}`;
    const statement = await get(url);
    expect(statement.statusCode).toBe(200);
    expect(statement.json()).toMatchObject({
      restaurantId: id,
      opening: '0',
      commission: '2500',
      closing: '2500',
    });
    expect(statement.json().lines[0]).toMatchObject({ kind: 'order', commission: '2500' });

    const backwards = await get(
      `/v1/admin/restaurant-statements?restaurantId=${id}&from=${dayOffset(1)}&to=${dayOffset(0)}`,
    );
    expect(backwards.statusCode).toBe(400);
    expect(backwards.json()).toMatchObject({ error: 'invalid_period' });
    const unknown = await get(
      `/v1/admin/restaurant-statements?restaurantId=${randomUUID()}&from=${dayOffset(0)}&to=${dayOffset(0)}`,
    );
    expect(unknown.statusCode).toBe(404);
    expect(unknown.json()).toMatchObject({ error: 'unknown_restaurant' });
  });

  it('refuses a user without the statements', async () => {
    const { get } = await admin(['OPS']);
    expect(
      (await get(`/v1/admin/restaurant-statements/restaurants?cityId=${azaz}`)).statusCode,
    ).toBe(403);
  });
});
