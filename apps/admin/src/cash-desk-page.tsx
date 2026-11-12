import { useQuery } from '@tanstack/react-query';
import { getRouteApi, Link } from '@tanstack/react-router';
import { type FormEvent, useState } from 'react';
import { useTranslation } from 'react-i18next';
import {
  type CurrentSession,
  type CustodyLine,
  cashLinesOf,
  type DeskCustody,
  type DrawerSession,
  directionOf,
  type HandInRefusal,
  handInLinesOf,
  remainingOf,
  type SessionRefusal,
  type Typed,
  useCaptainSearch,
  useCloseSession,
  useCurrentSession,
  useDeskCustody,
  useHandIn,
  useOpenSession,
  useSessions,
} from './cash-desk.js';
import { type City, chosenCity, citiesQuery } from './cities.js';
import { formatDateTime, formatMoney } from './format.js';

const route = getRouteApi('/signed-in/cash-desk');
const sessionsRoute = getRouteApi('/signed-in/cash-desk/sessions');

const sessionRefusalKeys = {
  session_open: 'cashDesk.refusal.session_open',
  session_closed: 'cashDesk.refusal.session_closed',
  note_required: 'cashDesk.refusal.note_required',
  invalid_amounts: 'cashDesk.refusal.invalid_amounts',
} as const satisfies Record<SessionRefusal, string>;

const handInRefusalKeys = {
  no_open_session: 'cashDesk.refusal.no_open_session',
  nothing_due: 'cashDesk.refusal.nothing_due',
  above_custody: 'cashDesk.refusal.above_custody',
  unknown_captain: 'cashDesk.refusal.unknown_captain',
  invalid_amounts: 'cashDesk.refusal.invalid_amounts',
} as const satisfies Record<HandInRefusal, string>;

const statusKeys = {
  active: 'cashDesk.status.active',
  suspended: 'cashDesk.status.suspended',
  terminated: 'cashDesk.status.terminated',
} as const;

// AP §9.10.3 «الصندوق» (slice 2.17a): the user's drawer session and
// «تسليم النقد اليومي». Unstyled until the design.
export function CashDeskPage() {
  const { t } = useTranslation();
  const search = route.useSearch();
  const cities = useQuery(citiesQuery);
  const city = cities.data ? chosenCity(cities.data, search.city) : undefined;
  const current = useCurrentSession(city?.id);
  return (
    <main>
      <h1>{t('cashDesk.title')}</h1>
      <p>
        <Link to="/">{t('common.home')}</Link>{' '}
        <Link to="/cash-desk/sessions" search={search}>
          {t('cashDesk.sessions.title')}
        </Link>
      </p>
      {cities.isError || current.isError ? (
        <p role="alert">{t('common.failed')}</p>
      ) : !city || !current.data ? (
        <p role="status">{t('status.loading')}</p>
      ) : (
        <>
          <SessionSection current={current.data} city={city} />
          {current.data.session && <HandInSection city={city} />}
        </>
      )}
    </main>
  );
}

function SessionSection({ current, city }: { current: CurrentSession; city: City }) {
  const { t } = useTranslation();
  return (
    <section aria-labelledby="drawer-session">
      <h2 id="drawer-session">{t('cashDesk.session.title')}</h2>
      {current.session ? (
        <>
          <p>
            {t('cashDesk.session.openSince', {
              at: formatDateTime(current.session.openedAt, city.timeZone),
            })}
          </p>
          <SessionCash session={current.session} />
          <CloseSession key={current.session.id} session={current.session} />
        </>
      ) : (
        <OpenSession currencies={current.currencies} city={city} />
      )}
    </section>
  );
}

function SessionCash({ session }: { session: DrawerSession }) {
  const { t } = useTranslation();
  return (
    <table>
      <thead>
        <tr>
          <th scope="col">{t('cashDesk.currency')}</th>
          <th scope="col">{t('cashDesk.session.float')}</th>
          <th scope="col">{t('cashDesk.session.expected')}</th>
          {session.closedAt && <th scope="col">{t('cashDesk.session.counted')}</th>}
          {session.closedAt && <th scope="col">{t('cashDesk.session.variance')}</th>}
        </tr>
      </thead>
      <tbody>
        {session.currencies.map((line) => (
          <tr key={line.currency}>
            <th scope="row">{line.currency}</th>
            <td>{formatMoney({ amount: line.openingFloat, currency: line.currency })}</td>
            <td>{formatMoney({ amount: line.expected, currency: line.currency })}</td>
            {session.closedAt && (
              <td>
                {line.counted !== null &&
                  formatMoney({ amount: line.counted, currency: line.currency })}
              </td>
            )}
            {session.closedAt && (
              <td>
                {line.variance !== null &&
                  formatMoney({ amount: line.variance, currency: line.currency })}
              </td>
            )}
          </tr>
        ))}
      </tbody>
    </table>
  );
}

