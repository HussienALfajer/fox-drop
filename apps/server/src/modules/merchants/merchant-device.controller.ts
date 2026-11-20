import { Body, HttpStatus, NotFoundException, Put } from '@nestjs/common';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { AppSignedIn, CurrentAppSession } from '../../http/access.js';
import { MerchantController } from '../../http/route-groups.js';
import type { AppSession } from '../identity/index.js';
import { MerchantsRefusedError, MerchantsService } from './merchants.service.js';
import { ReceivingDevicesService } from './receiving-devices.service.js';
import { deviceCheckCodes } from './receiving.js';

class MerchantDeviceReportDto extends createZodDto(
  z.object({
    appVersion: z.string().min(1).max(40),
    ringing: z
      .boolean()
      .nullable()
      .describe(
        '«الرنين على هذا الجهاز» (RA §4.4), an owner’s setting; ignored for a cashier, whose device always rings; null leaves it as it is.',
      ),
  }),
) {}

class MerchantDeviceCheckDto extends createZodDto(
  z.object({
    failed: z
      .array(z.enum(deviceCheckCodes))
      .max(deviceCheckCodes.length)
      .describe('The checks of RA §4.5 that failed; empty when all passed.'),
    delayMs: z
      .int()
      .min(0)
      .max(600_000)
      .nullable()
      .describe('Check 8: the server connection’s delay, or null when it failed.'),
  }),
) {}

export const merchantDeviceCheckSchema = z
  .object({
    at: z.iso.datetime(),
    passed: z.boolean().describe('No failed item but `sleep`, a warning only.'),
    failed: z.array(z.enum(deviceCheckCodes)),
    delayMs: z.int().nullable(),
  })
  .meta({ id: 'MerchantDeviceCheck' });

class MerchantThisDeviceDto extends createZodDto(
  z.object({
    ringing: z
      .boolean()
      .describe('Whether ring events ring on this device (a cashier’s always, RA §4.4).'),
    check: merchantDeviceCheckSchema.nullable().describe('The latest device check (RA §4.5).'),
  }),
) {}

// RA §4.4–4.5 (slice 2.42): this device's report and its device check. The
// app sends the report at every start and when an owner turns ringing on or
// off, the check after each run; each sets a value, so neither takes an
// Idempotency-Key. A device not named yet is 404 unknown_device (the app
// names it first, RA §5.2 item 5).
@MerchantController()
export class MerchantDeviceController {
  constructor(
    private readonly devices: ReceivingDevicesService,
    private readonly merchants: MerchantsService,
  ) {}

  @Put('device')
  @AppSignedIn()
  @ZodResponse({ status: 200, type: MerchantThisDeviceDto })
  async report(@CurrentAppSession() session: AppSession, @Body() body: MerchantDeviceReportDto) {
    const account = merchantOf(session);
    await refused(() =>
      this.devices.report(account.restaurantId, session.deviceId, {
        appVersion: body.appVersion,
        ringing: account.role === 'owner' ? body.ringing : null,
      }),
    );
    return this.answer(session);
  }

  @Put('device/check')
  @AppSignedIn()
  @ZodResponse({ status: 200, type: MerchantThisDeviceDto })
  async check(@CurrentAppSession() session: AppSession, @Body() body: MerchantDeviceCheckDto) {
    const account = merchantOf(session);
    await refused(() =>
      this.devices.recordCheck(account.restaurantId, session.deviceId, {
        failed: body.failed,
        delayMs: body.delayMs,
      }),
    );
    return this.answer(session);
  }

  private async answer(session: AppSession) {
    const account = merchantOf(session);
    const device = (await this.merchants.devices(account.restaurantId)).find(
      (each) => each.deviceId === session.deviceId,
    );
    if (!device) throw unknownDevice();
    return {
      ringing: account.role === 'cashier' || device.ringing,
      check: device.check && { ...device.check, at: device.check.at.toISOString() },
    };
  }
}

function merchantOf(session: AppSession) {
  if (!session.merchant) throw new Error('a merchant route without a restaurant user');
  return session.merchant;
}

function unknownDevice() {
  return new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, error: 'unknown_device' });
}

async function refused(run: () => Promise<void>): Promise<void> {
  try {
    await run();
  } catch (error) {
    if (error instanceof MerchantsRefusedError && error.refusal === 'unknown_device') {
      throw unknownDevice();
    }
    throw error;
  }
}
