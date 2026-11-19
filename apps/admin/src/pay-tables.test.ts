import { describe, expect, it, vi } from 'vitest';
import {
  draftOf,
  includedMetresOf,
  kmValueOf,
  payFormOf,
  type PayVersion,
  proposedStart,
  publishRequestOf,
  type RateForm,
} from './pay-tables.js';

vi.mock('./api.js', () => ({ api: {} }));

// AP §9.12.5 «أجور الكباتن»: the table's form and the body it publishes.
const rate = {
  basePay: '2500',
  includedMetres: 3000,
  perExtraKm: '500',
  waitingPerMinute: '0',
  minimumPay: '2500',
};
const version: PayVersion = {
  id: '01900000-0000-7000-8000-0000000000f1',
  state: 'in_force',
  currency: 'TRY',
  effectiveFrom: '2026-11-01T08:00:00.000Z',
  rates: (['walking', 'bicycle', 'motorbike', 'car'] as const).map((vehicle) => ({
    vehicle,
    ...rate,
  })),
  editorName: null,
  reason: null,
  createdAt: '2026-11-01T08:00:00.000Z',
};
const timeZone = 'Asia/Damascus';
const earliestStart = '2026-11-26T10:15:30.000Z';
const context = { cityId: 'city', currency: 'TRY', earliestStart, timeZone };

describe('the distances', () => {
  it('reads the included km to the metre, zero allowed, and a positive maximum', () => {
    expect(includedMetresOf('3')).toBe(3000);
    expect(includedMetresOf('0')).toBe(0);
    expect(includedMetresOf('2.5')).toBe(2500);
    expect(includedMetresOf('2.0005')).toBeNull();
    expect(includedMetresOf('٣')).toBeNull();
    expect(kmValueOf('12.5')).toBe(12.5);
    expect(kmValueOf('0')).toBeNull();
    expect(kmValueOf('-1')).toBeNull();
  });
});

describe('the form', () => {
  it('starts from the newest version an hour past the earliest start, on the city clock', () => {
    const form = payFormOf(version, 'TRY', earliestStart, timeZone);
    expect(form.rates.car).toEqual({
      basePay: '25.00',
      includedKm: '3',
      perExtraKm: '5.00',
      waitingPerMinute: '0.00',
      minimumPay: '25.00',
    });
    // 10:15:30 UTC + 1 h, up to the minute, is 14:16 in Damascus (UTC+3).
    expect(form.start).toBe('2026-11-26T14:16');
    expect(proposedStart(earliestStart, timeZone)).toBe(form.start);
    // A version in another currency than the base starts the form empty.
    expect(payFormOf(version, 'USD', earliestStart, timeZone).rates.car.basePay).toBe('');
  });

  it('publishes every vehicle in minor units with the start and the reason', () => {
    const form = { ...payFormOf(version, 'TRY', earliestStart, timeZone), reason: ' رفع ' };
    form.rates.motorbike = { ...form.rates.motorbike, basePay: '30', waitingPerMinute: '1.5' };
    const request = publishRequestOf(form, context);
    expect(request).toEqual({
      body: {
        cityId: 'city',
        currency: 'TRY',
        effectiveFrom: '2026-11-26T11:16:00.000Z',
        rates: [
          { vehicle: 'walking', ...rate },
          { vehicle: 'bicycle', ...rate },
          { vehicle: 'motorbike', ...rate, basePay: '3000', waitingPerMinute: '150' },
          { vehicle: 'car', ...rate },
        ],
        reason: 'رفع',
      },
    });
  });

  it('names the first problem', () => {
    const form = payFormOf(version, 'TRY', earliestStart, timeZone);
    const bad = (rates: Partial<RateForm>, vehicle: 'car' | 'walking' = 'car') => ({
      ...form,
      reason: 'x',
      rates: { ...form.rates, [vehicle]: { ...form.rates[vehicle], ...rates } },
    });
    expect(publishRequestOf(bad({ basePay: '2.555' }), context)).toEqual({
      problem: 'amount',
      vehicle: 'car',
    });
    expect(publishRequestOf(bad({ includedKm: '' }, 'walking'), context)).toEqual({
      problem: 'distance',
      vehicle: 'walking',
    });
    expect(publishRequestOf({ ...form, reason: 'x', start: '' }, context)).toEqual({
      problem: 'start',
    });
    expect(publishRequestOf({ ...form, reason: 'x', start: '2026-11-26T13:15' }, context)).toEqual({
      problem: 'too_early',
    });
    expect(publishRequestOf({ ...form, reason: '  ' }, context)).toEqual({ problem: 'reason' });
  });

  it('gives the calculator the rate typed, or nothing while it is incomplete', () => {
    const form = payFormOf(version, 'TRY', earliestStart, timeZone);
    expect(draftOf(form.rates.car, 'TRY')).toEqual({
      draftBasePay: '2500',
      draftIncludedMetres: 3000,
      draftPerExtraKm: '500',
      draftWaitingPerMinute: '0',
      draftMinimumPay: '2500',
    });
    expect(draftOf({ ...form.rates.car, minimumPay: '' }, 'TRY')).toBeNull();
  });
});
