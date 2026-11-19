import { useQuery } from '@tanstack/react-query';
import { getRouteApi, Link } from '@tanstack/react-router';
import { type FormEvent, lazy, Suspense, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { type City, chosenCity, citiesQuery } from './cities.js';
import {
  bandLines,
  type DeliveryFees,
  type FeeRestaurant,
  type FeeRule,
  type FeeVersion,
  type PreviewResult,
  type RuleForm,
  ruleFormOf,
  type RuleProblem,
  ruleRequestOf,
  type SaveResult,
  useDeliveryFees,
  usePreviewFee,
  useSaveFeeRule,
} from './delivery-fees.js';
import { PRICING_EDIT } from './peak-bonus.js';
import { formatDateTime, formatDistance, formatMoney, minorOf } from './format.js';
import { degreesOf } from './restaurant-drafts.js';
import { can } from './session.js';

const PinMap = lazy(() => import('./pin-map.js').then((module) => ({ default: module.PinMap })));

const route = getRouteApi('/signed-in/delivery-fees');
const signedIn = getRouteApi('/signed-in');

const problemKeys = {
  fee: 'deliveryFees.problem.fee',
  band_fee: 'deliveryFees.problem.bandFee',
  band_edge: 'deliveryFees.problem.bandEdge',
  minimum: 'deliveryFees.problem.minimum',
  threshold: 'deliveryFees.problem.threshold',
} as const satisfies Record<RuleProblem, string>;

const refusalKeys = {
  invalid_fee_rule: 'deliveryFees.refused.invalid',
  fee_not_in_base_currency: 'deliveryFees.refused.currency',
} as const;

const unpricedKeys = {
  no_fee_rule: 'deliveryFees.preview.noRule',
  fee_not_in_base_currency: 'deliveryFees.preview.otherCurrency',
} as const;

// AP §9.12.3 «رسوم التوصيل» (slice 2.37a): the city's rule and its
// versions, the restaurants' own rules and the preview calculator; OWN
// changes them. Unstyled until the design.
export function DeliveryFeesPage() {
  const { t } = useTranslation();
  const search = route.useSearch();
  const cities = useQuery(citiesQuery);
  const city = cities.data ? chosenCity(cities.data, search.city) : undefined;
  const fees = useDeliveryFees(city?.id);
  return (
    <main>
      <h1>{t('deliveryFees.title')}</h1>
      <p>
        <Link to="/">{t('common.home')}</Link>
      </p>
      <p>{t('deliveryFees.explain')}</p>
      {fees.isError || cities.isError ? (
        <p role="alert">{t('common.failed')}</p>
      ) : !city || !fees.data ? (
        <p role="status">{t('status.loading')}</p>
      ) : (
        <DeliveryFeesView fees={fees.data} city={city} />
      )}
    </main>
  );
}

function DeliveryFeesView({ fees, city }: { fees: DeliveryFees; city: City }) {
  const { t } = useTranslation();
  const { session } = signedIn.useRouteContext();
  const manages = can(session, PRICING_EDIT);
  const save = useSaveFeeRule(city.id);
  const current = fees.versions[0] ?? null;
  return (
    <>
      <section aria-labelledby="fees-in-force">
        <h2 id="fees-in-force">{t('deliveryFees.inForce')}</h2>
        {current ? <RuleSummary rule={current.rule} /> : <p>{t('deliveryFees.noRule')}</p>}
        <p>
          {fees.distanceMethod === 'road'
            ? t('deliveryFees.measuredByRoad')
            : t('deliveryFees.measuredStraight')}
        </p>
      </section>
      {manages && (
        <section aria-labelledby="fees-change">
          <h2 id="fees-change">{t('deliveryFees.change')}</h2>
          <CityRuleForm
            // The form starts again from each newly saved version.
            key={current?.rule.id ?? 'none'}
            rule={current?.rule ?? null}
            currency={fees.baseCurrency}
            save={save}
          />
          {save.isError && <p role="alert">{t('common.failed')}</p>}
          <SaveStatus result={save.data} />
        </section>
      )}
      <section aria-labelledby="fees-history">
        <h2 id="fees-history">{t('deliveryFees.history')}</h2>
        {fees.versions.length === 0 ? (
          <p>{t('deliveryFees.noRule')}</p>
        ) : (
          <ol>
            {fees.versions.map((version) => (
              <li key={version.rule.id}>
                <VersionLine version={version} city={city} />
                <RuleSummary rule={version.rule} />
              </li>
            ))}
          </ol>
        )}
      </section>
      <RestaurantRules fees={fees} city={city} manages={manages} />
      {fees.baseCurrency !== null && (
        <PreviewCalculator fees={fees} city={city} currency={fees.baseCurrency} />
      )}
    </>
  );
}

function VersionLine({ version, city }: { version: FeeVersion; city: City }) {
  const { t } = useTranslation();
  return (
    <p>
      {t('deliveryFees.setBy', {
        at: formatDateTime(version.createdAt, city.timeZone),
        name: version.editorName ?? t('deliveryFees.system'),
      })}
      {version.reason && <> {t('deliveryFees.reason', { reason: version.reason })}</>}
    </p>
  );
}

function RuleSummary({ rule }: { rule: FeeRule }) {
  const { t } = useTranslation();
  const money = (amount: string) => formatMoney({ amount, currency: rule.currency });
  return (
    <ul>
      {rule.flatFee !== null ? (
        <li>{t('deliveryFees.flatLine', { fee: money(rule.flatFee) })}</li>
      ) : (
        bandLines(rule).map((band, index) => (
          <li key={index}>
            {band.upToMetres === null
              ? t('deliveryFees.lastBandLine', {
                  from: formatDistance(band.fromMetres),
                  fee: money(band.fee),
                })
              : t('deliveryFees.bandLine', {
                  from: formatDistance(band.fromMetres),
                  to: formatDistance(band.upToMetres),
                  fee: money(band.fee),
                })}
          </li>
        ))
      )}
      {rule.minimumFee !== null && (
        <li>{t('deliveryFees.minimumLine', { fee: money(rule.minimumFee) })}</li>
      )}
      {rule.freeDeliveryFrom !== null && (
        <li>{t('deliveryFees.freeLine', { from: money(rule.freeDeliveryFrom) })}</li>
      )}
    </ul>
  );
}

function SaveStatus({ result }: { result: SaveResult | undefined }) {
  const { t } = useTranslation();
  if (!result) return null;
  if (result.status === 'refused') return <p role="alert">{t(refusalKeys[result.refusal])}</p>;
  return <p role="status">{t('deliveryFees.saved')}</p>;
}

function CityRuleForm({
  rule,
  currency,
  save,
}: {
  rule: FeeRule | null;
  currency: string | null;
  save: ReturnType<typeof useSaveFeeRule>;
}) {
  const { t } = useTranslation();
  const [form, setForm] = useState<RuleForm>(() => ruleFormOf(rule, currency ?? ''));
  const [reason, setReason] = useState('');
  const [problem, setProblem] = useState<RuleProblem | null>(null);
  function submit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    if (currency === null) return;
    const request = ruleRequestOf(form, currency);
    if ('problem' in request) {
      setProblem(request.problem);
      return;
    }
    setProblem(null);
    save.mutate({ restaurantId: null, rule: request.rule, reason: reason.trim() || null });
  }
  return currency === null ? (
    <p>{t('deliveryFees.noBase')}</p>
  ) : (
    <form onSubmit={submit}>
      <fieldset disabled={save.isPending}>
        <RuleFields form={form} setForm={setForm} currency={currency} />
        <label>
          {t('deliveryFees.reasonField')}
          <input value={reason} onChange={(event) => setReason(event.target.value)} />
        </label>
        {problem && <p role="alert">{t(problemKeys[problem])}</p>}
        <button type="submit">{t('deliveryFees.save')}</button>
      </fieldset>
    </form>
  );
}

