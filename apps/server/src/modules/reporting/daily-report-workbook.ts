import { newWorkbook } from '../../workbooks/new-workbook.js';
import { dailyReportLabels as labels } from '../content/index.js';
import type { CashFigures, DailyFigures } from './daily-figures.js';
import type { DailyReport } from './daily-report.service.js';
import { localTime, majorOf } from './statement-workbook.js';

type Line = keyof typeof labels.line;

// The earned figures, one row each, the day and the days before as columns.
const earnedLines: [Line, (figures: DailyFigures) => bigint | number][] = [
  ['orders', (f) => f.orders.count],
  ['gmv', (f) => f.orders.gmv],
  ['itemsValue', (f) => f.orders.itemsValue],
  ['deliveryFees', (f) => f.deliveryFees],
  ['platformDiscount', (f) => f.discounts.platform],
  ['restaurantDiscount', (f) => f.discounts.restaurant],
  ['commission', (f) => f.commission],
  ['captainBase', (f) => f.captainPay.base],
  ['captainDistance', (f) => f.captainPay.distance],
  ['captainWaiting', (f) => f.captainPay.waiting],
  ['captainPeak', (f) => f.captainPay.peak],
  ['captainBonuses', (f) => f.captainPay.bonuses],
  ['captainTotal', (f) => f.captainPay.total],
  ['compensation', (f) => f.compensation],
  ['operatingCost', (f) => f.operatingCost],
  ['testCost', (f) => f.testCost],
  ['fxRounding', (f) => f.fxRounding],
  ['adjustments', (f) => f.adjustments],
  ['withheldDeposits', (f) => f.withheldDeposits],
  ['margin', (f) => f.margin],
  ['restaurantCommission', (f) => f.restaurants.commission],
  ['restaurantDiscountShare', (f) => f.restaurants.discountShare],
  ['owedByRestaurants', (f) => f.restaurants.owedByRestaurants],
  ['owedToRestaurants', (f) => f.restaurants.owedToRestaurants],
];

const cashLines: (Exclude<keyof CashFigures, 'currency'> & Line)[] = [
  'custodyCreated',
  'handedIn',
  'reimbursed',
  'openCustody',
  'owedToCaptains',
  'captainPayouts',
  'restaurantPayments',
];

// Architecture §5.9, AP §9.10.1 (slice 2.20d): the daily report as one
// right-to-left sheet: the header, the earned figures beside the days
// before, the captains' cash per currency, and today's state. Amounts are
// numbers in major units, the base's or the cash's own currency.
export async function dailyReportWorkbook(
  report: DailyReport,
  timeZone: string,
  decimalsOf: ReadonlyMap<string, number>,
): Promise<Buffer> {
  const decimals = (currency: string) => decimalsOf.get(currency) ?? 2;
  const format = (currency: string) => {
    const places = decimals(currency);
    return places === 0 ? '#,##0' : `#,##0.${'0'.repeat(places)}`;
  };
  const base = report.currency;

  const workbook = await newWorkbook();
  workbook.creator = 'FOX DROP';
  const sheet = workbook.addWorksheet(labels.sheet, { views: [{ rightToLeft: true }] });

  sheet.addRow([labels.title]).font = { bold: true, size: 14 };
  sheet.addRow([labels.day, report.day]);
  sheet.addRow([labels.currency, base]);
  sheet.addRow([labels.note]);
  sheet.addRow([]);

  const days = [report, ...report.previous];
  sheet.addRow([labels.earned, ...days.map((each) => each.day)]).font = { bold: true };
  for (const [line, value] of earnedLines) {
    const row = sheet.addRow([
      labels.line[line],
      ...days.map((each) => {
        const amount = value(each);
        return typeof amount === 'bigint' ? majorOf(amount, decimals(base)) : amount;
      }),
    ]);
    if (line !== 'orders') {
      for (let column = 2; column <= days.length + 1; column += 1) {
        row.getCell(column).numFmt = format(base);
      }
    }
    if (line === 'margin') row.font = { bold: true };
  }
  sheet.addRow([]);

  sheet.addRow([labels.cash, ...report.cash.map((each) => each.currency)]).font = { bold: true };
  for (const line of cashLines) {
    const row = sheet.addRow([
      labels.line[line],
      ...report.cash.map((each) => majorOf(each[line], decimals(each.currency))),
    ]);
    report.cash.forEach((each, index) => {
      row.getCell(index + 2).numFmt = format(each.currency);
    });
  }

  if (report.now !== null) {
    sheet.addRow([]);
    sheet.addRow([labels.now]).font = { bold: true };
    sheet.addRow([labels.line.captainsBlocked, report.now.captainsBlocked]);
    sheet.addRow([labels.line.overdueRestaurants, report.now.overdueRestaurants.length]);
    if (report.now.overdueRestaurants.length > 0) {
      sheet.addRow([labels.restaurant, labels.balance, labels.overdueSince]).font = { bold: true };
      for (const each of report.now.overdueRestaurants) {
        const row = sheet.addRow([
          each.name,
          majorOf(each.balance, decimals(base)),
          localTime(each.overdueSince, timeZone),
        ]);
        row.getCell(2).numFmt = format(base);
      }
    }
  }
  sheet.columns.forEach((column, index) => {
    column.width = index === 0 ? 42 : 14;
  });
  return Buffer.from(await workbook.xlsx.writeBuffer());
}
