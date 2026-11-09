import { describe, expect, it, vi } from 'vitest';
import { canDecide, prepTimeFits, type RejectForm, rejectBody } from './order-on-behalf.js';

vi.mock('./api.js', () => ({ api: {} }));

const choices = {
  prepTime: { options: [10, 15, 20], stepMin: 5, floorMin: 5, ceilingMin: 90, defaultMin: 20 },
  rejectionReasons: [{ code: 'too_busy', label: 'ضغط طلبات' }],
  busyExtraOptionsMin: [10, 20],
};

// AP §9.3.2: OWN and OPS decide for the restaurant while the order is placed.
describe('canDecide', () => {
  const session = (permissions: string[]) => ({ permissions }) as never;
  it('needs operations.manage and a placed order with its choices', () => {
    const placed = { status: 'placed', onBehalf: choices } as const;
    expect(canDecide(session(['operations.manage']), placed)).toBe(true);
    expect(canDecide(session(['operations.read']), placed)).toBe(false);
    expect(canDecide(session(['operations.manage']), { status: 'accepted', onBehalf: null })).toBe(
      false,
    );
  });
});

describe('prepTimeFits (RA §8.5)', () => {
  it('takes a whole minute within the floor and the ceiling', () => {
    expect(prepTimeFits(25, choices.prepTime)).toBe(true);
    expect(prepTimeFits(4, choices.prepTime)).toBe(false);
    expect(prepTimeFits(91, choices.prepTime)).toBe(false);
    expect(prepTimeFits(12.5, choices.prepTime)).toBe(false);
  });
});

// RA §8.6 through AP §9.3.2: a reason, its step and operations' note.
describe('rejectBody', () => {
  const form = (patch: Partial<RejectForm>): RejectForm => ({
    rejection: 'restaurant_closed',
    items: new Map(),
    tooBusy: { kind: 'none' },
    reason: ' اتصل المطعم ',
    ...patch,
  });

  it('waits for a reason and the note', () => {
    expect(rejectBody(form({ rejection: null }))).toBeNull();
    expect(rejectBody(form({ reason: '  ' }))).toBeNull();
    expect(rejectBody(form({}))).toEqual({
      rejection: 'restaurant_closed',
      items: [],
      busyExtraMin: null,
      pauseMin: null,
      reason: 'اتصل المطعم',
    });
  });

  it('needs the items for «صنف غير متوفر», and sends them only then', () => {
    expect(rejectBody(form({ rejection: 'item_unavailable' }))).toBeNull();
    const items = new Map([['item-1', 'turned_back_on' as const]]);
    expect(rejectBody(form({ rejection: 'item_unavailable', items }))?.items).toEqual([
      { itemId: 'item-1', until: 'turned_back_on' },
    ]);
    expect(rejectBody(form({ items }))?.items).toEqual([]);
  });

  it('sends busy mode or the 30-minute pause only with «ضغط طلبات»', () => {
    expect(
      rejectBody(form({ rejection: 'too_busy', tooBusy: { kind: 'busy', minutes: 20 } })),
    ).toMatchObject({ busyExtraMin: 20, pauseMin: null });
    expect(rejectBody(form({ rejection: 'too_busy', tooBusy: { kind: 'pause' } }))).toMatchObject({
      busyExtraMin: null,
      pauseMin: 30,
    });
    expect(rejectBody(form({ tooBusy: { kind: 'pause' } }))).toMatchObject({ pauseMin: null });
  });
});
