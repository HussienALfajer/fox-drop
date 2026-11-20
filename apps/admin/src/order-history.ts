import type { components } from '@fox-drop/api-schema';
import { useInfiniteQuery, useMutation } from '@tanstack/react-query';
import { useRef } from 'react';
import { api } from './api.js';
import type { StatementExport } from './restaurant-statements.js';
import { periodFits } from './restaurant-statements.js';
import { type AdminSession, can } from './session.js';

// AP §6.2 «سجل الطلبات»: OWN and OPS in full, SUP and FIN read, FIN with
// the financial correction.
export const ORDER_HISTORY_READ = 'order_history.read';
export const FINANCIAL_CORRECTION = 'order_history.financial_correction';
// AP §9.5, the rule of AP §7.2: the customer's phone for OWN, OPS and SUP.
export const REVEAL_PHONE = 'customers.reveal_phone';

export const canSeeOrderHistory = (session: AdminSession) => can(session, ORDER_HISTORY_READ);
export const canSearchByPhone = (session: AdminSession) => can(session, REVEAL_PHONE);

type HistoryBody = components['schemas']['AdminOrderHistoryQueryDto'];
export type HistoryRow = components['schemas']['AdminOrderHistoryDto_Output']['orders'][number];
export type OrderStatus = NonNullable<HistoryBody['status']>;
export type OrderOutcome = NonNullable<HistoryBody['outcome']>;
export type Responsible = NonNullable<HistoryBody['responsible']>;
export type HistoryKind = HistoryBody['kind'];

export const STATUSES = [
  'placed',
  'accepted',
  'ready',
  'picked_up',
  'arrived',
  'delivered',
  'rejected',
  'cancelled',
  'failed',
] as const satisfies readonly OrderStatus[];
export const OUTCOMES = [
  'normal',
  'free',
  'fake',
  'damaged',
  'wrong_refused',
  'failed_other',
] as const satisfies readonly OrderOutcome[];
export const RESPONSIBLES = [
  'restaurant',
  'captain',
  'customer',
  'platform',
] as const satisfies readonly Responsible[];
export const KINDS = ['all', 'real', 'test'] as const satisfies readonly HistoryKind[];

// The filters kept in the URL: every one but the customer's phone, which
// stays in the page's state and the POST's body only.
export interface HistorySearch {
  number?: string;
  restaurant?: string;
  captain?: string;
  from?: string;
  to?: string;
  status?: OrderStatus;
  outcome?: OrderOutcome;
  responsible?: Responsible;
  code?: string;
  zone?: string;
  kind?: HistoryKind;
}

const UUID = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/;
const DAY = /^\d{4}-\d{2}-\d{2}$/;
const oneOf = <T extends string>(choices: readonly T[], value: unknown): T | undefined =>
  (choices as readonly unknown[]).includes(value) ? (value as T) : undefined;

// The route's search: a value that is not one of the filter's is dropped.
export function historySearchOf(search: Record<string, unknown>): HistorySearch {
  const text = (key: string, pattern: RegExp) => {
    const value = search[key];
    return typeof value === 'string' && pattern.test(value) ? value : undefined;
  };
  const picked: { [Key in keyof HistorySearch]-?: HistorySearch[Key] | undefined } = {
    number: text('number', /^#?\d{1,12}$/),
    restaurant: text('restaurant', UUID),
    captain: text('captain', UUID),
    from: text('from', DAY),
    to: text('to', DAY),
    status: oneOf(STATUSES, search.status),
    outcome: oneOf(OUTCOMES, search.outcome),
    responsible: oneOf(RESPONSIBLES, search.responsible),
    code: text('code', /^\S{1,40}$/),
    zone: text('zone', UUID),
    kind: oneOf(KINDS, search.kind),
  };
  return Object.fromEntries(
    Object.entries(picked).filter(([, value]) => value !== undefined),
  ) as HistorySearch;
}

// The body of the list and of the export.
export function historyBodyOf(
  cityId: string,
  search: HistorySearch,
  phone: string,
): Omit<HistoryBody, 'cursor'> {
  return {
    cityId,
    number: search.number ?? null,
    customerPhone: phone.trim() === '' ? null : phone.trim(),
    restaurantId: search.restaurant ?? null,
    captainId: search.captain ?? null,
    from: search.from ?? null,
    to: search.to ?? null,
    status: search.status ?? null,
    outcome: search.outcome ?? null,
    responsible: search.responsible ?? null,
    code: search.code ?? null,
    zoneId: search.zone ?? null,
    kind: search.kind ?? 'all',
  };
}

// The export needs a period of business days, at most 366 (as the server).
export const canExport = (search: HistorySearch) =>
  search.from !== undefined && search.to !== undefined && periodFits(search.from, search.to);

export type HistoryRefusal = 'invalid_period' | 'invalid_phone' | 'phone_not_allowed';
const REFUSALS: readonly HistoryRefusal[] = [
  'invalid_period',
  'invalid_phone',
  'phone_not_allowed',
];

export class HistoryRefusedError extends Error {
  constructor(readonly refusal: HistoryRefusal) {
    super(refusal);
  }
}

function refusalOf(error: unknown): HistoryRefusal | null {
  const refusal = (error as { error?: unknown } | undefined)?.error;
  return REFUSALS.includes(refusal as HistoryRefusal) ? (refusal as HistoryRefusal) : null;
}

// The pages, 50 orders each, read on «عرض المزيد».
export function useOrderHistory(body: Omit<HistoryBody, 'cursor'> | null) {
  return useInfiniteQuery({
    queryKey: ['order-history', body],
    enabled: body !== null,
    initialPageParam: null as string | null,
    getNextPageParam: (page: { next: string | null }) => page.next,
    retry: (count, error) => !(error instanceof HistoryRefusedError) && count < 3,
    queryFn: async ({ pageParam }) => {
      const { data, error, response } = await api.POST('/v1/admin/order-history', {
        body: { ...body!, cursor: pageParam },
      });
      if (data) return data;
      const refusal = refusalOf(error);
      if (refusal) throw new HistoryRefusedError(refusal);
      throw new Error(`The order history read failed with ${response.status}.`);
    },
  });
}

// «تصدير Excel» of the filters and their period: one key per body until an
// answer, as the statement's.
export function useExportOrderHistory() {
  const keys = useRef(new Map<string, string>());
  return useMutation({
    mutationFn: async (body: Omit<HistoryBody, 'cursor'>): Promise<StatementExport> => {
      const choice = JSON.stringify(body);
      let key = keys.current.get(choice);
      if (key === undefined) {
        key = crypto.randomUUID();
        keys.current.set(choice, key);
      }
      const { data, response } = await api.POST('/v1/admin/order-history/exports', {
        params: { header: { 'Idempotency-Key': key } },
        body: { ...body, from: body.from!, to: body.to! },
      });
      if (!data) throw new Error(`The export failed with ${response.status}.`);
      keys.current.delete(choice);
      return data;
    },
  });
}
