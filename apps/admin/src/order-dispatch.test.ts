import { describe, expect, it, vi } from 'vitest';
import { canMoveToManual, dispatchLine } from './order-dispatch.js';

vi.mock('./api.js', () => ({ api: {} }));

const auto = {
  mode: 'auto' as const,
  manual: null,
  autoOffers: 0,
  autoOfferOpen: false,
  maxOffers: null,
};
const waiting = { captain: null, captainTrack: 'searching' as const, status: 'accepted' as const };
const offered = { ...waiting, captainTrack: 'offered' as const };
const captain = { id: 'c1', name: 'كابتن', vehicle: 'motorbike' };

// AP §9.2.1, §9.12.6 (slice 2.15c): the dispatch line of a card.
describe('dispatchLine', () => {
  it('says the search, the open automatic offer and «من {م}» in «مختلط»', () => {
    expect(dispatchLine({ ...waiting, dispatch: auto })).toEqual({ kind: 'searching' });
    expect(
      dispatchLine({ ...offered, dispatch: { ...auto, autoOffers: 2, autoOfferOpen: true } }),
    ).toEqual({ kind: 'offer', offer: 2, of: null });
    expect(
      dispatchLine({
        ...offered,
        dispatch: { ...auto, mode: 'mixed', autoOffers: 3, autoOfferOpen: true, maxOffers: 5 },
      }),
    ).toEqual({ kind: 'offer', offer: 3, of: 5 });
  });

  it('never names operations’ own offer as an automatic one', () => {
    expect(dispatchLine({ ...offered, dispatch: { ...auto, autoOffers: 2 } })).toBeNull();
  });

  it('says why an order left automatic dispatch, whatever the mode and track now', () => {
    const manual = { reason: 'operations' as const, at: '2026-11-12T10:00:00.000Z' };
    const expected = { kind: 'manual', reason: 'operations' };
    expect(dispatchLine({ ...waiting, dispatch: { ...auto, mode: 'manual', manual } })).toEqual(
      expected,
    );
    expect(
      dispatchLine({
        ...waiting,
        captainTrack: null,
        status: 'placed',
        dispatch: { ...auto, manual },
      }),
    ).toEqual(expected);
  });

  it('says nothing in «يدوي», before the search, once a captain has it or after the end', () => {
    expect(dispatchLine({ ...waiting, dispatch: { ...auto, mode: 'manual' } })).toBeNull();
    expect(dispatchLine({ ...waiting, captainTrack: null, dispatch: auto })).toBeNull();
    expect(
      dispatchLine({ ...waiting, captain, captainTrack: 'assigned', dispatch: auto }),
    ).toBeNull();
    const manual = { reason: 'max_offers' as const, at: '2026-11-12T10:00:00.000Z' };
    expect(
      dispatchLine({ ...waiting, status: 'cancelled', dispatch: { ...auto, manual } }),
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
    expect(canMoveToManual(manage, { ...order, captain })).toBe(false);
    expect(canMoveToManual(manage, { ...order, status: 'picked_up' })).toBe(false);
  });
});
