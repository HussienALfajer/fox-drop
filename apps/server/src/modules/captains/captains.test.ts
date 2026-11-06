import 'reflect-metadata';
import { randomUUID } from 'node:crypto';
import { Test, type TestingModule } from '@nestjs/testing';
import pg from 'pg';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { startTestDatabase, type TestDatabase } from '../../database/test-database.js';
import { startTestValkey, type TestValkey } from '../../valkey/test-valkey.js';
import { type FxChange, FxService } from '../fx/index.js';
import { type JournalType, LedgerService } from '../ledger/index.js';
import { type Vehicle, vehicles } from '../settings/index.js';
import {
  type CaptainChange,
  CaptainsModule,
  CaptainsRefusedError,
  CaptainsService,
  type NewCaptain,
  type PayRate,
} from './index.js';

// CaptainsService on a fresh database and Valkey: the captain record, its
// status and cash limit, the pay table, and going online and offline with the
// checks of CA §7.2 (AP §8.5.3–8.5.4, §9.7, §9.12.5).
let database: TestDatabase;
let cache: TestValkey;
let moduleRef: TestingModule;
let captains: CaptainsService;
let ledger: LedgerService;
let fx: FxService;
let db: Database['db'];
let sql: pg.Pool;

beforeAll(async () => {
  [database, cache] = await Promise.all([startTestDatabase(), startTestValkey()]);
  process.env.DATABASE_URL = database.appUrl;
  process.env.VALKEY_URL = cache.url;
  moduleRef = await Test.createTestingModule({ imports: [CaptainsModule] }).compile();
  await moduleRef.init();
  captains = moduleRef.get(CaptainsService);
  ledger = moduleRef.get(LedgerService);
  fx = moduleRef.get(FxService);
  ({ db } = moduleRef.get<Database>(DATABASE, { strict: false }));
  sql = new pg.Pool({ connectionString: database.appUrl });
}, 300_000);

afterAll(async () => {
  await moduleRef?.close();
  await sql?.end();
  await Promise.all([database?.stop(), cache?.stop()]);
});

const context = { ipAddress: '203.0.113.7', device: 'Firefox 140 on Windows' };
const change: CaptainChange = {
  actor: { type: 'admin', id: '0190f3a0-0000-7000-8000-0000000000a1', role: 'OWN' },
  context,
  reason: 'اختبار',
};
const fxSystem: FxChange = {
  actor: { type: 'system', id: null, role: null },
  context: { ipAddress: null, device: null },
};
const day = 86_400_000;
const device = { appVersion: '1.0.0', simulatedLocation: false };

let cities = 0;

// A new city with TRY as its base.
async function city(): Promise<string> {
  cities += 1;
  const { rows } = await sql.query<{ id: string }>(
    'INSERT INTO geo.cities (code, name) VALUES ($1, $2) RETURNING id',
    [`C${String.fromCharCode(64 + cities)}`, `test city ${cities}`],
  );
  const cityId = rows[0]!.id;
  await fx.setCityCurrency(cityId, { currency: 'TRY', displayOrder: 1, enabled: true }, fxSystem);
  await fx.setBaseCurrency(cityId, 'TRY', fxSystem);
  return cityId;
}

const motorbike: NewCaptain = {
  name: 'أحمد محمد علي',
  vehicle: 'motorbike',
  plateNumber: '123456',
  custodyLimit: { amount: 300_000n, currency: 'TRY' },
};

async function captain(overrides: Partial<NewCaptain> = {}) {
  const cityId = await city();
  const id = await captains.createCaptain(cityId, { ...motorbike, ...overrides }, change);
  return { cityId, id };
}

