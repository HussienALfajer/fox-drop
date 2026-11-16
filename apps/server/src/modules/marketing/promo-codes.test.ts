import { describe, expect, it } from 'vitest';
import {
  checkPromoFields,
  generatedCode,
  merchantShareBp,
  normalizeCode,
  promoCodeState,
  type PromoFields,
} from './promo-codes.js';

// The field rules of AP §9.11.1 (slice 2.21a), without a database.
const base: PromoFields = {
  kind: 'percentage',
  percentBp: 2000,
  amount: null,
  maxDiscount: 5000n,
  minOrder: 15000n,
  validFrom: new Date('2026-12-01T00:00:00Z'),
  validTo: new Date('2026-12-31T00:00:00Z'),
  startMinute: null,
  endMinute: null,
  totalLimit: 100,
  perCustomerLimit: 1,
  audience: 'everyone',
  restaurantIds: [],
  zoneIds: [],
  funding: 'platform',
  sharedMerchantBp: null,
  dailyBudget: null,
  visibility: 'visible',
};

describe('checkPromoFields', () => {
  it('takes the example of AP §9.11.1: 20% with a maximum of 50 and a minimum of 150', () => {
    expect(checkPromoFields(base)).toBeNull();
  });

  it('asks each type for its own value only', () => {
    expect(checkPromoFields({ ...base, percentBp: null })).toMatch(/percentage/);
    expect(checkPromoFields({ ...base, percentBp: 10001 })).toMatch(/percentage/);
    expect(
      checkPromoFields({
        ...base,
        kind: 'fixed_amount',
        percentBp: null,
        maxDiscount: null,
        amount: 3000n,
      }),
    ).toBeNull();
    expect(
      checkPromoFields({ ...base, kind: 'fixed_amount', percentBp: null, amount: 3000n }),
    ).toMatch(/no percentage or cap/);
    expect(
      checkPromoFields({ ...base, kind: 'free_delivery', percentBp: null, maxDiscount: null }),
    ).toBeNull();
    expect(checkPromoFields({ ...base, kind: 'free_delivery', maxDiscount: null })).toMatch(
      /free-delivery/,
    );
  });

  it('refuses an end before the start, half the hours and the same minute twice', () => {
    expect(checkPromoFields({ ...base, validTo: base.validFrom })).toMatch(/end/);
    expect(checkPromoFields({ ...base, startMinute: 600 })).toMatch(/hours/);
    expect(checkPromoFields({ ...base, startMinute: 600, endMinute: 600 })).toMatch(/same minute/);
    // Hours past midnight are allowed.
    expect(checkPromoFields({ ...base, startMinute: 1200, endMinute: 120 })).toBeNull();
  });

  it('keeps the per-customer limit within the total', () => {
    expect(checkPromoFields({ ...base, totalLimit: 1, perCustomerLimit: 2 })).toMatch(/exceed/);
    expect(checkPromoFields({ ...base, totalLimit: null, perCustomerLimit: null })).toBeNull();
  });

  it('asks a shared code for its ratio and a restaurant-funded code for its restaurants', () => {
    const restaurantIds = ['0195d0c0-0000-7000-8000-000000000001'];
    expect(checkPromoFields({ ...base, funding: 'shared', restaurantIds })).toMatch(/share/);
    expect(
      checkPromoFields({ ...base, funding: 'shared', sharedMerchantBp: 4000, restaurantIds }),
    ).toBeNull();
    expect(checkPromoFields({ ...base, funding: 'restaurant' })).toMatch(/names its restaurants/);
    expect(checkPromoFields({ ...base, sharedMerchantBp: 4000 })).toMatch(/only a shared/);
    expect(merchantShareBp({ funding: 'platform', sharedMerchantBp: null })).toBe(0);
    expect(merchantShareBp({ funding: 'restaurant', sharedMerchantBp: null })).toBe(10000);
    expect(merchantShareBp({ funding: 'shared', sharedMerchantBp: 4000 })).toBe(4000);
  });
});

describe('codes', () => {
  it('stores a typed code trimmed and in upper case', () => {
    expect(normalizeCode('  fox20 ')).toBe('FOX20');
  });

  it('generates the prefix and 8 characters that cannot be misread', () => {
    const code = generatedCode('EID');
    expect(code).toMatch(/^EID[A-HJKMNP-Z2-9]{8}$/);
  });

  it('shows a code scheduled, running, paused or ended', () => {
    const code = { status: 'active' as const, validFrom: base.validFrom, validTo: base.validTo };
    expect(promoCodeState(code, new Date('2026-11-30T00:00:00Z'))).toBe('scheduled');
    expect(promoCodeState(code, new Date('2026-12-10T00:00:00Z'))).toBe('active');
    expect(promoCodeState({ ...code, status: 'paused' }, new Date('2026-12-10T00:00:00Z'))).toBe(
      'paused',
    );
    expect(promoCodeState(code, new Date('2026-12-31T00:00:00Z'))).toBe('expired');
  });
});
