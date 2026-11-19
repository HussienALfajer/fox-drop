import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import type { components } from '@fox-drop/api-schema';
import { api } from './api.js';
import { decimalOf, minorOf } from './format.js';

// The city's settings that «المدن», «الإعدادات الافتراضية» and «قواعد
// التوزيع» show (AP §9.12.1, §9.12.4, §9.12.6; slice 2.37c), read and saved
// through the settings routes, which give each role only what its Appendix A
// edit roles hold (OPS: dispatch.mode alone).
export type SettingEntry = components['schemas']['SettingEntryDto_Output'];

// Who reaches «الإعدادات الافتراضية» (OWN) and «قواعد التوزيع» (OWN, OPS).
export const SETTINGS_MANAGE = 'settings.manage';
export const SWITCH_DISPATCH_MODE = 'dispatch.switch_mode';

// AP §9.12.4, in the spec's order; a vehicle's suggested custody limit is a
// key per vehicle.
export const DEFAULT_KEYS = [
  'merchant.default_commission_pct',
  'merchant.default_min_order',
  'merchant.default_prep_min',
  'captain.custody_limit_suggested.motorbike',
  'captain.custody_limit_suggested.car',
  'captain.custody_limit_suggested.bicycle',
  'captain.custody_limit_suggested.walking',
] as const;

// AP §9.12.6: the mode, then the settings of eligibility, ranking, offers,
// the search start and the capacity check.
export const DISPATCH_KEYS = [
  'dispatch.mode',
  'dispatch.max_offers_before_manual',
  'dispatch.search_radius_km',
  'dispatch.ranking',
  'dispatch.offer_timeout_sec',
  'captain.offer_expiry_offline_count',
  'captain.remit_online_grace_hours',
  'dispatch.search_start_buffer_min',
  'dispatch.capacity_check',
] as const;

// AP §9.12.1: the city's business-day cutoff and platform hours.
export const CITY_KEYS = ['finance.business_day_cutoff', 'platform.hours'] as const;

export type CitySettingKey =
  (typeof DEFAULT_KEYS)[number] | (typeof DISPATCH_KEYS)[number] | (typeof CITY_KEYS)[number];

// The settings in the order asked, those the server answered for the role.
export function entriesOf(
  settings: SettingEntry[],
  keys: readonly CitySettingKey[],
): (SettingEntry & { key: CitySettingKey })[] {
  return keys.flatMap((key) => {
    const entry = settings.find((each) => each.key === key);
    return entry ? [{ ...entry, key }] : [];
  });
}

// The schedule's weekdays (platform.hours), from Saturday, the Syrian week.
export const weekdays = [
  'saturday',
  'sunday',
  'monday',
  'tuesday',
  'wednesday',
  'thursday',
  'friday',
] as const;
export type Weekday = (typeof weekdays)[number];
type Schedule = Record<Weekday, { open: string; close: string }[]>;

interface Money {
  amountMinor: number;
  currency: string | null;
}

// A setting as its field edits it: a text, a flag, or a text per weekday.
export type SettingForm =
  | { kind: 'text'; text: string }
  | { kind: 'flag'; on: boolean }
  | { kind: 'week'; days: Record<Weekday, string> };

// The periods of a day as typed: «09:00-23:00» comma separated, empty for
// closed.
function dayText(periods: { open: string; close: string }[]): string {
  return periods.map((period) => `${period.open}-${period.close}`).join(', ');
}

export function settingFormOf(entry: SettingEntry): SettingForm {
  const value = entry.value as unknown;
  if (entry.type === 'boolean') return { kind: 'flag', on: value === true };
  if (entry.type === 'schedule') {
    const schedule = (value ?? {}) as Partial<Schedule>;
    return {
      kind: 'week',
      days: Object.fromEntries(
        weekdays.map((day) => [day, dayText(schedule[day] ?? [])]),
      ) as Record<Weekday, string>,
    };
  }
  if (entry.type === 'money') {
    const money = value as Money | null;
    return {
      kind: 'text',
      text: money?.currency ? decimalOf(String(money.amountMinor), money.currency) : '',
    };
  }
  return { kind: 'text', text: value === null || value === undefined ? '' : String(value) };
}

