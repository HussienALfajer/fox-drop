import {
  BadRequestException,
  ConflictException,
  HttpStatus,
  NotFoundException,
  UnprocessableEntityException,
} from '@nestjs/common';
import type { FastifyRequest } from 'fastify';
import { z } from 'zod';
import { requestContext } from '../../http/request-context.js';
import { ContentRefusedError } from '../content/index.js';
import type { AdminSession } from '../identity/index.js';
import { ticketSources } from './schema.js';
import type { Ticket, TicketAdmin, TicketNote } from './support.service.js';
import { TicketRefusedError } from './support.service.js';
import { slaKinds, ticketParties, ticketStatuses } from './tickets.js';

const number = z.string().regex(/^\d{1,18}$/);

// A ticket as the panel reads it (AP §9.9.2–§9.9.3). The SLA's state is
// worked out by the panel from its times, so it moves without a read.
export const ticketBody = z.object({
  id: z.uuid(),
  number: number.describe('Shown as `T-{number}` (AP §4.8).'),
  source: z.enum(ticketSources),
  party: z.enum(ticketParties),
  partyId: z.uuid(),
  partyName: z.string(),
  orderId: z.uuid().nullable(),
  orderNumber: number.nullable(),
  urgent: z.boolean().describe('«عاجلة»: open, on an order still active.'),
  typeCode: z.string(),
  typeLabel: z.string(),
  description: z.string(),
  status: z.enum(ticketStatuses),
  assigneeId: z.uuid().nullable(),
  assigneeName: z.string().nullable(),
  sla: z.object({
    kind: z.enum(slaKinds),
    startedAt: z.iso.datetime(),
    dueAt: z.iso.datetime(),
    stoppedAt: z.iso.datetime().nullable().describe('The first response once given.'),
  }),
  openedByName: z.string().nullable(),
  openedAt: z.iso.datetime(),
  updatedAt: z.iso.datetime(),
});

export const ticketNoteBody = z.object({
  id: z.uuid(),
  authorName: z.string().nullable(),
  body: z.string(),
  createdAt: z.iso.datetime(),
});

// What opening a ticket asks: the party, its type and what was said.
export const openTicketFields = {
  party: z.enum(ticketParties),
  typeCode: z.string().min(1).max(60).describe("From the party's list (AP Appendix B)."),
  description: z.string().trim().min(1).max(2000),
};

export function ticketOut(ticket: Ticket): z.infer<typeof ticketBody> {
  return {
    id: ticket.id,
    number: ticket.number.toString(),
    source: ticket.source,
    party: ticket.party,
    partyId: ticket.partyId,
    partyName: ticket.partyName,
    orderId: ticket.orderId,
    orderNumber: ticket.orderNumber?.toString() ?? null,
    urgent: ticket.urgent,
    typeCode: ticket.typeCode,
    typeLabel: ticket.typeLabel,
    description: ticket.description,
    status: ticket.status,
    assigneeId: ticket.assigneeId,
    assigneeName: ticket.assigneeName,
    sla: {
      kind: ticket.sla.kind,
      startedAt: ticket.sla.startedAt.toISOString(),
      dueAt: ticket.sla.dueAt.toISOString(),
      stoppedAt: ticket.sla.stoppedAt?.toISOString() ?? null,
    },
    openedByName: ticket.openedByName,
    openedAt: ticket.openedAt.toISOString(),
    updatedAt: ticket.updatedAt.toISOString(),
  };
}

export function noteOut(note: TicketNote): z.infer<typeof ticketNoteBody> {
  return {
    id: note.id,
    authorName: note.authorName,
    body: note.body,
    createdAt: note.createdAt.toISOString(),
  };
}

export function ticketAdminOf(session: AdminSession, request: FastifyRequest): TicketAdmin {
  return {
    accountId: session.accountId,
    actor: { type: 'admin', id: session.accountId, role: session.roles.join(',') },
    context: requestContext(request),
  };
}

// The refusals as HTTP answers.
export async function answered<T>(run: () => Promise<T>): Promise<T> {
  try {
    return await run();
  } catch (error) {
    if (error instanceof ContentRefusedError) {
      throw new BadRequestException({ statusCode: HttpStatus.BAD_REQUEST, error: error.refusal });
    }
    if (!(error instanceof TicketRefusedError)) throw error;
    switch (error.refusal) {
      case 'unknown_ticket':
      case 'unknown_party':
        throw new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, error: error.refusal });
      case 'unknown_assignee':
        throw new BadRequestException({ statusCode: HttpStatus.BAD_REQUEST, error: error.refusal });
      case 'idempotency_key_reused':
        throw new UnprocessableEntityException({
          statusCode: HttpStatus.UNPROCESSABLE_ENTITY,
          error: error.refusal,
        });
      default:
        throw new ConflictException({ statusCode: HttpStatus.CONFLICT, error: error.refusal });
    }
  }
}
