import type { ReportItem, ReportOrder } from '../ordering/index.js';
import { basisPoints, cityHour, type ReportClock } from './report-tables.js';

// RA §11's periods for the owners; a day of the daily summary is asked by
// its date instead.
export const ownerPeriods = ['today', 'yesterday', 'last_7_days', 'last_30_days'] as const;
export type OwnerPeriod = (typeof ownerPeriods)[number];

export const TOP_ITEMS = 10;

// RA §11: one period's figures for a restaurant's owners, test orders left
// out. Minutes are averages to one decimal; null where there is nothing to
// average or share.
export interface RestaurantFigures {
  received: number;
  acceptedByYou: number;
  acceptedByOperations: number;
  rejected: number;
  rejections: { label: string; byOperations: boolean; count: number }[];
  unanswered: number;
  acceptanceBp: number | null;
  delivered: number;
  // In the restaurant's currency's minor units.
  sales: bigint;
  averageOrder: bigint | null;
  commission: bigint;
  discounts: bigint;
  net: bigint;
  acceptMinutes: number | null;
  prepActualMinutes: number | null;
  prepChosenMinutes: number | null;
  lateBp: number | null;
  readyNotPressed: number;
  captainWaitMinutes: number | null;
  rating: { count: number; average: number | null };
  topByQuantity: ReportItem[];
  topBySales: ReportItem[];
  // Delivered orders by the hour they were placed on the city's clock, the
  // business day's hours in order.
  hours: { hour: number; delivered: number }[];
  pauseMinutes: { restaurant: number; ops: number; auto: number };
}

export interface RestaurantFiguresInput {
  orders: readonly ReportOrder[];
  items: readonly ReportItem[];
  rating: { count: number; total: number } | undefined;
  pauses: ReadonlyMap<string, number> | undefined;
  // The restaurant account's entries of the period (RA §12): the
  // commission (less what was reversed) and the restaurant-funded
  // discounts, + the restaurant owes.
  money: { commission: bigint; discounts: bigint };
  currency: string;
  clock: ReportClock;
}

const average = (values: readonly number[]): number | null =>
  values.length === 0
    ? null
    : Math.round((values.reduce((sum, value) => sum + value, 0) / values.length) * 10) / 10;

const minutes = (from: Date | null, to: Date | null): number | null =>
  from === null || to === null ? null : (to.getTime() - from.getTime()) / 60_000;

const kept = (values: (number | null)[]) =>
  values.filter((value): value is number => value !== null && value >= 0);

// The rules of RA §11's table, each as its row defines it.
export function restaurantFigures(input: RestaurantFiguresInput): RestaurantFigures {
  const { orders } = input;
  const acceptedByYou = orders.filter((row) => row.acceptedBy === 'restaurant');
  const acceptedByOperations = orders.filter((row) => row.acceptedBy === 'admin');
  const accepted = orders.filter((row) => row.acceptedAt !== null);
  const rejected = orders.filter((row) => row.status === 'rejected');
  const unanswered = orders.filter((row) => row.cancelReason === 'merchant_auto_cancel');
  // Cancelled by the customer before any answer: no answer was asked of the
  // restaurant, so the rate leaves it out.
  const cancelledFirst = orders.filter(
    (row) => row.cancelledBy === 'customer' && row.cancelledFrom === 'placed',
  ).length;
  const delivered = orders.filter((row) => row.status === 'delivered');
  const sales = delivered
    .filter((row) => row.currency === input.currency)
    .reduce((total, row) => total + row.itemsValue, 0n);
  const rejections = new Map<string, { label: string; byOperations: boolean; count: number }>();
  for (const row of rejected) {
    const label = row.rejectReasonLabel ?? row.rejectReason ?? '';
    const byOperations = row.rejectedBy === 'admin';
    const key = `${label}|${byOperations}`;
    const found = rejections.get(key) ?? { label, byOperations, count: 0 };
    found.count += 1;
    rejections.set(key, found);
  }
  // Ready after the prep time chosen, or picked up after it when ready was
  // not pressed (its ready_at is the pickup's), of the accepted orders.
  const prepared = accepted.filter((row) => row.readyAt !== null && row.prepMin !== null);
  const late = prepared.filter((row) => minutes(row.acceptedAt, row.readyAt)! > row.prepMin!);
  const byHour = new Map<number, number>();
  for (const row of delivered) {
    const hour = cityHour(row.placedAt, input.clock);
    byHour.set(hour, (byHour.get(hour) ?? 0) + 1);
  }
  const first = Math.floor(input.clock.cutoffMinutes / 60);
  const top = (by: (item: ReportItem) => bigint | number) =>
    [...input.items]
      .sort((a, b) => {
        const difference = Number(by(b)) - Number(by(a));
        return difference !== 0 ? difference : a.name.localeCompare(b.name, 'ar');
      })
      .slice(0, TOP_ITEMS);
  return {
    received: orders.length,
    acceptedByYou: acceptedByYou.length,
    acceptedByOperations: acceptedByOperations.length,
    rejected: rejected.length,
    rejections: [...rejections.values()].sort((a, b) => b.count - a.count),
    unanswered: unanswered.length,
    acceptanceBp: basisPoints(acceptedByYou.length, orders.length - cancelledFirst),
    delivered: delivered.length,
    sales,
    averageOrder: delivered.length === 0 ? null : sales / BigInt(delivered.length),
    commission: input.money.commission,
    discounts: input.money.discounts,
    net: sales - input.money.commission - input.money.discounts,
    acceptMinutes: average(kept(acceptedByYou.map((row) => minutes(row.placedAt, row.acceptedAt)))),
    prepActualMinutes: average(kept(prepared.map((row) => minutes(row.acceptedAt, row.readyAt)))),
    prepChosenMinutes: average(prepared.map((row) => row.prepMin!)),
    lateBp: basisPoints(late.length, accepted.length),
    readyNotPressed: orders.filter((row) => row.readyByPickup).length,
    captainWaitMinutes: average(
      kept(orders.map((row) => minutes(row.arrivedAtMerchantAt, row.pickedUpAt))),
    ),
    rating: {
      count: input.rating?.count ?? 0,
      average:
        input.rating === undefined || input.rating.count === 0
          ? null
          : Math.round((input.rating.total / input.rating.count) * 10) / 10,
    },
    topByQuantity: top((item) => item.quantity),
    topBySales: top((item) => item.sales),
    hours: Array.from({ length: 24 }, (_, index) => {
      const hour = (first + index) % 24;
      return { hour, delivered: byHour.get(hour) ?? 0 };
    }),
    pauseMinutes: {
      restaurant: input.pauses?.get('restaurant') ?? 0,
      ops: input.pauses?.get('ops') ?? 0,
      auto: input.pauses?.get('auto') ?? 0,
    },
  };
}
