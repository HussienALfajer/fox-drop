import { describe, expect, it, vi } from 'vitest';
import {
  DISPATCH_KEYS,
  entriesOf,
  type SettingEntry,
  settingFormOf,
  settingValueOf,
} from './city-settings.js';

vi.mock('./api.js', () => ({ api: {} }));

// AP §9.12.1, §9.12.4, §9.12.6: a setting as its field edits it and the
// value saved.
function entry(key: string, type: string, value: unknown, unit: string | null = null) {
  return {
    key,
    template: key,
    parameter: null,
    group: 'dispatch',
    type,
    unit,
    scope: 'city',
    cityId: 'c',
    editRoles: ['OWN'],
    reasonRequired: false,
    beforeLaunch: false,
    default: value,
    value,
    isDefault: true,
  } as SettingEntry;
}

describe('entriesOf', () => {
  it('keeps the order asked and only what the server gave the role', () => {
    const settings = [
      entry('dispatch.capacity_check', 'boolean', true),
      entry('dispatch.mode', 'enum', 'manual'),
    ];
    expect(entriesOf(settings, DISPATCH_KEYS).map((each) => each.key)).toEqual([
      'dispatch.mode',
      'dispatch.capacity_check',
    ]);
  });
});

describe('settingFormOf and settingValueOf', () => {
  it('saves numbers, enums, flags and times as their types', () => {
    const radius = entry('dispatch.search_radius_km', 'distance', 3, 'km');
    expect(settingFormOf(radius)).toEqual({ kind: 'text', text: '3' });
    expect(settingValueOf(radius, { kind: 'text', text: '2.5' }, null)).toBe(2.5);
    expect(settingValueOf(radius, { kind: 'text', text: 'ثلاثة' }, null)).toBeNull();
    const timeout = entry('dispatch.offer_timeout_sec', 'duration', 45, 'sec');
    expect(settingValueOf(timeout, { kind: 'text', text: '1.5' }, null)).toBeNull();
    const mode = entry('dispatch.mode', 'enum', 'manual');
    expect(settingValueOf(mode, { kind: 'text', text: 'auto' }, null)).toBe('auto');
    const check = entry('dispatch.capacity_check', 'boolean', true);
    expect(settingFormOf(check)).toEqual({ kind: 'flag', on: true });
    expect(settingValueOf(check, { kind: 'flag', on: false }, null)).toBe(false);
    const cutoff = entry('finance.business_day_cutoff', 'time_of_day', '06:00');
    expect(settingValueOf(cutoff, { kind: 'text', text: '05:30' }, null)).toBe('05:30');
    expect(settingValueOf(cutoff, { kind: 'text', text: '25:00' }, null)).toBeNull();
  });

  it('types money in the base currency major units, needing a base', () => {
    const minimum = entry('merchant.default_min_order', 'money', {
      amountMinor: 15000,
      currency: 'TRY',
    });
    expect(settingFormOf(minimum)).toEqual({ kind: 'text', text: '150.00' });
    expect(settingValueOf(minimum, { kind: 'text', text: '200' }, 'TRY')).toEqual({
      amountMinor: 20000,
      currency: 'TRY',
    });
    expect(settingValueOf(minimum, { kind: 'text', text: '200' }, null)).toBeNull();
    expect(settingFormOf(entry('merchant.default_min_order', 'money', null))).toEqual({
      kind: 'text',
      text: '',
    });
  });

  it('types the platform hours per weekday, empty as closed', () => {
    const allDay = Object.fromEntries(
      ['saturday', 'sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday'].map((day) => [
        day,
        [{ open: '00:00', close: '24:00' }],
      ]),
    );
    const hours = entry('platform.hours', 'schedule', allDay);
    const form = settingFormOf(hours);
    if (form.kind !== 'week') throw new Error('not a week');
    expect(form.days.friday).toBe('00:00-24:00');
    const changed = {
      ...form,
      days: { ...form.days, friday: '', saturday: '09:00-13:00، 16:00-23:00' },
    };
    expect(settingValueOf(hours, changed, null)).toMatchObject({
      friday: [],
      saturday: [
        { open: '09:00', close: '13:00' },
        { open: '16:00', close: '23:00' },
      ],
    });
    expect(
      settingValueOf(hours, { ...form, days: { ...form.days, monday: 'كل اليوم' } }, null),
    ).toBeNull();
  });
});
