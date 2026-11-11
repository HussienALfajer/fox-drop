import { describe, expect, it } from 'vitest';
import {
  type CancellationChoices,
  cancellationEntries,
  type CancellationFacts,
  FOOD_CREDIT_REASON,
} from './cancellation.js';

// AP §8.1, docs/domain/01, 08, 09; AP §9.3.2 «إلغاء الطلب»: what operations'
// cancellation books, and when it counts a late-cancellation strike.

// TRY the base; USD at 41.20 TRY (AP §8.6).
const snapshot = {
  cityId: 'city-1',
  baseCurrency: 'TRY',
  takenAt: new Date('2026-11-11T10:00:00Z'),
  currencies: [
    {
      code: 'TRY',
      decimals: 2,
      rate: { numerator: 1n, denominator: 1n },
      rateVersionId: null,
      roundingUnitMinor: 500n,
      roundingMode: 'nearest' as const,
    },
    {
      code: 'USD',
      decimals: 2,
      rate: { numerator: 412n, denominator: 10n },
      rateVersionId: '019a0000-0000-7000-8000-000000000001',
      roundingUnitMinor: 50n,
      roundingMode: 'nearest' as const,
    },
  ],
};

const accepted: CancellationFacts = {
  status: 'accepted',
  restaurantId: 'restaurant-1',
  captainId: null,
  arrivedAtMerchant: false,
  currency: 'TRY',
  itemsValue: 24_000n,
  discount: 0n,
  commissionBp: 1500,
  testOrder: false,
  cashLines: [{ currency: 'TRY', amount: 24_000n }],
  cashBase: 24_000n,
  snapshot,
  captainPay: 2_500n,
};

const atRestaurant: CancellationFacts = {
  ...accepted,
  status: 'ready',
  captainId: 'captain-1',
  arrivedAtMerchant: true,
};

const plain: CancellationChoices = {
  responsible: 'platform',
  foodPrepared: false,
  compensateCaptain: false,
  cash: null,
};

const merchant = { kind: 'merchant', id: 'restaurant-1' };
const captain = { kind: 'captain', id: 'captain-1' };
const platform = { kind: 'platform', id: null };

