import { useQuery } from '@tanstack/react-query';
import { getRouteApi, Link } from '@tanstack/react-router';
import { type FormEvent, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { type City, chosenCity, citiesQuery } from './cities.js';
import { formatDateTime, formatMoney } from './format.js';
import { vehicleKeys } from './order-labels.js';
import {
  type DistanceResult,
  draftOf,
  formatKm,
  includedMetresOf,
  kmValueOf,
  type PayForm,
  payFormOf,
  type PayParts,
  type PayProblem,
  type PayTables,
  payVehicles,
  type PayVersion,
  type PublishResult,
  publishRequestOf,
  type RateForm,
  type Vehicle,
  usePayPreview,
  usePayTables,
  usePublishPayTable,
  useSaveMaxDistance,
} from './pay-tables.js';
import { PRICING_EDIT } from './peak-bonus.js';
import { can } from './session.js';

const route = getRouteApi('/signed-in/pay-tables');
const signedIn = getRouteApi('/signed-in');

const stateKeys = {
  in_force: 'payTables.state.in_force',
  announced: 'payTables.state.announced',
  replaced: 'payTables.state.replaced',
  ended: 'payTables.state.ended',
} as const satisfies Record<PayVersion['state'], string>;

const problemKeys = {
  amount: 'payTables.problem.amount',
  distance: 'payTables.problem.distance',
  start: 'payTables.problem.start',
  too_early: 'payTables.problem.tooEarly',
  reason: 'payTables.problem.reason',
} as const satisfies Record<PayProblem['problem'], string>;

const refusalKeys = {
  invalid_pay_table: 'payTables.refused.invalid',
  not_in_base_currency: 'payTables.refused.currency',
} as const;

const rateFields = [
  ['basePay', 'payTables.field.basePay'],
  ['includedKm', 'payTables.field.includedKm'],
  ['perExtraKm', 'payTables.field.perExtraKm'],
  ['waitingPerMinute', 'payTables.field.waitingPerMinute'],
  ['minimumPay', 'payTables.field.minimumPay'],
] as const satisfies readonly (readonly [keyof RateForm, string])[];

// AP §9.12.5 «أجور الكباتن» (slice 2.37b): the table per vehicle in force
// and those announced, the maximum distance, publishing a new table 7 days
// ahead or more, the preview calculator and the history; linked with
// «مكافأة ساعة الذروة». Unstyled until the design.
export function PayTablesPage() {
  const { t } = useTranslation();
  const search = route.useSearch();
  const cities = useQuery(citiesQuery);
  const city = cities.data ? chosenCity(cities.data, search.city) : undefined;
  const tables = usePayTables(city?.id);
  return (
    <main>
      <h1>{t('payTables.title')}</h1>
      <p>
        <Link to="/">{t('common.home')}</Link>{' '}
        <Link to="/peak-bonus" search={city ? { city: city.code } : {}}>
          {t('peakBonus.title')}
        </Link>
      </p>
      <p>{t('payTables.explain')}</p>
      {tables.isError || cities.isError ? (
        <p role="alert">{t('common.failed')}</p>
      ) : !city || !tables.data ? (
        <p role="status">{t('status.loading')}</p>
      ) : (
        <PayTablesView tables={tables.data} city={city} />
      )}
    </main>
  );
}

function PayTablesView({ tables, city }: { tables: PayTables; city: City }) {
  const { t } = useTranslation();
  const { session } = signedIn.useRouteContext();
  const manages = can(session, PRICING_EDIT);
  const publish = usePublishPayTable(city.id);
  const current = tables.versions.find((version) => version.state === 'in_force') ?? null;
  const announced = tables.versions
    .filter((version) => version.state === 'announced')
    .sort((a, b) => a.effectiveFrom.localeCompare(b.effectiveFrom));
  const newest = tables.versions[0] ?? null;
  const [draft, setDraft] = useState<RateForm | null>(null);
  return (
    <>
      <section aria-labelledby="pay-in-force">
        <h2 id="pay-in-force">{t('payTables.inForce')}</h2>
        {current ? (
          <RatesTable version={current} tables={tables} />
        ) : (
          <p>{t('payTables.noTable')}</p>
        )}
        <p>{t('payTables.waitingNote', { minutes: tables.waitingThresholdMin })}</p>
      </section>
      <section aria-labelledby="pay-announced">
        <h2 id="pay-announced">{t('payTables.announced')}</h2>
        {announced.length === 0 ? (
          <p>{t('payTables.noneAnnounced')}</p>
        ) : (
          announced.map((version) => (
            <div key={version.id}>
              <p>
                {t('payTables.startsAt', {
                  at: formatDateTime(version.effectiveFrom, city.timeZone),
                })}
              </p>
              <RatesTable version={version} tables={tables} />
            </div>
          ))
        )}
      </section>
      <MaxDistances tables={tables} city={city} manages={manages} />
      {manages && tables.baseCurrency !== null && (
        <section aria-labelledby="pay-publish">
          <h2 id="pay-publish">{t('payTables.publish')}</h2>
          <p>{t('payTables.publishNote', { days: tables.noticeDays })}</p>
          <PublishForm
            // The form starts again from each newly published version.
            key={newest?.id ?? 'none'}
            tables={tables}
            city={city}
            currency={tables.baseCurrency}
            newest={newest}
            publish={publish}
            onRates={setDraft}
          />
          {publish.isError && <p role="alert">{t('common.failed')}</p>}
          <PublishStatus result={publish.data} city={city} />
        </section>
      )}
      {tables.baseCurrency !== null && (
        <PreviewCalculator city={city} currency={tables.baseCurrency} draft={draft} />
      )}
      <section aria-labelledby="pay-history">
        <h2 id="pay-history">{t('payTables.history')}</h2>
        {tables.versions.length === 0 ? (
          <p>{t('payTables.noTable')}</p>
        ) : (
          <ol>
            {tables.versions.map((version) => (
              <li key={version.id}>
                <p>
                  {t(stateKeys[version.state])}{' '}
                  {t('payTables.startsAt', {
                    at: formatDateTime(version.effectiveFrom, city.timeZone),
                  })}{' '}
                  {t('payTables.setBy', {
                    at: formatDateTime(version.createdAt, city.timeZone),
                    name: version.editorName ?? t('payTables.system'),
                  })}
                  {version.reason && <> {t('payTables.reason', { reason: version.reason })}</>}
                </p>
                <RatesTable version={version} tables={tables} />
              </li>
            ))}
          </ol>
        )}
      </section>
    </>
  );
}

function RatesTable({ version, tables }: { version: PayVersion; tables: PayTables }) {
  const { t } = useTranslation();
  const money = (amount: string) => formatMoney({ amount, currency: version.currency });
  return (
    <table>
      <thead>
        <tr>
          <th>{t('payTables.column.vehicle')}</th>
          <th>{t('payTables.column.basePay')}</th>
          <th>{t('payTables.column.perExtraKm')}</th>
          <th>{t('payTables.column.waiting')}</th>
          <th>{t('payTables.column.minimum')}</th>
          <th>{t('payTables.column.maxDistance')}</th>
        </tr>
      </thead>
      <tbody>
        {version.rates.map((rate) => {
          const maxKm = tables.maxDistanceKm.find((entry) => entry.vehicle === rate.vehicle);
          return (
            <tr key={rate.vehicle}>
              <td>{t(vehicleKeys[rate.vehicle])}</td>
              <td>
                {t('payTables.baseLine', {
                  pay: money(rate.basePay),
                  distance: formatKm(rate.includedMetres),
                })}
              </td>
              <td>{money(rate.perExtraKm)}</td>
              <td>{money(rate.waitingPerMinute)}</td>
              <td>{money(rate.minimumPay)}</td>
              <td>{maxKm ? formatKm(maxKm.km * 1000) : ''}</td>
            </tr>
          );
        })}
      </tbody>
    </table>
  );
}

function MaxDistances({
  tables,
  city,
  manages,
}: {
  tables: PayTables;
  city: City;
  manages: boolean;
}) {
  const { t } = useTranslation();
  return (
    <section aria-labelledby="pay-max-distance">
      <h2 id="pay-max-distance">{t('payTables.maxDistance')}</h2>
      <p>{t('payTables.maxDistanceNote')}</p>
      <ul>
        {tables.maxDistanceKm.map((entry) => (
          <li key={entry.vehicle}>
            {manages ? (
              <MaxDistanceForm
                key={entry.km}
                cityId={city.id}
                vehicle={entry.vehicle}
                km={entry.km}
              />
            ) : (
              t('payTables.maxDistanceLine', {
                vehicle: t(vehicleKeys[entry.vehicle]),
                distance: formatKm(entry.km * 1000),
              })
            )}
          </li>
        ))}
      </ul>
    </section>
  );
}

function MaxDistanceForm({
  cityId,
  vehicle,
  km,
}: {
  cityId: string;
  vehicle: Vehicle;
  km: number;
}) {
  const { t } = useTranslation();
  const save = useSaveMaxDistance(cityId);
  const [typed, setTyped] = useState(String(km));
  const [invalid, setInvalid] = useState(false);
  const name = t(vehicleKeys[vehicle]);
  function submit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    const value = kmValueOf(typed);
    setInvalid(value === null);
    if (value !== null) save.mutate({ vehicle, km: value });
  }
  const result: DistanceResult | undefined = save.data;
  return (
    <form onSubmit={submit}>
      <label>
        {t('payTables.maxDistanceOf', { vehicle: name })}
        <input
          value={typed}
          onChange={(event) => setTyped(event.target.value)}
          inputMode="decimal"
        />
      </label>{' '}
      <button type="submit" disabled={save.isPending}>
        {t('payTables.saveMaxDistance', { vehicle: name })}
      </button>
      {invalid && <p role="alert">{t('payTables.problem.maxDistance')}</p>}
      {save.isError && <p role="alert">{t('common.failed')}</p>}
      {result?.status === 'refused' && <p role="alert">{t('payTables.refused.maxDistance')}</p>}
      {result?.status === 'saved' && <p role="status">{t('payTables.maxDistanceSaved')}</p>}
    </form>
  );
}

