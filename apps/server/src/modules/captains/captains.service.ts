import { Inject, Injectable, Logger, type OnModuleInit } from '@nestjs/common';
import { and, desc, eq, gt, gte, inArray, isNull, lte, max, ne, or, sql } from 'drizzle-orm';
import type { NodePgDatabase } from 'drizzle-orm/node-postgres';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { type AuditActor, type AuditRequestContext, AuditService } from '../audit/index.js';
import { FxService } from '../fx/index.js';
import {
  GeoService,
  lastCutoff,
  nextCutoff,
  type Point,
  straightLineMetres,
} from '../geo/index.js';
import { type JournalType, LedgerService } from '../ledger/index.js';
import { lockCityCurrencies, SettingsService, type Vehicle, vehicles } from '../settings/index.js';
import {
  type Availability,
  availability,
  type AvailabilityInput,
  type CaptainStatus,
  type LastOrderBy,
  type OnlineBlock,
  onlineBlocks,
} from './availability.js';
import { LIVE_POSITION_MAX_AGE_MS, LivePositions, type NearbyCaptain } from './live-positions.js';
import { checkPayRate, orderPay, type PayParts, type PayRate } from './pay.js';
import {
  captainRecords,
  handInGraces,
  locations,
  type onlineEndReasons,
  onlinePeriods,
  payRates,
  payTables,
} from './schema.js';

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
  | 'active_order'
  // CA §7.3, §15: last-order mode needs an active order, and the captain may
  // cancel only the mode they asked for.
  | 'no_active_order'
  | 'last_order_not_yours'
  // CA §10.5: the carried currencies are the city's enabled ones, once each,
  // one at least.
  | 'invalid_carried_currencies'
  // CA §10.5, C4: «أقصى مبلغ أحمله» is above zero, in the city's base.
  | 'invalid_max_pickup'
  // AP §9.12.5: the peak windows' days, hours, amounts and zones.
  | 'invalid_peak_bonus'
  | 'unknown_city'
  // AP §8.5.4: a grace lifts a closed_due block; none is due.
  | 'nothing_due';

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

type OnlineEndReason = (typeof onlineEndReasons)[number];

// CA §7.3, §7.6, K18: how a last-order mode ends its online period once the
// order left the captain.
const LAST_ORDER_END: Record<LastOrderBy, OnlineEndReason> = {
  captain: 'last_order',
  forced: 'forced',
  suspended: 'suspended',
  terminated: 'terminated',
};

// CA §7.6, §14 #26, AP §10: a change of the captain's availability that
// another module tells the captain about, in the transaction that made it
// (onAvailabilityChanged). forced_offline: operations' «فصل من الاتصال»,
// at once (atOnce) or after the active order; offline_after_order: a
// last-order mode ended the online period when the order left the captain.
export type AvailabilityChange =
  | {
      kind: 'forced_offline';
      captainId: string;
      cityId: string;
      reason: string;
      atOnce: boolean;
      at: Date;
    }
  | { kind: 'offline_after_order'; captainId: string; cityId: string; at: Date }
  // C3, CA §7.4 (slice 2.15b): offline after `count` offers in a row
  // expired unanswered.
  | { kind: 'offers_expired'; captainId: string; cityId: string; count: number; at: Date }
  // AP §9.10.3 (slice 2.17a): the desk moved the captain's custody, so the
  // app reads its state again (the block lifts at once).
  | { kind: 'custody_changed'; captainId: string; cityId: string; at: Date }
  // AP §8.5.4, CA §14 #18 (slice 2.17b): a hand-in grace until the next
  // cutoff, «مُنحت مهلة حتى {الساعة}» on the city's clock.
  | {
      kind: 'hand_in_grace';
      captainId: string;
      cityId: string;
      graceId: string;
      until: Date;
      timeZone: string;
      at: Date;
    };

// AP §9.10.2 «أرصدة الكباتن»: one captain's money as finance lists it.
export interface CaptainBalance {
  captainId: string;
  name: string;
  status: CaptainStatus;
  custody: Custody;
  // What stops the captain now: cash due from a closed day with no grace
  // running, or the cash limit reached.
  blocks: ('closed_due' | 'cash_limit')[];
  handInGrace: HandInGrace | null;
  // captain.earnings in the base: + the platform owes the captain.
  earnings: Money;
}

// AP §8.5.4 «Hand-in grace»: the one in force for a captain, theirs or the
// city's bulk grace, with the later end.
export interface HandInGrace {
  id: string;
  until: Date;
  reason: string;
  // The bulk grace of the whole city (OWN, from the cash desk).
  bulk: boolean;
  grantedAt: Date;
}

// A captain as the desk finds them (AP §9.10.3 step 1).
export interface DeskCaptain {
  id: string;
  cityId: string;
  name: string;
  status: CaptainStatus;
}

type AvailabilityListener = (tx: Tx, change: AvailabilityChange) => Promise<void>;

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
  // CA §10.5 «العملات التي أحملها»: null until the captain sets them, the
  // base only. A reader keeps only the ones its snapshot has.
  carriedCurrencies: string[] | null;
  // CA §10.5, C4 «أقصى مبلغ أحمله»: in the city's base, null for no limit.
  maxPickup: Money | null;
}

// CA §10.5, K2 «أقصى مبلغ أحمله»: the limit (null for none), whether the
// captain has answered yet (the app asks until they do), and the base the
// amount is in.
export interface MaxPickup {
  limit: Money | null;
  answered: boolean;
  baseCurrency: string | null;
}

