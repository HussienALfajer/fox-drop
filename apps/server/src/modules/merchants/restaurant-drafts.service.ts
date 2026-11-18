import { Inject, Injectable } from '@nestjs/common';
import { and, asc, desc, eq, inArray, isNull, sql } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { AuditService } from '../audit/index.js';
import { FilesService } from '../files/index.js';
import { commissionAt } from './commission.js';
import { checkWeeklySchedule, GeoService, type OpeningPeriod, type Point } from '../geo/index.js';
import { SettingsService } from '../settings/index.js';
import {
  changedBy,
  checkCommission,
  type Coverage,
  type Executor,
  forAudit,
  type MerchantChange,
  MerchantsRefusedError,
  MerchantsService,
  type Money,
  type Tx,
  validPoint,
} from './merchants.service.js';
import {
  commissionRates,
  contracts,
  coverageZones,
  openingPeriods,
  restaurants,
  weeklySchedules,
} from './schema.js';

// The texts' bounds (decided by us, slice 2.30a).
export const DRAFT_NAME_MAX = 80;
export const DRAFT_DESCRIPTION_MAX = 300;
export const DRAFT_ADDRESS_MAX = 200;

// A number in E.164: the restaurant's own may be a landline, so any country.
const E164 = /^\+[1-9]\d{7,14}$/;

// AP §9.6.3 step 1.
export interface DraftBasics {
  nameAr: string;
  nameEn: string | null;
  categoryIds: string[];
  description: string | null;
}

// AP §9.6.3 step 2: the pin, the address, the restaurant's number and the
// owner's name as a contact. The owner's number is the owner account of
// step 6 (identity keeps it encrypted), never a plain copy here.
export interface DraftLocation {
  location: Point;
  address: string | null;
  phone: string | null;
  ownerName: string | null;
}

// AP §9.6.3 step 3: the hours (several periods a day; a day without any is
// a day off), the default prep time, the minimum order and the coverage.
export interface DraftOperations {
  periods: OpeningPeriod[];
  defaultPrepMin: number;
  minimumOrder: Money;
  coverage: Coverage;
}

// Which steps of AP §9.6.3 hold what they need (steps 4 to 6 join with
// their own parts).
export interface DraftSteps {
  basics: boolean;
  location: boolean;
  operations: boolean;
  commission: boolean;
  contract: boolean;
}

// AP §9.6.3 step 4, D16 (OWN alone): the standard commission, and an
// optional launch rate in force until a date, after which the standard one
// applies by itself. Basis points of the items value.
export interface DraftCommission {
  rateBp: number;
  launch: { rateBp: number; until: Date } | null;
}

// AP §9.6.3 step 5: the signing date (YYYY-MM-DD), the duration in months
// and the scans (keys in private-docs), and who confirmed it with the
// price-parity pledge.
export interface DraftContract {
  signedOn: string | null;
  durationMonths: number | null;
  contractKey: string | null;
  licenceKey: string | null;
  confirmedAt: Date | null;
  confirmedBy: string | null;
}

// What DATA saves at step 5: an upload id replaces a scan, null keeps it.
export interface ContractFields {
  signedOn: string;
  durationMonths: number;
  contractUploadId: string | null;
  licenceUploadId: string | null;
}

// The wizard's read of a restaurant: every field it saved so far.
export interface RestaurantDraft {
  id: string;
  cityId: string;
  accountStatus: string;
  basics: DraftBasics & { logoKey: string | null; coverKey: string | null };
  location: {
    location: Point | null;
    address: string | null;
    phone: string | null;
    ownerName: string | null;
  };
  operations: {
    periods: OpeningPeriod[];
    defaultPrepMin: number | null;
    minimumOrder: Money | null;
    coverage: Coverage | null;
  };
  commission: DraftCommission | null;
  contract: DraftContract | null;
  steps: DraftSteps;
  createdAt: Date;
  updatedAt: Date;
}

export interface DraftSummary {
  id: string;
  nameAr: string;
  steps: DraftSteps;
  createdAt: Date;
  updatedAt: Date;
}

