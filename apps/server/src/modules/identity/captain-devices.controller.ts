import {
  Body,
  ConflictException,
  Get,
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

class AdminCaptainDeviceDto extends createZodDto(
  z.object({
    device: z
      .object({
        sessionId: z.uuid().describe('Named by «تحرير الجهاز», so it never ends a newer one.'),
        signedInAt: z.iso.datetime(),
      })
      .nullable()
      .describe('The device signed in now (K5: one at a time), or null.'),
  }),
) {}

class AdminReleaseDeviceDto extends createZodDto(
  z.object({
    sessionId: z.uuid().describe('The device the panel showed.'),
    reason: z.string().trim().min(1).max(500).describe('Why, kept in the audit log (AP §9.7.5).'),
  }),
) {}

class AdminDeviceReleasedDto extends createZodDto(z.object({ status: z.literal('released') })) {}

// AP §9.7.5 «تحرير الجهاز» (OWN, OPS: captains.manage). The release names the
// session the panel showed, so a repeat or a late release is refused (409
// no_device) instead of signing out the new phone: no Idempotency-Key.
@AdminController('captains')
export class CaptainDevicesController {
  constructor(private readonly devices: CaptainDevicesService) {}

  // 404 unknown_captain for a captain with no sign-in account.
  @Get(':captainId/device')
  @RequirePermission('captains.manage')
  @ZodResponse({ status: 200, type: AdminCaptainDeviceDto })
  async device(@Param() params: AdminCaptainParamsDto) {
    try {
      const device = await this.devices.device(params.captainId);
      return {
        device: device && { ...device, signedInAt: device.signedInAt.toISOString() },
      };
    } catch (error) {
      throw refused(error);
    }
  }

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
      await this.devices.release(
        params.captainId,
        body.sessionId,
        body.reason,
        actor,
        requestContext(request),
      );
      return { status: 'released' as const };
    } catch (error) {
      throw refused(error);
    }
  }
}

function refused(error: unknown): unknown {
  if (!(error instanceof DeviceReleaseRefusedError)) return error;
  if (error.refusal === 'unknown_captain') {
    return new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, error: error.refusal });
  }
  return new ConflictException({ statusCode: HttpStatus.CONFLICT, error: error.refusal });
}
