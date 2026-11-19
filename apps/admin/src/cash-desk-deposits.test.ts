import { describe, expect, it, vi } from 'vitest';

vi.mock('./api.js', () => ({ api: {} }));

const { settlementOf } = await import('./cash-desk-deposits.js');
const { commandResult } = await import('./captain-applications.js');

// AP §9.7.5 step 4, C17 (slice 2.35b): the deposit follows the kit's step.
describe('the deposit at termination', () => {
  it('waits for the kit, then refunds when it came back and withholds otherwise', () => {
    expect(settlementOf({ kitReturned: null })).toBeNull();
    expect(settlementOf({ kitReturned: true })).toBe('refunded');
    expect(settlementOf({ kitReturned: false })).toBe('withheld');
  });

  it('names the steps «إغلاق الحساب» waits for, and OWN’s approval of a flagged captain', () => {
    const answer = (status: number, body: object) =>
      commandResult({ error: body, response: new Response(null, { status }) });
    expect(answer(409, { error: 'offboarding_incomplete', missing: ['kit', 'deposit'] })).toEqual({
      status: 'refused',
      refusal: 'offboarding_incomplete',
      missing: ['kit', 'deposit'],
    });
    expect(answer(403, { error: 'owner_approval_required' })).toEqual({
      status: 'refused',
      refusal: 'owner_approval_required',
    });
  });
});

describe('the page’s actions once the contract is being ended', async () => {
  const { offboardingActions } = await import('./captain-offboarding.js');
  const all = new Set(['confirm_probation', 'terminate', 'return_kit', 'close', 'review_document']);
  const offboarding = (endedAt: string | null) =>
    ({ endedAt }) as Parameters<typeof offboardingActions>[1];

  it('keeps every action before, drops the probation and «إنهاء التعاقد» during, and all after', () => {
    expect(offboardingActions(all, null)).toBe(all);
    expect([...offboardingActions(all, offboarding(null))].sort()).toEqual(
      ['close', 'return_kit', 'review_document'].sort(),
    );
    expect(offboardingActions(all, offboarding('2026-11-19T10:00:00.000Z')).size).toBe(0);
  });
});
