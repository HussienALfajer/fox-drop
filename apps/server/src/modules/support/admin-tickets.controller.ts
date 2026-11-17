import { Body, Get, HttpCode, Param, Post, Put, Query, Req } from '@nestjs/common';
import type { FastifyRequest } from 'fastify';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { CurrentAdminSession, RequireAnyPermission, RequirePermission } from '../../http/access.js';
import { Idempotent, IdempotencyKey } from '../../http/idempotency.js';
import { phoneOf } from '../../http/phone-search.js';
import { AdminController } from '../../http/route-groups.js';
import type { AdminSession } from '../identity/index.js';
import { ticketSources } from './schema.js';
import { SupportService } from './support.service.js';
import {
  affectedLine,
  answered,
  correctionPreviewBody,
  correctionPreviewOut,
  linesIn,
  moneyPreviewBody,
  moneyPreviewOut,
  noteOut,
  pickupDisputeBody,
  pickupDisputeOut,
  receivedLine,
  openTicketFields,
  ticketAdminOf,
  ticketBody,
  ticketNoteBody,
  ticketOrderBody,
  ticketOrderOut,
  ticketOut,
} from './ticket-body.js';
import { compensationValue, compensationValueBody } from '../marketing/index.js';
import { TicketRefusedError } from './support.service.js';
import { responsibleParties, ticketParties, ticketResolutions, ticketStatuses } from './tickets.js';

const city = { cityId: z.uuid() };

class AdminTicketsQueryDto extends createZodDto(
  z.object({
    ...city,
    status: z.enum(ticketStatuses).optional(),
    typeCode: z.string().max(60).optional(),
    assigneeId: z.uuid().optional(),
    source: z.enum(ticketSources).optional(),
    breached: z
      .enum(['true', 'false'])
      .optional()
      .describe('«تجاوز المهلة»: only the tickets whose SLA timer is breached.'),
  }),
) {}

class AdminTicketsDto extends createZodDto(
  z.object({ tickets: z.array(ticketBody).describe('Newest first, the latest 200.') }),
) {}

class AdminTicketCityQueryDto extends createZodDto(z.object(city)) {}

class AdminTicketParamsDto extends createZodDto(z.object({ ticketId: z.uuid() })) {}

const choice = z.object({ code: z.string(), label: z.string() });

class AdminTicketTypesDto extends createZodDto(
  z.object({
    customer: z.array(choice),
    restaurant: z.array(choice),
    captain: z.array(choice),
  }),
) {}

class AdminTicketAssigneesDto extends createZodDto(
  z.object({ assignees: z.array(z.object({ id: z.uuid(), name: z.string() })) }),
) {}

class AdminTicketPartySearchDto extends createZodDto(
  z.object({
    ...city,
    party: z.enum(ticketParties),
    q: z.string().trim().min(1).max(60).describe('A part of the name, or the number.'),
  }),
) {}

class AdminTicketPartiesDto extends createZodDto(
  z.object({ parties: z.array(z.object({ id: z.uuid(), name: z.string() })) }),
) {}

class AdminOpenTicketDto extends createZodDto(
  z.object({
    ...city,
    ...openTicketFields,
    partyId: z.uuid(),
    restaurantId: z
      .uuid()
      .nullable()
      .optional()
      .describe('«سعر مختلف عن المحل» (typeCode price_difference): the restaurant it is about.'),
  }),
) {}

class AdminTicketDto extends createZodDto(ticketBody) {}

class AdminTicketPageDto extends createZodDto(
  ticketBody.extend({
    notes: z.array(ticketNoteBody).describe('Oldest first.'),
    pickupDispute: pickupDisputeBody.nullable().describe('«خلاف على دفعة الاستلام» only.'),
    order: ticketOrderBody
      .nullable()
      .describe("A customer's general ticket on an order: its lines and money (AP §8.10)."),
  }),
) {}

const minor = z.string().regex(/^\d{1,15}$/);

const affectedLines = z
  .array(affectedLine)
  .max(50)
  .describe("The order's lines by position, each once, with how many were affected.");

