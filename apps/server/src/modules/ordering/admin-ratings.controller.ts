import { Get, HttpStatus, NotFoundException, Param, Query } from '@nestjs/common';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { RequirePermission } from '../../http/access.js';
import { AdminController } from '../../http/route-groups.js';
import { CaptainsService } from '../captains/index.js';
import { MerchantsService } from '../merchants/index.js';
import { type RatingPage, RatingPagesService, ratingPeriods } from './rating-pages.js';

class AdminRatingsQueryDto extends createZodDto(
  z.object({
    period: z
      .enum(ratingPeriods)
      .default('all')
      .describe(
        'Business days on the city’s clock: «الكل», «اليوم», «أمس», «آخر 7 أيام», «آخر 30 يوماً».',
      ),
    stars: z.coerce
      .number()
      .int()
      .min(1)
      .max(5)
      .optional()
      .describe('Only the ratings with these stars; the summary counts every star.'),
    page: z.coerce.number().int().min(0).max(10_000).default(0).describe('The page, from 0.'),
    asOf: z.iso
      .datetime()
      .optional()
      .describe('The first page’s `asOf`, sent with every next page so the pages agree.'),
  }),
) {}

class AdminRatingsRestaurantParamsDto extends createZodDto(z.object({ restaurantId: z.uuid() })) {}

class AdminRatingsCaptainParamsDto extends createZodDto(z.object({ captainId: z.uuid() })) {}

class AdminRatingsCaptainsQueryDto extends createZodDto(z.object({ cityId: z.uuid() })) {}

class AdminRatingsDto extends createZodDto(
  z.object({
    asOf: z.iso.datetime().describe('The moment the pages are read up to.'),
    count: z.int().describe('The ratings of the period, test orders left out.'),
    average: z.number().nullable().describe('Their average stars to one decimal; null with none.'),
    distribution: z
      .array(z.object({ stars: z.int(), count: z.int() }))
      .describe('The count of each star, from 5 down to 1.'),
    ratings: z
      .array(
        z.object({
          orderId: z.uuid(),
          orderNumber: z.string(),
          stars: z.int(),
          reasons: z
            .array(z.object({ code: z.string(), label: z.string() }))
            .describe('The reasons the customer picked, their labels as chosen.'),
          comment: z.string().nullable(),
          at: z.iso.datetime(),
        }),
      )
      .describe('The page, newest first, with the order; never the customer’s name (AP §9.6.4).'),
    more: z.boolean().describe('Whether a next page follows.'),
  }),
) {}

class AdminRatedCaptainsDto extends createZodDto(
  z.object({
    captains: z
      .array(
        z.object({
          id: z.uuid(),
          name: z.string(),
          count: z.int(),
          average: z.number().nullable(),
        }),
      )
      .describe('The city’s captains, the best rated first and the unrated last.'),
  }),
) {}

function body(found: RatingPage) {
  return {
    asOf: found.asOf.toISOString(),
    count: found.count,
    average: found.average,
    distribution: found.distribution,
    ratings: found.ratings.map(({ orderId, orderNumber, stars, reasons, comment, at }) => ({
      orderId,
      orderNumber,
      stars,
      reasons,
      comment,
      at: at.toISOString(),
    })),
    more: found.more,
  };
}

const query = (found: AdminRatingsQueryDto) => ({
  period: found.period,
  stars: found.stars ?? null,
  page: found.page,
  asOf: found.asOf === undefined ? null : new Date(found.asOf),
});

// AP §9.6.4 «التقييمات», §9.7.4 «التقييمات والشكاوى», CU §12.1 (slice
// 2.26c): a restaurant's and a captain's ratings with everything, comments
// included, until the profiles of 2.30 and 2.36 (owner decision 2026-11-18).
@AdminController('ratings')
export class AdminRatingsController {
  constructor(
    private readonly ratings: RatingPagesService,
    private readonly merchants: MerchantsService,
    private readonly captains: CaptainsService,
  ) {}

  // 404 unknown_restaurant.
  @Get('restaurants/:restaurantId')
  @RequirePermission('restaurants.read')
  @ZodResponse({ status: 200, type: AdminRatingsDto })
  async restaurant(
    @Param() params: AdminRatingsRestaurantParamsDto,
    @Query() found: AdminRatingsQueryDto,
  ) {
    const restaurant = await this.merchants.restaurant(params.restaurantId);
    if (!restaurant) {
      throw new NotFoundException({
        statusCode: HttpStatus.NOT_FOUND,
        error: 'unknown_restaurant',
      });
    }
    return body(
      await this.ratings.read(
        { party: 'restaurant', id: restaurant.id, cityId: restaurant.cityId },
        query(found),
        new Date(),
      ),
    );
  }

  @Get('captains')
  @RequirePermission('captains.read')
  @ZodResponse({ status: 200, type: AdminRatedCaptainsDto })
  async captainsOfCity(@Query() found: AdminRatingsCaptainsQueryDto) {
    const captains = await this.captains.captainIds(found.cityId);
    return { captains: await this.ratings.captainsOfCity(captains) };
  }

  // 404 unknown_captain.
  @Get('captains/:captainId')
  @RequirePermission('captains.read')
  @ZodResponse({ status: 200, type: AdminRatingsDto })
  async captain(
    @Param() params: AdminRatingsCaptainParamsDto,
    @Query() found: AdminRatingsQueryDto,
  ) {
    const captain = await this.captains.captain(params.captainId, new Date());
    if (!captain) {
      throw new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, error: 'unknown_captain' });
    }
    return body(
      await this.ratings.read(
        { party: 'captain', id: captain.id, cityId: captain.cityId },
        query(found),
        new Date(),
      ),
    );
  }
}
