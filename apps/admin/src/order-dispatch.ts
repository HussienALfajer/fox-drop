import type { components } from '@fox-drop/api-schema';
import { queryOptions, useMutation, useQueryClient } from '@tanstack/react-query';
import { useRef } from 'react';
import { api } from './api.js';
import { OPERATIONS_MANAGE } from './assign-captain.js';
import { pollUnlessLive } from './live.js';
import type { OrderDetail } from './order-detail.js';
import { POLL_MS, type OrderCard } from './orders-board.js';
import { type AdminSession, can } from './session.js';

type Dispatch = OrderCard['dispatch'];
type ManualReason = NonNullable<Dispatch['manual']>['reason'];
export type OrderOffer = components['schemas']['AdminOrderOffersDto_Output']['offers'][number];

// AP §9.12.6 (slice 2.15c): why the order left automatic dispatch.
export const manualReasonKeys = {
  max_offers: 'dispatch.manual.max_offers',
  no_captain_alert: 'dispatch.manual.no_captain_alert',
  operations: 'dispatch.manual.operations',
} as const satisfies Record<ManualReason, string>;

export const offerKindKeys = {
  manual: 'dispatch.offers.kind.manual',
  auto: 'dispatch.offers.kind.auto',
} as const satisfies Record<OrderOffer['kind'], string>;

export const offerStatusKeys = {
  open: 'dispatch.offers.status.open',
  accepted: 'dispatch.offers.status.accepted',
  declined: 'dispatch.offers.status.declined',
  expired: 'dispatch.offers.status.expired',
  withdrawn: 'dispatch.offers.status.withdrawn',
} as const satisfies Record<OrderOffer['status'], string>;

// What the card and the detail say of the dispatch while the order waits
// for a captain (placed to ready, no captain; AP §9.2.1, §9.12.6): left to
// operations and why, from the move on; in «آلي» or «مختلط», once the
// search started, the automatic offer open («العرض {ن}», «من {م}» in
// «مختلط») or the search for the next. Nothing in «يدوي» (D6, «بحاجة
// لتعيين» says it) or while operations' own offer is open («أُرسل عرض إلى
// كابتن» says it).
export type DispatchLine =
  | { kind: 'manual'; reason: ManualReason }
  | { kind: 'offer'; offer: number; of: number | null }
  | { kind: 'searching' }
  | null;

export function dispatchLine(
  card: Pick<OrderCard, 'dispatch' | 'captain' | 'captainTrack' | 'status'>,
): DispatchLine {
  const { dispatch } = card;
  const waiting =
    card.captain === null &&
    (card.status === 'placed' || card.status === 'accepted' || card.status === 'ready');
  if (!waiting) return null;
  if (dispatch.manual !== null) return { kind: 'manual', reason: dispatch.manual.reason };
  if (dispatch.mode === 'manual') return null;
  if (card.captainTrack === 'offered') {
    return dispatch.autoOfferOpen
      ? { kind: 'offer', offer: dispatch.autoOffers, of: dispatch.maxOffers }
      : null;
  }
  return card.captainTrack === 'searching' ? { kind: 'searching' } : null;
}

// AP §9.3.2 «توزيع يدوي لهذا الطلب»: OWN and OPS, before assignment, while
// the order is still in automatic dispatch. The server checks again.
export function canMoveToManual(
  session: AdminSession | null | undefined,
  order: Pick<OrderDetail, 'dispatch' | 'captain' | 'status'>,
): boolean {
  return (
    can(session, OPERATIONS_MANAGE) &&
    order.dispatch.mode !== 'manual' &&
    order.dispatch.manual === null &&
    order.captain === null &&
    (order.status === 'placed' || order.status === 'accepted' || order.status === 'ready')
  );
}

// order_not_automatic: the city went back to «يدوي» or the order left
// already; order_not_assignable: a captain took it first.
export type ManualDispatchResult =
  | { status: 'done' }
  | { status: 'refused'; refusal: 'order_not_automatic' | 'order_not_assignable' };

// One Idempotency-Key until an answer arrives, so a retry after a lost
// answer replays (architecture §5.3).
export function useManualDispatch(orderId: string) {
  const queryClient = useQueryClient();
  const key = useRef<string | null>(null);
  return useMutation({
    mutationFn: async (): Promise<ManualDispatchResult> => {
      key.current ??= crypto.randomUUID();
      const { data, error, response } = await api.POST(
        '/v1/admin/orders/{orderId}/manual-dispatch',
        { params: { path: { orderId }, header: { 'Idempotency-Key': key.current } } },
      );
      if (data) {
        key.current = null;
        return { status: 'done' };
      }
      const refusal = (error as { error?: unknown } | undefined)?.error;
      if (
        response.status === 409 &&
        (refusal === 'order_not_automatic' || refusal === 'order_not_assignable')
      ) {
        key.current = null;
        return { status: 'refused', refusal };
      }
      throw new Error(`Taking the order out of automatic dispatch failed with ${response.status}.`);
    },
    onSettled: () =>
      Promise.all([
        queryClient.invalidateQueries({ queryKey: ['order', orderId] }),
        queryClient.invalidateQueries({ queryKey: ['orders-board'] }),
      ]),
  });
}

// AP §9.3.1, §9.7.4: the order's offers, oldest first; under the order's
// key, so its events read it again.
export function orderOffersQuery(orderId: string, cityId: string | undefined) {
  return queryOptions({
    queryKey: ['order', orderId, 'offers'],
    queryFn: async (): Promise<OrderOffer[]> => {
      const { data } = await api.GET('/v1/admin/orders/{orderId}/offers', {
        params: { path: { orderId } },
      });
      if (!data) throw new Error('The offers read failed.');
      return data.offers;
    },
    refetchInterval: pollUnlessLive(cityId, POLL_MS),
    refetchIntervalInBackground: true,
  });
}
