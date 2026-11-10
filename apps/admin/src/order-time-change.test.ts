import { describe, expect, it, vi } from 'vitest';
import {
  addMinFits,
  canChangeTime,
  changeTimeBody,
  newPromisedAt,
  prepMoves,
  timeChips,
} from './order-time-change.js';

vi.mock('./api.js', () => ({ api: {} }));

// AP §9.3.2 «تعديل الوقت»: OWN and OPS, while the detail offers it.
describe('canChangeTime', () => {
  const session = (permissions: string[]) => ({ permissions }) as never;
  it('needs operations.manage and the detail choice', () => {
    expect(canChangeTime(session(['operations.manage']), { timeChange: { maxMin: 60 } })).toBe(
      true,
    );
    expect(canChangeTime(session(['operations.read']), { timeChange: { maxMin: 60 } })).toBe(false);
    expect(canChangeTime(session(['operations.manage']), { timeChange: null })).toBe(false);
  });
});

// Owner decision 2026-11-10: the chips, or a whole minute from 1 to the ceiling.
describe('the minutes', () => {
  it('offers the chips within the ceiling', () => {
    expect(timeChips(60)).toEqual([5, 10, 15, 20]);
    expect(timeChips(12)).toEqual([5, 10]);
  });

  it('takes a whole minute from 1 to the ceiling', () => {
    expect(addMinFits(1, 60)).toBe(true);
    expect(addMinFits(60, 60)).toBe(true);
    expect(addMinFits(0, 60)).toBe(false);
    expect(addMinFits(61, 60)).toBe(false);
    expect(addMinFits(7.5, 60)).toBe(false);
    expect(addMinFits(Number.NaN, 60)).toBe(false);
  });
});

describe('changeTimeBody', () => {
  it('sends the minutes with the note, an empty note as null', () => {
    expect(changeTimeBody(7, 60, ' الطريق مزدحم ')).toEqual({ addMin: 7, reason: 'الطريق مزدحم' });
    expect(changeTimeBody(10, 60, '  ')).toEqual({ addMin: 10, reason: null });
    expect(changeTimeBody(61, 60, 'x')).toBeNull();
  });
});

// docs/domain/03: the new promised time rounds up to the next 5 minutes, as
// the server does.
describe('newPromisedAt', () => {
  it('adds the minutes and rounds up to the next 5', () => {
    expect(newPromisedAt('2026-11-10T10:00:00.000Z', 5)).toBe('2026-11-10T10:05:00.000Z');
    expect(newPromisedAt('2026-11-10T10:02:00.000Z', 7)).toBe('2026-11-10T10:10:00.000Z');
    expect(newPromisedAt('2026-11-10T10:00:30.000Z', 1)).toBe('2026-11-10T10:05:00.000Z');
  });
});

describe('prepMoves', () => {
  it('moves the prep time only before the food is ready', () => {
    expect(prepMoves('accepted')).toBe(true);
    expect(prepMoves('ready')).toBe(false);
    expect(prepMoves('picked_up')).toBe(false);
  });
});
