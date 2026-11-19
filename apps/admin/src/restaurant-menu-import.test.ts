import { describe, expect, it, vi } from 'vitest';

vi.mock('./api.js', () => ({ api: {} }));

const { importable, importFileProblem, workbookBlob, XLSX_TYPE } =
  await import('./restaurant-menu-import.js');
type ImportPlan = import('./restaurant-menu-import.js').ImportPlan;

const plan: ImportPlan = {
  fileError: null,
  errors: [],
  categoriesAdded: [],
  added: [],
  changed: [],
  unchanged: 3,
};

describe('«استيراد من Excel» (slice 2.31)', () => {
  it('takes an .xlsx of 2 MB at most', () => {
    expect(importFileProblem({ name: 'menu.xlsx', type: XLSX_TYPE, size: 1000 })).toBe(null);
    expect(importFileProblem({ name: 'MENU.XLSX', type: '', size: 1000 })).toBe(null);
    expect(importFileProblem({ name: 'menu.csv', type: 'text/csv', size: 10 })).toBe('type');
    expect(importFileProblem({ name: 'menu.xlsx', type: XLSX_TYPE, size: 3_000_000 })).toBe('size');
  });

  it('imports only a plan without errors that adds or changes something', () => {
    expect(importable(plan)).toBe(false);
    expect(
      importable({
        ...plan,
        changed: [
          {
            row: 2,
            itemId: 'i',
            code: 'A1',
            fields: ['price'],
            categoryName: 'وجبات',
            name: 'شاورما',
            description: null,
            price: '13000',
            groupIds: [],
            oldPrice: '12000',
          },
        ],
      }),
    ).toBe(true);
    expect(
      importable({
        ...plan,
        added: [
          {
            row: 3,
            code: null,
            categoryName: 'حلويات',
            name: 'كنافة',
            description: null,
            price: '8000',
            groupIds: [],
          },
        ],
        errors: [{ row: 4, column: 'price', error: 'invalid_price' }],
      }),
    ).toBe(false);
  });

  it('rebuilds the template from its base64', async () => {
    const blob = workbookBlob(btoa('PK'));
    expect(blob.type).toBe(XLSX_TYPE);
    expect(new Uint8Array(await blob.arrayBuffer())).toEqual(new Uint8Array([0x50, 0x4b]));
  });
});
