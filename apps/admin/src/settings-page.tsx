import { useQuery } from '@tanstack/react-query';
import { getRouteApi, Link } from '@tanstack/react-router';
import { type FormEvent, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { type City, chosenCity, citiesQuery } from './cities.js';
import { baseOf, useCityProfile } from './city-profile.js';
import { type SettingEntry, useCitySettings, weekdays } from './city-settings.js';
import { decimalOf } from './format.js';
import {
  type GeneralForm,
  type SettingCommandResult,
  generalFormOf,
  generalValueOf,
  groupEntries,
  isNullable,
  type SettingGroup,
  settingGroups,
  useSettingCommand,
} from './settings.js';

const route = getRouteApi('/signed-in/settings');

// AP §9.14 «الإعدادات» (slice 2.38a, OWN): the group screens, each setting
// with its Arabic name and description, default, value in force, unit, its
// field and «استعادة الافتراضي»; a reason where the setting has money impact.
// Every change applies at once and is audited. Unstyled until the design.
export function SettingsPage() {
  const { t } = useTranslation();
  const search = route.useSearch();
  const cities = useQuery(citiesQuery);
  const city = cities.data ? chosenCity(cities.data, search.city) : undefined;
  const settings = useCitySettings(city?.id);
  const group = search.group;
  return (
    <main>
      <h1>{t('settings.title')}</h1>
      <p>
        <Link to="/">{t('common.home')}</Link>
      </p>
      <p>{t('settings.explain')}</p>
      <nav aria-label={t('settings.groups')}>
        <ul>
          {settingGroups.map((each) => (
            <li key={each}>
              {each === 'apps' ? (
                <Link to="/settings/apps">{t('settings.group.apps')}</Link>
              ) : (
                <Link
                  to="/settings"
                  search={{ ...search, group: each }}
                  aria-current={each === group ? 'page' : undefined}
                >
                  {t(`settings.group.${each}`)}
                </Link>
              )}
            </li>
          ))}
        </ul>
      </nav>
      <h2>{t(`settings.group.${group}`)}</h2>
      <GroupLinks group={group} />
      {settings.isError || cities.isError ? (
        <p role="alert">{t('common.failed')}</p>
      ) : !city || !settings.data ? (
        <p role="status">{t('status.loading')}</p>
      ) : (
        <GroupSettings city={city} entries={groupEntries(settings.data, group)} />
      )}
    </main>
  );
}

// The group's own pages: the sending numbers in security, the rates (and
// each currency's rounding) in finance.
function GroupLinks({ group }: { group: SettingGroup }) {
  const { t } = useTranslation();
  if (group === 'security') {
    return (
      <p>
        <Link to="/settings/otp-senders">{t('settings.otpSendersLink')}</Link>
      </p>
    );
  }
  if (group === 'finance') {
    return (
      <p>
        <Link to="/exchange-rates">{t('settings.ratesLink')}</Link>
      </p>
    );
  }
  return null;
}

export function GroupSettings({ city, entries }: { city: City; entries: SettingEntry[] }) {
  const { t } = useTranslation();
  const needsBase = entries.some((entry) => entry.type === 'money');
  const profile = useCityProfile(needsBase ? city.id : undefined);
  // The command and each setting's last answer live above the cards, which
  // start again with the value the save brings, so the answer outlives them.
  const command = useSettingCommand(city.id);
  const [results, setResults] = useState<Partial<Record<string, SettingCommandResult>>>({});
  if (entries.length === 0) return <p>{t('settings.empty')}</p>;
  const base = profile.data ? baseOf(profile.data) : null;
  return (
    <ul>
      {entries.map((entry) => (
        <li key={entry.key}>
          <SettingCard
            key={JSON.stringify(entry.value)}
            city={city}
            entry={entry}
            baseCurrency={base}
            command={command}
            result={results[entry.key]}
            onResult={(result) => setResults((before) => ({ ...before, [entry.key]: result }))}
          />
        </li>
      ))}
    </ul>
  );
}

function SettingCard({
  city,
  entry,
  baseCurrency,
  command,
  result,
  onResult,
}: {
  city: City;
  entry: SettingEntry;
  baseCurrency: string | null;
  command: ReturnType<typeof useSettingCommand>;
  result: SettingCommandResult | undefined;
  onResult: (result: SettingCommandResult) => void;
}) {
  const { t } = useTranslation();
  const [form, setForm] = useState<GeneralForm>(() => generalFormOf(entry, t('settings.fullWord')));
  const [reason, setReason] = useState('');
  const [problem, setProblem] = useState(false);
  const { descriptionOf, nameOf, valueWords } = useSettingWords();
  const name = nameOf(entry);
  const save = (event: FormEvent) => {
    event.preventDefault();
    const value = generalValueOf(entry, form, baseCurrency);
    setProblem(value === undefined);
    if (value !== undefined) {
      command.mutate({ kind: 'save', entry, value, reason }, { onSuccess: onResult });
    }
  };
  const canReset = !entry.isDefault && !entry.beforeLaunch;
  return (
    <form onSubmit={save} aria-label={name}>
      <h3>{name}</h3>
      <p>{descriptionOf(entry)}</p>
      <p>
        {entry.scope === 'city'
          ? t('settings.scopeCity', { city: city.name })
          : t('settings.scopeGlobal')}
      </p>
      <p>
        {t('settings.current', { value: valueWords(entry, entry.value) })}
        {entry.isDefault && ` ${t('settings.isDefault')}`}
      </p>
      <p>
        {entry.beforeLaunch
          ? t('settings.beforeLaunch')
          : t('settings.default', { value: valueWords(entry, entry.default) })}
      </p>
      <SettingField entry={entry} form={form} baseCurrency={baseCurrency} onChange={setForm} />
      {(entry.type === 'money' || entry.template === 'order.late_compensation_value') &&
        baseCurrency === null && <p>{t('settings.noBase')}</p>}
      {entry.reasonRequired && (
        <label>
          {t('settings.reason')}
          <input
            value={reason}
            maxLength={500}
            aria-description={t('settings.reasonHint')}
            onChange={(event) => setReason(event.target.value)}
          />
        </label>
      )}
      {form.kind !== 'fixed' && (
        <button type="submit" disabled={command.isPending}>
          {t('settings.save')}
        </button>
      )}
      {canReset && (
        <button
          type="button"
          disabled={command.isPending}
          onClick={() => command.mutate({ kind: 'reset', entry, reason }, { onSuccess: onResult })}
        >
          {t('settings.reset')}
        </button>
      )}
      {problem && <p role="alert">{t('settings.problem')}</p>}
      {result?.status === 'saved' && <p role="status">{t('settings.saved')}</p>}
      {result?.status === 'restored' && <p role="status">{t('settings.restored')}</p>}
      {result?.status === 'refused' && (
        <p role="alert">{t(`settings.refused.${result.refusal}`)}</p>
      )}
      {command.isError && command.variables?.entry.key === entry.key && (
        <p role="alert">{t('common.failed')}</p>
      )}
    </form>
  );
}

function SettingField({
  entry,
  form,
  baseCurrency,
  onChange,
}: {
  entry: SettingEntry;
  form: GeneralForm;
  baseCurrency: string | null;
  onChange: (form: GeneralForm) => void;
}) {
  const { t } = useTranslation();
  const { choicesOf, unitWords } = useSettingWords();
  // An amount names its currency: a rounding unit its own, the rest the base.
  const currency =
    entry.type !== 'money'
      ? null
      : entry.template.startsWith('currency.')
        ? entry.parameter
        : baseCurrency;
  const unit = currency ?? unitWords(entry);
  const valueLabel = unit === null ? t('settings.value') : t('settings.valueIn', { unit });
  switch (form.kind) {
    case 'fixed':
      return <p>{t('settings.readOnly')}</p>;
    case 'flag':
      return (
        <label>
          <input
            type="checkbox"
            checked={form.on}
            onChange={(event) => onChange({ kind: 'flag', on: event.target.checked })}
          />
          {t('settings.on')}
        </label>
      );
    case 'week':
      return (
        <fieldset>
          <legend>{t('citySettings.hoursExplain')}</legend>
          {weekdays.map((day) => (
            <label key={day}>
              {t(`settings.choice.weekday.${day}`)}
              <input
                value={form.days[day]}
                dir="ltr"
                onChange={(event) =>
                  onChange({ kind: 'week', days: { ...form.days, [day]: event.target.value } })
                }
              />
            </label>
          ))}
        </fieldset>
      );
    case 'range':
      return (
        <fieldset>
          <legend>{valueLabel}</legend>
          <label>
            {t('settings.rangeMin')}
            <input
              value={form.min}
              dir="ltr"
              inputMode="numeric"
              onChange={(event) => onChange({ ...form, min: event.target.value })}
            />
          </label>
          <label>
            {t('settings.rangeMax')}
            <input
              value={form.max}
              dir="ltr"
              inputMode="numeric"
              onChange={(event) => onChange({ ...form, max: event.target.value })}
            />
          </label>
        </fieldset>
      );
    case 'late':
      return (
        <fieldset>
          <legend>{t('settings.lateKind')}</legend>
          <label>
            <input
              type="radio"
              checked={form.mode === 'amount'}
              onChange={() => onChange({ ...form, mode: 'amount' })}
            />
            {t('settings.lateAmount')}
          </label>
          <label>
            <input
              type="radio"
              checked={form.mode === 'percent'}
              onChange={() => onChange({ ...form, mode: 'percent' })}
            />
            {t('settings.latePercent')}
          </label>
          <label>
            {form.mode === 'percent'
              ? t('settings.valueIn', { unit: t('settings.unit.percent') })
              : valueLabel}
            <input
              value={form.text}
              dir="ltr"
              inputMode="decimal"
              onChange={(event) => onChange({ ...form, text: event.target.value })}
            />
          </label>
        </fieldset>
      );
    case 'list':
      return (
        <label>
          {valueLabel}
          <input
            value={form.text}
            dir="ltr"
            aria-description={t('settings.listHint')}
            onChange={(event) => onChange({ kind: 'list', text: event.target.value })}
          />
        </label>
      );
    case 'text': {
      const choices = choicesOf(entry);
      if (choices !== null) {
        return (
          <label>
            {valueLabel}
            <select
              value={form.text}
              onChange={(event) => onChange({ kind: 'text', text: event.target.value })}
            >
              {form.text === '' && <option value="">{t('settings.unset')}</option>}
              {Object.entries(choices).map(([value, words]) => (
                <option key={value} value={value}>
                  {words}
                </option>
              ))}
            </select>
          </label>
        );
      }
      if (entry.type === 'text') {
        return (
          <label>
            {valueLabel}
            <textarea
              value={form.text}
              maxLength={500}
              onChange={(event) => onChange({ kind: 'text', text: event.target.value })}
            />
          </label>
        );
      }
      return (
        <label>
          {valueLabel}
          <input
            value={form.text}
            dir="ltr"
            inputMode={entry.type === 'time_of_day' ? 'text' : 'decimal'}
            onChange={(event) => onChange({ kind: 'text', text: event.target.value })}
          />
        </label>
      );
    }
  }
}

// The words of the settings: names, choices, units and values, from the
// translations by the server's codes (panel-labels.test.ts on the server
// checks that every setting and choice has its words).
function useSettingWords() {
  const { t } = useTranslation();
  const words = (key: string, options?: object): unknown =>
    (t as unknown as (key: string, options?: object) => unknown)(key, options);

  // The words of an enum setting's choices, by value; the two settlement days
  // share the weekdays'.
  function choicesOf(entry: SettingEntry): Record<string, string> | null {
    if (entry.type !== 'enum') return null;
    const table = words(
      entry.template.endsWith('_weekday')
        ? 'settings.choice.weekday'
        : `settings.choice.${entry.template}`,
      { returnObjects: true },
    );
    return typeof table === 'object' && table !== null ? (table as Record<string, string>) : null;
  }

  // A setting's name, with its vehicle (a currency's code shows as it is).
  function nameOf(entry: SettingEntry): string {
    const name = String(words(`settings.name.${entry.template}`));
    if (entry.parameter === null) return name;
    const parameter = entry.template.includes('<vehicle>')
      ? String(words(`settings.vehicle.${entry.parameter}`))
      : entry.parameter;
    return String(words('settings.nameWithParameter', { name, parameter }));
  }

  function unitWords(entry: SettingEntry): string | null {
    if (entry.type === 'percentage') return t('settings.unit.percent');
    if (entry.unit === null) return null;
    return String(words(`settings.unit.${entry.unit}`));
  }

  // A value in words: the value in force or the default.
  function valueWords(entry: SettingEntry, value: unknown): string {
    if (value === null || value === undefined) {
      return isNullable(entry) ? t('settings.none') : t('settings.unset');
    }
    const unit = unitWords(entry);
    const withUnit = (text: string) =>
      unit === null
        ? text
        : entry.type === 'percentage'
          ? t('settings.percentValue', { value: text })
          : t('settings.withUnit', { value: text, unit });
    if (typeof value === 'boolean') return t(value ? 'settings.on' : 'settings.off');
    if (entry.type === 'schedule') {
      const schedule = value as Record<string, { open: string; close: string }[] | undefined>;
      return weekdays
        .map((day) =>
          t('settings.dayPeriods', {
            day: t(`settings.choice.weekday.${day}`),
            periods:
              (schedule[day] ?? []).map((period) => `${period.open}-${period.close}`).join(', ') ||
              t('settings.closed'),
          }),
        )
        .join('، ');
    }
    if (entry.type === 'enum') {
      const choices = choicesOf(entry) ?? {};
      const values = Array.isArray(value) ? (value as string[]) : [String(value)];
      return values.map((each) => choices[each] ?? each).join('، ');
    }
    if (Array.isArray(value)) {
      return withUnit(
        (value as (number | string)[])
          .map((each) => (each === 'full' ? t('settings.fullWord') : String(each)))
          .join('، '),
      );
    }
    if (typeof value === 'object') {
      const shape = value as Record<string, unknown>;
      if ('min' in shape && 'max' in shape) {
        return withUnit(t('settings.rangeValue', { min: shape.min, max: shape.max }));
      }
      if (shape.kind === 'percent') return t('settings.percentValue', { value: shape.percent });
      if (typeof shape.amountMinor === 'number') {
        const currency =
          typeof shape.currency === 'string'
            ? shape.currency
            : entry.template.startsWith('currency.')
              ? entry.parameter
              : null;
        if (currency === null) return String(shape.amountMinor);
        return `${decimalOf(String(shape.amountMinor), currency)} ${currency}`;
      }
      return JSON.stringify(value);
    }
    return withUnit(String(value));
  }

  const descriptionOf = (entry: SettingEntry) =>
    String(words(`settings.description.${entry.template}`));
  return { choicesOf, descriptionOf, nameOf, unitWords, valueWords };
}
