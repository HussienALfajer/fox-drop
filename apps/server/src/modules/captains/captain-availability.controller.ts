import {
  BadRequestException,
  Body,
  ConflictException,
  ForbiddenException,
  Get,
  HttpCode,
  HttpStatus,
  Post,
  Put,
} from '@nestjs/common';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { AppSignedIn, CurrentAppSession } from '../../http/access.js';
import { CaptainController } from '../../http/route-groups.js';
import { TermsService } from '../content/index.js';
import type { AppSession } from '../identity/index.js';
import type { Availability, OnlineBlock } from './availability.js';
import {
  type CaptainState,
  CaptainsRefusedError,
  CaptainsService,
  type MaxPickup,
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
    state: z.enum([
      'offline',
      'online_available',
      'busy',
      'last_order',
      'not_receiving_offers',
      'suspended',
    ]),
    since: z.iso.datetime().nullable().describe('Online since; null unless online.'),
    reasons: z
      .array(z.enum(['cash_limit', 'closed_due', 'simulated_location']))
      .describe('Why no offers arrive; empty unless not_receiving_offers.'),
    suspensionReason: z.string().nullable(),
    suspendedUntil: z.iso
      .datetime()
      .nullable()
      .describe('While suspended: the end, or null until further notice.'),
    lastOrderBy: z
      .enum(['captain', 'forced', 'suspended', 'terminated'])
      .nullable()
      .describe(
        "In last_order: who set it (CA §7.3, §7.6, K18). Only the captain's own can be cancelled.",
      ),
    lastOrderReason: z
      .string()
      .nullable()
      .describe("In last_order: the reason shown, a force offline's or a suspension's."),
    offersExpired: z
      .number()
      .int()
      .positive()
      .nullable()
      .describe(
        'While offline after C3 (CA §7.4): the offers in a row that expired unanswered, for «لم ترد على {العدد} عروض متتالية، فأصبحت غير متصل. اضغط «متصل» عندما تكون جاهزاً.»; null otherwise.',
      ),
  })
  .describe(
    'CA §7.1: «غير متصل», «متصل متاح», «مشغول» (an active order), «آخر طلب» (last-order mode), «لا تصلك عروض» with its reasons, «موقوف».',
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
      remitTolerance: money.describe(
        'CA §7.5: captain.remit_tolerance; the hand-in reminder shows when usage is above it.',
      ),
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

class CaptainLastOrderDto extends createZodDto(
  z.object({
    on: z
      .boolean()
      .describe('CA §7.3: «لا أريد طلبات جديدة» on, or cancelled before the order ends.'),
  }),
) {}

class CaptainLocationsSavedDto extends createZodDto(
  z.object({ accepted: z.int().describe('The new points kept.') }),
) {}

const carriedCurrenciesSchema = z.object({
  baseCurrency: z.string().length(3).nullable().describe('Null while the city has none.'),
  carried: z
    .array(z.string().length(3))
    .describe('«العملات التي أحملها» (CA §10.5), in the city’s display order.'),
  choices: z
    .array(z.object({ currency: z.string().length(3), name: z.string() }))
    .describe('Every currency the city has enabled, the base among them, with its Arabic name.'),
});

class CaptainCarriedCurrenciesDto extends createZodDto(carriedCurrenciesSchema) {}

class CaptainSetCarriedCurrenciesDto extends createZodDto(
  z.object({
    currencies: z
      .array(z.string().length(3))
      .min(1)
      .max(10)
      .describe('The currencies carried, one at least, the base among them or not.'),
  }),
) {}

const maxPickupSchema = z.object({
  limit: money
    .nullable()
    .describe('«أقصى مبلغ أحمله» (CA §10.5, C4) in the city’s base currency; null is no limit.'),
  answered: z
    .boolean()
    .describe('Whether the captain has answered, a limit or none; the app asks until then (K2).'),
  baseCurrency: z.string().length(3).nullable().describe('Null while the city has none.'),
});

class CaptainMaxPickupDto extends createZodDto(maxPickupSchema) {}

class CaptainSetMaxPickupDto extends createZodDto(
  z.object({
    amount: z
      .string()
      .regex(/^[1-9][0-9]{0,18}$/)
      .nullable()
      .describe('Minor units of the city’s base currency, above zero; null for no limit.'),
  }),
) {}

// CA §7, §4.3: the captain's availability, going online and offline, and the
// location every 10 seconds while online.
@CaptainController()
export class CaptainAvailabilityController {
  constructor(
    private readonly captains: CaptainsService,
    private readonly terms: TermsService,
  ) {}

  @Get('availability')
  @AppSignedIn()
  @ZodResponse({ status: 200, type: CaptainAvailabilityDto })
  async state(@CurrentAppSession() session: AppSession) {
    return stateBody(await this.captains.state(captainOf(session), new Date()));
  }

  // CA §7.2: refused with 409 online_blocked and every block, so the app shows
  // each with its next step (terms_not_accepted opens the terms, K7).
  @Post('availability/online')
  @AppSignedIn()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: CaptainAvailabilityDto })
  async online(@CurrentAppSession() session: AppSession, @Body() body: CaptainGoOnlineDto) {
    try {
      const captainId = captainOf(session);
      const termsPending = await this.terms.pending('captain', session.accountId);
      return stateBody(
        await this.captains.goOnline(captainId, { ...body, termsPending }, new Date()),
      );
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

  // CA §7.3, §15: last-order mode on or off during an active order. Refused
  // 409 not_online, no_active_order (on without an order) or
  // last_order_not_yours (off when operations, a suspension or a termination
  // set it).
  @Post('availability/last-order')
  @AppSignedIn()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: CaptainAvailabilityDto })
  async lastOrder(@CurrentAppSession() session: AppSession, @Body() body: CaptainLastOrderDto) {
    try {
      return stateBody(await this.captains.setLastOrder(captainOf(session), body.on, new Date()));
    } catch (error) {
      if (
        error instanceof CaptainsRefusedError &&
        ['not_online', 'no_active_order', 'last_order_not_yours'].includes(error.refusal)
      ) {
        throw new ConflictException({ statusCode: HttpStatus.CONFLICT, error: error.refusal });
      }
      throw error;
    }
  }

  // CA §10.5 «العملات التي أحملها» on «الإعدادات» (owner decision 2026-11-11).
  @Get('settings/carried-currencies')
  @AppSignedIn()
  @ZodResponse({ status: 200, type: CaptainCarriedCurrenciesDto })
  async carriedCurrencies(@CurrentAppSession() session: AppSession) {
    return this.captains.carriedCurrencies(captainOf(session));
  }

  // Sets them to a value, so it takes no Idempotency-Key. 400
  // invalid_carried_currencies outside the city's enabled currencies.
  @Put('settings/carried-currencies')
  @AppSignedIn()
  @ZodResponse({ status: 200, type: CaptainCarriedCurrenciesDto })
  async setCarriedCurrencies(
    @CurrentAppSession() session: AppSession,
    @Body() body: CaptainSetCarriedCurrenciesDto,
  ) {
    try {
      return await this.captains.setCarriedCurrencies(captainOf(session), body.currencies);
    } catch (error) {
      if (error instanceof CaptainsRefusedError && error.refusal === 'invalid_carried_currencies') {
        throw new BadRequestException({
          statusCode: HttpStatus.BAD_REQUEST,
          error: error.refusal,
          message: error.message,
        });
      }
      throw error;
    }
  }

  // CA §10.5, K2 «أقصى مبلغ أحمله» on «الإعدادات».
  @Get('settings/max-pickup-amount')
  @AppSignedIn()
  @ZodResponse({ status: 200, type: CaptainMaxPickupDto })
  async maxPickup(@CurrentAppSession() session: AppSession) {
    return maxPickupBody(await this.captains.maxPickup(captainOf(session)));
  }

  // Sets it to a value, so it takes no Idempotency-Key. 400
  // invalid_max_pickup above the largest amount, 409 not_in_base_currency
  // while the city has no base, 409 active_order during an order (CA §15).
  @Put('settings/max-pickup-amount')
  @AppSignedIn()
  @ZodResponse({ status: 200, type: CaptainMaxPickupDto })
  async setMaxPickup(
    @CurrentAppSession() session: AppSession,
    @Body() body: CaptainSetMaxPickupDto,
  ) {
    try {
      const amount = body.amount === null ? null : BigInt(body.amount);
      return maxPickupBody(await this.captains.setMaxPickup(captainOf(session), amount));
    } catch (error) {
      if (error instanceof CaptainsRefusedError && error.refusal === 'invalid_max_pickup') {
        throw new BadRequestException({
          statusCode: HttpStatus.BAD_REQUEST,
          error: error.refusal,
          message: error.message,
        });
      }
      if (
        error instanceof CaptainsRefusedError &&
        (error.refusal === 'not_in_base_currency' || error.refusal === 'active_order')
      ) {
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

function maxPickupBody(value: MaxPickup) {
  return { ...value, limit: value.limit && moneyBody(value.limit) };
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
    lastOrderBy: state.state === 'last_order' ? state.by : null,
    lastOrderReason: state.state === 'last_order' ? state.reason : null,
    offersExpired: state.state === 'offline' ? state.offersExpired : null,
  };
}

function stateBody({ availability: state, custody, remitTolerance }: CaptainState) {
  return {
    availability: availabilityBody(state),
    custody: {
      usage: moneyBody(custody.usage),
      limit: moneyBody(custody.limit),
      warn: custody.warn,
      closedDue: moneyBody(custody.closedDue),
      lastCutoff: custody.lastCutoff.toISOString(),
      remitTolerance: moneyBody(remitTolerance),
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
