import type { components } from '@fox-drop/api-schema';
import { queryOptions, useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { useRef } from 'react';
import { api } from './api.js';
import { decimalOf, minorOf } from './format.js';
import { pollUnlessLive } from './live.js';
import { type AdminSession, can } from './session.js';

// AP §9.9 «الدعم» (slice 2.23a): manual tickets, their list, page, notes,
// assignee and status, and their SLA timer.
export const SUPPORT_READ = 'support.read';
export const SUPPORT_MANAGE = 'support.manage';
// AP §6.3: a pickup dispute is resolved by OWN, OPS and FIN.
export const RESOLVE_PICKUP_DISPUTE = 'support.resolve_pickup_dispute';

export type Ticket = components['schemas']['AdminTicketDto_Output'];
export type TicketPage = components['schemas']['AdminTicketPageDto_Output'];
export type TicketTypes = components['schemas']['AdminTicketTypesDto_Output'];
export type TicketStatus = Ticket['status'];
export type TicketParty = Ticket['party'];
export type TicketSla = Ticket['sla'];
export type TicketKind = Ticket['kind'];
export type TicketResolution = NonNullable<Ticket['resolution']>['code'];
export type ResponsibleParty = NonNullable<NonNullable<Ticket['resolution']>['responsible']>;
export type PickupDispute = NonNullable<TicketPage['pickupDispute']>;
export type TicketReport = NonNullable<TicketPage['report']>;
export type CorrectionPreview = components['schemas']['AdminTicketCorrectionDto_Output'];
export type TicketOrder = NonNullable<TicketPage['order']>;
export type MoneyPreview = components['schemas']['AdminTicketMoneyPreviewDto_Output'];
export type AffectedLine = { position: number; quantity: number };
type CompensateBody = components['schemas']['AdminCompensateDto'];
export type CannedReply = components['schemas']['AdminCannedRepliesDto_Output']['replies'][number];

export const canReadTickets = (session: AdminSession | null | undefined) =>
  can(session, SUPPORT_READ);
export const canManageTickets = (session: AdminSession | null | undefined) =>
  can(session, SUPPORT_MANAGE);

// AP Appendix C.
export const ticketStatusKeys = {
  new: 'tickets.status.new',
  in_progress: 'tickets.status.inProgress',
  waiting: 'tickets.status.waiting',
  resolved: 'tickets.status.resolved',
  closed: 'tickets.status.closed',
} as const satisfies Record<TicketStatus, string>;

export const ticketPartyKeys = {
  customer: 'tickets.party.customer',
  restaurant: 'tickets.party.restaurant',
  captain: 'tickets.party.captain',
} as const satisfies Record<TicketParty, string>;

export const slaKindKeys = {
  first_response: 'tickets.sla.firstResponse',
  resolution: 'tickets.sla.resolution',
} as const satisfies Record<TicketSla['kind'], string>;

// The sources the panel names; the server's `source` is a string, and a code
// the panel does not know is hidden.
export const ticketSourceKeys = {
  manual: 'tickets.source.manual',
  pickup_dispute: 'tickets.source.pickupDispute',
  customer_report: 'tickets.source.customerReport',
  price_report: 'tickets.source.priceReport',
  merchant_report: 'tickets.source.merchantReport',
  order_problem: 'tickets.source.orderProblem',
} as const;

// RA §15 (slice 2.24b): what «طلب تعديل بيانات» asks to change.
export const dataChangeSubjectKeys = {
  min_order: 'tickets.report.subjects.minOrder',
  coverage: 'tickets.report.subjects.coverage',
  owners: 'tickets.report.subjects.owners',
  owner_phone: 'tickets.report.subjects.ownerPhone',
} as const satisfies Record<NonNullable<TicketReport['subject']>, string>;
export type TicketSource = keyof typeof ticketSourceKeys;

export function sourceKey(source: string): (typeof ticketSourceKeys)[TicketSource] | null {
  return Object.hasOwn(ticketSourceKeys, source) ? ticketSourceKeys[source as TicketSource] : null;
}

// AP §4.8.
export const ticketLabel = (number: string): string => `T-${number}`;

export type SlaState = 'running' | 'amber' | 'breached' | 'met';

// AP §9.9.2: amber at 80% of the timer, red once breached; a first response
// given in time is met. The server's rule (support/tickets.ts) on its clock.
export function slaState(sla: TicketSla, now: number): SlaState {
  const start = Date.parse(sla.startedAt);
  const due = Date.parse(sla.dueAt);
  const end = sla.stoppedAt === null ? now : Date.parse(sla.stoppedAt);
  if (end >= due) return 'breached';
  if (sla.stoppedAt !== null) return 'met';
  return now >= start + (due - start) * 0.8 ? 'amber' : 'running';
}

// Whole minutes left (negative once past), for «متبقٍ {د} د».
export function minutesLeft(sla: TicketSla, now: number): number {
  return Math.ceil((Date.parse(sla.dueAt) - now) / 60_000);
}

// «بانتظار رد» by hand, and back to «قيد المعالجة»; «محلولة» only by
// resolving (owner decision 2026-11-17).
export function statusChoices(status: TicketStatus): ('in_progress' | 'waiting')[] {
  if (status === 'new' || status === 'in_progress') return ['waiting'];
  if (status === 'waiting') return ['in_progress'];
  return [];
}

export const isOpenTicket = (status: TicketStatus): boolean =>
  status === 'new' || status === 'in_progress' || status === 'waiting';

// AP §9.9.3 (slice 2.23b): the resolutions each kind takes, as the server's
// support/tickets.ts.
export const resolutionKeys = {
  none_explained: 'tickets.resolution.noneExplained',
  compensation_code: 'tickets.resolution.compensationCode',
  free_redelivery: 'tickets.resolution.freeRedelivery',
  price_corrected: 'tickets.resolution.priceCorrected',
  price_correct: 'tickets.resolution.priceCorrect',
  captain_paid: 'tickets.resolution.captainPaid',
  accounts_corrected: 'tickets.resolution.accountsCorrected',
  payment_correct: 'tickets.resolution.paymentCorrect',
} as const satisfies Record<TicketResolution, string>;

export const responsibleKeys = {
  restaurant: 'tickets.responsible.restaurant',
  captain: 'tickets.responsible.captain',
  customer: 'tickets.responsible.customer',
  platform: 'tickets.responsible.platform',
} as const satisfies Record<ResponsibleParty, string>;

export const confirmedByKeys = {
  restaurant: 'tickets.dispute.confirmedBy.restaurant',
  automatic: 'tickets.dispute.confirmedBy.automatic',
  operations: 'tickets.dispute.confirmedBy.operations',
} as const satisfies Record<PickupDispute['confirmedBy'], string>;

export function resolutionChoices(kind: TicketKind): TicketResolution[] {
  switch (kind) {
    case 'general':
      return ['compensation_code', 'free_redelivery', 'none_explained'];
    case 'price_difference':
      return ['price_corrected', 'price_correct'];
    case 'pickup_dispute':
      return ['captain_paid', 'accounts_corrected', 'payment_correct'];
  }
}

// AP §8.10, §9.9.3 (slice 2.23c): the money a general ticket's resolution
// takes is a customer's ticket on an order (the server's `order`): «كود
// تعويض» for a session holding operations.compensate, the affected items and
// M once the order was delivered normally. «مشكلة في المبلغ أو الباقي» takes
// M (its code is M, uncapped), every other type the affected items.
export const WRONG_CHANGE_TYPE = 'amount_or_change';

// «إعادة توصيل مجانية» (AP §9.9.3, slice 2.23d) re-delivers the affected
// items of a normal delivery, so never for the wrong change.
export function generalChoices(
  ticket: Pick<TicketPage, 'kind' | 'order' | 'typeCode'>,
  compensates: boolean,
): TicketResolution[] {
  return resolutionChoices(ticket.kind).filter((choice) => {
    if (choice === 'compensation_code') return ticket.order !== null && compensates;
    if (choice === 'free_redelivery') {
      return (
        ticket.order !== null &&
        ticket.order.deliveredNormally &&
        ticket.typeCode !== WRONG_CHANGE_TYPE
      );
    }
    return true;
  });
}

// AP §9.9.3: a re-delivery is never at the customer's fault, and its
// captain's pay can be charged to a responsible restaurant or captain only.
export const redeliveryParties: ResponsibleParty[] = ['restaurant', 'captain', 'platform'];
export const chargesPay = (responsible: ResponsibleParty | ''): boolean =>
  responsible === 'restaurant' || responsible === 'captain';

// The affected quantities typed per line position: the lines with one or
// more, each within its quantity; null when one is not a whole number in it.
export function affectedOf(
  lines: TicketOrder['lines'],
  typed: Record<number, string>,
): AffectedLine[] | null {
  const affected: AffectedLine[] = [];
  for (const line of lines) {
    const text = (typed[line.position] ?? '').trim();
    if (text === '' || text === '0') continue;
    if (!/^\d{1,2}$/.test(text)) return null;
    const quantity = Number(text);
    if (quantity > line.quantity) return null;
    affected.push({ position: line.position, quantity });
  }
  return affected;
}

// M typed in major units, as minor units; null when it is not an amount
// above zero.
export function shortAmountOf(typed: string, currency: string): string | null {
  const amount = minorOf(typed, currency);
  return amount === null || amount === '0' ? null : amount;
}

// AP §8.10 «previewed before the ticket is resolved»: the entries for the
// responsible party, the affected lines and M.
export function moneyPreviewQuery(
  cityId: string,
  ticketId: string,
  body: {
    responsible: ResponsibleParty;
    affected: AffectedLine[];
    shortAmount: string | null;
    code: boolean;
    redelivery: boolean;
  },
) {
  return queryOptions({
    queryKey: ['ticket', ticketId, 'money', body],
    queryFn: async (): Promise<
      { status: 'done'; preview: MoneyPreview } | { status: 'refused'; refusal: ResolveRefusal }
    > => {
      const { data, error, response } = await api.POST(
        '/v1/admin/tickets/{ticketId}/money-preview',
        {
          params: { path: { ticketId } },
          body: { cityId, ...body },
        },
      );
      if (data) return { status: 'done', preview: data };
      const refusal = refusalOf<ResolveRefusal>(error, resolveRefusals);
      if (refusal) return { status: 'refused', refusal };
      throw new Error(`The money preview failed with ${response.status}.`);
    },
  });
}

// AP §9.9.3: the responsible party is asked for every ticket but a price
// difference.
export const needsResponsible = (kind: TicketKind): boolean => kind !== 'price_difference';

// Who may resolve the ticket (AP §6.3): a pickup dispute with its own
// permission, every other with support.manage.
export function canResolve(
  session: AdminSession | null | undefined,
  ticket: Pick<Ticket, 'kind' | 'status'>,
): boolean {
  if (!isOpenTicket(ticket.status)) return false;
  return can(session, ticket.kind === 'pickup_dispute' ? RESOLVE_PICKUP_DISPUTE : SUPPORT_MANAGE);
}

// «إغلاق»: whoever may resolve the ticket (AP §6.3).
export const canCloseTicket = canResolve;

// «تصحيح في الحسابات»: the amounts typed per currency in major units, as
// lines in minor units; an empty field or a zero is left out; null when one
// is not an amount.
export function receivedLinesOf(
  typed: Record<string, string>,
): { currency: string; amount: string }[] | null {
  const lines: { currency: string; amount: string }[] = [];
  for (const [currency, text] of Object.entries(typed)) {
    if (text.trim() === '') continue;
    const amount = minorOf(text, currency);
    if (amount === null) return null;
    if (amount !== '0') lines.push({ currency, amount });
  }
  return lines;
}

// The fields of the correction form, started from the lines the restaurant
// said it received.
export function typedLinesOf(dispute: PickupDispute): Record<string, string> {
  return Object.fromEntries(
    dispute.currencies.map((currency) => {
      const line = dispute.received.find((each) => each.currency === currency);
      return [currency, line ? decimalOf(line.amount, currency) : ''];
    }),
  );
}

export interface TicketFilters {
  status: TicketStatus | '';
  typeCode: string;
  assigneeId: string;
  source: TicketSource | '';
  breached: boolean;
}

export const NO_TICKET_FILTER: TicketFilters = {
  status: '',
  typeCode: '',
  assigneeId: '',
  source: '',
  breached: false,
};

// The tickets are live over the city's channel (ticket.changed) and read
// again every 10 seconds only while it is down, like the board.
export const TICKETS_POLL_MS = 10_000;

export function ticketsQuery(cityId: string, filters: TicketFilters) {
  return queryOptions({
    queryKey: ['tickets', cityId, filters],
    queryFn: async (): Promise<Ticket[]> => {
      const { data, error } = await api.GET('/v1/admin/tickets', {
        params: {
          query: {
            cityId,
            ...(filters.status ? { status: filters.status } : {}),
            ...(filters.typeCode ? { typeCode: filters.typeCode } : {}),
            ...(filters.assigneeId ? { assigneeId: filters.assigneeId } : {}),
            ...(filters.source ? { source: filters.source } : {}),
            ...(filters.breached ? { breached: 'true' as const } : {}),
          },
        },
      });
      if (error || !data) throw new Error('The tickets could not be read.');
      return data.tickets;
    },
    refetchInterval: pollUnlessLive(cityId, TICKETS_POLL_MS),
  });
}

export function ticketQuery(cityId: string, ticketId: string) {
  return queryOptions({
    queryKey: ['ticket', ticketId],
    queryFn: async (): Promise<TicketPage | null> => {
      const { data, response } = await api.GET('/v1/admin/tickets/{ticketId}', {
        params: { path: { ticketId }, query: { cityId } },
      });
      if (response.status === 404) return null;
      if (!data) throw new Error('The ticket could not be read.');
      return data;
    },
    refetchInterval: pollUnlessLive(cityId, TICKETS_POLL_MS),
  });
}

export const ticketTypesQuery = queryOptions({
  queryKey: ['ticket-types'],
  queryFn: async (): Promise<TicketTypes> => {
    const { data, error } = await api.GET('/v1/admin/tickets/types');
    if (error || !data) throw new Error('The ticket types could not be read.');
    return data;
  },
});

export const ticketAssigneesQuery = queryOptions({
  queryKey: ['ticket-assignees'],
  queryFn: async (): Promise<{ id: string; name: string }[]> => {
    const { data, error } = await api.GET('/v1/admin/tickets/assignees');
    if (error || !data) throw new Error('The assignees could not be read.');
    return data.assignees;
  },
});

export function orderTicketsQuery(orderId: string) {
  return queryOptions({
    queryKey: ['order', orderId, 'tickets'],
    queryFn: async (): Promise<Ticket[]> => {
      const { data, error } = await api.GET('/v1/admin/orders/{orderId}/tickets', {
        params: { path: { orderId } },
      });
      if (error || !data) throw new Error("The order's tickets could not be read.");
      return data.tickets;
    },
  });
}

export type OpenRefusal =
  | 'unknown_reason'
  | 'reason_note_required'
  | 'unknown_party'
  | 'unknown_order'
  | 'no_captain'
  | 'idempotency_key_reused'
  | 'invalid_restaurant';

const openRefusals: readonly string[] = [
  'unknown_reason',
  'reason_note_required',
  'unknown_party',
  'unknown_order',
  'no_captain',
  'idempotency_key_reused',
  'invalid_restaurant',
] satisfies OpenRefusal[];

export type OpenResult =
  { status: 'done'; ticket: Ticket } | { status: 'refused'; refusal: OpenRefusal };

export interface OpenTicketBody {
  party: TicketParty;
  typeCode: string;
  description: string;
}

// «سعر مختلف عن المحل» (owner decision 2026-11-17): a customer's, naming the
// restaurant.
export const PRICE_DIFFERENCE = 'price_difference';
export const PICKUP_DISPUTE = 'pickup_dispute';

function refusalOf<T extends string>(error: unknown, known: readonly string[]): T | null {
  const refusal = (error as { error?: unknown } | undefined)?.error;
  return typeof refusal === 'string' && known.includes(refusal) ? (refusal as T) : null;
}

// One Idempotency-Key per body until an answer arrives, so a retry after a
// lost answer opens one ticket (architecture §5.3).
function useKeys() {
  const keys = useRef(new Map<string, string>());
  return {
    keyFor(body: object): [string, () => void] {
      const id = JSON.stringify(body);
      let key = keys.current.get(id);
      if (key === undefined) {
        key = crypto.randomUUID();
        keys.current.set(id, key);
      }
      return [key, () => keys.current.delete(id)];
    },
  };
}

// «تذكرة يدوية» from the list: a party found by name or number.
export function useOpenTicket(cityId: string) {
  const queryClient = useQueryClient();
  const keys = useKeys();
  return useMutation({
    mutationFn: async (
      body: OpenTicketBody & { partyId: string; restaurantId: string | null },
    ): Promise<OpenResult> => {
      const [key, done] = keys.keyFor(body);
      const { data, error, response } = await api.POST('/v1/admin/tickets', {
        params: { header: { 'Idempotency-Key': key } },
        body: { cityId, ...body },
      });
      if (data) {
        done();
        return { status: 'done', ticket: data };
      }
      const refusal = refusalOf<OpenRefusal>(error, openRefusals);
      if (refusal) {
        done();
        return { status: 'refused', refusal };
      }
      throw new Error(`Opening the ticket failed with ${response.status}.`);
    },
    onSettled: () => queryClient.invalidateQueries({ queryKey: ['tickets', cityId] }),
  });
}

// AP §9.3.2 «فتح تذكرة» on the order: the party is the order's.
export function useOpenOrderTicket(orderId: string) {
  const queryClient = useQueryClient();
  const keys = useKeys();
  return useMutation({
    mutationFn: async (body: OpenTicketBody): Promise<OpenResult> => {
      const [key, done] = keys.keyFor(body);
      const { data, error, response } = await api.POST('/v1/admin/orders/{orderId}/tickets', {
        params: { path: { orderId }, header: { 'Idempotency-Key': key } },
        body,
      });
      if (data) {
        done();
        return { status: 'done', ticket: data };
      }
      const refusal = refusalOf<OpenRefusal>(error, openRefusals);
      if (refusal) {
        done();
        return { status: 'refused', refusal };
      }
      throw new Error(`Opening the ticket failed with ${response.status}.`);
    },
    onSettled: () =>
      Promise.all([
        queryClient.invalidateQueries({ queryKey: ['order', orderId] }),
        queryClient.invalidateQueries({ queryKey: ['tickets'] }),
        queryClient.invalidateQueries({ queryKey: ['orders-board'] }),
      ]),
  });
}

// A party of the city: a customer by the number, a restaurant by a part of
// its name, a captain by either. A read sent as a POST so a number never sits
// in a URL.
export function useFindParties(cityId: string) {
  return useMutation({
    mutationFn: async ({ party, q }: { party: TicketParty; q: string }) => {
      const { data, response } = await api.POST('/v1/admin/tickets/parties/search', {
        body: { cityId, party, q },
      });
      if (!data) throw new Error(`The search failed with ${response.status}.`);
      return data.parties;
    },
  });
}

export type ChangeRefusal =
  | 'unknown_ticket'
  | 'ticket_not_open'
  | 'unknown_assignee'
  | 'invalid_status_change'
  | 'idempotency_key_reused';

const changeRefusals: readonly string[] = [
  'unknown_ticket',
  'ticket_not_open',
  'unknown_assignee',
  'invalid_status_change',
  'idempotency_key_reused',
] satisfies ChangeRefusal[];

export type ChangeResult =
  { status: 'done'; page: TicketPage } | { status: 'refused'; refusal: ChangeRefusal };

export type TicketChange =
  | { kind: 'note'; body: string }
  | { kind: 'assign'; assigneeId: string | null }
  | { kind: 'status'; status: 'in_progress' | 'waiting' };

// A note (with its key), the assignee or the status; the assignee and the
// status set a value, so they take no key.
export function useChangeTicket(cityId: string, ticketId: string) {
  const queryClient = useQueryClient();
  const keys = useKeys();
  return useMutation({
    mutationFn: async (change: TicketChange): Promise<ChangeResult> => {
      const path = { ticketId };
      let answer;
      let done = () => {};
      if (change.kind === 'note') {
        const [key, forget] = keys.keyFor(change);
        done = forget;
        answer = await api.POST('/v1/admin/tickets/{ticketId}/notes', {
          params: { path, header: { 'Idempotency-Key': key } },
          body: { cityId, body: change.body },
        });
      } else if (change.kind === 'assign') {
        answer = await api.PUT('/v1/admin/tickets/{ticketId}/assignee', {
          params: { path },
          body: { cityId, assigneeId: change.assigneeId },
        });
      } else {
        answer = await api.PUT('/v1/admin/tickets/{ticketId}/status', {
          params: { path },
          body: { cityId, status: change.status },
        });
      }
      const { data, error, response } = answer;
      if (data) {
        done();
        return { status: 'done', page: data };
      }
      const refusal = refusalOf<ChangeRefusal>(error, changeRefusals);
      if (refusal) {
        done();
        return { status: 'refused', refusal };
      }
      throw new Error(`The ticket change failed with ${response.status}.`);
    },
    onSuccess: (result) => {
      if (result.status === 'done') queryClient.setQueryData(['ticket', ticketId], result.page);
    },
    onSettled: () =>
      Promise.all([
        queryClient.invalidateQueries({ queryKey: ['tickets', cityId] }),
        queryClient.invalidateQueries({ queryKey: ['ticket', ticketId] }),
      ]),
  });
}

export function useTicketTypes(enabled = true) {
  return useQuery({ ...ticketTypesQuery, enabled });
}

// AP §9.13 «الردود الجاهزة»: read on the ticket page and in «المحتوى».
export const cannedRepliesQuery = queryOptions({
  queryKey: ['canned-replies'],
  queryFn: async (): Promise<CannedReply[]> => {
    const { data, error } = await api.GET('/v1/admin/content/canned-replies');
    if (error || !data) throw new Error('The canned replies could not be read.');
    return data.replies;
  },
});

export type ResolveRefusal =
  | 'unknown_ticket'
  | 'ticket_not_open'
  | 'invalid_resolution'
  | 'responsible_required'
  | 'lines_required'
  | 'invalid_lines'
  | 'no_difference'
  | 'order_required'
  | 'not_delivered'
  | 'amount_required'
  | 'value_required'
  | 'invalid_affected'
  | 'invalid_value'
  | 'unknown_reason'
  | 'no_base_currency'
  | 'currency_changed'
  | 'money_already_resolved'
  | 'affected_required'
  | 'captain_pay_unset'
  | 'restaurant_closed'
  | 'emergency_stop'
  | 'forbidden';

const resolveRefusals: readonly string[] = [
  'unknown_ticket',
  'ticket_not_open',
  'invalid_resolution',
  'responsible_required',
  'lines_required',
  'invalid_lines',
  'no_difference',
  'order_required',
  'not_delivered',
  'amount_required',
  'value_required',
  'invalid_affected',
  'invalid_value',
  'unknown_reason',
  'no_base_currency',
  'currency_changed',
  'money_already_resolved',
  'affected_required',
  'captain_pay_unset',
  'restaurant_closed',
  'emergency_stop',
  'forbidden',
] satisfies ResolveRefusal[];

export type ResolveResult =
  { status: 'done'; page: TicketPage } | { status: 'refused'; refusal: ResolveRefusal };

export interface ResolveBody {
  resolution: TicketResolution;
  responsible: ResponsibleParty | null;
  message: string;
  receivedLines: { currency: string; amount: string }[] | null;
  // AP §8.10 (slice 2.23c).
  affected: AffectedLine[];
  shortAmount: string | null;
  code: CompensateBody | null;
  // «إعادة توصيل مجانية» (slice 2.23d).
  chargePay: boolean;
}

// AP §9.9.3 «Preview» of «تصحيح في الحسابات», asked for each set of lines.
export function correctionPreviewQuery(
  cityId: string,
  ticketId: string,
  receivedLines: { currency: string; amount: string }[],
) {
  return queryOptions({
    queryKey: ['ticket', ticketId, 'correction', receivedLines],
    queryFn: async (): Promise<
      | { status: 'done'; preview: CorrectionPreview }
      | { status: 'refused'; refusal: ResolveRefusal }
    > => {
      const { data, error, response } = await api.POST(
        '/v1/admin/tickets/{ticketId}/correction-preview',
        { params: { path: { ticketId } }, body: { cityId, receivedLines } },
      );
      if (data) return { status: 'done', preview: data };
      const refusal = refusalOf<ResolveRefusal>(error, resolveRefusals);
      if (refusal) return { status: 'refused', refusal };
      throw new Error(`The correction preview failed with ${response.status}.`);
    },
  });
}

// «حل التذكرة» and «إغلاق» (owner decision 2026-11-17): each answers the
// page; a repeat is refused by what the first changed, so no key.
export function useResolveTicket(cityId: string, ticketId: string) {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: async (
      change: { kind: 'resolve'; body: ResolveBody } | { kind: 'close'; reason: string },
    ): Promise<ResolveResult> => {
      const path = { ticketId };
      const { data, error, response } =
        change.kind === 'resolve'
          ? await api.POST('/v1/admin/tickets/{ticketId}/resolve', {
              params: { path },
              body: { cityId, ...change.body },
            })
          : await api.POST('/v1/admin/tickets/{ticketId}/close', {
              params: { path },
              body: { cityId, reason: change.reason },
            });
      if (data) return { status: 'done', page: data };
      const refusal = refusalOf<ResolveRefusal>(error, resolveRefusals);
      if (refusal) return { status: 'refused', refusal };
      throw new Error(`The ticket change failed with ${response.status}.`);
    },
    onSuccess: (result) => {
      if (result.status === 'done') queryClient.setQueryData(['ticket', ticketId], result.page);
    },
    onSettled: () =>
      Promise.all([
        queryClient.invalidateQueries({ queryKey: ['tickets', cityId] }),
        queryClient.invalidateQueries({ queryKey: ['ticket', ticketId] }),
        queryClient.invalidateQueries({ queryKey: ['alerts'] }),
      ]),
  });
}
