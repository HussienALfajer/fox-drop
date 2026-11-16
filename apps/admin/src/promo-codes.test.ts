import { describe, expect, it, vi } from 'vitest';
import {
  basisPointsOf,
  createRequestOf,
  emptyForm,
  extendedEndOf,
  fieldsOf,
  formOfCode,
  type PromoCode,
  type PromoForm,
  utcToZoned,
} from './promo-codes.js';

vi.mock('./api.js', () => ({ api: {} }));

// AP §9.11.1 «أكواد الخصم»: the form and the bodies it sends.
const cityId = '01900000-0000-7000-8000-0000000000c1';
const restaurant = '01900000-0000-7000-8000-0000000000d1';
const timeZone = 'Asia/Damascus';

const filled: PromoForm = {
  ...emptyForm,
  code: 'fox20',
  percent: '20',
  maxDiscount: '50',
  minOrder: '150',
  validFrom: '2026-12-01T00:00',
  validTo: '2026-12-31T23:59',
  totalLimit: '100',
  dailyBudget: '1000',
};

describe('the form', () => {
  it('reads percents as basis points', () => {
    expect(basisPointsOf('20')).toBe(2000);
    expect(basisPointsOf('12.5')).toBe(1250);
    expect(basisPointsOf('0.01')).toBe(1);
    expect(basisPointsOf('12.345')).toBeNull();
    expect(basisPointsOf('')).toBeNull();
  });

  it('sends the example of AP §9.11.1 as one typed code, the dates on the city clock', () => {
    expect(createRequestOf(filled, cityId, 'TRY', timeZone)).toEqual({
      mode: 'typed',
      body: {
        cityId,
        code: 'fox20',
        kind: 'percentage',
        percentBp: 2000,
        amount: null,
        maxDiscount: '5000',
        minOrder: '15000',
        validFrom: '2026-11-30T21:00:00.000Z',
        validTo: '2026-12-31T20:59:00.000Z',
        startMinute: null,
        endMinute: null,
        totalLimit: 100,
        perCustomerLimit: 1,
        audience: 'everyone',
        restaurantIds: [],
        zoneIds: [],
        funding: 'platform',
        sharedMerchantBp: null,
        dailyBudget: '100000',
        visibility: 'visible',
      },
    });
  });

  it('sends a batch with its count and prefix', () => {
    const request = createRequestOf(
      { ...filled, mode: 'batch', count: '50', prefix: 'EID' },
      cityId,
      'TRY',
      timeZone,
    );
    expect(request).toMatchObject({ mode: 'batch', body: { count: 50, prefix: 'EID' } });
    expect(
      createRequestOf({ ...filled, mode: 'batch', count: '1' }, cityId, 'TRY', timeZone),
    ).toEqual({ problem: 'count' });
  });

  it('names the first problem', () => {
    const problem = (form: Partial<PromoForm>) =>
      createRequestOf({ ...filled, ...form }, cityId, 'TRY', timeZone);
    expect(problem({ code: 'ab' })).toEqual({ problem: 'code' });
    expect(problem({ percent: '101' })).toEqual({ problem: 'percent' });
    expect(problem({ kind: 'fixed_amount', amount: '' })).toEqual({ problem: 'amount' });
    expect(problem({ minOrder: '0' })).toEqual({ problem: 'money' });
    expect(problem({ validTo: '2026-11-01T00:00' })).toEqual({ problem: 'dates' });
    expect(problem({ start: '20:00' })).toEqual({ problem: 'hours' });
    expect(problem({ totalLimit: '1', perCustomerLimit: '2' })).toEqual({ problem: 'limits' });
    expect(problem({ totalLimit: '1000001' })).toEqual({ problem: 'limits' });
    expect(problem({ totalLimit: '', perCustomerLimit: '1001' })).toEqual({ problem: 'limits' });
    expect(problem({ funding: 'shared', restaurantIds: [restaurant] })).toEqual({
      problem: 'share',
    });
    expect(problem({ funding: 'restaurant' })).toEqual({ problem: 'restaurants' });
  });

  it('sends a free-delivery code without a value and a shared ratio as basis points', () => {
    const checked = fieldsOf(
      {
        ...filled,
        kind: 'free_delivery',
        funding: 'shared',
        sharedPercent: '40',
        restaurantIds: [restaurant],
        start: '20:00',
        end: '02:00',
      },
      'TRY',
      timeZone,
    );
    expect(checked).toMatchObject({
      fields: {
        kind: 'free_delivery',
        percentBp: null,
        maxDiscount: null,
        sharedMerchantBp: 4000,
        startMinute: 1200,
        endMinute: 120,
      },
    });
  });

  it('starts an edit from the saved code', () => {
    const code: PromoCode = {
      id: '01900000-0000-7000-8000-0000000000a1',
      code: 'FOX20',
      batchId: null,
      kind: 'percentage',
      percentBp: 2000,
      amount: null,
      maxDiscount: '5000',
      minOrder: '15000',
      validFrom: '2026-11-30T21:00:00.000Z',
      validTo: '2026-12-31T20:59:00.000Z',
      startMinute: 1200,
      endMinute: 120,
      totalLimit: null,
      perCustomerLimit: 1,
      audience: 'new_users',
      restaurantIds: [],
      zoneIds: [],
      funding: 'platform',
      sharedMerchantBp: null,
      dailyBudget: null,
      visibility: 'secret',
      currency: 'TRY',
      status: 'active',
      state: 'active',
      uses: 0,
      costToDate: '0',
      createdAt: '2026-11-16T10:00:00.000Z',
      updatedAt: '2026-11-16T10:00:00.000Z',
    };
    expect(formOfCode(code, timeZone)).toMatchObject({
      code: 'FOX20',
      percent: '20',
      maxDiscount: '50.00',
      minOrder: '150.00',
      validFrom: '2026-12-01T00:00',
      validTo: '2026-12-31T23:59',
      start: '20:00',
      end: '02:00',
      totalLimit: '',
      audience: 'new_users',
      visibility: 'secret',
    });
    expect(utcToZoned('2026-11-30T21:00:00.000Z', timeZone)).toBe('2026-12-01T00:00');
  });
});

describe('«تمديد» (AP §9.11.1 «Code report», slice 2.21d)', () => {
  const code = { validTo: '2026-12-31T21:00:00.000Z' };
  const now = new Date('2026-12-10T12:00:00Z');

  it('takes a wall time on the city clock later than the end and than now', () => {
    expect(extendedEndOf('2027-01-31T23:59', code, timeZone, now)).toBe('2027-01-31T20:59:00.000Z');
  });

  it('refuses the same end, an earlier one, one before now, and nothing typed', () => {
    expect(extendedEndOf('2027-01-01T00:00', code, timeZone, now)).toBeNull();
    expect(extendedEndOf('2026-12-20T00:00', code, timeZone, now)).toBeNull();
    const ended = { validTo: '2026-12-01T21:00:00.000Z' };
    expect(extendedEndOf('2026-12-05T00:00', ended, timeZone, now)).toBeNull();
    expect(extendedEndOf('2026-12-12T00:00', ended, timeZone, now)).toBe(
      '2026-12-11T21:00:00.000Z',
    );
    expect(extendedEndOf('', code, timeZone, now)).toBeNull();
  });
});