// The onboarding wizard «إضافة مطعم» (AP §9.6.3; slice 2.30a): a restaurant
// in `draft` saved at every step. The panel names the draft's id, so saving
// step 1 again (a retry included) sets the same values instead of making a
// second draft. Each step writes in one transaction under the restaurant's
// lock and is audited; only a draft is changed here.
@Injectable()
export class RestaurantDraftsService {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly merchants: MerchantsService,
    private readonly geo: GeoService,
    private readonly settings: SettingsService,
    private readonly audit: AuditService,
    private readonly files: FilesService,
  ) {}

  // Step 4 (OWN): the commission of the new restaurant. Every version not
  // yet in force is withdrawn, then the rate (or the launch rate) starts now
  // and, with a launch rate, the standard rate from its end; so saving the
  // step again replaces the plan. No reason: it is the first commission, not
  // a change (AP §9.6.5).
  async saveCommission(
    restaurantId: string,
    commission: DraftCommission,
    change: MerchantChange,
    now = new Date(),
  ): Promise<void> {
    checkCommission(commission.rateBp);
    if (commission.launch !== null) {
      checkCommission(commission.launch.rateBp);
      if (commission.launch.until.getTime() <= now.getTime()) {
        throw new MerchantsRefusedError(
          'invalid_commission',
          'the launch commission ends after now',
        );
      }
    }
    await this.database.db.transaction(async (tx) => {
      const row = await this.lockDraft(tx, restaurantId);
      const before = await this.commissionOf(tx, restaurantId);
      if (JSON.stringify(before) === JSON.stringify(commission)) return;
      await tx
        .update(commissionRates)
        .set({ withdrawnAt: sql`now()` })
        .where(
          and(
            eq(commissionRates.restaurantId, restaurantId),
            isNull(commissionRates.withdrawnAt),
            sql`${commissionRates.effectiveFrom} > now()`,
          ),
        );
      const by = changedBy(change.actor);
      await tx.insert(commissionRates).values({
        restaurantId,
        rateBp: commission.launch?.rateBp ?? commission.rateBp,
        effectiveFrom: sql`now()`,
        ...by,
      });
      if (commission.launch !== null) {
        await tx.insert(commissionRates).values({
          restaurantId,
          rateBp: commission.rateBp,
          effectiveFrom: commission.launch.until,
          ...by,
        });
      }
      const audited = (value: DraftCommission | null) =>
        value === null
          ? null
          : {
              rateBp: value.rateBp,
              launch:
                value.launch === null
                  ? null
                  : { rateBp: value.launch.rateBp, until: value.launch.until.toISOString() },
            };
      await this.record(
        tx,
        change,
        row.cityId,
        restaurantId,
        'restaurant.commission',
        audited(before),
        audited(commission)!,
      );
    });
  }

  // Step 5 (DATA, OPS, OWN): the dates and the scans. Another value clears
  // the confirmation, which then confirms what is there now.
  async saveContract(
    restaurantId: string,
    fields: ContractFields,
    change: MerchantChange,
    now = new Date(),
  ): Promise<void> {
    if (!/^\d{4}-\d{2}-\d{2}$/.test(fields.signedOn) || Number.isNaN(Date.parse(fields.signedOn))) {
      throw new MerchantsRefusedError('invalid_contract', 'the signing date is YYYY-MM-DD');
    }
    if (
      !Number.isInteger(fields.durationMonths) ||
      fields.durationMonths < 1 ||
      fields.durationMonths > 120
    ) {
      throw new MerchantsRefusedError('invalid_contract', 'the duration is 1 to 120 months');
    }
    // Before the transaction: it calls the storage (the files module's rule).
    if (fields.contractUploadId !== null) {
      await this.files.prepare(fields.contractUploadId, 'restaurant_contract', now);
    }
    if (fields.licenceUploadId !== null) {
      await this.files.prepare(fields.licenceUploadId, 'restaurant_licence', now);
    }
    await this.database.db.transaction(async (tx) => {
      const row = await this.lockDraft(tx, restaurantId);
      const before = await this.contractOf(tx, restaurantId);
      const linked = async (uploadId: string | null, kept: string | null) => {
        if (uploadId === null) return kept;
        const { key, alreadyLinked } = await this.files.link(tx, uploadId, now);
        if (alreadyLinked && key !== kept) {
          throw new MerchantsRefusedError('upload_used', 'the upload is linked elsewhere');
        }
        return key;
      };
      const after = {
        signedOn: fields.signedOn,
        durationMonths: fields.durationMonths,
        contractKey: await linked(fields.contractUploadId, before?.contractKey ?? null),
        licenceKey: await linked(fields.licenceUploadId, before?.licenceKey ?? null),
      };
      const same =
        before !== null &&
        before.signedOn === after.signedOn &&
        before.durationMonths === after.durationMonths &&
        before.contractKey === after.contractKey &&
        before.licenceKey === after.licenceKey;
      if (same) return;
      const values = {
        ...after,
        confirmedAt: null,
        confirmedBy: null,
        updatedBy: change.actor.id!,
        updatedAt: sql`now()`,
      };
      await tx
        .insert(contracts)
        .values({ restaurantId, ...values })
        .onConflictDoUpdate({ target: contracts.restaurantId, set: values });
      await this.record(
        tx,
        change,
        row.cityId,
        restaurantId,
        'restaurant.contract',
        before === null
          ? null
          : {
              signedOn: before.signedOn,
              durationMonths: before.durationMonths,
              contractKey: before.contractKey,
              licenceKey: before.licenceKey,
            },
        after,
      );
    });
  }

  // Step 5 (OWN, OPS): confirms the contract as saved with the price-parity
  // pledge. It needs the signing date, the duration and the contract's scan
  // (the licence's is optional, decided by us); confirming again changes
  // nothing.
  async confirmContract(restaurantId: string, change: MerchantChange): Promise<void> {
    await this.database.db.transaction(async (tx) => {
      const row = await this.lockDraft(tx, restaurantId);
      const contract = await this.contractOf(tx, restaurantId);
      if (
        contract === null ||
        contract.signedOn === null ||
        contract.durationMonths === null ||
        contract.contractKey === null
      ) {
        throw new MerchantsRefusedError(
          'invalid_contract',
          'the contract needs its date, duration and scan first',
        );
      }
      if (contract.confirmedAt !== null) return;
      await tx
        .update(contracts)
        .set({ confirmedAt: sql`now()`, confirmedBy: change.actor.id! })
        .where(eq(contracts.restaurantId, restaurantId));
      await this.record(tx, change, row.cityId, restaurantId, 'restaurant.contract.confirm', null, {
        parityPledge: true,
      });
    });
  }

  // The standard rate and the launch rate, as step 4 shows them: the rate
  // in force, and when a later version is planned, the one in force is the
  // launch rate until that version's start.
  private async commissionOf(
    executor: Executor,
    restaurantId: string,
    now = new Date(),
  ): Promise<DraftCommission | null> {
    const versions = await executor
      .select({
        id: commissionRates.id,
        rateBp: commissionRates.rateBp,
        effectiveFrom: commissionRates.effectiveFrom,
      })
      .from(commissionRates)
      .where(
        and(eq(commissionRates.restaurantId, restaurantId), isNull(commissionRates.withdrawnAt)),
      );
    const current = commissionAt(versions, now);
    const ahead = versions
      .filter((version) => version.effectiveFrom.getTime() > now.getTime())
      .sort((a, b) => a.effectiveFrom.getTime() - b.effectiveFrom.getTime());
    const next = ahead[0] && commissionAt(ahead, ahead[0].effectiveFrom);
    if (current === null) return next ? { rateBp: next.rateBp, launch: null } : null;
    if (!next) return { rateBp: current.rateBp, launch: null };
    return {
      rateBp: next.rateBp,
      launch: { rateBp: current.rateBp, until: next.effectiveFrom },
    };
  }

  private async contractOf(
    executor: Executor,
    restaurantId: string,
  ): Promise<DraftContract | null> {
    const [row] = await executor
      .select({
        signedOn: contracts.signedOn,
        durationMonths: contracts.durationMonths,
        contractKey: contracts.contractKey,
        licenceKey: contracts.licenceKey,
        confirmedAt: contracts.confirmedAt,
        confirmedBy: contracts.confirmedBy,
      })
      .from(contracts)
      .where(eq(contracts.restaurantId, restaurantId));
    return row ?? null;
  }

  // Step 1: starts the draft with this id in the city, or saves its basics.
  async saveBasics(
    restaurantId: string,
    cityId: string,
    basics: DraftBasics,
    change: MerchantChange,
  ): Promise<void> {
    const checked = checkBasics(basics);
    if ((await this.geo.cityTimeZone(cityId)) === null) {
      throw new MerchantsRefusedError('unknown_city', 'no such city');
    }
    await this.merchants.checkCategories(checked.categoryIds);
    await this.database.db.transaction(async (tx) => {
      const [created] = await tx
        .insert(restaurants)
        .values({ id: restaurantId, cityId, ...checked })
        .onConflictDoNothing({ target: restaurants.id })
        .returning({ id: restaurants.id });
      if (created) {
        await this.record(tx, change, cityId, restaurantId, 'restaurant.create', null, {
          ...checked,
        });
        return;
      }
      const row = await this.lockDraft(tx, restaurantId);
      if (row.cityId !== cityId) {
        throw new MerchantsRefusedError('not_a_draft', 'the draft belongs to another city');
      }
      const before = {
        nameAr: row.nameAr,
        nameEn: row.nameEn,
        categoryIds: row.categoryIds,
        description: row.description,
      };
      if (JSON.stringify(before) === JSON.stringify(checked)) return;
      await tx
        .update(restaurants)
        .set({ ...checked, updatedAt: sql`now()` })
        .where(eq(restaurants.id, restaurantId));
      await this.record(tx, change, cityId, restaurantId, 'restaurant.basics', before, {
        ...checked,
      });
    });
  }

  // Step 2: the pin with the address and the contacts.
  async saveLocation(
    restaurantId: string,
    location: DraftLocation,
    change: MerchantChange,
  ): Promise<void> {
    if (!validPoint(location.location)) {
      throw new MerchantsRefusedError('invalid_restaurant', 'the pin is not on the map');
    }
    const address = optionalText(location.address, DRAFT_ADDRESS_MAX, 'the address');
    const ownerName = optionalText(location.ownerName, DRAFT_NAME_MAX, "the owner's name");
    if (location.phone !== null && !E164.test(location.phone)) {
      throw new MerchantsRefusedError('invalid_restaurant', 'the number is in E.164');
    }
    const after = {
      latitude: location.location.latitude,
      longitude: location.location.longitude,
      address,
      phone: location.phone,
      ownerName,
    };
    await this.database.db.transaction(async (tx) => {
      const row = await this.lockDraft(tx, restaurantId);
      const before = {
        latitude: row.latitude,
        longitude: row.longitude,
        address: row.address,
        phone: row.phone,
        ownerName: row.ownerName,
      };
      if (JSON.stringify(before) === JSON.stringify(after)) return;
      await tx
        .update(restaurants)
        .set({
          location: sql`ST_SetSRID(ST_MakePoint(${after.longitude}, ${after.latitude}), 4326)`,
          address,
          phone: location.phone,
          ownerName,
          updatedAt: sql`now()`,
        })
        .where(eq(restaurants.id, restaurantId));
      // The numbers stay out of the audit log, which keeps no phone.
      const audited = (value: typeof after) => ({
        latitude: value.latitude,
        longitude: value.longitude,
        address: value.address,
        ownerName: value.ownerName,
      });
      await this.record(
        tx,
        change,
        row.cityId,
        restaurantId,
        'restaurant.location',
        row.latitude === null ? null : audited(before as typeof after),
        audited(after),
      );
    });
  }

  // Step 3: the hours, the default prep time, the minimum order and the
  // coverage, together.
  async saveOperations(
    restaurantId: string,
    operations: DraftOperations,
    change: MerchantChange,
  ): Promise<void> {
    if (operations.periods.length === 0) {
      throw new MerchantsRefusedError('invalid_schedule', 'the hours need one opening period');
    }
    const problem = checkWeeklySchedule(operations.periods);
    if (problem !== null) throw new MerchantsRefusedError('invalid_schedule', problem);
    if (operations.minimumOrder.amount < 0n) {
      throw new MerchantsRefusedError('invalid_restaurant', 'the minimum order is 0 or more');
    }
    const cityId = await this.cityOf(restaurantId);
    // RA §10: within the prep-time chooser's limits.
    const [floor, ceiling] = await Promise.all([
      this.settings.get('merchant.prep_time_floor_min', { cityId }),
      this.settings.get('merchant.prep_time_ceiling_min', { cityId }),
    ]);
    if (
      !Number.isInteger(operations.defaultPrepMin) ||
      operations.defaultPrepMin < floor ||
      operations.defaultPrepMin > ceiling
    ) {
      throw new MerchantsRefusedError(
        'invalid_prep_time',
        `the prep time is whole minutes from ${floor} to ${ceiling}`,
      );
    }
    await this.merchants.checkCoverage(cityId, operations.coverage);
    const periods = [...operations.periods].sort(
      (a, b) => a.weekday - b.weekday || a.opensAt - b.opensAt,
    );
    const coverage: Coverage =
      operations.coverage.kind === 'zones'
        ? { kind: 'zones', zoneIds: [...operations.coverage.zoneIds].sort() }
        : operations.coverage;
    await this.database.db.transaction(async (tx) => {
      const row = await this.lockDraft(tx, restaurantId);
      await this.merchants.checkBaseCurrency(tx, row.cityId, operations.minimumOrder.currency);
      const before = await this.operationsOf(tx, row);
      const after = {
        periods,
        defaultPrepMin: operations.defaultPrepMin,
        minimumOrder: operations.minimumOrder,
        coverage,
      };
      const sameHours = JSON.stringify(before.periods) === JSON.stringify(periods);
      if (
        sameHours &&
        before.defaultPrepMin === after.defaultPrepMin &&
        before.minimumOrder?.amount === after.minimumOrder.amount &&
        before.minimumOrder.currency === after.minimumOrder.currency &&
        JSON.stringify(before.coverage) === JSON.stringify(coverage)
      ) {
        return;
      }
      await tx
        .update(restaurants)
        .set({
          coverageKind: coverage.kind,
          coverageRadiusMetres: coverage.kind === 'radius' ? coverage.radiusMetres : null,
          minimumOrder: after.minimumOrder.amount,
          minimumOrderCurrency: after.minimumOrder.currency,
          defaultPrepMin: after.defaultPrepMin,
          updatedAt: sql`now()`,
        })
        .where(eq(restaurants.id, restaurantId));
      await tx
        .update(coverageZones)
        .set({ removedAt: sql`now()` })
        .where(and(eq(coverageZones.restaurantId, restaurantId), isNull(coverageZones.removedAt)));
      if (coverage.kind === 'zones') {
        await tx
          .insert(coverageZones)
          .values(coverage.zoneIds.map((zoneId) => ({ restaurantId, zoneId })))
          .onConflictDoUpdate({
            target: [coverageZones.restaurantId, coverageZones.zoneId],
            set: { removedAt: null },
          });
      }
      if (!sameHours) {
        const [{ id }] = (await tx
          .insert(weeklySchedules)
          .values({ restaurantId, ...changedBy(change.actor) })
          .returning({ id: weeklySchedules.id })) as [{ id: string }];
        await tx
          .insert(openingPeriods)
          .values(periods.map((period) => ({ scheduleId: id, ...period })));
      }
      await this.record(
        tx,
        change,
        row.cityId,
        restaurantId,
        'restaurant.operations',
        before.minimumOrder === null ? null : forAudit(before),
        forAudit(after),
      );
    });
  }

  // The wizard's read of one restaurant (any status), or null.
  async draft(restaurantId: string): Promise<RestaurantDraft | null> {
    const [row] = await this.rows(this.database.db, eq(restaurants.id, restaurantId));
    if (!row) return null;
    const operations = await this.operationsOf(this.database.db, row);
    const commission = await this.commissionOf(this.database.db, restaurantId);
    const contract = await this.contractOf(this.database.db, restaurantId);
    return {
      id: row.id,
      cityId: row.cityId,
      accountStatus: row.accountStatus,
      basics: {
        nameAr: row.nameAr,
        nameEn: row.nameEn,
        categoryIds: row.categoryIds,
        description: row.description,
        logoKey: row.logoKey,
        coverKey: row.coverKey,
      },
      location: {
        location:
          row.latitude === null || row.longitude === null
            ? null
            : { latitude: row.latitude, longitude: row.longitude },
        address: row.address,
        phone: row.phone,
        ownerName: row.ownerName,
      },
      operations,
      commission,
      contract,
      steps: {
        ...stepsOf(row, operations.periods),
        commission: commission !== null,
        contract: contract?.confirmedAt != null,
      },
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    };
  }

  // The city's drafts, the latest saved first: the wizard resumes from them.
  async drafts(cityId: string): Promise<DraftSummary[]> {
    const rows = await this.rows(
      this.database.db,
      and(eq(restaurants.cityId, cityId), eq(restaurants.accountStatus, 'draft'))!,
    );
    const ids = rows.map((row) => row.id);
    const periods = await this.periodCounts(ids);
    const withCommission = new Set(
      ids.length === 0
        ? []
        : (
            await this.database.db
              .selectDistinct({ id: commissionRates.restaurantId })
              .from(commissionRates)
              .where(
                and(
                  inArray(commissionRates.restaurantId, ids),
                  isNull(commissionRates.withdrawnAt),
                ),
              )
          ).map((row) => row.id),
    );
    const confirmed = new Set(
      ids.length === 0
        ? []
        : (
            await this.database.db
              .select({ id: contracts.restaurantId })
              .from(contracts)
              .where(
                and(
                  inArray(contracts.restaurantId, ids),
                  sql`${contracts.confirmedAt} IS NOT NULL`,
                ),
              )
          ).map((row) => row.id),
    );
    return rows
      .map((row) => ({
        id: row.id,
        nameAr: row.nameAr,
        steps: {
          basics: true,
          location: row.latitude !== null,
          operations: row.minimumOrder !== null && (periods.get(row.id) ?? 0) > 0,
          commission: withCommission.has(row.id),
          contract: confirmed.has(row.id),
        },
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
      }))
      .sort((a, b) => b.updatedAt.getTime() - a.updatedAt.getTime());
  }

  private rows(executor: Executor, where: ReturnType<typeof eq>) {
    return executor
      .select({
        id: restaurants.id,
        cityId: restaurants.cityId,
        accountStatus: restaurants.accountStatus,
        nameAr: restaurants.nameAr,
        nameEn: restaurants.nameEn,
        categoryIds: restaurants.categoryIds,
        description: restaurants.description,
        logoKey: restaurants.logoKey,
        coverKey: restaurants.coverKey,
        latitude: sql<number | null>`ST_Y(${restaurants.location})`,
        longitude: sql<number | null>`ST_X(${restaurants.location})`,
        address: restaurants.address,
        phone: restaurants.phone,
        ownerName: restaurants.ownerName,
        coverageKind: restaurants.coverageKind,
        coverageRadiusMetres: restaurants.coverageRadiusMetres,
        minimumOrder: restaurants.minimumOrder,
        minimumOrderCurrency: restaurants.minimumOrderCurrency,
        defaultPrepMin: restaurants.defaultPrepMin,
        createdAt: restaurants.createdAt,
        updatedAt: restaurants.updatedAt,
      })
      .from(restaurants)
      .where(where);
  }

  // How many periods each restaurant's schedule in force has.
  private async periodCounts(ids: string[]): Promise<Map<string, number>> {
    if (ids.length === 0) return new Map();
    const rows = await this.database.db
      .selectDistinctOn([weeklySchedules.restaurantId], {
        restaurantId: weeklySchedules.restaurantId,
        periods: sql<number>`(SELECT count(*)::int FROM ${openingPeriods} WHERE ${openingPeriods.scheduleId} = ${weeklySchedules.id})`,
      })
      .from(weeklySchedules)
      .where(inArray(weeklySchedules.restaurantId, ids))
      .orderBy(asc(weeklySchedules.restaurantId), desc(weeklySchedules.id));
    return new Map(rows.map((row) => [row.restaurantId, row.periods]));
  }

  private async operationsOf(
    executor: Executor,
    row: {
      id: string;
      coverageKind: 'radius' | 'zones' | null;
      coverageRadiusMetres: number | null;
      minimumOrder: bigint | null;
      minimumOrderCurrency: string | null;
      defaultPrepMin: number | null;
    },
  ): Promise<RestaurantDraft['operations']> {
    const coverage: Coverage | null =
      row.coverageKind === 'radius'
        ? { kind: 'radius', radiusMetres: row.coverageRadiusMetres! }
        : row.coverageKind === 'zones'
          ? { kind: 'zones', zoneIds: await this.merchants.coveredZoneIds(executor, row.id) }
          : null;
    return {
      periods: await this.merchants.schedule(executor, row.id),
      defaultPrepMin: row.defaultPrepMin,
      minimumOrder:
        row.minimumOrder === null || row.minimumOrderCurrency === null
          ? null
          : { amount: row.minimumOrder, currency: row.minimumOrderCurrency },
      coverage,
    };
  }

  private async cityOf(restaurantId: string): Promise<string> {
    const [row] = await this.database.db
      .select({ cityId: restaurants.cityId })
      .from(restaurants)
      .where(eq(restaurants.id, restaurantId));
    if (!row) throw new MerchantsRefusedError('unknown_restaurant', 'no such restaurant');
    return row.cityId;
  }

  // The draft under its row lock; any other status is 409 not_a_draft.
  private async lockDraft(tx: Tx, restaurantId: string) {
    const [row] = await this.rows(tx, eq(restaurants.id, restaurantId)).for('update');
    if (!row) throw new MerchantsRefusedError('unknown_restaurant', 'no such restaurant');
    if (row.accountStatus !== 'draft') {
      throw new MerchantsRefusedError('not_a_draft', 'only a draft is saved by the wizard');
    }
    return row;
  }

  private async record(
    tx: Tx,
    change: MerchantChange,
    cityId: string,
    restaurantId: string,
    action: string,
    before: Record<string, unknown> | null,
    after: Record<string, unknown>,
  ): Promise<void> {
    await this.audit.recordWrite(
      {
        actor: change.actor,
        context: change.context,
        cityId,
        action,
        target: { type: 'restaurant', id: restaurantId },
        before,
        after,
        reason: change.reason ?? null,
      },
      tx,
    );
  }
}

