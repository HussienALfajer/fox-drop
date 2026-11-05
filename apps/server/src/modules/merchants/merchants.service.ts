import { Inject, Injectable, type OnModuleInit } from '@nestjs/common';
import { and, asc, desc, eq, inArray, isNull, sql } from 'drizzle-orm';
import type { NodePgDatabase } from 'drizzle-orm/node-postgres';
import type { AnyPgColumn } from 'drizzle-orm/pg-core';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { type AuditActor, type AuditRequestContext, AuditService } from '../audit/index.js';
import { FxService } from '../fx/index.js';
import { GeoService, type Point } from '../geo/index.js';
import { lockCityCurrencies, SettingsService } from '../settings/index.js';
import { commissionAt } from './commission.js';
import { checkWeeklySchedule, currentPeriod, type OpeningPeriod } from './hours.js';
import { type AccountStatus, type OperatingState, operatingState } from './operating-state.js';
import {
  categories,
  commissionRates,
  coverageZones,
  holidayCloses,
  itemOptionGroups,
  items,
  openingPeriods,
  optionGroups,
  options,
  pauses,
  restaurants,
  weeklySchedules,
} from './schema.js';

export type MerchantsRefusal =
  | 'unknown_restaurant'
  | 'invalid_restaurant'
  | 'invalid_coverage'
  | 'invalid_schedule'
  | 'invalid_commission'
  | 'not_in_base_currency'
  | 'status_change_not_allowed'
  | 'invalid_menu'
  | 'item_code_taken'
  | 'reason_required';

// A change the merchants module refuses, with the reason the routes map to
// their own answers.
export class MerchantsRefusedError extends Error {
  override readonly name = 'MerchantsRefusedError';
  constructor(
    readonly refusal: MerchantsRefusal,
    message: string,
  ) {
    super(message);
  }
}

// Who changes a restaurant and why, for the audit log.
export interface MerchantChange {
  actor: AuditActor;
  context: AuditRequestContext;
  reason?: string | null;
}

// Owner decision 2026-11-06: a radius around the pin, or chosen zones.
export type Coverage =
  { kind: 'radius'; radiusMetres: number } | { kind: 'zones'; zoneIds: string[] };

// In the city's base currency, integer minor units (AP §8.6).
export interface Money {
  amount: bigint;
  currency: string;
}

export interface NewRestaurant {
  nameAr: string;
  nameEn?: string | null;
  category?: string | null;
  description?: string | null;
  address?: string | null;
  phone?: string | null;
  location: Point;
  coverage: Coverage;
  minimumOrder: Money;
  // Basis points of the items value: 1500 is 15% (AP §9.6.3 step 4, OWN).
  commissionBp: number;
  defaultPrepMin: number;
}

export interface Restaurant {
  id: string;
  cityId: string;
  nameAr: string;
  nameEn: string | null;
  accountStatus: AccountStatus;
  visible: boolean;
  location: Point;
  coverage: Coverage;
  minimumOrder: Money;
  defaultPrepMin: number;
  maxActiveOrders: number | null;
  // The commission in effect now, in basis points.
  commissionBp: number | null;
  schedule: OpeningPeriod[];
}

export interface MenuOption {
  id: string;
  name: string;
  priceDelta: Money;
  available: boolean;
}

export interface MenuOptionGroup {
  id: string;
  name: string;
  minChoices: number;
  maxChoices: number;
  options: MenuOption[];
}

export interface MenuItem {
  id: string;
  code: string;
  name: string;
  description: string | null;
  price: Money;
  available: boolean;
  hidden: boolean;
  optionGroups: MenuOptionGroup[];
}

export interface MenuCategory {
  id: string;
  name: string;
  hidden: boolean;
  available: boolean;
  items: MenuItem[];
}

export interface Menu {
  categories: MenuCategory[];
}

// AP §9.6.1, §9.6.3 step 8 and §9.6.5: the account status changes allowed.
// The activation checklist joins with the onboarding wizard (Phase 2).
const statusChanges: Record<AccountStatus, readonly AccountStatus[]> = {
  draft: ['test', 'active'],
  test: ['active', 'terminated'],
  active: ['suspended', 'terminated'],
  suspended: ['active', 'terminated'],
  terminated: [],
};

type Tx = Parameters<Parameters<Database['db']['transaction']>[0]>[0];
type Executor = Pick<NodePgDatabase, 'select' | 'execute'>;

