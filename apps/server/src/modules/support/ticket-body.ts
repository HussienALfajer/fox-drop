import {
  BadRequestException,
  ConflictException,
  ForbiddenException,
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
import type { MoneyLine, PickupCorrectionPreview, PickupDisputeFacts } from './pickup-disputes.js';
import type { Ticket, TicketAdmin, TicketNote } from './support.service.js';
import { TicketRefusedError } from './support.service.js';
import {
  responsibleParties,
  slaKinds,
  ticketKinds,
  ticketParties,
  ticketResolutions,
  ticketStatuses,
} from './tickets.js';

const number = z.string().regex(/^\d{1,18}$/);

// Money in minor units of its currency, as the panel reads it elsewhere.
export const moneyLine = z.object({
  amount: z.string().regex(/^-?\d{1,18}$/),
  currency: z.string().regex(/^[A-Z]{3}$/),
});

// A line the resolver enters: what the restaurant received in a currency.
export const receivedLine = z.object({
  amount: z.string().regex(/^\d{1,15}$/),
  currency: z.string().regex(/^[A-Z]{3}$/),
});

// A ticket as the panel reads it (AP §9.9.2–§9.9.3). The SLA's state is
// worked out by the panel from its times, so it moves without a read.
export const ticketBody = z.object({
  id: z.uuid(),
  number: number.describe('Shown as `T-{number}` (AP §4.8).'),
  // A string, not an enum: the sources of the apps join with their slices
  // (2.23b, 2.24), and a one-value enum makes the Dart client's names fail
  // its analysis.
  source: z
    .string()
    .describe(`Where the ticket came from (AP §9.9.1): ${ticketSources.join(', ')} so far.`),
  party: z.enum(ticketParties),
  partyId: z.uuid(),
  partyName: z.string(),
  orderId: z.uuid().nullable(),
  orderNumber: number.nullable(),
  urgent: z
    .boolean()
    .describe('«عاجلة»: open, on an order still active, or a pickup dispute while open.'),
  kind: z
    .enum(ticketKinds)
    .describe('Which resolutions it takes (AP §9.9.3): general, price_difference, pickup_dispute.'),
  restaurantId: z.uuid().nullable().describe('«سعر مختلف عن المحل»: the restaurant.'),
  restaurantName: z.string().nullable(),
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
  resolution: z
    .object({
      code: z.enum(ticketResolutions),
      responsible: z.enum(responsibleParties).nullable(),
      message: z.string().describe("Sent to the ticket's party."),
      correctedLines: z
        .array(moneyLine)
        .nullable()
        .describe('«تصحيح في الحسابات»: what the restaurant received, as corrected.'),
      resolvedAt: z.iso.datetime(),
      resolvedByName: z.string().nullable(),
    })
    .nullable()
    .describe('«محلولة»'),
  closure: z
    .object({
      reason: z.string(),
      closedAt: z.iso.datetime(),
      closedByName: z.string().nullable(),
    })
    .nullable()
    .describe('«مغلقة» without a resolution.'),
});

// AP §9.9.3: what the pickup-dispute ticket shows.
export const pickupDisputeBody = z.object({
  pickupPayment: moneyLine,
  recorded: z.array(moneyLine).describe("The captain's payment lines as booked."),
  received: z.array(moneyLine).describe('What the restaurant says it received.'),
  confirmedBy: z.enum(['restaurant', 'automatic', 'operations']),
  captainName: z.string().nullable(),
  disputedAt: z.iso.datetime(),
  currencies: z.array(z.string()).describe('The currencies the corrected lines may use.'),
});

export const correctionPreviewBody = z.object({
  captainChanges: z
    .array(moneyLine)
    .describe('Per currency: + the captain hands it in, − the desk reimburses them.'),
  merchant: moneyLine.describe('+ a credit to the restaurant, − a debit.'),
  entries: z.array(
    z.object({
      type: z.string(),
      reason: z.string().nullable(),
      account: z.string(),
      party: z.object({
        kind: z.enum(['merchant', 'captain', 'platform']),
        id: z.uuid().nullable(),
        name: z.string().nullable(),
      }),
      amount: moneyLine.describe("From the platform's side: + a debit, − a credit."),
    }),
  ),
});

const moneyOut = (line: MoneyLine) => ({
  amount: line.amount.toString(),
  currency: line.currency,
});

export function linesIn(lines: z.infer<typeof receivedLine>[]): MoneyLine[] {
  return lines.map((line) => ({ currency: line.currency, amount: BigInt(line.amount) }));
}

export function pickupDisputeOut(facts: PickupDisputeFacts): z.infer<typeof pickupDisputeBody> {
  return {
    pickupPayment: moneyOut(facts.pickupPayment),
    recorded: facts.recorded.map(moneyOut),
    received: facts.received.map(moneyOut),
    confirmedBy: facts.confirmedBy,
    captainName: facts.captainName,
    disputedAt: facts.disputedAt.toISOString(),
    currencies: facts.currencies,
  };
}

export function correctionPreviewOut(
  preview: PickupCorrectionPreview,
): z.infer<typeof correctionPreviewBody> {
  return {
    captainChanges: preview.captainChanges.map(moneyOut),
    merchant: moneyOut(preview.merchant),
    entries: preview.entries.map((entry) => ({
      type: entry.type,
      reason: entry.reason,
      account: entry.account,
      party: entry.party,
      amount: moneyOut(entry.amount),
    })),
  };
}

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
    kind: ticket.kind,
    restaurantId: ticket.restaurantId,
    restaurantName: ticket.restaurantName,
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
    resolution:
      ticket.resolution === null
        ? null
        : {
            code: ticket.resolution.code,
            responsible: ticket.resolution.responsible,
            message: ticket.resolution.message,
            correctedLines: ticket.resolution.correctedLines?.map(moneyOut) ?? null,
            resolvedAt: ticket.resolution.resolvedAt.toISOString(),
            resolvedByName: ticket.resolution.resolvedByName,
          },
    closure:
      ticket.closure === null
        ? null
        : {
            reason: ticket.closure.reason,
            closedAt: ticket.closure.closedAt.toISOString(),
            closedByName: ticket.closure.closedByName,
          },
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
    permissions: session.permissions,
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
      case 'forbidden':
        throw new ForbiddenException({ statusCode: HttpStatus.FORBIDDEN, error: error.refusal });
      case 'unknown_assignee':
      case 'invalid_restaurant':
      case 'invalid_resolution':
      case 'responsible_required':
      case 'lines_required':
      case 'invalid_lines':
      case 'no_difference':
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
