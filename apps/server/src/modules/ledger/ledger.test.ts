import 'reflect-metadata';
import { randomUUID } from 'node:crypto';
import { Test } from '@nestjs/testing';
import pg from 'pg';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { startTestDatabase, type TestDatabase } from '../../database/test-database.js';
import {
  accountPurposeNames,
  journalTypeNames,
  journalTypesWithReason,
  ownedPurposes,
} from './catalogue.js';
import {
  LedgerModule,
  LedgerRefusal,
  LedgerService,
  LedgerWorkerModule,
  type PostJournal,
} from './index.js';

// The ledger module on a fresh database, connected as the application role
// through DATABASE_URL, as the server connects.
let database: TestDatabase;
let ledger: LedgerService;
let db: Database['db'];
let pool: Database['pool'];
let close: () => Promise<void>;

beforeAll(async () => {
  database = await startTestDatabase();
  process.env.DATABASE_URL = database.appUrl;
  const moduleRef = await Test.createTestingModule({ imports: [LedgerModule] }).compile();
  await moduleRef.init();
  ledger = moduleRef.get(LedgerService);
  ({ db, pool } = moduleRef.get<Database>(DATABASE, { strict: false }));
  close = () => moduleRef.close();
}, 300_000);

afterAll(async () => {
  await close?.();
  await database?.stop();
});

const system = { type: 'system', id: null } as const;

// A city of its own for each test, so balances never mix.
async function setUp() {
  const cityId = randomUUID();
  const captainId = randomUUID();
  const open = (
    purpose: (typeof accountPurposeNames)[number],
    currency = 'TRY',
    ownerId: string | null = null,
  ) => ledger.openAccount({ cityId, purpose, ownerId, currency });
  return {
    cityId,
    captainId,
    custody: await open('captain.custody', 'TRY', captainId),
    custodyUsd: await open('captain.custody', 'USD', captainId),
    earnings: await open('captain.earnings', 'TRY', captainId),
    clearing: await open('platform.order_clearing'),
    captainPay: await open('platform.captain_pay'),
    drawer: await open('platform.cash', 'TRY', randomUUID()),
    open,
  };
}

function pickup(
  cityId: string,
  custody: string,
  clearing: string,
  amounts: [bigint, bigint] = [-400n, 400n],
): PostJournal {
  return {
    cityId,
    type: 'custody.pay_merchant',
    source: { kind: 'order', id: randomUUID() },
    actor: system,
    entries: [
      { accountId: custody, currency: 'TRY', amount: amounts[0] },
      { accountId: clearing, currency: 'TRY', amount: amounts[1] },
    ],
  };
}

const post = (journal: PostJournal) => db.transaction((tx) => ledger.post(journal, tx));

describe('the catalogue', () => {
  it('has every entry type of AP §8.5 and §8.7, the platform types of §8.11, and no other', () => {
    expect([...journalTypeNames].sort()).toEqual(
      [
        'custody.collect',
        'custody.change_given',
        'custody.pay_merchant',
        'custody.hand_in',
        'custody.reimburse',
        'custody.fx_convert',
        'custody.pickup_correction',
        'custody.adjustment',
        'earn.order_pay',
        'earn.waiting_pay',
        'earn.peak_bonus',
        'earn.bonus',
        'earn.charge',
        'earn.deposit_instalment',
        'earn.payout',
        'earn.adjustment',
        'merchant.commission',
        'merchant.discount_share',
        'merchant.credit',
        'merchant.debit',
        'merchant.settlement',
        'merchant.adjustment',
        'platform.revenue_delivery',
        'platform.discount_cost',
        'platform.compensation_cost',
        'platform.operating_cost',
        'platform.test_cost',
        'platform.fx_rounding',
      ].sort(),
    );
  });

  it('has every platform account of AP §8.11', () => {
    expect(accountPurposeNames).toEqual(
      expect.arrayContaining([
        'platform.revenue_commission',
        'platform.revenue_delivery',
        'platform.discount_cost',
        'platform.compensation_cost',
        'platform.operating_cost',
        'platform.captain_pay',
        'platform.fx_rounding',
        'platform.test_cost',
      ]),
    );
  });

  it('is exactly what the database accepts', async () => {
    const { rows } = await pool.query<{ conname: string; definition: string }>(
      `SELECT conname, pg_get_constraintdef(oid) AS definition FROM pg_constraint
        WHERE conname IN ('journals_type_values', 'journals_reason_required',
                          'accounts_purpose_values', 'accounts_owner_present')`,
    );
    const listed = (name: string) =>
      [...(rows.find((row) => row.conname === name)?.definition ?? '').matchAll(/'([a-z_.]+)'/g)]
        .map((match) => match[1])
        .sort();
    expect(listed('journals_type_values')).toEqual([...journalTypeNames].sort());
    expect(listed('journals_reason_required')).toEqual([...journalTypesWithReason].sort());
    expect(listed('accounts_purpose_values')).toEqual([...accountPurposeNames].sort());
    expect(listed('accounts_owner_present')).toEqual([...ownedPurposes].sort());
  });
});