const receivedLines = z
  .array(receivedLine)
  .min(1)
  .max(10)
  .describe('The lines the restaurant received, one per currency.');

class AdminTicketResolveDto extends createZodDto(
  z.object({
    ...city,
    resolution: z.enum(ticketResolutions).describe("From the ticket kind's (AP §9.9.3)."),
    responsible: z
      .enum(responsibleParties)
      .nullable()
      .describe('Required for a general ticket; none for a price difference or a pickup dispute.'),
    message: z.string().trim().min(1).max(500).describe("Sent to the ticket's party."),
    receivedLines: receivedLines.nullable().describe('«تصحيح في الحسابات» only.'),
    affected: affectedLines
      .default([])
      .describe('A problem after delivery: the affected lines (V).'),
    shortAmount: minor
      .nullable()
      .default(null)
      .describe('«مشكلة في المبلغ أو الباقي»: M, what the customer was short.'),
    code: z
      .object({
        value: compensationValueBody,
        reason: z.object({
          code: z.string().max(60),
          note: z.string().trim().max(300).nullable(),
        }),
      })
      .nullable()
      .default(null)
      .describe('«كود تعويض»: its value and reason; null for the wrong change, whose code is M.'),
  }),
) {}

class AdminTicketMoneyPreviewBodyDto extends createZodDto(
  z.object({
    ...city,
    responsible: z.enum(responsibleParties),
    affected: affectedLines,
    shortAmount: minor.nullable(),
    code: z.boolean().describe('Whether the resolution is «كود تعويض».'),
  }),
) {}

class AdminTicketMoneyPreviewDto extends createZodDto(moneyPreviewBody) {}

class AdminTicketCorrectionPreviewDto extends createZodDto(z.object({ ...city, receivedLines })) {}

class AdminTicketCorrectionDto extends createZodDto(correctionPreviewBody) {}

class AdminTicketCloseDto extends createZodDto(
  z.object({ ...city, reason: z.string().trim().min(1).max(500).describe('Internal.') }),
) {}

class AdminTicketNoteDto extends createZodDto(
  z.object({ ...city, body: z.string().trim().min(1).max(2000) }),
) {}

class AdminTicketAssigneeDto extends createZodDto(
  z.object({ ...city, assigneeId: z.uuid().nullable() }),
) {}

class AdminTicketStatusDto extends createZodDto(
  z.object({
    ...city,
    status: z
      .enum(['in_progress', 'waiting'])
      .describe('«بانتظار رد», or back to «قيد المعالجة»; «محلولة» only by resolving.'),
  }),
) {}

// AP §9.9 «الدعم» (slice 2.23a): the tickets' list, «تذكرة يدوية», the
// ticket page with its internal notes, assignee and status. Read by
// support.read (OWN, OPS, SUP, FIN), changed by support.manage (AP §6).
@AdminController('tickets')
export class AdminTicketsController {
  constructor(private readonly support: SupportService) {}

  @Get()
  @RequirePermission('support.read')
  @ZodResponse({ status: 200, type: AdminTicketsDto })
  async list(@Query() query: AdminTicketsQueryDto) {
    const rows = await this.support.list(
      query.cityId,
      {
        status: query.status ?? null,
        typeCode: query.typeCode ?? null,
        assigneeId: query.assigneeId ?? null,
        source: query.source ?? null,
        breached: query.breached === 'true',
      },
      new Date(),
    );
    return { tickets: rows.map(ticketOut) } as AdminTicketsDto;
  }

  @Get('types')
  @RequirePermission('support.read')
  @ZodResponse({ status: 200, type: AdminTicketTypesDto })
  async types() {
    return (await this.support.types()) as AdminTicketTypesDto;
  }

  @Get('assignees')
  @RequirePermission('support.read')
  @ZodResponse({ status: 200, type: AdminTicketAssigneesDto })
  async assignees() {
    return { assignees: await this.support.assignees() } as AdminTicketAssigneesDto;
  }