// CA §10.5: the carried currencies with their choices.
export interface CarriedCurrencies {
  // Null while the city has no base, with nothing to choose.
  baseCurrency: string | null;
  // In the city's display order; the base only by default.
  carried: string[];
  // Every currency the city has enabled, the base among them, with its
  // Arabic name (AP §8.6: currencies are data).
  choices: { currency: string; name: string }[];
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
  // Each custody currency as the desk shows it (AP §9.10.3 step 2), in the
  // city's display order of its accounts; a currency never held is absent.
  currencies: CustodyCurrency[];
}

// One custody currency (AP §8.5.4), in its own minor units, from the
// captain's side: + the captain must hand in, − the office owes them.
export interface CustodyCurrency {
  currency: string;
  balance: bigint;
  // The balance at the last cutoff plus the desk entries since.
  closedDue: bigint;
  // The rest: today's collections and pickup payments.
  today: bigint;
  // The balance at the current rate.
  balanceInBase: bigint;
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
  // CA §7.5: captain.remit_tolerance in the base currency; the app shows the
  // hand-in reminder when the captain goes offline (after a last order too)
  // holding more.
  remitTolerance: Money;
  // AP §8.5.4: the hand-in grace running now, or null.
  handInGrace: HandInGrace | null;
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
// assignment picker greys them out with it.
export type IneligibleReason =
  | 'busy'
  // CA §7.3, K18: last-order mode, no new orders.
  | 'last_order'
  | 'cash_limit'
  | 'closed_due'
  | 'simulated_location'
  | 'out_of_range'
  | 'vehicle_not_allowed'
  // C4, K2: the order's pickup payment is above the captain's «أقصى مبلغ
  // أحمله»; operations may still send a manual offer (CA §8.4).
  | 'above_max_pickup';

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
  // Told in the transaction of a change the captain hears of
  // (onAvailabilityChanged).
  private readonly availabilityListeners: AvailabilityListener[] = [];

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
        SELECT 'captain.max_pickup_amount' AS key, max_pickup_currency AS currency
          FROM captains.captains WHERE city_id = ${cityId} AND status <> 'terminated'
            AND max_pickup_currency IS NOT NULL
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

  // Whether the captain has an active order now (CA §4.9: identity refuses a
  // second device then).
  async hasActiveOrder(
    captainId: string,
    executor: Pick<NodePgDatabase, 'select'> = this.database.db,
  ): Promise<boolean> {
    return (await this.activeOrders([captainId], executor)).size > 0;
  }

  // Dispatch withdraws a captain's open offer once the captain is offline
  // (going offline, a suspension, a termination), so the order is free again
  // at once. A listener that fails is logged and never undoes the offline.
  onWentOffline(listener: (captainId: string, now: Date) => Promise<void>): void {
    this.offlineListeners.push(listener);
  }

  // CA §14 #26, AP §10: notifications queue the captain's push and tell the
  // open app to read its state again, in the change's transaction (E4).
  onAvailabilityChanged(listener: AvailabilityListener): void {
    this.availabilityListeners.push(listener);
  }

