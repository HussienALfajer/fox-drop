import { createHash } from 'node:crypto';
import { Inject, Injectable } from '@nestjs/common';
import { and, asc, eq, isNull, lt, sql } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { AuditService } from '../audit/index.js';
import { FxService, type RoundingMode } from '../fx/index.js';
import { SettingsService } from '../settings/index.js';
import { type BulkPriceChange, bulkPrices } from './bulk-price.js';
import { type MenuChange, MenuEditorService } from './menu-editor.service.js';
import {
  forAudit,
  type MerchantChange,
  MerchantsRefusedError,
  MerchantsService,
  type Tx,
} from './merchants.service.js';
import { categories, idempotencyKeys, items } from './schema.js';

// Architecture §5.3: a key answers its command for 24 hours.
const KEY_LIFETIME_MS = 24 * 60 * 60 * 1000;

// «تعديل جماعي» for the whole menu or one category.
export type BulkScope = { categoryId: string | null };

// One item of the preview: its price before and after.
export interface BulkPreviewRow {
  itemId: string;
  code: string;
  name: string;
  categoryId: string;
  before: bigint;
  after: bigint | null;
}

export interface BulkPreview {
  currency: string;
  roundingUnit: bigint;
  // Every item of the scope; `after` null where the change would bring the
  // price to 0 or below (refused).
  rows: BulkPreviewRow[];
  changed: number;
  unchanged: number;
  refused: number;
}

// The menu editor's bulk changes (AP §9.6.6 «تعديل جماعي», «توفر جماعي»;
// slice 2.31). A bulk price change is previewed, then applied with its
// Idempotency-Key: the same input recomputed under the restaurant's lock, one
// price log row per changed item and one summary to the owners.
@Injectable()
export class MenuBulkService {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly editor: MenuEditorService,
    private readonly merchants: MerchantsService,
    private readonly audit: AuditService,
    private readonly fx: FxService,
    private readonly settings: SettingsService,
  ) {}

  // What the change would do, writing nothing (no lock: a read).
  async preview(restaurantId: string, scope: BulkScope, change: BulkPriceChange) {
    const found = await this.merchants.cityAndStatus(restaurantId);
    if (found === null) throw new MerchantsRefusedError('unknown_restaurant', 'no such restaurant');
    if (found.accountStatus === 'terminated') {
      throw new MerchantsRefusedError('restaurant_terminated', 'the restaurant is terminated');
    }
    return this.compute(this.database.db, restaurantId, found.cityId, scope, change);
  }

  // Applies the change: past test mode with `menus.edit_prices`; refused
  // whole while one price would reach 0 (`price_reaches_zero`). Audited as
  // menu.bulk_price. A repeat of the key within 24 hours answers its first
  // result; another command with it is `idempotency_key_reused`.
  async apply(
    restaurantId: string,
    scope: BulkScope,
    change: BulkPriceChange,
    menuChange: MenuChange & { accountId: string; idempotencyKey: string },
  ): Promise<{ changed: number; unchanged: number }> {
    const hash = requestHash({ kind: 'bulk_price', restaurantId, scope, change });
    return this.database.db.transaction(async (tx) => {
      const row = await this.editor.lockEditable(tx, restaurantId);
      const kept = await replay(tx, menuChange.accountId, menuChange.idempotencyKey, hash);
      if (kept !== null) return kept as { changed: number; unchanged: number };
      MenuEditorService.checkPriceEdit(row.accountStatus, menuChange);
      const preview = await this.compute(tx, restaurantId, row.cityId, scope, change);
      if (preview.refused > 0) {
        throw new MerchantsRefusedError(
          'price_reaches_zero',
          `${preview.refused} prices would reach 0`,
        );
      }
      const changed = preview.rows.filter(
        (each) => each.after !== null && each.after !== each.before,
      );
      for (const each of changed) {
        await tx
          .update(items)
          .set({ price: each.after!, updatedAt: sql`now()` })
          .where(eq(items.id, each.itemId));
      }
      const result = { changed: changed.length, unchanged: preview.unchanged };
      if (changed.length > 0) {
        await this.audit.recordWrite(
          {
            actor: menuChange.actor,
            context: menuChange.context,
            cityId: row.cityId,
            action: 'menu.bulk_price',
            target: { type: 'restaurant', id: restaurantId },
            before: null,
            after: forAudit({
              scope,
              change,
              currency: preview.currency,
              items: changed.map((each) => ({
                itemId: each.itemId,
                before: each.before,
                after: each.after,
              })),
            }),
            reason: menuChange.reason ?? null,
          },
          tx,
        );
        await this.editor.logPrices(
          tx,
          restaurantId,
          row,
          changed.map((each) => ({
            target: { type: 'item' as const, id: each.itemId },
            name: each.name,
            old: { amount: each.before, currency: preview.currency },
            new: { amount: each.after!, currency: preview.currency },
          })),
          menuChange,
        );
      }
      await keep(tx, menuChange.accountId, menuChange.idempotencyKey, hash, result);
      return result;
    });
  }

  // AP §9.6.6 «توفر جماعي»: many items on, or off «حتى الغد» or «حتى أعيده»,
  // each audited as its own switch. It sets a value, so it takes no key.
  async setItemsAvailability(
    restaurantId: string,
    itemIds: string[],
    availability: { available: true } | { available: false; until: 'tomorrow' | 'turned_back_on' },
    change: MerchantChange,
  ): Promise<void> {
    if (itemIds.length === 0 || new Set(itemIds).size !== itemIds.length) {
      throw new MerchantsRefusedError('invalid_menu', 'name one item or more, each once');
    }
    await this.merchants.setAvailabilities(
      restaurantId,
      itemIds.map((id) => ({ type: 'item' as const, id })),
      availability,
      change,
    );
  }

  private async compute(
    tx: Tx | Database['db'],
    restaurantId: string,
    cityId: string,
    scope: BulkScope,
    change: BulkPriceChange,
  ): Promise<BulkPreview> {
    const rounding = await this.rounding(tx, cityId);
    if (scope.categoryId !== null) {
      const [category] = await tx
        .select({ id: categories.id })
        .from(categories)
        .where(
          and(
            eq(categories.id, scope.categoryId),
            eq(categories.restaurantId, restaurantId),
            isNull(categories.deletedAt),
          ),
        );
      if (!category) throw new MerchantsRefusedError('unknown_menu_row', 'no such category here');
    }
    const rows = await tx
      .select({
        id: items.id,
        code: items.code,
        name: items.name,
        categoryId: items.categoryId,
        price: items.price,
        currency: items.currency,
      })
      .from(items)
      .innerJoin(categories, eq(categories.id, items.categoryId))
      .where(
        and(
          eq(items.restaurantId, restaurantId),
          eq(items.published, true),
          isNull(items.deletedAt),
          isNull(categories.deletedAt),
          ...(scope.categoryId === null ? [] : [eq(items.categoryId, scope.categoryId)]),
        ),
      )
      .orderBy(asc(categories.position), asc(items.position), asc(items.id));
    // A price kept in another currency than the base (before the first order
    // locked it) is left out: the rounding is the base's.
    const inBase = rows.filter((each) => each.currency === rounding.currency);
    let result;
    try {
      result = bulkPrices(
        inBase.map((each) => ({ id: each.id, price: each.price })),
        change,
        rounding,
      );
    } catch (error) {
      if (error instanceof RangeError) {
        throw new MerchantsRefusedError('invalid_menu', error.message);
      }
      throw error;
    }
    const after = new Map(result.rows.map((each) => [each.id, each.after]));
    return {
      currency: rounding.currency,
      roundingUnit: rounding.unit,
      rows: inBase.map((each) => ({
        itemId: each.id,
        code: each.code,
        name: each.name,
        categoryId: each.categoryId,
        before: each.price,
        after: after.get(each.id) ?? null,
      })),
      changed: result.rows.length - result.unchanged,
      unchanged: result.unchanged,
      refused: result.refused.length,
    };
  }

  // The base's rounding unit and mode (D14), as fx reads them.
  private async rounding(
    tx: Tx | Database['db'],
    cityId: string,
  ): Promise<{ currency: string; unit: bigint; mode: RoundingMode }> {
    const currency = await this.fx.baseCurrency(cityId, tx);
    if (currency === null) {
      throw new MerchantsRefusedError('not_in_base_currency', 'the city has no base currency');
    }
    const target = { cityId, parameter: currency };
    const unit = await this.settings.get('currency.<code>.rounding_unit', target, tx);
    const mode = await this.settings.get('currency.<code>.rounding_mode', target, tx);
    if (unit === null) {
      throw new MerchantsRefusedError('rounding_unit_missing', `${currency} has no rounding unit`);
    }
    return { currency, unit: BigInt(unit.amountMinor), mode: mode as RoundingMode };
  }
}

