import { Body, ForbiddenException, Get, Put } from '@nestjs/common';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { AppSignedIn, CurrentAppSession } from '../../http/access.js';
import { CaptainController } from '../../http/route-groups.js';
import type { AppSession } from '../identity/index.js';
import { CaptainsService } from './captains.service.js';
import { type CaptainDeviceCheck, captainDeviceCheckCodes } from './device-check.js';

const captainDeviceCheckSchema = z
  .object({
    at: z.iso.datetime(),
    passed: z.boolean().describe('No failed item.'),
    failed: z.array(z.enum(captainDeviceCheckCodes)),
  })
  .meta({ id: 'CaptainDeviceCheck' });

class CaptainThisDeviceCheckDto extends createZodDto(
  z.object({
    check: captainDeviceCheckSchema
      .nullable()
      .describe('This phone’s latest device check (CA §4.5); null before its first.'),
  }),
) {}

class CaptainDeviceCheckReportDto extends createZodDto(
  z.object({
    failed: z
      .array(z.enum(captainDeviceCheckCodes))
      .max(captainDeviceCheckCodes.length)
      .describe('The checks of CA §4.5 that failed; empty when all passed.'),
  }),
) {}

// CA §4.5, §15 «Report the device check» (slice 2.43): this phone's last
// check, which the app runs before the first «متصل» on it, and its report
// after each run, stored on the captain profile (AP §9.7.4). The report
// sets a value, so it takes no Idempotency-Key.
@CaptainController('device')
export class CaptainDeviceController {
  constructor(private readonly captains: CaptainsService) {}

  @Get('check')
  @AppSignedIn()
  @ZodResponse({ status: 200, type: CaptainThisDeviceCheckDto })
  async check(@CurrentAppSession() session: AppSession) {
    return { check: body(await this.captains.deviceCheck(captainOf(session), session.deviceId)) };
  }

  @Put('check')
  @AppSignedIn()
  @ZodResponse({ status: 200, type: CaptainThisDeviceCheckDto })
  async report(
    @CurrentAppSession() session: AppSession,
    @Body() report: CaptainDeviceCheckReportDto,
  ) {
    const check = await this.captains.recordDeviceCheck(
      captainOf(session),
      session.deviceId,
      report.failed,
    );
    return { check: body(check) };
  }
}

function body(check: CaptainDeviceCheck | null) {
  return check && { at: check.at.toISOString(), passed: check.passed, failed: check.failed };
}

function captainOf(session: AppSession): string {
  if (session.captain === null) throw new ForbiddenException();
  return session.captain.captainId;
}
