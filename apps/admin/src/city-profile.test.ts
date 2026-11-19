import { describe, expect, it, vi } from 'vitest';
import { cityFormOf, cityRequestOf, nextDisplayOrder } from './city-profile.js';

vi.mock('./api.js', () => ({ api: {} }));

// AP §9.12.1 «المدن»: the form of the city's fields and its body.
const city = {
  id: 'c',
  code: 'AZ',
  name: 'أعزاز',
  timeZone: 'Asia/Damascus',
  status: 'active' as const,
};

describe('cityRequestOf', () => {
  it('sends the fields trimmed, the code in capitals and the status', () => {
    const form = { ...cityFormOf(city), name: ' أعزاز ', code: 'az', active: false };
    expect(cityRequestOf(form)).toEqual({
      body: {
        name: 'أعزاز',
        code: 'AZ',
        timeZone: 'Asia/Damascus',
        status: 'inactive',
        reason: null,
      },
    });
  });

  it('names the first problem', () => {
    const form = cityFormOf(city);
    expect(cityRequestOf({ ...form, name: '' })).toEqual({ problem: 'name' });
    expect(cityRequestOf({ ...form, code: 'A1' })).toEqual({ problem: 'code' });
    expect(cityRequestOf({ ...form, timeZone: 'دمشق' })).toEqual({ problem: 'timeZone' });
    expect(cityRequestOf({ ...form, timeZone: 'America/Argentina/Buenos_Aires' })).toMatchObject({
      body: { timeZone: 'America/Argentina/Buenos_Aires' },
    });
  });
});

describe('nextDisplayOrder', () => {
  it('puts a new currency after the last', () => {
    const currency = { code: 'TRY', name: 'ليرة', symbol: '₺', enabled: true, isBase: true };
    expect(
      nextDisplayOrder({
        city,
        currencies: [
          { ...currency, displayOrder: 1 },
          { ...currency, code: 'USD', displayOrder: 4 },
        ],
        otherCurrencies: [],
        baseLocked: false,
      }),
    ).toBe(5);
  });
});
