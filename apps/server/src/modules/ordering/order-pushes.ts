import type { PushRecipient } from '../notifications/index.js';

// Architecture §8.1, CU §14, RA §16, CA §14: which push each order event
// sends to whom, with the values its template takes. Only the rows whose
// events exist are here; each later transition adds its rows with its slice
// (owner decision 2026-11-08). The texts are the templates' (AP §9.13).

export interface OrderPushFacts {
  orderId: string;
  number: string;
  customerAccountId: string;
  restaurantId: string;
  restaurantName: string;
  // The captain the event is about (an offer's, or the one assigned).
  captainId: string | null;
  captainFirstName: string | null;
  // CU §11.7, Q5: the recipient of an order for someone else.
  recipientName: string | null;
  // Formatted for the push: «9:45 م», «120 ₺».
  promisedTime: string | null;
  total: string;
  // CU §14 #8: the customer text of the cancellation's reason.
  cancelText: string | null;
  cancelReason: string | null;
  // RA §16 #18, CA §14 #11: the ops_cancel reason's label (owner decision
  // 2026-11-09), and whether the restaurant had accepted the order.
  cancelLabel: string | null;
  accepted: boolean;
  // CU §14 #7: the customer text of the rejection's reason; RA §16 #6: its
  // label.
  rejectText: string | null;
  rejectLabel: string | null;
  // RA §16 #5, #12: the order's prep time (operations chose or moved it).
  prepMin: number | null;
  // Who made the transition (order_events.actor_type).
  actor: string;
  // RA §16 #13: the pickup payment the captain declares; CA §9.4: what the
  // restaurant says it received.
  pickupAmount: string | null;
  receivedAmount: string | null;
  // CA §14 #1: the offer's order pay.
  offerPay: string | null;
  // RA §16 #2: the restaurant's unanswered orders of the business day and
  // the limit before the automatic pause.
  unanswered: { count: number; limit: number } | null;
}

export interface OrderPush {
  // The source's suffix: one push per party and event.
  party: 'customer' | 'merchant' | 'captain';
  recipient: PushRecipient;
  templateKey: string;
  values: Record<string, string>;
  data: Record<string, string>;
}

// The events whose pushes need what the restaurant's push needs beyond the
// order: their pickup request.
export const PICKUP_EVENTS = new Set(['order.pickup_requested', 'order.pickup_rejected']);

