import {
  Inject,
  Injectable,
  Logger,
  type OnApplicationBootstrap,
  type OnApplicationShutdown,
} from '@nestjs/common';
import { and, eq, inArray } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { reportError } from '../../observability/error-tracking.js';
import { type Availability, CaptainsService, type MapCaptain } from '../captains/index.js';
import { GeoService, type Point, type ZoneOutline } from '../geo/index.js';
import { MerchantsService } from '../merchants/index.js';
import { opsMapChannel, RealtimePublisher } from '../notifications/index.js';
import { type DispatchOrder, OrderAssignments } from '../ordering/index.js';
import { offers } from './schema.js';

// Architecture §6.2: the live map's channel carries the captains every 10 s.
export const LIVE_MAP_PUBLISH_MS = 10_000;

// AP §9.4: a restaurant's colour on the map: green open (busy mode
// included), amber paused, grey closed, on holiday or suspended. A draft or
// a terminated restaurant is not on the map.
export const mapRestaurantStates = [
  'open',
  'busy',
  'paused',
  'closed',
  'holiday',
  'suspended',
] as const;
export type MapRestaurantState = (typeof mapRestaurantStates)[number];

export interface MapRestaurant {
  id: string;
  name: string;
  location: Point;
  state: MapRestaurantState;
}

// AP §9.4: an active order as a line from the restaurant to the customer.
// `assignable`: accepted or ready with no captain and no open offer, what
// «عيّنه لطلب» lists (AP §9.3.2's assignment takes nothing else).
export interface MapOrder {
  id: string;
  number: string;
  status: DispatchOrder['status'];
  restaurantId: string;
  restaurantName: string;
  from: Point;
  to: Point;
  captainId: string | null;
  assignable: boolean;
}

// A captain with the order they carry now (the orange tooltip).
export interface MapCaptainView extends MapCaptain {
  order: { id: string; number: string } | null;
}

export interface LiveMapView {
  zones: ZoneOutline[];
  restaurants: MapRestaurant[];
  captains: MapCaptainView[];
  orders: MapOrder[];
}

// AP §9.4 «الخريطة الحية» (slice 2.39): what the live map shows of a city,
// read from each module's public service: the zones (geo), the restaurants
// with their state (merchants), the captains with their state and newest
// point (captains) and the active orders (ordering), with dispatch's own
// open offers.
@Injectable()
export class LiveMap {
  private readonly logger = new Logger('LiveMap');

  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly geo: GeoService,
    private readonly merchants: MerchantsService,
    private readonly captains: CaptainsService,
    private readonly assignments: OrderAssignments,
  ) {}

  async read(cityId: string, now: Date): Promise<LiveMapView> {
    const [zones, rows, active] = await Promise.all([
      this.geo.zoneOutlines(cityId),
      this.merchants.listRows(cityId),
      this.assignments.active(cityId),
    ]);
    const states = await Promise.all(
      rows.map(async (row) =>
        row.location === null || row.accountStatus === 'draft' || row.accountStatus === 'terminated'
          ? null
          : this.restaurantState(row.id, now),
      ),
    );
    const restaurants = rows.flatMap((row, index): MapRestaurant[] => {
      const state = states[index];
      return state && row.location
        ? [{ id: row.id, name: row.nameAr, location: row.location, state }]
        : [];
    });
    const byId = new Map(rows.map((row) => [row.id, row]));
    const offered = await this.openOffers(active.map((order) => order.id));
    // An order's restaurant always has its pin (activation needs it).
    const orders = active.flatMap((order): MapOrder[] => {
      const restaurant = byId.get(order.restaurantId);
      if (!restaurant?.location) return [];
      return [
        {
          id: order.id,
          number: String(order.number),
          status: order.status,
          restaurantId: order.restaurantId,
          restaurantName: restaurant.nameAr,
          from: restaurant.location,
          to: order.location,
          captainId: order.captainId,
          assignable:
            (order.status === 'accepted' || order.status === 'ready') &&
            order.captainId === null &&
            !offered.has(order.id),
        },
      ];
    });
    return { zones, restaurants, captains: await this.withOrders(cityId, now, active), orders };
  }

  // The captains' layer alone: what the channel carries every 10 s.
  async captainsLayer(cityId: string, now: Date): Promise<MapCaptainView[]> {
    return this.withOrders(cityId, now, await this.assignments.active(cityId));
  }

  private async withOrders(
    cityId: string,
    now: Date,
    active: DispatchOrder[],
  ): Promise<MapCaptainView[]> {
    const carried = new Map(
      active
        .filter((order) => order.captainId !== null)
        .map((order) => [order.captainId!, { id: order.id, number: String(order.number) }]),
    );
    return (await this.captains.mapCaptains(cityId, now)).map((captain) => ({
      ...captain,
      order: carried.get(captain.captainId) ?? null,
    }));
  }

  // The restaurant's colour now; null (left out) when its state cannot be
  // read, so one restaurant never hides the map.
  private async restaurantState(
    restaurantId: string,
    now: Date,
  ): Promise<MapRestaurantState | null> {
    try {
      const { state } = (await this.merchants.storefrontState(restaurantId, now)).state;
      if (state === 'draft' || state === 'terminated') return null;
      return state;
    } catch (error) {
      this.logger.warn({ err: error, restaurantId }, 'a map restaurant was left out');
      return null;
    }
  }

  private async openOffers(orderIds: string[]): Promise<Set<string>> {
    if (orderIds.length === 0) return new Set();
    const rows = await this.database.db
      .select({ orderId: offers.orderId })
      .from(offers)
      .where(and(inArray(offers.orderId, orderIds), eq(offers.status, 'open')));
    return new Set(rows.map((row) => row.orderId));
  }
}

