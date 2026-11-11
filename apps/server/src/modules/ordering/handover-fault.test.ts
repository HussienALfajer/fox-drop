import { describe, expect, it } from 'vitest';
import { handoverFault } from './order-assignments.js';

// AP §9.7.6 (slices 2.13b, 2.13c; owner decision 2026-11-11): the fault a
// handover keeps while the first captain could not complete the order or
// pressed «طوارئ»; «دون خطأ» wins.
describe('handoverFault', () => {
  const captain = 'c1';

  it('counts the captain at fault by default after «لا أستطيع إكمال الطلب»', () => {
    expect(handoverFault(captain, captain, null, null)).toBe(true);
    expect(handoverFault(captain, captain, null, false)).toBe(false);
  });

  it('counts no fault by default after «طوارئ», also with a request open', () => {
    expect(handoverFault(captain, null, captain, null)).toBe(false);
    expect(handoverFault(captain, captain, captain, null)).toBe(false);
    expect(handoverFault(captain, captain, captain, true)).toBe(true);
  });

  it('keeps no fault without either, or with another captain’s', () => {
    expect(handoverFault(captain, null, null, true)).toBeNull();
    expect(handoverFault(captain, 'c2', 'c2', false)).toBeNull();
  });
});
