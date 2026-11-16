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
import { MerchantStatementsService } from './index.js';

// The restaurant's weekly statement at the cutoff (AP §8.7, AP §9.10.3 tab 3,
// RA §12.3, §16 #30; slice 2.19a): each period since the previous statement,
// the earlier unpaid balance less the payments since, one statement per
// cutoff, the owners' push, and «تسوية المطاعم».
vi.setConfig({ testTimeout: 30_000 });

let database: TestDatabase;
let cache: TestValkey;
let app: NestFastifyApplication;
let sql: pg.Pool;
let db: Database;
let azaz: string;
let statements: MerchantStatementsService;
let ledger: LedgerService;
let merchants: MerchantsService;

const system = { type: 'system', id: null, role: null } as const;
const change = { actor: system, context: { ipAddress: null, device: null }, reason: 'test' };
const DAY = 86_400_000;

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
  statements = app.get(MerchantStatementsService);
  ledger = app.get(LedgerService);
  merchants = app.get(MerchantsService);
}, 300_000);

afterAll(async () => {
  await app?.close();
  await db?.pool.end();
  await sql?.end();
  await Promise.all([database?.stop(), cache?.stop()]);
});

async function restaurant() {
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
  return id;
}

// One journal on the restaurant's account: + the restaurant owes.
async function postWith(
  tx: Parameters<Parameters<Database['db']['transaction']>[0]>[0],
  restaurantId: string,
  type: JournalType,
  owes: bigint,
  { orderId = randomUUID(), reason = null }: { orderId?: string; reason?: string | null } = {},
) {
  const counter: AccountPurpose =
    type === 'merchant.commission'
      ? 'platform.revenue_commission'
      : type === 'merchant.settlement'
        ? 'platform.cash'
        : type === 'merchant.adjustment'
          ? 'platform.adjustments'
          : 'platform.order_clearing';
  {
    const own = await ledger.openAccount(
      { cityId: azaz, purpose: 'merchant.account', ownerId: restaurantId, currency: 'TRY' },
      tx,
    );
    const other = await ledger.openAccount(
      {
        cityId: azaz,
        purpose: counter,
        ownerId: counter === 'platform.cash' ? randomUUID() : null,
        currency: 'TRY',
      },
      tx,
    );
    await ledger.post(
      {
        cityId: azaz,
        type,
        source:
          type === 'merchant.settlement'
            ? { kind: 'receipt', id: randomUUID() }
            : type === 'merchant.adjustment'
              ? null
              : { kind: 'order', id: orderId },
        actor: { type: 'system', id: null },
        reason,
        // The platform's side: + the restaurant owes.
        entries: [
          { accountId: own, currency: 'TRY', amount: owes },
          { accountId: other, currency: 'TRY', amount: -owes },
        ],
      },
      tx,
    );
  }
}

async function post(
  restaurantId: string,
  type: JournalType,
  owes: bigint,
  options: { orderId?: string; reason?: string | null } = {},
) {
  await db.db.transaction((tx) => postWith(tx, restaurantId, type, owes, options));
}

async function rows(restaurantId: string) {
  return (
    await sql.query(
      'SELECT id, cutoff, total_due::text, previous_due::text, paid::text FROM cashdesk.merchant_statements WHERE restaurant_id = $1 ORDER BY cutoff',
      [restaurantId],
    )
  ).rows;
}

// A cutoff from the database clock: entries carry their transaction's time,
// and the test's clock can differ from it by a few milliseconds (Docker
// Desktop's virtual machine), enough to put an entry on the wrong side. The
// pauses keep it 2 ms from the entries on either side, since times reach
// JavaScript cut to the millisecond.
async function databaseNow(): Promise<Date> {
  await sql.query('SELECT pg_sleep(0.002)');
  const { rows } = await sql.query<{ now: Date }>('SELECT clock_timestamp() AS now');
  await sql.query('SELECT pg_sleep(0.002)');
  return rows[0]!.now;
}

