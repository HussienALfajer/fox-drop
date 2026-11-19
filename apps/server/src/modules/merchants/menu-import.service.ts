import { randomUUID } from 'node:crypto';
import { Inject, Injectable } from '@nestjs/common';
import { and, eq, inArray, isNull, sql } from 'drizzle-orm';
import ExcelJS from 'exceljs';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { AuditService } from '../audit/index.js';
import { FilesService } from '../files/index.js';
import { FxService } from '../fx/index.js';
import { keep, replay, requestHash } from './menu-bulk.service.js';
import { type MenuChange, MenuEditorService, type PriceChange } from './menu-editor.service.js';
import { IMPORT_HEADERS, type ImportMenu, type ImportPlan, planImport } from './menu-import.js';
import {
  forAudit,
  type MerchantChange,
  MerchantsRefusedError,
  MerchantsService,
  type Tx,
} from './merchants.service.js';
import { OptionGroupsService } from './option-groups.service.js';
import { categories, itemOptionGroups, items } from './schema.js';

export interface ImportResult {
  added: number;
  changed: number;
  unchanged: number;
  categoriesAdded: number;
}

// AP §9.6.6 «استيراد من Excel» (slice 2.31): the template filled with the
// menu, the dry run of an uploaded workbook and its commit. The commit
// recomputes the plan under the restaurant's lock and refuses it while any
// row errs; prices past test mode need `menus.edit_prices`, and their changes
// are logged and told to the owners as one summary, like a bulk change.
@Injectable()
export class MenuImportService {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly editor: MenuEditorService,
    private readonly merchants: MerchantsService,
    private readonly groups: OptionGroupsService,
    private readonly files: FilesService,
    private readonly fx: FxService,
    private readonly audit: AuditService,
  ) {}

  // The template, filled with the current menu so a re-import changes only
  // what was edited: one right-to-left sheet, a row per item.
  async template(restaurantId: string): Promise<Buffer> {
    const menu = await this.importMenu(restaurantId);
    const workbook = new ExcelJS.Workbook();
    const sheet = workbook.addWorksheet('القائمة', { views: [{ rightToLeft: true }] });
    sheet.addRow([...IMPORT_HEADERS]);
    sheet.getRow(1).font = { bold: true };
    const categoryNames = new Map(menu.categories.map((category) => [category.id, category.name]));
    const groupNames = new Map(menu.groups.map((group) => [group.id, group.name]));
    for (const item of menu.items) {
      sheet.addRow([
        item.code,
        categoryNames.get(item.categoryId) ?? '',
        item.name,
        item.description ?? '',
        Number(majorOf(item.price, menu.decimals)),
        item.groupIds.map((id) => groupNames.get(id) ?? '').join('، '),
      ]);
    }
    sheet.columns.forEach((column) => (column.width = 24));
    return Buffer.from(await workbook.xlsx.writeBuffer());
  }

  // What the import would do, writing nothing.
  async dryRun(restaurantId: string, uploadId: string): Promise<ImportPlan> {
    const rows = await this.rows(uploadId);
    if ((await this.merchants.cityAndStatus(restaurantId))?.accountStatus === 'terminated') {
      throw new MerchantsRefusedError('restaurant_terminated', 'the restaurant is terminated');
    }
    return this.plan(this.database.db, restaurantId, rows);
  }

  // Applies the workbook. A repeat of the key answers its first result.
  async commit(
    restaurantId: string,
    uploadId: string,
    change: MenuChange & { accountId: string; idempotencyKey: string },
  ): Promise<ImportResult> {
    const hash = requestHash({ kind: 'menu_import', restaurantId, uploadId });
    const rows = await this.rows(uploadId);
    return this.database.db.transaction(async (tx) => {
      const row = await this.editor.lockEditable(tx, restaurantId);
      const kept = await replay(tx, change.accountId, change.idempotencyKey, hash);
      if (kept !== null) return kept as ImportResult;
      const plan = await this.plan(tx, restaurantId, rows);
      if (plan.fileError !== null || plan.errors.length > 0) {
        throw new MerchantsRefusedError('import_invalid', 'the workbook has errors');
      }
      if (plan.added.length > 0 || plan.changed.some((each) => each.fields.includes('price'))) {
        MenuEditorService.checkPriceEdit(row.accountStatus, change);
      }
      const linked = await this.files.link(tx, uploadId);
      if (linked.alreadyLinked) {
        throw new MerchantsRefusedError('upload_used', 'the workbook was imported already');
      }
      const base = await this.fx.baseCurrency(row.cityId, tx);
      if (base === null) {
        throw new MerchantsRefusedError('not_in_base_currency', 'the city has no base currency');
      }
      await this.merchants.checkBaseCurrency(tx, row.cityId, base);
      const categoryIds = await this.addCategories(tx, restaurantId, row.cityId, plan, change);
      const prices: PriceChange[] = [];
      const codes = new Set(
        (
          await tx
            .select({ code: items.code })
            .from(items)
            .where(eq(items.restaurantId, restaurantId))
        ).map((each) => each.code),
      );
      let next = codes.size + 1;
      for (const added of plan.added) {
        let code = added.code;
        if (code === null) {
          for (; codes.has(`I${String(next).padStart(4, '0')}`); next += 1);
          code = `I${String(next).padStart(4, '0')}`;
        }
        codes.add(code);
        const itemId = randomUUID();
        const categoryId = categoryIds.get(added.categoryName)!;
        const values = {
          categoryId,
          name: added.name,
          description: added.description,
          price: added.price,
          currency: base,
          code,
        };
        await tx.insert(items).values({
          id: itemId,
          restaurantId,
          position: await this.endOf(tx, categoryId),
          published: true,
          hidden: false,
          badge: null,
          ...values,
        });
        await this.setGroups(tx, itemId, added.groupIds);
        await this.record(tx, change, row.cityId, 'menu.item.create', 'menu_item', itemId, null, {
          restaurantId,
          ...values,
          groupIds: added.groupIds,
        });
      }
      for (const changed of plan.changed) {
        const categoryId = categoryIds.get(changed.next.categoryName)!;
        await tx
          .update(items)
          .set({
            categoryId,
            name: changed.next.name,
            description: changed.next.description,
            price: changed.next.price,
            currency: base,
            ...(changed.fields.includes('category')
              ? { position: await this.endOf(tx, categoryId) }
              : {}),
            updatedAt: sql`now()`,
          })
          .where(eq(items.id, changed.itemId));
        if (changed.fields.includes('groups')) {
          await this.setGroups(tx, changed.itemId, changed.next.groupIds);
        }
        await this.record(
          tx,
          change,
          row.cityId,
          'menu.item.update',
          'menu_item',
          changed.itemId,
          { fields: changed.fields, price: changed.oldPrice },
          { categoryId, ...changed.next },
        );
        if (changed.fields.includes('price')) {
          prices.push({
            target: { type: 'item', id: changed.itemId },
            name: changed.next.name,
            old: { amount: changed.oldPrice, currency: base },
            new: { amount: changed.next.price, currency: base },
          });
        }
      }
      const result: ImportResult = {
        added: plan.added.length,
        changed: plan.changed.length,
        unchanged: plan.unchanged,
        categoriesAdded: plan.categoriesAdded.length,
      };
      await this.record(tx, change, row.cityId, 'menu.import', 'restaurant', restaurantId, null, {
        uploadId,
        ...result,
      });
      // One change by its item, several as one summary (AP §9.6.6: «like
      // any other admin price change»).
      await this.editor.logPrices(tx, restaurantId, row, prices, change);
      await keep(tx, change.accountId, change.idempotencyKey, hash, result);
      return result;
    });
  }

  // The workbook's first sheet as text cells, after files checked it.
  private async rows(uploadId: string): Promise<string[][]> {
    await this.files.prepare(uploadId, 'menu_import');
    const workbook = new ExcelJS.Workbook();
    try {
      await workbook.xlsx.load(
        (await this.files.preparedBytes(uploadId)) as unknown as ArrayBuffer,
      );
    } catch {
      throw new MerchantsRefusedError('import_unreadable', 'the file is not a readable workbook');
    }
    const sheet = workbook.worksheets[0];
    if (!sheet) return [];
    const rows: string[][] = [];
    sheet.eachRow({ includeEmpty: true }, (row, number) => {
      const cells: string[] = [];
      for (let column = 1; column <= IMPORT_HEADERS.length + 4; column += 1) {
        cells.push(textOf(row.getCell(column).value));
      }
      rows[number - 1] = cells;
    });
    return Array.from(rows, (cells) => cells ?? []);
  }

  private async plan(executor: Tx | Database['db'], restaurantId: string, rows: string[][]) {
    const menu = await this.importMenu(restaurantId);
    const plan = planImport(rows, menu);
    // A code a deleted item still holds is taken (codes are unique in the
    // restaurant, deleted rows included).
    const codes = plan.added.flatMap((each) => (each.code === null ? [] : [each.code]));
    if (codes.length > 0) {
      const taken = new Set(
        (
          await executor
            .select({ code: items.code })
            .from(items)
            .where(and(eq(items.restaurantId, restaurantId), inArray(items.code, codes)))
        ).map((each) => each.code),
      );
      for (const each of plan.added.filter((one) => one.code !== null && taken.has(one.code))) {
        plan.errors.push({ row: each.row, column: 'code', error: 'repeated_code' });
      }
      plan.errors.sort((a, b) => a.row - b.row);
      plan.added = plan.added.filter((each) => each.code === null || !taken.has(each.code));
    }
    return plan;
  }

  private async importMenu(restaurantId: string): Promise<ImportMenu> {
    const found = await this.merchants.cityAndStatus(restaurantId);
    if (found === null) throw new MerchantsRefusedError('unknown_restaurant', 'no such restaurant');
    const base = await this.fx.baseCurrency(found.cityId);
    const decimals =
      (await this.fx.currencies()).find((currency) => currency.code === base)?.decimals ?? 2;
    const [menu, groups] = await Promise.all([
      this.merchants.menu(restaurantId),
      this.groups.groups(restaurantId),
    ]);
    return {
      decimals,
      categories: menu.categories.map((category) => ({ id: category.id, name: category.name })),
      items: menu.categories.flatMap((category) =>
        category.items.map((item) => ({
          id: item.id,
          code: item.code,
          categoryId: category.id,
          name: item.name,
          description: item.description,
          price: item.price.amount,
          groupIds: item.optionGroups.map((group) => group.id),
        })),
      ),
      groups: groups.map((group) => ({ id: group.id, name: group.name })),
    };
  }

  // The new categories at the end of the menu; every category of the plan
  // by its name.
  private async addCategories(
    tx: Tx,
    restaurantId: string,
    cityId: string,
    plan: ImportPlan,
    change: MerchantChange,
  ): Promise<Map<string, string>> {
    const live = await tx
      .select({ id: categories.id, name: categories.name })
      .from(categories)
      .where(and(eq(categories.restaurantId, restaurantId), isNull(categories.deletedAt)));
    const ids = new Map(live.map((each) => [each.name, each.id]));
    const [{ count }] = (await tx
      .select({ count: sql<number>`count(*)::int` })
      .from(categories)
      .where(eq(categories.restaurantId, restaurantId))) as [{ count: number }];
    for (const [offset, name] of plan.categoriesAdded.entries()) {
      const id = randomUUID();
      await tx.insert(categories).values({
        id,
        restaurantId,
        name,
        hidden: false,
        position: count + offset,
        published: true,
      });
      ids.set(name, id);
      await this.record(tx, change, cityId, 'menu.category.create', 'menu_category', id, null, {
        restaurantId,
        name,
        hidden: false,
        window: null,
      });
    }
    return ids;
  }

  private async endOf(tx: Tx, categoryId: string): Promise<number> {
    const [{ count }] = (await tx
      .select({ count: sql<number>`count(*)::int` })
      .from(items)
      .where(eq(items.categoryId, categoryId))) as [{ count: number }];
    return count;
  }

  // The item's groups, in order: those named linked at these positions, the
  // others unlinked.
  private async setGroups(tx: Tx, itemId: string, groupIds: string[]): Promise<void> {
    const linked = await tx
      .select({ groupId: itemOptionGroups.groupId })
      .from(itemOptionGroups)
      .where(eq(itemOptionGroups.itemId, itemId));
    await tx
      .update(itemOptionGroups)
      .set({ removedAt: sql`now()` })
      .where(and(eq(itemOptionGroups.itemId, itemId), isNull(itemOptionGroups.removedAt)));
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
  }

  private async record(
    tx: Tx,
    change: MerchantChange,
    cityId: string,
    action: string,
    type: string,
    targetId: string,
    before: Record<string, unknown> | null,
    after: Record<string, unknown>,
  ): Promise<void> {
    await this.audit.recordWrite(
      {
        actor: change.actor,
        context: change.context,
        cityId,
        action,
        target: { type, id: targetId },
        before: before === null ? null : forAudit(before),
        after: forAudit(after),
        reason: change.reason ?? null,
      },
      tx,
    );
  }
}

// A cell as text: a number as written, a rich text's words, a formula's
// result.
function textOf(value: ExcelJS.CellValue): string {
  if (value === null || value === undefined) return '';
  if (typeof value === 'string') return value;
  if (typeof value === 'number' || typeof value === 'boolean') return String(value);
  if (value instanceof Date) return value.toISOString();
  if (typeof value === 'object' && 'richText' in value) {
    return value.richText.map((part) => part.text).join('');
  }
  if (typeof value === 'object' && 'result' in value)
    return textOf(value.result as ExcelJS.CellValue);
  if (typeof value === 'object' && 'text' in value) return String(value.text);
  return '';
}

// Minor units as major units with the currency's decimals, «120» or «35.5».
export function majorOf(minor: bigint, decimals: number): string {
  const digits = minor.toString().padStart(decimals + 1, '0');
  const whole = digits.slice(0, digits.length - decimals);
  const fraction = digits.slice(digits.length - decimals).replace(/0+$/, '');
  return fraction.length === 0 ? whole : `${whole}.${fraction}`;
}