function AmountFields({
  currencies,
  typed,
  onChange,
  label,
}: {
  currencies: readonly string[];
  typed: Typed;
  onChange: (typed: Typed) => void;
  label: (currency: string) => string;
}) {
  return (
    <>
      {currencies.map((currency) => (
        <p key={currency}>
          <label>
            {label(currency)}{' '}
            <input
              inputMode="decimal"
              value={typed[currency] ?? ''}
              onChange={(event) => onChange({ ...typed, [currency]: event.target.value })}
            />
          </label>
        </p>
      ))}
    </>
  );
}

// «فتح الصندوق»: the float counted per currency (empty is zero).
function OpenSession({ currencies, city }: { currencies: string[]; city: City }) {
  const { t } = useTranslation();
  const open = useOpenSession(city.id);
  const [typed, setTyped] = useState<Typed>({});
  const parsed = cashLinesOf(typed, currencies);

  function submit(event: FormEvent) {
    event.preventDefault();
    if ('lines' in parsed) open.mutate(parsed.lines);
  }

  return (
    <form onSubmit={submit}>
      <p>{t('cashDesk.session.none')}</p>
      <AmountFields
        currencies={currencies}
        typed={typed}
        onChange={setTyped}
        label={(currency) => t('cashDesk.session.floatIn', { currency })}
      />
      {'problem' in parsed && (
        <p role="alert">{t('cashDesk.problem.amount', { currency: parsed.problem })}</p>
      )}
      <button type="submit" disabled={'problem' in parsed || open.isPending}>
        {t('cashDesk.session.open')}
      </button>
      {open.isError && <p role="alert">{t('common.failed')}</p>}
      {open.data?.status === 'refused' && (
        <p role="alert">{t(sessionRefusalKeys[open.data.refusal])}</p>
      )}
    </form>
  );
}

// «إقفال الصندوق»: the counted cash of every currency; a variance needs a
// note, kept with the session.
function CloseSession({ session }: { session: DrawerSession }) {
  const { t } = useTranslation();
  const close = useCloseSession();
  const [typed, setTyped] = useState<Typed>({});
  const [note, setNote] = useState('');
  const currencies = session.currencies.map((line) => line.currency);
  const parsed = cashLinesOf(typed, currencies);
  const complete = 'lines' in parsed && parsed.lines.length === currencies.length;
  const variance =
    'lines' in parsed &&
    parsed.lines.some(
      (line) =>
        BigInt(line.amount) !==
        BigInt(session.currencies.find((each) => each.currency === line.currency)!.expected),
    );

  function submit(event: FormEvent) {
    event.preventDefault();
    if (!complete || !('lines' in parsed)) return;
    close.mutate({ sessionId: session.id, counted: parsed.lines, note: note.trim() || null });
  }

  return (
    <form onSubmit={submit}>
      <h3>{t('cashDesk.session.close')}</h3>
      <AmountFields
        currencies={currencies}
        typed={typed}
        onChange={setTyped}
        label={(currency) => t('cashDesk.session.countedIn', { currency })}
      />
      {'problem' in parsed && (
        <p role="alert">{t('cashDesk.problem.amount', { currency: parsed.problem })}</p>
      )}
      {variance && <p>{t('cashDesk.session.varianceNote')}</p>}
      <p>
        <label>
          {t('cashDesk.session.note')}{' '}
          <textarea
            value={note}
            maxLength={500}
            onChange={(event) => setNote(event.target.value)}
          />
        </label>
      </p>
      <button
        type="submit"
        disabled={!complete || (variance && note.trim() === '') || close.isPending}
      >
        {t('cashDesk.session.close')}
      </button>
      {close.isError && <p role="alert">{t('common.failed')}</p>}
      {close.data?.status === 'refused' && (
        <p role="alert">{t(sessionRefusalKeys[close.data.refusal])}</p>
      )}
    </form>
  );
}

