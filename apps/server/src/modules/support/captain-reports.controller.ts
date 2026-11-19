import { Body, ForbiddenException, Get, HttpCode, Param, Post, Req } from '@nestjs/common';
import type { FastifyRequest } from 'fastify';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { AppSignedIn, CurrentAppSession } from '../../http/access.js';
import { Idempotent, IdempotencyKey } from '../../http/idempotency.js';
import { requestContext } from '../../http/request-context.js';
import { CaptainController } from '../../http/route-groups.js';
import { NOTE_MAX } from '../content/index.js';
import type { AppSession } from '../identity/index.js';
import { answered, captainTicketBody, captainTicketOut } from './ticket-body.js';
import { SupportService } from './support.service.js';

class CaptainReportsDto extends createZodDto(
  z.object({
    tickets: z
      .array(captainTicketBody)
      .describe("Newest first, the latest 100: the captain's tickets, the panel's included."),
  }),
) {}

// CA §13 «بلاغاتي» (slice 2.24c): the captain's tickets with their status
// and resolution message, the appeals among them (slice 2.36b).
@CaptainController('reports')
export class CaptainReportsController {
  constructor(private readonly support: SupportService) {}

  @Get()
  @AppSignedIn()
  @ZodResponse({ status: 200, type: CaptainReportsDto })
  async list(@CurrentAppSession() session: AppSession) {
    const captain = session.captain;
    if (!captain) throw new ForbiddenException();
    const tickets = await this.support.captainTickets({
      accountId: session.accountId,
      captainId: captain.captainId,
    });
    return { tickets: tickets.map(captainTicketOut) };
  }
}

class CaptainAppealParamsDto extends createZodDto(z.object({ violationId: z.uuid() })) {}

class CaptainAppealBodyDto extends createZodDto(
  z.object({
    text: z.string().trim().min(1).max(NOTE_MAX).describe('Why the captain appeals.'),
    photoUploadId: z
      .uuid()
      .nullable()
      .describe('One photo at most, from POST /v1/captain/uploads/report-photo once uploaded.'),
  }),
) {}

class CaptainAppealTicketDto extends createZodDto(z.object({ ticket: captainTicketBody })) {}

// CA §11.3 «اعتراض», AP §9.7.5 (slice 2.36b): the captain appeals one of its
// violations; the ticket's status and decision show in «بلاغاتي». 400 the
// photo's upload_not_found, upload_expired, upload_missing, upload_invalid;
// 404 unknown_violation; 409 already_appealed, upload_used; 422
// idempotency_key_reused.
@CaptainController('violations')
export class CaptainAppealsController {
  constructor(private readonly support: SupportService) {}

  @Post(':violationId/appeal')
  @AppSignedIn()
  @Idempotent()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: CaptainAppealTicketDto })
  async appeal(
    @CurrentAppSession() session: AppSession,
    @Param() params: CaptainAppealParamsDto,
    @Body() body: CaptainAppealBodyDto,
    @IdempotencyKey() idempotencyKey: string,
    @Req() request: FastifyRequest,
  ) {
    const captain = session.captain;
    if (!captain) throw new ForbiddenException();
    const ticket = await answered(() =>
      this.support.appealViolation(
        params.violationId,
        { text: body.text, photoUploadId: body.photoUploadId },
        {
          accountId: session.accountId,
          captainId: captain.captainId,
          context: requestContext(request),
        },
        idempotencyKey,
        new Date(),
      ),
    );
    return { ticket: captainTicketOut(ticket) };
  }
}
