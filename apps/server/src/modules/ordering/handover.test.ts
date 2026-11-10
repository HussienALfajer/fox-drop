import { describe, expect, it } from 'vitest';
import { canHandOver, receiptDistance, receiptSet } from './handover.js';

// AP §9.3.2 «تسليم لكابتن آخر», CA §9.10.1, docs/domain/01 (slice 2.12b):
// the pure rules of the handover after the pickup.

const first = '0195f000-0000-7000-8000-000000000001';
const second = '0195f000-0000-7000-8000-000000000002';

describe('canHandOver', () => {
  const order = { status: 'picked_up' as const, captainId: first };
  const clear = { open: false, outcomePending: false };

  it('allows a picked-up or arrived order with its captain, to another captain', () => {
    expect(canHandOver(order, clear, second)).toBeNull();
    expect(canHandOver({ ...order, status: 'arrived' }, clear, second)).toBeNull();
  });

  it('refuses before the pickup and after the end', () => {
    for (const status of ['placed', 'accepted', 'ready', 'delivered', 'failed', 'cancelled']) {
      expect(canHandOver({ ...order, status } as never, clear, second)).toBe(
        'order_not_handoverable',
      );
    }
  });

  it('refuses an order with a handover open or an outcome waiting for its collection', () => {
    expect(canHandOver(order, { ...clear, open: true }, second)).toBe('order_not_handoverable');
    expect(canHandOver(order, { ...clear, outcomePending: true }, second)).toBe(
      'order_not_handoverable',
    );
  });

  it('refuses the order’s own captain as the second captain', () => {
    expect(canHandOver(order, clear, first)).toBe('same_captain');
  });
});

describe('receiptDistance', () => {
  const firstFix = { latitude: 36.59, longitude: 37.046, recordedAt: new Date(0) };

  it('measures the straight line to the first captain’s latest fix', () => {
    const near = receiptDistance({ latitude: 36.5905, longitude: 37.046 }, firstFix, 200);
    expect(near.within).toBe(true);
    expect(near.metres).toBeGreaterThan(50);
    expect(near.metres).toBeLessThan(60);
    const far = receiptDistance({ latitude: 36.6, longitude: 37.046 }, firstFix, 200);
    expect(far.within).toBe(false);
  });

  it('refuses without a fix of the first captain', () => {
    expect(receiptDistance({ latitude: 36.59, longitude: 37.046 }, null, 200)).toEqual({
      within: false,
      metres: null,
    });
  });
});

describe('receiptSet', () => {
  // docs/domain/01: arrived goes back to picked_up with the door arrival
  // cleared, and the order becomes the second captain's.
  it('makes the order the second captain’s, picked up, with no door arrival', () => {
    expect(receiptSet(second)).toEqual({
      status: 'picked_up',
      captainId: second,
      captainTrack: 'picked_up',
      arrivedAtCustomerAt: null,
      awayReason: null,
      awayReasonLabel: null,
      awayNote: null,
    });
  });
});
