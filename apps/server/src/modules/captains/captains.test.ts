import 'reflect-metadata';
import { randomUUID } from 'node:crypto';
import { Test, type TestingModule } from '@nestjs/testing';
import pg from 'pg';
import { afterAll, beforeAll, describe, expect, it, vi } from 'vitest';
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
import { LivePositions } from './live-positions.js';

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

// A new city with TRY as its base and, when asked, USD at 40 TRY.
async function city({ usd = false } = {}): Promise<string> {
  cities += 1;
  const { rows } = await sql.query<{ id: string }>(
    'INSERT INTO geo.cities (code, name) VALUES ($1, $2) RETURNING id',
    [`C${String.fromCharCode(64 + cities)}`, `test city ${cities}`],
  );
  const cityId = rows[0]!.id;
  await fx.setCityCurrency(cityId, { currency: 'TRY', displayOrder: 1, enabled: true }, fxSystem);
  await fx.setBaseCurrency(cityId, 'TRY', fxSystem);
  if (usd) {
    await fx.setCityCurrency(
      cityId,
      { currency: 'USD', displayOrder: 2, enabled: false },
      fxSystem,
    );
    await fx.setRate(
      cityId,
      'USD',
      { value: '40', direction: 'base_per_unit' },
      {
        ...fxSystem,
        actor: { type: 'admin', id: '0190f3a0-0000-7000-8000-0000000000f1', role: 'FIN' },
      },
    );
    await fx.setCityCurrency(cityId, { currency: 'USD', displayOrder: 2, enabled: true }, fxSystem);
  }
  return cityId;
}

const motorbike: NewCaptain = {
  name: 'أحمد محمد علي',
  vehicle: 'motorbike',
  plateNumber: '123456',
  custodyLimit: { amount: 300_000n, currency: 'TRY' },
};

async function captain(overrides: Partial<NewCaptain> = {}, options = { usd: false }) {
  const cityId = await city(options);
  const id = await captains.createCaptain(cityId, { ...motorbike, ...overrides }, change);
  return { cityId, id };
}

