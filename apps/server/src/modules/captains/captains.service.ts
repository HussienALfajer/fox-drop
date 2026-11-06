import { Inject, Injectable, Logger, type OnModuleInit } from '@nestjs/common';
import { and, desc, eq, gte, isNull, lte, sql } from 'drizzle-orm';
import type { NodePgDatabase } from 'drizzle-orm/node-postgres';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { type AuditActor, type AuditRequestContext, AuditService } from '../audit/index.js';
import { FxService } from '../fx/index.js';
import { GeoService, lastCutoff, type Point, straightLineMetres } from '../geo/index.js';
import { type JournalType, LedgerService } from '../ledger/index.js';
import { lockCityCurrencies, SettingsService, type Vehicle, vehicles } from '../settings/index.js';
import {
  type Availability,
  availability,
  type AvailabilityInput,
  type CaptainStatus,
  type OnlineBlock,
  onlineBlocks,
} from './availability.js';
import { LIVE_POSITION_MAX_AGE_MS, LivePositions, type NearbyCaptain } from './live-positions.js';
import { checkPayRate, orderPay, type PayRate } from './pay.js';
import { captainRecords, locations, onlinePeriods, payRates, payTables } from './schema.js';

export type CaptainsRefusal =
  | 'unknown_captain'
  | 'invalid_captain'
  | 'invalid_pay_table'
  | 'not_in_base_currency'
  | 'status_change_not_allowed'
  | 'reason_required'
  | 'online_blocked'
  | 'not_online'
  | 'invalid_location'
  | 'active_order';

// A change the captains module refuses, with the reason the routes map to
// their own answers; going online carries its blocks (CA §7.2).
export class CaptainsRefusedError extends Error {
  override readonly name = 'CaptainsRefusedError';
  constructor(
    readonly refusal: CaptainsRefusal,
    message: string,
    readonly blocks: OnlineBlock[] = [],
  ) {
    super(message);
  }
}

// Who changes a captain or a pay table and why, for the audit log.
export interface CaptainChange {
  actor: AuditActor;
  context: AuditRequestContext;
  reason?: string | null;
}

// Integer minor units with their currency (AP §8.6).
export interface Money {
  amount: bigint;
  currency: string;
}

export interface NewCaptain {
  name: string;
  vehicle: Vehicle;
  plateNumber?: string | null;
  // D10: required before activation, in the city's base currency.
  custodyLimit: Money;
}

export interface Captain {
  id: string;
  cityId: string;
  name: string;
  vehicle: Vehicle;
  plateNumber: string | null;
  status: CaptainStatus;
  suspension: { reason: string; until: Date | null } | null;
  custodyLimit: Money;
}

export interface PayTable {
  id: string;
  currency: string;
  effectiveFrom: Date;
  rates: Record<Vehicle, PayRate>;
}

// A captain's cash now (AP §8.5.3–8.5.4), in the city's base currency.
export interface Custody {
  // The positive custody positions, converted at current rates.
  usage: Money;
  limit: Money;
  // At captain.custody_warn_pct of the limit or more.
  warn: boolean;
  // Counted at the last business-day cutoff.
  closedDue: Money;
  lastCutoff: Date;
}

// One point the app sends while online (CA §4.3), every 10 seconds, or
// queued while it had no signal.
export interface LocationPoint {
  latitude: number;
  longitude: number;
  accuracyMetres: number;
  recordedAt: Date;
  simulated: boolean;
}

// A point recorded later than this after the server's clock is refused.
const LOCATION_CLOCK_SKEW_MS = 60_000;

export interface CaptainState {
  availability: Availability;
  custody: Custody;
}

type Executor = Pick<NodePgDatabase, 'select' | 'execute'>;

// Which of these captains have an active order (AP §9.12.6), read by the
// module that owns the orders (ordering registers it), through the executor
// given, so a transaction sees its own writes.
export type ActiveOrderLookup = (
  captainIds: string[],
  executor: Pick<NodePgDatabase, 'select'>,
) => Promise<Set<string>>;

// AP §9.3.2: why a captain near the restaurant cannot take an order now; the
// assignment picker greys them out with it. The maximum pickup amount (C4)
// joins with its slice.
export type IneligibleReason =
  | 'busy'
  | 'cash_limit'
  | 'closed_due'
  | 'simulated_location'
  | 'out_of_range'
  | 'vehicle_not_allowed';

// An online captain seen from a restaurant (AP §9.3.2, §9.12.6): the live
// position, the straight-line distance to it and the reasons the captain
// cannot take the order; eligible with none.
export interface Candidate {
  captainId: string;
  name: string;
  vehicle: Vehicle;
  position: Point;
  straightMetres: number;
  custody: Custody;
  reasons: IneligibleReason[];
}

// The picker lists every online captain of the city with a live position,
// greying out those beyond dispatch.search_radius_km; a city is far smaller.
const CITY_LIST_RADIUS_METRES = 100_000;
type Tx = Parameters<Parameters<Database['db']['transaction']>[0]>[0];

// AP §8.5.4: the desk entries posted after the cutoff settle the closed days.
const deskTypes: JournalType[] = [
  'custody.hand_in',
  'custody.reimburse',
  'custody.fx_convert',
  'custody.adjustment',
];

