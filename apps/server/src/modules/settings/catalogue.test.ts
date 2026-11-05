import { readFileSync } from 'node:fs';
import { describe, expect, it } from 'vitest';
import { catalogue, type SettingDefinition, type SettingKey, settingGroupOf } from './catalogue.js';

// AP Appendix A is the source of truth: every key in its table is in the
// catalogue with the same scope and edit roles, and nothing else is.
const appendix = readFileSync(
  new URL(
    '../../../../../docs/product/v1/admin-panel/appendix-a-settings-catalogue.md',
    import.meta.url,
  ),
  'utf8',
);

interface AppendixRow {
  key: string;
  default: string;
  scope: 'global' | 'city';
  editRoles: string[];
}

const rows: AppendixRow[] = appendix
  .split('\n')
  .filter((line) => line.startsWith('| `'))
  .map((line) => {
    const cells = line
      .replaceAll('\\|', '/')
      .split('|')
      .map((cell) => cell.trim());
    return {
      key: cells[1]!.replaceAll('`', '').replace('<customer/merchant/captain>', '<app>'),
      default: cells[2]!,
      scope: cells[3] === 'G' ? 'global' : 'city',
      editRoles: cells[4]!.split(',').map((role) => role.trim()),
    };
  });

const allDay = catalogue['platform.hours'].default;
const entries = Object.entries(catalogue) as [string, SettingDefinition][];

describe('the settings catalogue', () => {
  it('has every key of Appendix A and no other', () => {
    expect(rows.length).toBeGreaterThan(100);
    expect(Object.keys(catalogue)).toEqual(rows.map((row) => row.key));
  });

  it.each(rows)('gives $key the scope and edit roles of Appendix A', (row) => {
    const definition: SettingDefinition = catalogue[row.key as keyof typeof catalogue];
    expect(definition.scope).toBe(row.scope);
    expect(definition.editRoles).toEqual(row.editRoles);
  });

  it('has the defaults of Appendix A', () => {
    // The defaults written as one plain value or a list; the rest (24/7, 1–4,
    // a list ending in full) are checked by hand.
    const plain = (value: unknown): string | null => {
      if (typeof value === 'string' || typeof value === 'number' || typeof value === 'boolean') {
        return String(value);
      }
      if (Array.isArray(value)) return value.join(', ');
      if (value !== null && typeof value === 'object' && 'amountMinor' in value) {
        return String(value.amountMinor);
      }
      return null;
    };
    const compared = rows.filter((row) => {
      const value = plain(catalogue[row.key as keyof typeof catalogue].default);
      if (value === null) return false;
      expect(value.toLowerCase(), row.key).toBe(
        row.default.replace(/^«(.*)»$/, '$1').toLowerCase(),
      );
      return true;
    });
    expect(compared.length).toBeGreaterThan(90);
  });

  it('leaves the values marked "Before launch" without a default', () => {
    const marked = rows.filter((row) => row.default === 'Before launch').map((row) => row.key);
    const beforeLaunch = entries
      .filter(([, definition]) => definition.beforeLaunch)
      .map(([key]) => key);
    expect(beforeLaunch).toEqual(marked);
  });

  it.each(entries.filter(([, definition]) => !definition.beforeLaunch))(
    'parses the default of %s with its own schema',
    (_, definition) => {
      expect(definition.schema.parse(definition.default)).toEqual(definition.default);
    },
  );

  it('asks a reason for the settings with money impact (owner, 2026-11-05)', () => {
    expect(
      entries.filter(([, definition]) => definition.reasonRequired).map(([key]) => key),
    ).toEqual([
      'order.late_compensation_value',
      'merchant.default_commission_pct',
      'merchant.default_min_order',
      'captain.custody_limit_suggested.<vehicle>',
      'captain.remit_tolerance',
      'captain.negative_earnings_policy',
      'customer.fake_order_dues_rule',
      'customer.fake_order_dues_fixed',
      'support.compensation_cap_pct.SUP',
      'support.compensation_cap_pct.OPS',
      'currency.<code>.rounding_unit',
      'currency.<code>.rounding_mode',
    ]);
  });

  it.each([
    [
      'a non-zero amount without its currency',
      'captain.remit_tolerance',
      { amountMinor: 500, currency: null },
    ],
    [
      'a money amount in a float',
      'merchant.default_min_order',
      { amountMinor: 2.5, currency: 'TRY' },
    ],
    ['a duration below its floor', 'merchant.prep_time_step_min', 0],
    ['a percentage above 100', 'merchant.default_commission_pct', 101],
    ['an unknown enum value', 'dispatch.mode', 'random'],
    ['a channel not offered in V1', 'otp.channel_order', ['sms']],
    ['a jitter range upside down', 'otp.send_jitter_sec', { min: 5, max: 2 }],
    ['a time of day out of range', 'finance.business_day_cutoff', '25:00'],
    ['a schedule missing a weekday', 'platform.hours', { saturday: [] }],
    ['a malformed version', 'app.<app>.min_version', '1.4'],
    [
      'an interval closing before it opens',
      'platform.hours',
      { ...allDay, friday: [{ open: '10:00', close: '09:00' }] },
    ],
    [
      'overlapping intervals',
      'platform.hours',
      {
        ...allDay,
        friday: [
          { open: '08:00', close: '12:00' },
          { open: '11:00', close: '20:00' },
        ],
      },
    ],
  ])('refuses %s', (_, key, value) => {
    const definition: SettingDefinition = catalogue[key as keyof typeof catalogue];
    expect(definition.schema.safeParse(value).success).toBe(false);
  });
});

describe('the group screens (AP §9.14, owner decision 2026-11-05)', () => {
  it('put every key on one group screen, by its prefix', () => {
    const keys = Object.keys(catalogue) as SettingKey[];
    const byGroup = Object.groupBy(keys, (key) => settingGroupOf(key));
    expect(Object.keys(byGroup)).toEqual([
      'timers_limits',
      'restaurants',
      'dispatch',
      'captains',
      'customers',
      'security',
      'support',
      'finance',
      'apps',
    ]);
    expect(byGroup.security).toContain('otp.validity_min');
    expect(byGroup.timers_limits).toContain('platform.hours');
    expect(byGroup.dispatch).toContain('pricing.distance_method');
    expect(byGroup.customers).toContain('push.daily_limit');
    expect(byGroup.finance).toContain('currency.<code>.rounding_mode');
  });
});
