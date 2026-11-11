import { describe, expect, it, vi } from 'vitest';
import { canWaitForCustomer, waitBody } from './order-no-answer.js';

vi.mock('./api.js', () => ({ api: {} }));

const noAnswer = (waitAllowed: boolean) => ({ pings: [], reports: [], waitAllowed });

// CA §9.9 «انتظر» (slice 2.13d): OWN and OPS, while the captain's «الزبون لا
// يستجيب» waits.
describe('canWaitForCustomer', () => {
  const session = (permissions: string[]) => ({ permissions }) as never;
  it('needs operations.manage and a report waiting', () => {
    expect(canWaitForCustomer(session(['operations.manage']), { noAnswer: noAnswer(true) })).toBe(
      true,
    );
    expect(canWaitForCustomer(session(['operations.manage']), { noAnswer: noAnswer(false) })).toBe(
      false,
    );
    expect(canWaitForCustomer(session(['operations.read']), { noAnswer: noAnswer(true) })).toBe(
      false,
    );
  });
});

describe('waitBody', () => {
  it('requires the message, trimmed, up to 300 characters', () => {
    expect(waitBody(' انتظره 5 دقائق ')).toEqual({ message: 'انتظره 5 دقائق' });
    expect(waitBody('   ')).toBeNull();
    expect(waitBody('أ'.repeat(301))).toBeNull();
  });
});
