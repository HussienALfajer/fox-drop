import { describe, expect, it } from 'vitest';
import { type ReassignmentFacts, reassignmentEntries } from './reassignment.js';

// AP §9.3.2 «سحب وإعادة تعيين», AP §8.1, docs/domain/01: when operations may
// take an order from its captain before the pickup, and what the cash
// question books.

const assigned: ReassignmentFacts = {
  status: 'accepted',
  restaurantId: 'restaurant-1',
  captainId: 'captain-1',
  captainTrack: 'assigned',
  arrivedAtMerchant: false,
  currency: 'TRY',
  cashLines: [{ currency: 'TRY', amount: 24_000n }],
  cashBase: 24_000n,
};

const atRestaurant: ReassignmentFacts = {
  ...assigned,
  status: 'ready',
  captainTrack: 'at_merchant',
  arrivedAtMerchant: true,
};

describe('reassignmentEntries', () => {
  it('withdraws an assigned order before the restaurant, asking nothing', () => {
    expect(reassignmentEntries(assigned, null)).toEqual({ journals: [], cashAsked: false });
  });

  it('needs an accepted or ready order with a captain', () => {
    for (const status of ['placed', 'picked_up', 'arrived', 'delivered', 'cancelled'] as const) {
      expect(reassignmentEntries({ ...assigned, status }, null)).toEqual({
        problem: 'order_state_changed',
      });
    }
    expect(
      reassignmentEntries({ ...assigned, captainId: null, captainTrack: 'searching' }, null),
    ).toEqual({ problem: 'order_state_changed' });
  });

  it('refuses while a pickup request is open (pickup_request_open)', () => {
    expect(
      reassignmentEntries({ ...atRestaurant, captainTrack: 'pickup_pending' }, 'returned'),
    ).toEqual({ problem: 'pickup_request_open' });
  });

  it('asks the cash question exactly once the captain reached the restaurant', () => {
    expect(reassignmentEntries(atRestaurant, null)).toEqual({ problem: 'cash_answer_required' });
    expect(reassignmentEntries(assigned, 'returned')).toEqual({
      problem: 'cash_answer_not_allowed',
    });
    // The preview answers before the question is answered.
    expect(reassignmentEntries(atRestaurant, null, { preview: true })).toEqual({
      journals: [],
      cashAsked: true,
    });
    expect(reassignmentEntries(assigned, 'returned', { preview: true })).toEqual({
      journals: [],
      cashAsked: false,
    });
  });

  it('books nothing when the cash came back or was never paid', () => {
    for (const cash of ['returned', 'not_paid'] as const) {
      expect(reassignmentEntries(atRestaurant, cash)).toEqual({ journals: [], cashAsked: true });
    }
  });

  it('books the payment the restaurant kept: the captain paid it, the restaurant owes it', () => {
    const result = reassignmentEntries(atRestaurant, 'not_returned');
    expect(result).toEqual({
      cashAsked: true,
      journals: [
        {
          type: 'custody.pay_merchant',
          reason: null,
          entries: [
            {
              account: 'captain.custody',
              party: { kind: 'captain', id: 'captain-1' },
              amount: -24_000n,
              currency: 'TRY',
            },
            {
              account: 'platform.order_clearing',
              party: { kind: 'platform', id: null },
              amount: 24_000n,
              currency: 'TRY',
            },
          ],
        },
        {
          type: 'merchant.debit',
          reason: null,
          entries: [
            {
              account: 'merchant.account',
              party: { kind: 'merchant', id: 'restaurant-1' },
              amount: 24_000n,
              currency: 'TRY',
            },
            {
              account: 'platform.order_clearing',
              party: { kind: 'platform', id: null },
              amount: -24_000n,
              currency: 'TRY',
            },
          ],
        },
      ],
    });
    // The order clearing account nets to zero.
    if ('problem' in result) throw new Error('refused');
    const clearing = result.journals
      .flatMap((journal) => journal.entries)
      .filter((entry) => entry.account === 'platform.order_clearing')
      .reduce((sum, entry) => sum + entry.amount, 0n);
    expect(clearing).toBe(0n);
  });
});
