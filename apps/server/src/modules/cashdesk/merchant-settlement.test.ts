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
  CashDeskRefusedError,
  CashDeskService,
  type DeskUser,
  type MerchantSettleCommand,
  MerchantSettlementService,
  MerchantStatementsService,
} from './index.js';

// «تسوية المطاعم» at the office (AP §8.7, §9.10.3 tab 3, RA §12.4, §16 #31;
// slice 2.19b): the restaurant pays what it owes, in part or in full, in any
// accepted currency at the current rate (merchant.settlement against the
// drawer), or the desk pays a restaurant the platform owes; one numbered
// receipt per confirmation, the owners' push, the key.
vi.setConfig({ testTimeout: 30_000 });

let database: TestDatabase;
let cache: TestValkey;
let app: NestFastifyApplication;
let sql: pg.Pool;
let db: Database;
let azaz: string;
let desk: CashDeskService;
let settlements: MerchantSettlementService;
let ledger: LedgerService;
let merchants: MerchantsService;

const system = { type: 'system', id: null, role: null } as const;
const change = { actor: system, context: { ipAddress: null, device: null }, reason: 'test' };
const bySystem = { editor: 'system', context: change.context, reason: 'test' } as const;

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
  await fx.setCityCurrency(azaz, { currency: 'USD', displayOrder: 2, enabled: false }, change);
  await fx.setRate(
    azaz,
    'USD',
    { value: '40', direction: 'base_per_unit' },
    { ...change, actor: { type: 'admin', id: randomUUID(), role: 'FIN' } },
  );
  await fx.setCityCurrency(azaz, { currency: 'USD', displayOrder: 2, enabled: true }, change);
  const settings = app.get(SettingsService);
  for (const [code, unit] of [
    ['TRY', 100],
    ['USD', 50],
  ] as const) {
    await settings.update(
      'currency.<code>.rounding_unit',
      { cityId: azaz, parameter: code },
      { amountMinor: unit },
      bySystem,
    );
  }
  desk = app.get(CashDeskService);
  settlements = app.get(MerchantSettlementService);
  ledger = app.get(LedgerService);
  merchants = app.get(MerchantsService);
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
    [`Restaurant desk ${accounts}`, `restaurant-desk${accounts}@example.test`],
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
  const cookies = { [ADMIN_SESSION_COOKIE]: token };
  const user: DeskUser = {
    accountId,
    roles,
    actor: { type: 'admin', id: accountId, role: roles.join(',') },
    context: { ipAddress: '203.0.113.9', device: 'test' },
  };
  return {
    user,
    get: (url: string) => app.inject({ method: 'GET', url, cookies }),
    post: (url: string, payload: object, key: string | null = randomUUID()) =>
      app.inject({
        method: 'POST',
        url,
        cookies,
        headers: key === null ? {} : { 'idempotency-key': key },
        payload,
      }),
  };
}

async function openDesk(floats = [{ currency: 'TRY', amount: 100_000n }]) {
  const cashier = await admin(['FIN']);
  const session = await desk.openSession(cashier.user, azaz, floats, new Date());
  return { cashier, session };
}

async function restaurant() {
  const id = await merchants.createRestaurant(
    azaz,
    {
      nameAr: `مطعم التسوية ${randomUUID()}`,
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
async function owes(restaurantId: string, amount: bigint) {
  const type: JournalType = amount > 0n ? 'merchant.commission' : 'merchant.credit';
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
        source: { kind: 'order', id: randomUUID() },
        actor: { type: 'system', id: null },
        entries: [
          { accountId: own, currency: 'TRY', amount },
          { accountId: other, currency: 'TRY', amount: -amount },
        ],
      },
      tx,
    );
  });
}

// What the restaurant owes now (+), from its account.
async function due(restaurantId: string): Promise<bigint> {
  const [account] = await ledger.ownerAccounts(azaz, restaurantId, 'merchant.account');
  return account ? -(await ledger.balance(account.id)).amount : 0n;
}

// The screen's quote, confirmed as shown.
async function settle(
  user: DeskUser,
  restaurantId: string,
  lines: { currency: string; amount: bigint }[],
  key = randomUUID(),
) {
  const preview = await settlements.preview(restaurantId, lines);
  const command: MerchantSettleCommand = {
    restaurantId,
    due: preview.due,
    lines: preview.lines.map(({ currency, amount, base, rates }) => ({
      currency,
      amount,
      base,
      rates,
    })),
    idempotencyKey: key,
  };
  return settlements.settle(user, command, new Date());
}

async function refusal(promise: Promise<unknown>): Promise<string> {
  try {
    await promise;
  } catch (error) {
    if (error instanceof CashDeskRefusedError) return error.refusal;
    throw error;
  }
  throw new Error('not refused');
}

