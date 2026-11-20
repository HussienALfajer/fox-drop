import { Inject, Injectable } from '@nestjs/common';
import { and, desc, eq, gte, inArray, isNotNull, lt, notInArray, or, type SQL } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { CaptainsService } from '../captains/index.js';
import { cutoffOn, GeoService, lastCutoff } from '../geo/index.js';
import { MerchantsService } from '../merchants/index.js';
import { SettingsService } from '../settings/index.js';
import { UNTIL_ENDED } from './active-orders.js';
import type { PaymentLine } from './pickup-booking.js';
import { type OrderView, readOrders } from './order-views.js';
import { handovers, orders, orderStatuses, pickupRequests } from './schema.js';

type OrderStatus = (typeof orderStatuses)[number];

// RA §8.18 and CA §9.13 (slice 2.40): the restaurant's and the captain's
// «السجل», newest first, in pages of HISTORY_PAGE.
export const HISTORY_PAGE = 20;
// S12 (owner decision 2026-11-20): a cashier sees today and the 7 business
// days before.
export const CASHIER_DAYS = 7;
// The longest range a history reads at once, as the statements' (a year).
export const HISTORY_MAX_DAYS = 366;

const DAY_MS = 86_400_000;

export type HistoryRefusal = 'invalid_period' | 'cashier_window';

export class HistoryRefusedError extends Error {
  constructor(readonly refusal: HistoryRefusal) {
    super(refusal);
  }
}

// A page's cursor: the placing time and id of its last order.
export interface HistoryCursor {
  placedAt: Date;
  id: string;
}

export interface HistoryRange {
  fromDay?: string;
  toDay?: string;
}

const isDay = (day: string) =>
  /^\d{4}-\d{2}-\d{2}$/.test(day) && new Date(Date.parse(day)).toISOString().startsWith(day);

const dayPlus = (day: string, days: number) =>
  new Date(Date.parse(day) + days * DAY_MS).toISOString().slice(0, 10);

// The business day of a moment, YYYY-MM-DD on the city's clock.
export function businessDayOf(at: Date, cutoffMinutes: number, timeZone: string): string {
  return new Intl.DateTimeFormat('en-CA', {
    timeZone,
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
  }).format(lastCutoff(at, cutoffMinutes, timeZone));
}

// A range of business days the history reads: two real days, the last not
// before the first, at most HISTORY_MAX_DAYS.
export function rangeFits(fromDay: string, toDay: string): boolean {
  if (!isDay(fromDay) || !isDay(toDay)) return false;
  const days = (Date.parse(toDay) - Date.parse(fromDay)) / DAY_MS + 1;
  return days >= 1 && days <= HISTORY_MAX_DAYS;
}

interface Clock {
  timeZone: string;
  cutoffMinutes: number;
}

// The captain's own steps (CA §9.13), oldest first.
export const captainSteps = [
  'assigned',
  'received_handover',
  'arrived_at_restaurant',
  'picked_up',
  'handed_over',
  'arrived_at_customer',
  'delivered',
  'failed',
  'cancelled',
] as const;
export type CaptainStep = (typeof captainSteps)[number];

// One order of the captain's history: what they did of it, never who the
// customer is (K8): «الحي» only.
export interface CaptainHistoryRow {
  order: OrderView;
  day: string;
  handedOver: boolean;
  paidToRestaurant: PaymentLine[];
  collected: PaymentLine[];
  change: PaymentLine[];
  steps: { step: CaptainStep; at: Date }[];
}

