import { describe, expect, it, vi } from 'vitest';
import {
  canSetOutcome,
  emptyOutcome,
  foodsFor,
  type OutcomePreview,
  outcomeBody,
  outcomeLines,
  outcomePreviewBody,
  partiesFor,
} from './order-outcome.js';

vi.mock('./api.js', () => ({ api: {} }));

const choices = {
  foods: [
    { code: 'kept_by_captain' as const, label: 'يبقى مع الكابتن' },
    { code: 'returned_to_restaurant' as const, label: 'أُعيد إلى المطعم' },
    { code: 'destroyed' as const, label: 'أُتلف' },
  ],
};

// AP §9.3.2: OWN and OPS set the outcome of a picked-up or arrived order.
describe('canSetOutcome', () => {
  const session = (permissions: string[]) => ({ permissions }) as never;
  it('needs operations.manage and the dialog choices', () => {
    expect(canSetOutcome(session(['operations.manage']), { outcomeChoices: choices })).toBe(true);
    expect(canSetOutcome(session(['operations.read']), { outcomeChoices: choices })).toBe(false);
    expect(canSetOutcome(session(['operations.manage']), { outcomeChoices: null })).toBe(false);
  });
});

// AP §8.9: fake exactly when the customer is responsible.
describe('partiesFor', () => {
  it('offers the customer for a fake order only', () => {
    expect(partiesFor('fake')).toEqual(['customer']);
    expect(partiesFor('free')).toEqual(['restaurant', 'captain', 'platform']);
    expect(partiesFor(null)).toEqual([]);
  });
});

describe('the outcome body', () => {
  it('waits for an outcome and a fitting party, then the note', () => {
    expect(outcomePreviewBody(emptyOutcome, 'TRY')).toBeNull();
    expect(
      outcomePreviewBody({ ...emptyOutcome, outcome: 'fake', responsible: 'platform' }, 'TRY'),
    ).toBeNull();
    const fake = { ...emptyOutcome, outcome: 'fake' as const, responsible: 'customer' as const };
    expect(outcomePreviewBody(fake, 'TRY')).toEqual({
      outcome: 'fake',
      responsible: 'customer',
      delivered: false,
      food: 'kept_by_captain',
      amountToCollect: '0',
    });
    expect(outcomeBody(fake, 7, 'TRY')).toBeNull();
    expect(outcomeBody({ ...fake, reason: ' اتصلنا ' }, 7, 'TRY')).toMatchObject({
      reason: 'اتصلنا',
      version: 7,
    });
  });

  it('delivers free, and damaged when asked, without a food', () => {
    expect(
      outcomePreviewBody({ ...emptyOutcome, outcome: 'free', responsible: 'platform' }, 'TRY'),
    ).toMatchObject({ delivered: true, food: null });
    const damaged = {
      ...emptyOutcome,
      outcome: 'damaged' as const,
      responsible: 'captain' as const,
    };
    expect(outcomePreviewBody(damaged, 'TRY')).toMatchObject({
      delivered: false,
      food: 'kept_by_captain',
    });
    expect(outcomePreviewBody({ ...damaged, damagedDelivered: true }, 'TRY')).toMatchObject({
      delivered: true,
      food: null,
    });
  });

  it('keeps an amount to collect on a delivered order only (K9)', () => {
    const free = {
      ...emptyOutcome,
      outcome: 'free' as const,
      responsible: 'platform' as const,
      collect: '50',
    };
    expect(outcomePreviewBody(free, 'TRY')?.amountToCollect).toBe('5000');
    expect(outcomePreviewBody({ ...free, collect: '5x' }, 'TRY')).toBeNull();
    const failed = { ...free, outcome: 'failed_other' as const };
    expect(outcomePreviewBody(failed, 'TRY')?.amountToCollect).toBe('0');
  });

  it('returns the food to the restaurant only when it is responsible (K10)', () => {
    const form = {
      ...emptyOutcome,
      outcome: 'wrong_refused' as const,
      responsible: 'captain' as const,
      food: 'returned_to_restaurant' as const,
    };
    expect(foodsFor(form, choices).map((food) => food.code)).toEqual([
      'kept_by_captain',
      'destroyed',
    ]);
    expect(outcomePreviewBody(form, 'TRY')?.food).toBe('kept_by_captain');
    expect(foodsFor({ ...form, responsible: 'restaurant' }, choices)).toHaveLength(3);
    expect(outcomePreviewBody({ ...form, responsible: 'restaurant' }, 'TRY')?.food).toBe(
      'returned_to_restaurant',
    );
  });
});

const money = (amount: string) => ({ amount, currency: 'TRY' });
const entry = (
  type: string,
  account: string,
  amount: string,
  kind: 'merchant' | 'captain' | 'customer' | 'platform',
  name: string | null = null,
  reason: string | null = null,
) => ({ type, reason, account, party: { kind, id: null, name }, amount: money(amount) });