const time = /^([01]\d|2[0-3]):[0-5]\d$/;

// The value to save from the field, or null when it is not one of the
// setting's type; the server checks the rest (its limits). Money is in the
// city's base currency, which a city without one cannot take.
export function settingValueOf(
  entry: SettingEntry,
  form: SettingForm,
  baseCurrency: string | null,
): unknown {
  if (form.kind === 'flag') return form.on;
  if (form.kind === 'week') {
    const schedule: Partial<Schedule> = {};
    for (const day of weekdays) {
      const typed = form.days[day].trim();
      const periods: { open: string; close: string }[] = [];
      if (typed !== '') {
        for (const part of typed.split(/[,،]/)) {
          const match = /^\s*(\d\d:\d\d)\s*-\s*(\d\d:\d\d)\s*$/.exec(part);
          if (!match) return null;
          const [open, close] = [match[1]!, match[2]!];
          if (!time.test(open) || !(time.test(close) || close === '24:00')) return null;
          periods.push({ open, close });
        }
      }
      schedule[day] = periods;
    }
    return schedule;
  }
  const text = form.text.trim();
  switch (entry.type) {
    case 'money': {
      if (baseCurrency === null) return null;
      const minor = minorOf(text, baseCurrency);
      return minor === null ? null : { amountMinor: Number(minor), currency: baseCurrency };
    }
    case 'time_of_day':
      return time.test(text) ? text : null;
    case 'enum':
      return text === '' ? null : text;
    case 'duration':
    case 'count':
      return /^\d{1,6}$/.test(text) ? Number(text) : null;
    case 'percentage':
    case 'distance':
    case 'speed':
      return /^\d{1,6}(\.\d{1,3})?$/.test(text) ? Number(text) : null;
    default:
      return null;
  }
}

const settingsKey = (cityId: string) => ['city-settings', cityId] as const;

export function useCitySettings(cityId: string | undefined) {
  return useQuery({
    queryKey: settingsKey(cityId ?? ''),
    enabled: cityId !== undefined,
    queryFn: async () => {
      const { data } = await api.GET('/v1/admin/settings', {
        params: { query: { cityId: cityId! } },
      });
      if (!data) throw new Error('settings unavailable');
      return data.settings;
    },
  });
}

export type SettingRefusal = 'invalid_value' | 'reason_required' | 'wrong_currency' | 'forbidden';

export type SettingSaveResult =
  { status: 'saved' } | { status: 'refused'; refusal: SettingRefusal };

// Saves one setting for the city, in effect at once; it sets the value
// sent, so no key. The settings are read again after.
export function useSaveCitySetting(cityId: string) {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: async ({
      key,
      value,
      reason,
    }: {
      key: string;
      value: unknown;
      reason: string;
    }): Promise<SettingSaveResult> => {
      try {
        const { error, response } = await api.PUT('/v1/admin/settings/{key}', {
          params: { path: { key } },
          body: { cityId, value, reason: reason.trim() === '' ? null : reason.trim() },
        });
        const status: number = response.status;
        if (status === 403) return { status: 'refused', refusal: 'forbidden' };
        if (status === 400) {
          const code = (error as { error?: string } | undefined)?.error;
          if (code === 'reason_required' || code === 'wrong_currency') {
            return { status: 'refused', refusal: code };
          }
          return { status: 'refused', refusal: 'invalid_value' };
        }
        if (error !== undefined) throw new Error(`setting failed with ${status}`);
        return { status: 'saved' };
      } finally {
        await queryClient.invalidateQueries({ queryKey: settingsKey(cityId) });
        // The top bar's dispatch mode (AP §7.2) reads apart from the list;
        // the answer never waits for it.
        void queryClient.invalidateQueries({ queryKey: ['dispatch-mode', cityId] });
      }
    },
  });
}
