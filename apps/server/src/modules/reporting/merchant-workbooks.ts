import ExcelJS from 'exceljs';
import type { MerchantStatementRead } from '../cashdesk/index.js';
import { merchantExportLabels, restaurantStatementLabels } from '../content/index.js';
import type { OrderView } from '../ordering/index.js';
import { decimalOf, localTime, majorOf } from './statement-workbook.js';
import type { RestaurantFigures } from './restaurant-report.js';

// Architecture §5.9, RA §17 (slice 2.45d): the owner web portal's Excel
// files, each one right-to-left sheet in the restaurant app's words
// (`merchantExportLabels`). Amounts are numbers in their currency's major
// units, written from their digits; times on the city's clock.

const numberFormat = (places: number) => (places === 0 ? '#,##0' : `#,##0.${'0'.repeat(places)}`);

function newSheet(name: string) {
  const workbook = new ExcelJS.Workbook();
  workbook.creator = 'FOX DROP';
  return { workbook, sheet: workbook.addWorksheet(name, { views: [{ rightToLeft: true }] }) };
}

// A basis-point share as a percentage to one decimal («12.5»), or null.
const percentOf = (bp: number | null) => (bp === null ? null : Math.round(bp / 10) / 10);
const oneDecimal = (value: number | null) => (value === null ? null : Math.round(value * 10) / 10);

export interface MerchantReportSheet {
  restaurantName: string;
  fromDay: string;
  toDay: string;
  currency: string;
  current: RestaurantFigures;
  previous: RestaurantFigures;
}

// RA §11: every metric of the period beside the previous period of the same
// length, then the rejections, the top items and the delivered orders by
// hour of the period.
export async function merchantReportWorkbook(
  report: MerchantReportSheet,
  decimalsOf: ReadonlyMap<string, number>,
): Promise<Buffer> {
  const labels = merchantExportLabels.report;
  const places = decimalsOf.get(report.currency) ?? 2;
  const money = (minor: bigint | null) => (minor === null ? null : majorOf(minor, places));
  const { workbook, sheet } = newSheet(labels.sheet);
  sheet.addRow([labels.title]).font = { bold: true, size: 14 };
  sheet.addRow([report.restaurantName]);
  sheet.addRow([labels.period, `${report.fromDay} - ${report.toDay}`]);
  sheet.addRow([labels.currency, report.currency]);
  sheet.addRow([labels.excluded]);
  sheet.addRow([]);
  sheet.addRow([labels.metric, labels.current, labels.previous]).font = { bold: true };
  const m = labels.metrics;
  const rows: [string, (figures: RestaurantFigures) => number | null, boolean][] = [
    [m.received, (f) => f.received, false],
    [m.acceptedByYou, (f) => f.acceptedByYou, false],
    [m.acceptedByOperations, (f) => f.acceptedByOperations, false],
    [m.rejected, (f) => f.rejected, false],
    [m.unanswered, (f) => f.unanswered, false],
    [m.acceptance, (f) => percentOf(f.acceptanceBp), false],
    [m.delivered, (f) => f.delivered, false],
    [m.sales, (f) => money(f.sales), true],
    [m.averageOrder, (f) => money(f.averageOrder), true],
    [m.commission, (f) => money(f.commission), true],
    [m.discounts, (f) => money(f.discounts), true],
    [m.net, (f) => money(f.net), true],
    [m.acceptTime, (f) => oneDecimal(f.acceptMinutes), false],
    [m.prepTime, (f) => oneDecimal(f.prepActualMinutes), false],
    [m.chosenTime, (f) => oneDecimal(f.prepChosenMinutes), false],
    [m.late, (f) => percentOf(f.lateBp), false],
    [m.readyNotPressed, (f) => f.readyNotPressed, false],
    [m.captainWait, (f) => oneDecimal(f.captainWaitMinutes), false],
    [m.rating, (f) => oneDecimal(f.rating.average), false],
    [m.ratings, (f) => f.rating.count, false],
    [m.pauseRestaurant, (f) => f.pauseMinutes.restaurant, false],
    [m.pauseOps, (f) => f.pauseMinutes.ops, false],
    [m.pauseAuto, (f) => f.pauseMinutes.auto, false],
  ];
  for (const [label, value, isMoney] of rows) {
    const row = sheet.addRow([label, value(report.current), value(report.previous)]);
    if (isMoney) for (const cell of [2, 3]) row.getCell(cell).numFmt = numberFormat(places);
  }

  sheet.addRow([]);
  sheet.addRow([labels.rejections]).font = { bold: true };
  sheet.addRow([labels.reason, labels.byOperations, labels.count]).font = { bold: true };
  for (const rejection of report.current.rejections) {
    sheet.addRow([rejection.label, rejection.byOperations ? labels.yes : '', rejection.count]);
  }

  for (const [title, items] of [
    [labels.topByQuantity, report.current.topByQuantity],
    [labels.topBySales, report.current.topBySales],
  ] as const) {
    sheet.addRow([]);
    sheet.addRow([title]).font = { bold: true };
    sheet.addRow([labels.item, labels.quantity, labels.sales]).font = { bold: true };
    for (const item of items) {
      const row = sheet.addRow([item.name, item.quantity, money(item.sales)]);
      row.getCell(3).numFmt = numberFormat(places);
    }
  }

  sheet.addRow([]);
  sheet.addRow([labels.hours]).font = { bold: true };
  sheet.addRow([labels.hour, labels.count]).font = { bold: true };
  for (const hour of report.current.hours) {
    sheet.addRow([`${String(hour.hour).padStart(2, '0')}:00`, hour.delivered]);
  }
  sheet.columns.forEach((column, index) => {
    column.width = [34, 16, 16][index] ?? 14;
  });
  return Buffer.from(await workbook.xlsx.writeBuffer());
}

