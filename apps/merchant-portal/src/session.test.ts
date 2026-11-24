import { describe, expect, it, vi } from 'vitest';
import { phoneOf, signInResultOf, whatsappLink } from './session.js';

vi.mock('./api.js', () => ({ api: {} }));

// Slice D.11a: used-up attempts read as an expired code until D.11 gives
// them words of their own.
describe('a refused code', () => {
  it('reads attempts_used as code_expired', () => {
    expect(signInResultOf({ error: 'attempts_used', attemptsLeft: 0 }, 400)).toEqual({
      status: 'code_expired',
    });
    expect(signInResultOf({ error: 'code_expired', attemptsLeft: 0 }, 400)).toEqual({
      status: 'code_expired',
    });
    expect(signInResultOf({ error: 'wrong_code', attemptsLeft: 2 }, 400)).toEqual({
      status: 'wrong_code',
      attemptsLeft: 2,
    });
  });
});

describe('the owner’s number (RA §5.2)', () => {
  it('takes the forms an owner types', () => {
    expect(phoneOf('0912 345 678')).toBe('+963912345678');
    expect(phoneOf('912345678')).toBe('+963912345678');
    expect(phoneOf('00963912345678')).toBe('+963912345678');
    expect(phoneOf('+90 532 123 45 67')).toBe('+905321234567');
  });

  it('refuses anything else', () => {
    expect(phoneOf('')).toBeNull();
    expect(phoneOf('0812345678')).toBeNull();
    expect(phoneOf('+4915112345678')).toBeNull();
  });

  it('links WhatsApp without the plus', () => {
    expect(whatsappLink('+963912345678')).toBe('https://wa.me/963912345678');
  });
});
