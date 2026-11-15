import 'reflect-metadata';
import { randomBytes, randomInt, randomUUID } from 'node:crypto';
import type { NestFastifyApplication } from '@nestjs/platform-fastify';
import pg from 'pg';
import { afterAll, beforeAll, describe, expect, it, vi } from 'vitest';
import { ApiModule } from '../../api.module.js';
import { createDatabase, type Database } from '../../database/database.js';
import { startTestDatabase, type TestDatabase } from '../../database/test-database.js';
import { createApiApp } from '../../http/create-api-app.js';
import { startTestValkey, type TestValkey } from '../../valkey/test-valkey.js';
import { CaptainsService } from '../captains/index.js';
import { FxService } from '../fx/index.js';
import {
  ADMIN_SESSION_COOKIE,
  AdminSessionsService,
  CaptainAccountsService,
  CODE_SENDER,
  type DevelopmentCodeSender,
} from '../identity/index.js';
import { type AccountPurpose, type JournalType, LedgerService } from '../ledger/index.js';
import { SettingsService } from '../settings/index.js';
import {
  CashDeskRefusedError,
  CashDeskService,
  type DeskUser,
  type SettlementPreview,
  SettlementService,
} from './index.js';

// «تصفية الخميس» (AP §8.5.5, §9.10.3, D12; slice 2.18a): custody settled to
// zero in every currency and netted on screen against the full payout, the
// ledger keeping each apart; a payout in another currency at the current
// rate; the negative balance carried forward or collected; the payout day
// and OWN's off-cycle payout; the weekly statement and its push; the key.
vi.setConfig({ testTimeout: 30_000 });

let database: TestDatabase;
let cache: TestValkey;
let app: NestFastifyApplication;
let sql: pg.Pool;
let db: Database;
let azaz: string;
let desk: CashDeskService;
let settlements: SettlementService;
let captains: CaptainsService;
let ledger: LedgerService;
let settings: SettingsService;

const system = { type: 'system', id: null, role: null } as const;
const change = { actor: system, context: { ipAddress: null, device: null }, reason: 'test' };
const bySystem = { editor: 'system', context: change.context, reason: 'test' } as const;
const hour = 3_600_000;

// Noon on the latest Thursday in Azaz (a payout day by default), and the
// Friday after it.
function localNoonOn(weekday: string): Date {
  const parts = (at: Date) =>
    Object.fromEntries(
      new Intl.DateTimeFormat('en-US', {
        timeZone: 'Asia/Damascus',
        weekday: 'long',
        hour: 'numeric',
        hourCycle: 'h23',
      })
        .formatToParts(at)
        .map((part) => [part.type, part.value]),
    );
  const start = Math.floor(Date.now() / hour) * hour;
  for (let step = 0; step < 24 * 8; step += 1) {
    const at = new Date(start - step * hour);
    const found = parts(at);
    if (found.weekday === weekday && Number(found.hour) === 12) return at;
  }
  throw new Error('no such hour');
}
const thursday = localNoonOn('Thursday');
const friday = new Date(thursday.getTime() + 24 * hour);

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
  settings = app.get(SettingsService);
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
  settlements = app.get(SettlementService);
  captains = app.get(CaptainsService);
  ledger = app.get(LedgerService);
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
    [`Payer ${accounts}`, `payer${accounts}@example.test`],
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

async function openDesk(roles = ['FIN'], floats = [{ currency: 'TRY', amount: 100_000n }]) {
  const cashier = await admin(roles);
  const session = await desk.openSession(cashier.user, azaz, floats, new Date());
  return { cashier, session };
}

let captainCount = 0;
async function captain() {
  captainCount += 1;
  return captains.createCaptain(
    azaz,
    {
      name: `كابتن التصفية ${captainCount}`,
      vehicle: 'walking',
      custodyLimit: { amount: 1_000_000n, currency: 'TRY' },
    },
    change,
  );
}

