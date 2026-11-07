import { describe, expect, it } from 'vitest';
import { decimalOf, formatMoney } from './format.js';

// AP §4.7, §8.6: integer minor units shown with Western digits, never
// through a float.
describe('decimalOf', () => {
  it('places the decimal point by the currency', () => {
    expect(decimalOf('1250', 'USD')).toBe('12.50');
    expect(decimalOf('5', 'USD')).toBe('0.05');
    expect(decimalOf('-75', 'TRY')).toBe('-0.75');
    expect(decimalOf('9007199254740993', 'USD')).toBe('90071992547409.93');
  });
});

describe('formatMoney', () => {
  it('formats with Western digits', () => {
    expect(formatMoney({ amount: '1250', currency: 'USD' })).toMatch(/12\.50/);
  });
});
