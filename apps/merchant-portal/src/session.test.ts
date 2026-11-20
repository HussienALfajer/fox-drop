import { describe, expect, it, vi } from 'vitest';
import { phoneOf, whatsappLink } from './session.js';

vi.mock('./api.js', () => ({ api: {} }));

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
