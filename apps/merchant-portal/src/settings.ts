import type { components } from '@fox-drop/api-schema';
import { queryOptions, useMutation, useQueryClient } from '@tanstack/react-query';
import { api } from './api.js';
import { statusQuery } from './status.js';

export type Hours = components['schemas']['MerchantHoursDto_Output'];
export type PickupCurrencies = components['schemas']['MerchantPickupCurrenciesDto_Output'];

// RA §10, §17 (slice 2.45c): the owners' «الحالة والأوقات», read again after
// each save and on a state change the channel announces (live.ts).
export const hoursQuery = queryOptions({
  queryKey: ['restaurant-hours'],
  queryFn: async (): Promise<Hours> => {
    const { data, response } = await api.GET('/v1/merchant/restaurant/hours');
    if (!data) throw new Error(`The hours read failed (${response.status}).`);
    return data;
  },
});

// RA §12.7, §14.3 «العملات التي تقبلها من الكابتن».
export const pickupCurrenciesQuery = queryOptions({
  queryKey: ['pickup-currencies'],
  queryFn: async (): Promise<PickupCurrencies> => {
    const { data, response } = await api.GET('/v1/merchant/settings/pickup-currencies');
    if (!data) throw new Error(`The pickup currencies read failed (${response.status}).`);
    return data;
  },
});

// The weekdays as the screen lists them, Saturday first as the week runs in
// Syria; 0 is Sunday, as the server counts (the app's weekdayOrder).
export const WEEKDAY_ORDER = [6, 0, 1, 2, 3, 4, 5] as const;

// One period being edited, as two times of the city's day («HH:MM»); a
// closing time not after the opening crosses midnight (RA §10).
export interface PeriodForm {
  opensAt: string;
  closesAt: string;
}

export type WeekForm = Record<number, PeriodForm[]>;

// Minutes after midnight as «HH:MM», and back (null for anything else).
export function timeOf(minutes: number): string {
  const hours = Math.floor(minutes / 60) % 24;
  return `${String(hours).padStart(2, '0')}:${String(minutes % 60).padStart(2, '0')}`;
}

export function minutesOf(time: string): number | null {
  const match = /^([01]\d|2[0-3]):([0-5]\d)$/.exec(time);
  return match ? Number(match[1]) * 60 + Number(match[2]) : null;
}

// Each weekday's periods in order; none is «مغلق طوال اليوم».
export function weekOf(periods: Hours['periods']): WeekForm {
  const week: WeekForm = Object.fromEntries(WEEKDAY_ORDER.map((day) => [day, []]));
  for (const period of [...periods].sort((a, b) => a.opensAt - b.opensAt)) {
    week[period.weekday]?.push({
      opensAt: timeOf(period.opensAt),
      closesAt: timeOf(period.closesAt),
    });
  }
  return week;
}

// A new period after the day's last one (an hour long), or 09:00–10:00 on a
// closed day, as the app's.
export function withPeriod(week: WeekForm, weekday: number): WeekForm {
  const periods = week[weekday] ?? [];
  const last = periods.at(-1);
  const opensAt = last ? (minutesOf(last.closesAt) ?? 9 * 60) : 9 * 60;
  const next = { opensAt: timeOf(opensAt), closesAt: timeOf((opensAt + 60) % 1440) };
  return { ...week, [weekday]: [...periods, next] };
}

export function withoutPeriod(week: WeekForm, weekday: number, index: number): WeekForm {
  return { ...week, [weekday]: (week[weekday] ?? []).filter((_, at) => at !== index) };
}

export function withChange(
  week: WeekForm,
  weekday: number,
  index: number,
  period: PeriodForm,
): WeekForm {
  return {
    ...week,
    [weekday]: (week[weekday] ?? []).map((each, at) => (at === index ? period : each)),
  };
}

