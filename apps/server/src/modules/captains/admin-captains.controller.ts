import {
  Body,
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
import { CaptainsRefusedError, CaptainsService } from './captains.service.js';

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
}

function refused(error: unknown): unknown {
  if (error instanceof CaptainsRefusedError && error.refusal === 'unknown_captain') {
    return new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, error: error.refusal });
  }
  return error;
}
