import { describe, expect, it } from 'vitest';
import { strikesSince, trustBasis } from './trust.js';

// D23, docs/domain/08 (slice 2.25b; owner decisions 2026-11-17): «توثيق»
// makes the account trusted until a later fake outcome; «إزالة الثقة» acts as
// a fake outcome, so the normal deliveries count again from it.

const at = (minute: number) => new Date(Date.UTC(2026, 10, 17, 10, minute));

describe('trustBasis (D23 with the marks of AP §9.8)', () => {
  it('counts every delivery without a fake outcome or a mark', () => {
    expect(trustBasis(null, null)).toEqual({ since: null, marked: false });
  });

  it('counts from the latest fake outcome', () => {
    expect(trustBasis(at(5), null)).toEqual({ since: at(5), marked: false });
  });

  it('a fake outcome set by «تغيير النتيجة» after «توثيق» removes the trust', () => {
    // The order's first outcome came before the mark; the change to fake
    // after it, which counts the deliveries from the mark on.
    expect(trustBasis(at(1), { trusted: true, at: at(5) }, at(9))).toEqual({
      since: at(5),
      marked: false,
    });
  });

  it('«توثيق» trusts until a later fake outcome', () => {
    expect(trustBasis(null, { trusted: true, at: at(5) })).toEqual({
      since: at(5),
      marked: true,
    });
    expect(trustBasis(at(1), { trusted: true, at: at(5) })).toEqual({
      since: at(5),
      marked: true,
    });
    expect(trustBasis(at(9), { trusted: true, at: at(5) })).toEqual({
      since: at(9),
      marked: false,
    });
  });

  it('«إزالة الثقة» restarts the count as a fake outcome does', () => {
    expect(trustBasis(null, { trusted: false, at: at(5) })).toEqual({
      since: at(5),
      marked: false,
    });
    expect(trustBasis(at(9), { trusted: false, at: at(5) })).toEqual({
      since: at(9),
      marked: false,
    });
  });
});

describe('strikesSince (docs/domain/08: clearing restarts the count)', () => {
  it('counts the window without a clear', () => {
    expect(strikesSince(at(0), null)).toEqual(at(0));
  });

  it('counts from a clear inside the window', () => {
    expect(strikesSince(at(0), at(5))).toEqual(at(5));
  });

  it('keeps the window when the clear is older', () => {
    expect(strikesSince(at(5), at(0))).toEqual(at(5));
  });
});
