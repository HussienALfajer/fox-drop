import 'reflect-metadata';
import { Test, type TestingModule } from '@nestjs/testing';
import pg from 'pg';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { startTestDatabase, type TestDatabase } from '../../database/test-database.js';
import { startTestValkey, type TestValkey } from '../../valkey/test-valkey.js';
import { type FxChange, FxService } from '../fx/index.js';
import { GeoService, type Point } from '../geo/index.js';
import {
  type CaptainChange,
  CaptainsModule,
  CaptainsRefusedError,
  PeakBonusService,
} from './index.js';
import { localClock, type PeakWindow } from './peak-bonus.js';

// PeakBonusService on a fresh database (AP §9.12.5, D15): the versions, when
// a change takes effect, and the bonus by the restaurant's zone.
let database: TestDatabase;
let cache: TestValkey;
let moduleRef: TestingModule;
let peak: PeakBonusService;
let fx: FxService;
let geo: GeoService;
let sql: pg.Pool;

beforeAll(async () => {
  [database, cache] = await Promise.all([startTestDatabase(), startTestValkey()]);
  process.env.DATABASE_URL = database.appUrl;
  process.env.VALKEY_URL = cache.url;
  moduleRef = await Test.createTestingModule({ imports: [CaptainsModule] }).compile();
  await moduleRef.init();
  peak = moduleRef.get(PeakBonusService);
  fx = moduleRef.get(FxService);
  geo = moduleRef.get(GeoService);
  sql = new pg.Pool({ connectionString: database.appUrl });
}, 300_000);

afterAll(async () => {
  await moduleRef?.close();
  await sql?.end();
  await Promise.all([database?.stop(), cache?.stop()]);
});

const change: CaptainChange = {
  actor: { type: 'admin', id: '0190f3a0-0000-7000-8000-0000000000a1', role: 'OWN' },
  context: { ipAddress: '203.0.113.7', device: 'Firefox 140 on Windows' },
};
const fxSystem: FxChange = {
  actor: { type: 'system', id: null, role: null },
  context: { ipAddress: null, device: null },
};
const minute = 60_000;

let cities = 0;
async function city({ base = true } = {}): Promise<string> {
  cities += 1;
  const { rows } = await sql.query<{ id: string }>(
    'INSERT INTO geo.cities (code, name) VALUES ($1, $2) RETURNING id',
    [`P${String.fromCharCode(65 + cities)}`, `peak city ${cities}`],
  );
  const cityId = rows[0]!.id;
  if (base) {
    await fx.setCityCurrency(cityId, { currency: 'TRY', displayOrder: 1, enabled: true }, fxSystem);
    await fx.setBaseCurrency(cityId, 'TRY', fxSystem);
  }
  return cityId;
}

function square(latitude: number, longitude: number, half = 0.005): Point[] {
  return [
    { latitude: latitude - half, longitude: longitude - half },
    { latitude: latitude - half, longitude: longitude + half },
    { latitude: latitude + half, longitude: longitude + half },
    { latitude: latitude + half, longitude: longitude - half },
  ];
}
const inNorth = { latitude: 36.6, longitude: 37.05 };
const outside = { latitude: 36.7, longitude: 37.2 };

// A window running now on Azaz's clock, from an hour ago to an hour ahead,
// every day.
function aroundNow(amount: bigint, zoneIds: string[] = []): PeakWindow {
  const { minute: now } = localClock(new Date(), 'Asia/Damascus');
  return {
    days: [1, 2, 3, 4, 5, 6, 7],
    startMinute: (now - 60 + 1440) % 1440,
    endMinute: (now + 60) % 1440,
    amount,
    zoneIds,
  };
}
// A window that is not running now (it starts in three hours).
function later(amount: bigint): PeakWindow {
  const { minute: now } = localClock(new Date(), 'Asia/Damascus');
  return {
    days: [1, 2, 3, 4, 5, 6, 7],
    startMinute: (now + 180) % 1440,
    endMinute: (now + 240) % 1440,
    amount,
    zoneIds: [],
  };
}

