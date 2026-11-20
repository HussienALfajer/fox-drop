import type { components } from '@fox-drop/api-schema';
import { queryOptions } from '@tanstack/react-query';
import { api } from './api.js';
import { type AdminSession, can } from './session.js';

export type Dashboard = components['schemas']['AdminDashboardDto_Output'];
export type DashboardPeriod = Dashboard['today'];
export type TaskKey = Dashboard['tasks'][number]['key'];

export const DASHBOARD_READ = 'dashboard.read';

export function canSeeDashboard(session: AdminSession | null | undefined): boolean {
  return can(session, DASHBOARD_READ);
}

// AP §9.1: the figures change with every order, so the page reads them again
// every minute (decided by us; the alerts below are live over the channel).
export const DASHBOARD_POLL_MS = 60_000;

export function dashboardQuery(cityId: string) {
  return queryOptions({
    queryKey: ['dashboard', cityId],
    queryFn: async (): Promise<Dashboard> => {
      const { data, response } = await api.GET('/v1/admin/dashboard', {
        params: { query: { cityId } },
      });
      if (!data) throw new Error(`The dashboard read failed with ${response.status}.`);
      return data;
    },
    refetchInterval: DASHBOARD_POLL_MS,
  });
}

// One tile's value: a count, an amount in the base (minor units as text),
// minutes or a share in basis points; null when there is nothing to count.
export type TileValue =
  | { kind: 'count'; value: number }
  | { kind: 'money'; amount: string; currency: string }
  | { kind: 'minutes'; value: number }
  | { kind: 'percent'; bp: number }
  | null;

export type TileKey =
  | 'placed'
  | 'delivered'
  | 'inProgress'
  | 'cancelled'
  | 'rejected'
  | 'failed'
  | 'gmv'
  | 'itemsValue'
  | 'deliveryFees'
  | 'commission'
  | 'margin'
  | 'deliveryMinutes'
  | 'onTime'
  | 'success'
  | 'newCustomers'
  | 'firstOrders';

const count = (value: number): TileValue => ({ kind: 'count', value });
const money =
  (pick: (money: NonNullable<DashboardPeriod['money']>) => string) =>
  (period: DashboardPeriod): TileValue =>
    period.money && { kind: 'money', amount: pick(period.money), currency: period.money.currency };
const percent = (bp: number | null): TileValue => (bp === null ? null : { kind: 'percent', bp });

// AP §9.1.2's tiles, in its order.
export const tileLines: [TileKey, (period: DashboardPeriod) => TileValue][] = [
  ['placed', (p) => count(p.orders.placed)],
  ['delivered', (p) => count(p.orders.delivered)],
  ['inProgress', (p) => count(p.orders.inProgress)],
  ['cancelled', (p) => count(p.orders.cancelled)],
  ['rejected', (p) => count(p.orders.rejected)],
  ['failed', (p) => count(p.orders.failed)],
  ['gmv', money((m) => m.gmv)],
  ['itemsValue', money((m) => m.itemsValue)],
  ['deliveryFees', money((m) => m.deliveryFees)],
  ['commission', money((m) => m.commission)],
  ['margin', money((m) => m.margin)],
  [
    'deliveryMinutes',
    (p) =>
      p.orders.deliveryMinutes === null
        ? null
        : { kind: 'minutes', value: p.orders.deliveryMinutes },
  ],
  ['onTime', (p) => percent(p.orders.onTimeBp)],
  ['success', (p) => percent(p.orders.successBp)],
  ['newCustomers', (p) => count(p.newCustomers)],
  ['firstOrders', (p) => count(p.orders.firstOrders)],
];

// Today against last week: the difference in the tile's own kind, a
// percentage's in points; null when either side has nothing or the money's
// currencies differ.
export function changeOf(today: TileValue, lastWeek: TileValue): TileValue {
  if (today === null || lastWeek === null || today.kind !== lastWeek.kind) return null;
  switch (today.kind) {
    case 'count':
    case 'minutes':
      return {
        kind: today.kind,
        value: Math.round((today.value - (lastWeek as { value: number }).value) * 10) / 10,
      };
    case 'percent':
      return { kind: 'percent', bp: today.bp - (lastWeek as { bp: number }).bp };
    case 'money': {
      const last = lastWeek as { amount: string; currency: string };
      if (last.currency !== today.currency) return null;
      return {
        kind: 'money',
        amount: (BigInt(today.amount) - BigInt(last.amount)).toString(),
        currency: today.currency,
      };
    }
  }
}

// AP §9.1.4: each task's page. The alerts of a captain (probation,
// documents, acceptance) and the shortfalls open from `/alerts`, whose lines
// link the captain or the order.
export const taskPaths = {
  compensationApprovals: '/compensations',
  menuChanges: '/menu-change-requests',
  applications: '/captain-applications',
  probationReviews: '/alerts',
  expiringDocuments: '/alerts',
  acceptanceReviews: '/alerts',
  shortfalls: '/alerts',
  cashBlocked: '/captains',
  settlementsDue: '/cash-desk/restaurants',
  overdueRestaurants: '/cash-desk/restaurants',
  payoutsDue: '/cash-desk/settlements',
} as const satisfies Record<TaskKey, string>;
