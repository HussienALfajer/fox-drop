import { useMutation, useQueryClient } from '@tanstack/react-query';
import { api } from './api.js';
import {
  type SettingEntry,
  type SettingForm,
  settingFormOf,
  settingValueOf,
} from './city-settings.js';
import { decimalOf, minorOf } from './format.js';

// AP §9.14 «الإعدادات» (slice 2.38a, OWN): every Appendix A setting on its
// group screen, read and changed through the settings routes, which give
// each role only the settings its edit roles hold.
export type SettingGroup = SettingEntry['group'];

// The group screens in AP §9.14's order; «التطبيقات» has its own page (2.4a).
export const settingGroups = [
  'timers_limits',
  'dispatch',
  'customers',
  'captains',
  'restaurants',
  'support',
  'finance',
  'security',
  'apps',
] as const satisfies readonly SettingGroup[];

export function isSettingGroup(value: unknown): value is SettingGroup {
  return settingGroups.some((group) => group === value);
}

// The settings of a group as the screen lists them: the server's order,
// without the `currency.<code>.*` templates it lists for adding a currency
// (each currency of the city is listed by its concrete key).
export function groupEntries(settings: SettingEntry[], group: SettingGroup): SettingEntry[] {
  return settings.filter(
    (entry) => entry.group === group && !(entry.parameter === null && entry.template.includes('<')),
  );
}

// A setting without a value until entered, whose empty field is "none":
// `push.daily_limit` and `customer.fake_order_dues_fixed` (Appendix A «—»).
export function isNullable(entry: SettingEntry): boolean {
  return entry.default === null && !entry.beforeLaunch;
}

const JITTER = 'otp.send_jitter_sec';
const LATE = 'order.late_compensation_value';
const ROUNDING = 'currency.<code>.rounding_unit';
const CHANNELS = 'otp.channel_order';
const WARMUP = 'otp.sender_warmup_caps';
// «كامل» in the warm-up caps, typed as the word or as the server's code.
const FULL_WORDS = ['كامل', 'full'];

// A setting as its field edits it: the city settings' forms, plus a list of
// numbers, a range, the late code's value and a setting with one choice.
export type GeneralForm =
  | SettingForm
  | { kind: 'list'; text: string }
  | { kind: 'range'; min: string; max: string }
  | { kind: 'late'; mode: 'amount' | 'percent'; text: string }
  | { kind: 'fixed' };

type Late =
  { kind: 'amount'; amountMinor: number; currency: string } | { kind: 'percent'; percent: number };

export function generalFormOf(entry: SettingEntry, fullWord: string): GeneralForm {
  const value = entry.value as unknown;
  if (entry.template === CHANNELS) return { kind: 'fixed' };
  if (entry.template === JITTER) {
    const range = value as { min: number; max: number };
    return { kind: 'range', min: String(range.min), max: String(range.max) };
  }
  if (entry.template === LATE) {
    const late = value as Late | null;
    if (late?.kind === 'percent')
      return { kind: 'late', mode: 'percent', text: String(late.percent) };
    return {
      kind: 'late',
      mode: 'amount',
      text: late ? decimalOf(String(late.amountMinor), late.currency) : '',
    };
  }
  if (entry.template === ROUNDING) {
    const unit = value as { amountMinor: number } | null;
    return {
      kind: 'text',
      text: unit && entry.parameter ? decimalOf(String(unit.amountMinor), entry.parameter) : '',
    };
  }
  if (Array.isArray(entry.default)) {
    const list = (value ?? []) as (number | string)[];
    return {
      kind: 'list',
      text: list.map((each) => (each === 'full' ? fullWord : String(each))).join(', '),
    };
  }
  if (entry.type === 'text') return { kind: 'text', text: typeof value === 'string' ? value : '' };
  // Zero needs no currency (`captain.remit_tolerance` by default).
  const money = value as { amountMinor?: unknown; currency?: unknown } | null;
  if (entry.type === 'money' && money?.amountMinor === 0 && money.currency === null) {
    return { kind: 'text', text: '0' };
  }
  return settingFormOf(entry);
}

const whole = /^\d{1,6}$/;

