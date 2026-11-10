import { describe, expect, it } from 'vitest';
import { decimalOf, formatMoney, minorOf } from './format.js';

// AP §4.7, §8.6: integer minor units shown with Western digits, never
// through a float.
describe('decimalOf', () => {
  it('places the decimal point by the currency', () => {
    expect(decimalOf('1250', 'USD')).toBe('12.50');
    expect(decimalOf('5', 'USD')).toBe('0.05');
    expect(decimalOf('-75', 'TRY')).toBe('-0.75');
    expect(decimalOf('9007199254740993', 'USD')).toBe('90071992547409.93');
    expect(decimalOf('29000', 'SYP')).toBe('290.00');
  });
});

describe('formatMoney', () => {
  it('formats with Western digits', () => {
    expect(formatMoney({ amount: '1250', currency: 'USD' })).toMatch(/12\.50/);
    expect(formatMoney({ amount: '29050', currency: 'SYP' })).toMatch(/290\.50/);
  });
});

describe('minorOf', () => {
  it('reads an amount typed in major units as minor units', () => {
    expect(minorOf('40', 'TRY')).toBe('4000');
    expect(minorOf(' 40.5 ', 'TRY')).toBe('4050');
    expect(minorOf('0', 'TRY')).toBe('0');
    expect(minorOf('0.05', 'USD')).toBe('5');
  });

  it('refuses anything else', () => {
    expect(minorOf('', 'TRY')).toBeNull();
    expect(minorOf('-1', 'TRY')).toBeNull();
    expect(minorOf('1.234', 'TRY')).toBeNull();
    expect(minorOf('١٠', 'TRY')).toBeNull();
    expect(minorOf('1e3', 'TRY')).toBeNull();
  });
});
