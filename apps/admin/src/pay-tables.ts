import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import type { components } from '@fox-drop/api-schema';
import { api } from './api.js';
import { kmOf } from './delivery-fees.js';
import { zonedToUtc } from './emergency-stop.js';
import { decimalOf, minorOf } from './format.js';
import { utcToZoned } from './promo-codes.js';

// AP §9.12.5 «أجور الكباتن» (slice 2.37b): read with zones.read (OWN, OPS,
// FIN); only OWN publishes a table (pricing.edit_pay_tables, peak-bonus.ts's
// PRICING_EDIT) and changes the maximum distance (a setting OWN edits).

export type PayTables = components['schemas']['AdminPayTablesDto_Output'];
export type PayVersion = PayTables['versions'][number];
export type VehicleRate = PayVersion['rates'][number];
export type Vehicle = VehicleRate['vehicle'];
export type PayPreview = components['schemas']['AdminPayTablePreviewDto_Output'];
export type PayParts = NonNullable<PayPreview['draft']>;
type Publish = components['schemas']['AdminPublishPayTableDto'];

// In the catalogue's order, as the server lists them.
export const payVehicles = ['walking', 'bicycle', 'motorbike', 'car'] as const satisfies Vehicle[];

// A vehicle's rate as the form edits it: the amounts in major units and the
// included distance in km, as typed.
export interface RateForm {
  basePay: string;
  includedKm: string;
  perExtraKm: string;
  waitingPerMinute: string;
  minimumPay: string;
}

export interface PayForm {
  rates: Record<Vehicle, RateForm>;
  // The start as the city's wall time (datetime-local).
  start: string;
  reason: string;
}

const emptyRate: RateForm = {
  basePay: '',
  includedKm: '',
  perExtraKm: '',
  waitingPerMinute: '',
  minimumPay: '',
};

// Km typed to the metre, zero allowed (the base pay may include none), as
// whole metres, or null.
export function includedMetresOf(typed: string): number | null {
  const match = /^(\d{1,4})(?:\.(\d{1,3}))?$/.exec(typed.trim());
  if (!match) return null;
  return Number(match[1]) * 1000 + Number((match[2] ?? '').padEnd(3, '0'));
}

// A distance in km to the metre, as typed and stored («2.25 كم»; the
// shared formatDistance rounds to one decimal).
export function formatKm(metres: number): string {
  return new Intl.NumberFormat('ar-u-nu-latn', {
    style: 'unit',
    unit: 'kilometer',
    maximumFractionDigits: 3,
  }).format(metres / 1000);
}

// A positive km value typed (the maximum distance), or null.
export function kmValueOf(typed: string): number | null {
  const match = /^(\d{1,4})(?:\.(\d{1,3}))?$/.exec(typed.trim());
  if (!match) return null;
  const km = Number(typed.trim());
  return km > 0 ? km : null;
}

// The start the form proposes: an hour past the earliest the server allows,
// on the minute, so a form filled in slowly still passes.
export function proposedStart(earliestStart: string, timeZone: string): string {
  const minute = 60_000;
  const at = Math.ceil((new Date(earliestStart).getTime() + 60 * minute) / minute) * minute;
  return utcToZoned(new Date(at).toISOString(), timeZone);
}

// The form started from the newest version, or empty for none or one in
// another currency than the base (its amounts would read in the wrong unit).
export function payFormOf(
  version: PayVersion | null,
  currency: string,
  earliestStart: string,
  timeZone: string,
): PayForm {
  const rates = Object.fromEntries(
    payVehicles.map((vehicle) => {
      const rate = version?.rates.find((entry) => entry.vehicle === vehicle);
      if (!rate || version?.currency !== currency) return [vehicle, emptyRate];
      const money = (minor: string) => decimalOf(minor, currency);
      return [
        vehicle,
        {
          basePay: money(rate.basePay),
          includedKm: kmOf(rate.includedMetres),
          perExtraKm: money(rate.perExtraKm),
          waitingPerMinute: money(rate.waitingPerMinute),
          minimumPay: money(rate.minimumPay),
        },
      ];
    }),
  ) as Record<Vehicle, RateForm>;
  return { rates, start: proposedStart(earliestStart, timeZone), reason: '' };
}

export type RateProblem = 'amount' | 'distance';
export type PayProblem =
  { problem: RateProblem; vehicle: Vehicle } | { problem: 'start' | 'too_early' | 'reason' };

// One vehicle's rate in minor units and metres, or its first problem.
export function rateOf(
  form: RateForm,
  currency: string,
): Omit<VehicleRate, 'vehicle'> | RateProblem {
  const amounts = [form.basePay, form.perExtraKm, form.waitingPerMinute, form.minimumPay].map(
    (typed) => minorOf(typed, currency),
  );
  if (amounts.some((amount) => amount === null)) return 'amount';
  const includedMetres = includedMetresOf(form.includedKm);
  if (includedMetres === null) return 'distance';
  const [basePay, perExtraKm, waitingPerMinute, minimumPay] = amounts as string[];
  return {
    basePay: basePay!,
    includedMetres,
    perExtraKm: perExtraKm!,
    waitingPerMinute: waitingPerMinute!,
    minimumPay: minimumPay!,
  };
}

