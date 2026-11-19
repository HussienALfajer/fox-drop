import { useInfiniteQuery, useQuery } from '@tanstack/react-query';
import { getRouteApi, Link, useNavigate } from '@tanstack/react-router';
import { type FormEvent, useState } from 'react';
import { useTranslation } from 'react-i18next';
import {
  type ActorType,
  actorTypes,
  type AuditEvent,
  auditActionOf,
  auditActions,
  auditActorsQuery,
  auditLogQuery,
  auditLogQueryOf,
  type AuditLogSearch,
  auditLogSearchOf,
  targetTypeOf,
  targetTypes,
  valueText,
} from './audit-log.js';
import { type City, chosenCity, citiesQuery } from './cities.js';
import { formatDateTime } from './format.js';

const route = getRouteApi('/signed-in/audit-log');

// AP §9.16 «سجل التدقيق» (OWN; slice 2.38a): every write and sensitive view,
// newest first, filtered by actor, action, target and dates (business days
// on the chosen city's clock). Read only: nobody edits or deletes the log.
// Unstyled until the design.
export function AuditLogPage() {
  const { t } = useTranslation();
  const search = route.useSearch();
  const cities = useQuery(citiesQuery);
  const city = cities.data ? chosenCity(cities.data, search.city) : undefined;
  return (
    <main>
      <h1>{t('auditLog.title')}</h1>
      <p>
        <Link to="/">{t('common.home')}</Link>
      </p>
      <p>{t('auditLog.explain')}</p>
      {cities.isError ? <p role="alert">{t('common.failed')}</p> : null}
      {city && cities.data && (
        <>
          <Filters key={JSON.stringify(search)} search={search} />
          <Events search={search} city={city} cities={cities.data} />
        </>
      )}
    </main>
  );
}

function Filters({ search }: { search: AuditLogSearch }) {
  const { t } = useTranslation();
  const navigate = useNavigate({ from: '/audit-log' });
  const actors = useQuery(auditActorsQuery);
  const [form, setForm] = useState<AuditLogSearch>(search);
  const set = (field: keyof AuditLogSearch, value: string) =>
    setForm((before) => ({ ...before, [field]: value === '' ? undefined : value }));
  const apply = (event: FormEvent) => {
    event.preventDefault();
    void navigate({ search: auditLogSearchOf({ ...form, city: search.city }) });
  };
  return (
    <form onSubmit={apply} aria-label={t('auditLog.filters')}>
      <label>
        {t('auditLog.actorType')}
        <select
          value={form.actorType ?? ''}
          onChange={(event) => set('actorType', event.target.value)}
        >
          <option value="">{t('auditLog.all')}</option>
          {actorTypes.map((type) => (
            <option key={type} value={type}>
              {t(`auditLog.actorTypes.${type}`)}
            </option>
          ))}
        </select>
      </label>
      {actors.data && (
        <label>
          {t('auditLog.actor')}
          <select
            value={form.actorId ?? ''}
            onChange={(event) => set('actorId', event.target.value)}
          >
            <option value="">{t('auditLog.all')}</option>
            {actors.data.map((actor) => (
              <option key={actor.id} value={actor.id}>
                {actor.name}
              </option>
            ))}
          </select>
        </label>
      )}
      <label>
        {t('auditLog.action')}
        <select value={form.action ?? ''} onChange={(event) => set('action', event.target.value)}>
          <option value="">{t('auditLog.all')}</option>
          {auditActions.map((action) => (
            <option key={action} value={action}>
              {t(`auditLog.actions.${action}`)}
            </option>
          ))}
        </select>
      </label>
      <label>
        {t('auditLog.targetType')}
        <select
          value={form.targetType ?? ''}
          onChange={(event) => set('targetType', event.target.value)}
        >
          <option value="">{t('auditLog.all')}</option>
          {targetTypes.map((type) => (
            <option key={type} value={type}>
              {t(`auditLog.targets.${type}`)}
            </option>
          ))}
        </select>
      </label>
      <label>
        {t('auditLog.targetId')}
        <input
          value={form.targetId ?? ''}
          onChange={(event) => set('targetId', event.target.value.trim())}
          dir="ltr"
        />
      </label>
      <label>
        {t('auditLog.from')}
        <input
          type="date"
          value={form.from ?? ''}
          onChange={(event) => set('from', event.target.value)}
        />
      </label>
      <label>
        {t('auditLog.to')}
        <input
          type="date"
          value={form.to ?? ''}
          onChange={(event) => set('to', event.target.value)}
        />
      </label>
      <button type="submit">{t('auditLog.show')}</button>
    </form>
  );
}

