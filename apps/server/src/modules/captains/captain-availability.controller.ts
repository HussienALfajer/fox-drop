import {
  BadRequestException,
  Body,
  ConflictException,
  ForbiddenException,
  Get,
  HttpCode,
  HttpStatus,
  Post,
} from '@nestjs/common';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { AppSignedIn, CurrentAppSession } from '../../http/access.js';
import { CaptainController } from '../../http/route-groups.js';
import type { AppSession } from '../identity/index.js';
import type { Availability, OnlineBlock } from './availability.js';
import {
  type CaptainState,
  CaptainsRefusedError,
  CaptainsService,
  type Money,
} from './captains.service.js';

const money = z.object({
  amount: z
    .string()
    .regex(/^-?\d+$/)
    .describe('Integer minor units (AP §8.6).'),
  currency: z.string().length(3),
});

// One object with nullable parts rather than a union, which the generated
// Dart client cannot read without another package.
const availability = z
  .object({
    state: z.enum(['offline', 'online_available', 'busy', 'not_receiving_offers', 'suspended']),
    since: z.iso.datetime().nullable().describe('Online since; null unless online.'),
    reasons: z
      .array(z.enum(['cash_limit', 'closed_due', 'simulated_location']))
      .describe('Why no offers arrive; empty unless not_receiving_offers.'),
    suspensionReason: z.string().nullable(),
    suspendedUntil: z.iso
      .datetime()
      .nullable()
      .describe('While suspended: the end, or null until further notice.'),
  })
  .describe(
    'CA §7.1: «غير متصل», «متصل متاح», «مشغول» (an active order), «لا تصلك عروض» with its reasons, «موقوف».',
  );

class CaptainAvailabilityDto extends createZodDto(
  z.object({
    availability,
    custody: z.object({
      usage: money.describe('The cash held, in the base currency (AP §8.5.3).'),
      limit: money,
      warn: z.boolean().describe('At captain.custody_warn_pct of the limit or more.'),
      closedDue: money.describe('Due from closed business days (AP §8.5.4).'),
      lastCutoff: z.iso.datetime(),
    }),
  }),
) {}

const version = z.string().regex(/^\d+\.\d+\.\d+$/, 'expected a version such as 1.4.0');

class CaptainGoOnlineDto extends createZodDto(
  z.object({
    appVersion: version,
    simulatedLocation: z
      .boolean()
      .describe('A mock-location app is active (Android) or isSimulatedBySoftware (iOS).'),
  }),
) {}

class CaptainWentOfflineDto extends createZodDto(
  z.object({
    handIn: money
      .nullable()
      .describe('CA §7.5: the cash to hand in, above captain.remit_tolerance, or null.'),
  }),
) {}

class CaptainLocationsDto extends createZodDto(
  z.object({
    points: z
      .array(
        z.object({
          latitude: z.number().min(-90).max(90),
          longitude: z.number().min(-180).max(180),
          accuracyMetres: z.number().min(0).max(100_000),
          recordedAt: z.iso.datetime().describe('On the server clock (CA §4.6).'),
          simulated: z.boolean(),
        }),
      )
      .min(1)
      .max(360)
      .describe('Every 10 seconds, or the points queued without a signal (CA §4.3).'),
  }),
) {}

class CaptainLocationsSavedDto extends createZodDto(
  z.object({ accepted: z.int().describe('The new points kept.') }),
) {}

// CA §7, §4.3: the captain's availability, going online and offline, and the
// location every 10 seconds while online.
@CaptainController()
export class CaptainAvailabilityController {
  constructor(private readonly captains: CaptainsService) {}

  @Get('availability')
  @AppSignedIn()
  @ZodResponse({ status: 200, type: CaptainAvailabilityDto })
  async state(@CurrentAppSession() session: AppSession) {
    return stateBody(await this.captains.state(captainOf(session), new Date()));
  }

  // CA §7.2: refused with 409 online_blocked and every block, so the app shows
  // each with its next step.
  @Post('availability/online')
  @AppSignedIn()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: CaptainAvailabilityDto })
  async online(@CurrentAppSession() session: AppSession, @Body() body: CaptainGoOnlineDto) {
    try {
      return stateBody(await this.captains.goOnline(captainOf(session), body, new Date()));
    } catch (error) {
      if (error instanceof CaptainsRefusedError && error.refusal === 'online_blocked') {
        throw new ConflictException({
          statusCode: HttpStatus.CONFLICT,
          error: error.refusal,
          blocks: error.blocks.map(blockBody),
        });
      }
      throw error;
    }
  }

  @Post('availability/offline')
  @AppSignedIn()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: CaptainWentOfflineDto })
  async offline(@CurrentAppSession() session: AppSession) {
    try {
      const { handIn } = await this.captains.goOffline(captainOf(session), new Date());
      return { handIn: handIn === null ? null : moneyBody(handIn) };
    } catch (error) {
      // CA §15: not with an active order.
      if (error instanceof CaptainsRefusedError && error.refusal === 'active_order') {
        throw new ConflictException({ statusCode: HttpStatus.CONFLICT, error: error.refusal });
      }
      throw error;
    }
  }

  // Offline answers 409 not_online: no location is collected (CA §4.3).
  @Post('location')
  @AppSignedIn()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: CaptainLocationsSavedDto })
  async location(@CurrentAppSession() session: AppSession, @Body() body: CaptainLocationsDto) {
    try {
      return await this.captains.recordLocations(
        captainOf(session),
        body.points.map((point) => ({ ...point, recordedAt: new Date(point.recordedAt) })),
        new Date(),
      );
    } catch (error) {
      if (error instanceof CaptainsRefusedError && error.refusal === 'not_online') {
        throw new ConflictException({ statusCode: HttpStatus.CONFLICT, error: error.refusal });
      }
      if (error instanceof CaptainsRefusedError && error.refusal === 'invalid_location') {
        throw new BadRequestException({
          statusCode: HttpStatus.BAD_REQUEST,
          error: error.refusal,
          message: error.message,
        });
      }
      throw error;
    }
  }
}

function captainOf(session: AppSession): string {
  if (session.captain === null) throw new ForbiddenException();
  return session.captain.captainId;
}

function moneyBody(money: Money) {
  return { amount: money.amount.toString(), currency: money.currency };
}

function availabilityBody(state: Availability) {
  return {
    state: state.state,
    since: 'since' in state ? state.since.toISOString() : null,
    reasons: state.state === 'not_receiving_offers' ? state.reasons : [],
    suspensionReason: state.state === 'suspended' ? state.reason : null,
    suspendedUntil: state.state === 'suspended' ? (state.until?.toISOString() ?? null) : null,
  };
}

function stateBody({ availability: state, custody }: CaptainState) {
  return {
    availability: availabilityBody(state),
    custody: {
      usage: moneyBody(custody.usage),
      limit: moneyBody(custody.limit),
      warn: custody.warn,
      closedDue: moneyBody(custody.closedDue),
      lastCutoff: custody.lastCutoff.toISOString(),
    },
  };
}

// CA §7.2: each block with what the app needs for its message. Amounts are
// in the base currency of the state's custody.
function blockBody(block: OnlineBlock) {
  switch (block.kind) {
    case 'suspended':
      return { kind: block.kind, reason: block.reason, until: block.until?.toISOString() ?? null };
    case 'closed_due':
      return {
        kind: block.kind,
        amount: block.amount.toString(),
        cutoff: block.cutoff.toISOString(),
      };
    case 'cash_limit':
      return { kind: block.kind, limit: block.limit.toString() };
    default:
      return block;
  }
}
