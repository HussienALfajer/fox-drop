import { Inject, Injectable } from '@nestjs/common';
import { and, asc, eq, isNull, ne, sql } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { AuditService } from '../audit/index.js';
import {
  forAudit,
  type MerchantChange,
  MerchantsRefusedError,
  MerchantsService,
  type Money,
  type Tx,
} from './merchants.service.js';
import type { AccountStatus } from './operating-state.js';
import { categories, items } from './schema.js';

// The texts' bounds (decided by us, slice 2.30b).
export const MENU_NAME_MAX = 80;
export const MENU_DESCRIPTION_MAX = 300;
export const ITEM_CODE_MAX = 20;

// AP §9.6.6: the badges an item may carry.
export const itemBadges = ['new', 'most_ordered', 'spicy'] as const;
export type ItemBadge = (typeof itemBadges)[number];

// Step 7 edits the menu while the restaurant is onboarded: a draft or in test
// mode. Past activation the menu editor of 2.31 takes over, with the price log
// and the owners' notice of an admin's price change (AP §9.6.6, D17).
const EDITABLE: readonly AccountStatus[] = ['draft', 'test'];

// AP §9.6.6 «الفئات»: a category as the wizard saves it. The window is minutes
// after midnight on the city's clock (breakfast until 12:00 is 0 to 720); one
// whose end is not after its start crosses midnight; null is all day.
export interface CategoryFields {
  name: string;
  hidden: boolean;
  window: { startsAt: number; endsAt: number } | null;
}

// AP §9.6.6 «الأصناف»: an item as the wizard saves it. An empty code is
// generated (I0001 onward) when the item is created and kept when it is edited.
export interface ItemFields {
  categoryId: string;
  code: string | null;
  name: string;
  description: string | null;
  price: Money;
  hidden: boolean;
  badge: ItemBadge | null;
}

