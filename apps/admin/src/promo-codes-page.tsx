import { useQuery } from '@tanstack/react-query';
import { getRouteApi, Link } from '@tanstack/react-router';
import { type FormEvent, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { type City, chosenCity, citiesQuery } from './cities.js';
import { formatDateTime, formatMoney } from './format.js';
import {
  AUDIENCES,
  createRequestOf,
  emptyForm,
  type FormProblem,
  fieldsOf,
  formOfCode,
  FUNDINGS,
  KINDS,
  type PromoCode,
  type PromoCodes,
  type PromoForm,
  type PromoRefusal,
  type PromoState,
  type SaveResult,
  useCreatePromoCodes,
  useEditPromoCode,
  usePromoCodes,
  useSetPromoCodeStatus,
  valueOf,
  VISIBILITIES,
} from './promo-codes.js';

const route = getRouteApi('/signed-in/promo-codes');

export const kindKeys = {
  percentage: 'promoCodes.kind.percentage',
  fixed_amount: 'promoCodes.kind.fixed_amount',
  free_delivery: 'promoCodes.kind.free_delivery',
} as const;

export const stateKeys = {
  active: 'promoCodes.state.active',
  paused: 'promoCodes.state.paused',
  scheduled: 'promoCodes.state.scheduled',
  expired: 'promoCodes.state.expired',
} as const satisfies Record<PromoState, string>;

const audienceKeys = {
  everyone: 'promoCodes.audience.everyone',
  new_users: 'promoCodes.audience.new_users',
} as const;

const fundingKeys = {
  platform: 'promoCodes.funding.platform',
  restaurant: 'promoCodes.funding.restaurant',
  shared: 'promoCodes.funding.shared',
} as const;

const visibilityKeys = {
  visible: 'promoCodes.visibility.visible',
  secret: 'promoCodes.visibility.secret',
} as const;

const problemKeys = {
  code: 'promoCodes.problem.code',
  count: 'promoCodes.problem.count',
  prefix: 'promoCodes.problem.prefix',
  percent: 'promoCodes.problem.percent',
  amount: 'promoCodes.problem.amount',
  money: 'promoCodes.problem.money',
  dates: 'promoCodes.problem.dates',
  hours: 'promoCodes.problem.hours',
  limits: 'promoCodes.problem.limits',
  share: 'promoCodes.problem.share',
  restaurants: 'promoCodes.problem.restaurants',
} as const satisfies Record<FormProblem, string>;

export const refusalKeys = {
  invalid_promo_code: 'promoCodes.refusal.invalid_promo_code',
  code_taken: 'promoCodes.refusal.code_taken',
  no_base_currency: 'promoCodes.refusal.no_base_currency',
  currency_changed: 'promoCodes.refusal.currency_changed',
  unknown_promo_code: 'promoCodes.refusal.unknown_promo_code',
} as const satisfies Record<PromoRefusal, string>;

// AP §9.11.1 «أكواد الخصم» (slice 2.21a): the city's codes with their
// columns, and OWN's form to create, edit, pause and resume. Unstyled until
// the design.
export function PromoCodesPage() {
  const { t } = useTranslation();
  const search = route.useSearch();
  const cities = useQuery(citiesQuery);
  const city = cities.data ? chosenCity(cities.data, search.city) : undefined;
  const codes = usePromoCodes(city?.id);
  return (
    <main>
      <h1>{t('promoCodes.title')}</h1>
      <p>
        <Link to="/">{t('common.home')}</Link>
      </p>
      {codes.isError || cities.isError ? (
        <p role="alert">{t('common.failed')}</p>
      ) : !city || !codes.data ? (
        <p role="status">{t('status.loading')}</p>
      ) : (
        <PromoCodesView codes={codes.data} city={city} />
      )}
    </main>
  );
}

function PromoCodesView({ codes, city }: { codes: PromoCodes; city: City }) {
  const { t } = useTranslation();
  // The code being edited, or 'new' for the create form.
  const [editing, setEditing] = useState<PromoCode | 'new' | null>(null);
  const [saved, setSaved] = useState<string | null>(null);
  const setStatus = useSetPromoCodeStatus(city.id);
  const currency = codes.baseCurrency;
  return (
    <>
      {codes.canManage && currency === null && <p role="alert">{t('promoCodes.noBase')}</p>}
      {codes.canManage && currency !== null && editing === null && (
        <button type="button" onClick={() => setEditing('new')}>
          {t('promoCodes.new')}
        </button>
      )}
      {saved && <p role="status">{saved}</p>}
      {editing !== null && currency !== null && (
        <PromoCodeForm
          key={editing === 'new' ? 'new' : editing.id}
          editing={editing === 'new' ? null : editing}
          codes={codes}
          city={city}
          currency={currency}
          onDone={(message) => {
            setEditing(null);
            setSaved(message);
          }}
        />
      )}
      {codes.codes.length === 0 ? (
        <p>{t('promoCodes.none')}</p>
      ) : (
        <table>
          <thead>
            <tr>
              <th>{t('promoCodes.column.code')}</th>
              <th>{t('promoCodes.column.kind')}</th>
              <th>{t('promoCodes.column.value')}</th>
              <th>{t('promoCodes.column.state')}</th>
              <th>{t('promoCodes.column.uses')}</th>
              <th>{t('promoCodes.column.cost')}</th>
              <th>{t('promoCodes.column.end')}</th>
              {codes.canManage && <th>{t('promoCodes.column.actions')}</th>}
            </tr>
          </thead>
          <tbody>
            {codes.codes.map((code) => (
              <tr key={code.id}>
                <td>
                  <Link
                    to="/promo-codes/$codeId"
                    params={{ codeId: code.id }}
                    search={{ city: city.code }}
                  >
                    {code.code}
                  </Link>
                </td>
                <td>{t(kindKeys[code.kind])}</td>
                <td>
                  <ValueText code={code} />
                </td>
                <td>{t(stateKeys[code.state])}</td>
                <td>
                  {code.totalLimit === null
                    ? t('promoCodes.usesNoLimit', { uses: code.uses })
                    : t('promoCodes.usesOfLimit', { uses: code.uses, limit: code.totalLimit })}
                </td>
                <td>
                  {code.costToDate === null
                    ? '—'
                    : formatMoney({ amount: code.costToDate, currency: code.currency })}
                </td>
                <td>{formatDateTime(code.validTo, city.timeZone)}</td>
                {codes.canManage && (
                  <td>
                    <button
                      type="button"
                      onClick={() => {
                        setSaved(null);
                        setEditing(code);
                      }}
                    >
                      {t('promoCodes.edit', { code: code.code })}
                    </button>
                    {code.state !== 'expired' && (
                      <button
                        type="button"
                        disabled={setStatus.isPending}
                        onClick={() =>
                          setStatus.mutate({ codeId: code.id, pause: code.status === 'active' })
                        }
                      >
                        {code.status === 'active'
                          ? t('promoCodes.pause', { code: code.code })
                          : t('promoCodes.resume', { code: code.code })}
                      </button>
                    )}
                  </td>
                )}
              </tr>
            ))}
          </tbody>
        </table>
      )}
      {setStatus.isError && <p role="alert">{t('common.failed')}</p>}
    </>
  );
}

export function ValueText({ code }: { code: PromoCode }) {
  const { t } = useTranslation();
  const value = valueOf(code);
  if (value === null) return <>{t('promoCodes.wholeFee')}</>;
  if ('amount' in value)
    return <>{formatMoney({ amount: value.amount, currency: code.currency })}</>;
  return (
    <>
      {value.cap === null
        ? t('promoCodes.percent', { percent: value.percent })
        : t('promoCodes.percentCapped', {
            percent: value.percent,
            cap: formatMoney({ amount: value.cap, currency: code.currency }),
          })}
    </>
  );
}

function PromoCodeForm({
  editing,
  codes,
  city,
  currency,
  onDone,
}: {
  editing: PromoCode | null;
  codes: PromoCodes;
  city: City;
  currency: string;
  onDone: (message: string) => void;
}) {
  const { t } = useTranslation();
  const [form, setForm] = useState<PromoForm>(
    editing ? formOfCode(editing, city.timeZone) : emptyForm,
  );
  const [problem, setProblem] = useState<FormProblem | null>(null);
  const [refusal, setRefusal] = useState<PromoRefusal | null>(null);
  const create = useCreatePromoCodes(city.id);
  const edit = useEditPromoCode(city.id);
  const pending = create.isPending || edit.isPending;
  const set = (change: Partial<PromoForm>) => setForm((before) => ({ ...before, ...change }));
  const toggle = (list: string[], value: string) =>
    list.includes(value) ? list.filter((each) => each !== value) : [...list, value];

  function answered(result: SaveResult) {
    if (result.status === 'refused') {
      setRefusal(result.refusal);
      return;
    }
    onDone(
      editing
        ? t('promoCodes.saved', { code: editing.code })
        : result.codes.length === 1
          ? t('promoCodes.created', { code: result.codes[0]!.code })
          : t('promoCodes.generated', { count: result.codes.length }),
    );
  }

  function submit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    setRefusal(null);
    if (editing) {
      const checked = fieldsOf(form, currency, city.timeZone);
      if ('problem' in checked) return setProblem(checked.problem);
      setProblem(null);
      edit.mutate({ codeId: editing.id, fields: checked.fields }, { onSuccess: answered });
      return;
    }
    const request = createRequestOf(form, city.id, currency, city.timeZone);
    if ('problem' in request) return setProblem(request.problem);
    setProblem(null);
    create.mutate(request, { onSuccess: answered });
  }

  return (
    <section aria-labelledby="promo-form">
      <h2 id="promo-form">
        {editing ? t('promoCodes.editTitle', { code: editing.code }) : t('promoCodes.new')}
      </h2>
      <form onSubmit={submit}>
        <fieldset disabled={pending}>
          {!editing && (
            <fieldset>
              <legend>{t('promoCodes.field.code')}</legend>
              <label>
                <input
                  type="radio"
                  checked={form.mode === 'typed'}
                  onChange={() => set({ mode: 'typed' })}
                />
                {t('promoCodes.typed')}
              </label>
              <label>
                <input
                  type="radio"
                  checked={form.mode === 'batch'}
                  onChange={() => set({ mode: 'batch' })}
                />
                {t('promoCodes.batch')}
              </label>
              {form.mode === 'typed' ? (
                <label>
                  {t('promoCodes.field.typedCode')}
                  <input
                    value={form.code}
                    onChange={(event) => set({ code: event.target.value })}
                  />
                </label>
              ) : (
                <>
                  <label>
                    {t('promoCodes.field.count')}
                    <input
                      inputMode="numeric"
                      value={form.count}
                      onChange={(event) => set({ count: event.target.value })}
                    />
                  </label>
                  <label>
                    {t('promoCodes.field.prefix')}
                    <input
                      value={form.prefix}
                      onChange={(event) => set({ prefix: event.target.value })}
                    />
                  </label>
                </>
              )}
            </fieldset>
          )}
          <fieldset>
            <legend>{t('promoCodes.field.kind')}</legend>
            {KINDS.map((kind) => (
              <label key={kind}>
                <input type="radio" checked={form.kind === kind} onChange={() => set({ kind })} />
                {t(kindKeys[kind])}
              </label>
            ))}
            {form.kind === 'percentage' && (
              <>
                <label>
                  {t('promoCodes.field.percent')}
                  <input
                    inputMode="decimal"
                    value={form.percent}
                    onChange={(event) => set({ percent: event.target.value })}
                  />
                </label>
                <label>
                  {t('promoCodes.field.maxDiscount', { currency })}
                  <input
                    inputMode="decimal"
                    value={form.maxDiscount}
                    onChange={(event) => set({ maxDiscount: event.target.value })}
                  />
                </label>
              </>
            )}
            {form.kind === 'fixed_amount' && (
              <label>
                {t('promoCodes.field.amount', { currency })}
                <input
                  inputMode="decimal"
                  value={form.amount}
                  onChange={(event) => set({ amount: event.target.value })}
                />
              </label>
            )}
          </fieldset>
          <label>
            {t('promoCodes.field.minOrder', { currency })}
            <input
              inputMode="decimal"
              value={form.minOrder}
              onChange={(event) => set({ minOrder: event.target.value })}
            />
          </label>
          <fieldset>
            <legend>{t('promoCodes.field.validity')}</legend>
            <label>
              {t('promoCodes.field.validFrom')}
              <input
                type="datetime-local"
                value={form.validFrom}
                onChange={(event) => set({ validFrom: event.target.value })}
              />
            </label>
            <label>
              {t('promoCodes.field.validTo')}
              <input
                type="datetime-local"
                value={form.validTo}
                onChange={(event) => set({ validTo: event.target.value })}
              />
            </label>
            <p>{t('promoCodes.hoursExplain')}</p>
            <label>
              {t('promoCodes.field.start')}
              <input
                type="time"
                value={form.start}
                onChange={(event) => set({ start: event.target.value })}
              />
            </label>
            <label>
              {t('promoCodes.field.end')}
              <input
                type="time"
                value={form.end}
                onChange={(event) => set({ end: event.target.value })}
              />
            </label>
          </fieldset>
          <fieldset>
            <legend>{t('promoCodes.field.limits')}</legend>
            <label>
              {t('promoCodes.field.totalLimit')}
              <input
                inputMode="numeric"
                value={form.totalLimit}
                onChange={(event) => set({ totalLimit: event.target.value })}
              />
            </label>
            <label>
              {t('promoCodes.field.perCustomerLimit')}
              <input
                inputMode="numeric"
                value={form.perCustomerLimit}
                onChange={(event) => set({ perCustomerLimit: event.target.value })}
              />
            </label>
          </fieldset>
          <fieldset>
            <legend>{t('promoCodes.field.audience')}</legend>
            {AUDIENCES.map((audience) => (
              <label key={audience}>
                <input
                  type="radio"
                  checked={form.audience === audience}
                  onChange={() => set({ audience })}
                />
                {t(audienceKeys[audience])}
              </label>
            ))}
          </fieldset>
          <fieldset>
            <legend>{t('promoCodes.field.restaurants')}</legend>
            <p>{t('promoCodes.noneMeansAll')}</p>
            {codes.restaurants.map((restaurant) => (
              <label key={restaurant.id}>
                <input
                  type="checkbox"
                  checked={form.restaurantIds.includes(restaurant.id)}
                  onChange={() => set({ restaurantIds: toggle(form.restaurantIds, restaurant.id) })}
                />
                {restaurant.name}
              </label>
            ))}
          </fieldset>
          <fieldset>
            <legend>{t('promoCodes.field.zones')}</legend>
            <p>{t('promoCodes.noneMeansAll')}</p>
            {codes.zones.map((zone) => (
              <label key={zone.id}>
                <input
                  type="checkbox"
                  checked={form.zoneIds.includes(zone.id)}
                  onChange={() => set({ zoneIds: toggle(form.zoneIds, zone.id) })}
                />
                {zone.active ? zone.name : t('promoCodes.inactiveZone', { zone: zone.name })}
              </label>
            ))}
          </fieldset>
          <fieldset>
            <legend>{t('promoCodes.field.funding')}</legend>
            {FUNDINGS.map((funding) => (
              <label key={funding}>
                <input
                  type="radio"
                  checked={form.funding === funding}
                  onChange={() => set({ funding })}
                />
                {t(fundingKeys[funding])}
              </label>
            ))}
            {form.funding === 'shared' && (
              <label>
                {t('promoCodes.field.sharedPercent')}
                <input
                  inputMode="decimal"
                  value={form.sharedPercent}
                  onChange={(event) => set({ sharedPercent: event.target.value })}
                />
              </label>
            )}
          </fieldset>
          <label>
            {t('promoCodes.field.dailyBudget', { currency })}
            <input
              inputMode="decimal"
              value={form.dailyBudget}
              onChange={(event) => set({ dailyBudget: event.target.value })}
            />
          </label>
          <fieldset>
            <legend>{t('promoCodes.field.visibility')}</legend>
            {VISIBILITIES.map((visibility) => (
              <label key={visibility}>
                <input
                  type="radio"
                  checked={form.visibility === visibility}
                  onChange={() => set({ visibility })}
                />
                {t(visibilityKeys[visibility])}
              </label>
            ))}
          </fieldset>
          {problem && <p role="alert">{t(problemKeys[problem])}</p>}
          {refusal && <p role="alert">{t(refusalKeys[refusal])}</p>}
          {(create.isError || edit.isError) && <p role="alert">{t('common.failed')}</p>}
          <button type="submit">{editing ? t('promoCodes.save') : t('promoCodes.create')}</button>
          <button type="button" onClick={() => onDone('')}>
            {t('promoCodes.cancel')}
          </button>
        </fieldset>
      </form>
    </section>
  );
}