describe('PeakBonusService', () => {
  it('is off until the owner saves it (D15)', async () => {
    const cityId = await city();
    await expect(peak.state(cityId, new Date())).resolves.toEqual({ inForce: null, pending: null });
    await expect(peak.bonusFor(cityId, inNorth, new Date())).resolves.toBeNull();
    await expect(peak.activeNow(cityId, new Date())).resolves.toEqual([]);
  });

  it('enables at once and pays by the restaurant zone, the largest window', async () => {
    const cityId = await city();
    const north = await geo.createZone(
      cityId,
      { name: 'الشمال', area: square(36.6, 37.05), active: true },
      change,
    );
    const before = Date.now();
    const saved = await peak.setPeakBonus(
      cityId,
      { enabled: true, windows: [aroundNow(500n), aroundNow(800n, [north])] },
      change,
    );
    expect(saved.effectiveFrom.getTime()).toBeLessThanOrEqual(Date.now());
    expect(saved.effectiveFrom.getTime()).toBeGreaterThanOrEqual(before - minute);
    expect(saved.windows[1]!.zones).toEqual([{ id: north, name: 'الشمال' }]);
    const now = new Date();
    await expect(peak.bonusFor(cityId, inNorth, now)).resolves.toEqual({
      amount: 800n,
      currency: 'TRY',
      versionId: saved.id,
    });
    await expect(peak.bonusFor(cityId, outside, now)).resolves.toMatchObject({ amount: 500n });
    const active = await peak.activeNow(cityId, now);
    expect(active.map((window) => window.amount)).toEqual([500n, 800n]);
    expect(active[0]!.until.getTime() - now.getTime()).toBeGreaterThan(58 * minute);
    expect(active[0]!.until.getTime() - now.getTime()).toBeLessThanOrEqual(61 * minute);
    const { rows } = await sql.query<{ action: string }>(
      "SELECT action FROM audit.events WHERE target_type = 'peak_bonus' AND target_id = $1",
      [saved.id],
    );
    expect(rows).toEqual([{ action: 'peak_bonus.set' }]);
  });

  it('lowers or disables what is running at the end of the current window', async () => {
    const cityId = await city();
    await peak.setPeakBonus(cityId, { enabled: true, windows: [aroundNow(500n)] }, change);
    const lowered = await peak.setPeakBonus(
      cityId,
      { enabled: true, windows: [aroundNow(200n)] },
      change,
    );
    const wait = lowered.effectiveFrom.getTime() - Date.now();
    expect(wait).toBeGreaterThan(58 * minute);
    expect(wait).toBeLessThanOrEqual(61 * minute);
    const state = await peak.state(cityId, new Date());
    expect(state.inForce?.windows[0]!.amount).toBe(500n);
    expect(state.pending?.id).toBe(lowered.id);
    // Until then the order earns the announced bonus.
    await expect(peak.bonusFor(cityId, outside, new Date())).resolves.toMatchObject({
      amount: 500n,
    });
    await expect(
      peak.bonusFor(cityId, outside, new Date(lowered.effectiveFrom.getTime() - 30 * minute)),
    ).resolves.toMatchObject({ amount: 500n });
    // A raise saved meanwhile replaces the waiting change and applies at once.
    const raised = await peak.setPeakBonus(
      cityId,
      { enabled: true, windows: [aroundNow(700n)] },
      change,
    );
    const after = await peak.state(cityId, new Date());
    expect(after.inForce?.id).toBe(raised.id);
    expect(after.pending).toBeNull();
    await expect(
      peak.bonusFor(cityId, outside, new Date(lowered.effectiveFrom.getTime() - minute)),
    ).resolves.toMatchObject({ amount: 700n });
  });

  it('disables at once when no window is running (owner decision 2026-11-12)', async () => {
    const cityId = await city();
    await peak.setPeakBonus(cityId, { enabled: true, windows: [later(500n)] }, change);
    const off = await peak.setPeakBonus(cityId, { enabled: false, windows: [later(500n)] }, change);
    expect(off.effectiveFrom.getTime()).toBeLessThanOrEqual(Date.now());
    expect((await peak.state(cityId, new Date())).inForce?.enabled).toBe(false);
  });

  it('refuses invalid windows, another city’s zone and a city without a base', async () => {
    const cityId = await city();
    const other = await city();
    const zone = await geo.createZone(
      other,
      { name: 'elsewhere', area: square(36.6, 37.05), active: true },
      change,
    );
    await expect(
      peak.setPeakBonus(cityId, { enabled: true, windows: [aroundNow(0n)] }, change),
    ).rejects.toThrow(CaptainsRefusedError);
    await expect(
      peak.setPeakBonus(cityId, { enabled: true, windows: [aroundNow(500n, [zone])] }, change),
    ).rejects.toMatchObject({ refusal: 'invalid_peak_bonus' });
    await expect(
      peak.setPeakBonus(await city({ base: false }), { enabled: true, windows: [] }, change),
    ).rejects.toMatchObject({ refusal: 'not_in_base_currency' });
  });
});
