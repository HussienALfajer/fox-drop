import { describe, expect, it, vi } from 'vitest';

vi.mock('./api.js', () => ({ api: {} }));

const { captainChangeActionOf, cashLimitMinor, isCaptainTab, textOf } =
  await import('./captain-profile.js');

// AP §9.7.4–9.7.5 «ملف الكابتن» (slice 2.36a): the tabs and the actions'
// typed values.
describe('the captain profile', () => {
  it('knows its tabs', () => {
    expect(isCaptainTab('contract')).toBe(true);
    expect(isCaptainTab('menu')).toBe(false);
  });

  it('reads a cash limit above zero in the base’s minor units', () => {
    expect(cashLimitMinor('3000', 'TRY')).toBe('300000');
    expect(cashLimitMinor('12.5', 'TRY')).toBe('1250');
    expect(cashLimitMinor('0', 'TRY')).toBeNull();
    expect(cashLimitMinor('abc', 'TRY')).toBeNull();
  });

  it('trims a message and refuses an empty or long one', () => {
    expect(textOf('  مرحباً ', 300)).toBe('مرحباً');
    expect(textOf('   ', 300)).toBeNull();
    expect(textOf('x'.repeat(301), 300)).toBeNull();
  });

  it('names the change log’s known actions only', () => {
    expect(captainChangeActionOf('captain.status')).toBe('captain.status');
    expect(captainChangeActionOf('captain_application.terminate')).toBe(
      'captain_application.terminate',
    );
    expect(captainChangeActionOf('captain.unknown')).toBeNull();
  });
});
