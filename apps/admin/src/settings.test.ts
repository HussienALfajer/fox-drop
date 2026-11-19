import { describe, expect, it, vi } from 'vitest';
import type { SettingEntry } from './city-settings.js';

vi.mock('./api.js', () => ({ api: {} }));

const { generalFormOf, generalValueOf, groupEntries, isNullable, isSettingGroup } =
  await import('./settings.js');

function entry(fields: Partial<SettingEntry> & { key: string; type: string }): SettingEntry {
  return {
    template: fields.key,
    parameter: null,
    group: 'timers_limits',
    unit: null,
    scope: 'city',
    cityId: 'c',
    editRoles: ['OWN'],
    reasonRequired: false,
    beforeLaunch: false,
    default: null,
    value: null,
    isDefault: true,
    ...fields,
  } as SettingEntry;
}

// AP §9.14 «الإعدادات» (slice 2.38a): each Appendix A shape as its field edits
// it and the value saved.
describe('groupEntries', () => {
  it('lists a group, each currency by its key and not the template', () => {
    const settings = [
      entry({ key: 'fx.stale_alert_hours', type: 'duration', group: 'finance' }),
      entry({
        key: 'currency.<code>.rounding_mode',
        type: 'enum',
        group: 'finance',
      }),
      entry({
        key: 'currency.TRY.rounding_mode',
        template: 'currency.<code>.rounding_mode',
        parameter: 'TRY',
        type: 'enum',
        group: 'finance',
      }),
      entry({ key: 'order.eta_buffer_min', type: 'duration' }),
    ];
    expect(groupEntries(settings, 'finance').map((each) => each.key)).toEqual([
      'fx.stale_alert_hours',
      'currency.TRY.rounding_mode',
    ]);
  });

  it('knows the groups', () => {
    expect(isSettingGroup('security')).toBe(true);
    expect(isSettingGroup('billing')).toBe(false);
  });
});

