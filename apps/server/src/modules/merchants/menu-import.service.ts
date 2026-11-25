import { randomUUID } from 'node:crypto';
import { Inject, Injectable } from '@nestjs/common';
import { and, eq, inArray, isNull, sql } from 'drizzle-orm';
import type { CellValue } from 'exceljs';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { newWorkbook } from '../../workbooks/new-workbook.js';
import { AuditService } from '../audit/index.js';
import { FilesService } from '../files/index.js';
import { FxService } from '../fx/index.js';
import { keep, replay, requestHash } from './menu-bulk.service.js';
import { type MenuChange, MenuEditorService, type PriceChange } from './menu-editor.service.js';
import {
  IMPORT_HEADERS,
  IMPORT_MAX_ROWS,
  IMPORT_MAX_UNZIPPED,
  type ImportMenu,
  type ImportPlan,
  planImport,
  unzippedSize,
} from './menu-import.js';
import {
  forAudit,
  type MerchantChange,
  MerchantsRefusedError,
  MerchantsService,
  type Tx,
} from './merchants.service.js';
import { OptionGroupsService } from './option-groups.service.js';
import { categories, itemOptionGroups, items } from './schema.js';

// The commit's transaction, or the pool for the template and the dry run.
type Reader = Tx | Database['db'];

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
    const menu = await this.importMenu(
      this.database.db,
      restaurantId,
      await this.cityOf(restaurantId),
    );
    const workbook = await newWorkbook();
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
    const cityId = await this.cityOf(restaurantId);
    const sheet = await this.rows(uploadId);
    return this.plan(this.database.db, restaurantId, cityId, sheet);
  }

  // Applies the workbook. A repeat of the key answers its first result.
  async commit(
    restaurantId: string,
    uploadId: string,
    change: MenuChange & { accountId: string; idempotencyKey: string },
  ): Promise<ImportResult> {
    const hash = requestHash({ kind: 'menu_import', restaurantId, uploadId });
    const sheet = await this.rows(uploadId);
    return this.database.db.transaction(async (tx) => {
      const row = await this.editor.lockEditable(tx, restaurantId);
      await this.editor.menuChanged(tx, restaurantId, row.cityId);
      const kept = await replay(tx, change.accountId, change.idempotencyKey, hash);
      if (kept !== null) return kept as ImportResult;
      const plan = await this.plan(tx, restaurantId, row.cityId, sheet);
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
        // Only a changed category moves the item (to its new category's end).
        const moved = changed.fields.includes('category');
        const categoryId = moved ? categoryIds.get(changed.next.categoryName)! : null;
        await tx
          .update(items)
          .set({
            ...(categoryId === null
              ? {}
              : { categoryId, position: await this.endOf(tx, categoryId) }),
            name: changed.next.name,
            description: changed.next.description,
            price: changed.next.price,
            currency: base,
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
          { ...(categoryId === null ? {} : { categoryId }), ...changed.next },
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

  // The workbook's first sheet as text cells with their sheet row numbers,
  // after files checked it. A workbook that would unzip beyond
  // IMPORT_MAX_UNZIPPED bytes is refused before it is read (a zip bomb), and
  // only the first filled rows past the limit are kept.
  private async rows(uploadId: string): Promise<{ rows: string[][]; numbers: number[] }> {
    await this.files.prepare(uploadId, 'menu_import');
    const bytes = await this.files.preparedBytes(uploadId);
    const size = unzippedSize(bytes);
    if (size === null || size > IMPORT_MAX_UNZIPPED) {
      throw new MerchantsRefusedError('import_unreadable', 'the workbook is not a small zip');
    }
    const workbook = await newWorkbook();
    try {
      await workbook.xlsx.load(bytes as unknown as ArrayBuffer);
    } catch {
      throw new MerchantsRefusedError('import_unreadable', 'the file is not a readable workbook');
    }
    const sheet = workbook.worksheets[0];
    const rows: string[][] = [];
    const numbers: number[] = [];
    sheet?.eachRow((row, number) => {
      if (rows.length > IMPORT_MAX_ROWS + 1) return;
      const cells: string[] = [];
      for (let column = 1; column <= IMPORT_HEADERS.length + 4; column += 1) {
        cells.push(textOf(row.getCell(column).value));
      }
      rows.push(cells);
      numbers.push(number);
    });
    return { rows, numbers };
  }

  private async plan(
    executor: Reader,
    restaurantId: string,
    cityId: string,
    sheet: { rows: string[][]; numbers: number[] },
  ) {
    const menu = await this.importMenu(executor, restaurantId, cityId);
    const plan = planImport(sheet.rows, menu, sheet.numbers);
    // A code a deleted item, or one priced in another currency than the
    // base, still holds is taken (codes are unique in the restaurant).
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

  private async cityOf(restaurantId: string): Promise<string> {
    const found = await this.merchants.cityAndStatus(restaurantId);
    if (found === null) throw new MerchantsRefusedError('unknown_restaurant', 'no such restaurant');
    if (found.accountStatus === 'terminated') {
      throw new MerchantsRefusedError('restaurant_terminated', 'the restaurant is terminated');
    }
    return found.cityId;
  }

  // The published menu through the executor (the commit's transaction under
  // the restaurant's lock, so no pool read runs inside it). An item still
  // priced in another currency than the base is left out: the template and
  // the prices are the base's.
  private async importMenu(
    executor: Reader,
    restaurantId: string,
    cityId: string,
  ): Promise<ImportMenu> {
    const base = await this.fx.baseCurrency(cityId, executor);
    const decimals =
      (await this.fx.currencies(executor)).find((currency) => currency.code === base)?.decimals ??
      2;
    const now = new Date();
    const menu = await this.merchants.menu(restaurantId, now, executor);
    const groups = await this.groups.groups(restaurantId, now, executor);
    return {
      decimals,
      categories: menu.categories.map((category) => ({ id: category.id, name: category.name })),
      items: menu.categories.flatMap((category) =>
        category.items
          .filter((item) => item.price.currency === base)
          .map((item) => ({
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
      .where(
        and(
          eq(categories.restaurantId, restaurantId),
          eq(categories.published, true),
          isNull(categories.deletedAt),
        ),
      );
    // The plan refuses a name two of them share, so each name is one row.
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
function textOf(value: CellValue): string {
  if (value === null || value === undefined) return '';
  if (typeof value === 'string') return value;
  if (typeof value === 'number' || typeof value === 'boolean') return String(value);
  if (value instanceof Date) return value.toISOString();
  if (typeof value === 'object' && 'richText' in value) {
    return value.richText.map((part) => part.text).join('');
  }
  if (typeof value === 'object' && 'result' in value) return textOf(value.result as CellValue);
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