// A captain as the route and the channel send them: money as minor units in
// a string, times as ISO strings.
export function mapCaptainBody(captain: MapCaptainView) {
  return {
    captainId: captain.captainId,
    name: captain.name,
    vehicle: captain.vehicle,
    state: captain.state,
    blocks: captain.blocks,
    custody: {
      usage: {
        amount: captain.custody.usage.amount.toString(),
        currency: captain.custody.usage.currency,
      },
      limit: {
        amount: captain.custody.limit.amount.toString(),
        currency: captain.custody.limit.currency,
      },
    },
    position: captain.position && {
      latitude: captain.position.latitude,
      longitude: captain.position.longitude,
      recordedAt: captain.position.recordedAt.toISOString(),
    },
    order: captain.order,
  };
}

export const captainStates: Availability['state'][] = [
  'offline',
  'online_available',
  'busy',
  'last_order',
  'not_receiving_offers',
  'suspended',
];

// Architecture §6.2 (slice 2.39): the worker publishes each active city's
// captains on ops_map:city.{city_id} every LIVE_MAP_PUBLISH_MS, the whole
// layer each time (a lost one is followed by the next), best effort: a
// failure is logged and the next tick tries again. A position is no state
// change, so this never goes through an outbox (§6.2).
@Injectable()
export class LiveMapPublisher implements OnApplicationBootstrap, OnApplicationShutdown {
  private readonly logger = new Logger('LiveMapPublisher');
  private timer: NodeJS.Timeout | null = null;
  private running: Promise<void> | null = null;

  constructor(
    private readonly geo: GeoService,
    private readonly map: LiveMap,
    private readonly publisher: RealtimePublisher,
  ) {}

  onApplicationBootstrap(): void {
    this.timer = setInterval(() => {
      this.running ??= this.publish(new Date()).finally(() => {
        this.running = null;
      });
    }, LIVE_MAP_PUBLISH_MS);
  }

  async onApplicationShutdown(): Promise<void> {
    if (this.timer) clearInterval(this.timer);
    await this.running;
  }

  async publish(now: Date): Promise<void> {
    if (!this.publisher.enabled) return;
    try {
      for (const city of await this.geo.activeCities()) {
        try {
          const captains = (await this.map.captainsLayer(city.id, now)).map(mapCaptainBody);
          await this.publisher.broadcast(
            [opsMapChannel(city.id)],
            { type: 'captains', captains },
            `ops-map:${city.id}:${now.getTime()}`,
          );
        } catch (error) {
          this.logger.warn({ err: error, cityId: city.id }, 'the live map was not published');
        }
      }
    } catch (error) {
      this.logger.error({ err: error }, 'the live map could not read the cities');
      reportError(error);
    }
  }
}
