import { describe, expect, it } from 'vitest';
import { isAppMobile, syrianOrTurkishPhone } from './app-phone.js';

// Review of slice D.11a: the metadata reads a national 0 after the calling
// code as the same number. Taking it would give one phone a second keyed
// hash: a second account, and the number's limits counted twice.
describe('a number that is not canonical E.164', () => {
  it.each([
    ['a Syrian mobile with its 0', '+9630944123456'],
    ['a British mobile with its 0', '+4407400123456'],
    ['a German mobile with its 0', '+49015123456789'],
    ['a Turkish mobile with its 0', '+9005321234567'],
    ['an American number with its 1', '+112025550123'],
    ['a Russian mobile with its 8', '+789161234567'],
    ['an Iraqi mobile with its 0', '+96407701234567'],
  ])('is refused: %s', (_name, phone) => {
    expect(isAppMobile(phone)).toBe(false);
  });
});

// CU §7 (U5): the address's contact number stays Syrian or Turkish; the
// owner widened sign-in only (U3).
describe("the address's contact number", () => {
  it('takes a Syrian or Turkish mobile only', () => {
    expect(syrianOrTurkishPhone.safeParse('+963944123456').success).toBe(true);
    expect(syrianOrTurkishPhone.safeParse('+905321234567').success).toBe(true);
    expect(syrianOrTurkishPhone.safeParse('+4915123456789').success).toBe(false);
  });
});
