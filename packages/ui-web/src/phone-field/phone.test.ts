import { describe, expect, it } from 'vitest';
import { digitsOf, fromE164, nationalDigits, toE164 } from './phone';

// CU §5.2: Syrian mobiles have 9 digits after +963 and start with 9 (09xxxxxxxx
// and 9xxxxxxxx are accepted); Turkish mobiles have 10 digits after +90 and
// start with 5 (05xxxxxxxxx and 5xxxxxxxxx); the number is stored in E.164.
describe('toE164', () => {
  it.each([
    ['sy', '0912345678', '+963912345678'],
    ['sy', '912345678', '+963912345678'],
    ['sy', '09 123 456 78', '+963912345678'],
    ['tr', '05321234567', '+905321234567'],
    ['tr', '5321234567', '+905321234567'],
  ] as const)('%s %s is %s', (country, typed, expected) => {
    expect(toE164(country, typed)).toBe(expected);
  });

  it.each([
    ['sy', '091234567'], // 8 digits
    ['sy', '0812345678'], // starts with 8
    ['sy', '5321234567'], // a Turkish number under Syria
    ['tr', '0532123456'], // 9 digits
    ['tr', '9123456789'], // starts with 9
    ['sy', ''],
  ] as const)('%s %s is not a complete mobile number', (country, typed) => {
    expect(toE164(country, typed)).toBe('');
  });

  it('reads Arabic-Indic digits as Western digits (AP §4.7)', () => {
    expect(toE164('sy', '٠٩١٢٣٤٥٦٧٨')).toBe('+963912345678');
    expect(digitsOf('۰۹١٢')).toBe('0912');
  });

  it('accepts a pasted number with its calling code', () => {
    expect(toE164('sy', '+963 912 345 678')).toBe('+963912345678');
    expect(toE164('sy', '00963912345678')).toBe('+963912345678');
    expect(toE164('tr', '+90 532 123 45 67')).toBe('+905321234567');
  });

  it('cuts the digits past the country length', () => {
    expect(nationalDigits('sy', '09123456789999')).toBe('912345678');
  });
});

describe('fromE164', () => {
  it('splits a stored number into its country and national digits', () => {
    expect(fromE164('+963912345678')).toEqual({ country: 'sy', national: '912345678' });
    expect(fromE164('+905321234567')).toEqual({ country: 'tr', national: '5321234567' });
  });

  it('refuses anything else', () => {
    expect(fromE164('')).toBeNull();
    expect(fromE164('+96381234567')).toBeNull();
    expect(fromE164('+441234567890')).toBeNull();
  });
});
