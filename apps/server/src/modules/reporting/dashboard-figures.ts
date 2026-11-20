import type { Availability, MapCaptain } from '../captains/index.js';

// «لوحة التحكم» (AP §9.1; slice 2.40): the dashboard's pure figures, from
// the orders ordering reads (`DashboardOrdersService.placedBetween`) and the
// states the captains and merchants modules answer.

// One order placed in the window, test orders and free re-deliveries left
// out.
export interface DashboardOrder {
  restaurantId: string;
  status: string;
  placedAt: Date;
  deliveredAt: Date | null;
  promisedAt: Date | null;
  // Rejected by the restaurant (or on its behalf).
  rejected: boolean;
  // Ready after its prep time (acceptance plus the prep time chosen), or
  // still not ready past it.
  late: boolean;
  // The customer's first order ever.
  firstOrder: boolean;
}

const ACTIVE = new Set(['placed', 'accepted', 'ready', 'picked_up', 'arrived']);

// AP §9.1.2: the orders placed by `until`, counted by their status now.
export interface OrderTiles {
  placed: number;
  delivered: number;
  inProgress: number;
  cancelled: number;
  rejected: number;
  failed: number;
  // Of the delivered: the average minutes from placing to delivery, one
  // decimal; the share delivered at or before the promised time, in basis
  // points. Null without one.
  deliveryMinutes: number | null;
  onTimeBp: number | null;
  // Delivered ÷ placed, in basis points; null without an order.
  successBp: number | null;
  firstOrders: number;
}

export function orderTiles(rows: readonly DashboardOrder[], until: Date): OrderTiles {
  const placed = rows.filter((row) => row.placedAt.getTime() < until.getTime());
  const count = (status: string) => placed.filter((row) => row.status === status).length;
  const delivered = placed.filter((row) => row.status === 'delivered' && row.deliveredAt !== null);
  const minutes = delivered.map(
    (row) => (row.deliveredAt!.getTime() - row.placedAt.getTime()) / 60_000,
  );
  const promised = delivered.filter((row) => row.promisedAt !== null);
  const onTime = promised.filter(
    (row) => row.deliveredAt!.getTime() <= row.promisedAt!.getTime(),
  ).length;
  return {
    placed: placed.length,
    delivered: count('delivered'),
    inProgress: placed.filter((row) => ACTIVE.has(row.status)).length,
    cancelled: count('cancelled'),
    rejected: count('rejected'),
    failed: count('failed'),
    deliveryMinutes:
      minutes.length === 0
        ? null
        : Math.round((minutes.reduce((total, each) => total + each, 0) / minutes.length) * 10) / 10,
    onTimeBp: promised.length === 0 ? null : Math.round((onTime * 10_000) / promised.length),
    successBp:
      placed.length === 0 ? null : Math.round((count('delivered') * 10_000) / placed.length),
    firstOrders: placed.filter((row) => row.firstOrder).length,
  };
}

const HOUR_MS = 3_600_000;

// AP §9.1.5: the orders placed in each of `hours` hours from `from`.
export function hourlyCounts(rows: readonly DashboardOrder[], from: Date, hours: number): number[] {
  const counts = Array.from({ length: hours }, () => 0);
  for (const row of rows) {
    const hour = Math.floor((row.placedAt.getTime() - from.getTime()) / HOUR_MS);
    if (hour >= 0 && hour < hours) counts[hour]! += 1;
  }
  return counts;
}

// AP §9.1.5 «Top restaurants today by orders», most first.
export function topRestaurants(
  rows: readonly DashboardOrder[],
  limit: number,
): { restaurantId: string; orders: number }[] {
  const counts = new Map<string, number>();
  for (const row of rows) counts.set(row.restaurantId, (counts.get(row.restaurantId) ?? 0) + 1);
  return [...counts]
    .map(([restaurantId, orders]) => ({ restaurantId, orders }))
    .sort((a, b) => b.orders - a.orders || a.restaurantId.localeCompare(b.restaurantId))
    .slice(0, limit);
}

