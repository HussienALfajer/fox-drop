import { Inject, Injectable } from '@nestjs/common';
import { and, asc, eq, inArray, isNull, max, notInArray, sql } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { Jobs } from '../../jobs/jobs.module.js';
import { AuditService } from '../audit/index.js';
import { FilesService } from '../files/index.js';
import { MENU_DESCRIPTION_MAX, MENU_NAME_MAX, MenuEditorService } from './menu-editor.service.js';
import {
  forAudit,
  type MenuCategory,
  type MenuItem,
  type MerchantChange,
  MerchantsRefusedError,
  MerchantsService,
  type Money,
  type SwitchedOff,
  type Tx,
} from './merchants.service.js';
import { OptionGroupsService } from './option-groups.service.js';
import {
  categories,
  changeRequests,
  changeRequestTargets,
  itemOptionGroups,
  items,
  optionGroups,
  options,
  restaurants,
} from './schema.js';
import { recordStateChange } from './state-events.js';

export type ChangeTargetType = (typeof changeRequestTargets)[number];

// RA §9.2 «After admin review»: what a request changes. `created` is a new
// row, unpublished until approved; the others a field of a published row.
export const changeFields = [
  'created',
  'name',
  'description',
  'photo',
  'choices',
  'items',
] as const;
export type ChangeField = (typeof changeFields)[number];

// RA §9.5: a rejection's reason, which the restaurant reads (decided by us).
export const REJECTION_REASON_MAX = 200;

// A request's values, flat: each field fills only its own part (a new item
// its category, name, description, price and photo; a rename its name).
export interface ChangeValues {
  name: string | null;
  description: string | null;
  photoKey: string | null;
  price: Money | null;
  categoryId: string | null;
  groupId: string | null;
  minChoices: number | null;
  maxChoices: number | null;
  itemIds: string[] | null;
  options: { id: string; name: string; priceDelta: Money }[] | null;
}

// A pending request as the owners read it beside its row.
export interface PendingChange extends ChangeValues {
  requestId: string;
  field: ChangeField;
  createdAt: Date;
}

export type OwnersMenuItem = MenuItem & { pending: PendingChange[] };
export type OwnersMenuCategory = Omit<MenuCategory, 'items'> & {
  items: OwnersMenuItem[];
  pending: PendingChange[];
};

export interface OwnersOptionGroup {
  id: string;
  name: string;
  minChoices: number;
  maxChoices: number;
  itemIds: string[];
  options: {
    id: string;
    name: string;
    priceDelta: Money;
    switchedOff: SwitchedOff;
    pending: PendingChange[];
  }[];
  pending: PendingChange[];
}

// RA §9.5: the owners' menu with each row's pending requests and the new
// rows waiting for review, which customers do not see.
export interface OwnersMenu {
  categories: OwnersMenuCategory[];
  optionGroups: OwnersOptionGroup[];
}

// AP §9.6.7 «طلبات تعديل القائمة»: a request in the queue.
export interface QueuedRequest {
  id: string;
  restaurantId: string;
  restaurantName: string;
  targetType: ChangeTargetType;
  targetId: string;
  field: ChangeField;
  // The row's name as the restaurant knows it: a new row's asked name.
  targetName: string;
  createdAt: Date;
}

// AP §9.6.7 «Request view»: before and after, with what the preview needs.
export interface RequestView extends QueuedRequest {
  status: 'pending' | 'approved' | 'rejected' | 'withdrawn';
  // Null for a new row.
  before: ChangeValues | null;
  after: ChangeValues;
  // An item's category, an option's group.
  parentName: string | null;
  // The item as customers see it now (a request on an item), for the
  // customer preview.
  item: { name: string; description: string | null; photoKey: string | null; price: Money } | null;
  // The names of the items a group's request names.
  itemNames: { id: string; name: string }[];
}

// What the reviewer may correct before approving (RA §9.5).
export interface Correction {
  name?: string | undefined;
  description?: string | null | undefined;
}

export interface NewItemRequest {
  categoryId: string;
  name: string;
  description: string | null;
  price: Money;
  uploadId: string | null;
}

export interface OptionGroupRequest {
  name: string;
  minChoices: number;
  maxChoices: number;
  itemIds: string[];
  options: { id: string; name: string; priceDelta: Money }[];
}

// The value a request keeps (jsonb): amounts as strings.
type StoredMoney = { amount: string; currency: string };
type Stored = {
  name?: string;
  priceDelta?: StoredMoney;
  description?: string | null;
  photoKey?: string | null;
  price?: StoredMoney;
  categoryId?: string;
  groupId?: string;
  minChoices?: number;
  maxChoices?: number;
  itemIds?: string[];
  options?: { id: string; name: string; priceDelta: StoredMoney }[];
};

type RequestRow = typeof changeRequests.$inferSelect;
type Target = { type: ChangeTargetType; id: string };

const auditType = (type: ChangeTargetType) => `menu_${type}`;
const stored = (money: Money): StoredMoney => ({
  amount: money.amount.toString(),
  currency: money.currency,
});
const money = (value: StoredMoney): Money => ({
  amount: BigInt(value.amount),
  currency: value.currency,
});