// «تسليم النقد اليومي»: find the captain, see the custody, record.
function HandInSection({ city }: { city: City }) {
  const { t } = useTranslation();
  const [text, setText] = useState('');
  const [captainId, setCaptainId] = useState<string | undefined>();
  const found = useCaptainSearch(city.id, text);
  return (
    <section aria-labelledby="hand-in">
      <h2 id="hand-in">{t('cashDesk.handIn.title')}</h2>
      <p>
        <label>
          {t('cashDesk.handIn.search')}{' '}
          <input value={text} onChange={(event) => setText(event.target.value)} />
        </label>
      </p>
      {found.isError && <p role="alert">{t('common.failed')}</p>}
      {found.data && found.data.length === 0 && <p>{t('cashDesk.handIn.noneFound')}</p>}
      {found.data && found.data.length > 0 && (
        <ul>
          {found.data.map((captain) => (
            <li key={captain.id}>
              <button type="button" onClick={() => setCaptainId(captain.id)}>
                {captain.name}
              </button>{' '}
              {t(statusKeys[captain.status])}
            </li>
          ))}
        </ul>
      )}
      {captainId && <CaptainCustody key={captainId} captainId={captainId} city={city} />}
    </section>
  );
}

function CaptainCustody({ captainId, city }: { captainId: string; city: City }) {
  const { t } = useTranslation();
  const custody = useDeskCustody(captainId);
  if (custody.isError) return <p role="alert">{t('common.failed')}</p>;
  if (!custody.data) return <p role="status">{t('status.loading')}</p>;
  return <HandInForm custody={custody.data} city={city} />;
}

function HandInForm({ custody, city }: { custody: DeskCustody; city: City }) {
  const { t } = useTranslation();
  const handIn = useHandIn();
  const [typed, setTyped] = useState<Typed>({});
  const [confirming, setConfirming] = useState(false);
  const parsed = handInLinesOf(typed, custody);
  const active = custody.currencies.filter((line) => directionOf(line) !== 'none');
  const byCurrency = new Map(custody.currencies.map((line) => [line.currency, line]));

  function submit(event: FormEvent) {
    event.preventDefault();
    if (!parsed || !('lines' in parsed)) return;
    if (!confirming) {
      setConfirming(true);
      return;
    }
    handIn.mutate(
      { captainId: custody.id, lines: parsed.lines },
      { onSuccess: (result) => result.status === 'recorded' && setTyped({}) },
    );
    setConfirming(false);
  }

  const money = (amount: string, currency: string) => formatMoney({ amount, currency });

  return (
    <form onSubmit={submit}>
      <h3>{custody.name}</h3>
      <p>
        {t('cashDesk.handIn.closedDue', {
          amount: money(custody.closedDue.amount, custody.closedDue.currency),
          cutoff: formatDateTime(custody.lastCutoff, city.timeZone),
        })}
      </p>
      {custody.currencies.length === 0 ? (
        <p>{t('cashDesk.handIn.noCustody')}</p>
      ) : (
        <table>
          <thead>
            <tr>
              <th scope="col">{t('cashDesk.currency')}</th>
              <th scope="col">{t('cashDesk.handIn.previousDays')}</th>
              <th scope="col">{t('cashDesk.handIn.today')}</th>
              <th scope="col">{t('cashDesk.handIn.expected')}</th>
              <th scope="col">{t('cashDesk.handIn.baseEquivalent')}</th>
            </tr>
          </thead>
          <tbody>
            {custody.currencies.map((line) => (
              <tr key={line.currency}>
                <th scope="row">{line.currency}</th>
                <td>{money(line.closedDue, line.currency)}</td>
                <td>{money(line.today, line.currency)}</td>
                <td>
                  <Expected line={line} />
                </td>
                <td>{money(line.balanceInBase, custody.closedDue.currency)}</td>
              </tr>
            ))}
          </tbody>
        </table>
      )}
      {active.map((line) => (
        <p key={line.currency}>
          <label>
            {directionOf(line) === 'hand_in'
              ? t('cashDesk.handIn.receivedIn', { currency: line.currency })
              : t('cashDesk.handIn.paidIn', { currency: line.currency })}{' '}
            <input
              inputMode="decimal"
              value={typed[line.currency] ?? ''}
              onChange={(event) => {
                setConfirming(false);
                setTyped({ ...typed, [line.currency]: event.target.value });
              }}
            />
          </label>
        </p>
      ))}
      {parsed && 'problem' in parsed && (
        <p role="alert">
          {parsed.problem === 'above'
            ? t('cashDesk.problem.above', { currency: parsed.currency })
            : t('cashDesk.problem.amount', { currency: parsed.currency })}
        </p>
      )}
      {confirming && parsed && 'lines' in parsed && (
        <section aria-labelledby="hand-in-confirm">
          <h4 id="hand-in-confirm">{t('cashDesk.handIn.confirmTitle')}</h4>
          <ul>
            {parsed.lines.map((each) => {
              const line = byCurrency.get(each.currency)!;
              const remaining = remainingOf(line, each.amount);
              return (
                <li key={each.currency}>
                  {directionOf(line) === 'hand_in'
                    ? t('cashDesk.handIn.willReceive', {
                        amount: money(each.amount, each.currency),
                      })
                    : t('cashDesk.handIn.willPay', {
                        amount: money(each.amount, each.currency),
                      })}{' '}
                  {BigInt(remaining) === 0n
                    ? t('cashDesk.handIn.settled')
                    : t('cashDesk.handIn.remaining', {
                        amount: money(remaining, each.currency),
                      })}
                </li>
              );
            })}
          </ul>
        </section>
      )}
      <button type="submit" disabled={!parsed || !('lines' in parsed) || handIn.isPending}>
        {confirming ? t('cashDesk.handIn.confirm') : t('cashDesk.handIn.review')}
      </button>
      {handIn.isError && <p role="alert">{t('common.failed')}</p>}
      {handIn.data?.status === 'refused' && (
        <p role="alert">{t(handInRefusalKeys[handIn.data.refusal])}</p>
      )}
      {handIn.data?.status === 'recorded' && (
        <ul role="status">
          {handIn.data.receipts.map((receipt) => (
            <li key={receipt.id}>
              <Link to="/cash-desk/receipts/$receiptId" params={{ receiptId: receipt.id }}>
                {t('cashDesk.handIn.issued', { number: receipt.number })}
              </Link>
            </li>
          ))}
        </ul>
      )}
    </form>
  );
}

