import { Inject, Injectable } from '@nestjs/common';
import { and, eq, isNull, sql } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { AuditService } from '../audit/index.js';
import { activationChecklist, type Checklist, MENU_IMAGES_PCT } from './activation-checklist.js';
import {
  type Executor,
  type MerchantChange,
  MerchantsRefusedError,
  MerchantsService,
  switchedOff,
  type Tx,
} from './merchants.service.js';
import type { AccountStatus } from './operating-state.js';
import { categories, commissionRates, contracts, items, restaurants } from './schema.js';

// The checklist as the panel shows it (AP §9.6.3 step 8).
export interface RestaurantChecklist extends Checklist {
  accountStatus: AccountStatus;
  images: { withPhoto: number; total: number; requiredPct: number };
  imagesWaiver: { at: Date; by: string } | null;
}

// The wizard's step 8 (AP §9.6.3; slice 2.30b): the activation checklist,
// OWN's waiver of its image rule, «تشغيل الوضع التجريبي» (a draft to `test`)
// and «تفعيل وإظهار للزبائن» (`test` to `active`). Each command reads the
// checklist inside its transaction, under the restaurant's lock, so a menu
// edit cannot slip between the check and the change; the owner accounts and
// the delivered test orders come from identity and ordering, read through
// the pool (an owner removed at that moment is the one gap, harmless: the
// draft's accounts are added and removed only before test mode).
@Injectable()
export class ActivationService {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly merchants: MerchantsService,
    private readonly audit: AuditService,
  ) {}

  // The checklist of a restaurant in any status, or null.
  async checklist(restaurantId: string, now = new Date()): Promise<RestaurantChecklist | null> {
    const found = await this.merchants.cityAndStatus(restaurantId);
    if (found === null) return null;
    const [row] = await this.database.db
      .select({
        complete: sql<boolean>`${restaurants.location} IS NOT NULL AND ${restaurants.minimumOrder} IS NOT NULL`,
      })
      .from(restaurants)
      .where(eq(restaurants.id, restaurantId));
    return this.read(this.database.db, restaurantId, found.accountStatus, row!.complete, now);
  }

  // OWN waives the rule of images on 80% of the items, or takes the waiver
  // back, while the restaurant is onboarded (a draft or in test mode).
  // Setting the same value again writes nothing. Audited as
  // restaurant.menu_images_waiver.
  async setImagesWaiver(
    restaurantId: string,
    waived: boolean,
    change: MerchantChange,
  ): Promise<void> {
    await this.database.db.transaction(async (tx) => {
      const row = await this.merchants.lockRestaurant(tx, restaurantId);
      if (row.accountStatus !== 'draft' && row.accountStatus !== 'test') {
        throw new MerchantsRefusedError('menu_locked', 'the waiver belongs to the onboarding');
      }
      const [before] = await tx
        .select({ at: restaurants.menuImagesWaivedAt })
        .from(restaurants)
        .where(eq(restaurants.id, restaurantId));
      if ((before!.at !== null) === waived) return;
      await tx
        .update(restaurants)
        .set(
          waived
            ? { menuImagesWaivedAt: sql`now()`, menuImagesWaivedBy: change.actor.id! }
            : { menuImagesWaivedAt: null, menuImagesWaivedBy: null },
        )
        .where(eq(restaurants.id, restaurantId));
      await this.audit.recordWrite(
        {
          actor: change.actor,
          context: change.context,
          cityId: row.cityId,
          action: 'restaurant.menu_images_waiver',
          target: { type: 'restaurant', id: restaurantId },
          before: { waived: !waived },
          after: { waived },
          reason: change.reason ?? null,
        },
        tx,
      );
    });
  }

  // «تشغيل الوضع التجريبي»: a draft whose checklist is complete but for the
  // test order becomes `test`, seen only by admin test accounts (AP §9.6.1).
  // Already in test mode: nothing.
  async startTestMode(restaurantId: string, change: MerchantChange, now = new Date()) {
    await this.change(restaurantId, 'test', change, now);
  }

  // «تفعيل وإظهار للزبائن»: a restaurant in test mode whose checklist is
  // complete becomes `active`, seen by customers. Already active: nothing.
  async activate(restaurantId: string, change: MerchantChange, now = new Date()) {
    await this.change(restaurantId, 'active', change, now);
  }

  private async change(
    restaurantId: string,
    status: 'test' | 'active',
    change: MerchantChange,
    now: Date,
  ): Promise<void> {
    await this.database.db.transaction(async (tx) => {
      const row = await this.merchants.lockRestaurant(tx, restaurantId);
      if (row.accountStatus === status) return;
      const from = status === 'test' ? 'draft' : 'test';
      if (row.accountStatus !== from) {
        throw new MerchantsRefusedError(
          'status_change_not_allowed',
          `only a ${from} restaurant becomes ${status} here`,
        );
      }
      const checklist = await this.read(tx, restaurantId, row.accountStatus, row.complete, now);
      if (status === 'test' ? !checklist.canStartTest : !checklist.canActivate) {
        throw new MerchantsRefusedError(
          'checklist_incomplete',
          `missing: ${checklist.items
            .filter((item) => item.state === 'missing')
            .map((item) => item.code)
            .join(', ')}`,
        );
      }
      await this.merchants.writeAccountStatus(tx, restaurantId, row, status, change);
    });
  }

  private async read(
    executor: Executor | Tx,
    restaurantId: string,
    accountStatus: AccountStatus,
    record: boolean,
    now: Date,
  ): Promise<RestaurantChecklist> {
    const [waiver] = await executor
      .select({ at: restaurants.menuImagesWaivedAt, by: restaurants.menuImagesWaivedBy })
      .from(restaurants)
      .where(eq(restaurants.id, restaurantId));
    const [commission] = await executor
      .select({ count: sql<number>`count(*)::int` })
      .from(commissionRates)
      .where(
        and(eq(commissionRates.restaurantId, restaurantId), isNull(commissionRates.withdrawnAt)),
      );
    const [contract] = await executor
      .select({ confirmedAt: contracts.confirmedAt })
      .from(contracts)
      .where(eq(contracts.restaurantId, restaurantId));
    const periods = await this.merchants.schedule(executor, restaurantId);
    // The menu customers would see: published rows not deleted nor hidden.
    const visibleCategories = await executor
      .select({
        id: categories.id,
        available: categories.available,
        unavailableUntil: categories.unavailableUntil,
      })
      .from(categories)
      .where(
        and(
          eq(categories.restaurantId, restaurantId),
          eq(categories.published, true),
          eq(categories.hidden, false),
          isNull(categories.deletedAt),
        ),
      );
    const visibleItems = await executor
      .select({
        categoryId: items.categoryId,
        photoKey: items.photoKey,
        available: items.available,
        unavailableUntil: items.unavailableUntil,
      })
      .from(items)
      .where(
        and(
          eq(items.restaurantId, restaurantId),
          eq(items.published, true),
          eq(items.hidden, false),
          isNull(items.deletedAt),
        ),
      );
    const shown = new Map(visibleCategories.map((category) => [category.id, category]));
    const menuItems = visibleItems.filter((item) => shown.has(item.categoryId));
    const categoriesWithAvailableItems = visibleCategories.filter(
      (category) =>
        switchedOff(category, now) === null &&
        menuItems.some(
          (item) => item.categoryId === category.id && switchedOff(item, now) === null,
        ),
    ).length;
    const withPhoto = menuItems.filter((item) => item.photoKey !== null).length;
    const [ownerAccounts, deliveredTestOrders] = await Promise.all([
      this.merchants.ownerAccountCount(restaurantId),
      this.merchants.deliveredTestOrderCount(restaurantId),
    ]);
    const checklist = activationChecklist({
      record,
      commission: (commission?.count ?? 0) > 0,
      contract: contract?.confirmedAt != null,
      hours: periods.length > 0,
      categoriesWithAvailableItems,
      items: menuItems.length,
      itemsWithPhoto: withPhoto,
      imagesWaived: waiver?.at != null,
      ownerAccounts,
      deliveredTestOrders,
    });
    return {
      ...checklist,
      accountStatus,
      images: { withPhoto, total: menuItems.length, requiredPct: MENU_IMAGES_PCT },
      imagesWaiver:
        waiver?.at != null && waiver.by !== null ? { at: waiver.at, by: waiver.by } : null,
    };
  }
}
