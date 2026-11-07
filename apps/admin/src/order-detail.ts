import type { components } from '@fox-drop/api-schema';
import { queryOptions } from '@tanstack/react-query';
import { api } from './api.js';
import { POLL_MS } from './orders-board.js';

export type OrderDetail = components['schemas']['AdminOrderDto_Output']['order'];

export function orderQuery(orderId: string) {
  return queryOptions({
    queryKey: ['order', orderId],
    // null for an order that does not exist (404 unknown_order).
    queryFn: async (): Promise<OrderDetail | null> => {
      const { data, response } = await api.GET('/v1/admin/orders/{orderId}', {
        params: { path: { orderId } },
      });
      if (response.status === 404) return null;
      if (!data) throw new Error('The order read failed.');
      return data.order;
    },
    refetchInterval: POLL_MS,
  });
}

// The timeline's event types the panel names (AP §9.3.1); another type shows
// the status it reached.
export const eventKeys = {
  'order.placed': 'order.event.placed',
  'order.accepted': 'order.event.accepted',
  'order.ready': 'order.event.ready',
  'order.cancelled': 'order.event.cancelled',
  'order.search_started': 'order.event.searchStarted',
  'order.offered': 'order.event.offered',
  'order.offer_closed': 'order.event.offerClosed',
  'order.assigned': 'order.event.assigned',
  'order.captain_arrived': 'order.event.captainArrived',
  'order.pickup_requested': 'order.event.pickupRequested',
  'order.pickup_rejected': 'order.event.pickupRejected',
  'order.picked_up': 'order.event.pickedUp',
  'order.pickup_disputed': 'order.event.pickupDisputed',
  'order.arrived_at_customer': 'order.event.arrivedAtCustomer',
  'order.delivered': 'order.event.delivered',
} as const;

export function eventKey(type: string | null): (typeof eventKeys)[keyof typeof eventKeys] | null {
  return type !== null && type in eventKeys ? eventKeys[type as keyof typeof eventKeys] : null;
}

export const actorKeys = {
  system: 'order.actor.system',
  customer: 'order.actor.customer',
  restaurant: 'order.actor.restaurant',
  captain: 'order.actor.captain',
  admin: 'order.actor.admin',
} as const;

export function actorKey(type: string) {
  return type in actorKeys ? actorKeys[type as keyof typeof actorKeys] : 'order.actor.other';
}
