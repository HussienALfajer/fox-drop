import {
  Body,
  ForbiddenException,
  HttpCode,
  HttpStatus,
  Post,
  ServiceUnavailableException,
} from '@nestjs/common';
import { ApiExcludeEndpoint } from '@nestjs/swagger';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { AppSignedIn, CurrentAppSession, RealtimeProxy } from '../../http/access.js';
import {
  CaptainController,
  CustomerController,
  MerchantController,
} from '../../http/route-groups.js';
import type { AppSession } from '../identity/index.js';
import { RealtimeAccess, type SubscribeAnswer } from './realtime-access.js';
import { CONNECTION_TOKEN_MINUTES, RealtimeTokens } from './realtime-tokens.js';

class RealtimeTokenDto extends createZodDto(
  z.object({
    token: z
      .string()
      .describe(
        `Centrifugo's connection token, valid ${CONNECTION_TOKEN_MINUTES} minutes; ask again when it expires.`,
      ),
    expiresAt: z.iso.datetime(),
  }),
) {}

// What Centrifugo posts to the subscription proxy; the fields this check
// does not need pass through.
class RealtimeSubscribeDto extends createZodDto(
  z.looseObject({
    user: z.string(),
    channel: z.string(),
    meta: z.unknown().optional(),
  }),
) {}

async function tokenOf(tokens: RealtimeTokens, session: AppSession) {
  const issued = await tokens.connectionToken(session, new Date());
  if (!issued) {
    throw new ServiceUnavailableException({
      statusCode: HttpStatus.SERVICE_UNAVAILABLE,
      error: 'realtime_unavailable',
    });
  }
  return { token: issued.token, expiresAt: issued.expiresAt.toISOString() };
}

// RA §4.3: every signed-in device of the restaurant connects to Centrifugo
// and subscribes to merchant:{restaurant_id} (architecture §6.1–6.2).
@MerchantController('realtime')
export class MerchantRealtimeController {
  constructor(
    private readonly tokens: RealtimeTokens,
    private readonly access: RealtimeAccess,
  ) {}

  @Post('token')
  @AppSignedIn()
  @HttpCode(HttpStatus.OK)
  @ZodResponse({ status: HttpStatus.OK, type: RealtimeTokenDto })
  async token(@CurrentAppSession() session: AppSession) {
    // RA §5.5: a terminated restaurant's owners keep only the money section.
    if (await this.access.terminated(session)) {
      throw new ForbiddenException({
        statusCode: HttpStatus.FORBIDDEN,
        error: 'restaurant_terminated',
      });
    }
    return tokenOf(this.tokens, session);
  }

  // Centrifugo's subscription proxy for the merchant namespace.
  @Post('subscribe')
  @RealtimeProxy()
  @ApiExcludeEndpoint()
  @HttpCode(HttpStatus.OK)
  subscribe(@Body() body: RealtimeSubscribeDto): Promise<SubscribeAnswer> {
    return this.access.subscribe('merchant', body);
  }
}

// CU §4.3: while an order is active and the app is open, the app subscribes
// to order:{order_id}.
@CustomerController('realtime')
export class CustomerRealtimeController {
  constructor(
    private readonly tokens: RealtimeTokens,
    private readonly access: RealtimeAccess,
  ) {}

  @Post('token')
  @AppSignedIn()
  @HttpCode(HttpStatus.OK)
  @ZodResponse({ status: HttpStatus.OK, type: RealtimeTokenDto })
  token(@CurrentAppSession() session: AppSession) {
    return tokenOf(this.tokens, session);
  }

  // Centrifugo's subscription proxy for the order namespace.
  @Post('subscribe')
  @RealtimeProxy()
  @ApiExcludeEndpoint()
  @HttpCode(HttpStatus.OK)
  subscribe(@Body() body: RealtimeSubscribeDto): Promise<SubscribeAnswer> {
    return this.access.subscribe('customer', body);
  }
}

// CA §15: the captain's device connects to Centrifugo and subscribes to
// captain:{captain_id}, for its offers and its assigned order (architecture
// §6.2).
@CaptainController('realtime')
export class CaptainRealtimeController {
  constructor(
    private readonly tokens: RealtimeTokens,
    private readonly access: RealtimeAccess,
  ) {}

  @Post('token')
  @AppSignedIn()
  @HttpCode(HttpStatus.OK)
  @ZodResponse({ status: HttpStatus.OK, type: RealtimeTokenDto })
  token(@CurrentAppSession() session: AppSession) {
    return tokenOf(this.tokens, session);
  }

  // Centrifugo's subscription proxy for the captain namespace.
  @Post('subscribe')
  @RealtimeProxy()
  @ApiExcludeEndpoint()
  @HttpCode(HttpStatus.OK)
  subscribe(@Body() body: RealtimeSubscribeDto): Promise<SubscribeAnswer> {
    return this.access.subscribe('captain', body);
  }
}
