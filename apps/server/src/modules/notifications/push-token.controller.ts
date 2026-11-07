import { Body, HttpCode, HttpStatus, Put } from '@nestjs/common';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { AppSignedIn, CurrentAppSession } from '../../http/access.js';
import {
  CaptainController,
  CustomerController,
  MerchantController,
} from '../../http/route-groups.js';
import type { AppSession } from '../identity/index.js';
import { PushDevices } from './push-devices.js';
import { pushPlatforms } from './schema.js';

class PushTokenDto extends createZodDto(
  z.object({
    token: z.string().min(1).max(4096).describe("Firebase Cloud Messaging's registration token."),
    platform: z.enum(pushPlatforms),
  }),
) {}

class PushTokenRegisteredDto extends createZodDto(z.object({ status: z.literal('registered') })) {}

async function registered(devices: PushDevices, session: AppSession, body: PushTokenDto) {
  await devices.register(session, body.token, body.platform, new Date());
  return { status: 'registered' as const };
}

// Architecture §8.1: each app registers its token at every start and whenever
// Firebase renews it; a repeat sets the same value, so it needs no key.
@CustomerController('push-token')
export class CustomerPushTokenController {
  constructor(private readonly devices: PushDevices) {}

  @Put()
  @AppSignedIn()
  @HttpCode(HttpStatus.OK)
  @ZodResponse({ status: HttpStatus.OK, type: PushTokenRegisteredDto })
  register(@CurrentAppSession() session: AppSession, @Body() body: PushTokenDto) {
    return registered(this.devices, session, body);
  }
}

@MerchantController('push-token')
export class MerchantPushTokenController {
  constructor(private readonly devices: PushDevices) {}

  @Put()
  @AppSignedIn()
  @HttpCode(HttpStatus.OK)
  @ZodResponse({ status: HttpStatus.OK, type: PushTokenRegisteredDto })
  register(@CurrentAppSession() session: AppSession, @Body() body: PushTokenDto) {
    return registered(this.devices, session, body);
  }
}

@CaptainController('push-token')
export class CaptainPushTokenController {
  constructor(private readonly devices: PushDevices) {}

  @Put()
  @AppSignedIn()
  @HttpCode(HttpStatus.OK)
  @ZodResponse({ status: HttpStatus.OK, type: PushTokenRegisteredDto })
  register(@CurrentAppSession() session: AppSession, @Body() body: PushTokenDto) {
    return registered(this.devices, session, body);
  }
}
