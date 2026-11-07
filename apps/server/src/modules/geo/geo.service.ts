import { Inject, Injectable, Logger, type OnModuleInit } from '@nestjs/common';
import { and, asc, desc, eq, ne, type SQL, sql } from 'drizzle-orm';
import type { NodePgDatabase } from 'drizzle-orm/node-postgres';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { type AuditActor, type AuditRequestContext, AuditService } from '../audit/index.js';
import { FxService } from '../fx/index.js';
import { lockCityCurrencies, SettingsService, type Vehicle } from '../settings/index.js';
import { checkDeliveryFeeRule, type DeliveryFeeRule, deliveryFeeFor } from './delivery-fee.js';
import {
  type Distance,
  measureDistance,
  type Point,
  ROAD_DISTANCES,
  type RoadDistances,
} from './distance.js';
import { cities, feeBands, feeRules, zones, zoneVotes } from './schema.js';

export type GeoRefusal =
  | 'invalid_area'
  | 'invalid_name'
  | 'zone_name_taken'
  | 'zones_overlap'
  | 'unknown_zone'
  | 'invalid_fee_rule'
  | 'fee_not_in_base_currency'
  | 'no_fee_rule'
  | 'inside_zone';

// A change or a fee geo refuses, with the reason the routes and the ordering
// module map to their own answers.
export class GeoRefusedError extends Error {
  override readonly name = 'GeoRefusedError';
  constructor(
    readonly refusal: GeoRefusal,
    message: string,
  ) {
    super(message);
  }
}

// Who changes a city's zones or fees and why, for the audit log.
export interface GeoChange {
  actor: AuditActor;
  context: AuditRequestContext;
  reason?: string | null;
}

export interface Zone {
  id: string;
  name: string;
  active: boolean;
}

export interface DeliveryFee {
  fee: bigint;
  currency: string;
  free: boolean;
  // The rule version it was priced with, and that rule's free-delivery
  // threshold (null without one).
  ruleId: string;
  freeDeliveryFrom: bigint | null;
  // The distance of a distance-band rule; null for a flat one.
  distance: Distance | null;
}

// Owner decision 2026-11-06: the fee is priced before a captain is known, by
// the motorbike's road distance, whoever delivers.
const FEE_VEHICLE: Vehicle = 'motorbike';

// Owner decisions 2026-11-06 (CU §7.2): one vote per device within 500 m,
// and a vote over 50 km from every active zone belongs to no city.
export const VOTE_RADIUS_METRES = 500;
export const VOTE_CITY_METRES = 50_000;

type Executor = Pick<NodePgDatabase, 'select'>;

// Cities (AP §9.12.1), distances (architecture §7.1), service zones and the
// delivery fee (AP §9.12.2–9.12.3) for the other modules.
@Injectable()
export class GeoService implements OnModuleInit {
  private readonly logger = new Logger(GeoService.name);

  constructor(
    @Inject(DATABASE) private readonly database: Database,
    @Inject(ROAD_DISTANCES) private readonly road: RoadDistances,
    private readonly settings: SettingsService,
    private readonly fx: FxService,
    private readonly audit: AuditService,
  ) {}

  // The fee rule is in the city's base currency (AP §8.6), so fx refuses a
  // base change until the rule is in the new base.
  onModuleInit(): void {
    this.fx.useCityAmounts(async (cityId, executor) => {
      const rule = await this.deliveryFeeRule(cityId, executor);
      return rule === null ? [] : [{ key: 'delivery_fee_rule', currency: rule.currency }];
    });
  }

  // The active cities, by name: the panel's city selector (AP §7.2). V1 has
  // Azaz only; access by city comes with the panel users' cities.
  async activeCities(): Promise<{ id: string; code: string; name: string; timeZone: string }[]> {
    return this.database.db
      .select({ id: cities.id, code: cities.code, name: cities.name, timeZone: cities.timeZone })
      .from(cities)
      .where(eq(cities.status, 'active'))
      .orderBy(asc(cities.name));
  }

  // The city's id by its code, such as AZ; null for an unknown code.
  async cityIdByCode(code: string): Promise<string | null> {
    const [row] = await this.database.db
      .select({ id: cities.id })
      .from(cities)
      .where(eq(cities.code, code));
    return row?.id ?? null;
  }

