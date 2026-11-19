import { Inject, Injectable } from '@nestjs/common';
import { and, eq, isNull, sql } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { AuditService } from '../audit/index.js';
import { SettingsService } from '../settings/index.js';
import type { BulkPriceChange } from './bulk-price.js';
import { type BulkScope, MenuBulkService } from './menu-bulk.service.js';
import { checkWindow, type MenuChange, MenuEditorService } from './menu-editor.service.js';
import {
  forAudit,
  type MerchantChange,
  MerchantsRefusedError,
  MerchantsService,
  type Money,
  type Tx,
} from './merchants.service.js';
import { categories, items, optionGroups, options } from './schema.js';

// The owners' menu commands in the restaurant app (RA §9.2 «Immediately»,
// §9.4, §18; slice 2.32a): a price, an option's delta, hiding, the order and
// a category's window publish at once, under the restaurant's lock, audited
// with the user and the device, and tell every device of the restaurant
// (`menu_changed`). Prices go through 2.31's price log; a price moved by more
// than merchant.price_change_alert_pct raises «تغيير أسعار كبير» (AP §9.1.3).
// What needs review (names, new rows, photos, groups) is 2.32b's.
@Injectable()
export class RestaurantMenuService {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly merchants: MerchantsService,
    private readonly editor: MenuEditorService,
    private readonly bulk: MenuBulkService,
    private readonly audit: AuditService,
    private readonly settings: SettingsService,
  ) {}

  // RA §9.4: an item's price, above 0 in the base. The same price again
  // writes nothing. Audited as menu.item.update.
  async setItemPrice(
    restaurantId: string,
    itemId: string,
    price: Money,
    change: MerchantChange,
  ): Promise<void> {
    if (price.amount <= 0n) {
      throw new MerchantsRefusedError('invalid_menu', 'an item price is above 0');
    }
    const menuChange = await this.ownersChange(restaurantId, change);
    await this.database.db.transaction(async (tx) => {
      const row = await this.editor.lockEditable(tx, restaurantId);
      await this.merchants.checkBaseCurrency(tx, row.cityId, price.currency);
      const [before] = await tx
        .select({ name: items.name, price: items.price, currency: items.currency })
        .from(items)
        .where(and(eq(items.id, itemId), ...this.live(items, restaurantId)));
      if (!before) throw new MerchantsRefusedError('unknown_menu_row', 'no such item here');
      if (before.price === price.amount && before.currency === price.currency) return;
      await tx
        .update(items)
        .set({ price: price.amount, currency: price.currency, updatedAt: sql`now()` })
        .where(eq(items.id, itemId));
      await this.record(tx, change, row.cityId, 'menu.item.update', 'menu_item', itemId, {
        before: { price: before.price, currency: before.currency },
        after: { price: price.amount, currency: price.currency },
      });
      await this.editor.logPrices(
        tx,
        restaurantId,
        row,
        [
          {
            target: { type: 'item', id: itemId },
            name: before.name,
            old: { amount: before.price, currency: before.currency },
            new: price,
          },
        ],
        menuChange,
      );
    });
  }

  // RA §9.4: an option's price delta, 0 or more in the base. Audited as
  // menu.option.update.
  async setOptionDelta(
    restaurantId: string,
    optionId: string,
    delta: Money,
    change: MerchantChange,
  ): Promise<void> {
    if (delta.amount < 0n) {
      throw new MerchantsRefusedError('invalid_menu', 'a price delta is 0 or more');
    }
    const menuChange = await this.ownersChange(restaurantId, change);
    await this.database.db.transaction(async (tx) => {
      const row = await this.editor.lockEditable(tx, restaurantId);
      await this.merchants.checkBaseCurrency(tx, row.cityId, delta.currency);
      const [before] = await tx
        .select({ name: options.name, delta: options.priceDelta, currency: options.currency })
        .from(options)
        .innerJoin(optionGroups, eq(optionGroups.id, options.groupId))
        .where(
          and(
            eq(options.id, optionId),
            eq(optionGroups.restaurantId, restaurantId),
            eq(options.published, true),
            isNull(options.deletedAt),
            isNull(optionGroups.deletedAt),
          ),
        );
      if (!before) throw new MerchantsRefusedError('unknown_menu_row', 'no such option here');
      if (before.delta === delta.amount && before.currency === delta.currency) return;
      await tx
        .update(options)
        .set({ priceDelta: delta.amount, currency: delta.currency, updatedAt: sql`now()` })
        .where(eq(options.id, optionId));
      await this.record(tx, change, row.cityId, 'menu.option.update', 'menu_option', optionId, {
        before: { priceDelta: before.delta, currency: before.currency },
        after: { priceDelta: delta.amount, currency: delta.currency },
      });
      await this.editor.logPrices(
        tx,
        restaurantId,
        row,
        [
          {
            target: { type: 'option', id: optionId },
            name: before.name,
            old: { amount: before.delta, currency: before.currency },
            new: delta,
          },
        ],
        menuChange,
      );
    });
  }

  // RA §9.2: hide or show a category or an item. Audited as
  // menu.category.update or menu.item.update.
  async setHidden(
    restaurantId: string,
    target: { type: 'category' | 'item'; id: string },
    hidden: boolean,
    change: MerchantChange,
  ): Promise<void> {
    const table = target.type === 'category' ? categories : items;
    await this.database.db.transaction(async (tx) => {
      const row = await this.editor.lockEditable(tx, restaurantId);
      const [before] = await tx
        .select({ hidden: table.hidden })
        .from(table)
        .where(and(eq(table.id, target.id), ...this.live(table, restaurantId)));
      if (!before) throw new MerchantsRefusedError('unknown_menu_row', `no such ${target.type}`);
      if (before.hidden === hidden) return;
      await tx
        .update(table)
        .set({ hidden, updatedAt: sql`now()` })
        .where(eq(table.id, target.id));
      await this.record(
        tx,
        change,
        row.cityId,
        `menu.${target.type}.update`,
        target.type === 'category' ? 'menu_category' : 'menu_item',
        target.id,
        { before: { hidden: before.hidden }, after: { hidden } },
      );
      await this.editor.menuChanged(tx, restaurantId, row.cityId);
    });
  }

  // RA §9.1, §9.2: a category's daily window (minutes on the city's clock),
  // or null for all day. Audited as menu.category.update.
  async setCategoryWindow(
    restaurantId: string,
    categoryId: string,
    window: { startsAt: number; endsAt: number } | null,
    change: MerchantChange,
  ): Promise<void> {
    checkWindow(window);
    await this.database.db.transaction(async (tx) => {
      const row = await this.editor.lockEditable(tx, restaurantId);
      const [before] = await tx
        .select({ startsAt: categories.windowStartsAt, endsAt: categories.windowEndsAt })
        .from(categories)
        .where(and(eq(categories.id, categoryId), ...this.live(categories, restaurantId)));
      if (!before) throw new MerchantsRefusedError('unknown_menu_row', 'no such category here');
      const was =
        before.startsAt === null || before.endsAt === null
          ? null
          : { startsAt: before.startsAt, endsAt: before.endsAt };
      if (JSON.stringify(was) === JSON.stringify(window)) return;
      await tx
        .update(categories)
        .set({
          windowStartsAt: window?.startsAt ?? null,
          windowEndsAt: window?.endsAt ?? null,
          updatedAt: sql`now()`,
        })
        .where(eq(categories.id, categoryId));
      await this.record(
        tx,
        change,
        row.cityId,
        'menu.category.update',
        'menu_category',
        categoryId,
        {
          before: { window: was },
          after: { window },
        },
      );
      await this.editor.menuChanged(tx, restaurantId, row.cityId);
    });
  }

  // RA §9.2: the order of the categories, or of one category's items; every
  // row once, as the panel's editor (2.31) takes it.
  async orderCategories(
    restaurantId: string,
    categoryIds: string[],
    change: MerchantChange,
  ): Promise<void> {
    await this.editor.orderCategories(restaurantId, categoryIds, change);
  }

  async orderItems(
    restaurantId: string,
    categoryId: string,
    itemIds: string[],
    change: MerchantChange,
  ): Promise<void> {
    await this.editor.orderItems(restaurantId, categoryId, itemIds, change);
  }

  // RA §9.4 «Bulk change (owners)»: the panel's tool (AP §9.6.6).
  async bulkPreview(restaurantId: string, scope: BulkScope, bulkChange: BulkPriceChange) {
    return this.bulk.preview(restaurantId, scope, bulkChange);
  }

  async bulkApply(
    restaurantId: string,
    scope: BulkScope,
    bulkChange: BulkPriceChange,
    change: MerchantChange & { accountId: string; idempotencyKey: string },
  ): Promise<{ changed: number; unchanged: number }> {
    const menuChange = await this.ownersChange(restaurantId, change);
    return this.bulk.apply(restaurantId, scope, bulkChange, { ...change, ...menuChange });
  }

  // The owners set prices in any status the menu is editable in (RA §9.2), so
  // the panel's `menus.edit_prices` does not apply; the threshold is read
  // before the transaction.
  private async ownersChange(restaurantId: string, change: MerchantChange): Promise<MenuChange> {
    const found = await this.merchants.cityAndStatus(restaurantId);
    if (found === null) throw new MerchantsRefusedError('unknown_restaurant', 'no such restaurant');
    const alertPct = await this.settings.get('merchant.price_change_alert_pct', {
      cityId: found.cityId,
    });
    return { ...change, mayEditPrices: true, alertPct };
  }

  // A published row of the restaurant that is not deleted: the restaurant's
  // own unpublished rows wait for their review (2.32b).
  private live(table: typeof categories | typeof items, restaurantId: string) {
    return [
      eq(table.restaurantId, restaurantId),
      eq(table.published, true),
      isNull(table.deletedAt),
    ] as const;
  }

  private async record(
    tx: Tx,
    change: MerchantChange,
    cityId: string,
    action: string,
    type: 'menu_category' | 'menu_item' | 'menu_option',
    targetId: string,
    values: { before: object; after: object },
  ): Promise<void> {
    await this.audit.recordWrite(
      {
        actor: change.actor,
        context: change.context,
        cityId,
        action,
        target: { type, id: targetId },
        before: forAudit(values.before),
        after: forAudit(values.after),
        reason: null,
      },
      tx,
    );
  }
}
