import { describe, expect, it, vi } from 'vitest';

vi.mock('./api.js', () => ({ api: {} }));

const { statusChoices } = await import('./otp-senders.js');

const number = (status: string) => ({ status }) as never;

// «أرقام إرسال الرموز» (slice 2.38a; architecture §8.3.3 item 13).
describe('statusChoices', () => {
  it('offers active or standby, and nothing before pairing again', () => {
    expect(statusChoices(number('warming'))).toEqual(['active', 'standby']);
    expect(statusChoices(number('active'))).toEqual(['standby']);
    expect(statusChoices(number('standby'))).toEqual(['active']);
    expect(statusChoices(number('throttled'))).toEqual(['active', 'standby']);
    expect(statusChoices(number('disconnected'))).toEqual([]);
    expect(statusChoices(number('banned'))).toEqual([]);
  });
});
