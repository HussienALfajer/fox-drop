import type { components } from '@fox-drop/api-schema';
import { queryOptions } from '@tanstack/react-query';
import { api } from './api.js';
import { pollUnlessLive } from './live.js';
import { POLL_MS } from './orders-board.js';

export type OrderDetail = components['schemas']['AdminOrderDto_Output']['order'];

// cityId: the board's city, whose channel carries the order's events.
export function orderQuery(orderId: string, cityId: string | undefined) {
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
    refetchInterval: pollUnlessLive(cityId, POLL_MS),
    refetchIntervalInBackground: true,
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
  'order.cancellation_acknowledged': 'order.event.cancellationAcknowledged',
  'order.time_changed': 'order.event.timeChanged',
  'order.item_reported': 'order.event.itemReported',
  'order.item_report_withdrawn': 'order.event.itemReportWithdrawn',
  'order.item_report_closed': 'order.event.itemReportClosed',
  'order.edited': 'order.event.edited',
  'order.edit_acknowledged': 'order.event.editAcknowledged',
  'order.outcome_set': 'order.event.outcomeSet',
  'order.outcome_collected': 'order.event.outcomeCollected',
  'order.outcome_changed': 'order.event.outcomeChanged',
  'order.reassigned': 'order.event.reassigned',
  'order.handover_offered': 'order.event.handoverOffered',
  'order.handover_assigned': 'order.event.handoverAssigned',
  'order.handover_closed': 'order.event.handoverClosed',
  'order.handed_over': 'order.event.handedOver',
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

// The codes the server stores as an event's reason, by event type (the
// offer's answer, the pickup's outcome, the cancellation); a reason from a
// Content list shows by its stored label in its own section (AP §9.13);
// an operator's own reason is free text and shows as written. Any other
// code stays hidden rather than show an English word.
// AP Appendix C: an outcome set or changed (slice 2.11c) names its code.
function outcomeReasonKeys() {
  return {
    free: 'order.outcome.free',
    fake: 'order.outcome.fake',
    damaged: 'order.outcome.damaged',
    wrong_refused: 'order.outcome.wrongRefused',
    failed_other: 'order.outcome.failedOther',
  } as const;
}

const reasonKeysByType = {
  'order.offer_closed': {
    declined: 'order.reason.declined',
    expired: 'order.reason.expired',
    withdrawn: 'order.reason.withdrawn',
  },
  'order.pickup_rejected': {
    amount_incorrect: 'order.reason.amountIncorrect',
    incomplete: 'order.reason.incomplete',
  },
  'order.picked_up': {
    restaurant: 'order.reason.byRestaurant',
    automatic: 'order.reason.automatic',
    operations: 'order.reason.byOperations',
  },
  'order.cancelled': { merchant_auto_cancel: 'order.reason.merchantAutoCancel' },
  'order.outcome_set': outcomeReasonKeys(),
  'order.outcome_changed': outcomeReasonKeys(),
} as const;

type ReasonKey = {
  [
    Type in keyof typeof reasonKeysByType
  ]: (typeof reasonKeysByType)[Type][keyof (typeof reasonKeysByType)[Type]];
}[keyof typeof reasonKeysByType];

export type EventReason = { key: ReasonKey } | { text: string } | null;

export function eventReason(event: {
  type: string | null;
  actor: { type: string };
  reason: string | null;
}): EventReason {
  if (event.reason === null) return null;
  const codes: Record<string, ReasonKey> | undefined =
    event.type !== null && event.type in reasonKeysByType
      ? reasonKeysByType[event.type as keyof typeof reasonKeysByType]
      : undefined;
  const key = codes?.[event.reason];
  if (key) return { key };
  return event.actor.type === 'admin' ? { text: event.reason } : null;
}

export const cancelReasonKeys: Record<string, ReasonKey> = reasonKeysByType['order.cancelled'];

type Cancellation = NonNullable<OrderDetail['cancellation']>;

// AP Appendix C: the responsible parties.
export const responsibleKeys = {
  restaurant: 'order.responsible.restaurant',
  captain: 'order.responsible.captain',
  customer: 'order.responsible.customer',
  platform: 'order.responsible.platform',
} as const satisfies Record<NonNullable<Cancellation['responsible']>, string>;

// docs/domain/01: the answers to «هل أعاد المطعم المبلغ للكابتن؟».
export const cashKeys = {
  returned: 'order.cash.returned',
  not_returned: 'order.cash.not_returned',
  not_paid: 'order.cash.not_paid',
} as const satisfies Record<NonNullable<Cancellation['cash']>, string>;

// AP §9.3.2 «تسليم لكابتن آخر» (slice 2.12b): why a handover closed without
// the receipt.
export const handoverCloseKeys = {
  declined: 'order.handovers.closed.declined',
  expired: 'order.handovers.closed.expired',
  withdrawn: 'order.handovers.closed.withdrawn',
  ended: 'order.handovers.closed.ended',
} as const satisfies Record<
  NonNullable<OrderDetail['handover']['handovers'][number]['closeReason']>,
  string
>;

export const outcomeKeys = {
  normal: 'order.outcome.normal',
  free: 'order.outcome.free',
  fake: 'order.outcome.fake',
  damaged: 'order.outcome.damaged',
  wrong_refused: 'order.outcome.wrongRefused',
  failed_other: 'order.outcome.failedOther',
} as const satisfies Record<NonNullable<OrderDetail['delivery']>['outcome'], string>;

export const requestStatusKeys = {
  open: 'order.request.open',
  confirmed: 'order.request.confirmed',
  rejected: 'order.request.rejected',
  voided: 'order.request.voided',
} as const satisfies Record<OrderDetail['pickup']['requests'][number]['status'], string>;
