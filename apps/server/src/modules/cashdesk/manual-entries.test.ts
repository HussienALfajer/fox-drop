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
  CODE_SENDER,
  type DevelopmentCodeSender,
} from '../identity/index.js';
import { type AccountPurpose, type JournalType, LedgerService } from '../ledger/index.js';
import { MerchantsService } from '../merchants/index.js';

// AP §9.10.7 «القيود التصحيحية» (slice 2.20c): OWN and FIN post a manual
// entry with a reason on a captain's custody or earnings, a restaurant's
// account or a customer's dues (AP §8.8 dues.adjustment), reverse an existing
// entry linked to it, and list every manual entry with who, when, why and
// what it corrects. Nothing is deleted.
vi.setConfig({ testTimeout: 30_000 });

let database: TestDatabase;
let cache: TestValkey;
let app: NestFastifyApplication;
let sql: pg.Pool;
let db: Database;
let azaz: string;
let ledger: LedgerService;
let captains: CaptainsService;
let merchants: MerchantsService;

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
  await fx.setCityCurrency(azaz, { currency: 'USD', displayOrder: 2, enabled: false }, change);
  await fx.setRate(
    azaz,
    'USD',
    { value: '40', direction: 'base_per_unit' },
    { ...change, actor: { type: 'admin', id: randomUUID(), role: 'FIN' } },
  );
  await fx.setCityCurrency(azaz, { currency: 'USD', displayOrder: 2, enabled: true }, change);
  ledger = app.get(LedgerService);
  captains = app.get(CaptainsService);
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
  const name = `Finance ${accounts}`;
  const { rows } = await sql.query(
    `INSERT INTO identity.admin_accounts (name, email, status, password_hash, totp_secret_encrypted)
     VALUES ($1, $2, 'active', 'not used', 'not used') RETURNING id`,
    [name, `manual-entries${accounts}@example.test`],
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
  return {
    accountId,
    name,
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

let captainCount = 0;
async function captain() {
  captainCount += 1;
  return captains.createCaptain(
    azaz,
    {
      name: `كابتن القيود ${captainCount}`,
      vehicle: 'walking',
      custodyLimit: { amount: 1_000_000n, currency: 'TRY' },
    },
    change,
  );
}

async function restaurant() {
  const id = await merchants.createRestaurant(
    azaz,
    {
      nameAr: `مطعم القيود ${randomUUID()}`,
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

async function customer() {
  const phone = `+9639${randomInt(100_000_000).toString().padStart(8, '0')}`;
  const deviceId = randomUUID();
  await app.inject({
    method: 'POST',
    url: '/v1/customer/auth/code',
    payload: { phone, deviceId },
  });
  const code = app.get<DevelopmentCodeSender>(CODE_SENDER).lastCode(phone);
  const answer = await app.inject({
    method: 'POST',
    url: '/v1/customer/auth/sign-in',
    payload: { phone, deviceId, code },
  });
  expect(answer.statusCode).toBe(200);
  const sub = JSON.parse(
    Buffer.from(answer.json().accessToken.split('.')[1], 'base64url').toString(),
  ).sub as string;
  return { id: sub, phone };
}

// A journal of the system on one party account, against the counter-account
// its type takes: + to the party, from its side.
async function post(
  type: JournalType,
  purpose: AccountPurpose,
  ownerId: string,
  counter: AccountPurpose,
  platformSide: bigint,
  orderId: string | null = null,
) {
  return db.db.transaction(async (tx) => {
    const own = await ledger.openAccount({ cityId: azaz, purpose, ownerId, currency: 'TRY' }, tx);
    const other = await ledger.openAccount(
      { cityId: azaz, purpose: counter, ownerId: null, currency: 'TRY' },
      tx,
    );
    return ledger.post(
      {
        cityId: azaz,
        type,
        source: orderId ? { kind: 'order', id: orderId } : null,
        actor: { type: 'system', id: null },
        entries: [
          { accountId: own, currency: 'TRY', amount: platformSide },
          { accountId: other, currency: 'TRY', amount: -platformSide },
        ],
      },
      tx,
    );
  });
}

async function balanceOf(purpose: AccountPurpose, ownerId: string, currency = 'TRY') {
  const [account] = (await ledger.ownerAccounts(azaz, ownerId, purpose)).filter(
    (each) => each.currency === currency,
  );
  return account ? (await ledger.balance(account.id)).amount : 0n;
}

const adjustment = (fields: object) => ({
  cityId: azaz,
  currency: 'TRY',
  reason: 'تصحيح خطأ إدخال',
  ...fields,
});

describe('a manual entry and its reversal (AP §9.10.7)', () => {
  it("adjusts a captain's earnings, reverses it, and lists both linked", async () => {
    const owner = await admin(['OWN']);
    const captainId = await captain();

    const posted = await owner.post(
      '/v1/admin/manual-entries',
      adjustment({
        party: 'captain',
        partyId: captainId,
        account: 'captain.earnings',
        amount: '50000',
        reason: 'مكافأة نسيت',
      }),
    );
    expect(posted.statusCode).toBe(201);
    const entry = posted.json();
    expect(entry).toMatchObject({
      kind: 'adjustment',
      partyKind: 'captain',
      partyId: captainId,
      partyName: `كابتن القيود ${captainCount}`,
      reason: 'مكافأة نسيت',
      adminId: owner.accountId,
      adminName: owner.name,
      corrects: null,
      reversedBy: null,
      reversible: true,
      journal: {
        type: 'earn.adjustment',
        reason: 'مكافأة نسيت',
        lines: [{ purpose: 'captain.earnings', currency: 'TRY', amount: '50000' }],
        manualEntryId: entry.id,
      },
    });
    expect(await balanceOf('captain.earnings', captainId)).toBe(50_000n);

    const reversed = await owner.post('/v1/admin/manual-entries/reversals', {
      cityId: azaz,
      journalId: entry.journal.journalId,
      reason: 'المكافأة صُرفت سابقاً',
    });
    expect(reversed.statusCode).toBe(201);
    const reversal = reversed.json();
    expect(reversal).toMatchObject({
      kind: 'reversal',
      partyKind: 'captain',
      partyId: captainId,
      reason: 'المكافأة صُرفت سابقاً',
      reversible: false,
      journal: {
        type: 'earn.adjustment',
        lines: [{ purpose: 'captain.earnings', currency: 'TRY', amount: '-50000' }],
      },
      corrects: { journalId: entry.journal.journalId, manualEntryId: entry.id },
    });
    expect(await balanceOf('captain.earnings', captainId)).toBe(0n);

    const list = (await owner.get(`/v1/admin/manual-entries?cityId=${azaz}`)).json().entries;
    const [first, second] = [
      list.find((each: { id: string }) => each.id === reversal.id),
      list.find((each: { id: string }) => each.id === entry.id),
    ];
    expect(list.indexOf(first)).toBeLessThan(list.indexOf(second));
    expect(second).toMatchObject({
      reversible: false,
      reversedBy: { journalId: reversal.journal.journalId, manualEntryId: reversal.id },
    });
    expect(first.corrects.manualEntryId).toBe(entry.id);

    const again = await owner.post('/v1/admin/manual-entries/reversals', {
      cityId: azaz,
      journalId: entry.journal.journalId,
      reason: 'مرة ثانية',
    });
    expect(again.statusCode).toBe(409);
    expect(again.json().error).toBe('already_reversed');
    const ofReversal = await owner.post('/v1/admin/manual-entries/reversals', {
      cityId: azaz,
      journalId: reversal.journal.journalId,
      reason: 'عكس العكس',
    });
    expect(ofReversal.statusCode).toBe(409);
    expect(ofReversal.json().error).toBe('not_reversible');

    const { rows } = await sql.query(
      `SELECT action, actor_id FROM audit.events WHERE target_id = ANY($1) ORDER BY action`,
      [[entry.id, reversal.id]],
    );
    expect(rows).toEqual([
      { action: 'ledger.manual_adjustment', actor_id: owner.accountId },
      { action: 'ledger.reversal', actor_id: owner.accountId },
    ]);
  });

  it("adjusts a captain's custody in any enabled currency, the others in the base", async () => {
    const finance = await admin(['FIN']);
    const captainId = await captain();
    const custody = await finance.post(
      '/v1/admin/manual-entries',
      adjustment({
        party: 'captain',
        partyId: captainId,
        account: 'captain.custody',
        currency: 'USD',
        amount: '-2000',
      }),
    );
    expect(custody.statusCode).toBe(201);
    expect(await balanceOf('captain.custody', captainId, 'USD')).toBe(-2000n);

    const earningsInUsd = await finance.post(
      '/v1/admin/manual-entries',
      adjustment({
        party: 'captain',
        partyId: captainId,
        account: 'captain.earnings',
        currency: 'USD',
        amount: '100',
      }),
    );
    expect(earningsInUsd.statusCode).toBe(400);
    expect(earningsInUsd.json().error).toBe('invalid_currency');
  });

  it("adjusts a restaurant's account and a customer's dues (AP §8.8)", async () => {
    const finance = await admin(['FIN']);
    const restaurantId = await restaurant();
    const toRestaurant = await finance.post(
      '/v1/admin/manual-entries',
      adjustment({
        party: 'restaurant',
        partyId: restaurantId,
        account: 'merchant.account',
        amount: '-3000',
      }),
    );
    expect(toRestaurant.statusCode).toBe(201);
    expect(toRestaurant.json().journal.type).toBe('merchant.adjustment');
    expect(await balanceOf('merchant.account', restaurantId)).toBe(-3000n);

    const buyer = await customer();
    // AP §8.8: dues are read in their city, so a customer without dues here
    // takes no adjustment (decided by us).
    const noDues = await finance.post(
      '/v1/admin/manual-entries',
      adjustment({ party: 'customer', partyId: buyer.id, account: 'customer.dues', amount: '-1' }),
    );
    expect(noDues.statusCode).toBe(404);
    expect(noDues.json().error).toBe('unknown_party');
    // The customer owes 24 400 from a fake order; a correction clears it.
    await post('dues.charge', 'customer.dues', buyer.id, 'platform.revenue_delivery', 24_400n);
    const cleared = await finance.post(
      '/v1/admin/manual-entries',
      adjustment({
        party: 'customer',
        partyId: buyer.id,
        account: 'customer.dues',
        amount: '-24400',
      }),
    );
    expect(cleared.statusCode).toBe(201);
    expect(cleared.json().journal).toMatchObject({
      type: 'dues.adjustment',
      lines: [{ purpose: 'customer.dues', currency: 'TRY', amount: '-24400' }],
    });
    expect(await balanceOf('customer.dues', buyer.id)).toBe(0n);
  });

  it('refuses zero, an unknown party and an account the party has not', async () => {
    const finance = await admin(['FIN']);
    const captainId = await captain();
    const zero = await finance.post(
      '/v1/admin/manual-entries',
      adjustment({
        party: 'captain',
        partyId: captainId,
        account: 'captain.earnings',
        amount: '0',
      }),
    );
    expect(zero.json().error).toBe('invalid_amounts');
    const unknown = await finance.post(
      '/v1/admin/manual-entries',
      adjustment({
        party: 'captain',
        partyId: randomUUID(),
        account: 'captain.earnings',
        amount: '10',
      }),
    );
    expect(unknown.statusCode).toBe(404);
    expect(unknown.json().error).toBe('unknown_party');
    const notTheirs = await finance.post(
      '/v1/admin/manual-entries',
      adjustment({
        party: 'captain',
        partyId: captainId,
        account: 'merchant.account',
        amount: '1',
      }),
    );
    expect(notTheirs.statusCode).toBe(400);
    expect(notTheirs.json().error).toBe('invalid_account');
    const noReason = await finance.post(
      '/v1/admin/manual-entries',
      adjustment({
        party: 'captain',
        partyId: captainId,
        account: 'captain.earnings',
        amount: '1',
        reason: '  ',
      }),
    );
    expect(noReason.statusCode).toBe(400);
  });

  it("reverses a manual entry but not an order's or a receipt's journal (decided by us)", async () => {
    const finance = await admin(['FIN']);
    const captainId = await captain();
    // «تغيير النتيجة» reverses an order's journals itself (AP §8.9).
    const pay = await post(
      'earn.order_pay',
      'captain.earnings',
      captainId,
      'platform.captain_pay',
      -9000n,
      randomUUID(),
    );
    const pickup = await post(
      'custody.pay_merchant',
      'captain.custody',
      captainId,
      'platform.order_clearing',
      -40_000n,
      randomUUID(),
    );
    const manual = (
      await finance.post(
        '/v1/admin/manual-entries',
        adjustment({
          party: 'captain',
          partyId: captainId,
          account: 'captain.earnings',
          amount: '-1000',
        }),
      )
    ).json();

    const view = (
      await finance.get(
        `/v1/admin/manual-entries/account?cityId=${azaz}&party=captain&partyId=${captainId}&account=captain.earnings`,
      )
    ).json();
    expect(view.balances).toEqual([{ currency: 'TRY', amount: '8000' }]);
    expect(view.currencies).toEqual(['TRY']);
    expect(view.entries).toMatchObject([
      { journalId: manual.journal.journalId, reversible: true, reversed: false },
      { journalId: pay, type: 'earn.order_pay', reversible: false, reversed: false },
    ]);
    const custodyView = (
      await finance.get(
        `/v1/admin/manual-entries/account?cityId=${azaz}&party=captain&partyId=${captainId}&account=captain.custody`,
      )
    ).json();
    expect(custodyView.currencies).toEqual(['TRY', 'USD']);
    expect(custodyView.entries).toMatchObject([{ journalId: pickup, reversible: false }]);

    for (const journalId of [pay, pickup]) {
      const refused = await finance.post('/v1/admin/manual-entries/reversals', {
        cityId: azaz,
        journalId,
        reason: 'خطأ',
      });
      expect(refused.statusCode).toBe(409);
      expect(refused.json().error).toBe('not_reversible');
    }

    // Two reversals at once: one reverses, the other finds it reversed.
    const both = await Promise.all(
      ['أولى', 'ثانية'].map((reason) =>
        finance.post('/v1/admin/manual-entries/reversals', {
          cityId: azaz,
          journalId: manual.journal.journalId,
          reason,
        }),
      ),
    );
    expect(both.map((each) => each.statusCode).sort()).toEqual([201, 409]);
    expect(both.find((each) => each.statusCode === 409)!.json().error).toBe('already_reversed');
    expect(await balanceOf('captain.earnings', captainId)).toBe(9000n);

    const unknown = await finance.post('/v1/admin/manual-entries/reversals', {
      cityId: azaz,
      journalId: randomUUID(),
      reason: 'خطأ',
    });
    expect(unknown.statusCode).toBe(404);
    expect(unknown.json().error).toBe('unknown_journal');
  });

  it('answers a key sent again with the same entry, and refuses it with another command', async () => {
    const finance = await admin(['FIN']);
    const captainId = await captain();
    const key = randomUUID();
    const body = adjustment({
      party: 'captain',
      partyId: captainId,
      account: 'captain.earnings',
      amount: '700',
    });
    const [first, second] = await Promise.all([
      finance.post('/v1/admin/manual-entries', body, key),
      finance.post('/v1/admin/manual-entries', body, key),
    ]);
    expect(first.statusCode).toBe(201);
    expect(second.statusCode).toBe(201);
    expect(second.json().id).toBe(first.json().id);
    expect(await balanceOf('captain.earnings', captainId)).toBe(700n);
    const reversal = (
      await finance.post('/v1/admin/manual-entries/reversals', {
        cityId: azaz,
        journalId: first.json().journal.journalId,
        reason: 'عكس',
      })
    ).json();
    const replayed = await finance.post('/v1/admin/manual-entries', body, key);
    expect(replayed.json().reversedBy).toMatchObject({ manualEntryId: reversal.id });
    const other = await finance.post('/v1/admin/manual-entries', { ...body, amount: '800' }, key);
    expect(other.statusCode).toBe(422);
    const noKey = await finance.post('/v1/admin/manual-entries', body, null);
    expect(noKey.statusCode).toBe(400);
  });

  it('finds a captain and a restaurant by name, a customer by number', async () => {
    const finance = await admin(['FIN']);
    const captainId = await captain();
    const restaurantId = await restaurant();
    const buyer = await customer();
    const search = (party: string, q: string) =>
      finance.post('/v1/admin/manual-entries/parties/search', { cityId: azaz, party, q }, null);

    expect(
      (await search('captain', `القيود ${captainCount}`))
        .json()
        .parties.map((p: { id: string }) => p.id),
    ).toContain(captainId);
    const name = (await merchants.restaurant(restaurantId))!.nameAr;
    expect((await search('restaurant', name.slice(-12))).json().parties).toEqual([
      { id: restaurantId, name },
    ]);
    expect((await search('customer', buyer.phone)).json().parties).toEqual([
      { id: buyer.id, name: '' },
    ]);
    expect((await search('customer', 'أحمد')).json().parties).toEqual([]);
  });
});