// docs/domain/09's example: «سيُعاد للكابتن 400 (عهدة) ويُقيَّد له أجر 35
// (مستحقات). تُسجَّل عمولة 60 على المطعم. سيُحظر الزبون حتى دفع 380.»
describe('outcomeLines', () => {
  const pickup = { captainName: 'أحمد', payment: money('40000') };
  const fake: OutcomePreview = {
    status: 'failed',
    loss: money('34000'),
    dues: money('38000'),
    captainPay: money('3500'),
    provisional: false,
    entries: [
      entry('merchant.commission', 'merchant.account', '6000', 'merchant', 'مطعم السعادة'),
      entry('merchant.commission', 'platform.order_clearing', '-6000', 'platform'),
      entry('dues.charge', 'customer.dues', '38000', 'customer', 'سامي'),
      entry('dues.charge', 'platform.order_clearing', '-34000', 'platform'),
      entry('dues.charge', 'platform.revenue_delivery', '-4000', 'platform'),
      entry('earn.order_pay', 'captain.earnings', '-3500', 'captain', 'أحمد'),
      entry('earn.order_pay', 'platform.captain_pay', '3500', 'platform'),
    ],
  };

  it('says each entry of a fake order in the spec example style', () => {
    expect(outcomeLines(fake, pickup)).toEqual([
      { key: 'custodyReimbursed', name: 'أحمد', amount: money('40000') },
      { key: 'commission', name: 'مطعم السعادة', amount: money('6000') },
      { key: 'dues', name: 'سامي', amount: money('38000') },
      { key: 'captainPay', name: 'أحمد', amount: money('3500'), by: 'captainPay' },
    ]);
  });

  it("names the captain's charge and the platform's cost", () => {
    const lines = outcomeLines(
      {
        ...fake,
        status: 'delivered',
        entries: [
          entry('earn.charge', 'captain.earnings', '34000', 'captain', 'أحمد', 'تالف'),
          entry('earn.charge', 'platform.order_clearing', '-34000', 'platform', null, 'تالف'),
          entry('platform.operating_cost', 'platform.operating_cost', '-1000', 'platform'),
          entry('platform.operating_cost', 'platform.order_clearing', '1000', 'platform'),
        ],
      },
      pickup,
    );
    expect(lines.slice(1)).toEqual([
      { key: 'captainCharge', name: 'أحمد', amount: money('34000'), reason: 'تالف' },
      { key: 'platformCostReturned', amount: money('1000') },
    ]);
  });

  it('says what is collected, the custody left, the pay it offsets and the revenue (K9)', () => {
    const lines = outcomeLines(
      {
        ...fake,
        status: 'delivered',
        provisional: true,
        entries: [
          entry('custody.collect', 'captain.custody', '5000', 'captain', 'أحمد'),
          entry('custody.collect', 'platform.order_clearing', '-5000', 'platform'),
          entry('merchant.debit', 'merchant.account', '40000', 'merchant', 'مطعم السعادة'),
          entry('merchant.debit', 'platform.order_clearing', '-40000', 'platform'),
          entry('earn.order_pay', 'captain.earnings', '-3500', 'captain', 'أحمد'),
          entry('earn.order_pay', 'platform.operating_cost', '3500', 'platform'),
          entry(
            'platform.operating_cost',
            'platform.operating_cost',
            '-3500',
            'platform',
            null,
            'ما دفعه الزبون يغطّي أجر الكابتن',
          ),
          entry(
            'platform.operating_cost',
            'platform.order_clearing',
            '3500',
            'platform',
            null,
            'ما دفعه الزبون يغطّي أجر الكابتن',
          ),
          entry('platform.revenue_delivery', 'platform.order_clearing', '1500', 'platform'),
          entry('platform.revenue_delivery', 'platform.revenue_delivery', '-1500', 'platform'),
        ],
      },
      pickup,
    );
    expect(lines).toEqual([
      { key: 'collect', name: 'أحمد', amount: money('5000') },
      { key: 'custodyReimbursed', name: 'أحمد', amount: money('35000') },
      { key: 'merchantDebit', name: 'مطعم السعادة', amount: money('40000') },
      { key: 'captainPay', name: 'أحمد', amount: money('3500'), by: 'cost' },
      { key: 'payOffset', amount: money('3500'), test: false },
      { key: 'deliveryRevenue', amount: money('1500') },
    ]);
    expect(
      outcomeLines(
        { ...fake, entries: [entry('custody.collect', 'captain.custody', '42000', 'captain')] },
        pickup,
      ).slice(0, 2),
    ).toEqual([
      { key: 'collect', name: 'أحمد', amount: money('42000') },
      { key: 'custodyHandIn', name: 'أحمد', amount: money('2000') },
    ]);
  });

  it('refuses to name an entry of a sign or type it does not know', () => {
    const lines = outcomeLines(
      {
        ...fake,
        entries: [
          entry('dues.charge', 'customer.dues', '-38000', 'customer'),
          entry('merchant.settlement', 'merchant.account', '100', 'merchant'),
        ],
      },
      pickup,
    );
    expect(lines.slice(1)).toEqual([{ key: 'unknown' }, { key: 'unknown' }]);
  });
});
