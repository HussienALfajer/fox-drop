import { Inject, Injectable, Logger, type OnModuleInit } from '@nestjs/common';
import { and, asc, desc, eq, inArray, ne, type SQL, sql } from 'drizzle-orm';
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
  measureDistances,
  measureRoute,
  type Point,
  ROAD_DISTANCES,
  type RoadDistances,
  type Route,
} from './distance.js';
import {
  cities,
  feeBands,
  feeRules,
  officePeriods,
  offices,
  restaurantFeeBands,
  restaurantFeeRules,
  zones,
  zoneVotes,
} from './schema.js';
import {
  checkWeeklySchedule,
  currentPeriod,
  nextOpening,
  type OpeningPeriod,
} from './weekly-hours.js';

export type GeoRefusal =
  | 'invalid_area'
  | 'invalid_name'
  | 'zone_name_taken'
  | 'zones_overlap'
  | 'unknown_zone'
  | 'invalid_fee_rule'
  | 'fee_not_in_base_currency'
  | 'no_fee_rule'
  | 'inside_zone'
  | 'invalid_office'
  | 'invalid_city'
  | 'city_code_taken'
  | 'last_active_city'
  | 'unknown_city';

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

// A zone with its outline, its corners in order without the closing one.
export interface ZoneOutline extends Zone {
  area: Point[];
}

// AP §9.12.1 «المدن»: a city's own fields.
export interface City {
  id: string;
  code: string;
  name: string;
  timeZone: string;
  status: 'active' | 'inactive';
}

// AP §9.12.2: a cell of the vote map, about 100 m across, with its votes.
export interface VoteCell {
  latitude: number;
  longitude: number;
  votes: number;
}

export interface DeliveryFee {
  fee: bigint;
  currency: string;
  free: boolean;
  // The rule version it was priced with, and that rule's free-delivery
  // threshold (null without one).
  ruleId: string;
  // Whether the rule is the city's or the restaurant's own (slice 2.37a).
  scope: 'city' | 'restaurant';
  freeDeliveryFrom: bigint | null;
  // The distance of a distance-band rule; null for a flat one.
  distance: Distance | null;
}

// A fee rule version with its id.
export type FeeRule = DeliveryFeeRule & { id: string };

// A version as «رسوم التوصيل» lists it: who set it, why and when.
export interface FeeRuleVersion {
  rule: FeeRule;
  editorId: string | null;
  reason: string | null;
  createdAt: Date;
}

// AP §9.12.1, CA C13: the city's office and its desk hours, with whether the
// desk is open at the moment asked: open, until when today (CA §7.5 «المكتب
// مفتوح حتى {الساعة}»); closed, when it opens next (null with no hours).
export interface Office {
  location: Point;
  hours: OpeningPeriod[];
  timeZone: string;
  open: boolean;
  closesAt: Date | null;
  opensAt: Date | null;
}

// Owner decision 2026-11-06: the fee is priced before a captain is known, by
// the motorbike's road distance, whoever delivers.
const FEE_VEHICLE: Vehicle = 'motorbike';

// Owner decisions 2026-11-06 (CU §7.2): one vote per device within 500 m,
// and a vote over 50 km from every active zone belongs to no city.
export const VOTE_RADIUS_METRES = 500;
export const VOTE_CITY_METRES = 50_000;