function RuleFields({
  form,
  setForm,
  currency,
}: {
  form: RuleForm;
  setForm: (form: RuleForm) => void;
  currency: string;
}) {
  const { t } = useTranslation();
  const setBand = (index: number, change: Partial<RuleForm['bands'][number]>) =>
    setForm({
      ...form,
      bands: form.bands.map((band, at) => (at === index ? { ...band, ...change } : band)),
    });
  return (
    <>
      <fieldset>
        <legend>{t('deliveryFees.kind')}</legend>
        <label>
          <input
            type="radio"
            checked={form.kind === 'flat'}
            onChange={() => setForm({ ...form, kind: 'flat' })}
          />
          {t('deliveryFees.flat')}
        </label>
        <label>
          <input
            type="radio"
            checked={form.kind === 'distance_bands'}
            onChange={() => setForm({ ...form, kind: 'distance_bands' })}
          />
          {t('deliveryFees.bands')}
        </label>
      </fieldset>
      {form.kind === 'flat' ? (
        <label>
          {t('deliveryFees.flatFee', { currency })}
          <input
            inputMode="decimal"
            value={form.flatFee}
            onChange={(event) => setForm({ ...form, flatFee: event.target.value })}
          />
        </label>
      ) : (
        <>
          {form.bands.map((band, index) => {
            const last = index === form.bands.length - 1;
            return (
              <fieldset key={index}>
                <legend>{t('deliveryFees.band', { number: index + 1 })}</legend>
                {last ? (
                  <p>{t('deliveryFees.lastBand')}</p>
                ) : (
                  <label>
                    {t('deliveryFees.upToKm')}
                    <input
                      inputMode="decimal"
                      value={band.upToKm}
                      onChange={(event) => setBand(index, { upToKm: event.target.value })}
                    />
                  </label>
                )}
                <label>
                  {t('deliveryFees.bandFee', { currency })}
                  <input
                    inputMode="decimal"
                    value={band.fee}
                    onChange={(event) => setBand(index, { fee: event.target.value })}
                  />
                </label>
                {form.bands.length > 1 && (
                  <button
                    type="button"
                    onClick={() =>
                      setForm({ ...form, bands: form.bands.filter((_, at) => at !== index) })
                    }
                  >
                    {t('deliveryFees.removeBand')}
                  </button>
                )}
              </fieldset>
            );
          })}
          <button
            type="button"
            onClick={() =>
              // A new band goes before the last one, which has no edge.
              setForm({
                ...form,
                bands: [...form.bands.slice(0, -1), { upToKm: '', fee: '' }, form.bands.at(-1)!],
              })
            }
          >
            {t('deliveryFees.addBand')}
          </button>
        </>
      )}
      <label>
        {t('deliveryFees.minimumFee', { currency })}
        <input
          inputMode="decimal"
          value={form.minimumFee}
          onChange={(event) => setForm({ ...form, minimumFee: event.target.value })}
        />
      </label>
      <label>
        {t('deliveryFees.freeDeliveryFrom', { currency })}
        <input
          inputMode="decimal"
          value={form.freeDeliveryFrom}
          onChange={(event) => setForm({ ...form, freeDeliveryFrom: event.target.value })}
        />
      </label>
      <p>{t('deliveryFees.emptyIsNone')}</p>
    </>
  );
}

