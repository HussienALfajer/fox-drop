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
  cancelText: null,
  cancelReason: null,
  actor: 'restaurant',
  pickupAmount: '120 ₺',
  receivedAmount: '100 ₺',
  offerPay: '25 ₺',
  unanswered: null,
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
  it('rings every device of the restaurant with a new order (RA §16 #1)', () => {
    expect(sent('order.placed', null, { captainId: null })).toEqual([
      [restaurant, 'merchant.new_order', { رقم: '10002' }],
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