function PublishStatus({ result, city }: { result: PublishResult | undefined; city: City }) {
  const { t } = useTranslation();
  if (!result) return null;
  if (result.status === 'refused') return <p role="alert">{t(refusalKeys[result.refusal])}</p>;
  return (
    <p role="status">
      {t('payTables.published', { at: formatDateTime(result.effectiveFrom, city.timeZone) })}
    </p>
  );
}

function PublishForm({
  tables,
  city,
  currency,
  newest,
  publish,
  onRates,
}: {
  tables: PayTables;
  city: City;
  currency: string;
  newest: PayVersion | null;
  publish: ReturnType<typeof usePublishPayTable>;
  onRates: (rate: RateForm | null) => void;
}) {
  const { t } = useTranslation();
  const [form, setForm] = useState<PayForm>(() =>
    payFormOf(newest, currency, tables.earliestStart, city.timeZone),
  );
  const [problem, setProblem] = useState<PayProblem | null>(null);
  function setRate(vehicle: Vehicle, field: keyof RateForm, value: string) {
    setForm((before) => ({
      ...before,
      rates: { ...before.rates, [vehicle]: { ...before.rates[vehicle], [field]: value } },
    }));
  }
  function submit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    const request = publishRequestOf(form, {
      cityId: city.id,
      currency,
      earliestStart: tables.earliestStart,
      timeZone: city.timeZone,
    });
    if ('problem' in request) {
      setProblem(request);
      return;
    }
    setProblem(null);
    publish.mutate(request.body);
  }
  return (
    <form onSubmit={submit}>
      {payVehicles.map((vehicle) => (
        <fieldset key={vehicle}>
          <legend>{t(vehicleKeys[vehicle])}</legend>
          {rateFields.map(([field, key]) => (
            <label key={field}>
              {t(key, { currency })}
              <input
                value={form.rates[vehicle][field]}
                onChange={(event) => setRate(vehicle, field, event.target.value)}
                inputMode="decimal"
              />
            </label>
          ))}
          <button type="button" onClick={() => onRates(form.rates[vehicle])}>
            {t('payTables.useInCalculator', { vehicle: t(vehicleKeys[vehicle]) })}
          </button>
        </fieldset>
      ))}
      <label>
        {t('payTables.start')}
        <input
          type="datetime-local"
          value={form.start}
          onChange={(event) => setForm({ ...form, start: event.target.value })}
        />
      </label>
      <label>
        {t('payTables.reasonField')}
        <input
          value={form.reason}
          onChange={(event) => setForm({ ...form, reason: event.target.value })}
        />
      </label>
      {problem && (
        <p role="alert">
          {t(problemKeys[problem.problem], {
            vehicle: 'vehicle' in problem ? t(vehicleKeys[problem.vehicle]) : '',
            at: formatDateTime(tables.earliestStart, city.timeZone),
          })}
        </p>
      )}
      <button type="submit" disabled={publish.isPending}>
        {t('payTables.publishButton')}
      </button>
    </form>
  );
}

