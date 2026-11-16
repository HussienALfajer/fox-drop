import { useMutation, useQuery } from '@tanstack/react-query';
import type { components } from '@fox-drop/api-schema';
import { useRef } from 'react';
import { api } from './api.js';

// AP §6.2 «Statements and settlement» of restaurants: OWN, FIN.
export const RESTAURANT_STATEMENTS = 'restaurants.statements';

export type PeriodStatement = components['schemas']['AdminRestaurantPeriodStatementDto_Output'];
export type PeriodStatementLine = PeriodStatement['lines'][number];
export type StatementRestaurant =
  components['schemas']['AdminStatementRestaurantsDto_Output']['restaurants'][number];
export type StatementExport = components['schemas']['AdminExportDto_Output'];

// The longest period the server takes: a year and a day.
export const PERIOD_MAX_DAYS = 366;
// How often a pending export is read again, and how long the screen waits
// for it before saying it failed (the worker retries a failure for about an
// hour, and the export has no failed state yet).
export const EXPORT_POLL_MS = 2_000;
export const EXPORT_WAIT_MS = 10 * 60_000;

// Whether the screen gave up on an export asked at `startedAt`.
export function exportGaveUp(startedAt: number, now: number): boolean {
  return now - startedAt >= EXPORT_WAIT_MS;
}

export interface Period {
  restaurantId: string;
  from: string;
  to: string;
}

// Today on the city's clock, YYYY-MM-DD.
export function todayOn(now: Date, timeZone: string): string {
  return new Intl.DateTimeFormat('en-CA', {
    timeZone,
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
  }).format(now);
}

// The period a screen opens on: this month so far, on the city's clock.
export function defaultPeriod(now: Date, timeZone: string): { from: string; to: string } {
  const to = todayOn(now, timeZone);
  return { from: `${to.slice(0, 8)}01`, to };
}

function isDay(day: string): boolean {
  const at = Date.parse(`${day}T00:00:00Z`);
  return (
    /^\d{4}-\d{2}-\d{2}$/.test(day) &&
    !Number.isNaN(at) &&
    new Date(at).toISOString().startsWith(day)
  );
}

// Whether the server takes the period: two real days, the last not before
// the first, at most PERIOD_MAX_DAYS.
export function periodFits(from: string, to: string): boolean {
  if (!isDay(from) || !isDay(to)) return false;
  const days = (Date.parse(to) - Date.parse(from)) / 86_400_000 + 1;
  return days >= 1 && days <= PERIOD_MAX_DAYS;
}

// What a line is: an order, a payment by the restaurant, the desk paying it
// (a payout, which raises what it owes), or an exception by its cause.
export function entryOf(
  line: PeriodStatementLine,
):
  | { kind: 'order' | 'payment' | 'payout' }
  | { kind: 'exception'; cause: PeriodStatementLine['cause'] } {
  if (line.kind === 'order') return { kind: 'order' };
  if (line.kind === 'payment') {
    return { kind: BigInt(line.amount ?? '0') < 0n ? 'payment' : 'payout' };
  }
  return { kind: 'exception', cause: line.cause };
}

// The city's restaurants to choose from (AP §9.10.5).
export function useStatementRestaurants(cityId: string | undefined) {
  return useQuery({
    queryKey: ['restaurant-statements', 'restaurants', cityId ?? ''],
    enabled: cityId !== undefined,
    queryFn: async (): Promise<StatementRestaurant[]> => {
      const { data } = await api.GET('/v1/admin/restaurant-statements/restaurants', {
        params: { query: { cityId: cityId! } },
      });
      if (!data) throw new Error('The statement restaurants read failed.');
      return data.restaurants;
    },
  });
}

export type PeriodResult =
  | { status: 'ready'; statement: PeriodStatement }
  | { status: 'refused'; refusal: 'invalid_period' | 'unknown_restaurant' };

// A restaurant's statement for the period, once one is chosen.
export function useRestaurantPeriodStatement(period: Period | null) {
  return useQuery({
    queryKey: ['restaurant-statements', 'statement', period],
    enabled: period !== null,
    queryFn: async (): Promise<PeriodResult> => {
      const { data, error, response } = await api.GET('/v1/admin/restaurant-statements', {
        params: { query: period! },
      });
      if (data) return { status: 'ready', statement: data };
      const refusal = (error as { error?: unknown } | undefined)?.error;
      if (refusal === 'invalid_period' || refusal === 'unknown_restaurant') {
        return { status: 'refused', refusal };
      }
      throw new Error(`The restaurant statement read failed with ${response.status}.`);
    },
  });
}

// «تصدير Excel» (architecture §5.9): one key per period until an answer, so
// a retry after a lost answer reads the same export.
export function useExportStatement() {
  const keys = useRef(new Map<string, string>());
  return useMutation({
    mutationFn: async (period: Period): Promise<StatementExport> => {
      const choice = JSON.stringify(period);
      let key = keys.current.get(choice);
      if (key === undefined) {
        key = crypto.randomUUID();
        keys.current.set(choice, key);
      }
      const { data, response } = await api.POST('/v1/admin/restaurant-statements/exports', {
        params: { header: { 'Idempotency-Key': key } },
        body: period,
      });
      if (!data) throw new Error(`The export failed with ${response.status}.`);
      keys.current.delete(choice);
      return data;
    },
  });
}

// The export's state, read again while the worker writes it, until the
// screen gives up on it.
export function useExportState(exportId: string | undefined, startedAt: number) {
  return useQuery({
    queryKey: ['exports', exportId ?? ''],
    enabled: exportId !== undefined,
    refetchInterval: (query) =>
      query.state.data?.status === 'pending' && !exportGaveUp(startedAt, Date.now())
        ? EXPORT_POLL_MS
        : false,
    queryFn: async (): Promise<StatementExport> => {
      const { data, response } = await api.GET('/v1/admin/exports/{exportId}', {
        params: { path: { exportId: exportId! } },
      });
      if (!data) throw new Error(`The export read failed with ${response.status}.`);
      return data;
    },
  });
}

// «تنزيل»: a fresh signed URL (valid 5 minutes, audited by the server) at
// the moment of the click, then the browser follows it.
export function useDownloadExport() {
  return useMutation({
    mutationFn: async (exportId: string): Promise<StatementExport> => {
      const { data, response } = await api.GET('/v1/admin/exports/{exportId}', {
        params: { path: { exportId }, query: { download: 'true' } },
      });
      if (!data) throw new Error(`The export download failed with ${response.status}.`);
      if (data.url) window.location.assign(data.url);
      return data;
    },
  });
}
