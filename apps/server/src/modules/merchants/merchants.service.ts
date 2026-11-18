import { Inject, Injectable, type OnModuleInit } from '@nestjs/common';
import { and, asc, desc, eq, inArray, isNull, or, sql } from 'drizzle-orm';
import type { NodePgDatabase } from 'drizzle-orm/node-postgres';
import type { AnyPgColumn } from 'drizzle-orm/pg-core';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { Jobs } from '../../jobs/jobs.module.js';
import { type AuditActor, type AuditRequestContext, AuditService } from '../audit/index.js';
import { CategoriesService, ContentRefusedError } from '../content/index.js';
import { FilesService } from '../files/index.js';
import { FxService } from '../fx/index.js';
import {
  checkWeeklySchedule,
  currentPeriod,
  GeoService,
  inDailyWindow,
  nextCutoff,
  nextOpening,
  type OpeningPeriod,
  type Point,
} from '../geo/index.js';
import { lockCityCurrencies, SettingsService } from '../settings/index.js';
import { commissionAt } from './commission.js';
import { type AccountStatus, type OperatingState, operatingState } from './operating-state.js';
import { recordStateChange, type StateKind } from './state-events.js';
import {
  categories,
  commissionRates,
  devicePlatforms,
  devices,
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
  | 'unknown_menu_row'
  | 'restaurant_terminated'
  | 'invalid_device'
  | 'device_rename_not_allowed'
  | 'reason_required'
  | 'upload_used'
  | 'restaurant_closed'
  | 'paused_by_operations'
  | 'invalid_pause'
  | 'invalid_busy_extra'
  | 'invalid_holiday_close'
  | 'invalid_prep_time'
  | 'invalid_max_active_orders'
  | 'invalid_pickup_currencies'
  | 'restaurant_suspended'
  | 'owner_only'
  // AP §9.13: not an active category, named twice, or too many.
  | 'unknown_category'
  // AP §9.6.3 (slice 2.30a): the wizard's city is unknown, or its target is
  // no longer a draft (or a draft of another city).
  | 'unknown_city'
  | 'not_a_draft'
  // AP §9.6.3 step 5: a contract without its date, duration or scan.
  | 'invalid_contract'
  // AP §9.6.3 step 7 (slice 2.30b): the wizard edits the menu of a draft or
  // a restaurant in test mode only.
  | 'menu_locked'
  // AP §9.6.3 step 8: test mode or activation with an item of the checklist
  // missing.
  | 'checklist_incomplete'
  // AP §9.6.5 «تثبيت» (slice 2.30c): outside 0 to SORT_WEIGHT_MAX.
  | 'invalid_sort_weight';

// Slice 2.30c: the same commission «now» again within this is a repeat.
const COMMISSION_REPEAT_WINDOW_MS = 60_000;

// AP §9.6.5 «تثبيت» (slice 2.30c, decided by us): the highest sort weight.
export const SORT_WEIGHT_MAX = 1000;

// AP §9.6.2: a restaurant as the panel's list reads it.
export interface RestaurantListRow {
  id: string;
  nameAr: string;
  nameEn: string | null;
  categoryIds: string[];
  accountStatus: AccountStatus;
  visible: boolean;
  sortWeight: number;
  phone: string | null;
  location: Point | null;
}

// AP §9.6.5, D16: a commission version as the panel lists it.
export interface CommissionHistoryEntry {
  id: string;
  rateBp: number;
  effectiveFrom: Date;
  changedByType: 'admin' | 'merchant' | 'system';
  changedById: string | null;
  reason: string | null;
  createdAt: Date;
}

// AP §9.13: how many categories one restaurant links to, at most.
export const RESTAURANT_CATEGORIES_MAX = 5;

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
  // AP §9.13: active categories of the content module, once each.
  categoryIds?: string[];
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
  // AP §9.13 «التصنيفات»: the content module's categories, in the panel's
  // choice order; removed ones stay until the restaurant's are set again.
  categoryIds: string[];
  description: string | null;
  // Keys in public-media, served by imgproxy (architecture §5.8); null
  // without an image.
  logoKey: string | null;
  coverKey: string | null;
  accountStatus: AccountStatus;
  // The reason of a suspension, for the restaurant app's banner (RA §5.5).
  suspensionReason: string | null;
  visible: boolean;
  // CU §8.1 «جديد على FOX DROP»: its first activation; null before.
  activatedAt: Date | null;
  location: Point;
  // The street address the captain app shows (CA §9.2); null until entered.
  address: string | null;
  // E.164, for the captain's «اتصال بالمطعم» (CA §9.2); null until entered.
  phone: string | null;
  coverage: Coverage;
  minimumOrder: Money;
  defaultPrepMin: number;
  maxActiveOrders: number | null;
  // RA §12.7: the other currencies switched on for pickup, as stored; the
  // base is always accepted. A reader keeps only the ones its snapshot has.
  pickupCurrencies: string[];
  // The commission in effect now, in basis points.
  commissionBp: number | null;
  schedule: OpeningPeriod[];
}

// A row's own availability switch (RA §9.3): null while on; off until a
// time («حتى الغد», the next business-day cutoff) or, with null, until turned
// back on («حتى أعيده»).
export type SwitchedOff = { until: Date | null } | null;

export type DevicePlatform = (typeof devicePlatforms)[number];

export interface StorefrontState {
  state: OperatingState;
  // A holiday close's message, or an operations pause's (AP §9.6.5).
  message: string | null;
  // While closed by the schedule, its next opening; null otherwise.
  opensAt: Date | null;
  // While inside an opening period, when it ends («يغلق اليوم 11:30 م», RA
  // §7.2); null outside one.
  closesAt: Date | null;
}

export interface MenuOption {
  id: string;
  name: string;
  priceDelta: Money;
  available: boolean;
  switchedOff: SwitchedOff;
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
  // Its key in public-media, served by imgproxy (architecture §5.8); null
  // without a photo.
  photoKey: string | null;
  price: Money;
  // Whether a customer can order it now: its switch, its category's (and its
  // window), and its required groups' options (RA §9.3).
  available: boolean;
  switchedOff: SwitchedOff;
  hidden: boolean;
  // AP §9.6.6: «جديد», «الأكثر طلباً» or «حار»; null without one.
  badge: 'new' | 'most_ordered' | 'spicy' | null;
  optionGroups: MenuOptionGroup[];
}

