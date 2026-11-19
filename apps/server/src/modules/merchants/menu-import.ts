import { ITEM_CODE_MAX, MENU_DESCRIPTION_MAX, MENU_NAME_MAX } from './menu-editor.service.js';

// AP §9.6.6 «استيراد من Excel»: the template's columns, in its order, by
// their Arabic headers (the workbook's words; the panel's are its own).
export const IMPORT_COLUMNS = [
  'code',
  'category',
  'name',
  'description',
  'price',
  'groups',
] as const;
export type ImportColumn = (typeof IMPORT_COLUMNS)[number];
export const IMPORT_HEADERS: readonly string[] = [
  'رمز الصنف',
  'التصنيف',
  'الصنف',
  'الوصف',
  'السعر',
  'مجموعات الخيارات',
];

// The most rows one file takes (decided by us, slice 2.31).
export const IMPORT_MAX_ROWS = 2_000;

export type ImportRowError =
  'required' | 'too_long' | 'invalid_price' | 'repeated_code' | 'unknown_group';
export type ImportFileError = 'missing_headers' | 'no_rows' | 'too_many_rows';

// The menu the rows are checked against: its live categories, items and
// option groups, and the base currency's decimals (prices are written in
// major units).
export interface ImportMenu {
  decimals: number;
  categories: { id: string; name: string }[];
  items: {
    id: string;
    code: string;
    categoryId: string;
    name: string;
    description: string | null;
    price: bigint;
    groupIds: string[];
  }[];
  groups: { id: string; name: string }[];
}

export interface ImportItem {
  categoryName: string;
  name: string;
  description: string | null;
  price: bigint;
  groupIds: string[];
}

export interface ImportPlan {
  fileError: ImportFileError | null;
  // The sheet's row numbers, the header being row 1.
  errors: { row: number; column: ImportColumn; error: ImportRowError }[];
  // New category names, in the order of their first row: added at the end.
  categoriesAdded: string[];
  added: ({ row: number; code: string | null } & ImportItem)[];
  changed: {
    row: number;
    itemId: string;
    code: string;
    fields: ('category' | 'name' | 'description' | 'price' | 'groups')[];
    next: ImportItem;
    oldPrice: bigint;
  }[];
  unchanged: number;
}

// The pure rule: rows (the header first, cells as text) against the menu.
// A row whose code matches an item changes it; a row with a new code or none
// adds an item (a code left empty is generated); nothing is ever deleted.
// Group names are separated by commas and must name groups already made.
export function planImport(rows: readonly (readonly string[])[], menu: ImportMenu): ImportPlan {
  const plan: ImportPlan = {
    fileError: null,
    errors: [],
    categoriesAdded: [],
    added: [],
    changed: [],
    unchanged: 0,
  };
  const [header, ...body] = rows;
  const at = new Map((header ?? []).map((cell, index) => [cell.trim(), index]));
  const indexes = IMPORT_HEADERS.map((name) => at.get(name));
  if (indexes.some((index) => index === undefined)) {
    return { ...plan, fileError: 'missing_headers' };
  }
  const filled = body
    .map((cells, index) => ({ row: index + 2, cells }))
    .filter(({ cells }) => cells.some((cell) => cell.trim().length > 0));
  if (filled.length === 0) return { ...plan, fileError: 'no_rows' };
  if (filled.length > IMPORT_MAX_ROWS) return { ...plan, fileError: 'too_many_rows' };

  const byCode = new Map(menu.items.map((item) => [item.code, item]));
  const categoryNames = new Map(menu.categories.map((category) => [category.id, category.name]));
  const knownCategories = new Set(menu.categories.map((category) => category.name));
  const groupsByName = new Map(menu.groups.map((group) => [group.name, group.id]));
  const seenCodes = new Set<string>();
  for (const { row, cells } of filled) {
    const cell = (column: ImportColumn) =>
      (cells[indexes[IMPORT_COLUMNS.indexOf(column)]!] ?? '').trim();
    const error = (column: ImportColumn, kind: ImportRowError) =>
      plan.errors.push({ row, column, error: kind });
    const before = plan.errors.length;

    const code = cell('code');
    if (code.length > ITEM_CODE_MAX) error('code', 'too_long');
    else if (code.length > 0 && seenCodes.has(code)) error('code', 'repeated_code');
    if (code.length > 0) seenCodes.add(code);
    const categoryName = cell('category');
    if (categoryName.length === 0) error('category', 'required');
    else if (categoryName.length > MENU_NAME_MAX) error('category', 'too_long');
    const name = cell('name');
    if (name.length === 0) error('name', 'required');
    else if (name.length > MENU_NAME_MAX) error('name', 'too_long');
    const description = cell('description');
    if (description.length > MENU_DESCRIPTION_MAX) error('description', 'too_long');
    const price = minorOf(cell('price'), menu.decimals);
    if (price === null) error('price', 'invalid_price');
    const groupNames = cell('groups')
      .split(/[,،]/)
      .map((each) => each.trim())
      .filter((each) => each.length > 0);
    const groupIds = groupNames.map((each) => groupsByName.get(each));
    if (groupIds.some((id) => id === undefined) || new Set(groupNames).size !== groupNames.length) {
      error('groups', 'unknown_group');
    }
    if (plan.errors.length > before) continue;

    const next: ImportItem = {
      categoryName,
      name,
      description: description.length === 0 ? null : description,
      price: price!,
      groupIds: groupIds as string[],
    };
    if (!knownCategories.has(categoryName)) {
      knownCategories.add(categoryName);
      plan.categoriesAdded.push(categoryName);
    }
    const existing = code.length > 0 ? byCode.get(code) : undefined;
    if (!existing) {
      plan.added.push({ row, code: code.length > 0 ? code : null, ...next });
      continue;
    }
    const fields = (
      [
        ['category', categoryNames.get(existing.categoryId) !== categoryName],
        ['name', existing.name !== next.name],
        ['description', existing.description !== next.description],
        ['price', existing.price !== next.price],
        ['groups', existing.groupIds.join() !== next.groupIds.join()],
      ] as const
    )
      .filter(([, differs]) => differs)
      .map(([field]) => field);
    if (fields.length === 0) {
      plan.unchanged += 1;
      continue;
    }
    plan.changed.push({
      row,
      itemId: existing.id,
      code,
      fields,
      next,
      oldPrice: existing.price,
    });
  }
  return plan;
}

// A price in major units («120», «35.5») in minor units, above 0 and a whole
// amount of the minor unit; null otherwise.
export function minorOf(text: string, decimals: number): bigint | null {
  const match = /^(\d{1,13})(?:\.(\d+))?$/.exec(text);
  if (!match) return null;
  const fraction = (match[2] ?? '').replace(/0+$/, '');
  if (fraction.length > decimals) return null;
  const minor = BigInt(match[1]! + fraction.padEnd(decimals, '0'));
  return minor > 0n ? minor : null;
}
