import { useQuery } from '@tanstack/react-query';
import { getRouteApi, Link } from '@tanstack/react-router';
import { type FormEvent, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { chosenCity } from './cities.js';
import {
  allCitiesQuery,
  type CityForm,
  cityFormOf,
  type CityProblem,
  type CityProfile,
  type CityRefusal,
  cityRequestOf,
  nextDisplayOrder,
  useCityCommand,
  useCityProfile,
} from './city-profile.js';
import { SettingsList } from './city-settings-page.js';
import { CITY_KEYS, entriesOf, useCitySettings } from './city-settings.js';
import { ZONES_MANAGE } from './office.js';
import { can } from './session.js';

const route = getRouteApi('/signed-in/cities');
const signedIn = getRouteApi('/signed-in');

const problemKeys = {
  name: 'cityProfile.problem.name',
  code: 'cityProfile.problem.code',
  timeZone: 'cityProfile.problem.timeZone',
} as const satisfies Record<CityProblem, string>;

const refusalKeys = {
  invalid_name: 'cityProfile.refused.invalid_name',
  invalid_city: 'cityProfile.refused.invalid_city',
  city_code_taken: 'cityProfile.refused.city_code_taken',
  not_city_currency: 'cityProfile.refused.not_city_currency',
  inactive_currency: 'cityProfile.refused.inactive_currency',
  base_disabled: 'cityProfile.refused.base_disabled',
  base_locked: 'cityProfile.refused.base_locked',
  rate_missing: 'cityProfile.refused.rate_missing',
  amounts_in_other_currency: 'cityProfile.refused.amounts_in_other_currency',
} as const satisfies Record<CityRefusal, string>;

// AP §9.12.1 «المدن» (slice 2.37c; owner decision 2026-11-19: the existing
// city only): the city's fields, its currencies and base, its cutoff and
// platform hours, with links to the office and the exchange rates. Every
// city is listed, so an inactive one can be activated again. Unstyled
// until the design.
export function CityProfilePage() {
  const { t } = useTranslation();
  const search = route.useSearch();
  const cities = useQuery(allCitiesQuery);
  const city = cities.data ? chosenCity(cities.data, search.city) : undefined;
  const profile = useCityProfile(city?.id);
  const settings = useCitySettings(city?.id);
  return (
    <main>
      <h1>{t('cityProfile.title')}</h1>
      <p>
        <Link to="/">{t('common.home')}</Link>
      </p>
      <p>{t('cityProfile.explain')}</p>
      {profile.isError || cities.isError ? (
        <p role="alert">{t('common.failed')}</p>
      ) : !city || !profile.data ? (
        <p role="status">{t('status.loading')}</p>
      ) : (
        <>
          <CityFields key={[city.id, profile.data.city.code].join()} profile={profile.data} />
          <Currencies profile={profile.data} />
          {settings.data && (
            <section aria-labelledby="city-day">
              <h2 id="city-day">{t('cityProfile.dayAndHours')}</h2>
              <SettingsList city={city} entries={entriesOf(settings.data, CITY_KEYS)} />
            </section>
          )}
          <p>
            <Link to="/office" search={{ city: profile.data.city.code }}>
              {t('cityProfile.office')}
            </Link>{' '}
            <Link to="/exchange-rates" search={{ city: profile.data.city.code }}>
              {t('cityProfile.rates')}
            </Link>
          </p>
        </>
      )}
    </main>
  );
}

function CityFields({ profile }: { profile: CityProfile }) {
  const { t } = useTranslation();
  const { session } = signedIn.useRouteContext();
  const manage = can(session, ZONES_MANAGE);
  const command = useCityCommand(profile.city.id);
  const [form, setForm] = useState<CityForm>(() => cityFormOf(profile.city));
  const [problem, setProblem] = useState<CityProblem | null>(null);
  const city = profile.city;

  const submit = (event: FormEvent) => {
    event.preventDefault();
    const request = cityRequestOf(form);
    if ('problem' in request) {
      setProblem(request.problem);
      return;
    }
    setProblem(null);
    command.mutate({ kind: 'city', body: request.body });
  };

  return (
    <section aria-labelledby="city-fields">
      <h2 id="city-fields">{t('cityProfile.fields')}</h2>
      <ul>
        <li>{t('cityProfile.nameLine', { name: city.name })}</li>
        <li>{t('cityProfile.codeLine', { code: city.code })}</li>
        <li>{t('cityProfile.timeZoneLine', { timeZone: city.timeZone })}</li>
        <li>{t(city.status === 'active' ? 'cityProfile.active' : 'cityProfile.inactive')}</li>
      </ul>
      {manage && (
        <form onSubmit={submit} aria-label={t('cityProfile.change')}>
          <label>
            {t('cityProfile.name')}
            <input
              value={form.name}
              maxLength={100}
              onChange={(event) => setForm({ ...form, name: event.target.value })}
            />
          </label>
          <label>
            {t('cityProfile.code')}
            <input
              value={form.code}
              maxLength={3}
              dir="ltr"
              onChange={(event) => setForm({ ...form, code: event.target.value })}
            />
          </label>
          <p>{t('cityProfile.codeExplain')}</p>
          <label>
            {t('cityProfile.timeZone')}
            <input
              value={form.timeZone}
              dir="ltr"
              onChange={(event) => setForm({ ...form, timeZone: event.target.value })}
            />
          </label>
          <p>{t('cityProfile.timeZoneExplain')}</p>
          <label>
            <input
              type="checkbox"
              checked={form.active}
              onChange={(event) => setForm({ ...form, active: event.target.checked })}
            />
            {t('cityProfile.activeLabel')}
          </label>
          {!form.active && city.status === 'active' && (
            <p role="alert">{t('cityProfile.deactivateWarning')}</p>
          )}
          <label>
            {t('cityProfile.reason')}
            <input
              value={form.reason}
              maxLength={500}
              onChange={(event) => setForm({ ...form, reason: event.target.value })}
            />
          </label>
          {problem && <p role="alert">{t(problemKeys[problem])}</p>}
          <button type="submit" disabled={command.isPending}>
            {t('cityProfile.save')}
          </button>
          {command.data?.status === 'saved' && <p role="status">{t('cityProfile.saved')}</p>}
          {command.data?.status === 'refused' && (
            <p role="alert">{t(refusalKeys[command.data.refusal])}</p>
          )}
          {command.isError && <p role="alert">{t('common.failed')}</p>}
        </form>
      )}
    </section>
  );
}

function Currencies({ profile }: { profile: CityProfile }) {
  const { t } = useTranslation();
  const { session } = signedIn.useRouteContext();
  const manage = can(session, ZONES_MANAGE);
  const command = useCityCommand(profile.city.id);
  const [picked, setAdding] = useState('');
  // The choice, or the first currency left once it was added.
  const adding = profile.otherCurrencies.some((each) => each.code === picked)
    ? picked
    : (profile.otherCurrencies[0]?.code ?? '');

  return (
    <section aria-labelledby="city-currencies">
      <h2 id="city-currencies">{t('cityProfile.currencies')}</h2>
      <p>
        {t(profile.baseLocked ? 'cityProfile.baseLocked' : 'cityProfile.baseOpen')}{' '}
        {t('cityProfile.ratesExplain')}
      </p>
      {profile.currencies.length === 0 ? (
        <p>{t('cityProfile.noCurrencies')}</p>
      ) : (
        <ul>
          {profile.currencies.map((currency) => (
            <li key={currency.code}>
              {t('cityProfile.currencyLine', {
                name: currency.name,
                code: currency.code,
                state: t(
                  currency.isBase
                    ? 'cityProfile.base'
                    : currency.enabled
                      ? 'cityProfile.accepted'
                      : 'cityProfile.notAccepted',
                ),
              })}
              {manage && !currency.isBase && (
                <>
                  {' '}
                  <button
                    type="button"
                    disabled={command.isPending}
                    onClick={() =>
                      command.mutate({
                        kind: 'currency',
                        currency: currency.code,
                        displayOrder: currency.displayOrder,
                        enabled: !currency.enabled,
                      })
                    }
                  >
                    {t(currency.enabled ? 'cityProfile.stopAccepting' : 'cityProfile.accept', {
                      code: currency.code,
                    })}
                  </button>
                  {!profile.baseLocked && (
                    <>
                      {' '}
                      <button
                        type="button"
                        disabled={command.isPending}
                        onClick={() => command.mutate({ kind: 'base', currency: currency.code })}
                      >
                        {t('cityProfile.makeBase', { code: currency.code })}
                      </button>
                    </>
                  )}
                </>
              )}
            </li>
          ))}
        </ul>
      )}
      {manage && profile.otherCurrencies.length > 0 && (
        <p>
          <label>
            {t('cityProfile.addCurrency')}
            <select value={adding} onChange={(event) => setAdding(event.target.value)}>
              {profile.otherCurrencies.map((currency) => (
                <option key={currency.code} value={currency.code}>
                  {t('cityProfile.currencyOption', { name: currency.name, code: currency.code })}
                </option>
              ))}
            </select>
          </label>{' '}
          <button
            type="button"
            disabled={command.isPending || adding === ''}
            onClick={() =>
              command.mutate({
                kind: 'currency',
                currency: adding,
                displayOrder: nextDisplayOrder(profile),
                enabled: false,
              })
            }
          >
            {t('cityProfile.add')}
          </button>
        </p>
      )}
      {command.data?.status === 'refused' && (
        <p role="alert">{t(refusalKeys[command.data.refusal])}</p>
      )}
      {command.isError && <p role="alert">{t('common.failed')}</p>}
    </section>
  );
}
