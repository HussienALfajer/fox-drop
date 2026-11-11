import { describe, expect, it, vi } from 'vitest';
import { canMoveToManual, dispatchLine } from './order-dispatch.js';

vi.mock('./api.js', () => ({ api: {} }));

const auto = { mode: 'auto' as const, manual: null, autoOffers: 0, maxOffers: null };
const waiting = { captain: null, captainTrack: 'searching' as const };

// AP §9.2.1, §9.12.6 (slice 2.15c): the dispatch line of a card.
describe('dispatchLine', () => {
  it('says the search, the open automatic offer and «من {م}» in «مختلط»', () => {
    expect(dispatchLine({ ...waiting, dispatch: auto })).toEqual({ kind: 'searching' });
    expect(
      dispatchLine({
        captain: null,
        captainTrack: 'offered',
        dispatch: { ...auto, autoOffers: 2 },
      }),
    ).toEqual({ kind: 'offer', offer: 2, of: null });
    expect(
      dispatchLine({
        captain: null,
        captainTrack: 'offered',
        dispatch: { mode: 'mixed', manual: null, autoOffers: 3, maxOffers: 5 },
      }),
    ).toEqual({ kind: 'offer', offer: 3, of: 5 });
  });

  it('says why an order left automatic dispatch, whatever the mode now', () => {
    const manual = { reason: 'operations' as const, at: '2026-11-12T10:00:00.000Z' };
    expect(dispatchLine({ ...waiting, dispatch: { ...auto, mode: 'manual', manual } })).toEqual({
      kind: 'manual',
      reason: 'operations',
    });
  });

  it('says nothing in «يدوي», before the search or once a captain has the order', () => {
    expect(dispatchLine({ ...waiting, dispatch: { ...auto, mode: 'manual' } })).toBeNull();
    expect(dispatchLine({ captain: null, captainTrack: null, dispatch: auto })).toBeNull();
    expect(
      dispatchLine({
        captain: { id: 'c1', name: 'كابتن', vehicle: 'motorbike' },
        captainTrack: 'assigned',
        dispatch: auto,
      }),
    ).toBeNull();
  });
});

// AP §9.3.2 «توزيع يدوي لهذا الطلب»: OWN and OPS, before assignment, in
// automatic dispatch.
describe('canMoveToManual', () => {
  const session = (permissions: string[]) => ({ permissions }) as never;
  const manage = session(['operations.manage']);
  const order = { dispatch: auto, captain: null, status: 'accepted' as const };
  it('needs operations.manage, no captain and the order still automatic', () => {
    expect(canMoveToManual(manage, order)).toBe(true);
    expect(canMoveToManual(session(['operations.read']), order)).toBe(false);
    expect(canMoveToManual(manage, { ...order, dispatch: { ...auto, mode: 'manual' } })).toBe(
      false,
    );
    expect(
      canMoveToManual(manage, {
        ...order,
        dispatch: { ...auto, manual: { reason: 'max_offers', at: '2026-11-12T10:00:00.000Z' } },
      }),
    ).toBe(false);
    expect(
      canMoveToManual(manage, {
        ...order,
        captain: { id: 'c1', name: 'كابتن', vehicle: 'motorbike' },
      }),
    ).toBe(false);
    expect(canMoveToManual(manage, { ...order, status: 'picked_up' })).toBe(false);
  });
});
