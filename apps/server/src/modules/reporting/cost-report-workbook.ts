import ExcelJS from 'exceljs';
import { costReportLabels as labels } from '../content/index.js';
import type { CostReport } from './cost-report.service.js';
import { majorOf } from './statement-workbook.js';

// Architecture §5.9, AP §9.10.6 (slice 2.22d): the cost report as one
// right-to-left sheet: the header, the totals, then each split with its
// orders and cost. Amounts are numbers in the base's major units.
export async function costReportWorkbook(
  report: CostReport,
  decimalsOf: ReadonlyMap<string, number>,
): Promise<Buffer> {
  const places = decimalsOf.get(report.currency) ?? 2;
  const format = places === 0 ? '#,##0' : `#,##0.${'0'.repeat(places)}`;
  const money = (amount: bigint) => majorOf(amount, places);

  const workbook = new ExcelJS.Workbook();
  workbook.creator = 'FOX DROP';
  const sheet = workbook.addWorksheet(labels.sheet, { views: [{ rightToLeft: true }] });
  // A row whose cells from `first` on are amounts.
  const amounts = (values: (string | number)[], first: number) => {
    const row = sheet.addRow(values);
    for (let column = first; column <= values.length; column += 1) {
      row.getCell(column).numFmt = format;
    }
    return row;
  };
  const section = (title: string, header: string[]) => {
    sheet.addRow([]);
    sheet.addRow([title]).font = { bold: true };
    sheet.addRow(header).font = { bold: true };
  };

  sheet.addRow([labels.title]).font = { bold: true, size: 14 };
  sheet.addRow([labels.period, report.fromDay, report.toDay]);
  sheet.addRow([labels.currency, report.currency]);
  sheet.addRow([labels.note]);
  sheet.addRow([]);
  amounts([labels.line.discounts, money(report.totals.discounts)], 2);
  amounts([labels.line.compensation, money(report.totals.compensation)], 2);
  amounts([labels.line.operating, money(report.totals.operating)], 2);
  amounts([labels.line.total, money(report.totals.total)], 2).font = { bold: true };

  section(labels.section.compensationReasons, [
    labels.column.reason,
    labels.column.orders,
    labels.column.amount,
  ]);
  for (const row of report.compensationReasons) {
    const name =
      row.label ?? (row.kind === 'late_delivery' ? labels.lateDelivery : labels.operating.other);
    amounts([name, row.orders, money(row.amount)], 3);
  }

  section(labels.section.operatingReasons, [
    labels.column.reason,
    labels.column.orders,
    labels.column.amount,
  ]);
  for (const row of report.operatingReasons) {
    amounts([labels.operating[row.reason], row.orders, money(row.amount)], 3);
  }

  section(labels.section.parties, [
    labels.column.party,
    labels.column.orders,
    labels.column.amount,
  ]);
  for (const row of report.parties) {
    amounts([labels.party[row.party ?? 'none'], row.orders, money(row.amount)], 3);
  }

  section(labels.section.codes, [labels.column.code, labels.column.orders, labels.column.amount]);
  for (const row of report.codes) {
    amounts([row.code ?? labels.unknown, row.orders, money(row.amount)], 3);
  }

  section(labels.section.restaurants, [
    labels.column.restaurant,
    labels.line.discounts,
    labels.line.compensation,
    labels.line.operating,
    labels.line.total,
  ]);
  for (const row of report.restaurants) {
    amounts(
      [
        row.name ?? labels.unknown,
        money(row.discounts),
        money(row.compensation),
        money(row.operating),
        money(row.total),
      ],
      2,
    );
  }
  sheet.columns.forEach((column, index) => {
    column.width = index === 0 ? 42 : 18;
  });
  return Buffer.from(await workbook.xlsx.writeBuffer());
}
