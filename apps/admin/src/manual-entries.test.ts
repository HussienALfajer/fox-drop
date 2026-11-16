import { describe, expect, it, vi } from 'vitest';
import {
  adjustmentBody,
  balanceWordsOf,
  partyAccounts,
  signedAmountOf,
  typeKeyOf,
} from './manual-entries.js';

vi.mock('./api.js', () => ({ api: {} }));

// AP §9.10.7 «القيود التصحيحية» (slice 2.20c).
describe('signedAmountOf', () => {
  it('takes major units and signs them by the direction', () => {
    expect(signedAmountOf('500', 'up', 'TRY')).toBe('50000');
    expect(signedAmountOf('12.5', 'down', 'USD')).toBe('-1250');
  });

  it('refuses zero, too many decimals and anything not an amount', () => {
    expect(signedAmountOf('0', 'up', 'TRY')).toBeNull();
    expect(signedAmountOf('0.00', 'down', 'TRY')).toBeNull();
    expect(signedAmountOf('1.234', 'up', 'TRY')).toBeNull();
    expect(signedAmountOf('-5', 'up', 'TRY')).toBeNull();
    expect(signedAmountOf('', 'up', 'TRY')).toBeNull();
  });
});

describe('adjustmentBody', () => {
  const form = {
    party: 'captain' as const,
    partyId: '01900000-0000-7000-8000-0000000000a1',
    account: 'captain.earnings' as const,
    currency: 'TRY',
    amount: '500',
    direction: 'up' as const,
    reason: ' مكافأة نُسيت ',
  };

  it('needs an amount and a reason', () => {
    expect(adjustmentBody('city', form)).toEqual({
      cityId: 'city',
      party: 'captain',
      partyId: form.partyId,
      account: 'captain.earnings',
      currency: 'TRY',
      amount: '50000',
      reason: 'مكافأة نُسيت',
    });
    expect(adjustmentBody('city', { ...form, reason: '  ' })).toBeNull();
    expect(adjustmentBody('city', { ...form, amount: '0' })).toBeNull();
  });
});

describe('balanceWordsOf', () => {
  it("reads a restaurant's balance from its side, the others as they are", () => {
    expect(balanceWordsOf('merchant.account', { amount: '-3000', currency: 'TRY' })).toEqual({
      key: 'manualEntries.restaurantOwes',
      money: { amount: '3000', currency: 'TRY' },
    });
    expect(balanceWordsOf('merchant.account', { amount: '500', currency: 'TRY' })?.key).toBe(
      'manualEntries.restaurantOwed',
    );
    expect(balanceWordsOf('merchant.account', { amount: '0', currency: 'TRY' })).toBeNull();
    expect(balanceWordsOf('captain.earnings', { amount: '-500', currency: 'TRY' })).toBeNull();
  });
});

describe('the accounts and types', () => {
  it('gives each party its accounts', () => {
    expect(partyAccounts).toEqual({
      captain: ['captain.custody', 'captain.earnings'],
      restaurant: ['merchant.account'],
      customer: ['customer.dues'],
    });
  });

  it('labels a known journal type and hides an unknown one', () => {
    expect(typeKeyOf('earn.adjustment')).toBe('manualEntries.type.earnAdjustment');
    expect(typeKeyOf('dues.adjustment')).toBe('manualEntries.type.duesAdjustment');
    expect(typeKeyOf('platform.something')).toBe('manualEntries.type.other');
  });
});