// RA §9.2 «After admin review», §9.5, §18; AP §9.6.7 (slice 2.32b): the
// owners' change requests and their review. A new category, item, option
// group or option is its own unpublished row with the request `created`; a
// published row's name, description, photo, a group's choices and items wait
// as one pending request per field (a newer edit replaces its value, the
// published value again withdraws it). OWN or OPS approve (publishing at once,
// a text corrected first) or reject (with a reason) in the panel; the owners
// hear of it with a silent push (RA §16 #22). A rejected or withdrawn new row
// is soft-deleted (owner decision 2026-11-19). Every write takes the
// restaurant's lock, is audited and tells every device (`menu_changed`).
@Injectable()
export class ChangeRequestsService {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly merchants: MerchantsService,
    private readonly editor: MenuEditorService,
    private readonly groups: OptionGroupsService,
    private readonly files: FilesService,
    private readonly audit: AuditService,
    private readonly jobs: Jobs,
  ) {}

  // A new category, or a published category's name.
  async requestCategory(
    restaurantId: string,
    categoryId: string,
    name: string,
    change: MerchantChange,
  ): Promise<void> {
    const text = checkedName(name);
    await this.database.db.transaction(async (tx) => {
      const row = await this.editor.lockEditable(tx, restaurantId);
      const [before] = await tx.select().from(categories).where(eq(categories.id, categoryId));
      const target: Target = { type: 'category', id: categoryId };
      if (!before) {
        const [{ count }] = (await tx
          .select({ count: sql<number>`count(*)::int` })
          .from(categories)
          .where(eq(categories.restaurantId, restaurantId))) as [{ count: number }];
        await tx
          .insert(categories)
          .values({ id: categoryId, restaurantId, name: text, position: count, published: false });
        await this.ask(tx, row.cityId, restaurantId, target, 'created', { name: text }, change);
        return;
      }
      if (before.restaurantId !== restaurantId || before.deletedAt !== null) {
        throw new MerchantsRefusedError('unknown_menu_row', 'no such category here');
      }
      if (!before.published) {
        await tx
          .update(categories)
          .set({ name: text, updatedAt: sql`now()` })
          .where(eq(categories.id, categoryId));
        await this.ask(tx, row.cityId, restaurantId, target, 'created', { name: text }, change);
        return;
      }
      await this.askOrDrop(
        tx,
        row.cityId,
        restaurantId,
        target,
        'name',
        before.name === text,
        {
          name: text,
        },
        change,
      );
    });
  }

  // A new item with its category, name, description, price and photo, or an
  // edit of the one waiting for review. A published item's text goes through
  // `requestItemText`, its price through «تعديل السعر» (RA §9.4).
  async requestNewItem(
    restaurantId: string,
    itemId: string,
    fields: NewItemRequest,
    change: MerchantChange,
  ): Promise<void> {
    const name = checkedName(fields.name);
    const description = checkedDescription(fields.description);
    if (fields.price.amount <= 0n) {
      throw new MerchantsRefusedError('invalid_menu', 'an item price is above 0');
    }
    if (fields.uploadId !== null) {
      await this.files.prepare(fields.uploadId, 'item_photo', new Date(), change.actor.id);
    }
    await this.database.db.transaction(async (tx) => {
      const row = await this.editor.lockEditable(tx, restaurantId);
      await this.merchants.checkBaseCurrency(tx, row.cityId, fields.price.currency);
      const [category] = await tx
        .select({ id: categories.id })
        .from(categories)
        .where(
          and(
            eq(categories.id, fields.categoryId),
            eq(categories.restaurantId, restaurantId),
            isNull(categories.deletedAt),
          ),
        );
      if (!category) throw new MerchantsRefusedError('unknown_menu_row', 'no such category here');
      const [before] = await tx.select().from(items).where(eq(items.id, itemId));
      if (before && (before.restaurantId !== restaurantId || before.deletedAt !== null)) {
        throw new MerchantsRefusedError('unknown_menu_row', 'no such item here');
      }
      if (before?.published) {
        throw new MerchantsRefusedError('already_published', 'the item is published');
      }
      const photoKey =
        fields.uploadId === null
          ? (before?.photoKey ?? null)
          : await this.linkPhoto(tx, fields.uploadId, before?.photoKey ?? null);
      const values = {
        categoryId: fields.categoryId,
        name,
        description,
        price: fields.price.amount,
        currency: fields.price.currency,
        photoKey,
      };
      if (!before) {
        await tx.insert(items).values({
          id: itemId,
          restaurantId,
          code: await this.editor.generatedCode(tx, restaurantId),
          position: await nextPosition(tx, items, eq(items.categoryId, fields.categoryId)),
          published: false,
          ...values,
        });
      } else {
        await tx
          .update(items)
          .set({
            ...values,
            ...(before.categoryId === fields.categoryId
              ? {}
              : {
                  position: await nextPosition(tx, items, eq(items.categoryId, fields.categoryId)),
                }),
            updatedAt: sql`now()`,
          })
          .where(eq(items.id, itemId));
      }
      await this.ask(
        tx,
        row.cityId,
        restaurantId,
        { type: 'item', id: itemId },
        'created',
        {
          categoryId: fields.categoryId,
          name,
          description,
          price: stored(fields.price),
          photoKey,
        },
        change,
      );
    });
  }

  // A published item's name and description: one request per field that
  // differs; the published value again withdraws its request.
  async requestItemText(
    restaurantId: string,
    itemId: string,
    fields: { name: string; description: string | null },
    change: MerchantChange,
  ): Promise<void> {
    const name = checkedName(fields.name);
    const description = checkedDescription(fields.description);
    await this.database.db.transaction(async (tx) => {
      const row = await this.editor.lockEditable(tx, restaurantId);
      const before = await this.ownItem(tx, restaurantId, itemId);
      if (!before.published) {
        throw new MerchantsRefusedError('not_published', 'a new item is edited as a whole');
      }
      const target: Target = { type: 'item', id: itemId };
      await this.askOrDrop(
        tx,
        row.cityId,
        restaurantId,
        target,
        'name',
        before.name === name,
        {
          name,
        },
        change,
      );
      await this.askOrDrop(
        tx,
        row.cityId,
        restaurantId,
        target,
        'description',
        before.description === description,
        { description },
        change,
      );
    });
  }

  // RA §9.2: a new or replaced photo; the old one stays until approval. A new
  // item's photo is part of its own request.
  async requestItemPhoto(
    restaurantId: string,
    itemId: string,
    uploadId: string,
    change: MerchantChange,
  ): Promise<void> {
    await this.files.prepare(uploadId, 'item_photo', new Date(), change.actor.id);
    await this.database.db.transaction(async (tx) => {
      const row = await this.editor.lockEditable(tx, restaurantId);
      const before = await this.ownItem(tx, restaurantId, itemId);
      const target: Target = { type: 'item', id: itemId };
      if (!before.published) {
        const photoKey = await this.linkPhoto(tx, uploadId, before.photoKey);
        if (photoKey === before.photoKey) return;
        await tx
          .update(items)
          .set({ photoKey, updatedAt: sql`now()` })
          .where(eq(items.id, itemId));
        const [created] = await this.pendingOf(tx, target, 'created');
        await this.ask(
          tx,
          row.cityId,
          restaurantId,
          target,
          'created',
          { ...(created?.pendingValue as Stored), photoKey },
          change,
        );
        return;
      }
      const [pending] = await this.pendingOf(tx, target, 'photo');
      const was = (pending?.pendingValue as Stored | undefined)?.photoKey ?? before.photoKey;
      const photoKey = await this.linkPhoto(tx, uploadId, was);
      await this.ask(tx, row.cityId, restaurantId, target, 'photo', { photoKey }, change);
    });
  }

  // RA §9.2 «Option groups»: a new group with its options and items, or a
  // published group's name, choices, items, new options and options' names,
  // each its own request. An option's delta changes through «تعديل السعر»
  // (RA §9.4), so a published option keeps its delta here; options left out
  // stay as they are (the app never deletes, RA §9.2).
  async requestOptionGroup(
    restaurantId: string,
    groupId: string,
    fields: OptionGroupRequest,
    change: MerchantChange,
  ): Promise<void> {
    const name = checkedName(fields.name);
    const { minChoices, maxChoices } = fields;
    if (
      !Number.isInteger(minChoices) ||
      !Number.isInteger(maxChoices) ||
      minChoices < 0 ||
      maxChoices < 1 ||
      maxChoices < minChoices
    ) {
      throw new MerchantsRefusedError('invalid_menu', '0 ≤ minimum ≤ maximum and maximum ≥ 1');
    }
    const optionIds = fields.options.map((option) => option.id);
    if (
      new Set(optionIds).size !== optionIds.length ||
      new Set(fields.itemIds).size !== fields.itemIds.length
    ) {
      throw new MerchantsRefusedError('invalid_menu', 'name each option and item once');
    }
    const asked = fields.options.map((option) => {
      if (option.priceDelta.amount < 0n) {
        throw new MerchantsRefusedError('invalid_menu', 'a price delta is 0 or more');
      }
      return { id: option.id, name: checkedName(option.name), priceDelta: option.priceDelta };
    });
    await this.database.db.transaction(async (tx) => {
      const row = await this.editor.lockEditable(tx, restaurantId);
      for (const option of asked) {
        await this.merchants.checkBaseCurrency(tx, row.cityId, option.priceDelta.currency);
      }
      if (fields.itemIds.length > 0) {
        const found = await tx
          .select({ id: items.id })
          .from(items)
          .where(
            and(
              inArray(items.id, fields.itemIds),
              eq(items.restaurantId, restaurantId),
              isNull(items.deletedAt),
            ),
          );
        if (found.length !== fields.itemIds.length) {
          throw new MerchantsRefusedError('unknown_menu_row', 'no such item here');
        }
      }
      const [before] = await tx.select().from(optionGroups).where(eq(optionGroups.id, groupId));
      if (before && (before.restaurantId !== restaurantId || before.deletedAt !== null)) {
        throw new MerchantsRefusedError('unknown_menu_row', 'no such option group here');
      }
      const existing =
        optionIds.length === 0
          ? []
          : await tx.select().from(options).where(inArray(options.id, optionIds));
      if (existing.some((option) => option.groupId !== groupId || option.deletedAt !== null)) {
        throw new MerchantsRefusedError('unknown_menu_row', 'no such option in the group');
      }
      const target: Target = { type: 'option_group', id: groupId };
      if (!before || !before.published) {
        if (asked.length === 0 || maxChoices > asked.length) {
          throw new MerchantsRefusedError(
            'invalid_menu',
            'a new group has options, at least its maximum choices',
          );
        }
        const values = { name, minChoices, maxChoices };
        if (!before) {
          await tx
            .insert(optionGroups)
            .values({ id: groupId, restaurantId, published: false, ...values });
        } else {
          await tx
            .update(optionGroups)
            .set({ ...values, updatedAt: sql`now()` })
            .where(eq(optionGroups.id, groupId));
          // An option left out of a new group goes with it.
          await tx
            .update(options)
            .set({ deletedAt: sql`now()` })
            .where(
              and(
                eq(options.groupId, groupId),
                isNull(options.deletedAt),
                optionIds.length === 0 ? sql`true` : notInArray(options.id, optionIds),
              ),
            );
        }
        for (const [position, option] of asked.entries()) {
          const values = {
            name: option.name,
            priceDelta: option.priceDelta.amount,
            currency: option.priceDelta.currency,
            position,
          };
          if (existing.some((each) => each.id === option.id)) {
            await tx
              .update(options)
              .set({ ...values, updatedAt: sql`now()` })
              .where(eq(options.id, option.id));
          } else {
            await tx
              .insert(options)
              .values({ id: option.id, groupId, published: false, ...values });
          }
        }
        await this.ask(
          tx,
          row.cityId,
          restaurantId,
          target,
          'created',
          {
            name,
            minChoices,
            maxChoices,
            itemIds: fields.itemIds,
            options: asked.map((option) => ({
              id: option.id,
              name: option.name,
              priceDelta: stored(option.priceDelta),
            })),
          },
          change,
        );
        return;
      }
      // A published group: its live options and the new ones must hold the
      // maximum.
      const live = await tx
        .select({ id: options.id })
        .from(options)
        .where(and(eq(options.groupId, groupId), isNull(options.deletedAt)));
      const newOnes = asked.filter((option) => !existing.some((each) => each.id === option.id));
      if (maxChoices > live.length + newOnes.length) {
        throw new MerchantsRefusedError(
          'invalid_menu',
          'the maximum choices are at most the options of the group',
        );
      }
      for (const option of asked) {
        const was = existing.find((each) => each.id === option.id);
        const optionTarget: Target = { type: 'option', id: option.id };
        if (was?.published) {
          if (
            was.priceDelta !== option.priceDelta.amount ||
            was.currency !== option.priceDelta.currency
          ) {
            throw new MerchantsRefusedError(
              'invalid_menu',
              'a delta changes through its own command',
            );
          }
          await this.askOrDrop(
            tx,
            row.cityId,
            restaurantId,
            optionTarget,
            'name',
            was.name === option.name,
            { name: option.name },
            change,
          );
          continue;
        }
        const values = {
          name: option.name,
          priceDelta: option.priceDelta.amount,
          currency: option.priceDelta.currency,
        };
        if (was) {
          await tx
            .update(options)
            .set({ ...values, updatedAt: sql`now()` })
            .where(eq(options.id, option.id));
        } else {
          await tx.insert(options).values({
            id: option.id,
            groupId,
            published: false,
            position: await nextPosition(tx, options, eq(options.groupId, groupId)),
            ...values,
          });
        }
        await this.ask(
          tx,
          row.cityId,
          restaurantId,
          optionTarget,
          'created',
          { groupId, name: option.name, priceDelta: stored(option.priceDelta) },
          change,
        );
      }
      await this.askOrDrop(
        tx,
        row.cityId,
        restaurantId,
        target,
        'name',
        before.name === name,
        {
          name,
        },
        change,
      );
      await this.askOrDrop(
        tx,
        row.cityId,
        restaurantId,
        target,
        'choices',
        before.minChoices === minChoices && before.maxChoices === maxChoices,
        { minChoices, maxChoices },
        change,
      );
      const linked = await this.linkedItems(tx, groupId);
      await this.askOrDrop(
        tx,
        row.cityId,
        restaurantId,
        target,
        'items',
        sameSet(linked, fields.itemIds),
        { itemIds: fields.itemIds },
        change,
      );
    });
  }

  // RA §9.5: the owner withdraws a pending request; a new row goes with it.
  async withdraw(restaurantId: string, requestId: string, change: MerchantChange): Promise<void> {
    await this.database.db.transaction(async (tx) => {
      const row = await this.editor.lockEditable(tx, restaurantId);
      const request = await this.lockRequest(tx, requestId);
      if (request.restaurantId !== restaurantId) {
        throw new MerchantsRefusedError('unknown_change_request', 'no such request here');
      }
      await this.close(tx, row.cityId, request, 'withdrawn', null, change);
      await this.editor.menuChanged(tx, restaurantId, row.cityId);
    });
  }

  // RA §9.5: the owners' menu, each row with its pending requests, and the
  // new rows that wait for review at the end of their category or group.
  async ownersMenu(restaurantId: string, now = new Date()): Promise<OwnersMenu> {
    const db = this.database.db;
    const [menu, published, requests] = await Promise.all([
      this.merchants.menu(restaurantId, now),
      this.groups.groups(restaurantId, now),
      db
        .select()
        .from(changeRequests)
        .where(
          and(eq(changeRequests.restaurantId, restaurantId), eq(changeRequests.status, 'pending')),
        )
        .orderBy(asc(changeRequests.createdAt), asc(changeRequests.id)),
    ]);
    const [newCategories, newItems, newGroups] = await Promise.all([
      db
        .select()
        .from(categories)
        .where(
          and(
            eq(categories.restaurantId, restaurantId),
            eq(categories.published, false),
            isNull(categories.deletedAt),
          ),
        )
        .orderBy(asc(categories.position), asc(categories.id)),
      db
        .select()
        .from(items)
        .where(
          and(
            eq(items.restaurantId, restaurantId),
            eq(items.published, false),
            isNull(items.deletedAt),
          ),
        )
        .orderBy(asc(items.position), asc(items.id)),
      db
        .select()
        .from(optionGroups)
        .where(
          and(
            eq(optionGroups.restaurantId, restaurantId),
            eq(optionGroups.published, false),
            isNull(optionGroups.deletedAt),
          ),
        )
        .orderBy(asc(optionGroups.name), asc(optionGroups.id)),
    ]);
    const groupIds = [...published.map((group) => group.id), ...newGroups.map((g) => g.id)];
    const newOptions =
      groupIds.length === 0
        ? []
        : await db
            .select()
            .from(options)
            .where(
              and(
                inArray(options.groupId, groupIds),
                eq(options.published, false),
                isNull(options.deletedAt),
              ),
            )
            .orderBy(asc(options.position), asc(options.id));
    const pendingOf = (id: string) =>
      requests.filter((request) => request.targetId === id).map(pendingChange);
    const newItem = (item: (typeof newItems)[number]): OwnersMenuItem => ({
      id: item.id,
      code: item.code,
      name: item.name,
      description: item.description,
      photoKey: item.photoKey,
      price: { amount: item.price, currency: item.currency },
      available: false,
      switchedOff: null,
      hidden: item.hidden,
      badge: item.badge,
      optionGroups: [],
      pending: pendingOf(item.id),
    });
    const withPending = (category: MenuCategory): OwnersMenuCategory => ({
      ...category,
      items: [
        ...category.items.map((item) => ({ ...item, pending: pendingOf(item.id) })),
        ...newItems.filter((item) => item.categoryId === category.id).map(newItem),
      ],
      pending: pendingOf(category.id),
    });
    const newOption = (option: (typeof newOptions)[number]) => ({
      id: option.id,
      name: option.name,
      priceDelta: { amount: option.priceDelta, currency: option.currency },
      switchedOff: null,
      pending: pendingOf(option.id),
    });
    return {
      categories: [
        ...menu.categories.map(withPending),
        ...newCategories.map((category) =>
          withPending({
            id: category.id,
            name: category.name,
            hidden: category.hidden,
            available: false,
            switchedOff: null,
            window: null,
            inWindow: true,
            items: [],
          }),
        ),
      ],
      optionGroups: [
        ...published.map((group) => ({
          ...group,
          options: [
            ...group.options.map((option) => ({ ...option, pending: pendingOf(option.id) })),
            ...newOptions.filter((option) => option.groupId === group.id).map(newOption),
          ],
          pending: pendingOf(group.id),
        })),
        ...newGroups.map((group) => {
          const created = requests.find(
            (request) => request.targetId === group.id && request.field === 'created',
          );
          return {
            id: group.id,
            name: group.name,
            minChoices: group.minChoices,
            maxChoices: group.maxChoices,
            itemIds: (created?.pendingValue as Stored | undefined)?.itemIds ?? [],
            options: newOptions.filter((option) => option.groupId === group.id).map(newOption),
            pending: pendingOf(group.id),
          };
        }),
      ],
    };
  }

  // AP §9.6.7: the city's pending requests, oldest first.
  async queue(cityId: string): Promise<QueuedRequest[]> {
    const rows = await this.database.db
      .select({ request: changeRequests, restaurantName: restaurants.nameAr })
      .from(changeRequests)
      .innerJoin(restaurants, eq(restaurants.id, changeRequests.restaurantId))
      .where(and(eq(restaurants.cityId, cityId), eq(changeRequests.status, 'pending')))
      .orderBy(asc(changeRequests.createdAt), asc(changeRequests.id));
    const names = await this.names(
      this.database.db,
      rows.map((row) => row.request),
    );
    return rows.map((row) => queued(row.request, row.restaurantName, names));
  }

  // AP §9.6.7 «Request view»: before and after, in any status.
  async view(requestId: string): Promise<RequestView> {
    const db = this.database.db;
    const [found] = await db
      .select({ request: changeRequests, restaurantName: restaurants.nameAr })
      .from(changeRequests)
      .innerJoin(restaurants, eq(restaurants.id, changeRequests.restaurantId))
      .where(eq(changeRequests.id, requestId));
    if (!found) throw new MerchantsRefusedError('unknown_change_request', 'no such request');
    const { request } = found;
    const names = await this.names(db, [request]);
    const before = await this.currentValue(db, request);
    const after = values(
      (request.status === 'approved' ? request.approvedValue : request.pendingValue) as Stored,
    );
    let parentName: string | null = null;
    let item: RequestView['item'] = null;
    if (request.targetType === 'item') {
      const [row] = await db
        .select({ item: items, category: categories.name })
        .from(items)
        .innerJoin(categories, eq(categories.id, items.categoryId))
        .where(eq(items.id, request.targetId));
      if (row) {
        parentName = row.category;
        item = {
          name: row.item.name,
          description: row.item.description,
          photoKey: row.item.photoKey,
          price: { amount: row.item.price, currency: row.item.currency },
        };
      }
    } else if (request.targetType === 'option') {
      const [row] = await db
        .select({ name: optionGroups.name })
        .from(options)
        .innerJoin(optionGroups, eq(optionGroups.id, options.groupId))
        .where(eq(options.id, request.targetId));
      parentName = row?.name ?? null;
    }
    const itemIds = [...new Set([...(before?.itemIds ?? []), ...(after.itemIds ?? [])])];
    const itemNames =
      itemIds.length === 0
        ? []
        : await db
            .select({ id: items.id, name: items.name })
            .from(items)
            .where(inArray(items.id, itemIds));
    return {
      ...queued(request, found.restaurantName, names),
      status: request.status,
      before,
      after,
      parentName,
      item,
      itemNames,
    };
  }

  // RA §9.5 «Approve»: the change publishes at once, the text corrected
  // first when the reviewer did; audited, the owners told (RA §16 #22).
  async approve(requestId: string, correction: Correction, change: MerchantChange): Promise<void> {
    const restaurantId = await this.restaurantOf(requestId);
    await this.database.db.transaction(async (tx) => {
      const row = await this.editor.lockEditable(tx, restaurantId);
      const request = await this.lockRequest(tx, requestId);
      if (request.status !== 'pending') {
        throw new MerchantsRefusedError('request_not_pending', 'the request was decided');
      }
      const asked = request.pendingValue as Stored;
      const value: Stored = { ...asked, ...this.corrected(request, correction) };
      const before = await this.currentValue(tx, request);
      await this.publish(tx, request, value);
      await tx
        .update(changeRequests)
        .set({
          status: 'approved',
          approvedValue: value,
          reviewedById: change.actor.id,
          reviewedAt: sql`now()`,
          updatedAt: sql`now()`,
        })
        .where(eq(changeRequests.id, requestId));
      await this.record(tx, change, row.cityId, 'menu.change_request.approve', request, before, {
        value,
        corrected: Object.keys(this.corrected(request, correction)).length > 0,
      });
      await this.editor.menuChanged(tx, restaurantId, row.cityId);
      const names = await this.names(tx, [{ ...request, pendingValue: value }]);
      await recordStateChange(tx, this.jobs, {
        restaurantId,
        cityId: row.cityId,
        kind: 'menu_change_approved',
        at: new Date(),
        values: { requestId, name: names.get(request.id) ?? '' },
      });
    });
  }

  // RA §9.5 «Reject»: needs a reason, which the restaurant sees; a new row
  // goes with it.
  async reject(requestId: string, reason: string, change: MerchantChange): Promise<void> {
    const text = reason.trim();
    if (text.length === 0 || text.length > REJECTION_REASON_MAX) {
      throw new MerchantsRefusedError(
        'invalid_menu',
        `a reason of ${REJECTION_REASON_MAX} characters at most`,
      );
    }
    const restaurantId = await this.restaurantOf(requestId);
    await this.database.db.transaction(async (tx) => {
      const row = await this.editor.lockEditable(tx, restaurantId);
      const request = await this.lockRequest(tx, requestId);
      const names = await this.names(tx, [request]);
      await this.close(tx, row.cityId, request, 'rejected', text, change);
      await this.editor.menuChanged(tx, restaurantId, row.cityId);
      await recordStateChange(tx, this.jobs, {
        restaurantId,
        cityId: row.cityId,
        kind: 'menu_change_rejected',
        at: new Date(),
        values: { requestId, name: names.get(request.id) ?? '', reason: text },
      });
    });
  }

  // Only a request's text, and only where it asks one, may be corrected.
  private corrected(request: RequestRow, correction: Correction): Stored {
    const out: Stored = {};
    const named = request.field === 'created' || request.field === 'name';
    const described =
      request.field === 'description' ||
      (request.field === 'created' && request.targetType === 'item');
    if (correction.name !== undefined) {
      if (!named) throw new MerchantsRefusedError('invalid_menu', 'this request has no name');
      out.name = checkedName(correction.name);
    }
    if (correction.description !== undefined) {
      if (!described) {
        throw new MerchantsRefusedError('invalid_menu', 'this request has no description');
      }
      out.description = checkedDescription(correction.description);
    }
    return out;
  }

  // Publishes an approved request's value.
  private async publish(tx: Tx, request: RequestRow, value: Stored): Promise<void> {
    const id = request.targetId;
    switch (`${request.targetType}.${request.field}`) {
      case 'category.created':
        await tx
          .update(categories)
          .set({
            name: value.name!,
            published: true,
            position: await nextPosition(
              tx,
              categories,
              eq(categories.restaurantId, request.restaurantId),
            ),
            updatedAt: sql`now()`,
          })
          .where(eq(categories.id, id));
        return;
      case 'category.name':
        await tx
          .update(categories)
          .set({ name: value.name!, updatedAt: sql`now()` })
          .where(eq(categories.id, id));
        return;
      case 'item.created': {
        const [category] = await tx
          .select({ published: categories.published })
          .from(categories)
          .innerJoin(items, eq(items.categoryId, categories.id))
          .where(eq(items.id, id));
        if (!category?.published) {
          throw new MerchantsRefusedError('category_pending', 'its category waits for review');
        }
        const [item] = await tx
          .select({ categoryId: items.categoryId })
          .from(items)
          .where(eq(items.id, id));
        await tx
          .update(items)
          .set({
            name: value.name!,
            description: value.description ?? null,
            published: true,
            position: await nextPosition(tx, items, eq(items.categoryId, item!.categoryId)),
            updatedAt: sql`now()`,
          })
          .where(eq(items.id, id));
        return;
      }
      case 'item.name':
        await tx
          .update(items)
          .set({ name: value.name!, updatedAt: sql`now()` })
          .where(eq(items.id, id));
        return;
      case 'item.description':
        await tx
          .update(items)
          .set({ description: value.description ?? null, updatedAt: sql`now()` })
          .where(eq(items.id, id));
        return;
      case 'item.photo':
        await tx
          .update(items)
          .set({ photoKey: value.photoKey ?? null, updatedAt: sql`now()` })
          .where(eq(items.id, id));
        return;
      case 'option_group.created':
        await tx
          .update(optionGroups)
          .set({ name: value.name!, published: true, updatedAt: sql`now()` })
          .where(eq(optionGroups.id, id));
        await tx
          .update(options)
          .set({ published: true, updatedAt: sql`now()` })
          .where(and(eq(options.groupId, id), isNull(options.deletedAt)));
        await this.groups.linkItemsIn(
          tx,
          id,
          await this.liveItems(tx, request.restaurantId, value.itemIds ?? []),
        );
        return;
      case 'option_group.name':
        await tx
          .update(optionGroups)
          .set({ name: value.name!, updatedAt: sql`now()` })
          .where(eq(optionGroups.id, id));
        return;
      case 'option_group.choices': {
        const [{ count }] = (await tx
          .select({ count: sql<number>`count(*)::int` })
          .from(options)
          .where(
            and(eq(options.groupId, id), eq(options.published, true), isNull(options.deletedAt)),
          )) as [{ count: number }];
        if (value.maxChoices! > count) {
          throw new MerchantsRefusedError(
            'invalid_menu',
            'the maximum choices are at most the published options: approve the new ones first',
          );
        }
        await tx
          .update(optionGroups)
          .set({
            minChoices: value.minChoices!,
            maxChoices: value.maxChoices!,
            updatedAt: sql`now()`,
          })
          .where(eq(optionGroups.id, id));
        return;
      }
      case 'option_group.items':
        await this.groups.linkItemsIn(
          tx,
          id,
          await this.liveItems(tx, request.restaurantId, value.itemIds ?? []),
        );
        return;
      case 'option.created': {
        const [group] = await tx
          .select({ published: optionGroups.published })
          .from(optionGroups)
          .where(eq(optionGroups.id, value.groupId!));
        if (!group?.published) {
          throw new MerchantsRefusedError('group_pending', 'its group waits for review');
        }
        await tx
          .update(options)
          .set({
            name: value.name!,
            published: true,
            position: await nextPosition(tx, options, eq(options.groupId, value.groupId!)),
            updatedAt: sql`now()`,
          })
          .where(eq(options.id, id));
        return;
      }
      case 'option.name':
        await tx
          .update(options)
          .set({ name: value.name!, updatedAt: sql`now()` })
          .where(eq(options.id, id));
        return;
      default:
        throw new Error(`no such request ${request.targetType}.${request.field}`);
    }
  }

  // Closes a pending request (withdrawn or rejected); a new row is
  // soft-deleted, and a new category takes its new items with it.
  private async close(
    tx: Tx,
    cityId: string,
    request: RequestRow,
    status: 'withdrawn' | 'rejected',
    reason: string | null,
    change: MerchantChange,
  ): Promise<void> {
    if (request.status !== 'pending') {
      throw new MerchantsRefusedError('request_not_pending', 'the request was decided');
    }
    await tx
      .update(changeRequests)
      .set({
        status,
        rejectionReason: reason,
        ...(status === 'rejected' ? { reviewedById: change.actor.id, reviewedAt: sql`now()` } : {}),
        updatedAt: sql`now()`,
      })
      .where(eq(changeRequests.id, request.id));
    await this.record(
      tx,
      change,
      cityId,
      `menu.change_request.${status === 'rejected' ? 'reject' : 'withdraw'}`,
      request,
      null,
      { value: request.pendingValue, reason },
    );
    if (request.field !== 'created') return;
    const id = request.targetId;
    switch (request.targetType) {
      case 'category': {
        await tx
          .update(categories)
          .set({ deletedAt: sql`now()` })
          .where(eq(categories.id, id));
        const waiting = await tx
          .select({ id: items.id })
          .from(items)
          .where(
            and(eq(items.categoryId, id), eq(items.published, false), isNull(items.deletedAt)),
          );
        for (const item of waiting) {
          const [created] = await this.pendingOf(tx, { type: 'item', id: item.id }, 'created');
          if (created) await this.close(tx, cityId, created, status, reason, change);
        }
        return;
      }
      case 'item':
        await tx
          .update(items)
          .set({ deletedAt: sql`now()` })
          .where(eq(items.id, id));
        return;
      case 'option_group':
        await tx
          .update(optionGroups)
          .set({ deletedAt: sql`now()` })
          .where(eq(optionGroups.id, id));
        await tx
          .update(options)
          .set({ deletedAt: sql`now()` })
          .where(and(eq(options.groupId, id), isNull(options.deletedAt)));
        return;
      case 'option':
        await tx
          .update(options)
          .set({ deletedAt: sql`now()` })
          .where(eq(options.id, id));
        return;
    }
  }

  // Asks a field's value: replaces the pending one, or adds it. The same
  // value again writes nothing.
  private async ask(
    tx: Tx,
    cityId: string,
    restaurantId: string,
    target: Target,
    field: ChangeField,
    value: Stored,
    change: MerchantChange,
  ): Promise<void> {
    const [pending] = await this.pendingOf(tx, target, field);
    if (pending && JSON.stringify(pending.pendingValue) === JSON.stringify(value)) return;
    const requestedById = change.actor.id!;
    let request: RequestRow;
    if (pending) {
      [request] = (await tx
        .update(changeRequests)
        .set({ pendingValue: value, requestedById, updatedAt: sql`now()` })
        .where(eq(changeRequests.id, pending.id))
        .returning()) as [RequestRow];
    } else {
      [request] = (await tx
        .insert(changeRequests)
        .values({
          restaurantId,
          targetType: target.type,
          targetId: target.id,
          field,
          pendingValue: value,
          requestedById,
        })
        .returning()) as [RequestRow];
    }
    await this.record(
      tx,
      change,
      cityId,
      'menu.change_request',
      request,
      pending ? { value: pending.pendingValue } : null,
      { value },
    );
    await this.editor.menuChanged(tx, restaurantId, cityId);
  }

  // A published field: the published value again withdraws its request.
  private async askOrDrop(
    tx: Tx,
    cityId: string,
    restaurantId: string,
    target: Target,
    field: ChangeField,
    asPublished: boolean,
    value: Stored,
    change: MerchantChange,
  ): Promise<void> {
    if (!asPublished) {
      await this.ask(tx, cityId, restaurantId, target, field, value, change);
      return;
    }
    const [pending] = await this.pendingOf(tx, target, field);
    if (!pending) return;
    await this.close(tx, cityId, pending, 'withdrawn', null, change);
    await this.editor.menuChanged(tx, restaurantId, cityId);
  }

  private pendingOf(tx: Tx, target: Target, field: ChangeField) {
    return tx
      .select()
      .from(changeRequests)
      .where(
        and(
          eq(changeRequests.targetType, target.type),
          eq(changeRequests.targetId, target.id),
          eq(changeRequests.field, field),
          eq(changeRequests.status, 'pending'),
        ),
      )
      .for('update');
  }

  private async lockRequest(tx: Tx, requestId: string): Promise<RequestRow> {
    const [request] = await tx
      .select()
      .from(changeRequests)
      .where(eq(changeRequests.id, requestId))
      .for('update');
    if (!request) throw new MerchantsRefusedError('unknown_change_request', 'no such request');
    return request;
  }

  private async restaurantOf(requestId: string): Promise<string> {
    const [request] = await this.database.db
      .select({ restaurantId: changeRequests.restaurantId })
      .from(changeRequests)
      .where(eq(changeRequests.id, requestId));
    if (!request) throw new MerchantsRefusedError('unknown_change_request', 'no such request');
    return request.restaurantId;
  }

  private async ownItem(tx: Tx, restaurantId: string, itemId: string) {
    const [item] = await tx
      .select()
      .from(items)
      .where(
        and(eq(items.id, itemId), eq(items.restaurantId, restaurantId), isNull(items.deletedAt)),
      );
    if (!item) throw new MerchantsRefusedError('unknown_menu_row', 'no such item here');
    return item;
  }

  // Links an owner's photo upload; the same upload again is a repeat when it
  // is the photo already asked, `upload_used` otherwise.
  private async linkPhoto(tx: Tx, uploadId: string, current: string | null): Promise<string> {
    const { key, alreadyLinked } = await this.files.link(tx, uploadId);
    if (alreadyLinked && key !== current) {
      throw new MerchantsRefusedError('upload_used', 'the upload is linked elsewhere');
    }
    return key;
  }

  private async linkedItems(tx: Tx, groupId: string): Promise<string[]> {
    const rows = await tx
      .select({ itemId: itemOptionGroups.itemId })
      .from(itemOptionGroups)
      .innerJoin(items, eq(items.id, itemOptionGroups.itemId))
      .where(
        and(
          eq(itemOptionGroups.groupId, groupId),
          isNull(itemOptionGroups.removedAt),
          isNull(items.deletedAt),
        ),
      );
    return rows.map((row) => row.itemId);
  }

  // The items of a request still live when it is approved.
  private async liveItems(tx: Tx, restaurantId: string, itemIds: string[]): Promise<string[]> {
    if (itemIds.length === 0) return [];
    const rows = await tx
      .select({ id: items.id })
      .from(items)
      .where(
        and(
          inArray(items.id, itemIds),
          eq(items.restaurantId, restaurantId),
          isNull(items.deletedAt),
        ),
      );
    return itemIds.filter((id) => rows.some((row) => row.id === id));
  }

  // A published field's value now, beside a request on it; null for a new row.
  private async currentValue(
    db: Pick<Tx, 'select'>,
    request: RequestRow,
  ): Promise<ChangeValues | null> {
    const id = request.targetId;
    switch (request.targetType) {
      case 'category': {
        if (request.field === 'created') return null;
        const [row] = await db.select().from(categories).where(eq(categories.id, id));
        return row ? values({ name: row.name }) : null;
      }
      case 'item': {
        if (request.field === 'created') return null;
        const [row] = await db.select().from(items).where(eq(items.id, id));
        if (!row) return null;
        if (request.field === 'name') return values({ name: row.name });
        if (request.field === 'description') return values({ description: row.description });
        return values({ photoKey: row.photoKey });
      }
      case 'option_group': {
        if (request.field === 'created') return null;
        const [row] = await db.select().from(optionGroups).where(eq(optionGroups.id, id));
        if (!row) return null;
        if (request.field === 'name') return values({ name: row.name });
        if (request.field === 'choices') {
          return values({ minChoices: row.minChoices, maxChoices: row.maxChoices });
        }
        const linked = await db
          .select({ itemId: itemOptionGroups.itemId })
          .from(itemOptionGroups)
          .where(and(eq(itemOptionGroups.groupId, id), isNull(itemOptionGroups.removedAt)));
        return values({ itemIds: linked.map((link) => link.itemId) });
      }
      case 'option': {
        if (request.field === 'created') return null;
        const [row] = await db.select().from(options).where(eq(options.id, id));
        return row ? values({ name: row.name }) : null;
      }
    }
  }

  // Each request's row name as the restaurant knows it: a new row's or a
  // rename's asked name, the row's name otherwise.
  private async names(
    db: Pick<Tx, 'select'>,
    requests: Pick<RequestRow, 'id' | 'targetType' | 'targetId' | 'field' | 'pendingValue'>[],
  ): Promise<Map<string, string>> {
    const ids = (type: ChangeTargetType) =>
      requests.filter((request) => request.targetType === type).map((r) => r.targetId);
    const lookup = async (
      table: typeof categories | typeof items | typeof optionGroups | typeof options,
      list: string[],
    ) =>
      list.length === 0
        ? []
        : await db
            .select({ id: table.id, name: table.name })
            .from(table)
            .where(inArray(table.id, list));
    const rows = [
      ...(await lookup(categories, ids('category'))),
      ...(await lookup(items, ids('item'))),
      ...(await lookup(optionGroups, ids('option_group'))),
      ...(await lookup(options, ids('option'))),
    ];
    return new Map(
      requests.map((request) => {
        const asked = (request.pendingValue as Stored).name;
        const own = rows.find((row) => row.id === request.targetId)?.name ?? '';
        return [request.id, request.field === 'created' ? (asked ?? own) : own];
      }),
    );
  }

  private async record(
    tx: Tx,
    change: MerchantChange,
    cityId: string,
    action: string,
    request: RequestRow,
    before: object | null,
    after: Record<string, unknown>,
  ): Promise<void> {
    await this.audit.recordWrite(
      {
        actor: change.actor,
        context: change.context,
        cityId,
        action,
        target: { type: auditType(request.targetType), id: request.targetId },
        before: before === null ? null : forAudit({ ...before }),
        after: forAudit({
          restaurantId: request.restaurantId,
          requestId: request.id,
          field: request.field,
          ...after,
        }),
        reason: change.reason ?? null,
      },
      tx,
    );
  }
}

