import { describe, expect, it } from 'vitest';
import type { ReportOrder } from '../ordering/index.js';
import { restaurantFigures } from './restaurant-report.js';

const clock = { timeZone: 'Asia/Damascus', cutoffMinutes: 4 * 60 };
const at = (iso: string) => new Date(iso);

function order(overrides: Partial<ReportOrder> = {}): ReportOrder {
  return {
    id: crypto.randomUUID(),
    restaurantId: 'r1',
    zoneId: 'z1',
    captainId: 'c1',
    customerAccountId: 'a1',
    status: 'delivered',
    outcome: 'normal',
    currency: 'TRY',
    itemsValue: 10_000n,
    placedAt: at('2026-11-18T09:00:00Z'),
    acceptedAt: at('2026-11-18T09:02:00Z'),
    acceptedBy: 'restaurant',
    prepMin: 15,
    readyAt: at('2026-11-18T09:12:00Z'),
    readyByPickup: false,
    searchStartedAt: null,
    assignedAt: null,
    arrivedAtMerchantAt: at('2026-11-18T09:10:00Z'),
    pickedUpAt: at('2026-11-18T09:14:00Z'),
    deliveredAt: at('2026-11-18T09:30:00Z'),
    promisedAt: at('2026-11-18T09:35:00Z'),
    rejectedBy: null,
    rejectReason: null,
    rejectReasonLabel: null,
    cancelReason: null,
    cancelReasonLabel: null,
    cancelledBy: null,
    cancelledFrom: null,
    cancelResponsible: null,
    firstOrder: false,
    ...overrides,
  };
}

// RA §11's table, row by row.
describe('restaurantFigures', () => {
  const figures = restaurantFigures({
    orders: [
      order(),
      order({ itemsValue: 20_000n, readyAt: at('2026-11-18T09:25:00Z'), readyByPickup: true }),
      order({ acceptedBy: 'admin', status: 'accepted', deliveredAt: null, readyAt: null }),
      order({
        status: 'rejected',
        acceptedAt: null,
        acceptedBy: null,
        rejectReasonLabel: 'المطعم مغلق',
        rejectedBy: 'admin',
      }),
      order({
        status: 'cancelled',
        acceptedAt: null,
        acceptedBy: null,
        cancelReason: 'merchant_auto_cancel',
        cancelledBy: 'system',
        cancelledFrom: 'placed',
      }),
      order({
        status: 'cancelled',
        acceptedAt: null,
        acceptedBy: null,
        cancelReason: 'changed_mind',
        cancelledBy: 'customer',
        cancelledFrom: 'placed',
      }),
    ],
    items: [
      { itemId: 'i1', name: 'شاورما', currency: 'TRY', quantity: 3, sales: 9_000n },
      { itemId: 'i2', name: 'فلافل', currency: 'TRY', quantity: 5, sales: 5_000n },
    ],
    rating: { count: 2, total: 9 },
    pauses: new Map([['auto', 30]]),
    money: { commission: 4_500n, discounts: 1_000n },
    currency: 'TRY',
    clock,
  });

  it('counts the answers and the acceptance rate without the customer’s own cancellation', () => {
    expect(figures).toMatchObject({
      received: 6,
      acceptedByYou: 2,
      acceptedByOperations: 1,
      rejected: 1,
      rejections: [{ label: 'المطعم مغلق', byOperations: true, count: 1 }],
      unanswered: 1,
      // 2 of 6 − 1.
      acceptanceBp: 4000,
    });
  });

  it('adds the sales, the average order and the net from the account’s entries', () => {
    expect(figures).toMatchObject({
      delivered: 2,
      sales: 30_000n,
      averageOrder: 15_000n,
      commission: 4_500n,
      discounts: 1_000n,
      net: 24_500n,
    });
  });

  it('averages the times and rates the late preparations of the accepted orders', () => {
    expect(figures).toMatchObject({
      acceptMinutes: 2,
      prepActualMinutes: 16.5,
      prepChosenMinutes: 15,
      // One of the three accepted was ready after its 15 minutes.
      lateBp: 3333,
      readyNotPressed: 1,
      captainWaitMinutes: 4,
      rating: { count: 2, average: 4.5 },
      pauseMinutes: { restaurant: 0, ops: 0, auto: 30 },
    });
  });

  it('ranks the top items and counts the delivered orders by hour from the cutoff', () => {
    expect(figures.topByQuantity.map((item) => item.name)).toEqual(['فلافل', 'شاورما']);
    expect(figures.topBySales.map((item) => item.name)).toEqual(['شاورما', 'فلافل']);
    expect(figures.hours[0]).toEqual({ hour: 4, delivered: 0 });
    expect(figures.hours.find((row) => row.hour === 12)).toEqual({ hour: 12, delivered: 2 });
  });
});
