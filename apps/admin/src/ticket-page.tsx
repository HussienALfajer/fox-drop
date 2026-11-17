import { useQuery } from '@tanstack/react-query';
import { getRouteApi, Link } from '@tanstack/react-router';
import { type FormEvent, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { type City, chosenCity, citiesQuery } from './cities.js';
import { formatDateTime, formatMoney } from './format.js';
import { useOpsChannel } from './live.js';
import { OPERATIONS_READ } from './orders-board.js';
import {
  compensationOf,
  type CompensationForm,
  emptyCompensation,
  OPERATIONS_COMPENSATE,
  orderCompensationsQuery,
} from './order-compensation.js';
import { CompensationFields } from './order-compensation-page.js';
import { type AdminSession, can } from './session.js';
import { SlaTimer } from './tickets-page.js';
import {
  cannedRepliesQuery,
  canManageTickets,
  canCloseTicket,
  canResolve,
  confirmedByKeys,
  correctionPreviewQuery,
  affectedOf,
  generalChoices,
  moneyPreviewQuery,
  needsResponsible,
  shortAmountOf,
  type TicketOrder,
  WRONG_CHANGE_TYPE,
  type PickupDispute,
  receivedLinesOf,
  resolutionChoices,
  resolutionKeys,
  type ResolveRefusal,
  responsibleKeys,
  type ResponsibleParty,
  type TicketResolution,
  typedLinesOf,
  useResolveTicket,
  type ChangeRefusal,
  isOpenTicket,
  statusChoices,
  ticketAssigneesQuery,
  ticketLabel,
  type TicketPage as TicketPageData,
  ticketPartyKeys,
  ticketQuery,
  sourceKey,
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

const resolveRefusalKeys = {
  unknown_ticket: 'tickets.refusal.unknownTicket',
  ticket_not_open: 'tickets.refusal.notOpen',
  invalid_resolution: 'tickets.refusal.invalidResolution',
  responsible_required: 'tickets.refusal.responsibleRequired',
  lines_required: 'tickets.refusal.linesRequired',
  invalid_lines: 'tickets.refusal.invalidLines',
  no_difference: 'tickets.refusal.noDifference',
  order_required: 'tickets.refusal.orderRequired',
  not_delivered: 'tickets.refusal.notDelivered',
  amount_required: 'tickets.refusal.amountRequired',
  value_required: 'tickets.refusal.valueRequired',
  invalid_affected: 'tickets.refusal.invalidAffected',
  invalid_value: 'tickets.refusal.invalidValue',
  unknown_reason: 'tickets.refusal.unknownReason',
  no_base_currency: 'tickets.refusal.noBaseCurrency',
  currency_changed: 'tickets.refusal.currencyChanged',
  money_already_resolved: 'tickets.refusal.moneyAlreadyResolved',
  forbidden: 'tickets.refusal.forbidden',
} as const satisfies Record<ResolveRefusal, string>;

// AP §9.9.3 (slice 2.23a): the ticket with its linked order, type, what the
// party said and the internal notes (AP §4.5), the assignee and the status.
// Slice 2.23b: the pickup dispute's facts, «حل التذكرة» with the message
// sent to the party, «إغلاق» without one, and «الردود الجاهزة» for a note or
// a message. Unstyled until the design.
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
  const source = sourceKey(ticket.source);
  return (
    <>
      <h1>{t('tickets.heading', { number: ticketLabel(ticket.number) })}</h1>
      <dl>
        <dt>{t('tickets.column.source')}</dt>
        <dd>{source && t(source)}</dd>
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
        {ticket.restaurantName !== null && (
          <>
            <dt>{t('tickets.restaurant')}</dt>
            <dd>{ticket.restaurantName}</dd>
          </>
        )}
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
      {ticket.pickupDispute && (
        <PickupDisputeFacts dispute={ticket.pickupDispute} timeZone={city.timeZone} />
      )}
      {ticket.order && <TicketOrderFacts order={ticket.order} />}
      {ticket.resolution && (
        <section>
          <h2>{t('tickets.resolved.heading')}</h2>
          <p>
            {t(resolutionKeys[ticket.resolution.code])}
            {ticket.resolution.responsible &&
              ` (${t(responsibleKeys[ticket.resolution.responsible])})`}
          </p>
          <p>
            {t('tickets.resolved.by', {
              name: ticket.resolution.resolvedByName ?? t('tickets.unnamed'),
              time: time(ticket.resolution.resolvedAt),
            })}
          </p>
          <p>
            {t('tickets.field', {
              label: t('tickets.resolved.message'),
              value: ticket.resolution.message,
            })}
          </p>
          {ticket.resolution.affectedLines && ticket.resolution.moneyCurrency && (
            <>
              <ul>
                {ticket.resolution.affectedLines.map((line) => (
                  <li key={line.position}>
                    {t('tickets.money.affectedLine', {
                      name: line.name,
                      quantity: line.quantity,
                      value: formatMoney({
                        amount: line.value,
                        currency: ticket.resolution!.moneyCurrency!,
                      }),
                    })}
                  </li>
                ))}
              </ul>
              <p>
                {t('tickets.money.affectedValue', {
                  amount: formatMoney({
                    amount: ticket.resolution.affectedValue!,
                    currency: ticket.resolution.moneyCurrency,
                  }),
                })}
              </p>
            </>
          )}
          {ticket.resolution.shortAmount && ticket.resolution.moneyCurrency && (
            <p>
              {t('tickets.money.shortAmount', {
                amount: formatMoney({
                  amount: ticket.resolution.shortAmount,
                  currency: ticket.resolution.moneyCurrency,
                }),
              })}
            </p>
          )}
          {ticket.resolution.compensationId && <p>{t('tickets.money.codeAsked')}</p>}
          {ticket.resolution.correctedLines && (
            <p>
              {t('tickets.field', {
                label: t('tickets.resolved.corrected'),
                value: ticket.resolution.correctedLines.map(formatMoney).join(' + '),
              })}
            </p>
          )}
        </section>
      )}
      {ticket.closure && (
        <section>
          <h2>{t('tickets.closed.heading')}</h2>
          <p>
            {t('tickets.field', {
              label: t('tickets.closed.reason'),
              value: ticket.closure.reason,
            })}
          </p>
          <p>
            {t('tickets.resolved.by', {
              name: ticket.closure.closedByName ?? t('tickets.unnamed'),
              time: time(ticket.closure.closedAt),
            })}
          </p>
        </section>
      )}
      {manage && <TicketActions ticket={ticket} cityId={city.id} />}
      {canResolve(session, ticket) && (
        <ResolveTicket ticket={ticket} cityId={city.id} session={session} />
      )}
      {canCloseTicket(session, ticket) && <CloseTicket ticketId={ticket.id} cityId={city.id} />}
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
      <CannedReplies
        onPick={(text) => setBody((current) => (current ? `${current} ${text}` : text))}
      />
      <button type="submit" disabled={!body.trim() || change.isPending}>
        {t('tickets.saveNote')}
      </button>
      {change.isError && <p role="alert">{t('common.failed')}</p>}
      {result?.status === 'refused' && <p role="alert">{t(changeRefusalKeys[result.refusal])}</p>}
    </form>
  );
}

// «الردود الجاهزة» (AP §9.13): a reply put into the note or the message.
function CannedReplies({ onPick }: { onPick: (text: string) => void }) {
  const { t } = useTranslation();
  const replies = useQuery(cannedRepliesQuery);
  const [chosen, setChosen] = useState('');
  if (!replies.data || replies.data.length === 0) return null;
  return (
    <span>
      <label>
        {t('tickets.canned.pick')}
        <select value={chosen} onChange={(event) => setChosen(event.target.value)}>
          <option value="">{t('tickets.choose')}</option>
          {replies.data.map((reply, index) => (
            <option key={index} value={String(index)}>
              {reply.title}
            </option>
          ))}
        </select>
      </label>
      <button
        type="button"
        disabled={chosen === ''}
        onClick={() => {
          const reply = replies.data[Number(chosen)];
          if (reply) onPick(reply.body);
        }}
      >
        {t('tickets.canned.use')}
      </button>
    </span>
  );
}

// AP §9.9.3: the pickup payment, the captain's lines, what the restaurant
// says it received and how the pickup was confirmed.
function PickupDisputeFacts({ dispute, timeZone }: { dispute: PickupDispute; timeZone: string }) {
  const { t } = useTranslation();
  return (
    <section>
      <h2>{t('tickets.dispute.heading')}</h2>
      <dl>
        <dt>{t('tickets.dispute.pickupPayment')}</dt>
        <dd>{formatMoney(dispute.pickupPayment)}</dd>
        <dt>{t('tickets.dispute.recorded')}</dt>
        <dd>{dispute.recorded.map(formatMoney).join(' + ')}</dd>
        <dt>{t('tickets.dispute.received')}</dt>
        <dd>{dispute.received.map(formatMoney).join(' + ')}</dd>
        <dt>{t('tickets.dispute.captain')}</dt>
        <dd>{dispute.captainName ?? t('tickets.unnamed')}</dd>
        <dt>{t('tickets.dispute.confirmed')}</dt>
        <dd>{t(confirmedByKeys[dispute.confirmedBy])}</dd>
        <dt>{t('tickets.dispute.disputedAt')}</dt>
        <dd>{formatDateTime(dispute.disputedAt, timeZone)}</dd>
      </dl>
    </section>
  );
}

// «حل التذكرة» (AP §9.9.3; owner decision 2026-11-17): the kind's
// resolutions, the responsible party of a general ticket, the message sent
// to the party at once, and for «تصحيح في الحسابات» the lines received with
// the preview of the entries, which the confirm waits for.
function ResolveTicket({
  ticket,
  cityId,
  session,
}: {
  ticket: TicketPageData;
  cityId: string;
  session: AdminSession | null | undefined;
}) {
  const { t } = useTranslation();
  const choices =
    ticket.kind === 'general'
      ? generalChoices(ticket, can(session, OPERATIONS_COMPENSATE))
      : resolutionChoices(ticket.kind);
  const [resolution, setResolution] = useState<TicketResolution>(choices[0]!);
  const [responsible, setResponsible] = useState<ResponsibleParty | ''>('');
  const [message, setMessage] = useState('');
  const [typed, setTyped] = useState<Record<string, string>>(() =>
    ticket.pickupDispute ? typedLinesOf(ticket.pickupDispute) : {},
  );
  const resolve = useResolveTicket(cityId, ticket.id);
  const correcting = resolution === 'accounts_corrected';
  const lines = correcting ? receivedLinesOf(typed) : null;
  const preview = useQuery({
    ...correctionPreviewQuery(cityId, ticket.id, lines ?? []),
    enabled: correcting && lines !== null && lines.length > 0,
  });
  const previewed = preview.data?.status === 'done' ? preview.data.preview : null;
  // AP §8.10 (slice 2.23c): a customer's ticket on an order.
  const order = ticket.order;
  const wrongChange = ticket.typeCode === WRONG_CHANGE_TYPE;
  const coding = resolution === 'compensation_code';
  const [quantities, setQuantities] = useState<Record<number, string>>({});
  const [short, setShort] = useState('');
  const [codeForm, setCodeForm] = useState<CompensationForm>(emptyCompensation);
  const takesItems = order !== null && order.deliveredNormally && !wrongChange;
  const takesShort =
    order !== null && order.deliveredNormally && wrongChange && responsible !== 'customer';
  const affected = takesItems ? affectedOf(order.lines, quantities) : [];
  const shortAmount =
    takesShort && short.trim() !== '' ? shortAmountOf(short, order.currency) : null;
  const shortInvalid = takesShort && short.trim() !== '' && shortAmount === null;
  const compensations = useQuery({
    ...orderCompensationsQuery(order?.orderId ?? ''),
    enabled: coding && order !== null && !wrongChange,
  });
  const code =
    coding && !wrongChange && order !== null ? compensationOf(codeForm, order.currency) : null;
  const asksMoney =
    responsible !== '' && affected !== null && (affected.length > 0 || shortAmount !== null);
  const money = useQuery({
    ...moneyPreviewQuery(cityId, ticket.id, {
      responsible: responsible === '' ? 'platform' : responsible,
      affected: affected ?? [],
      shortAmount,
      code: coding,
    }),
    enabled: asksMoney,
  });
  const moneyPreviewed = money.data?.status === 'done' ? money.data.preview : null;
  const ready =
    message.trim() !== '' &&
    (!needsResponsible(ticket.kind) || responsible !== '') &&
    (!correcting || (previewed !== null && !preview.isFetching)) &&
    affected !== null &&
    !shortInvalid &&
    (!takesShort || shortAmount !== null) &&
    (!coding || wrongChange || code !== null) &&
    (!coding || !wrongChange || shortAmount !== null) &&
    (!asksMoney || (moneyPreviewed !== null && !money.isFetching));
  const submit = (event: FormEvent) => {
    event.preventDefault();
    if (!ready) return;
    resolve.mutate({
      kind: 'resolve',
      body: {
        resolution,
        responsible: needsResponsible(ticket.kind) && responsible !== '' ? responsible : null,
        message: message.trim(),
        receivedLines: correcting ? lines : null,
        affected: affected ?? [],
        shortAmount,
        code,
      },
    });
  };
  const result = resolve.data;
  return (
    <form onSubmit={submit}>
      <h2>{t('tickets.resolve.title')}</h2>
      <label>
        {t('tickets.resolve.resolution')}
        <select
          value={resolution}
          onChange={(event) => setResolution(event.target.value as TicketResolution)}
        >
          {choices.map((choice) => (
            <option key={choice} value={choice}>
              {t(resolutionKeys[choice])}
            </option>
          ))}
        </select>
      </label>
      {needsResponsible(ticket.kind) && (
        <label>
          {t('tickets.resolve.responsible')}
          <select
            value={responsible}
            onChange={(event) => setResponsible(event.target.value as ResponsibleParty | '')}
          >
            <option value="">{t('tickets.choose')}</option>
            {Object.entries(responsibleKeys)
              .filter(([party]) => !(wrongChange && order !== null && party === 'restaurant'))
              .map(([party, key]) => (
                <option key={party} value={party}>
                  {t(key)}
                </option>
              ))}
          </select>
        </label>
      )}
      {correcting && ticket.pickupDispute && (
        <fieldset>
          <legend>{t('tickets.resolve.received')}</legend>
          {ticket.pickupDispute.currencies.map((currency) => (
            <label key={currency}>
              {currency}
              <input
                inputMode="decimal"
                value={typed[currency] ?? ''}
                onChange={(event) => setTyped({ ...typed, [currency]: event.target.value })}
              />
            </label>
          ))}
          {lines === null && <p role="alert">{t('tickets.refusal.invalidLines')}</p>}
          {preview.data?.status === 'refused' && (
            <p role="alert">{t(resolveRefusalKeys[preview.data.refusal])}</p>
          )}
          {preview.isError && <p role="alert">{t('common.failed')}</p>}
          {previewed && (
            <section>
              <h3>{t('tickets.resolve.preview')}</h3>
              <ul>
                {previewed.captainChanges.map((change) => (
                  <li key={change.currency}>
                    {change.amount.startsWith('-')
                      ? t('tickets.resolve.captainReimbursed', {
                          amount: formatMoney({ ...change, amount: change.amount.slice(1) }),
                        })
                      : t('tickets.resolve.captainHandsIn', { amount: formatMoney(change) })}
                  </li>
                ))}
                {previewed.merchant.amount !== '0' && (
                  <li>
                    {previewed.merchant.amount.startsWith('-')
                      ? t('tickets.resolve.merchantDebit', {
                          amount: formatMoney({
                            ...previewed.merchant,
                            amount: previewed.merchant.amount.slice(1),
                          }),
                        })
                      : t('tickets.resolve.merchantCredit', {
                          amount: formatMoney(previewed.merchant),
                        })}
                  </li>
                )}
              </ul>
            </section>
          )}
        </fieldset>
      )}
      {order !== null && ticket.kind === 'general' && (
        <ProblemMoney
          order={order}
          takesItems={takesItems}
          takesShort={takesShort}
          quantities={quantities}
          onQuantities={setQuantities}
          short={short}
          onShort={setShort}
          invalid={affected === null || shortInvalid}
        />
      )}
      {coding && wrongChange && <p>{t('tickets.money.wrongChangeCode')}</p>}
      {coding && !wrongChange && compensations.data && (
        <fieldset>
          <legend>{t('tickets.money.code')}</legend>
          <CompensationFields data={compensations.data} fields={codeForm} onChange={setCodeForm} />
        </fieldset>
      )}
      {compensations.isError && <p role="alert">{t('common.failed')}</p>}
      {money.data?.status === 'refused' && (
        <p role="alert">{t(resolveRefusalKeys[money.data.refusal])}</p>
      )}
      {money.isError && <p role="alert">{t('common.failed')}</p>}
      {asksMoney && moneyPreviewed && <MoneyPreviewLines preview={moneyPreviewed} />}
      <label>
        {t('tickets.resolve.message')}
        <textarea
          value={message}
          maxLength={500}
          onChange={(event) => setMessage(event.target.value)}
        />
      </label>
      <CannedReplies onPick={setMessage} />
      <p>{t('tickets.resolve.messageNote', { party: ticket.partyName })}</p>
      <button type="submit" disabled={!ready || resolve.isPending}>
        {t('tickets.resolve.submit')}
      </button>
      {resolve.isError && <p role="alert">{t('common.failed')}</p>}
      {result?.status === 'refused' && <p role="alert">{t(resolveRefusalKeys[result.refusal])}</p>}
    </form>
  );
}

// AP §8.10, CU Q23 (slice 2.23c): the order's lines and what the captain
// recorded at the door.
function TicketOrderFacts({ order }: { order: TicketOrder }) {
  const { t } = useTranslation();
  const money = (amount: string) => formatMoney({ amount, currency: order.currency });
  return (
    <section>
      <h2>{t('tickets.money.orderHeading')}</h2>
      {!order.deliveredNormally && <p>{t('tickets.money.notDelivered')}</p>}
      <ul>
        {order.lines.map((line) => (
          <li key={line.position}>
            {t('tickets.money.line', {
              name: line.name,
              quantity: line.quantity,
              price: money(line.unitPrice),
            })}
          </li>
        ))}
      </ul>
      <p>{t('tickets.money.total', { amount: money(order.total) })}</p>
      {order.received.length > 0 && (
        <p>
          {t('tickets.money.received', { amount: order.received.map(formatMoney).join(' + ') })}
        </p>
      )}
      {order.change.length > 0 && (
        <p>{t('tickets.money.change', { amount: order.change.map(formatMoney).join(' + ') })}</p>
      )}
    </section>
  );
}

// The affected items (V) or the wrong change (M) of a problem after delivery.
function ProblemMoney({
  order,
  takesItems,
  takesShort,
  quantities,
  onQuantities,
  short,
  onShort,
  invalid,
}: {
  order: TicketOrder;
  takesItems: boolean;
  takesShort: boolean;
  quantities: Record<number, string>;
  onQuantities: (quantities: Record<number, string>) => void;
  short: string;
  onShort: (short: string) => void;
  invalid: boolean;
}) {
  const { t } = useTranslation();
  if (!takesItems && !takesShort) return null;
  return (
    <fieldset>
      <legend>{t(takesItems ? 'tickets.money.affected' : 'tickets.money.short')}</legend>
      {takesItems &&
        order.lines.map((line) => (
          <label key={line.position}>
            {t('tickets.money.affectedOf', { name: line.name, quantity: line.quantity })}
            <input
              inputMode="numeric"
              value={quantities[line.position] ?? ''}
              onChange={(event) =>
                onQuantities({ ...quantities, [line.position]: event.target.value })
              }
            />
          </label>
        ))}
      {takesShort && (
        <label>
          {t('tickets.money.shortAmountLabel', { currency: order.currency })}
          <input
            inputMode="decimal"
            value={short}
            onChange={(event) => onShort(event.target.value)}
          />
        </label>
      )}
      {invalid && <p role="alert">{t('tickets.refusal.invalidAffected')}</p>}
    </fieldset>
  );
}

// The entries in words: V, what the restaurant ends up owing and what the
// captain is charged; nothing for the platform or the customer.
function MoneyPreviewLines({
  preview,
}: {
  preview: {
    currency: string | null;
    affectedValue: string;
    merchantDebit: string;
    captainCharge: string;
  };
}) {
  const { t } = useTranslation();
  if (preview.currency === null) return null;
  const money = (amount: string) => formatMoney({ amount, currency: preview.currency! });
  return (
    <section>
      <h3>{t('tickets.resolve.preview')}</h3>
      <ul>
        {preview.affectedValue !== '0' && (
          <li>{t('tickets.money.affectedValue', { amount: money(preview.affectedValue) })}</li>
        )}
        {preview.merchantDebit !== '0' && (
          <li>{t('tickets.money.merchantOwes', { amount: money(preview.merchantDebit) })}</li>
        )}
        {preview.captainCharge !== '0' && (
          <li>{t('tickets.money.captainCharged', { amount: money(preview.captainCharge) })}</li>
        )}
        {preview.merchantDebit === '0' && preview.captainCharge === '0' && (
          <li>{t('tickets.money.noEntries')}</li>
        )}
      </ul>
    </section>
  );
}

// «إغلاق» (owner decision 2026-11-17): no message, no entries.
function CloseTicket({ ticketId, cityId }: { ticketId: string; cityId: string }) {
  const { t } = useTranslation();
  const close = useResolveTicket(cityId, ticketId);
  const [reason, setReason] = useState('');
  const submit = (event: FormEvent) => {
    event.preventDefault();
    if (reason.trim()) close.mutate({ kind: 'close', reason: reason.trim() });
  };
  const result = close.data;
  return (
    <form onSubmit={submit}>
      <h2>{t('tickets.close.title')}</h2>
      <p>{t('tickets.close.note')}</p>
      <label>
        {t('tickets.close.reason')}
        <input value={reason} maxLength={500} onChange={(event) => setReason(event.target.value)} />
      </label>
      <button type="submit" disabled={!reason.trim() || close.isPending}>
        {t('tickets.close.submit')}
      </button>
      {close.isError && <p role="alert">{t('common.failed')}</p>}
      {result?.status === 'refused' && <p role="alert">{t(resolveRefusalKeys[result.refusal])}</p>}
    </form>
  );
}
