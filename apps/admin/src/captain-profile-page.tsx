import { useQuery } from '@tanstack/react-query';
import { getRouteApi, Link } from '@tanstack/react-router';
import { type FormEvent, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { actionsOf, applicationQuery, canSeeApplications } from './captain-applications.js';
import { CAPTAINS_MANAGE } from './captain-device.js';
import { ReleaseDevice } from './captain-device-page.js';
import { acceptancePercent } from './captain-list.js';
import { offboardingActions } from './captain-offboarding.js';
import { OffboardingSection } from './captain-offboarding-page.js';
import { ForceOffline } from './captain-offline-page.js';
import {
  CAPTAIN_TABS,
  type CaptainProfile,
  type CaptainTab,
  canChangeCashLimit,
  canMessage,
  canSuspend,
  captainChangeActionOf,
  captainChangeLogQuery,
  captainNotesQuery,
  captainOffersQuery,
  captainOrdersQuery,
  captainProfileQuery,
  cashLimitMinor,
  MESSAGE_MAX,
  textOf,
  useAddCaptainNote,
  useCaptainPhone,
  useMessageCaptain,
  useSetCaptainCashLimit,
  useSetCaptainStatus,
} from './captain-profile.js';
import { ViolationsSection } from './captain-violations-page.js';
import { CASH_DESK } from './cash-desk.js';
import { type City, citiesQuery } from './cities.js';
import { zonedToUtc } from './emergency-stop.js';
import { formatAverage, formatDateTime, formatMoney } from './format.js';
import { statusKeys, vehicleKey } from './order-labels.js';
import { OPERATIONS_READ } from './orders-board.js';
import { RatingsSection } from './ratings-page.js';
import { NOTE_MAX, noteOf } from './restaurant-profile.js';
import { type AdminSession, can } from './session.js';

const route = getRouteApi('/signed-in/captains/$captainId');
const signedIn = getRouteApi('/signed-in');

// AP §9.7.4–9.7.5 «ملف الكابتن» (slice 2.36a): one captain's tabs and
// actions, opened from «الكباتن». «البيانات والمستندات», «المركبة» and «العدة
// والتأمين» stay on the captain's file (the application's page, linked);
// «العقد» holds «إنهاء التعاقد», moved here. Unstyled until the design.
export function CaptainProfilePage() {
  const { t } = useTranslation();
  const { session } = signedIn.useRouteContext();
  const { captainId } = route.useParams();
  const search = route.useSearch();
  const tab: CaptainTab = search.tab ?? 'overview';
  const cities = useQuery(citiesQuery);
  const profile = useQuery(captainProfileQuery(captainId));
  const read = profile.data;
  const city =
    typeof read === 'object' && read !== null
      ? cities.data?.find((each) => each.id === read.cityId)
      : undefined;
  if (profile.isError || cities.isError) return <p role="alert">{t('common.failed')}</p>;
  if (read === null) return <p role="alert">{t('captainProfile.unknown')}</p>;
  if (read === 'rates_unavailable') {
    return <p role="alert">{t('captainProfile.ratesUnavailable')}</p>;
  }
  if (!read || !city) return <p role="status">{t('status.loading')}</p>;
  const captain = read;
  return (
    <main>
      <h1>{captain.name}</h1>
      <p>
        <Link to="/captains" search={{ city: city.code }}>
          {t('captainProfile.back')}
        </Link>
      </p>
      <p>{t(`captainList.statusLabel.${captain.status}`)}</p>
      {captain.suspension !== null && <Suspension captain={captain} city={city} />}
      <nav aria-label={t('captainProfile.tabs')}>
        <ul>
          {CAPTAIN_TABS.filter(
            // A captain's ratings are captains.read's (FIN reads the money).
            (each) => each !== 'ratings' || can(session, 'captains.read'),
          ).map((each) => (
            <li key={each}>
              <Link
                to="/captains/$captainId"
                params={{ captainId }}
                search={{ city: city.code, tab: each }}
                aria-current={each === tab ? 'page' : undefined}
              >
                {t(`captainProfile.tab.${each}`)}
              </Link>
            </li>
          ))}
        </ul>
      </nav>
      <h2>{t(`captainProfile.tab.${tab}`)}</h2>
      <Tab tab={tab} captain={captain} city={city} session={session} />
    </main>
  );
}

function Suspension({ captain, city }: { captain: CaptainProfile; city: City }) {
  const { t } = useTranslation();
  const suspension = captain.suspension!;
  return (
    <p>
      {suspension.until === null
        ? t('captainProfile.suspendedOpen', { reason: suspension.reason })
        : t('captainProfile.suspendedUntil', {
            reason: suspension.reason,
            until: formatDateTime(suspension.until, city.timeZone),
          })}
    </p>
  );
}

function Tab(props: {
  tab: CaptainTab;
  captain: CaptainProfile;
  city: City;
  session: AdminSession;
}) {
  const { captain, city, session } = props;
  switch (props.tab) {
    case 'overview':
      return <Overview captain={captain} session={session} />;
    case 'data':
      return <Data captain={captain} city={city} session={session} />;
    case 'app':
      return <App captain={captain} city={city} session={session} />;
    case 'contract':
      return <Contract captain={captain} city={city} session={session} />;
    case 'custody':
      return <Custody captain={captain} city={city} session={session} />;
    case 'earnings':
      return <Earnings captain={captain} city={city} session={session} />;
    case 'orders':
      return <Orders captain={captain} city={city} session={session} />;
    case 'offers':
      return <Offers captain={captain} city={city} session={session} />;
    case 'ratings':
      return <Ratings captain={captain} city={city} />;
    case 'suspensions':
      return <Suspensions captain={captain} city={city} session={session} />;
    case 'notes':
      return <Notes captain={captain} city={city} />;
    case 'log':
      return <ChangeLog captain={captain} city={city} />;
  }
}

const listFormat = new Intl.ListFormat('ar-u-nu-latn', { type: 'unit' });

// Online hours to one decimal (a duration, not money).
const hoursFormat = new Intl.NumberFormat('ar-u-nu-latn', { maximumFractionDigits: 1 });
function hours(minutes: number): string {
  return hoursFormat.format(minutes / 60);
}

function Overview({ captain, session }: { captain: CaptainProfile; session: AdminSession }) {
  const { t } = useTranslation();
  const acceptance = acceptancePercent(captain);
  const { onTime, earnings } = captain;
  const money = (amount: string) => formatMoney({ amount, currency: earnings.currency });
  return (
    <section aria-label={t('captainProfile.tab.overview')}>
      <dl>
        <dt>{t('captainProfile.overview.ordersToday')}</dt>
        <dd>{captain.ordersToday}</dd>
        <dt>{t('captainProfile.overview.delivered')}</dt>
        <dd>{captain.delivered}</dd>
        <dt>{t('captainProfile.overview.acceptance')}</dt>
        <dd>
          {acceptance === null
            ? '—'
            : t('captainList.acceptance', {
                percent: acceptance,
                answered: captain.acceptance!.answered,
              })}
        </dd>
        <dt>{t('captainProfile.overview.onTime')}</dt>
        <dd>
          {onTime.counted === 0
            ? '—'
            : t('captainProfile.overview.onTimeValue', {
                percent: Math.round((onTime.onTime * 100) / onTime.counted),
                counted: onTime.counted,
              })}
        </dd>
        <dt>{t('captainProfile.overview.cancellations')}</dt>
        <dd>{captain.cancellations}</dd>
        <dt>{t('captainProfile.overview.rating')}</dt>
        <dd>
          {captain.rating === null
            ? t('captainList.noRating')
            : t('captainList.rating', {
                average: formatAverage(Math.round(captain.rating.average * 10) / 10),
                count: captain.rating.count,
              })}
        </dd>
      </dl>
      <table aria-label={t('captainProfile.overview.periods')}>
        <thead>
          <tr>
            <th scope="col">{t('captainProfile.overview.period')}</th>
            <th scope="col">{t('captainProfile.overview.earnings')}</th>
            <th scope="col">{t('captainProfile.overview.paidOrders')}</th>
            <th scope="col">{t('captainProfile.overview.online')}</th>
          </tr>
        </thead>
        <tbody>
          {(['today', 'week', 'month'] as const).map((period) => (
            <tr key={period}>
              <th scope="row">{t(`captainProfile.overview.${period}`)}</th>
              <td>{money(earnings[period].earnings)}</td>
              <td>{earnings[period].orders}</td>
              <td>
                {t('captainProfile.overview.hours', {
                  hours: hours(earnings[period].onlineMinutes),
                })}
              </td>
            </tr>
          ))}
        </tbody>
      </table>
      {canMessage(session) && captain.status !== 'terminated' && (
        <MessageForm captainId={captain.id} />
      )}
    </section>
  );
}

function MessageForm({ captainId }: { captainId: string }) {
  const { t } = useTranslation();
  const [text, setText] = useState('');
  const send = useMessageCaptain(captainId);
  const body = textOf(text, MESSAGE_MAX);
  const submit = (event: FormEvent) => {
    event.preventDefault();
    if (body === null) return;
    send.mutate(body, {
      onSuccess: (result) => {
        if (result === 'sent') setText('');
      },
    });
  };
  return (
    <form onSubmit={submit} aria-label={t('captainProfile.message.title')}>
      <h3>{t('captainProfile.message.title')}</h3>
      <label>
        {t('captainProfile.message.text')}
        <textarea
          value={text}
          maxLength={MESSAGE_MAX}
          onChange={(event) => setText(event.target.value)}
        />
      </label>
      <button type="submit" disabled={send.isPending || body === null}>
        {t('captainProfile.message.send')}
      </button>
      {send.isError && <p role="alert">{t('common.failed')}</p>}
      {send.data === 'terminated' && <p role="alert">{t('captainProfile.message.terminated')}</p>}
      {send.data === 'sent' && <p role="status">{t('captainProfile.message.sent')}</p>}
    </form>
  );
}

// The file is the application's page, captains.read's (not FIN's).
function FileLink(props: { captain: CaptainProfile; city: City; session: AdminSession }) {
  const { t } = useTranslation();
  const { captain, city } = props;
  if (!canSeeApplications(props.session)) return null;
  if (captain.applicationId === null) return <p>{t('captainProfile.noFile')}</p>;
  return (
    <p>
      <Link
        to="/captain-applications/$applicationId"
        params={{ applicationId: captain.applicationId }}
        search={{ city: city.code }}
      >
        {t('captainProfile.openFile')}
      </Link>
    </p>
  );
}

function Data(props: { captain: CaptainProfile; city: City; session: AdminSession }) {
  const { t } = useTranslation();
  const { captain, city, session } = props;
  const phone = useCaptainPhone(captain.id);
  return (
    <section aria-label={t('captainProfile.tab.data')}>
      <dl>
        <dt>{t('captainProfile.data.phone')}</dt>
        <dd dir="ltr">{phone.data ?? captain.maskedPhone ?? '—'}</dd>
        <dt>{t('captainProfile.data.vehicle')}</dt>
        <dd>{t(vehicleKey(captain.vehicle))}</dd>
        <dt>{t('captainProfile.data.plate')}</dt>
        <dd dir="ltr">{captain.plateNumber ?? '—'}</dd>
      </dl>
      {canMessage(session) && captain.maskedPhone !== null && phone.data === undefined && (
        // captains.manage calls the captain; each read is audited.
        <button type="button" disabled={phone.isPending} onClick={() => phone.mutate()}>
          {t('captainProfile.data.showPhone')}
        </button>
      )}
      {phone.isError && <p role="alert">{t('common.failed')}</p>}
      <p>{t('captainProfile.data.explain')}</p>
      <FileLink captain={captain} city={city} session={session} />
    </section>
  );
}

function App(props: { captain: CaptainProfile; city: City; session: AdminSession }) {
  const { t } = useTranslation();
  const { captain, city, session } = props;
  const { app } = captain;
  return (
    <section aria-label={t('captainProfile.tab.app')}>
      <dl>
        <dt>{t('captainProfile.app.maxPickup')}</dt>
        <dd>
          {app.maxPickup !== null
            ? formatMoney(app.maxPickup)
            : app.maxPickupAnswered
              ? t('captainProfile.app.noLimit')
              : t('captainProfile.app.notAnswered')}
        </dd>
        <dt>{t('captainProfile.app.carried')}</dt>
        <dd>{listFormat.format(app.carriedCurrencies)}</dd>
        <dt>{t('captainProfile.app.expiredInRow')}</dt>
        <dd>{app.expiredInRow}</dd>
        <dt>{t('captainProfile.app.deviceCheck')}</dt>
        <dd>
          {app.deviceCheck === null
            ? t('captainProfile.app.checkNone')
            : app.deviceCheck.passed
              ? t('captainProfile.app.checkPassed', {
                  time: formatDateTime(app.deviceCheck.at, city.timeZone),
                })
              : t('captainProfile.app.checkFailed', {
                  time: formatDateTime(app.deviceCheck.at, city.timeZone),
                  items: app.deviceCheck.failed
                    .map((code) => t(`captainProfile.app.check.${code}`))
                    .join('، '),
                })}
        </dd>
      </dl>
      {can(session, CAPTAINS_MANAGE) && captain.status !== 'terminated' && (
        <>
          <ReleaseDevice captainId={captain.id} time={(at) => formatDateTime(at, city.timeZone)} />
          <ForceOffline captainId={captain.id} />
        </>
      )}
    </section>
  );
}

function Contract(props: { captain: CaptainProfile; city: City; session: AdminSession }) {
  const { t } = useTranslation();
  const { captain, city, session } = props;
  const application = useQuery({
    ...applicationQuery(captain.applicationId ?? ''),
    enabled: captain.applicationId !== null && canSeeApplications(session),
  });
  return (
    <section aria-label={t('captainProfile.tab.contract')}>
      <p>
        {captain.contractPhase === null
          ? t('captainProfile.noContract')
          : t('captainProfile.phase', {
              phase: t(`captainList.phase.${captain.contractPhase}`),
            })}
      </p>
      <FileLink captain={captain} city={city} session={session} />
      {captain.applicationId !== null &&
        canSeeApplications(session) &&
        (application.isError ? (
          <p role="alert">{t('common.failed')}</p>
        ) : application.data === undefined ? (
          <p role="status">{t('status.loading')}</p>
        ) : application.data === null ? null : (
          <OffboardingSection
            application={application.data}
            session={session}
            actions={offboardingActions(
              actionsOf(session, application.data.stage),
              application.data.offboarding,
            )}
            cityCode={city.code}
            timeZone={city.timeZone}
          />
        ))}
    </section>
  );
}

function Custody(props: { captain: CaptainProfile; city: City; session: AdminSession }) {
  const { t } = useTranslation();
  const { captain, city, session } = props;
  const { custody } = captain;
  return (
    <section aria-label={t('captainProfile.tab.custody')}>
      <p>
        {t('captainList.custody', {
          usage: formatMoney(custody.usage),
          limit: formatMoney(custody.limit),
        })}
      </p>
      <p>{t('captainProfile.custody.closedDue', { amount: formatMoney(custody.closedDue) })}</p>
      {custody.blocks.map((block) => (
        <p key={block}>{t(`captainProfile.custody.block.${block}`)}</p>
      ))}
      {custody.handInGraceUntil !== null && (
        <p>
          {t('captainProfile.custody.grace', {
            until: formatDateTime(custody.handInGraceUntil, city.timeZone),
          })}
        </p>
      )}
      {custody.currencies.length === 0 ? (
        <p>{t('captainProfile.custody.none')}</p>
      ) : (
        <table aria-label={t('captainProfile.tab.custody')}>
          <thead>
            <tr>
              <th scope="col">{t('captainProfile.custody.currency')}</th>
              <th scope="col">{t('captainProfile.custody.balance')}</th>
              <th scope="col">{t('captainProfile.custody.closedDueColumn')}</th>
              <th scope="col">{t('captainProfile.custody.today')}</th>
              <th scope="col">{t('captainProfile.custody.inBase')}</th>
            </tr>
          </thead>
          <tbody>
            {custody.currencies.map((line) => (
              <tr key={line.currency}>
                <th scope="row">{line.currency}</th>
                <td>{formatMoney({ amount: line.balance, currency: line.currency })}</td>
                <td>{formatMoney({ amount: line.closedDue, currency: line.currency })}</td>
                <td>{formatMoney({ amount: line.today, currency: line.currency })}</td>
                <td>
                  {formatMoney({ amount: line.balanceInBase, currency: custody.usage.currency })}
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      )}
      <p>
        <Link to="/captain-balances" search={{ city: city.code }}>
          {t('captainProfile.custody.balances')}
        </Link>
      </p>
      {canChangeCashLimit(session) && captain.status !== 'terminated' && (
        <CashLimitForm captain={captain} />
      )}
    </section>
  );
}

const cashLimitRefusals = {
  invalid_captain: 'captainProfile.cashLimit.invalid',
  not_in_base_currency: 'captainProfile.cashLimit.notInBase',
} as const;

function CashLimitForm({ captain }: { captain: CaptainProfile }) {
  const { t } = useTranslation();
  const { currency } = captain.custody.limit;
  const [amount, setAmount] = useState('');
  const [reason, setReason] = useState('');
  const save = useSetCaptainCashLimit(captain.id);
  const minor = cashLimitMinor(amount, currency);
  const why = reason.trim();
  const submit = (event: FormEvent) => {
    event.preventDefault();
    if (minor === null || why === '') return;
    save.mutate(
      { amount: minor, currency, reason: why },
      {
        onSuccess: (result) => {
          if (result.status === 'done') {
            setAmount('');
            setReason('');
          }
        },
      },
    );
  };
  return (
    <form onSubmit={submit} aria-label={t('captainProfile.cashLimit.title')}>
      <h3>{t('captainProfile.cashLimit.title')}</h3>
      <label>
        {t('captainProfile.cashLimit.amount', { currency })}
        <input
          inputMode="decimal"
          dir="ltr"
          value={amount}
          onChange={(event) => setAmount(event.target.value)}
        />
      </label>
      <label>
        {t('captainProfile.reason')}
        <textarea
          maxLength={500}
          value={reason}
          onChange={(event) => setReason(event.target.value)}
        />
      </label>
      <button type="submit" disabled={save.isPending || minor === null || why === ''}>
        {t('captainProfile.cashLimit.save')}
      </button>
      {save.isError && <p role="alert">{t('common.failed')}</p>}
      {save.data?.status === 'refused' && (
        <p role="alert">{t(cashLimitRefusals[save.data.refusal])}</p>
      )}
      {save.data?.status === 'done' && <p role="status">{t('captainProfile.cashLimit.done')}</p>}
    </form>
  );
}

function Earnings(props: { captain: CaptainProfile; city: City; session: AdminSession }) {
  const { t } = useTranslation();
  const { captain, city, session } = props;
  const { earnings } = captain;
  return (
    <section aria-label={t('captainProfile.tab.earnings')}>
      <p>
        {t('captainProfile.earnings.balance', {
          amount: formatMoney({ amount: earnings.balance, currency: earnings.currency }),
        })}
      </p>
      <ul>
        {(['week', 'month'] as const).map((period) => (
          <li key={period}>
            {t(`captainProfile.earnings.${period}`, {
              from: formatDateTime(earnings[period].from, city.timeZone),
              amount: formatMoney({
                amount: earnings[period].earnings,
                currency: earnings.currency,
              }),
              orders: earnings[period].orders,
            })}
          </li>
        ))}
      </ul>
      {can(session, CASH_DESK) && (
        <p>
          <Link
            to="/cash-desk/settlements/$captainId"
            params={{ captainId: captain.id }}
            search={{ city: city.code }}
          >
            {t('captainProfile.earnings.statements')}
          </Link>
        </p>
      )}
    </section>
  );
}

function Orders(props: { captain: CaptainProfile; city: City; session: AdminSession }) {
  const { t } = useTranslation();
  const { captain, city, session } = props;
  const orders = useQuery(captainOrdersQuery(captain.id));
  if (orders.isError) return <p role="alert">{t('common.failed')}</p>;
  if (!orders.data) return <p role="status">{t('status.loading')}</p>;
  if (orders.data.length === 0) return <p>{t('captainProfile.orders.none')}</p>;
  return (
    <ul aria-label={t('captainProfile.tab.orders')}>
      {orders.data.map((order) => (
        <li key={order.id}>
          {can(session, OPERATIONS_READ) ? (
            <Link to="/orders/$orderId" params={{ orderId: order.id }} search={{ city: city.code }}>
              {t('order.number', { number: order.number })}
            </Link>
          ) : (
            t('order.number', { number: order.number })
          )}{' '}
          {formatDateTime(order.placedAt, city.timeZone)} {t(statusKeys[order.status])}{' '}
          {formatMoney({ amount: order.total, currency: order.currency })}
          {order.testOrder && ` ${t('captainProfile.orders.test')}`}
          {order.redelivery && ` ${t('captainProfile.orders.redelivery')}`}
        </li>
      ))}
    </ul>
  );
}

function Offers(props: { captain: CaptainProfile; city: City; session: AdminSession }) {
  const { t } = useTranslation();
  const { captain, city, session } = props;
  const offers = useQuery(captainOffersQuery(captain.id));
  if (offers.isError) return <p role="alert">{t('common.failed')}</p>;
  if (!offers.data) return <p role="status">{t('status.loading')}</p>;
  if (offers.data.length === 0) return <p>{t('captainProfile.offers.none')}</p>;
  return (
    <table aria-label={t('captainProfile.tab.offers')}>
      <thead>
        <tr>
          <th scope="col">{t('captainProfile.offers.time')}</th>
          <th scope="col">{t('captainProfile.offers.order')}</th>
          <th scope="col">{t('captainProfile.offers.response')}</th>
          <th scope="col">{t('captainProfile.offers.responseTime')}</th>
        </tr>
      </thead>
      <tbody>
        {offers.data.map((offer) => (
          <tr key={offer.id}>
            <td>{formatDateTime(offer.offeredAt, city.timeZone)}</td>
            <td>
              {offer.orderNumber === null ? (
                '—'
              ) : can(session, OPERATIONS_READ) ? (
                <Link
                  to="/orders/$orderId"
                  params={{ orderId: offer.orderId }}
                  search={{ city: city.code }}
                >
                  {t('order.number', { number: offer.orderNumber })}
                </Link>
              ) : (
                t('order.number', { number: offer.orderNumber })
              )}
              {offer.handover && ` ${t('captainProfile.offers.handover')}`}
              {offer.kind === 'auto' && ` ${t('captainProfile.offers.auto')}`}
            </td>
            <td>{t(`captainProfile.offers.status.${offer.status}`)}</td>
            <td>
              {offer.responseSeconds === null
                ? '—'
                : t('captainProfile.offers.seconds', { seconds: offer.responseSeconds })}
            </td>
          </tr>
        ))}
      </tbody>
    </table>
  );
}

function Ratings({ captain, city }: { captain: CaptainProfile; city: City }) {
  const [filters, setFilters] = useState<{
    period: 'all' | 'today' | 'yesterday' | 'last_7_days' | 'last_30_days';
    stars: number | null;
  }>({ period: 'all', stars: null });
  return (
    <RatingsSection
      target={{ party: 'captain', id: captain.id }}
      city={city}
      period={filters.period}
      stars={filters.stars}
      onFilters={setFilters}
    />
  );
}

const statusRefusals = {
  status_change_not_allowed: 'captainProfile.status.notAllowed',
  offboarding_open: 'captainProfile.status.offboarding',
  invalid_captain: 'captainProfile.status.invalidUntil',
  reason_required: 'captainProfile.status.reasonRequired',
} as const;

function Suspensions(props: { captain: CaptainProfile; city: City; session: AdminSession }) {
  const { t } = useTranslation();
  const { captain, city, session } = props;
  const [until, setUntil] = useState('');
  const [reason, setReason] = useState('');
  const change = useSetCaptainStatus(captain.id);
  const suspended = captain.status === 'suspended';
  const why = reason.trim();
  const end = until === '' ? null : zonedToUtc(until, city.timeZone);
  const submit = (event: FormEvent) => {
    event.preventDefault();
    if (why === '' || (until !== '' && end === null)) return;
    change.mutate(
      suspended
        ? { status: 'active', until: null, reason: why }
        : { status: 'suspended', until: end, reason: why },
      {
        onSuccess: (result) => {
          if (result.status === 'done') {
            setReason('');
            setUntil('');
          }
        },
      },
    );
  };
  return (
    <section aria-label={t('captainProfile.tab.suspensions')}>
      {captain.suspension !== null ? (
        <Suspension captain={captain} city={city} />
      ) : (
        <p>{t('captainProfile.status.notSuspended')}</p>
      )}
      {canSuspend(session) && captain.status !== 'terminated' && (
        <form onSubmit={submit} aria-label={t('captainProfile.status.title')}>
          <h3>
            {suspended ? t('captainProfile.status.reactivate') : t('captainProfile.status.suspend')}
          </h3>
          {!suspended && (
            <label>
              {t('captainProfile.status.until')}
              <input
                type="datetime-local"
                value={until}
                onChange={(event) => setUntil(event.target.value)}
              />
            </label>
          )}
          {!suspended && <p>{t('captainProfile.status.untilExplain')}</p>}
          <label>
            {suspended ? t('captainProfile.reason') : t('captainProfile.status.reasonShown')}
            <textarea
              maxLength={500}
              value={reason}
              onChange={(event) => setReason(event.target.value)}
            />
          </label>
          <button type="submit" disabled={change.isPending || why === ''}>
            {suspended
              ? t('captainProfile.status.reactivateConfirm')
              : t('captainProfile.status.suspendConfirm')}
          </button>
          {change.isError && <p role="alert">{t('common.failed')}</p>}
          {change.data?.status === 'refused' && (
            <p role="alert">{t(statusRefusals[change.data.refusal])}</p>
          )}
        </form>
      )}
      <ViolationsSection captain={captain} city={city} session={session} />
    </section>
  );
}

function Notes({ captain, city }: { captain: CaptainProfile; city: City }) {
  const { t } = useTranslation();
  const notes = useQuery(captainNotesQuery(captain.id));
  const add = useAddCaptainNote(captain.id);
  const [text, setText] = useState('');
  const submit = (event: FormEvent) => {
    event.preventDefault();
    const body = noteOf(text);
    if (body !== null) add.mutate(body, { onSuccess: () => setText('') });
  };
  return (
    <section aria-label={t('captainProfile.tab.notes')}>
      <form onSubmit={submit}>
        <label>
          {t('profile.notes.new')}
          <textarea
            value={text}
            maxLength={NOTE_MAX}
            onChange={(event) => setText(event.target.value)}
          />
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

function ChangeLog({ captain, city }: { captain: CaptainProfile; city: City }) {
  const { t } = useTranslation();
  const log = useQuery(captainChangeLogQuery(captain.id));
  if (log.isError) return <p role="alert">{t('common.failed')}</p>;
  if (!log.data) return <p role="status">{t('status.loading')}</p>;
  if (log.data.length === 0) return <p>{t('profile.log.none')}</p>;
  return (
    <ul aria-label={t('captainProfile.tab.log')}>
      {log.data.map((entry) => {
        const action = captainChangeActionOf(entry.action);
        const who =
          entry.actorType === 'system'
            ? t('profile.log.system')
            : (entry.actorName ?? t('profile.someone'));
        return (
          <li key={entry.id}>
            <p>
              {t('captainProfile.log.line', {
                time: formatDateTime(entry.at, city.timeZone),
                action:
                  action === null
                    ? t('profile.log.other')
                    : t(`captainProfile.log.action.${action}`),
                name: who,
              })}
            </p>
            {entry.reason !== null && <p>{t('profile.log.reason', { reason: entry.reason })}</p>}
          </li>
        );
      })}
    </ul>
  );
}
