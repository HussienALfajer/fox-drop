import ExcelJS from 'exceljs';
import type { RestaurantPeriodStatement } from '../cashdesk/index.js';
import { restaurantStatementLabels as labels } from '../content/index.js';

// An amount of minor units in major units, written from its digits so the
// cell holds the number nearest the exact amount (Excel keeps numbers as
// doubles; money is never computed through one here).
export function majorOf(minor: bigint, decimals: number): number {
  return Number(decimalOf(minor, decimals));
}

// The same amount as text with all its minor digits, «10.50».
export function decimalOf(minor: bigint, decimals: number): string {
  const negative = minor < 0n;
  const digits = (negative ? -minor : minor).toString().padStart(decimals + 1, '0');
  const whole = digits.slice(0, digits.length - decimals);
  const fraction = digits.slice(digits.length - decimals);
  return `${negative ? '-' : ''}${whole}${decimals > 0 ? `.${fraction}` : ''}`;
}

// A moment on the city's clock, YYYY-MM-DD HH:MM, Western digits.
export function localTime(at: Date, timeZone: string): string {
  const parts = Object.fromEntries(
    new Intl.DateTimeFormat('en-CA', {
      timeZone,
      year: 'numeric',
      month: '2-digit',
      day: '2-digit',
      hour: '2-digit',
      minute: '2-digit',
      hourCycle: 'h23',
    })
      .formatToParts(at)
      .map((part) => [part.type, part.value]),
  );
  return `${parts.year}-${parts.month}-${parts.day} ${parts.hour}:${parts.minute}`;
}

// Architecture §5.9, AP §9.10.5 (slice 2.19g): a restaurant's statement for
// a period as one right-to-left sheet: the header, the summary from the
// opening to the closing balance, then every line. Amounts are numbers in
// the base's major units, from the restaurant's side (+ it owes).
export async function statementWorkbook(
  statement: RestaurantPeriodStatement,
  timeZone: string,
  decimalsOf: ReadonlyMap<string, number>,
): Promise<Buffer> {
  const base = statement.currency;
  const decimals = (currency: string) => decimalsOf.get(currency) ?? 2;
  const money = (minor: bigint) => majorOf(minor, base === null ? 2 : decimals(base));
  const format = (currency: string | null) => {
    const places = currency === null ? 2 : decimals(currency);
    return places === 0 ? '#,##0' : `#,##0.${'0'.repeat(places)}`;
  };

  const workbook = new ExcelJS.Workbook();
  workbook.creator = 'FOX DROP';
  const sheet = workbook.addWorksheet(labels.sheet, { views: [{ rightToLeft: true }] });

  sheet.addRow([labels.title]).font = { bold: true, size: 14 };
  sheet.addRow([labels.restaurant, statement.restaurantName]);
  sheet.addRow([
    labels.period,
    `${labels.from} ${statement.fromDay} ${labels.to} ${statement.toDay}`,
  ]);
  sheet.addRow([labels.currency, base ?? '']);
  sheet.addRow([labels.sign]);
  sheet.addRow([]);

  const summary: [string, bigint | number][] = [
    [labels.opening, statement.opening],
    [labels.orders, statement.orders],
    [labels.itemsValue, statement.itemsValue],
    [labels.commission, statement.commission],
    [labels.discountShare, statement.discountShare],
    [labels.exceptions, statement.exceptions],
    [labels.paid, statement.paid],
    [labels.closing, statement.closing],
  ];
  for (const [label, value] of summary) {
    const row = sheet.addRow([label, typeof value === 'bigint' ? money(value) : value]);
    if (typeof value === 'bigint') row.getCell(2).numFmt = format(base);
    if (label === labels.closing || label === labels.opening) row.font = { bold: true };
  }
  sheet.addRow([]);

  const c = labels.columns;
  const header = sheet.addRow([
    c.at,
    c.entry,
    c.order,
    c.itemsValue,
    c.pickupLines,
    c.commission,
    c.discountShare,
    c.amount,
    c.reason,
    c.receipt,
  ]);
  header.font = { bold: true };
  for (const line of statement.lines) {
    const at = localTime(line.at, timeZone);
    const order = line.orderNumber?.toString() ?? '';
    const row =
      line.kind === 'order'
        ? sheet.addRow([
            at,
            labels.entries.order,
            order,
            line.itemsValue === null ? null : money(line.itemsValue),
            (line.pickupLines ?? [])
              .map((each) => `${decimalOf(each.amount, decimals(each.currency))} ${each.currency}`)
              .join(' + '),
            money(line.commission),
            money(line.discountShare),
            money(line.commission + line.discountShare),
            '',
            '',
          ])
        : sheet.addRow([
            at,
            line.kind === 'payment'
              ? line.amount < 0n
                ? labels.entries.payment
                : labels.entries.payout
              : line.cause === null
                ? ''
                : labels.causes[line.cause],
            order,
            null,
            '',
            null,
            null,
            money(line.amount),
            line.reason ?? '',
            line.receipt?.number ?? '',
          ]);
    for (const column of [4, 6, 7, 8]) row.getCell(column).numFmt = format(base);
  }
  sheet.columns.forEach((column, index) => {
    column.width = [18, 30, 12, 14, 24, 12, 16, 14, 30, 18][index] ?? 14;
  });
  return Buffer.from(await workbook.xlsx.writeBuffer());
}