  // A read sent as a POST so a number never sits in a URL; no key.
  @Post('parties/search')
  @RequirePermission('support.manage')
  @HttpCode(200)
  @ZodResponse({ status: 200, type: AdminTicketPartiesDto })
  async findParties(@Body() body: AdminTicketPartySearchDto) {
    const parties = await this.support.findParties(
      body.cityId,
      body.party,
      { text: body.q, phone: phoneOf(body.q) },
      new Date(),
    );
    return { parties } as AdminTicketPartiesDto;
  }

  // «تذكرة يدوية» without an order (one on an order is opened from the
  // order, POST /v1/admin/orders/{orderId}/tickets). 400 unknown_reason;
  // 404 unknown_party; 422 idempotency_key_reused.
  @Post()
  @RequirePermission('support.manage')
  @Idempotent()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: AdminTicketDto })
  async open(
    @Body() body: AdminOpenTicketDto,
    @IdempotencyKey() idempotencyKey: string,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    const ticket = await answered(() =>
      this.support.open(
        { ...body, restaurantId: body.restaurantId ?? null },
        ticketAdminOf(session, request),
        idempotencyKey,
        new Date(),
      ),
    );
    return ticketOut(ticket) as AdminTicketDto;
  }

  // 404 unknown_ticket.
  @Get(':ticketId')
  @RequirePermission('support.read')
  @ZodResponse({ status: 200, type: AdminTicketPageDto })
  async ticket(@Param() params: AdminTicketParamsDto, @Query() query: AdminTicketCityQueryDto) {
    return pageOut(await answered(() => this.support.ticket(query.cityId, params.ticketId)));
  }

  // AP §4.5 an internal note. 404 unknown_ticket; 409 ticket_not_open; 422
  // idempotency_key_reused.
  @Post(':ticketId/notes')
  @RequirePermission('support.manage')
  @Idempotent()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: AdminTicketPageDto })
  async addNote(
    @Param() params: AdminTicketParamsDto,
    @Body() body: AdminTicketNoteDto,
    @IdempotencyKey() idempotencyKey: string,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return pageOut(
      await answered(() =>
        this.support.addNote(
          body.cityId,
          params.ticketId,
          body.body,
          ticketAdminOf(session, request),
          idempotencyKey,
          new Date(),
        ),
      ),
    );
  }

  // Sets the assignee: no key. 400 unknown_assignee; 404 unknown_ticket;
  // 409 ticket_not_open.
  @Put(':ticketId/assignee')
  @RequirePermission('support.manage')
  @ZodResponse({ status: 200, type: AdminTicketPageDto })
  async assign(
    @Param() params: AdminTicketParamsDto,
    @Body() body: AdminTicketAssigneeDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return pageOut(
      await answered(() =>
        this.support.assign(
          body.cityId,
          params.ticketId,
          body.assigneeId,
          ticketAdminOf(session, request),
          new Date(),
        ),
      ),
    );
  }

  // A repeat is refused by what the first changed: no key. 404
  // unknown_ticket; 409 invalid_status_change.
  @Put(':ticketId/status')
  @RequirePermission('support.manage')
  @ZodResponse({ status: 200, type: AdminTicketPageDto })
  async setStatus(
    @Param() params: AdminTicketParamsDto,
    @Body() body: AdminTicketStatusDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return pageOut(
      await answered(() =>
        this.support.setStatus(
          body.cityId,
          params.ticketId,
          body.status,
          ticketAdminOf(session, request),
          new Date(),
        ),
      ),
    );
  }

  // AP §9.9.3 «Preview»: «تصحيح في الحسابات» before it is posted; writes
  // nothing, so no key. 400 invalid_lines, no_difference; 404
  // unknown_ticket; 409 not_pickup_dispute, ticket_not_open.
  @Post(':ticketId/correction-preview')
  @RequirePermission('support.resolve_pickup_dispute')
  @HttpCode(200)
  @ZodResponse({ status: 200, type: AdminTicketCorrectionDto })
  async correctionPreview(
    @Param() params: AdminTicketParamsDto,
    @Body() body: AdminTicketCorrectionPreviewDto,
  ) {
    const preview = await answered(() =>
      this.support.previewCorrection(
        body.cityId,
        params.ticketId,
        linesIn(body.receivedLines),
        new Date(),
      ),
    );
    return correctionPreviewOut(preview) as AdminTicketCorrectionDto;
  }

  // AP §8.10 «previewed before the ticket is resolved» (slice 2.23c): the
  // entries of a problem after delivery for a responsible party; writes
  // nothing, so no key. 400 invalid_resolution, order_required,
  // not_delivered, amount_required, invalid_affected, invalid_value; 404
  // unknown_ticket; 409 ticket_not_open.
  @Post(':ticketId/money-preview')
  @RequirePermission('support.manage')
  @HttpCode(200)
  @ZodResponse({ status: 200, type: AdminTicketMoneyPreviewDto })
  async moneyPreview(
    @Param() params: AdminTicketParamsDto,
    @Body() body: AdminTicketMoneyPreviewBodyDto,
  ) {
    const preview = await answered(() =>
      this.support.previewMoney(body.cityId, params.ticketId, {
        responsible: body.responsible,
        affected: body.affected,
        shortAmount: body.shortAmount === null ? null : BigInt(body.shortAmount),
        code: body.code,
      }),
    );
    return moneyPreviewOut(preview) as AdminTicketMoneyPreviewDto;
  }

  // «حل التذكرة» (AP §9.9.3; owner decision 2026-11-17): «محلولة» with the
  // message sent to the party. A pickup dispute needs
  // support.resolve_pickup_dispute, every other support.manage (403
  // forbidden). A repeat is refused by what the first changed, so no key.
  // 400 invalid_resolution, responsible_required, lines_required,
  // invalid_lines, no_difference; 404 unknown_ticket; 409 ticket_not_open.
  @Post(':ticketId/resolve')
  @RequireAnyPermission('support.manage', 'support.resolve_pickup_dispute')
  @HttpCode(200)
  @ZodResponse({ status: 200, type: AdminTicketPageDto })
  async resolve(
    @Param() params: AdminTicketParamsDto,
    @Body() body: AdminTicketResolveDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return pageOut(
      await answered(() =>
        this.support.resolve(
          body.cityId,
          params.ticketId,
          {
            resolution: body.resolution,
            responsible: body.responsible,
            message: body.message,
            lines: body.receivedLines === null ? null : linesIn(body.receivedLines),
            affected: body.affected,
            shortAmount: body.shortAmount === null ? null : BigInt(body.shortAmount),
            code: codeIn(body.code),
          },
          ticketAdminOf(session, request),
          new Date(),
        ),
      ),
    );
  }

  // «إغلاق» (owner decision 2026-11-17): «مغلقة» without a resolution, with
  // an internal reason; a pickup dispute needs support.resolve_pickup_dispute
  // (403 forbidden). 404 unknown_ticket; 409 ticket_not_open.
  @Post(':ticketId/close')
  @RequireAnyPermission('support.manage', 'support.resolve_pickup_dispute')
  @HttpCode(200)
  @ZodResponse({ status: 200, type: AdminTicketPageDto })
  async close(
    @Param() params: AdminTicketParamsDto,
    @Body() body: AdminTicketCloseDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return pageOut(
      await answered(() =>
        this.support.close(
          body.cityId,
          params.ticketId,
          body.reason,
          ticketAdminOf(session, request),
          new Date(),
        ),
      ),
    );
  }
}

function pageOut(page: Awaited<ReturnType<SupportService['ticket']>>): AdminTicketPageDto {
  return {
    ...ticketOut(page),
    notes: page.notes.map(noteOut),
    pickupDispute: page.pickupDispute === null ? null : pickupDisputeOut(page.pickupDispute),
    order: page.order === null ? null : ticketOrderOut(page.order),
  } as AdminTicketPageDto;
}

// «كود تعويض»'s value and reason, 400 invalid_value when its fields do not
// fit its kind.
function codeIn(body: AdminTicketResolveDto['code']) {
  if (body === null) return null;
  const value = compensationValue(body.value);
  if (value === null)
    throw new TicketRefusedError('invalid_value', 'the value does not fit its kind');
  return { value, reason: body.reason };
}
