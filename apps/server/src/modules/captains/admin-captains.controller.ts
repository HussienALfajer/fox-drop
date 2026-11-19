import {
  BadRequestException,
  Body,
  ConflictException,
  HttpCode,
  HttpStatus,
  NotFoundException,
  Param,
  Get,
  Post,
  Put,
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

const actionReason = z
  .string()
  .trim()
  .min(1)
  .max(500)
  .describe('Kept in the audit log (AP §9.7.5: every action needs a reason).');

class AdminCaptainStatusDto extends createZodDto(
  z.object({
    status: z
      .enum(['suspended', 'active'])
      .describe('«إيقاف» or the reactivation; the termination is the offboarding’s.'),
    until: z.iso
      .datetime()
      .nullable()
      .describe('A suspension’s end, null for until further notice; null to reactivate.'),
    reason: actionReason.describe('A suspension’s is shown to the captain (AP §9.7.5).'),
  }),
) {}

class AdminCaptainCashLimitDto extends createZodDto(
  z.object({
    amount: z
      .string()
      .regex(/^\d{1,15}$/)
      .describe('Minor units, above zero.'),
    currency: z.string().length(3).describe("The city's base currency."),
    reason: actionReason,
  }),
) {}

class AdminCaptainActionDoneDto extends createZodDto(z.object({ done: z.literal(true) })) {}

// AP §9.7.5 «فصل من الاتصال» (OWN, OPS: captains.manage), the suspension
// and reactivation (slice 2.36a), the cash limit, the grace, and the
// captain's state the panel shows beside them. A repeat changes nothing more than the
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

  // AP §9.7.5 «إيقاف» (for a duration or until further notice) and the
  // reactivation (OWN, OPS: captains.suspend), each with a reason; the
  // captain hears it (CA §14 #26). It sets a state, so no Idempotency-Key:
  // suspending again replaces the suspension, reactivating again is 409.
  // 404 unknown_captain; 400 invalid_captain (an end not after now, or an
  // end on a reactivation); 409 status_change_not_allowed (a terminated
  // captain, an active one reactivated) or offboarding_open (the contract
  // is being ended: the captain stays suspended until «إغلاق الحساب»).
  @Post(':captainId/status')
  @HttpCode(200)
  @RequirePermission('captains.suspend')
  @ZodResponse({ status: 200, type: AdminCaptainAvailabilityDto })
  async setStatus(
    @Param() params: AdminCaptainStateParamsDto,
    @Body() body: AdminCaptainStatusDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    try {
      await this.captains.setStatus(
        params.captainId,
        body.status,
        {
          ...changeOf(session, request, body.reason),
          until: body.until === null ? null : new Date(body.until),
        },
        new Date(),
      );
      return await this.availability(params);
    } catch (error) {
      throw refused(error);
    }
  }

  // AP §9.7.5 «Change the cash limit» (OWN, FIN: captains.cash_limit): the
  // new value in the city's base, effective at once, with a reason. It sets
  // a value, so no Idempotency-Key. 404 unknown_captain; 400 invalid_captain
  // (zero), not_in_base_currency; 409 captain_terminated.
  @Put(':captainId/cash-limit')
  @RequirePermission('captains.cash_limit')
  @ZodResponse({ status: 200, type: AdminCaptainActionDoneDto })
  async setCashLimit(
    @Param() params: AdminCaptainStateParamsDto,
    @Body() body: AdminCaptainCashLimitDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    try {
      await this.captains.setCustodyLimit(
        params.captainId,
        { amount: BigInt(body.amount), currency: body.currency },
        changeOf(session, request, body.reason),
      );
      return { done: true as const };
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
  if (
    error.refusal === 'nothing_due' ||
    error.refusal === 'status_change_not_allowed' ||
    error.refusal === 'offboarding_open' ||
    error.refusal === 'captain_terminated'
  ) {
    return new ConflictException({ statusCode: HttpStatus.CONFLICT, error: error.refusal });
  }
  if (
    error.refusal === 'invalid_captain' ||
    error.refusal === 'reason_required' ||
    error.refusal === 'not_in_base_currency'
  ) {
    return new BadRequestException({ statusCode: HttpStatus.BAD_REQUEST, error: error.refusal });
  }
  return error;
}