// Cash in the captain's hands: + collected from a customer, − paid to a
// restaurant or handed in at the desk.
async function custody(cityId: string, captainId: string, type: JournalType, amount: bigint) {
  await db.transaction(async (tx) => {
    const account = await ledger.openAccount(
      { cityId, purpose: 'captain.custody', ownerId: captainId, currency: 'TRY' },
      tx,
    );
    const desk = type === 'custody.hand_in';
    const counter = await ledger.openAccount(
      desk
        ? { cityId, purpose: 'platform.cash', ownerId: randomUUID(), currency: 'TRY' }
        : { cityId, purpose: 'platform.order_clearing', ownerId: null, currency: 'TRY' },
      tx,
    );
    await ledger.post(
      {
        cityId,
        type,
        source: desk ? null : { kind: 'order', id: randomUUID() },
        actor: { type: 'system', id: null },
        entries: [
          { accountId: account, currency: 'TRY', amount },
          { accountId: counter, currency: 'TRY', amount: -amount },
        ],
      },
      tx,
    );
  });
}

const rate: PayRate = {
  basePay: 2_500n,
  includedMetres: 3_000,
  perExtraKm: 500n,
  waitingPerMinute: 0n,
  minimumPay: 2_500n,
};
const everyVehicle = (value: PayRate) =>
  Object.fromEntries(vehicles.map((vehicle) => [vehicle, value])) as Record<Vehicle, PayRate>;

describe('CaptainsService.createCaptain', () => {
  it('adds an active captain with its vehicle and cash limit, audited', async () => {
    const { id } = await captain();
    expect(await captains.captain(id)).toMatchObject({
      name: 'أحمد محمد علي',
      vehicle: 'motorbike',
      plateNumber: '123456',
      status: 'active',
      suspension: null,
      custodyLimit: { amount: 300_000n, currency: 'TRY' },
    });
    const { rows } = await sql.query(
      "SELECT changes FROM audit.events WHERE action = 'captain.create' AND target_id = $1",
      [id],
    );
    expect(rows[0].changes.custodyLimit).toEqual({
      before: null,
      after: { amount: '300000', currency: 'TRY' },
    });
  });

  it('refuses a motor vehicle without its plate, and a cash limit outside the base', async () => {
    const cityId = await city();
    await expect(
      captains.createCaptain(cityId, { ...motorbike, plateNumber: ' ' }, change),
    ).rejects.toMatchObject({ refusal: 'invalid_captain' });
    await expect(
      captains.createCaptain(
        cityId,
        { ...motorbike, custodyLimit: { amount: 1_000n, currency: 'USD' } },
        change,
      ),
    ).rejects.toMatchObject({ refusal: 'not_in_base_currency' });
    await expect(
      captains.createCaptain(
        cityId,
        { ...motorbike, custodyLimit: { amount: 0n, currency: 'TRY' } },
        change,
      ),
    ).rejects.toMatchObject({ refusal: 'invalid_captain' });
    expect(
      await captains.createCaptain(
        cityId,
        { ...motorbike, vehicle: 'walking', plateNumber: null },
        change,
      ),
    ).toEqual(expect.any(String));
  });
});

describe('CaptainsService.setStatus', () => {
  it('suspends with a reason and an end, reactivates, and ends at termination', async () => {
    const { id } = await captain();
    const now = new Date();
    const until = new Date(now.getTime() + day);
    await expect(
      captains.setStatus(id, 'suspended', { ...change, reason: ' ' }, now),
    ).rejects.toMatchObject({ refusal: 'reason_required' });
    await captains.setStatus(id, 'suspended', { ...change, reason: 'تأخر متكرر', until }, now);
    expect((await captains.captain(id))?.suspension).toEqual({ reason: 'تأخر متكرر', until });
    await captains.setStatus(id, 'active', change, now);
    expect((await captains.captain(id))?.suspension).toBeNull();
    await captains.setStatus(id, 'terminated', change, now);
    await expect(captains.setStatus(id, 'active', change, now)).rejects.toMatchObject({
      refusal: 'status_change_not_allowed',
    });
  });

  it('sets an online captain offline at once', async () => {
    const { id } = await captain();
    const now = new Date();
    await captains.goOnline(id, device, now);
    await captains.setStatus(id, 'suspended', change, new Date(now.getTime() + 1_000));
    expect((await captains.state(id, new Date(now.getTime() + 2_000))).availability).toEqual({
      state: 'suspended',
      reason: 'اختبار',
      until: null,
    });
    const { rows } = await sql.query(
      'SELECT end_reason FROM captains.online_periods WHERE captain_id = $1',
      [id],
    );
    expect(rows).toEqual([{ end_reason: 'suspended' }]);
  });
});

