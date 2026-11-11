import type { components } from '@fox-drop/api-schema';
import { useMutation, useQueryClient } from '@tanstack/react-query';
import { useRef } from 'react';
import { api } from './api.js';
import { OPERATIONS_MANAGE } from './assign-captain.js';
import type { OrderDetail } from './order-detail.js';
import { type AdminSession, can } from './session.js';

type WaitBody = components['schemas']['AdminNoAnswerWaitDto'];
export type NoAnswer = OrderDetail['noAnswer'];
type PingAnswer = NonNullable<NoAnswer['pings'][number]['answer']>;

// CU §11.7: the customer's answer as the captain sees it (CA §9.9).
export const pingAnswerKeys = {
  coming: 'order.noAnswer.coming',
  contacting_recipient: 'order.noAnswer.contactingRecipient',
} as const satisfies Record<PingAnswer, string>;

// A report the order left before «انتظر» (slice 2.13d).
export const closedHowKeys = {
  handed_over: 'order.noAnswer.closedHandedOver',
  ended: 'order.noAnswer.closedEnded',
} as const satisfies Record<NonNullable<NoAnswer['reports'][number]['closedHow']>, string>;

// CA §9.9 «انتظر»: OWN and OPS, while the captain's «الزبون لا يستجيب»
// waits (owner decision 2026-11-11).
export function canWaitForCustomer(
  session: AdminSession | null | undefined,
  order: Pick<OrderDetail, 'noAnswer'>,
): boolean {
  return can(session, OPERATIONS_MANAGE) && order.noAnswer.waitAllowed;
}

// The message the captain sees and hears is required, up to 300 characters.
export function waitBody(message: string): WaitBody | null {
  const trimmed = message.trim();
  return trimmed === '' || trimmed.length > 300 ? null : { message: trimmed };
}

// order_state_changed: nothing waits any more (answered from another
// screen, or the order left the door).
export type WaitResult = { status: 'done' } | { status: 'refused'; refusal: 'order_state_changed' };

// One Idempotency-Key per message until an answer arrives, so a retry after
// a lost answer replays (architecture §5.3).
export function useWaitForCustomer(orderId: string) {
  const queryClient = useQueryClient();
  const keys = useRef(new Map<string, string>());
  return useMutation({
    mutationFn: async (body: WaitBody): Promise<WaitResult> => {
      const id = JSON.stringify(body);
      let key = keys.current.get(id);
      if (key === undefined) {
        key = crypto.randomUUID();
        keys.current.set(id, key);
      }
      const { data, error, response } = await api.POST(
        '/v1/admin/orders/{orderId}/no-answer/wait',
        {
          params: { path: { orderId }, header: { 'Idempotency-Key': key } },
          body,
        },
      );
      if (data) {
        keys.current.delete(id);
        return { status: 'done' };
      }
      const refusal = (error as { error?: unknown } | undefined)?.error;
      if (response.status === 409 && refusal === 'order_state_changed') {
        keys.current.delete(id);
        return { status: 'refused', refusal };
      }
      throw new Error(`«انتظر» failed with ${response.status}.`);
    },
    onSettled: () =>
      Promise.all([
        queryClient.invalidateQueries({ queryKey: ['order', orderId] }),
        queryClient.invalidateQueries({ queryKey: ['orders-board'] }),
        queryClient.invalidateQueries({ queryKey: ['alerts'] }),
      ]),
  });
}