// AP §9.7.5: the status changes allowed; every one needs a reason.
const statusChanges: Record<CaptainStatus, CaptainStatus[]> = {
  active: ['suspended', 'terminated'],
  suspended: ['active', 'suspended', 'terminated'],
  terminated: [],
};

// AP §9.12.5: a change to the pay table takes effect 7 days or more after it
// is published (fixed); a city's first table takes effect when published
// (owner decision 2026-11-06).
const PAY_TABLE_NOTICE_MS = 7 * 86_400_000;

// The captain record, its cash limit, its availability and the city's pay
// table (architecture §4.2; AP §9.7, §9.12.5; CA §7). Money is read through
// LedgerService only.
@Injectable()
export class CaptainsService implements OnModuleInit {
  private readonly logger = new Logger('CaptainsService');
  // None until ordering registers its lookup (useActiveOrders).
  private activeOrders: ActiveOrderLookup = () => Promise.resolve(new Set());
  // Told once a captain's online period ended and committed (onWentOffline).
  private readonly offlineListeners: ((captainId: string, now: Date) => Promise<void>)[] = [];

  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly settings: SettingsService,
    private readonly fx: FxService,
    private readonly geo: GeoService,
    private readonly ledger: LedgerService,
    private readonly audit: AuditService,
    private readonly positions: LivePositions,
  ) {}

  // The cash limits and the pay tables in force or to come are in the city's
  // base currency, so fx refuses a base change while one is in another.
  onModuleInit(): void {
    this.fx.useCityAmounts(async (cityId, executor) => {
      const { rows } = await executor.execute<{ key: string; currency: string }>(sql`
        SELECT 'captain.custody_limit' AS key, custody_limit_currency AS currency
          FROM captains.captains WHERE city_id = ${cityId} AND status <> 'terminated'
        UNION
        SELECT 'captain.pay_table' AS key, currency FROM captains.pay_tables
          WHERE city_id = ${cityId} AND (effective_from > now() OR id = (
            SELECT id FROM captains.pay_tables WHERE city_id = ${cityId} AND effective_from <= now()
              ORDER BY effective_from DESC, id DESC LIMIT 1))`);
      return rows;
    });
  }

  // The ordering module tells which captains have an active order, so
  // captains never reads its tables.
  useActiveOrders(lookup: ActiveOrderLookup): void {
    this.activeOrders = lookup;
  }

  // Dispatch withdraws a captain's open offer once the captain is offline
  // (going offline, a suspension, a termination), so the order is free again
  // at once. A listener that fails is logged and never undoes the offline.
  onWentOffline(listener: (captainId: string, now: Date) => Promise<void>): void {
    this.offlineListeners.push(listener);
  }

  // The start of the captain's open online period, or null while offline:
  // C3 counts the offers of this period only (CA §7.4).
  async onlineSince(captainId: string): Promise<Date | null> {
    const [open] = await this.database.db
      .select({ startedAt: onlinePeriods.startedAt })
      .from(onlinePeriods)
      .where(and(eq(onlinePeriods.captainId, captainId), isNull(onlinePeriods.endedAt)));
    return open?.startedAt ?? null;
  }

  private async wentOffline(captainId: string, now: Date): Promise<void> {
    for (const listener of this.offlineListeners) {
      try {
        await listener(captainId, now);
      } catch (error) {
        this.logger.error({ err: error, captainId }, 'an offline listener failed');
      }
    }
  }

  // AP §9.7.1: an activated captain, with the vehicle and the cash limit the
  // activation needs. The pipeline before it comes with its slice.
  async createCaptain(cityId: string, captain: NewCaptain, change: CaptainChange) {
    const name = captain.name.trim();
    const plateNumber = captain.plateNumber?.trim() || null;
    if (name.length === 0) throw new CaptainsRefusedError('invalid_captain', 'a name is required');
    if (!vehicles.includes(captain.vehicle)) {
      throw new CaptainsRefusedError('invalid_captain', `${captain.vehicle} is not a vehicle`);
    }
    if ((captain.vehicle === 'motorbike' || captain.vehicle === 'car') && plateNumber === null) {
      throw new CaptainsRefusedError('invalid_captain', 'a motor vehicle needs its plate number');
    }
    checkLimit(captain.custodyLimit);
    return this.database.db.transaction(async (tx) => {
      await this.checkBaseCurrency(tx, cityId, captain.custodyLimit.currency);
      const [{ id }] = (await tx
        .insert(captainRecords)
        .values({
          cityId,
          name,
          vehicle: captain.vehicle,
          plateNumber,
          custodyLimit: captain.custodyLimit.amount,
          custodyLimitCurrency: captain.custodyLimit.currency,
        })
        .returning({ id: captainRecords.id })) as [{ id: string }];
      await this.audit.recordWrite(
        {
          actor: change.actor,
          context: change.context,
          cityId,
          action: 'captain.create',
          target: { type: 'captain', id },
          before: null,
          after: {
            name,
            vehicle: captain.vehicle,
            plateNumber,
            custodyLimit: moneyOf(captain.custodyLimit),
          },
          reason: change.reason ?? null,
        },
        tx,
      );
      return id;
    });
  }

  // The captain as they are now: a suspension past its end reads as active.
  async captain(captainId: string, now: Date): Promise<Captain | null> {
    const [row] = await this.database.db
      .select()
      .from(captainRecords)
      .where(eq(captainRecords.id, captainId));
    return row ? captainOf(row, now) : null;
  }

  // Whether the city has a pay table, in force or to come, for the seed.
  async hasPayTable(cityId: string): Promise<boolean> {
    const [table] = await this.database.db
      .select({ id: payTables.id })
      .from(payTables)
      .where(eq(payTables.cityId, cityId))
      .limit(1);
    return table !== undefined;
  }

  // The captains of a city by name, for the seed.
  async captainIds(cityId: string): Promise<{ id: string; name: string }[]> {
    return this.database.db
      .select({ id: captainRecords.id, name: captainRecords.name })
      .from(captainRecords)
      .where(eq(captainRecords.cityId, cityId));
  }

  // AP §9.7.5: suspend (until a moment or further notice), reactivate or
  // terminate, each with a reason. Suspending a suspended captain replaces
  // the suspension (a new reason or end); one past its end counts as active. An online captain goes offline at once; an
  // active order would keep them in last-order mode (K18), which comes with
  // the ordering slices.
  async setStatus(
    captainId: string,
    status: CaptainStatus,
    change: CaptainChange & { until?: Date | null },
    now: Date,
  ): Promise<void> {
    if (!hasReason(change)) {
      throw new CaptainsRefusedError('reason_required', `becoming ${status} needs a reason`);
    }
    if (status !== 'suspended' && change.until != null) {
      throw new CaptainsRefusedError('invalid_captain', 'only a suspension has an end');
    }
    if (change.until != null && change.until <= now) {
      throw new CaptainsRefusedError('invalid_captain', 'a suspension ends after now');
    }
    const { cityId, ended } = await this.database.db.transaction(async (tx) => {
      const row = await this.lockCaptain(tx, captainId);
      const current = captainOf(row, now).status;
      if (!statusChanges[current].includes(status)) {
        throw new CaptainsRefusedError(
          'status_change_not_allowed',
          `a ${current} captain cannot become ${status}`,
        );
      }
      const until = change.until ?? null;
      await tx
        .update(captainRecords)
        .set({
          status,
          suspensionReason: status === 'suspended' ? change.reason!.trim() : null,
          suspendedUntil: until,
          updatedAt: sql`now()`,
        })
        .where(eq(captainRecords.id, captainId));
      const ended =
        status === 'active'
          ? null
          : await this.endOnline(
              tx,
              captainId,
              status === 'suspended' ? 'suspended' : 'terminated',
              now,
            );
      await this.audit.recordWrite(
        {
          actor: change.actor,
          context: change.context,
          cityId: row.cityId,
          action: 'captain.status',
          target: { type: 'captain', id: captainId },
          before: { status: current },
          after: { status, ...(until === null ? {} : { suspendedUntil: until.toISOString() }) },
          reason: change.reason ?? null,
        },
        tx,
      );
      return { cityId: row.cityId, ended };
    });
    if (ended !== null) {
      await this.positions.remove(cityId, captainId, ended);
      await this.wentOffline(captainId, now);
    }
  }

  // AP §9.7.5: a new cash limit, effective immediately, with a reason.
  async setCustodyLimit(captainId: string, limit: Money, change: CaptainChange): Promise<void> {
    if (!hasReason(change)) {
      throw new CaptainsRefusedError('reason_required', 'a cash limit change needs a reason');
    }
    checkLimit(limit);
    await this.database.db.transaction(async (tx) => {
      const row = await this.lockCaptain(tx, captainId);
      await this.checkBaseCurrency(tx, row.cityId, limit.currency);
      await tx
        .update(captainRecords)
        .set({
          custodyLimit: limit.amount,
          custodyLimitCurrency: limit.currency,
          updatedAt: sql`now()`,
        })
        .where(eq(captainRecords.id, captainId));
      await this.audit.recordWrite(
        {
          actor: change.actor,
          context: change.context,
          cityId: row.cityId,
          action: 'captain.custody_limit',
          target: { type: 'captain', id: captainId },
          before: {
            custodyLimit: moneyOf({ amount: row.custodyLimit, currency: row.custodyLimitCurrency }),
          },
          after: { custodyLimit: moneyOf(limit) },
          reason: change.reason ?? null,
        },
        tx,
      );
    });
  }

  // AP §9.12.5: a new version of the city's pay table, one rate per vehicle,
  // never changed. The first takes effect now (or later); every later one 7
  // days or more after it is published, from that moment by default.
  async setPayTable(
    cityId: string,
    table: { currency: string; rates: Record<Vehicle, PayRate>; effectiveFrom?: Date },
    change: CaptainChange,
  ): Promise<string> {
    if (!hasReason(change)) {
      throw new CaptainsRefusedError('reason_required', 'a pay table needs a reason');
    }
    for (const vehicle of vehicles) {
      const rate = table.rates[vehicle];
      const problem = rate === undefined ? `${vehicle} has no rate` : checkPayRate(rate);
      if (problem !== null) throw new CaptainsRefusedError('invalid_pay_table', problem);
    }
    if (Object.keys(table.rates).some((key) => !vehicles.includes(key as Vehicle))) {
      throw new CaptainsRefusedError('invalid_pay_table', 'a rate is for an unknown vehicle');
    }
    const editor = change.actor;
    if (editor.type !== 'admin' && editor.type !== 'system') {
      throw new Error(`a ${editor.type} does not set a pay table`);
    }
    const editorType = editor.type;
    return this.database.db.transaction(async (tx) => {
      // Two versions of one city take turns.
      await tx.execute(
        sql`SELECT pg_advisory_xact_lock(hashtextextended(${`pay-table:${cityId}`}, 0))`,
      );
      await this.checkBaseCurrency(tx, cityId, table.currency);
      const [{ now }] = (await tx
        .execute<{ now: Date }>(sql`SELECT now() AS now`)
        .then((result) => result.rows)) as [{ now: Date }];
      const published = new Date(now).getTime();
      const [{ count }] = (await tx
        .select({ count: sql<number>`count(*)::int` })
        .from(payTables)
        .where(eq(payTables.cityId, cityId))) as [{ count: number }];
      const earliest = count === 0 ? published : published + PAY_TABLE_NOTICE_MS;
      const effectiveFrom = table.effectiveFrom ?? new Date(earliest);
      if (effectiveFrom.getTime() < earliest) {
        throw new CaptainsRefusedError(
          'invalid_pay_table',
          count === 0
            ? 'a pay table takes effect now or later'
            : 'a pay table change takes effect 7 days or more after it is published',
        );
      }
      const [{ id }] = (await tx
        .insert(payTables)
        .values({
          cityId,
          currency: table.currency,
          effectiveFrom,
          editorType,
          editorId: editor.id,
          reason: change.reason!.trim(),
        })
        .returning({ id: payTables.id })) as [{ id: string }];
      await tx
        .insert(payRates)
        .values(vehicles.map((vehicle) => ({ tableId: id, vehicle, ...table.rates[vehicle] })));
      await this.audit.recordWrite(
        {
          actor: change.actor,
          context: change.context,
          cityId,
          action: 'pay_table.create',
          target: { type: 'pay_table', id },
          before: null,
          after: {
            currency: table.currency,
            effectiveFrom: effectiveFrom.toISOString(),
            rates: Object.fromEntries(
              vehicles.map((vehicle) => [vehicle, rateOf(table.rates[vehicle])]),
            ),
          },
          reason: change.reason ?? null,
        },
        tx,
      );
      return id;
    });
  }

  // The version in force at a moment: the latest start reached; of two with
  // the same start, the later version.
  async payTable(cityId: string, at: Date): Promise<PayTable | null> {
    const [table] = await this.database.db
      .select()
      .from(payTables)
      .where(and(eq(payTables.cityId, cityId), lte(payTables.effectiveFrom, at)))
      .orderBy(desc(payTables.effectiveFrom), desc(payTables.id))
      .limit(1);
    if (!table) return null;
    const rows = await this.database.db
      .select()
      .from(payRates)
      .where(eq(payRates.tableId, table.id));
    const rates = Object.fromEntries(
      rows.map((row) => [
        row.vehicle,
        {
          basePay: row.basePay,
          includedMetres: row.includedMetres,
          perExtraKm: row.perExtraKm,
          waitingPerMinute: row.waitingPerMinute,
          minimumPay: row.minimumPay,
        },
      ]),
    ) as Record<Vehicle, PayRate>;
    return { id: table.id, currency: table.currency, effectiveFrom: table.effectiveFrom, rates };
  }

  // AP §9.12.6, the capacity check: whether an eligible captain is within
  // dispatch.search_radius_km of the restaurant now (nearestEligible).
  async eligibleNear(
    cityId: string,
    restaurant: Point,
    tripMetres: number,
    now: Date,
  ): Promise<boolean> {
    return (await this.nearestEligible(cityId, restaurant, tripMetres, now)) !== null;
  }

  // The nearest eligible captain within dispatch.search_radius_km of the
  // restaurant now, with its vehicle and live position, or null (the capacity
  // check and the search start). Eligible is a candidate without a reason
  // (candidates); the maximum pickup amount is ignored, as AP §9.12.6 says.
  async nearestEligible(
    cityId: string,
    restaurant: Point,
    tripMetres: number,
    now: Date,
  ): Promise<(NearbyCaptain & { vehicle: Vehicle }) | null> {
    const radiusMetres = (await this.settings.get('dispatch.search_radius_km', { cityId })) * 1000;
    const [first] = await this.scan(cityId, restaurant, tripMetres, now, radiusMetres, true);
    return first
      ? { captainId: first.captainId, position: first.position, vehicle: first.vehicle }
      : null;
  }

  // AP §9.3.2, the assignment picker: every online captain of the city with a
  // live position, nearest to the restaurant first by the straight line, each
  // with the reasons it cannot take an order of this trip now (AP §9.12.6):
  // busy with an active order, at the cash limit, blocked for unhanded cash,
  // a simulated location, beyond dispatch.search_radius_km, or a vehicle
  // whose dispatch.max_distance_km.<vehicle> is below the trip.
  async candidates(
    cityId: string,
    restaurant: Point,
    tripMetres: number,
    now: Date,
  ): Promise<Candidate[]> {
    const radiusMetres = (await this.settings.get('dispatch.search_radius_km', { cityId })) * 1000;
    return this.scan(cityId, restaurant, tripMetres, now, radiusMetres, false);
  }

  // Dispatch's lock on a captain (AP §9.12.6): with the city's rules read
  // now, outside any transaction, a function that locks the captain row in
  // the command's transaction and answers the state, which going offline and
  // another assignment then wait for.
  async assignmentLock(
    cityId: string,
    now: Date,
  ): Promise<(tx: Tx, captainId: string) => Promise<Availability>> {
    const rules = await this.cityRules(cityId, now);
    return async (tx, captainId) => {
      const row = await this.lockCaptain(tx, captainId);
      const input = await this.input(tx, row, rules);
      return availability(input.availability, now);
    };
  }

  // C3, AP §9.7.6: after captain.offer_expiry_offline_count expired offers in
  // a row, the captain goes offline; never with an active order.
  async offlineForUnansweredOffers(captainId: string, now: Date): Promise<boolean> {
    const cityId = (await this.row(this.database.db, captainId)).cityId;
    const ended = await this.database.db.transaction(async (tx) => {
      await this.lockCaptain(tx, captainId);
      if ((await this.activeOrders([captainId], tx)).size > 0) return null;
      return this.endOnline(tx, captainId, 'offers_expired', now);
    });
    if (ended === null) return false;
    await this.positions.remove(cityId, captainId, ended);
    await this.wentOffline(captainId, now);
    return true;
  }

  // AP §9.12.5, CA §8.2: an order's pay by the pay table it kept, for the
  // vehicle and the trip, before any waiting.
  async orderPay(payTableId: string, vehicle: Vehicle, metres: number): Promise<Money | null> {
    const [table] = await this.database.db
      .select({ currency: payTables.currency })
      .from(payTables)
      .where(eq(payTables.id, payTableId));
    const [rate] = await this.database.db
      .select()
      .from(payRates)
      .where(and(eq(payRates.tableId, payTableId), eq(payRates.vehicle, vehicle)));
    if (!table || !rate) return null;
    return { amount: orderPay(rate, { metres, waitingMinutes: 0 }), currency: table.currency };
  }

  // The live positions come from Valkey, or from the locations table when
  // Valkey cannot answer (architecture §5.7), nearest first; then, with the
  // city's rules read once, each captain's record and state. A captain whose
  // state cannot be read (such as a currency without a rate) is logged and
  // left out, never failing the quote. With firstEligible, only the nearest
  // eligible one within the radius, reading no further than it.
  private async scan(
    cityId: string,
    restaurant: Point,
    tripMetres: number,
    now: Date,
    radiusMetres: number,
    firstEligible: boolean,
  ): Promise<Candidate[]> {
    const listRadius = firstEligible ? radiusMetres : CITY_LIST_RADIUS_METRES;
    const nearby =
      (await this.positions.near(cityId, restaurant, listRadius, now)) ??
      (await this.nearFromLocations(cityId, restaurant, listRadius, now));
    if (nearby.length === 0) return [];
    const rules = await this.cityRules(cityId, now);
    const maxMetres = new Map<Vehicle, number>();
    const found: Candidate[] = [];
    for (const captain of nearby) {
      try {
        const row = await this.row(this.database.db, captain.captainId);
        if (row.cityId !== cityId) continue;
        let vehicleMax = maxMetres.get(row.vehicle);
        if (vehicleMax === undefined) {
          const maxKm = await this.settings.get(`dispatch.max_distance_km.${row.vehicle}`, {
            cityId,
          });
          vehicleMax = maxKm * 1000;
          maxMetres.set(row.vehicle, vehicleMax);
        }
        if (firstEligible && tripMetres > vehicleMax) continue;
        const input = await this.input(this.database.db, row, rules);
        const state = availability(input.availability, now);
        if (state.state === 'offline' || state.state === 'suspended') continue;
        const straightMetres = Math.round(straightLineMetres(captain.position, restaurant));
        const reasons: IneligibleReason[] = [];
        if (state.state === 'busy') reasons.push('busy');
        if (state.state === 'not_receiving_offers') reasons.push(...state.reasons);
        if (straightMetres > radiusMetres) reasons.push('out_of_range');
        if (tripMetres > vehicleMax) reasons.push('vehicle_not_allowed');
        if (firstEligible && reasons.length > 0) continue;
        found.push({
          captainId: row.id,
          name: row.name,
          vehicle: row.vehicle,
          position: captain.position,
          straightMetres,
          custody: input.custody,
          reasons,
        });
        if (firstEligible) return found;
      } catch (error) {
        this.logger.warn(
          { err: error, captainId: captain.captainId },
          'a nearby captain was left out',
        );
      }
    }
    return found;
  }

  // The newest real point of each open online period within the radius, no
  // older than the live position may be (LIVE_POSITION_MAX_AGE_MS), nearest
  // first: what Valkey holds, read from PostgreSQL.
  private async nearFromLocations(
    cityId: string,
    point: Point,
    radiusMetres: number,
    now: Date,
  ): Promise<NearbyCaptain[]> {
    const at = sql`ST_SetSRID(ST_MakePoint(${point.longitude}, ${point.latitude}), 4326)::geography`;
    const since = new Date(now.getTime() - LIVE_POSITION_MAX_AGE_MS).toISOString();
    const { rows } = await this.database.db.execute<{
      captain_id: string;
      latitude: number;
      longitude: number;
    }>(sql`
      SELECT p.captain_id, ST_Y(newest.location) AS latitude, ST_X(newest.location) AS longitude
        FROM ${onlinePeriods} p
        JOIN ${captainRecords} c ON c.id = p.captain_id
        CROSS JOIN LATERAL (
          SELECT l.location FROM ${locations} l
            WHERE l.captain_id = p.captain_id AND l.recorded_at >= p.started_at
              AND l.recorded_at >= ${since} AND NOT l.simulated
            ORDER BY l.recorded_at DESC LIMIT 1
        ) newest
        WHERE p.ended_at IS NULL AND c.city_id = ${cityId}
          AND ST_DWithin(newest.location::geography, ${at}, ${radiusMetres})
        ORDER BY ST_Distance(newest.location::geography, ${at})`);
    return rows.map((row) => ({
      captainId: row.captain_id,
      position: { latitude: Number(row.latitude), longitude: Number(row.longitude) },
    }));
  }

  // The captain's state and cash now (CA §7.1, AP §8.5.3–8.5.4).
  async state(captainId: string, now: Date): Promise<CaptainState> {
    const row = await this.row(this.database.db, captainId);
    const rules = await this.cityRules(row.cityId, now);
    const input = await this.input(this.database.db, row, rules);
    return { availability: availability(input.availability, now), custody: input.custody };
  }

  // CA §7.2: going online, refused with every block that applies. Already
  // online answers the state as it is.
  async goOnline(
    captainId: string,
    device: { appVersion: string | null; simulatedLocation: boolean },
    now: Date,
  ): Promise<CaptainState> {
    const cityId = (await this.row(this.database.db, captainId)).cityId;
    const rules = await this.cityRules(cityId, now);
    return this.database.db.transaction(async (tx) => {
      const row = await this.lockCaptain(tx, captainId);
      const input = await this.input(tx, row, rules);
      if (input.availability.onlineSince === null) {
        const blocks = onlineBlocks(
          {
            ...input.availability,
            appVersion: device.appVersion,
            simulatedLocation: device.simulatedLocation,
          },
          now,
        );
        if (blocks.length > 0) {
          throw new CaptainsRefusedError('online_blocked', 'the captain cannot go online', blocks);
        }
        await tx
          .insert(onlinePeriods)
          .values({ captainId, startedAt: now, appVersion: device.appVersion });
        input.availability.onlineSince = now;
      }
      return { availability: availability(input.availability, now), custody: input.custody };
    });
  }

  // CA §7.5: one tap with no active order. The answer carries the cash to
  // hand in above captain.remit_tolerance, for the reminder, or null.
  async goOffline(captainId: string, now: Date): Promise<{ handIn: Money | null }> {
    const cityId = (await this.row(this.database.db, captainId)).cityId;
    const rules = await this.cityRules(cityId, now);
    const ended = await this.database.db.transaction(async (tx) => {
      await this.lockCaptain(tx, captainId);
      // CA §15: not with an active order; an assignment locks the captain
      // too, so none can slip in between.
      if ((await this.activeOrders([captainId], tx)).size > 0) {
        throw new CaptainsRefusedError('active_order', 'the captain has an active order');
      }
      return this.endOnline(tx, captainId, 'captain', now);
    });
    if (ended !== null) {
      await this.positions.remove(cityId, captainId, ended);
      await this.wentOffline(captainId, now);
    }
    // After the offline commits, so reading the cash can never undo it.
    const row = await this.row(this.database.db, captainId);
    const { custody } = await this.input(this.database.db, row, rules);
    const held = custody.usage.amount;
    return { handIn: held > rules.remitTolerance ? { ...custody.usage } : null };
  }

  // CA §4.3, architecture §7.3: the points recorded inside one of the
  // captain's online periods, kept for routes and disputes (a point queued
  // without a signal included); the newest real point of the open period is
  // the live position. A point recorded offline is dropped, since nothing is
  // collected then, and so is one older than the partitions; a point sent
  // again is kept once. Refused (not_online) when the captain is offline and
  // no point belongs to an online period.
  async recordLocations(
    captainId: string,
    points: LocationPoint[],
    now: Date,
  ): Promise<{ accepted: number }> {
    for (const point of points) {
      if (point.recordedAt.getTime() > now.getTime() + LOCATION_CLOCK_SKEW_MS) {
        throw new CaptainsRefusedError('invalid_location', 'a point is recorded in the future');
      }
      if (!Number.isFinite(point.accuracyMetres) || point.accuracyMetres < 0) {
        throw new CaptainsRefusedError('invalid_location', 'the accuracy is metres, 0 or more');
      }
    }
    const row = await this.row(this.database.db, captainId);
    // The partitions reach back to the start of last month (UTC).
    const oldest = Date.UTC(now.getUTCFullYear(), now.getUTCMonth() - 1, 1);
    const result = await this.database.db.transaction(async (tx) => {
      // The open period is held, so going offline waits for these points.
      const [open] = await tx
        .select({ id: onlinePeriods.id, startedAt: onlinePeriods.startedAt })
        .from(onlinePeriods)
        .where(and(eq(onlinePeriods.captainId, captainId), isNull(onlinePeriods.endedAt)))
        .for('share');
      // A point queued without a signal counts when it was recorded inside
      // one of the captain's online periods, so the route is complete.
      const first = new Date(Math.min(...points.map((point) => point.recordedAt.getTime())));
      const periods = await tx
        .select({ startedAt: onlinePeriods.startedAt, endedAt: onlinePeriods.endedAt })
        .from(onlinePeriods)
        .where(
          and(
            eq(onlinePeriods.captainId, captainId),
            sql`coalesce(${onlinePeriods.endedAt}, 'infinity') >= ${first.toISOString()}`,
          ),
        );
      const kept = points.filter(
        (point) =>
          point.recordedAt.getTime() >= oldest &&
          periods.some(
            (period) =>
              point.recordedAt >= period.startedAt &&
              (period.endedAt === null || point.recordedAt <= period.endedAt),
          ),
      );
      if (!open && kept.length === 0) return null;
      if (kept.length === 0) return { accepted: 0, open, live: [] };
      const inserted = await tx
        .insert(locations)
        .values(
          kept.map((point) => ({
            captainId,
            cityId: row.cityId,
            recordedAt: point.recordedAt,
            receivedAt: now,
            location: sql`ST_SetSRID(ST_MakePoint(${point.longitude}, ${point.latitude}), 4326)`,
            accuracyMetres: point.accuracyMetres,
            simulated: point.simulated,
          })),
        )
        .onConflictDoNothing()
        .returning({ recordedAt: locations.recordedAt });
      // A simulated point never becomes the live position.
      const live = open
        ? kept.filter((point) => !point.simulated && point.recordedAt >= open.startedAt)
        : [];
      return { accepted: inserted.length, open, live };
    });
    if (result === null) throw new CaptainsRefusedError('not_online', 'the captain is offline');
    const { open, live } = result;
    if (open && live.length > 0) {
      const newest = live.reduce((latest, point) =>
        point.recordedAt > latest.recordedAt ? point : latest,
      );
      await this.positions.set(row.cityId, captainId, open.id, newest);
    }
    return { accepted: result.accepted };
  }

  // The city's rules the state reads, outside any transaction: settings take
  // a pool connection of their own.
  private async cityRules(cityId: string, now: Date) {
    const timeZone = await this.geo.cityTimeZone(cityId);
    if (timeZone === null) throw new Error(`city ${cityId} does not exist`);
    const [cutoff, tolerance, graceHours, warnPct, minVersion] = await Promise.all([
      this.settings.get('finance.business_day_cutoff', { cityId }),
      this.settings.get('captain.remit_tolerance', { cityId }),
      this.settings.get('captain.remit_online_grace_hours', { cityId }),
      this.settings.get('captain.custody_warn_pct', { cityId }),
      this.settings.get('app.<app>.min_version', { parameter: 'captain' }),
    ]);
    const [hours, minutes] = cutoff.split(':').map(Number) as [number, number];
    return {
      lastCutoff: lastCutoff(now, hours * 60 + minutes, timeZone),
      remitTolerance: BigInt(tolerance.amountMinor),
      graceHours,
      warnPct,
      minVersion,
    };
  }

  private async input(
    executor: Tx | Database['db'],
    row: typeof captainRecords.$inferSelect,
    rules: Awaited<ReturnType<CaptainsService['cityRules']>>,
  ): Promise<{ availability: AvailabilityInput; custody: Custody }> {
    const [open] = await executor
      .select({ startedAt: onlinePeriods.startedAt, appVersion: onlinePeriods.appVersion })
      .from(onlinePeriods)
      .where(and(eq(onlinePeriods.captainId, row.id), isNull(onlinePeriods.endedAt)));
    const custody = await this.custody(executor, row, rules.lastCutoff, rules.warnPct);
    // CA §4.3: the newest point of this online period says whether the
    // location is simulated now.
    const [latest] = open
      ? await executor
          .select({ simulated: locations.simulated })
          .from(locations)
          .where(and(eq(locations.captainId, row.id), gte(locations.recordedAt, open.startedAt)))
          .orderBy(desc(locations.recordedAt))
          .limit(1)
      : [];
    return {
      availability: {
        // As stored: the rules read a suspension past its end as active.
        status: row.status,
        suspension:
          row.status === 'suspended'
            ? { reason: row.suspensionReason!, until: row.suspendedUntil }
            : null,
        onlineSince: open?.startedAt ?? null,
        custodyUsage: custody.usage.amount,
        custodyLimit: custody.limit.amount,
        closedDue: custody.closedDue.amount,
        remitTolerance: rules.remitTolerance,
        lastCutoff: rules.lastCutoff,
        remitOnlineGraceHours: rules.graceHours,
        appVersion: open?.appVersion ?? null,
        minVersion: rules.minVersion,
        simulatedLocation: latest?.simulated ?? false,
        activeOrder: open ? (await this.activeOrders([row.id], executor)).size > 0 : false,
      },
      custody,
    };
  }

  // AP §8.5.3: usage is the sum of the positive positions; AP §8.5.4: the
  // closed days' due nets every currency. Both at current rates, in base.
  private async custody(
    executor: Tx | Database['db'],
    row: typeof captainRecords.$inferSelect,
    cutoff: Date,
    warnPct: number,
  ): Promise<Custody> {
    const accounts = await this.ledger.ownerAccounts(
      row.cityId,
      row.id,
      'captain.custody',
      executor,
    );
    // Every currency counts at its current rate, a disabled one included.
    const { base, toBase } = await this.fx.currentValue(row.cityId, executor);
    const inBase = (amount: bigint, currency: string) =>
      currency === base || amount === 0n ? amount : toBase(amount, currency);
    // A limit set in another of the city's currencies before the base locked.
    const limit = inBase(row.custodyLimit, row.custodyLimitCurrency);
    let usage = 0n;
    let closedDue = 0n;
    for (const account of accounts) {
      const balance = await this.ledger.balance(account.id, executor);
      if (balance.amount > 0n) usage += inBase(balance.amount, account.currency);
      const closed = await this.ledger.balanceAt(account.id, cutoff, deskTypes, executor);
      closedDue += inBase(closed.amount, account.currency);
    }
    return {
      usage: { amount: usage, currency: base },
      limit: { amount: limit, currency: base },
      warn: usage * 100n >= limit * BigInt(warnPct),
      closedDue: { amount: closedDue, currency: base },
      lastCutoff: cutoff,
    };
  }

  private async endOnline(
    tx: Tx,
    captainId: string,
    reason: 'captain' | 'suspended' | 'terminated' | 'offers_expired',
    now: Date,
  ): Promise<string | null> {
    const [ended] = await tx
      .update(onlinePeriods)
      .set({
        endedAt: sql`greatest(${now.toISOString()}::timestamptz, started_at)`,
        endReason: reason,
      })
      .where(and(eq(onlinePeriods.captainId, captainId), isNull(onlinePeriods.endedAt)))
      .returning({ id: onlinePeriods.id });
    return ended?.id ?? null;
  }

  private async row(executor: Executor, captainId: string) {
    const [row] = await executor
      .select()
      .from(captainRecords)
      .where(eq(captainRecords.id, captainId));
    if (!row) throw new CaptainsRefusedError('unknown_captain', 'no such captain');
    return row;
  }

  private async lockCaptain(tx: Tx, captainId: string) {
    const [row] = await tx
      .select()
      .from(captainRecords)
      .where(eq(captainRecords.id, captainId))
      .for('update');
    if (!row) throw new CaptainsRefusedError('unknown_captain', 'no such captain');
    return row;
  }

  // As the merchants' amounts: the base, or until the first order locks it,
  // another of the city's currencies.
  private async checkBaseCurrency(tx: Tx, cityId: string, currency: string): Promise<void> {
    await lockCityCurrencies(tx, cityId);
    const base = await this.fx.baseCurrency(cityId, tx);
    const allowed =
      currency === base ||
      (!(await this.fx.baseLocked(cityId, tx)) &&
        (await this.fx.cityCurrencies(cityId, tx)).some((entry) => entry.currency === currency));
    if (!allowed) {
      throw new CaptainsRefusedError(
        'not_in_base_currency',
        `amounts are in the city's base currency, ${base ?? 'not chosen yet'}`,
      );
    }
  }
}

