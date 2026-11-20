import ExcelJS from 'exceljs';
import { reportLabels as labels } from '../content/index.js';
import { ROW_CODES } from './report-tables.js';
import type { Report } from './reports.service.js';
import { majorOf } from './statement-workbook.js';

type Words = Record<string, string>;
const word = (words: unknown, key: string): string | undefined => (words as Words)[key];

// The name of a code in one of `reportLabels.code`'s lists, or the code.
export function codeName(list: string, code: string): string {
  const words = (labels.code as Record<string, Words>)[list];
  return (words && word(words, code)) ?? code;
}

// Architecture §5.9, AP §9.17 (slice 2.41): a report as one right-to-left
// sheet: the title, the period and the currency, then each table with its
// title, its header and its rows. Counts are numbers, shares percentages,
// minutes numbers to one decimal, amounts numbers in their currency's major
// units (the report's, or the row's own), a code its Arabic name.
export async function reportWorkbook(
  report: Report,
  decimalsOf: ReadonlyMap<string, number>,
): Promise<Buffer> {
  const workbook = new ExcelJS.Workbook();
  workbook.creator = 'FOX DROP';
  const sheet = workbook.addWorksheet(labels.sheet, { views: [{ rightToLeft: true }] });
  sheet.addRow([labels.title[report.kind]]).font = { bold: true, size: 14 };
  sheet.addRow([labels.period, report.fromDay, report.toDay]);
  sheet.addRow([labels.currency, report.currency]);
  for (const table of report.tables) {
    const key = `${report.kind}.${table.key}`;
    sheet.addRow([]);
    sheet.addRow([word(labels.table, key) ?? table.key]).font = { bold: true };
    const named = table.rowKind !== 'none';
    sheet.addRow([
      ...(named ? [word(labels.rowHeader, key) ?? ''] : []),
      ...table.columns.map((column) => word(labels.column, column.key) ?? column.key),
    ]).font = { bold: true };
    const rowCodes = ROW_CODES[key];
    for (const row of table.rows) {
      const name =
        row.label ??
        (row.code === null
          ? ''
          : table.rowKind === 'hour'
            ? `${row.code.padStart(2, '0')}:00`
            : rowCodes
              ? codeName(rowCodes, row.code)
              : row.code);
      const currency = row.currency ?? report.currency;
      const places = decimalsOf.get(currency) ?? 2;
      const formats: (string | undefined)[] = [];
      const values = table.columns.map((column, index) => {
        const value = row.cells[index] ?? null;
        if (value === null) return '';
        switch (column.kind) {
          case 'count':
            return Number(value);
          case 'bp':
            formats[index] = '0.0%';
            return Number(value) / 10_000;
          case 'minutes':
          case 'stars':
            formats[index] = '0.0';
            return Number(value);
          case 'money':
            formats[index] = places === 0 ? '#,##0' : `#,##0.${'0'.repeat(places)}`;
            return majorOf(BigInt(value), places);
          case 'code':
            return codeName(column.key, value);
          case 'text':
            return value;
        }
      });
      const added = sheet.addRow([...(named ? [name] : []), ...values]);
      formats.forEach((format, index) => {
        if (format !== undefined) added.getCell(index + (named ? 2 : 1)).numFmt = format;
      });
    }
  }
  return Buffer.from(await workbook.xlsx.writeBuffer());
}
