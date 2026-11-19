import { useQuery } from '@tanstack/react-query';
import { getRouteApi, Link } from '@tanstack/react-router';
import { type FormEvent, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { chosenCity, citiesQuery } from './cities.js';
import { useServerNow } from './clock.js';
import { formatDateTime, formatMoney } from './format.js';
import { mediaUrl } from './media.js';
import {
  ageHours,
  approvalOf,
  type ChangeValues,
  type ChangeView,
  changeKind,
  correctable,
  type DecideRefusal,
  itemAfter,
  menuChangeQuery,
  menuChangesQuery,
  REVIEW_HOURS,
  useDecideMenuChange,
} from './menu-change-requests.js';
import { MenuPreviewSection } from './restaurant-menu-preview-page.js';

const listRoute = getRouteApi('/signed-in/menu-change-requests');
const viewRoute = getRouteApi('/signed-in/menu-change-requests/$requestId');

const refusalKeys = {
  request_not_pending: 'menuChanges.refused.request_not_pending',
  unknown_change_request: 'menuChanges.refused.unknown_change_request',
  category_pending: 'menuChanges.refused.category_pending',
  group_pending: 'menuChanges.refused.group_pending',
  invalid_menu: 'menuChanges.refused.invalid_menu',
  restaurant_terminated: 'menuChanges.refused.restaurant_terminated',
} as const satisfies Record<DecideRefusal, string>;

// AP §9.6.7 «طلبات تعديل القائمة» (slice 2.32b): every restaurant's pending
// requests of the city, oldest first, with the restaurant, the row, the kind
// of change and its age (RA §9.5: within 24 hours). Unstyled until the design.
export function MenuChangeRequestsPage() {
  const { t } = useTranslation();
  const search = listRoute.useSearch();
  const cities = useQuery(citiesQuery);
  const city = cities.data ? chosenCity(cities.data, search.city) : undefined;
  const requests = useQuery({ ...menuChangesQuery(city?.id ?? ''), enabled: city !== undefined });
  const now = new Date(useServerNow());
  return (
    <main>
      <h1>{t('menuChanges.title')}</h1>
      <p>
        <Link to="/">{t('common.home')}</Link>
      </p>
      <p>{t('menuChanges.explain', { hours: REVIEW_HOURS })}</p>
      {cities.isError || requests.isError ? (
        <p role="alert">{t('common.failed')}</p>
      ) : !city || !requests.data ? (
        <p role="status">{t('status.loading')}</p>
      ) : requests.data.length === 0 ? (
        <p>{t('menuChanges.none')}</p>
      ) : (
        <table>
          <thead>
            <tr>
              <th>{t('menuChanges.restaurant')}</th>
              <th>{t('menuChanges.row')}</th>
              <th>{t('menuChanges.kindTitle')}</th>
              <th>{t('menuChanges.age')}</th>
            </tr>
          </thead>
          <tbody>
            {requests.data.map((request) => {
              const hours = ageHours(request.createdAt, now);
              return (
                <tr key={request.id}>
                  <td>{request.restaurantName}</td>
                  <td>
                    <Link
                      to="/menu-change-requests/$requestId"
                      params={{ requestId: request.id }}
                      search={{ city: city.code }}
                    >
                      {request.targetName}
                    </Link>
                  </td>
                  <td>
                    <Kind change={request} />
                  </td>
                  <td>
                    {t('menuChanges.hours', { hours })}
                    {hours >= REVIEW_HOURS ? ` ${t('menuChanges.late')}` : null}
                  </td>
                </tr>
              );
            })}
          </tbody>
        </table>
      )}
    </main>
  );
}

// AP §9.6.7 «Request view»: before and after side by side, the item as
// customers will see it and the restaurant's customer preview; «قبول» with
// a text correction, «رفض» with a reason (RA §9.5).
export function MenuChangeRequestPage() {
  const { t } = useTranslation();
  const { requestId } = viewRoute.useParams();
  const search = viewRoute.useSearch();
  const cities = useQuery(citiesQuery);
  const city = cities.data ? chosenCity(cities.data, search.city) : undefined;
  const view = useQuery(menuChangeQuery(requestId));
  return (
    <main>
      <h1>{t('menuChanges.viewTitle')}</h1>
      <p>
        <Link to="/menu-change-requests" search={city ? { city: city.code } : {}}>
          {t('menuChanges.back')}
        </Link>
      </p>
      {view.isError ? (
        <p role="alert">{t('common.failed')}</p>
      ) : !view.data || !city ? (
        <p role="status">{t('status.loading')}</p>
      ) : (
        <RequestView view={view.data} timeZone={city.timeZone} />
      )}
    </main>
  );
}

function RequestView({ view, timeZone }: { view: ChangeView; timeZone: string }) {
  const { t } = useTranslation();
  const [correction, setCorrection] = useState({ name: '', description: '' });
  const [reason, setReason] = useState('');
  const decide = useDecideMenuChange(view.id);
  const fix = correctable(view);
  const preview = itemAfter(view, correction);
  const result = decide.data;
  const approve = (event: FormEvent) => {
    event.preventDefault();
    decide.mutate(approvalOf(view, correction));
  };
  const reject = (event: FormEvent) => {
    event.preventDefault();
    if (reason.trim() !== '') decide.mutate({ kind: 'reject', reason: reason.trim() });
  };
  return (
    <>
      <p>{t('menuChanges.restaurantLine', { name: view.restaurantName })}</p>
      <p>
        <Kind change={view} />
      </p>
      <p>
        {view.parentName === null
          ? view.targetName
          : t('menuChanges.rowIn', { name: view.targetName, parent: view.parentName })}
      </p>
      <p>{t('menuChanges.asked', { time: formatDateTime(view.createdAt, timeZone) })}</p>
      {view.status !== 'pending' && <p>{t(`menuChanges.status.${view.status}`)}</p>}
      <table>
        <thead>
          <tr>
            <th>{t('menuChanges.before')}</th>
            <th>{t('menuChanges.after')}</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td>
              {view.before === null ? (
                t('menuChanges.newRow')
              ) : (
                <Values values={view.before} view={view} />
              )}
            </td>
            <td>
              <Values values={view.after} view={view} />
            </td>
          </tr>
        </tbody>
      </table>
      {preview !== null && (
        <section aria-label={t('menuChanges.itemPreview')}>
          <h2>{t('menuChanges.itemPreview')}</h2>
          {preview.photoKey !== null && (
            <img src={mediaUrl(preview.photoKey, 320)} alt={preview.name} width={320} />
          )}
          <p>
            {preview.price === null
              ? preview.name
              : t('menu.preview.item', { name: preview.name, price: formatMoney(preview.price) })}
          </p>
          {preview.description !== null && <p>{preview.description}</p>}
        </section>
      )}
      <MenuPreviewSection restaurantId={view.restaurantId} />
      {view.status === 'pending' && (
        <>
          <form onSubmit={approve} aria-label={t('menuChanges.approve')}>
            {fix.name && (
              <label>
                {t('menuChanges.correctName')}
                <input
                  value={correction.name}
                  maxLength={80}
                  onChange={(event) => setCorrection({ ...correction, name: event.target.value })}
                />
              </label>
            )}
            {fix.description && (
              <label>
                {t('menuChanges.correctDescription')}
                <textarea
                  value={correction.description}
                  maxLength={300}
                  onChange={(event) =>
                    setCorrection({ ...correction, description: event.target.value })
                  }
                />
              </label>
            )}
            <button type="submit" disabled={decide.isPending}>
              {t('menuChanges.approve')}
            </button>
          </form>
          <form onSubmit={reject} aria-label={t('menuChanges.reject')}>
            <label>
              {t('menuChanges.reason')}
              <input
                value={reason}
                maxLength={200}
                required
                onChange={(event) => setReason(event.target.value)}
              />
            </label>
            <button type="submit" disabled={decide.isPending || reason.trim() === ''}>
              {t('menuChanges.reject')}
            </button>
          </form>
        </>
      )}
      {decide.isError && <p role="alert">{t('common.failed')}</p>}
      {result?.status === 'refused' && <p role="alert">{t(refusalKeys[result.refusal])}</p>}
      {result?.status === 'done' && <p role="status">{t('menuChanges.decided')}</p>}
    </>
  );
}

function Kind({ change }: { change: Pick<ChangeView, 'targetType' | 'field'> }) {
  const { t } = useTranslation();
  const key = changeKind(change);
  return key === null ? null : <>{t(key)}</>;
}

// A request's values: only the parts its field fills.
function Values({ values, view }: { values: ChangeValues; view: ChangeView }) {
  const { t } = useTranslation();
  const itemName = (id: string) => view.itemNames.find((item) => item.id === id)?.name ?? id;
  return (
    <dl>
      {values.name !== null && (
        <>
          <dt>{t('menuChanges.field.name')}</dt>
          <dd>{values.name}</dd>
        </>
      )}
      {(view.field === 'description' || values.description !== null) && (
        <>
          <dt>{t('menuChanges.field.description')}</dt>
          <dd>{values.description ?? t('menuChanges.empty')}</dd>
        </>
      )}
      {values.price !== null && (
        <>
          <dt>{t('menuChanges.field.price')}</dt>
          <dd>{formatMoney(values.price)}</dd>
        </>
      )}
      {(view.field === 'photo' || values.photoKey !== null) && (
        <>
          <dt>{t('menuChanges.field.photo')}</dt>
          <dd>
            {values.photoKey === null ? (
              t('menuChanges.noPhoto')
            ) : (
              <img
                src={mediaUrl(values.photoKey, 320)}
                alt={t('menuChanges.field.photo')}
                width={320}
              />
            )}
          </dd>
        </>
      )}
      {values.minChoices !== null && values.maxChoices !== null && (
        <>
          <dt>{t('menuChanges.field.choices')}</dt>
          <dd>{t('menuChanges.choices', { min: values.minChoices, max: values.maxChoices })}</dd>
        </>
      )}
      {values.options !== null && (
        <>
          <dt>{t('menuChanges.field.options')}</dt>
          <dd>
            {values.options
              .map((option) =>
                t('menu.preview.option', {
                  name: option.name,
                  delta: formatMoney(option.priceDelta),
                }),
              )
              .join('، ')}
          </dd>
        </>
      )}
      {values.itemIds !== null && (
        <>
          <dt>{t('menuChanges.field.items')}</dt>
          <dd>
            {values.itemIds.length === 0
              ? t('menuChanges.noItems')
              : values.itemIds.map(itemName).join('، ')}
          </dd>
        </>
      )}
    </dl>
  );
}
