import { describe, expect, it, vi } from 'vitest';
import { canAssign } from './assign-captain.js';

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
