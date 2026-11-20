import { describe, expect, it, vi } from 'vitest';
import {
  minutesOf,
  orderSettingsOf,
  scheduleOf,
  switchedCurrencies,
  timeOf,
  weekOf,
  withChange,
  withPeriod,
  withoutPeriod,
} from './settings.js';

vi.mock('./api.js', () => ({ api: {} }));

describe('the weekly schedule (RA §10)', () => {
  it('reads each weekday in order, Saturday first, a closed day empty', () => {
    const week = weekOf([
      { weekday: 6, opensAt: 18 * 60, closesAt: 2 * 60 },
      { weekday: 6, opensAt: 9 * 60, closesAt: 14 * 60 },
      { weekday: 0, opensAt: 0, closesAt: 0 },
    ]);
    expect(week[6]).toEqual([
      { opensAt: '09:00', closesAt: '14:00' },
      { opensAt: '18:00', closesAt: '02:00' },
    ]);
    expect(week[0]).toEqual([{ opensAt: '00:00', closesAt: '00:00' }]);
    expect(week[5]).toEqual([]);
  });

  it('adds a period after the last one, removes and changes one', () => {
    const empty = weekOf([]);
    const one = withPeriod(empty, 1);
    expect(one[1]).toEqual([{ opensAt: '09:00', closesAt: '10:00' }]);
    const late = withPeriod(withChange(one, 1, 0, { opensAt: '22:00', closesAt: '23:30' }), 1);
    expect(late[1]?.[1]).toEqual({ opensAt: '23:30', closesAt: '00:30' });
    expect(withoutPeriod(late, 1, 0)[1]).toEqual([{ opensAt: '23:30', closesAt: '00:30' }]);
  });

  it('sends the periods in minutes, or nothing while a time is not one', () => {
    const week = withChange(withPeriod(weekOf([]), 6), 6, 0, {
      opensAt: '18:00',
      closesAt: '02:00',
    });
    expect(scheduleOf(week)).toEqual([{ weekday: 6, opensAt: 1080, closesAt: 120 }]);
    expect(scheduleOf(withChange(week, 6, 0, { opensAt: '', closesAt: '02:00' }))).toBeNull();
    expect(minutesOf('24:00')).toBeNull();
    expect(timeOf(1439)).toBe('23:59');
  });
});

describe('the prep time and the limit (RA §7.4, §10)', () => {
  const limits = { prepFloorMin: 5, prepCeilingMin: 90 };

  it('keeps the prep time within the chooser and the limit off or 1 to 50', () => {
    expect(
      orderSettingsOf({ defaultPrepMin: '20', limited: false, maxActiveOrders: '' }, limits),
    ).toEqual({ defaultPrepMin: 20, maxActiveOrders: null });
    expect(
      orderSettingsOf({ defaultPrepMin: '20', limited: true, maxActiveOrders: '50' }, limits),
    ).toEqual({ defaultPrepMin: 20, maxActiveOrders: 50 });
    for (const form of [
      { defaultPrepMin: '4', limited: false, maxActiveOrders: '' },
      { defaultPrepMin: '91', limited: false, maxActiveOrders: '' },
      { defaultPrepMin: '7.5', limited: false, maxActiveOrders: '' },
      { defaultPrepMin: '20', limited: true, maxActiveOrders: '0' },
      { defaultPrepMin: '20', limited: true, maxActiveOrders: '51' },
    ]) {
      expect(orderSettingsOf(form, limits)).toBeNull();
    }
  });
});

describe('the pickup currencies (RA §12.7)', () => {
  it('switches one and keeps the city’s order', () => {
    const pickup = {
      baseCurrency: { currency: 'TRY', name: 'ليرة تركية' },
      accepted: ['SYP'],
      choices: [
        { currency: 'USD', name: 'دولار' },
        { currency: 'SYP', name: 'ليرة سورية' },
      ],
    };
    expect(switchedCurrencies(pickup, 'USD', true)).toEqual(['USD', 'SYP']);
    expect(switchedCurrencies(pickup, 'SYP', false)).toEqual([]);
  });
});
