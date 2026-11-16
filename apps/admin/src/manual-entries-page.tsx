import { useQuery } from '@tanstack/react-query';
import { getRouteApi, Link } from '@tanstack/react-router';
import { type FormEvent, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { type City, chosenCity, citiesQuery } from './cities.js';
import { formatDateTime, formatMoney } from './format.js';
import {
  type AccountEntry,
  adjustmentBody,
  balanceWordsOf,
  entryAnchorOf,
  entryLinkOf,
  formKeyOf,
  type Direction,
  type JournalSummary,
  MANUAL_ADJUSTMENT,
  type ManualEntry,
  type ManualEntryResult,
  PARTIES,
  type Party,
  type PartyAccount,
  partyAccounts,
  typeKeyOf,
  useAccount,
  useAdjust,
  useManualEntries,
  usePartySearch,
  useReverse,
} from './manual-entries.js';
import { can } from './session.js';

const route = getRouteApi('/signed-in/manual-entries');
const signedIn = getRouteApi('/signed-in');

const partyKeys = {
  captain: 'manualEntries.party.captain',
  restaurant: 'manualEntries.party.restaurant',
  customer: 'manualEntries.party.customer',
} as const satisfies Record<Party, string>;

const accountKeys = {
  'captain.custody': 'manualEntries.account.custody',
  'captain.earnings': 'manualEntries.account.earnings',
  'merchant.account': 'manualEntries.account.merchant',
  'customer.dues': 'manualEntries.account.dues',
} as const satisfies Record<PartyAccount, string>;

// What each direction does to the account, in the party's terms.
const directionKeys = {
  'captain.custody': {
    up: 'manualEntries.direction.custodyUp',
    down: 'manualEntries.direction.custodyDown',
  },
  'captain.earnings': {
    up: 'manualEntries.direction.earningsUp',
    down: 'manualEntries.direction.earningsDown',
  },
  'merchant.account': {
    up: 'manualEntries.direction.merchantUp',
    down: 'manualEntries.direction.merchantDown',
  },
  'customer.dues': {
    up: 'manualEntries.direction.duesUp',
    down: 'manualEntries.direction.duesDown',
  },
} as const satisfies Record<PartyAccount, Record<Direction, string>>;

const refusalKeys = {
  invalid_amounts: 'manualEntries.refusal.invalidAmounts',
  invalid_currency: 'manualEntries.refusal.invalidCurrency',
  invalid_account: 'manualEntries.refusal.invalidAccount',
  reason_required: 'manualEntries.refusal.reasonRequired',
  unknown_party: 'manualEntries.refusal.unknownParty',
  no_base_currency: 'manualEntries.refusal.noBaseCurrency',
  unknown_journal: 'manualEntries.refusal.unknownJournal',
  already_reversed: 'manualEntries.refusal.alreadyReversed',
  not_reversible: 'manualEntries.refusal.notReversible',
} as const;

// AP §9.10.7 «القيود التصحيحية» (slice 2.20c): OWN and FIN post a manual
// entry with a reason on a captain's custody or earnings, a restaurant's
// account or a customer's dues, reverse an existing entry, and see every
// manual entry with who, when, why and what it corrects. Nothing is deleted.
// Unstyled until the design.
export function ManualEntriesPage() {
  const { t } = useTranslation();
  const search = route.useSearch();
  const cities = useQuery(citiesQuery);
  const city = cities.data ? chosenCity(cities.data, search.city) : undefined;
  return (
    <main>
      <h1>{t('manualEntries.title')}</h1>
      <p>
        <Link to="/">{t('common.home')}</Link>
      </p>
      <p>{t('manualEntries.nothingDeleted')}</p>
      {cities.isError ? (
        <p role="alert">{t('common.failed')}</p>
      ) : !city ? (
        <p role="status">{t('status.loading')}</p>
      ) : (
        <>
          <NewEntry city={city} />
          <EntryList city={city} />
        </>
      )}
    </main>
  );
}

function Outcome({ result }: { result: ManualEntryResult | undefined }) {
  const { t } = useTranslation();
  if (!result) return null;
  return result.status === 'posted' ? (
    <p role="status">
      {result.entry.kind === 'reversal' ? t('manualEntries.reversed') : t('manualEntries.posted')}
    </p>
  ) : (
    <p role="alert">{t(refusalKeys[result.refusal])}</p>
  );
}

function NewEntry({ city }: { city: City }) {
  const { t } = useTranslation();
  const [party, setParty] = useState<Party>('captain');
  const [text, setText] = useState('');
  const [chosen, setChosen] = useState<{ id: string; name: string } | null>(null);
  const [account, setAccount] = useState<PartyAccount>('captain.custody');
  const found = usePartySearch(city.id, party, chosen ? '' : text);

  const chooseParty = (next: Party) => {
    setParty(next);
    setChosen(null);
    setText('');
    setAccount(partyAccounts[next][0]);
  };

  return (
    <section>
      <h2>{t('manualEntries.new')}</h2>
      <label>
        {t('manualEntries.partyLabel')}{' '}
        <select value={party} onChange={(event) => chooseParty(event.target.value as Party)}>
          {PARTIES.map((each) => (
            <option key={each} value={each}>
              {t(partyKeys[each])}
            </option>
          ))}
        </select>
      </label>
      {chosen ? (
        <p>
          {t('manualEntries.chosen', {
            party: t(partyKeys[party]),
            name: chosen.name || t('manualEntries.noName'),
          })}{' '}
          <button type="button" onClick={() => setChosen(null)}>
            {t('manualEntries.change')}
          </button>
        </p>
      ) : (
        <>
          <label>
            {party === 'customer' ? t('manualEntries.searchByNumber') : t('manualEntries.search')}{' '}
            <input value={text} onChange={(event) => setText(event.target.value)} />
          </label>
          {found.isError && <p role="alert">{t('common.failed')}</p>}
          {found.data?.length === 0 && <p>{t('manualEntries.noneFound')}</p>}
          <ul>
            {found.data?.map((each) => (
              <li key={each.id}>
                <button type="button" onClick={() => setChosen(each)}>
                  {t('manualEntries.choose', { name: each.name || t('manualEntries.noName') })}
                </button>
              </li>
            ))}
          </ul>
        </>
      )}
      {chosen && (
        <>
          <label>
            {t('manualEntries.accountLabel')}{' '}
            <select
              value={account}
              onChange={(event) => setAccount(event.target.value as PartyAccount)}
            >
              {partyAccounts[party].map((each) => (
                <option key={each} value={each}>
                  {t(accountKeys[each])}
                </option>
              ))}
            </select>
          </label>
          <AccountPanel city={city} party={party} partyId={chosen.id} account={account} />
        </>
      )}
    </section>
  );
}

function AccountPanel({
  city,
  party,
  partyId,
  account,
}: {
  city: City;
  party: Party;
  partyId: string;
  account: PartyAccount;
}) {
  const { t } = useTranslation();
  const view = useAccount(city.id, { party, partyId, account });
  if (view.isError) return <p role="alert">{t('common.failed')}</p>;
  if (!view.data) return <p role="status">{t('status.loading')}</p>;
  return (
    <>
      <p>
        {view.data.balances.length === 0
          ? t('manualEntries.noBalance')
          : t('manualEntries.balance', {
              amounts: view.data.balances
                .map((money) => {
                  const words = balanceWordsOf(account, money);
                  return words
                    ? t(words.key, { amount: formatMoney(words.money) })
                    : formatMoney(money);
                })
                .join(' + '),
            })}
      </p>
      <h3>{t('manualEntries.latest')}</h3>
      {view.data.entries.length === 0 ? (
        <p>{t('manualEntries.noEntries')}</p>
      ) : (
        <ul>
          {view.data.entries.map((entry) => (
            <AccountLine key={entry.journalId} entry={entry} city={city} />
          ))}
        </ul>
      )}
      <AdjustmentForm
        key={formKeyOf(partyId, account)}
        city={city}
        party={party}
        partyId={partyId}
        account={account}
        currencies={view.data.currencies}
      />
    </>
  );
}

function AccountLine({ entry, city }: { entry: AccountEntry; city: City }) {
  const { t } = useTranslation();
  return (
    <li>
      <Summary summary={entry} city={city} />{' '}
      {entry.reversed ? (
        <span>{t('manualEntries.wasReversed')}</span>
      ) : (
        entry.reversible && <ReverseForm city={city} journalId={entry.journalId} />
      )}
    </li>
  );
}

// A journal as one line: its kind, time, amounts, order and reason.
function Summary({ summary, city }: { summary: JournalSummary; city: City }) {
  const { t } = useTranslation();
  return (
    <span>
      {t(typeKeyOf(summary.type))} {formatDateTime(summary.createdAt, city.timeZone)}{' '}
      {summary.lines.map((line) => formatMoney(line)).join(' + ')}
      {summary.orderNumber !== null && (
        <> {t('manualEntries.order', { number: summary.orderNumber })}</>
      )}
      {summary.reason !== null && <> {t('manualEntries.reason', { reason: summary.reason })}</>}
    </span>
  );
}

function AdjustmentForm({
  city,
  party,
  partyId,
  account,
  currencies,
}: {
  city: City;
  party: Party;
  partyId: string;
  account: PartyAccount;
  // From the server: custody in any enabled currency, the others the base.
  currencies: string[];
}) {
  const { t } = useTranslation();
  const [currency, setCurrency] = useState<string | null>(null);
  const [direction, setDirection] = useState<Direction>('up');
  const [amount, setAmount] = useState('');
  const [reason, setReason] = useState('');
  const [review, setReview] = useState(false);
  const adjust = useAdjust(city.id);
  const chosenCurrency = currency ?? currencies[0] ?? null;
  const body =
    chosenCurrency === null
      ? null
      : adjustmentBody(city.id, {
          party,
          partyId,
          account,
          currency: chosenCurrency,
          amount,
          direction,
          reason,
        });

  const submit = (event: FormEvent) => {
    event.preventDefault();
    if (!body) return;
    if (!review) {
      setReview(true);
      return;
    }
    adjust.mutate(body, {
      onSuccess: (result) => {
        if (result.status === 'posted') {
          setAmount('');
          setReason('');
        }
        setReview(false);
      },
    });
  };

  if (currencies.length === 0) return <p>{t('manualEntries.refusal.noBaseCurrency')}</p>;
  return (
    <form onSubmit={submit}>
      <h3>{t('manualEntries.adjust')}</h3>
      <fieldset disabled={review || adjust.isPending}>
        <label>
          {t('manualEntries.currency')}{' '}
          <select
            value={chosenCurrency ?? ''}
            onChange={(event) => setCurrency(event.target.value)}
          >
            {currencies.map((each) => (
              <option key={each} value={each}>
                {each}
              </option>
            ))}
          </select>
        </label>
        {(['up', 'down'] as const).map((each) => (
          <label key={each}>
            <input
              type="radio"
              name="direction"
              checked={direction === each}
              onChange={() => setDirection(each)}
            />{' '}
            {t(directionKeys[account][each])}
          </label>
        ))}
        <label>
          {t('manualEntries.amount')}{' '}
          <input
            inputMode="decimal"
            value={amount}
            onChange={(event) => setAmount(event.target.value)}
          />
        </label>
        <label>
          {t('manualEntries.reasonLabel')}{' '}
          <textarea
            value={reason}
            maxLength={500}
            onChange={(event) => setReason(event.target.value)}
          />
        </label>
      </fieldset>
      {review && body && (
        <p>
          {t('manualEntries.review', {
            direction: t(directionKeys[account][direction]),
            amount: formatMoney({ amount: body.amount.replace('-', ''), currency: body.currency }),
          })}
        </p>
      )}
      <button type="submit" disabled={!body || adjust.isPending}>
        {review ? t('manualEntries.confirm') : t('manualEntries.reviewButton')}
      </button>
      {review && (
        <button type="button" onClick={() => setReview(false)}>
          {t('manualEntries.back')}
        </button>
      )}
      {adjust.isError && <p role="alert">{t('common.failed')}</p>}
      <Outcome result={adjust.data} />
    </form>
  );
}

function ReverseForm({ city, journalId }: { city: City; journalId: string }) {
  const { t } = useTranslation();
  const [open, setOpen] = useState(false);
  const [reason, setReason] = useState('');
  const reverse = useReverse(city.id);
  if (!open) {
    return (
      <button type="button" onClick={() => setOpen(true)}>
        {t('manualEntries.reverse')}
      </button>
    );
  }
  const submit = (event: FormEvent) => {
    event.preventDefault();
    if (!reason.trim()) return;
    reverse.mutate(
      { journalId, reason },
      { onSuccess: (result) => result.status === 'posted' && setOpen(false) },
    );
  };
  return (
    <form onSubmit={submit}>
      <label>
        {t('manualEntries.reverseReason')}{' '}
        <textarea
          value={reason}
          maxLength={500}
          onChange={(event) => setReason(event.target.value)}
        />
      </label>
      <button type="submit" disabled={!reason.trim() || reverse.isPending}>
        {t('manualEntries.confirmReverse')}
      </button>
      <button type="button" onClick={() => setOpen(false)}>
        {t('manualEntries.back')}
      </button>
      {reverse.isError && <p role="alert">{t('common.failed')}</p>}
      <Outcome result={reverse.data} />
    </form>
  );
}

function EntryList({ city }: { city: City }) {
  const { t } = useTranslation();
  const entries = useManualEntries(city.id);
  return (
    <section>
      <h2>{t('manualEntries.list')}</h2>
      {entries.isError ? (
        <p role="alert">{t('common.failed')}</p>
      ) : !entries.data ? (
        <p role="status">{t('status.loading')}</p>
      ) : entries.data.length === 0 ? (
        <p>{t('manualEntries.empty')}</p>
      ) : (
        <ol>
          {entries.data.map((entry) => (
            <EntryItem key={entry.id} entry={entry} city={city} />
          ))}
        </ol>
      )}
    </section>
  );
}

function EntryItem({ entry, city }: { entry: ManualEntry; city: City }) {
  const { t } = useTranslation();
  const { session } = signedIn.useRouteContext();
  return (
    <li id={entryAnchorOf(entry.id)}>
      <h3>
        {entry.kind === 'reversal'
          ? t('manualEntries.kind.reversal')
          : t('manualEntries.kind.adjustment')}{' '}
        {t('manualEntries.chosen', {
          party: t(partyKeys[entry.partyKind]),
          name: entry.partyName || t('manualEntries.noName'),
        })}
      </h3>
      <p>
        <Summary summary={entry.journal} city={city} />
      </p>
      <p>
        {t('manualEntries.by', {
          name: entry.adminName ?? t('manualEntries.noName'),
          at: formatDateTime(entry.createdAt, city.timeZone),
        })}
      </p>
      {entry.corrects && (
        <p>
          {t('manualEntries.corrects')} <Summary summary={entry.corrects} city={city} />{' '}
          {entry.corrects.manualEntryId && (
            <a href={entryLinkOf(entry.corrects.manualEntryId)}>
              {t('manualEntries.openOriginal')}
            </a>
          )}
        </p>
      )}
      {entry.reversedBy && (
        <p>
          {t('manualEntries.reversedAt', {
            at: formatDateTime(entry.reversedBy.at, city.timeZone),
          })}{' '}
          {entry.reversedBy.manualEntryId && (
            <a href={entryLinkOf(entry.reversedBy.manualEntryId)}>
              {t('manualEntries.openReversal')}
            </a>
          )}
        </p>
      )}
      {entry.reversible && can(session, MANUAL_ADJUSTMENT) && (
        <ReverseForm city={city} journalId={entry.journal.journalId} />
      )}
    </li>
  );
}
