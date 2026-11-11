import { Inject, Injectable, type OnModuleInit } from '@nestjs/common';
import { asc, eq, inArray, sql } from 'drizzle-orm';
import type { NodePgDatabase } from 'drizzle-orm/node-postgres';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { AuditService } from '../audit/index.js';
import { FxService } from '../fx/index.js';
import { GeoService, type Point } from '../geo/index.js';
import { lockCityCurrencies } from '../settings/index.js';
import { type CaptainChange, CaptainsRefusedError } from './captains.service.js';
import {
  activeWindows,
  bonusAt,
  checkPeakWindows,
  localClock,
  type PeakVersion,
  type PeakWindow,
  takesEffect,
  versionInForce,
} from './peak-bonus.js';
import { peakBonusVersions, peakBonusWindows } from './schema.js';

type Executor = Pick<NodePgDatabase, 'select' | 'execute'>;

// A window as the panel and the captain app read it, with its zones' names.
export interface PeakWindowView extends PeakWindow {
  zones: { id: string; name: string }[];
}

export interface PeakVersionView {
  id: string;
  enabled: boolean;
  currency: string;
  effectiveFrom: Date;
  windows: PeakWindowView[];
}

// AP §9.12.5: what the panel shows, the version in force and the change
// waiting for the end of the current window (null without one).
export interface PeakBonusState {
  inForce: PeakVersionView | null;
  pending: PeakVersionView | null;
}

// The bonus one delivered order earns at a moment: its amount, by the version
// in force then (null when no bonus applies).
export interface PeakBonusAmount {
  amount: bigint;
  currency: string;
  versionId: string;
}

// CA §12.5: a window running now, the home screen's «مكافأة الذروة الآن:
// +{المبلغ} لكل طلب حتى {الساعة}».
export interface ActivePeakWindow {
  amount: bigint;
  currency: string;
  // When this occurrence of the window started (CA §14 #23's push).
  since: Date;
  until: Date;
  zones: { id: string; name: string }[];
}