describe('CaptainsService.setCustodyLimit', () => {
  it('changes the limit at once with a reason, audited', async () => {
    const { id } = await captain();
    await expect(
      captains.setCustodyLimit(
        id,
        { amount: 500_000n, currency: 'TRY' },
        { ...change, reason: '' },
      ),
    ).rejects.toMatchObject({ refusal: 'reason_required' });
    await captains.setCustodyLimit(id, { amount: 500_000n, currency: 'TRY' }, change);
    expect((await captains.captain(id))?.custodyLimit).toEqual({
      amount: 500_000n,
      currency: 'TRY',
    });
    const { rows } = await sql.query(
      "SELECT changes FROM audit.events WHERE action = 'captain.custody_limit' AND target_id = $1",
      [id],
    );
    expect(rows[0].changes.custodyLimit).toEqual({
      before: { amount: '300000', currency: 'TRY' },
      after: { amount: '500000', currency: 'TRY' },
    });
  });
});

describe('CaptainsService.setPayTable', () => {
  it('starts the first table now and every later one 7 days or more after', async () => {
    const cityId = await city();
    const first = await captains.setPayTable(
      cityId,
      { currency: 'TRY', rates: everyVehicle(rate) },
      change,
    );
    const now = new Date();
    expect(await captains.payTable(cityId, now)).toMatchObject({
      id: first,
      currency: 'TRY',
      rates: { motorbike: rate, walking: rate },
    });

    const raised = { ...rate, basePay: 3_000n };
    await expect(
      captains.setPayTable(
        cityId,
        {
          currency: 'TRY',
          rates: everyVehicle(raised),
          effectiveFrom: new Date(now.getTime() + day),
        },
        change,
      ),
    ).rejects.toMatchObject({ refusal: 'invalid_pay_table' });
    const second = await captains.setPayTable(
      cityId,
      { currency: 'TRY', rates: everyVehicle(raised) },
      change,
    );
    expect((await captains.payTable(cityId, new Date(now.getTime() + 6 * day)))?.id).toBe(first);
    expect(await captains.payTable(cityId, new Date(now.getTime() + 8 * day))).toMatchObject({
      id: second,
      rates: { car: raised },
    });
  });

  it('refuses a table without every vehicle, without a reason or outside the base', async () => {
    const cityId = await city();
    const noCar: Partial<Record<Vehicle, PayRate>> = everyVehicle(rate);
    delete noCar.car;
    await expect(
      captains.setPayTable(
        cityId,
        { currency: 'TRY', rates: noCar as Record<Vehicle, PayRate> },
        change,
      ),
    ).rejects.toMatchObject({ refusal: 'invalid_pay_table' });
    await expect(
      captains.setPayTable(
        cityId,
        { currency: 'TRY', rates: everyVehicle({ ...rate, basePay: -1n }) },
        change,
      ),
    ).rejects.toMatchObject({ refusal: 'invalid_pay_table' });
    await expect(
      captains.setPayTable(
        cityId,
        { currency: 'TRY', rates: everyVehicle(rate) },
        { ...change, reason: null },
      ),
    ).rejects.toMatchObject({ refusal: 'reason_required' });
    await expect(
      captains.setPayTable(cityId, { currency: 'USD', rates: everyVehicle(rate) }, change),
    ).rejects.toMatchObject({ refusal: 'not_in_base_currency' });
    expect(await captains.payTable(cityId, new Date())).toBeNull();
  });
});

