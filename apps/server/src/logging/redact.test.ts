import { describe, expect, it } from 'vitest';
import { redactText } from './redact.js';

// Architecture §16 with CU U3 (slice D.11a): a number of any country is
// masked in a message, written with + or with 00.
describe('a phone number of any country in a message', () => {
  it.each([
    ['German', '+4915123456789', '004915123456789'],
    ['British', '+447911123456', '00447911123456'],
    ['American', '+12015550123', '0012015550123'],
  ])('is masked when %s', (_country, international, withZeros) => {
    for (const phone of [international, withZeros]) {
      const text = redactText(`code sent to ${phone} just now`);
      expect(text).not.toContain(phone.slice(-8));
      expect(text).toBe(`code sent to ***${phone.slice(-2)} just now`);
    }
  });
});
