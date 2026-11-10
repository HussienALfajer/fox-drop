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
  // CA §9.10: the pickup payment (the items value), «للمطعم».
  itemsValue: string;
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
  // RA §8.13, §12.5: what an edit after the pickup debits the restaurant
  // when it is responsible; null otherwise.
  merchantDebit: string | null;
  // AP §8.9 «تحديد النتيجة» (slice 2.11a): the outcome's label (AP Appendix
  // C), the status it ended in, the customer's text of a failed order and
  // what the restaurant returns when it is responsible.
  // With an amount to collect (slice 2.11b, K9), the amount, and whether it
  // still waits for the payment.
  outcome: {
    label: string;
    status: 'delivered' | 'failed';
    customerText: string | null;
    merchantDebit: string | null;
    amountToCollect: string | null;
    awaitingCollection: boolean;
  } | null;
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
  // RA §16 «Owners»: the owners' devices only.
  const owners = (templateKey: string, values: Record<string, string> = {}): OrderPush => ({
    ...merchant(templateKey, values),
    recipient: { party: 'merchant', restaurantId: facts.restaurantId, owners: true },
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
  // AP §8.9: the pushes of an outcome posted: the customer's, the owners'
  // and, unless the captain recorded its payment, the captain's.
  const outcomePushes = (
    outcome: NonNullable<OrderPushFacts['outcome']>,
    withCaptain: boolean,
  ): OrderPush[] => {
    const failed = outcome.status === 'failed';
    const debit = outcome.merchantDebit;
    return [
      failed
        ? customer('customer.failed', { السبب: outcome.customerText ?? '' })
        : customer('customer.delivered'),
      ...(failed
        ? [
            debit === null
              ? owners('merchant.order_failed', { النتيجة: outcome.label })
              : owners('merchant.order_failed_debited', {
                  النتيجة: outcome.label,
                  المبلغ: debit,
                }),
          ]
        : debit === null
          ? []
          : [owners('merchant.outcome_debited', { النتيجة: outcome.label, المبلغ: debit })]),
      ...(withCaptain ? captain('captain.outcome_set', { النتيجة: outcome.label }) : []),
    ];
  };

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
    case 'order.outcome_set': {
      // AP §8.9 (slice 2.11a): the customer's «تعذّر تسليم طلبك: {السبب}» (CU
      // §14 #9) or «تم التسليم» for a free or damaged delivery (CU #6); the
      // owners' silent push of a failed order or of what they return (RA
      // §16 #19); the captain's «أنهت العمليات الطلب: {النتيجة}.» (CA §9.10).
      const outcome = facts.outcome;
      if (outcome === null) return [];
      // K9: only the captain hears it now, with the amount; the others when
      // the payment is recorded (order.outcome_collected).
      if (outcome.awaitingCollection) {
        return captain('captain.outcome_collect', {
          النتيجة: outcome.label,
          المبلغ: outcome.amountToCollect ?? '',
        });
      }
      return outcomePushes(outcome, true);
    }
    case 'order.outcome_collected': {
      // K9 (slice 2.11b): the outcome posted from the payment recorded; the
      // captain hears it only when operations recorded it.
      const outcome = facts.outcome;
      return outcome === null ? [] : outcomePushes(outcome, facts.actor === 'admin');
    }
    case 'order.item_reported':
      // CU §11.6, §14 #10: FOX DROP will call the customer.
      return [customer('customer.item_unavailable')];
    case 'order.item_report_closed':
      // RA §16 #37, with operations' reason.
      return [merchant('merchant.item_report_closed', { السبب: reason ?? '' })];
    case 'order.time_changed':
      return [
        // CU §11.6, §14 #12: the new promised time.
        customer('customer.time_changed', { الساعة: facts.promisedTime ?? '' }),
        // RA §16 #12: the prep time moved while the food was being prepared.
        ...(reason === 'prep_time_changed'
          ? [merchant('merchant.prep_time_changed', { د: String(facts.prepMin ?? '') })]
          : []),
      ];
    case 'order.edited':
      // AP §9.3.3 after the pickup (slice 2.10b): the customer's new total,
      // the captain's new amount to collect (CA §9.10), and the owners'
      // silent push of the debit when the restaurant is responsible (RA
      // §8.13, §12.5); the restaurant's devices are not rung.
      if (reason === 'removed_after_pickup' || reason === 'fee_lowered_after_pickup') {
        return [
          customer('customer.order_edited', { المبلغ: facts.total }),
          ...(facts.merchantDebit === null
            ? []
            : [owners('merchant.debited_after_pickup', { المبلغ: facts.merchantDebit })]),
          ...captain(
            reason === 'removed_after_pickup'
              ? 'captain.items_removed_after_pickup'
              : 'captain.collect_lowered',
            { المبلغ: facts.total },
          ),
        ];
      }
      return [
        // CU §11.6, §14 #11: the new total; a ready order back to preparing
        // also moved the promised time (CU §14 #12).
        customer('customer.order_edited', { المبلغ: facts.total }),
        ...(reason === 'items_added_back_to_preparing'
          ? [customer('customer.time_changed', { الساعة: facts.promisedTime ?? '' })]
          : []),
        // RA §8.13, §16 #16–17: an addition rings until acknowledged.
        merchant(reason === 'changed' ? 'merchant.edited' : 'merchant.edited_items_added'),
        // CA §9.10, §14 #10: the new amounts to pay and to collect.
        ...captain('captain.order_edited', {
          للمطعم: facts.itemsValue,
          للتحصيل: facts.total,
        }),
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
