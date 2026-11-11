import {
  Body,
  ConflictException,
  HttpCode,
  HttpStatus,
  NotFoundException,
  Param,
  Post,
  Req,
} from '@nestjs/common';
import type { FastifyRequest } from 'fastify';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { CurrentAdminSession, RequirePermission } from '../../http/access.js';
import { requestContext } from '../../http/request-context.js';
import { AdminController } from '../../http/route-groups.js';
import type { AdminSession } from './admin-sessions.service.js';
import { CaptainDevicesService, DeviceReleaseRefusedError } from './captain-devices.service.js';

class AdminCaptainParamsDto extends createZodDto(z.object({ captainId: z.uuid() })) {}

class AdminReleaseDeviceDto extends createZodDto(
  z.object({
    reason: z.string().trim().min(1).max(500).describe('Why, kept in the audit log (AP §9.7.5).'),
  }),
) {}

class AdminDeviceReleasedDto extends createZodDto(z.object({ status: z.literal('released') })) {}

// AP §9.7.5 «تحرير الجهاز» (OWN, OPS: captains.manage). No Idempotency-Key: a
// repeat finds no device signed in and is refused (409 no_device).
@AdminController('captains')
export class CaptainDevicesController {
  constructor(private readonly devices: CaptainDevicesService) {}

  // 404 unknown_captain for a captain with no sign-in account.
  @Post(':captainId/release-device')
  @HttpCode(200)
  @RequirePermission('captains.manage')
  @ZodResponse({ status: 200, type: AdminDeviceReleasedDto })
  async release(
    @Param() params: AdminCaptainParamsDto,
    @Body() body: AdminReleaseDeviceDto,
    @CurrentAdminSession() actor: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    try {
      await this.devices.release(params.captainId, body.reason, actor, requestContext(request));
      return { status: 'released' as const };
    } catch (error) {
      if (!(error instanceof DeviceReleaseRefusedError)) throw error;
      if (error.refusal === 'unknown_captain') {
        throw new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, error: error.refusal });
      }
      throw new ConflictException({ statusCode: HttpStatus.CONFLICT, error: error.refusal });
    }
  }
}
