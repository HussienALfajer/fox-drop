import { useQuery } from '@tanstack/react-query';
import { getRouteApi, Link } from '@tanstack/react-router';
import { type FormEvent, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { type CashLine, type Paper, useCurrentSession } from './cash-desk.js';
import { chosenCity, citiesQuery, type City } from './cities.js';
import {
  aboveDues,
  addressLabelOf,
  BLOCK_KINDS,
  type BlockForm,
  type BlockKind,
  birthdayText,
  blockBodyOf,
  blockKindKeys,
  CASH_DESK_RECORD,
  codeUseKeys,
  CUSTOMERS_BLOCK,
  CUSTOMERS_CLEAR_STRIKES,
  CUSTOMERS_MANAGE,
  CUSTOMERS_READ,
  CUSTOMERS_SIGN_OUT,
  CUSTOMERS_TEST_ACCOUNT,
  type CustomerAction,
  type CustomerProfile,
  type CustomerReceipt,
  duesLinesOf,
  duesPayBodyOf,
  statusKeys,
  useAddNote,
  useBlockCustomer,
  useCustomer,
  useCustomerAction,
  useCustomerReceipt,
  useCustomerReceipts,
  useCustomerSearch,
  useDuesPreview,
  usePayDues,
  useSignOutEverywhere,
  useUnblockCustomer,
} from './customers.js';
import { statusKeys as orderStatusKeys } from './order-labels.js';
import { canReadTickets, ticketStatusKeys } from './tickets.js';
import { formatDateTime, formatMoney } from './format.js';
import { can } from './session.js';
import './receipt-print.css';

const listRoute = getRouteApi('/signed-in/customers');
const profileRoute = getRouteApi('/signed-in/customers/$customerId');
const receiptRoute = getRouteApi('/signed-in/cash-desk/customer-receipts/$receiptId');
const signedIn = getRouteApi('/signed-in');

const paperClasses = { thermal: 'paper-thermal', a4: 'paper-a4' } as const satisfies Record<
  Paper,
  string
>;

// AP §9.8 «الزبائن» (slice 2.25a): the search by the number or the name.
// Unstyled until the design.
export function CustomersPage() {
  const { t } = useTranslation();
  const search = listRoute.useSearch();
  const cities = useQuery(citiesQuery);
  const city = cities.data ? chosenCity(cities.data, search.city) : undefined;
  const [text, setText] = useState('');
  const found = useCustomerSearch(city?.id, text);
  return (
    <main>
      <p>
        <Link to="/">{t('common.home')}</Link>
      </p>
      <h1>{t('customers.title')}</h1>
      <p>
        <label>
          {t('customers.search')}{' '}
          <input value={text} onChange={(event) => setText(event.target.value)} />
        </label>
      </p>
      <p>{t('customers.searchHint')}</p>
      {found.isError || cities.isError ? (
        <p role="alert">{t('common.failed')}</p>
      ) : found.data?.length === 0 ? (
        <p>{t('customers.none')}</p>
      ) : (
        found.data && (
          <ul>
            {found.data.map((customer) => (
              <li key={customer.id}>
                <Link
                  to="/customers/$customerId"
                  params={{ customerId: customer.id }}
                  search={search}
                >
                  {customer.name ?? t('customers.noName')}
                </Link>{' '}
                {customer.maskedPhone && <bdi dir="ltr">{customer.maskedPhone}</bdi>}{' '}
                {t(statusKeys[customer.status])}
              </li>
            ))}
          </ul>
        )
      )}
    </main>
  );
}

// AP §9.8 «ملف الزبون»: the details, the status, the trust, the strikes,
// the dues, the blocks, «حظر», «فك الحظر» and «تسجيل دفع المستحق» (slice
// 2.25a); the orders, tickets, codes, addresses and notes, «توثيق»,
// «إزالة الثقة», «مسح المخالفات», «إنهاء الإيقاف», the test account,
// «تغيير الرقم» and «تسجيل الخروج من كل الأجهزة» (slice 2.25b).
export function CustomerProfilePage() {
  const { t } = useTranslation();
  const { customerId } = profileRoute.useParams();
  const search = profileRoute.useSearch();
  const cities = useQuery(citiesQuery);
  const city = cities.data ? chosenCity(cities.data, search.city) : undefined;
  const profile = useCustomer(city?.id, customerId);
  return (
    <main>
      <p>
        <Link to="/customers" search={search}>
          {t('customers.title')}
        </Link>
      </p>
      {profile.isError || cities.isError ? (
        <p role="alert">{t('common.failed')}</p>
      ) : profile.data === 'unknown' ? (
        <p role="alert">{t('customers.unknown')}</p>
      ) : !profile.data || !city ? (
        <p role="status">{t('status.loading')}</p>
      ) : (
        <ProfileWithActions profile={profile.data} city={city} />
      )}
    </main>
  );
}

function ProfileWithActions({ profile, city }: { profile: CustomerProfile; city: City }) {
  const { t } = useTranslation();
  const { session } = signedIn.useRouteContext();
  const customerId = profile.id;
  const stopId = profile.reviewStop?.id ?? null;
  return (
    <>
      <Profile
        profile={profile}
        city={city}
        linksOrders={can(session, 'operations.read')}
        linksTickets={canReadTickets(session)}
      />
      {can(session, CUSTOMERS_READ) && <AddNote cityId={city.id} customerId={customerId} />}
      {can(session, CUSTOMERS_MANAGE) && (
        <>
          <ProfileAction
            key={profile.trusted ? 1 : 0}
            cityId={city.id}
            customerId={customerId}
            title={t(profile.trusted ? 'customers.untrust.title' : 'customers.trustMark.title')}
            action={(note) => ({
              path: '/v1/admin/customers/{customerId}/trust',
              body: { trusted: !profile.trusted, note },
            })}
          />
          <ChangePhone cityId={city.id} customerId={customerId} />
        </>
      )}
      {can(session, CUSTOMERS_CLEAR_STRIKES) && (
        <>
          {stopId !== null && (
            <ProfileAction
              key={stopId}
              cityId={city.id}
              customerId={customerId}
              title={t('customers.endStop.title')}
              action={(note) => ({
                path: '/v1/admin/customers/{customerId}/end-review-stop',
                body: { stopId, note },
              })}
            />
          )}
          <ProfileAction
            key={profile.lateCancels.cleared?.at ?? 0}
            cityId={city.id}
            customerId={customerId}
            title={t('customers.clearStrikes.title')}
            hint={t('customers.clearStrikes.hint')}
            action={(note) => ({
              path: '/v1/admin/customers/{customerId}/clear-strikes',
              body: { note },
            })}
          />
        </>
      )}
      {can(session, CUSTOMERS_TEST_ACCOUNT) && (
        <TestAccount cityId={city.id} customerId={customerId} flagged={profile.testAccount} />
      )}
      {can(session, CUSTOMERS_SIGN_OUT) && (
        <SignOutEverywhere cityId={city.id} customerId={customerId} />
      )}
      {can(session, CUSTOMERS_BLOCK) && (
        <>
          {profile.block && (
            <Unblock cityId={city.id} customerId={customerId} blockId={profile.block.id} />
          )}
          {/* A block in force still takes dues on top (AP §9.8). */}
          <Block
            key={profile.block?.id ?? 'none'}
            profile={profile}
            city={city}
            kinds={profile.block ? ['dues'] : BLOCK_KINDS}
          />
        </>
      )}
      {can(session, CASH_DESK_RECORD) && (
        <>
          {BigInt(profile.dues.amount) > 0n && <PayDues cityId={city.id} customerId={customerId} />}
          <Receipts customerId={customerId} timeZone={city.timeZone} />
        </>
      )}
    </>
  );
}

function Profile({
  profile,
  city,
  linksOrders,
  linksTickets,
}: {
  profile: CustomerProfile;
  city: City;
  linksOrders: boolean;
  linksTickets: boolean;
}) {
  const { t } = useTranslation();
  const name = [profile.firstName, profile.lastName].filter(Boolean).join(' ');
  const dues = BigInt(profile.dues.amount);
  return (
    <section>
      <h1>{name || t('customers.noName')}</h1>
      <dl>
        <dt>{t('customers.phone')}</dt>
        <dd>
          <bdi dir="ltr">{profile.maskedPhone ?? '—'}</bdi>
        </dd>
        <dt>{t('customers.gender')}</dt>
        <dd>{profile.gender ? t(`customers.genderName.${profile.gender}`) : '—'}</dd>
        <dt>{t('customers.birthday')}</dt>
        <dd>{profile.birthday ? birthdayText(profile.birthday) : '—'}</dd>
        <dt>{t('customers.statusLabel')}</dt>
        <dd>{t(statusKeys[profile.status])}</dd>
        <dt>{t('customers.trust')}</dt>
        <dd>
          {profile.trusted
            ? t('customers.trusted')
            : t('customers.notTrusted', {
                delivered: profile.delivered,
                needed: profile.trustedAfter,
              })}
        </dd>
        {profile.trustMark && (
          <dd>
            {t(profile.trustMark.trusted ? 'customers.trustMarked' : 'customers.trustRemoved', {
              at: formatDateTime(profile.trustMark.at, city.timeZone),
              name: profile.trustMark.byName ?? '—',
              note: profile.trustMark.note,
            })}
          </dd>
        )}
        <dt>{t('customers.lateCancels')}</dt>
        <dd>
          {t('customers.lateCancelsValue', {
            inWindow: profile.lateCancels.inWindow,
            limit: profile.lateCancels.limit,
            days: profile.lateCancels.windowDays,
            total: profile.lateCancels.total,
          })}
        </dd>
        {profile.lateCancels.cleared && (
          <dd>
            {t('customers.strikesCleared', {
              at: formatDateTime(profile.lateCancels.cleared.at, city.timeZone),
              name: profile.lateCancels.cleared.byName ?? '—',
              note: profile.lateCancels.cleared.note,
            })}
          </dd>
        )}
        <dt>{t('customers.testAccount')}</dt>
        <dd>{t(profile.testAccount ? 'customers.yes' : 'customers.no')}</dd>
        <dt>{t('customers.fakeOrders')}</dt>
        <dd>{profile.fakeOrders}</dd>
        <dt>{t('customers.dues')}</dt>
        <dd>
          {profile.dues.currency === null
            ? '—'
            : dues > 0n
              ? t('customers.duesOwed', {
                  amount: formatMoney({
                    amount: profile.dues.amount,
                    currency: profile.dues.currency,
                  }),
                })
              : dues < 0n
                ? t('customers.duesCredit', {
                    amount: formatMoney({
                      amount: profile.dues.amount.slice(1),
                      currency: profile.dues.currency,
                    }),
                  })
                : t('customers.duesNone')}
        </dd>
      </dl>
      {profile.reviewStop && (
        <p>
          {t('customers.reviewStop', {
            at: formatDateTime(profile.reviewStop.startedAt, city.timeZone),
          })}
        </p>
      )}
      {profile.block && (
        <p>
          {profile.block.until
            ? t('customers.blockedUntil', {
                until: formatDateTime(profile.block.until, city.timeZone),
                reason: profile.block.reasonLabel,
              })
            : t('customers.blockedIndefinite', { reason: profile.block.reasonLabel })}{' '}
          {t('customers.customerSees', { text: profile.block.customerText })}
        </p>
      )}
      <h2>{t('customers.orders.title')}</h2>
      <p>
        {t('customers.orders.count', { count: profile.orders.count })}{' '}
        {profile.orders.spent.length > 0 &&
          t('customers.orders.spent', {
            amounts: profile.orders.spent.map((line) => formatMoney(line)).join(' + '),
          })}
      </p>
      {profile.orders.last && (
        <p>
          {t('customers.orders.last', {
            number: profile.orders.last.number,
            at: formatDateTime(profile.orders.last.placedAt, city.timeZone),
            status:
              profile.orders.last.status in orderStatusKeys
                ? t(orderStatusKeys[profile.orders.last.status as keyof typeof orderStatusKeys])
                : '',
          })}{' '}
          {linksOrders && (
            <Link
              to="/orders/$orderId"
              params={{ orderId: profile.orders.last.id }}
              search={{ city: city.code }}
            >
              {t('customers.orders.open')}
            </Link>
          )}
        </p>
      )}
      <h2>{t('customers.tickets.title')}</h2>
      {profile.tickets.length === 0 ? (
        <p>{t('customers.tickets.none')}</p>
      ) : (
        <ul>
          {profile.tickets.map((ticket) => (
            <li key={ticket.id}>
              {linksTickets ? (
                <Link
                  to="/tickets/$ticketId"
                  params={{ ticketId: ticket.id }}
                  search={{ city: city.code }}
                >
                  {t('customers.tickets.number', { number: ticket.number })}
                </Link>
              ) : (
                t('customers.tickets.number', { number: ticket.number })
              )}{' '}
              {ticket.typeLabel}{' '}
              {ticket.status in ticketStatusKeys &&
                t(ticketStatusKeys[ticket.status as keyof typeof ticketStatusKeys])}{' '}
              {ticket.orderNumber && t('customers.tickets.order', { number: ticket.orderNumber })}{' '}
              {formatDateTime(ticket.openedAt, city.timeZone)}
            </li>
          ))}
        </ul>
      )}
      <h2>{t('customers.ratings.title')}</h2>
      <p>{t('customers.ratings.notYet')}</p>
      <h2>{t('customers.codes.title')}</h2>
      {profile.codes.length === 0 ? (
        <p>{t('customers.codes.none')}</p>
      ) : (
        <ul>
          {profile.codes.map((code) => (
            <li key={code.orderId}>
              <bdi dir="ltr">{code.code}</bdi>{' '}
              {t('customers.codes.discount', {
                amount: formatMoney({ amount: code.discount, currency: code.currency }),
              })}{' '}
              {codeUseKeys[code.status] !== undefined &&
                t(codeUseKeys[code.status] as 'customers.codes.held')}{' '}
              {formatDateTime(code.heldAt, city.timeZone)}
            </li>
          ))}
        </ul>
      )}
      <h2>{t('customers.addresses.title')}</h2>
      {profile.addresses.length === 0 ? (
        <p>{t('customers.addresses.none')}</p>
      ) : (
        <ul>
          {profile.addresses.map((address) => (
            <li key={address.id}>
              {t(
                address.isDefault ? 'customers.addresses.lineDefault' : 'customers.addresses.line',
                {
                  label: addressLabelOf(address, t),
                  street: address.street,
                  floor: address.floor ?? '—',
                  landmark: address.landmark,
                  neighbourhood: address.neighbourhood ?? t('customers.addresses.outside'),
                },
              )}{' '}
              <bdi dir="ltr">
                {t('customers.addresses.point', {
                  latitude: address.location.latitude.toFixed(5),
                  longitude: address.location.longitude.toFixed(5),
                })}
              </bdi>
              {address.recipientName && (
                <>
                  {' '}
                  {t('customers.addresses.recipient', { name: address.recipientName })}{' '}
                  <bdi dir="ltr">{address.maskedContactPhone}</bdi>
                </>
              )}
            </li>
          ))}
        </ul>
      )}
      <h2>{t('customers.notes.title')}</h2>
      {profile.notes.length === 0 ? (
        <p>{t('customers.notes.none')}</p>
      ) : (
        <ul>
          {profile.notes.map((note) => (
            <li key={note.id}>
              {note.body}{' '}
              {t('customers.by', {
                at: formatDateTime(note.createdAt, city.timeZone),
                name: note.authorName ?? '—',
              })}
            </li>
          ))}
        </ul>
      )}
      <h2>{t('customers.blocks')}</h2>
      {profile.blocks.length === 0 ? (
        <p>{t('customers.noBlocks')}</p>
      ) : (
        <table>
          <thead>
            <tr>
              <th scope="col">{t('customers.blockTable.kind')}</th>
              <th scope="col">{t('customers.blockTable.reason')}</th>
              <th scope="col">{t('customers.blockTable.started')}</th>
              <th scope="col">{t('customers.blockTable.ended')}</th>
            </tr>
          </thead>
          <tbody>
            {profile.blocks.map((block) => (
              <tr key={block.id}>
                <td>
                  {t(blockKindKeys[block.kind])}
                  {block.until && ` ${formatDateTime(block.until, city.timeZone)}`}
                  {block.duesAmount &&
                    block.duesCurrency &&
                    ` ${formatMoney({ amount: block.duesAmount, currency: block.duesCurrency })}`}
                </td>
                <td>
                  {t('customers.reasonWithNote', { reason: block.reasonLabel, note: block.note })}
                </td>
                <td>
                  {t('customers.by', {
                    at: formatDateTime(block.startedAt, city.timeZone),
                    name: block.startedByName ?? '—',
                  })}
                </td>
                <td>
                  {block.kind === 'dues'
                    ? t('customers.duesBlockEnds')
                    : block.inForce
                      ? t('customers.inForce')
                      : block.endedAt &&
                        (block.endedByName
                          ? t('customers.liftedBy', {
                              at: formatDateTime(block.endedAt, city.timeZone),
                              name: block.endedByName,
                              note: block.endNote ?? '',
                            })
                          : t('customers.ranOut', {
                              at: formatDateTime(block.endedAt, city.timeZone),
                            }))}
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      )}
    </section>
  );
}

function Block({
  profile,
  city,
  kinds,
}: {
  profile: CustomerProfile;
  city: City;
  kinds: readonly BlockKind[];
}) {
  const { t } = useTranslation();
  const block = useBlockCustomer(city.id, profile.id);
  const [form, setForm] = useState<BlockForm>({
    kind: kinds.includes('indefinite') ? 'indefinite' : kinds[0]!,
    until: '',
    amount: '',
    reason: '',
    note: '',
  });
  const [problem, setProblem] = useState<string | null>(null);
  const result = block.data;

  function submit(event: FormEvent) {
    event.preventDefault();
    const built = blockBodyOf(
      city.id,
      form,
      { timeZone: city.timeZone, currency: profile.dues.currency },
      new Date(),
    );
    if (built.status === 'problem') {
      setProblem(t(`customers.block.problem.${built.problem}`));
      return;
    }
    setProblem(null);
    block.mutate(built.body);
  }

  return (
    <form onSubmit={submit}>
      <h2>{t('customers.block.title')}</h2>
      <fieldset>
        <legend>{t('customers.block.kindLabel')}</legend>
        {kinds.map((kind) => (
          <label key={kind}>
            <input
              type="radio"
              name="kind"
              checked={form.kind === kind}
              onChange={() => setForm({ ...form, kind })}
            />{' '}
            {t(blockKindKeys[kind])}
          </label>
        ))}
      </fieldset>
      {form.kind === 'until' && (
        <p>
          <label>
            {t('customers.block.until')}{' '}
            <input
              type="datetime-local"
              value={form.until}
              onChange={(event) => setForm({ ...form, until: event.target.value })}
            />
          </label>
        </p>
      )}
      {form.kind === 'dues' && (
        <>
          <p>
            <label>
              {t('customers.block.amount', { currency: profile.dues.currency ?? '' })}{' '}
              <input
                inputMode="decimal"
                value={form.amount}
                onChange={(event) => setForm({ ...form, amount: event.target.value })}
              />
            </label>
          </p>
          <p>{t('customers.block.duesHint')}</p>
        </>
      )}
      <p>
        <label>
          {t('customers.block.reason')}{' '}
          <select
            value={form.reason}
            onChange={(event) => setForm({ ...form, reason: event.target.value })}
          >
            <option value="">{t('customers.block.chooseReason')}</option>
            {profile.blockReasons.map((reason) => (
              <option key={reason.code} value={reason.code}>
                {reason.label}
              </option>
            ))}
          </select>
        </label>
      </p>
      <p>
        <label>
          {t('customers.block.note')}{' '}
          <textarea
            value={form.note}
            onChange={(event) => setForm({ ...form, note: event.target.value })}
          />
        </label>
      </p>
      <p>
        <button type="submit" disabled={block.isPending}>
          {t('customers.block.submit')}
        </button>
      </p>
      {problem && <p role="alert">{problem}</p>}
      {result?.status === 'refused' && (
        <p role="alert">{t(`customers.refused.${result.refusal}`)}</p>
      )}
      {block.isError && <p role="alert">{t('common.failed')}</p>}
    </form>
  );
}

function Unblock({
  cityId,
  customerId,
  blockId,
}: {
  cityId: string;
  customerId: string;
  blockId: string;
}) {
  const { t } = useTranslation();
  const unblock = useUnblockCustomer(cityId, customerId);
  const [note, setNote] = useState('');
  const result = unblock.data;
  return (
    <form
      onSubmit={(event) => {
        event.preventDefault();
        if (note.trim() !== '') unblock.mutate({ blockId, note });
      }}
    >
      <h2>{t('customers.unblock.title')}</h2>
      <p>
        <label>
          {t('customers.unblock.note')}{' '}
          <textarea value={note} onChange={(event) => setNote(event.target.value)} />
        </label>
      </p>
      <p>
        <button type="submit" disabled={unblock.isPending || note.trim() === ''}>
          {t('customers.unblock.submit')}
        </button>
      </p>
      {result?.status === 'refused' && (
        <p role="alert">{t(`customers.refused.${result.refusal}`)}</p>
      )}
      {unblock.isError && <p role="alert">{t('common.failed')}</p>}
    </form>
  );
}

// Slice 2.25b: a profile command that needs only its reason («توثيق»,
// «إزالة الثقة», «مسح المخالفات», «إنهاء الإيقاف»).
function ProfileAction({
  cityId,
  customerId,
  title,
  hint,
  action,
}: {
  cityId: string;
  customerId: string;
  title: string;
  hint?: string;
  action: (note: string) => CustomerAction;
}) {
  const { t } = useTranslation();
  const command = useCustomerAction(cityId, customerId);
  const [note, setNote] = useState('');
  const result = command.data;
  return (
    <form
      onSubmit={(event) => {
        event.preventDefault();
        if (note.trim() !== '') command.mutate(action(note.trim()));
      }}
    >
      <h2>{title}</h2>
      {hint && <p>{hint}</p>}
      <p>
        <label>
          {t('customers.action.note')}{' '}
          <textarea value={note} onChange={(event) => setNote(event.target.value)} />
        </label>
      </p>
      <p>
        <button type="submit" disabled={command.isPending || note.trim() === ''}>
          {title}
        </button>
      </p>
      {result?.status === 'refused' && (
        <p role="alert">{t(`customers.refused.${result.refusal}`)}</p>
      )}
      {command.isError && <p role="alert">{t('common.failed')}</p>}
    </form>
  );
}

// «تغيير الرقم» (AP §9.8, CU §5.4): the customer signs in again everywhere.
function ChangePhone({ cityId, customerId }: { cityId: string; customerId: string }) {
  const { t } = useTranslation();
  const command = useCustomerAction(cityId, customerId);
  const [phone, setPhone] = useState('');
  const [note, setNote] = useState('');
  const result = command.data;
  const ready = phone.trim() !== '' && note.trim() !== '';
  return (
    <form
      onSubmit={(event) => {
        event.preventDefault();
        if (ready) {
          command.mutate({
            path: '/v1/admin/customers/{customerId}/change-phone',
            body: { phone: phone.trim(), note: note.trim() },
          });
        }
      }}
    >
      <h2>{t('customers.changePhone.title')}</h2>
      <p>{t('customers.changePhone.hint')}</p>
      <p>
        <label>
          {t('customers.changePhone.phone')}{' '}
          <input
            dir="ltr"
            inputMode="tel"
            value={phone}
            onChange={(event) => setPhone(event.target.value)}
          />
        </label>
      </p>
      <p>
        <label>
          {t('customers.action.note')}{' '}
          <textarea value={note} onChange={(event) => setNote(event.target.value)} />
        </label>
      </p>
      <p>
        <button type="submit" disabled={command.isPending || !ready}>
          {t('customers.changePhone.submit')}
        </button>
      </p>
      {result?.status === 'done' && <p role="status">{t('customers.changePhone.done')}</p>}
      {result?.status === 'refused' && (
        <p role="alert">{t(`customers.refused.${result.refusal}`)}</p>
      )}
      {command.isError && <p role="alert">{t('common.failed')}</p>}
    </form>
  );
}

// «حساب تجريبي للإدارة» (OWN): sees the restaurants in test mode.
function TestAccount({
  cityId,
  customerId,
  flagged,
}: {
  cityId: string;
  customerId: string;
  flagged: boolean;
}) {
  const { t } = useTranslation();
  const command = useCustomerAction(cityId, customerId);
  return (
    <section>
      <h2>{t('customers.testAccountAction.title')}</h2>
      <p>{t('customers.testAccountAction.hint')}</p>
      <p>
        <button
          type="button"
          disabled={command.isPending}
          onClick={() =>
            command.mutate({
              path: '/v1/admin/customers/{customerId}/test-account',
              body: { flagged: !flagged },
            })
          }
        >
          {t(flagged ? 'customers.testAccountAction.off' : 'customers.testAccountAction.on')}
        </button>
      </p>
      {command.isError && <p role="alert">{t('common.failed')}</p>}
    </section>
  );
}

// «تسجيل الخروج من كل الأجهزة» (AP §9.8): after a lost or sold phone.
function SignOutEverywhere({ cityId, customerId }: { cityId: string; customerId: string }) {
  const { t } = useTranslation();
  const signOut = useSignOutEverywhere(cityId, customerId);
  const [note, setNote] = useState('');
  return (
    <form
      onSubmit={(event) => {
        event.preventDefault();
        if (note.trim() !== '') signOut.mutate(note.trim());
      }}
    >
      <h2>{t('customers.signOut.title')}</h2>
      <p>{t('customers.signOut.hint')}</p>
      <p>
        <label>
          {t('customers.action.note')}{' '}
          <textarea value={note} onChange={(event) => setNote(event.target.value)} />
        </label>
      </p>
      <p>
        <button type="submit" disabled={signOut.isPending || note.trim() === ''}>
          {t('customers.signOut.title')}
        </button>
      </p>
      {signOut.data !== undefined && (
        <p role="status">{t('customers.signOut.done', { count: signOut.data })}</p>
      )}
      {signOut.isError && <p role="alert">{t('common.failed')}</p>}
    </form>
  );
}

// «ملاحظة داخلية»: everyone who reads the customers.
function AddNote({ cityId, customerId }: { cityId: string; customerId: string }) {
  const { t } = useTranslation();
  const add = useAddNote(cityId, customerId);
  const [body, setBody] = useState('');
  return (
    <form
      onSubmit={(event) => {
        event.preventDefault();
        const text = body.trim();
        if (text !== '') add.mutate(text, { onSuccess: () => setBody('') });
      }}
    >
      <h2>{t('customers.notes.add')}</h2>
      <p>
        <label>
          {t('customers.notes.body')}{' '}
          <textarea
            maxLength={500}
            value={body}
            onChange={(event) => setBody(event.target.value)}
          />
        </label>
      </p>
      <p>
        <button type="submit" disabled={add.isPending || body.trim() === ''}>
          {t('customers.notes.submit')}
        </button>
      </p>
      {add.isError && <p role="alert">{t('common.failed')}</p>}
    </form>
  );
}

// AP §8.8 «تسجيل دفع المستحق»: the cash per currency of the open drawer, in
// part or in full, reviewed at the current rate, then the receipt.
function PayDues({ cityId, customerId }: { cityId: string; customerId: string }) {
  const { t } = useTranslation();
  const current = useCurrentSession(cityId);
  const [typed, setTyped] = useState<Record<string, string>>({});
  const [reviewed, setReviewed] = useState<CashLine[] | null>(null);
  const [problem, setProblem] = useState<string | null>(null);
  if (current.isError) return <p role="alert">{t('common.failed')}</p>;
  if (!current.data) return <p role="status">{t('status.loading')}</p>;
  const session = current.data.session;
  if (!session) {
    return (
      <section>
        <h2>{t('customers.pay.title')}</h2>
        <p>
          <Link to="/cash-desk">{t('customers.pay.noSession')}</Link>
        </p>
      </section>
    );
  }
  const currencies = session.currencies.map((each) => each.currency);

  function review(event: FormEvent) {
    event.preventDefault();
    const result = duesLinesOf(typed, currencies);
    if (result.status === 'lines') {
      setProblem(null);
      setReviewed(result.lines);
    } else {
      setReviewed(null);
      setProblem(
        result.status === 'invalid'
          ? t('customers.pay.invalid', { currency: result.currency })
          : t('customers.pay.empty'),
      );
    }
  }

  return (
    <section>
      <h2>{t('customers.pay.title')}</h2>
      <form onSubmit={review}>
        <p>{t('customers.pay.hint')}</p>
        {currencies.map((currency) => (
          <p key={currency}>
            <label>
              {t('customers.pay.amount', { currency })}{' '}
              <input
                inputMode="decimal"
                value={typed[currency] ?? ''}
                onChange={(event) => {
                  setTyped({ ...typed, [currency]: event.target.value });
                  setReviewed(null);
                }}
              />
            </label>
          </p>
        ))}
        <p>
          <button type="submit">{t('customers.pay.review')}</button>
        </p>
        {problem && <p role="alert">{problem}</p>}
      </form>
      {reviewed && <PayReview cityId={cityId} customerId={customerId} lines={reviewed} />}
    </section>
  );
}

function PayReview({
  cityId,
  customerId,
  lines,
}: {
  cityId: string;
  customerId: string;
  lines: CashLine[];
}) {
  const { t } = useTranslation();
  const preview = useDuesPreview(cityId, customerId, lines);
  const pay = usePayDues(cityId, customerId);
  if (preview.isError) return <p role="alert">{t('common.failed')}</p>;
  if (preview.data === 'refused') return <p role="alert">{t('customers.pay.quoteRefused')}</p>;
  if (!preview.data) return <p role="status">{t('status.loading')}</p>;
  const quoted = preview.data;
  const above = aboveDues(quoted);
  const result = pay.data;
  return (
    <section>
      <ul>
        {quoted.lines.map((line) => (
          <li key={line.currency}>
            {t('customers.pay.line', {
              amount: formatMoney({ amount: line.amount, currency: line.currency }),
              base: formatMoney({ amount: line.base, currency: quoted.currency }),
            })}
            {line.unit && (
              <>
                {' '}
                {t('customers.pay.rate', {
                  from: line.unit.from,
                  value: line.unit.value,
                  to: line.unit.to,
                })}
              </>
            )}
          </li>
        ))}
      </ul>
      <p>
        {t('customers.pay.total', {
          amount: formatMoney({ amount: quoted.total, currency: quoted.currency }),
        })}
      </p>
      {above ? (
        <p role="alert">{t('customers.pay.above')}</p>
      ) : (
        <p>
          {t('customers.pay.remaining', {
            amount: formatMoney({ amount: quoted.remaining, currency: quoted.currency }),
          })}
        </p>
      )}
      {result?.status === 'paid' ? (
        <p role="status">
          <Link
            to="/cash-desk/customer-receipts/$receiptId"
            params={{ receiptId: result.receipt.id }}
          >
            {t('customers.pay.done', { number: result.receipt.number })}
          </Link>
        </p>
      ) : (
        <>
          <p>
            <button
              type="button"
              disabled={above || pay.isPending}
              onClick={() => pay.mutate(duesPayBodyOf(quoted))}
            >
              {t('customers.pay.confirm')}
            </button>
          </p>
          {result?.status === 'refused' && (
            <p role="alert">{t(`customers.pay.refused.${result.refusal}`)}</p>
          )}
          {pay.isError && <p role="alert">{t('common.failed')}</p>}
        </>
      )}
    </section>
  );
}

function Receipts({ customerId, timeZone }: { customerId: string; timeZone: string }) {
  const { t } = useTranslation();
  const receipts = useCustomerReceipts(customerId, true);
  if (receipts.isError) return <p role="alert">{t('common.failed')}</p>;
  if (!receipts.data || receipts.data.length === 0) return null;
  return (
    <section>
      <h2>{t('customers.receipts')}</h2>
      <ul>
        {receipts.data.map((receipt) => (
          <li key={receipt.id}>
            <Link to="/cash-desk/customer-receipts/$receiptId" params={{ receiptId: receipt.id }}>
              {receipt.number}
            </Link>{' '}
            {formatDateTime(receipt.createdAt, timeZone)}{' '}
            {formatMoney({ amount: receipt.total, currency: receipt.currency })}
          </li>
        ))}
      </ul>
    </section>
  );
}

// AP §4.8: the customer's receipt, printed on an 80 mm roll or on A4.
export function CustomerReceiptPage() {
  const { t } = useTranslation();
  const { receiptId } = receiptRoute.useParams();
  const receipt = useCustomerReceipt(receiptId);
  const cities = useQuery(citiesQuery);
  const [paper, setPaper] = useState<Paper>('thermal');

  function print(choice: Paper) {
    setPaper(choice);
    requestAnimationFrame(() => window.print());
  }

  const city = cities.data?.find((each) => each.id === receipt.data?.cityId);
  return (
    <main>
      {receipt.isError || cities.isError ? (
        <p role="alert">{t('common.failed')}</p>
      ) : !receipt.data || !city ? (
        <p role="status">{t('status.loading')}</p>
      ) : (
        <>
          <p className="no-print">
            <Link
              to="/customers/$customerId"
              params={{ customerId: receipt.data.customerId }}
              search={{ city: city.code }}
            >
              {t('customers.backToProfile')}
            </Link>{' '}
            <button type="button" onClick={() => print('thermal')}>
              {t('cashDesk.receipt.printThermal')}
            </button>{' '}
            <button type="button" onClick={() => print('a4')}>
              {t('cashDesk.receipt.printA4')}
            </button>
          </p>
          <ReceiptView receipt={receipt.data} timeZone={city.timeZone} paper={paper} />
        </>
      )}
    </main>
  );
}

function ReceiptView({
  receipt,
  timeZone,
  paper,
}: {
  receipt: CustomerReceipt;
  timeZone: string;
  paper: Paper;
}) {
  const { t } = useTranslation();
  return (
    <article
      className={['receipt', paperClasses[paper]].join(' ')}
      aria-labelledby="customer-receipt-number"
    >
      <h1>{t('app.name')}</h1>
      <h2 id="customer-receipt-number">
        {t('cashDesk.receipt.number', { number: receipt.number })}
      </h2>
      <p>{t('cashDesk.receiptType.customer_dues_payment')}</p>
      <p>{formatDateTime(receipt.createdAt, timeZone)}</p>
      <p>{t('customers.receipt.customer', { name: receipt.customerName })}</p>
      <p>{t('cashDesk.receipt.cashier', { name: receipt.cashierName ?? '' })}</p>
      <table>
        <thead>
          <tr>
            <th scope="col">{t('cashDesk.currency')}</th>
            <th scope="col">{t('restaurantSettlement.receipt.amount')}</th>
            <th scope="col">
              {t('restaurantSettlement.receipt.base', { currency: receipt.currency })}
            </th>
          </tr>
        </thead>
        <tbody>
          {receipt.lines.map((line) => (
            <tr key={line.currency}>
              <th scope="row">{line.currency}</th>
              <td>{formatMoney({ amount: line.amount, currency: line.currency })}</td>
              <td>{formatMoney({ amount: line.base, currency: receipt.currency })}</td>
            </tr>
          ))}
        </tbody>
      </table>
      <p>
        {t('customers.receipt.total', {
          amount: formatMoney({ amount: receipt.total, currency: receipt.currency }),
        })}
      </p>
      <p>
        {t('customers.receipt.before', {
          amount: formatMoney({ amount: receipt.dueBefore, currency: receipt.currency }),
        })}
      </p>
      <p>
        {t('customers.receipt.after', {
          amount: formatMoney({ amount: receipt.dueAfter, currency: receipt.currency }),
        })}
      </p>
    </article>
  );
}