export function orderPushes(
  type: string,
  reason: string | null,
  facts: OrderPushFacts,
): OrderPush[] {
  const number = { رقم: facts.number };
  const order = { target: 'order', orderId: facts.orderId };
  const customer = (templateKey: string, values: Record<string, string> = {}): OrderPush => ({
    party: 'customer',
    recipient: { party: 'customer', accountId: facts.customerAccountId },
    templateKey,
    values,
    data: order,
  });
  const merchant = (templateKey: string, values: Record<string, string> = {}): OrderPush => ({
    party: 'merchant',
    recipient: { party: 'merchant', restaurantId: facts.restaurantId, owners: false },
    templateKey,
    values: { ...number, ...values },
    data: order,
  });
  const captain = (
    templateKey: string,
    values: Record<string, string> = {},
    data: Record<string, string> = order,
  ): OrderPush[] =>
    facts.captainId === null
      ? []
      : [
          {
            party: 'captain',
            recipient: { party: 'captain', captainId: facts.captainId },
            templateKey,
            values: { ...number, ...values },
            data,
          },
        ];
  const captainName = facts.captainFirstName ?? '';

  switch (type) {
    case 'order.placed':
      return [merchant('merchant.new_order')];
    case 'order.accepted':
      return [
        customer('customer.accepted', { الساعة: facts.promisedTime ?? '' }),
        // RA §8.15, §16 #5: accepted by operations on the restaurant's behalf.
        ...(facts.actor === 'admin'
          ? [merchant('merchant.accepted_by_operations', { د: String(facts.prepMin ?? '') })]
          : []),
      ];
    case 'order.rejected':
      return [
        // CU §11.9, §14 #7: the apology, with the reason's customer text.
        customer('customer.rejected', {
          المطعم: facts.restaurantName,
          السبب: facts.rejectText ?? '',
        }),
        // RA §8.15, §16 #6: rejected by operations on the restaurant's
        // behalf; the restaurant's own rejection needs no push.
        ...(facts.actor === 'admin'
          ? [merchant('merchant.rejected_by_operations', { السبب: facts.rejectLabel ?? '' })]
          : []),
      ];
    case 'order.ready':
      // CA §14 #5: the assigned captain, once the restaurant presses ready.
      return captain('captain.order_ready');
    case 'order.cancelled':
      // RA §16 #4: the customer cancelled while placed; they need no push.
      if (facts.actor === 'customer') return [merchant('merchant.customer_cancelled')];
      if (facts.actor === 'admin') {
        const label = { السبب: facts.cancelLabel ?? '' };
        return [
          customer('customer.cancelled', { السبب: facts.cancelText ?? '' }),
          // RA §8.14, §16 #18: the restaurant stops preparing; a placed order
          // only chimes on its board.
          ...(facts.accepted ? [merchant('merchant.cancelled_after_acceptance', label)] : []),
          // CA §9.10, §14 #11: the assigned captain; an offered one hears nothing.
          ...captain('captain.cancelled', label),
        ];
      }
      return [
        // AP §8.3: the apology, with the reason's customer text.
        customer('customer.cancelled', { السبب: facts.cancelText ?? '' }),
        ...(facts.cancelReason === 'merchant_auto_cancel' && facts.unanswered
          ? [
              merchant('merchant.auto_cancelled', {
                العدد: String(facts.unanswered.count),
                الحد: String(facts.unanswered.limit),
              }),
            ]
          : []),
      ];
    case 'order.offered':
      return captain(
        'captain.new_offer',
        { الأجر: facts.offerPay ?? '', المطعم: facts.restaurantName },
        { target: 'offer', orderId: facts.orderId },
      );
    case 'order.assigned':
      return [
        customer('customer.captain_assigned', { الاسم: captainName }),
        // CA §14 #4: assigned by operations without an offer; an offer the
        // captain accepted needs no push.
        ...(facts.actor === 'admin' ? captain('captain.assigned_by_operations') : []),
      ];
    case 'order.captain_arrived':
      return [merchant('merchant.captain_arrived', { الاسم: captainName })];
    case 'order.pickup_requested':
      return [
        merchant('merchant.pickup_requested', {
          الاسم: captainName,
          المبلغ: facts.pickupAmount ?? '',
        }),
      ];
    case 'order.pickup_rejected':
      return reason === 'amount_incorrect'
        ? captain('captain.pickup_amount_incorrect', { المبلغ: facts.receivedAmount ?? '' })
        : captain('captain.pickup_incomplete');
    case 'order.picked_up':
      return [
        customer('customer.picked_up', { الاسم: captainName }),
        merchant(
          reason === 'operations'
            ? 'merchant.pickup_confirmed_by_operations'
            : 'merchant.picked_up',
        ),
        ...captain('captain.picked_up'),
      ];
    case 'order.pickup_disputed':
      return captain('captain.pickup_disputed');
    case 'order.arrived_at_customer':
      return [
        facts.recipientName
          ? customer('customer.captain_arrived_recipient', {
              المستلم: facts.recipientName,
              المبلغ: facts.total,
            })
          : customer('customer.captain_arrived', { المبلغ: facts.total }),
      ];
    case 'order.delivered':
      return [customer('customer.delivered')];
    case 'order.time_changed':
      return [
        // CU §11.6, §14 #12: the new promised time.
        customer('customer.time_changed', { الساعة: facts.promisedTime ?? '' }),
        // RA §16 #12: the prep time moved while the food was being prepared.
        ...(reason === 'prep_time_changed'
          ? [merchant('merchant.prep_time_changed', { د: String(facts.prepMin ?? '') })]
          : []),
      ];
    default:
      // The search and an offer closing are silent (CA §14 #2).
      return [];
  }
}

// CU §4.6, AP §4.7: an amount as the apps show it, «120 ₺» or «10.50 $», with
// Western digits: a whole amount drops its fraction.
export function formatMoney(
  minor: bigint,
  currency: string,
  known: ReadonlyMap<string, { symbol: string; decimals: number }>,
): string {
  const { symbol, decimals } = known.get(currency) ?? { symbol: currency, decimals: 2 };
  const negative = minor < 0n;
  const digits = (negative ? -minor : minor).toString().padStart(decimals + 1, '0');
  const whole = digits.slice(0, digits.length - decimals);
  const fraction = digits.slice(digits.length - decimals);
  const amount = /^0*$/.test(fraction) ? whole : `${whole}.${fraction}`;
  return `${negative ? '-' : ''}${amount} ${symbol}`;
}

// A 12-hour time on the city's clock with «ص» or «م», as the apps show it.
export function formatTime(moment: Date, timeZone: string): string {
  const parts = Object.fromEntries(
    new Intl.DateTimeFormat('en-US', {
      timeZone,
      hour: 'numeric',
      minute: '2-digit',
      hourCycle: 'h23',
    })
      .formatToParts(moment)
      .map((part) => [part.type, part.value]),
  );
  const hour = Number(parts.hour) % 24;
  return `${hour % 12 === 0 ? 12 : hour % 12}:${parts.minute} ${hour < 12 ? 'ص' : 'م'}`;
}