  // The city's time zone, such as Asia/Damascus, the clock of its restaurants'
  // hours; null for an unknown city.
  async cityTimeZone(cityId: string): Promise<string | null> {
    const [row] = await this.database.db
      .select({ timeZone: cities.timeZone })
      .from(cities)
      .where(eq(cities.id, cityId));
    return row?.timeZone ?? null;
  }

  // The distance between two points for a vehicle, in whole metres: by road
  // through OSRM, or the straight line × 1.3 when OSRM does not answer or
  // pricing.distance_method is straight_line (AP §9.12.3).
  async distance(from: Point, to: Point, { vehicle }: { vehicle: Vehicle }): Promise<Distance> {
    const method = await this.settings.get('pricing.distance_method');
    return measureDistance(from, to, vehicle, method, this.road, (error) => {
      // No points in the log: a customer's delivery point is personal data.
      this.logger.warn(
        { vehicle, err: error },
        'OSRM did not answer: the straight line × 1.3 is used',
      );
    });
  }

  // The city's zones, active or not, by name.
  async zones(cityId: string): Promise<Zone[]> {
    return this.database.db
      .select({ id: zones.id, name: zones.name, active: zones.active })
      .from(zones)
      .where(eq(zones.cityId, cityId))
      .orderBy(asc(zones.name));
  }

  // A new zone: a neighbourhood's polygon, its corners in order (AP §9.12.2).
  // The ring closes by itself; one that crosses itself is refused, and so is
  // an active zone that overlaps another active one (owner decision
  // 2026-11-06), so every point has one neighbourhood at most.
  async createZone(
    cityId: string,
    zone: { name: string; area: Point[]; active: boolean },
    change: GeoChange,
  ): Promise<string> {
    const name = zone.name.trim();
    if (name.length === 0) throw new GeoRefusedError('invalid_name', 'a zone needs a name');
    const corners = zone.area.map(({ latitude, longitude }) => [longitude, latitude]);
    if (
      new Set(corners.map((corner) => corner.join())).size < 3 ||
      !zone.area.every(
        ({ latitude, longitude }) => Math.abs(latitude) <= 90 && Math.abs(longitude) <= 180,
      )
    ) {
      throw new GeoRefusedError('invalid_area', 'a zone needs at least three corners on the map');
    }
    const ring = JSON.stringify({ type: 'Polygon', coordinates: [[...corners, corners[0]]] });
    const area = sql`ST_SetSRID(ST_GeomFromGeoJSON(${ring}), 4326)`;

    return this.database.db.transaction(async (tx) => {
      const [{ valid } = { valid: false }] = await tx
        .execute<{ valid: boolean }>(sql`SELECT ST_IsValid(${area}) AS valid`)
        .then((result) => result.rows);
      if (!valid) {
        throw new GeoRefusedError('invalid_area', 'the zone outline crosses itself');
      }
      await lockZones(tx, cityId);
      const [taken] = await tx
        .select({ id: zones.id })
        .from(zones)
        .where(and(eq(zones.cityId, cityId), eq(zones.name, name)));
      if (taken) {
        throw new GeoRefusedError('zone_name_taken', `the city already has a zone named ${name}`);
      }
      if (zone.active) await this.refuseOverlap(tx, cityId, area, null);
      const [{ id }] = (await tx
        .insert(zones)
        .values({ cityId, name, area, active: zone.active })
        .returning({ id: zones.id })) as [{ id: string }];
      await this.audit.recordWrite(
        {
          actor: change.actor,
          context: change.context,
          cityId,
          action: 'zone.create',
          target: { type: 'zone', id },
          before: null,
          after: { name, active: zone.active, area: zone.area },
          reason: change.reason ?? null,
        },
        tx,
      );
      return id;
    });
  }

