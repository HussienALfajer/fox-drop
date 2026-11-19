import { Inject, Injectable } from '@nestjs/common';
import { and, asc, eq, inArray, isNull, sql } from 'drizzle-orm';
import type { NodePgDatabase } from 'drizzle-orm/node-postgres';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { AuditService } from '../audit/index.js';
import { MENU_NAME_MAX, type MenuChange, MenuEditorService } from './menu-editor.service.js';
import {
  forAudit,
  type MerchantChange,
  MerchantsRefusedError,
  MerchantsService,
  type Money,
  type SwitchedOff,
  switchedOff,
  type Tx,
} from './merchants.service.js';
import { itemOptionGroups, items, optionGroups, options } from './schema.js';

// AP §9.6.6 «مجموعات الخيارات»: a group as the editor saves it. Required with
// a minimum of 1 or more; an add-on group has a minimum of 0.
export interface OptionGroupFields {
  name: string;
  minChoices: number;
  maxChoices: number;
}

// An option of a group with its price delta in the base (0 or more);
// `removed` hides it for good (deleted_at).
export interface OptionFields {
  name: string;
  priceDelta: Money;
  removed: boolean;
}

// A group as the editor reads it: every live option and the items it is
// linked to.
export interface EditorOptionGroup {
  id: string;
  name: string;
  minChoices: number;
  maxChoices: number;
  options: { id: string; name: string; priceDelta: Money; switchedOff: SwitchedOff }[];
  itemIds: string[];
}