function stepsOf(
  row: { latitude: number | null; minimumOrder: bigint | null },
  periods: OpeningPeriod[],
): Pick<DraftSteps, 'basics' | 'location' | 'operations'> {
  return {
    basics: true,
    location: row.latitude !== null,
    operations: row.minimumOrder !== null && periods.length > 0,
  };
}

function checkBasics(basics: DraftBasics): DraftBasics {
  const nameAr = basics.nameAr.trim();
  if (nameAr.length === 0 || nameAr.length > DRAFT_NAME_MAX) {
    throw new MerchantsRefusedError(
      'invalid_restaurant',
      `the Arabic name is 1 to ${DRAFT_NAME_MAX} characters`,
    );
  }
  if (new Set(basics.categoryIds).size !== basics.categoryIds.length) {
    throw new MerchantsRefusedError('unknown_category', 'a category is named twice');
  }
  return {
    nameAr,
    nameEn: optionalText(basics.nameEn, DRAFT_NAME_MAX, 'the English name'),
    categoryIds: basics.categoryIds,
    description: optionalText(basics.description, DRAFT_DESCRIPTION_MAX, 'the description'),
  };
}

// A text trimmed, null when empty, refused above its bound.
function optionalText(value: string | null, max: number, what: string): string | null {
  const text = value?.trim() ?? '';
  if (text.length > max) {
    throw new MerchantsRefusedError('invalid_restaurant', `${what} is at most ${max} characters`);
  }
  return text.length === 0 ? null : text;
}
