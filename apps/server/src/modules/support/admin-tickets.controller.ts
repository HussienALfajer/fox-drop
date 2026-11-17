import { Body, Get, HttpCode, Param, Post, Put, Query, Req } from '@nestjs/common';
import type { FastifyRequest } from 'fastify';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { CurrentAdminSession, RequirePermission } from '../../http/access.js';
import { Idempotent, IdempotencyKey } from '../../http/idempotency.js';
import { phoneOf } from '../../http/phone-search.js';
import { AdminController } from '../../http/route-groups.js';
import type { AdminSession } from '../identity/index.js';
import { ticketSources } from './schema.js';
import { SupportService } from './support.service.js';
import {
  answered,
  noteOut,
  openTicketFields,
  ticketAdminOf,
  ticketBody,
  ticketNoteBody,
  ticketOut,
} from './ticket-body.js';
import { ticketParties, ticketStatuses } from './tickets.js';

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
  z.object({ ...city, ...openTicketFields, partyId: z.uuid() }),
) {}

class AdminTicketDto extends createZodDto(ticketBody) {}

class AdminTicketPageDto extends createZodDto(
  ticketBody.extend({ notes: z.array(ticketNoteBody).describe('Oldest first.') }),
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
      this.support.open(body, ticketAdminOf(session, request), idempotencyKey, new Date()),
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
}

function pageOut(page: Awaited<ReturnType<SupportService['ticket']>>): AdminTicketPageDto {
  return { ...ticketOut(page), notes: page.notes.map(noteOut) } as AdminTicketPageDto;
}