describe('generalFormOf and generalValueOf', () => {
  it('edits a list of minutes and the warm-up caps with «كامل»', () => {
    const options = entry({
      key: 'merchant.prep_time_options',
      type: 'duration',
      default: [10, 15],
      value: [10, 15, 20],
    });
    expect(generalFormOf(options, 'كامل')).toEqual({ kind: 'list', text: '10, 15, 20' });
    expect(generalValueOf(options, { kind: 'list', text: '10، 25 ,30' }, null)).toEqual([
      10, 25, 30,
    ]);
    expect(generalValueOf(options, { kind: 'list', text: '10, كامل' }, null)).toBeUndefined();
    expect(generalValueOf(options, { kind: 'list', text: ' ' }, null)).toBeUndefined();

    const caps = entry({
      key: 'otp.sender_warmup_caps',
      type: 'count',
      default: [50, 'full'],
      value: [50, 'full'],
    });
    expect(generalFormOf(caps, 'كامل')).toEqual({ kind: 'list', text: '50, كامل' });
    expect(generalValueOf(caps, { kind: 'list', text: '40, 80, كامل' }, null)).toEqual([
      40,
      80,
      'full',
    ]);
  });

  it('edits the jitter as a range', () => {
    const jitter = entry({
      key: 'otp.send_jitter_sec',
      type: 'duration',
      default: { min: 1, max: 4 },
      value: { min: 1, max: 4 },
    });
    expect(generalFormOf(jitter, 'كامل')).toEqual({ kind: 'range', min: '1', max: '4' });
    expect(generalValueOf(jitter, { kind: 'range', min: '2', max: '6' }, null)).toEqual({
      min: 2,
      max: 6,
    });
    expect(generalValueOf(jitter, { kind: 'range', min: '6', max: '2' }, null)).toBeUndefined();
  });

  it('edits the late code as an amount in the base currency or a percentage', () => {
    const late = entry({
      key: 'order.late_compensation_value',
      type: 'money',
      beforeLaunch: true,
    });
    expect(generalFormOf(late, 'كامل')).toEqual({ kind: 'late', mode: 'amount', text: '' });
    expect(generalValueOf(late, { kind: 'late', mode: 'amount', text: '25' }, 'TRY')).toEqual({
      kind: 'amount',
      amountMinor: 2500,
      currency: 'TRY',
    });
    expect(
      generalValueOf(late, { kind: 'late', mode: 'amount', text: '25' }, null),
    ).toBeUndefined();
    expect(generalValueOf(late, { kind: 'late', mode: 'percent', text: '10' }, 'TRY')).toEqual({
      kind: 'percent',
      percent: 10,
    });
    expect(generalFormOf({ ...late, value: { kind: 'percent', percent: 15 } }, 'كامل')).toEqual({
      kind: 'late',
      mode: 'percent',
      text: '15',
    });
  });

  it('edits a rounding unit in its own currency', () => {
    const unit = entry({
      key: 'currency.USD.rounding_unit',
      template: 'currency.<code>.rounding_unit',
      parameter: 'USD',
      type: 'money',
      beforeLaunch: true,
      value: { amountMinor: 50 },
    });
    expect(generalFormOf(unit, 'كامل')).toEqual({ kind: 'text', text: '0.50' });
    expect(generalValueOf(unit, { kind: 'text', text: '1' }, 'TRY')).toEqual({ amountMinor: 100 });
    expect(generalValueOf(unit, { kind: 'text', text: '0' }, 'TRY')).toBeUndefined();
  });

  it('leaves a nullable setting empty as none, and a text as typed', () => {
    const limit = entry({ key: 'push.daily_limit', type: 'count' });
    expect(isNullable(limit)).toBe(true);
    expect(generalValueOf(limit, { kind: 'text', text: '' }, null)).toBeNull();
    expect(generalValueOf(limit, { kind: 'text', text: '3' }, null)).toBe(3);
    const deposit = entry({ key: 'captain.kit_deposit_amount', type: 'money', beforeLaunch: true });
    expect(isNullable(deposit)).toBe(false);
    expect(generalValueOf(deposit, { kind: 'text', text: '' }, 'TRY')).toBeUndefined();

    const message = entry({
      key: 'platform.emergency_default_message_browse',
      type: 'text',
      default: 'نعتذر',
      value: 'نعتذر',
    });
    expect(generalFormOf(message, 'كامل')).toEqual({ kind: 'text', text: 'نعتذر' });
    expect(generalValueOf(message, { kind: 'text', text: ' نعود قريباً ' }, null)).toBe(
      'نعود قريباً',
    );
    expect(generalValueOf(message, { kind: 'text', text: '' }, null)).toBeUndefined();
  });

  it('offers no field for the one sign-in channel', () => {
    const channels = entry({
      key: 'otp.channel_order',
      type: 'enum',
      default: ['whatsapp'],
      value: ['whatsapp'],
    });
    expect(generalFormOf(channels, 'كامل')).toEqual({ kind: 'fixed' });
    expect(generalValueOf(channels, { kind: 'fixed' }, null)).toBeUndefined();
  });

  it('keeps the city settings’ shapes: a flag, a number, a choice', () => {
    const check = entry({
      key: 'dispatch.capacity_check',
      type: 'boolean',
      default: true,
      value: true,
    });
    expect(generalValueOf(check, { kind: 'flag', on: false }, null)).toBe(false);
    const buffer = entry({ key: 'order.eta_buffer_min', type: 'duration', default: 10, value: 10 });
    expect(generalFormOf(buffer, 'كامل')).toEqual({ kind: 'text', text: '10' });
    expect(generalValueOf(buffer, { kind: 'text', text: '12' }, null)).toBe(12);
    expect(generalValueOf(buffer, { kind: 'text', text: 'ten' }, null)).toBeUndefined();
    const country = entry({
      key: 'customer.phone_default_country',
      type: 'enum',
      beforeLaunch: true,
    });
    expect(generalValueOf(country, { kind: 'text', text: 'SY' }, null)).toBe('SY');
    expect(generalValueOf(country, { kind: 'text', text: '' }, null)).toBeUndefined();
  });
});