describe('LedgerWorkerModule', () => {
  // Next month's partition, dropped by the migration role so the worker has to
  // create it, as it will every month.
  const next = new Date();
  next.setUTCDate(1);
  next.setUTCMonth(next.getUTCMonth() + 1);
  const nextPartition = `ledger.entries_${next.toISOString().slice(0, 7).replace('-', '_')}`;

  it('creates the next entries partition, append-only like the others', async () => {
    const migrator = new pg.Client({ connectionString: database.migratorUrl });
    await migrator.connect();
    await migrator.query(`DROP TABLE ${nextPartition}`);
    await migrator.end();

    const moduleRef = await Test.createTestingModule({ imports: [LedgerWorkerModule] }).compile();
    await moduleRef.init();
    await moduleRef.close();

    const { rows } = await pool.query(
      `SELECT pg_get_userbyid(relowner) AS owner,
              has_table_privilege('fox_drop_app', oid, 'INSERT') AS can_insert,
              has_table_privilege('fox_drop_app', oid, 'UPDATE') AS can_update,
              has_table_privilege('fox_drop_app', oid, 'DELETE') AS can_delete
         FROM pg_class WHERE oid = $1::regclass`,
      [nextPartition],
    );
    expect(rows).toEqual([
      { owner: 'fox_drop_migrator', can_insert: true, can_update: false, can_delete: false },
    ]);
  });
});

describe('LedgerService.openAccount', () => {
  it('gives the same account for the same city, purpose, owner and currency', async () => {
    const { cityId, captainId, custody, open } = await setUp();

    expect(await open('captain.custody', 'TRY', captainId)).toBe(custody);
    expect(await open('captain.custody', 'USD', captainId)).not.toBe(custody);
    expect(await open('platform.order_clearing')).toBe(await open('platform.order_clearing'));
    expect(
      await ledger.openAccount({
        cityId: randomUUID(),
        purpose: 'captain.custody',
        ownerId: captainId,
        currency: 'TRY',
      }),
    ).not.toBe(custody);
    expect(cityId).toBeDefined();
  });

  it.each([
    ['a captain account without its captain', 'captain.custody', null, 'TRY'],
    ['a city platform account with an owner', 'platform.revenue_delivery', randomUUID(), 'TRY'],
    ['a drawer without its drawer', 'platform.cash', null, 'TRY'],
    ['a currency that is not a code', 'platform.revenue_delivery', null, 'try'],
  ] as const)('refuses %s', async (_, purpose, ownerId, currency) => {
    await expect(
      ledger.openAccount({ cityId: randomUUID(), purpose, ownerId, currency }),
    ).rejects.toThrow(LedgerRefusal);
  });
});