function Events({ search, city, cities }: { search: AuditLogSearch; city: City; cities: City[] }) {
  const { t } = useTranslation();
  const log = useInfiniteQuery(auditLogQuery(auditLogQueryOf(search, city.timeZone)));
  if (log.isError) return <p role="alert">{t('common.failed')}</p>;
  if (!log.data) return null;
  const events = log.data.pages.flatMap((page) => page.events);
  return (
    <section aria-label={t('auditLog.events')}>
      {events.length === 0 ? (
        <p>{t('auditLog.none')}</p>
      ) : (
        <table>
          <thead>
            <tr>
              <th>{t('auditLog.at')}</th>
              <th>{t('auditLog.actor')}</th>
              <th>{t('auditLog.city')}</th>
              <th>{t('auditLog.action')}</th>
              <th>{t('auditLog.target')}</th>
              <th>{t('auditLog.changes')}</th>
              <th>{t('auditLog.reason')}</th>
              <th>{t('auditLog.source')}</th>
            </tr>
          </thead>
          <tbody>
            {events.map((event) => (
              <EventRow key={event.id} event={event} city={city} cities={cities} />
            ))}
          </tbody>
        </table>
      )}
      {log.hasNextPage && (
        <button
          type="button"
          disabled={log.isFetchingNextPage}
          onClick={() => void log.fetchNextPage()}
        >
          {t('auditLog.more')}
        </button>
      )}
    </section>
  );
}

function EventRow({ event, city, cities }: { event: AuditEvent; city: City; cities: City[] }) {
  const { t } = useTranslation();
  const action = auditActionOf(event.action);
  const target = targetTypeOf(event.targetType);
  const eventCity = cities.find((each) => each.id === event.cityId);
  const actorType: ActorType = event.actorType;
  return (
    <tr>
      <td>{formatDateTime(event.at, city.timeZone)}</td>
      <td>
        {event.actorName ?? t(`auditLog.actorTypes.${actorType}`)}
        {event.actorRole !== null && (
          <>
            {' '}
            <bdi dir="ltr">{event.actorRole}</bdi>
          </>
        )}
      </td>
      <td>
        {event.cityId === null ? t('auditLog.wholePlatform') : (eventCity?.name ?? event.cityId)}
      </td>
      <td>
        {action === null ? <code dir="ltr">{event.action}</code> : t(`auditLog.actions.${action}`)}
        {event.kind === 'view' && <> {t('auditLog.view')}</>}
      </td>
      <td>
        {target === null ? (
          <code dir="ltr">{event.targetType}</code>
        ) : (
          t(`auditLog.targets.${target}`)
        )}{' '}
        <code dir="ltr">{event.targetId}</code>
      </td>
      <td>
        {event.changes.length > 0 && (
          <ul>
            {event.changes.map((change) => (
              <li key={change.field}>
                {t('auditLog.fromTo', {
                  field: change.field,
                  before: valueText(change.before) ?? t('auditLog.empty'),
                  after: valueText(change.after) ?? t('auditLog.empty'),
                })}
              </li>
            ))}
          </ul>
        )}
      </td>
      <td>{event.reason ?? '—'}</td>
      <td>
        {event.ipAddress !== null && <bdi dir="ltr">{event.ipAddress}</bdi>}
        {event.device !== null && (
          <>
            {' '}
            <bdi dir="ltr">{event.device}</bdi>
          </>
        )}
      </td>
    </tr>
  );
}
