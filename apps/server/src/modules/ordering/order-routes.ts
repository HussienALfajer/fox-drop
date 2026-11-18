import { Inject, Injectable, Logger, type OnModuleInit } from '@nestjs/common';
import { eq, type SQL, sql } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { CaptainsService, type LivePosition } from '../captains/index.js';
import { GeoService, type Point, type Route } from '../geo/index.js';
import { MerchantsService } from '../merchants/index.js';
import { orderChannel, RealtimePublisher } from '../notifications/index.js';
import { CAPTAIN_ACTIVE } from './order-assignments.js';
import { handovers, orders, type orderStatuses } from './schema.js';

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
    // CU §11.3: never a point of the way to the restaurant (or, after a
    // handover, to the first captain): a queued point sent late is older.
    const latest = await this.captains.latestPoint(order.captainId);
    const since = await this.followedSince(orderId, order.captainId);
    const from = latest && since && latest.recordedAt >= since ? latest : null;
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

  // From when the captain's points belong to the way to the customer
  // (followedSinceQuery; CA §9.10.1 for a handover).
  private async followedSince(orderId: string, captainId: string): Promise<Date | null> {
    const { rows } = await this.database.db.execute<{ id: string; since: Date | string | null }>(
      sql`${followedSinceQuery(sql`o.id = ${orderId} AND o.captain_id = ${captainId}`)}`,
    );
    const since = rows[0]?.since;
    return since ? new Date(since) : null;
  }

  // Architecture §6.2: the captain's new live position on order:{id} of the
  // order they carry after the pickup. Nothing waits for it (the captain's
  // request does not either, CaptainsService.onLivePosition): a missed one is
  // followed by the next point 10 seconds later, and the app reads the
  // position again on reconnecting.
  private async publish(captainId: string, position: LivePosition): Promise<void> {
    if (!this.publisher.enabled) return;
    const { rows: carried } = await this.database.db.execute<{
      id: string;
      since: Date | string | null;
    }>(sql`${followedSinceQuery(sql`o.captain_id = ${captainId}`)}`);
    for (const { id, since } of carried) {
      // CU §11.3: a point of the way to the restaurant (or, after a
      // handover, to the first captain) is not shown, though sent after.
      if (since === null || position.recordedAt < new Date(since)) continue;
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

// The orders followed now (picked up or arrived) matching the condition on
// `o`, each with the moment from which its captain's points belong to the
// way to the customer: the arrival at the restaurant, where the pickup's own
// fix is taken, or, after a handover to that captain, the receipt less the
// age its fix may have (FIX_MAX_AGE_MS, one minute). A point queued earlier
// and sent late is older.
function followedSinceQuery(condition: SQL) {
  return sql`
    SELECT o.id, greatest(coalesce(o.arrived_at_merchant_at, o.picked_up_at), (
      SELECT max(h.received_at) - interval '1 minute' FROM ${handovers} h
        WHERE h.order_id = o.id AND h.order_placed_at = o.placed_at
          AND h.to_captain_id = o.captain_id)) AS since
      FROM ${orders} o
      WHERE ${condition} AND o.status IN ('picked_up', 'arrived')`;
}
