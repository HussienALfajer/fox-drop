import { describe, expect, it } from 'vitest';
import { currentTemplates } from './resend-notification.js';

// AP §9.3.2 «إعادة إرسال الإشعار» pushes the order's current state: never an
// old step («طلب جديد» after acceptance, an offer once assigned).
describe("the templates that tell an order's current state", () => {
  it('rings the restaurant again only while the order waits for it or the captain is there', () => {
    expect(currentTemplates('merchant', 'placed', null)).toEqual(['merchant.new_order']);
    expect(currentTemplates('merchant', 'accepted', 'searching')).toEqual([]);
    expect(currentTemplates('merchant', 'ready', 'at_merchant')).toEqual([
      'merchant.captain_arrived',
    ]);
    expect(currentTemplates('merchant', 'ready', 'pickup_pending')).toEqual([
      'merchant.pickup_requested',
    ]);
    expect(currentTemplates('merchant', 'picked_up', 'picked_up')).toEqual([]);
  });

  it('tells the customer the acceptance, then the captain, the pickup and the door', () => {
    expect(currentTemplates('customer', 'placed', null)).toEqual([]);
    expect(currentTemplates('customer', 'accepted', 'searching')).toEqual(['customer.accepted']);
    expect(currentTemplates('customer', 'ready', 'assigned')).toEqual([
      'customer.captain_assigned',
    ]);
    expect(currentTemplates('customer', 'picked_up', 'picked_up')).toEqual(['customer.picked_up']);
    expect(currentTemplates('customer', 'arrived', 'at_customer')).toEqual([
      'customer.captain_arrived',
      'customer.captain_arrived_recipient',
    ]);
  });

  it('never offers the captain an order already theirs', () => {
    expect(currentTemplates('captain', 'accepted', 'offered')).toEqual([]);
    expect(currentTemplates('captain', 'accepted', 'assigned')).toEqual([
      'captain.assigned_by_operations',
    ]);
    expect(currentTemplates('captain', 'ready', 'assigned')).toEqual([
      'captain.assigned_by_operations',
      'captain.order_ready',
    ]);
    expect(currentTemplates('captain', 'arrived', 'at_customer')).toEqual(['captain.picked_up']);
  });
});
