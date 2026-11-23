import { describe, expect, it } from 'vitest';
import { digitsOf, fromE164, parsePhone } from './phone';

const e164 = (country: 'sy' | 'tr', text: string) => parsePhone(country, text).e164;

// CU §5.2: Syrian mobiles have 9 digits after +963 and start with 9 (09xxxxxxxx
// and 9xxxxxxxx are accepted); Turkish mobiles have 10 digits after +90 and
// start with 5 (05xxxxxxxxx and 5xxxxxxxxx); the number is stored in E.164.
describe('parsePhone: the picked country', () => {
  it.each([
    ['sy', '0912345678', '+963912345678'],
    ['sy', '912345678', '+963912345678'],
    ['sy', '09 123 456 78', '+963912345678'],
    ['tr', '05321234567', '+905321234567'],
    ['tr', '5321234567', '+905321234567'],
  ] as const)('%s %s is %s', (country, typed, expected) => {
    expect(e164(country, typed)).toBe(expected);
  });

  it.each([
    ['sy', '091234567'], // 8 digits
    ['sy', '0812345678'], // starts with 8
    ['sy', '5321234567'], // a Turkish number under Syria
    ['tr', '0532123456'], // 9 digits
    ['tr', '9123456789'], // starts with 9
    ['sy', ''],
  ] as const)('%s %s is not a complete mobile number', (country, typed) => {
    expect(e164(country, typed)).toBe('');
  });

  it('reads Arabic-Indic digits as Western digits (AP §4.7)', () => {
    expect(e164('sy', '٠٩١٢٣٤٥٦٧٨')).toBe('+963912345678');
    expect(digitsOf('۰۹١٢')).toBe('0912');
  });

  it('keeps the digits as typed in the box', () => {
    expect(parsePhone('sy', '09123').display).toBe('09123');
  });
});

describe('parsePhone: never cuts digits (as Flutter foxPhoneE164)', () => {
  it.each([
    ['sy', '09123456789'],
    ['sy', '9123456789'],
    ['sy', '09123456789999'],
    ['tr', '053212345678'],
  ] as const)('%s %s is refused, not shortened', (country, typed) => {
    const parsed = parsePhone(country, typed);
    expect(parsed.refused).toBe(true);
    expect(parsed.e164).toBe('');
    expect(parsed.display).toBe(typed);
  });
});

describe('parsePhone: a number with its own calling code', () => {
  it.each([
    ['sy', '+963 912 345 678', 'sy', '+963912345678'],
    ['sy', '00963912345678', 'sy', '+963912345678'],
    ['sy', '963912345678', 'sy', '+963912345678'], // not +963963912345
    ['tr', '+90 532 123 45 67', 'tr', '+905321234567'],
    ['tr', '905321234567', 'tr', '+905321234567'],
  ] as const)('%s picked, %s is %s %s', (picked, typed, country, expected) => {
    const parsed = parsePhone(picked, typed);
    expect(parsed.country).toBe(country);
    expect(parsed.e164).toBe(expected);
    expect(parsed.refused).toBe(false);
  });

  it.each([
    ['sy', '+905321234567', 'tr', '+905321234567'],
    ['sy', '00905321234567', 'tr', '+905321234567'],
    ['sy', '905321234567', 'tr', '+905321234567'],
    ['tr', '+963912345678', 'sy', '+963912345678'],
    ['tr', '00963912345678', 'sy', '+963912345678'],
    ['tr', '963912345678', 'sy', '+963912345678'],
  ] as const)(
    'the other country: %s picked, %s switches to %s',
    (picked, typed, country, expected) => {
      const parsed = parsePhone(picked, typed);
      expect(parsed.country).toBe(country);
      expect(parsed.e164).toBe(expected);
    },
  );

  it.each([
    ['sy', '+90912345678'], // +90 and a number that is not Turkish
    ['sy', '+9059123'], // incomplete
    ['tr', '+9639123'], // incomplete
    ['sy', '+963912345678999'], // too long
    ['sy', '+441234567890'], // neither country
  ] as const)('%s %s is refused, never reshaped into another number', (picked, typed) => {
    const parsed = parsePhone(picked, typed);
    expect(parsed.refused).toBe(true);
    expect(parsed.e164).toBe('');
  });
});

describe('parsePhone: a refused text keeps its plus', () => {
  it.each([
    ['sy', '+90912345678', '+90912345678'],
    ['sy', '+963 912 345 678 999', '+963912345678999'],
    ['sy', '00441234567890', '441234567890'.padStart(14, '0')],
  ] as const)('%s %s shows %s', (picked, typed, shown) => {
    const parsed = parsePhone(picked, typed);
    expect(parsed.refused).toBe(true);
    expect(parsed.display).toBe(shown);
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
