import {
  Body,
  ConflictException,
  Get,
  HttpCode,
  HttpStatus,
  Post,
  Query,
  UnprocessableEntityException,
} from '@nestjs/common';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { AppSignedInOrGuest, OptionalAppSession } from '../../http/access.js';
import { Idempotent, IdempotencyKey } from '../../http/idempotency.js';
import { CustomerController } from '../../http/route-groups.js';
import type { AppSession } from '../identity/index.js';
import { BrowsingService, SEARCH_ITEMS_MAX } from './browsing.service.js';
import {
  card,
  cardBody,
  itemBody,
  state,
  stateBody,
  storefrontItem,
} from './customer-browsing.controller.js';
import { CustomersService } from './customers.service.js';
import { LostDemandRefusedError, LostDemandService } from './lost-demand.service.js';
import { pointQuery } from './point-query.js';
import { searchText } from './search-text.js';

// CU §8.3 (decided by us): a search of 2 to 50 characters.
const query = z.string().trim().min(2).max(50);

class CustomerSearchQueryDto extends createZodDto(
  pointQuery.extend({
    q: query.describe('What the customer typed; the app sends it once typing stops.'),
  }),
) {}

class CustomerSearchDto extends createZodDto(
  z.object({
    restaurants: z
      .array(card)
      .describe(
        'Restaurants delivering to the point whose name or category matches: open first, then busy and paused, then closed.',
      ),
    items: z
      .array(
        storefrontItem.extend({
          restaurantId: z.uuid(),
          restaurantName: z.string(),
          restaurantState: state,
        }),
      )
      .describe(
        `Their items whose name or description matches, in the restaurants' order (closed last), at most ${SEARCH_ITEMS_MAX}.`,
      ),
  }),
) {}

class CustomerSuggestionDto extends createZodDto(
  z.object({
    latitude: z.number().min(-90).max(90),
    longitude: z.number().min(-180).max(180),
    restaurantName: z.string().trim().min(1).max(60).describe('«اسم المطعم», required.'),
    note: z
      .string()
      .trim()
      .max(200)
      .nullable()
      .describe('«ملاحظة», optional; an empty one is none.'),
    query: z
      .string()
      .trim()
      .max(50)
      .nullable()
      .describe('The search that found nothing, if the form followed one.'),
  }),
) {}

class CustomerSuggestedDto extends createZodDto(z.object({ status: z.literal('received') })) {}

// CU §8.3: the search and «لم تجده؟ أخبرنا», open to guests (CU §5.1).
@CustomerController()
export class CustomerSearchController {
  constructor(
    private readonly browsing: BrowsingService,
    private readonly customers: CustomersService,
    private readonly lostDemand: LostDemandService,
  ) {}

  // A search that finds nothing at a served point feeds the lost-demand
  // report (AP §9.17).
  @Get('search')
  @AppSignedInOrGuest()
  @ZodResponse({ status: 200, type: CustomerSearchDto })
  async search(
    @Query() query: CustomerSearchQueryDto,
    @OptionalAppSession() session: AppSession | null,
  ) {
    const { q, ...point } = query;
    const now = new Date();
    const testAccount =
      session === null ? false : await this.customers.isTestAccount(session.accountId);
    const found = await this.browsing.search(point, now, q, testAccount);
    // An admin test account's searches and one of diacritics only are no
    // demand (decided by us).
    if (
      found.place !== null &&
      found.restaurants.length === 0 &&
      found.items.length === 0 &&
      !testAccount &&
      searchText(q) !== ''
    ) {
      await this.lostDemand.recordMiss(found.place, q, session?.accountId ?? null, now);
    }
    const ratings = await this.customers.ratings.restaurants(
      found.restaurants.map((restaurant) => restaurant.id),
    );
    return {
      restaurants: found.restaurants.map((restaurant) =>
        cardBody(restaurant, ratings.get(restaurant.id)),
      ),
      items: found.items.map((item) => ({
        ...itemBody(item),
        restaurantId: item.restaurantId,
        restaurantName: item.restaurantName,
        restaurantState: stateBody(item.restaurantState),
      })),
    };
  }

  // «لم تجده؟ أخبرنا»: 409 outside_zones at a point no zone covers.
  @Post('restaurant-suggestions')
  @AppSignedInOrGuest()
  @Idempotent()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: CustomerSuggestedDto })
  async suggest(
    @Body() body: CustomerSuggestionDto,
    @IdempotencyKey() key: string,
    @OptionalAppSession() session: AppSession | null,
  ) {
    const { latitude, longitude, restaurantName, note, query: search } = body;
    try {
      await this.lostDemand.suggest(
        { latitude, longitude },
        {
          restaurantName,
          note: note === null || note === '' ? null : note,
          query: search === null || search === '' ? null : search,
        },
        session?.accountId ?? null,
        key,
        new Date(),
      );
    } catch (error) {
      if (error instanceof LostDemandRefusedError) {
        const body = { error: error.refusal };
        throw error.refusal === 'idempotency_key_reused'
          ? new UnprocessableEntityException({
              statusCode: HttpStatus.UNPROCESSABLE_ENTITY,
              ...body,
            })
          : new ConflictException({ statusCode: HttpStatus.CONFLICT, ...body });
      }
      throw error;
    }
    return { status: 'received' as const };
  }
}
