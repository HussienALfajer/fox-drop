import type { components } from '@fox-drop/api-schema';
import { queryOptions } from '@tanstack/react-query';
import { api } from './api.js';
import { type PeriodChoice, periodQuery } from './period.js';

export type Figures = components['schemas']['MerchantFiguresDto_Output'];
export type FigureSet = Figures['current'];

export type ReportsRead =
  | { status: 'ok'; figures: Figures }
  | { status: 'refused'; refusal: 'period' | 'noBase' | 'terminated' | 'other' };

// RA §11, §17 (slice 2.45d): the owner's figures of a period or a custom
// range, with the previous period of the same length.
export function figuresQuery(choice: PeriodChoice) {
  return queryOptions({
    queryKey: ['figures', choice],
    queryFn: async (): Promise<ReportsRead> => {
      const { data, error, response } = await api.GET('/v1/merchant/figures', {
        params: { query: periodQuery(choice) },
      });
      if (data) return { status: 'ok', figures: data };
      if (response.status >= 400 && response.status < 500) {
        const refusal = (error as { error?: unknown } | undefined)?.error;
        return {
          status: 'refused',
          refusal:
            refusal === 'invalid_period'
              ? 'period'
              : refusal === 'no_base_currency'
                ? 'noBase'
                : refusal === 'restaurant_terminated'
                  ? 'terminated'
                  : 'other',
        };
      }
      throw new Error(`The figures read failed (${response.status}).`);
    },
  });
}

// The comparison with the previous period (RA §11), as the app's changeOf:
// none when either has no value, the same, up from nothing, or the change
// in whole percent. Money compares as integers of minor units.
export type Change =
  | { kind: 'none' }
  | { kind: 'same' }
  | { kind: 'new' }
  | { kind: 'moved'; up: boolean; percent: number };

export function changeOf(
  current: number | string | null,
  previous: number | string | null,
): Change {
  if (current === null || previous === null) return { kind: 'none' };
  if (typeof current === 'string' || typeof previous === 'string') {
    const now = BigInt(current);
    const before = BigInt(previous);
    if (now === before) return { kind: 'same' };
    if (before === 0n) return now > 0n ? { kind: 'new' } : { kind: 'none' };
    const gap = now > before ? now - before : before - now;
    const base = before < 0n ? -before : before;
    // Half up to a whole percent, in integers.
    const percent = Number((gap * 200n + base) / (base * 2n));
    return { kind: 'moved', up: now > before, percent };
  }
  if (current === previous) return { kind: 'same' };
  if (previous === 0) return current > 0 ? { kind: 'new' } : { kind: 'none' };
  const percent = Math.round((Math.abs(current - previous) * 100) / Math.abs(previous));
  return { kind: 'moved', up: current > previous, percent };
}

export type MetricKind = 'count' | 'percent' | 'minutes' | 'money' | 'rating';

// RA §11's table, row by row: its key (the label and definition), how its
// value reads and where it is in the figures.
export const METRICS: readonly {
  key: string;
  kind: MetricKind;
  value: (figures: FigureSet) => number | string | null;
}[] = [
  { key: 'received', kind: 'count', value: (f) => f.received },
  { key: 'acceptedByYou', kind: 'count', value: (f) => f.acceptedByYou },
  { key: 'acceptedByOperations', kind: 'count', value: (f) => f.acceptedByOperations },
  { key: 'rejected', kind: 'count', value: (f) => f.rejected },
  { key: 'unanswered', kind: 'count', value: (f) => f.unanswered },
  { key: 'acceptance', kind: 'percent', value: (f) => f.acceptanceBp },
  { key: 'delivered', kind: 'count', value: (f) => f.delivered },
  { key: 'sales', kind: 'money', value: (f) => f.sales },
  { key: 'averageOrder', kind: 'money', value: (f) => f.averageOrder },
  { key: 'commission', kind: 'money', value: (f) => f.commission },
  { key: 'discounts', kind: 'money', value: (f) => f.discounts },
  { key: 'net', kind: 'money', value: (f) => f.net },
  { key: 'acceptTime', kind: 'minutes', value: (f) => f.acceptMinutes },
  { key: 'prepTime', kind: 'minutes', value: (f) => f.prepActualMinutes },
  { key: 'chosenTime', kind: 'minutes', value: (f) => f.prepChosenMinutes },
  { key: 'late', kind: 'percent', value: (f) => f.lateBp },
  { key: 'readyNotPressed', kind: 'count', value: (f) => f.readyNotPressed },
  { key: 'captainWait', kind: 'minutes', value: (f) => f.captainWaitMinutes },
  { key: 'rating', kind: 'rating', value: (f) => f.rating.average },
];

// A share in basis points as a percentage to one decimal (1250 → 12.5).
export function percentOf(bp: number): number {
  return Math.round(bp / 10) / 10;
}

// Minutes to one decimal.
export function minutesOf(minutes: number): number {
  return Math.round(minutes * 10) / 10;
}
