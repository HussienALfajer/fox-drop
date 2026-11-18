import { Delete, Get, HttpStatus, NotFoundException, Param, Put, Query } from '@nestjs/common';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { AppSignedIn, CurrentAppSession } from '../../http/access.js';
import { CustomerController } from '../../http/route-groups.js';
import type { AppSession } from '../identity/index.js';
import { BrowsingService } from './browsing.service.js';
import { card, cardBody } from './customer-browsing.controller.js';
import { CustomersService } from './customers.service.js';
import { FavouritesService } from './favourites.js';
import { pointQuery } from './point-query.js';

class CustomerFavouritesQueryDto extends createZodDto(pointQuery) {}

class CustomerFavouritesDto extends createZodDto(
  z.object({
    restaurants: z
      .array(card)
      .describe(
        'CU §9.6 «المفضلة»: the favourites that deliver to the point, with their state and estimate, open first and closed last; the others are left out.',
      ),
  }),
) {}

class CustomerFavouriteParamsDto extends createZodDto(z.object({ restaurantId: z.uuid() })) {}

class CustomerFavouriteDto extends createZodDto(
  z.object({ restaurantId: z.uuid(), favourite: z.boolean() }),
) {}

// CU §9.6, U18 (slice 2.28b): the heart and «المفضلة», for a signed-in
// customer (a guest is asked to sign in). Setting and removing a favourite
// set a state, so neither takes an Idempotency-Key.
@CustomerController('favourites')
export class CustomerFavouritesController {
  constructor(
    private readonly browsing: BrowsingService,
    private readonly customers: CustomersService,
    private readonly favourites: FavouritesService,
  ) {}

  @Get()
  @AppSignedIn()
  @ZodResponse({ status: 200, type: CustomerFavouritesDto })
  async list(@Query() query: CustomerFavouritesQueryDto, @CurrentAppSession() session: AppSession) {
    const [testAccount, ids] = await Promise.all([
      this.customers.isTestAccount(session.accountId),
      this.favourites.ids(session.accountId),
    ]);
    const cards = await this.browsing.favourites(query, new Date(), testAccount, ids);
    const ratings = await this.customers.ratings.restaurants(cards.map((each) => each.id));
    return { restaurants: cards.map((each) => cardBody(each, ratings.get(each.id), true)) };
  }

  // 404 unknown_restaurant for one customers do not see.
  @Put(':restaurantId')
  @AppSignedIn()
  @ZodResponse({ status: 200, type: CustomerFavouriteDto })
  async add(@Param() params: CustomerFavouriteParamsDto, @CurrentAppSession() session: AppSession) {
    const now = new Date();
    const testAccount = await this.customers.isTestAccount(session.accountId);
    if (!(await this.browsing.seen(params.restaurantId, now, testAccount))) {
      throw new NotFoundException({
        statusCode: HttpStatus.NOT_FOUND,
        error: 'unknown_restaurant',
      });
    }
    await this.favourites.add(session.accountId, params.restaurantId, now);
    return { restaurantId: params.restaurantId, favourite: true };
  }

  // Removing one that is not a favourite changes nothing.
  @Delete(':restaurantId')
  @AppSignedIn()
  @ZodResponse({ status: 200, type: CustomerFavouriteDto })
  async remove(
    @Param() params: CustomerFavouriteParamsDto,
    @CurrentAppSession() session: AppSession,
  ) {
    await this.favourites.remove(session.accountId, params.restaurantId, new Date());
    return { restaurantId: params.restaurantId, favourite: false };
  }
}