function PreviewCalculator({
  city,
  currency,
  draft,
}: {
  city: City;
  currency: string;
  draft: RateForm | null;
}) {
  const { t } = useTranslation();
  const preview = usePayPreview(city.id);
  const [vehicle, setVehicle] = useState<Vehicle>('motorbike');
  const [km, setKm] = useState('');
  const [waited, setWaited] = useState('0');
  const [withDraft, setWithDraft] = useState(true);
  const [invalid, setInvalid] = useState(false);
  const draftQuery = draft === null ? null : draftOf(draft, currency);
  function submit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    const metres = includedMetresOf(km);
    const waitedMinutes = /^\d{1,4}$/.test(waited.trim()) ? Number(waited.trim()) : null;
    const fits =
      metres !== null && metres <= 100_000 && waitedMinutes !== null && waitedMinutes <= 1440;
    setInvalid(!fits);
    if (!fits) return;
    preview.mutate({
      vehicle,
      metres: metres!,
      waitedMinutes: waitedMinutes!,
      draft: withDraft ? draftQuery : null,
    });
  }
  return (
    <section aria-labelledby="pay-preview">
      <h2 id="pay-preview">{t('payTables.preview.title')}</h2>
      <form onSubmit={submit}>
        <label>
          {t('payTables.preview.vehicle')}
          <select value={vehicle} onChange={(event) => setVehicle(event.target.value as Vehicle)}>
            {payVehicles.map((each) => (
              <option key={each} value={each}>
                {t(vehicleKeys[each])}
              </option>
            ))}
          </select>
        </label>
        <label>
          {t('payTables.preview.km')}
          <input value={km} onChange={(event) => setKm(event.target.value)} inputMode="decimal" />
        </label>
        <label>
          {t('payTables.preview.waited')}
          <input
            value={waited}
            onChange={(event) => setWaited(event.target.value)}
            inputMode="numeric"
          />
        </label>
        {draftQuery !== null && (
          <label>
            <input
              type="checkbox"
              checked={withDraft}
              onChange={(event) => setWithDraft(event.target.checked)}
            />
            {t('payTables.preview.withDraft')}
          </label>
        )}
        <button type="submit" disabled={preview.isPending}>
          {t('payTables.preview.calculate')}
        </button>
      </form>
      {invalid && <p role="alert">{t('payTables.preview.invalid')}</p>}
      {preview.isError && <p role="alert">{t('common.failed')}</p>}
      {preview.data && (
        <div role="status">
          {preview.data.inForce ? (
            <PartsLines title={t('payTables.preview.inForce')} parts={preview.data.inForce} />
          ) : (
            <p>{t('payTables.noTable')}</p>
          )}
          {preview.data.announced.map((parts) => (
            <PartsLines
              key={parts.effectiveFrom}
              title={t('payTables.startsAt', {
                at: formatDateTime(parts.effectiveFrom, city.timeZone),
              })}
              parts={parts}
            />
          ))}
          {preview.data.draft && (
            <PartsLines title={t('payTables.preview.draft')} parts={preview.data.draft} />
          )}
        </div>
      )}
    </section>
  );
}

function PartsLines({ title, parts }: { title: string; parts: PayParts }) {
  const { t } = useTranslation();
  return (
    <>
      <h3>{title}</h3>
      <ul>
        <li>{t('payTables.preview.base', { amount: formatMoney(parts.base) })}</li>
        <li>{t('payTables.preview.distance', { amount: formatMoney(parts.distance) })}</li>
        {parts.topUp.amount !== '0' && (
          <li>{t('payTables.preview.topUp', { amount: formatMoney(parts.topUp) })}</li>
        )}
        <li>{t('payTables.preview.waiting', { amount: formatMoney(parts.waiting) })}</li>
        <li>{t('payTables.preview.total', { amount: formatMoney(parts.total) })}</li>
      </ul>
    </>
  );
}