// AP §9.1.5 «Restaurants with the most rejections or delays today»: the
// restaurants with either, by their sum, most first.
export function troubledRestaurants(
  rows: readonly DashboardOrder[],
  limit: number,
): { restaurantId: string; rejected: number; late: number }[] {
  const counts = new Map<string, { rejected: number; late: number }>();
  for (const row of rows) {
    if (!row.rejected && !row.late) continue;
    const each = counts.get(row.restaurantId) ?? { rejected: 0, late: 0 };
    if (row.rejected) each.rejected += 1;
    if (row.late) each.late += 1;
    counts.set(row.restaurantId, each);
  }
  return [...counts]
    .map(([restaurantId, each]) => ({ restaurantId, ...each }))
    .sort(
      (a, b) =>
        b.rejected + b.late - (a.rejected + a.late) || a.restaurantId.localeCompare(b.restaurantId),
    )
    .slice(0, limit);
}

// AP §9.1.1 «Captains»: online (any state but offline and suspended),
// available (receiving offers), busy (an order, last-order mode included)
// and blocked for cash (any cash block, as the daily report counts them).
export function captainCounts(captains: readonly Pick<MapCaptain, 'state' | 'blocks'>[]) {
  const is = (...states: Availability['state'][]) =>
    captains.filter((captain) => states.includes(captain.state)).length;
  return {
    online: captains.filter(
      (captain) => captain.state !== 'offline' && captain.state !== 'suspended',
    ).length,
    available: is('online_available'),
    busy: is('busy', 'last_order'),
    cashBlocked: captains.filter((captain) => captain.blocks.length > 0).length,
  };
}

export const dashboardRestaurantStates = [
  'open',
  'busy',
  'paused',
  'closed',
  'holiday',
  'suspended',
] as const;
export type DashboardRestaurantState = (typeof dashboardRestaurantStates)[number];

// AP §9.1.1 «Restaurants»: busy is at its maximum active orders (RA §7.4),
// closed is by the schedule, a holiday close counted apart.
export function restaurantCounts(
  states: readonly DashboardRestaurantState[],
): Record<DashboardRestaurantState, number> {
  return Object.fromEntries(
    dashboardRestaurantStates.map((state) => [
      state,
      states.filter((each) => each === state).length,
    ]),
  ) as Record<DashboardRestaurantState, number>;
}

// AP §9.1.4 «المهام», in the spec's order.
export const dashboardTaskKeys = [
  'compensationApprovals',
  'menuChanges',
  'applications',
  'probationReviews',
  'expiringDocuments',
  'acceptanceReviews',
  'shortfalls',
  'cashBlocked',
  'settlementsDue',
  'overdueRestaurants',
  'payoutsDue',
] as const;
export type DashboardTaskKey = (typeof dashboardTaskKeys)[number];

// The roles each task is for: the recipients of the alert it counts (AP
// §9.1.3), the spec's for the approvals (OWN) and the menu changes (OWN,
// OPS), and, for those with no alert, ours: the cash blocks as «كابتن بلغ حد
// العهدة» (OWN, OPS, FIN), the restaurants' settlements and the captains'
// payouts the desk's (OWN, FIN).
const TASK_ROLES: Record<DashboardTaskKey, readonly string[]> = {
  compensationApprovals: ['OWN'],
  menuChanges: ['OWN', 'OPS'],
  applications: ['OWN', 'OPS'],
  probationReviews: ['OWN', 'OPS'],
  expiringDocuments: ['OWN', 'OPS'],
  acceptanceReviews: ['OWN', 'OPS'],
  shortfalls: ['OWN', 'OPS', 'FIN'],
  cashBlocked: ['OWN', 'OPS', 'FIN'],
  settlementsDue: ['OWN', 'FIN'],
  overdueRestaurants: ['OWN', 'FIN'],
  payoutsDue: ['OWN', 'FIN'],
};

export function taskForRoles(key: DashboardTaskKey, roles: readonly string[]): boolean {
  return TASK_ROLES[key].some((role) => roles.includes(role));
}

// The tasks the roles get, with their counts; a null count (the payouts off
// the payout day) leaves the task out.
export function dashboardTasks(
  roles: readonly string[],
  counts: Record<DashboardTaskKey, number | null>,
): { key: DashboardTaskKey; count: number }[] {
  return dashboardTaskKeys.flatMap((key) => {
    const count = counts[key];
    return count === null || !taskForRoles(key, roles) ? [] : [{ key, count }];
  });
}