function RestaurantRules({
  fees,
  city,
  manages,
}: {
  fees: DeliveryFees;
  city: City;
  manages: boolean;
}) {
  const { t } = useTranslation();
  const save = useSaveFeeRule(city.id);
  const own = fees.restaurants.filter((restaurant) => restaurant.ownRule !== null);
  return (
    <section aria-labelledby="fees-restaurants">
      <h2 id="fees-restaurants">{t('deliveryFees.restaurants')}</h2>
      <p>{t('deliveryFees.restaurantsExplain')}</p>
      {own.length === 0 ? (
        <p>{t('deliveryFees.noOwnRules')}</p>
      ) : (
        <ul>
          {own.map((restaurant) => (
            <li key={restaurant.id}>
              <h3>{restaurant.nameAr}</h3>
              <VersionLine version={restaurant.ownRule!} city={city} />
              <RuleSummary rule={restaurant.ownRule!.rule} />
              {manages && (
                <button
                  type="button"
                  disabled={save.isPending}
                  onClick={() =>
                    save.mutate({ restaurantId: restaurant.id, rule: null, reason: null })
                  }
                >
                  {t('deliveryFees.backToCity', { name: restaurant.nameAr })}
                </button>
              )}
            </li>
          ))}
        </ul>
      )}
      {save.isError && <p role="alert">{t('common.failed')}</p>}
      <SaveStatus result={save.data} />
      {manages && fees.baseCurrency !== null && fees.restaurants.length > 0 && (
        <RestaurantRuleForm fees={fees} city={city} currency={fees.baseCurrency} />
      )}
    </section>
  );
}

