import { useMutation } from '@tanstack/react-query';
import { api } from './api.js';
import type { OrderDetail } from './order-detail.js';
import { type AdminSession, can } from './session.js';

export type ResendTarget = 'customer' | 'merchant' | 'captain';

// AP §9.3.2: OWN, OPS and SUP resend a notification (the server checks it).
export function canResend(session: AdminSession | null | undefined): boolean {
  return can(session, 'operations.manage') || can(session, 'operations.compensate');
}

// «إعادة إرسال الإشعار» is for active orders; the captain's only once one is
// assigned.
export function resendTargets(order: Pick<OrderDetail, 'status' | 'captain'>): ResendTarget[] {
  const active = ['placed', 'accepted', 'ready', 'picked_up', 'arrived'].includes(order.status);
  if (!active) return [];
  return order.captain ? ['customer', 'merchant', 'captain'] : ['customer', 'merchant'];
}

export type ResendResult =
  | { status: 'sent'; body: string }
  | { status: 'refused'; refusal: 'nothing_to_resend' | 'order_state_changed' };

export function useResendNotification(orderId: string) {
  return useMutation({
    mutationFn: async (to: ResendTarget): Promise<ResendResult> => {
      const { data, error, response } = await api.POST(
        '/v1/admin/orders/{orderId}/resend-notification',
        { params: { path: { orderId } }, body: { to } },
      );
      if (data) return { status: 'sent', body: data.body };
      const refusal = (error as { error?: unknown } | undefined)?.error;
      if (
        response.status === 409 &&
        (refusal === 'nothing_to_resend' || refusal === 'order_state_changed')
      ) {
        return { status: 'refused', refusal };
      }
      throw new Error(`resend failed with ${response.status}`);
    },
  });
}
