import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import type { components } from '@fox-drop/api-schema';
import { api } from './api.js';
import { minuteOf, timeOf } from './peak-bonus.js';

// AP §9.12.1, CA C13: the city's office and its desk hours. The panel reads
// it with the zones (zones.read); OWN saves it (zones.manage). Owner
// decision 2026-11-12: coordinates and the hours per weekday on a small form
// until the map (slice 2.29).
export const ZONES_MANAGE = 'zones.manage';

export type CityOffice = components['schemas']['AdminCityOfficeDto_Output'];
type SetOffice = components['schemas']['AdminSetCityOfficeDto'];

// The weekdays of the server (0 Sunday to 6 Saturday), listed from Saturday,
// the Syrian week.
export const officeDays = [6, 0, 1, 2, 3, 4, 5] as const;
export type OfficeDay = (typeof officeDays)[number];

// A weekday as the form edits it: open or not, the hours as «09:00».
export interface DayForm {
  open: boolean;
  from: string;
  to: string;
}

export interface OfficeForm {
  latitude: string;
  longitude: string;
  days: Record<OfficeDay, DayForm>;
}

const closedDay: DayForm = { open: false, from: '', to: '' };

// The form of the office in force (empty with every day closed while none).
export function officeFormOf(office: CityOffice['office']): OfficeForm {
  const days = Object.fromEntries(
    officeDays.map((day) => {
      const period = office?.hours.find((each) => each.weekday === day);
      return [
        day,
        period
          ? { open: true, from: timeOf(period.opensAt), to: timeOf(period.closesAt % 1440) }
          : closedDay,
      ];
    }),
  ) as Record<OfficeDay, DayForm>;
  return {
    latitude: office ? String(office.location.latitude) : '',
    longitude: office ? String(office.location.longitude) : '',
    days,
  };
}

export type OfficeProblem = 'location' | 'hours';

// A decimal degree as typed, within its range; null otherwise.
function degreesOf(typed: string, limit: number): number | null {
  if (!/^-?\d{1,3}(\.\d+)?$/.test(typed.trim())) return null;
  const value = Number(typed.trim());
  return Math.abs(value) <= limit ? value : null;
}

// The body to save, or what is wrong (for hours, the first weekday); the
// server checks the rest (30 minutes or more, no overlap).
export function officeRequestOf(
  form: OfficeForm,
): { body: SetOffice } | { problem: 'location' } | { problem: 'hours'; day: OfficeDay } {
  const latitude = degreesOf(form.latitude, 90);
  const longitude = degreesOf(form.longitude, 180);
  if (latitude === null || longitude === null) return { problem: 'location' };
  const hours: SetOffice['hours'] = [];
  for (const day of officeDays) {
    const each = form.days[day];
    if (!each.open) continue;
    const opensAt = minuteOf(each.from);
    const closesAt = minuteOf(each.to);
    if (opensAt === null || closesAt === null || opensAt === closesAt) {
      return { problem: 'hours', day };
    }
    // An end at or before the start runs past midnight; 00:00 is the day's end.
    hours.push({ weekday: day, opensAt, closesAt: closesAt === 0 ? 1440 : closesAt });
  }
  return { body: { location: { latitude, longitude }, hours } };
}

const officeKey = (cityId: string) => ['city-office', cityId] as const;

export function useCityOffice(cityId: string | undefined) {
  return useQuery({
    queryKey: officeKey(cityId ?? ''),
    enabled: cityId !== undefined,
    queryFn: async () => {
      const { data } = await api.GET('/v1/admin/cities/{cityId}/office', {
        params: { path: { cityId: cityId! } },
      });
      if (!data) throw new Error('office unavailable');
      return data;
    },
  });
}

export type OfficeSaveResult = { status: 'saved' } | { status: 'refused' };

// Saves a new version; a 400 is hours the server refused (invalid_office).
export function useSaveOffice(cityId: string) {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: async (body: SetOffice): Promise<OfficeSaveResult> => {
      const { data, response } = await api.PUT('/v1/admin/cities/{cityId}/office', {
        params: { path: { cityId } },
        body,
      });
      const status: number = response.status;
      if (status === 400) return { status: 'refused' };
      if (!data) throw new Error(`office failed with ${status}`);
      queryClient.setQueryData(officeKey(cityId), data);
      return { status: 'saved' };
    },
  });
}
