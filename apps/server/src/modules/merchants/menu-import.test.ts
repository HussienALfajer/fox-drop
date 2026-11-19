import { describe, expect, it } from 'vitest';
import ExcelJS from 'exceljs';
import { IMPORT_HEADERS, type ImportMenu, planImport, unzippedSize } from './menu-import.js';

// AP §9.6.6 «استيراد من Excel» (slice 2.31): the rows of the template checked
// against the menu, and what an import would add, change or leave alone.
const menu: ImportMenu = {
  decimals: 2,
  categories: [
    { id: 'meals', name: 'وجبات' },
    { id: 'drinks', name: 'مشروبات' },
  ],
  items: [
    {
      id: 'a',
      code: 'A1',
      categoryId: 'meals',
      name: 'شاورما',
      description: null,
      price: 12_000n,
      groupIds: ['size'],
    },
    {
      id: 'b',
      code: 'B1',
      categoryId: 'drinks',
      name: 'عصير',
      description: 'طازج',
      price: 3_000n,
      groupIds: [],
    },
  ],
  groups: [
    { id: 'size', name: 'الحجم' },
    { id: 'extras', name: 'إضافات' },
  ],
};

const header = [...IMPORT_HEADERS];
const row = (code: string, category: string, name: string, price: string, extra = ['', '']) => [
  code,
  category,
  name,
  extra[0] ?? '',
  price,
  extra[1] ?? '',
];

describe('planImport', () => {
  it('matches rows by item code, adds new ones and leaves the same ones alone', () => {
    const plan = planImport(
      [
        header,
        row('A1', 'وجبات', 'شاورما', '120', ['', 'الحجم']),
        row('B1', 'مشروبات', 'عصير برتقال', '35.5', ['طازج', '']),
        row('', 'حلويات', 'كنافة', '80', ['', 'إضافات، الحجم']),
        row('C9', 'وجبات', 'برغر', '150'),
      ],
      menu,
    );
    expect(plan.errors).toEqual([]);
    expect(plan.fileError).toBe(null);
    expect(plan.unchanged).toBe(1);
    expect(plan.categoriesAdded).toEqual(['حلويات']);
    expect(plan.changed).toEqual([
      {
        row: 3,
        itemId: 'b',
        code: 'B1',
        fields: ['name', 'price'],
        next: {
          categoryName: 'مشروبات',
          name: 'عصير برتقال',
          description: 'طازج',
          price: 3_550n,
          groupIds: [],
        },
        oldPrice: 3_000n,
      },
    ]);
    expect(plan.added).toEqual([
      {
        row: 4,
        code: null,
        categoryName: 'حلويات',
        name: 'كنافة',
        description: null,
        price: 8_000n,
        groupIds: ['extras', 'size'],
      },
      {
        row: 5,
        code: 'C9',
        categoryName: 'وجبات',
        name: 'برغر',
        description: null,
        price: 15_000n,
        groupIds: [],
      },
    ]);
  });

  it('reports every row error, with the row number of the sheet', () => {
    const plan = planImport(
      [
        header,
        row('A1', '', 'شاورما', '120'),
        row('X1', 'وجبات', '', '0'),
        row('X2', 'وجبات', 'برغر', '1.234'),
        row('X2', 'وجبات', 'برغر', 'abc'),
        row('X'.repeat(21), 'وجبات', 'برغر', '10'),
        row('X3', 'وجبات', 'برغر', '10', ['', 'مجهولة']),
      ],
      menu,
    );
    expect(plan.errors).toEqual([
      { row: 2, column: 'category', error: 'required' },
      { row: 3, column: 'name', error: 'required' },
      { row: 3, column: 'price', error: 'invalid_price' },
      { row: 4, column: 'price', error: 'invalid_price' },
      { row: 5, column: 'code', error: 'repeated_code' },
      { row: 5, column: 'price', error: 'invalid_price' },
      { row: 6, column: 'code', error: 'too_long' },
      { row: 7, column: 'groups', error: 'unknown_group' },
    ]);
  });

  it('refuses a file without the template headers, or without rows', () => {
    expect(planImport([['code', 'name']], menu).fileError).toBe('missing_headers');
    expect(planImport([header], menu).fileError).toBe('no_rows');
    expect(planImport([], menu).fileError).toBe('missing_headers');
    // Blank rows are skipped, not counted.
    expect(planImport([header, ['', '', '', '', '', '']], menu).fileError).toBe('no_rows');
  });

  it('takes the headers in any order and a name too long as an error', () => {
    const reordered = ['السعر', 'الصنف', 'التصنيف', 'رمز الصنف', 'الوصف', 'مجموعات الخيارات'];
    const plan = planImport([reordered, ['120', 'ش'.repeat(81), 'وجبات', 'A1', '', 'الحجم']], menu);
    expect(plan.errors).toEqual([{ row: 2, column: 'name', error: 'too_long' }]);
  });

  it('refuses a category or group name two rows of the menu share', () => {
    const twice: ImportMenu = {
      ...menu,
      categories: [...menu.categories, { id: 'meals2', name: 'وجبات' }],
      groups: [...menu.groups, { id: 'size2', name: 'الحجم' }],
    };
    expect(
      planImport(
        [
          header,
          row('A1', 'وجبات', 'شاورما', '120'),
          row('B1', 'مشروبات', 'عصير', '30', ['', 'الحجم']),
        ],
        twice,
      ).errors,
    ).toEqual([
      { row: 2, column: 'category', error: 'ambiguous_name' },
      { row: 3, column: 'groups', error: 'ambiguous_name' },
    ]);
  });

  it('numbers the rows as the sheet does, blank rows left out', () => {
    const plan = planImport([header, row('', 'وجبات', '', '10')], menu, [1, 7]);
    expect(plan.errors).toEqual([{ row: 7, column: 'name', error: 'required' }]);
  });
});

describe('unzippedSize', () => {
  it('reads what a workbook holds once unzipped, and refuses what is no zip', async () => {
    const workbook = new ExcelJS.Workbook();
    workbook.addWorksheet('القائمة').addRow([...IMPORT_HEADERS]);
    const bytes = new Uint8Array(await workbook.xlsx.writeBuffer());
    const size = unzippedSize(bytes);
    expect(size).toBeGreaterThan(bytes.length);
    expect(size).toBeLessThan(100_000);
    expect(unzippedSize(new TextEncoder().encode('not a zip at all, nothing here'))).toBe(null);
  });
});
