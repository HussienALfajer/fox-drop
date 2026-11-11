import { useQuery } from '@tanstack/react-query';
import { getRouteApi, Link } from '@tanstack/react-router';
import { type FormEvent, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { type City, chosenCity, citiesQuery } from './cities.js';
import { formatDateTime, formatMoney } from './format.js';
import {
  crossesMidnight,
  emptyWindow,
  type FormProblem,
  formOf,
  type PeakBonus,
  type PeakForm,
  type PeakVersion,
  PRICING_EDIT,
  requestOf,
  timeOf,
  usePeakBonus,
  useSavePeakBonus,
  type WeekDay,
  weekDays,
  type WindowForm,
} from './peak-bonus.js';
import { can } from './session.js';

const route = getRouteApi('/signed-in/peak-bonus');
const signedIn = getRouteApi('/signed-in');

const dayKeys = {
  1: 'peakBonus.day.1',
  2: 'peakBonus.day.2',
  3: 'peakBonus.day.3',
  4: 'peakBonus.day.4',
  5: 'peakBonus.day.5',
  6: 'peakBonus.day.6',
  7: 'peakBonus.day.7',
} as const satisfies Record<WeekDay, string>;

const problemKeys = {
  days: 'peakBonus.problem.days',
  hours: 'peakBonus.problem.hours',
  amount: 'peakBonus.problem.amount',
} as const satisfies Record<FormProblem, string>;

// AP §9.12.5 «مكافأة ساعة الذروة» (D15): the bonus in force, a lowering
// waiting for the end of the current window, and OWN's form. Unstyled until
// the design.
export function PeakBonusPage() {
  const { t } = useTranslation();
  const search = route.useSearch();
  const cities = useQuery(citiesQuery);
  const city = cities.data ? chosenCity(cities.data, search.city) : undefined;
  const bonus = usePeakBonus(city?.id);
  return (
    <main>
      <h1>{t('peakBonus.title')}</h1>
      <p>
        <Link to="/">{t('common.home')}</Link>
      </p>
      <p>{t('peakBonus.explain')}</p>
      {bonus.isError || cities.isError ? (
        <p role="alert">{t('common.failed')}</p>
      ) : !city || !bonus.data ? (
        <p role="status">{t('status.loading')}</p>
      ) : (
        <PeakBonusView bonus={bonus.data} city={city} />
      )}
    </main>
  );
}

function PeakBonusView({ bonus, city }: { bonus: PeakBonus; city: City }) {
  const { t } = useTranslation();
  const { session } = signedIn.useRouteContext();
  const save = useSavePeakBonus();
  const newest = bonus.pending ?? bonus.inForce;
  return (
    <>
      <section aria-labelledby="peak-in-force">
        <h2 id="peak-in-force">{t('peakBonus.inForce')}</h2>
        <VersionSummary version={bonus.inForce} city={city} />
      </section>
      {bonus.pending && (
        <section aria-labelledby="peak-pending">
          <h2 id="peak-pending">
            {t('peakBonus.pending', {
              at: formatDateTime(bonus.pending.effectiveFrom, city.timeZone),
            })}
          </h2>
          <p>{t('peakBonus.pendingExplain')}</p>
          <VersionSummary version={bonus.pending} city={city} />
        </section>
      )}
      {can(session, PRICING_EDIT) && (
        <PeakBonusForm
          // The form starts again from each newly saved version.
          key={newest?.id ?? 'none'}
          initial={formOf(newest)}
          zones={bonus.zones}
          currency={newest?.currency ?? null}
          city={city}
          save={save}
        />
      )}
      {save.isError && <p role="alert">{t('common.failed')}</p>}
      {save.data?.status === 'refused' && <p role="alert">{t('peakBonus.refused')}</p>}
      {save.data?.status === 'saved' && (
        <p role="status">
          {save.data.bonus.pending
            ? t('peakBonus.savedLater', {
                at: formatDateTime(save.data.bonus.pending.effectiveFrom, city.timeZone),
              })
            : t('peakBonus.saved')}
        </p>
      )}
    </>
  );
}

function VersionSummary({ version, city }: { version: PeakVersion | null; city: City }) {
  const { t } = useTranslation();
  if (version === null || !version.enabled) return <p>{t('peakBonus.off')}</p>;
  if (version.windows.length === 0) return <p>{t('peakBonus.noWindows')}</p>;
  return (
    <ul>
      {version.windows.map((window, index) => (
        <li key={index}>
          {t('peakBonus.windowLine', {
            days: weekDays
              .filter((day) => window.days.includes(day))
              .map((day) => t(dayKeys[day]))
              .join('، '),
            start: timeOf(window.startMinute),
            end: timeOf(window.endMinute),
            amount: formatMoney({ amount: window.amount, currency: version.currency }),
          })}
          {crossesMidnight(window) && <> {t('peakBonus.nextDay')}</>}{' '}
          {window.zones.length === 0
            ? t('peakBonus.allZones')
            : t('peakBonus.someZones', { zones: window.zones.map((zone) => zone.name).join('، ') })}
        </li>
      ))}
      <li>{t('peakBonus.since', { at: formatDateTime(version.effectiveFrom, city.timeZone) })}</li>
    </ul>
  );
}

function PeakBonusForm({
  initial,
  zones,
  currency,
  city,
  save,
}: {
  initial: PeakForm;
  zones: PeakBonus['zones'];
  currency: string | null;
  city: City;
  save: ReturnType<typeof useSavePeakBonus>;
}) {
  const { t } = useTranslation();
  const [form, setForm] = useState<PeakForm>(initial);
  const [problem, setProblem] = useState<{ problem: FormProblem; window: number } | null>(null);
  // Amounts are typed in the city's base; a city without one is refused.
  const base = currency ?? 'TRY';
  const setWindow = (index: number, change: Partial<WindowForm>) =>
    setForm((before) => ({
      ...before,
      windows: before.windows.map((window, at) =>
        at === index ? { ...window, ...change } : window,
      ),
    }));
  const toggle = (list: readonly (number | string)[], value: number | string) =>
    list.includes(value) ? list.filter((each) => each !== value) : [...list, value];
  function submit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    const request = requestOf(form, city.id, base);
    if ('problem' in request) {
      setProblem(request);
      return;
    }
    setProblem(null);
    save.mutate(request.body);
  }
  return (
    <section aria-labelledby="peak-form">
      <h2 id="peak-form">{t('peakBonus.change')}</h2>
      <p>{t('peakBonus.rule')}</p>
      <form onSubmit={submit}>
        <fieldset disabled={save.isPending}>
          <label>
            <input
              type="checkbox"
              checked={form.enabled}
              onChange={(event) => setForm({ ...form, enabled: event.target.checked })}
            />
            {t('peakBonus.enabled')}
          </label>
          {form.windows.map((window, index) => (
            <fieldset key={index}>
              <legend>{t('peakBonus.window', { number: index + 1 })}</legend>
              {weekDays.map((day) => (
                <label key={day}>
                  <input
                    type="checkbox"
                    checked={window.days.includes(day)}
                    onChange={() =>
                      setWindow(index, { days: toggle(window.days, day) as number[] })
                    }
                  />
                  {t(dayKeys[day])}
                </label>
              ))}
              <label>
                {t('peakBonus.from')}
                <input
                  type="time"
                  value={window.start}
                  onChange={(event) => setWindow(index, { start: event.target.value })}
                />
              </label>
              <label>
                {t('peakBonus.to')}
                <input
                  type="time"
                  value={window.end}
                  onChange={(event) => setWindow(index, { end: event.target.value })}
                />
              </label>
              <label>
                {t('peakBonus.amount', { currency: base })}
                <input
                  inputMode="decimal"
                  value={window.amount}
                  onChange={(event) => setWindow(index, { amount: event.target.value })}
                />
              </label>
              <fieldset>
                <legend>{t('peakBonus.zones')}</legend>
                <p>{t('peakBonus.zonesExplain')}</p>
                {zones.map((zone) => (
                  <label key={zone.id}>
                    <input
                      type="checkbox"
                      checked={window.zoneIds.includes(zone.id)}
                      onChange={() =>
                        setWindow(index, { zoneIds: toggle(window.zoneIds, zone.id) as string[] })
                      }
                    />
                    {zone.name}
                  </label>
                ))}
              </fieldset>
              <button
                type="button"
                onClick={() =>
                  setForm({ ...form, windows: form.windows.filter((_, at) => at !== index) })
                }
              >
                {t('peakBonus.removeWindow')}
              </button>
              {problem?.window === index && <p role="alert">{t(problemKeys[problem.problem])}</p>}
            </fieldset>
          ))}
          <button
            type="button"
            onClick={() => setForm({ ...form, windows: [...form.windows, emptyWindow] })}
          >
            {t('peakBonus.addWindow')}
          </button>
          <button type="submit">{t('peakBonus.save')}</button>
        </fieldset>
      </form>
    </section>
  );
}