function queued(
  request: RequestRow,
  restaurantName: string,
  names: Map<string, string>,
): QueuedRequest {
  return {
    id: request.id,
    restaurantId: request.restaurantId,
    restaurantName,
    targetType: request.targetType,
    targetId: request.targetId,
    field: request.field as ChangeField,
    targetName: names.get(request.id) ?? '',
    createdAt: request.createdAt,
  };
}

function pendingChange(request: RequestRow): PendingChange {
  return {
    requestId: request.id,
    field: request.field as ChangeField,
    createdAt: request.createdAt,
    ...values(request.pendingValue as Stored),
  };
}

function values(value: Stored): ChangeValues {
  return {
    name: value.name ?? null,
    description: value.description ?? null,
    photoKey: value.photoKey ?? null,
    price: value.price ? money(value.price) : value.priceDelta ? money(value.priceDelta) : null,
    categoryId: value.categoryId ?? null,
    groupId: value.groupId ?? null,
    minChoices: value.minChoices ?? null,
    maxChoices: value.maxChoices ?? null,
    itemIds: value.itemIds ?? null,
    options:
      value.options?.map((option) => ({
        id: option.id,
        name: option.name,
        priceDelta: money(option.priceDelta),
      })) ?? null,
  };
}

// The next position at the end of a list.
async function nextPosition(
  tx: Tx,
  table: typeof categories | typeof items | typeof options,
  where: ReturnType<typeof eq>,
): Promise<number> {
  const [row] = await tx
    .select({ last: max(table.position) })
    .from(table)
    .where(where);
  return (row?.last ?? -1) + 1;
}

function sameSet(current: string[], wanted: string[]): boolean {
  return current.length === wanted.length && wanted.every((id) => current.includes(id));
}

function checkedName(value: string): string {
  const text = value.trim();
  if (text.length === 0 || text.length > MENU_NAME_MAX) {
    throw new MerchantsRefusedError(
      'invalid_menu',
      `a name of ${MENU_NAME_MAX} characters at most`,
    );
  }
  return text;
}

function checkedDescription(value: string | null): string | null {
  const text = value?.trim() ?? '';
  if (text.length > MENU_DESCRIPTION_MAX) {
    throw new MerchantsRefusedError(
      'invalid_menu',
      `a description is ${MENU_DESCRIPTION_MAX} characters at most`,
    );
  }
  return text.length === 0 ? null : text;
}
