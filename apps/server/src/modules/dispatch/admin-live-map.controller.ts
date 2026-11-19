import { Get, HttpStatus, NotFoundException, Query } from '@nestjs/common';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { RequirePermission } from '../../http/access.js';
import { AdminController } from '../../http/route-groups.js';
import { GeoService } from '../geo/index.js';
import { vehicles } from '../settings/index.js';
import { captainStates, LiveMap, mapCaptainBody, mapRestaurantStates } from './live-map.js';

const point = z.object({ latitude: z.number(), longitude: z.number() });
const money = z.object({
  amount: z
    .string()
    .regex(/^-?\d+$/)
    .describe('Minor units of the currency, as a string.'),
  currency: z.string().length(3),
});

// The captains' layer, also what ops_map:city.{city_id} carries every 10 s
// as { type: "captains", captains }.
const mapCaptain = z.object({
  captainId: z.uuid(),
  name: z.string(),
  vehicle: z.enum(vehicles),
  state: z
    .enum(captainStates)
    .describe(
      'CA §7.1. The map: online_available green, busy and last_order orange, the others grey (offline and suspended show the last known position and its time).',
    ),
  blocks: z
    .array(z.enum(['closed_due', 'cash_limit']))
    .describe('AP §9.4 «red outline»: blocked for unhanded cash or at the cash limit.'),
  custody: z.object({ usage: money, limit: money }).describe('The cash-limit usage, in base.'),
  // The newest real point of any online period, whatever its age; null
  // without one. (No description: the generated clients share this shape.)
  position: point.extend({ recordedAt: z.iso.datetime() }).nullable(),
  order: z
    .object({ id: z.uuid(), number: z.string() })
    .nullable()
    .describe('The active order the captain carries.'),
});

class AdminLiveMapQueryDto extends createZodDto(z.object({ cityId: z.uuid() })) {}

class AdminLiveMapDto extends createZodDto(
  z.object({
    zones: z.array(
      z.object({ id: z.uuid(), name: z.string(), active: z.boolean(), area: z.array(point) }),
    ),
    restaurants: z.array(
      z.object({
        id: z.uuid(),
        name: z.string(),
        location: point,
        state: z
          .enum(mapRestaurantStates)
          .describe('AP §9.4: open and busy green, paused amber, the others grey.'),
      }),
    ),
    captains: z.array(mapCaptain),
    orders: z.array(
      z.object({
        id: z.uuid(),
        number: z.string(),
        status: z.enum(['placed', 'accepted', 'ready', 'picked_up', 'arrived']),
        restaurantId: z.uuid(),
        restaurantName: z.string(),
        from: point.describe("The restaurant's pin."),
        to: point.describe("The customer's pin."),
        captainId: z.uuid().nullable(),
        assignable: z
          .boolean()
          .describe('Accepted or ready, no captain and no open offer: «عيّنه لطلب» lists it.'),
      }),
    ),
  }),
) {}

// AP §9.4 «الخريطة الحية» (slice 2.39): OWN and OPS in full, SUP read
// (live_map.read). The assignment from the map is AP §9.3.2's
// POST /v1/admin/orders/{orderId}/assign (operations.manage).
@AdminController('live-map')
export class AdminLiveMapController {
  constructor(
    private readonly map: LiveMap,
    private readonly geo: GeoService,
  ) {}

  // 404 unknown_city.
  @Get()
  @RequirePermission('live_map.read')
  @ZodResponse({ status: 200, type: AdminLiveMapDto })
  async read(@Query() query: AdminLiveMapQueryDto) {
    if ((await this.geo.city(query.cityId)) === null) {
      throw new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, error: 'unknown_city' });
    }
    const view = await this.map.read(query.cityId, new Date());
    return {
      zones: view.zones,
      restaurants: view.restaurants,
      captains: view.captains.map(mapCaptainBody),
      orders: view.orders.map((order) => ({
        ...order,
        status: order.status as 'placed' | 'accepted' | 'ready' | 'picked_up' | 'arrived',
      })),
    };
  }
}