async function pushes(restaurantId: string) {
  return (
    await sql.query(
      "SELECT body, owners_only, data FROM notifications.push_messages WHERE restaurant_id = $1 AND template_key = 'merchant.weekly_statement'",
      [restaurantId],
    )
  ).rows;
}

describe('the restaurant weekly statement at the cutoff', () => {
  it('covers the entries before the cutoff, once, and tells the owners', async () => {
    const id = await restaurant();
    const order = randomUUID();
    await post(id, 'merchant.commission', 6_000n, { orderId: order });
    await post(id, 'merchant.debit', 40_000n, {
      orderId: randomUUID(),
      reason: 'استرداد مبلغ الاستلام',
    });
    const cutoff = await databaseNow();
    // Posted after the cutoff: next week's.
    await post(id, 'merchant.commission', 5_700n);

    await statements.closeAt(azaz, cutoff, cutoff, { notify: true });
    await statements.closeAt(azaz, cutoff, cutoff, { notify: true });

    const [first, ...others] = await rows(id);
    expect(others).toEqual([]);
    expect(first).toMatchObject({ total_due: '46000', previous_due: '0', paid: '0' });
    const statement = await statements.statement(first.id);
    expect(statement).toMatchObject({
      restaurantId: id,
      orders: 1,
      commission: 6_000n,
      exceptions: 40_000n,
      weekTotal: 46_000n,
      totalDue: 46_000n,
      periodFrom: null,
    });
    expect(statement?.lines).toEqual([
      expect.objectContaining({ kind: 'order', orderId: order, commission: 6_000n, position: 0 }),
      expect.objectContaining({ kind: 'exception', cause: 'pickup_refund', amount: 40_000n }),
    ]);
    expect(await pushes(id)).toEqual([
      {
        body: 'كشف الأسبوع جاهز: المستحق 460 ₺. التسوية اليوم في المكتب أو عند زيارة موظفنا.',
        owners_only: true,
        data: { target: 'statement', statementId: first.id },
      },
    ]);
  });

  it('carries the earlier unpaid balance less the payments since into the next', async () => {
    const id = await restaurant();
    await post(id, 'merchant.commission', 8_000n);
    const first = await databaseNow();
    await statements.closeAt(azaz, first, first, { notify: false });
    await post(id, 'merchant.settlement', -5_000n);
    await post(id, 'merchant.commission', 6_000n);
    const second = await databaseNow();
    await statements.closeAt(azaz, second, second, { notify: false });

    const [, next] = await rows(id);
    const statement = await statements.statement(next.id);
    expect(statement).toMatchObject({
      periodFrom: first,
      previousDue: 8_000n,
      paid: 5_000n,
      earlierUnpaid: 3_000n,
      weekTotal: 6_000n,
      totalDue: 9_000n,
    });
    expect(statement?.lines.map((line) => line.kind)).toEqual(['payment', 'order']);
    expect(await pushes(id)).toEqual([]);
  });

  it('leaves an entry committed after the statement to the next one', async () => {
    const id = await restaurant();
    await post(id, 'merchant.commission', 1_000n);
    let posted!: () => void;
    let release!: () => void;
    const written = new Promise<void>((resolve) => (posted = resolve));
    const held = new Promise<void>((resolve) => (release = resolve));
    // Stamped before the cutoff (its transaction's start), committed after.
    const late = db.db.transaction(async (tx) => {
      await postWith(tx, id, 'merchant.commission', 700n);
      posted();
      await held;
    });
    await written;
    const first = await databaseNow();
    await statements.closeAt(azaz, first, first, { notify: false });
    release();
    await late;
    const second = await databaseNow();
    await statements.closeAt(azaz, second, second, { notify: false });

    const [one, two] = await rows(id);
    expect(one).toMatchObject({ total_due: '1000' });
    expect(await statements.statement(two.id)).toMatchObject({
      previousDue: 1_000n,
      weekTotal: 700n,
      totalDue: 1_700n,
    });
  });

  it('takes no statement for a restaurant with nothing in the period and nothing due', async () => {
    const id = await restaurant();
    const cutoff = await databaseNow();
    await statements.closeAt(azaz, cutoff, cutoff, { notify: true });
    expect(await rows(id)).toEqual([]);
  });

  it('pushes nothing when the platform owes the restaurant', async () => {
    const id = await restaurant();
    await post(id, 'merchant.credit', -3_400n);
    const cutoff = await databaseNow();
    await statements.closeAt(azaz, cutoff, cutoff, { notify: true });
    expect((await rows(id))[0]).toMatchObject({ total_due: '-3400' });
    expect(await pushes(id)).toEqual([]);
  });

  it('closes at the business-day cutoff that starts the settlement day', async () => {
    const { last, next, weekday } = await statements.cutoffs(azaz, new Date());
    expect(weekday).toBe('saturday');
    const local = new Intl.DateTimeFormat('en-US', {
      timeZone: 'Asia/Damascus',
      weekday: 'long',
      hour: 'numeric',
      minute: 'numeric',
      hourCycle: 'h23',
    });
    expect(local.format(last)).toBe('Saturday 06:00');
    expect(next.getTime() - last.getTime()).toBe(7 * DAY);
    expect(last.getTime()).toBeLessThanOrEqual(Date.now());
  });

  it('dates the overdue from the oldest statement still unpaid', async () => {
    const id = await restaurant();
    await post(id, 'merchant.commission', 1_000n);
    const first = await databaseNow();
    await statements.closeAt(azaz, first, first, { notify: false });
    await post(id, 'merchant.commission', 2_000n);
    const second = await databaseNow();
    await statements.closeAt(azaz, second, second, { notify: false });

    const list = await statements.restaurants(azaz, new Date(second.getTime() + 3 * DAY));
    const row = list.restaurants.find((each) => each.restaurantId === id);
    expect(row).toMatchObject({ unpaid: 3_000n });
    expect(row?.latest).toMatchObject({ commission: 2_000n, totalDue: 3_000n });
    expect(row?.overdueSince).toEqual(new Date(first.getTime() + 2 * DAY));
  });

  // Slice 2.19b's review: a payout to the restaurant raises what it owes in
  // its week, never a negative payment, and a credit since the cutoff
  // settles the oldest statement first, as a payment does.
  it('counts a payout in its week, not as a payment', async () => {
    const id = await restaurant();
    await post(id, 'merchant.commission', 1_000n);
    const first = await databaseNow();
    await statements.closeAt(azaz, first, first, { notify: false });
    await post(id, 'merchant.settlement', -1_000n);
    await post(id, 'merchant.credit', -300n);
    await post(id, 'merchant.settlement', 300n);
    await post(id, 'merchant.commission', 50n);
    const second = await databaseNow();
    await statements.closeAt(azaz, second, second, { notify: false });

    const [one, two] = await rows(id);
    expect(await statements.statement(two.id)).toMatchObject({
      paid: 1_000n,
      earlierUnpaid: 0n,
      weekTotal: 50n,
      totalDue: 50n,
      status: 'unpaid',
    });
    expect(await statements.statement(one.id)).toMatchObject({ status: 'paid', unpaid: 0n });
    const row = (
      await statements.restaurants(azaz, new Date(second.getTime() + DAY))
    ).restaurants.find((each) => each.restaurantId === id);
    expect(row).toMatchObject({ unpaid: 50n, overdueSince: null });
  });

  it('lets a credit since the cutoff settle the statement, a payout after it too', async () => {
    const owed = await restaurant();
    const even = await restaurant();
    for (const id of [owed, even]) await post(id, 'merchant.commission', 1_000n);
    const cutoff = await databaseNow();
    await statements.closeAt(azaz, cutoff, cutoff, { notify: false });
    for (const id of [owed, even]) await post(id, 'merchant.credit', -1_500n);
    await post(even, 'merchant.settlement', 500n);

    const list = await statements.restaurants(azaz, new Date(cutoff.getTime() + 3 * DAY));
    expect(list.restaurants.find((each) => each.restaurantId === owed)).toMatchObject({
      balance: -500n,
      unpaid: 0n,
      overdueSince: null,
    });
    for (const id of [owed, even]) {
      const [statement] = await rows(id);
      expect(await statements.statement(statement.id)).toMatchObject({
        status: 'paid',
        unpaid: 0n,
      });
    }
  });

  it('lists the restaurants with a balance, the overdue first', async () => {
    const paid = await restaurant();
    const late = await restaurant();
    await post(paid, 'merchant.commission', 90_000n);
    await post(late, 'merchant.commission', 1_000n);
    const cutoff = await databaseNow();
    await statements.closeAt(azaz, cutoff, cutoff, { notify: false });
    await post(paid, 'merchant.settlement', -90_000n);
    await post(paid, 'merchant.commission', 500n);

    const now = new Date(cutoff.getTime() + 3 * DAY);
    const list = await statements.restaurants(azaz, now);
    const mine = list.restaurants.filter((row) => [paid, late].includes(row.restaurantId));
    expect(mine.map((row) => row.restaurantId)).toEqual([late, paid]);
    expect(mine[0]).toMatchObject({ balance: 1_000n, unpaid: 1_000n });
    expect(mine[0]?.overdueSince).toEqual(new Date(cutoff.getTime() + 2 * DAY));
    expect(mine[1]).toMatchObject({ balance: 500n, unpaid: 0n, overdueSince: null });
    expect(list.currency).toBe('TRY');
  });
});

