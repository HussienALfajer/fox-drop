import type { components } from '@fox-drop/api-schema';
import { queryOptions } from '@tanstack/react-query';
import { api } from './api.js';

export type BoardOrder = components['schemas']['MerchantOrdersDto_Output']['orders'][number];
export type OrderDetail = components['schemas']['MerchantOrderWithTimelineDto_Output'];

// RA §17: the live orders, read only; the same reads as the app's board.
export const boardQuery = queryOptions({
  queryKey: ['board'],
  queryFn: async () => {
    const { data, response } = await api.GET('/v1/merchant/orders');
    if (!data) throw new Error(`The board read failed (${response.status}).`);
    return data.orders;
  },
});

export const orderQuery = (orderId: string) =>
  queryOptions({
    queryKey: ['order', orderId],
    queryFn: async (): Promise<OrderDetail | null> => {
      const { data, response } = await api.GET('/v1/merchant/orders/{orderId}', {
        params: { path: { orderId } },
      });
      if (response.status === 404) return null;
      if (!data) throw new Error(`The order read failed (${response.status}).`);
      return data;
    },
  });

// RA §8.1–8.2: the four columns, right to left.
export const columns = ['incoming', 'preparing', 'ready', 'with_captain'] as const;
export type Column = (typeof columns)[number];

// The board lists a delivered order within its dispute window and an order
// operations cancelled until «حسناً» (RA §8.10, §8.14): both are actions the
// portal has none of, so it shows the four columns' orders only.
export function columnOf(order: Pick<BoardOrder, 'status'>): Column | null {
  switch (order.status) {
    case 'placed':
      return 'incoming';
    case 'accepted':
      return 'preparing';
    case 'ready':
      return 'ready';
    case 'picked_up':
    case 'arrived':
      return 'with_captain';
    default:
      return null;
  }
}

// RA §8.2: a new order past its accept alert, or one in preparation past its
// prep time.
export function isLate(order: BoardOrder, now: number): boolean {
  if (order.status === 'placed') {
    return order.acceptAlertAt !== null && Date.parse(order.acceptAlertAt) <= now;
  }
  if (order.status === 'accepted') {
    return order.acceptance !== null && Date.parse(order.acceptance.prepDueAt) <= now;
  }
  return false;
}

// RA §8.2's sorting of each column.
function sortKey(order: BoardOrder, column: Column, now: number): [number, number] {
  switch (column) {
    case 'incoming':
      return [0, Date.parse(order.placedAt)];
    case 'preparing': {
      const due = order.acceptance ? Date.parse(order.acceptance.prepDueAt) : Infinity;
      return [isLate(order, now) ? 0 : 1, due];
    }
    case 'ready':
      return order.captainArrival
        ? [0, Date.parse(order.captainArrival.at)]
        : [1, Date.parse(order.readyAt ?? order.placedAt)];
    case 'with_captain':
      return [0, Date.parse(order.pickup.pickedUpAt ?? order.placedAt)];
  }
}

export function boardColumns(orders: BoardOrder[], now: number): Record<Column, BoardOrder[]> {
  const board: Record<Column, BoardOrder[]> = {
    incoming: [],
    preparing: [],
    ready: [],
    with_captain: [],
  };
  for (const order of orders) {
    const column = columnOf(order);
    if (column) board[column].push(order);
  }
  for (const column of columns) {
    board[column].sort((a, b) => {
      const [aGroup, aAt] = sortKey(a, column, now);
      const [bGroup, bAt] = sortKey(b, column, now);
      return aGroup - bGroup || aAt - bAt;
    });
  }
  return board;
}

// RA §8.1's captain line, as a translation key and its values.
export type CaptainLine =
  | { key: 'waiting' }
  | { key: 'onTheWay'; name: string }
  | { key: 'atRestaurant'; minutes: number }
  | { key: 'pickupPending' }
  | { key: 'withCaptain'; name: string }
  | null;

export function captainLine(order: BoardOrder, now: number): CaptainLine {
  const name = order.captain?.firstName ?? '';
  switch (order.captainTrack) {
    case 'searching':
    case 'offered':
      return { key: 'waiting' };
    case 'assigned':
      return { key: 'onTheWay', name };
    case 'at_merchant':
      return {
        key: 'atRestaurant',
        minutes: order.captainArrival
          ? Math.max(0, Math.floor((now - Date.parse(order.captainArrival.at)) / 60_000))
          : 0,
      };
    case 'pickup_pending':
      return { key: 'pickupPending' };
    case 'picked_up':
    case 'at_customer':
    case 'done':
      return { key: 'withCaptain', name };
    default:
      return null;
  }
}

// RA §8.2's running timer: the auto-cancel countdown of a new order, the prep
// countdown (counting up once late, «متأخر {د} د»), or the captain's waiting.
export type Timer =
  | { key: 'autoCancel'; ms: number }
  | { key: 'prepLeft'; ms: number }
  | { key: 'prepLate'; minutes: number }
  | { key: 'captainWaiting'; ms: number }
  | null;

export function timerOf(order: BoardOrder, now: number): Timer {
  if (order.status === 'placed' && order.autoCancelAt) {
    return { key: 'autoCancel', ms: Math.max(0, Date.parse(order.autoCancelAt) - now) };
  }
  if (order.status === 'ready' && order.captainArrival) {
    return { key: 'captainWaiting', ms: Math.max(0, now - Date.parse(order.captainArrival.at)) };
  }
  if (order.status === 'accepted' && order.acceptance) {
    const left = Date.parse(order.acceptance.prepDueAt) - now;
    return left > 0
      ? { key: 'prepLeft', ms: left }
      : { key: 'prepLate', minutes: Math.floor(-left / 60_000) };
  }
  return null;
}

export function itemCount(order: Pick<BoardOrder, 'lines'>): number {
  return order.lines.reduce((count, line) => count + line.quantity, 0);
}