// What PUT /v1/merchant/restaurant/hours takes, or null while a time is not
// one. The server checks the rest (overlaps, 30 minutes or more).
export function scheduleOf(week: WeekForm): Hours['periods'] | null {
  const periods: Hours['periods'] = [];
  for (const weekday of WEEKDAY_ORDER) {
    for (const period of week[weekday] ?? []) {
      const opensAt = minutesOf(period.opensAt);
      const closesAt = minutesOf(period.closesAt);
      if (opensAt === null || closesAt === null) return null;
      periods.push({ weekday, opensAt, closesAt });
    }
  }
  return periods;
}

// The default prep time within the chooser's limits, and the maximum off or
// 1 to 50 (RA §7.4, §10); null when either is not.
export function orderSettingsOf(
  form: { defaultPrepMin: string; limited: boolean; maxActiveOrders: string },
  limits: { prepFloorMin: number; prepCeilingMin: number },
): { defaultPrepMin: number; maxActiveOrders: number | null } | null {
  const prep = Number(form.defaultPrepMin);
  if (!/^\d+$/.test(form.defaultPrepMin.trim())) return null;
  if (prep < limits.prepFloorMin || prep > limits.prepCeilingMin) return null;
  if (!form.limited) return { defaultPrepMin: prep, maxActiveOrders: null };
  const max = Number(form.maxActiveOrders);
  if (!/^\d+$/.test(form.maxActiveOrders.trim()) || max < 1 || max > 50) return null;
  return { defaultPrepMin: prep, maxActiveOrders: max };
}

// The other currencies to accept after switching one, in the city's order.
export function switchedCurrencies(
  pickup: PickupCurrencies,
  currency: string,
  on: boolean,
): string[] {
  const accepted = new Set(pickup.accepted);
  if (on) accepted.add(currency);
  else accepted.delete(currency);
  return pickup.choices.map((choice) => choice.currency).filter((code) => accepted.has(code));
}

export type SettingsRefusal = 'invalidSchedule' | 'invalidSettings' | 'invalidCurrencies' | 'other';

function refusalOf(error: unknown): SettingsRefusal {
  switch ((error as { error?: unknown } | undefined)?.error) {
    case 'invalid_schedule':
      return 'invalidSchedule';
    case 'invalid_prep_time':
    case 'invalid_max_active_orders':
      return 'invalidSettings';
    case 'invalid_pickup_currencies':
      return 'invalidCurrencies';
    default:
      return 'other';
  }
}

export type SettingsCommand =
  | { kind: 'hours'; periods: Hours['periods'] }
  | { kind: 'order_settings'; defaultPrepMin: number; maxActiveOrders: number | null }
  | { kind: 'pickup_currencies'; currencies: string[] };

export type SettingsAnswer = { status: 'done' } | { status: 'refused'; refusal: SettingsRefusal };

// Each sets a value and applies at once (RA §10), so none takes a key; its
// answer replaces the read. The hours and the limit change the status too.
export function useSettingsCommand() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: async (command: SettingsCommand): Promise<SettingsAnswer> => {
      if (command.kind === 'pickup_currencies') {
        const { data, error, response } = await api.PUT('/v1/merchant/settings/pickup-currencies', {
          body: { currencies: command.currencies },
        });
        if (data) {
          queryClient.setQueryData(pickupCurrenciesQuery.queryKey, data);
          return { status: 'done' };
        }
        return refused(response.status, error);
      }
      const { data, error, response } =
        command.kind === 'hours'
          ? await api.PUT('/v1/merchant/restaurant/hours', { body: { periods: command.periods } })
          : await api.PUT('/v1/merchant/restaurant/order-settings', {
              body: {
                defaultPrepMin: command.defaultPrepMin,
                maxActiveOrders: command.maxActiveOrders,
              },
            });
      if (data) {
        queryClient.setQueryData(hoursQuery.queryKey, data);
        void queryClient.invalidateQueries({ queryKey: statusQuery.queryKey });
        return { status: 'done' };
      }
      return refused(response.status, error);
    },
  });
}

function refused(status: number, error: unknown): SettingsAnswer {
  if (status >= 400 && status < 500) return { status: 'refused', refusal: refusalOf(error) };
  throw new Error(`The settings command failed (${status}).`);
}
