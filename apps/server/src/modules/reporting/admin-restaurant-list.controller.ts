import { Body, HttpCode, HttpStatus, NotFoundException, Post } from '@nestjs/common';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { RequirePermission } from '../../http/access.js';
import { AdminController } from '../../http/route-groups.js';
import { GeoService } from '../geo/index.js';
import { RestaurantListService } from './restaurant-list.service.js';

const accountStatus = z.enum(['draft', 'test', 'active', 'suspended', 'terminated']);

class AdminRestaurantListQueryDto extends createZodDto(
  z.object({
    cityId: z.uuid(),
    status: accountStatus.nullable().describe('Only this account status; null for every one.'),
    categoryId: z.uuid().nullable().describe('Only the restaurants of this category.'),
    zoneId: z.uuid().nullable().describe('Only the restaurants whose pin is in this zone.'),
    q: z
      .string()
      .trim()
      .min(1)
      .max(60)
      .nullable()
      .describe(
        'A part of the name, or a number (E.164, 00…, 09…, 05…): the restaurant’s own or a user’s.',
      ),
  }),
) {}

class AdminRestaurantListDto extends createZodDto(
  z.object({
    currency: z.string().length(3).nullable().describe('The city’s base, of every balance.'),
    restaurants: z
      .array(
        z.object({
          id: z.uuid(),
          nameAr: z.string(),
          nameEn: z.string().nullable(),
          categories: z.array(z.object({ id: z.uuid(), name: z.string() })),
          accountStatus,
          state: z
            .enum(['open', 'busy', 'paused', 'closed'])
            .nullable()
            .describe('The operating state in test mode or active; null otherwise.'),
          visible: z.boolean(),
          sortWeight: z.int(),
          zoneName: z.string().nullable().describe('The zone the pin is in.'),
          ratingAverage: z.number().nullable(),
          ratingCount: z.int(),
          ordersToday: z.int().describe('Placed since today’s cutoff, test orders left out.'),
          acceptanceBp7d: z
            .int()
            .nullable()
            .describe(
              'Accepted of those accepted, rejected or never answered over 7 business days, in basis points.',
            ),
          commissionBp: z.int().nullable().describe('In force now.'),
          balance: z
            .string()
            .regex(/^-?\d{1,18}$/)
            .describe('Minor units in the base: + the restaurant owes, − the platform owes it.'),
          lastOrderAt: z.iso.datetime().nullable(),
        }),
      )
      .describe('By name; drafts included.'),
  }),
) {}

// AP §9.6.2 «المطاعم» (slice 2.30c, restaurants.read): the city's
// restaurants with their columns, filters and search. A read sent as a POST,
// so a number searched never sits in a URL (as the desk's searches); no key.
@AdminController('restaurant-list')
export class AdminRestaurantListController {
  constructor(
    private readonly list: RestaurantListService,
    private readonly geo: GeoService,
  ) {}

  @Post()
  @RequirePermission('restaurants.read')
  @HttpCode(200)
  @ZodResponse({ status: 200, type: AdminRestaurantListDto })
  async read(@Body() body: AdminRestaurantListQueryDto) {
    if ((await this.geo.cityTimeZone(body.cityId)) === null) {
      throw new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, error: 'unknown_city' });
    }
    const { currency, restaurants } = await this.list.list(
      body.cityId,
      { status: body.status, categoryId: body.categoryId, zoneId: body.zoneId, q: body.q },
      new Date(),
    );
    return {
      currency,
      restaurants: restaurants.map((restaurant) => ({
        id: restaurant.id,
        nameAr: restaurant.nameAr,
        nameEn: restaurant.nameEn,
        categories: restaurant.categories,
        accountStatus: restaurant.accountStatus,
        state: restaurant.state,
        visible: restaurant.visible,
        sortWeight: restaurant.sortWeight,
        zoneName: restaurant.zone?.name ?? null,
        ratingAverage:
          restaurant.rating === null ? null : Math.round(restaurant.rating.average * 10) / 10,
        ratingCount: restaurant.rating?.count ?? 0,
        ordersToday: restaurant.ordersToday,
        acceptanceBp7d: restaurant.acceptanceBp7d,
        commissionBp: restaurant.commissionBp,
        balance: restaurant.balance.toString(),
        lastOrderAt: restaurant.lastOrderAt?.toISOString() ?? null,
      })),
    };
  }
}