  // Activates or deactivates one of the city's zones (AP §9.12.2). A zone
  // that would overlap an active one stays inactive.
  async setZoneActive(
    cityId: string,
    zoneId: string,
    active: boolean,
    change: GeoChange,
  ): Promise<void> {
    await this.database.db.transaction(async (tx) => {
      await lockZones(tx, cityId);
      const [zone] = await tx
        .select({ active: zones.active })
        .from(zones)
        .where(and(eq(zones.cityId, cityId), eq(zones.id, zoneId)));
      if (!zone) throw new GeoRefusedError('unknown_zone', 'the city has no such zone');
      if (zone.active === active) return;
      if (active) {
        await this.refuseOverlap(
          tx,
          cityId,
          sql`(SELECT area FROM geo.zones WHERE id = ${zoneId})`,
          zoneId,
        );
      }
      await tx
        .update(zones)
        .set({ active, updatedAt: sql`now()` })
        .where(eq(zones.id, zoneId));
      await this.audit.recordWrite(
        {
          actor: change.actor,
          context: change.context,
          cityId,
          action: 'zone.update',
          target: { type: 'zone', id: zoneId },
          before: { active: zone.active },
          after: { active },
          reason: change.reason ?? null,
        },
        tx,
      );
    });
  }

  // Two zones overlap when their insides meet; sharing an edge is fine.
  private async refuseOverlap(
    tx: Pick<NodePgDatabase, 'select'>,
    cityId: string,
    area: SQL,
    except: string | null,
  ): Promise<void> {
    const [other] = await tx
      .select({ name: zones.name })
      .from(zones)
      .where(
        and(
          eq(zones.cityId, cityId),
          eq(zones.active, true),
          except === null ? undefined : ne(zones.id, except),
          sql`ST_Intersects(${zones.area}, ${area})`,
          sql`NOT ST_Touches(${zones.area}, ${area})`,
        ),
      )
      .limit(1);
    if (other) {
      throw new GeoRefusedError('zones_overlap', `the zone overlaps the active zone ${other.name}`);
    }
  }

  // The active zone a point is inside, its edge included (CU §7.1); null
  // outside every active zone. Active zones never overlap; a point on an
  // edge two of them share gets the older one.
  async zoneAt(
    cityId: string,
    { latitude, longitude }: Point,
  ): Promise<{ id: string; name: string } | null> {
    const point = sql`ST_SetSRID(ST_MakePoint(${longitude}, ${latitude}), 4326)`;
    const [row] = await this.database.db
      .select({ id: zones.id, name: zones.name })
      .from(zones)
      .where(
        and(
          eq(zones.cityId, cityId),
          eq(zones.active, true),
          sql`ST_Covers(${zones.area}, ${point})`,
        ),
      )
      .orderBy(asc(zones.id))
      .limit(1);
    return row ?? null;
  }

  // Where a point is (CU §7.1): the active zone of an active city that covers
  // it, as zoneAt picks it, or, outside every one, the city whose active zones
  // are nearest with no zone; null while no city has an active zone. The
  // customer app knows no city, so its routes find it here.
  async locate(
    point: Point,
  ): Promise<{ cityId: string; zone: { id: string; name: string } | null } | null> {
    const covering = await this.coveringZone(point);
    if (covering !== null) {
      return { cityId: covering.cityId, zone: { id: covering.id, name: covering.name } };
    }
    const nearest = await this.nearestZone(point);
    return nearest === null ? null : { cityId: nearest.cityId, zone: null };
  }

  // CU §7.2: «صوّت لمنطقتك» for a point outside every active zone. Owner
  // decisions 2026-11-06: a device votes once within VOTE_RADIUS_METRES of
  // its earlier votes, and a repeat records nothing and answers
  // already_voted, so the app thanks the customer either way; a vote farther
  // than VOTE_CITY_METRES from every active zone is kept with no city.
  async castVote(deviceId: string, point: Point): Promise<'recorded' | 'already_voted'> {
    if ((await this.coveringZone(point)) !== null) {
      throw new GeoRefusedError('inside_zone', 'the point is inside an active zone');
    }
    const nearest = await this.nearestZone(point);
    const cityId = nearest !== null && nearest.metres <= VOTE_CITY_METRES ? nearest.cityId : null;
    const at = pointSql(point);
    return this.database.db.transaction(async (tx) => {
      await tx.execute(
        sql`SELECT pg_advisory_xact_lock(hashtextextended(${`zone_votes:${deviceId}`}, 0))`,
      );
      const [earlier] = await tx
        .select({ id: zoneVotes.id })
        .from(zoneVotes)
        .where(
          and(
            eq(zoneVotes.deviceId, deviceId),
            sql`ST_DWithin(${zoneVotes.location}::geography, ${at}::geography, ${VOTE_RADIUS_METRES})`,
          ),
        )
        .limit(1);
      if (earlier) return 'already_voted';
      await tx.insert(zoneVotes).values({ cityId, deviceId, location: at });
      return 'recorded';
    });
  }

