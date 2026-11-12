import {
  Body,
  ConflictException,
  HttpCode,
  HttpStatus,
  NotFoundException,
  Param,
  Get,
  Post,
  Req,
} from '@nestjs/common';
import type { FastifyRequest } from 'fastify';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { CurrentAdminSession, RequirePermission } from '../../http/access.js';
import { requestContext } from '../../http/request-context.js';
import { AdminController } from '../../http/route-groups.js';
import type { AdminSession } from '../identity/index.js';
import { CaptainsRefusedError, CaptainsService, type HandInGrace } from './captains.service.js';

class AdminCaptainStateParamsDto extends createZodDto(z.object({ captainId: z.uuid() })) {}

class AdminCaptainAvailabilityDto extends createZodDto(
  z.object({
    state: z.enum([
      'offline',
      'online_available',
      'busy',
      'last_order',
      'not_receiving_offers',
      'suspended',
    ]),
    lastOrderBy: z
      .enum(['captain', 'forced', 'suspended', 'terminated'])
      .nullable()
      .describe('In last_order: who set it (CA §7.3, §7.6, K18).'),
  }),
) {}

class AdminForceOfflineDto extends createZodDto(
  z.object({
    reason: z
      .string()
      .trim()
      .min(1)
      .max(500)
      .describe('Shown to the captain and kept in the audit log (AP §9.7.5).'),
  }),
) {}

const graceReason = z
  .string()
  .trim()
  .min(1)
  .max(500)
  .describe('Why, such as «المكتب كان مغلقاً»; kept in the audit log (AP §8.5.4).');

class AdminHandInGraceDto extends createZodDto(z.object({ reason: graceReason })) {}

class AdminBulkHandInGraceDto extends createZodDto(
  z.object({ cityId: z.uuid(), reason: graceReason }),
) {}

const graceBody = z.object({
  id: z.uuid(),
  until: z.iso.datetime().describe('The next business-day cutoff when it was granted.'),
  reason: z.string(),
  bulk: z.boolean().describe("The city's bulk grace for one business day."),
  grantedAt: z.iso.datetime(),
});

class AdminHandInGraceAnswerDto extends createZodDto(graceBody) {}

class AdminBulkHandInGraceAnswerDto extends createZodDto(
  z.object({
    grace: graceBody,
    captainIds: z
      .array(z.uuid())
      .describe('The captains blocked by cash due who were told; none on a repeat.'),
  }),
) {}

// AP §9.7.5 «فصل من الاتصال» (OWN, OPS: captains.manage), and the captain's
// state the panel shows beside it. A repeat changes nothing more than the
// first (the captain is already offline or in last-order mode), so no
// Idempotency-Key.
@AdminController('captains')
export class AdminCaptainsController {
  constructor(private readonly captains: CaptainsService) {}

  // 404 unknown_captain.
  @Get(':captainId/availability')
  @RequirePermission('captains.manage')
  @ZodResponse({ status: 200, type: AdminCaptainAvailabilityDto })
  async availability(@Param() params: AdminCaptainStateParamsDto) {
    try {
      const { availability } = await this.captains.state(params.captainId, new Date());
      return {
        state: availability.state,
        lastOrderBy: availability.state === 'last_order' ? availability.by : null,
      };
    } catch (error) {
      throw refused(error);
    }
  }

  // Offline at once, or last-order mode with an active order (K18); the
  // answer is the state after it. 404 unknown_captain.
  @Post(':captainId/force-offline')
  @HttpCode(200)
  @RequirePermission('captains.manage')
  @ZodResponse({ status: 200, type: AdminCaptainAvailabilityDto })
  async forceOffline(
    @Param() params: AdminCaptainStateParamsDto,
    @Body() body: AdminForceOfflineDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    try {
      const now = new Date();
      await this.captains.forceOffline(
        params.captainId,
        {
          actor: { type: 'admin', id: session.accountId, role: session.roles.join(',') },
          context: requestContext(request),
          reason: body.reason,
        },
        now,
      );
      return await this.availability(params);
    } catch (error) {
      throw refused(error);
    }
  }

  // AP §8.5.4 «Hand-in grace» for one captain (OWN, FIN): the closed_due
  // block lifts until the next cutoff. A repeat before that cutoff answers
  // the same grace, so no Idempotency-Key. 404 unknown_captain; 409
  // nothing_due when nothing above the tolerance is due from a closed day.
  @Post(':captainId/hand-in-grace')
  @HttpCode(200)
  @RequirePermission('captains.hand_in_grace')
  @ZodResponse({ status: 200, type: AdminHandInGraceAnswerDto })
  async grantGrace(
    @Param() params: AdminCaptainStateParamsDto,
    @Body() body: AdminHandInGraceDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    try {
      return graceBodyOf(
        await this.captains.grantGrace(
          params.captainId,
          changeOf(session, request, body.reason),
          new Date(),
        ),
      );
    } catch (error) {
      throw refused(error);
    }
  }

  // AP §9.10.3 «Bulk hand-in grace» (OWN), from the daily hand-in tab: every
  // captain of the city for one business day. A repeat answers the same
  // grace and tells no one, so no Idempotency-Key. 404 unknown_city.
  @Post('hand-in-grace')
  @HttpCode(200)
  @RequirePermission('captains.bulk_hand_in_grace')
  @ZodResponse({ status: 200, type: AdminBulkHandInGraceAnswerDto })
  async grantBulkGrace(
    @Body() body: AdminBulkHandInGraceDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    try {
      const { grace, captainIds } = await this.captains.grantBulkGrace(
        body.cityId,
        changeOf(session, request, body.reason),
        new Date(),
      );
      return { grace: graceBodyOf(grace), captainIds };
    } catch (error) {
      throw refused(error);
    }
  }
}

function changeOf(session: AdminSession, request: FastifyRequest, reason: string) {
  return {
    actor: { type: 'admin' as const, id: session.accountId, role: session.roles.join(',') },
    context: requestContext(request),
    reason,
  };
}

export function graceBodyOf(grace: HandInGrace) {
  return {
    id: grace.id,
    until: grace.until.toISOString(),
    reason: grace.reason,
    bulk: grace.bulk,
    grantedAt: grace.grantedAt.toISOString(),
  };
}

function refused(error: unknown): unknown {
  if (!(error instanceof CaptainsRefusedError)) return error;
  if (error.refusal === 'unknown_captain' || error.refusal === 'unknown_city') {
    return new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, error: error.refusal });
  }
  if (error.refusal === 'nothing_due') {
    return new ConflictException({ statusCode: HttpStatus.CONFLICT, error: error.refusal });
  }
  return error;
}