async function receiptPushes(restaurantId: string) {
  return (
    await sql.query(
      "SELECT body, owners_only, data FROM notifications.push_messages WHERE restaurant_id = $1 AND template_key = 'merchant.settlement_receipt'",
      [restaurantId],
    )
  ).rows;
}

describe('the restaurant settlement at the office', () => {
  it('records a partial payment, leaves the rest due and tells the owners', async () => {
    const { cashier, session } = await openDesk();
    const id = await restaurant();
    await owes(id, 46_000n);

    const preview = await settlements.preview(id, [{ currency: 'TRY', amount: 20_000n }]);
    expect(preview).toMatchObject({
      currency: 'TRY',
      due: 46_000n,
      total: 20_000n,
      remaining: 26_000n,
    });
    const key = randomUUID();
    const receipt = await settle(cashier.user, id, [{ currency: 'TRY', amount: 20_000n }], key);

    expect(receipt).toMatchObject({
      type: 'merchant_settlement',
      restaurantId: id,
      sessionId: session.id,
      method: 'office',
      currency: 'TRY',
      dueBefore: 46_000n,
      total: 20_000n,
      dueAfter: 26_000n,
      lines: [{ currency: 'TRY', amount: 20_000n, base: 20_000n }],
    });
    expect(receipt.number).toMatch(/^AZ-\d{4}-\d{6}$/);
    expect(await due(id)).toBe(26_000n);
    expect((await desk.session(session.id))?.currencies[0]).toMatchObject({
      currency: 'TRY',
      expected: 120_000n,
    });
    expect(await receiptPushes(id)).toEqual([
      {
        body: `إيصال ${receipt.number}: استلمنا منك 200 ₺`,
        owners_only: true,
        data: { target: 'receipt', receiptId: receipt.id },
      },
    ]);

    // The same key answers the same receipt, and posts nothing again.
    const again = await settlements.settle(
      cashier.user,
      {
        restaurantId: id,
        due: 46_000n,
        lines: [{ currency: 'TRY', amount: 20_000n, base: 20_000n, rates: [] }],
        idempotencyKey: key,
      },
      new Date(),
    );
    expect(again.id).toBe(receipt.id);
    expect(await due(id)).toBe(26_000n);
  });

  it('turns the statement partly paid, then paid, the oldest first', async () => {
    const { cashier } = await openDesk();
    const statements = app.get(MerchantStatementsService);
    const id = await restaurant();
    await owes(id, 46_000n);
    const { rows } = await sql.query<{ now: Date }>('SELECT clock_timestamp() AS now');
    await statements.closeAt(azaz, rows[0]!.now, rows[0]!.now, { notify: false });
    const statementOf = async () => {
      const row = (await statements.restaurants(azaz, new Date())).restaurants.find(
        (each) => each.restaurantId === id,
      );
      return statements.statement(row!.latest!.id);
    };
    expect(await statementOf()).toMatchObject({ status: 'unpaid', unpaid: 46_000n });

    await settle(cashier.user, id, [{ currency: 'TRY', amount: 20_000n }]);
    expect(await statementOf()).toMatchObject({ status: 'partly_paid', unpaid: 26_000n });

    await settle(cashier.user, id, [{ currency: 'TRY', amount: 26_000n }]);
    const list = await statements.restaurants(azaz, new Date());
    expect(list.restaurants.some((each) => each.restaurantId === id)).toBe(false);
    const [{ id: statementId }] = (
      await sql.query('SELECT id FROM cashdesk.merchant_statements WHERE restaurant_id = $1', [id])
    ).rows;
    expect(await statements.statement(statementId)).toMatchObject({ status: 'paid', unpaid: 0n });
  });

  it('takes several currencies, each at the current rate', async () => {
    const { cashier } = await openDesk();
    const id = await restaurant();
    await owes(id, 100_000n);

    const receipt = await settle(cashier.user, id, [
      { currency: 'TRY', amount: 10_000n },
      { currency: 'USD', amount: 2_000n },
    ]);

    expect(receipt.lines).toEqual([
      { currency: 'TRY', amount: 10_000n, base: 10_000n },
      { currency: 'USD', amount: 2_000n, base: 80_000n },
    ]);
    expect(receipt).toMatchObject({ total: 90_000n, dueAfter: 10_000n });
    expect(await due(id)).toBe(10_000n);
    const { rows } = await sql.query(
      `SELECT j.rates FROM cashdesk.receipt_lines l JOIN ledger.journals j ON j.id = l.journal_id
       WHERE l.receipt_id = $1 AND l.currency = 'USD'`,
      [receipt.id],
    );
    expect(rows[0].rates).toEqual([{ currency: 'USD', rateVersionId: expect.any(String) }]);
    expect((await receiptPushes(id))[0].body).toBe(
      `إيصال ${receipt.number}: استلمنا منك 100 ₺ + 20 $`,
    );
  });

  it('never takes more than is owed, nor a balance that moved, nor a rate not shown', async () => {
    const { cashier } = await openDesk();
    const id = await restaurant();
    await owes(id, 10_000n);

    expect(await refusal(settle(cashier.user, id, [{ currency: 'TRY', amount: 10_100n }]))).toBe(
      'above_balance',
    );
    const preview = await settlements.preview(id, [{ currency: 'USD', amount: 100n }]);
    await owes(id, 500n);
    const shown = (base: bigint, dueShown = preview.due) =>
      settlements.settle(
        cashier.user,
        {
          restaurantId: id,
          due: dueShown,
          lines: [{ currency: 'USD', amount: 100n, base, rates: preview.lines[0]!.rates }],
          idempotencyKey: randomUUID(),
        },
        new Date(),
      );
    expect(await refusal(shown(preview.lines[0]!.base))).toBe('balance_changed');
    expect(await refusal(shown(preview.lines[0]!.base + 100n, 10_500n))).toBe('rate_changed');
    expect(await due(id)).toBe(10_500n);
  });

  it('refuses a restaurant that owes nothing and one unknown', async () => {
    const { cashier } = await openDesk();
    const id = await restaurant();
    expect(await refusal(settle(cashier.user, id, [{ currency: 'TRY', amount: 100n }]))).toBe(
      'nothing_due',
    );
    expect(await refusal(settlements.preview(randomUUID(), []))).toBe('unknown_restaurant');
  });

  it('needs an open drawer', async () => {
    const cashier = await admin(['FIN']);
    const id = await restaurant();
    await owes(id, 1_000n);
    expect(await refusal(settle(cashier.user, id, [{ currency: 'TRY', amount: 1_000n }]))).toBe(
      'no_open_session',
    );
  });

  it('pays a restaurant the platform owes from the drawer it holds', async () => {
    const { cashier, session } = await openDesk([{ currency: 'TRY', amount: 2_000n }]);
    const id = await restaurant();
    await owes(id, -3_400n);

    expect(await refusal(settle(cashier.user, id, [{ currency: 'TRY', amount: 3_400n }]))).toBe(
      'drawer_short',
    );
    const receipt = await settle(cashier.user, id, [{ currency: 'TRY', amount: 2_000n }]);
    expect(receipt).toMatchObject({
      type: 'merchant_payout',
      dueBefore: -3_400n,
      total: 2_000n,
      dueAfter: -1_400n,
    });
    expect(await due(id)).toBe(-1_400n);
    expect((await desk.session(session.id))?.currencies[0]).toMatchObject({ expected: 0n });
    // RA §16 #31 names a payment received: none for a payout.
    expect(await receiptPushes(id)).toEqual([]);
  });
});

