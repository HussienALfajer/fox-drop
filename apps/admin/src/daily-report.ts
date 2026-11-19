import { useMutation, useQuery } from '@tanstack/react-query';
import type { components } from '@fox-drop/api-schema';
import { useRef } from 'react';
import { api } from './api.js';
import type { StatementExport } from './restaurant-statements.js';

export type DailyReport = components['schemas']['AdminDailyReportDto_Output'];
export type DayFigures = DailyReport['previous'][number];
export type CashFigures = DailyReport['cash'][number];

// The figures' words are `dailyReport.line.<key>`, the export's too (the
// server's export-labels.test.ts keeps them equal).
export type FigureKey =
  | 'orders'
  | 'gmv'
  | 'itemsValue'
  | 'deliveryFees'
  | 'platformDiscount'
  | 'restaurantDiscount'
  | 'commission'
  | 'captainBase'
  | 'captainDistance'
  | 'captainWaiting'
  | 'captainPeak'
  | 'captainBonuses'
  | 'captainTotal'
  | 'compensation'
  | 'operatingCost'
  | 'testCost'
  | 'fxRounding'
  | 'adjustments'
  | 'withheldDeposits'
  | 'margin'
  | 'restaurantCommission'
  | 'restaurantDiscountShare'
  | 'owedByRestaurants'
  | 'owedToRestaurants';

export type CashKey = Exclude<keyof CashFigures, 'currency'>;

// AP §9.10.1, in the spec's order: what was earned, then what restaurants
// owe. A count or an amount in the day's base (minor units as text).
export const figureLines: [
  FigureKey,
  (day: DayFigures) => { count: number } | { amount: string },
][] = [
  ['orders', (d) => ({ count: d.orders.count })],
  ['gmv', (d) => ({ amount: d.orders.gmv })],
  ['itemsValue', (d) => ({ amount: d.orders.itemsValue })],
  ['deliveryFees', (d) => ({ amount: d.deliveryFees })],
  ['platformDiscount', (d) => ({ amount: d.discounts.platform })],
  ['restaurantDiscount', (d) => ({ amount: d.discounts.restaurant })],
  ['commission', (d) => ({ amount: d.commission })],
  ['captainBase', (d) => ({ amount: d.captainPay.base })],
  ['captainDistance', (d) => ({ amount: d.captainPay.distance })],
  ['captainWaiting', (d) => ({ amount: d.captainPay.waiting })],
  ['captainPeak', (d) => ({ amount: d.captainPay.peak })],
  ['captainBonuses', (d) => ({ amount: d.captainPay.bonuses })],
  ['captainTotal', (d) => ({ amount: d.captainPay.total })],
  ['compensation', (d) => ({ amount: d.compensation })],
  ['operatingCost', (d) => ({ amount: d.operatingCost })],
  ['testCost', (d) => ({ amount: d.testCost })],
  ['fxRounding', (d) => ({ amount: d.fxRounding })],
  ['adjustments', (d) => ({ amount: d.adjustments })],
  ['withheldDeposits', (d) => ({ amount: d.withheldDeposits })],
  ['margin', (d) => ({ amount: d.margin })],
  ['restaurantCommission', (d) => ({ amount: d.restaurants.commission })],
  ['restaurantDiscountShare', (d) => ({ amount: d.restaurants.discountShare })],
  ['owedByRestaurants', (d) => ({ amount: d.restaurants.owedByRestaurants })],
  ['owedToRestaurants', (d) => ({ amount: d.restaurants.owedToRestaurants })],
];

// The captains' cash per currency (AP §9.10.1).
export const cashLines: CashKey[] = [
  'custodyCreated',
  'handedIn',
  'reimbursed',
  'openCustody',
  'owedToCaptains',
  'captainPayouts',
  'restaurantPayments',
];

export type DailyReportResult =
  | { status: 'ready'; report: DailyReport }
  | { status: 'refused'; refusal: 'invalid_day' | 'no_base_currency' | 'rate_missing' };

// The report of a business day, today's when none is given.
export function useDailyReport(cityId: string | undefined, day: string | undefined) {
  return useQuery({
    queryKey: ['daily-report', cityId ?? '', day ?? 'today'],
    enabled: cityId !== undefined,
    queryFn: async (): Promise<DailyReportResult> => {
      const { data, error, response } = await api.GET('/v1/admin/daily-report', {
        params: { query: { cityId: cityId!, ...(day ? { day } : {}) } },
      });
      if (data) return { status: 'ready', report: data };
      const refusal = (error as { error?: unknown } | undefined)?.error;
      if (
        refusal === 'invalid_day' ||
        refusal === 'no_base_currency' ||
        refusal === 'rate_missing'
      ) {
        return { status: 'refused', refusal };
      }
      throw new Error(`The daily report read failed with ${response.status}.`);
    },
  });
}

// «تصدير Excel» of a day: one key per day until an answer, as the
// statement's.
export function useExportDailyReport() {
  const keys = useRef(new Map<string, string>());
  return useMutation({
    mutationFn: async (body: { cityId: string; day: string }): Promise<StatementExport> => {
      const choice = JSON.stringify(body);
      let key = keys.current.get(choice);
      if (key === undefined) {
        key = crypto.randomUUID();
        keys.current.set(choice, key);
      }
      const { data, response } = await api.POST('/v1/admin/daily-report/exports', {
        params: { header: { 'Idempotency-Key': key } },
        body,
      });
      if (!data) throw new Error(`The export failed with ${response.status}.`);
      keys.current.delete(choice);
      return data;
    },
  });
}
