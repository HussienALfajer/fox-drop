import { describe, expect, it, vi } from 'vitest';
import {
  canChangeOutcome,
  changeBody,
  changeFormOf,
  changeLines,
  changePreviewBody,
  type OutcomeChangePreview,
  outcomesFor,
} from './order-outcome-change.js';

vi.mock('./api.js', () => ({ api: {} }));

const TRY = (amount: string) => ({ amount, currency: 'TRY' });

const fake = {
  at: '2026-11-10T10:00:00.000Z',
  awaitingCollection: false,
  collectedAt: null,
  outcome: 'fake' as const,
  status: 'failed' as const,
  responsible: 'customer' as const,
  food: 'kept_by_captain' as const,
  amountToCollect: TRY('0'),
  loss: TRY('20400'),
  dues: TRY('24400'),
  merchantDebit: null,
  captainPay: TRY('2500'),
  customerText: 'لم يُستلم الطلب',
  note: 'اتصلنا بالزبون',
  setBy: '00000000-0000-7000-8000-000000000001',
  history: [],
};

const change = { until: '2026-11-17T10:00:00.000Z', foods: [] };

// AP §8.9 «تغيير النتيجة» (slice 2.11c): OWN only, while the server offers it.
describe('canChangeOutcome', () => {
  const session = (permissions: string[]) => ({ permissions }) as never;
  it('needs orders.change_outcome and the change offered', () => {
    const order = { outcomeChange: change, outcome: fake };
    expect(canChangeOutcome(session(['orders.change_outcome']), order)).toBe(true);
    expect(canChangeOutcome(session(['operations.manage']), order)).toBe(false);
    expect(
      canChangeOutcome(session(['orders.change_outcome']), { ...order, outcomeChange: null }),
    ).toBe(false);
  });
});

describe('the change form', () => {
  it('starts from the outcome in force and needs something different and a reason', () => {
    const form = changeFormOf(fake);
    expect(changePreviewBody(form, fake)).toBeNull();
    const other = { ...form, outcome: 'failed_other' as const, responsible: 'platform' as const };
    expect(changePreviewBody(other, fake)).toEqual({
      outcome: 'failed_other',
      responsible: 'platform',
      delivered: false,
      food: 'kept_by_captain',
    });
    expect(changeBody(other, fake, 9)).toBeNull();
    expect(changeBody({ ...other, reason: ' راجعنا ' }, fake, 9)).toEqual({
      outcome: 'failed_other',
      responsible: 'platform',
      delivered: false,
      food: 'kept_by_captain',
      version: 9,
      reason: 'راجعنا',
    });
  });

  it('offers only a delivered outcome once an amount was collected', () => {
    const free = {
      ...fake,
      outcome: 'free' as const,
      status: 'delivered' as const,
      responsible: 'platform' as const,
      food: null,
      dues: null,
      amountToCollect: TRY('5000'),
    };
    expect(outcomesFor(free)).toEqual(['free', 'damaged']);
    expect(outcomesFor(fake)).toHaveLength(5);
    const form = changeFormOf(free);
    expect(form.damagedDelivered).toBe(true);
    expect(
      changePreviewBody({ ...form, outcome: 'damaged', responsible: 'restaurant' }, free),
    ).toEqual({ outcome: 'damaged', responsible: 'restaurant', delivered: true, food: null });
    expect(
      changePreviewBody(
        { ...form, outcome: 'damaged', responsible: 'restaurant', damagedDelivered: false },
        free,
      ),
    ).toBeNull();
  });
});

// AP §8.9: what the change undoes, in the outcome's own sentences, then what
// it posts.
describe('changeLines', () => {
  const entry = (type: string, account: string, amount: string, kind = 'platform') => ({
    type,
    reason: null,
    account,
    party: { kind: kind as 'platform', id: null, name: kind === 'customer' ? 'سامر' : null },
    amount: TRY(amount),
  });
  it('signs the reversal back as the outcome in force posted it', () => {
    const preview: OutcomeChangePreview = {
      status: 'failed',
      provisional: false,
      loss: TRY('20400'),
      dues: null,
      captainPay: TRY('2500'),
      reversed: [
        entry('dues.charge', 'customer.dues', '-24400', 'customer'),
        entry('dues.charge', 'platform.order_clearing', '20400'),
        entry('dues.charge', 'platform.revenue_delivery', '4000'),
      ],
      entries: [
        entry('platform.operating_cost', 'platform.operating_cost', '20400'),
        entry('platform.operating_cost', 'platform.order_clearing', '-20400'),
      ],
    };
    expect(changeLines(preview)).toEqual({
      undone: [{ key: 'dues', name: 'سامر', amount: TRY('24400') }],
      posted: [{ key: 'platformCost', amount: TRY('20400'), test: false }],
    });
  });
});