async function overdueAlerts(restaurantId: string) {
  return (
    await sql.query(
      "SELECT severity, resolved_at, details FROM notifications.alerts WHERE code = 'restaurant_settlement_overdue' AND subject_id = $1 ORDER BY raised_at",
      [restaurantId],
    )
  ).rows;
}

async function overduePushes(restaurantId: string) {
  return (
    await sql.query(
      "SELECT body, owners_only, data FROM notifications.push_messages WHERE restaurant_id = $1 AND template_key = 'merchant.settlement_overdue' ORDER BY created_at",
      [restaurantId],
    )
  ).rows;
}

// RA §12.6, §16 #32, AP §8.7, §9.1.3 (slice 2.19f): a statement not fully
// paid merchant.settlement_overdue_days after its settlement day raises
// «مطعم متأخر في التسوية» for OWN and FIN and reminds the owners once; the
// alert closes once it is paid. The restaurant is never paused for it.
describe('the overdue settlement', () => {
  it('waits for the overdue days after the settlement day', async () => {
    const id = await restaurant();
    await post(id, 'merchant.commission', 1_000n);
    const cutoff = await databaseNow();
    await statements.closeAt(azaz, cutoff, cutoff, { notify: false });

    const early = new Date(cutoff.getTime() + 2 * DAY - 60_000);
    expect(await statements.overdue(azaz, id, early)).toBeNull();
    await statements.syncOverdue(azaz, early);
    expect(await overdueAlerts(id)).toEqual([]);
    expect(await overduePushes(id)).toEqual([]);
  });

  it('raises the alert and reminds the owners once, and closes it when paid', async () => {
    const id = await restaurant();
    await post(id, 'merchant.commission', 1_000n);
    const first = await databaseNow();
    await statements.closeAt(azaz, first, first, { notify: false });
    await post(id, 'merchant.commission', 2_000n);
    const second = await databaseNow();
    await statements.closeAt(azaz, second, second, { notify: false });

    // The second week is still within its days (its cutoff is after the
    // first's): only the first is overdue. Every sync runs at that moment.
    const now = new Date(first.getTime() + 2 * DAY);
    const firstId = (await rows(id))[0].id;
    expect(await statements.overdue(azaz, id, now)).toEqual({
      currency: 'TRY',
      amount: 1_000n,
      statementId: firstId,
      statementCutoff: first,
      since: now,
    });
    await statements.syncOverdue(azaz, now);
    await statements.syncOverdue(azaz, now);

    const [alert, ...more] = await overdueAlerts(id);
    expect(more).toEqual([]);
    expect(alert).toMatchObject({ severity: 'warning', resolved_at: null });
    expect(alert.details).toMatchObject({ restaurantName: expect.stringContaining('مطعم') });
    expect(await overduePushes(id)).toEqual([
      {
        body: 'لديك مبلغ متأخر: 10 ₺. يرجى التسوية في أقرب وقت.',
        owners_only: true,
        data: { target: 'account' },
      },
    ]);

    // A part paid settles the oldest first: still overdue, no new reminder.
    await post(id, 'merchant.settlement', -500n);
    await statements.syncOverdue(azaz, now);
    expect(await overdueAlerts(id)).toHaveLength(1);
    expect((await overdueAlerts(id))[0].resolved_at).toBeNull();
    expect(await overduePushes(id)).toHaveLength(1);

    // The rest of the first week paid: the second is not overdue yet.
    await post(id, 'merchant.settlement', -500n);
    await statements.syncOverdue(azaz, now);
    expect((await overdueAlerts(id))[0].resolved_at).not.toBeNull();
    expect(await statements.overdue(azaz, id, now)).toBeNull();
  });
});