// The onboarding wizard's step 7 (AP §9.6.3, §9.6.6; slice 2.30b): the basic
// menu, categories and items, published at once (an admin's edit, AP
// §9.6.7). The panel names each new row's id, so a save is a set: creating
// it the first time and setting its fields after, and a retry changes
// nothing. Every write takes the restaurant's lock and is audited.
@Injectable()
export class MenuEditorService {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly merchants: MerchantsService,
    private readonly audit: AuditService,
  ) {}

  // Creates the category with this id at the end of the menu, or sets its
  // fields. Audited as menu.category.create or menu.category.update.
  async saveCategory(
    restaurantId: string,
    categoryId: string,
    fields: CategoryFields,
    change: MerchantChange,
  ): Promise<void> {
    const name = checkedText(fields.name, MENU_NAME_MAX, 'a category needs a name');
    checkWindow(fields.window);
    const after = { name, hidden: fields.hidden, window: fields.window };
    await this.database.db.transaction(async (tx) => {
      const row = await this.lockEditable(tx, restaurantId);
      const [before] = await tx
        .select({
          restaurantId: categories.restaurantId,
          name: categories.name,
          hidden: categories.hidden,
          windowStartsAt: categories.windowStartsAt,
          windowEndsAt: categories.windowEndsAt,
          deletedAt: categories.deletedAt,
        })
        .from(categories)
        .where(eq(categories.id, categoryId));
      const values = {
        name,
        hidden: fields.hidden,
        windowStartsAt: fields.window?.startsAt ?? null,
        windowEndsAt: fields.window?.endsAt ?? null,
      };
      if (!before) {
        const [{ count }] = (await tx
          .select({ count: sql<number>`count(*)::int` })
          .from(categories)
          .where(eq(categories.restaurantId, restaurantId))) as [{ count: number }];
        await tx
          .insert(categories)
          .values({ id: categoryId, restaurantId, position: count, published: true, ...values });
        await this.record(tx, change, row.cityId, 'menu.category.create', categoryId, null, {
          restaurantId,
          ...after,
        });
        return;
      }
      if (before.restaurantId !== restaurantId || before.deletedAt !== null) {
        throw new MerchantsRefusedError('unknown_menu_row', 'no such category here');
      }
      const was = {
        name: before.name,
        hidden: before.hidden,
        window:
          before.windowStartsAt === null || before.windowEndsAt === null
            ? null
            : { startsAt: before.windowStartsAt, endsAt: before.windowEndsAt },
      };
      if (JSON.stringify(was) === JSON.stringify(after)) return;
      await tx
        .update(categories)
        .set({ ...values, updatedAt: sql`now()` })
        .where(eq(categories.id, categoryId));
      await this.record(tx, change, row.cityId, 'menu.category.update', categoryId, was, after);
    });
  }

  // Creates the item with this id at the end of its category, or sets its
  // fields; a move to another category puts it at that one's end. The price
  // is above 0 in the city's base currency (RA §9.4); a code is unique in the
  // restaurant. Audited as menu.item.create or menu.item.update.
  async saveItem(
    restaurantId: string,
    itemId: string,
    fields: ItemFields,
    change: MerchantChange,
  ): Promise<void> {
    const name = checkedText(fields.name, MENU_NAME_MAX, 'an item needs a name');
    const description = optionalText(fields.description, MENU_DESCRIPTION_MAX);
    const code = fields.code?.trim() ?? '';
    if (code.length > ITEM_CODE_MAX) {
      throw new MerchantsRefusedError(
        'invalid_menu',
        `a code is ${ITEM_CODE_MAX} characters at most`,
      );
    }
    if (fields.price.amount <= 0n) {
      throw new MerchantsRefusedError('invalid_menu', 'an item price is above 0');
    }
    if (fields.badge !== null && !itemBadges.includes(fields.badge)) {
      throw new MerchantsRefusedError('invalid_menu', 'no such badge');
    }
    await this.database.db.transaction(async (tx) => {
      const row = await this.lockEditable(tx, restaurantId);
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
      const [before] = await tx
        .select({
          restaurantId: items.restaurantId,
          categoryId: items.categoryId,
          code: items.code,
          name: items.name,
          description: items.description,
          price: items.price,
          currency: items.currency,
          hidden: items.hidden,
          badge: items.badge,
          deletedAt: items.deletedAt,
        })
        .from(items)
        .where(eq(items.id, itemId));
      if (before && (before.restaurantId !== restaurantId || before.deletedAt !== null)) {
        throw new MerchantsRefusedError('unknown_menu_row', 'no such item here');
      }
      const codeTaken = async (candidate: string) =>
        (
          await tx
            .select({ id: items.id })
            .from(items)
            .where(
              and(
                eq(items.restaurantId, restaurantId),
                eq(items.code, candidate),
                ne(items.id, itemId),
              ),
            )
        ).length > 0;
      let savedCode = code.length > 0 ? code : (before?.code ?? '');
      if (code.length > 0 && code !== before?.code && (await codeTaken(code))) {
        throw new MerchantsRefusedError('item_code_taken', `the code ${code} is taken`);
      }
      const position = async () => {
        const [{ count }] = (await tx
          .select({ count: sql<number>`count(*)::int` })
          .from(items)
          .where(eq(items.categoryId, fields.categoryId))) as [{ count: number }];
        return count;
      };
      const values = {
        categoryId: fields.categoryId,
        name,
        description,
        price: fields.price.amount,
        currency: fields.price.currency,
        hidden: fields.hidden,
        badge: fields.badge,
      };
      if (!before) {
        if (savedCode.length === 0) {
          // A generated code skips the ones entered by hand.
          const [{ count }] = (await tx
            .select({ count: sql<number>`count(*)::int` })
            .from(items)
            .where(eq(items.restaurantId, restaurantId))) as [{ count: number }];
          for (let next = count + 1; ; next += 1) {
            savedCode = `I${String(next).padStart(4, '0')}`;
            if (!(await codeTaken(savedCode))) break;
          }
        }
        await tx.insert(items).values({
          id: itemId,
          restaurantId,
          code: savedCode,
          position: await position(),
          published: true,
          ...values,
        });
        await this.record(
          tx,
          change,
          row.cityId,
          'menu.item.create',
          itemId,
          null,
          forAudit({ restaurantId, ...values, code: savedCode }),
        );
        return;
      }
      const was = forAudit({
        categoryId: before.categoryId,
        name: before.name,
        description: before.description,
        price: before.price,
        currency: before.currency,
        hidden: before.hidden,
        badge: before.badge,
        code: before.code,
      });
      const after = forAudit({ ...values, code: savedCode });
      if (JSON.stringify(was) === JSON.stringify(after)) return;
      await tx
        .update(items)
        .set({
          ...values,
          code: savedCode,
          ...(before.categoryId === fields.categoryId ? {} : { position: await position() }),
          updatedAt: sql`now()`,
        })
        .where(eq(items.id, itemId));
      await this.record(tx, change, row.cityId, 'menu.item.update', itemId, was, after);
    });
  }

  // AP §9.6.6 «إعادة الترتيب»: every category of the restaurant, once each, in
  // the new order. Audited as menu.category.order.
  async orderCategories(
    restaurantId: string,
    categoryIds: string[],
    change: MerchantChange,
  ): Promise<void> {
    await this.database.db.transaction(async (tx) => {
      const row = await this.lockEditable(tx, restaurantId);
      const current = await tx
        .select({ id: categories.id })
        .from(categories)
        .where(and(eq(categories.restaurantId, restaurantId), isNull(categories.deletedAt)))
        .orderBy(asc(categories.position), asc(categories.id));
      await this.reorder(
        tx,
        categories,
        current.map((each) => each.id),
        categoryIds,
      );
      await this.record(tx, change, row.cityId, 'menu.category.order', restaurantId, null, {
        categoryIds,
      });
    });
  }

  // Every item of one category, once each, in the new order. Audited as
  // menu.item.order.
  async orderItems(
    restaurantId: string,
    categoryId: string,
    itemIds: string[],
    change: MerchantChange,
  ): Promise<void> {
    await this.database.db.transaction(async (tx) => {
      const row = await this.lockEditable(tx, restaurantId);
      const [category] = await tx
        .select({ id: categories.id })
        .from(categories)
        .where(
          and(
            eq(categories.id, categoryId),
            eq(categories.restaurantId, restaurantId),
            isNull(categories.deletedAt),
          ),
        );
      if (!category) throw new MerchantsRefusedError('unknown_menu_row', 'no such category here');
      const current = await tx
        .select({ id: items.id })
        .from(items)
        .where(and(eq(items.categoryId, categoryId), isNull(items.deletedAt)))
        .orderBy(asc(items.position), asc(items.id));
      await this.reorder(
        tx,
        items,
        current.map((each) => each.id),
        itemIds,
      );
      await this.record(tx, change, row.cityId, 'menu.item.order', categoryId, null, { itemIds });
    });
  }

  // Whether step 7 edits a restaurant's menu in this status.
  static editable(status: AccountStatus): boolean {
    return EDITABLE.includes(status);
  }

  // RA §9.3: a category or an item switched on, or off «حتى الغد» or «حتى
  // أعيده», as the restaurant app does; only while step 7 edits the menu.
  async setAvailability(
    restaurantId: string,
    target: { type: 'category' | 'item'; id: string },
    availability: { available: true } | { available: false; until: 'tomorrow' | 'turned_back_on' },
    change: MerchantChange,
  ): Promise<void> {
    await this.merchants.setAvailability(
      restaurantId,
      target,
      availability,
      change,
      new Date(),
      EDITABLE,
    );
  }

  // The restaurant under its lock, while step 7 may edit its menu.
  private async lockEditable(tx: Tx, restaurantId: string) {
    const row = await this.merchants.lockRestaurant(tx, restaurantId);
    if (!EDITABLE.includes(row.accountStatus)) {
      throw new MerchantsRefusedError(
        'menu_locked',
        'the wizard edits the menu of a draft or a restaurant in test mode only',
      );
    }
    return row;
  }

  private async reorder(
    tx: Tx,
    table: typeof categories | typeof items,
    current: string[],
    wanted: string[],
  ): Promise<void> {
    if (
      wanted.length !== current.length ||
      new Set(wanted).size !== wanted.length ||
      wanted.some((id) => !current.includes(id))
    ) {
      throw new MerchantsRefusedError('invalid_menu', 'name every row once, in the new order');
    }
    for (const [position, id] of wanted.entries()) {
      await tx
        .update(table)
        .set({ position, updatedAt: sql`now()` })
        .where(eq(table.id, id));
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
    // A reorder targets what holds the rows: the restaurant's categories or
    // one category's items.
    const type =
      action === 'menu.category.order'
        ? 'restaurant'
        : action.startsWith('menu.category') || action === 'menu.item.order'
          ? 'menu_category'
          : 'menu_item';
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

function checkedText(value: string, max: number, what: string): string {
  const text = value.trim();
  if (text.length === 0 || text.length > max) {
    throw new MerchantsRefusedError('invalid_menu', `${what} of ${max} characters at most`);
  }
  return text;
}

function optionalText(value: string | null, max: number): string | null {
  const text = value?.trim() ?? '';
  if (text.length > max) {
    throw new MerchantsRefusedError('invalid_menu', `a description is ${max} characters at most`);
  }
  return text.length === 0 ? null : text;
}

// Two whole minutes of the day; the end 1440 is midnight, and an end not after
// the start crosses midnight. A window of the whole day is no window.
export function checkWindow(window: { startsAt: number; endsAt: number } | null): void {
  if (window === null) return;
  const { startsAt, endsAt } = window;
  if (
    !Number.isInteger(startsAt) ||
    !Number.isInteger(endsAt) ||
    startsAt < 0 ||
    startsAt > 1439 ||
    endsAt < 0 ||
    endsAt > 1440 ||
    startsAt === endsAt % 1440
  ) {
    throw new MerchantsRefusedError('invalid_menu', 'a window is two different minutes of the day');
  }
}