// The value to save from the field, `undefined` when it is not one of the
// setting's shapes (the server checks the rest, its limits); null is "none"
// for a nullable setting. Money is in the city's base currency, a rounding
// unit in its own currency.
export function generalValueOf(
  entry: SettingEntry,
  form: GeneralForm,
  baseCurrency: string | null,
): unknown {
  if (form.kind === 'fixed') return undefined;
  if (form.kind === 'range') {
    if (!whole.test(form.min.trim()) || !whole.test(form.max.trim())) return undefined;
    const [min, max] = [Number(form.min.trim()), Number(form.max.trim())];
    return min <= max ? { min, max } : undefined;
  }
  if (form.kind === 'late') {
    const text = form.text.trim();
    if (form.mode === 'percent') {
      return /^\d{1,3}(\.\d{1,2})?$/.test(text)
        ? { kind: 'percent', percent: Number(text) }
        : undefined;
    }
    if (baseCurrency === null) return undefined;
    const minor = minorOf(text, baseCurrency);
    return minor === null || minor === '0'
      ? undefined
      : { kind: 'amount', amountMinor: Number(minor), currency: baseCurrency };
  }
  if (form.kind === 'list') {
    const parts = form.text
      .split(/[,،]/)
      .map((part) => part.trim())
      .filter((part) => part !== '');
    if (parts.length === 0) return undefined;
    const values: (number | 'full')[] = [];
    for (const part of parts) {
      if (entry.template === WARMUP && FULL_WORDS.includes(part)) values.push('full');
      else if (whole.test(part)) values.push(Number(part));
      else return undefined;
    }
    return values;
  }
  if (form.kind === 'text' && form.text.trim() === '' && isNullable(entry)) return null;
  if (entry.template === ROUNDING && form.kind === 'text') {
    if (entry.parameter === null) return undefined;
    const minor = minorOf(form.text, entry.parameter);
    return minor === null || minor === '0' ? undefined : { amountMinor: Number(minor) };
  }
  if (entry.type === 'text' && form.kind === 'text') {
    const text = form.text.trim();
    return text === '' ? undefined : text;
  }
  return settingValueOf(entry, form as SettingForm, baseCurrency) ?? undefined;
}

export type SettingCommandRefusal =
  'invalid_value' | 'reason_required' | 'wrong_currency' | 'forbidden' | 'no_default';

export type SettingCommandResult =
  { status: 'saved' | 'restored' } | { status: 'refused'; refusal: SettingCommandRefusal };

function refusalOf(status: number, error: unknown): SettingCommandRefusal | null {
  if (status === 403) return 'forbidden';
  if (status !== 400) return null;
  const code = (error as { error?: string } | undefined)?.error;
  return code === 'reason_required' || code === 'wrong_currency' || code === 'no_default'
    ? code
    : 'invalid_value';
}

// Saves («حفظ») or resets («استعادة الافتراضي») one setting, in effect at
// once: a city setting for the city, a global one for every city. Both set
// a value, so no key. The city's settings are read again after.
export function useSettingCommand(cityId: string) {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: async (
      command:
        | { kind: 'save'; entry: SettingEntry; value: unknown; reason: string }
        | { kind: 'reset'; entry: SettingEntry; reason: string },
    ): Promise<SettingCommandResult> => {
      const reason = command.reason.trim() === '' ? null : command.reason.trim();
      const scopeCity = command.entry.scope === 'city' ? cityId : null;
      const params = { path: { key: command.entry.key } };
      try {
        const { error, response } =
          command.kind === 'save'
            ? await api.PUT('/v1/admin/settings/{key}', {
                params,
                body: { cityId: scopeCity, value: command.value, reason },
              })
            : await api.POST('/v1/admin/settings/{key}/reset', {
                params,
                body: { cityId: scopeCity, reason },
              });
        const status: number = response.status;
        const refusal = refusalOf(status, error);
        if (refusal !== null) return { status: 'refused', refusal };
        if (error !== undefined) throw new Error(`setting failed with ${status}`);
        return { status: command.kind === 'save' ? 'saved' : 'restored' };
      } finally {
        await queryClient.invalidateQueries({ queryKey: ['city-settings', cityId] });
        // The top bar's dispatch mode (AP §7.2) reads apart from the list;
        // the answer never waits for it.
        void queryClient.invalidateQueries({ queryKey: ['dispatch-mode', cityId] });
      }
    },
  });
}