export interface MerchantHistorySheet {
  fromDay: string;
  toDay: string;
  timeZone: string;
  orders: OrderView[];
  dayOf: (order: OrderView) => string;
  // The owner's money lines of each order (RA §8.18), null on a cancelled
  // or rejected one.
  owner: ReadonlyMap<
    string,
    { commission: bigint; discountShare: bigint; merchantNet: bigint } | null
  >;
}

// RA §8.18: one row per order of the range, newest first: the number, the
// time, the business day, the status, the item count, the items value and
// the owner's commission, restaurant-funded discount and net.
export async function merchantHistoryWorkbook(
  history: MerchantHistorySheet,
  decimalsOf: ReadonlyMap<string, number>,
): Promise<Buffer> {
  const labels = merchantExportLabels.history;
  const { workbook, sheet } = newSheet(labels.sheet);
  sheet.addRow([labels.title]).font = { bold: true, size: 14 };
  sheet.addRow([labels.period, `${history.fromDay} - ${history.toDay}`]);
  sheet.addRow([]);
  const c = labels.column;
  sheet.addRow([
    c.number,
    c.time,
    c.day,
    c.status,
    c.items,
    c.itemsValue,
    c.commission,
    c.discountShare,
    c.net,
    c.note,
  ]).font = { bold: true };
  for (const order of history.orders) {
    const places = decimalsOf.get(order.currency) ?? 2;
    const money = (minor: bigint | undefined) =>
      minor === undefined ? null : majorOf(minor, places);
    const owner = history.owner.get(order.id) ?? undefined;
    const notes = [
      order.testOrder ? labels.test : null,
      order.redelivery !== null ? labels.redelivery : null,
    ].filter((note) => note !== null);
    const row = sheet.addRow([
      order.number.toString(),
      localTime(order.placedAt, history.timeZone),
      history.dayOf(order),
      labels.status[order.status],
      order.lines.reduce((count, line) => count + line.quantity, 0),
      money(order.money.itemsValue),
      money(owner?.commission),
      money(owner?.discountShare),
      money(owner?.merchantNet),
      notes.join('، '),
    ]);
    for (const cell of [6, 7, 8, 9]) row.getCell(cell).numFmt = numberFormat(places);
  }
  sheet.columns.forEach((column, index) => {
    column.width = [12, 18, 12, 14, 12, 14, 12, 16, 12, 24][index] ?? 14;
  });
  return Buffer.from(await workbook.xlsx.writeBuffer());
}

// RA §12.3, §12.5: a weekly statement as the app shows it: the header, the
// totals from the week to the total due, then every line with «من قرّر».
// Amounts from the restaurant's side (+ it owes).
export async function merchantStatementWorkbook(
  statement: MerchantStatementRead,
  timeZone: string,
  decimalsOf: ReadonlyMap<string, number>,
): Promise<Buffer> {
  const labels = merchantExportLabels.statement;
  const base = statement.currency;
  const decimals = (currency: string) => decimalsOf.get(currency) ?? 2;
  const money = (minor: bigint) => majorOf(minor, decimals(base));
  const format = numberFormat(decimals(base));
  const { workbook, sheet } = newSheet(labels.sheet);
  sheet.addRow([labels.title]).font = { bold: true, size: 14 };
  sheet.addRow([labels.restaurant, statement.restaurantName]);
  sheet.addRow([
    labels.period,
    `${statement.periodFrom === null ? '' : `${localTime(statement.periodFrom, timeZone)} - `}${localTime(statement.cutoff, timeZone)}`,
  ]);
  sheet.addRow([labels.currency, base]);
  if (statement.status !== null) {
    sheet.addRow([labels.status, labels.statuses[statement.status]]);
  }
  sheet.addRow([labels.sign]);
  sheet.addRow([]);
  const totals: [string, bigint | number, boolean][] = [
    [labels.orders, statement.orders, false],
    [labels.itemsValue, statement.itemsValue, false],
    [labels.commission, statement.commission, false],
    [labels.discountShare, statement.discountShare, false],
    [labels.exceptions, statement.exceptions, false],
    [labels.weekTotal, statement.weekTotal, true],
    [labels.previousDue, statement.previousDue, false],
    [labels.paid, statement.paid, false],
    [labels.earlierUnpaid, statement.earlierUnpaid, false],
    [labels.totalDue, statement.totalDue, true],
    [labels.unpaid, statement.unpaid, true],
  ];
  for (const [label, value, bold] of totals) {
    const row = sheet.addRow([label, typeof value === 'bigint' ? money(value) : value]);
    if (typeof value === 'bigint') row.getCell(2).numFmt = format;
    if (bold) row.font = { bold: true };
  }
  sheet.addRow([]);
  const c = labels.columns;
  sheet.addRow([
    c.at,
    c.entry,
    c.order,
    c.itemsValue,
    c.pickupLines,
    c.commission,
    c.discountShare,
    c.amount,
    c.reason,
    c.decidedBy,
  ]).font = { bold: true };
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
                : restaurantStatementLabels.causes[line.cause],
            order,
            null,
            '',
            null,
            null,
            money(line.amount),
            line.reason ?? '',
            line.decidedBy === null
              ? ''
              : (line.decidedBy.name ?? labels.deciders[line.decidedBy.type]),
          ]);
    for (const column of [4, 6, 7, 8]) row.getCell(column).numFmt = format;
  }
  sheet.columns.forEach((column, index) => {
    column.width = [18, 30, 12, 14, 24, 12, 16, 14, 30, 18][index] ?? 14;
  });
  return Buffer.from(await workbook.xlsx.writeBuffer());
}
