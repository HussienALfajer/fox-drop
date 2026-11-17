import type { components } from '@fox-drop/api-schema';
import { queryOptions, useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { useRef } from 'react';
import { api } from './api.js';
import { pollUnlessLive } from './live.js';
import { type AdminSession, can } from './session.js';

// AP §9.9 «الدعم» (slice 2.23a): manual tickets, their list, page, notes,
// assignee and status, and their SLA timer.
export const SUPPORT_READ = 'support.read';
export const SUPPORT_MANAGE = 'support.manage';

export type Ticket = components['schemas']['AdminTicketDto_Output'];
export type TicketPage = components['schemas']['AdminTicketPageDto_Output'];
export type TicketTypes = components['schemas']['AdminTicketTypesDto_Output'];
export type TicketStatus = Ticket['status'];
export type TicketParty = Ticket['party'];
export type TicketSla = Ticket['sla'];

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

export const ticketSourceKeys = {
  manual: 'tickets.source.manual',
} as const satisfies Record<Ticket['source'], string>;

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

export interface TicketFilters {
  status: TicketStatus | '';
  typeCode: string;
  assigneeId: string;
  source: Ticket['source'] | '';
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
  | 'idempotency_key_reused';

const openRefusals: readonly string[] = [
  'unknown_reason',
  'reason_note_required',
  'unknown_party',
  'unknown_order',
  'no_captain',
  'idempotency_key_reused',
] satisfies OpenRefusal[];

export type OpenResult =
  { status: 'done'; ticket: Ticket } | { status: 'refused'; refusal: OpenRefusal };

export interface OpenTicketBody {
  party: TicketParty;
  typeCode: string;
  description: string;
}

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
    mutationFn: async (body: OpenTicketBody & { partyId: string }): Promise<OpenResult> => {
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
