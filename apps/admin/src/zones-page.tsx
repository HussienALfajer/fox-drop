import { useQuery } from '@tanstack/react-query';
import { getRouteApi, Link } from '@tanstack/react-router';
import { type FormEvent, lazy, Suspense, useMemo, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { chosenCity, citiesQuery } from './cities.js';
import { useCityOffice, ZONES_MANAGE } from './office.js';
import { can } from './session.js';
import {
  type CityZones,
  cornersOf,
  cornersText,
  mapCentre,
  newZoneForm,
  type Point,
  useCityZones,
  useSaveZone,
  voteCount,
  withoutLastCorner,
  type Zone,
  type ZoneForm,
  zoneFormOf,
  type ZoneProblem,
  type ZoneRefusal,
  zoneRequestOf,
} from './zones.js';

const ZoneMap = lazy(() => import('./zone-map.js').then((module) => ({ default: module.ZoneMap })));

const route = getRouteApi('/signed-in/zones');
const signedIn = getRouteApi('/signed-in');

const problemKeys = {
  name: 'zones.problem.name',
  corners: 'zones.problem.corners',
} as const satisfies Record<ZoneProblem, string>;

const refusalKeys = {
  invalid_name: 'zones.refused.invalid_name',
  invalid_area: 'zones.refused.invalid_area',
  zone_name_taken: 'zones.refused.zone_name_taken',
  zones_overlap: 'zones.refused.zones_overlap',
  unknown_zone: 'zones.refused.unknown_zone',
} as const satisfies Record<ZoneRefusal, string>;

// The votes listed under the map, the most voted first.
const VOTES_LISTED = 20;

// AP §9.12.2 «مناطق الخدمة» (slice 2.37c): the city's neighbourhoods and
// the votes from outside them; OWN draws, edits and activates a zone.
// Unstyled until the design.
export function ZonesPage() {
  const { t } = useTranslation();
  const search = route.useSearch();
  const cities = useQuery(citiesQuery);
  const city = cities.data ? chosenCity(cities.data, search.city) : undefined;
  const zones = useCityZones(city?.id);
  return (
    <main>
      <h1>{t('zones.title')}</h1>
      <p>
        <Link to="/">{t('common.home')}</Link>
      </p>
      <p>{t('zones.explain')}</p>
      {zones.isError || cities.isError ? (
        <p role="alert">{t('common.failed')}</p>
      ) : !city || !zones.data ? (
        <p role="status">{t('status.loading')}</p>
      ) : (
        <ZonesView key={city.id} cityId={city.id} data={zones.data} />
      )}
    </main>
  );
}

function ZonesView({ cityId, data }: { cityId: string; data: CityZones }) {
  const { t } = useTranslation();
  const { session } = signedIn.useRouteContext();
  const manage = can(session, ZONES_MANAGE);
  const save = useSaveZone(cityId);
  const [form, setForm] = useState<ZoneForm | null>(null);
  // A city's first zone starts from its office's point (zones.read too).
  const office = useCityOffice(cityId);
  const centre = useMemo(
    () => mapCentre(data.zones, data.votes) ?? office.data?.office?.location ?? null,
    [data, office.data],
  );
  const edit = (next: ZoneForm) => {
    save.reset();
    setForm(next);
  };

  const toggle = (zone: Zone) =>
    save.mutate({
      id: zone.id,
      body: { name: zone.name, area: zone.area, active: !zone.active, reason: null },
    });

  return (
    <>
      <Suspense fallback={<p role="status">{t('status.loading')}</p>}>
        <ZoneMap
          zones={data.zones}
          votes={data.votes}
          centre={centre ?? form?.corners[0] ?? null}
          editing={form && { id: form.id, corners: form.corners }}
          onCorners={(corners) => setForm((current) => current && { ...current, corners })}
        />
      </Suspense>
      <section aria-labelledby="zones-list">
        <h2 id="zones-list">{t('zones.list')}</h2>
        {data.zones.length === 0 ? (
          <p>{t('zones.none')}</p>
        ) : (
          <ul>
            {data.zones.map((zone) => (
              <li key={zone.id}>
                {t('zones.line', {
                  name: zone.name,
                  state: t(zone.active ? 'zones.active' : 'zones.inactive'),
                  corners: zone.area.length,
                })}
                {manage && form === null && (
                  <>
                    {' '}
                    <button type="button" onClick={() => edit(zoneFormOf(zone))}>
                      {t('zones.edit', { name: zone.name })}
                    </button>{' '}
                    <button type="button" disabled={save.isPending} onClick={() => toggle(zone)}>
                      {t(zone.active ? 'zones.deactivate' : 'zones.activate', { name: zone.name })}
                    </button>
                  </>
                )}
              </li>
            ))}
          </ul>
        )}
        {manage && form === null && (
          <button type="button" onClick={() => edit(newZoneForm(crypto.randomUUID()))}>
            {t('zones.draw')}
          </button>
        )}
        {form === null && save.data?.status === 'refused' && (
          <p role="alert">{t(refusalKeys[save.data.refusal])}</p>
        )}
        {save.isError && <p role="alert">{t('common.failed')}</p>}
      </section>
      {form && (
        <ZoneEditor
          key={form.id}
          form={form}
          isNew={!data.zones.some((zone) => zone.id === form.id)}
          onChange={setForm}
          onDone={() => setForm(null)}
          save={save}
        />
      )}
      <Votes votes={data.votes} />
    </>
  );
}

function ZoneEditor(props: {
  form: ZoneForm;
  isNew: boolean;
  onChange: (form: ZoneForm) => void;
  onDone: () => void;
  save: ReturnType<typeof useSaveZone>;
}) {
  const { t } = useTranslation();
  const { form, save } = props;
  // The text follows the map until it is typed in; a line that is not a
  // point keeps the corners as they were.
  const [typed, setTyped] = useState<string | null>(null);
  const [problem, setProblem] = useState<ZoneProblem | null>(null);
  const text = typed ?? cornersText(form.corners);
  const unreadable = typed !== null && cornersOf(typed) === null;
  const setCorners = (corners: Point[]) => {
    setTyped(null);
    props.onChange({ ...form, corners });
  };

  const submit = (event: FormEvent) => {
    event.preventDefault();
    if (unreadable) {
      setProblem('corners');
      return;
    }
    const request = zoneRequestOf(form);
    if ('problem' in request) {
      setProblem(request.problem);
      return;
    }
    setProblem(null);
    save.mutate(
      { id: form.id, body: request.body },
      { onSuccess: (result) => result.status === 'saved' && props.onDone() },
    );
  };

  return (
    <form onSubmit={submit} aria-labelledby="zone-editor">
      <h2 id="zone-editor">{t(props.isNew ? 'zones.newTitle' : 'zones.editTitle')}</h2>
      <p>{t('zones.howToDraw')}</p>
      <label>
        {t('zones.name')}
        <input
          value={form.name}
          maxLength={100}
          onChange={(event) => props.onChange({ ...form, name: event.target.value })}
        />
      </label>
      <p>{t('zones.nameExplain')}</p>
      <label>
        {t('zones.corners')}
        <textarea
          value={text}
          rows={6}
          dir="ltr"
          onChange={(event) => {
            setTyped(event.target.value);
            const corners = cornersOf(event.target.value);
            if (corners) props.onChange({ ...form, corners });
          }}
        />
      </label>
      <p>{t('zones.cornersExplain', { count: form.corners.length })}</p>
      {unreadable && <p role="alert">{t('zones.problem.unreadable')}</p>}
      <button
        type="button"
        disabled={form.corners.length === 0}
        onClick={() => setCorners(withoutLastCorner(form.corners))}
      >
        {t('zones.removeLast')}
      </button>
      <label>
        <input
          type="checkbox"
          checked={form.active}
          onChange={(event) => props.onChange({ ...form, active: event.target.checked })}
        />
        {t('zones.activeLabel')}
      </label>
      <label>
        {t('zones.reason')}
        <input
          value={form.reason}
          maxLength={500}
          onChange={(event) => props.onChange({ ...form, reason: event.target.value })}
        />
      </label>
      {problem && <p role="alert">{t(problemKeys[problem])}</p>}
      {save.data?.status === 'refused' && <p role="alert">{t(refusalKeys[save.data.refusal])}</p>}
      <button type="submit" disabled={save.isPending}>
        {t('zones.save')}
      </button>{' '}
      <button type="button" onClick={props.onDone}>
        {t('zones.cancel')}
      </button>
    </form>
  );
}

function Votes({ votes }: { votes: CityZones['votes'] }) {
  const { t } = useTranslation();
  return (
    <section aria-labelledby="zone-votes">
      <h2 id="zone-votes">{t('zones.votes')}</h2>
      <p>{t('zones.votesExplain')}</p>
      {votes.length === 0 ? (
        <p>{t('zones.noVotes')}</p>
      ) : (
        <>
          <p>{t('zones.voteTotal', { count: voteCount(votes), cells: votes.length })}</p>
          <ol>
            {votes.slice(0, VOTES_LISTED).map((cell) => (
              <li key={[cell.latitude, cell.longitude].join()}>
                {t('zones.voteCell', {
                  latitude: cell.latitude,
                  longitude: cell.longitude,
                  count: cell.votes,
                })}
              </li>
            ))}
          </ol>
        </>
      )}
    </section>
  );
}
