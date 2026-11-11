import { describe, expect, it, vi } from 'vitest';
import { canAssign, canOffer, secondsLeft } from './assign-captain.js';

vi.mock('./api.js', () => ({ api: {} }));

const captain = { id: 'k1', name: 'سامر', vehicle: 'motorbike' };

// AP §9.3.2 «تعيين كابتن», as the server takes it (CA §8.1).
describe('canAssign', () => {
  it('offers «تعيين كابتن» for an accepted or ready order with no captain and no open offer', () => {
    expect(canAssign({ status: 'accepted', captain: null, captainTrack: 'searching' })).toBe(true);
    expect(canAssign({ status: 'ready', captain: null, captainTrack: null })).toBe(true);
  });

  it('hides it while the restaurant has not accepted, an offer is open, or after assignment', () => {
    expect(canAssign({ status: 'placed', captain: null, captainTrack: null })).toBe(false);
    expect(canAssign({ status: 'ready', captain: null, captainTrack: 'offered' })).toBe(false);
    expect(canAssign({ status: 'ready', captain, captainTrack: 'assigned' })).toBe(false);
    expect(canAssign({ status: 'picked_up', captain, captainTrack: 'picked_up' })).toBe(false);
  });
});

// C4, K2, CA §8.4: only «المبلغ أكبر مما يحمله» may be overridden.
describe('canOffer', () => {
  it('offers an eligible captain and one greyed out only for the maximum pickup amount', () => {
    expect(canOffer({ eligible: true, reasons: [] }, true)).toBe(true);
    expect(canOffer({ eligible: false, reasons: ['above_max_pickup'] }, true)).toBe(true);
  });

  it('never overrides the limit when «تعيين» assigns at once', () => {
    expect(canOffer({ eligible: true, reasons: [] }, false)).toBe(true);
    expect(canOffer({ eligible: false, reasons: ['above_max_pickup'] }, false)).toBe(false);
  });

  it('never offers a captain greyed out for any other reason too', () => {
    expect(canOffer({ eligible: false, reasons: ['busy'] }, true)).toBe(false);
    expect(canOffer({ eligible: false, reasons: ['above_max_pickup', 'out_of_range'] }, true)).toBe(
      false,
    );
  });
});

describe('secondsLeft', () => {
  it('counts the offer down to zero', () => {
    const expiresAt = '2026-11-07T09:00:45.000Z';
    expect(secondsLeft(expiresAt, Date.parse('2026-11-07T09:00:00.000Z'))).toBe(45);
    expect(secondsLeft(expiresAt, Date.parse('2026-11-07T09:00:44.500Z'))).toBe(1);
    expect(secondsLeft(expiresAt, Date.parse('2026-11-07T09:01:00.000Z'))).toBe(0);
  });
});