type Executor = Pick<NodePgDatabase, 'select' | 'selectDistinctOn'>;

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

  // The fee rules, the city's and the restaurants' own, are in the city's
  // base currency (AP §8.6), so fx refuses a base change until they are in
  // the new base.
  onModuleInit(): void {
    this.fx.useCityAmounts(async (cityId, executor) => {
      const rule = await this.deliveryFeeRule(cityId, executor);
      const own = await this.restaurantFeeRules(cityId, executor);
      return [
        ...(rule === null ? [] : [{ key: 'delivery_fee_rule', currency: rule.currency }]),
        ...own.map(({ restaurantId, rule }) => ({
          key: `restaurant_fee_rule:${restaurantId}`,
          currency: rule.currency,
        })),
      ];
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

  // Every city, active or not, by name: «المدن» (AP §9.12.1), where an
  // inactive city can be activated again.
  async cities(): Promise<City[]> {
    return this.database.db.select(cityFields).from(cities).orderBy(asc(cities.name));
  }

  // One city, active or not; null for an unknown one.
  async city(cityId: string): Promise<City | null> {
    const [row] = await this.database.db
      .select(cityFields)
      .from(cities)
      .where(eq(cities.id, cityId));
    return row ?? null;
  }

  // AP §9.12.1 «المدن» (OWN): the city's name, its code (used in receipt
  // numbers from now on; those issued keep theirs), its clock and its status.
  // Owner decision 2026-11-19: the clock may change at any time, orders or
  // not. A value already in place changes and records nothing.
  async updateCity(cityId: string, fields: Omit<City, 'id'>, change: GeoChange): Promise<void> {
    const name = fields.name.trim();
    if (name.length === 0) throw new GeoRefusedError('invalid_name', 'a city needs a name');
    if (!/^[A-Z]{2,3}$/.test(fields.code)) {
      throw new GeoRefusedError('invalid_city', 'a city code is two or three capital letters');
    }
    await this.database.db.transaction(async (tx) => {
      const [{ known } = { known: false }] = await tx
        .execute<{ known: boolean }>(
          sql`SELECT EXISTS (SELECT 1 FROM pg_timezone_names WHERE name = ${fields.timeZone}) AS known`,
        )
        .then((result) => result.rows);
      if (!known || !knownTimeZone(fields.timeZone)) {
        throw new GeoRefusedError('invalid_city', `unknown time zone ${fields.timeZone}`);
      }
      const [before] = await tx
        .select(cityFields)
        .from(cities)
        .where(eq(cities.id, cityId))
        .for('update');
      if (!before) throw new GeoRefusedError('unknown_city', 'no such city');
      const after = { name, code: fields.code, timeZone: fields.timeZone, status: fields.status };
      const changed = (Object.keys(after) as (keyof typeof after)[]).filter(
        (key) => before[key] !== after[key],
      );
      if (changed.length === 0) return;
      if (changed.includes('code')) {
        const [taken] = await tx
          .select({ id: cities.id })
          .from(cities)
          .where(and(eq(cities.code, after.code), ne(cities.id, cityId)));
        if (taken) {
          throw new GeoRefusedError('city_code_taken', `another city has the code ${after.code}`);
        }
      }
      if (changed.includes('status') && after.status === 'inactive') {
        // What an inactive city stops is the owner's to decide; until then
        // the platform keeps one active city (decided by us).
        const [other] = await tx
          .select({ id: cities.id })
          .from(cities)
          .where(and(eq(cities.status, 'active'), ne(cities.id, cityId)))
          .limit(1);
        if (!other) {
          throw new GeoRefusedError('last_active_city', 'the last active city stays active');
        }
      }
      try {
        await tx.update(cities).set(after).where(eq(cities.id, cityId));
      } catch (error) {
        // Another city took the code meanwhile.
        if ((error as { cause?: { code?: string } }).cause?.code === '23505') {
          throw new GeoRefusedError('city_code_taken', `another city has the code ${after.code}`);
        }
        throw error;
      }
      await this.audit.recordWrite(
        {
          actor: change.actor,
          context: change.context,
          cityId,
          action: 'city.update',
          target: { type: 'city', id: cityId },
          before: Object.fromEntries(changed.map((key) => [key, before[key]])),
          after: Object.fromEntries(changed.map((key) => [key, after[key]])),
          reason: change.reason ?? null,
        },
        tx,
      );
    });
  }

  // The city's id by its code, such as AZ; null for an unknown code.
  async cityIdByCode(code: string): Promise<string | null> {
    const [row] = await this.database.db
      .select({ id: cities.id })
      .from(cities)
      .where(eq(cities.code, code));
    return row?.id ?? null;
  }

  // The city's code and clock, such as AZ and Asia/Damascus, for its receipt
  // numbers (AP §4.8); null for an unknown city.
  async cityCode(cityId: string): Promise<{ code: string; timeZone: string } | null> {
    const [row] = await this.database.db
      .select({ code: cities.code, timeZone: cities.timeZone })
      .from(cities)
      .where(eq(cities.id, cityId));
    return row ?? null;
  }

  // The city's time zone, such as Asia/Damascus, the clock of its restaurants'
  // hours; null for an unknown city.
  async cityTimeZone(
    cityId: string,
    executor: Pick<Database['db'], 'select'> = this.database.db,
  ): Promise<string | null> {
    const [row] = await executor
      .select({ timeZone: cities.timeZone })
      .from(cities)
      .where(eq(cities.id, cityId));
    return row?.timeZone ?? null;
  }

  // The city's office in force (the newest version) and the desk's state at
  // this moment on the city's clock; null until one is saved.
  async office(cityId: string, now: Date): Promise<Office | null> {
    const [row] = await this.database.db
      .select({
        id: offices.id,
        latitude: offices.latitude,
        longitude: offices.longitude,
        timeZone: cities.timeZone,
      })
      .from(offices)
      .innerJoin(cities, eq(cities.id, offices.cityId))
      .where(eq(offices.cityId, cityId))
      .orderBy(desc(offices.id))
      .limit(1);
    if (!row) return null;
    const hours = await this.officeHours(this.database.db, row.id);
    const period = currentPeriod(hours, now, row.timeZone);
    return {
      location: { latitude: row.latitude, longitude: row.longitude },
      hours,
      timeZone: row.timeZone,
      open: period !== null,
      closesAt: period?.endsAt ?? null,
      opensAt: period === null ? nextOpening(hours, now, row.timeZone) : null,
    };
  }

  // Saves a new version of the city's office (AP §9.12.1; owner decision
  // 2026-11-12: coordinates until the map, one desk period per weekday at
  // most, the rules of a restaurant's week: 30 minutes or more, no overlap,
  // one may cross midnight). Audited city.office with the version before.
  async setOffice(
    cityId: string,
    office: { location: Point; hours: OpeningPeriod[] },
    change: GeoChange,
  ): Promise<void> {
    const { latitude, longitude } = office.location;
    if (
      !Number.isFinite(latitude) ||
      !Number.isFinite(longitude) ||
      Math.abs(latitude) > 90 ||
      Math.abs(longitude) > 180
    ) {
      throw new GeoRefusedError('invalid_office', 'the office is a point on the map');
    }
    const hours = [...office.hours].sort((a, b) => a.weekday - b.weekday);
    const problem =
      new Set(hours.map((period) => period.weekday)).size < hours.length
        ? 'one desk period per weekday'
        : checkWeeklySchedule(hours);
    if (problem !== null) throw new GeoRefusedError('invalid_office', problem);

    await this.database.db.transaction(async (tx) => {
      // The city row, locked, so two saves take turns.
      const [city] = await tx
        .select({ id: cities.id })
        .from(cities)
        .where(eq(cities.id, cityId))
        .for('update');
      if (!city) throw new GeoRefusedError('unknown_city', 'no such city');
      const [before] = await tx
        .select({ id: offices.id, latitude: offices.latitude, longitude: offices.longitude })
        .from(offices)
        .where(eq(offices.cityId, cityId))
        .orderBy(desc(offices.id))
        .limit(1);
      const [{ id }] = (await tx
        .insert(offices)
        .values({
          cityId,
          latitude,
          longitude,
          editorId: change.actor.type === 'admin' ? change.actor.id : null,
        })
        .returning({ id: offices.id })) as [{ id: string }];
      if (hours.length > 0) {
        await tx.insert(officePeriods).values(hours.map((period) => ({ officeId: id, ...period })));
      }
      await this.audit.recordWrite(
        {
          actor: change.actor,
          context: change.context,
          cityId,
          action: 'city.office',
          target: { type: 'city', id: cityId },
          before: before
            ? {
                location: { latitude: before.latitude, longitude: before.longitude },
                hours: await this.officeHours(tx, before.id),
              }
            : null,
          after: { location: { latitude, longitude }, hours },
          reason: change.reason ?? null,
        },
        tx,
      );
    });
  }

  private async officeHours(executor: Executor, officeId: string): Promise<OpeningPeriod[]> {
    return executor
      .select({
        weekday: officePeriods.weekday,
        opensAt: officePeriods.opensAt,
        closesAt: officePeriods.closesAt,
      })
      .from(officePeriods)
      .where(eq(officePeriods.officeId, officeId))
      .orderBy(asc(officePeriods.weekday));
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

  // A leg's route for the maps (architecture §7.1, CA §4.6, CU §11.3): by
  // road with its line and duration, or the straight line × 1.3 at the city's
  // order.eta_speed_kmh without a line when OSRM does not answer. It always
  // asks OSRM: pricing.distance_method decides the fee's distance, not the map.
  async route(
    cityId: string,
    from: Point,
    to: Point,
    { vehicle }: { vehicle: Vehicle },
  ): Promise<Route> {
    const speedKmh = await this.settings.get('order.eta_speed_kmh', { cityId });
    return measureRoute(from, to, vehicle, speedKmh, this.road, (error) => {
      this.logger.warn(
        { vehicle, err: error },
        'OSRM did not answer the route: the straight line × 1.3 is used',
      );
    });
  }

  // The distances from many points, each with its vehicle, to one point, in
  // their order (dispatch's ranking, AP §9.12.6): one OSRM matrix per
  // vehicle, following pricing.distance_method, the straight line × 1.3 for
  // any point OSRM cannot answer.
  async distancesTo(sources: { point: Point; vehicle: Vehicle }[], to: Point): Promise<Distance[]> {
    const method = await this.settings.get('pricing.distance_method');
    const result: Distance[] = new Array<Distance>(sources.length);
    const byVehicle = new Map<Vehicle, number[]>();
    sources.forEach((source, index) => {
      byVehicle.set(source.vehicle, [...(byVehicle.get(source.vehicle) ?? []), index]);
    });
    await Promise.all(
      [...byVehicle].map(async ([vehicle, indexes]) => {
        const measured = await measureDistances(
          indexes.map((index) => sources[index]!.point),
          to,
          vehicle,
          method,
          this.road,
          (error) => {
            this.logger.warn(
              { vehicle, err: error },
              'OSRM matrix did not answer for every point: the straight line × 1.3 is used',
            );
          },
        );
        indexes.forEach((index, at) => {
          result[index] = measured[at]!;
        });
      }),
    );
    return result;
  }

  // The city's zones, active or not, by name.
  async zones(cityId: string): Promise<Zone[]> {
    return this.database.db
      .select({ id: zones.id, name: zones.name, active: zones.active })
      .from(zones)
      .where(eq(zones.cityId, cityId))
      .orderBy(asc(zones.name));
  }

  // The city's zones with their outlines, by name: the zones map (AP
  // §9.12.2). The corners leave SQL as GeoJSON, never as a polygon value.
  async zoneOutlines(cityId: string): Promise<ZoneOutline[]> {
    const rows = await this.database.db
      .select({
        id: zones.id,
        name: zones.name,
        active: zones.active,
        area: sql<string>`ST_AsGeoJSON(${zones.area}, 15)`,
      })
      .from(zones)
      .where(eq(zones.cityId, cityId))
      .orderBy(asc(zones.name));
    return rows.map((row) => ({ ...row, area: cornersOf(row.area) }));
  }

  // AP §9.12.2: the city's votes from outside its active zones (a zone
  // drawn over a vote later leaves it off), counted by cells of a thousandth
  // of a degree (about 100 m), the most voted first.
  async voteMap(cityId: string): Promise<VoteCell[]> {
    const latitude = sql<string>`round(ST_Y(${zoneVotes.location})::numeric, 3)`;
    const longitude = sql<string>`round(ST_X(${zoneVotes.location})::numeric, 3)`;
    const rows = await this.database.db
      .select({ latitude, longitude, votes: sql<number>`count(*)::int` })
      .from(zoneVotes)
      .where(
        and(
          eq(zoneVotes.cityId, cityId),
          sql`NOT EXISTS (SELECT 1 FROM geo.zones covering WHERE covering.city_id = ${cityId}
            AND covering.active AND ST_Covers(covering.area, ${zoneVotes.location}))`,
        ),
      )
      .groupBy(latitude, longitude)
      .orderBy(sql`count(*) DESC`, latitude, longitude);
    return rows.map((row) => ({
      latitude: Number(row.latitude),
      longitude: Number(row.longitude),
      votes: row.votes,
    }));
  }

  // AP §9.17 «Lost demand» (slice 2.41): the city's votes cast between two
  // moments from outside its active zones now, as the vote map counts them.
  async votesBetween(cityId: string, from: Date, to: Date): Promise<number> {
    const [row] = await this.database.db
      .select({ count: sql<number>`count(*)::int` })
      .from(zoneVotes)
      .where(
        and(
          eq(zoneVotes.cityId, cityId),
          sql`${zoneVotes.createdAt} >= ${from.toISOString()} AND ${zoneVotes.createdAt} < ${to.toISOString()}`,
          sql`NOT EXISTS (SELECT 1 FROM geo.zones covering WHERE covering.city_id = ${cityId}
            AND covering.active AND ST_Covers(covering.area, ${zoneVotes.location}))`,
        ),
      );
    return Number(row?.count ?? 0);
  }

  // The centre of the city's active zones, where a map of the city starts
  // (the wizard's pin, slice 2.30a); null without any.
  async zonesCentre(cityId: string): Promise<Point | null> {
    const [row] = await this.database.db
      .select({
        latitude: sql<number | null>`ST_Y(ST_Centroid(ST_Collect(${zones.area})))`,
        longitude: sql<number | null>`ST_X(ST_Centroid(ST_Collect(${zones.area})))`,
      })
      .from(zones)
      .where(and(eq(zones.cityId, cityId), eq(zones.active, true)));
    return row?.latitude == null || row.longitude == null
      ? null
      : { latitude: row.latitude, longitude: row.longitude };
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
    const { name, area } = zoneInput(zone);
    return this.database.db.transaction(async (tx) => {
      await refuseInvalidArea(tx, area);
      await lockZones(tx, cityId);
      return this.insertZone(
        tx,
        cityId,
        null,
        { name, area, active: zone.active },
        change,
        zone.area,
      );
    });
  }

  // Adds a zone under the city's zones lock: its name free in the city, and
  // when active, clear of the other active zones. Audited with its corners.
  private async insertZone(
    tx: Pick<NodePgDatabase, 'select' | 'insert' | 'execute'>,
    cityId: string,
    id: string | null,
    zone: { name: string; area: SQL; active: boolean },
    change: GeoChange,
    corners: Point[],
  ): Promise<string> {
    const { name, area, active } = zone;
    const [taken] = await tx
      .select({ id: zones.id })
      .from(zones)
      .where(and(eq(zones.cityId, cityId), eq(zones.name, name)));
    if (taken) {
      throw new GeoRefusedError('zone_name_taken', `the city already has a zone named ${name}`);
    }
    if (active) await this.refuseOverlap(tx, cityId, area, null);
    const [created] = (await tx
      .insert(zones)
      .values({ ...(id === null ? {} : { id }), cityId, name, area, active })
      .returning({ id: zones.id })) as [{ id: string }];
    await this.audit.recordWrite(
      {
        actor: change.actor,
        context: change.context,
        cityId,
        action: 'zone.create',
        target: { type: 'zone', id: created.id },
        before: null,
        after: { name, active, area: corners },
        reason: change.reason ?? null,
      },
      tx,
    );
    return created.id;
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

  // AP §9.12.2: a zone's name, outline and state as the zones map saves
  // them, under an id the panel chose: a new id creates the zone (as
  // createZone), so saving again changes nothing. An id of another city's
  // zone is unknown_zone. The checks of createZone apply; an active zone, or
  // one being activated, must not overlap another active zone. Only what
  // changed is written and audited.
  async saveZone(
    cityId: string,
    zoneId: string,
    zone: { name: string; area: Point[]; active: boolean },
    change: GeoChange,
  ): Promise<'created' | 'updated'> {
    const { name, area } = zoneInput(zone);
    return this.database.db.transaction(async (tx) => {
      await refuseInvalidArea(tx, area);
      await lockZones(tx, cityId);
      const [before] = await tx
        .select({
          cityId: zones.cityId,
          name: zones.name,
          active: zones.active,
          area: sql<string>`ST_AsGeoJSON(${zones.area}, 15)`,
          sameArea: sql<boolean>`ST_OrderingEquals(${zones.area}, ${area})`,
        })
        .from(zones)
        .where(eq(zones.id, zoneId));
      if (before && before.cityId !== cityId) {
        throw new GeoRefusedError('unknown_zone', 'the city has no such zone');
      }
      if (!before) {
        await this.insertZone(
          tx,
          cityId,
          zoneId,
          { name, area, active: zone.active },
          change,
          zone.area,
        );
        return 'created';
      }
      const nameChanged = before.name !== name;
      if (!nameChanged && before.sameArea && before.active === zone.active) return 'updated';
      if (nameChanged) {
        const [taken] = await tx
          .select({ id: zones.id })
          .from(zones)
          .where(and(eq(zones.cityId, cityId), eq(zones.name, name), ne(zones.id, zoneId)));
        if (taken) {
          throw new GeoRefusedError('zone_name_taken', `the city already has a zone named ${name}`);
        }
      }
      if (zone.active) await this.refuseOverlap(tx, cityId, area, zoneId);
      await tx
        .update(zones)
        .set({ name, area, active: zone.active, updatedAt: sql`now()` })
        .where(eq(zones.id, zoneId));
      const was: Record<string, unknown> = {};
      const now: Record<string, unknown> = {};
      if (nameChanged) [was.name, now.name] = [before.name, name];
      if (!before.sameArea) [was.area, now.area] = [cornersOf(before.area), zone.area];
      if (before.active !== zone.active) [was.active, now.active] = [before.active, zone.active];
      await this.audit.recordWrite(
        {
          actor: change.actor,
          context: change.context,
          cityId,
          action: 'zone.update',
          target: { type: 'zone', id: zoneId },
          before: was,
          after: now,
          reason: change.reason ?? null,
        },
        tx,
      );
      return 'updated';
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

  // AP §9.11.4 (slice 2.27d): the ids of the points the zone covers, its
  // edge included, whether it is active or not; in one query, the polygon
  // never leaving SQL.
  async covered(
    zoneId: string,
    points: { id: string; latitude: number; longitude: number }[],
  ): Promise<Set<string>> {
    if (points.length === 0) return new Set();
    const rows = await this.database.db.execute<{ id: string }>(sql`
      SELECT p.id
      FROM unnest(
        ${sql.param(points.map((point) => point.id))}::text[],
        ${sql.param(points.map((point) => point.latitude))}::float8[],
        ${sql.param(points.map((point) => point.longitude))}::float8[]
      ) AS p(id, latitude, longitude)
      JOIN ${zones} ON ${zones.id} = ${zoneId}::uuid
      WHERE ST_Covers(${zones.area}, ST_SetSRID(ST_MakePoint(p.longitude, p.latitude), 4326))`);
    return new Set(rows.rows.map((row) => row.id));
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
  ): Promise<FeeRule | null> {
    const [row] = await executor
      .select()
      .from(feeRules)
      .where(eq(feeRules.cityId, cityId))
      .orderBy(desc(feeRules.id))
      .limit(1);
    if (!row) return null;
    return (await withBands([row], executor, 'city'))[0]!.rule;
  }

  // A restaurant's own rule in effect (slice 2.37a); null while it follows
  // the city's rule.
  async restaurantFeeRule(
    cityId: string,
    restaurantId: string,
    executor: Executor = this.database.db,
  ): Promise<FeeRule | null> {
    const [row] = await executor
      .select()
      .from(restaurantFeeRules)
      .where(
        and(
          eq(restaurantFeeRules.cityId, cityId),
          eq(restaurantFeeRules.restaurantId, restaurantId),
        ),
      )
      .orderBy(desc(restaurantFeeRules.id))
      .limit(1);
    if (!row || row.kind === 'city_rule') return null;
    return (await withBands([row], executor, 'restaurant'))[0]!.rule;
  }

  // «رسوم التوصيل» (AP §9.12.3): the city's rule versions, newest first, at
  // most `limit`.
  async deliveryFeeVersions(cityId: string, limit = 50): Promise<FeeRuleVersion[]> {
    const rows = await this.database.db
      .select()
      .from(feeRules)
      .where(eq(feeRules.cityId, cityId))
      .orderBy(desc(feeRules.id))
      .limit(limit);
    return withBands(rows, this.database.db, 'city');
  }

  // The restaurants of the city with a rule of their own in effect, each
  // with its version.
  async restaurantFeeRules(
    cityId: string,
    executor: Executor = this.database.db,
  ): Promise<(FeeRuleVersion & { restaurantId: string })[]> {
    const rows = await executor
      .selectDistinctOn([restaurantFeeRules.restaurantId])
      .from(restaurantFeeRules)
      .where(eq(restaurantFeeRules.cityId, cityId))
      .orderBy(restaurantFeeRules.restaurantId, desc(restaurantFeeRules.id));
    const own = rows.filter((row) => row.kind !== 'city_rule');
    const versions = await withBands(own, executor, 'restaurant');
    return versions.map((version, index) => ({
      ...version,
      restaurantId: own[index]!.restaurantId,
    }));
  }

  // A new version of the city's delivery fee rule, in effect at once, in the
  // city's base currency (AP §9.12.3, §8.6).
  async setDeliveryFeeRule(
    cityId: string,
    rule: DeliveryFeeRule,
    change: GeoChange,
  ): Promise<string> {
    return (await this.addFeeRule(cityId, null, rule, change))!;
  }

  // A new version of a restaurant's own rule, in effect at once, replacing
  // the city's for that restaurant alone (slice 2.37a, owner decision
  // 2026-11-19); null returns it to the city's rule. The caller checks the
  // restaurant is the city's. Answers the rule's id, or null when the
  // restaurant follows the city's rule.
  async setRestaurantFeeRule(
    cityId: string,
    restaurantId: string,
    rule: DeliveryFeeRule | null,
    change: GeoChange,
  ): Promise<string | null> {
    return this.addFeeRule(cityId, restaurantId, rule, change);
  }

  private async addFeeRule(
    cityId: string,
    restaurantId: string | null,
    rule: DeliveryFeeRule | null,
    change: GeoChange,
  ): Promise<string | null> {
    if (rule !== null) {
      const problem = checkDeliveryFeeRule(rule);
      if (problem !== null) throw new GeoRefusedError('invalid_fee_rule', problem);
    }

    return this.database.db.transaction(async (tx) => {
      // A base change takes the same lock, so it never passes this rule; so
      // do the other changes of the city's rules.
      await lockCityCurrencies(tx, cityId);
      if (rule !== null) {
        // The fee is charged in the base currency. Until the first order
        // locks the base, the rule may be entered in another of the city's
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
      }
      const before =
        restaurantId === null
          ? await this.deliveryFeeRule(cityId, tx)
          : await this.restaurantFeeRule(cityId, restaurantId, tx);
      // A change that changes nothing adds no version.
      if (before === null && rule === null) return null;
      if (before !== null && rule !== null && sameRule(before, rule)) return before.id;
      const values = {
        cityId,
        currency: rule?.currency ?? null,
        flatFee: rule?.kind === 'flat' ? rule.flatFee : null,
        minimumFee: rule?.minimumFee ?? null,
        freeDeliveryFrom: rule?.freeDeliveryFrom ?? null,
        editorId: change.actor.type === 'admin' ? change.actor.id : null,
        reason: change.reason ?? null,
      };
      const bands = rule?.kind === 'distance_bands' ? rule.bands : [];
      let id: string;
      if (restaurantId === null) {
        // The city's rule always has one.
        [{ id }] = (await tx
          .insert(feeRules)
          .values({ ...values, kind: rule!.kind, currency: rule!.currency })
          .returning({ id: feeRules.id })) as [{ id: string }];
        if (bands.length > 0) {
          await tx
            .insert(feeBands)
            .values(bands.map((band, position) => ({ ruleId: id, position, ...band })));
        }
      } else {
        [{ id }] = (await tx
          .insert(restaurantFeeRules)
          .values({ ...values, restaurantId, kind: rule?.kind ?? 'city_rule' })
          .returning({ id: restaurantFeeRules.id })) as [{ id: string }];
        if (bands.length > 0) {
          await tx
            .insert(restaurantFeeBands)
            .values(bands.map((band, position) => ({ ruleId: id, position, ...band })));
        }
      }
      await this.audit.recordWrite(
        {
          actor: change.actor,
          context: change.context,
          cityId,
          action: restaurantId === null ? 'delivery_fee_rule.set' : 'restaurant_fee_rule.set',
          target:
            restaurantId === null
              ? { type: 'city', id: cityId }
              : { type: 'restaurant', id: restaurantId },
          before: before === null ? null : forAudit(before),
          after: rule === null ? { id, kind: 'city_rule' } : forAudit({ ...rule, id }),
          reason: change.reason ?? null,
        },
        tx,
      );
      return rule === null ? null : id;
    });
  }

  // The fee a customer pays to have an order of this items value, in the
  // base currency, carried from the restaurant to the point (AP §9.12.3),
  // by the restaurant's own rule or else the city's. The items value is
  // after the restaurant's item discounts, the value the commission is on
  // (owner decision 2026-11-06; docs/domain/04).
  async deliveryFee(
    cityId: string,
    {
      restaurantId,
      from,
      to,
      itemsValue,
    }: { restaurantId: string | null; from: Point; to: Point; itemsValue: bigint },
  ): Promise<DeliveryFee> {
    const own = restaurantId === null ? null : await this.restaurantFeeRule(cityId, restaurantId);
    const rule = own ?? (await this.deliveryFeeRule(cityId));
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
      scope: own === null ? 'city' : 'restaurant',
      freeDeliveryFrom: rule.freeDeliveryFrom,
      distance,
    };
  }
}

// Rule rows with their bands, in their order, in one query for the bands:
// the city's from fee_bands, a restaurant's from restaurant_fee_bands.
async function withBands(
  rows: {
    id: string;
    kind: 'flat' | 'distance_bands' | 'city_rule';
    currency: string | null;
    flatFee: bigint | null;
    minimumFee: bigint | null;
    freeDeliveryFrom: bigint | null;
    editorId: string | null;
    reason: string | null;
    createdAt: Date;
  }[],
  executor: Executor,
  scope: 'city' | 'restaurant',
): Promise<FeeRuleVersion[]> {
  const banded = rows.filter((row) => row.kind === 'distance_bands').map((row) => row.id);
  const table = scope === 'city' ? feeBands : restaurantFeeBands;
  const bands =
    banded.length === 0
      ? []
      : await executor
          .select({ ruleId: table.ruleId, upToMetres: table.upToMetres, fee: table.fee })
          .from(table)
          .where(inArray(table.ruleId, banded))
          .orderBy(asc(table.ruleId), asc(table.position));
  return rows.map((row) => {
    const common = {
      id: row.id,
      currency: row.currency!,
      minimumFee: row.minimumFee,
      freeDeliveryFrom: row.freeDeliveryFrom,
    };
    const rule: FeeRule =
      row.kind === 'flat'
        ? { ...common, kind: 'flat', flatFee: row.flatFee! }
        : {
            ...common,
            kind: 'distance_bands',
            bands: bands
              .filter((band) => band.ruleId === row.id)
              .map(({ upToMetres, fee }) => ({ upToMetres, fee })),
          };
    return { rule, editorId: row.editorId, reason: row.reason, createdAt: row.createdAt };
  });
}

const cityFields = {
  id: cities.id,
  code: cities.code,
  name: cities.name,
  timeZone: cities.timeZone,
  status: cities.status,
};

// Whether the JavaScript clock knows the zone too (business-day.ts and the
// weekly hours compute on it), besides PostgreSQL.
function knownTimeZone(timeZone: string): boolean {
  try {
    new Intl.DateTimeFormat('en', { timeZone });
    return true;
  } catch {
    return false;
  }
}

// A zone's name trimmed and its outline as a PostGIS polygon, the ring
// closed; an empty name, fewer than three distinct corners or one off the
// map is refused.
function zoneInput(zone: { name: string; area: Point[] }): { name: string; area: SQL } {
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
  return { name, area: sql`ST_SetSRID(ST_GeomFromGeoJSON(${ring}), 4326)` };
}

// An outline that crosses itself is refused.
async function refuseInvalidArea(executor: Pick<NodePgDatabase, 'execute'>, area: SQL) {
  const [{ valid } = { valid: false }] = await executor
    .execute<{ valid: boolean }>(sql`SELECT ST_IsValid(${area}) AS valid`)
    .then((result) => result.rows);
  if (!valid) throw new GeoRefusedError('invalid_area', 'the zone outline crosses itself');
}

// A polygon's GeoJSON as its corners in order, without the closing one.
function cornersOf(geoJson: string): Point[] {
  const { coordinates } = JSON.parse(geoJson) as { coordinates: [number, number][][] };
  return (coordinates[0] ?? [])
    .slice(0, -1)
    .map(([longitude, latitude]) => ({ latitude, longitude }));
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