// AP §9.12.5 «مكافأة ساعة الذروة» (D15): the city's peak bonus versions,
// saved by the owner, and the bonus a delivered order earns.
@Injectable()
export class PeakBonusService implements OnModuleInit {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly fx: FxService,
    private readonly geo: GeoService,
    private readonly audit: AuditService,
  ) {}

  // The latest version, while it is on, is in the city's base currency, so
  // fx refuses a base change under it.
  onModuleInit(): void {
    this.fx.useCityAmounts(async (cityId, executor) => {
      const { rows } = await executor.execute<{ key: string; currency: string; enabled: boolean }>(
        sql`SELECT 'captain.peak_bonus' AS key, currency, enabled
              FROM captains.peak_bonus_versions WHERE city_id = ${cityId}
              ORDER BY created_at DESC, id DESC LIMIT 1`,
      );
      return rows.filter((row) => row.enabled).map(({ key, currency }) => ({ key, currency }));
    });
  }

  async state(cityId: string, now: Date): Promise<PeakBonusState> {
    const versions = await this.versions(cityId, this.database.db);
    const inForce = versionInForce(versions, now);
    const last = versions.at(-1) ?? null;
    const pending = last !== null && last.effectiveFrom > now ? last : null;
    const names = await this.zoneNames(cityId);
    return { inForce: inForce && view(inForce, names), pending: pending && view(pending, names) };
  }

  // A new version (OWN, AP §9.12.5): enabling or raising at once, lowering or
  // disabling at the end of the current window (takesEffect), each window's
  // zones the city's own; a newer version replaces one still waiting.
  async setPeakBonus(
    cityId: string,
    next: { enabled: boolean; windows: PeakWindow[] },
    change: CaptainChange,
  ): Promise<PeakVersionView> {
    const problem = checkPeakWindows(next.windows);
    if (problem !== null) throw new CaptainsRefusedError('invalid_peak_bonus', problem);
    const zoneIds = new Set((await this.geo.zones(cityId)).map((zone) => zone.id));
    if (next.windows.some((window) => window.zoneIds.some((id) => !zoneIds.has(id)))) {
      throw new CaptainsRefusedError('invalid_peak_bonus', 'a zone is not one of the city');
    }
    const timeZone = await this.geo.cityTimeZone(cityId);
    if (timeZone === null) throw new Error(`city ${cityId} not found`);
    const editor = change.actor;
    if (editor.type !== 'admin' && editor.type !== 'system') {
      throw new Error(`a ${editor.type} does not set the peak bonus`);
    }
    const editorType = editor.type;
    const saved = await this.database.db.transaction(async (tx) => {
      // Two versions of one city take turns.
      await tx.execute(
        sql`SELECT pg_advisory_xact_lock(hashtextextended(${`peak-bonus:${cityId}`}, 0))`,
      );
      await lockCityCurrencies(tx, cityId);
      const currency = await this.fx.baseCurrency(cityId, tx);
      if (currency === null) {
        throw new CaptainsRefusedError(
          'not_in_base_currency',
          'the peak bonus is in the base currency, not chosen yet',
        );
      }
      const [{ now }] = (await tx
        .execute<{ now: Date }>(sql`SELECT now() AS now`)
        .then((result) => result.rows)) as [{ now: Date }];
      const createdAt = new Date(now);
      const versions = await this.versions(cityId, tx);
      const current = versionInForce(versions, createdAt);
      const effectiveFrom = takesEffect(
        // A version in an earlier base pays nothing now (bonusFor).
        current?.currency === currency ? current : null,
        next,
        createdAt,
        localClock(createdAt, timeZone),
      );
      const [{ id }] = (await tx
        .insert(peakBonusVersions)
        .values({
          cityId,
          enabled: next.enabled,
          currency,
          effectiveFrom,
          editorType,
          editorId: editor.id,
          createdAt,
        })
        .returning({ id: peakBonusVersions.id })) as [{ id: string }];
      if (next.windows.length > 0) {
        await tx
          .insert(peakBonusWindows)
          .values(next.windows.map((window, position) => ({ versionId: id, position, ...window })));
      }
      await this.audit.recordWrite(
        {
          actor: change.actor,
          context: change.context,
          cityId,
          action: 'peak_bonus.set',
          target: { type: 'peak_bonus', id },
          before: current && auditOf(current),
          after: auditOf({ enabled: next.enabled, currency, effectiveFrom, windows: next.windows }),
          reason: change.reason ?? null,
        },
        tx,
      );
      return { id, enabled: next.enabled, currency, effectiveFrom, windows: next.windows };
    });
    return view(saved, await this.zoneNames(cityId));
  }

  // AP §8.4, §9.12.5, CA §8.2: the bonus an order from a restaurant at this
  // point earns if delivered at this moment, matched on the restaurant's
  // zone; null when none applies or the version is in an earlier base.
  async bonusFor(cityId: string, restaurant: Point, at: Date): Promise<PeakBonusAmount | null> {
    const version = versionInForce(await this.versions(cityId, this.database.db), at);
    if (version === null || !version.enabled || version.windows.length === 0) return null;
    const [timeZone, zone, currency] = await Promise.all([
      this.geo.cityTimeZone(cityId),
      this.geo.zoneAt(cityId, restaurant),
      this.fx.baseCurrency(cityId),
    ]);
    if (timeZone === null || currency !== version.currency) return null;
    const amount = bonusAt(version, localClock(at, timeZone), zone?.id ?? null);
    return amount > 0n ? { amount, currency, versionId: version.id } : null;
  }

  // CA §12.5: the windows running now, each with its amount, its end and its
  // zones (none: every zone).
  async activeNow(cityId: string, now: Date): Promise<ActivePeakWindow[]> {
    const version = versionInForce(await this.versions(cityId, this.database.db), now);
    if (version === null || !version.enabled) return [];
    const timeZone = await this.geo.cityTimeZone(cityId);
    if (timeZone === null) return [];
    const running = activeWindows(version.windows, localClock(now, timeZone));
    if (running.length === 0) return [];
    const names = await this.zoneNames(cityId);
    return running.map(({ window, startedSecondsAgo, endsInSeconds }) => ({
      amount: window.amount,
      currency: version.currency,
      // The whole minute it started, the same on every read.
      since: new Date(Math.floor((now.getTime() - startedSecondsAgo * 1000) / 60_000) * 60_000),
      until: new Date(now.getTime() + endsInSeconds * 1000),
      zones: zonesOf(window, names),
    }));
  }

  // The city's versions in the order they were saved, with their windows.
  private async versions(cityId: string, executor: Executor): Promise<PeakVersion[]> {
    const rows = await executor
      .select()
      .from(peakBonusVersions)
      .where(eq(peakBonusVersions.cityId, cityId))
      .orderBy(asc(peakBonusVersions.createdAt), asc(peakBonusVersions.id));
    if (rows.length === 0) return [];
    const windows = await executor
      .select()
      .from(peakBonusWindows)
      .where(
        inArray(
          peakBonusWindows.versionId,
          rows.map((row) => row.id),
        ),
      )
      .orderBy(asc(peakBonusWindows.versionId), asc(peakBonusWindows.position));
    return rows.map((row) => ({
      id: row.id,
      enabled: row.enabled,
      currency: row.currency,
      effectiveFrom: row.effectiveFrom,
      createdAt: row.createdAt,
      windows: windows
        .filter((window) => window.versionId === row.id)
        .map(({ days, startMinute, endMinute, amount, zoneIds }) => ({
          days,
          startMinute,
          endMinute,
          amount,
          zoneIds,
        })),
    }));
  }

  private async zoneNames(cityId: string): Promise<Map<string, string>> {
    return new Map((await this.geo.zones(cityId)).map((zone) => [zone.id, zone.name]));
  }
}

function zonesOf(window: PeakWindow, names: Map<string, string>) {
  return window.zoneIds.map((id) => ({ id, name: names.get(id) ?? '' }));
}

function view(
  version: Pick<PeakVersion, 'id' | 'enabled' | 'currency' | 'effectiveFrom' | 'windows'>,
  names: Map<string, string>,
): PeakVersionView {
  return {
    id: version.id,
    enabled: version.enabled,
    currency: version.currency,
    effectiveFrom: version.effectiveFrom,
    windows: version.windows.map((window) => ({ ...window, zones: zonesOf(window, names) })),
  };
}

// The audit log keeps the amounts as strings.
function auditOf(version: Pick<PeakVersion, 'enabled' | 'currency' | 'effectiveFrom' | 'windows'>) {
  return {
    enabled: version.enabled,
    currency: version.currency,
    effectiveFrom: version.effectiveFrom.toISOString(),
    windows: version.windows.map((window) => ({ ...window, amount: window.amount.toString() })),
  };
}
