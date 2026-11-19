import { describe, expect, it, vi } from 'vitest';
import {
  bandLines,
  emptyRule,
  type FeeRule,
  kmOf,
  metresOf,
  ruleFormOf,
  ruleRequestOf,
} from './delivery-fees.js';

vi.mock('./api.js', () => ({ api: {} }));

// AP §9.12.3 «رسوم التوصيل»: the rule's form and the body it saves.
const bands: FeeRule = {
  id: '01900000-0000-7000-8000-0000000000f1',
  kind: 'distance_bands',
  currency: 'TRY',
  flatFee: null,
  bands: [
    { upToMetres: 2000, fee: '3000' },
    { upToMetres: 4500, fee: '4000' },
    { upToMetres: null, fee: '5500' },
  ],
  minimumFee: null,
  freeDeliveryFrom: '50000',
};

describe('the distances', () => {
  it('reads km to the metre and writes metres as km', () => {
    expect(metresOf('2')).toBe(2000);
    expect(metresOf('2.5')).toBe(2500);
    expect(metresOf(' 0.25 ')).toBe(250);
    expect(metresOf('0')).toBeNull();
    expect(metresOf('2.0005')).toBeNull();
    expect(metresOf('٢')).toBeNull();
    expect(kmOf(4500)).toBe('4.5');
  });
});

describe('the form of a rule', () => {
  it('starts empty without a rule and from the rule in major units', () => {
    expect(ruleFormOf(null, 'TRY')).toEqual(emptyRule);
    // A rule entered in another currency than the form's starts empty.
    expect(ruleFormOf(bands, 'USD')).toEqual(emptyRule);
    expect(ruleFormOf(bands, 'TRY')).toEqual({
      kind: 'distance_bands',
      flatFee: '',
      bands: [
        { upToKm: '2', fee: '30.00' },
        { upToKm: '4.5', fee: '40.00' },
        { upToKm: '', fee: '55.00' },
      ],
      minimumFee: '',
      freeDeliveryFrom: '500.00',
    });
  });

  it('sends the bands back as they were', () => {
    expect(ruleRequestOf(ruleFormOf(bands, 'TRY'), 'TRY')).toEqual({
      rule: {
        kind: 'distance_bands',
        currency: 'TRY',
        flatFee: null,
        bands: [
          { upToMetres: 2000, fee: '3000' },
          { upToMetres: 4500, fee: '4000' },
          { upToMetres: null, fee: '5500' },
        ],
        minimumFee: null,
        freeDeliveryFrom: '50000',
      },
    });
  });

  it('sends a flat fee with its minimum, empty fields as none', () => {
    expect(
      ruleRequestOf(
        { ...emptyRule, kind: 'flat', flatFee: '40', minimumFee: '25.5', freeDeliveryFrom: ' ' },
        'TRY',
      ),
    ).toEqual({
      rule: {
        kind: 'flat',
        currency: 'TRY',
        flatFee: '4000',
        bands: null,
        minimumFee: '2550',
        freeDeliveryFrom: null,
      },
    });
  });

  it('names the first problem', () => {
    expect(ruleRequestOf({ ...emptyRule, flatFee: 'x' }, 'TRY')).toEqual({ problem: 'fee' });
    const form = ruleFormOf(bands, 'TRY');
    expect(
      ruleRequestOf(
        { ...form, bands: [form.bands[0]!, { ...form.bands[1]!, upToKm: '1.5' }, form.bands[2]!] },
        'TRY',
      ),
    ).toEqual({ problem: 'band_edge', band: 1 });
    expect(
      ruleRequestOf({ ...form, bands: [{ ...form.bands[0]!, fee: '' }, form.bands[2]!] }, 'TRY'),
    ).toEqual({ problem: 'band_fee', band: 0 });
    expect(ruleRequestOf({ ...form, minimumFee: '1.234' }, 'TRY')).toEqual({ problem: 'minimum' });
    expect(ruleRequestOf({ ...form, freeDeliveryFrom: '0' }, 'TRY')).toEqual({
      problem: 'threshold',
    });
  });
});

describe('the bands as lines', () => {
  it('starts each band at the edge before it', () => {
    expect(bandLines(bands)).toEqual([
      { fromMetres: 0, upToMetres: 2000, fee: '3000' },
      { fromMetres: 2000, upToMetres: 4500, fee: '4000' },
      { fromMetres: 4500, upToMetres: null, fee: '5500' },
    ]);
  });
});
