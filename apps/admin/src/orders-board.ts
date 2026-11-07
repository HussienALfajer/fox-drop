import type { components } from '@fox-drop/api-schema';
import { queryOptions } from '@tanstack/react-query';
import { api } from './api.js';

export const OPERATIONS_READ = 'operations.read';

export type OrderCard = components['schemas']['AdminBoardDto_Output']['orders'][number];
export type OrderStatus = OrderCard['status'];

// Until the ops: channel exists the board and the detail read the server
// again every 10 seconds (owner decisions 2026-11-06 and 2026-11-07).
export const POLL_MS = 10_000;

export function boardQuery(cityId: string) {
  return queryOptions({
    queryKey: ['orders-board', cityId],
    queryFn: async (): Promise<OrderCard[]> => {
      const { data } = await api.GET('/v1/admin/orders', { params: { query: { cityId } } });
      if (!data) throw new Error('The board read failed.');
      return data.orders;
    },
    refetchInterval: POLL_MS,
  });
}

// AP §9.2.1: the five columns, right to left in the page's direction.
export const COLUMNS = ['placed', 'accepted', 'ready', 'picked_up', 'arrived'] as const;
export type Column = (typeof COLUMNS)[number];

// AP §9.2.1: green within the limit, amber from 80% of it (fixed), red past
// it; null where the column's limit is not built yet (limitAt null).
export type Sla = 'green' | 'amber' | 'red';

export function sla(card: Pick<OrderCard, 'statusSince' | 'limitAt'>, now: number): Sla | null {
  if (card.limitAt === null) return null;
  const since = Date.parse(card.statusSince);
  const limit = Date.parse(card.limitAt);
  if (now >= limit) return 'red';
  if (limit <= since) return 'green';
  return (now - since) / (limit - since) >= 0.8 ? 'amber' : 'green';
}

export function isLate(card: OrderCard, now: number): boolean {
  return sla(card, now) === 'red';
}

// AP §9.2.1's filters that the data has today; tickets and test orders come
// with their slices.
export type BoardFilter = {
  restaurantId: string;
  captainId: string;
  neighbourhood: string;
  lateOnly: boolean;
  noCaptainOnly: boolean;
};

export const NO_FILTER: BoardFilter = {
  restaurantId: '',
  captainId: '',
  neighbourhood: '',
  lateOnly: false,
  noCaptainOnly: false,
};

export function filterCards(cards: OrderCard[], filter: BoardFilter, now: number): OrderCard[] {
  return cards.filter(
    (card) =>
      (filter.restaurantId === '' || card.restaurant.id === filter.restaurantId) &&
      (filter.captainId === '' || card.captain?.id === filter.captainId) &&
      (filter.neighbourhood === '' || card.neighbourhood === filter.neighbourhood) &&
      (!filter.lateOnly || isLate(card, now)) &&
      (!filter.noCaptainOnly || card.captain === null),
  );
}

export type BoardColumn = { status: Column; cards: OrderCard[]; late: number };

// The cards by column, oldest first as the server sends them, with each
// column's count of late cards for its header.
export function columns(cards: OrderCard[], now: number): BoardColumn[] {
  return COLUMNS.map((status) => {
    const inColumn = cards.filter((card) => card.status === status);
    return {
      status,
      cards: inColumn,
      late: inColumn.filter((card) => isLate(card, now)).length,
    };
  });
}

// The filters' choices, from the cards on the board.
export function filterChoices(cards: OrderCard[]) {
  const restaurants = new Map<string, string>();
  const captains = new Map<string, string>();
  const neighbourhoods = new Set<string>();
  for (const card of cards) {
    restaurants.set(card.restaurant.id, card.restaurant.name);
    if (card.captain) captains.set(card.captain.id, card.captain.name);
    neighbourhoods.add(card.neighbourhood);
  }
  const byName = (a: { name: string }, b: { name: string }) => a.name.localeCompare(b.name, 'ar');
  return {
    restaurants: [...restaurants].map(([id, name]) => ({ id, name })).sort(byName),
    captains: [...captains].map(([id, name]) => ({ id, name })).sort(byName),
    neighbourhoods: [...neighbourhoods].sort((a, b) => a.localeCompare(b, 'ar')),
  };
}

// The time in the current state as minutes and seconds, such as 12:05.
export function elapsed(since: string, now: number): string {
  const seconds = Math.max(0, Math.floor((now - Date.parse(since)) / 1000));
  const minutes = Math.floor(seconds / 60);
  return `${minutes}:${String(seconds % 60).padStart(2, '0')}`;
}
