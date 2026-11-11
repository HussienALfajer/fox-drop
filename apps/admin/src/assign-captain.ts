import type { components } from '@fox-drop/api-schema';
import { queryOptions, useMutation, useQueryClient } from '@tanstack/react-query';
import { useRef } from 'react';
import { api } from './api.js';
import type { OrderDetail } from './order-detail.js';

export const OPERATIONS_MANAGE = 'operations.manage';

type ListedCaptain = components['schemas']['AdminPickerDto_Output']['captains'][number];
// offerable: «تعيين» may go to this captain (canOffer).
export type PickerCaptain = ListedCaptain & { offerable: boolean };
export type DispatchState = components['schemas']['AdminDispatchStateDto_Output']['order'];
export type IneligibleReason = PickerCaptain['reasons'][number] | 'offline';

// Why a captain is greyed out in a picker (AP §9.3.2).
export const ineligibleKeys = {
  busy: 'assign.reason.busy',
  last_order: 'assign.reason.lastOrder',
  cash_limit: 'assign.reason.cashLimit',
  closed_due: 'assign.reason.closedDue',
  simulated_location: 'assign.reason.simulatedLocation',
  out_of_range: 'assign.reason.outOfRange',
  vehicle_not_allowed: 'assign.reason.vehicleNotAllowed',
  above_max_pickup: 'assign.reason.aboveMaxPickup',
  offline: 'assign.reason.offline',
} as const satisfies Record<IneligibleReason, string>;

// AP §9.3.2 «تعيين كابتن»: no captain and no open offer, before pickup. The
// server takes accepted or ready orders only (owner decision 2026-11-06, CA
// §8.1): a placed order waits for the restaurant.
export function canAssign(
  order: Pick<OrderDetail, 'status' | 'captain' | 'captainTrack'>,
): boolean {
  return (
    (order.status === 'accepted' || order.status === 'ready') &&
    order.captain === null &&
    order.captainTrack !== 'offered'
  );
}

// C4, K2, CA §8.4: a captain greyed out only for «المبلغ أكبر مما يحمله»
// may still get a manual offer, which they can decline; only when «تعيين»
// arrives as an offer (assignsAsOffer), since the server refuses a direct
// assignment then.
export function canOffer(
  captain: Pick<ListedCaptain, 'eligible' | 'reasons'>,
  assignsAsOffer: boolean,
): boolean {
  return (
    captain.eligible ||
    (assignsAsOffer &&
      captain.reasons.length > 0 &&
      captain.reasons.every((reason) => reason === 'above_max_pickup'))
  );
}

// The picker: every online captain of the city, nearest first, eligible or
// greyed out with its reasons. Read once when it opens and on «تحديث».
// The seconds left of an open offer (CA §8.2), on the server's clock.
export function secondsLeft(expiresAt: string, now: number): number {
  return Math.max(0, Math.ceil((Date.parse(expiresAt) - now) / 1000));
}

export function pickerQuery(orderId: string) {
  return queryOptions({
    queryKey: ['captain-picker', orderId],
    queryFn: async (): Promise<PickerCaptain[]> => {
      const { data } = await api.GET('/v1/admin/orders/{orderId}/captains', {
        params: { path: { orderId } },
      });
      if (!data) throw new Error('The picker read failed.');
      return data.captains.map((captain) => ({
        ...captain,
        offerable: canOffer(captain, data.assignsAsOffer),
      }));
    },
  });
}

export type AssignRefusal =
  'order_not_assignable' | 'captain_not_eligible' | 'captain_has_offer' | 'unknown_captain';

export type AssignResult =
  | { status: 'offered'; order: DispatchState; expiresAt: string }
  | { status: 'assigned'; order: DispatchState }
  | { status: 'refused'; refusal: AssignRefusal; reasons: IneligibleReason[] };

const knownReasons: readonly string[] = [
  'busy',
  'last_order',
  'cash_limit',
  'closed_due',
  'simulated_location',
  'out_of_range',
  'vehicle_not_allowed',
  'above_max_pickup',
  'offline',
] satisfies IneligibleReason[];

const refusals: readonly string[] = [
  'order_not_assignable',
  'captain_not_eligible',
  'captain_has_offer',
  'unknown_captain',
] satisfies AssignRefusal[];

// With dispatch.manual_assign_requires_accept (true) the captain gets an
// offer and the answer carries it; without it the order is the captain's at
// once (AP §9.3.2). A retry of the same choice sends the same
// Idempotency-Key, so a lost answer never assigns twice (architecture §5.3).
export function useAssignCaptain(orderId: string) {
  const queryClient = useQueryClient();
  const keys = useRef(new Map<string, string>());
  return useMutation({
    mutationFn: async (captainId: string): Promise<AssignResult> => {
      let key = keys.current.get(captainId);
      if (key === undefined) {
        key = crypto.randomUUID();
        keys.current.set(captainId, key);
      }
      const { data, error, response } = await api.POST('/v1/admin/orders/{orderId}/assign', {
        params: { path: { orderId }, header: { 'Idempotency-Key': key } },
        body: { captainId },
      });
      if (data) {
        keys.current.delete(captainId);
        const { order } = data;
        return order.offer
          ? { status: 'offered', order, expiresAt: order.offer.expiresAt }
          : { status: 'assigned', order };
      }
      const body = error as { error?: unknown; reasons?: unknown } | undefined;
      const refusal = body?.error;
      if (
        (response.status === 409 || response.status === 404) &&
        typeof refusal === 'string' &&
        refusals.includes(refusal)
      ) {
        keys.current.delete(captainId);
        // A reason the panel does not know yet is left out of the explanation.
        const reasons = Array.isArray(body?.reasons)
          ? (body.reasons as unknown[]).filter(
              (reason): reason is IneligibleReason =>
                typeof reason === 'string' && knownReasons.includes(reason),
            )
          : [];
        return { status: 'refused', refusal: refusal as AssignRefusal, reasons };
      }
      throw new Error('The assignment failed.');
    },
    onSettled: () =>
      Promise.all([
        queryClient.invalidateQueries({ queryKey: ['order', orderId] }),
        queryClient.invalidateQueries({ queryKey: ['captain-picker', orderId] }),
        queryClient.invalidateQueries({ queryKey: ['orders-board'] }),
      ]),
  });
}
