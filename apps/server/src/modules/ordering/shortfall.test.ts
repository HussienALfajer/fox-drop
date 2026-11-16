import { describe, expect, it } from 'vitest';
import { SHORTFALL_REASON, shortfallEntries, type ShortfallFacts } from './shortfall.js';

// AP §8.6, docs/domain/06 «Payment at the door» (slice 2.20b): the shortfall
// a collection left on the order clearing account (+2 000 here: the customer
// paid 420 of 440) moves to the party operations choose, the missing amount
// only, from the platform's side; the clearing account goes back to zero.

const facts: ShortfallFacts = {
  amount: 2_000n,
  currency: 'TRY',
  captainId: 'captain-1',
  customerAccountId: 'customer-1',
  testOrder: false,
};

const lines = (result: ReturnType<typeof shortfallEntries>) =>
  result.journals.map((journal) => [
    journal.type,
    journal.reason,
    journal.entries.map((entry) => [entry.account, entry.party.id, entry.amount, entry.currency]),
  ]);

describe('shortfallEntries', () => {
  it('charges the captain the missing amount on their earnings', () => {
    const result = shortfallEntries(facts, 'captain');
    expect(lines(result)).toEqual([
      [
        'earn.charge',
        SHORTFALL_REASON,
        [
          ['captain.earnings', 'captain-1', 2_000n, 'TRY'],
          ['platform.order_clearing', null, -2_000n, 'TRY'],
        ],
      ],
    ]);
    expect(result.captainCharge).toBe(2_000n);
    expect(result.dues).toBeNull();
  });

  it('puts the missing amount only on the customer dues, which blocks until paid', () => {
    const result = shortfallEntries(facts, 'customer');
    expect(lines(result)).toEqual([
      [
        'dues.charge',
        SHORTFALL_REASON,
        [
          ['customer.dues', 'customer-1', 2_000n, 'TRY'],
          ['platform.order_clearing', null, -2_000n, 'TRY'],
        ],
      ],
    ]);
    expect(result.dues).toBe(2_000n);
    expect(result.captainCharge).toBeNull();
  });

  it('books the missing amount as an operating cost of the platform', () => {
    expect(lines(shortfallEntries(facts, 'platform'))).toEqual([
      [
        'platform.operating_cost',
        SHORTFALL_REASON,
        [
          ['platform.operating_cost', null, 2_000n, 'TRY'],
          ['platform.order_clearing', null, -2_000n, 'TRY'],
        ],
      ],
    ]);
  });

  it('books a test order as a test cost', () => {
    expect(lines(shortfallEntries({ ...facts, testOrder: true }, 'platform'))).toEqual([
      [
        'platform.test_cost',
        SHORTFALL_REASON,
        [
          ['platform.test_cost', null, 2_000n, 'TRY'],
          ['platform.order_clearing', null, -2_000n, 'TRY'],
        ],
      ],
    ]);
  });

  it('settles the order clearing account in every case', () => {
    for (const party of ['captain', 'customer', 'platform'] as const) {
      const clearing = shortfallEntries(facts, party)
        .journals.flatMap((journal) => journal.entries)
        .filter((entry) => entry.account === 'platform.order_clearing')
        .reduce((sum, entry) => sum + entry.amount, 0n);
      expect(clearing).toBe(-facts.amount);
    }
  });

  it('refuses a collection with no shortfall', () => {
    expect(() => shortfallEntries({ ...facts, amount: 0n }, 'platform')).toThrow();
  });
});