export interface MenuCategory {
  id: string;
  name: string;
  hidden: boolean;
  // Its switch and its daily window.
  available: boolean;
  switchedOff: SwitchedOff;
  // CU §9.3: minutes after midnight on the city's clock, such as breakfast
  // until 12:00; null all day. «متوفر من {الساعة}» outside it.
  window: { startsAt: number; endsAt: number } | null;
  inWindow: boolean;
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

export type Tx = Parameters<Parameters<Database['db']['transaction']>[0]>[0];
export type Executor = Pick<NodePgDatabase, 'select' | 'execute'>;

// A restaurant's orders in placed, accepted or ready (RA §7.4).
export type ActiveOrderCount = (restaurantId: string) => Promise<number>;

// Restaurants, their hours, states, coverage, minimum order, commission and
// menu (architecture §4.2; AP §9.6, RA §7, §9, §10) for the other modules.
@Injectable()
export class MerchantsService implements OnModuleInit {
  // RA §7.4: a restaurant's active orders, counted by the ordering module
  // (countActiveOrders); none until it registers.
  private activeOrders: ActiveOrderCount = () => Promise.resolve(0);
  // AP §9.6.3 step 8 (slice 2.30b): the checklist's owner accounts (identity)
  // and delivered test orders (ordering); none until they register.
  private ownerAccounts: ActiveOrderCount = () => Promise.resolve(0);
  private deliveredTestOrders: ActiveOrderCount = () => Promise.resolve(0);

  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly geo: GeoService,
    private readonly fx: FxService,
    private readonly audit: AuditService,
    private readonly settings: SettingsService,
    private readonly files: FilesService,
    private readonly jobs: Jobs,
    private readonly categories: CategoriesService,
  ) {}

  // AP §9.13, AP §9.6.3 step 1 (slice 2.27a): the restaurant's categories,
  // active ones of the content module, once each, at most
  // RESTAURANT_CATEGORIES_MAX; an empty list leaves it without one. Audited as
  // restaurant.categories.
  async setRestaurantCategories(
    restaurantId: string,
    categoryIds: string[],
    change: MerchantChange,
  ): Promise<string[]> {
    await this.checkCategories(categoryIds);
    return this.database.db.transaction(async (tx) => {
      const row = await this.lockRestaurant(tx, restaurantId);
      const [{ before }] = (await tx
        .select({ before: restaurants.categoryIds })
        .from(restaurants)
        .where(eq(restaurants.id, restaurantId))) as [{ before: string[] }];
      if (before.join() === categoryIds.join()) return before;
      await tx
        .update(restaurants)
        .set({ categoryIds, updatedAt: sql`now()` })
        .where(eq(restaurants.id, restaurantId));
      await this.audit.recordWrite(
        {
          actor: change.actor,
          context: change.context,
          cityId: row.cityId,
          action: 'restaurant.categories',
          target: { type: 'restaurant', id: restaurantId },
          before: { categoryIds: before },
          after: { categoryIds },
          reason: null,
        },
        tx,
      );
      return categoryIds;
    });
  }

  // Module-internal: the drafts service shares it (slice 2.30a).
  async checkCategories(ids: string[]): Promise<void> {
    if (ids.length > RESTAURANT_CATEGORIES_MAX) {
      throw new MerchantsRefusedError(
        'unknown_category',
        `at most ${RESTAURANT_CATEGORIES_MAX} categories`,
      );
    }
    try {
      await this.categories.checkActive(ids);
    } catch (error) {
      if (error instanceof ContentRefusedError) {
        throw new MerchantsRefusedError('unknown_category', error.message);
      }
      throw error;
    }
  }

