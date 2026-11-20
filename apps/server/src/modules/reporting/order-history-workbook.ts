import ExcelJS from 'exceljs';
import { orderHistoryLabels as labels } from '../content/index.js';
import type { AdminHistoryRow } from '../ordering/index.js';
import { majorOf } from './statement-workbook.js';

// The panel keys the codes in camel case (`order.status.pickedUp`).
function camel(code: string): string {
  return code.replace(/_([a-z])/g, (_, letter: string) => letter.toUpperCase());
}

export interface OrderHistorySheet {
  fromDay: string;
  toDay: string;
  timeZone: string;
  rows: AdminHistoryRow[];
  restaurantNames: ReadonlyMap<string, string>;
  captainNames: ReadonlyMap<string, string>;
}

// Architecture §5.9, AP §9.5 (slice 2.40): «سجل الطلبات» as one
// right-to-left sheet: the header, then one row per order with the table's
// columns, newest first. Totals are numbers in their currency's major units;
// times on the city's clock.
export async function orderHistoryWorkbook(
  sheetData: OrderHistorySheet,
  decimalsOf: ReadonlyMap<string, number>,
): Promise<Buffer> {
  const time = new Intl.DateTimeFormat('en-CA', {
    timeZone: sheetData.timeZone,
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit',
    hourCycle: 'h23',
  });
  const workbook = new ExcelJS.Workbook();
  workbook.creator = 'FOX DROP';
  const sheet = workbook.addWorksheet(labels.sheet, { views: [{ rightToLeft: true }] });
  sheet.addRow([labels.title]).font = { bold: true, size: 14 };
  sheet.addRow([sheetData.fromDay, sheetData.toDay]);
  sheet.addRow([]);
  const column = labels.column;
  sheet.addRow([
    column.number,
    column.time,
    column.restaurant,
    column.neighbourhood,
    column.captain,
    column.status,
    column.outcome,
    column.responsible,
    column.total,
    column.deliveryTime,
    column.code,
    column.kind,
  ]).font = { bold: true };
  for (const row of sheetData.rows) {
    const places = decimalsOf.get(row.currency) ?? 2;
    const added = sheet.addRow([
      Number(row.number),
      time.format(row.placedAt).replace(',', ''),
      sheetData.restaurantNames.get(row.restaurantId) ?? '',
      row.neighbourhood,
      row.captainId ? (sheetData.captainNames.get(row.captainId) ?? '') : '',
      labels.status[camel(row.status) as keyof typeof labels.status],
      row.outcome ? labels.outcome[camel(row.outcome) as keyof typeof labels.outcome] : '',
      row.responsible ? labels.responsible[row.responsible] : '',
      majorOf(row.total, places),
      row.deliveryMinutes ?? '',
      row.promoCode ?? '',
      row.redelivery ? labels.redelivery : row.testOrder ? labels.test : labels.real,
    ]);
    added.getCell(9).numFmt = places === 0 ? '#,##0' : `#,##0.${'0'.repeat(places)}`;
  }
  sheet.columns.forEach((each, index) => {
    each.width = [10, 18, 28, 20, 24, 16, 18, 16, 14, 18, 14, 18][index] ?? 16;
  });
  return Buffer.from(await workbook.xlsx.writeBuffer());
}
