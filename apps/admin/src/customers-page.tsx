import { useQuery } from '@tanstack/react-query';
import { getRouteApi, Link } from '@tanstack/react-router';
import { type FormEvent, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { type CashLine, type Paper, useCurrentSession } from './cash-desk.js';
import { chosenCity, citiesQuery, type City } from './cities.js';
import {
  aboveDues,
  BLOCK_KINDS,
  type BlockForm,
  type BlockKind,
  birthdayText,
  blockBodyOf,
  blockKindKeys,
  CASH_DESK_RECORD,
  CUSTOMERS_BLOCK,
  type CustomerProfile,
  type CustomerReceipt,
  duesLinesOf,
  duesPayBodyOf,
  statusKeys,
  useBlockCustomer,
  useCustomer,
  useCustomerReceipt,
  useCustomerReceipts,
  useCustomerSearch,
  useDuesPreview,
  usePayDues,
  useUnblockCustomer,
} from './customers.js';
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

// AP §9.8 «ملف الزبون» as slice 2.25a builds it: the details, the status,
// the trust, the strikes, the dues, the blocks, «حظر», «فك الحظر» and
// «تسجيل دفع المستحق».
export function CustomerProfilePage() {
  const { t } = useTranslation();
  const { customerId } = profileRoute.useParams();
  const search = profileRoute.useSearch();
  const { session } = signedIn.useRouteContext();
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
        <>
          <Profile profile={profile.data} city={city} />
          {can(session, CUSTOMERS_BLOCK) && (
            <>
              {profile.data.block && (
                <Unblock cityId={city.id} customerId={customerId} blockId={profile.data.block.id} />
              )}
              {/* A block in force still takes dues on top (AP §9.8). */}
              <Block
                key={profile.data.block?.id ?? 'none'}
                profile={profile.data}
                city={city}
                kinds={profile.data.block ? ['dues'] : BLOCK_KINDS}
              />
            </>
          )}
          {can(session, CASH_DESK_RECORD) && (
            <>
              {BigInt(profile.data.dues.amount) > 0n && (
                <PayDues cityId={city.id} customerId={customerId} />
              )}
              <Receipts customerId={customerId} timeZone={city.timeZone} />
            </>
          )}
        </>
      )}
    </main>
  );
}

function Profile({ profile, city }: { profile: CustomerProfile; city: City }) {
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
        <dt>{t('customers.lateCancels')}</dt>
        <dd>
          {t('customers.lateCancelsValue', {
            inWindow: profile.lateCancels.inWindow,
            limit: profile.lateCancels.limit,
            days: profile.lateCancels.windowDays,
            total: profile.lateCancels.total,
          })}
        </dd>
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