// Restaurants, their hours, states, coverage, minimum order, commission and
// menu (architecture §4.2; AP §9.6, RA §7, §9, §10) for the other modules.
@Injectable()
export class MerchantsService implements OnModuleInit {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly geo: GeoService,
    private readonly fx: FxService,
    private readonly audit: AuditService,
    private readonly settings: SettingsService,
  ) {}

  // The minimum orders and menu prices are in the city's base currency
  // (AP §8.6), so fx refuses a base change while one is in another. A
  // terminated restaurant takes no more orders and does not count.
  onModuleInit(): void {
    this.fx.useCityAmounts(async (cityId, executor) => {
      const { rows } = await executor.execute<{ currency: string }>(sql`
        SELECT minimum_order_currency AS currency FROM merchants.restaurants
          WHERE city_id = ${cityId} AND account_status <> 'terminated'
        UNION
        SELECT i.currency FROM merchants.items i
          JOIN merchants.restaurants r ON r.id = i.restaurant_id
          WHERE r.city_id = ${cityId} AND r.account_status <> 'terminated' AND i.deleted_at IS NULL
        UNION
        SELECT o.currency FROM merchants.options o
          JOIN merchants.option_groups g ON g.id = o.group_id
          JOIN merchants.restaurants r ON r.id = g.restaurant_id
          WHERE r.city_id = ${cityId} AND r.account_status <> 'terminated' AND o.deleted_at IS NULL`);
      return rows.map(({ currency }) => ({ key: 'merchant_amounts', currency }));
    });
  }

  // The city's restaurants, by Arabic name.
  async restaurantIds(cityId: string): Promise<{ id: string; nameAr: string }[]> {
    return this.database.db
      .select({ id: restaurants.id, nameAr: restaurants.nameAr })
      .from(restaurants)
      .where(eq(restaurants.cityId, cityId))
      .orderBy(asc(restaurants.nameAr));
  }

  // A new restaurant, a draft until activated (AP §9.6.3).
  async createRestaurant(
    cityId: string,
    restaurant: NewRestaurant,
    change: MerchantChange,
  ): Promise<string> {
    const nameAr = restaurant.nameAr.trim();
    if (nameAr.length === 0) {
      throw new MerchantsRefusedError('invalid_restaurant', 'a restaurant needs an Arabic name');
    }
    if (!validPoint(restaurant.location)) {
      throw new MerchantsRefusedError('invalid_restaurant', 'the pin is not on the map');
    }
    // RA §10: within the prep-time chooser's limits.
    const floor = await this.settings.get('merchant.prep_time_floor_min', { cityId });
    const ceiling = await this.settings.get('merchant.prep_time_ceiling_min', { cityId });
    if (
      !Number.isInteger(restaurant.defaultPrepMin) ||
      restaurant.defaultPrepMin < floor ||
      restaurant.defaultPrepMin > ceiling
    ) {
      throw new MerchantsRefusedError(
        'invalid_restaurant',
        `the prep time is whole minutes from ${floor} to ${ceiling}`,
      );
    }
    checkCommission(restaurant.commissionBp);
    if (restaurant.minimumOrder.amount < 0n) {
      throw new MerchantsRefusedError('invalid_restaurant', 'the minimum order is 0 or more');
    }
    await this.checkCoverage(cityId, restaurant.coverage);
    const { longitude, latitude } = restaurant.location;

    return this.database.db.transaction(async (tx) => {
      await this.checkBaseCurrency(tx, cityId, restaurant.minimumOrder.currency);
      const [{ id }] = (await tx
        .insert(restaurants)
        .values({
          cityId,
          nameAr,
          nameEn: restaurant.nameEn ?? null,
          category: restaurant.category ?? null,
          description: restaurant.description ?? null,
          address: restaurant.address ?? null,
          phone: restaurant.phone ?? null,
          location: sql`ST_SetSRID(ST_MakePoint(${longitude}, ${latitude}), 4326)`,
          coverageKind: restaurant.coverage.kind,
          coverageRadiusMetres:
            restaurant.coverage.kind === 'radius' ? restaurant.coverage.radiusMetres : null,
          minimumOrder: restaurant.minimumOrder.amount,
          minimumOrderCurrency: restaurant.minimumOrder.currency,
          defaultPrepMin: restaurant.defaultPrepMin,
        })
        .returning({ id: restaurants.id })) as [{ id: string }];
      if (restaurant.coverage.kind === 'zones') {
        await tx
          .insert(coverageZones)
          .values(restaurant.coverage.zoneIds.map((zoneId) => ({ restaurantId: id, zoneId })));
      }
      await tx.insert(commissionRates).values({
        restaurantId: id,
        rateBp: restaurant.commissionBp,
        effectiveFrom: sql`now()`,
        ...changedBy(change.actor),
        reason: change.reason ?? null,
      });
      await this.audit.recordWrite(
        {
          actor: change.actor,
          context: change.context,
          cityId,
          action: 'restaurant.create',
          target: { type: 'restaurant', id },
          before: null,
          after: forAudit({ ...restaurant, nameAr }),
          reason: change.reason ?? null,
        },
        tx,
      );
      return id;
    });
  }

  async restaurant(restaurantId: string, at = new Date()): Promise<Restaurant | null> {
    const [row] = await this.database.db
      .select({
        id: restaurants.id,
        cityId: restaurants.cityId,
        nameAr: restaurants.nameAr,
        nameEn: restaurants.nameEn,
        accountStatus: restaurants.accountStatus,
        visible: restaurants.visible,
        latitude: sql<number>`ST_Y(${restaurants.location})`,
        longitude: sql<number>`ST_X(${restaurants.location})`,
        coverageKind: restaurants.coverageKind,
        coverageRadiusMetres: restaurants.coverageRadiusMetres,
        minimumOrder: restaurants.minimumOrder,
        minimumOrderCurrency: restaurants.minimumOrderCurrency,
        defaultPrepMin: restaurants.defaultPrepMin,
        maxActiveOrders: restaurants.maxActiveOrders,
      })
      .from(restaurants)
      .where(eq(restaurants.id, restaurantId));
    if (!row) return null;
    const coverage: Coverage =
      row.coverageKind === 'radius'
        ? { kind: 'radius', radiusMetres: row.coverageRadiusMetres! }
        : { kind: 'zones', zoneIds: await this.coveredZoneIds(this.database.db, restaurantId) };
    const rates = await this.database.db
      .select({
        id: commissionRates.id,
        rateBp: commissionRates.rateBp,
        effectiveFrom: commissionRates.effectiveFrom,
      })
      .from(commissionRates)
      .where(eq(commissionRates.restaurantId, restaurantId));
    return {
      id: row.id,
      cityId: row.cityId,
      nameAr: row.nameAr,
      nameEn: row.nameEn,
      accountStatus: row.accountStatus,
      visible: row.visible,
      location: { latitude: row.latitude, longitude: row.longitude },
      coverage,
      minimumOrder: { amount: row.minimumOrder, currency: row.minimumOrderCurrency },
      defaultPrepMin: row.defaultPrepMin,
      maxActiveOrders: row.maxActiveOrders,
      commissionBp: commissionAt(rates, at)?.rateBp ?? null,
      schedule: await this.schedule(this.database.db, restaurantId),
    };
  }

  // AP §9.6.1, §9.6.5: the account status, along the allowed changes.
  // Suspending, reactivating and terminating need a reason; a suspension
  // keeps it for the restaurant app (RA §5.5).
  async setAccountStatus(
    restaurantId: string,
    status: AccountStatus,
    change: MerchantChange,
  ): Promise<void> {
    await this.database.db.transaction(async (tx) => {
      const row = await this.lockRestaurant(tx, restaurantId);
      if (row.accountStatus === status) return;
      if (!statusChanges[row.accountStatus].includes(status)) {
        throw new MerchantsRefusedError(
          'status_change_not_allowed',
          `a ${row.accountStatus} restaurant cannot become ${status}`,
        );
      }
      if (
        (status === 'suspended' ||
          status === 'terminated' ||
          (row.accountStatus === 'suspended' && status === 'active')) &&
        !hasReason(change)
      ) {
        throw new MerchantsRefusedError('reason_required', `becoming ${status} needs a reason`);
      }
      await tx
        .update(restaurants)
        .set({
          accountStatus: status,
          suspensionReason: status === 'suspended' ? change.reason!.trim() : null,
          updatedAt: sql`now()`,
        })
        .where(eq(restaurants.id, restaurantId));
      await this.audit.recordWrite(
        {
          actor: change.actor,
          context: change.context,
          cityId: row.cityId,
          action: 'restaurant.status',
          target: { type: 'restaurant', id: restaurantId },
          before: { accountStatus: row.accountStatus },
          after: { accountStatus: status },
          reason: change.reason ?? null,
        },
        tx,
      );
    });
  }

  // RA §10: a new version of the weekly schedule, in force at once.
  async setWeeklySchedule(
    restaurantId: string,
    periods: OpeningPeriod[],
    change: MerchantChange,
  ): Promise<void> {
    const problem = checkWeeklySchedule(periods);
    if (problem !== null) throw new MerchantsRefusedError('invalid_schedule', problem);
    await this.database.db.transaction(async (tx) => {
      const row = await this.lockRestaurant(tx, restaurantId);
      const before = await this.schedule(tx, restaurantId);
      const [{ id }] = (await tx
        .insert(weeklySchedules)
        .values({ restaurantId, ...changedBy(change.actor) })
        .returning({ id: weeklySchedules.id })) as [{ id: string }];
      if (periods.length > 0) {
        await tx
          .insert(openingPeriods)
          .values(periods.map((period) => ({ scheduleId: id, ...period })));
      }
      await this.audit.recordWrite(
        {
          actor: change.actor,
          context: change.context,
          cityId: row.cityId,
          action: 'restaurant.hours',
          target: { type: 'restaurant', id: restaurantId },
          before: { periods: before },
          after: { periods },
          reason: change.reason ?? null,
        },
        tx,
      );
    });
  }

  // AP §9.6.5, D16: a new commission for new orders, at once or from a time.
  async setCommission(
    restaurantId: string,
    { rateBp, effectiveFrom }: { rateBp: number; effectiveFrom?: Date },
    change: MerchantChange,
  ): Promise<void> {
    checkCommission(rateBp);
    if (!hasReason(change)) {
      throw new MerchantsRefusedError('reason_required', 'a commission change needs a reason');
    }
    await this.database.db.transaction(async (tx) => {
      const row = await this.lockRestaurant(tx, restaurantId);
      // New orders only (D16): never from a moment already past.
      const [{ now }] = (await tx
        .execute<{ now: Date }>(sql`SELECT now() AS now`)
        .then((result) => result.rows)) as [{ now: Date }];
      if (effectiveFrom !== undefined && effectiveFrom.getTime() < new Date(now).getTime()) {
        throw new MerchantsRefusedError(
          'invalid_commission',
          'a commission change takes effect now or later',
        );
      }
      const rates = await tx
        .select({
          id: commissionRates.id,
          rateBp: commissionRates.rateBp,
          effectiveFrom: commissionRates.effectiveFrom,
        })
        .from(commissionRates)
        .where(eq(commissionRates.restaurantId, restaurantId));
      const before = commissionAt(rates, new Date(now));
      await tx.insert(commissionRates).values({
        restaurantId,
        rateBp,
        effectiveFrom: effectiveFrom ?? sql`now()`,
        ...changedBy(change.actor),
        reason: change.reason ?? null,
      });
      await this.audit.recordWrite(
        {
          actor: change.actor,
          context: change.context,
          cityId: row.cityId,
          action: 'restaurant.commission',
          target: { type: 'restaurant', id: restaurantId },
          before: before === null ? null : { rateBp: before.rateBp },
          after: { rateBp, effectiveFrom: effectiveFrom?.toISOString() ?? 'now' },
          reason: change.reason ?? null,
        },
        tx,
      );
    });
  }

  // The state at a moment (RA §7.1). Active orders count from the ordering
  // module when it exists (slice 1.8); until then none.
  async operatingState(restaurantId: string, now = new Date()): Promise<OperatingState> {
    const db = this.database.db;
    const [row] = await db
      .select({
        cityId: restaurants.cityId,
        accountStatus: restaurants.accountStatus,
        maxActiveOrders: restaurants.maxActiveOrders,
        busyExtraMin: restaurants.busyExtraMin,
        busyUntil: restaurants.busyUntil,
      })
      .from(restaurants)
      .where(eq(restaurants.id, restaurantId));
    if (!row) throw new MerchantsRefusedError('unknown_restaurant', 'no such restaurant');
    const timeZone = await this.geo.cityTimeZone(row.cityId);
    if (timeZone === null) throw new Error(`restaurant ${restaurantId} is in an unknown city`);
    const [holiday] = await db
      .select({ endsAt: holidayCloses.endsAt })
      .from(holidayCloses)
      .where(
        and(
          eq(holidayCloses.restaurantId, restaurantId),
          isNull(holidayCloses.endedAt),
          sql`${holidayCloses.startsAt} <= ${now.toISOString()}`,
          sql`${holidayCloses.endsAt} > ${now.toISOString()}`,
        ),
      )
      .orderBy(desc(holidayCloses.endsAt))
      .limit(1);
    const [pause] = await db
      .select({ source: pauses.source, endsAt: pauses.endsAt })
      .from(pauses)
      .where(
        and(
          eq(pauses.restaurantId, restaurantId),
          isNull(pauses.endedAt),
          sql`${pauses.startsAt} <= ${now.toISOString()}`,
          sql`(${pauses.endsAt} IS NULL OR ${pauses.endsAt} > ${now.toISOString()})`,
        ),
      )
      .orderBy(desc(pauses.startsAt))
      .limit(1);
    return operatingState(
      {
        accountStatus: row.accountStatus,
        holiday: holiday ?? null,
        period: currentPeriod(await this.schedule(db, restaurantId), now, timeZone),
        pause: pause ?? null,
        busyMode:
          row.busyExtraMin !== null && row.busyUntil !== null
            ? { extraMin: row.busyExtraMin, endsAt: row.busyUntil }
            : null,
        activeOrders: 0,
        maxActiveOrders: row.maxActiveOrders,
      },
      now,
    );
  }

  // Whether the restaurant delivers to the point (RA R13, CU §8): the point
  // is inside an active service zone, and inside the restaurant's radius or
  // one of its zones (owner decision 2026-11-06).
  async covers(restaurantId: string, { latitude, longitude }: Point): Promise<boolean> {
    if (!validPoint({ latitude, longitude })) return false;
    const [row] = await this.database.db
      .select({
        cityId: restaurants.cityId,
        coverageKind: restaurants.coverageKind,
        withinRadius: sql<boolean>`ST_DWithin(${restaurants.location}::geography, ST_SetSRID(ST_MakePoint(${longitude}, ${latitude}), 4326)::geography, ${restaurants.coverageRadiusMetres})`,
      })
      .from(restaurants)
      .where(eq(restaurants.id, restaurantId));
    if (!row) return false;
    const zone = await this.geo.zoneAt(row.cityId, { latitude, longitude });
    if (zone === null) return false;
    if (row.coverageKind === 'radius') return row.withinRadius;
    return (await this.coveredZoneIds(this.database.db, restaurantId)).includes(zone.id);
  }

  // AP §9.6.6: a category, published at once when an admin adds it.
  async addCategory(
    restaurantId: string,
    category: { name: string; window?: { startsAt: number; endsAt: number } | null },
    change: MerchantChange,
  ): Promise<string> {
    const name = category.name.trim();
    if (name.length === 0)
      throw new MerchantsRefusedError('invalid_menu', 'a category needs a name');
    const { window } = category;
    if (
      window != null &&
      (!Number.isInteger(window.startsAt) ||
        !Number.isInteger(window.endsAt) ||
        window.startsAt < 0 ||
        window.startsAt > 1439 ||
        window.endsAt < 0 ||
        window.endsAt > 1440)
    ) {
      throw new MerchantsRefusedError('invalid_menu', 'a window is two whole minutes of the day');
    }
    return this.database.db.transaction(async (tx) => {
      const row = await this.lockRestaurant(tx, restaurantId);
      const [{ count }] = (await tx
        .select({ count: sql<number>`count(*)::int` })
        .from(categories)
        .where(eq(categories.restaurantId, restaurantId))) as [{ count: number }];
      const [{ id }] = (await tx
        .insert(categories)
        .values({
          restaurantId,
          name,
          position: count,
          windowStartsAt: category.window?.startsAt ?? null,
          windowEndsAt: category.window?.endsAt ?? null,
          published: true,
        })
        .returning({ id: categories.id })) as [{ id: string }];
      await this.audit.recordWrite(
        {
          actor: change.actor,
          context: change.context,
          cityId: row.cityId,
          action: 'menu.category.create',
          target: { type: 'menu_category', id },
          before: null,
          after: { restaurantId, name, window: category.window ?? null },
          reason: change.reason ?? null,
        },
        tx,
      );
      return id;
    });
  }

  // AP §9.6.6: an item of a category, priced above 0 in the base currency
  // (RA §9.4). Its code is generated when left empty.
  async addItem(
    restaurantId: string,
    item: {
      categoryId: string;
      code?: string | null;
      name: string;
      description?: string | null;
      price: Money;
      optionGroupIds?: string[];
    },
    change: MerchantChange,
  ): Promise<string> {
    const name = item.name.trim();
    if (name.length === 0) throw new MerchantsRefusedError('invalid_menu', 'an item needs a name');
    if (item.price.amount <= 0n) {
      throw new MerchantsRefusedError('invalid_menu', 'an item price is above 0');
    }
    return this.database.db.transaction(async (tx) => {
      const row = await this.lockRestaurant(tx, restaurantId);
      await this.checkBaseCurrency(tx, row.cityId, item.price.currency);
      const [category] = await tx
        .select({ id: categories.id })
        .from(categories)
        .where(and(eq(categories.id, item.categoryId), eq(categories.restaurantId, restaurantId)));
      if (!category) throw new MerchantsRefusedError('invalid_menu', 'no such category here');
      const groupIds = item.optionGroupIds ?? [];
      if (groupIds.length > 0) {
        const groups = await tx
          .select({ id: optionGroups.id })
          .from(optionGroups)
          .where(
            and(inArray(optionGroups.id, groupIds), eq(optionGroups.restaurantId, restaurantId)),
          );
        if (groups.length !== new Set(groupIds).size) {
          throw new MerchantsRefusedError('invalid_menu', 'no such option group here');
        }
      }
      const [{ count }] = (await tx
        .select({ count: sql<number>`count(*)::int` })
        .from(items)
        .where(eq(items.restaurantId, restaurantId))) as [{ count: number }];
      const codeTaken = async (code: string) =>
        (
          await tx
            .select({ id: items.id })
            .from(items)
            .where(and(eq(items.restaurantId, restaurantId), eq(items.code, code)))
        ).length > 0;
      let code = item.code?.trim() ?? '';
      if (code.length > 0) {
        if (await codeTaken(code)) {
          throw new MerchantsRefusedError('item_code_taken', `the code ${code} is taken`);
        }
      } else {
        // A generated code skips the ones entered by hand.
        for (let next = count + 1; ; next += 1) {
          code = `I${String(next).padStart(4, '0')}`;
          if (!(await codeTaken(code))) break;
        }
      }
      const [{ id }] = (await tx
        .insert(items)
        .values({
          restaurantId,
          categoryId: item.categoryId,
          code,
          name,
          description: item.description ?? null,
          price: item.price.amount,
          currency: item.price.currency,
          position: count,
          published: true,
        })
        .returning({ id: items.id })) as [{ id: string }];
      if (groupIds.length > 0) {
        await tx
          .insert(itemOptionGroups)
          .values(groupIds.map((groupId, position) => ({ itemId: id, groupId, position })));
      }
      await this.audit.recordWrite(
        {
          actor: change.actor,
          context: change.context,
          cityId: row.cityId,
          action: 'menu.item.create',
          target: { type: 'menu_item', id },
          before: null,
          after: forAudit({ restaurantId, ...item, name, code }),
          reason: change.reason ?? null,
        },
        tx,
      );
      return id;
    });
  }

  // AP §9.6.6: an option group with its options; a minimum of 0 makes it an
  // add-on group. Deltas are 0 or more in the base currency (RA §9.4).
  async addOptionGroup(
    restaurantId: string,
    group: {
      name: string;
      minChoices: number;
      maxChoices: number;
      options: { name: string; priceDelta: Money }[];
    },
    change: MerchantChange,
  ): Promise<string> {
    const name = group.name.trim();
    const { minChoices, maxChoices } = group;
    if (
      name.length === 0 ||
      !Number.isInteger(minChoices) ||
      !Number.isInteger(maxChoices) ||
      minChoices < 0 ||
      maxChoices < 1 ||
      maxChoices < minChoices ||
      group.options.length < Math.max(minChoices, 1) ||
      group.options.some(
        (option) => option.name.trim().length === 0 || option.priceDelta.amount < 0n,
      )
    ) {
      throw new MerchantsRefusedError(
        'invalid_menu',
        'an option group needs a name, choices with 0 ≤ min ≤ max, max ≥ 1, enough named options and deltas of 0 or more',
      );
    }
    return this.database.db.transaction(async (tx) => {
      const row = await this.lockRestaurant(tx, restaurantId);
      for (const currency of new Set(group.options.map((option) => option.priceDelta.currency))) {
        await this.checkBaseCurrency(tx, row.cityId, currency);
      }
      const [{ id }] = (await tx
        .insert(optionGroups)
        .values({ restaurantId, name, minChoices, maxChoices, published: true })
        .returning({ id: optionGroups.id })) as [{ id: string }];
      await tx.insert(options).values(
        group.options.map((option, position) => ({
          groupId: id,
          name: option.name.trim(),
          priceDelta: option.priceDelta.amount,
          currency: option.priceDelta.currency,
          position,
          published: true,
        })),
      );
      await this.audit.recordWrite(
        {
          actor: change.actor,
          context: change.context,
          cityId: row.cityId,
          action: 'menu.option_group.create',
          target: { type: 'menu_option_group', id },
          before: null,
          after: forAudit({ restaurantId, ...group, name }),
          reason: change.reason ?? null,
        },
        tx,
      );
      return id;
    });
  }

  // The published menu, in order, with what is hidden or unavailable now
  // marked; deleted rows are left out. Availability windows and «حتى الغد»
  // join with the customer's menu (slice 1.7) and the switches (RA §9.3).
  async menu(restaurantId: string): Promise<Menu> {
    const db = this.database.db;
    const [restaurant] = await db
      .select({ id: restaurants.id })
      .from(restaurants)
      .where(eq(restaurants.id, restaurantId));
    if (!restaurant) throw new MerchantsRefusedError('unknown_restaurant', 'no such restaurant');
    const published = (table: { published: AnyPgColumn; deletedAt: AnyPgColumn }) =>
      and(eq(table.published, true), isNull(table.deletedAt));
    const categoryRows = await db
      .select()
      .from(categories)
      .where(and(eq(categories.restaurantId, restaurantId), published(categories)))
      .orderBy(asc(categories.position), asc(categories.id));
    const itemRows = await db
      .select()
      .from(items)
      .where(and(eq(items.restaurantId, restaurantId), published(items)))
      .orderBy(asc(items.position), asc(items.id));
    const groupRows = await db
      .select()
      .from(optionGroups)
      .where(and(eq(optionGroups.restaurantId, restaurantId), published(optionGroups)));
    const groupIds = groupRows.map((group) => group.id);
    const optionRows =
      groupIds.length === 0
        ? []
        : await db
            .select()
            .from(options)
            .where(and(inArray(options.groupId, groupIds), published(options)))
            .orderBy(asc(options.position), asc(options.id));
    const links =
      itemRows.length === 0
        ? []
        : await db
            .select()
            .from(itemOptionGroups)
            .where(
              and(
                inArray(
                  itemOptionGroups.itemId,
                  itemRows.map((item) => item.id),
                ),
                isNull(itemOptionGroups.removedAt),
              ),
            )
            .orderBy(asc(itemOptionGroups.position));

    const groupsById = new Map(
      groupRows.map((group) => [
        group.id,
        {
          id: group.id,
          name: group.name,
          minChoices: group.minChoices,
          maxChoices: group.maxChoices,
          options: optionRows
            .filter((option) => option.groupId === group.id)
            .map((option) => ({
              id: option.id,
              name: option.name,
              priceDelta: { amount: option.priceDelta, currency: option.currency },
              available: option.available,
            })),
        },
      ]),
    );
    return {
      categories: categoryRows.map((category) => ({
        id: category.id,
        name: category.name,
        hidden: category.hidden,
        available: category.available,
        items: itemRows
          .filter((item) => item.categoryId === category.id)
          .map((item) => {
            const groups = links
              .filter((link) => link.itemId === item.id)
              .flatMap((link) => groupsById.get(link.groupId) ?? []);
            // RA §9.3: an unavailable category makes its items unavailable,
            // and so does a required group whose options are all unavailable.
            const requiredGroupOut = groups.some(
              (group) => group.minChoices > 0 && group.options.every((option) => !option.available),
            );
            return {
              id: item.id,
              code: item.code,
              name: item.name,
              description: item.description,
              price: { amount: item.price, currency: item.currency },
              available: item.available && category.available && !requiredGroupOut,
              hidden: item.hidden,
              optionGroups: groups,
            };
          }),
      })),
    };
  }

  private async lockRestaurant(tx: Tx, restaurantId: string) {
    const [row] = await tx
      .select({ cityId: restaurants.cityId, accountStatus: restaurants.accountStatus })
      .from(restaurants)
      .where(eq(restaurants.id, restaurantId))
      .for('update');
    if (!row) throw new MerchantsRefusedError('unknown_restaurant', 'no such restaurant');
    return row;
  }

  private async schedule(executor: Executor, restaurantId: string): Promise<OpeningPeriod[]> {
    const [current] = await executor
      .select({ id: weeklySchedules.id })
      .from(weeklySchedules)
      .where(eq(weeklySchedules.restaurantId, restaurantId))
      .orderBy(desc(weeklySchedules.id))
      .limit(1);
    if (!current) return [];
    return executor
      .select({
        weekday: openingPeriods.weekday,
        opensAt: openingPeriods.opensAt,
        closesAt: openingPeriods.closesAt,
      })
      .from(openingPeriods)
      .where(eq(openingPeriods.scheduleId, current.id))
      .orderBy(asc(openingPeriods.weekday), asc(openingPeriods.opensAt));
  }

  private async coveredZoneIds(executor: Executor, restaurantId: string): Promise<string[]> {
    const rows = await executor
      .select({ zoneId: coverageZones.zoneId })
      .from(coverageZones)
      .where(and(eq(coverageZones.restaurantId, restaurantId), isNull(coverageZones.removedAt)))
      .orderBy(asc(coverageZones.zoneId));
    return rows.map((row) => row.zoneId);
  }

  private async checkCoverage(cityId: string, coverage: Coverage): Promise<void> {
    if (coverage.kind === 'radius') {
      if (!Number.isInteger(coverage.radiusMetres) || coverage.radiusMetres <= 0) {
        throw new MerchantsRefusedError('invalid_coverage', 'the radius is whole metres above 0');
      }
      return;
    }
    const known = new Set((await this.geo.zones(cityId)).map((zone) => zone.id));
    if (
      coverage.zoneIds.length === 0 ||
      new Set(coverage.zoneIds).size !== coverage.zoneIds.length ||
      !coverage.zoneIds.every((id) => known.has(id))
    ) {
      throw new MerchantsRefusedError(
        'invalid_coverage',
        "coverage takes one or more of the city's zones",
      );
    }
  }

  // Amounts are in the city's base currency. Until the first order locks the
  // base, one of the city's other currencies is allowed, so the base can then
  // change to it (AP §8.6, D25), as the delivery fee does.
  private async checkBaseCurrency(tx: Tx, cityId: string, currency: string): Promise<void> {
    await lockCityCurrencies(tx, cityId);
    const base = await this.fx.baseCurrency(cityId, tx);
    const allowed =
      currency === base ||
      (!(await this.fx.baseLocked(cityId, tx)) &&
        (await this.fx.cityCurrencies(cityId, tx)).some((entry) => entry.currency === currency));
    if (!allowed) {
      throw new MerchantsRefusedError(
        'not_in_base_currency',
        `amounts are in the city's base currency, ${base ?? 'not chosen yet'}`,
      );
    }
  }
}

