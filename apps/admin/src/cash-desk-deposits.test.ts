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
