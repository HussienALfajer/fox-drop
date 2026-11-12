import { useQuery } from '@tanstack/react-query';
import { getRouteApi, Link } from '@tanstack/react-router';
import { type FormEvent, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { type City, chosenCity, citiesQuery } from './cities.js';
import { formatDateTime } from './format.js';
import {
  type CityOffice,
  type DayForm,
  type OfficeDay,
  officeDays,
  type OfficeForm,
  officeFormOf,
  officeRequestOf,
  useCityOffice,
  useSaveOffice,
  ZONES_MANAGE,
} from './office.js';
import { timeOf } from './peak-bonus.js';
import { can } from './session.js';

const route = getRouteApi('/signed-in/office');
const signedIn = getRouteApi('/signed-in');

const dayKeys = {
  0: 'office.day.0',
  1: 'office.day.1',
  2: 'office.day.2',
  3: 'office.day.3',
  4: 'office.day.4',
  5: 'office.day.5',
  6: 'office.day.6',
} as const satisfies Record<OfficeDay, string>;

// AP §9.12.1, CA C13 «المكتب»: the office's point and the desk hours per
// weekday that captains see, and OWN's small form (owner decision
// 2026-11-12, until the map of 2.29). Unstyled until the design.
export function OfficePage() {
  const { t } = useTranslation();
  const search = route.useSearch();
  const cities = useQuery(citiesQuery);
  const city = cities.data ? chosenCity(cities.data, search.city) : undefined;
  const office = useCityOffice(city?.id);
  return (
    <main>
      <h1>{t('office.title')}</h1>
      <p>
        <Link to="/">{t('common.home')}</Link>
      </p>
      <p>{t('office.explain')}</p>
      {office.isError || cities.isError ? (
        <p role="alert">{t('common.failed')}</p>
      ) : !city || !office.data ? (
        <p role="status">{t('status.loading')}</p>
      ) : (
        <OfficeView office={office.data} city={city} />
      )}
    </main>
  );
}

function OfficeView({ office, city }: { office: CityOffice; city: City }) {
  const { t } = useTranslation();
  const { session } = signedIn.useRouteContext();
  const current = office.office;
  const save = useSaveOffice(city.id);
  return (
    <>
      <section aria-labelledby="office-now">
        <h2 id="office-now">{t('office.inForce')}</h2>
        {current === null ? (
          <p>{t('office.none')}</p>
        ) : (
          <ul>
            <li>
              {t('office.location', {
                latitude: current.location.latitude,
                longitude: current.location.longitude,
              })}
            </li>
            {officeDays.map((day) => {
              const period = current.hours.find((each) => each.weekday === day);
              return (
                <li key={day}>
                  {period
                    ? t('office.dayLine', {
                        day: t(dayKeys[day]),
                        from: timeOf(period.opensAt),
                        to: timeOf(period.closesAt % 1440),
                      })
                    : t('office.dayClosed', { day: t(dayKeys[day]) })}
                </li>
              );
            })}
            <li>
              {current.open && current.closesAt
                ? t('office.openUntil', { at: formatDateTime(current.closesAt, city.timeZone) })
                : current.opensAt
                  ? t('office.closedUntil', { at: formatDateTime(current.opensAt, city.timeZone) })
                  : t('office.neverOpen')}
            </li>
          </ul>
        )}
      </section>
      {can(session, ZONES_MANAGE) && (
        <OfficeFormSection
          // The form starts again from each saved version.
          key={JSON.stringify(current && { location: current.location, hours: current.hours })}
          initial={officeFormOf(current)}
          save={save}
        />
      )}
      {save.isError && <p role="alert">{t('common.failed')}</p>}
      {save.data?.status === 'refused' && <p role="alert">{t('office.refused')}</p>}
      {save.data?.status === 'saved' && <p role="status">{t('office.saved')}</p>}
    </>
  );
}

function OfficeFormSection({
  initial,
  save,
}: {
  initial: OfficeForm;
  save: ReturnType<typeof useSaveOffice>;
}) {
  const { t } = useTranslation();
  const [form, setForm] = useState<OfficeForm>(initial);
  const [problem, setProblem] = useState<ReturnType<typeof officeRequestOf> | null>(null);
  const setDay = (day: OfficeDay, change: Partial<DayForm>) =>
    setForm((before) => ({
      ...before,
      days: { ...before.days, [day]: { ...before.days[day], ...change } },
    }));
  function submit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    const request = officeRequestOf(form);
    if ('problem' in request) {
      setProblem(request);
      return;
    }
    setProblem(null);
    save.mutate(request.body);
  }
  return (
    <section aria-labelledby="office-form">
      <h2 id="office-form">{t('office.change')}</h2>
      <form onSubmit={submit}>
        <fieldset disabled={save.isPending}>
          <label>
            {t('office.latitude')}
            <input
              inputMode="decimal"
              dir="ltr"
              value={form.latitude}
              onChange={(event) => setForm({ ...form, latitude: event.target.value })}
            />
          </label>
          <label>
            {t('office.longitude')}
            <input
              inputMode="decimal"
              dir="ltr"
              value={form.longitude}
              onChange={(event) => setForm({ ...form, longitude: event.target.value })}
            />
          </label>
          {problem && 'problem' in problem && problem.problem === 'location' && (
            <p role="alert">{t('office.problem.location')}</p>
          )}
          <p>{t('office.hoursExplain')}</p>
          {officeDays.map((day) => (
            <fieldset key={day}>
              <legend>{t(dayKeys[day])}</legend>
              <label>
                <input
                  type="checkbox"
                  checked={form.days[day].open}
                  onChange={(event) => setDay(day, { open: event.target.checked })}
                />
                {t('office.open')}
              </label>
              {form.days[day].open && (
                <>
                  <label>
                    {t('office.from')}
                    <input
                      type="time"
                      value={form.days[day].from}
                      onChange={(event) => setDay(day, { from: event.target.value })}
                    />
                  </label>
                  <label>
                    {t('office.to')}
                    <input
                      type="time"
                      value={form.days[day].to}
                      onChange={(event) => setDay(day, { to: event.target.value })}
                    />
                  </label>
                </>
              )}
              {problem && 'day' in problem && problem.day === day && (
                <p role="alert">{t('office.problem.hours')}</p>
              )}
            </fieldset>
          ))}
          <button type="submit">{t('office.save')}</button>
        </fieldset>
      </form>
    </section>
  );
}