describe('the routes of the restaurant settlement', () => {
  it('quotes and settles for FIN, money as strings, with the key', async () => {
    const cashier = await admin(['FIN']);
    await desk.openSession(cashier.user, azaz, [], new Date());
    const id = await restaurant();
    await owes(id, 5_000n);

    const preview = await cashier.post(
      '/v1/admin/cash-desk/restaurant-settlements/preview',
      { restaurantId: id, lines: [{ currency: 'TRY', amount: '3000' }] },
      null,
    );
    expect(preview.statusCode).toBe(200);
    expect(preview.json()).toMatchObject({ due: '5000', total: '3000', remaining: '2000' });

    const body = {
      restaurantId: id,
      due: '5000',
      lines: [{ currency: 'TRY', amount: '3000', base: '3000', rates: [] }],
    };
    expect(
      (await cashier.post('/v1/admin/cash-desk/restaurant-settlements', body, null)).statusCode,
    ).toBe(400);
    const settled = await cashier.post('/v1/admin/cash-desk/restaurant-settlements', body);
    expect(settled.statusCode).toBe(201);
    expect(settled.json()).toMatchObject({
      type: 'merchant_settlement',
      dueBefore: '5000',
      dueAfter: '2000',
    });

    const read = await cashier.get(`/v1/admin/cash-desk/restaurant-receipts/${settled.json().id}`);
    expect(read.statusCode).toBe(200);
    expect(read.json()).toMatchObject({ number: settled.json().number, total: '3000' });

    const above = await cashier.post('/v1/admin/cash-desk/restaurant-settlements', {
      ...body,
      due: '2000',
      lines: [{ currency: 'TRY', amount: '3000', base: '3000', rates: [] }],
    });
    expect(above.statusCode).toBe(409);
    expect(above.json()).toMatchObject({ error: 'above_balance' });
  });

  it('refuses a user without the desk', async () => {
    const support = await admin(['SUP']);
    const response = await support.post(
      '/v1/admin/cash-desk/restaurant-settlements/preview',
      { restaurantId: randomUUID(), lines: [] },
      null,
    );
    expect(response.statusCode).toBe(403);
  });
});
