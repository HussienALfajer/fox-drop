import { describe, expect, it, vi } from 'vitest';
import { fractionText, rateLines, unitText } from './exchange-rates.js';

vi.mock('./api.js', () => ({ api: {} }));

// AP §8.6: a rate is an exact fraction; the screen shows it both ways
// without a float.
describe('fractionText', () => {
  it('shows a fraction to six places, half up, without trailing zeros', () => {
    expect(fractionText('206', '5')).toBe('41.2');
    expect(fractionText('5', '206')).toBe('0.024272');
    expect(fractionText('1', '3')).toBe('0.333333');
    expect(fractionText('2', '3')).toBe('0.666667');
    expect(fractionText('290', '1')).toBe('290');
  });
});

describe('rateLines', () => {
  it('states the rate in both directions', () => {
    const rate = {
      versionId: '1',
      baseCurrency: 'TRY',
      numerator: '206',
      denominator: '5',
      editorId: '01900000-0000-7000-8000-0000000000f1',
      editorName: 'سارة',
      reason: null,
      setAt: '2026-11-16T09:00:00.000Z',
    };
    expect(rateLines('USD', rate)).toEqual({
      basePerUnit: '41.2',
      unitsPerBase: '0.024272',
      currency: 'USD',
      base: 'TRY',
    });
  });
});

describe('unitText', () => {
  it('gives the rounding unit in major units', () => {
    expect(unitText('500', 2)).toBe('5');
    expect(unitText('50', 2)).toBe('0.5');
    expect(unitText(null, 2)).toBeNull();
  });
});
