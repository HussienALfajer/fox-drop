import { describe, expect, it } from 'vitest';
import table from './phone-cases.json';
import { callingCode, cleanPhone, groupDigits, readPhone } from './phone';

interface Case {
  name: string;
  input: string;
  picked: string;
  country: string;
  grouped: string;
  e164?: string;
  problem?: string;
  missing?: number;
  prefix?: string;
  switchedFrom?: string;
}

/** `{U+XXXX}` in the table is the invisible character itself. */
const withMarks = (text: string) =>
  text.replace(/\{U\+([0-9A-F]{4})\}/g, (_, hex: string) =>
    String.fromCodePoint(Number.parseInt(hex, 16)),
  );

// D.11's normalisation table, shared with core_ui's `phone_rules_test.dart`:
// the web and Flutter read a number by the same rules.
describe('readPhone: every row of phone-cases.json', () => {
  it.each((table.cases as Case[]).map((c) => [c.name, c] as const))('%s', (_, c) => {
    const read = readPhone(withMarks(c.input), c.picked);
    expect({
      country: read.country,
      grouped: read.grouped,
      e164: read.e164,
      problem: read.problem,
      missing: read.missing,
      prefix: read.prefix,
      switchedFrom: read.switchedFrom,
    }).toEqual({
      country: c.country,
      grouped: c.grouped,
      e164: c.e164,
      problem: c.problem,
      missing: c.missing,
      prefix: c.prefix,
      switchedFrom: c.switchedFrom,
    });
  });

  it('has a row for every problem and for a switched country', () => {
    const problems = new Set((table.cases as Case[]).map((c) => c.problem));
    for (const problem of [
      'empty',
      'missingDigits',
      'tooLong',
      'landline',
      'notMobilePrefix',
      'unknownCode',
    ])
      expect(problems).toContain(problem);
    expect((table.cases as Case[]).some((c) => c.switchedFrom)).toBe(true);
  });
});

describe('the helpers', () => {
  it('cleans to + and Western digits only', () => {
    expect(cleanPhone(`${String.fromCodePoint(0x200f)}+٩٦٣ (944)-123.456`)).toBe('+963944123456');
    expect(cleanPhone('call 0944 123 456 now')).toBe('0944123456');
  });

  it('groups by three, the rest as one group of up to four', () => {
    expect(groupDigits('944123456')).toBe('944 123 456');
    expect(groupDigits('5321234567')).toBe('532 123 4567');
    expect(groupDigits('9441')).toBe('9441');
  });

  it('knows every region’s calling code', () => {
    expect(callingCode('SY')).toBe('963');
    expect(callingCode('TR')).toBe('90');
    expect(callingCode('XX')).toBeUndefined();
  });
});