function Expected({ line }: { line: CustodyLine }) {
  const { t } = useTranslation();
  const direction = directionOf(line);
  const amount = formatMoney({
    amount: line.balance.replace(/^-/, ''),
    currency: line.currency,
  });
  if (direction === 'hand_in') return <>{t('cashDesk.handIn.toReceive', { amount })}</>;
  if (direction === 'reimburse') return <>{t('cashDesk.handIn.toPay', { amount })}</>;
  return <>{t('cashDesk.handIn.nothing')}</>;
}

// AP §9.10.3: OWN sees every session and variance; FIN their own.
export function CashDeskSessionsPage() {
  const { t } = useTranslation();
  const search = sessionsRoute.useSearch();
  const cities = useQuery(citiesQuery);
  const city = cities.data ? chosenCity(cities.data, search.city) : undefined;
  const sessions = useSessions(city?.id);
  return (
    <main>
      <h1>{t('cashDesk.sessions.title')}</h1>
      <p>
        <Link to="/cash-desk" search={search}>
          {t('cashDesk.title')}
        </Link>
      </p>
      {cities.isError || sessions.isError ? (
        <p role="alert">{t('common.failed')}</p>
      ) : !city || !sessions.data ? (
        <p role="status">{t('status.loading')}</p>
      ) : sessions.data.length === 0 ? (
        <p>{t('cashDesk.sessions.none')}</p>
      ) : (
        sessions.data.map((session) => (
          <section key={session.id} aria-label={session.adminName ?? session.adminAccountId}>
            <h2>
              {t('cashDesk.sessions.line', {
                name: session.adminName ?? '',
                opened: formatDateTime(session.openedAt, city.timeZone),
              })}
            </h2>
            <p>
              {session.closedAt
                ? t('cashDesk.sessions.closedAt', {
                    at: formatDateTime(session.closedAt, city.timeZone),
                  })
                : t('cashDesk.sessions.stillOpen')}
            </p>
            <SessionCash session={session} />
            {session.closeNote && <p>{t('cashDesk.sessions.note', { note: session.closeNote })}</p>}
          </section>
        ))
      )}
    </main>
  );
}
