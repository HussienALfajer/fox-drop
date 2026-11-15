import { describe, expect, it, vi } from 'vitest';
import { canSettle, netDirection, type SettlementPreview, settleBodyOf } from './settlement.js';

vi.mock('./api.js', () => ({ api: {} }));

const session = (roles: string[]) => ({
  accountId: '01900000-0000-7000-8000-0000000000b1',
  roles,
  permissions: ['cash_desk.record'],
  signedInAt: '2026-11-12T08:00:00.000Z',
  expiresAt: '2026-11-12T20:00:00.000Z',
});

const preview: SettlementPreview = {
  captainId: '01900000-0000-7000-8000-0000000000a1',
  name: 'كابتن',
  cityId: '01900000-0000-7000-8000-0000000000c1',
  payoutDay: true,
  payoutWeekday: 'thursday',
  policy: 'carry_forward',
  custody: [{ currency: 'TRY', balance: '30000', balanceInBase: '30000' }],
  earnings: { amount: '50000', currency: 'TRY' },
  payout: { currency: 'TRY', amount: '50000', rates: [], unit: null },
  collect: null,
  net: [{ currency: 'TRY', amount: '-20000' }],
};

// AP §8.5.5, §9.10.3 (slice 2.18a): who settles on which day, and the body
// that confirms exactly what the screen showed.
describe('the Thursday settlement', () => {
  it('lets every desk user settle on the payout day, and only OWN on another', () => {
    expect(canSettle(session(['FIN']) as never, true)).toBe(true);
    expect(canSettle(session(['FIN']) as never, false)).toBe(false);
    expect(canSettle(session(['OWN']) as never, false)).toBe(true);
  });

  it('nets the custody against the payout: the captain receives 200 ₺', () => {
    expect(netDirection(preview.net[0]!.amount)).toBe('receives');
    expect(netDirection('5000')).toBe('gives');
  });

  it('sends what the preview showed, with a reason only off the payout day', () => {
    expect(settleBodyOf(preview, 'ignored')).toEqual({
      captainId: preview.captainId,
      custody: [{ currency: 'TRY', balance: '30000' }],
      earnings: '50000',
      payout: { currency: 'TRY', amount: '50000', rates: [] },
      reason: null,
    });
    expect(settleBodyOf({ ...preview, payoutDay: false }, '  إنهاء التعاقد ').reason).toBe(
      'إنهاء التعاقد',
    );
    expect(settleBodyOf({ ...preview, payout: null }, '').payout).toBeNull();
  });
});