// One journal of an order on one of the captain's accounts (a charge with a
// negative amount), against the
// counter-account its type takes: + to the captain (from their side).
async function post(
  captainId: string,
  type: JournalType,
  amount: bigint,
  {
    currency = 'TRY',
    orderId = randomUUID(),
    reason = type === 'earn.bonus' || type === 'earn.adjustment' ? 'test' : null,
  }: { currency?: string; orderId?: string; reason?: string | null } = {},
) {
  const custody = type.startsWith('custody.');
  const counter: AccountPurpose = custody
    ? 'platform.order_clearing'
    : type === 'earn.charge'
      ? 'platform.order_clearing'
      : type === 'earn.deposit_instalment'
        ? 'captain.deposit'
        : type === 'earn.adjustment'
          ? 'platform.adjustments'
          : 'platform.captain_pay';
  await db.db.transaction(async (tx) => {
    const own = await ledger.openAccount(
      {
        cityId: azaz,
        purpose: custody ? 'captain.custody' : 'captain.earnings',
        ownerId: captainId,
        currency,
      },
      tx,
    );
    const other = await ledger.openAccount(
      {
        cityId: azaz,
        purpose: counter,
        ownerId: counter === 'captain.deposit' ? captainId : null,
        currency,
      },
      tx,
    );
    // Custody is + from the platform's side; earnings − (a liability).
    const signed = custody ? amount : -amount;
    await ledger.post(
      {
        cityId: azaz,
        type,
        source: { kind: 'order', id: orderId },
        actor: { type: 'system', id: null },
        reason,
        entries: [
          { accountId: own, currency, amount: signed },
          { accountId: other, currency, amount: -signed },
        ],
      },
      tx,
    );
  });
}

const refusal = (promise: Promise<unknown>) =>
  promise.then(
    () => null,
    (error: unknown) => (error instanceof CashDeskRefusedError ? error.refusal : error),
  );

// The command the screen sends after the preview it showed.
function commandOf(
  preview: SettlementPreview,
  overrides: Partial<{ reason: string | null; idempotencyKey: string }> = {},
) {
  return {
    captainId: preview.captainId,
    custody: preview.custody.map(({ currency, balance }) => ({ currency, balance })),
    earnings: preview.earnings.amount,
    payout: preview.payout && {
      currency: preview.payout.currency,
      amount: preview.payout.amount,
      rates: preview.payout.rates,
    },
    reason: overrides.reason ?? null,
    idempotencyKey: overrides.idempotencyKey ?? randomUUID(),
  };
}

async function custodyOf(captainId: string) {
  const { custody } = await captains.deskCustody(captainId, new Date());
  return Object.fromEntries(custody.currencies.map((line) => [line.currency, line.balance]));
}

async function earningsOf(captainId: string) {
  const rows = (await captains.balances(azaz, new Date())).filter(
    (row) => row.captainId === captainId,
  );
  return rows[0]?.earnings.amount ?? 0n;
}

