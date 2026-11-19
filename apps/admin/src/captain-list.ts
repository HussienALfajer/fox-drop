import type { components } from '@fox-drop/api-schema';
import { keepPreviousData, queryOptions } from '@tanstack/react-query';
import { api } from './api.js';
import { type AdminSession, can } from './session.js';

export type CaptainList = components['schemas']['AdminCaptainListDto_Output'];
export type ListedCaptain = CaptainList['captains'][number];
export type CaptainStatus = ListedCaptain['status'];

// AP §9.7.3, in the filter's order.
export const captainStatuses = [
  'online',
  'busy',
  'offline',
  'suspended',
  'cash_blocked',
  'terminated',
] as const satisfies readonly CaptainStatus[];

// AP §9.7.3 «الكباتن» (slice 2.36a): every reader of captains, and FIN
// (captains.money, AP §6.2).
export function canSeeCaptains(session: AdminSession | null | undefined): boolean {
  return can(session, 'captains.read') || can(session, 'captains.money');
}

// AP §9.7.3 «Filters and sorting: by any column».
export const sortColumns = [
  'name',
  'status',
  'phase',
  'custody',
  'earnings',
  'ordersToday',
  'acceptance',
  'rating',
] as const;
export type SortColumn = (typeof sortColumns)[number];
export type SortDirection = 'asc' | 'desc';

// The list's filters and order as the search keeps them.
export interface CaptainListFilter {
  status?: CaptainStatus;
  q?: string;
  sort?: SortColumn;
  dir?: SortDirection;
}

export function captainListFilterOf(search: Record<string, unknown>): CaptainListFilter {
  const text = (key: string) =>
    typeof search[key] === 'string' && search[key] !== '' ? (search[key] as string) : undefined;
  const status = captainStatuses.find((each) => each === text('status'));
  const sort = sortColumns.find((each) => each === text('sort'));
  const dir = text('dir');
  return {
    ...(status ? { status } : {}),
    ...(text('q') ? { q: text('q')! } : {}),
    ...(sort ? { sort } : {}),
    ...(dir === 'asc' || dir === 'desc' ? { dir } : {}),
  };
}

// The search is a POST, so a number typed never sits in a URL; the panel
// keeps only the name searched in its search parameters (q) and the number
// in the page's state. The order is the panel's own.
export const captainListQuery = (cityId: string, status: CaptainStatus | null, q: string | null) =>
  queryOptions({
    queryKey: ['captain-list', cityId, status, q],
    queryFn: async (): Promise<ListedCaptain[]> => {
      const { data } = await api.POST('/v1/admin/captain-list', {
        body: {
          cityId,
          status,
          q: q?.trim() ? q.trim().slice(0, 60) : null,
        },
      });
      if (!data) throw new Error('The captain list read failed.');
      return data.captains;
    },
    placeholderData: keepPreviousData,
  });

// Of the last offers answered, the share accepted in whole percent; null
// without one.
export function acceptancePercent(captain: Pick<ListedCaptain, 'acceptance'>): number | null {
  const { acceptance } = captain;
  return acceptance === null || acceptance.answered === 0
    ? null
    : Math.round((acceptance.accepted * 100) / acceptance.answered);
}

// The custody's use of the limit in whole percent, for the bar.
export function limitUsePercent(captain: Pick<ListedCaptain, 'custody'>): number {
  const usage = BigInt(captain.custody.usage.amount);
  const limit = BigInt(captain.custody.limit.amount);
  if (limit <= 0n) return 100;
  const percent = Number((usage * 100n) / limit);
  return Math.max(0, Math.min(100, percent));
}

const phaseOrder = { probation: 0, commitment: 1, open: 2 } as const;

// The value a column sorts by: a number, or a text for the name; a captain
// without one (no rating, no offer, no contract) sorts last either way.
function keyOf(captain: ListedCaptain, column: SortColumn): number | string | null {
  switch (column) {
    case 'name':
      return captain.name;
    case 'status':
      return captainStatuses.indexOf(captain.status);
    case 'phase':
      return captain.contractPhase === null ? null : phaseOrder[captain.contractPhase];
    case 'custody':
      return Number(captain.custody.usage.amount);
    case 'earnings':
      return Number(captain.earnings.amount);
    case 'ordersToday':
      return captain.ordersToday;
    case 'acceptance':
      return acceptancePercent(captain);
    case 'rating':
      return captain.ratingAverage;
  }
}

const collator = new Intl.Collator('ar-u-nu-latn');

// The list in the column's order (AP §9.7.3, «highest custody first» is
// custody descending); ties keep the server's order, by name.
export function sortCaptains(
  captains: readonly ListedCaptain[],
  column: SortColumn,
  direction: SortDirection,
): ListedCaptain[] {
  const sign = direction === 'asc' ? 1 : -1;
  return captains
    .map((captain, index) => ({ captain, index, key: keyOf(captain, column) }))
    .sort((a, b) => {
      if (a.key === null || b.key === null) {
        return a.key === b.key ? a.index - b.index : a.key === null ? 1 : -1;
      }
      const order =
        typeof a.key === 'string' && typeof b.key === 'string'
          ? collator.compare(a.key, b.key)
          : (a.key as number) - (b.key as number);
      return order === 0 ? a.index - b.index : sign * order;
    })
    .map((each) => each.captain);
}