  // The minimum orders and menu prices are in the city's base currency
  // (AP §8.6), so fx refuses a base change while one is in another. A
  // terminated restaurant takes no more orders and does not count.
  onModuleInit(): void {
    this.fx.useCityAmounts(async (cityId, executor) => {
      const { rows } = await executor.execute<{ currency: string }>(sql`
        SELECT minimum_order_currency AS currency FROM merchants.restaurants
          WHERE city_id = ${cityId} AND account_status <> 'terminated'
            AND minimum_order_currency IS NOT NULL
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

  // AP §9.6.2 «المطاعم» (slice 2.30c): every restaurant of the city as the
  // list reads it, drafts included (their pin may be missing), by name.
  async listRows(cityId: string): Promise<RestaurantListRow[]> {
    const rows = await this.database.db
      .select({
        id: restaurants.id,
        nameAr: restaurants.nameAr,
        nameEn: restaurants.nameEn,
        categoryIds: restaurants.categoryIds,
        accountStatus: restaurants.accountStatus,
        visible: restaurants.visible,
        sortWeight: restaurants.sortWeight,
        phone: restaurants.phone,
        latitude: sql<number | null>`ST_Y(${restaurants.location})`,
        longitude: sql<number | null>`ST_X(${restaurants.location})`,
      })
      .from(restaurants)
      .where(eq(restaurants.cityId, cityId))
      .orderBy(asc(restaurants.nameAr), asc(restaurants.id));
    return rows.map(({ latitude, longitude, ...row }) => ({
      ...row,
      location:
        latitude === null || longitude === null
          ? null
          : { latitude: Number(latitude), longitude: Number(longitude) },
    }));
  }

  // The restaurants' names by id, in one read: what an order shows of its
  // restaurant (CU §11.1).
  async names(ids: string[]): Promise<Map<string, { nameAr: string; nameEn: string | null }>> {
    if (ids.length === 0) return new Map();
    const rows = await this.database.db
      .select({ id: restaurants.id, nameAr: restaurants.nameAr, nameEn: restaurants.nameEn })
      .from(restaurants)
      .where(inArray(restaurants.id, ids));
    return new Map(rows.map(({ id, ...names }) => [id, names]));
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
    await this.checkCategories(restaurant.categoryIds ?? []);
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
          categoryIds: restaurant.categoryIds ?? [],
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

  // A restaurant with its whole record, or null: none, or a draft still
  // without its pin or operations.
  async restaurant(restaurantId: string, at = new Date()): Promise<Restaurant | null> {
    const [row] = await this.database.db
      .select({
        id: restaurants.id,
        cityId: restaurants.cityId,
        nameAr: restaurants.nameAr,
        nameEn: restaurants.nameEn,
        categoryIds: restaurants.categoryIds,
        description: restaurants.description,
        logoKey: restaurants.logoKey,
        coverKey: restaurants.coverKey,
        accountStatus: restaurants.accountStatus,
        suspensionReason: restaurants.suspensionReason,
        visible: restaurants.visible,
        activatedAt: restaurants.activatedAt,
        latitude: sql<number>`ST_Y(${restaurants.location})`,
        longitude: sql<number>`ST_X(${restaurants.location})`,
        address: restaurants.address,
        phone: restaurants.phone,
        coverageKind: restaurants.coverageKind,
        coverageRadiusMetres: restaurants.coverageRadiusMetres,
        minimumOrder: restaurants.minimumOrder,
        minimumOrderCurrency: restaurants.minimumOrderCurrency,
        defaultPrepMin: restaurants.defaultPrepMin,
        maxActiveOrders: restaurants.maxActiveOrders,
        pickupCurrencies: restaurants.pickupCurrencies,
      })
      .from(restaurants)
      .where(eq(restaurants.id, restaurantId));
    // A draft whose wizard has not reached its pin and operations is no
    // restaurant yet for any reader (slice 2.30a); the wizard reads it apart.
    if (
      !row ||
      row.minimumOrder === null ||
      row.minimumOrderCurrency === null ||
      row.defaultPrepMin === null ||
      row.latitude === null
    ) {
      return null;
    }
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
      .where(
        and(eq(commissionRates.restaurantId, restaurantId), isNull(commissionRates.withdrawnAt)),
      );
    return {
      id: row.id,
      cityId: row.cityId,
      nameAr: row.nameAr,
      nameEn: row.nameEn,
      categoryIds: row.categoryIds,
      description: row.description,
      logoKey: row.logoKey,
      coverKey: row.coverKey,
      accountStatus: row.accountStatus,
      suspensionReason: row.suspensionReason,
      visible: row.visible,
      activatedAt: row.activatedAt,
      location: { latitude: row.latitude, longitude: row.longitude },
      address: row.address,
      phone: row.phone,
      coverage,
      minimumOrder: { amount: row.minimumOrder, currency: row.minimumOrderCurrency },
      defaultPrepMin: row.defaultPrepMin,
      maxActiveOrders: row.maxActiveOrders,
      pickupCurrencies: row.pickupCurrencies,
      commissionBp: commissionAt(rates, at)?.rateBp ?? null,
      schedule: await this.schedule(this.database.db, restaurantId),
    };
  }

  // The account status read in another module's transaction under a share
  // lock on the restaurant's row, so the status cannot change before that
  // transaction ends (setAccountStatus takes the row's update lock): the
  // wizard's accounts are added and removed only while a draft (slice
  // 2.30a). Null for no such restaurant.
  async lockedAccountStatus(tx: Tx, restaurantId: string): Promise<AccountStatus | null> {
    const [row] = await tx
      .select({ accountStatus: restaurants.accountStatus })
      .from(restaurants)
      .where(eq(restaurants.id, restaurantId))
      .for('share');
    return row?.accountStatus ?? null;
  }

  // A restaurant's city and account status, a draft without its record
  // included (the wizard's accounts, slice 2.30a), or null.
  async cityAndStatus(
    restaurantId: string,
  ): Promise<{ cityId: string; accountStatus: AccountStatus } | null> {
    const [row] = await this.database.db
      .select({ cityId: restaurants.cityId, accountStatus: restaurants.accountStatus })
      .from(restaurants)
      .where(eq(restaurants.id, restaurantId));
    return row ?? null;
  }

  // AP §9.6.1: the restaurant's account status now, or null for no such
  // restaurant (RA §5.5, for the restaurant users' sign-in).
  async accountStatus(restaurantId: string): Promise<AccountStatus | null> {
    const [row] = await this.database.db
      .select({ accountStatus: restaurants.accountStatus })
      .from(restaurants)
      .where(eq(restaurants.id, restaurantId));
    return row?.accountStatus ?? null;
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
      await this.writeAccountStatus(tx, restaurantId, row, status, change);
    });
  }

  // AP §9.6.5 (slice 2.30c): the panel's suspension (from active) and
  // reactivation (from suspended), never another change, so a reactivation
  // cannot skip test mode's checklist. The status already reached changes
  // nothing.
  async changeAccountStatusFrom(
    restaurantId: string,
    from: AccountStatus,
    status: AccountStatus,
    change: MerchantChange,
  ): Promise<void> {
    await this.database.db.transaction(async (tx) => {
      const row = await this.lockRestaurant(tx, restaurantId);
      if (row.accountStatus === status) return;
      if (row.accountStatus !== from) {
        throw new MerchantsRefusedError(
          'status_change_not_allowed',
          `only a ${from} restaurant becomes ${status} here`,
        );
      }
      await this.writeAccountStatus(tx, restaurantId, row, status, change);
    });
  }

  // AP §9.6.5 «إنهاء» (slice 2.30c): the termination in the caller's
  // transaction, which cashdesk runs under the restaurant's account lock
  // after checking its balance. Answers the city; terminated already changes
  // nothing.
  async terminateIn(tx: Tx, restaurantId: string, change: MerchantChange): Promise<void> {
    const row = await this.lockRestaurant(tx, restaurantId);
    if (row.accountStatus === 'terminated') return;
    if (row.accountStatus === 'draft') {
      throw new MerchantsRefusedError('status_change_not_allowed', 'a draft is not terminated');
    }
    await this.writeAccountStatus(tx, restaurantId, row, 'terminated', change);
  }

  // Module-internal: the status change under the restaurant's lock, which the
  // activation service shares (slice 2.30b) after its checklist.
  async writeAccountStatus(
    tx: Tx,
    restaurantId: string,
    row: { cityId: string; accountStatus: AccountStatus; complete: boolean },
    status: AccountStatus,
    change: MerchantChange,
  ): Promise<void> {
    if (row.accountStatus === status) return;
    if (!statusChanges[row.accountStatus].includes(status) || !row.complete) {
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
        // CU §8.1: the first activation, from a draft or test mode.
        ...(status === 'active'
          ? { activatedAt: sql`coalesce(${restaurants.activatedAt}, now())` }
          : {}),
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
    // RA §16 #23, §5.5 (slice 2.30c): the restaurant's devices read their
    // status again; a suspension and a reactivation chime.
    const kind: StateKind | null =
      status === 'suspended'
        ? 'suspended_by_operations'
        : status === 'terminated'
          ? 'terminated'
          : row.accountStatus === 'suspended' && status === 'active'
            ? 'reactivated_by_operations'
            : null;
    if (kind !== null) {
      await recordStateChange(tx, this.jobs, {
        restaurantId,
        cityId: row.cityId,
        kind,
        at: new Date(),
        values: kind === 'suspended_by_operations' ? { reason: change.reason!.trim() } : {},
      });
    }
  }

  // AP §9.6.5 «إخفاء أو إظهار» (slice 2.30c): visibility only; customers see
  // an active restaurant only while visible (AP §9.6.1). Not once terminated.
  // The same value again writes nothing.
  async setVisibility(restaurantId: string, visible: boolean, change: MerchantChange) {
    await this.database.db.transaction(async (tx) => {
      const row = await this.lockRestaurant(tx, restaurantId);
      if (row.accountStatus === 'terminated') {
        throw new MerchantsRefusedError('restaurant_terminated', 'the restaurant is terminated');
      }
      const [{ before }] = (await tx
        .select({ before: restaurants.visible })
        .from(restaurants)
        .where(eq(restaurants.id, restaurantId))) as [{ before: boolean }];
      if (before === visible) return;
      await tx
        .update(restaurants)
        .set({ visible, updatedAt: sql`now()` })
        .where(eq(restaurants.id, restaurantId));
      await this.audit.recordWrite(
        {
          actor: change.actor,
          context: change.context,
          cityId: row.cityId,
          action: 'restaurant.visibility',
          target: { type: 'restaurant', id: restaurantId },
          before: { visible: before },
          after: { visible },
          reason: change.reason ?? null,
        },
        tx,
      );
    });
  }

  // AP §9.6.5 «تثبيت» (slice 2.30c): the position in the lists, the higher
  // first (customers' lists sort by it), 0 to SORT_WEIGHT_MAX. Not once
  // terminated. The same value again writes nothing.
  async setSortWeight(restaurantId: string, sortWeight: number, change: MerchantChange) {
    if (!Number.isInteger(sortWeight) || sortWeight < 0 || sortWeight > SORT_WEIGHT_MAX) {
      throw new MerchantsRefusedError(
        'invalid_sort_weight',
        `the sort weight is a whole number from 0 to ${SORT_WEIGHT_MAX}`,
      );
    }
    await this.database.db.transaction(async (tx) => {
      const row = await this.lockRestaurant(tx, restaurantId);
      if (row.accountStatus === 'terminated') {
        throw new MerchantsRefusedError('restaurant_terminated', 'the restaurant is terminated');
      }
      const [{ before }] = (await tx
        .select({ before: restaurants.sortWeight })
        .from(restaurants)
        .where(eq(restaurants.id, restaurantId))) as [{ before: number }];
      if (before === sortWeight) return;
      await tx
        .update(restaurants)
        .set({ sortWeight, updatedAt: sql`now()` })
        .where(eq(restaurants.id, restaurantId));
      await this.audit.recordWrite(
        {
          actor: change.actor,
          context: change.context,
          cityId: row.cityId,
          action: 'restaurant.sort_weight',
          target: { type: 'restaurant', id: restaurantId },
          before: { sortWeight: before },
          after: { sortWeight },
          reason: change.reason ?? null,
        },
        tx,
      );
    });
  }

  // AP §9.6.5 (slice 2.30c): what the panel's actions read: the account
  // status with a suspension's reason, the visibility and the sort weight;
  // null for no such restaurant, a draft without its record included.
  async accountSettings(restaurantId: string): Promise<{
    cityId: string;
    nameAr: string;
    accountStatus: AccountStatus;
    suspensionReason: string | null;
    visible: boolean;
    sortWeight: number;
  } | null> {
    const [row] = await this.database.db
      .select({
        cityId: restaurants.cityId,
        nameAr: restaurants.nameAr,
        accountStatus: restaurants.accountStatus,
        suspensionReason: restaurants.suspensionReason,
        visible: restaurants.visible,
        sortWeight: restaurants.sortWeight,
      })
      .from(restaurants)
      .where(eq(restaurants.id, restaurantId));
    return row ?? null;
  }

  // AP §9.6.5, D16 (slice 2.30c): every commission version not withdrawn,
  // the latest start first, with who set it and why («سجل العمولة»).
  async commissionVersions(restaurantId: string): Promise<CommissionHistoryEntry[]> {
    return this.database.db
      .select({
        id: commissionRates.id,
        rateBp: commissionRates.rateBp,
        effectiveFrom: commissionRates.effectiveFrom,
        changedByType: commissionRates.changedByType,
        changedById: commissionRates.changedById,
        reason: commissionRates.reason,
        createdAt: commissionRates.createdAt,
      })
      .from(commissionRates)
      .where(
        and(eq(commissionRates.restaurantId, restaurantId), isNull(commissionRates.withdrawnAt)),
      )
      .orderBy(desc(commissionRates.effectiveFrom), desc(commissionRates.id));
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
      await recordStateChange(tx, this.jobs, {
        restaurantId,
        cityId: row.cityId,
        kind: 'hours',
        at: new Date(),
      });
    });
  }

  // RA §12.2, AP §9.6.5, D16 (slice 2.19d): the commission in force now and
  // the next version scheduled after now, if any («تتغيّر عمولتك…»).
  async commissionSchedule(
    restaurantId: string,
    now: Date,
  ): Promise<{ rateBp: number | null; next: { rateBp: number; from: Date } | null }> {
    const rates = await this.database.db
      .select({
        id: commissionRates.id,
        rateBp: commissionRates.rateBp,
        effectiveFrom: commissionRates.effectiveFrom,
      })
      .from(commissionRates)
      .where(
        and(eq(commissionRates.restaurantId, restaurantId), isNull(commissionRates.withdrawnAt)),
      );
    const ahead = rates.filter((rate) => rate.effectiveFrom.getTime() > now.getTime());
    const firstStart = Math.min(...ahead.map((rate) => rate.effectiveFrom.getTime()));
    const next = commissionAt(
      ahead.filter((rate) => rate.effectiveFrom.getTime() === firstStart),
      new Date(firstStart),
    );
    return {
      rateBp: commissionAt(rates, now)?.rateBp ?? null,
      next: next && { rateBp: next.rateBp, from: next.effectiveFrom },
    };
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
      // Slice 2.30c: a draft's commission is the wizard's step 4, without a
      // reason or a push; a terminated restaurant takes no new order.
      if (row.accountStatus === 'draft') {
        throw new MerchantsRefusedError('not_a_draft', 'a draft’s commission is the wizard’s');
      }
      if (row.accountStatus === 'terminated') {
        throw new MerchantsRefusedError('restaurant_terminated', 'the restaurant is terminated');
      }
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
        .where(
          and(eq(commissionRates.restaurantId, restaurantId), isNull(commissionRates.withdrawnAt)),
        );
      const before = commissionAt(rates, new Date(now));
      // A request sent again (the same rate and start, or the same rate «now»
      // within REPEAT_WINDOW_MS of the latest version) changes nothing, so a
      // retry neither adds a version nor pushes twice.
      const [latest] = await tx
        .select({
          rateBp: commissionRates.rateBp,
          effectiveFrom: commissionRates.effectiveFrom,
          createdAt: commissionRates.createdAt,
        })
        .from(commissionRates)
        .where(
          and(eq(commissionRates.restaurantId, restaurantId), isNull(commissionRates.withdrawnAt)),
        )
        .orderBy(desc(commissionRates.id))
        .limit(1);
      if (
        latest !== undefined &&
        latest.rateBp === rateBp &&
        (effectiveFrom !== undefined
          ? latest.effectiveFrom.getTime() === effectiveFrom.getTime()
          : latest.effectiveFrom.getTime() <= new Date(now).getTime() &&
            new Date(now).getTime() - latest.createdAt.getTime() < COMMISSION_REPEAT_WINDOW_MS)
      ) {
        return;
      }
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
      // RA §16 #33, §12.2 (S15): the owners hear the new rate and its start.
      await recordStateChange(tx, this.jobs, {
        restaurantId,
        cityId: row.cityId,
        kind: 'commission_change',
        at: new Date(now),
        values: { rateBp, from: (effectiveFrom ?? new Date(now)).toISOString() },
      });
    });
  }

  // RA §7.4: the ordering module counts the active orders, which this module
  // cannot read (architecture §4.3).
  countActiveOrders(count: ActiveOrderCount): void {
    this.activeOrders = count;
  }

  // AP §9.6.3 step 8: identity counts a restaurant's owner accounts.
  countOwnerAccounts(count: ActiveOrderCount): void {
    this.ownerAccounts = count;
  }

  // AP §9.6.3 step 8: ordering counts a restaurant's delivered test orders.
  countDeliveredTestOrders(count: ActiveOrderCount): void {
    this.deliveredTestOrders = count;
  }

  ownerAccountCount(restaurantId: string): Promise<number> {
    return this.ownerAccounts(restaurantId);
  }

  deliveredTestOrderCount(restaurantId: string): Promise<number> {
    return this.deliveredTestOrders(restaurantId);
  }

  // RA §7.4: the restaurant's orders in placed, accepted or ready now.
  activeOrderCount(restaurantId: string): Promise<number> {
    return this.activeOrders(restaurantId);
  }

  // The state at a moment (RA §7.1).
  async operatingState(restaurantId: string, now = new Date()): Promise<OperatingState> {
    return (await this.storefrontState(restaurantId, now)).state;
  }

  // The operating state as customers see it (CU §9.2): with the message of a
  // holiday close or an operations pause, and, while closed by the schedule,
  // when it next opens («مغلق — يفتح {اليوم} {الساعة}»).
  // A command reads it inside its transaction, after the restaurant's lock.
  async storefrontState(
    restaurantId: string,
    now = new Date(),
    db: Executor = this.database.db,
  ): Promise<StorefrontState> {
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
      .select({ endsAt: holidayCloses.endsAt, message: holidayCloses.message })
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
      .select({ source: pauses.source, endsAt: pauses.endsAt, message: pauses.message })
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
    const schedule = await this.schedule(db, restaurantId);
    const period = currentPeriod(schedule, now, timeZone);
    const state = operatingState(
      {
        accountStatus: row.accountStatus,
        holiday: holiday ?? null,
        period,
        pause: pause ?? null,
        busyMode:
          row.busyExtraMin !== null && row.busyUntil !== null
            ? { extraMin: row.busyExtraMin, endsAt: row.busyUntil }
            : null,
        // Counted only against a maximum: the count reads every partition.
        activeOrders: row.maxActiveOrders === null ? 0 : await this.activeOrders(restaurantId),
        maxActiveOrders: row.maxActiveOrders,
      },
      now,
    );
    const message =
      state.state === 'holiday'
        ? (holiday?.message ?? null)
        : state.state === 'paused' && state.source === 'ops'
          ? (pause?.message ?? null)
          : null;
    const opensAt = state.state === 'closed' ? nextOpening(schedule, now, timeZone) : null;
    return { state, message, opensAt, closesAt: period?.endsAt ?? null };
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

  // The restaurants a customer at the point sees (CU §8.2): active and
  // visible, covering it as covers() does, whatever their operating state.
  // An admin test account (AP §9.8, slice 2.25b) also sees the restaurants
  // in test mode (AP §9.6.3), `seenByCustomer`.
  async coveringRestaurants(cityId: string, point: Point, testAccount = false): Promise<string[]> {
    if (!validPoint(point)) return [];
    const zone = await this.geo.zoneAt(cityId, point);
    if (zone === null) return [];
    const at = sql`ST_SetSRID(ST_MakePoint(${point.longitude}, ${point.latitude}), 4326)::geography`;
    const rows = await this.database.db
      .select({ id: restaurants.id })
      .from(restaurants)
      .where(
        and(
          eq(restaurants.cityId, cityId),
          or(
            and(eq(restaurants.accountStatus, 'active'), eq(restaurants.visible, true)),
            testAccount ? eq(restaurants.accountStatus, 'test') : undefined,
          ),
          sql`CASE ${restaurants.coverageKind}
            WHEN 'radius' THEN ST_DWithin(${restaurants.location}::geography, ${at}, ${restaurants.coverageRadiusMetres})
            ELSE EXISTS (SELECT 1 FROM ${coverageZones} WHERE ${coverageZones.restaurantId} = ${restaurants.id} AND ${coverageZones.zoneId} = ${zone.id} AND ${coverageZones.removedAt} IS NULL)
          END`,
        ),
      )
      .orderBy(desc(restaurants.sortWeight), asc(restaurants.id));
    return rows.map((row) => row.id);
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
  // marked; deleted rows are left out. A switch off «حتى الغد» is on again
  // from its time. A category outside its daily window, on the city's clock,
  // is unavailable with its items (CU §9.3).
  async menu(restaurantId: string, now = new Date()): Promise<Menu> {
    const db = this.database.db;
    const [restaurant] = await db
      .select({ id: restaurants.id, cityId: restaurants.cityId })
      .from(restaurants)
      .where(eq(restaurants.id, restaurantId));
    if (!restaurant) throw new MerchantsRefusedError('unknown_restaurant', 'no such restaurant');
    const timeZone = await this.geo.cityTimeZone(restaurant.cityId);
    if (timeZone === null) throw new Error(`restaurant ${restaurantId} is in an unknown city`);
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
              available: switchedOff(option, now) === null,
              switchedOff: switchedOff(option, now),
            })),
        },
      ]),
    );
    return {
      categories: categoryRows.map((category) => {
        const window =
          category.windowStartsAt === null || category.windowEndsAt === null
            ? null
            : { startsAt: category.windowStartsAt, endsAt: category.windowEndsAt };
        const inWindow = window === null || inDailyWindow(window, now, timeZone);
        const categoryOn = switchedOff(category, now) === null && inWindow;
        return {
          id: category.id,
          name: category.name,
          hidden: category.hidden,
          available: categoryOn,
          switchedOff: switchedOff(category, now),
          window,
          inWindow,
          items: itemRows
            .filter((item) => item.categoryId === category.id)
            .map((item) => {
              const groups = links
                .filter((link) => link.itemId === item.id)
                .flatMap((link) => groupsById.get(link.groupId) ?? []);
              // RA §9.3: an unavailable category makes its items unavailable,
              // and so does a required group whose options are all unavailable.
              const requiredGroupOut = groups.some(
                (group) =>
                  group.minChoices > 0 && group.options.every((option) => !option.available),
              );
              return {
                id: item.id,
                code: item.code,
                name: item.name,
                description: item.description,
                photoKey: item.photoKey,
                price: { amount: item.price, currency: item.currency },
                available: switchedOff(item, now) === null && categoryOn && !requiredGroupOut,
                switchedOff: switchedOff(item, now),
                hidden: item.hidden,
                badge: item.badge,
                optionGroups: groups,
              };
            }),
        };
      }),
    };
  }

  // Whether this app installation has its name in the restaurant (RA §5.2
  // item 5).
  // RA §4.7, §8.4: the names of the restaurant's devices by their app
  // installation, for «قُبل الطلب من جهاز {اسم الجهاز}»; an unnamed one is
  // left out.
  async deviceNames(restaurantId: string, deviceIds: string[]): Promise<Map<string, string>> {
    if (deviceIds.length === 0) return new Map();
    const rows = await this.database.db
      .select({ deviceId: devices.deviceId, name: devices.name })
      .from(devices)
      .where(and(eq(devices.restaurantId, restaurantId), inArray(devices.deviceId, deviceIds)));
    return new Map(rows.map((row) => [row.deviceId, row.name]));
  }

  async deviceNamed(restaurantId: string, deviceId: string): Promise<boolean> {
    const [device] = await this.database.db
      .select({ id: devices.id })
      .from(devices)
      .where(and(eq(devices.restaurantId, restaurantId), eq(devices.deviceId, deviceId)));
    return device !== undefined;
  }

  // RA §5.2 item 5, §5.3: names a device on its first sign-in, with its
  // platform and app version. Renaming it is managing devices, an owner's
  // capability (RA §5.4), so a cashier may only name it the first time.
  async nameDevice(
    restaurantId: string,
    deviceId: string,
    device: { name: string; platform: DevicePlatform; appVersion: string },
    by: { accountId: string; role: 'owner' | 'cashier' },
    now = new Date(),
  ): Promise<void> {
    const name = device.name.trim();
    if (name.length === 0)
      throw new MerchantsRefusedError('invalid_device', 'a device needs a name');
    const values = {
      name,
      platform: device.platform,
      appVersion: device.appVersion,
      namedById: by.accountId,
      updatedAt: now,
    };
    await this.database.db.transaction(async (tx) => {
      await this.lockRestaurant(tx, restaurantId);
      const [named] = await tx
        .select({ id: devices.id })
        .from(devices)
        .where(and(eq(devices.restaurantId, restaurantId), eq(devices.deviceId, deviceId)));
      if (named && by.role !== 'owner') {
        throw new MerchantsRefusedError(
          'device_rename_not_allowed',
          'only an owner renames a device',
        );
      }
      if (named) {
        await tx.update(devices).set(values).where(eq(devices.id, named.id));
      } else {
        await tx.insert(devices).values({ restaurantId, deviceId, createdAt: now, ...values });
      }
    });
  }

  // RA §9.3: switches a category, an item or an option of the restaurant on,
  // or off «حتى الغد» (until the next business-day cutoff on the city's
  // clock, RA §4.9) or «حتى أعيده». A category's switch leaves its items' own
  // switches as they are. Audited with the user and the device.
  async setAvailability(
    restaurantId: string,
    target: { type: 'category' | 'item' | 'option'; id: string },
    availability: { available: true } | { available: false; until: 'tomorrow' | 'turned_back_on' },
    change: MerchantChange,
    now = new Date(),
    // The statuses this caller edits (the wizard's step 7: a draft or test
    // mode), checked under the lock; `menu_locked` otherwise.
    onlyIn: readonly AccountStatus[] | null = null,
  ): Promise<SwitchedOff> {
    const until = availability.available
      ? null
      : await this.switchedOffUntil(restaurantId, availability.until, now);
    return this.database.db.transaction(async (tx) => {
      const row = await this.lockRestaurant(tx, restaurantId);
      // RA §5.5: a terminated restaurant keeps only its money section.
      if (row.accountStatus === 'terminated') {
        throw new MerchantsRefusedError('restaurant_terminated', 'the restaurant is terminated');
      }
      if (onlyIn !== null && !onlyIn.includes(row.accountStatus)) {
        throw new MerchantsRefusedError('menu_locked', 'this menu is not edited here now');
      }
      const switched = await this.writeAvailability(
        tx,
        row.cityId,
        restaurantId,
        target,
        availability.available,
        until,
        change,
        now,
      );
      if (!switched) {
        throw new MerchantsRefusedError('unknown_menu_row', `no such ${target.type} here`);
      }
      return availability.available ? null : { until };
    });
  }

  // RA §9.3: the end of a switch off: «حتى الغد» is the next business-day
  // cutoff on the city's clock (RA §4.9), «حتى أعيده» none (null).
  async switchedOffUntil(
    restaurantId: string,
    until: 'tomorrow' | 'turned_back_on',
    now: Date,
  ): Promise<Date | null> {
    if (until === 'turned_back_on') return null;
    const [city] = await this.database.db
      .select({ cityId: restaurants.cityId })
      .from(restaurants)
      .where(eq(restaurants.id, restaurantId));
    if (!city) throw new MerchantsRefusedError('unknown_restaurant', 'no such restaurant');
    const timeZone = await this.geo.cityTimeZone(city.cityId);
    if (timeZone === null) throw new Error(`restaurant ${restaurantId} is in an unknown city`);
    const cutoff = await this.settings.get('finance.business_day_cutoff', {
      cityId: city.cityId,
    });
    const [hours, minutes] = cutoff.split(':').map(Number) as [number, number];
    return nextCutoff(now, hours * 60 + minutes, timeZone);
  }

  // RA §8.6 «صنف غير متوفر», RA §8.12: a rejection's or an item report's
  // items switched off at once, in the order's transaction (after the
  // order's lock), each until the end `switchedOffUntil` gave. An item
  // deleted from the menu since is left alone. Audited as the restaurant's
  // own switch.
  async switchOffForRejection(
    tx: Tx,
    restaurantId: string,
    switches: { itemId: string; until: Date | null }[],
    change: MerchantChange,
    now: Date,
  ): Promise<void> {
    const row = await this.lockRestaurant(tx, restaurantId);
    for (const each of switches) {
      await this.writeAvailability(
        tx,
        row.cityId,
        restaurantId,
        { type: 'item', id: each.itemId },
        false,
        each.until,
        change,
        now,
      );
    }
  }

  // RA §8.12 «تراجع — الصنف متوفر»: a withdrawn report's items switched on
  // again, in the order's transaction (after the order's lock). An item
  // deleted from the menu since is left alone.
  async switchOnItems(
    tx: Tx,
    restaurantId: string,
    itemIds: string[],
    change: MerchantChange,
    now: Date,
  ): Promise<void> {
    const row = await this.lockRestaurant(tx, restaurantId);
    for (const itemId of itemIds) {
      await this.writeAvailability(
        tx,
        row.cityId,
        restaurantId,
        { type: 'item', id: itemId },
        true,
        null,
        change,
        now,
      );
    }
  }

  // One row's switch with its audit; false when the row is not the
  // restaurant's (or deleted).
  private async writeAvailability(
    tx: Tx,
    cityId: string,
    restaurantId: string,
    target: { type: 'category' | 'item' | 'option'; id: string },
    available: boolean,
    until: Date | null,
    change: MerchantChange,
    now: Date,
  ): Promise<boolean> {
    const table = { category: categories, item: items, option: options }[target.type];
    const [found] =
      target.type === 'option'
        ? await tx
            .select({ id: options.id })
            .from(options)
            .innerJoin(optionGroups, eq(optionGroups.id, options.groupId))
            .where(
              and(
                eq(options.id, target.id),
                eq(optionGroups.restaurantId, restaurantId),
                isNull(options.deletedAt),
                isNull(optionGroups.deletedAt),
              ),
            )
        : await this.ownRow(
            tx,
            target.type === 'item' ? items : categories,
            restaurantId,
            target.id,
          );
    if (!found) return false;
    const [before] = await tx
      .select({ available: table.available, unavailableUntil: table.unavailableUntil })
      .from(table)
      .where(eq(table.id, target.id));
    await tx
      .update(table)
      .set({ available, unavailableUntil: available ? null : until, updatedAt: now })
      .where(eq(table.id, target.id));
    const after: SwitchedOff = available ? null : { until };
    await this.audit.recordWrite(
      {
        actor: change.actor,
        context: change.context,
        cityId,
        action: `menu.${target.type}.availability`,
        target: { type: `menu_${target.type}`, id: target.id },
        before: { switchedOff: before ? switchedOff(before, now) : null },
        after: { switchedOff: after },
        reason: change.reason ?? null,
      },
      tx,
    );
    return true;
  }

  // AP §9.6.3: the restaurant's logo or cover from an admin's upload,
  // published at once (an admin's edit needs no review, AP §9.6.7). The files
  // module copies and checks the file before the transaction (no storage call
  // under the restaurant's lock) and marks it linked in it. Setting the
  // same upload again changes nothing; another record's upload is refused.
  async setRestaurantImage(
    restaurantId: string,
    image: 'logo' | 'cover',
    uploadId: string,
    change: MerchantChange,
  ): Promise<string> {
    const purpose = image === 'logo' ? 'restaurant_logo' : 'restaurant_cover';
    await this.files.prepare(uploadId, purpose);
    return this.database.db.transaction(async (tx) => {
      const row = await this.lockRestaurant(tx, restaurantId);
      const column = image === 'logo' ? restaurants.logoKey : restaurants.coverKey;
      const [{ before }] = (await tx
        .select({ before: column })
        .from(restaurants)
        .where(eq(restaurants.id, restaurantId))) as [{ before: string | null }];
      const { key, alreadyLinked } = await this.files.link(tx, uploadId);
      if (alreadyLinked) {
        if (before === key) return key;
        throw new MerchantsRefusedError('upload_used', 'the upload is linked elsewhere');
      }
      await tx
        .update(restaurants)
        .set({ [image === 'logo' ? 'logoKey' : 'coverKey']: key, updatedAt: sql`now()` })
        .where(eq(restaurants.id, restaurantId));
      await this.audit.recordWrite(
        {
          actor: change.actor,
          context: change.context,
          cityId: row.cityId,
          action: `restaurant.${image}`,
          target: { type: 'restaurant', id: restaurantId },
          before: { key: before },
          after: { key },
          reason: null,
        },
        tx,
      );
      return key;
    });
  }

  // AP §9.6.6: an item's photo from an admin's upload, published at once.
  // As setRestaurantImage; the restaurant's lock orders it with the menu's
  // other changes.
  async setItemPhoto(
    restaurantId: string,
    itemId: string,
    uploadId: string,
    change: MerchantChange,
  ): Promise<string> {
    await this.files.prepare(uploadId, 'item_photo');
    return this.database.db.transaction(async (tx) => {
      const row = await this.lockRestaurant(tx, restaurantId);
      const [item] = await tx
        .select({ before: items.photoKey })
        .from(items)
        .where(
          and(eq(items.id, itemId), eq(items.restaurantId, restaurantId), isNull(items.deletedAt)),
        );
      if (!item) throw new MerchantsRefusedError('unknown_menu_row', 'no such item here');
      const { key, alreadyLinked } = await this.files.link(tx, uploadId);
      if (alreadyLinked) {
        if (item.before === key) return key;
        throw new MerchantsRefusedError('upload_used', 'the upload is linked elsewhere');
      }
      await tx
        .update(items)
        .set({ photoKey: key, updatedAt: sql`now()` })
        .where(eq(items.id, itemId));
      await this.audit.recordWrite(
        {
          actor: change.actor,
          context: change.context,
          cityId: row.cityId,
          action: 'menu.item.photo',
          target: { type: 'menu_item', id: itemId },
          before: { key: item.before },
          after: { key },
          reason: null,
        },
        tx,
      );
      return key;
    });
  }

  private ownRow(
    tx: Tx,
    table: typeof items | typeof categories,
    restaurantId: string,
    id: string,
  ) {
    return tx
      .select({ id: table.id })
      .from(table)
      .where(and(eq(table.id, id), eq(table.restaurantId, restaurantId), isNull(table.deletedAt)));
  }

  // Module-internal: the drafts service shares it (slice 2.30a).
  async lockRestaurant(tx: Tx, restaurantId: string) {
    const [row] = await tx
      .select({
        cityId: restaurants.cityId,
        accountStatus: restaurants.accountStatus,
        // The pin and the operations: a draft may still lack them.
        complete: sql<boolean>`${restaurants.location} IS NOT NULL AND ${restaurants.minimumOrder} IS NOT NULL`,
      })
      .from(restaurants)
      .where(eq(restaurants.id, restaurantId))
      .for('update');
    if (!row) throw new MerchantsRefusedError('unknown_restaurant', 'no such restaurant');
    return row;
  }

  // Module-internal: the drafts service shares it (slice 2.30a).
  async schedule(executor: Executor, restaurantId: string): Promise<OpeningPeriod[]> {
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

  // Module-internal: the drafts service shares it (slice 2.30a).
  async coveredZoneIds(executor: Executor, restaurantId: string): Promise<string[]> {
    const rows = await executor
      .select({ zoneId: coverageZones.zoneId })
      .from(coverageZones)
      .where(and(eq(coverageZones.restaurantId, restaurantId), isNull(coverageZones.removedAt)))
      .orderBy(asc(coverageZones.zoneId));
    return rows.map((row) => row.zoneId);
  }

  // Module-internal: the drafts service shares it (slice 2.30a).
  async checkCoverage(cityId: string, coverage: Coverage): Promise<void> {
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
  // Module-internal: the drafts service shares it (slice 2.30a).
  async checkBaseCurrency(tx: Tx, cityId: string, currency: string): Promise<void> {
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

// A row's switch at a moment: off «حتى الغد» is on again from its time.
export function switchedOff(
  row: { available: boolean; unavailableUntil: Date | null },
  now: Date,
): SwitchedOff {
  if (row.available) return null;
  if (row.unavailableUntil === null) return { until: null };
  return now.getTime() < row.unavailableUntil.getTime() ? { until: row.unavailableUntil } : null;
}

export function validPoint({ latitude, longitude }: Point): boolean {
  return (
    Number.isFinite(latitude) &&
    Number.isFinite(longitude) &&
    Math.abs(latitude) <= 90 &&
    Math.abs(longitude) <= 180
  );
}

export function hasReason(change: MerchantChange): boolean {
  return (change.reason ?? '').trim().length > 0;
}

export function checkCommission(rateBp: number): void {
  if (!Number.isInteger(rateBp) || rateBp < 0 || rateBp > 10_000) {
    throw new MerchantsRefusedError(
      'invalid_commission',
      'the commission is 0 to 100%, in basis points',
    );
  }
}

export function changedBy(actor: AuditActor): {
  changedByType: 'admin' | 'merchant' | 'system';
  changedById: string | null;
} {
  if (actor.type === 'admin' || actor.type === 'merchant' || actor.type === 'system') {
    return { changedByType: actor.type, changedById: actor.id };
  }
  throw new Error(`a ${actor.type} does not change a restaurant`);
}

// The audit log keeps JSON, which has no bigint: amounts become strings.
export function forAudit(value: object): Record<string, unknown> {
  return JSON.parse(
    JSON.stringify(value, (_key, inner: unknown) =>
      typeof inner === 'bigint' ? inner.toString() : inner,
    ),
  ) as Record<string, unknown>;
}
