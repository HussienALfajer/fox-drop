import type { DailyFigures } from './daily-figures.js';
import type { DayFigures } from './daily-report.service.js';
import type { ReportRow, ReportTable } from './report-tables.js';

const amount = (value: bigint) => value.toString();

// AP §9.17 «Finance»: the period's summary and each day's (the daily
// report's figures, AP §9.10.1, of the whole period and of each business
// day), the cash per currency, rounding and FX, and the compensation and
// other costs, in the base (+ a gain for the platform, as the daily report).
export function financeReport(period: DailyFigures, days: readonly DayFigures[]): ReportTable[] {
  const lines: [string, bigint][] = [
    ['gmv', period.orders.gmv],
    ['items_value', period.orders.itemsValue],
    ['delivery_fees', period.deliveryFees],
    ['commission', period.commission],
    ['discounts_platform', period.discounts.platform],
    ['discounts_restaurant', period.discounts.restaurant],
    ['captain_pay', period.captainPay.total],
    ['compensation', period.compensation],
    ['operating_cost', period.operatingCost],
    ['test_cost', period.testCost],
    ['fx_rounding', period.fxRounding],
    ['adjustments', period.adjustments],
    ['withheld_deposits', period.withheldDeposits],
    ['margin', period.margin],
  ];
  return [
    {
      key: 'summary',
      rowKind: 'code',
      columns: [{ key: 'amount', kind: 'money' }],
      rows: lines.map(([code, value]): ReportRow => ({
        code,
        label: null,
        cells: [amount(value)],
      })),
    },
    {
      key: 'by_day',
      rowKind: 'day',
      columns: [
        { key: 'orders', kind: 'count' },
        { key: 'gmv', kind: 'money' },
        { key: 'delivery_fees', kind: 'money' },
        { key: 'commission', kind: 'money' },
        { key: 'captain_pay', kind: 'money' },
        { key: 'compensation', kind: 'money' },
        { key: 'margin', kind: 'money' },
      ],
      rows: days.map((day) => ({
        code: day.day,
        label: null,
        cells: [
          String(day.orders.count),
          amount(day.orders.gmv),
          amount(day.deliveryFees),
          amount(day.commission),
          amount(day.captainPay.total),
          amount(day.compensation),
          amount(day.margin),
        ],
      })),
    },
    {
      // Per currency, in that currency (the row's own).
      key: 'cash',
      rowKind: 'code',
      columns: [
        { key: 'custody_created', kind: 'money' },
        { key: 'handed_in', kind: 'money' },
        { key: 'reimbursed', kind: 'money' },
        { key: 'captain_payouts', kind: 'money' },
        { key: 'restaurant_payments', kind: 'money' },
        { key: 'open_custody', kind: 'money' },
      ],
      rows: period.cash.map((cash) => ({
        code: cash.currency,
        label: null,
        currency: cash.currency,
        cells: [
          amount(cash.custodyCreated),
          amount(cash.handedIn),
          amount(cash.reimbursed),
          amount(cash.captainPayouts),
          amount(cash.restaurantPayments),
          amount(cash.openCustody),
        ],
      })),
    },
  ];
}
