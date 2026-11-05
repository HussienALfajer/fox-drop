import { Inject, Injectable, Logger, type OnModuleInit } from '@nestjs/common';
import { and, asc, desc, eq, sql } from 'drizzle-orm';
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
import { cities, feeBands, feeRules, zones } from './schema.js';

export type GeoRefusal =
  | 'invalid_area'
  | 'zone_name_taken'
  | 'invalid_fee_rule'
  | 'fee_not_in_base_currency'
  | 'no_fee_rule';

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
  // The rule version it was priced with.
  ruleId: string;
  // The distance of a distance-band rule; null for a flat one.
  distance: Distance | null;
}

// Owner decision 2026-11-06: the fee is priced before a captain is known, by
// the motorbike's road distance, whoever delivers.
const FEE_VEHICLE: Vehicle = 'motorbike';

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

  // The city's id by its code, such as AZ; null for an unknown code.
  async cityIdByCode(code: string): Promise<string | null> {
    const [row] = await this.database.db
      .select({ id: cities.id })
      .from(cities)
      .where(eq(cities.code, code));
    return row?.id ?? null;
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
  // The ring closes by itself; one that crosses itself is refused.
  async createZone(
    cityId: string,
    zone: { name: string; area: Point[]; active: boolean },
    change: GeoChange,
  ): Promise<string> {
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
      const [row] = await tx
        .insert(zones)
        .values({ cityId, name: zone.name, area, active: zone.active })
        .onConflictDoNothing({ target: [zones.cityId, zones.name] })
        .returning({ id: zones.id });
      if (!row) {
        throw new GeoRefusedError(
          'zone_name_taken',
          `the city already has a zone named ${zone.name}`,
        );
      }
      await this.audit.recordWrite(
        {
          actor: change.actor,
          context: change.context,
          cityId,
          action: 'zone.create',
          target: { type: 'zone', id: row.id },
          before: null,
          after: { name: zone.name, active: zone.active, corners: corners.length },
          reason: change.reason ?? null,
        },
        tx,
      );
      return row.id;
    });
  }

  // The active zone a point is inside, its edge included (CU §7.1); null
  // outside every active zone. Where two overlap, the smaller one, the more
  // precise neighbourhood.
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
      .orderBy(sql`ST_Area(${zones.area})`, asc(zones.id))
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
      const base = await this.fx.baseCurrency(cityId, tx);
      if (rule.currency !== base) {
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
  async deliveryFee(
    cityId: string,
    { from, to, itemsValue }: { from: Point; to: Point; itemsValue: bigint },
  ): Promise<DeliveryFee> {
    const rule = await this.deliveryFeeRule(cityId);
    if (rule === null) throw new GeoRefusedError('no_fee_rule', 'the city has no delivery fee yet');
    const distance =
      rule.kind === 'distance_bands'
        ? await this.distance(from, to, { vehicle: FEE_VEHICLE })
        : null;
    const { fee, free } = deliveryFeeFor(rule, { itemsValue, metres: distance?.metres });
    return { fee, currency: rule.currency, free, ruleId: rule.id, distance };
  }
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