function validPoint({ latitude, longitude }: Point): boolean {
  return (
    Number.isFinite(latitude) &&
    Number.isFinite(longitude) &&
    Math.abs(latitude) <= 90 &&
    Math.abs(longitude) <= 180
  );
}

function hasReason(change: MerchantChange): boolean {
  return (change.reason ?? '').trim().length > 0;
}

function checkCommission(rateBp: number): void {
  if (!Number.isInteger(rateBp) || rateBp < 0 || rateBp > 10_000) {
    throw new MerchantsRefusedError(
      'invalid_commission',
      'the commission is 0 to 100%, in basis points',
    );
  }
}

function changedBy(actor: AuditActor): {
  changedByType: 'admin' | 'merchant' | 'system';
  changedById: string | null;
} {
  if (actor.type === 'admin' || actor.type === 'merchant' || actor.type === 'system') {
    return { changedByType: actor.type, changedById: actor.id };
  }
  throw new Error(`a ${actor.type} does not change a restaurant`);
}

// The audit log keeps JSON, which has no bigint: amounts become strings.
function forAudit(value: object): Record<string, unknown> {
  return JSON.parse(
    JSON.stringify(value, (_key, inner: unknown) =>
      typeof inner === 'bigint' ? inner.toString() : inner,
    ),
  ) as Record<string, unknown>;
}