// The menu editor's option groups and add-ons (AP §9.6.6; slice 2.31). As the
// categories and items, the panel names each new row's id, so a save creates
// it the first time and sets its fields after; every write takes the
// restaurant's lock (never a terminated one) and is audited. A delta change
// is a price change: past test mode it needs `menus.edit_prices`, and it is
// logged and told as one (`MenuEditorService.logPrices`).
@Injectable()
export class OptionGroupsService {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly editor: MenuEditorService,
    private readonly audit: AuditService,
    private readonly merchants: MerchantsService,
  ) {}

  // Every live group of the restaurant, by name, with its options in order
  // and its linked items.
  async groups(
    restaurantId: string,
    now = new Date(),
    executor: Pick<NodePgDatabase, 'select'> = this.database.db,
  ): Promise<EditorOptionGroup[]> {
    const db = executor;
    const groupRows = await db
      .select()
      .from(optionGroups)
      .where(
        and(
          eq(optionGroups.restaurantId, restaurantId),
          eq(optionGroups.published, true),
          isNull(optionGroups.deletedAt),
        ),
      )
      .orderBy(asc(optionGroups.name), asc(optionGroups.id));
    if (groupRows.length === 0) return [];
    const ids = groupRows.map((group) => group.id);
    const optionRows = await db
      .select()
      .from(options)
      .where(
        and(inArray(options.groupId, ids), eq(options.published, true), isNull(options.deletedAt)),
      )
      .orderBy(asc(options.position), asc(options.id));
    const links = await db
      .select({ groupId: itemOptionGroups.groupId, itemId: itemOptionGroups.itemId })
      .from(itemOptionGroups)
      .innerJoin(items, eq(items.id, itemOptionGroups.itemId))
      .where(
        and(
          inArray(itemOptionGroups.groupId, ids),
          isNull(itemOptionGroups.removedAt),
          isNull(items.deletedAt),
        ),
      )
      .orderBy(asc(items.position), asc(items.id));
    return groupRows.map((group) => ({
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
          switchedOff: switchedOff(option, now),
        })),
      itemIds: links.filter((link) => link.groupId === group.id).map((link) => link.itemId),
    }));
  }

  // Creates the group with this id or sets its fields: 0 ≤ min ≤ max, max ≥
  // 1, and once it has options, max at most their count. Audited as
  // menu.option_group.create or .update.
  async saveGroup(
    restaurantId: string,
    groupId: string,
    fields: OptionGroupFields,
    change: MerchantChange,
  ): Promise<void> {
    const name = fields.name.trim();
    const { minChoices, maxChoices } = fields;
    if (
      name.length === 0 ||
      name.length > MENU_NAME_MAX ||
      !Number.isInteger(minChoices) ||
      !Number.isInteger(maxChoices) ||
      minChoices < 0 ||
      maxChoices < 1 ||
      maxChoices < minChoices
    ) {
      throw new MerchantsRefusedError(
        'invalid_menu',
        `an option group needs a name of ${MENU_NAME_MAX} characters at most and 0 ≤ min ≤ max, max ≥ 1`,
      );
    }
    await this.database.db.transaction(async (tx) => {
      const row = await this.editor.lockEditable(tx, restaurantId);
      const [before] = await tx
        .select({
          restaurantId: optionGroups.restaurantId,
          name: optionGroups.name,
          minChoices: optionGroups.minChoices,
          maxChoices: optionGroups.maxChoices,
          deletedAt: optionGroups.deletedAt,
        })
        .from(optionGroups)
        .where(eq(optionGroups.id, groupId));
      const after = { name, minChoices, maxChoices };
      if (!before) {
        await tx
          .insert(optionGroups)
          .values({ id: groupId, restaurantId, published: true, ...after });
        await this.editor.menuChanged(tx, restaurantId, row.cityId);
        await this.record(tx, change, row.cityId, 'menu.option_group.create', groupId, null, {
          restaurantId,
          ...after,
        });
        return;
      }
      if (before.restaurantId !== restaurantId || before.deletedAt !== null) {
        throw new MerchantsRefusedError('unknown_menu_row', 'no such option group here');
      }
      const was = {
        name: before.name,
        minChoices: before.minChoices,
        maxChoices: before.maxChoices,
      };
      if (JSON.stringify(was) === JSON.stringify(after)) return;
      await this.checkChoices(tx, groupId, maxChoices, 0);
      await tx
        .update(optionGroups)
        .set({ ...after, updatedAt: sql`now()` })
        .where(eq(optionGroups.id, groupId));
      await this.editor.menuChanged(tx, restaurantId, row.cityId);
      await this.record(tx, change, row.cityId, 'menu.option_group.update', groupId, was, after);
    });
  }

  // Creates the option with this id at the end of its group, or sets its
  // fields. A delta is 0 or more in the base (RA §9.4); past test mode a new
  // option or a changed delta needs `menus.edit_prices`. Audited as
  // menu.option.create or .update.
  async saveOption(
    restaurantId: string,
    groupId: string,
    optionId: string,
    fields: OptionFields,
    change: MenuChange,
  ): Promise<void> {
    const name = fields.name.trim();
    if (name.length === 0 || name.length > MENU_NAME_MAX) {
      throw new MerchantsRefusedError(
        'invalid_menu',
        `an option needs a name of ${MENU_NAME_MAX} characters at most`,
      );
    }
    if (fields.priceDelta.amount < 0n) {
      throw new MerchantsRefusedError('invalid_menu', 'a price delta is 0 or more');
    }
    await this.database.db.transaction(async (tx) => {
      const row = await this.editor.lockEditable(tx, restaurantId);
      await this.ownGroup(tx, restaurantId, groupId);
      const [before] = await tx
        .select({
          groupId: options.groupId,
          name: options.name,
          priceDelta: options.priceDelta,
          currency: options.currency,
          deletedAt: options.deletedAt,
        })
        .from(options)
        .where(eq(options.id, optionId));
      if (before && (before.groupId !== groupId || before.deletedAt !== null)) {
        throw new MerchantsRefusedError('unknown_menu_row', 'no such option here');
      }
      if (!before && fields.removed) {
        throw new MerchantsRefusedError('unknown_menu_row', 'no such option here');
      }
      const deltaChanged =
        before !== undefined &&
        (before.priceDelta !== fields.priceDelta.amount ||
          before.currency !== fields.priceDelta.currency);
      if (before === undefined || deltaChanged) {
        MenuEditorService.checkPriceEdit(row.accountStatus, change);
        await this.merchants.checkBaseCurrency(tx, row.cityId, fields.priceDelta.currency);
      }
      const values = {
        name,
        priceDelta: fields.priceDelta.amount,
        currency: fields.priceDelta.currency,
      };
      if (!before) {
        const [{ count }] = (await tx
          .select({ count: sql<number>`count(*)::int` })
          .from(options)
          .where(eq(options.groupId, groupId))) as [{ count: number }];
        await tx
          .insert(options)
          .values({ id: optionId, groupId, position: count, published: true, ...values });
        await this.editor.menuChanged(tx, restaurantId, row.cityId);
        await this.record(
          tx,
          change,
          row.cityId,
          'menu.option.create',
          optionId,
          null,
          forAudit({ groupId, ...values }),
        );
        return;
      }
      const was = forAudit({
        name: before.name,
        priceDelta: before.priceDelta,
        currency: before.currency,
        removed: false,
      });
      const after = forAudit({ ...values, removed: fields.removed });
      if (JSON.stringify(was) === JSON.stringify(after)) return;
      if (fields.removed) {
        const [group] = await tx
          .select({ maxChoices: optionGroups.maxChoices })
          .from(optionGroups)
          .where(eq(optionGroups.id, groupId));
        await this.checkChoices(tx, groupId, group?.maxChoices ?? 1, 1);
      }
      await tx
        .update(options)
        .set({
          ...values,
          ...(fields.removed ? { deletedAt: sql`now()` } : {}),
          updatedAt: sql`now()`,
        })
        .where(eq(options.id, optionId));
      await this.editor.menuChanged(tx, restaurantId, row.cityId);
      await this.record(tx, change, row.cityId, 'menu.option.update', optionId, was, after);
      if (deltaChanged) {
        await this.editor.logPrices(
          tx,
          restaurantId,
          row,
          [
            {
              target: { type: 'option', id: optionId },
              name,
              old: { amount: before.priceDelta, currency: before.currency },
              new: fields.priceDelta,
            },
          ],
          change,
        );
      }
    });
  }

  // Every live option of the group, once each, in the new order. Audited as
  // menu.option.order.
  async orderOptions(
    restaurantId: string,
    groupId: string,
    optionIds: string[],
    change: MerchantChange,
  ): Promise<void> {
    await this.database.db.transaction(async (tx) => {
      const row = await this.editor.lockEditable(tx, restaurantId);
      await this.ownGroup(tx, restaurantId, groupId);
      const current = (
        await tx
          .select({ id: options.id })
          .from(options)
          .where(
            and(
              eq(options.groupId, groupId),
              eq(options.published, true),
              isNull(options.deletedAt),
            ),
          )
      ).map((each) => each.id);
      if (!sameSet(current, optionIds)) {
        throw new MerchantsRefusedError('invalid_menu', 'name every option once, in the new order');
      }
      for (const [position, id] of optionIds.entries()) {
        await tx
          .update(options)
          .set({ position, updatedAt: sql`now()` })
          .where(eq(options.id, id));
      }
      await this.editor.menuChanged(tx, restaurantId, row.cityId);
      await this.record(tx, change, row.cityId, 'menu.option.order', groupId, null, {
        optionIds,
      });
    });
  }

  // AP §9.6.6 «ربط مجموعة بعدة أصناف»: the items the group is linked to, as a
  // set. A new link goes at the end of the item's groups; an unlinked one
  // gets removed_at. Audited as menu.option_group.items.
  async linkItems(
    restaurantId: string,
    groupId: string,
    itemIds: string[],
    change: MerchantChange,
  ): Promise<void> {
    if (new Set(itemIds).size !== itemIds.length) {
      throw new MerchantsRefusedError('invalid_menu', 'name each item once');
    }
    await this.database.db.transaction(async (tx) => {
      const row = await this.editor.lockEditable(tx, restaurantId);
      await this.ownGroup(tx, restaurantId, groupId);
      await this.ownItems(tx, restaurantId, itemIds);
      const { added, removed } = await this.linkItemsIn(tx, groupId, itemIds);
      if (added.length === 0 && removed.length === 0) return;
      await this.editor.menuChanged(tx, restaurantId, row.cityId);
      await this.record(tx, change, row.cityId, 'menu.option_group.items', groupId, null, {
        added,
        removed,
      });
    });
  }

  // Module-internal: the group's items as a set, in the caller's transaction
  // (an approved request's, slice 2.32b): a new link at the end of the item's
  // groups, an old one again, the others unlinked.
  async linkItemsIn(
    tx: Tx,
    groupId: string,
    itemIds: string[],
  ): Promise<{ added: string[]; removed: string[] }> {
    const linked = await tx
      .select({ itemId: itemOptionGroups.itemId, removedAt: itemOptionGroups.removedAt })
      .from(itemOptionGroups)
      .where(eq(itemOptionGroups.groupId, groupId));
    const live = linked.filter((link) => link.removedAt === null).map((link) => link.itemId);
    const added = itemIds.filter((id) => !live.includes(id));
    const removed = live.filter((id) => !itemIds.includes(id));
    for (const itemId of added) {
      await this.link(
        tx,
        itemId,
        groupId,
        linked.some((link) => link.itemId === itemId),
      );
    }
    if (removed.length > 0) {
      await tx
        .update(itemOptionGroups)
        .set({ removedAt: sql`now()` })
        .where(
          and(eq(itemOptionGroups.groupId, groupId), inArray(itemOptionGroups.itemId, removed)),
        );
    }
    return { added, removed };
  }

  // An item's groups, in order: the ones named are linked at these
  // positions, the others unlinked. Audited as menu.item.option_groups.
  async setItemGroups(
    restaurantId: string,
    itemId: string,
    groupIds: string[],
    change: MerchantChange,
  ): Promise<void> {
    if (new Set(groupIds).size !== groupIds.length) {
      throw new MerchantsRefusedError('invalid_menu', 'name each group once');
    }
    await this.database.db.transaction(async (tx) => {
      const row = await this.editor.lockEditable(tx, restaurantId);
      await this.ownItems(tx, restaurantId, [itemId]);
      for (const groupId of groupIds) await this.ownGroup(tx, restaurantId, groupId);
      const linked = await tx
        .select({
          groupId: itemOptionGroups.groupId,
          position: itemOptionGroups.position,
          removedAt: itemOptionGroups.removedAt,
        })
        .from(itemOptionGroups)
        .where(eq(itemOptionGroups.itemId, itemId))
        .orderBy(asc(itemOptionGroups.position));
      const was = linked.filter((link) => link.removedAt === null).map((link) => link.groupId);
      if (JSON.stringify(was) === JSON.stringify(groupIds)) return;
      for (const [position, groupId] of groupIds.entries()) {
        if (linked.some((link) => link.groupId === groupId)) {
          await tx
            .update(itemOptionGroups)
            .set({ position, removedAt: null })
            .where(and(eq(itemOptionGroups.itemId, itemId), eq(itemOptionGroups.groupId, groupId)));
        } else {
          await tx.insert(itemOptionGroups).values({ itemId, groupId, position });
        }
      }
      const unlinked = was.filter((id) => !groupIds.includes(id));
      if (unlinked.length > 0) {
        await tx
          .update(itemOptionGroups)
          .set({ removedAt: sql`now()` })
          .where(
            and(eq(itemOptionGroups.itemId, itemId), inArray(itemOptionGroups.groupId, unlinked)),
          );
      }
      await this.editor.menuChanged(tx, restaurantId, row.cityId);
      await this.record(
        tx,
        change,
        row.cityId,
        'menu.item.option_groups',
        itemId,
        { groupIds: was },
        { groupIds },
      );
    });
  }

  // Links the group at the end of the item's live groups, again when it was
  // linked before.
  private async link(tx: Tx, itemId: string, groupId: string, before: boolean): Promise<void> {
    const [{ count }] = (await tx
      .select({ count: sql<number>`count(*)::int` })
      .from(itemOptionGroups)
      .where(and(eq(itemOptionGroups.itemId, itemId), isNull(itemOptionGroups.removedAt)))) as [
      { count: number },
    ];
    if (before) {
      await tx
        .update(itemOptionGroups)
        .set({ position: count, removedAt: null })
        .where(and(eq(itemOptionGroups.itemId, itemId), eq(itemOptionGroups.groupId, groupId)));
    } else {
      await tx.insert(itemOptionGroups).values({ itemId, groupId, position: count });
    }
  }

  // Once a group has published options, its maximum is at most their count
  // (less the ones about to go); a restaurant's new option waiting for review
  // (slice 2.32b) does not count until approved.
  private async checkChoices(
    tx: Tx,
    groupId: string,
    maxChoices: number,
    leaving: number,
  ): Promise<void> {
    const [{ count }] = (await tx
      .select({ count: sql<number>`count(*)::int` })
      .from(options)
      .where(
        and(eq(options.groupId, groupId), eq(options.published, true), isNull(options.deletedAt)),
      )) as [{ count: number }];
    const left = count - leaving;
    if (left > 0 && maxChoices > left) {
      throw new MerchantsRefusedError(
        'invalid_menu',
        'the maximum choices are at most the options of the group',
      );
    }
  }

  private async ownGroup(tx: Tx, restaurantId: string, groupId: string): Promise<void> {
    const [found] = await tx
      .select({ id: optionGroups.id })
      .from(optionGroups)
      .where(
        and(
          eq(optionGroups.id, groupId),
          eq(optionGroups.restaurantId, restaurantId),
          isNull(optionGroups.deletedAt),
        ),
      );
    if (!found) throw new MerchantsRefusedError('unknown_menu_row', 'no such option group here');
  }

  private async ownItems(tx: Tx, restaurantId: string, itemIds: string[]): Promise<void> {
    if (itemIds.length === 0) return;
    const found = await tx
      .select({ id: items.id })
      .from(items)
      .where(
        and(
          inArray(items.id, itemIds),
          eq(items.restaurantId, restaurantId),
          isNull(items.deletedAt),
        ),
      );
    if (found.length !== itemIds.length) {
      throw new MerchantsRefusedError('unknown_menu_row', 'no such item here');
    }
  }

  private async record(
    tx: Tx,
    change: MerchantChange,
    cityId: string,
    action: string,
    targetId: string,
    before: Record<string, unknown> | null,
    after: Record<string, unknown>,
  ): Promise<void> {
    const type = action.startsWith('menu.option_group')
      ? 'menu_option_group'
      : action === 'menu.option.order'
        ? 'menu_option_group'
        : action.startsWith('menu.item')
          ? 'menu_item'
          : 'menu_option';
    await this.audit.recordWrite(
      {
        actor: change.actor,
        context: change.context,
        cityId,
        action,
        target: { type, id: targetId },
        before,
        after,
        reason: change.reason ?? null,
      },
      tx,
    );
  }
}

function sameSet(current: string[], wanted: string[]): boolean {
  return (
    wanted.length === current.length &&
    new Set(wanted).size === wanted.length &&
    wanted.every((id) => current.includes(id))
  );
}
