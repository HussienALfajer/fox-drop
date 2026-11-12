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
import { formatTime } from '../content/index.js';
import { FxService } from '../fx/index.js';
import {
  ADMIN_SESSION_COOKIE,
  AdminSessionsService,
  CaptainAccountsService,
  CODE_SENDER,
  type DevelopmentCodeSender,
} from '../identity/index.js';
import { type JournalType, LedgerService } from '../ledger/index.js';
import { SettingsService } from '../settings/index.js';
import { CashDeskRefusedError, CashDeskService, type DeskUser } from './index.js';

// The cash desk (AP §9.10.3, §4.8, §8.5.1, §8.5.4; slice 2.17a): drawer
// sessions with their float and variance, the daily hand-in and the
// reimbursement against the session's cash, receipts numbered without gaps,
// the captain's push and the routes.
vi.setConfig({ testTimeout: 30_000 });

let database: TestDatabase;
let cache: TestValkey;
let app: NestFastifyApplication;
let sql: pg.Pool;
let db: Database;
let azaz: string;
let desk: CashDeskService;
let captains: CaptainsService;
let ledger: LedgerService;

const system = { type: 'system', id: null, role: null } as const;
const change = { actor: system, context: { ipAddress: null, device: null }, reason: 'test' };
const day = 86_400_000;

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
  const bySystem = { editor: 'system', context: change.context, reason: 'test' } as const;
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
// A signed-in admin holding these roles (the identity rows written here).
async function admin(roles: string[]) {
  accounts += 1;
  const { rows } = await sql.query(
    `INSERT INTO identity.admin_accounts (name, email, status, password_hash, totp_secret_encrypted)
     VALUES ($1, $2, 'active', 'not used', 'not used') RETURNING id`,
    [`Cashier ${accounts}`, `cashier${accounts}@example.test`],
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

const phoneNumber = () => `+9639${randomInt(100_000_000).toString().padStart(8, '0')}`;

let captainCount = 0;
async function captain() {
  captainCount += 1;
  const id = await captains.createCaptain(
    azaz,
    {
      name: `كابتن الصندوق ${captainCount}`,
      vehicle: 'walking',
      custodyLimit: { amount: 1_000_000n, currency: 'TRY' },
    },
    change,
  );
  const phone = phoneNumber();
  await app.get(CaptainAccountsService).addAccount(id, phone, change);
  return { id, phone };
}

// The captain's cash from an order: + collected, − paid to a restaurant.
async function custody(captainId: string, type: JournalType, amount: bigint, currency = 'TRY') {
  await db.db.transaction(async (tx) => {
    const account = await ledger.openAccount(
      { cityId: azaz, purpose: 'captain.custody', ownerId: captainId, currency },
      tx,
    );
    const clearing = await ledger.openAccount(
      { cityId: azaz, purpose: 'platform.order_clearing', ownerId: null, currency },
      tx,
    );
    await ledger.post(
      {
        cityId: azaz,
        type,
        source: { kind: 'order', id: randomUUID() },
        actor: { type: 'system', id: null },
        entries: [
          { accountId: account, currency, amount },
          { accountId: clearing, currency, amount: -amount },
        ],
      },
      tx,
    );
  });
}

async function balances(captainId: string) {
  const { custody: held } = await captains.deskCustody(captainId, new Date());
  return Object.fromEntries(held.currencies.map((line) => [line.currency, line.balance]));
}

const refusal = (promise: Promise<unknown>) =>
  promise.then(
    () => null,
    (error: unknown) => (error instanceof CashDeskRefusedError ? error.refusal : error),
  );

const year = new Intl.DateTimeFormat('en-US', { timeZone: 'Asia/Damascus', year: 'numeric' })
  .format(new Date())
  .slice(-4);
const sequenceOf = (number: string) => Number(number.slice(-6));

async function openDesk(roles = ['FIN']) {
  const cashier = await admin(roles);
  const session = await desk.openSession(
    cashier.user,
    azaz,
    [{ currency: 'TRY', amount: 50_000n }],
    new Date(),
  );
  return { cashier, session };
}

describe('drawer sessions (AP §9.10.3 «جلسة الصندوق»)', () => {
  it('opens with a float for every city currency, one office session at a time', async () => {
    const { cashier, session } = await openDesk();
    expect(session).toMatchObject({ kind: 'office', closedAt: null, adminName: 'Cashier 1' });
    expect(session.currencies).toEqual([
      { currency: 'TRY', openingFloat: 50_000n, expected: 50_000n, counted: null, variance: null },
      { currency: 'USD', openingFloat: 0n, expected: 0n, counted: null, variance: null },
    ]);
    expect(await refusal(desk.openSession(cashier.user, azaz, [], new Date()))).toBe(
      'session_open',
    );
    expect(await desk.openSessionOf(cashier.user.accountId)).toMatchObject({ id: session.id });
    expect(await refusal(desk.openSession(cashier.user, randomUUID(), [], new Date()))).toBe(
      'unknown_city',
    );
    const other = await admin(['FIN']);
    expect(
      await refusal(
        desk.openSession(other.user, azaz, [{ currency: 'EUR', amount: 1n }], new Date()),
      ),
    ).toBe('invalid_amounts');
  });

  it('closes with the counted cash, the variance and its note', async () => {
    const { cashier, session } = await openDesk();
    const { id: captainId } = await captain();
    await custody(captainId, 'custody.collect', 41_000n);
    await desk.handIn(
      cashier.user,
      { captainId, lines: [{ currency: 'TRY', amount: 41_000n }], idempotencyKey: randomUUID() },
      new Date(),
    );
    const counted = [
      { currency: 'TRY', amount: 90_000n },
      { currency: 'USD', amount: 0n },
    ];
    // Expected 50 000 + 41 000; counted 1 000 short.
    expect(
      await refusal(desk.closeSession(cashier.user, session.id, counted, null, new Date())),
    ).toBe('note_required');
    expect(
      await refusal(
        desk.closeSession(cashier.user, session.id, counted.slice(0, 1), 'x', new Date()),
      ),
    ).toBe('invalid_amounts');
    const stranger = await admin(['FIN']);
    expect(
      await refusal(desk.closeSession(stranger.user, session.id, counted, 'x', new Date())),
    ).toBe('not_your_session');
    const closed = await desk.closeSession(
      cashier.user,
      session.id,
      counted,
      'نقص ورقة عشرة',
      new Date(),
    );
    expect(closed.closeNote).toBe('نقص ورقة عشرة');
    expect(closed.closedAt).not.toBeNull();
    expect(closed.currencies[0]).toEqual({
      currency: 'TRY',
      openingFloat: 50_000n,
      expected: 91_000n,
      counted: 90_000n,
      variance: -1_000n,
    });
    expect(
      await refusal(desk.closeSession(cashier.user, session.id, counted, 'x', new Date())),
    ).toBe('session_closed');
    // No transaction after the close, and a new session may open.
    expect(
      await refusal(
        desk.handIn(
          cashier.user,
          { captainId, lines: [{ currency: 'TRY', amount: 1n }], idempotencyKey: randomUUID() },
          new Date(),
        ),
      ),
    ).toBe('no_open_session');
    await desk.openSession(cashier.user, azaz, [], new Date());
  });

  it('closes without a note when nothing is missing', async () => {
    const { cashier, session } = await openDesk();
    const closed = await desk.closeSession(
      cashier.user,
      session.id,
      [
        { currency: 'TRY', amount: 50_000n },
        { currency: 'USD', amount: 0n },
      ],
      null,
      new Date(),
    );
    expect(closed.currencies.map((line) => line.variance)).toEqual([0n, 0n]);
  });
});

describe('the daily hand-in (AP §9.10.3 «تسليم النقد اليومي», §8.5.4)', () => {
  it('takes the cash, issues a numbered receipt and lifts the block of a closed day', async () => {
    const { cashier, session } = await openDesk();
    const { id: captainId } = await captain();
    await custody(captainId, 'custody.collect', 41_000n);
    const later = new Date(Date.now() + 2 * day);
    expect((await captains.state(captainId, later)).custody.closedDue.amount).toBe(41_000n);

    const [receipt, ...more] = await desk.handIn(
      cashier.user,
      { captainId, lines: [{ currency: 'TRY', amount: 41_000n }], idempotencyKey: randomUUID() },
      new Date(),
    );
    expect(more).toEqual([]);
    expect(receipt!.number).toMatch(new RegExp(`^AZ-${year}-\\d{6}$`));
    expect(receipt).toMatchObject({
      type: 'captain_hand_in',
      sessionId: session.id,
      captainId,
      captainName: expect.stringContaining('كابتن الصندوق'),
      cashierName: expect.stringContaining('Cashier'),
      lines: [{ currency: 'TRY', expected: 41_000n, amount: 41_000n, remaining: 0n }],
    });
    expect(await balances(captainId)).toEqual({ TRY: 0n });
    expect((await captains.state(captainId, later)).custody.closedDue.amount).toBe(0n);
    expect((await desk.openSessionOf(cashier.user.accountId))!.currencies[0]!.expected).toBe(
      91_000n,
    );

    // The receipt's journal moves the custody into the session's drawer, and
    // the captain hears it (CA §14 #19).
    const lines = await sql.query(
      'SELECT journal_id FROM cashdesk.receipt_lines WHERE receipt_id = $1',
      [receipt!.id],
    );
    const [journal] = await ledger.journalLines([lines.rows[0].journal_id]);
    expect(journal).toMatchObject({
      type: 'custody.hand_in',
      entries: expect.arrayContaining([
        { purpose: 'captain.custody', ownerId: captainId, currency: 'TRY', amount: -41_000n },
        { purpose: 'platform.cash', ownerId: session.id, currency: 'TRY', amount: 41_000n },
      ]),
    });
    const pushes = await sql.query(
      "SELECT template_key, body, level FROM notifications.push_messages WHERE source = 'cashdesk:receipt:' || $1",
      [receipt!.id],
    );
    expect(pushes.rows).toEqual([
      {
        template_key: 'captain.desk_receipt',
        body: `إيصال ${receipt!.number}: تسليم نقد 410 ₺`,
        level: 'silent',
      },
    ]);
    const broadcasts = await sql.query(
      "SELECT count(*)::int AS n FROM notifications.platform_outbox WHERE type = 'captain.availability_changed' AND payload->>'captainId' = $1",
      [captainId],
    );
    expect(broadcasts.rows).toEqual([{ n: 1 }]);
  });

  it('leaves a difference open, and refuses more than the custody or a currency not held', async () => {
    const { cashier } = await openDesk();
    const { id: captainId } = await captain();
    await custody(captainId, 'custody.collect', 41_000n);
    const handIn = (lines: { currency: string; amount: bigint }[]) =>
      desk.handIn(cashier.user, { captainId, lines, idempotencyKey: randomUUID() }, new Date());
    expect(await refusal(handIn([{ currency: 'TRY', amount: 41_001n }]))).toBe('above_custody');
    expect(await refusal(handIn([{ currency: 'USD', amount: 100n }]))).toBe('nothing_due');
    expect(await refusal(handIn([{ currency: 'TRY', amount: 0n }]))).toBe('invalid_amounts');
    expect(
      await refusal(
        handIn([
          { currency: 'TRY', amount: 1n },
          { currency: 'TRY', amount: 1n },
        ]),
      ),
    ).toBe('invalid_amounts');
    const [receipt] = await handIn([{ currency: 'TRY', amount: 40_000n }]);
    expect(receipt!.lines).toEqual([
      { currency: 'TRY', expected: 41_000n, amount: 40_000n, remaining: 1_000n },
    ]);
    expect(await balances(captainId)).toEqual({ TRY: 1_000n });
  });

  it('pays back a negative custody, the first captain of a handover included, on its own receipt', async () => {
    const { cashier } = await openDesk();
    const { id: captainId } = await captain();
    // Paid the restaurant 400 ₺ and handed the order over (CA §19 item 21);
    // collected 10 $ on another order.
    await custody(captainId, 'custody.pay_merchant', -40_000n);
    await custody(captainId, 'custody.collect', 1_000n, 'USD');
    const receipts = await desk.handIn(
      cashier.user,
      {
        captainId,
        lines: [
          { currency: 'TRY', amount: 40_000n },
          { currency: 'USD', amount: 1_000n },
        ],
        idempotencyKey: randomUUID(),
      },
      new Date(),
    );
    expect(receipts.map((receipt) => receipt.type)).toEqual([
      'captain_hand_in',
      'captain_reimbursement',
    ]);
    expect(receipts[1]!.lines).toEqual([
      { currency: 'TRY', expected: -40_000n, amount: 40_000n, remaining: 0n },
    ]);
    expect(sequenceOf(receipts[1]!.number)).toBe(sequenceOf(receipts[0]!.number) + 1);
    expect(await balances(captainId)).toEqual({ TRY: 0n, USD: 0n });
    // The drawer paid the lira out and took the dollars in.
    const session = await desk.openSessionOf(cashier.user.accountId);
    expect(session!.currencies.map((line) => [line.currency, line.expected])).toEqual([
      ['TRY', 10_000n],
      ['USD', 1_000n],
    ]);
  });

  it('numbers receipts without a gap: a refused hand-in takes no number', async () => {
    const { cashier } = await openDesk();
    const { id: captainId } = await captain();
    await custody(captainId, 'custody.collect', 20_000n);
    const handIn = (amount: bigint) =>
      desk.handIn(
        cashier.user,
        { captainId, lines: [{ currency: 'TRY', amount }], idempotencyKey: randomUUID() },
        new Date(),
      );
    const [first] = await handIn(10_000n);
    expect(await refusal(handIn(10_001n))).toBe('above_custody');
    const [second] = await handIn(10_000n);
    expect(sequenceOf(second!.number)).toBe(sequenceOf(first!.number) + 1);
  });

  it('answers a repeat of the same key with the same receipts, and refuses the key with another command', async () => {
    const { cashier } = await openDesk();
    const { id: captainId } = await captain();
    await custody(captainId, 'custody.collect', 30_000n);
    const key = randomUUID();
    const command = {
      captainId,
      lines: [{ currency: 'TRY', amount: 10_000n }],
      idempotencyKey: key,
    };
    const first = await desk.handIn(cashier.user, command, new Date());
    const again = await desk.handIn(cashier.user, command, new Date());
    expect(again.map((receipt) => receipt.id)).toEqual(first.map((receipt) => receipt.id));
    expect(await balances(captainId)).toEqual({ TRY: 20_000n });
    expect(
      await refusal(
        desk.handIn(
          cashier.user,
          { ...command, lines: [{ currency: 'TRY', amount: 5_000n }] },
          new Date(),
        ),
      ),
    ).toBe('idempotency_key_reused');
  });

  it('pays back only what the drawer holds in that currency', async () => {
    const { cashier } = await openDesk();
    const { id: captainId } = await captain();
    await custody(captainId, 'custody.pay_merchant', -60_000n);
    const payBack = (amount: bigint) =>
      desk.handIn(
        cashier.user,
        { captainId, lines: [{ currency: 'TRY', amount }], idempotencyKey: randomUUID() },
        new Date(),
      );
    // The float is 500 ₺.
    expect(await refusal(payBack(60_000n))).toBe('drawer_short');
    await payBack(50_000n);
    expect(await balances(captainId)).toEqual({ TRY: -10_000n });
  });

  it('settles one balance once when two desks record it at the same moment', async () => {
    const [first, second] = await Promise.all([openDesk(), openDesk()]);
    const { id: captainId } = await captain();
    await custody(captainId, 'custody.collect', 41_000n);
    const handIn = (user: DeskUser) =>
      refusal(
        desk.handIn(
          user,
          {
            captainId,
            lines: [{ currency: 'TRY', amount: 41_000n }],
            idempotencyKey: randomUUID(),
          },
          new Date(),
        ),
      );
    const answers = await Promise.all([handIn(first.cashier.user), handIn(second.cashier.user)]);
    expect(answers.sort()).toEqual(['nothing_due', null]);
    expect(await balances(captainId)).toEqual({ TRY: 0n });
  });

  it('answers a hand-in sent twice at once with the same receipts', async () => {
    const { cashier } = await openDesk();
    const { id: captainId } = await captain();
    await custody(captainId, 'custody.collect', 41_000n);
    const command = {
      captainId,
      lines: [{ currency: 'TRY', amount: 41_000n }],
      idempotencyKey: randomUUID(),
    };
    const [one, two] = await Promise.all([
      desk.handIn(cashier.user, command, new Date()),
      desk.handIn(cashier.user, command, new Date()),
    ]);
    expect(two.map((receipt) => receipt.id)).toEqual(one.map((receipt) => receipt.id));
    expect(await balances(captainId)).toEqual({ TRY: 0n });
  });

  it('closes a session only once a running hand-in is done, and refuses one behind a close', async () => {
    const { cashier, session } = await openDesk();
    const { id: captainId } = await captain();
    await custody(captainId, 'custody.collect', 1_000n);
    const counted = [
      { currency: 'TRY', amount: 50_000n },
      { currency: 'USD', amount: 0n },
    ];
    // A hand-in still running holds the session FOR SHARE.
    const running = await sql.connect();
    await running.query('BEGIN');
    await running.query('SELECT id FROM cashdesk.drawer_sessions WHERE id = $1 FOR SHARE', [
      session.id,
    ]);
    let closed = false;
    const close = desk
      .closeSession(cashier.user, session.id, counted, null, new Date())
      .then(() => (closed = true));
    await new Promise((resolve) => setTimeout(resolve, 300));
    expect(closed).toBe(false);
    await running.query('COMMIT');
    running.release();
    await close;
    expect(closed).toBe(true);

    // A close holding the session: the hand-in waiting behind it finds none.
    const other = await openDesk();
    const closing = await sql.connect();
    await closing.query('BEGIN');
    await closing.query('UPDATE cashdesk.drawer_sessions SET closed_at = now() WHERE id = $1', [
      other.session.id,
    ]);
    const handIn = refusal(
      desk.handIn(
        other.cashier.user,
        { captainId, lines: [{ currency: 'TRY', amount: 1_000n }], idempotencyKey: randomUUID() },
        new Date(),
      ),
    );
    await new Promise((resolve) => setTimeout(resolve, 300));
    await closing.query('COMMIT');
    closing.release();
    expect(await handIn).toBe('no_open_session');
    expect(await balances(captainId)).toEqual({ TRY: 1_000n });
  });

  it('needs an open session and a known captain', async () => {
    const cashier = await admin(['FIN']);
    const { id: captainId } = await captain();
    await custody(captainId, 'custody.collect', 1_000n);
    const lines = [{ currency: 'TRY', amount: 1_000n }];
    expect(
      await refusal(
        desk.handIn(cashier.user, { captainId, lines, idempotencyKey: randomUUID() }, new Date()),
      ),
    ).toBe('no_open_session');
    const { cashier: open } = await openDesk();
    expect(
      await refusal(
        desk.handIn(
          open.user,
          { captainId: randomUUID(), lines, idempotencyKey: randomUUID() },
          new Date(),
        ),
      ),
    ).toBe('unknown_captain');
  });
});

// A receipt's journals as posted, its conversions first, read through the
// ledger's service (the module boundary).
async function receiptJournals(receiptId: string) {
  const { rows } = await sql.query<{ journal_id: string }>(
    `SELECT journal_id FROM cashdesk.receipt_conversions WHERE receipt_id = $1
     UNION ALL SELECT journal_id FROM cashdesk.receipt_lines WHERE receipt_id = $1`,
    [receiptId],
  );
  const journals = await ledger.journalLines(rows.map((row) => row.journal_id));
  return rows.map((row) => journals.find((journal) => journal.id === row.journal_id)!);
}

describe('cross-currency settlement (AP §9.10.3, §8.6)', () => {
  it('converts the custody at the rate shown and takes the cash in the other currency', async () => {
    const { cashier, session } = await openDesk();
    const { id: captainId } = await captain();
    // 20.00 USD collected yesterday; the captain pays in lira.
    await custody(captainId, 'custody.collect', 2_000n, 'USD');
    const quote = await desk.quoteConversion(azaz, { from: 'USD', to: 'TRY', amount: 2_000n });
    expect(quote).toMatchObject({
      from: 'USD',
      to: 'TRY',
      amount: 2_000n,
      converted: 80_000n,
      rates: [{ currency: 'USD', rateVersionId: expect.any(String) }],
      unit: { from: 'USD', to: 'TRY', value: '40' },
    });
    const conversion = { from: 'USD', to: 'TRY', amount: 2_000n, converted: 80_000n };
    const [receipt, ...more] = await desk.handIn(
      cashier.user,
      {
        captainId,
        conversions: [{ ...conversion, rates: quote.rates }],
        lines: [{ currency: 'TRY', amount: 80_000n }],
        idempotencyKey: randomUUID(),
      },
      new Date(),
    );
    expect(more).toEqual([]);
    expect(receipt).toMatchObject({
      type: 'captain_hand_in',
      conversions: [conversion],
      // The custody expected after the conversion.
      lines: [{ currency: 'TRY', expected: 80_000n, amount: 80_000n, remaining: 0n }],
    });
    expect(await balances(captainId)).toEqual({ TRY: 0n, USD: 0n });
    expect(
      (await captains.state(captainId, new Date(Date.now() + 2 * day))).custody.closedDue.amount,
    ).toBe(0n);
    expect((await desk.openSessionOf(cashier.user.accountId))!.currencies).toMatchObject([
      { currency: 'TRY', expected: 130_000n },
      { currency: 'USD', expected: 0n },
    ]);

    // One fx_convert journal through platform.fx_rounding, kept with the
    // receipt, whose audit keeps the rate's version.
    const [convert, cash] = await receiptJournals(receipt!.id);
    expect([convert!.type, cash!.type]).toEqual(['custody.fx_convert', 'custody.hand_in']);
    const audit = await sql.query(
      "SELECT changes FROM audit.events WHERE action = 'cash_desk.receipt' AND target_id = $1",
      [receipt!.id],
    );
    expect(audit.rows[0].changes.conversions.after[0].rates).toEqual(quote.rates);
    expect(convert!.entries).toEqual(
      expect.arrayContaining([
        { purpose: 'captain.custody', ownerId: captainId, currency: 'USD', amount: -2_000n },
        { purpose: 'platform.fx_rounding', ownerId: null, currency: 'USD', amount: 2_000n },
        { purpose: 'captain.custody', ownerId: captainId, currency: 'TRY', amount: 80_000n },
        { purpose: 'platform.fx_rounding', ownerId: null, currency: 'TRY', amount: -80_000n },
      ]),
    );
    const pushes = await sql.query(
      "SELECT body FROM notifications.push_messages WHERE source = 'cashdesk:receipt:' || $1",
      [receipt!.id],
    );
    expect(pushes.rows).toEqual([{ body: `إيصال ${receipt!.number}: تسليم نقد 800 ₺` }]);
    expect(session.id).toBe(receipt!.sessionId);
  });

  it('rounds by the target currency and nets what the office owes against what is due', async () => {
    const { cashier } = await openDesk();
    const { id: captainId } = await captain();
    // Owed 10.10 USD back (a pickup payment), due 500 TRY.
    await custody(captainId, 'custody.pay_merchant', -1_010n, 'USD');
    await custody(captainId, 'custody.collect', 50_000n);
    // 10.10 USD = 404 TRY, to the nearest lira.
    const quote = await desk.quoteConversion(azaz, { from: 'USD', to: 'TRY', amount: 1_010n });
    expect(quote.converted).toBe(40_400n);
    const [receipt] = await desk.handIn(
      cashier.user,
      {
        captainId,
        conversions: [
          { from: 'USD', to: 'TRY', amount: 1_010n, converted: 40_400n, rates: quote.rates },
        ],
        lines: [{ currency: 'TRY', amount: 9_600n }],
        idempotencyKey: randomUUID(),
      },
      new Date(),
    );
    expect(receipt!.lines).toEqual([
      { currency: 'TRY', expected: 9_600n, amount: 9_600n, remaining: 0n },
    ]);
    expect(await balances(captainId)).toEqual({ TRY: 0n, USD: 0n });
  });

  it('refuses a rate or amount other than the one shown, and a conversion past the custody', async () => {
    const { cashier } = await openDesk();
    const { id: captainId } = await captain();
    await custody(captainId, 'custody.collect', 2_000n, 'USD');
    const quote = await desk.quoteConversion(azaz, { from: 'USD', to: 'TRY', amount: 2_000n });
    const handIn = (conversion: object, lines = [{ currency: 'TRY', amount: 80_000n }]) =>
      refusal(
        desk.handIn(
          cashier.user,
          {
            captainId,
            conversions: [
              {
                from: 'USD',
                to: 'TRY',
                amount: 2_000n,
                converted: 80_000n,
                rates: quote.rates,
                ...conversion,
              },
            ],
            lines,
            idempotencyKey: randomUUID(),
          },
          new Date(),
        ),
      );
    expect(await handIn({ converted: 79_900n })).toBe('rate_changed');
    expect(await handIn({ amount: 2_001n, converted: 80_000n })).toBe('above_custody');
    expect(await handIn({ from: 'TRY', to: 'TRY' })).toBe('invalid_amounts');
    expect(await handIn({ from: 'TRY', to: 'USD' })).toBe('nothing_due');
    // Nothing changes hands: the conversion alone is no receipt.
    expect(await handIn({}, [])).toBe('invalid_amounts');

    const fx = app.get(FxService);
    const fin = { ...change, actor: { type: 'admin', id: randomUUID(), role: 'FIN' } } as const;
    await fx.setRate(azaz, 'USD', { value: '41', direction: 'base_per_unit' }, fin);
    try {
      expect(await handIn({})).toBe('rate_changed');
    } finally {
      await fx.setRate(azaz, 'USD', { value: '40', direction: 'base_per_unit' }, fin);
    }
    expect(await balances(captainId)).toEqual({ USD: 2_000n });
  });

  it('answers a repeat of a conversion with the same receipt, posting once', async () => {
    const { cashier } = await openDesk();
    const { id: captainId } = await captain();
    await custody(captainId, 'custody.collect', 2_000n, 'USD');
    const quote = await desk.quoteConversion(azaz, { from: 'USD', to: 'TRY', amount: 2_000n });
    const command = {
      captainId,
      conversions: [
        { from: 'USD', to: 'TRY', amount: 2_000n, converted: 80_000n, rates: quote.rates },
      ],
      lines: [{ currency: 'TRY', amount: 80_000n }],
      idempotencyKey: randomUUID(),
    };
    const [first] = await desk.handIn(cashier.user, command, new Date());
    const [again] = await desk.handIn(cashier.user, command, new Date());
    expect(again!.id).toBe(first!.id);
    expect((await receiptJournals(first!.id)).map((journal) => journal.type)).toEqual([
      'custody.fx_convert',
      'custody.hand_in',
    ]);
    expect(await balances(captainId)).toEqual({ TRY: 0n, USD: 0n });
    // The key with another conversion is refused.
    expect(
      await refusal(
        desk.handIn(
          cashier.user,
          {
            ...command,
            conversions: [{ ...command.conversions[0]!, amount: 1_000n, converted: 40_000n }],
          },
          new Date(),
        ),
      ),
    ).toBe('idempotency_key_reused');
  });

  it('quote and record a conversion through the routes', async () => {
    const { cashier } = await openDesk();
    const { id: captainId } = await captain();
    await custody(captainId, 'custody.collect', 2_000n, 'USD');
    const quote = await cashier.post(
      '/v1/admin/cash-desk/conversions/quote',
      { cityId: azaz, from: 'USD', to: 'TRY', amount: '2000' },
      null,
    );
    expect(quote.statusCode).toBe(200);
    expect(quote.json()).toMatchObject({
      converted: '80000',
      unit: { from: 'USD', to: 'TRY', value: '40' },
    });
    const answer = await cashier.post('/v1/admin/cash-desk/hand-ins', {
      captainId,
      conversions: [
        { from: 'USD', to: 'TRY', amount: '2000', converted: '80000', rates: quote.json().rates },
      ],
      lines: [{ currency: 'TRY', amount: '80000' }],
    });
    expect(answer.statusCode).toBe(201);
    expect(answer.json().receipts[0]).toMatchObject({
      conversions: [{ from: 'USD', amount: '2000', to: 'TRY', converted: '80000' }],
    });
    const ops = await admin(['OPS']);
    expect(
      (
        await ops.post(
          '/v1/admin/cash-desk/conversions/quote',
          { cityId: azaz, from: 'USD', to: 'TRY', amount: '2000' },
          null,
        )
      ).statusCode,
    ).toBe(403);
  });
});

describe('the desk routes', () => {
  it('find a captain by name or number and show the custody split', async () => {
    const { cashier } = await openDesk();
    const { id: captainId, phone } = await captain();
    await custody(captainId, 'custody.collect', 41_000n);
    const search = (q: string) =>
      cashier.post('/v1/admin/cash-desk/captains/search', { cityId: azaz, q }, null);
    const byPhone = await search(phone);
    expect(byPhone.statusCode).toBe(200);
    expect(byPhone.json().captains).toEqual([
      expect.objectContaining({ id: captainId, status: 'active' }),
    ]);
    // As the counter types a Syrian mobile: 09…, with spaces.
    const local = `0${phone.slice(4, 7)} ${phone.slice(7)}`;
    expect((await search(local)).json().captains).toEqual([
      expect.objectContaining({ id: captainId }),
    ]);
    const name = (await captains.captain(captainId, new Date()))!.name;
    const byName = await search(name);
    expect(byName.json().captains.map((each: { id: string }) => each.id)).toEqual([captainId]);
    const detail = await cashier.get(`/v1/admin/cash-desk/captains/${captainId}`);
    expect(detail.statusCode).toBe(200);
    expect(detail.json()).toMatchObject({
      id: captainId,
      closedDue: { amount: '0', currency: 'TRY' },
      currencies: [
        {
          currency: 'TRY',
          balance: '41000',
          closedDue: '0',
          today: '41000',
          balanceInBase: '41000',
        },
      ],
    });
  });

  it('record a hand-in with its key, and serve the receipt', async () => {
    const { cashier } = await openDesk();
    const { id: captainId } = await captain();
    await custody(captainId, 'custody.collect', 41_000n);
    const payload = { captainId, lines: [{ currency: 'TRY', amount: '41000' }] };
    expect((await cashier.post('/v1/admin/cash-desk/hand-ins', payload, null)).statusCode).toBe(
      400,
    );
    const answer = await cashier.post('/v1/admin/cash-desk/hand-ins', payload);
    expect(answer.statusCode).toBe(201);
    const [receipt] = answer.json().receipts;
    expect(receipt).toMatchObject({
      type: 'captain_hand_in',
      lines: [{ currency: 'TRY', expected: '41000', amount: '41000', remaining: '0' }],
    });
    const read = await cashier.get(`/v1/admin/cash-desk/receipts/${receipt.id}`);
    expect(read.json()).toMatchObject({ id: receipt.id, number: receipt.number });
    expect(
      (await cashier.post('/v1/admin/cash-desk/hand-ins', { ...payload, captainId: randomUUID() }))
        .statusCode,
    ).toBe(404);
    expect(
      (
        await cashier.post('/v1/admin/cash-desk/hand-ins', {
          captainId,
          lines: [{ currency: 'TRY', amount: '1' }],
        })
      ).json(),
    ).toMatchObject({ statusCode: 409, error: 'nothing_due' });
  });

  it('open and close a session, and show OWN every session', async () => {
    const cashier = await admin(['FIN']);
    const opened = await cashier.post(
      '/v1/admin/cash-desk/sessions',
      { cityId: azaz, floats: [{ currency: 'TRY', amount: '10000' }] },
      null,
    );
    expect(opened.statusCode).toBe(201);
    const current = await cashier.get(`/v1/admin/cash-desk/sessions/current?cityId=${azaz}`);
    expect(current.json().session).toMatchObject({ id: opened.json().id });
    const closed = await cashier.post(
      `/v1/admin/cash-desk/sessions/${opened.json().id}/close`,
      {
        counted: [
          { currency: 'TRY', amount: '10000' },
          { currency: 'USD', amount: '0' },
        ],
        note: null,
      },
      null,
    );
    expect(closed.statusCode).toBe(200);
    expect(closed.json().currencies[0]).toMatchObject({ variance: '0' });
    expect(
      (await cashier.get(`/v1/admin/cash-desk/sessions/current?cityId=${azaz}`)).json(),
    ).toEqual({
      session: null,
      currencies: ['TRY', 'USD'],
    });

    const finList = await cashier.get(`/v1/admin/cash-desk/sessions?cityId=${azaz}`);
    expect(
      finList
        .json()
        .sessions.every(
          (each: { adminAccountId: string }) => each.adminAccountId === cashier.user.accountId,
        ),
    ).toBe(true);
    const owner = await admin(['OWN']);
    const ownList = await owner.get(`/v1/admin/cash-desk/sessions?cityId=${azaz}`);
    expect(
      new Set(
        ownList.json().sessions.map((each: { adminAccountId: string }) => each.adminAccountId),
      ).size,
    ).toBeGreaterThan(1);
    const ops = await admin(['OPS']);
    expect((await ops.get(`/v1/admin/cash-desk/sessions/current?cityId=${azaz}`)).statusCode).toBe(
      403,
    );
  });
});

// The captain app's calls, signed in on a new device.
async function captainHeaders(phone: string) {
  const deviceId = randomUUID();
  await app.inject({ method: 'POST', url: '/v1/captain/auth/code', payload: { phone, deviceId } });
  const code = app.get<DevelopmentCodeSender>(CODE_SENDER).lastCode(phone);
  const answer = await app.inject({
    method: 'POST',
    url: '/v1/captain/auth/sign-in',
    payload: { phone, deviceId, code },
  });
  return { authorization: `Bearer ${answer.json().accessToken}` };
}

describe('«عهدتي» (CA §10.2, AP §9.10.3: receipts appear at once)', () => {
  it('shows the custody per currency, every entry and the receipt the desk just issued', async () => {
    const { id: captainId, phone } = await captain();
    await custody(captainId, 'custody.pay_merchant', -40_000n);
    await custody(captainId, 'custody.collect', 41_000n);
    await custody(captainId, 'custody.collect', 500n, 'USD');
    const headers = await captainHeaders(phone);
    const read = () => app.inject({ method: 'GET', url: '/v1/captain/custody', headers });

    const before = (await read()).json();
    expect(before).toMatchObject({
      limit: { amount: '1000000', currency: 'TRY' },
      warn: false,
      handInGraceUntil: null,
      receipts: [],
    });
    expect(before.currencies.map((each: { currency: string }) => each.currency)).toEqual([
      'TRY',
      'USD',
    ]);
    expect(before.currencies[0]).toEqual({
      currency: 'TRY',
      balance: '1000',
      closedDue: '0',
      today: '1000',
      balanceInBase: '1000',
    });
    expect(before.entries.map((entry: { kind: string }) => entry.kind)).toEqual([
      'collect',
      'collect',
      'pay_merchant',
    ]);
    expect(before.entries[2]).toMatchObject({
      amount: { amount: '-40000', currency: 'TRY' },
      receiptNumber: null,
    });

    const { cashier } = await openDesk();
    const [receipt] = await desk.handIn(
      cashier.user,
      { captainId, lines: [{ currency: 'TRY', amount: 1_000n }], idempotencyKey: randomUUID() },
      new Date(),
    );
    const after = (await read()).json();
    expect(after.currencies[0]).toMatchObject({ currency: 'TRY', balance: '0' });
    expect(after.entries[0]).toMatchObject({
      kind: 'hand_in',
      orderNumber: null,
      receiptNumber: receipt!.number,
      amount: { amount: '-1000', currency: 'TRY' },
    });
    expect(after.receipts).toEqual([
      {
        id: receipt!.id,
        number: receipt!.number,
        type: 'captain_hand_in',
        at: receipt!.createdAt.toISOString(),
        cashierName: expect.any(String),
        conversions: [],
        lines: [{ currency: 'TRY', amount: '1000' }],
      },
    ]);
  });

  it('needs a captain sign-in', async () => {
    const response = await app.inject({ method: 'GET', url: '/v1/captain/custody' });
    expect(response.statusCode).toBe(401);
  });
});

describe('the hand-in grace routes (AP §8.5.4, CA §14 #18)', () => {
  it('grant a grace to one captain or to the city, each by its roles', async () => {
    const [fin, ops, own] = [await admin(['FIN']), await admin(['OPS']), await admin(['OWN'])];
    const { id: captainId } = await captain();
    const one = `/v1/admin/captains/${captainId}/hand-in-grace`;
    expect((await ops.post(one, { reason: 'المكتب مغلق' }, null)).statusCode).toBe(403);
    expect((await fin.post(one, { reason: 'المكتب مغلق' }, null)).json()).toMatchObject({
      statusCode: 409,
      error: 'nothing_due',
    });
    expect((await fin.post(one, { reason: ' ' }, null)).statusCode).toBe(400);
    const bulk = { cityId: azaz, reason: 'المكتب مغلق' };
    expect((await fin.post('/v1/admin/captains/hand-in-grace', bulk, null)).statusCode).toBe(403);
    const granted = await own.post('/v1/admin/captains/hand-in-grace', bulk, null);
    expect(granted.statusCode).toBe(200);
    expect(granted.json()).toMatchObject({ grace: { bulk: true, reason: 'المكتب مغلق' } });
    // A repeat answers the same grace and tells no one.
    const again = await own.post('/v1/admin/captains/hand-in-grace', bulk, null);
    expect(again.json()).toEqual({ ...granted.json(), captainIds: [] });
    expect(
      (await own.post('/v1/admin/captains/hand-in-grace', { ...bulk, cityId: randomUUID() }, null))
        .statusCode,
    ).toBe(404);
  });

  it('tells the captain «مُنحت مهلة حتى {الساعة}», silently', async () => {
    const { id: captainId } = await captain();
    await custody(captainId, 'custody.collect', 41_000n);
    const later = new Date(Date.now() + 2 * day);
    const fin = await admin(['FIN']);
    const grace = await captains.grantGrace(
      captainId,
      { actor: fin.user.actor, context: fin.user.context, reason: 'المكتب مغلق' },
      later,
    );
    const pushes = await sql.query(
      'SELECT body, level FROM notifications.push_messages WHERE source = $1',
      [`captain:captain.hand_in_grace:${grace.id}:${captainId}`],
    );
    const hour = formatTime(grace.until, 'Asia/Damascus');
    expect(pushes.rows).toEqual([{ body: `مُنحت مهلة حتى ${hour}`, level: 'silent' }]);
  });
});

describe('«أرصدة الكباتن» (AP §9.10.2)', () => {
  it('lists each captain with custody, closed_due, limit, block, grace and last hand-in, by custody', async () => {
    const { cashier } = await openDesk();
    const small = await captain();
    const large = await captain();
    await custody(small.id, 'custody.collect', 10_000n);
    await custody(large.id, 'custody.collect', 2_000n, 'USD');
    await custody(large.id, 'custody.collect', 5_000n);
    const later = new Date(Date.now() + 2 * day);
    await desk.handIn(
      cashier.user,
      {
        captainId: small.id,
        lines: [{ currency: 'TRY', amount: 4_000n }],
        idempotencyKey: randomUUID(),
      },
      new Date(),
    );
    await captains.grantGrace(
      large.id,
      { actor: cashier.user.actor, context: cashier.user.context, reason: 'المكتب مغلق' },
      later,
    );

    const list = await desk.balances(azaz, later);
    const ours = list.filter((row) => [small.id, large.id].includes(row.captainId));
    expect(ours.map((row) => row.captainId)).toEqual([large.id, small.id]);
    expect(ours[0]).toMatchObject({
      name: expect.stringContaining('كابتن الصندوق'),
      custody: {
        usage: { amount: 85_000n, currency: 'TRY' },
        closedDue: { amount: 85_000n, currency: 'TRY' },
        limit: { amount: 1_000_000n, currency: 'TRY' },
      },
      blocks: [],
      handInGrace: { bulk: false, reason: 'المكتب مغلق' },
      earnings: { amount: 0n, currency: 'TRY' },
      lastHandInAt: null,
      lastPayoutAt: null,
    });
    expect(ours[0]!.custody.currencies.map((line) => line.currency)).toEqual(['TRY', 'USD']);
    expect(ours[1]).toMatchObject({
      custody: { closedDue: { amount: 6_000n } },
      blocks: ['closed_due'],
      handInGrace: null,
      lastHandInAt: expect.any(Date),
    });
    // Sorted by custody, the highest first, across the whole list.
    const totals = list.map((row) => row.custodyInBase);
    expect(totals).toEqual([...totals].sort((a, b) => (a < b ? 1 : a > b ? -1 : 0)));
  });

  it('serves the list to finance only', async () => {
    const fin = await admin(['FIN']);
    const ops = await admin(['OPS']);
    expect((await ops.get(`/v1/admin/cash-desk/balances?cityId=${azaz}`)).statusCode).toBe(403);
    const answer = await fin.get(`/v1/admin/cash-desk/balances?cityId=${azaz}`);
    expect(answer.statusCode).toBe(200);
    expect(answer.json().captains[0]).toMatchObject({
      captainId: expect.any(String),
      custodyInBase: expect.any(String),
      usage: { currency: 'TRY' },
      blocks: expect.any(Array),
    });
  });
});
