import { ForbiddenException, Get } from '@nestjs/common';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { AppSignedIn, CurrentAppSession } from '../../http/access.js';
import { CaptainController } from '../../http/route-groups.js';
import type { AppSession } from '../identity/index.js';
import { captainTicketBody, captainTicketOut } from './ticket-body.js';
import { SupportService } from './support.service.js';

class CaptainReportsDto extends createZodDto(
  z.object({
    tickets: z
      .array(captainTicketBody)
      .describe("Newest first, the latest 100: the captain's tickets, the panel's included."),
  }),
) {}

// CA §13 «بلاغاتي» (slice 2.24c): the captain's tickets with their status
// and resolution message; the appeals join with 2.36 (owner decision
// 2026-11-17).
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