describe('the routes of «تسوية المطاعم»', () => {
  let accounts = 0;
  async function admin(roles: string[]) {
    accounts += 1;
    const { rows: created } = await sql.query(
      `INSERT INTO identity.admin_accounts (name, email, status, password_hash, totp_secret_encrypted)
       VALUES ($1, $2, 'active', 'not used', 'not used') RETURNING id`,
      [`Statements ${accounts}`, `statements${accounts}@example.test`],
    );
    const accountId: string = created[0].id;
    for (const role of roles) {
      await sql.query(
        'INSERT INTO identity.admin_account_roles (account_id, role_code) VALUES ($1, $2)',
        [accountId, role],
      );
    }
    const { token } = await app
      .get(AdminSessionsService)
      .start(db.db, accountId, { ipAddress: '203.0.113.9', device: 'test' }, new Date());
    return (url: string) =>
      app.inject({ method: 'GET', url, cookies: { [ADMIN_SESSION_COOKIE]: token } });
  }

  it('answers the list and a statement to FIN, money as strings', async () => {
    const id = await restaurant();
    await post(id, 'merchant.commission', 2_500n);
    const cutoff = await databaseNow();
    await statements.closeAt(azaz, cutoff, cutoff, { notify: false });
    const get = await admin(['FIN']);

    const list = await get(`/v1/admin/cash-desk/restaurants?cityId=${azaz}`);
    expect(list.statusCode).toBe(200);
    const row = list
      .json()
      .restaurants.find((each: { restaurantId: string }) => each.restaurantId === id);
    expect(row).toMatchObject({ balance: '2500', unpaid: '2500', overdueSince: null });

    const statement = await get(`/v1/admin/cash-desk/merchant-statements/${row.latest.id}`);
    expect(statement.statusCode).toBe(200);
    expect(statement.json()).toMatchObject({ restaurantId: id, totalDue: '2500' });
    expect(statement.json().lines[0]).toMatchObject({ kind: 'order', commission: '2500' });

    const unknown = await get(`/v1/admin/cash-desk/merchant-statements/${randomUUID()}`);
    expect(unknown.statusCode).toBe(404);
    expect(unknown.json()).toMatchObject({ error: 'unknown_statement' });
  });

  it('refuses a user without the desk', async () => {
    const get = await admin(['SUP']);
    expect((await get(`/v1/admin/cash-desk/restaurants?cityId=${azaz}`)).statusCode).toBe(403);
  });
});
