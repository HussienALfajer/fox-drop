import type { components } from '@fox-drop/api-schema';
import { useMutation, useQueryClient } from '@tanstack/react-query';
import { useRef } from 'react';
import { api } from './api.js';
import { OPERATIONS_MANAGE } from './assign-captain.js';
import type { OrderDetail } from './order-detail.js';
import { type AdminSession, can } from './session.js';

type CloseBody = components['schemas']['AdminCloseItemReportDto'];
export type ItemReport = NonNullable<OrderDetail['itemReport']>;

// RA §8.12: «حتى الغد» or «حتى أعيده» for each item; the optional note is a
// reason of Content's item_unavailable_note list and shows by its label.
export const untilKeys = {
  tomorrow: 'order.itemReport.untilTomorrow',
  turned_back_on: 'order.itemReport.untilTurnedBackOn',
} as const satisfies Record<ItemReport['items'][number]['until'], string>;

// AP §9.3.2 «إغلاق بلاغ صنف نفد»: OWN and OPS, while a report is open.
export function canCloseItemReport(
  session: AdminSession | null | undefined,
  order: Pick<OrderDetail, 'itemReport'>,
): order is { itemReport: ItemReport } {
  return can(session, OPERATIONS_MANAGE) && order.itemReport !== null;
}

// Operations' reason is required (AP §9.3.2).
export function closeItemReportBody(reason: string): CloseBody | null {
  const trimmed = reason.trim();
  return trimmed === '' ? null : { reason: trimmed };
}

// order_state_changed: the report closed first (withdrawn by the restaurant,
// or the order cancelled).
export type CloseItemReportResult =
  { status: 'done' } | { status: 'refused'; refusal: 'order_state_changed' };

// One Idempotency-Key per reason until an answer arrives, so a retry after a
// lost answer replays (architecture §5.3).
export function useCloseItemReport(orderId: string) {
  const queryClient = useQueryClient();
  const keys = useRef(new Map<string, string>());
  return useMutation({
    mutationFn: async (body: CloseBody): Promise<CloseItemReportResult> => {
      const id = JSON.stringify(body);
      let key = keys.current.get(id);
      if (key === undefined) {
        key = crypto.randomUUID();
        keys.current.set(id, key);
      }
      const { data, error, response } = await api.POST(
        '/v1/admin/orders/{orderId}/item-report/close',
        { params: { path: { orderId }, header: { 'Idempotency-Key': key } }, body },
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
      throw new Error(`Closing the report failed with ${response.status}.`);
    },
    onSettled: () =>
      Promise.all([
        queryClient.invalidateQueries({ queryKey: ['order', orderId] }),
        queryClient.invalidateQueries({ queryKey: ['orders-board'] }),
        queryClient.invalidateQueries({ queryKey: ['alerts'] }),
      ]),
  });
}