function captainOf(row: typeof captainRecords.$inferSelect, now: Date): Captain {
  const lapsed =
    row.status === 'suspended' && row.suspendedUntil !== null && row.suspendedUntil <= now;
  const status = lapsed ? 'active' : row.status;
  return {
    id: row.id,
    cityId: row.cityId,
    name: row.name,
    vehicle: row.vehicle,
    plateNumber: row.plateNumber,
    status,
    suspension:
      status === 'suspended' ? { reason: row.suspensionReason!, until: row.suspendedUntil } : null,
    custodyLimit: { amount: row.custodyLimit, currency: row.custodyLimitCurrency },
  };
}

function checkLimit(limit: Money): void {
  if (limit.amount <= 0n || limit.amount > 2n ** 63n - 1n) {
    throw new CaptainsRefusedError('invalid_captain', 'the cash limit is above zero');
  }
}

function hasReason(change: CaptainChange): boolean {
  return (change.reason ?? '').trim().length > 0;
}

// The audit log keeps amounts as strings.
function moneyOf(money: Money) {
  return { amount: money.amount.toString(), currency: money.currency };
}

function rateOf(rate: PayRate) {
  return {
    basePay: rate.basePay.toString(),
    includedMetres: rate.includedMetres,
    perExtraKm: rate.perExtraKm.toString(),
    waitingPerMinute: rate.waitingPerMinute.toString(),
    minimumPay: rate.minimumPay.toString(),
  };
}