describe('LedgerService.post', () => {
  it('posts a balanced journal and a balance is the sum of its entries', async () => {
    const { cityId, custody, clearing } = await setUp();

    await post(pickup(cityId, custody, clearing));
    await post(pickup(cityId, custody, clearing, [410n, -410n]));

    expect(await ledger.balance(custody)).toEqual({ currency: 'TRY', amount: 10n });
    expect(await ledger.balance(clearing)).toEqual({ currency: 'TRY', amount: -10n });
  });

  it("shows a balance from the party's view", async () => {
    const { cityId, earnings, captainPay } = await setUp();

    await post({
      cityId,
      type: 'earn.order_pay',
      source: { kind: 'order', id: randomUUID() },
      actor: system,
      entries: [
        { accountId: earnings, currency: 'TRY', amount: -35n },
        { accountId: captainPay, currency: 'TRY', amount: 35n },
      ],
    });

    // The platform owes the captain 35 (AP §8.5.2) and paid 35 in captain pay.
    expect(await ledger.balance(earnings)).toEqual({ currency: 'TRY', amount: 35n });
    expect(await ledger.balance(captainPay)).toEqual({ currency: 'TRY', amount: 35n });
  });

  it('gives a zero balance to an account without entries', async () => {
    const { earnings } = await setUp();
    expect(await ledger.balance(earnings)).toEqual({ currency: 'TRY', amount: 0n });
  });

  it("commits and rolls back with the caller's transaction", async () => {
    const { cityId, custody, clearing } = await setUp();

    await expect(
      db.transaction(async (tx) => {
        await ledger.post(pickup(cityId, custody, clearing), tx);
        throw new Error('the order change failed');
      }),
    ).rejects.toThrow('the order change failed');

    expect(await ledger.balance(custody)).toEqual({ currency: 'TRY', amount: 0n });
  });

  it('refuses a journal that does not balance to zero', async () => {
    const { cityId, custody, clearing } = await setUp();
    await expect(post(pickup(cityId, custody, clearing, [-400n, 390n]))).rejects.toThrow(
      LedgerRefusal,
    );
  });

  it('refuses a journal that balances overall but not in each currency', async () => {
    const { cityId, custody, custodyUsd, open } = await setUp();
    const fxTry = await open('platform.fx_rounding');
    const fxUsd = await open('platform.fx_rounding', 'USD');
    await expect(
      post({
        cityId,
        type: 'custody.fx_convert',
        source: null,
        actor: system,
        entries: [
          { accountId: custodyUsd, currency: 'USD', amount: -10n },
          { accountId: fxUsd, currency: 'USD', amount: -5n },
          { accountId: custody, currency: 'TRY', amount: 10n },
          { accountId: fxTry, currency: 'TRY', amount: 5n },
        ],
      }),
    ).rejects.toThrow(/does not balance to zero in currency USD/);
  });

  it.each([
    ['a fraction', 400.5],
    ['a number instead of minor units as an integer', 400],
  ])('refuses an amount that is %s', async (_, amount) => {
    const { cityId, custody, clearing } = await setUp();
    const journal = pickup(cityId, custody, clearing);
    journal.entries[0]!.amount = -amount as unknown as bigint;
    journal.entries[1]!.amount = amount as unknown as bigint;
    await expect(post(journal)).rejects.toThrow(LedgerRefusal);
  });

  it('refuses an entry of zero', async () => {
    const { cityId, custody, clearing } = await setUp();
    const journal = pickup(cityId, custody, clearing);
    journal.entries.push({ accountId: clearing, currency: 'TRY', amount: 0n });
    await expect(post(journal)).rejects.toThrow(LedgerRefusal);
  });

  it("refuses an amount in another currency than its account's", async () => {
    const { cityId, custodyUsd, clearing } = await setUp();
    const journal = pickup(cityId, custodyUsd, clearing);
    await expect(post(journal)).rejects.toThrow(/currency/);
  });

  it('refuses an account of another city', async () => {
    const { custody, clearing } = await setUp();
    await expect(post(pickup(randomUUID(), custody, clearing))).rejects.toThrow(/city/);
  });

  it('refuses an account that does not exist', async () => {
    const { cityId, custody } = await setUp();
    await expect(post(pickup(cityId, custody, randomUUID()))).rejects.toThrow(LedgerRefusal);
  });

  it("refuses an account that cannot take the type's other side", async () => {
    const { cityId, custody, drawer } = await setUp();
    await expect(post(pickup(cityId, custody, drawer))).rejects.toThrow(/platform\.cash/);
  });

  it('refuses a journal without the account its type is named for', async () => {
    const { cityId, clearing } = await setUp();
    await expect(post(pickup(cityId, clearing, clearing))).rejects.toThrow(
      /needs an entry on captain\.custody/,
    );
  });

  it('refuses one journal on the accounts of two captains', async () => {
    const { cityId, custody, clearing, open } = await setUp();
    const otherCustody = await open('captain.custody', 'TRY', randomUUID());
    const journal = pickup(cityId, custody, clearing, [-400n, 800n]);
    journal.entries.push({ accountId: otherCustody, currency: 'TRY', amount: -400n });
    await expect(post(journal)).rejects.toThrow(/owner/);
  });

  it('refuses the order clearing account outside an order', async () => {
    const { cityId, custody, clearing } = await setUp();
    await expect(post({ ...pickup(cityId, custody, clearing), source: null })).rejects.toThrow(
      /order/,
    );
  });

  it('refuses a manual correction without a reason', async () => {
    const { cityId, custody, open } = await setUp();
    const adjustments = await open('platform.adjustments');
    const correction: PostJournal = {
      cityId,
      type: 'custody.adjustment',
      source: null,
      actor: { type: 'admin', id: randomUUID() },
      reason: '  ',
      entries: [
        { accountId: custody, currency: 'TRY', amount: 5n },
        { accountId: adjustments, currency: 'TRY', amount: -5n },
      ],
    };
    await expect(post(correction)).rejects.toThrow(/reason/);

    await post({ ...correction, reason: 'Counted 5 more at the desk' });
    expect(await ledger.balance(custody)).toEqual({ currency: 'TRY', amount: 5n });
  });

  it.each([
    ['custody.hand_in', 'without a drawer', 'adjustments'],
    ['earn.payout', 'into exchange instead of a drawer', 'fxRounding'],
  ] as const)('refuses %s %s', async (type, _, counter) => {
    const { cityId, custody, earnings, open } = await setUp();
    const accounts = {
      adjustments: await open('platform.adjustments'),
      fxRounding: await open('platform.fx_rounding'),
    };
    const own = type === 'earn.payout' ? earnings : custody;
    await expect(
      post({
        cityId,
        type,
        source: null,
        actor: { type: 'admin', id: randomUUID() },
        entries: [
          { accountId: own, currency: 'TRY', amount: -10n },
          { accountId: accounts[counter], currency: 'TRY', amount: 10n },
        ],
      }),
    ).rejects.toThrow(/platform\.cash|between two currencies|cannot take/);
  });

  it('converts custody between two currencies through exchange, and only between two', async () => {
    const { cityId, custody, custodyUsd, open } = await setUp();
    const fxTry = await open('platform.fx_rounding');
    const fxUsd = await open('platform.fx_rounding', 'USD');
    const convert = (lines: [string, string, bigint][]) =>
      post({
        cityId,
        type: 'custody.fx_convert',
        source: null,
        actor: { type: 'admin', id: randomUUID() },
        entries: lines.map(([accountId, currency, amount]) => ({ accountId, currency, amount })),
      });

    await expect(
      convert([
        [custody, 'TRY', -400n],
        [fxTry, 'TRY', 400n],
      ]),
    ).rejects.toThrow(/two currencies/);

    // 10 USD of custody becomes 350 TRY of custody at the desk's rate.
    await convert([
      [custodyUsd, 'USD', -1000n],
      [fxUsd, 'USD', 1000n],
      [custody, 'TRY', 35000n],
      [fxTry, 'TRY', -35000n],
    ]);
    expect(await ledger.balance(custody)).toEqual({ currency: 'TRY', amount: 35000n });
    expect(await ledger.balance(custodyUsd)).toEqual({ currency: 'USD', amount: -1000n });
  });

  it('refuses a manual bonus without a reason', async () => {
    const { cityId, earnings, captainPay } = await setUp();
    await expect(
      post({
        cityId,
        type: 'earn.bonus',
        source: null,
        actor: { type: 'admin', id: randomUUID() },
        entries: [
          { accountId: earnings, currency: 'TRY', amount: -50n },
          { accountId: captainPay, currency: 'TRY', amount: 50n },
        ],
      }),
    ).rejects.toThrow(/reason/);
  });

  it.each([
    ['the system with an id', { type: 'system', id: randomUUID() }],
    ['an admin without an id', { type: 'admin', id: null }],
    ['an id that is not a UUID', { type: 'admin', id: 'owner' }],
  ] as const)('refuses an actor that is %s', async (_, actor) => {
    const { cityId, custody, clearing } = await setUp();
    await expect(post({ ...pickup(cityId, custody, clearing), actor })).rejects.toThrow(
      LedgerRefusal,
    );
  });

  // AP §8.9, captain responsible: the pickup payment comes back as the
  // captain's charge of the merchant net and the restaurant's commission.
  it('settles a failed order on the order clearing account', async () => {
    const { cityId, custody, earnings, clearing, open } = await setUp();
    const restaurant = await open('merchant.account', 'TRY', randomUUID());
    const journal = pickup(cityId, custody, clearing);
    await post(journal);
    const onOrder = (type: PostJournal['type'], account: string, amount: bigint) =>
      post({
        ...journal,
        type,
        entries: [
          { accountId: account, currency: 'TRY', amount },
          { accountId: clearing, currency: 'TRY', amount: -amount },
        ],
      });

    await onOrder('earn.charge', earnings, 340n);
    await onOrder('merchant.commission', restaurant, 60n);

    expect(await ledger.balance(clearing)).toEqual({ currency: 'TRY', amount: 0n });
    expect(await ledger.balance(earnings)).toEqual({ currency: 'TRY', amount: -340n });
  });
});

