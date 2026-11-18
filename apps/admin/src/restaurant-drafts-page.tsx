import { useQuery } from '@tanstack/react-query';
import { getRouteApi, Link, useNavigate } from '@tanstack/react-router';
import { type FormEvent, lazy, Suspense, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { chosenCity, citiesQuery, type City } from './cities.js';
import { formatDateTime } from './format.js';
import {
  accountBody,
  type AccountForm,
  accountsQuery,
  basicsBody,
  basicsFormOf,
  canConfirmContract,
  canSaveStep,
  commissionBody,
  commissionFormOf,
  contractFormOf,
  contractProblem,
  degreesOf,
  type Draft,
  type DraftChoices,
  draftChoicesQuery,
  draftQuery,
  draftsQuery,
  locationBody,
  locationFormOf,
  operationsBody,
  operationsFormOf,
  type OperationsForm,
  type SaveResult,
  STEPS,
  type Step,
  stepsDone,
  useAccountCommand,
  useSaveStep,
  weekDays,
} from './restaurant-drafts.js';
import { IMAGE_TYPES } from './restaurant-images.js';
import { ImageField } from './restaurant-images-page.js';
import type { AdminSession } from './session.js';

// MapLibre is most of the bundle: it loads with the location step only.
const PinMap = lazy(() => import('./pin-map.js').then((module) => ({ default: module.PinMap })));

const listRoute = getRouteApi('/signed-in/restaurant-drafts');
const draftRoute = getRouteApi('/signed-in/restaurant-drafts/$restaurantId');
const signedIn = getRouteApi('/signed-in');

// «إضافة مطعم» (AP §9.6.3; slice 2.30a): the city's drafts, the latest
// saved first, and a new one. Unstyled until the design.
export function RestaurantDraftsPage() {
  const { t } = useTranslation();
  const { session } = signedIn.useRouteContext();
  const search = listRoute.useSearch();
  const navigate = useNavigate();
  const cities = useQuery(citiesQuery);
  const city = cities.data ? chosenCity(cities.data, search.city) : undefined;
  const drafts = useQuery({ ...draftsQuery(city?.id ?? ''), enabled: city !== undefined });
  const start = () =>
    void navigate({
      to: '/restaurant-drafts/$restaurantId',
      params: { restaurantId: crypto.randomUUID() },
      search: { ...(search.city ? { city: search.city } : {}), step: 'basics' },
    });
  return (
    <main>
      <h1>{t('drafts.title')}</h1>
      <p>
        <Link to="/">{t('common.home')}</Link>
      </p>
      <p>{t('drafts.explain')}</p>
      {canSaveStep(session, 'basics') && (
        <button type="button" onClick={start} disabled={city === undefined}>
          {t('drafts.new')}
        </button>
      )}
      <h2>{t('drafts.list')}</h2>
      {drafts.isError || cities.isError ? (
        <p role="alert">{t('common.failed')}</p>
      ) : !drafts.data || !city ? (
        <p role="status">{t('status.loading')}</p>
      ) : drafts.data.length === 0 ? (
        <p>{t('drafts.none')}</p>
      ) : (
        <ul>
          {drafts.data.map((draft) => (
            <li key={draft.id}>
              <Link
                to="/restaurant-drafts/$restaurantId"
                params={{ restaurantId: draft.id }}
                search={{ ...(search.city ? { city: search.city } : {}), step: 'basics' }}
              >
                {draft.nameAr}
              </Link>{' '}
              {t('drafts.savedAt', { time: formatDateTime(draft.updatedAt, city.timeZone) })}{' '}
              {t('drafts.progress', {
                done: Object.values(draft.steps).filter(Boolean).length,
                total: Object.keys(draft.steps).length,
              })}
            </li>
          ))}
        </ul>
      )}
    </main>
  );
}

// One draft: the steps as links, then the step asked for.
export function RestaurantDraftPage() {
  const { t } = useTranslation();
  const { session } = signedIn.useRouteContext();
  const { restaurantId } = draftRoute.useParams();
  const search = draftRoute.useSearch();
  const cities = useQuery(citiesQuery);
  const draft = useQuery(draftQuery(restaurantId));
  const city =
    cities.data && draft.data !== undefined
      ? (cities.data.find((each) => each.id === draft.data?.cityId) ??
        chosenCity(cities.data, search.city))
      : undefined;
  const choices = useQuery({ ...draftChoicesQuery(city?.id ?? ''), enabled: city !== undefined });
  const accounts = useQuery({ ...accountsQuery(restaurantId), enabled: draft.data != null });
  if (draft.isError || cities.isError || choices.isError) {
    return <p role="alert">{t('common.failed')}</p>;
  }
  if (draft.data === undefined || !city || !choices.data) {
    return <p role="status">{t('status.loading')}</p>;
  }
  const done = stepsDone(draft.data, accounts.data ?? []);
  // Before step 1 is saved, only step 1 opens.
  const step: Step = draft.data === null ? 'basics' : search.step;
  const stepSearch = (each: Step) => ({
    ...(search.city ? { city: search.city } : {}),
    step: each,
  });
  return (
    <main>
      <h1>{draft.data?.basics.nameAr ?? t('drafts.newTitle')}</h1>
      <p>
        <Link to="/restaurant-drafts" search={search.city ? { city: search.city } : {}}>
          {t('drafts.back')}
        </Link>
      </p>
      <nav aria-label={t('drafts.steps')}>
        <ol>
          {STEPS.map((each) => (
            <li key={each}>
              {draft.data === null && each !== 'basics' ? (
                t(`drafts.step.${each}`)
              ) : (
                <Link
                  to="/restaurant-drafts/$restaurantId"
                  params={{ restaurantId }}
                  search={stepSearch(each)}
                  aria-current={each === step ? 'step' : undefined}
                >
                  {t(`drafts.step.${each}`)}
                </Link>
              )}{' '}
              {done[each] ? t('drafts.done') : t('drafts.notDone')}
            </li>
          ))}
        </ol>
      </nav>
      <h2>{t(`drafts.step.${step}`)}</h2>
      {step === 'basics' ? (
        <BasicsStep
          key={restaurantId}
          restaurantId={restaurantId}
          draft={draft.data}
          city={city}
          choices={choices.data}
          session={session}
        />
      ) : draft.data === null ? null : step === 'location' ? (
        <LocationStep
          key={restaurantId}
          restaurantId={restaurantId}
          draft={draft.data}
          choices={choices.data}
          session={session}
        />
      ) : step === 'operations' ? (
        <OperationsStep
          key={restaurantId}
          restaurantId={restaurantId}
          draft={draft.data}
          choices={choices.data}
          session={session}
        />
      ) : step === 'commission' ? (
        <CommissionStep
          key={restaurantId}
          restaurantId={restaurantId}
          draft={draft.data}
          city={city}
          choices={choices.data}
          session={session}
        />
      ) : step === 'contract' ? (
        <ContractStep
          key={restaurantId}
          restaurantId={restaurantId}
          draft={draft.data}
          session={session}
        />
      ) : (
        <AccountsStep restaurantId={restaurantId} session={session} />
      )}
    </main>
  );
}

// The answer of a save: saved, the server's refusal, or a failure.
function SaveStatus({
  pending,
  failed,
  result,
  problem,
}: {
  pending: boolean;
  failed: boolean;
  result: SaveResult | undefined;
  problem: string | null;
}) {
  const { t } = useTranslation();
  if (problem !== null)
    return <p role="alert">{t(`drafts.problem.${problem}` as 'drafts.problem.invalid')}</p>;
  if (pending) return <p role="status">{t('drafts.saving')}</p>;
  if (failed) return <p role="alert">{t('common.failed')}</p>;
  if (result?.status === 'refused') {
    return (
      <p role="alert">
        {t(`drafts.refused.${result.refusal}` as 'drafts.refused.invalid', {
          defaultValue: t('drafts.refused.invalid'),
        })}
      </p>
    );
  }
  if (result?.status === 'saved') return <p role="status">{t('drafts.saved')}</p>;
  return null;
}

function BasicsStep(props: {
  restaurantId: string;
  draft: Draft | null;
  city: City;
  choices: DraftChoices;
  session: AdminSession;
}) {
  const { t } = useTranslation();
  const navigate = useNavigate();
  const [form, setForm] = useState(() => basicsFormOf(props.draft));
  const [problem, setProblem] = useState<string | null>(null);
  const save = useSaveStep(props.restaurantId);
  const editable = canSaveStep(props.session, 'basics');
  const submit = (event: FormEvent) => {
    event.preventDefault();
    const body = basicsBody(form, props.draft?.cityId ?? props.city.id);
    setProblem(body === null ? 'name' : null);
    if (body === null) return;
    save.mutate(
      { step: 'basics', body },
      {
        onSuccess: (result) => {
          if (result.status === 'saved' && props.draft === null) {
            void navigate({
              to: '/restaurant-drafts/$restaurantId',
              params: { restaurantId: props.restaurantId },
              search: { step: 'location', city: props.city.code },
            });
          }
        },
      },
    );
  };
  const toggle = (id: string) =>
    setForm({
      ...form,
      categoryIds: form.categoryIds.includes(id)
        ? form.categoryIds.filter((each) => each !== id)
        : [...form.categoryIds, id],
    });
  return (
    <>
      <form onSubmit={submit}>
        <fieldset disabled={!editable}>
          <label>
            {t('drafts.basics.nameAr')}
            <input
              value={form.nameAr}
              maxLength={props.choices.nameMax}
              required
              onChange={(event) => setForm({ ...form, nameAr: event.target.value })}
            />
          </label>
          <label>
            {t('drafts.basics.nameEn')}
            <input
              dir="ltr"
              value={form.nameEn}
              maxLength={props.choices.nameMax}
              onChange={(event) => setForm({ ...form, nameEn: event.target.value })}
            />
          </label>
          <fieldset>
            <legend>{t('drafts.basics.categories', { max: props.choices.categoriesMax })}</legend>
            {props.choices.categories.map((category) => (
              <label key={category.id}>
                <input
                  type="checkbox"
                  checked={form.categoryIds.includes(category.id)}
                  disabled={
                    !form.categoryIds.includes(category.id) &&
                    form.categoryIds.length >= props.choices.categoriesMax
                  }
                  onChange={() => toggle(category.id)}
                />
                {category.name}
              </label>
            ))}
          </fieldset>
          <label>
            {t('drafts.basics.description')}
            <textarea
              value={form.description}
              maxLength={props.choices.descriptionMax}
              onChange={(event) => setForm({ ...form, description: event.target.value })}
            />
          </label>
          <button type="submit" disabled={save.isPending}>
            {t('drafts.save')}
          </button>
        </fieldset>
      </form>
      <SaveStatus
        pending={save.isPending}
        failed={save.isError}
        result={save.data}
        problem={problem}
      />
      {props.draft === null ? (
        <p>{t('drafts.basics.imagesAfter')}</p>
      ) : (
        <>
          <ImageField
            label={t('images.logo')}
            imageKey={props.draft.basics.logoKey}
            width={160}
            target={{ kind: 'logo', restaurantId: props.restaurantId }}
            editable={editable}
          />
          <ImageField
            label={t('images.cover')}
            imageKey={props.draft.basics.coverKey}
            width={640}
            target={{ kind: 'cover', restaurantId: props.restaurantId }}
            editable={editable}
          />
        </>
      )}
    </>
  );
}

function LocationStep(props: {
  restaurantId: string;
  draft: Draft;
  choices: DraftChoices;
  session: AdminSession;
}) {
  const { t } = useTranslation();
  const [form, setForm] = useState(() => locationFormOf(props.draft));
  const [problem, setProblem] = useState<string | null>(null);
  const save = useSaveStep(props.restaurantId);
  const editable = canSaveStep(props.session, 'location');
  const latitude = degreesOf(form.latitude, 90);
  const longitude = degreesOf(form.longitude, 180);
  const pin = latitude !== null && longitude !== null ? { latitude, longitude } : null;
  const submit = (event: FormEvent) => {
    event.preventDefault();
    const request = locationBody(form);
    setProblem('problem' in request ? request.problem : null);
    if ('body' in request) save.mutate({ step: 'location', body: request.body });
  };
  return (
    <>
      <p>{t('drafts.location.explain')}</p>
      <Suspense fallback={<p role="status">{t('status.loading')}</p>}>
        <PinMap
          pin={pin}
          centre={props.choices.centre}
          onChange={(point) =>
            editable &&
            setForm({
              ...form,
              latitude: point.latitude.toFixed(6),
              longitude: point.longitude.toFixed(6),
            })
          }
        />
      </Suspense>
      <form onSubmit={submit}>
        <fieldset disabled={!editable}>
          <label>
            {t('drafts.location.latitude')}
            <input
              dir="ltr"
              inputMode="decimal"
              value={form.latitude}
              onChange={(event) => setForm({ ...form, latitude: event.target.value })}
            />
          </label>
          <label>
            {t('drafts.location.longitude')}
            <input
              dir="ltr"
              inputMode="decimal"
              value={form.longitude}
              onChange={(event) => setForm({ ...form, longitude: event.target.value })}
            />
          </label>
          <label>
            {t('drafts.location.address')}
            <input
              value={form.address}
              maxLength={props.choices.addressMax}
              onChange={(event) => setForm({ ...form, address: event.target.value })}
            />
          </label>
          <label>
            {t('drafts.location.phone')}
            <input
              dir="ltr"
              inputMode="tel"
              value={form.phone}
              onChange={(event) => setForm({ ...form, phone: event.target.value })}
            />
          </label>
          <label>
            {t('drafts.location.ownerName')}
            <input
              value={form.ownerName}
              maxLength={props.choices.nameMax}
              onChange={(event) => setForm({ ...form, ownerName: event.target.value })}
            />
          </label>
          <p>{t('drafts.location.ownerPhone')}</p>
          <button type="submit" disabled={save.isPending}>
            {t('drafts.save')}
          </button>
        </fieldset>
      </form>
      <SaveStatus
        pending={save.isPending}
        failed={save.isError}
        result={save.data}
        problem={problem}
      />
    </>
  );
}

function OperationsStep(props: {
  restaurantId: string;
  draft: Draft;
  choices: DraftChoices;
  session: AdminSession;
}) {
  const { t } = useTranslation();
  const [form, setForm] = useState<OperationsForm>(() =>
    operationsFormOf(props.draft, props.choices),
  );
  const [problem, setProblem] = useState<string | null>(null);
  const save = useSaveStep(props.restaurantId);
  const editable = canSaveStep(props.session, 'operations');
  const setPeriod = (
    day: (typeof weekDays)[number],
    index: number,
    part: 'from' | 'to',
    value: string,
  ) =>
    setForm({
      ...form,
      days: {
        ...form.days,
        [day]: form.days[day].map((each, at) => (at === index ? { ...each, [part]: value } : each)),
      },
    });
  const submit = (event: FormEvent) => {
    event.preventDefault();
    const request = operationsBody(form, props.choices.baseCurrency);
    setProblem('problem' in request ? request.problem : null);
    if ('body' in request) save.mutate({ step: 'operations', body: request.body });
  };
  return (
    <>
      <form onSubmit={submit}>
        <fieldset disabled={!editable}>
          <fieldset>
            <legend>{t('drafts.operations.hours')}</legend>
            <p>{t('drafts.operations.hoursExplain')}</p>
            {weekDays.map((day) => (
              <fieldset key={day}>
                <legend>{t(`office.day.${day}`)}</legend>
                {form.days[day].length === 0 && <p>{t('drafts.operations.dayOff')}</p>}
                {form.days[day].map((period, index) => (
                  <p key={index}>
                    <label>
                      {t('drafts.operations.from')}
                      <input
                        type="time"
                        value={period.from}
                        onChange={(event) => setPeriod(day, index, 'from', event.target.value)}
                      />
                    </label>
                    <label>
                      {t('drafts.operations.to')}
                      <input
                        type="time"
                        value={period.to}
                        onChange={(event) => setPeriod(day, index, 'to', event.target.value)}
                      />
                    </label>
                    <button
                      type="button"
                      onClick={() =>
                        setForm({
                          ...form,
                          days: {
                            ...form.days,
                            [day]: form.days[day].filter((_each, at) => at !== index),
                          },
                        })
                      }
                    >
                      {t('drafts.operations.removePeriod')}
                    </button>
                  </p>
                ))}
                <button
                  type="button"
                  onClick={() =>
                    setForm({
                      ...form,
                      days: { ...form.days, [day]: [...form.days[day], { from: '', to: '' }] },
                    })
                  }
                >
                  {t('drafts.operations.addPeriod')}
                </button>
              </fieldset>
            ))}
          </fieldset>
          <label>
            {t('drafts.operations.prep', {
              floor: props.choices.prepFloorMin,
              ceiling: props.choices.prepCeilingMin,
            })}
            <input
              dir="ltr"
              inputMode="numeric"
              value={form.defaultPrepMin}
              onChange={(event) => setForm({ ...form, defaultPrepMin: event.target.value })}
            />
          </label>
          <label>
            {t('drafts.operations.minimum', { currency: props.choices.baseCurrency ?? '' })}
            <input
              dir="ltr"
              inputMode="decimal"
              value={form.minimumOrder}
              onChange={(event) => setForm({ ...form, minimumOrder: event.target.value })}
            />
          </label>
          <fieldset>
            <legend>{t('drafts.operations.coverage')}</legend>
            <label>
              <input
                type="radio"
                name="coverage"
                checked={form.coverage === 'radius'}
                onChange={() => setForm({ ...form, coverage: 'radius' })}
              />
              {t('drafts.operations.radius')}
            </label>
            {form.coverage === 'radius' && (
              <label>
                {t('drafts.operations.radiusKm')}
                <input
                  dir="ltr"
                  inputMode="decimal"
                  value={form.radiusKm}
                  onChange={(event) => setForm({ ...form, radiusKm: event.target.value })}
                />
              </label>
            )}
            <label>
              <input
                type="radio"
                name="coverage"
                checked={form.coverage === 'zones'}
                onChange={() => setForm({ ...form, coverage: 'zones' })}
              />
              {t('drafts.operations.zones')}
            </label>
            {form.coverage === 'zones' &&
              props.choices.zones.map((zone) => (
                <label key={zone.id}>
                  <input
                    type="checkbox"
                    checked={form.zoneIds.includes(zone.id)}
                    onChange={() =>
                      setForm({
                        ...form,
                        zoneIds: form.zoneIds.includes(zone.id)
                          ? form.zoneIds.filter((each) => each !== zone.id)
                          : [...form.zoneIds, zone.id],
                      })
                    }
                  />
                  {zone.name}
                </label>
              ))}
          </fieldset>
          <button type="submit" disabled={save.isPending}>
            {t('drafts.save')}
          </button>
        </fieldset>
      </form>
      <SaveStatus
        pending={save.isPending}
        failed={save.isError}
        result={save.data}
        problem={problem}
      />
    </>
  );
}

function CommissionStep(props: {
  restaurantId: string;
  draft: Draft;
  city: City;
  choices: DraftChoices;
  session: AdminSession;
}) {
  const { t } = useTranslation();
  const [form, setForm] = useState(() =>
    commissionFormOf(props.draft, props.choices, props.city.timeZone),
  );
  const [problem, setProblem] = useState<string | null>(null);
  const save = useSaveStep(props.restaurantId);
  const editable = canSaveStep(props.session, 'commission');
  const submit = (event: FormEvent) => {
    event.preventDefault();
    const request = commissionBody(form, props.city.timeZone);
    setProblem('problem' in request ? request.problem : null);
    if ('body' in request) save.mutate({ step: 'commission', body: request.body });
  };
  return (
    <>
      {!editable && <p>{t('drafts.commission.ownOnly')}</p>}
      <form onSubmit={submit}>
        <fieldset disabled={!editable}>
          <label>
            {t('drafts.commission.rate')}
            <input
              dir="ltr"
              inputMode="decimal"
              value={form.rate}
              onChange={(event) => setForm({ ...form, rate: event.target.value })}
            />
          </label>
          <label>
            <input
              type="checkbox"
              checked={form.launch}
              onChange={(event) => setForm({ ...form, launch: event.target.checked })}
            />
            {t('drafts.commission.launch')}
          </label>
          {form.launch && (
            <>
              <label>
                {t('drafts.commission.launchRate')}
                <input
                  dir="ltr"
                  inputMode="decimal"
                  value={form.launchRate}
                  onChange={(event) => setForm({ ...form, launchRate: event.target.value })}
                />
              </label>
              <label>
                {t('drafts.commission.standardFrom')}
                <input
                  type="date"
                  value={form.standardFrom}
                  onChange={(event) => setForm({ ...form, standardFrom: event.target.value })}
                />
              </label>
            </>
          )}
          <button type="submit" disabled={save.isPending}>
            {t('drafts.save')}
          </button>
        </fieldset>
      </form>
      <p>{t('drafts.commission.terms')}</p>
      <SaveStatus
        pending={save.isPending}
        failed={save.isError}
        result={save.data}
        problem={problem}
      />
    </>
  );
}

function ContractStep(props: { restaurantId: string; draft: Draft; session: AdminSession }) {
  const { t } = useTranslation();
  const [form, setForm] = useState(() => contractFormOf(props.draft));
  const [pledge, setPledge] = useState(false);
  const [problem, setProblem] = useState<string | null>(null);
  const save = useSaveStep(props.restaurantId);
  const confirm = useSaveStep(props.restaurantId);
  const editable = canSaveStep(props.session, 'contract');
  const contract = props.draft.contract;
  const submit = (event: FormEvent) => {
    event.preventDefault();
    const found = contractProblem(form);
    setProblem(found);
    if (found === null) {
      save.mutate(
        { step: 'contract', form },
        { onSuccess: () => setForm({ ...form, contractFile: null, licenceFile: null }) },
      );
    }
  };
  return (
    <>
      <form onSubmit={submit}>
        <fieldset disabled={!editable}>
          <label>
            {t('drafts.contract.signedOn')}
            <input
              type="date"
              value={form.signedOn}
              onChange={(event) => setForm({ ...form, signedOn: event.target.value })}
            />
          </label>
          <label>
            {t('drafts.contract.duration')}
            <input
              dir="ltr"
              inputMode="numeric"
              value={form.durationMonths}
              onChange={(event) => setForm({ ...form, durationMonths: event.target.value })}
            />
          </label>
          <Scan
            label={t('drafts.contract.contractScan')}
            url={contract?.contractUrl ?? null}
            onPick={(file) => setForm({ ...form, contractFile: file })}
          />
          <Scan
            label={t('drafts.contract.licenceScan')}
            url={contract?.licenceUrl ?? null}
            onPick={(file) => setForm({ ...form, licenceFile: file })}
          />
          <button type="submit" disabled={save.isPending}>
            {t('drafts.save')}
          </button>
        </fieldset>
      </form>
      <SaveStatus
        pending={save.isPending}
        failed={save.isError}
        result={save.data}
        problem={problem}
      />
      <h3>{t('drafts.contract.confirmTitle')}</h3>
      {contract?.confirmedAt ? (
        <p role="status">{t('drafts.contract.confirmed')}</p>
      ) : canConfirmContract(props.session) ? (
        <>
          <label>
            <input
              type="checkbox"
              checked={pledge}
              onChange={(event) => setPledge(event.target.checked)}
            />
            {t('drafts.contract.pledge')}
          </label>
          <button
            type="button"
            disabled={!pledge || confirm.isPending || contract === null}
            onClick={() => confirm.mutate({ step: 'confirm' })}
          >
            {t('drafts.contract.confirm')}
          </button>
          <SaveStatus
            pending={confirm.isPending}
            failed={confirm.isError}
            result={confirm.data}
            problem={null}
          />
        </>
      ) : (
        <p>{t('drafts.contract.confirmByOps')}</p>
      )}
    </>
  );
}

function Scan(props: { label: string; url: string | null; onPick: (file: File | null) => void }) {
  const { t } = useTranslation();
  return (
    <section aria-label={props.label}>
      <h3>{props.label}</h3>
      {props.url ? (
        <img src={props.url} alt={props.label} width={320} />
      ) : (
        <p>{t('images.none')}</p>
      )}
      <label>
        {props.url ? t('images.replace') : t('images.upload')}
        <input
          type="file"
          accept={IMAGE_TYPES.join(',')}
          onChange={(event) => props.onPick(event.target.files?.[0] ?? null)}
        />
      </label>
    </section>
  );
}

function AccountsStep(props: { restaurantId: string; session: AdminSession }) {
  const { t } = useTranslation();
  const accounts = useQuery(accountsQuery(props.restaurantId));
  const command = useAccountCommand(props.restaurantId);
  const [form, setForm] = useState<AccountForm>({ role: 'owner', name: '', phone: '' });
  const [problem, setProblem] = useState(false);
  const editable = canSaveStep(props.session, 'accounts');
  const submit = (event: FormEvent) => {
    event.preventDefault();
    const body = accountBody(form);
    setProblem(body === null);
    if (body !== null) {
      command.mutate(
        { add: body },
        {
          onSuccess: (result) => {
            if (result.status === 'saved') setForm({ role: 'cashier', name: '', phone: '' });
          },
        },
      );
    }
  };
  if (accounts.isError) return <p role="alert">{t('common.failed')}</p>;
  if (!accounts.data) return <p role="status">{t('status.loading')}</p>;
  const result = command.data;
  return (
    <>
      <p>{t('drafts.accounts.explain')}</p>
      {accounts.data.length === 0 ? (
        <p>{t('drafts.accounts.none')}</p>
      ) : (
        <ul>
          {accounts.data.map((account) => (
            <li key={account.id}>
              {t(`drafts.accounts.role.${account.role}`)} {account.name}{' '}
              <bdi dir="ltr">{account.phone}</bdi>{' '}
              {editable && (
                <button
                  type="button"
                  disabled={command.isPending}
                  onClick={() => command.mutate({ remove: account.id })}
                >
                  {t('drafts.accounts.remove')}
                </button>
              )}
            </li>
          ))}
        </ul>
      )}
      {editable ? (
        <form onSubmit={submit}>
          <label>
            {t('drafts.accounts.roleLabel')}
            <select
              value={form.role}
              onChange={(event) =>
                setForm({ ...form, role: event.target.value as AccountForm['role'] })
              }
            >
              <option value="owner">{t('drafts.accounts.role.owner')}</option>
              <option value="cashier">{t('drafts.accounts.role.cashier')}</option>
            </select>
          </label>
          <label>
            {t('drafts.accounts.name')}
            <input
              value={form.name}
              maxLength={80}
              onChange={(event) => setForm({ ...form, name: event.target.value })}
            />
          </label>
          <label>
            {t('drafts.accounts.phone')}
            <input
              dir="ltr"
              inputMode="tel"
              value={form.phone}
              onChange={(event) => setForm({ ...form, phone: event.target.value })}
            />
          </label>
          <button type="submit" disabled={command.isPending}>
            {t('drafts.accounts.add')}
          </button>
        </form>
      ) : (
        <p>{t('drafts.accounts.opsOnly')}</p>
      )}
      {problem ? (
        <p role="alert">{t('drafts.problem.account')}</p>
      ) : command.isPending ? (
        <p role="status">{t('drafts.saving')}</p>
      ) : command.isError ? (
        <p role="alert">{t('common.failed')}</p>
      ) : result?.status === 'refused' ? (
        <p role="alert">
          {t(`drafts.refused.${result.refusal}` as 'drafts.refused.invalid', {
            defaultValue: t('drafts.refused.invalid'),
          })}
        </p>
      ) : null}
    </>
  );
}
