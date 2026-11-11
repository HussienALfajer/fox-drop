import { describe, expect, it } from 'vitest';
import { formatMoney, formatTime, orderPushes, type OrderPushFacts } from './order-pushes.js';

// CU §14, RA §16, CA §14: which push each built event sends to whom.
const facts: OrderPushFacts = {
  orderId: 'order-1',
  number: '10002',
  customerAccountId: 'customer-1',
  restaurantId: 'restaurant-1',
  restaurantName: 'مطعم الاختبار',
  captainId: 'captain-1',
  captainFirstName: 'أحمد',
  recipientName: null,
  promisedTime: '9:45 م',
  total: '160 ₺',
  itemsValue: '120 ₺',
  cancelText: null,
  cancelReason: null,
  cancelLabel: null,
  accepted: false,
  rejectText: null,
  rejectLabel: null,
  prepMin: 20,
  actor: 'restaurant',
  pickupAmount: '120 ₺',
  receivedAmount: '100 ₺',
  offerPay: '25 ₺',
  unanswered: null,
  merchantDebit: null,
  reassignLabel: null,
  reassigned: false,
  outcome: null,
};

const sent = (type: string, reason: string | null = null, more: Partial<OrderPushFacts> = {}) =>
  orderPushes(type, reason, { ...facts, ...more }).map((push) => [
    push.recipient,
    push.templateKey,
    push.values,
  ]);

const customer = { party: 'customer', accountId: 'customer-1' };
const restaurant = { party: 'merchant', restaurantId: 'restaurant-1', owners: false };
const captain = { party: 'captain', captainId: 'captain-1' };

