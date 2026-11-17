import { useQuery } from '@tanstack/react-query';
import { getRouteApi, Link } from '@tanstack/react-router';
import { type FormEvent, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { type City, chosenCity, citiesQuery } from './cities.js';
import { useServerNow } from './clock.js';
import { formatDateTime } from './format.js';
import { useOpsChannel } from './live.js';
import { can } from './session.js';
import { OPERATIONS_READ } from './orders-board.js';
import {
  canManageTickets,
  minutesLeft,
  NO_TICKET_FILTER,
  type OpenRefusal,
  slaKindKeys,
  slaState,
  type Ticket,
  type TicketFilters,
  ticketAssigneesQuery,
  ticketLabel,
  type TicketParty,
  ticketPartyKeys,
  sourceKey,
  ticketSourceKeys,
  ticketStatusKeys,
  ticketsQuery,
  ticketTypesQuery,
  useFindParties,
  useOpenTicket,
} from './tickets.js';

const route = getRouteApi('/signed-in/tickets');
const signedIn = getRouteApi('/signed-in');

export const openRefusalKeys = {
  unknown_reason: 'tickets.refusal.unknownType',
  reason_note_required: 'tickets.refusal.unknownType',
  unknown_party: 'tickets.refusal.unknownParty',
  unknown_order: 'tickets.refusal.unknownOrder',
  no_captain: 'tickets.refusal.noCaptain',
  idempotency_key_reused: 'common.failed',
} as const satisfies Record<OpenRefusal, string>;

const slaStateKeys = {
  running: 'tickets.sla.running',
  amber: 'tickets.sla.amber',
  breached: 'tickets.sla.breached',
  met: 'tickets.sla.met',
} as const;

// AP §9.9.2 «الدعم» (slice 2.23a): the city's tickets, newest first, with the
// filters and «تذكرة يدوية». Unstyled until the design: the timer's amber and
// red are its state in words.
export function TicketsPage() {
  const { t } = useTranslation();
  const search = route.useSearch();
  const { session } = signedIn.useRouteContext();
  const cities = useQuery(citiesQuery);
  const city = cities.data ? chosenCity(cities.data, search.city) : undefined;
  useOpsChannel(city?.id);
  const [filters, setFilters] = useState<TicketFilters>(NO_TICKET_FILTER);
  const tickets = useQuery({ ...ticketsQuery(city?.id ?? '', filters), enabled: !!city });
  const types = useQuery(ticketTypesQuery);
  const assignees = useQuery(ticketAssigneesQuery);
  const allTypes = types.data
    ? [...types.data.customer, ...types.data.restaurant, ...types.data.captain].filter(
        (each, index, list) => list.findIndex((other) => other.code === each.code) === index,
      )
    : [];
  return (
    <main>
      <h1>{t('tickets.title')}</h1>
      <p>
        <Link to="/">{t('common.home')}</Link>
      </p>
      {city && canManageTickets(session) && <OpenTicketForm city={city} />}
      <fieldset>
        <legend>{t('tickets.filters')}</legend>
        <label>
          {t('tickets.column.status')}
          <select
            value={filters.status}
            onChange={(event) =>
              setFilters({ ...filters, status: event.target.value as TicketFilters['status'] })
            }
          >
            <option value="">{t('tickets.all')}</option>
            {Object.entries(ticketStatusKeys).map(([status, key]) => (
              <option key={status} value={status}>
                {t(key)}
              </option>
            ))}
          </select>
        </label>
        <label>
          {t('tickets.column.type')}
          <select
            value={filters.typeCode}
            onChange={(event) => setFilters({ ...filters, typeCode: event.target.value })}
          >
            <option value="">{t('tickets.all')}</option>
            {allTypes.map((type) => (
              <option key={type.code} value={type.code}>
                {type.label}
              </option>
            ))}
          </select>
        </label>
        <label>
          {t('tickets.column.assignee')}
          <select
            value={filters.assigneeId}
            onChange={(event) => setFilters({ ...filters, assigneeId: event.target.value })}
          >
            <option value="">{t('tickets.all')}</option>
            {assignees.data?.map((member) => (
              <option key={member.id} value={member.id}>
                {member.name}
              </option>
            ))}
          </select>
        </label>
        <label>
          {t('tickets.column.source')}
          <select
            value={filters.source}
            onChange={(event) =>
              setFilters({ ...filters, source: event.target.value as TicketFilters['source'] })
            }
          >
            <option value="">{t('tickets.all')}</option>
            {Object.entries(ticketSourceKeys).map(([source, key]) => (
              <option key={source} value={source}>
                {t(key)}
              </option>
            ))}
          </select>
        </label>
        <label>
          <input
            type="checkbox"
            checked={filters.breached}
            onChange={(event) => setFilters({ ...filters, breached: event.target.checked })}
          />
          {t('tickets.breachedOnly')}
        </label>
      </fieldset>
      {tickets.isError || cities.isError ? (
        <p role="alert">{t('common.failed')}</p>
      ) : !city || !tickets.data ? (
        <p role="status">{t('status.loading')}</p>
      ) : tickets.data.length === 0 ? (
        <p>{t('tickets.none')}</p>
      ) : (
        <TicketTable tickets={tickets.data} city={city} />
      )}
    </main>
  );
}

export function TicketTable({ tickets, city }: { tickets: Ticket[]; city: City }) {
  const { t } = useTranslation();
  return (
    <table>
      <thead>
        <tr>
          <th>{t('tickets.column.number')}</th>
          <th>{t('tickets.column.order')}</th>
          <th>{t('tickets.column.type')}</th>
          <th>{t('tickets.column.party')}</th>
          <th>{t('tickets.column.priority')}</th>
          <th>{t('tickets.column.status')}</th>
          <th>{t('tickets.column.assignee')}</th>
          <th>{t('tickets.column.sla')}</th>
        </tr>
      </thead>
      <tbody>
        {tickets.map((ticket) => (
          <TicketRow key={ticket.id} ticket={ticket} city={city} />
        ))}
      </tbody>
    </table>
  );
}

function TicketRow({ ticket, city }: { ticket: Ticket; city: City }) {
  const { t } = useTranslation();
  const source = sourceKey(ticket.source);
  const { session } = signedIn.useRouteContext();
  return (
    <tr>
      <td>
        <Link to="/tickets/$ticketId" params={{ ticketId: ticket.id }} search={{ city: city.code }}>
          {ticketLabel(ticket.number)}
        </Link>{' '}
        {source && t(source)}
      </td>
      <td>
        {ticket.orderId && ticket.orderNumber ? (
          can(session, OPERATIONS_READ) ? (
            <Link
              to="/orders/$orderId"
              params={{ orderId: ticket.orderId }}
              search={{ city: city.code }}
            >
              {t('tickets.orderNumber', { number: ticket.orderNumber })}
            </Link>
          ) : (
            t('tickets.orderNumber', { number: ticket.orderNumber })
          )
        ) : (
          t('tickets.noOrder')
        )}
      </td>
      <td>{ticket.typeLabel}</td>
      <td>
        {t('tickets.partyLine', {
          party: t(ticketPartyKeys[ticket.party]),
          name: ticket.partyName,
        })}
      </td>
      <td>{t(ticket.urgent ? 'tickets.priority.urgent' : 'tickets.priority.normal')}</td>
      <td>{t(ticketStatusKeys[ticket.status])}</td>
      <td>{ticket.assigneeName ?? t('tickets.unassigned')}</td>
      <td>
        <SlaTimer ticket={ticket} timeZone={city.timeZone} />
      </td>
    </tr>
  );
}

// AP §9.9.2: the timer's kind, its state and what is left, on the server's
// clock.
export function SlaTimer({ ticket, timeZone }: { ticket: Ticket; timeZone: string }) {
  const { t } = useTranslation();
  const now = useServerNow();
  const state = slaState(ticket.sla, now);
  const left = minutesLeft(ticket.sla, now);
  return (
    <span data-sla={state}>
      {t(slaKindKeys[ticket.sla.kind])} {t(slaStateKeys[state])}{' '}
      {(state === 'running' || state === 'amber') && t('tickets.sla.left', { minutes: left })}
      {state === 'breached' &&
        ticket.sla.stoppedAt === null &&
        t('tickets.sla.late', { minutes: -left })}{' '}
      {t('tickets.sla.due', { time: formatDateTime(ticket.sla.dueAt, timeZone) })}
    </span>
  );
}

// «تذكرة يدوية» (AP §9.9.1): a ticket after a call or a WhatsApp message.
// One on an order is opened from the order's page, which names its parties.
function OpenTicketForm({ city }: { city: City }) {
  const { t } = useTranslation();
  const types = useQuery(ticketTypesQuery);
  const find = useFindParties(city.id);
  const open = useOpenTicket(city.id);
  const [party, setParty] = useState<TicketParty>('customer');
  const [q, setQ] = useState('');
  const [partyId, setPartyId] = useState('');
  const [typeCode, setTypeCode] = useState('');
  const [description, setDescription] = useState('');
  const choose = (next: TicketParty) => {
    setParty(next);
    setPartyId('');
    setTypeCode('');
    find.reset();
  };
  const searchParty = (event: FormEvent) => {
    event.preventDefault();
    if (q.trim()) find.mutate({ party, q: q.trim() });
  };
  const ready = partyId !== '' && typeCode !== '' && description.trim() !== '';
  const submit = (event: FormEvent) => {
    event.preventDefault();
    if (ready) open.mutate({ party, partyId, typeCode, description: description.trim() });
  };
  const result = open.data;
  return (
    <section>
      <h2>{t('tickets.manual')}</h2>
      <form onSubmit={searchParty}>
        <label>
          {t('tickets.column.party')}
          <select value={party} onChange={(event) => choose(event.target.value as TicketParty)}>
            {Object.entries(ticketPartyKeys).map(([value, key]) => (
              <option key={value} value={value}>
                {t(key)}
              </option>
            ))}
          </select>
        </label>
        <label>
          {t(party === 'customer' ? 'tickets.searchByPhone' : 'tickets.searchByName')}
          <input value={q} onChange={(event) => setQ(event.target.value)} />
        </label>
        <button type="submit" disabled={find.isPending}>
          {t('tickets.search')}
        </button>
      </form>
      {find.isError && <p role="alert">{t('common.failed')}</p>}
      {find.data && find.data.length === 0 && <p>{t('tickets.noParty')}</p>}
      {find.data && find.data.length > 0 && (
        <label>
          {t('tickets.chooseParty')}
          <select value={partyId} onChange={(event) => setPartyId(event.target.value)}>
            <option value="">{t('tickets.choose')}</option>
            {find.data.map((each) => (
              <option key={each.id} value={each.id}>
                {each.name || t('tickets.unnamed')}
              </option>
            ))}
          </select>
        </label>
      )}
      <form onSubmit={submit}>
        <label>
          {t('tickets.column.type')}
          <select value={typeCode} onChange={(event) => setTypeCode(event.target.value)}>
            <option value="">{t('tickets.choose')}</option>
            {types.data?.[party].map((type) => (
              <option key={type.code} value={type.code}>
                {type.label}
              </option>
            ))}
          </select>
        </label>
        <label>
          {t('tickets.description')}
          <textarea
            value={description}
            maxLength={2000}
            onChange={(event) => setDescription(event.target.value)}
          />
        </label>
        <button type="submit" disabled={!ready || open.isPending}>
          {t('tickets.open')}
        </button>
      </form>
      {open.isError && <p role="alert">{t('common.failed')}</p>}
      {result?.status === 'refused' && <p role="alert">{t(openRefusalKeys[result.refusal])}</p>}
      {result?.status === 'done' && (
        <p role="status">
          {t('tickets.opened')}{' '}
          <Link
            to="/tickets/$ticketId"
            params={{ ticketId: result.ticket.id }}
            search={{ city: city.code }}
          >
            {ticketLabel(result.ticket.number)}
          </Link>
        </p>
      )}
    </section>
  );
}