describe('«تصفية الخميس» (AP §8.5.5, §9.10.3)', () => {
  it('nets the custody against the payout on screen, the ledger keeping them apart', async () => {
    const { cashier, session } = await openDesk();
    const captainId = await captain();
    const orderId = randomUUID();
    await post(captainId, 'custody.collect', 30_000n);
    await post(captainId, 'earn.order_pay', 45_000n, { orderId });
    await post(captainId, 'earn.waiting_pay', 2_000n, { orderId });
    await post(captainId, 'earn.peak_bonus', 5_000n, { orderId });
    await post(captainId, 'earn.charge', -2_000n);

    // Owing 300 ₺ of custody with 500 ₺ of earnings, the captain gets 200 ₺.
    const preview = await settlements.preview(captainId, null, thursday);
    expect(preview).toMatchObject({
      payoutDay: true,
      payoutWeekday: 'thursday',
      policy: 'carry_forward',
      custody: [{ currency: 'TRY', balance: 30_000n }],
      earnings: { amount: 50_000n, currency: 'TRY' },
      payout: { currency: 'TRY', amount: 50_000n, rates: [] },
      collect: null,
      net: [{ currency: 'TRY', amount: -20_000n }],
    });

    const settled = await settlements.settle(cashier.user, commandOf(preview), thursday);
    expect(settled.receipts.map((receipt) => receipt.type)).toEqual([
      'captain_hand_in',
      'captain_payout',
    ]);
    expect(settled.receipts[1]!.lines).toEqual([
      { currency: 'TRY', expected: -50_000n, amount: 50_000n, remaining: 0n },
    ]);
    expect(await custodyOf(captainId)).toEqual({ TRY: 0n });
    expect(await earningsOf(captainId)).toBe(0n);
    // The drawer paid 200 ₺ out.
    const drawer = await desk.openSessionOf(cashier.user.accountId);
    expect(drawer!.currencies[0]).toMatchObject({ currency: 'TRY', expected: 80_000n });

    // Two journals: the hand-in and the payout, each against the drawer.
    const lines = await sql.query(
      `SELECT l.journal_id FROM cashdesk.receipt_lines l JOIN cashdesk.receipts r ON r.id = l.receipt_id
       WHERE r.id = ANY($1::uuid[]) ORDER BY r.sequence`,
      [settled.receipts.map((receipt) => receipt.id)],
    );
    const journals = await ledger.journalLines(lines.rows.map((row) => row.journal_id));
    expect(journals.map((journal) => journal.type).sort()).toEqual([
      'custody.hand_in',
      'earn.payout',
    ]);
    expect(journals.find((journal) => journal.type === 'earn.payout')).toMatchObject({
      entries: expect.arrayContaining([
        { purpose: 'captain.earnings', ownerId: captainId, currency: 'TRY', amount: 50_000n },
        { purpose: 'platform.cash', ownerId: session.id, currency: 'TRY', amount: -50_000n },
      ]),
    });

    // The statement: the period's orders, pay by part, charges, the net paid.
    expect(settled.statement).toMatchObject({
      captainId,
      periodFrom: null,
      orders: 1,
      basePay: 45_000n,
      distancePay: 0n,
      waitingPay: 2_000n,
      peakBonus: 5_000n,
      bonuses: 0n,
      charges: 2_000n,
      instalments: 0n,
      adjustments: 0n,
      carriedIn: 0n,
      balance: 50_000n,
      paid: 50_000n,
      payout: { currency: 'TRY', amount: 50_000n },
      collected: 0n,
      carriedOut: 0n,
      offCycle: false,
      reason: null,
      receiptIds: settled.receipts.map((receipt) => receipt.id),
    });
    expect(await settlements.statement(settled.statement.id)).toEqual(settled.statement);

    // The captain hears each receipt and the statement (CA §14 #19–#20).
    const pushes = await sql.query(
      `SELECT template_key, body FROM notifications.push_messages
       WHERE source = 'cashdesk:statement:' || $1`,
      [settled.statement.id],
    );
    expect(pushes.rows).toEqual([
      { template_key: 'captain.weekly_statement', body: 'كشف الأسبوع جاهز: قبضت 500 ₺' },
    ]);
    const receiptPushes = await sql.query(
      "SELECT body FROM notifications.push_messages WHERE source = 'cashdesk:receipt:' || $1",
      [settled.receipts[1]!.id],
    );
    expect(receiptPushes.rows).toEqual([
      { body: `إيصال ${settled.receipts[1]!.number}: صرف المستحقات 500 ₺` },
    ]);

    // «آخر صرف» in «أرصدة الكباتن».
    const row = (await desk.balances(azaz, new Date())).find(
      (each) => each.captainId === captainId,
    );
    expect(row!.lastPayoutAt).toEqual(thursday);

    // The next statement starts where this one ended.
    await post(captainId, 'earn.order_pay', 10_000n);
    const next = await settlements.settle(
      cashier.user,
      commandOf(await settlements.preview(captainId, null, thursday)),
      thursday,
    );
    expect(next.statement).toMatchObject({
      periodFrom: thursday,
      orders: 1,
      basePay: 10_000n,
      charges: 0n,
      carriedIn: 0n,
      paid: 10_000n,
    });
  });

  it('pays in another accepted currency at the current rate', async () => {
    const { cashier } = await openDesk(['FIN'], [{ currency: 'USD', amount: 10_000n }]);
    const captainId = await captain();
    await post(captainId, 'custody.collect', 1_000n, { currency: 'USD' });
    await post(captainId, 'earn.order_pay', 50_000n);
    // 500 ₺ at 40 ₺ the dollar: 12.50 $; the captain hands in 10 $.
    const preview = await settlements.preview(captainId, 'USD', thursday);
    expect(preview.payout).toMatchObject({ currency: 'USD', amount: 1_250n });
    expect(preview.payout!.rates).toHaveLength(1);
    expect(preview.net).toEqual([{ currency: 'USD', amount: -250n }]);
    const settled = await settlements.settle(cashier.user, commandOf(preview), thursday);
    expect(settled.statement).toMatchObject({
      paid: 50_000n,
      payout: { currency: 'USD', amount: 1_250n },
    });
    expect(await earningsOf(captainId)).toBe(0n);
    expect(await custodyOf(captainId)).toEqual({ USD: 0n });

    // A rate that moved after the screen showed it is refused.
    const other = await captain();
    await post(other, 'earn.order_pay', 50_000n);
    const shown = commandOf(await settlements.preview(other, 'USD', thursday));
    expect(
      await refusal(
        settlements.settle(
          cashier.user,
          { ...shown, payout: { ...shown.payout!, amount: 1_200n } },
          thursday,
        ),
      ),
    ).toBe('rate_changed');
  });

  it('carries a negative balance forward by default, or collects it at the desk', async () => {
    const { cashier } = await openDesk();
    const carried = await captain();
    await post(carried, 'earn.order_pay', 10_000n);
    await post(carried, 'earn.charge', -30_000n);
    await post(carried, 'custody.collect', 5_000n);
    const preview = await settlements.preview(carried, null, thursday);
    expect(preview).toMatchObject({ payout: null, collect: null });
    expect(preview.net).toEqual([{ currency: 'TRY', amount: 5_000n }]);
    const settled = await settlements.settle(cashier.user, commandOf(preview), thursday);
    expect(settled.receipts.map((receipt) => receipt.type)).toEqual(['captain_hand_in']);
    expect(settled.statement).toMatchObject({
      balance: -20_000n,
      paid: 0n,
      payout: null,
      collected: 0n,
      carriedOut: -20_000n,
    });
    expect(await earningsOf(carried)).toBe(-20_000n);
    // The next week starts from what was carried.
    await post(carried, 'earn.order_pay', 25_000n);
    const next = await settlements.settle(
      cashier.user,
      commandOf(await settlements.preview(carried, null, thursday)),
      thursday,
    );
    // A statement covers the period since the previous actual payout, so
    // the week carried forward is in it (owner decision 2026-11-15).
    expect(next.statement).toMatchObject({
      periodFrom: null,
      carriedIn: 0n,
      basePay: 35_000n,
      charges: 30_000n,
      paid: 5_000n,
    });

    await settings.update(
      'captain.negative_earnings_policy',
      { cityId: azaz },
      'collect_at_desk',
      bySystem,
    );
    try {
      const collected = await captain();
      await post(collected, 'earn.charge', -7_000n);
      const asked = await settlements.preview(collected, null, thursday);
      expect(asked).toMatchObject({ policy: 'collect_at_desk', payout: null, collect: 7_000n });
      expect(asked.net).toEqual([{ currency: 'TRY', amount: 7_000n }]);
      const done = await settlements.settle(cashier.user, commandOf(asked), thursday);
      expect(done.receipts.map((receipt) => receipt.type)).toEqual(['captain_earnings_collection']);
      expect(done.receipts[0]!.lines).toEqual([
        { currency: 'TRY', expected: 7_000n, amount: 7_000n, remaining: 0n },
      ]);
      expect(done.statement).toMatchObject({ balance: -7_000n, collected: 7_000n, carriedOut: 0n });
      expect(await earningsOf(collected)).toBe(0n);
    } finally {
      await settings.update(
        'captain.negative_earnings_policy',
        { cityId: azaz },
        'carry_forward',
        bySystem,
      );
    }
  });

  it('is refused on another day, except to OWN with a reason, which it audits', async () => {
    const fin = await openDesk(['FIN']);
    const owner = await openDesk(['OWN']);
    const captainId = await captain();
    await post(captainId, 'earn.order_pay', 20_000n);
    const preview = await settlements.preview(captainId, null, friday);
    expect(preview.payoutDay).toBe(false);
    expect(await refusal(settlements.settle(fin.cashier.user, commandOf(preview), friday))).toBe(
      'not_payout_day',
    );
    expect(await refusal(settlements.settle(owner.cashier.user, commandOf(preview), friday))).toBe(
      'reason_required',
    );
    const settled = await settlements.settle(
      owner.cashier.user,
      commandOf(preview, { reason: 'إنهاء التعاقد' }),
      friday,
    );
    expect(settled.statement).toMatchObject({ offCycle: true, reason: 'إنهاء التعاقد' });
    const audit = await sql.query(
      "SELECT reason, changes FROM audit.events WHERE action = 'cash_desk.settlement' AND target_id = $1",
      [settled.statement.id],
    );
    expect(audit.rows[0].reason).toBe('إنهاء التعاقد');
    expect(audit.rows[0].changes.offCycle.after).toBe(true);
  });

  it('is refused when the balances moved since the screen, with nothing due, or a short drawer', async () => {
    const { cashier } = await openDesk(['FIN'], []);
    const captainId = await captain();
    expect(
      await refusal(
        settlements.settle(
          cashier.user,
          commandOf(await settlements.preview(captainId, null, thursday)),
          thursday,
        ),
      ),
    ).toBe('nothing_due');
    await post(captainId, 'earn.order_pay', 20_000n);
    const preview = await settlements.preview(captainId, null, thursday);
    await post(captainId, 'custody.collect', 1_000n);
    expect(await refusal(settlements.settle(cashier.user, commandOf(preview), thursday))).toBe(
      'balance_changed',
    );
    // The drawer holds no lira to pay 200 ₺ (less the 10 ₺ handed in).
    expect(
      await refusal(
        settlements.settle(
          cashier.user,
          commandOf(await settlements.preview(captainId, null, thursday)),
          thursday,
        ),
      ),
    ).toBe('drawer_short');
  });

  it('answers a repeat with the same key with the first settlement', async () => {
    const { cashier } = await openDesk();
    const captainId = await captain();
    await post(captainId, 'earn.order_pay', 20_000n);
    const command = commandOf(await settlements.preview(captainId, null, thursday));
    const [first, second] = await Promise.all([
      settlements.settle(cashier.user, command, thursday),
      settlements.settle(cashier.user, command, thursday),
    ]);
    expect(second).toEqual(first);
    const again = await settlements.settle(cashier.user, command, thursday);
    expect(again.statement.id).toBe(first.statement.id);
    expect(
      await refusal(settlements.settle(cashier.user, { ...command, earnings: 1n }, thursday)),
    ).toBe('idempotency_key_reused');
  });

  it("settles after an earlier week's pay was reversed, the pay line below zero", async () => {
    const { cashier } = await openDesk();
    const captainId = await captain();
    const orderId = randomUUID();
    await post(captainId, 'earn.order_pay', 50_000n, { orderId });
    await settlements.settle(
      cashier.user,
      commandOf(await settlements.preview(captainId, null, thursday)),
      thursday,
    );
    // «تغيير النتيجة» makes the captain responsible: the pay comes back.
    await post(captainId, 'earn.order_pay', -50_000n, { orderId });
    await post(captainId, 'earn.order_pay', 10_000n);
    const settled = await settlements.settle(
      cashier.user,
      commandOf(await settlements.preview(captainId, null, thursday)),
      thursday,
    );
    expect(settled.statement).toMatchObject({
      orders: 1,
      basePay: -40_000n,
      balance: -40_000n,
      paid: 0n,
      carriedOut: -40_000n,
    });
  });

  it('refuses a confirmation that names a currency twice', async () => {
    const { cashier } = await openDesk(['FIN'], [{ currency: 'TRY', amount: 100_000n }]);
    const captainId = await captain();
    await post(captainId, 'custody.collect', 30_000n);
    await post(captainId, 'custody.collect', 1_000n, { currency: 'USD' });
    const shown = commandOf(await settlements.preview(captainId, null, thursday));
    const twice = { ...shown, custody: [shown.custody[0]!, shown.custody[0]!] };
    expect(await refusal(settlements.settle(cashier.user, twice, thursday))).toBe(
      'balance_changed',
    );
  });

  it('settles over HTTP and serves the statement', async () => {
    const owner = await admin(['OWN']);
    await desk.openSession(owner.user, azaz, [{ currency: 'TRY', amount: 100_000n }], new Date());
    const captainId = await captain();
    await post(captainId, 'earn.order_pay', 20_000n);
    const body = {
      captainId,
      custody: [],
      earnings: '20000',
      payout: { currency: 'TRY', amount: '20000', rates: [] },
      reason: 'إنهاء التعاقد',
    };
    const moved = await owner.post('/v1/admin/cash-desk/settlements', {
      ...body,
      earnings: '1',
    });
    expect(moved.statusCode).toBe(409);
    expect(moved.json().error).toBe('balance_changed');
    expect((await owner.post('/v1/admin/cash-desk/settlements', body, null)).statusCode).toBe(400);
    const key = randomUUID();
    const settled = await owner.post('/v1/admin/cash-desk/settlements', body, key);
    expect(settled.statusCode).toBe(201);
    expect(settled.json()).toMatchObject({
      statement: { captainId, paid: '20000', payout: { currency: 'TRY', amount: '20000' } },
      receipts: [{ type: 'captain_payout', lines: [{ amount: '20000', expected: '-20000' }] }],
    });
    const again = await owner.post(
      '/v1/admin/cash-desk/settlements',
      { ...body, reason: 'سبب آخر' },
      key,
    );
    expect(again.statusCode).toBe(422);
    const id = settled.json().statement.id;
    const read = await owner.get(`/v1/admin/cash-desk/statements/${id}`);
    expect(read.statusCode).toBe(200);
    expect(read.json()).toEqual(settled.json().statement);
    const unknown = await owner.get(`/v1/admin/cash-desk/statements/${randomUUID()}`);
    expect(unknown.statusCode).toBe(404);
    expect(unknown.json().error).toBe('unknown_statement');
  });

  it('lists the captains to settle, and serves the routes', async () => {
    const { cashier } = await openDesk();
    const captainId = await captain();
    await post(captainId, 'earn.order_pay', 20_000n);
    const listed = await cashier.get(`/v1/admin/cash-desk/settlements?cityId=${azaz}`);
    expect(listed.statusCode).toBe(200);
    expect(listed.json().captains.map((row: { captainId: string }) => row.captainId)).toContain(
      captainId,
    );
    const previewed = await cashier.post(
      '/v1/admin/cash-desk/settlements/preview',
      { captainId, payoutCurrency: null },
      null,
    );
    expect(previewed.statusCode).toBe(200);
    expect(previewed.json()).toMatchObject({
      earnings: { amount: '20000', currency: 'TRY' },
      payout: { currency: 'TRY', amount: '20000' },
    });
  });
});