// Cash in the captain's hands: + collected from a customer, − paid to a
// restaurant or handed in at the desk.
async function custody(
  cityId: string,
  captainId: string,
  type: JournalType,
  amount: bigint,
  currency = 'TRY',
) {
  await db.transaction(async (tx) => {
    const account = await ledger.openAccount(
      { cityId, purpose: 'captain.custody', ownerId: captainId, currency },
      tx,
    );
    const desk = type === 'custody.hand_in';
    const counter = await ledger.openAccount(
      desk
        ? { cityId, purpose: 'platform.cash', ownerId: randomUUID(), currency }
        : { cityId, purpose: 'platform.order_clearing', ownerId: null, currency },
      tx,
    );
    await ledger.post(
      {
        cityId,
        type,
        source: desk ? null : { kind: 'order', id: randomUUID() },
        actor: { type: 'system', id: null },
        entries: [
          { accountId: account, currency, amount },
          { accountId: counter, currency, amount: -amount },
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
    expect(await captains.captain(id, new Date())).toMatchObject({
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
    expect((await captains.captain(id, new Date()))?.suspension).toEqual({
      reason: 'تأخر متكرر',
      until,
    });
    await captains.setStatus(id, 'active', change, now);
    expect((await captains.captain(id, new Date()))?.suspension).toBeNull();
    await captains.setStatus(id, 'terminated', change, now);
    await expect(captains.setStatus(id, 'active', change, now)).rejects.toMatchObject({
      refusal: 'status_change_not_allowed',
    });
  });

  it('reads a suspension past its end as active, and replaces a suspension', async () => {
    const { id } = await captain();
    const now = new Date();
    const until = new Date(now.getTime() + day);
    await captains.setStatus(id, 'suspended', { ...change, reason: 'يوم', until }, now);
    await captains.setStatus(id, 'suspended', { ...change, reason: 'سبعة أيام' }, now);
    expect((await captains.captain(id, now))?.suspension).toEqual({
      reason: 'سبعة أيام',
      until: null,
    });
    const later = new Date(now.getTime() + 2 * day);
    await captains.setStatus(id, 'suspended', { ...change, reason: 'يوم', until: later }, now);
    const after = new Date(later.getTime() + 1);
    expect(await captains.captain(id, after)).toMatchObject({ status: 'active', suspension: null });
    // The next step of the ladder needs no reactivation first (AP §9.7.6).
    await captains.setStatus(id, 'suspended', { ...change, reason: 'المرحلة التالية' }, after);
    expect((await captains.captain(id, after))?.status).toBe('suspended');
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
    expect((await captains.captain(id, new Date()))?.custodyLimit).toEqual({
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

  it('counts every currency at its current rate and nets them in closed_due (AP §8.5.4)', async () => {
    const { cityId, id } = await captain({}, { usd: true });
    // Paid a restaurant 400 TRY, collected 10 USD (400 TRY) from the customer.
    await custody(cityId, id, 'custody.pay_merchant', -40_000n);
    await custody(cityId, id, 'custody.collect', 1_000n, 'USD');
    const later = new Date(Date.now() + 2 * day);
    const { custody: held } = await captains.state(id, later);
    // Usage is the positive positions only; closed_due nets them.
    expect(held.usage).toEqual({ amount: 40_000n, currency: 'TRY' });
    expect(held.closedDue).toEqual({ amount: 0n, currency: 'TRY' });
    expect((await captains.goOnline(id, device, later)).availability.state).toBe(
      'online_available',
    );
    // A disabled currency still counts, and going offline still works.
    await fx.setCityCurrency(
      cityId,
      { currency: 'USD', displayOrder: 2, enabled: false },
      fxSystem,
    );
    expect((await captains.state(id, later)).custody.usage.amount).toBe(40_000n);
    expect(await captains.goOffline(id, later)).toEqual({
      handIn: { amount: 40_000n, currency: 'TRY' },
    });
  });

  it('blocks on a closed day due in another currency', async () => {
    const { cityId, id } = await captain({}, { usd: true });
    await custody(cityId, id, 'custody.collect', 500n, 'USD');
    const refused = await captains
      .goOnline(id, device, new Date(Date.now() + 2 * day))
      .catch((error: unknown) => error);
    expect((refused as CaptainsRefusedError).blocks).toMatchObject([
      { kind: 'closed_due', amount: 20_000n },
    ]);
  });

  it('converts a cash limit set in another of the city currencies', async () => {
    const { cityId, id } = await captain(
      { custodyLimit: { amount: 7_500n, currency: 'USD' } },
      { usd: true },
    );
    await custody(cityId, id, 'custody.collect', 300_000n);
    expect((await captains.state(id, new Date())).custody).toMatchObject({
      usage: { amount: 300_000n, currency: 'TRY' },
      limit: { amount: 300_000n, currency: 'TRY' },
    });
  });

  it('refuses an unknown captain', async () => {
    await expect(captains.state(randomUUID(), new Date())).rejects.toMatchObject({
      refusal: 'unknown_captain',
    });
  });
});

describe('CaptainsService.eligibleNear (AP §9.12.6)', () => {
  const restaurant = { latitude: 36.587, longitude: 37.046 };
  const near = { latitude: 36.588, longitude: 37.047 };
  const online = async (
    point: { latitude: number; longitude: number },
    simulatedLater = false,
    inCity?: string,
  ) => {
    const { cityId, id } = inCity
      ? { cityId: inCity, id: await captains.createCaptain(inCity, motorbike, change) }
      : await captain();
    const now = new Date();
    await captains.goOnline(id, device, now);
    const points = [{ ...point, accuracyMetres: 8, recordedAt: now, simulated: false }];
    if (simulatedLater) {
      points.push({
        ...point,
        accuracyMetres: 8,
        recordedAt: new Date(now.getTime() + 1),
        simulated: true,
      });
    }
    await captains.recordLocations(id, points, new Date(now.getTime() + 2));
    return { cityId, id };
  };

  it('finds an online captain near the restaurant, and none once offline', async () => {
    const { cityId, id } = await online(near);
    expect(await captains.eligibleNear(cityId, restaurant, 500, new Date())).toBe(true);
    await captains.goOffline(id, new Date());
    expect(await captains.eligibleNear(cityId, restaurant, 500, new Date())).toBe(false);
  });

  it('gives the nearest eligible captain with its vehicle and position, for the search start', async () => {
    const { cityId, id } = await online(near);
    const nearest = await captains.nearestEligible(cityId, restaurant, 500, new Date());
    expect(nearest).toMatchObject({ captainId: id, vehicle: 'motorbike' });
    expect(nearest!.position.latitude).toBeCloseTo(near.latitude, 5);
    expect(nearest!.position.longitude).toBeCloseTo(near.longitude, 5);
    await captains.goOffline(id, new Date());
    expect(await captains.nearestEligible(cityId, restaurant, 500, new Date())).toBeNull();
  });

  it('reads the locations when Valkey cannot answer (architecture §5.7)', async () => {
    const { cityId, id } = await online(near);
    const positions = moduleRef.get(LivePositions);
    const spy = vi.spyOn(positions, 'near').mockResolvedValue(null);
    try {
      const nearest = await captains.nearestEligible(cityId, restaurant, 500, new Date());
      expect(nearest).toMatchObject({ captainId: id });
      expect(nearest!.position.latitude).toBeCloseTo(near.latitude, 5);
      expect(await captains.eligibleNear(cityId, restaurant, 500, new Date())).toBe(true);
      // About 5.5 km away is outside the 3 km radius there too.
      expect(
        await captains.eligibleNear(
          cityId,
          { latitude: 36.587, longitude: 37.108 },
          500,
          new Date(),
        ),
      ).toBe(false);
      await captains.goOffline(id, new Date());
      expect(await captains.eligibleNear(cityId, restaurant, 500, new Date())).toBe(false);
    } finally {
      spy.mockRestore();
    }
  });

  it('leaves out a position older than 10 minutes', async () => {
    const { cityId } = await online(near);
    const later = new Date(Date.now() + 11 * 60_000);
    expect(await captains.eligibleNear(cityId, restaurant, 500, later)).toBe(false);
  });

  it('leaves out an online captain who receives no offers (a simulated location)', async () => {
    const { cityId } = await online(near, true);
    expect(await captains.eligibleNear(cityId, restaurant, 500, new Date())).toBe(false);
  });

  it('makes a captain with an active order busy: no offers, and no going offline (CA §7.1, §15)', async () => {
    const { cityId, id } = await online(near);
    captains.useActiveOrders((ids) => Promise.resolve(new Set(ids.filter((each) => each === id))));
    try {
      expect((await captains.state(id, new Date())).availability.state).toBe('busy');
      expect(await captains.nearestEligible(cityId, restaurant, 500, new Date())).toBeNull();
      const [seen] = (await captains.candidates(cityId, restaurant, 500, new Date())).filter(
        (each) => each.captainId === id,
      );
      expect(seen?.reasons).toEqual(['busy']);
      await expect(captains.goOffline(id, new Date())).rejects.toMatchObject({
        refusal: 'active_order',
      });
    } finally {
      captains.useActiveOrders(() => Promise.resolve(new Set()));
    }
    await captains.goOffline(id, new Date());
  });

  it('lists every online captain of the city with why it cannot take the trip (AP §9.3.2)', async () => {
    const { cityId, id } = await online(near);
    // About 5.5 km east, beyond the 3 km search radius.
    const far = await online({ latitude: 36.587, longitude: 37.108 }, false, cityId);
    const simulated = await online(near, true, cityId);
    try {
      const mine = async (tripMetres: number) =>
        new Map(
          (await captains.candidates(cityId, restaurant, tripMetres, new Date())).map((each) => [
            each.captainId,
            each,
          ]),
        );
      const listed = await mine(500);
      expect(listed.get(id)).toMatchObject({ name: expect.any(String), vehicle: 'motorbike' });
      expect(listed.get(id)!.reasons).toEqual([]);
      expect(listed.get(id)!.straightMetres).toBeGreaterThan(100);
      expect(listed.get(id)!.straightMetres).toBeLessThan(200);
      expect(listed.get(far.id)!.reasons).toEqual(['out_of_range']);
      expect(listed.get(simulated.id)!.reasons).toEqual(['simulated_location']);
      // Nearest first.
      const order = [...listed.keys()];
      expect(order.indexOf(id)).toBeLessThan(order.indexOf(far.id));
      // A motorbike takes trips up to dispatch.max_distance_km.motorbike (10 km).
      expect((await mine(12_000)).get(id)!.reasons).toEqual(['vehicle_not_allowed']);
    } finally {
      for (const each of [id, far.id, simulated.id]) await captains.goOffline(each, new Date());
    }
  });
});