describe('the pushes of an order event', () => {
  it('tells the customer of an item report and the restaurant of its closing by operations (CU §14 #10, RA §16 #37)', () => {
    expect(sent('order.item_reported')).toEqual([[customer, 'customer.item_unavailable', {}]]);
    expect(sent('order.item_report_closed', 'وجد المطعم الصنف', { actor: 'admin' })).toEqual([
      [restaurant, 'merchant.item_report_closed', { رقم: '10002', السبب: 'وجد المطعم الصنف' }],
    ]);
    expect(sent('order.item_report_withdrawn')).toEqual([]);
  });

  it('tells the customer a new promised time, and the restaurant a new prep time (CU §14 #12, RA §16 #12)', () => {
    expect(sent('order.time_changed', 'prep_time_changed', { actor: 'admin' })).toEqual([
      [customer, 'customer.time_changed', { الساعة: '9:45 م' }],
      [restaurant, 'merchant.prep_time_changed', { رقم: '10002', د: '20' }],
    ]);
    expect(sent('order.time_changed', 'promised_time_changed', { actor: 'admin' })).toEqual([
      [customer, 'customer.time_changed', { الساعة: '9:45 م' }],
    ]);
  });

  it('tells every party of an edit: the customer the new total, the restaurant a ring or a chime, the captain the new amounts (CU §14 #11, RA §16 #16–17, CA §14 #10)', () => {
    const amounts = { رقم: '10002', للمطعم: '120 ₺', للتحصيل: '160 ₺' };
    expect(sent('order.edited', 'items_added', { actor: 'admin' })).toEqual([
      [customer, 'customer.order_edited', { المبلغ: '160 ₺' }],
      [restaurant, 'merchant.edited_items_added', { رقم: '10002' }],
      [captain, 'captain.order_edited', amounts],
    ]);
    expect(sent('order.edited', 'changed', { actor: 'admin', captainId: null })).toEqual([
      [customer, 'customer.order_edited', { المبلغ: '160 ₺' }],
      [restaurant, 'merchant.edited', { رقم: '10002' }],
    ]);
    expect(sent('order.edited', 'items_added_back_to_preparing', { actor: 'admin' })).toEqual([
      [customer, 'customer.order_edited', { المبلغ: '160 ₺' }],
      [customer, 'customer.time_changed', { الساعة: '9:45 م' }],
      [restaurant, 'merchant.edited_items_added', { رقم: '10002' }],
      [captain, 'captain.order_edited', amounts],
    ]);
    expect(sent('order.edit_acknowledged')).toEqual([]);
  });

  it('tells the captain the new amount to collect after the pickup, and the owners the debit (CA §9.10, RA §8.13)', () => {
    const owners = { ...restaurant, owners: true };
    expect(
      sent('order.edited', 'removed_after_pickup', { actor: 'admin', merchantDebit: '120 ₺' }),
    ).toEqual([
      [customer, 'customer.order_edited', { المبلغ: '160 ₺' }],
      [owners, 'merchant.debited_after_pickup', { رقم: '10002', المبلغ: '120 ₺' }],
      [captain, 'captain.items_removed_after_pickup', { رقم: '10002', المبلغ: '160 ₺' }],
    ]);
    // Another party responsible: the restaurant hears nothing.
    expect(sent('order.edited', 'fee_lowered_after_pickup', { actor: 'admin' })).toEqual([
      [customer, 'customer.order_edited', { المبلغ: '160 ₺' }],
      [captain, 'captain.collect_lowered', { رقم: '10002', المبلغ: '160 ₺' }],
    ]);
  });

  it('tells everyone an outcome set by operations (CU §14 #6, #9, RA §16 #19, CA §9.10)', () => {
    const owners = { ...restaurant, owners: true };
    const failed = {
      label: 'تعذّر التسليم',
      status: 'failed' as const,
      customerText: 'تعذّر الوصول إليك أو إلى العنوان',
      merchantDebit: null,
      amountToCollect: null,
      awaitingCollection: false,
    };
    expect(sent('order.outcome_set', 'failed_other', { actor: 'admin', outcome: failed })).toEqual([
      [customer, 'customer.failed', { السبب: 'تعذّر الوصول إليك أو إلى العنوان' }],
      [owners, 'merchant.order_failed', { رقم: '10002', النتيجة: 'تعذّر التسليم' }],
      [captain, 'captain.outcome_set', { رقم: '10002', النتيجة: 'تعذّر التسليم' }],
    ]);
    expect(
      sent('order.outcome_set', 'wrong_refused', {
        actor: 'admin',
        outcome: { ...failed, label: 'خطأ ورفضه الزبون', merchantDebit: '400 ₺' },
      })[1],
    ).toEqual([
      owners,
      'merchant.order_failed_debited',
      { رقم: '10002', النتيجة: 'خطأ ورفضه الزبون', المبلغ: '400 ₺' },
    ]);
    const free = {
      label: 'مجاني',
      status: 'delivered' as const,
      customerText: null,
      amountToCollect: null,
      awaitingCollection: false,
    };
    // Delivered: the restaurant hears only what it returns.
    expect(
      sent('order.outcome_set', 'free', {
        actor: 'admin',
        outcome: { ...free, merchantDebit: null },
      }),
    ).toEqual([
      [customer, 'customer.delivered', {}],
      [captain, 'captain.outcome_set', { رقم: '10002', النتيجة: 'مجاني' }],
    ]);
    expect(
      sent('order.outcome_set', 'free', {
        actor: 'admin',
        outcome: { ...free, merchantDebit: '400 ₺' },
      })[1],
    ).toEqual([
      owners,
      'merchant.outcome_debited',
      { رقم: '10002', النتيجة: 'مجاني', المبلغ: '400 ₺' },
    ]);
  });

  it('tells the captain only an amount to collect, and the others once it is recorded (CA §9.10, K9)', () => {
    const owners = { ...restaurant, owners: true };
    const free = {
      label: 'مجاني',
      status: 'delivered' as const,
      customerText: null,
      merchantDebit: '400 ₺',
      amountToCollect: '50 ₺',
    };
    expect(
      sent('order.outcome_set', 'free', {
        actor: 'admin',
        outcome: { ...free, awaitingCollection: true },
      }),
    ).toEqual([
      [captain, 'captain.outcome_collect', { رقم: '10002', النتيجة: 'مجاني', المبلغ: '50 ₺' }],
    ]);
    const collected = { ...free, awaitingCollection: false };
    expect(
      sent('order.outcome_collected', 'free', { actor: 'captain', outcome: collected }),
    ).toEqual([
      [customer, 'customer.delivered', {}],
      [owners, 'merchant.outcome_debited', { رقم: '10002', النتيجة: 'مجاني', المبلغ: '400 ₺' }],
    ]);
    // Operations recorded it: the captain hears the end too.
    expect(
      sent('order.outcome_collected', 'free', { actor: 'admin', outcome: collected }).at(-1),
    ).toEqual([captain, 'captain.outcome_set', { رقم: '10002', النتيجة: 'مجاني' }]);
  });

  // AP §8.9 «تغيير النتيجة» (slice 2.11c; owner decision 2026-11-10): only the
  // parties the change moves hear it.
  it('tells only the parties an outcome change moves', () => {
    const owners = { ...restaurant, owners: true };
    const changed = {
      label: 'تعذّر التسليم',
      status: 'failed' as const,
      customerText: 'تعذّر الوصول إليك أو إلى العنوان',
      merchantDebit: null,
      amountToCollect: null,
      awaitingCollection: false,
      change: { customer: true, duesCancelled: true, captain: false, merchant: false },
    };
    // A fake order changed to failed_other with the platform responsible:
    // the customer's dues are gone; the captain keeps the same pay.
    expect(
      sent('order.outcome_changed', 'failed_other', { actor: 'admin', outcome: changed }),
    ).toEqual([[customer, 'customer.outcome_dues_cancelled', { رقم: '10002' }]]);
    // Delivered after all, the restaurant now returning the payment and the
    // captain charged.
    expect(
      sent('order.outcome_changed', 'damaged', {
        actor: 'admin',
        outcome: {
          ...changed,
          label: 'تالف',
          status: 'delivered',
          customerText: null,
          merchantDebit: '400 ₺',
          change: { customer: true, duesCancelled: false, captain: true, merchant: true },
        },
      }),
    ).toEqual([
      [customer, 'customer.outcome_changed_delivered', { رقم: '10002' }],
      [
        owners,
        'merchant.outcome_changed_debited',
        { رقم: '10002', النتيجة: 'تالف', المبلغ: '400 ₺' },
      ],
      [captain, 'captain.outcome_changed', { رقم: '10002', النتيجة: 'تالف' }],
    ]);
    // The restaurant's debit cleared; the customer's failed text.
    expect(
      sent('order.outcome_changed', 'failed_other', {
        actor: 'admin',
        outcome: {
          ...changed,
          change: { customer: true, duesCancelled: false, captain: false, merchant: true },
        },
      }),
    ).toEqual([
      [
        customer,
        'customer.outcome_changed',
        { رقم: '10002', السبب: 'تعذّر الوصول إليك أو إلى العنوان' },
      ],
      [owners, 'merchant.outcome_changed', { رقم: '10002', النتيجة: 'تعذّر التسليم' }],
    ]);
    // Nothing anyone sees moved: no push.
    expect(
      sent('order.outcome_changed', 'failed_other', {
        actor: 'admin',
        outcome: {
          ...changed,
          change: { customer: false, duesCancelled: false, captain: false, merchant: false },
        },
      }),
    ).toEqual([]);
  });

  it('rings every device of the restaurant with a new order (RA §16 #1)', () => {
    expect(sent('order.placed', null, { captainId: null })).toEqual([
      [restaurant, 'merchant.new_order', { رقم: '10002' }],
    ]);
  });

  it('tells the withdrawn captain, then the customer and the restaurant the new captain (slice 2.12a)', () => {
    // CA §9.10, §14 #11: the event is about the withdrawn captain.
    expect(sent('order.reassigned', 'captain_late', { reassignLabel: 'تأخر الكابتن' })).toEqual([
      [captain, 'captain.withdrawn', { رقم: '10002', السبب: 'تأخر الكابتن' }],
    ]);
    // CU §14 #13, RA §16 #8: an assignment after a withdrawal.
    expect(sent('order.assigned', null, { reassigned: true, actor: 'admin' })).toEqual([
      [customer, 'customer.captain_changed', { الاسم: 'أحمد' }],
      [restaurant, 'merchant.captain_changed', { رقم: '10002', الاسم: 'أحمد' }],
      [captain, 'captain.assigned_by_operations', { رقم: '10002' }],
    ]);
  });

  it('tells the second captain the handover, then the customer and the first captain the receipt (slice 2.12b)', () => {
    // AP §10: the second captain gets the task; the event is about them.
    expect(sent('order.handover_offered')).toEqual([
      [captain, 'captain.new_offer', { رقم: '10002', الأجر: '25 ₺', المطعم: 'مطعم الاختبار' }],
    ]);
    expect(sent('order.handover_assigned', null, { actor: 'admin' })).toEqual([
      [captain, 'captain.assigned_by_operations', { رقم: '10002' }],
    ]);
    expect(sent('order.handover_assigned', null, { actor: 'captain' })).toEqual([]);
    expect(sent('order.handover_closed', 'declined')).toEqual([]);
    // CU §14 #13, CA §14 #11: the receipt; the restaurant hears nothing.
    expect(sent('order.handed_over', null, { otherCaptainId: 'captain-0' })).toEqual([
      [customer, 'customer.captain_changed', { الاسم: 'أحمد' }],
      [
        { party: 'captain', captainId: 'captain-0' },
        'captain.handed_over',
        { رقم: '10002', الاسم: 'أحمد' },
      ],
    ]);
  });

  it('tells the customer the acceptance, the captain, the pickup, the door and the delivery (CU §14 #1–6)', () => {
    expect(sent('order.accepted')).toEqual([[customer, 'customer.accepted', { الساعة: '9:45 م' }]]);
    expect(sent('order.assigned')).toEqual([
      [customer, 'customer.captain_assigned', { الاسم: 'أحمد' }],
    ]);
    expect(sent('order.picked_up', 'restaurant')).toEqual([
      [customer, 'customer.picked_up', { الاسم: 'أحمد' }],
      [restaurant, 'merchant.picked_up', { رقم: '10002' }],
      [captain, 'captain.picked_up', { رقم: '10002' }],
    ]);
    expect(sent('order.arrived_at_customer')).toEqual([
      [customer, 'customer.captain_arrived', { المبلغ: '160 ₺' }],
    ]);
    expect(sent('order.arrived_at_customer', null, { recipientName: 'سارة' })).toEqual([
      [customer, 'customer.captain_arrived_recipient', { المستلم: 'سارة', المبلغ: '160 ₺' }],
    ]);
    expect(sent('order.delivered')).toEqual([[customer, 'customer.delivered', {}]]);
  });

  it('rings the customer at the door and chimes their answer and «انتظر» to the captain (CU §14 #5, CA §14 #13, #13a)', () => {
    expect(sent('order.customer_pinged')).toEqual([[customer, 'customer.door_ping', {}]]);
    expect(sent('order.customer_pinged', null, { recipientName: 'سارة' })).toEqual([
      [customer, 'customer.door_ping_recipient', { المستلم: 'سارة' }],
    ]);
    expect(sent('order.ping_answered', 'coming')).toEqual([
      [captain, 'captain.customer_coming', { رقم: '10002' }],
    ]);
    expect(sent('order.ping_answered', 'contacting_recipient')).toEqual([
      [captain, 'captain.customer_contacting_recipient', { رقم: '10002' }],
    ]);
    // The open app rings on any screen for this push.
    expect(orderPushes('order.customer_pinged', null, facts)[0]!.data).toEqual({
      target: 'order',
      orderId: facts.orderId,
      kind: 'door_ping',
    });
    expect(sent('order.customer_not_answering')).toEqual([]);
    expect(sent('order.no_answer_waited', 'انتظره 5 دقائق')).toEqual([
      [captain, 'captain.no_answer_wait', { رقم: '10002', الرسالة: 'انتظره 5 دقائق' }],
    ]);
  });

  it('apologises for an automatic cancellation and tells the restaurant its count (AP §8.3, RA §16 #2)', () => {
    expect(
      sent('order.cancelled', 'merchant_auto_cancel', {
        captainId: null,
        cancelReason: 'merchant_auto_cancel',
        cancelText: 'لم يرد المطعم على طلبك',
        unanswered: { count: 2, limit: 3 },
      }),
    ).toEqual([
      [customer, 'customer.cancelled', { السبب: 'لم يرد المطعم على طلبك' }],
      [restaurant, 'merchant.auto_cancelled', { رقم: '10002', العدد: '2', الحد: '3' }],
    ]);
  });

  it("chimes the restaurant's devices when the customer cancels, and sends the customer nothing (RA §16 #4, CU §11.4)", () => {
    expect(
      sent('order.cancelled', 'changed_mind', {
        captainId: null,
        actor: 'customer',
        cancelReason: 'changed_mind',
      }),
    ).toEqual([[restaurant, 'merchant.customer_cancelled', { رقم: '10002' }]]);
  });

  it('rings the restaurant and tells the captain when operations cancel after acceptance (RA §16 #18, CA §14 #11)', () => {
    const byOperations = {
      actor: 'admin',
      cancelReason: 'emergency',
      cancelText: 'ظرف طارئ منعنا من إكمال طلبك',
      cancelLabel: 'ظرف طارئ',
      accepted: true,
    };
    expect(sent('order.cancelled', 'emergency', byOperations)).toEqual([
      [customer, 'customer.cancelled', { السبب: 'ظرف طارئ منعنا من إكمال طلبك' }],
      [restaurant, 'merchant.cancelled_after_acceptance', { رقم: '10002', السبب: 'ظرف طارئ' }],
      [captain, 'captain.cancelled', { رقم: '10002', السبب: 'ظرف طارئ' }],
    ]);
    // Placed, no captain: the customer only; the restaurant's board chimes.
    expect(
      sent('order.cancelled', 'emergency', { ...byOperations, accepted: false, captainId: null }),
    ).toEqual([[customer, 'customer.cancelled', { السبب: 'ظرف طارئ منعنا من إكمال طلبك' }]]);
  });

  it('acknowledging a cancellation is silent (RA §8.14)', () => {
    expect(sent('order.cancellation_acknowledged', null, { cancelLabel: 'ظرف طارئ' })).toEqual([]);
  });

  it('apologises for a rejection, and tells the restaurant only when operations acted (CU §14 #7, RA §16 #5, #6)', () => {
    const rejected = {
      captainId: null,
      rejectText: 'بعض الأصناف غير متوفرة: شاورما',
      rejectLabel: 'صنف غير متوفر',
    };
    expect(sent('order.rejected', 'item_unavailable', rejected)).toEqual([
      [
        customer,
        'customer.rejected',
        { المطعم: 'مطعم الاختبار', السبب: 'بعض الأصناف غير متوفرة: شاورما' },
      ],
    ]);
    expect(sent('order.rejected', 'item_unavailable', { ...rejected, actor: 'admin' })).toEqual([
      [
        customer,
        'customer.rejected',
        { المطعم: 'مطعم الاختبار', السبب: 'بعض الأصناف غير متوفرة: شاورما' },
      ],
      [restaurant, 'merchant.rejected_by_operations', { رقم: '10002', السبب: 'صنف غير متوفر' }],
    ]);
    expect(sent('order.accepted', null, { actor: 'admin', prepMin: 25 })).toEqual([
      [customer, 'customer.accepted', { الساعة: '9:45 م' }],
      [restaurant, 'merchant.accepted_by_operations', { رقم: '10002', د: '25' }],
    ]);
  });

  it("offers the captain the pay, and tells operations' assignment only (CA §14 #1, #4)", () => {
    expect(sent('order.offered')).toEqual([
      [captain, 'captain.new_offer', { رقم: '10002', الأجر: '25 ₺', المطعم: 'مطعم الاختبار' }],
    ]);
    expect(orderPushes('order.offered', null, facts)[0]!.data).toEqual({
      target: 'offer',
      orderId: 'order-1',
    });
    expect(sent('order.assigned', null, { actor: 'admin' })).toEqual([
      [customer, 'customer.captain_assigned', { الاسم: 'أحمد' }],
      [captain, 'captain.assigned_by_operations', { رقم: '10002' }],
    ]);
  });

  it('carries the pickup between the captain and the restaurant (RA §16 #9, #13, #15; CA §14 #5, #8, #9)', () => {
    expect(sent('order.captain_arrived')).toEqual([
      [restaurant, 'merchant.captain_arrived', { رقم: '10002', الاسم: 'أحمد' }],
    ]);
    expect(sent('order.ready')).toEqual([[captain, 'captain.order_ready', { رقم: '10002' }]]);
    expect(sent('order.ready', null, { captainId: null })).toEqual([]);
    expect(sent('order.pickup_requested')).toEqual([
      [restaurant, 'merchant.pickup_requested', { رقم: '10002', الاسم: 'أحمد', المبلغ: '120 ₺' }],
    ]);
    expect(sent('order.pickup_rejected', 'amount_incorrect')).toEqual([
      [captain, 'captain.pickup_amount_incorrect', { رقم: '10002', المبلغ: '100 ₺' }],
    ]);
    expect(sent('order.pickup_rejected', 'incomplete')).toEqual([
      [captain, 'captain.pickup_incomplete', { رقم: '10002' }],
    ]);
    expect(sent('order.picked_up', 'operations')[1]).toEqual([
      restaurant,
      'merchant.pickup_confirmed_by_operations',
      { رقم: '10002' },
    ]);
    expect(sent('order.pickup_disputed')).toEqual([
      [captain, 'captain.pickup_disputed', { رقم: '10002' }],
    ]);
  });

  it('keeps the search and a closed offer silent (CA §14 #2)', () => {
    expect(sent('order.search_started')).toEqual([]);
    expect(sent('order.offer_closed', 'expired')).toEqual([]);
  });
});

describe('the values as the apps show them (CU §4.6, AP §4.7)', () => {
  const known = new Map([
    ['TRY', { symbol: '₺', decimals: 2 }],
    ['USD', { symbol: '$', decimals: 2 }],
  ]);

  it('shows money with its symbol, without a whole fraction', () => {
    expect(formatMoney(12_000n, 'TRY', known)).toBe('120 ₺');
    expect(formatMoney(1050n, 'USD', known)).toBe('10.50 $');
    expect(formatMoney(5n, 'XYZ', known)).toBe('0.05 XYZ');
  });

  it("shows a time on the city's 12-hour clock", () => {
    expect(formatTime(new Date('2026-11-08T18:45:00Z'), 'Asia/Damascus')).toBe('9:45 م');
    expect(formatTime(new Date('2026-11-08T21:05:00Z'), 'Asia/Damascus')).toBe('12:05 ص');
    expect(formatTime(new Date('2026-11-08T06:30:00Z'), 'Asia/Damascus')).toBe('9:30 ص');
  });
});