  private async availabilityChanged(tx: Tx, change: AvailabilityChange): Promise<void> {
    for (const listener of this.availabilityListeners) await listener(tx, change);
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

  // CA §10.5 «العملات التي أحملها»: what the captain carries of the city's
  // enabled currencies (the base until they set them), and the choices.
  async carriedCurrencies(captainId: string): Promise<CarriedCurrencies> {
    const [row] = await this.database.db
      .select({ cityId: captainRecords.cityId, carried: captainRecords.carriedCurrencies })
      .from(captainRecords)
      .where(eq(captainRecords.id, captainId));
    if (!row) throw new CaptainsRefusedError('unknown_captain', 'no such captain');
    const city = await this.fx.cityCurrencies(row.cityId);
    const base = city.find((entry) => entry.isBase);
    if (!base) return { baseCurrency: null, carried: [], choices: [] };
    const names = new Map((await this.fx.currencies()).map((each) => [each.code, each.nameAr]));
    const choices = city.filter((entry) => entry.enabled).map((entry) => entry.currency);
    const carried = row.carried ?? [base.currency];
    return {
      baseCurrency: base.currency,
      carried: choices.filter((code) => carried.includes(code)),
      choices: choices.map((currency) => ({ currency, name: names.get(currency) ?? currency })),
    };
  }

  // CA §10.5: the captain switches the currencies they carry, any time; the
  // next pickup's proposal uses them. Refused invalid_carried_currencies
  // outside the city's enabled currencies, repeated or empty. The captain's
  // own preference, as their device check, so it is not audited.
  async setCarriedCurrencies(captainId: string, currencies: string[]): Promise<CarriedCurrencies> {
    const [row] = await this.database.db
      .select({ cityId: captainRecords.cityId })
      .from(captainRecords)
      .where(eq(captainRecords.id, captainId));
    if (!row) throw new CaptainsRefusedError('unknown_captain', 'no such captain');
    const choices = (await this.fx.cityCurrencies(row.cityId))
      .filter((entry) => entry.enabled)
      .map((entry) => entry.currency);
    if (
      currencies.length === 0 ||
      new Set(currencies).size !== currencies.length ||
      currencies.some((code) => !choices.includes(code))
    ) {
      throw new CaptainsRefusedError(
        'invalid_carried_currencies',
        `the carried currencies are among ${choices.join(', ')}, once each, one at least`,
      );
    }
    await this.database.db
      .update(captainRecords)
      .set({
        carriedCurrencies: choices.filter((code) => currencies.includes(code)),
        updatedAt: sql`now()`,
      })
      .where(eq(captainRecords.id, captainId));
    return this.carriedCurrencies(captainId);
  }

  // CA §10.5, K2 «أقصى مبلغ أحمله»: the captain's limit and whether they
  // have answered.
  async maxPickup(captainId: string): Promise<MaxPickup> {
    const [row] = await this.database.db
      .select({
        cityId: captainRecords.cityId,
        amount: captainRecords.maxPickupAmount,
        currency: captainRecords.maxPickupCurrency,
        setAt: captainRecords.maxPickupSetAt,
      })
      .from(captainRecords)
      .where(eq(captainRecords.id, captainId));
    if (!row) throw new CaptainsRefusedError('unknown_captain', 'no such captain');
    return {
      limit: row.amount === null ? null : { amount: row.amount, currency: row.currency! },
      answered: row.setAt !== null,
      baseCurrency: await this.fx.baseCurrency(row.cityId),
    };
  }

  // CA §10.5: the captain sets «أقصى مبلغ أحمله» in the city's base, or
  // none, without an active order (CA §15: 409 active_order); the next offer
  // uses it. Answering none records the
  // answer too, so the app stops asking (K2). Refused invalid_max_pickup at
  // zero or below, not_in_base_currency while the city has no base. The
  // captain's own preference, so it is not audited.
  async setMaxPickup(captainId: string, amount: bigint | null): Promise<MaxPickup> {
    if (amount !== null && (amount <= 0n || amount > 2n ** 63n - 1n)) {
      throw new CaptainsRefusedError(
        'invalid_max_pickup',
        'the maximum pickup amount is above zero',
      );
    }
    await this.database.db.transaction(async (tx) => {
      const row = await this.lockCaptain(tx, captainId);
      if ((await this.activeOrders([captainId], tx)).size > 0) {
        throw new CaptainsRefusedError('active_order', 'the captain has an active order');
      }
      let currency: string | null = null;
      if (amount !== null) {
        await lockCityCurrencies(tx, row.cityId);
        currency = await this.fx.baseCurrency(row.cityId, tx);
        if (currency === null) {
          throw new CaptainsRefusedError(
            'not_in_base_currency',
            'the city has no base currency yet',
          );
        }
      }
      await tx
        .update(captainRecords)
        .set({
          maxPickupAmount: amount,
          maxPickupCurrency: currency,
          maxPickupSetAt: sql`now()`,
          updatedAt: sql`now()`,
        })
        .where(eq(captainRecords.id, captainId));
    });
    return this.maxPickup(captainId);
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

  // CA §14 #23 (owner decision 2026-11-12): the city's active captains,
  // online or not: neither terminated nor in a suspension still running.
  async activeCaptainIds(cityId: string, now: Date): Promise<string[]> {
    const rows = await this.database.db
      .select({ id: captainRecords.id })
      .from(captainRecords)
      .where(
        and(
          eq(captainRecords.cityId, cityId),
          sql`(${captainRecords.status} = 'active' OR (${captainRecords.status} = 'suspended'
                AND ${captainRecords.suspendedUntil} <= ${now}))`,
        ),
      );
    return rows.map((row) => row.id);
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
  // the suspension (a new reason or end); one past its end counts as active.
  // An online captain goes offline at once; with an active order they are in
  // last-order mode instead and go offline when it ends (K18). Reactivating
  // during the order lifts the suspension's mode.
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
          ? await this.clearLastOrder(tx, captainId, 'suspended')
          : await this.offlineOrLastOrder(tx, captainId, status, null, now);
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

  // AP §9.7.5 «فصل من الاتصال» (CA §7.6, K18): operations set the captain
  // offline at once with a reason, or, with an active order, in last-order
  // mode with that reason (it replaces a mode the captain asked for). The
  // captain hears it with the reason (CA §14 #26). An offline captain stays
  // so, and nothing is recorded.
  async forceOffline(captainId: string, change: CaptainChange, now: Date): Promise<void> {
    if (!hasReason(change)) {
      throw new CaptainsRefusedError('reason_required', 'a force offline needs a reason');
    }
    const reason = change.reason!.trim();
    const { cityId, ended } = await this.database.db.transaction(async (tx) => {
      const row = await this.lockCaptain(tx, captainId);
      const open = await this.openPeriod(tx, captainId);
      // Offline, or already forced: a repeat writes nothing more.
      if (open === null || open.lastOrderBy === 'forced') {
        return { cityId: row.cityId, ended: null };
      }
      const ended = await this.offlineOrLastOrder(tx, captainId, 'forced', reason, now);
      await this.audit.recordWrite(
        {
          actor: change.actor,
          context: change.context,
          cityId: row.cityId,
          action: 'captain.force_offline',
          target: { type: 'captain', id: captainId },
          before: { online: true },
          after: ended === null ? { lastOrder: 'forced' } : { online: false },
          reason,
        },
        tx,
      );
      await this.availabilityChanged(tx, {
        kind: 'forced_offline',
        captainId,
        cityId: row.cityId,
        reason,
        atOnce: ended !== null,
        at: now,
      });
      return { cityId: row.cityId, ended };
    });
    if (ended !== null) {
      await this.positions.remove(cityId, captainId, ended);
      await this.wentOffline(captainId, now);
    }
  }

  // CA §7.3, §15 «لا أريد طلبات جديدة»: the captain turns last-order mode on
  // during an active order (no offers, offline when it ends), or off before
  // it ends. Refused while offline (not_online), on without an active order
  // (no_active_order), and off when operations, a suspension or a
  // termination set the mode (last_order_not_yours). On while already on
  // keeps the mode as it is.
  async setLastOrder(captainId: string, on: boolean, now: Date): Promise<CaptainState> {
    await this.database.db.transaction(async (tx) => {
      await this.lockCaptain(tx, captainId);
      const open = await this.openPeriod(tx, captainId);
      if (open === null) throw new CaptainsRefusedError('not_online', 'the captain is offline');
      if (on) {
        if (open.lastOrderBy !== null) return;
        if ((await this.activeOrders([captainId], tx)).size === 0) {
          throw new CaptainsRefusedError('no_active_order', 'last-order mode needs an order');
        }
        await tx
          .update(onlinePeriods)
          .set({ lastOrderBy: 'captain', lastOrderAt: now, lastOrderReason: null })
          .where(eq(onlinePeriods.id, open.id));
        return;
      }
      if (open.lastOrderBy === null) return;
      if (open.lastOrderBy !== 'captain') {
        throw new CaptainsRefusedError('last_order_not_yours', 'operations set this mode');
      }
      await this.clearLastOrder(tx, captainId, 'captain');
    });
    return this.state(captainId, now);
  }

  // CA §7.3, §7.6, K18 (slice 2.13a): in the transaction where an order left
  // the captain (delivered, ended with an outcome, cancelled, withdrawn), a
  // last-order mode ends the online period once no active order is left,
  // with the mode's reason; the captain hears it (AP §10). A suspension's
  // mode whose suspension has ended is lifted instead, and the captain stays
  // online. The answer runs after the commit: the live position removed and
  // the listeners told. Nothing without a mode.
  async afterOrderLeft(tx: Tx, captainId: string, now: Date): Promise<() => Promise<void>> {
    const row = await this.lockCaptain(tx, captainId);
    const open = await this.openPeriod(tx, captainId);
    const nothing = () => Promise.resolve();
    if (open === null || open.lastOrderBy === null) return nothing;
    if ((await this.activeOrders([captainId], tx)).size > 0) return nothing;
    if (open.lastOrderBy === 'suspended' && captainOf(row, now).status !== 'suspended') {
      await this.clearLastOrder(tx, captainId, 'suspended');
      return nothing;
    }
    const ended = await this.endOnline(tx, captainId, LAST_ORDER_END[open.lastOrderBy], now);
    if (ended === null) return nothing;
    await this.availabilityChanged(tx, {
      kind: 'offline_after_order',
      captainId,
      cityId: row.cityId,
      at: now,
    });
    return async () => {
      await this.positions.remove(row.cityId, captainId, ended);
      await this.wentOffline(captainId, now);
    };
  }

  // K18: an online captain with an active order enters last-order mode for
  // a suspension, a termination or a force offline; without one the online
  // period ends at once. Answers the ended period's id, or null.
  private async offlineOrLastOrder(
    tx: Tx,
    captainId: string,
    by: Exclude<LastOrderBy, 'captain'>,
    reason: string | null,
    now: Date,
  ): Promise<string | null> {
    const open = await this.openPeriod(tx, captainId);
    if (open === null) return null;
    if ((await this.activeOrders([captainId], tx)).size === 0) {
      return this.endOnline(tx, captainId, LAST_ORDER_END[by], now);
    }
    // Operations' force offline stays: a suspension or termination after it
    // ends the period anyway, and lifting the suspension must not lift it.
    if (open.lastOrderBy === 'forced') return null;
    await tx
      .update(onlinePeriods)
      .set({ lastOrderBy: by, lastOrderAt: now, lastOrderReason: by === 'forced' ? reason : null })
      .where(eq(onlinePeriods.id, open.id));
    return null;
  }

  // Lifts the open period's last-order mode when it is the given kind.
  private async clearLastOrder(tx: Tx, captainId: string, by: LastOrderBy): Promise<null> {
    await tx
      .update(onlinePeriods)
      .set({ lastOrderBy: null, lastOrderAt: null, lastOrderReason: null })
      .where(
        and(
          eq(onlinePeriods.captainId, captainId),
          isNull(onlinePeriods.endedAt),
          eq(onlinePeriods.lastOrderBy, by),
        ),
      );
    return null;
  }

  private async openPeriod(executor: Tx | Database['db'], captainId: string) {
    const [open] = await executor
      .select({
        id: onlinePeriods.id,
        startedAt: onlinePeriods.startedAt,
        appVersion: onlinePeriods.appVersion,
        lastOrderBy: onlinePeriods.lastOrderBy,
        lastOrderReason: onlinePeriods.lastOrderReason,
      })
      .from(onlinePeriods)
      .where(and(eq(onlinePeriods.captainId, captainId), isNull(onlinePeriods.endedAt)));
    return open ?? null;
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
  // whose dispatch.max_distance_km.<vehicle> is below the trip, or, given
  // the order's pickup payment, a «أقصى مبلغ أحمله» below it (C4; none for a
  // handover, CA §9.10.1).
  async candidates(
    cityId: string,
    restaurant: Point,
    tripMetres: number,
    now: Date,
    pickupPayment: Money | null = null,
  ): Promise<Candidate[]> {
    const radiusMetres = (await this.settings.get('dispatch.search_radius_km', { cityId })) * 1000;
    return this.scan(cityId, restaurant, tripMetres, now, radiusMetres, false, pickupPayment);
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

  // AP §9.10.3 step 1: the city's captains whose name contains the text,
  // terminated ones included (their custody is still settled), by name.
  async findByName(cityId: string, text: string, limit: number): Promise<DeskCaptain[]> {
    const pattern = `%${text.replace(/[\\%_]/g, (character) => `\\${character}`)}%`;
    return this.database.db
      .select({
        id: captainRecords.id,
        cityId: captainRecords.cityId,
        name: captainRecords.name,
        status: captainRecords.status,
      })
      .from(captainRecords)
      .where(and(eq(captainRecords.cityId, cityId), sql`${captainRecords.name} ILIKE ${pattern}`))
      .orderBy(captainRecords.name)
      .limit(limit);
  }

  // AP §9.10.3 step 2: the captain and their custody now, per currency.
  async deskCustody(
    captainId: string,
    now: Date,
  ): Promise<DeskCaptain & { custody: Custody; handInGrace: HandInGrace | null }> {
    const row = await this.row(this.database.db, captainId);
    const rules = await this.cityRules(row.cityId, now);
    const custody = await this.custody(this.database.db, row, rules.lastCutoff, rules.warnPct);
    const handInGrace = await this.graceOf(this.database.db, row.cityId, row.id, now);
    return {
      id: row.id,
      cityId: row.cityId,
      name: row.name,
      status: row.status,
      custody,
      handInGrace,
    };
  }

  // AP §9.10.2 «أرصدة الكباتن»: every captain of the city not terminated,
  // and a terminated one still holding custody or earnings (to settle).
  async balances(cityId: string, now: Date): Promise<CaptainBalance[]> {
    const rows = await this.database.db
      .select()
      .from(captainRecords)
      .where(eq(captainRecords.cityId, cityId))
      .orderBy(captainRecords.name);
    if (rows.length === 0) return [];
    const rules = await this.cityRules(cityId, now);
    const { base, toBase } = await this.fx.currentValue(cityId);
    const listed: CaptainBalance[] = [];
    for (const row of rows) {
      const executor = this.database.db;
      const custody = await this.custody(executor, row, rules.lastCutoff, rules.warnPct);
      let earnings = 0n;
      for (const account of await this.ledger.ownerAccounts(
        cityId,
        row.id,
        'captain.earnings',
        executor,
      )) {
        const { amount } = await this.ledger.balance(account.id, executor);
        earnings +=
          account.currency === base || amount === 0n ? amount : toBase(amount, account.currency);
      }
      const held = custody.currencies.some((line) => line.balance !== 0n);
      if (row.status === 'terminated' && !held && earnings === 0n) continue;
      const handInGrace = await this.graceOf(executor, cityId, row.id, now);
      const blocks: CaptainBalance['blocks'] = [];
      const graced = handInGrace !== null && now < handInGrace.until;
      if (custody.closedDue.amount > rules.remitTolerance && !graced) blocks.push('closed_due');
      if (custody.usage.amount >= custody.limit.amount) blocks.push('cash_limit');
      listed.push({
        captainId: row.id,
        name: row.name,
        status: row.status,
        custody,
        blocks,
        handInGrace,
        earnings: { amount: earnings, currency: base },
      });
    }
    return listed;
  }

  // AP §8.5.4 «Hand-in grace» for one captain (OWN or FIN, with a reason):
  // the closed_due block lifts until the next cutoff, the custody staying
  // due. Refused while nothing above the tolerance is due (nothing_due). A
  // repeat while a grace of the captain runs to the same cutoff answers it.
  async grantGrace(captainId: string, change: CaptainChange, now: Date): Promise<HandInGrace> {
    if (!hasReason(change)) {
      throw new CaptainsRefusedError('reason_required', 'a grace needs a reason');
    }
    const cityId = (await this.row(this.database.db, captainId)).cityId;
    const rules = await this.cityRules(cityId, now);
    return this.database.db.transaction(async (tx) => {
      const row = await this.lockCaptain(tx, captainId);
      const custody = await this.custody(tx, row, rules.lastCutoff, rules.warnPct);
      if (custody.closedDue.amount <= rules.remitTolerance) {
        throw new CaptainsRefusedError('nothing_due', 'nothing is due from a closed day');
      }
      const [same] = await tx
        .select()
        .from(handInGraces)
        .where(
          and(eq(handInGraces.captainId, captainId), eq(handInGraces.until, rules.nextCutoff)),
        );
      if (same) return graceOfRow(same);
      const grace = await this.insertGrace(tx, cityId, captainId, change, rules.nextCutoff, now);
      await this.audit.recordWrite(
        {
          actor: change.actor,
          context: change.context,
          cityId,
          action: 'captain.hand_in_grace',
          target: { type: 'captain', id: captainId },
          before: null,
          after: { until: grace.until.toISOString(), closedDue: moneyOf(custody.closedDue) },
          reason: grace.reason,
        },
        tx,
      );
      await this.graceHeard(tx, cityId, captainId, grace, rules.timeZone, now);
      return grace;
    });
  }

  // AP §8.5.4, §9.10.3 «Bulk hand-in grace» (OWN, with a reason): every
  // captain of the city for one business day, until the next cutoff. The
  // captains blocked by closed_due now hear it (CA §14 #18); a repeat while
  // the city's grace runs to the same cutoff answers it and tells no one.
  async grantBulkGrace(
    cityId: string,
    change: CaptainChange,
    now: Date,
  ): Promise<{ grace: HandInGrace; captainIds: string[] }> {
    if (!hasReason(change)) {
      throw new CaptainsRefusedError('reason_required', 'a grace needs a reason');
    }
    if ((await this.geo.cityTimeZone(cityId)) === null) {
      throw new CaptainsRefusedError('unknown_city', 'no such city');
    }
    const rules = await this.cityRules(cityId, now);
    const rows = await this.database.db
      .select()
      .from(captainRecords)
      .where(and(eq(captainRecords.cityId, cityId), ne(captainRecords.status, 'terminated')));
    const due: string[] = [];
    for (const row of rows) {
      try {
        const custody = await this.custody(this.database.db, row, rules.lastCutoff, rules.warnPct);
        if (custody.closedDue.amount > rules.remitTolerance) due.push(row.id);
      } catch (error) {
        this.logger.warn({ err: error, captainId: row.id }, 'closed_due not read for the grace');
      }
    }
    return this.database.db.transaction(async (tx) => {
      await tx.execute(
        sql`SELECT pg_advisory_xact_lock(hashtextextended(${`captains.bulk-grace:${cityId}`}, 0))`,
      );
      const [same] = await tx
        .select()
        .from(handInGraces)
        .where(
          and(
            eq(handInGraces.cityId, cityId),
            isNull(handInGraces.captainId),
            eq(handInGraces.until, rules.nextCutoff),
          ),
        );
      if (same) return { grace: graceOfRow(same), captainIds: [] };
      const grace = await this.insertGrace(tx, cityId, null, change, rules.nextCutoff, now);
      await this.audit.recordWrite(
        {
          actor: change.actor,
          context: change.context,
          cityId,
          action: 'captain.bulk_hand_in_grace',
          target: { type: 'city', id: cityId },
          before: null,
          after: { until: grace.until.toISOString(), captainIds: due },
          reason: grace.reason,
        },
        tx,
      );
      for (const captainId of due) {
        await this.graceHeard(tx, cityId, captainId, grace, rules.timeZone, now);
      }
      return { grace, captainIds: due };
    });
  }

  private async insertGrace(
    tx: Tx,
    cityId: string,
    captainId: string | null,
    change: CaptainChange,
    until: Date,
    now: Date,
  ): Promise<HandInGrace> {
    if (change.actor.type !== 'admin' || change.actor.id === null) {
      throw new Error('a grace is granted by an admin');
    }
    const [row] = await tx
      .insert(handInGraces)
      .values({
        cityId,
        captainId,
        until,
        reason: change.reason!.trim(),
        grantedBy: change.actor.id,
        grantedAt: now,
      })
      .returning();
    return graceOfRow(row!);
  }

  private async graceHeard(
    tx: Tx,
    cityId: string,
    captainId: string,
    grace: HandInGrace,
    timeZone: string,
    now: Date,
  ): Promise<void> {
    await this.availabilityChanged(tx, {
      kind: 'hand_in_grace',
      captainId,
      cityId,
      graceId: grace.id,
      until: grace.until,
      timeZone,
      at: now,
    });
  }

  // The grace running now for the captain: theirs or the city's, the later
  // end first.
  private async graceOf(
    executor: Executor,
    cityId: string,
    captainId: string,
    now: Date,
  ): Promise<HandInGrace | null> {
    const [row] = await executor
      .select()
      .from(handInGraces)
      .where(
        and(
          eq(handInGraces.cityId, cityId),
          or(eq(handInGraces.captainId, captainId), isNull(handInGraces.captainId)),
          gt(handInGraces.until, now),
          lte(handInGraces.grantedAt, now),
        ),
      )
      .orderBy(desc(handInGraces.until), desc(handInGraces.grantedAt))
      .limit(1);
    return row ? graceOfRow(row) : null;
  }

  // AP §9.10.3, the ledger's «Concurrency»: reads the city's rules, then
  // gives the function that locks the captain row in the desk's transaction
  // and answers their custody, so two desks never settle one balance twice.
  async deskLock(
    captainId: string,
    now: Date,
  ): Promise<{ captain: DeskCaptain; lock: (tx: Tx) => Promise<Custody> }> {
    const row = await this.row(this.database.db, captainId);
    const rules = await this.cityRules(row.cityId, now);
    return {
      captain: { id: row.id, cityId: row.cityId, name: row.name, status: row.status },
      lock: async (tx) => {
        const locked = await this.lockCaptain(tx, captainId);
        return this.custody(tx, locked, rules.lastCutoff, rules.warnPct);
      },
    };
  }

  // In the desk's transaction, after its journals: the listeners hear it,
  // so the app reads its state again.
  async custodyChanged(tx: Tx, captain: DeskCaptain, now: Date): Promise<void> {
    await this.availabilityChanged(tx, {
      kind: 'custody_changed',
      captainId: captain.id,
      cityId: captain.cityId,
      at: now,
    });
  }

  // C3, AP §9.7.6: after captain.offer_expiry_offline_count expired offers in
  // a row, the captain goes offline; never with an active order.
  async offlineForUnansweredOffers(captainId: string, now: Date, count: number): Promise<boolean> {
    const cityId = (await this.row(this.database.db, captainId)).cityId;
    const ended = await this.database.db.transaction(async (tx) => {
      await this.lockCaptain(tx, captainId);
      if ((await this.activeOrders([captainId], tx)).size > 0) return null;
      const period = await this.endOnline(tx, captainId, 'offers_expired', now);
      // CA §7.4: the push and sound «لم ترد على 3 عروض متتالية…».
      if (period !== null) {
        await this.availabilityChanged(tx, {
          kind: 'offers_expired',
          captainId,
          cityId,
          count,
          at: now,
        });
      }
      return period;
    });
    if (ended === null) return false;
    await this.positions.remove(cityId, captainId, ended);
    await this.wentOffline(captainId, now);
    return true;
  }

  // AP §9.12.5, CA §8.2: an order's pay by the pay table it kept, for the
  // vehicle and the trip, before any waiting.
  async orderPay(payTableId: string, vehicle: Vehicle, metres: number): Promise<Money | null> {
    const parts = await this.payParts(payTableId, vehicle, metres, 0);
    return parts && { amount: parts.orderPay, currency: parts.currency };
  }

  // AP §8.4, CA §9.8: the pay of a delivered order in its parts, by the pay
  // table it kept, for the vehicle, the trip and the waiting minutes.
  async payParts(
    payTableId: string,
    vehicle: Vehicle,
    metres: number,
    waitingMinutes: number,
  ): Promise<(PayParts & { currency: string }) | null> {
    const [table] = await this.database.db
      .select({ currency: payTables.currency })
      .from(payTables)
      .where(eq(payTables.id, payTableId));
    const [rate] = await this.database.db
      .select()
      .from(payRates)
      .where(and(eq(payRates.tableId, payTableId), eq(payRates.vehicle, vehicle)));
    if (!table || !rate) return null;
    return { ...orderPay(rate, { metres, waitingMinutes }), currency: table.currency };
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
    pickupPayment: Money | null = null,
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
        if (state.state === 'last_order') reasons.push('last_order');
        if (state.state === 'not_receiving_offers') reasons.push(...state.reasons);
        if (straightMetres > radiusMetres) reasons.push('out_of_range');
        if (tripMetres > vehicleMax) reasons.push('vehicle_not_allowed');
        if (pickupPayment && aboveMaxPickup(row, pickupPayment)) reasons.push('above_max_pickup');
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

  // AP §9.1.3 «كابتن بلغ حد العهدة»: each captain of the city not
  // terminated, with whether its custody usage reached 100% of its cash
  // limit, or null when its cash cannot be read now (a currency without a
  // rate), so its alert stays as it was.
  async cashLimits(
    cityId: string,
    now: Date,
  ): Promise<{ id: string; name: string; atLimit: boolean | null }[]> {
    const rows = await this.database.db
      .select()
      .from(captainRecords)
      .where(and(eq(captainRecords.cityId, cityId), ne(captainRecords.status, 'terminated')));
    if (rows.length === 0) return [];
    const rules = await this.cityRules(cityId, now);
    const states = await Promise.all(
      rows.map(async (row) => {
        try {
          const custody = await this.custody(
            this.database.db,
            row,
            rules.lastCutoff,
            rules.warnPct,
          );
          return [
            { id: row.id, name: row.name, atLimit: custody.usage.amount >= custody.limit.amount },
          ];
        } catch (error) {
          this.logger.warn({ err: error, captainId: row.id }, 'cash limit not read');
          return [{ id: row.id, name: row.name, atLimit: null }];
        }
      }),
    );
    return states.flat();
  }

  // AP §9.1.3 «انقطع اتصال كابتن أثناء طلب»: when each captain's newest
  // point since a moment was recorded (simulated ones included: the app is
  // still sending); a captain with none since is left out.
  async lastFixes(captainIds: readonly string[], since: Date): Promise<Map<string, Date>> {
    if (captainIds.length === 0) return new Map();
    const rows = await this.database.db
      .select({ captainId: locations.captainId, at: max(locations.recordedAt) })
      .from(locations)
      .where(
        and(
          inArray(locations.captainId, [...new Set(captainIds)]),
          gte(locations.recordedAt, since),
        ),
      )
      .groupBy(locations.captainId);
    return new Map(rows.flatMap((row) => (row.at ? [[row.captainId, row.at] as const] : [])));
  }

  // CA §9.10.1 (slice 2.12b): the captain's newest real point of their open
  // online period, whatever its age, or null: where the first captain of a
  // handover waits, which the second captain is led to and receives near.
  async latestPoint(captainId: string): Promise<(Point & { recordedAt: Date }) | null> {
    const { rows } = await this.database.db.execute<{
      latitude: number;
      longitude: number;
      recorded_at: Date | string;
    }>(sql`
      SELECT ST_Y(l.location) AS latitude, ST_X(l.location) AS longitude, l.recorded_at
        FROM ${onlinePeriods} p
        JOIN ${locations} l ON l.captain_id = p.captain_id AND l.recorded_at >= p.started_at
        WHERE p.captain_id = ${captainId} AND p.ended_at IS NULL AND NOT l.simulated
        ORDER BY l.recorded_at DESC LIMIT 1`);
    const [row] = rows;
    if (!row) return null;
    return {
      latitude: Number(row.latitude),
      longitude: Number(row.longitude),
      recordedAt: new Date(row.recorded_at),
    };
  }

  // K17 (slice 2.12b): the captain who handed their order to another goes
  // offline in the receipt's transaction, once the order is no longer theirs
  // (refused otherwise). The answer runs after the commit: the live position
  // removed and the listeners told, as any end of an online period.
  async offlineAfterHandover(tx: Tx, captainId: string, now: Date): Promise<() => Promise<void>> {
    const row = await this.lockCaptain(tx, captainId);
    if ((await this.activeOrders([captainId], tx)).size > 0) {
      throw new Error(`captain ${captainId} still has an active order`);
    }
    const ended = await this.endOnline(tx, captainId, 'handed_over', now);
    return async () => {
      if (ended === null) return;
      await this.positions.remove(row.cityId, captainId, ended);
      await this.wentOffline(captainId, now);
    };
  }

  // K17 (slices 2.13b, 2.13c): the order left a captain whose «لا أستطيع
  // إكمال الطلب» or «طوارئ» was open: the online period ends with that reason
  // in that transaction, under the captain's lock, once no active order is
  // left, whatever last-order mode it had. The listeners hear it (the app
  // reads its state again); the answer runs after the commit.
  async offlineAfterProblem(
    tx: Tx,
    captainId: string,
    reason: 'cannot_complete' | 'emergency',
    now: Date,
  ): Promise<() => Promise<void>> {
    const row = await this.lockCaptain(tx, captainId);
    if ((await this.activeOrders([captainId], tx)).size > 0) {
      throw new Error(`captain ${captainId} still has an active order`);
    }
    const ended = await this.endOnline(tx, captainId, reason, now);
    if (ended === null) return () => Promise.resolve();
    await this.availabilityChanged(tx, {
      kind: 'offline_after_order',
      captainId,
      cityId: row.cityId,
      at: now,
    });
    return async () => {
      await this.positions.remove(row.cityId, captainId, ended);
      await this.wentOffline(captainId, now);
    };
  }

  // The captain's state and cash now (CA §7.1, AP §8.5.3–8.5.4).
  async state(captainId: string, now: Date): Promise<CaptainState> {
    const row = await this.row(this.database.db, captainId);
    const rules = await this.cityRules(row.cityId, now);
    const input = await this.input(this.database.db, row, rules);
    return {
      availability: availability(input.availability, now),
      custody: input.custody,
      remitTolerance: { amount: rules.remitTolerance, currency: input.custody.usage.currency },
      handInGrace: input.grace,
    };
  }

  // CA §7.2: going online, refused with every block that applies. Already
  // online answers the state as it is. The caller reads whether the
  // captain's account has the terms in force to accept (K7).
  async goOnline(
    captainId: string,
    device: { appVersion: string | null; simulatedLocation: boolean; termsPending: boolean },
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
            termsPending: device.termsPending,
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
      return {
        availability: availability(input.availability, now),
        custody: input.custody,
        remitTolerance: { amount: rules.remitTolerance, currency: input.custody.usage.currency },
        handInGrace: input.grace,
      };
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
    return { handIn: handInOf(custody, rules.remitTolerance) };
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
    const [cutoff, tolerance, graceHours, warnPct, minVersion, expiryCount] = await Promise.all([
      this.settings.get('finance.business_day_cutoff', { cityId }),
      this.settings.get('captain.remit_tolerance', { cityId }),
      this.settings.get('captain.remit_online_grace_hours', { cityId }),
      this.settings.get('captain.custody_warn_pct', { cityId }),
      this.settings.get('app.<app>.min_version', { parameter: 'captain' }),
      this.settings.get('captain.offer_expiry_offline_count', { cityId }),
    ]);
    const [hours, minutes] = cutoff.split(':').map(Number) as [number, number];
    return {
      now,
      timeZone,
      lastCutoff: lastCutoff(now, hours * 60 + minutes, timeZone),
      nextCutoff: nextCutoff(now, hours * 60 + minutes, timeZone),
      remitTolerance: BigInt(tolerance.amountMinor),
      graceHours,
      warnPct,
      minVersion,
      expiryCount,
    };
  }

  private async input(
    executor: Tx | Database['db'],
    row: typeof captainRecords.$inferSelect,
    rules: Awaited<ReturnType<CaptainsService['cityRules']>>,
  ): Promise<{ availability: AvailabilityInput; custody: Custody; grace: HandInGrace | null }> {
    const open = await this.openPeriod(executor, row.id);
    const grace = await this.graceOf(executor, row.cityId, row.id, rules.now);
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
    // C3, CA §7.4: offline since the latest period ended for unanswered
    // offers.
    const [last] = open
      ? []
      : await executor
          .select({ endReason: onlinePeriods.endReason })
          .from(onlinePeriods)
          .where(eq(onlinePeriods.captainId, row.id))
          .orderBy(desc(onlinePeriods.startedAt))
          .limit(1);
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
        termsPending: false,
        activeOrder: open ? (await this.activeOrders([row.id], executor)).size > 0 : false,
        lastOrder:
          open?.lastOrderBy == null ? null : { by: open.lastOrderBy, reason: open.lastOrderReason },
        offersExpired: last?.endReason === 'offers_expired' ? rules.expiryCount : null,
        graceUntil: grace?.until ?? null,
      },
      custody,
      grace,
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
    const currencies: CustodyCurrency[] = [];
    for (const account of accounts) {
      const balance = await this.ledger.balance(account.id, executor);
      const balanceInBase = inBase(balance.amount, account.currency);
      if (balance.amount > 0n) usage += balanceInBase;
      const closed = await this.ledger.balanceAt(account.id, cutoff, deskTypes, executor);
      closedDue += inBase(closed.amount, account.currency);
      currencies.push({
        currency: account.currency,
        balance: balance.amount,
        closedDue: closed.amount,
        today: balance.amount - closed.amount,
        balanceInBase,
      });
    }
    currencies.sort(
      (a, b) =>
        Number(b.currency === base) - Number(a.currency === base) ||
        a.currency.localeCompare(b.currency),
    );
    return {
      usage: { amount: usage, currency: base },
      limit: { amount: limit, currency: base },
      warn: usage * 100n >= limit * BigInt(warnPct),
      closedDue: { amount: closedDue, currency: base },
      lastCutoff: cutoff,
      currencies,
    };
  }

  private async endOnline(
    tx: Tx,
    captainId: string,
    reason: OnlineEndReason,
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

function handInOf(custody: Custody, tolerance: bigint): Money | null {
  return custody.usage.amount > tolerance ? { ...custody.usage } : null;
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
    carriedCurrencies: row.carriedCurrencies,
    maxPickup:
      row.maxPickupAmount === null
        ? null
        : { amount: row.maxPickupAmount, currency: row.maxPickupCurrency! },
  };
}

// C4: the base currency cannot change while a captain keeps a limit in it
// (useCityAmounts), so a limit in another currency never meets an order.
function aboveMaxPickup(row: typeof captainRecords.$inferSelect, pickupPayment: Money): boolean {
  return (
    row.maxPickupAmount !== null &&
    row.maxPickupCurrency === pickupPayment.currency &&
    pickupPayment.amount > row.maxPickupAmount
  );
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

function graceOfRow(row: typeof handInGraces.$inferSelect): HandInGrace {
  return {
    id: row.id,
    until: row.until,
    reason: row.reason,
    bulk: row.captainId === null,
    grantedAt: row.grantedAt,
  };
}