// The body to publish, or the first problem; the server checks the start
// again by its own clock.
export function publishRequestOf(
  form: PayForm,
  {
    cityId,
    currency,
    earliestStart,
    timeZone,
  }: {
    cityId: string;
    currency: string;
    earliestStart: string;
    timeZone: string;
  },
): { body: Publish } | PayProblem {
  const rates: Publish['rates'] = [];
  for (const vehicle of payVehicles) {
    const rate = rateOf(form.rates[vehicle], currency);
    if (typeof rate === 'string') return { problem: rate, vehicle };
    rates.push({ vehicle, ...rate });
  }
  const effectiveFrom = zonedToUtc(form.start, timeZone);
  if (effectiveFrom === null) return { problem: 'start' };
  if (new Date(effectiveFrom).getTime() < new Date(earliestStart).getTime()) {
    return { problem: 'too_early' };
  }
  const reason = form.reason.trim();
  if (reason === '') return { problem: 'reason' };
  return { body: { cityId, currency, effectiveFrom, rates, reason } };
}

// The draft rate's query fields for the calculator, or null while the rate
// is incomplete.
export function draftOf(form: RateForm, currency: string) {
  const rate = rateOf(form, currency);
  if (typeof rate === 'string') return null;
  return {
    draftBasePay: rate.basePay,
    draftIncludedMetres: rate.includedMetres,
    draftPerExtraKm: rate.perExtraKm,
    draftWaitingPerMinute: rate.waitingPerMinute,
    draftMinimumPay: rate.minimumPay,
  };
}

const payKey = (cityId: string) => ['pay-tables', cityId] as const;

export function usePayTables(cityId: string | undefined) {
  return useQuery({
    queryKey: payKey(cityId ?? ''),
    enabled: cityId !== undefined,
    queryFn: async () => {
      const { data } = await api.GET('/v1/admin/pay-tables', {
        params: { query: { cityId: cityId! } },
      });
      if (!data) throw new Error('pay tables unavailable');
      return data;
    },
  });
}

// A 400 is a table the server refused (a start too early by its clock), a
// 409 one outside the base currency.
export type PublishResult =
  | { status: 'published'; effectiveFrom: string }
  | { status: 'refused'; refusal: 'invalid_pay_table' | 'not_in_base_currency' };

// Publishing answers the screen, which replaces the read; a repeat of the
// newest version answers it, so no key.
export function usePublishPayTable(cityId: string) {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: async (body: Publish): Promise<PublishResult> => {
      const { data, response } = await api.PUT('/v1/admin/pay-tables', { body });
      const status: number = response.status;
      if (status === 400) return { status: 'refused', refusal: 'invalid_pay_table' };
      if (status === 409) return { status: 'refused', refusal: 'not_in_base_currency' };
      if (!data) throw new Error(`pay table failed with ${status}`);
      queryClient.setQueryData(payKey(cityId), data);
      return { status: 'published', effectiveFrom: body.effectiveFrom };
    },
  });
}

export type DistanceResult = { status: 'saved' } | { status: 'refused' };

// dispatch.max_distance_km.<vehicle>, changed at once through the settings
// (owner decision 2026-11-19).
export function useSaveMaxDistance(cityId: string) {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: async ({ vehicle, km }: { vehicle: Vehicle; km: number }) => {
      try {
        const { error, response } = await api.PUT('/v1/admin/settings/{key}', {
          params: { path: { key: `dispatch.max_distance_km.${vehicle}` } },
          body: { cityId, value: km, reason: null },
        });
        const status: number = response.status;
        if (status === 400 || status === 403) return { status: 'refused' } as DistanceResult;
        if (error !== undefined) throw new Error(`max distance failed with ${status}`);
        return { status: 'saved' } as DistanceResult;
      } finally {
        await queryClient.invalidateQueries({ queryKey: payKey(cityId) });
      }
    },
  });
}

export interface PreviewInput {
  vehicle: Vehicle;
  metres: number;
  waitedMinutes: number;
  draft: ReturnType<typeof draftOf>;
}

// The preview calculator (AP §9.12.5): a sample trip's pay by the table in
// force, each announced one and the table being typed.
export function usePayPreview(cityId: string) {
  return useMutation({
    mutationFn: async ({ vehicle, metres, waitedMinutes, draft }: PreviewInput) => {
      const { data, response } = await api.GET('/v1/admin/pay-tables/preview', {
        params: { query: { cityId, vehicle, metres, waitedMinutes, ...(draft ?? {}) } },
      });
      if (!data) throw new Error(`pay preview failed with ${response.status}`);
      return data;
    },
  });
}
