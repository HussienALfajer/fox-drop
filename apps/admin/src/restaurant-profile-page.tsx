import { useQuery } from '@tanstack/react-query';
import { getRouteApi, Link } from '@tanstack/react-router';
import { type FormEvent, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { type City, citiesQuery } from './cities.js';
import { formatDateTime, formatMoney } from './format.js';
import { statusKeys } from './order-labels.js';
import { OPERATIONS_READ } from './orders-board.js';
import { RatingsSection } from './ratings-page.js';
import {
  type Draft,
  type DraftChoices,
  draftChoicesQuery,
  draftQuery,
} from './restaurant-drafts.js';
import { Accounts, BasicsStep, LocationStep, OperationsStep } from './restaurant-drafts-page.js';
import { percentText } from './restaurant-list.js';
import { MenuStep } from './restaurant-menu-page.js';
import {
  canOpenStatement,
  canSignOutDevices,
  changeActionOf,
  changeFieldOf,
  changeLogQuery,
  devicesQuery,
  NOTE_MAX,
  noteOf,
  notesQuery,
  type OverviewPeriod,
  overviewPeriods,
  overviewQuery,
  PROFILE_TABS,
  type ProfileTab,
  restaurantOrdersQuery,
  useAddNote,
  useSignOutDevices,
  valueText,
} from './restaurant-profile.js';
import { defaultPeriod } from './restaurant-statements.js';
import { RestaurantStatusSection } from './restaurant-status-page.js';
import { type AdminSession, can } from './session.js';

const route = getRouteApi('/signed-in/restaurants/$restaurantId');
const signedIn = getRouteApi('/signed-in');

// AP §9.6.4 «ملف المطعم» (slice 2.30d): one restaurant's tabs, opened from
// «المطاعم». It took over «حالة المطاعم», «الصور» and «تصنيفات المطعم».
// Unstyled until the design.
export function RestaurantProfilePage() {
  const { t } = useTranslation();
  const { session } = signedIn.useRouteContext();
  const { restaurantId } = route.useParams();
  const search = route.useSearch();
  const tab: ProfileTab = search.tab ?? 'overview';
  const cities = useQuery(citiesQuery);
  const draft = useQuery(draftQuery(restaurantId));
  const city = cities.data?.find((each) => each.id === draft.data?.cityId);
  const choices = useQuery({ ...draftChoicesQuery(city?.id ?? ''), enabled: city !== undefined });
  if (draft.isError || cities.isError || choices.isError) {
    return <p role="alert">{t('common.failed')}</p>;
  }
  if (draft.data === null) return <p role="alert">{t('profile.unknown')}</p>;
  if (!draft.data || !city || !choices.data) return <p role="status">{t('status.loading')}</p>;
  const tabSearch = (each: ProfileTab) => ({ city: city.code, tab: each });
  return (
    <main>
      <h1>{draft.data.basics.nameAr}</h1>
      <p>
        <Link to="/restaurants" search={{ city: city.code }}>
          {t('profile.back')}
        </Link>
      </p>
      <p>
        {t('profile.accountStatus', {
          status: t(
            `restaurantList.accountStatus.${draft.data.accountStatus}` as 'restaurantList.accountStatus.active',
          ),
        })}
      </p>
      {draft.data.accountStatus === 'draft' && (
        <p>
          {t('profile.draft')}{' '}
          <Link
            to="/restaurant-drafts/$restaurantId"
            params={{ restaurantId }}
            search={{ city: city.code, step: 'basics' }}
          >
            {t('profile.openWizard')}
          </Link>
        </p>
      )}
      <nav aria-label={t('profile.tabs')}>
        <ul>
          {PROFILE_TABS.map((each) => (
            <li key={each}>
              <Link
                to="/restaurants/$restaurantId"
                params={{ restaurantId }}
                search={tabSearch(each)}
                aria-current={each === tab ? 'page' : undefined}
              >
                {t(`profile.tab.${each}`)}
              </Link>
            </li>
          ))}
        </ul>
      </nav>
      <h2>{t(`profile.tab.${tab}`)}</h2>
      <Tab
        tab={tab}
        restaurantId={restaurantId}
        draft={draft.data}
        city={city}
        choices={choices.data}
        session={session}
      />
    </main>
  );
}

function Tab(props: {
  tab: ProfileTab;
  restaurantId: string;
  draft: Draft;
  city: City;
  choices: DraftChoices;
  session: AdminSession;
}) {
  const { t } = useTranslation();
  const { restaurantId, draft, city, choices, session } = props;
  // A draft's steps are the wizard's; a terminated restaurant is read only.
  const editable = draft.accountStatus !== 'draft' && draft.accountStatus !== 'terminated';
  const step = { restaurantId, draft, choices, session, where: 'profile' as const };
  switch (props.tab) {
    case 'overview':
      return <Overview restaurantId={restaurantId} city={city} />;
    case 'status':
      return <RestaurantStatusSection restaurantId={restaurantId} city={city} />;
    case 'data':
      return editable ? (
        <BasicsStep key={restaurantId} {...step} city={city} />
      ) : (
        <ReadOnly draft={draft} />
      );
    case 'location':
      return editable ? <LocationStep key={restaurantId} {...step} /> : <ReadOnly draft={draft} />;
    case 'hours':
      return editable ? (
        <>
          <OperationsStep key={restaurantId} {...step} />
          <p>{t('profile.hoursMore')}</p>
        </>
      ) : (
        <ReadOnly draft={draft} />
      );
    case 'accounts':
      return (
        <>
          <Accounts restaurantId={restaurantId} session={session} />
          <Devices restaurantId={restaurantId} city={city} session={session} />
        </>
      );
    case 'menu':
      return (
        <MenuStep restaurantId={restaurantId} currency={choices.baseCurrency} session={session} />
      );
    case 'orders':
      return <Orders restaurantId={restaurantId} city={city} session={session} />;
    case 'statement':
      return <Statement restaurantId={restaurantId} city={city} session={session} />;
    case 'ratings':
      return <Ratings restaurantId={restaurantId} city={city} />;
    case 'contract':
      return <Contract draft={draft} city={city} />;
    case 'notes':
      return <Notes restaurantId={restaurantId} city={city} />;
    case 'log':
      return <ChangeLog restaurantId={restaurantId} city={city} />;
  }
}

function ReadOnly({ draft }: { draft: Draft }) {
  const { t } = useTranslation();
  return (
    <p>{draft.accountStatus === 'draft' ? t('profile.draft') : t('profile.terminatedReadOnly')}</p>
  );
}

function Overview({ restaurantId, city }: { restaurantId: string; city: City }) {
  const { t } = useTranslation();
  const [period, setPeriod] = useState<OverviewPeriod>('today');
  const overview = useQuery(overviewQuery(restaurantId, period));
  const share = (bp: number | null) => (bp === null ? t('profile.none') : percentText(bp));
  const minutes = (value: number | null) =>
    value === null ? t('profile.none') : t('profile.overview.minutes', { minutes: value });
  return (
    <section aria-label={t('profile.tab.overview')}>
      <label>
        {t('profile.overview.period')}
        <select
          value={period}
          onChange={(event) =>
            setPeriod(overviewPeriods.find((each) => each === event.target.value) ?? 'today')
          }
        >
          {overviewPeriods.map((each) => (
            <option key={each} value={each}>
              {t(`profile.overview.periods.${each}`)}
            </option>
          ))}
        </select>
      </label>
      {overview.isError ? (
        <p role="alert">{t('common.failed')}</p>
      ) : !overview.data ? (
        <p role="status">{t('status.loading')}</p>
      ) : (
        <>
          <p>
            {t('profile.overview.since', {
              time: formatDateTime(overview.data.from, city.timeZone),
            })}
          </p>
          <dl>
            <dt>{t('profile.overview.orders')}</dt>
            <dd>{overview.data.orders}</dd>
            <dt>{t('profile.overview.sales')}</dt>
            <dd>
              {overview.data.sales.length === 0
                ? t('profile.none')
                : overview.data.sales.map((line) => formatMoney(line)).join(' · ')}
            </dd>
            <dt>{t('profile.overview.acceptance')}</dt>
            <dd>{share(overview.data.acceptanceBp)}</dd>
            <dt>{t('profile.overview.prep')}</dt>
            <dd>
              {t('profile.overview.prepAgainst', {
                actual: minutes(overview.data.prepActualMin),
                chosen: minutes(overview.data.prepChosenMin),
              })}
            </dd>
            <dt>{t('profile.overview.late')}</dt>
            <dd>{share(overview.data.lateBp)}</dd>
            <dt>{t('profile.overview.rejection')}</dt>
            <dd>{share(overview.data.rejectionBp)}</dd>
            <dt>{t('profile.overview.rating')}</dt>
            <dd>
              {overview.data.ratingAverage === null
                ? t('profile.none')
                : t('restaurantList.rating', {
                    average: overview.data.ratingAverage,
                    count: overview.data.ratingCount,
                  })}
            </dd>
            <dt>{t('profile.overview.unanswered')}</dt>
            <dd>{overview.data.unanswered}</dd>
          </dl>
          {overview.data.rejectionReasons.length > 0 && (
            <>
              <h3>{t('profile.overview.reasons')}</h3>
              <ul>
                {overview.data.rejectionReasons.map((reason) => (
                  <li key={reason.label}>
                    {t('profile.overview.reason', { label: reason.label, count: reason.count })}
                  </li>
                ))}
              </ul>
            </>
          )}
        </>
      )}
    </section>
  );
}

function Devices(props: { restaurantId: string; city: City; session: AdminSession }) {
  const { t } = useTranslation();
  const devices = useQuery(devicesQuery(props.restaurantId));
  const signOut = useSignOutDevices(props.restaurantId);
  const [reason, setReason] = useState('');
  const allowed = canSignOutDevices(props.session);
  const send = (deviceId: string | null) => {
    if (reason.trim() !== '') signOut.mutate({ deviceId, reason: reason.trim() });
  };
  return (
    <section aria-label={t('profile.devices.title')}>
      <h3>{t('profile.devices.title')}</h3>
      <p>{t('profile.devices.explain')}</p>
      {devices.isError ? (
        <p role="alert">{t('common.failed')}</p>
      ) : !devices.data ? (
        <p role="status">{t('status.loading')}</p>
      ) : devices.data.length === 0 ? (
        <p>{t('profile.devices.none')}</p>
      ) : (
        <ul>
          {devices.data.map((device) => (
            <li key={device.deviceId}>
              {t('profile.devices.line', {
                name: device.name,
                platform: t(`profile.devices.platform.${device.platform}`),
                version: device.appVersion,
              })}{' '}
              {device.user &&
                t('profile.devices.user', {
                  role: t(`drafts.accounts.role.${device.user.role}`),
                  name: device.user.name,
                })}{' '}
              {device.signedIn ? t('profile.devices.signedIn') : t('profile.devices.signedOut')}{' '}
              {device.lastSeenAt &&
                t('profile.devices.lastSeen', {
                  time: formatDateTime(device.lastSeenAt, props.city.timeZone),
                })}{' '}
              {t('profile.devices.reported', { value: t('profile.notYet') })}{' '}
              {allowed && device.signedIn && (
                <button
                  type="button"
                  disabled={signOut.isPending || reason.trim() === ''}
                  onClick={() => send(device.deviceId)}
                >
                  {t('profile.devices.signOut')}
                </button>
              )}
            </li>
          ))}
        </ul>
      )}
      {allowed && (
        <p>
          <label>
            {t('profile.devices.reason')}
            <input value={reason} maxLength={500} onChange={(e) => setReason(e.target.value)} />
          </label>{' '}
          <button
            type="button"
            disabled={signOut.isPending || reason.trim() === ''}
            onClick={() => send(null)}
          >
            {t('profile.devices.signOutAll')}
          </button>
        </p>
      )}
      {signOut.isError ? (
        <p role="alert">{t('common.failed')}</p>
      ) : signOut.data?.status === 'refused' ? (
        <p role="alert">{t('profile.devices.noDevice')}</p>
      ) : signOut.data?.status === 'done' ? (
        <p role="status">{t('profile.devices.done')}</p>
      ) : null}
    </section>
  );
}

function Orders(props: { restaurantId: string; city: City; session: AdminSession }) {
  const { t } = useTranslation();
  const orders = useQuery(restaurantOrdersQuery(props.restaurantId));
  const opens = can(props.session, OPERATIONS_READ);
  if (orders.isError) return <p role="alert">{t('common.failed')}</p>;
  if (!orders.data) return <p role="status">{t('status.loading')}</p>;
  if (orders.data.length === 0) return <p>{t('profile.orders.none')}</p>;
  return (
    <>
      <p>{t('profile.orders.explain')}</p>
      <ul>
        {orders.data.map((order) => (
          <li key={order.id}>
            {opens ? (
              <Link
                to="/orders/$orderId"
                params={{ orderId: order.id }}
                search={{ city: props.city.code }}
              >
                {t('profile.orders.number', { number: order.number })}
              </Link>
            ) : (
              t('profile.orders.number', { number: order.number })
            )}{' '}
            {formatDateTime(order.placedAt, props.city.timeZone)} {t(statusKeys[order.status])}{' '}
            {formatMoney({ amount: order.total, currency: order.currency })}
            {order.testOrder && ` · ${t('profile.orders.test')}`}
            {order.redelivery && ` · ${t('profile.orders.redelivery')}`}
          </li>
        ))}
      </ul>
    </>
  );
}

function Statement(props: { restaurantId: string; city: City; session: AdminSession }) {
  const { t } = useTranslation();
  if (!canOpenStatement(props.session)) return <p>{t('profile.statement.notAllowed')}</p>;
  const period = defaultPeriod(new Date(), props.city.timeZone);
  return (
    <p>
      <Link
        to="/restaurant-statements"
        search={{ city: props.city.code, restaurant: props.restaurantId, ...period }}
      >
        {t('profile.statement.open')}
      </Link>
    </p>
  );
}

function Ratings({ restaurantId, city }: { restaurantId: string; city: City }) {
  const [filters, setFilters] = useState<{
    period: 'all' | 'today' | 'yesterday' | 'last_7_days' | 'last_30_days';
    stars: number | null;
  }>({ period: 'all', stars: null });
  return (
    <RatingsSection
      target={{ party: 'restaurant', id: restaurantId }}
      city={city}
      period={filters.period}
      stars={filters.stars}
      onFilters={setFilters}
    />
  );
}

function Contract({ draft, city }: { draft: Draft; city: City }) {
  const { t } = useTranslation();
  const contract = draft.contract;
  return (
    <section aria-label={t('profile.tab.contract')}>
      {contract === null ? (
        <p>{t('profile.contract.none')}</p>
      ) : (
        <dl>
          <dt>{t('drafts.contract.signedOn')}</dt>
          <dd>{contract.signedOn ?? t('profile.none')}</dd>
          <dt>{t('drafts.contract.duration')}</dt>
          <dd>
            {contract.durationMonths === null
              ? t('profile.none')
              : t('profile.contract.months', { months: contract.durationMonths })}
          </dd>
          <dt>{t('profile.contract.confirmed')}</dt>
          <dd>
            {contract.confirmedAt === null
              ? t('profile.contract.notConfirmed')
              : formatDateTime(contract.confirmedAt, city.timeZone)}
          </dd>
        </dl>
      )}
      {contract?.contractUrl && (
        <figure>
          <img src={contract.contractUrl} alt={t('drafts.contract.contractScan')} width={480} />
          <figcaption>{t('drafts.contract.contractScan')}</figcaption>
        </figure>
      )}
      {contract?.licenceUrl && (
        <figure>
          <img src={contract.licenceUrl} alt={t('drafts.contract.licenceScan')} width={480} />
          <figcaption>{t('drafts.contract.licenceScan')}</figcaption>
        </figure>
      )}
      <p>{t('profile.contract.readOnly')}</p>
    </section>
  );
}

function Notes({ restaurantId, city }: { restaurantId: string; city: City }) {
  const { t } = useTranslation();
  const notes = useQuery(notesQuery(restaurantId));
  const add = useAddNote(restaurantId);
  const [text, setText] = useState('');
  const submit = (event: FormEvent) => {
    event.preventDefault();
    const body = noteOf(text);
    if (body !== null) add.mutate(body, { onSuccess: () => setText('') });
  };
  return (
    <section aria-label={t('profile.tab.notes')}>
      <form onSubmit={submit}>
        <label>
          {t('profile.notes.new')}
          <textarea value={text} maxLength={NOTE_MAX} onChange={(e) => setText(e.target.value)} />
        </label>
        <button type="submit" disabled={add.isPending || noteOf(text) === null}>
          {t('profile.notes.add')}
        </button>
      </form>
      {add.isError && <p role="alert">{t('common.failed')}</p>}
      {notes.isError ? (
        <p role="alert">{t('common.failed')}</p>
      ) : !notes.data ? (
        <p role="status">{t('status.loading')}</p>
      ) : notes.data.length === 0 ? (
        <p>{t('profile.notes.none')}</p>
      ) : (
        <ul>
          {notes.data.map((note) => (
            <li key={note.id}>
              <p>{note.body}</p>
              <p>
                {t('profile.notes.by', {
                  name: note.authorName ?? t('profile.someone'),
                  time: formatDateTime(note.createdAt, city.timeZone),
                })}
              </p>
            </li>
          ))}
        </ul>
      )}
    </section>
  );
}

function ChangeLog({ restaurantId, city }: { restaurantId: string; city: City }) {
  const { t } = useTranslation();
  const log = useQuery(changeLogQuery(restaurantId));
  if (log.isError) return <p role="alert">{t('common.failed')}</p>;
  if (!log.data) return <p role="status">{t('status.loading')}</p>;
  if (log.data.length === 0) return <p>{t('profile.log.none')}</p>;
  return (
    <>
      <p>{t('profile.log.explain')}</p>
      <ul>
        {log.data.map((entry) => {
          const action = changeActionOf(entry.action);
          const who =
            entry.actorType === 'system'
              ? t('profile.log.system')
              : (entry.actorName ?? t('profile.someone'));
          return (
            <li key={entry.id}>
              <p>
                {t(entry.account === null ? 'profile.log.line' : 'profile.log.lineAccount', {
                  time: formatDateTime(entry.at, city.timeZone),
                  action:
                    action === null ? t('profile.log.other') : t(`profile.log.action.${action}`),
                  account: entry.account ?? '',
                  name: who,
                })}
              </p>
              {entry.changes.length > 0 && (
                <ul>
                  {entry.changes.map((change) => {
                    const before = valueText(change.before);
                    const after = valueText(change.after);
                    return (
                      <li key={change.field}>
                        {(() => {
                          const field = changeFieldOf(change.field);
                          return field === null
                            ? t('profile.log.otherField')
                            : t(`profile.log.fields.${field}`);
                        })()}
                        {before !== null || after !== null
                          ? ` ${t('profile.log.fromTo', {
                              before: before ?? t('profile.none'),
                              after: after ?? t('profile.none'),
                            })}`
                          : ` ${t('profile.log.changed')}`}
                      </li>
                    );
                  })}
                </ul>
              )}
              {entry.reason !== null && <p>{t('profile.log.reason', { reason: entry.reason })}</p>}
            </li>
          );
        })}
      </ul>
    </>
  );
}