describe('cancellationEntries', () => {
  it('books nothing and counts no strike for a placed order', () => {
    expect(cancellationEntries({ ...accepted, status: 'placed' }, plain)).toEqual({
      journals: [],
      strike: false,
      merchantCredit: null,
      captainCompensation: null,
      cashAsked: false,
      compensationAllowed: false,
    });
  });

  it('refuses food prepared or a compensation while placed (invalid_cancellation)', () => {
    const placed = { ...accepted, status: 'placed' as const };
    expect(cancellationEntries(placed, { ...plain, foodPrepared: true })).toEqual({
      problem: 'invalid_cancellation',
    });
    expect(cancellationEntries(placed, { ...plain, compensateCaptain: true })).toEqual({
      problem: 'invalid_cancellation',
    });
  });

  it('credits the merchant net on platform.operating_cost when the food was prepared (docs/domain/09)', () => {
    const result = cancellationEntries(accepted, { ...plain, foodPrepared: true });
    // 24 000 less 15% commission.
    expect(result).toMatchObject({ merchantCredit: 20_400n, strike: false });
    expect('journals' in result && result.journals).toEqual([
      {
        type: 'merchant.credit',
        reason: FOOD_CREDIT_REASON,
        entries: [
          { account: 'merchant.account', party: merchant, amount: -20_400n, currency: 'TRY' },
          { account: 'platform.order_clearing', party: platform, amount: 20_400n, currency: 'TRY' },
        ],
      },
      {
        type: 'platform.operating_cost',
        reason: null,
        entries: [
          { account: 'platform.operating_cost', party: platform, amount: 20_400n, currency: 'TRY' },
          {
            account: 'platform.order_clearing',
            party: platform,
            amount: -20_400n,
            currency: 'TRY',
          },
        ],
      },
    ]);
    expect(FOOD_CREDIT_REASON).toBe('تعويض عن طلب أُلغي بعد التحضير');
  });

  it('credits the whole items value on a test order (no commission)', () => {
    const result = cancellationEntries(
      { ...accepted, testOrder: true },
      { ...plain, foodPrepared: true },
    );
    expect(result).toMatchObject({ merchantCredit: 24_000n });
  });

  it('gives no credit when the restaurant is responsible', () => {
    const result = cancellationEntries(accepted, {
      ...plain,
      foodPrepared: true,
      responsible: 'restaurant',
    });
    expect(result).toMatchObject({ journals: [], merchantCredit: null });
  });

  it('refuses a credit on an order with a discount, not booked until codes', () => {
    expect(() =>
      cancellationEntries({ ...accepted, discount: 1_000n }, { ...plain, foodPrepared: true }),
    ).toThrow(/discount/);
  });

  it('counts a strike when the customer is responsible after acceptance, whatever the reason (docs/domain/08)', () => {
    expect(cancellationEntries(accepted, { ...plain, responsible: 'customer' })).toMatchObject({
      strike: true,
    });
    expect(
      cancellationEntries({ ...accepted, status: 'ready' }, { ...plain, responsible: 'customer' }),
    ).toMatchObject({ strike: true });
    expect(
      cancellationEntries({ ...accepted, status: 'placed' }, { ...plain, responsible: 'customer' }),
    ).toMatchObject({ strike: false });
  });

  it('pays the captain the base pay on platform.operating_cost («تعويض الكابتن»)', () => {
    const result = cancellationEntries(atRestaurant, {
      ...plain,
      compensateCaptain: true,
      cash: 'not_paid',
    });
    expect(result).toEqual({
      journals: [
        {
          type: 'earn.order_pay',
          reason: null,
          entries: [
            { account: 'captain.earnings', party: captain, amount: -2_500n, currency: 'TRY' },
            {
              account: 'platform.operating_cost',
              party: platform,
              amount: 2_500n,
              currency: 'TRY',
            },
          ],
        },
      ],
      strike: false,
      merchantCredit: null,
      captainCompensation: 2_500n,
      cashAsked: true,
      compensationAllowed: true,
    });
  });

  it("books a test order's compensation on platform.test_cost", () => {
    const result = cancellationEntries(
      { ...atRestaurant, testOrder: true },
      { ...plain, compensateCaptain: true, cash: 'returned' },
    );
    expect('journals' in result && result.journals[0]!.entries[1]!.account).toBe(
      'platform.test_cost',
    );
  });

  it('refuses a compensation before the captain reached the restaurant, or without a pay', () => {
    expect(cancellationEntries(accepted, { ...plain, compensateCaptain: true })).toEqual({
      problem: 'compensation_not_allowed',
    });
    expect(
      cancellationEntries(
        { ...atRestaurant, captainPay: null },
        { ...plain, compensateCaptain: true, cash: 'returned' },
      ),
    ).toEqual({ problem: 'captain_pay_unset' });
  });

  it('asks the cash question exactly when the captain reached the restaurant', () => {
    expect(cancellationEntries(atRestaurant, plain)).toEqual({ problem: 'cash_answer_required' });
    expect(cancellationEntries(accepted, { ...plain, cash: 'returned' })).toEqual({
      problem: 'cash_answer_not_allowed',
    });
    expect(cancellationEntries(atRestaurant, { ...plain, cash: 'returned' })).toMatchObject({
      journals: [],
      cashAsked: true,
    });
    expect(cancellationEntries(atRestaurant, { ...plain, cash: 'not_paid' })).toMatchObject({
      journals: [],
    });
  });

  it('answers the preview with the questions to ask instead of refusing incomplete choices', () => {
    expect(cancellationEntries(atRestaurant, plain, { preview: true })).toEqual({
      journals: [],
      strike: false,
      merchantCredit: null,
      captainCompensation: null,
      cashAsked: true,
      compensationAllowed: true,
    });
    expect(
      cancellationEntries(
        accepted,
        { ...plain, compensateCaptain: true, cash: 'not_returned' },
        { preview: true },
      ),
    ).toEqual({
      journals: [],
      strike: false,
      merchantCredit: null,
      captainCompensation: null,
      cashAsked: false,
      compensationAllowed: false,
    });
    // What the preview cannot leave out still refuses.
    expect(
      cancellationEntries(
        { ...accepted, status: 'placed' },
        { ...plain, foodPrepared: true },
        { preview: true },
      ),
    ).toEqual({ problem: 'invalid_cancellation' });
  });

  it('brings a kept payment in another currency into the base at the order’s rates (RA §12.7)', () => {
    // 100 TRY and 5 USD (206 TRY): the restaurant owes 306 TRY back.
    const facts = {
      ...atRestaurant,
      cashLines: [
        { currency: 'TRY', amount: 10_000n },
        { currency: 'USD', amount: 500n },
      ],
      cashBase: 30_600n,
    };
    const result = cancellationEntries(facts, { ...plain, cash: 'not_returned' });
    expect('journals' in result && result.journals.slice(-2)).toEqual([
      {
        type: 'platform.fx_rounding',
        reason: null,
        entries: [
          { account: 'platform.order_clearing', party: platform, amount: -500n, currency: 'USD' },
          { account: 'platform.fx_rounding', party: platform, amount: 500n, currency: 'USD' },
          { account: 'platform.order_clearing', party: platform, amount: 20_600n, currency: 'TRY' },
          { account: 'platform.fx_rounding', party: platform, amount: -20_600n, currency: 'TRY' },
        ],
        rates: [{ currency: 'USD', rateVersionId: snapshot.currencies[1]!.rateVersionId }],
      },
      {
        type: 'merchant.debit',
        reason: null,
        entries: [
          {
            account: 'merchant.account',
            party: { kind: 'merchant', id: 'restaurant-1' },
            amount: 30_600n,
            currency: 'TRY',
          },
          {
            account: 'platform.order_clearing',
            party: platform,
            amount: -30_600n,
            currency: 'TRY',
          },
        ],
      },
    ]);
    // The clearing account nets to zero in each currency.
    const clearing = new Map<string, bigint>();
    for (const journal of 'journals' in result ? result.journals : []) {
      for (const entry of journal.entries) {
        if (entry.account !== 'platform.order_clearing') continue;
        clearing.set(entry.currency, (clearing.get(entry.currency) ?? 0n) + entry.amount);
      }
    }
    expect([...clearing.values()]).toEqual([0n, 0n]);
    expect(cancellationEntries(facts, { ...plain, cash: 'returned' })).toMatchObject({
      journals: [],
    });
  });

  it("books the captain's payment and debits the restaurant when it kept the money (AP §8.1)", () => {
    const facts = {
      ...atRestaurant,
      cashLines: [{ currency: 'TRY', amount: 20_000n }],
      cashBase: 20_000n,
    };
    const result = cancellationEntries(facts, { ...plain, cash: 'not_returned' });
    expect('journals' in result && result.journals).toEqual([
      {
        type: 'custody.pay_merchant',
        reason: null,
        entries: [
          { account: 'captain.custody', party: captain, amount: -20_000n, currency: 'TRY' },
          { account: 'platform.order_clearing', party: platform, amount: 20_000n, currency: 'TRY' },
        ],
      },
      {
        type: 'merchant.debit',
        reason: null,
        entries: [
          { account: 'merchant.account', party: merchant, amount: 20_000n, currency: 'TRY' },
          {
            account: 'platform.order_clearing',
            party: platform,
            amount: -20_000n,
            currency: 'TRY',
          },
        ],
      },
    ]);
  });

  it('nets the order clearing account to zero, whatever is booked', () => {
    const result = cancellationEntries(atRestaurant, {
      responsible: 'customer',
      foodPrepared: true,
      compensateCaptain: true,
      cash: 'not_returned',
    });
    if (!('journals' in result)) throw new Error('refused');
    const clearing = result.journals
      .flatMap((journal) => journal.entries)
      .filter((entry) => entry.account === 'platform.order_clearing')
      .reduce((sum, entry) => sum + entry.amount, 0n);
    expect(clearing).toBe(0n);
    for (const journal of result.journals) {
      expect(journal.entries.reduce((sum, entry) => sum + entry.amount, 0n)).toBe(0n);
    }
    expect(result.strike).toBe(true);
  });
});