export function requestHash(command: object): string {
  return createHash('sha256')
    .update(JSON.stringify(forAudit(command)))
    .digest('hex');
}

// Module-internal: a key's kept answer within its 24 hours, null when none.
export async function replay(
  tx: Tx,
  accountId: string,
  key: string,
  hash: string,
): Promise<unknown> {
  const [row] = await tx
    .select()
    .from(idempotencyKeys)
    .where(and(eq(idempotencyKeys.accountId, accountId), eq(idempotencyKeys.key, key)));
  if (!row || row.createdAt.getTime() < Date.now() - KEY_LIFETIME_MS) return null;
  if (row.requestHash !== hash) {
    throw new MerchantsRefusedError('idempotency_key_reused', 'the key came with another command');
  }
  return row.result;
}

// Module-internal: keeps the key with its answer in the command's
// transaction; a key older than 24 hours is used again.
export async function keep(
  tx: Tx,
  accountId: string,
  key: string,
  hash: string,
  result: object,
): Promise<void> {
  const now = new Date();
  const kept = { requestHash: hash, result, createdAt: now };
  const [taken] = await tx
    .insert(idempotencyKeys)
    .values({ accountId, key, ...kept })
    .onConflictDoUpdate({
      target: [idempotencyKeys.accountId, idempotencyKeys.key],
      set: kept,
      setWhere: lt(idempotencyKeys.createdAt, new Date(now.getTime() - KEY_LIFETIME_MS)),
    })
    .returning({ key: idempotencyKeys.key });
  if (!taken) {
    throw new MerchantsRefusedError('idempotency_key_reused', 'the key came with another command');
  }
}