  // The active zone of an active city that covers the point, its edge
  // included; of two sharing an edge, the older (as zoneAt).
  private async coveringZone(
    point: Point,
  ): Promise<{ cityId: string; id: string; name: string } | null> {
    const [row] = await this.database.db
      .select({ cityId: zones.cityId, id: zones.id, name: zones.name })
      .from(zones)
      .innerJoin(cities, eq(cities.id, zones.cityId))
      .where(
        and(
          eq(zones.active, true),
          eq(cities.status, 'active'),
          sql`ST_Covers(${zones.area}, ${pointSql(point)})`,
        ),
      )
      .orderBy(asc(zones.id))
      .limit(1);
    return row ?? null;
  }

  // The nearest active zone of an active city and its distance in metres.
  private async nearestZone(point: Point): Promise<{ cityId: string; metres: number } | null> {
    const at = pointSql(point);
    const [row] = await this.database.db
      .select({
        cityId: zones.cityId,
        metres: sql<number>`ST_Distance(${zones.area}::geography, ${at}::geography)`.mapWith(
          Number,
        ),
      })
      .from(zones)
      .innerJoin(cities, eq(cities.id, zones.cityId))
      .where(and(eq(zones.active, true), eq(cities.status, 'active')))
      .orderBy(sql`${zones.area} <-> ${at}`, asc(zones.id))
      .limit(1);
    return row ?? null;
  }

  // The city's delivery fee rule in effect, the newest version; null before
  // the first.
  async deliveryFeeRule(
    cityId: string,
    executor: Executor = this.database.db,
  ): Promise<(DeliveryFeeRule & { id: string }) | null> {
    const [rule] = await executor
      .select()
      .from(feeRules)
      .where(eq(feeRules.cityId, cityId))
      .orderBy(desc(feeRules.id))
      .limit(1);
    if (!rule) return null;
    const common = {
      id: rule.id,
      currency: rule.currency,
      minimumFee: rule.minimumFee,
      freeDeliveryFrom: rule.freeDeliveryFrom,
    };
    if (rule.kind === 'flat') return { ...common, kind: 'flat', flatFee: rule.flatFee! };
    const bands = await executor
      .select({ upToMetres: feeBands.upToMetres, fee: feeBands.fee })
      .from(feeBands)
      .where(eq(feeBands.ruleId, rule.id))
      .orderBy(asc(feeBands.position));
    return { ...common, kind: 'distance_bands', bands };
  }