function RestaurantRuleForm({
  fees,
  city,
  currency,
}: {
  fees: DeliveryFees;
  city: City;
  currency: string;
}) {
  const { t } = useTranslation();
  const save = useSaveFeeRule(city.id);
  const [restaurantId, setRestaurantId] = useState('');
  const [form, setForm] = useState<RuleForm>(() => ruleFormOf(null, currency));
  const [reason, setReason] = useState('');
  const [problem, setProblem] = useState<RuleProblem | null>(null);
  const choose = (id: string) => {
    setRestaurantId(id);
    // The form starts from the restaurant's own rule, else the city's.
    const restaurant = fees.restaurants.find((each) => each.id === id);
    setForm(ruleFormOf(restaurant?.ownRule?.rule ?? fees.versions[0]?.rule ?? null, currency));
  };
  function submit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    if (restaurantId === '') return;
    const request = ruleRequestOf(form, currency);
    if ('problem' in request) {
      setProblem(request.problem);
      return;
    }
    setProblem(null);
    save.mutate({ restaurantId, rule: request.rule, reason: reason.trim() || null });
  }
  return (
    <form onSubmit={submit} aria-labelledby="fees-own-form">
      <h3 id="fees-own-form">{t('deliveryFees.ownRule')}</h3>
      <fieldset disabled={save.isPending}>
        <RestaurantSelect
          restaurants={fees.restaurants}
          value={restaurantId}
          onChange={choose}
          label={t('deliveryFees.restaurant')}
        />
        {restaurantId !== '' && (
          <>
            <RuleFields form={form} setForm={setForm} currency={currency} />
            <label>
              {t('deliveryFees.reasonField')}
              <input value={reason} onChange={(event) => setReason(event.target.value)} />
            </label>
            {problem && <p role="alert">{t(problemKeys[problem])}</p>}
            <button type="submit">{t('deliveryFees.saveOwn')}</button>
          </>
        )}
      </fieldset>
      {save.isError && <p role="alert">{t('common.failed')}</p>}
      <SaveStatus result={save.data} />
    </form>
  );
}

function RestaurantSelect({
  restaurants,
  value,
  onChange,
  label,
}: {
  restaurants: FeeRestaurant[];
  value: string;
  onChange: (id: string) => void;
  label: string;
}) {
  const { t } = useTranslation();
  return (
    <label>
      {label}
      <select value={value} onChange={(event) => onChange(event.target.value)}>
        <option value="">{t('deliveryFees.chooseRestaurant')}</option>
        {restaurants.map((restaurant) => (
          <option key={restaurant.id} value={restaurant.id}>
            {restaurant.nameAr}
          </option>
        ))}
      </select>
    </label>
  );
}

