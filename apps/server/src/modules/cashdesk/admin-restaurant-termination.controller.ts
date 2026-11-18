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
import type { AdminSession } from '../identity/index.js';
import { MerchantsRefusedError } from '../merchants/index.js';
import { refusalsAsHttp } from './desk-http.js';
import { RestaurantTerminationService } from './restaurant-termination.service.js';

class AdminRestaurantTerminationParamsDto extends createZodDto(
  z.object({ restaurantId: z.uuid() }),
) {}

class AdminRestaurantTerminationDto extends createZodDto(
  z.object({
    reason: z.string().trim().min(1).max(500).describe('Why the contract ends (AP §9.6.5).'),
  }),
) {}

class AdminRestaurantTerminatedDto extends createZodDto(
  z.object({ restaurantId: z.uuid(), accountStatus: z.literal('terminated') }),
) {}

// AP §9.6.5 «إنهاء» (slice 2.30c, OWN: restaurants.terminate): ends the
// contract with a reason, once the restaurant's account is at zero (409
// balance_not_zero) and no order of it is unfinished (409
// orders_unfinished). No Idempotency-Key: terminated again changes nothing.
@AdminController('restaurants')
export class AdminRestaurantTerminationController {
  constructor(private readonly termination: RestaurantTerminationService) {}

  @Post(':restaurantId/terminate')
  @RequirePermission('restaurants.terminate')
  @HttpCode(200)
  @ZodResponse({ status: 200, type: AdminRestaurantTerminatedDto })
  async terminate(
    @Param() params: AdminRestaurantTerminationParamsDto,
    @Body() body: AdminRestaurantTerminationDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    try {
      await refusalsAsHttp(() =>
        this.termination.terminate(params.restaurantId, {
          actor: { type: 'admin', id: session.accountId, role: session.roles.join(',') },
          context: requestContext(request),
          reason: body.reason,
        }),
      );
    } catch (error) {
      if (!(error instanceof MerchantsRefusedError)) throw error;
      const answer = { error: error.refusal, message: error.message };
      if (error.refusal === 'unknown_restaurant') {
        throw new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, ...answer });
      }
      throw new ConflictException({ statusCode: HttpStatus.CONFLICT, ...answer });
    }
    return { restaurantId: params.restaurantId, accountStatus: 'terminated' as const };
  }
}