@Injectable()
export class AppHistories {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly merchants: MerchantsService,
    private readonly captains: CaptainsService,
    private readonly geo: GeoService,
    private readonly settings: SettingsService,
  ) {}

  private async clock(cityId: string): Promise<Clock> {
    const [timeZone, cutoff] = await Promise.all([
      this.geo.cityTimeZone(cityId),
      this.settings.get('finance.business_day_cutoff', { cityId }),
    ]);
    if (timeZone === null) throw new Error(`city ${cityId} has no clock`);
    const [hours, minutes] = cutoff.split(':').map(Number) as [number, number];
    return { timeZone, cutoffMinutes: hours * 60 + minutes };
  }

  private bounds(clock: Clock, fromDay: string, toDay: string) {
    return {
      from: cutoffOn(fromDay, clock.cutoffMinutes, clock.timeZone),
      to: cutoffOn(dayPlus(toDay, 1), clock.cutoffMinutes, clock.timeZone),
    };
  }

  private async restaurantClock(restaurantId: string, now: Date) {
    const restaurant = await this.merchants.restaurant(restaurantId, now);
    if (!restaurant) throw new Error(`restaurant ${restaurantId} does not exist`);
    const clock = await this.clock(restaurant.cityId);
    const today = businessDayOf(now, clock.cutoffMinutes, clock.timeZone);
    return { clock, today, windowFrom: dayPlus(today, -CASHIER_DAYS) };
  }

  // RA §8.18: the restaurant's orders placed in a range of business days
  // (the cashier's window when none is given), newest first. A cashier's
  // range must lie in the window (`cashier_window`). The status and the
  // number narrow it further.
  async restaurantPage(
    restaurantId: string,
    cashier: boolean,
    filter: HistoryRange & { status?: OrderStatus; number?: bigint; after?: HistoryCursor },
    now: Date,
  ) {
    const { clock, today, windowFrom } = await this.restaurantClock(restaurantId, now);
    const fromDay = filter.fromDay ?? windowFrom;
    const toDay = filter.toDay ?? today;
    if (!rangeFits(fromDay, toDay)) throw new HistoryRefusedError('invalid_period');
    if (cashier && (fromDay < windowFrom || toDay > today)) {
      throw new HistoryRefusedError('cashier_window');
    }
    const { from, to } = this.bounds(clock, fromDay, toDay);
    const page = await this.page(
      and(
        eq(orders.restaurantId, restaurantId),
        filter.status === undefined ? undefined : eq(orders.status, filter.status),
        filter.number === undefined ? undefined : eq(orders.number, filter.number),
      ),
      { from, to },
      filter.after ?? null,
    );
    return {
      fromDay,
      toDay,
      ...page,
      dayOf: (order: OrderView) =>
        businessDayOf(order.placedAt, clock.cutoffMinutes, clock.timeZone),
    };
  }

  // RA §8.18 «التفاصيل»: one order of the restaurant; a cashier's only
  // within the window, so the detail never shows more than the list.
  async restaurantOrder(
    restaurantId: string,
    orderId: string,
    cashier: boolean,
    now: Date,
  ): Promise<OrderView | null> {
    const [order] = await readOrders(
      this.database.db,
      and(eq(orders.id, orderId), eq(orders.restaurantId, restaurantId)),
    );
    if (!order) return null;
    if (!cashier) return order;
    const { clock, today, windowFrom } = await this.restaurantClock(restaurantId, now);
    const { from } = this.bounds(clock, windowFrom, today);
    return order.placedAt >= from ? order : null;
  }

  // CA §9.13: the orders the captain worked, once their part ended: those
  // they ended as the order's captain (delivered, failed or cancelled) and
  // those they handed over to another captain, in a range of business days
  // or all, newest first.
  async captainPage(
    captainId: string,
    filter: HistoryRange & { after?: HistoryCursor },
    now: Date,
  ): Promise<{ rows: CaptainHistoryRow[]; more: boolean }> {
    const captain = await this.captains.captain(captainId, now);
    if (!captain) throw new Error(`captain ${captainId} not found`);
    const clock = await this.clock(captain.cityId);
    let range: { from: Date; to: Date } | null = null;
    if (filter.fromDay !== undefined && filter.toDay !== undefined) {
      if (!rangeFits(filter.fromDay, filter.toDay)) throw new HistoryRefusedError('invalid_period');
      range = this.bounds(clock, filter.fromDay, filter.toDay);
    }
    const handedOverIds = this.database.db
      .select({ id: handovers.orderId })
      .from(handovers)
      .where(and(eq(handovers.fromCaptainId, captainId), isNotNull(handovers.receivedAt)));
    const { orders: views, more } = await this.page(
      or(
        and(eq(orders.captainId, captainId), notInArray(orders.status, UNTIL_ENDED)),
        inArray(orders.id, handedOverIds),
      ),
      range,
      filter.after ?? null,
    );
    const ids = views.map((order) => order.id);
    const [handed, requests] =
      ids.length === 0
        ? [[], []]
        : await Promise.all([
            this.database.db
              .select({
                orderId: handovers.orderId,
                fromCaptainId: handovers.fromCaptainId,
                toCaptainId: handovers.toCaptainId,
                receivedAt: handovers.receivedAt,
              })
              .from(handovers)
              .where(and(inArray(handovers.orderId, ids), isNotNull(handovers.receivedAt))),
            this.database.db
              .select({
                orderId: pickupRequests.orderId,
                closedAt: pickupRequests.closedAt,
                lines: pickupRequests.lines,
                bookedLines: pickupRequests.bookedLines,
              })
              .from(pickupRequests)
              .where(
                and(
                  inArray(pickupRequests.orderId, ids),
                  eq(pickupRequests.captainId, captainId),
                  eq(pickupRequests.status, 'confirmed'),
                ),
              ),
          ]);
    const rows = views.map((order) => {
      const gaveAt = handed.find(
        (each) => each.orderId === order.id && each.fromCaptainId === captainId,
      )?.receivedAt;
      const gotAt = handed.find(
        (each) => each.orderId === order.id && each.toCaptainId === captainId,
      )?.receivedAt;
      const request = requests.find((each) => each.orderId === order.id);
      return captainRow(order, {
        day: businessDayOf(order.placedAt, clock.cutoffMinutes, clock.timeZone),
        handedOverAt: gaveAt ?? null,
        receivedAt: gotAt ?? null,
        pickup: request
          ? {
              at: request.closedAt,
              lines: paymentLines(request.bookedLines ?? request.lines),
            }
          : null,
      });
    });
    return { rows, more };
  }

  // A page of orders matching `where`, newest first by placing time then id,
  // within the range when one is given and after the cursor.
  private async page(
    where: SQL | undefined,
    range: { from: Date; to: Date } | null,
    after: HistoryCursor | null,
  ): Promise<{ orders: OrderView[]; more: boolean }> {
    const bounded = and(
      where,
      range === null ? undefined : gte(orders.placedAt, range.from),
      range === null ? undefined : lt(orders.placedAt, range.to),
    );
    const keys = await this.database.db
      .select({ id: orders.id, placedAt: orders.placedAt })
      .from(orders)
      .where(
        and(
          bounded,
          after === null
            ? undefined
            : or(
                lt(orders.placedAt, after.placedAt),
                and(eq(orders.placedAt, after.placedAt), lt(orders.id, after.id)),
              ),
        ),
      )
      .orderBy(desc(orders.placedAt), desc(orders.id))
      .limit(HISTORY_PAGE + 1);
    const shown = keys.slice(0, HISTORY_PAGE);
    if (shown.length === 0) return { orders: [], more: false };
    const oldest = shown.at(-1)!.placedAt;
    const read = await readOrders(
      this.database.db,
      and(
        inArray(
          orders.id,
          shown.map((key) => key.id),
        ),
        gte(orders.placedAt, oldest),
      ),
    );
    const byId = new Map(read.map((order) => [order.id, order]));
    return {
      orders: shown.flatMap((key) => byId.get(key.id) ?? []),
      more: keys.length > HISTORY_PAGE,
    };
  }
}