// The captain app's calls, signed in on a new device.
async function signedIn(captainId: string) {
  const phone = `+9639${randomInt(100_000_000).toString().padStart(8, '0')}`;
  await app.get(CaptainAccountsService).addAccount(captainId, phone, change);
  const deviceId = randomUUID();
  await app.inject({ method: 'POST', url: '/v1/captain/auth/code', payload: { phone, deviceId } });
  const code = app.get<DevelopmentCodeSender>(CODE_SENDER).lastCode(phone);
  const answer = await app.inject({
    method: 'POST',
    url: '/v1/captain/auth/sign-in',
    payload: { phone, deviceId, code },
  });
  const headers = { authorization: `Bearer ${answer.json().accessToken}` };
  return () => app.inject({ method: 'GET', url: '/v1/captain/earnings', headers });
}

describe('«أرباحي» (CA §10.6, slice 2.18b)', () => {
  it('shows today and the week, the orders, the other lines and the balance', async () => {
    const captainId = await captain();
    const read = await signedIn(captainId);
    const orderId = randomUUID();
    await post(captainId, 'earn.order_pay', 3_500n, { orderId });
    await post(captainId, 'earn.peak_bonus', 500n, { orderId });
    await post(captainId, 'earn.bonus', 1_000n, { reason: 'مساعدة في الذروة' });
    await post(captainId, 'earn.charge', -700n, { orderId, reason: 'تالف' });
    // An hour online that ended ten minutes ago.
    await sql.query(
      `INSERT INTO captains.online_periods (captain_id, started_at, ended_at, end_reason)
       VALUES ($1, now() - interval '70 minutes', now() - interval '10 minutes', 'captain')`,
      [captainId],
    );

    const answer = await read();
    expect(answer.statusCode).toBe(200);
    const body = answer.json();
    expect(body).toMatchObject({
      currency: 'TRY',
      today: { earnings: '4300', orders: 1, onlineMinutes: 60 },
      week: { earnings: '4300', orders: 1, onlineMinutes: 60 },
      balance: '4300',
      payoutWeekday: 'thursday',
      negativePolicy: 'carry_forward',
    });
    expect(body.nextPayout).toMatch(/^\d{4}-\d{2}-\d{2}$/);
    // An order with no collection shows its total only.
    expect(body.orders).toEqual([
      { orderNumber: null, at: expect.any(String), parts: null, total: '4000' },
    ]);
    expect(
      body.lines.map((line: { kind: string; amount: string; reason: string | null }) => [
        line.kind,
        line.amount,
        line.reason,
      ]),
    ).toEqual(
      expect.arrayContaining([
        ['bonus', '1000', 'مساعدة في الذروة'],
        ['charge', '-700', 'تالف'],
      ]),
    );

    // After the settlement the balance is zero, with the payout and its receipt.
    const { cashier } = await openDesk(['OWN']);
    const preview = await settlements.preview(captainId, null, new Date());
    const settled = await settlements.settle(
      cashier.user,
      commandOf(preview, { reason: 'خارج الدورة' }),
      new Date(),
    );
    const after = (await read()).json();
    expect(after.balance).toBe('0');
    expect(after.week.earnings).toBe('4300');
    expect(after.lines[0]).toMatchObject({
      kind: 'payout',
      amount: '-4300',
      receiptNumber: settled.receipts[0]!.number,
      orderNumber: null,
    });
  });

  it('explains a negative balance with the policy', async () => {
    const captainId = await captain();
    const read = await signedIn(captainId);
    await post(captainId, 'earn.charge', -1_200n, { reason: 'تالف' });
    expect((await read()).json()).toMatchObject({
      balance: '-1200',
      today: { earnings: '-1200', orders: 0, onlineMinutes: 0 },
      negativePolicy: 'carry_forward',
    });
  });

  it("keeps another captain's earnings out, and needs a captain sign-in", async () => {
    const captainId = await captain();
    await post(captainId, 'earn.order_pay', 2_000n);
    const other = await signedIn(await captain());
    expect((await other()).json()).toMatchObject({
      balance: '0',
      orders: [],
      lines: [],
      week: { earnings: '0', orders: 0 },
    });
    const response = await app.inject({ method: 'GET', url: '/v1/captain/earnings' });
    expect(response.statusCode).toBe(401);
  });
});
