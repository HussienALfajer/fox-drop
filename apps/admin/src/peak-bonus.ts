import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import type { components } from '@fox-drop/api-schema';
import { api } from './api.js';
import { decimalOf, minorOf } from './format.js';

// AP §9.12.5: the panel reads the bonus with the zones (zones.read); only
// OWN saves it (pricing.edit_pay_tables).
export const ZONES_READ = 'zones.read';
export const PRICING_EDIT = 'pricing.edit_pay_tables';

export type PeakBonus = components['schemas']['AdminPeakBonusDto_Output'];
export type PeakVersion = NonNullable<PeakBonus['inForce']>;
type SetPeakBonus = components['schemas']['AdminSetPeakBonusDto'];

// ISO days, Monday first; the form lists them from Saturday, the Syrian week.
export const weekDays = [6, 7, 1, 2, 3, 4, 5] as const;
export type WeekDay = (typeof weekDays)[number];

// A window as the form edits it: the hours as «20:00», the amount in major
// units as typed.
export interface WindowForm {
  days: number[];
  start: string;
  end: string;
  amount: string;
  zoneIds: string[];
}

export interface PeakForm {
  enabled: boolean;
  windows: WindowForm[];
}

export const emptyWindow: WindowForm = {
  days: [],
  start: '',
  end: '',
  amount: '',
  zoneIds: [],
};

// «20:00» from the minutes of the city's day, and back (null when not one).
export function timeOf(minute: number): string {
  const hours = Math.floor(minute / 60);
  return `${String(hours).padStart(2, '0')}:${String(minute % 60).padStart(2, '0')}`;
}

export function minuteOf(typed: string): number | null {
  const match = /^([01]\d|2[0-3]):([0-5]\d)$/.exec(typed.trim());
  return match ? Number(match[1]) * 60 + Number(match[2]) : null;
}

// The form of the version in force (off with no window while none).
export function formOf(version: PeakVersion | null): PeakForm {
  if (version === null) return { enabled: false, windows: [] };
  return {
    enabled: version.enabled,
    windows: version.windows.map((window) => ({
      days: [...window.days],
      start: timeOf(window.startMinute),
      end: timeOf(window.endMinute),
      amount: decimalOf(window.amount, version.currency),
      zoneIds: window.zones.map((zone) => zone.id),
    })),
  };
}

export type FormProblem = 'days' | 'hours' | 'amount';

// The body to save, or the first window's problem (its index and what is
// wrong); the server checks the rest.
export function requestOf(
  form: PeakForm,
  cityId: string,
  currency: string,
): { body: SetPeakBonus } | { problem: FormProblem; window: number } {
  const windows: SetPeakBonus['windows'] = [];
  for (const [index, window] of form.windows.entries()) {
    if (window.days.length === 0) return { problem: 'days', window: index };
    const startMinute = minuteOf(window.start);
    const endMinute = minuteOf(window.end);
    if (startMinute === null || endMinute === null || startMinute === endMinute) {
      return { problem: 'hours', window: index };
    }
    const amount = minorOf(window.amount, currency);
    if (amount === null || /^0+$/.test(amount)) return { problem: 'amount', window: index };
    windows.push({
      days: [...window.days].sort((a, b) => a - b),
      startMinute,
      endMinute,
      amount,
      zoneIds: window.zoneIds,
    });
  }
  return { body: { cityId, enabled: form.enabled, windows } };
}

// A window that ends at or before it starts runs past midnight.
export const crossesMidnight = (window: { startMinute: number; endMinute: number }) =>
  window.endMinute <= window.startMinute;

const peakKey = (cityId: string) => ['peak-bonus', cityId] as const;

export function usePeakBonus(cityId: string | undefined) {
  return useQuery({
    queryKey: peakKey(cityId ?? ''),
    enabled: cityId !== undefined,
    queryFn: async () => {
      const { data } = await api.GET('/v1/admin/peak-bonus', {
        params: { query: { cityId: cityId! } },
      });
      if (!data) throw new Error('peak bonus unavailable');
      return data;
    },
  });
}

export type SaveResult = { status: 'saved'; bonus: PeakBonus } | { status: 'refused' };

// Saves a new version; a 400 is a window or a currency the server refused.
export function useSavePeakBonus() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: async (body: SetPeakBonus): Promise<SaveResult> => {
      const { data, response } = await api.PUT('/v1/admin/peak-bonus', { body });
      const status: number = response.status;
      if (status === 400) return { status: 'refused' };
      if (!data) throw new Error(`peak bonus failed with ${status}`);
      queryClient.setQueryData(peakKey(body.cityId), data);
      return { status: 'saved', bonus: data };
    },
  });
}
