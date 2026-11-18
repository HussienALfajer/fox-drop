import { Inject, Injectable, Logger, type OnModuleInit } from '@nestjs/common';
import { and, eq, inArray, sql } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { CaptainsService, type LivePosition } from '../captains/index.js';
import { GeoService, type Point, type Route } from '../geo/index.js';
import { MerchantsService } from '../merchants/index.js';
import { orderChannel, RealtimePublisher } from '../notifications/index.js';
import { CAPTAIN_ACTIVE } from './order-assignments.js';
import { orders, type orderStatuses } from './schema.js';

type OrderStatus = (typeof orderStatuses)[number];

// CU §11.3, architecture §6.2: from the pickup until the order ends, the
// customer sees the captain's live position.
export const FOLLOWED: OrderStatus[] = ['picked_up', 'arrived'];

// CA §9.2, §9.5: the captain's two legs.
export type Leg = 'to_restaurant' | 'to_customer';

export interface CaptainLegRoute {
  leg: Leg;
  destination: Point;
  // Null while the captain has no point in their open online period.
  route: Route | null;
}

export interface CustomerLegRoute {
  // The captain's newest point, null without one.
  captain: (Point & { recordedAt: Date }) | null;
  destination: Point;
  route: Route | null;
}

// A read the order's state does not allow.
export class OrderRouteRefusedError extends Error {
  constructor(readonly refusal: 'unknown_order' | 'order_state_changed') {
    super(refusal);
  }
}

// The leg's route and the captain's live position for the maps (CA §4.6,
// §9.2, §9.5, CU §11.3, architecture §6.2, §7.1, §7.3). The apps read a leg's
// route once (CA §4.6: light data); the position after the pickup is
// published to the order's channel with every new live point.
@Injectable()
export class OrderRoutes implements OnModuleInit {
  private readonly logger = new Logger(OrderRoutes.name);

  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly geo: GeoService,
    private readonly captains: CaptainsService,
    private readonly merchants: MerchantsService,
    private readonly publisher: RealtimePublisher,
  ) {}

  onModuleInit(): void {
    this.captains.onLivePosition((captainId, position) => this.publish(captainId, position));
  }

  // The captain's current leg, from their newest point: to the restaurant
  // until the pickup, then to the customer's pin.
  async captainLeg(captainId: string, orderId: string, now: Date): Promise<CaptainLegRoute> {
    const order = await this.order(orderId);
    if (!order || order.captainId !== captainId) {
      throw new OrderRouteRefusedError('unknown_order');
    }
    if (!CAPTAIN_ACTIVE.includes(order.status)) {
      throw new OrderRouteRefusedError('order_state_changed');
    }
    const leg: Leg = FOLLOWED.includes(order.status) ? 'to_customer' : 'to_restaurant';
    const destination =
      leg === 'to_customer' ? order.location : await this.restaurantPoint(order.restaurantId, now);
    const from = await this.captains.latestPoint(captainId);
    return {
      leg,
      destination,
      route: from ? await this.route(order.cityId, captainId, from, destination, now) : null,
    };
  }

  // CU §11.3: the customer's own order from the pickup until it ends: the
  // captain's newest point and the route from it to the pin.
  async customerLeg(accountId: string, orderId: string, now: Date): Promise<CustomerLegRoute> {
    const order = await this.order(orderId);
    if (!order || order.customerAccountId !== accountId) {
      throw new OrderRouteRefusedError('unknown_order');
    }
    if (!FOLLOWED.includes(order.status) || order.captainId === null) {
      throw new OrderRouteRefusedError('order_state_changed');
    }
    const from = await this.captains.latestPoint(order.captainId);
    return {
      captain: from,
      destination: order.location,
      route: from
        ? await this.route(order.cityId, order.captainId, from, order.location, now)
        : null,
    };
  }

  private async route(
    cityId: string,
    captainId: string,
    from: Point,
    to: Point,
    now: Date,
  ): Promise<Route> {
    const captain = await this.captains.captain(captainId, now);
    if (!captain) throw new Error(`captain ${captainId} not found`);
    return this.geo.route(cityId, from, to, { vehicle: captain.vehicle });
  }

  private async restaurantPoint(restaurantId: string, now: Date): Promise<Point> {
    const restaurant = await this.merchants.restaurant(restaurantId, now);
    if (!restaurant) throw new Error(`restaurant ${restaurantId} not found`);
    return restaurant.location;
  }

  private async order(orderId: string) {
    const [order] = await this.database.db
      .select({
        cityId: orders.cityId,
        restaurantId: orders.restaurantId,
        customerAccountId: orders.customerAccountId,
        status: orders.status,
        captainId: orders.captainId,
        latitude: sql<number>`ST_Y(${orders.location})`.mapWith(Number),
        longitude: sql<number>`ST_X(${orders.location})`.mapWith(Number),
      })
      .from(orders)
      .where(eq(orders.id, orderId));
    if (!order) return null;
    const { latitude, longitude, ...rest } = order;
    return { ...rest, location: { latitude, longitude } };
  }

  // Architecture §6.2: the captain's new live position on order:{id} of the
  // order they carry after the pickup. Nothing waits for it: a missed one is
  // followed by the next point 10 seconds later, and the app reads the
  // position again on reconnecting.
  private async publish(captainId: string, position: LivePosition): Promise<void> {
    if (!this.publisher.enabled) return;
    const carried = await this.database.db
      .select({ id: orders.id })
      .from(orders)
      .where(and(eq(orders.captainId, captainId), inArray(orders.status, FOLLOWED)));
    for (const { id } of carried) {
      try {
        await this.publisher.broadcast(
          [orderChannel(id)],
          {
            type: 'captain.position',
            schema: 1,
            orderId: id,
            latitude: position.latitude,
            longitude: position.longitude,
            recordedAt: position.recordedAt.toISOString(),
          },
          `captain-position:${id}:${position.recordedAt.getTime()}`,
        );
      } catch (error) {
        this.logger.warn({ err: error }, 'the captain position was not published');
      }
    }
  }
}
