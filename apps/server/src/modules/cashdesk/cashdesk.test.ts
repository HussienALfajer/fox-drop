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
} from '../identity/index.js';
import { type JournalType, LedgerService } from '../ledger/index.js';
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

describe('the desk routes', () => {
  it('find a captain by name or number and show the custody split', async () => {
    const { cashier } = await openDesk();
    const { id: captainId, phone } = await captain();
    await custody(captainId, 'custody.collect', 41_000n);
    const byPhone = await cashier.get(
      `/v1/admin/cash-desk/captains?cityId=${azaz}&q=${encodeURIComponent(phone)}`,
    );
    expect(byPhone.statusCode).toBe(200);
    expect(byPhone.json().captains).toEqual([
      expect.objectContaining({ id: captainId, status: 'active' }),
    ]);
    const name = (await captains.captain(captainId, new Date()))!.name;
    const byName = await cashier.get(
      `/v1/admin/cash-desk/captains?cityId=${azaz}&q=${encodeURIComponent(name)}`,
    );
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