  // A new version of the city's delivery fee rule, in effect at once, in the
  // city's base currency (AP §9.12.3, §8.6).
  async setDeliveryFeeRule(
    cityId: string,
    rule: DeliveryFeeRule,
    change: GeoChange,
  ): Promise<string> {
    const problem = checkDeliveryFeeRule(rule);
    if (problem !== null) throw new GeoRefusedError('invalid_fee_rule', problem);

    return this.database.db.transaction(async (tx) => {
      // A base change takes the same lock, so it never passes this rule.
      await lockCityCurrencies(tx, cityId);
      // The fee is charged in the base currency. Until the first order locks
      // the base, the rule may be entered in another of the city's
      // currencies, so the base can then change to it (AP §8.6, D25).
      const base = await this.fx.baseCurrency(cityId, tx);
      const allowed =
        rule.currency === base ||
        (!(await this.fx.baseLocked(cityId, tx)) &&
          (await this.fx.cityCurrencies(cityId, tx)).some(
            (entry) => entry.currency === rule.currency,
          ));
      if (!allowed) {
        throw new GeoRefusedError(
          'fee_not_in_base_currency',
          `the delivery fee is in the city's base currency, ${base ?? 'not chosen yet'}`,
        );
      }
      const before = await this.deliveryFeeRule(cityId, tx);
      // A change that changes nothing adds no version.
      if (before !== null && sameRule(before, rule)) return before.id;
      const [{ id }] = (await tx
        .insert(feeRules)
        .values({
          cityId,
          kind: rule.kind,
          currency: rule.currency,
          flatFee: rule.kind === 'flat' ? rule.flatFee : null,
          minimumFee: rule.minimumFee,
          freeDeliveryFrom: rule.freeDeliveryFrom,
          editorId: change.actor.type === 'admin' ? change.actor.id : null,
          reason: change.reason ?? null,
        })
        .returning({ id: feeRules.id })) as [{ id: string }];
      if (rule.kind === 'distance_bands') {
        await tx
          .insert(feeBands)
          .values(rule.bands.map((band, position) => ({ ruleId: id, position, ...band })));
      }
      await this.audit.recordWrite(
        {
          actor: change.actor,
          context: change.context,
          cityId,
          action: 'delivery_fee_rule.set',
          target: { type: 'city', id: cityId },
          before: before === null ? null : forAudit(before),
          after: forAudit({ ...rule, id }),
          reason: change.reason ?? null,
        },
        tx,
      );
      return id;
    });
  }

  // The fee a customer pays to have an order of this items value, in the
  // base currency, carried from the restaurant to the point (AP §9.12.3).
  // The items value is after the restaurant's item discounts, the value the
  // commission is on (owner decision 2026-11-06; docs/domain/04).
  async deliveryFee(
    cityId: string,
    { from, to, itemsValue }: { from: Point; to: Point; itemsValue: bigint },
  ): Promise<DeliveryFee> {
    const rule = await this.deliveryFeeRule(cityId);
    if (rule === null) throw new GeoRefusedError('no_fee_rule', 'the city has no delivery fee yet');
    const base = await this.fx.baseCurrency(cityId);
    if (rule.currency !== base) {
      throw new GeoRefusedError(
        'fee_not_in_base_currency',
        `the delivery fee is in ${rule.currency}, not the base currency ${base ?? '(none)'}`,
      );
    }
    const distance =
      rule.kind === 'distance_bands'
        ? await this.distance(from, to, { vehicle: FEE_VEHICLE })
        : null;
    const { fee, free } = deliveryFeeFor(rule, { itemsValue, metres: distance?.metres });
    return {
      fee,
      currency: rule.currency,
      free,
      ruleId: rule.id,
      freeDeliveryFrom: rule.freeDeliveryFrom,
      distance,
    };
  }
}

// Changes of one city's zones take turns, so the overlap check of one sees
// the zone the other added.
async function lockZones(executor: Pick<NodePgDatabase, 'execute'>, cityId: string) {
  await executor.execute(
    sql`SELECT pg_advisory_xact_lock(hashtextextended(${`zones:${cityId}`}, 0))`,
  );
}

// Whether two rules charge the same, field by field.
function sameRule(a: DeliveryFeeRule, b: DeliveryFeeRule): boolean {
  const fields = (rule: DeliveryFeeRule) =>
    JSON.stringify(
      [
        rule.kind,
        rule.currency,
        rule.minimumFee,
        rule.freeDeliveryFrom,
        rule.kind === 'flat' ? rule.flatFee : rule.bands.map((band) => [band.upToMetres, band.fee]),
      ],
      (_key, value: unknown) => (typeof value === 'bigint' ? value.toString() : value),
    );
  return fields(a) === fields(b);
}

// The audit log keeps JSON, which has no bigint: amounts become strings.
function forAudit(rule: DeliveryFeeRule & { id: string }): Record<string, unknown> {
  return JSON.parse(
    JSON.stringify(rule, (_key, value: unknown) =>
      typeof value === 'bigint' ? value.toString() : value,
    ),
  ) as Record<string, unknown>;
}

// A point as a PostGIS geometry in WGS 84.
function pointSql({ latitude, longitude }: Point): SQL {
  return sql`ST_SetSRID(ST_MakePoint(${longitude}, ${latitude}), 4326)`;
}