function PreviewCalculator({
  fees,
  city,
  currency,
}: {
  fees: DeliveryFees;
  city: City;
  currency: string;
}) {
  const { t } = useTranslation();
  const preview = usePreviewFee(city.id);
  const [restaurantId, setRestaurantId] = useState('');
  const [latitude, setLatitude] = useState('');
  const [longitude, setLongitude] = useState('');
  const [itemsValue, setItemsValue] = useState('');
  const [problem, setProblem] = useState<'point' | 'items' | null>(null);
  const restaurant = fees.restaurants.find((each) => each.id === restaurantId) ?? null;
  const lat = degreesOf(latitude, 90);
  const lng = degreesOf(longitude, 180);
  const pin = lat !== null && lng !== null ? { latitude: lat, longitude: lng } : null;
  function submit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    if (restaurant === null) return;
    if (pin === null) {
      setProblem('point');
      return;
    }
    const items = itemsValue.trim() === '' ? '0' : minorOf(itemsValue, currency);
    if (items === null) {
      setProblem('items');
      return;
    }
    setProblem(null);
    preview.mutate({ restaurantId: restaurant.id, ...pin, itemsValue: items });
  }
  return (
    <section aria-labelledby="fees-preview">
      <h2 id="fees-preview">{t('deliveryFees.preview.title')}</h2>
      <p>{t('deliveryFees.preview.explain')}</p>
      <form onSubmit={submit}>
        <fieldset disabled={preview.isPending}>
          <RestaurantSelect
            restaurants={fees.restaurants}
            value={restaurantId}
            onChange={setRestaurantId}
            label={t('deliveryFees.restaurant')}
          />
          {restaurant && (
            <>
              <Suspense fallback={<p role="status">{t('status.loading')}</p>}>
                <PinMap
                  pin={pin}
                  centre={restaurant.location}
                  onChange={(point) => {
                    setLatitude(point.latitude.toFixed(6));
                    setLongitude(point.longitude.toFixed(6));
                  }}
                />
              </Suspense>
              <label>
                {t('deliveryFees.preview.latitude')}
                <input
                  inputMode="decimal"
                  value={latitude}
                  onChange={(event) => setLatitude(event.target.value)}
                />
              </label>
              <label>
                {t('deliveryFees.preview.longitude')}
                <input
                  inputMode="decimal"
                  value={longitude}
                  onChange={(event) => setLongitude(event.target.value)}
                />
              </label>
              <label>
                {t('deliveryFees.preview.itemsValue', { currency })}
                <input
                  inputMode="decimal"
                  value={itemsValue}
                  onChange={(event) => setItemsValue(event.target.value)}
                />
              </label>
              {problem === 'point' && <p role="alert">{t('deliveryFees.preview.noPoint')}</p>}
              {problem === 'items' && <p role="alert">{t('deliveryFees.preview.badItems')}</p>}
              <button type="submit">{t('deliveryFees.preview.calculate')}</button>
            </>
          )}
        </fieldset>
      </form>
      {preview.isError && <p role="alert">{t('common.failed')}</p>}
      {preview.data && <PreviewAnswer result={preview.data} />}
    </section>
  );
}

function PreviewAnswer({ result }: { result: PreviewResult }) {
  const { t } = useTranslation();
  if (result.status === 'unpriced') {
    return <p role="alert">{t(unpricedKeys[result.refusal])}</p>;
  }
  const { preview } = result;
  return (
    <ul aria-label={t('deliveryFees.preview.result')}>
      <li>
        {preview.free
          ? t('deliveryFees.preview.free')
          : t('deliveryFees.preview.fee', {
              fee: formatMoney({ amount: preview.fee, currency: preview.currency }),
            })}
      </li>
      <li>
        {t(
          preview.distance.method === 'road'
            ? 'deliveryFees.preview.distanceRoad'
            : 'deliveryFees.preview.distanceStraight',
          { distance: formatDistance(preview.distance.metres) },
        )}
      </li>
      <li>
        {preview.scope === 'restaurant'
          ? t('deliveryFees.preview.ownRule')
          : t('deliveryFees.preview.cityRule')}
      </li>
      <li>
        {preview.zoneName === null
          ? t('deliveryFees.preview.outsideZones')
          : t('deliveryFees.preview.zone', { zone: preview.zoneName })}
      </li>
      {!preview.covers && <li>{t('deliveryFees.preview.notCovered')}</li>}
    </ul>
  );
}
