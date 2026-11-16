import { describe, expect, it, vi } from 'vitest';
import { needsApproval, percentText, valueOf, valueParts } from './order-compensation.js';

vi.mock('./api.js', () => ({ api: {} }));

const fixed = (amount: string) =>
  ({ kind: 'fixed_amount', amount, percentBp: null, maxDiscount: null }) as const;
const form = { kind: 'fixed_amount' as const, amount: '', percent: '', maxDiscount: '' };

describe('«تعويض الزبون»', () => {
  it('takes an amount in major units, or a percentage with its maximum', () => {
    expect(valueOf({ ...form, amount: '25.5' }, 'TRY')).toEqual({
      value: { kind: 'fixed_amount', amount: '2550', percentBp: null, maxDiscount: null },
    });
    expect(valueOf({ ...form, amount: '0' }, 'TRY')).toEqual({ problem: 'amount' });
    expect(valueOf({ ...form, amount: '1.234' }, 'TRY')).toEqual({ problem: 'amount' });
    const percentage = { ...form, kind: 'percentage' as const };
    expect(valueOf({ ...percentage, percent: '20', maxDiscount: '50' }, 'TRY')).toEqual({
      value: { kind: 'percentage', amount: null, percentBp: 2000, maxDiscount: '5000' },
    });
    expect(valueOf({ ...percentage, percent: '101', maxDiscount: '50' }, 'TRY')).toEqual({
      problem: 'percent',
    });
    expect(valueOf({ ...percentage, percent: '20', maxDiscount: '' }, 'TRY')).toEqual({
      problem: 'maxDiscount',
    });
  });

  it('asks OWN when the amount or the maximum passes what the cap leaves', () => {
    expect(needsApproval(fixed('12000'), '12000')).toBe(false);
    expect(needsApproval(fixed('12001'), '12000')).toBe(true);
    expect(
      needsApproval(
        { kind: 'percentage', amount: null, percentBp: 5000, maxDiscount: '12001' },
        '12000',
      ),
    ).toBe(true);
    expect(needsApproval(fixed('999999'), null)).toBe(false);
  });

  it('shows a percentage with its maximum', () => {
    expect(percentText(2000)).toBe('20');
    expect(percentText(1250)).toBe('12.5');
    expect(percentText(1205)).toBe('12.05');
    expect(
      valueParts({
        kind: 'percentage',
        amount: null,
        percentBp: 1000,
        maxDiscount: '5000',
        currency: 'TRY',
      }),
    ).toMatchObject({ kind: 'percentage', percent: '10' });
  });
});
