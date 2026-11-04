import { describe, expect, it } from 'vitest';
import { changedFields } from './changes.js';

describe('changedFields', () => {
  it('keeps only the fields whose value changed', () => {
    expect(
      changedFields(
        { name: 'Azaz', status: 'active', hours: { open: 9 } },
        { name: 'Azaz', status: 'inactive', hours: { open: 9 } },
      ),
    ).toEqual({ status: { before: 'active', after: 'inactive' } });
  });

  it('compares nested values by content', () => {
    expect(changedFields({ hours: { open: 9 } }, { hours: { open: 10 } })).toEqual({
      hours: { before: { open: 9 }, after: { open: 10 } },
    });
  });

  it('records every field of a created target as added', () => {
    expect(changedFields(null, { name: 'Azaz' })).toEqual({
      name: { before: null, after: 'Azaz' },
    });
  });

  it('records a field that disappears as removed', () => {
    expect(changedFields({ note: 'x' }, {})).toEqual({ note: { before: 'x', after: null } });
  });
});
