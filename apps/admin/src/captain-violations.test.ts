import { describe, expect, it, vi } from 'vitest';

vi.mock('./api.js', () => ({ api: {} }));

const { appealStateOf, canRecordViolation, suggestedFor, typeKey, typeOfKey } =
  await import('./captain-violations.js');

// AP §9.7.5–9.7.6 (slice 2.36b): the suggestion the form preselects and the
// appeal's state on a violation.
const violations = {
  violations: [],
  suggestion: { step: 'suspension_7d' as const, windowDays: 90 },
  types: { regular: [], severe: [] },
  suspensions: [],
};

const violation = (appeal: null | { outcome: 'accepted' | 'rejected' | null }) => ({
  appeal:
    appeal === null
      ? null
      : { ticketId: 't', at: '2026-11-19T10:00:00.000Z', outcome: appeal.outcome, decidedAt: null },
});

describe('the violations', () => {
  it('suggests the ladder’s step, and termination for a severe type', () => {
    expect(suggestedFor(violations, false)).toBe('suspension_7d');
    expect(suggestedFor(violations, true)).toBe('termination');
  });

  it('reads the appeal’s state', () => {
    expect(appealStateOf(violation(null) as never)).toBe('none');
    expect(appealStateOf(violation({ outcome: null }) as never)).toBe('open');
    expect(appealStateOf(violation({ outcome: 'accepted' }) as never)).toBe('accepted');
    expect(appealStateOf(violation({ outcome: 'rejected' }) as never)).toBe('rejected');
  });

  it('lets OWN and OPS record one', () => {
    expect(canRecordViolation({ permissions: ['captains.manage'] } as never)).toBe(true);
    expect(canRecordViolation({ permissions: ['captains.read'] } as never)).toBe(false);
  });
});

describe('the type chosen', () => {
  it('keeps its list with its code', () => {
    expect(typeOfKey(typeKey(true, 'theft'))).toEqual({ severe: true, code: 'theft' });
    expect(typeOfKey(typeKey(false, 'other'))).toEqual({ severe: false, code: 'other' });
    expect(typeOfKey('')).toEqual({ severe: false, code: null });
  });
});
