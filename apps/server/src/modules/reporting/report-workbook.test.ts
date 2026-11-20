import ExcelJS from 'exceljs';
import { describe, expect, it } from 'vitest';
import { reportWorkbook } from './report-workbook.js';

// AP §9.17 (slice 2.41): a report's file names its tables, columns and codes
// in Arabic and writes each kind of cell as Excel reads it.
describe('reportWorkbook', () => {
  it('writes each table with its Arabic header and typed cells', async () => {
    const file = await reportWorkbook(
      {
        kind: 'orders',
        cityId: 'c',
        fromDay: '2026-11-18',
        toDay: '2026-11-20',
        from: new Date(),
        to: new Date(),
        currency: 'TRY',
        tables: [
          {
            key: 'outcomes',
            rowKind: 'code',
            columns: [{ key: 'orders', kind: 'count' }],
            rows: [{ code: 'fake', label: null, cells: ['2'] }],
          },
          {
            key: 'by_hour',
            rowKind: 'hour',
            columns: [
              { key: 'success', kind: 'bp' },
              { key: 'sales', kind: 'money' },
            ],
            rows: [{ code: '9', label: null, cells: ['2500', '12345'] }],
          },
          {
            key: 'cancellations',
            rowKind: 'code',
            columns: [{ key: 'by', kind: 'code' }],
            rows: [{ code: 'merchant_auto_cancel', label: null, cells: ['system'] }],
          },
        ],
      },
      new Map([['TRY', 2]]),
    );
    const workbook = new ExcelJS.Workbook();
    await workbook.xlsx.load(file as unknown as ArrayBuffer);
    const sheet = workbook.worksheets[0]!;
    expect(sheet.views[0]?.rightToLeft).toBe(true);
    const rows = sheet
      .getSheetValues()
      .filter((row): row is ExcelJS.CellValue[] => Array.isArray(row))
      .map((row) => row.slice(1));
    expect(rows[0]).toEqual(['تقرير الطلبات']);
    expect(rows).toContainEqual(['النتيجة', 'الطلبات']);
    expect(rows).toContainEqual(['وهمي', 2]);
    expect(rows).toContainEqual(['09:00', 0.25, 123.45]);
    expect(rows).toContainEqual(['المطعم لم يستجب', 'النظام']);
  });
});
