import { useQuery } from '@tanstack/react-query';
import { getRouteApi, Link } from '@tanstack/react-router';
import { type FormEvent, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { type City, chosenCity, citiesQuery } from './cities.js';
import { baseOf, useCityProfile } from './city-profile.js';
import {
  type CitySettingKey,
  DEFAULT_KEYS,
  DISPATCH_KEYS,
  entriesOf,
  type SettingEntry,
  type SettingForm,
  settingFormOf,
  type SettingRefusal,
  settingValueOf,
  useCitySettings,
  useSaveCitySetting,
  type Weekday,
  weekdays,
} from './city-settings.js';
import { decimalOf } from './format.js';

const labelKeys = {
  'merchant.default_commission_pct': 'citySettings.label.defaultCommission',
  'merchant.default_min_order': 'citySettings.label.defaultMinOrder',
  'merchant.default_prep_min': 'citySettings.label.defaultPrep',
  'captain.custody_limit_suggested.motorbike': 'citySettings.label.custodyMotorbike',
  'captain.custody_limit_suggested.car': 'citySettings.label.custodyCar',
  'captain.custody_limit_suggested.bicycle': 'citySettings.label.custodyBicycle',
  'captain.custody_limit_suggested.walking': 'citySettings.label.custodyWalking',
  'dispatch.mode': 'citySettings.label.mode',
  'dispatch.max_offers_before_manual': 'citySettings.label.maxOffers',
  'dispatch.search_radius_km': 'citySettings.label.searchRadius',
  'dispatch.ranking': 'citySettings.label.ranking',
  'dispatch.offer_timeout_sec': 'citySettings.label.offerTimeout',
  'captain.offer_expiry_offline_count': 'citySettings.label.expiredOffline',
  'captain.remit_online_grace_hours': 'citySettings.label.remitGrace',
  'dispatch.search_start_buffer_min': 'citySettings.label.searchBuffer',
  'dispatch.capacity_check': 'citySettings.label.capacityCheck',
  'finance.business_day_cutoff': 'citySettings.label.cutoff',
  'platform.hours': 'citySettings.label.platformHours',
} as const satisfies Record<CitySettingKey, string>;

// The words of each enum value; a value the panel does not know is not
// offered.
const enumKeys = {
  'dispatch.mode': {
    manual: 'citySettings.mode.manual',
    auto: 'citySettings.mode.auto',
    mixed: 'citySettings.mode.mixed',
  },
  'dispatch.ranking': { nearest_then_fewest_today: 'citySettings.ranking.nearest' },
} as const;

function enumOptions(key: CitySettingKey): Record<string, EnumLabel> | undefined {
  return key in enumKeys ? enumKeys[key as keyof typeof enumKeys] : undefined;
}
type EnumLabel = {
  [Key in keyof typeof enumKeys]: (typeof enumKeys)[Key][keyof (typeof enumKeys)[Key]];
}[keyof typeof enumKeys];

const unitKeys = {
  sec: 'citySettings.unit.sec',
  min: 'citySettings.unit.min',
  hours: 'citySettings.unit.hours',
  km: 'citySettings.unit.km',
} as const;

function unitOf(entry: SettingEntry) {
  return entry.unit !== null && entry.unit in unitKeys
    ? unitKeys[entry.unit as keyof typeof unitKeys]
    : null;
}

const dayKeys = {
  saturday: 'citySettings.day.saturday',
  sunday: 'citySettings.day.sunday',
  monday: 'citySettings.day.monday',
  tuesday: 'citySettings.day.tuesday',
  wednesday: 'citySettings.day.wednesday',
  thursday: 'citySettings.day.thursday',
  friday: 'citySettings.day.friday',
} as const satisfies Record<Weekday, string>;

const refusalKeys = {
  invalid_value: 'citySettings.refused.invalid_value',
  reason_required: 'citySettings.refused.reason_required',
  wrong_currency: 'citySettings.refused.wrong_currency',
  forbidden: 'citySettings.refused.forbidden',
} as const satisfies Record<SettingRefusal, string>;

const defaultsRoute = getRouteApi('/signed-in/defaults');
const dispatchRoute = getRouteApi('/signed-in/dispatch-rules');

// AP §9.12.4 «الإعدادات الافتراضية» (slice 2.37c, OWN): the defaults a new
// restaurant or captain starts from. Unstyled until the design.
export function DefaultsPage() {
  const { t } = useTranslation();
  const search = defaultsRoute.useSearch();
  return (
    <SettingsScreen
      title={t('citySettings.defaultsTitle')}
      explain={t('citySettings.defaultsExplain')}
      code={search.city}
      keys={DEFAULT_KEYS}
    />
  );
}

// AP §9.12.6 «قواعد التوزيع» (slice 2.37c): OWN changes every rule; OPS
// sees and switches the mode only (the server lists OPS that setting alone).
export function DispatchRulesPage() {
  const { t } = useTranslation();
  const search = dispatchRoute.useSearch();
  return (
    <SettingsScreen
      title={t('citySettings.dispatchTitle')}
      explain={t('citySettings.dispatchExplain')}
      code={search.city}
      keys={DISPATCH_KEYS}
    >
      <section aria-labelledby="dispatch-eligibility">
        <h2 id="dispatch-eligibility">{t('citySettings.eligibility')}</h2>
        <ul>
          <li>{t('citySettings.rule.online')}</li>
          <li>{t('citySettings.rule.noOrder')}</li>
          <li>{t('citySettings.rule.custody')}</li>
          <li>{t('citySettings.rule.cash')}</li>
          <li>{t('citySettings.rule.radius')}</li>
          <li>{t('citySettings.rule.vehicle')}</li>
          <li>{t('citySettings.rule.pickup')}</li>
        </ul>
      </section>
    </SettingsScreen>
  );
}

function SettingsScreen(props: {
  title: string;
  explain: string;
  code: string | undefined;
  keys: readonly CitySettingKey[];
  children?: React.ReactNode;
}) {
  const { t } = useTranslation();
  const cities = useQuery(citiesQuery);
  const city = cities.data ? chosenCity(cities.data, props.code) : undefined;
  const settings = useCitySettings(city?.id);
  return (
    <main>
      <h1>{props.title}</h1>
      <p>
        <Link to="/">{t('common.home')}</Link>
      </p>
      <p>{props.explain}</p>
      {settings.isError || cities.isError ? (
        <p role="alert">{t('common.failed')}</p>
      ) : !city || !settings.data ? (
        <p role="status">{t('status.loading')}</p>
      ) : (
        <SettingsList city={city} entries={entriesOf(settings.data, props.keys)} />
      )}
      {props.children}
    </main>
  );
}

// The settings a role may change, each with its value and form; money in
// the city's base currency, read with the city (zones.read).
export function SettingsList({
  city,
  entries,
}: {
  city: City;
  entries: (SettingEntry & { key: CitySettingKey })[];
}) {
  const { t } = useTranslation();
  const needsBase = entries.some((entry) => entry.type === 'money');
  const profile = useCityProfile(needsBase ? city.id : undefined);
  if (entries.length === 0) return <p>{t('citySettings.none')}</p>;
  const base = profile.data ? baseOf(profile.data) : null;
  return (
    <ul>
      {entries.map((entry) => (
        <li key={entry.key}>
          <SettingRow cityId={city.id} entry={entry} baseCurrency={base} />
        </li>
      ))}
    </ul>
  );
}

function SettingRow({
  cityId,
  entry,
  baseCurrency,
}: {
  cityId: string;
  entry: SettingEntry & { key: CitySettingKey };
  baseCurrency: string | null;
}) {
  const { t } = useTranslation();
  const save = useSaveCitySetting(cityId);
  const [form, setForm] = useState<SettingForm>(() => settingFormOf(entry));
  const [reason, setReason] = useState('');
  const [problem, setProblem] = useState(false);
  const label = t(labelKeys[entry.key]);
  const value = useValueText(entry);

  const submit = (event: FormEvent) => {
    event.preventDefault();
    const value = settingValueOf(entry, form, baseCurrency);
    if (value === null) {
      setProblem(true);
      return;
    }
    setProblem(false);
    save.mutate({ key: entry.key, value, reason });
  };

  return (
    <form onSubmit={submit} aria-label={label}>
      <p>
        {t('citySettings.current', { label, value })}
        {entry.isDefault && ` ${t('citySettings.isDefault')}`}
      </p>
      <SettingInput entry={entry} form={form} label={label} onChange={setForm} />
      {entry.type === 'money' && baseCurrency === null && <p>{t('citySettings.noBase')}</p>}
      {entry.reasonRequired && (
        <label>
          {t('citySettings.reason')}
          <input
            value={reason}
            maxLength={500}
            onChange={(event) => setReason(event.target.value)}
          />
        </label>
      )}
      <button type="submit" disabled={save.isPending}>
        {t('citySettings.save', { label })}
      </button>
      {problem && <p role="alert">{t('citySettings.problem')}</p>}
      {save.data?.status === 'saved' && <p role="status">{t('citySettings.saved')}</p>}
      {save.data?.status === 'refused' && <p role="alert">{t(refusalKeys[save.data.refusal])}</p>}
      {save.isError && <p role="alert">{t('common.failed')}</p>}
    </form>
  );
}

function SettingInput({
  entry,
  form,
  label,
  onChange,
}: {
  entry: SettingEntry & { key: CitySettingKey };
  form: SettingForm;
  label: string;
  onChange: (form: SettingForm) => void;
}) {
  const { t } = useTranslation();
  const unit = unitOf(entry);
  if (form.kind === 'flag') {
    return (
      <label>
        <input
          type="checkbox"
          checked={form.on}
          onChange={(event) => onChange({ kind: 'flag', on: event.target.checked })}
        />
        {t('citySettings.on')}
      </label>
    );
  }
  if (form.kind === 'week') {
    return (
      <fieldset>
        <legend>{t('citySettings.hoursExplain')}</legend>
        {weekdays.map((day) => (
          <label key={day}>
            {t(dayKeys[day])}
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
  }
  const options = enumOptions(entry.key);
  if (entry.type === 'enum' && options) {
    return (
      <label>
        {label}
        <select
          value={form.text}
          onChange={(event) => onChange({ kind: 'text', text: event.target.value })}
        >
          {Object.entries(options).map(([value, key]) => (
            <option key={value} value={value}>
              {t(key)}
            </option>
          ))}
        </select>
      </label>
    );
  }
  return (
    <label>
      {unit ? t('citySettings.withUnit', { label, unit: t(unit) }) : label}
      <input
        value={form.text}
        dir="ltr"
        inputMode={entry.type === 'time_of_day' ? 'text' : 'decimal'}
        onChange={(event) => onChange({ kind: 'text', text: event.target.value })}
      />
    </label>
  );
}

// The value in force in words.
function useValueText(entry: SettingEntry & { key: CitySettingKey }): string {
  const { t } = useTranslation();
  const value = entry.value as unknown;
  if (value === null || value === undefined) return t('citySettings.unset');
  if (entry.type === 'boolean') return t(value ? 'citySettings.yes' : 'citySettings.no');
  if (entry.type === 'money') {
    const money = value as { amountMinor: number; currency: string | null };
    return money.currency
      ? `${decimalOf(String(money.amountMinor), money.currency)} ${money.currency}`
      : '0';
  }
  if (entry.type === 'schedule') return t('citySettings.scheduleSet');
  if (entry.type === 'enum') {
    const key = enumOptions(entry.key)?.[String(value)];
    return key ? t(key) : t('citySettings.otherValue');
  }
  const unit = unitOf(entry);
  return unit ? `${String(value)} ${t(unit)}` : String(value);
}
