import {
  ConflictException,
  ForbiddenException,
  Get,
  HttpStatus,
  NotFoundException,
  Param,
} from '@nestjs/common';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { AppSignedIn, CurrentAppSession } from '../../http/access.js';
import { CaptainController, CustomerController } from '../../http/route-groups.js';
import type { AppSession } from '../identity/index.js';
import { OrderRouteRefusedError, OrderRoutes } from './order-routes.js';

const mapPoint = z.object({ latitude: z.number(), longitude: z.number() });

// A leg's route (architecture §7.1): by road with its line, or the straight
// line × 1.3 (`straight_x1.3`) with `line` null when the routing service did
// not answer. `seconds` is the ETA of the leg.
const legRoute = z.object({
  metres: z.number().int(),
  seconds: z.number().int(),
  method: z.enum(['road', 'straight_x1.3']),
  line: z.array(mapPoint).nullable(),
});

class CaptainOrderRouteDto extends createZodDto(
  z.object({
    leg: z.enum(['to_restaurant', 'to_customer']),
    destination: mapPoint,
    route: legRoute.nullable(),
  }),
) {}

class CustomerOrderRouteDto extends createZodDto(
  z.object({
    captain: mapPoint.extend({ recordedAt: z.iso.datetime() }).nullable(),
    destination: mapPoint,
    route: legRoute.nullable(),
  }),
) {}

class OrderRouteParamsDto extends createZodDto(z.object({ orderId: z.uuid() })) {}

async function refusalsAsHttp<T>(read: () => Promise<T>): Promise<T> {
  try {
    return await read();
  } catch (error) {
    if (!(error instanceof OrderRouteRefusedError)) throw error;
    if (error.refusal === 'unknown_order') {
      throw new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, error: 'unknown_order' });
    }
    throw new ConflictException({ statusCode: HttpStatus.CONFLICT, error: error.refusal });
  }
}

// CA §4.6, §9.2, §9.5: the route and ETA of the captain's current leg, read
// once per leg. 404 unknown_order for another captain's order; 409
// order_state_changed once it is no longer active.
@CaptainController('orders')
export class CaptainOrderRouteController {
  constructor(private readonly routes: OrderRoutes) {}

  @Get(':orderId/route')
  @AppSignedIn()
  @ZodResponse({ status: 200, type: CaptainOrderRouteDto })
  async route(@CurrentAppSession() session: AppSession, @Param() params: OrderRouteParamsDto) {
    if (session.captain === null) throw new ForbiddenException();
    const captainId = session.captain.captainId;
    return refusalsAsHttp(() => this.routes.captainLeg(captainId, params.orderId, new Date()));
  }
}

// CU §11.3: the map from the pickup until the order ends: the captain's
// newest point and the route from it to the pin, read when the map opens and
// after a reconnect; the position then follows order:{id}. 404 unknown_order
// for another's order; 409 order_state_changed before the pickup or once it
// ended.
@CustomerController()
export class CustomerOrderRouteController {
  constructor(private readonly routes: OrderRoutes) {}

  @Get('orders/:orderId/route')
  @AppSignedIn()
  @ZodResponse({ status: 200, type: CustomerOrderRouteDto })
  async route(@CurrentAppSession() session: AppSession, @Param() params: OrderRouteParamsDto) {
    const leg = await refusalsAsHttp(() =>
      this.routes.customerLeg(session.accountId, params.orderId, new Date()),
    );
    return {
      captain: leg.captain && {
        latitude: leg.captain.latitude,
        longitude: leg.captain.longitude,
        recordedAt: leg.captain.recordedAt.toISOString(),
      },
      destination: leg.destination,
      route: leg.route,
    };
  }
}
