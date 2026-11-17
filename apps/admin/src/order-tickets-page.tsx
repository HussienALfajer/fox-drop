import { useQuery } from '@tanstack/react-query';
import { getRouteApi } from '@tanstack/react-router';
import { type FormEvent, useState } from 'react';
import { useTranslation } from 'react-i18next';
import type { City } from './cities.js';
import { openRefusalKeys, TicketTable } from './tickets-page.js';
import {
  canManageTickets,
  canReadTickets,
  orderTicketsQuery,
  ticketLabel,
  type TicketParty,
  ticketPartyKeys,
  ticketTypesQuery,
  useOpenOrderTicket,
} from './tickets.js';

const signedIn = getRouteApi('/signed-in');

// AP §9.3.1 «tickets linked» and §9.3.2 «فتح تذكرة» (slice 2.23a): the
// order's tickets, and a manual ticket on it for OWN, OPS and SUP naming the
// order's customer, restaurant or captain.
export function OrderTickets({
  orderId,
  hasCaptain,
  city,
}: {
  orderId: string;
  hasCaptain: boolean;
  city: City;
}) {
  const { t } = useTranslation();
  const { session } = signedIn.useRouteContext();
  const tickets = useQuery({ ...orderTicketsQuery(orderId), enabled: canReadTickets(session) });
  if (!canReadTickets(session)) return null;
  return (
    <section>
      <h2>{t('tickets.orderSection')}</h2>
      {tickets.isError ? (
        <p role="alert">{t('common.failed')}</p>
      ) : !tickets.data ? (
        <p role="status">{t('status.loading')}</p>
      ) : tickets.data.length === 0 ? (
        <p>{t('tickets.noneOnOrder')}</p>
      ) : (
        <TicketTable tickets={tickets.data} city={city} />
      )}
      {canManageTickets(session) && (
        <OpenOrderTicket key={orderId} orderId={orderId} hasCaptain={hasCaptain} />
      )}
    </section>
  );
}

function OpenOrderTicket({ orderId, hasCaptain }: { orderId: string; hasCaptain: boolean }) {
  const { t } = useTranslation();
  const types = useQuery(ticketTypesQuery);
  const open = useOpenOrderTicket(orderId);
  const [party, setParty] = useState<TicketParty>('customer');
  const [typeCode, setTypeCode] = useState('');
  const [description, setDescription] = useState('');
  const parties = (Object.keys(ticketPartyKeys) as TicketParty[]).filter(
    (each) => each !== 'captain' || hasCaptain,
  );
  const ready = typeCode !== '' && description.trim() !== '';
  const submit = (event: FormEvent) => {
    event.preventDefault();
    if (ready) open.mutate({ party, typeCode, description: description.trim() });
  };
  const result = open.data;
  return (
    <form onSubmit={submit}>
      <fieldset>
        <legend>{t('tickets.openOnOrder')}</legend>
        <label>
          {t('tickets.column.party')}
          <select
            value={party}
            onChange={(event) => {
              setParty(event.target.value as TicketParty);
              setTypeCode('');
            }}
          >
            {parties.map((each) => (
              <option key={each} value={each}>
                {t(ticketPartyKeys[each])}
              </option>
            ))}
          </select>
        </label>
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
        {open.isError && <p role="alert">{t('common.failed')}</p>}
        {result?.status === 'refused' && <p role="alert">{t(openRefusalKeys[result.refusal])}</p>}
        {result?.status === 'done' && (
          <p role="status">
            {t('tickets.openedNumber', { number: ticketLabel(result.ticket.number) })}
          </p>
        )}
      </fieldset>
    </form>
  );
}
