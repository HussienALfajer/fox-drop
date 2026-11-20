import { describe, expect, it } from 'vitest';
import {
  captainCounts,
  dashboardTaskKeys,
  dashboardTasks,
  type DashboardOrder,
  hourlyCounts,
  orderTiles,
  restaurantCounts,
  topRestaurants,
  troubledRestaurants,
} from './dashboard-figures.js';

const at = (iso: string) => new Date(iso);

function order(overrides: Partial<DashboardOrder> = {}): DashboardOrder {
  return {
    restaurantId: 'r1',
    status: 'delivered',
    placedAt: at('2026-11-20T08:00:00Z'),
    deliveredAt: at('2026-11-20T08:40:00Z'),
    promisedAt: at('2026-11-20T08:45:00Z'),
    rejected: false,
    late: false,
    firstOrder: false,
    ...overrides,
  };
}

describe('orderTiles (AP §9.1.2)', () => {
  it('counts the orders placed by the moment by their status now', () => {
    const tiles = orderTiles(
      [
        order(),
        order({ status: 'accepted', deliveredAt: null }),
        order({ status: 'picked_up', deliveredAt: null }),
        order({ status: 'cancelled', deliveredAt: null }),
        order({ status: 'rejected', deliveredAt: null, rejected: true }),
        order({ status: 'failed', deliveredAt: null }),
        // Placed after the moment: left out.
        order({ placedAt: at('2026-11-20T10:00:00Z') }),
      ],
      at('2026-11-20T09:00:00Z'),
    );
    expect(tiles).toMatchObject({
      placed: 6,
      delivered: 1,
      inProgress: 2,
      cancelled: 1,
      rejected: 1,
      failed: 1,
    });
  });

  it('averages the delivery minutes, the on-time and the success rates', () => {
    const tiles = orderTiles(
      [
        // 40 minutes, on time.
        order(),
        // 60 minutes, 5 late.
        order({
          deliveredAt: at('2026-11-20T09:00:00Z'),
          promisedAt: at('2026-11-20T08:55:00Z'),
        }),
        order({ status: 'cancelled', deliveredAt: null }),
        order({ status: 'accepted', deliveredAt: null }),
      ],
      at('2026-11-20T12:00:00Z'),
    );
    expect(tiles.deliveryMinutes).toBe(50);
    // 1 of the 2 delivered.
    expect(tiles.onTimeBp).toBe(5000);
    // 2 delivered of 4 placed.
    expect(tiles.successBp).toBe(5000);
  });

  it('answers null rates without an order to count', () => {
    const tiles = orderTiles([], at('2026-11-20T12:00:00Z'));
    expect(tiles).toMatchObject({
      placed: 0,
      deliveryMinutes: null,
      onTimeBp: null,
      successBp: null,
      firstOrders: 0,
    });
  });

  it('counts the first orders', () => {
    const tiles = orderTiles(
      [order({ firstOrder: true }), order({ firstOrder: true }), order()],
      at('2026-11-20T12:00:00Z'),
    );
    expect(tiles.firstOrders).toBe(2);
  });
});

describe('hourlyCounts (AP §9.1.5)', () => {
  it('counts the orders placed in each hour from the start', () => {
    const from = at('2026-11-20T01:00:00Z');
    expect(
      hourlyCounts(
        [
          order({ placedAt: at('2026-11-20T01:00:00Z') }),
          order({ placedAt: at('2026-11-20T01:59:59Z') }),
          order({ placedAt: at('2026-11-20T03:30:00Z') }),
          // Outside the hours: left out.
          order({ placedAt: at('2026-11-20T05:00:00Z') }),
          order({ placedAt: at('2026-11-20T00:59:00Z') }),
        ],
        from,
        4,
      ),
    ).toEqual([2, 0, 1, 0]);
  });
});

describe('the restaurants lists (AP §9.1.5)', () => {
  it('ranks the restaurants by their orders, most first', () => {
    expect(
      topRestaurants(
        [order({ restaurantId: 'a' }), order({ restaurantId: 'b' }), order({ restaurantId: 'b' })],
        5,
      ),
    ).toEqual([
      { restaurantId: 'b', orders: 2 },
      { restaurantId: 'a', orders: 1 },
    ]);
  });

  it('keeps the limit', () => {
    expect(
      topRestaurants([order({ restaurantId: 'a' }), order({ restaurantId: 'b' })], 1),
    ).toHaveLength(1);
  });

  it('ranks the restaurants by rejections and delays, without the ones with none', () => {
    expect(
      troubledRestaurants(
        [
          order({ restaurantId: 'a', rejected: true, status: 'rejected' }),
          order({ restaurantId: 'b', late: true }),
          order({ restaurantId: 'b', late: true }),
          order({ restaurantId: 'c' }),
        ],
        5,
      ),
    ).toEqual([
      { restaurantId: 'b', rejected: 0, late: 2 },
      { restaurantId: 'a', rejected: 1, late: 0 },
    ]);
  });
});

describe('the status strip (AP §9.1.1)', () => {
  it('counts the captains online, available, busy and blocked for cash', () => {
    expect(
      captainCounts([
        { state: 'offline', blocks: [] },
        { state: 'offline', blocks: ['closed_due'] },
        { state: 'online_available', blocks: [] },
        { state: 'busy', blocks: [] },
        { state: 'last_order', blocks: [] },
        { state: 'not_receiving_offers', blocks: ['cash_limit'] },
        { state: 'suspended', blocks: [] },
      ]),
    ).toEqual({ online: 4, available: 1, busy: 2, cashBlocked: 2 });
  });

  it('counts the restaurants by their state', () => {
    expect(
      restaurantCounts(['open', 'open', 'busy', 'paused', 'closed', 'holiday', 'suspended']),
    ).toEqual({ open: 2, busy: 1, paused: 1, closed: 1, holiday: 1, suspended: 1 });
  });
});

describe('the tasks (AP §9.1.4)', () => {
  const counts = {
    compensationApprovals: 1,
    menuChanges: 2,
    applications: 3,
    probationReviews: 4,
    expiringDocuments: 5,
    acceptanceReviews: 6,
    shortfalls: 7,
    cashBlocked: 8,
    settlementsDue: 9,
    overdueRestaurants: 10,
    payoutsDue: 11,
  };

  it('gives OWN every task', () => {
    expect(dashboardTasks(['OWN'], counts).map((task) => task.key)).toEqual(dashboardTaskKeys);
  });

  it('filters the tasks to the roles', () => {
    expect(dashboardTasks(['OPS'], counts).map((task) => task.key)).toEqual([
      'menuChanges',
      'applications',
      'probationReviews',
      'expiringDocuments',
      'acceptanceReviews',
      'shortfalls',
      'cashBlocked',
    ]);
    expect(dashboardTasks(['FIN'], counts).map((task) => task.key)).toEqual([
      'shortfalls',
      'cashBlocked',
      'settlementsDue',
      'overdueRestaurants',
      'payoutsDue',
    ]);
    expect(dashboardTasks(['SUP'], counts)).toEqual([]);
  });

  it('leaves out the payouts off the payout day', () => {
    expect(
      dashboardTasks(['FIN'], { ...counts, payoutsDue: null }).map((task) => task.key),
    ).not.toContain('payoutsDue');
  });

  it('carries each count', () => {
    expect(dashboardTasks(['OWN'], counts)[0]).toEqual({ key: 'compensationApprovals', count: 1 });
  });
});