describe('LedgerService.ownerAccounts', () => {
  it("lists one owner's accounts of a purpose, one per currency", async () => {
    const { cityId, captainId, custody, custodyUsd } = await setUp();
    const listed = await ledger.ownerAccounts(cityId, captainId, 'captain.custody');
    expect(listed.sort((a, b) => a.currency.localeCompare(b.currency))).toEqual([
      { id: custody, currency: 'TRY' },
      { id: custodyUsd, currency: 'USD' },
    ]);
    expect(await ledger.ownerAccounts(cityId, randomUUID(), 'captain.custody')).toEqual([]);
    expect(await ledger.ownerAccounts(randomUUID(), captainId, 'captain.custody')).toEqual([]);
  });
});

describe('LedgerService.balanceAt', () => {
  // The database clock between two posts: entries carry their transaction's
  // time.
  const databaseNow = async () =>
    (await pool.query<{ now: Date }>('SELECT clock_timestamp() AS now')).rows[0]!.now;

  it('sums the entries before a moment and the given types posted since (AP §8.5.4)', async () => {
    const { cityId, custody, clearing, drawer } = await setUp();
    await post(pickup(cityId, custody, clearing, [410n, -410n]));
    const cutoff = await databaseNow();
    await post(pickup(cityId, custody, clearing, [250n, -250n]));
    await post({
      cityId,
      type: 'custody.hand_in',
      source: null,
      actor: system,
      entries: [
        { accountId: custody, currency: 'TRY', amount: -100n },
        { accountId: drawer, currency: 'TRY', amount: 100n },
      ],
    });

    expect(await ledger.balanceAt(custody, cutoff, [])).toEqual({ currency: 'TRY', amount: 410n });
    expect(await ledger.balanceAt(custody, cutoff, ['custody.hand_in'])).toEqual({
      currency: 'TRY',
      amount: 310n,
    });
    expect(await ledger.balance(custody)).toEqual({ currency: 'TRY', amount: 560n });
  });
});

describe('LedgerService.reverse', () => {
  it('cancels a journal entry by entry, once, with a reason', async () => {
    const { cityId, custody, clearing } = await setUp();
    const original = await post(pickup(cityId, custody, clearing));
    const admin = { type: 'admin', id: randomUUID() } as const;
    const reverse = (reason: string) =>
      db.transaction((tx) => ledger.reverse(original, { actor: admin, reason }, tx));

    await expect(reverse(' ')).rejects.toThrow(/reason/);
    await reverse('The pickup was recorded twice');
    expect(await ledger.balance(custody)).toEqual({ currency: 'TRY', amount: 0n });
    expect(await ledger.balance(clearing)).toEqual({ currency: 'TRY', amount: 0n });

    await expect(reverse('Again')).rejects.toThrow(/already reversed/);
  });

  it('refuses a journal that does not exist', async () => {
    await expect(
      db.transaction((tx) =>
        ledger.reverse(randomUUID(), { actor: system, reason: 'Wrong entry' }, tx),
      ),
    ).rejects.toThrow(LedgerRefusal);
  });
});
