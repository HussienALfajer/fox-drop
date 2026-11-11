import { useMutation, useQueryClient } from '@tanstack/react-query';
import { useRef } from 'react';
import { api } from './api.js';
import { type DispatchState, type IneligibleReason, OPERATIONS_MANAGE } from './assign-captain.js';
import type { OrderDetail } from './order-detail.js';
import { type AdminSession, can } from './session.js';

// AP §9.3.2 «تسليم لكابتن آخر» (slice 2.12b): picked up or arrived with a
// captain, no handover open and no outcome waiting (the server's
// `handover.allowed`), for a session holding operations.manage.
export function canHandOver(
  session: AdminSession | null | undefined,
  order: Pick<OrderDetail, 'handover'>,
): boolean {
  return can(session, OPERATIONS_MANAGE) && order.handover.allowed;
}

export type HandoverRefusal =
  'order_not_handoverable' | 'captain_not_eligible' | 'captain_has_offer' | 'unknown_captain';

export type HandoverResult =
  | { status: 'offered'; order: DispatchState; expiresAt: string }
  | { status: 'assigned'; order: DispatchState }
  | { status: 'refused'; refusal: HandoverRefusal; reasons: IneligibleReason[] };

const refusals: readonly string[] = [
  'order_not_handoverable',
  'captain_not_eligible',
  'captain_has_offer',
  'unknown_captain',
] satisfies HandoverRefusal[];

const knownReasons: readonly string[] = [
  'busy',
  'cash_limit',
  'closed_due',
  'simulated_location',
  'out_of_range',
  'vehicle_not_allowed',
  'offline',
] satisfies IneligibleReason[];

// The required note, trimmed; null while empty (AP §9.3.2: a reason is
// required).
export function handoverNote(text: string): string | null {
  const note = text.trim();
  return note.length === 0 ? null : note;
}

// With dispatch.manual_assign_requires_accept the second captain gets an offer
// «استلام من كابتن», else the handover is theirs at once. One key per choice
// (the captain and the note), so a retry after a lost answer replays.
export function useHandOver(orderId: string) {
  const queryClient = useQueryClient();
  const keys = useRef(new Map<string, string>());
  return useMutation({
    mutationFn: async (choice: {
      captainId: string;
      reason: string;
      captainFault: boolean | null;
    }): Promise<HandoverResult> => {
      const choiceKey = `${choice.captainId}\n${choice.reason}\n${choice.captainFault}`;
      let key = keys.current.get(choiceKey);
      if (key === undefined) {
        key = crypto.randomUUID();
        keys.current.set(choiceKey, key);
      }
      const { data, error, response } = await api.POST('/v1/admin/orders/{orderId}/handover', {
        params: { path: { orderId }, header: { 'Idempotency-Key': key } },
        body: choice,
      });
      if (data) {
        keys.current.delete(choiceKey);
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
        keys.current.delete(choiceKey);
        const reasons = Array.isArray(body?.reasons)
          ? (body.reasons as unknown[]).filter(
              (reason): reason is IneligibleReason =>
                typeof reason === 'string' && knownReasons.includes(reason),
            )
          : [];
        return { status: 'refused', refusal: refusal as HandoverRefusal, reasons };
      }
      throw new Error('The handover failed.');
    },
    onSettled: () =>
      Promise.all([
        queryClient.invalidateQueries({ queryKey: ['order', orderId] }),
        queryClient.invalidateQueries({ queryKey: ['captain-picker', orderId] }),
        queryClient.invalidateQueries({ queryKey: ['orders-board'] }),
      ]),
  });
}

export type Handover = OrderDetail['handover']['handovers'][number];

// How a handover stands, for the detail's list: open (offered or assigned,
// waiting for the receipt), received, or closed with its reason.
export function handoverState(
  handover: Handover,
):
  | { kind: 'offered' }
  | { kind: 'waiting' }
  | { kind: 'received'; at: string }
  | { kind: 'closed'; reason: NonNullable<Handover['closeReason']> } {
  if (handover.receivedAt !== null) return { kind: 'received', at: handover.receivedAt };
  if (handover.closeReason !== null) return { kind: 'closed', reason: handover.closeReason };
  return handover.assignedAt === null ? { kind: 'offered' } : { kind: 'waiting' };
}
