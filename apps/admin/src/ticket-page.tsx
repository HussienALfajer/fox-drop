import { useQuery } from '@tanstack/react-query';
import { getRouteApi, Link } from '@tanstack/react-router';
import { type FormEvent, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { type City, chosenCity, citiesQuery } from './cities.js';
import { formatDateTime } from './format.js';
import { useOpsChannel } from './live.js';
import { OPERATIONS_READ } from './orders-board.js';
import { can } from './session.js';
import { SlaTimer } from './tickets-page.js';
import {
  canManageTickets,
  type ChangeRefusal,
  isOpenTicket,
  statusChoices,
  ticketAssigneesQuery,
  ticketLabel,
  type TicketPage as TicketPageData,
  ticketPartyKeys,
  ticketQuery,
  ticketSourceKeys,
  ticketStatusKeys,
  useChangeTicket,
} from './tickets.js';

const route = getRouteApi('/signed-in/tickets/$ticketId');
const signedIn = getRouteApi('/signed-in');

const changeRefusalKeys = {
  unknown_ticket: 'tickets.refusal.unknownTicket',
  ticket_not_open: 'tickets.refusal.notOpen',
  unknown_assignee: 'tickets.refusal.unknownAssignee',
  invalid_status_change: 'tickets.refusal.statusChanged',
  idempotency_key_reused: 'common.failed',
} as const satisfies Record<ChangeRefusal, string>;

// AP §9.9.3 (slice 2.23a): the ticket with its linked order, type, what the
// party said and the internal notes (AP §4.5), the assignee and the status.
// Resolving and canned replies come with 2.23b. Unstyled until the design.
export function TicketPage() {
  const { t } = useTranslation();
  const { ticketId } = route.useParams();
  const search = route.useSearch();
  const cities = useQuery(citiesQuery);
  const city = cities.data ? chosenCity(cities.data, search.city) : undefined;
  useOpsChannel(city?.id);
  const ticket = useQuery({ ...ticketQuery(city?.id ?? '', ticketId), enabled: !!city });
  return (
    <main>
      <p>
        <Link to="/tickets" search={city ? { city: city.code } : {}}>
          {t('tickets.title')}
        </Link>
      </p>
      {ticket.isError || cities.isError ? (
        <p role="alert">{t('common.failed')}</p>
      ) : !city || ticket.data === undefined ? (
        <p role="status">{t('status.loading')}</p>
      ) : ticket.data === null ? (
        <p role="alert">{t('tickets.refusal.unknownTicket')}</p>
      ) : (
        <TicketDetail ticket={ticket.data} city={city} />
      )}
    </main>
  );
}

function TicketDetail({ ticket, city }: { ticket: TicketPageData; city: City }) {
  const { t } = useTranslation();
  const { session } = signedIn.useRouteContext();
  const time = (at: string) => formatDateTime(at, city.timeZone);
  const manage = canManageTickets(session) && isOpenTicket(ticket.status);
  return (
    <>
      <h1>{t('tickets.heading', { number: ticketLabel(ticket.number) })}</h1>
      <dl>
        <dt>{t('tickets.column.source')}</dt>
        <dd>{t(ticketSourceKeys[ticket.source])}</dd>
        <dt>{t('tickets.column.party')}</dt>
        <dd>
          {t('tickets.partyLine', {
            party: t(ticketPartyKeys[ticket.party]),
            name: ticket.partyName,
          })}
        </dd>
        <dt>{t('tickets.column.order')}</dt>
        <dd>
          {ticket.orderId && ticket.orderNumber ? (
            can(session, OPERATIONS_READ) ? (
              <Link
                to="/orders/$orderId"
                params={{ orderId: ticket.orderId }}
                search={{ city: city.code }}
              >
                {t('tickets.openOrder', { number: ticket.orderNumber })}
              </Link>
            ) : (
              t('tickets.orderNumber', { number: ticket.orderNumber })
            )
          ) : (
            t('tickets.noOrder')
          )}
        </dd>
        <dt>{t('tickets.column.type')}</dt>
        <dd>{ticket.typeLabel}</dd>
        <dt>{t('tickets.column.priority')}</dt>
        <dd>{t(ticket.urgent ? 'tickets.priority.urgent' : 'tickets.priority.normal')}</dd>
        <dt>{t('tickets.column.status')}</dt>
        <dd>{t(ticketStatusKeys[ticket.status])}</dd>
        <dt>{t('tickets.column.assignee')}</dt>
        <dd>{ticket.assigneeName ?? t('tickets.unassigned')}</dd>
        <dt>{t('tickets.column.sla')}</dt>
        <dd>
          <SlaTimer ticket={ticket} timeZone={city.timeZone} />
        </dd>
        <dt>{t('tickets.openedAt')}</dt>
        <dd>
          {t('tickets.openedBy', {
            name: ticket.openedByName ?? t('tickets.unnamed'),
            time: time(ticket.openedAt),
          })}
        </dd>
        <dt>{t('tickets.description')}</dt>
        <dd>{ticket.description}</dd>
      </dl>
      {manage && <TicketActions ticket={ticket} cityId={city.id} />}
      <section>
        <h2>{t('tickets.notes')}</h2>
        {ticket.notes.length === 0 ? (
          <p>{t('tickets.noNotes')}</p>
        ) : (
          <ul>
            {ticket.notes.map((note) => (
              <li key={note.id}>
                {t('tickets.noteBy', {
                  name: note.authorName ?? t('tickets.unnamed'),
                  time: time(note.createdAt),
                })}{' '}
                {note.body}
              </li>
            ))}
          </ul>
        )}
        {manage && <AddNote ticketId={ticket.id} cityId={city.id} />}
      </section>
    </>
  );
}

function TicketActions({ ticket, cityId }: { ticket: TicketPageData; cityId: string }) {
  const { t } = useTranslation();
  const assignees = useQuery(ticketAssigneesQuery);
  const change = useChangeTicket(cityId, ticket.id);
  const result = change.data;
  return (
    <section>
      <label>
        {t('tickets.column.assignee')}
        <select
          value={ticket.assigneeId ?? ''}
          disabled={change.isPending}
          onChange={(event) =>
            change.mutate({ kind: 'assign', assigneeId: event.target.value || null })
          }
        >
          <option value="">{t('tickets.unassigned')}</option>
          {assignees.data?.map((member) => (
            <option key={member.id} value={member.id}>
              {member.name}
            </option>
          ))}
        </select>
      </label>
      {statusChoices(ticket.status).map((status) => (
        <button
          key={status}
          type="button"
          disabled={change.isPending}
          onClick={() => change.mutate({ kind: 'status', status })}
        >
          {t(status === 'waiting' ? 'tickets.setWaiting' : 'tickets.setInProgress')}
        </button>
      ))}
      {change.isError && <p role="alert">{t('common.failed')}</p>}
      {result?.status === 'refused' && <p role="alert">{t(changeRefusalKeys[result.refusal])}</p>}
    </section>
  );
}

function AddNote({ ticketId, cityId }: { ticketId: string; cityId: string }) {
  const { t } = useTranslation();
  const change = useChangeTicket(cityId, ticketId);
  const [body, setBody] = useState('');
  const submit = (event: FormEvent) => {
    event.preventDefault();
    if (!body.trim()) return;
    change.mutate(
      { kind: 'note', body: body.trim() },
      {
        onSuccess: (result) => {
          if (result.status === 'done') setBody('');
        },
      },
    );
  };
  const result = change.data;
  return (
    <form onSubmit={submit}>
      <label>
        {t('tickets.addNote')}
        <textarea value={body} maxLength={2000} onChange={(event) => setBody(event.target.value)} />
      </label>
      <button type="submit" disabled={!body.trim() || change.isPending}>
        {t('tickets.saveNote')}
      </button>
      {change.isError && <p role="alert">{t('common.failed')}</p>}
      {result?.status === 'refused' && <p role="alert">{t(changeRefusalKeys[result.refusal])}</p>}
    </form>
  );
}