describe('going online and offline (CA §7.2, §7.5)', () => {
  it('goes online once, and offline with no cash to hand in', async () => {
    const { id } = await captain();
    const now = new Date();
    expect((await captains.goOnline(id, device, now)).availability).toEqual({
      state: 'online_available',
      since: now,
    });
    const later = new Date(now.getTime() + 10_000);
    expect((await captains.goOnline(id, device, later)).availability).toEqual({
      state: 'online_available',
      since: now,
    });
    expect(await captains.goOffline(id, later)).toEqual({ handIn: null });
    expect((await captains.state(id, later)).availability).toEqual({ state: 'offline' });
  });

  it('reminds of the cash held when going offline', async () => {
    const { cityId, id } = await captain();
    await custody(cityId, id, 'custody.collect', 41_000n);
    const now = new Date();
    await captains.goOnline(id, device, now);
    expect(await captains.goOffline(id, now)).toEqual({
      handIn: { amount: 41_000n, currency: 'TRY' },
    });
  });

  it('refuses at the cash limit and warns from 80% of it', async () => {
    const { cityId, id } = await captain();
    await custody(cityId, id, 'custody.collect', 240_000n);
    const now = new Date();
    expect((await captains.state(id, now)).custody).toMatchObject({
      usage: { amount: 240_000n, currency: 'TRY' },
      warn: true,
    });
    await custody(cityId, id, 'custody.collect', 60_000n);
    const refused = await captains.goOnline(id, device, now).catch((error: unknown) => error);
    expect(refused).toBeInstanceOf(CaptainsRefusedError);
    expect((refused as CaptainsRefusedError).blocks).toEqual([
      { kind: 'cash_limit', limit: 300_000n },
    ]);
  });

  it('counts a pickup payment against the cash collected, never below zero usage', async () => {
    const { cityId, id } = await captain();
    await custody(cityId, id, 'custody.pay_merchant', -400_000n);
    const now = new Date();
    expect((await captains.state(id, now)).custody.usage.amount).toBe(0n);
    expect((await captains.goOnline(id, device, now)).availability.state).toBe('online_available');
  });

  it('refuses cash due from a closed day until it is handed in (AP §8.5.4)', async () => {
    const { cityId, id } = await captain();
    await custody(cityId, id, 'custody.collect', 41_000n);
    // Two days later the last cutoff is after the collection.
    const later = new Date(Date.now() + 2 * day);
    const refused = await captains.goOnline(id, device, later).catch((error: unknown) => error);
    expect((refused as CaptainsRefusedError).blocks).toEqual([
      {
        kind: 'closed_due',
        amount: 41_000n,
        cutoff: (await captains.state(id, later)).custody.lastCutoff,
      },
    ]);
    await custody(cityId, id, 'custody.hand_in', -41_000n);
    expect((await captains.state(id, later)).custody.closedDue.amount).toBe(0n);
    expect((await captains.goOnline(id, device, later)).availability.state).toBe(
      'online_available',
    );
  });

  it('refuses a suspended captain, a terminated one and a simulated location', async () => {
    const { id } = await captain();
    const now = new Date();
    const blocks = (promise: Promise<unknown>) =>
      promise.then(
        () => [],
        (error: CaptainsRefusedError) => error.blocks.map((block) => block.kind),
      );
    expect(
      await blocks(captains.goOnline(id, { ...device, simulatedLocation: true }, now)),
    ).toEqual(['simulated_location']);
    await captains.setStatus(id, 'suspended', change, now);
    expect(await blocks(captains.goOnline(id, device, now))).toEqual(['suspended']);
    await captains.setStatus(id, 'terminated', change, now);
    expect(await blocks(captains.goOnline(id, device, now))).toEqual(['contract_ended']);
  });

  it('refuses an unknown captain', async () => {
    await expect(captains.state(randomUUID(), new Date())).rejects.toMatchObject({
      refusal: 'unknown_captain',
    });
  });
});