function paymentLines(stored: unknown): PaymentLine[] {
  return (stored as { currency: string; amount: string }[]).map((line) => ({
    currency: line.currency,
    amount: BigInt(line.amount),
  }));
}

// CA §9.13: the steps the captain took on the order and what passed through
// their custody. A captain who handed the order over took it to the
// handover; the one who received it took it from there (assigned_at stays
// the first captain's, AP §9.3.2).
export function captainRow(
  order: OrderView,
  part: {
    day: string;
    handedOverAt: Date | null;
    receivedAt: Date | null;
    pickup: { at: Date | null; lines: PaymentLine[] } | null;
  },
): CaptainHistoryRow {
  const gave = part.handedOverAt !== null;
  const received = part.receivedAt !== null;
  const ended =
    order.status === 'delivered'
      ? (order.delivery?.at ?? order.outcome?.collectedAt ?? order.outcome?.at ?? null)
      : order.status === 'failed'
        ? (order.outcome?.at ?? null)
        : order.status === 'cancelled'
          ? (order.cancellation?.at ?? null)
          : null;
  const endStep: CaptainStep =
    order.status === 'failed' ? 'failed' : order.status === 'cancelled' ? 'cancelled' : 'delivered';
  const steps: [CaptainStep, Date | null | undefined][] = [
    ['assigned', received ? null : order.assignedAt],
    ['received_handover', part.receivedAt],
    ['arrived_at_restaurant', received ? null : order.captainArrival?.at],
    ['picked_up', part.pickup?.at ?? (received ? null : order.pickup?.at)],
    ['handed_over', part.handedOverAt],
    ['arrived_at_customer', gave ? null : order.customerArrival?.at],
    [endStep, gave ? null : ended],
  ];
  return {
    order,
    day: part.day,
    handedOver: gave,
    paidToRestaurant: part.pickup?.lines ?? [],
    collected: gave ? [] : (order.delivery?.received ?? []),
    change: gave ? [] : (order.delivery?.change ?? []),
    steps: steps
      .flatMap(([step, at]) => (at ? [{ step, at }] : []))
      .sort((a, b) => a.at.getTime() - b.at.getTime()),
  };
}
